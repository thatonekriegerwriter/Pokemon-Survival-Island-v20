

  
class PokemonEncounters
 # Returns whether a wild encounter should happen, based on its encounter
  # chance. Called when taking a step and by Rock Smash.
  
  def choose_wild_pokemon(enc_type, chance_rolls = 1)
    if !enc_type || !GameData::EncounterType.exists?(enc_type)
      raise ArgumentError.new(_INTL("Encounter type {1} does not exist", enc_type))
    end
    enc_list = @encounter_tables[enc_type]
    return nil if !enc_list || enc_list.length == 0
    # Static/Magnet Pull prefer wild encounters of certain types, if possible.
    # If they activate, they remove all Pokémon from the encounter table that do
    # not have the type they favor. If none have that type, nothing is changed.
    first_pkmn = $player.first_pokemon
    if first_pkmn
      favored_type = nil
      case first_pkmn.ability_id
      when :FLASHFIRE
        favored_type = :FIRE if Settings::MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS &&
                                GameData::Type.exists?(:FIRE) && rand(100) < 50
      when :HARVEST
        favored_type = :GRASS if Settings::MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS &&
                                 GameData::Type.exists?(:GRASS) && rand(100) < 50
      when :LIGHTNINGROD
        favored_type = :ELECTRIC if Settings::MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS &&
                                    GameData::Type.exists?(:ELECTRIC) && rand(100) < 50
      when :MAGNETPULL
        favored_type = :STEEL if GameData::Type.exists?(:STEEL) && rand(100) < 50
      when :STATIC
        favored_type = :ELECTRIC if GameData::Type.exists?(:ELECTRIC) && rand(100) < 50
      when :STORMDRAIN
        favored_type = :WATER if Settings::MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS &&
                                 GameData::Type.exists?(:WATER) && rand(100) < 50
      end
      if favored_type
        new_enc_list = []
        enc_list.each do |enc|
          species_data = GameData::Species.get(enc[1])
          new_enc_list.push(enc) if species_data.types.include?(favored_type)
        end
        enc_list = new_enc_list if new_enc_list.length > 0
      end
    end
    enc_list.sort! { |a, b| b[0] <=> a[0] }   # Highest probability first
    # Calculate the total probability value
    chance_total = 0
    enc_list.each { |a| chance_total += a[0] }
    # Choose a random entry in the encounter table based on entry probabilities
    rnd = 0
    chance_rolls.times do
      r = rand(chance_total)
      rnd = r if r > rnd   # Prefer rarer entries if rolling repeatedly
    end
    encounter = nil
    enc_list.each do |enc|
      rnd -= enc[0]
      next if rnd >= 0
      encounter = enc
      break
    end
   
    level =  new_set_enemy_level(encounter)

    # Some abilities alter the level of the wild Pokémon
    if first_pkmn
      case first_pkmn.ability_id
      when :HUSTLE, :PRESSURE, :VITALSPIRIT
        level = [level + rand(1..4), GameData::GrowthRate.max_level].max
      end
    end
    # Black Flute and White Flute alter the level of the wild Pokémon
    if Settings::FLUTES_CHANGE_WILD_ENCOUNTER_LEVELS
      if $PokemonMap.blackFluteUsed
        level = [level + rand(1..4), GameData::GrowthRate.max_level].min
      elsif $PokemonMap.whiteFluteUsed
        level = [level - rand(1..4), 1].max
      end
    end
    if level < 1
     level = 1 
    end
	
    # Return [species, level]
    return [encounter[1], level]
  end


  # Returns whether an encounter with the given Pokémon should be allowed after
  # taking into account Repels and ability effects.
  def allow_encounter?(enc_data, repel_active = false)
    return false if !enc_data
    return true if pbPokeRadarOnShakingGrass
    # Repel
    if repel_active
      first_pkmn = (Settings::REPEL_COUNTS_FAINTED_POKEMON) ? $player.first_pokemon : $player.first_able_pokemon
      if first_pkmn && enc_data[1] < first_pkmn.level
        @chance_accumulator = 0
        return false
      end
    end
    # Some abilities make wild encounters less likely if the wild Pokémon is
    # sufficiently weaker than the Pokémon with the ability
    first_pkmn = $player.first_pokemon
    if first_pkmn
      case first_pkmn.ability_id
      when :INTIMIDATE, :KEENEYE
        return false if enc_data[1] <= first_pkmn.level - 5 && rand(100) < 50
      end
    end
    return true
  end

  # Returns whether a wild encounter should be turned into a double wild
  # encounter.
  def have_double_wild_battle?
    return false if $game_temp.force_single_battle
    return false if pbInSafari?
    return true if $PokemonGlobal.partner
    return false if $player.able_pokemon_count <= 1
    return true if $PokemonSystem.battlesize == 1
    return true if $PokemonSystem.battlesize == 2 && !pbCanTripleBattle? && pbCanDoubleBattle?
    return true if $game_player.pbTerrainTag.double_wild_encounters && rand(100) < 30
    return false
  end





end



class Battle

  def pbEndOfBattle
    oldDecision = @decision
    @decision = 4 if @decision == 1 && wildBattle? && @caughtPokemon.length > 0
    case oldDecision
    ##### WIN #####
    when 1
      PBDebug.log("")
      PBDebug.log("***Player won***")
      if trainerBattle?
        @scene.pbTrainerBattleSuccess
        case @opponent.length
        when 1
          pbDisplayPaused(_INTL("You defeated {1}!", @opponent[0].full_name))
        when 2
          pbDisplayPaused(_INTL("You defeated {1} and {2}!", @opponent[0].full_name,
                                @opponent[1].full_name))
        when 3
          pbDisplayPaused(_INTL("You defeated {1}, {2} and {3}!", @opponent[0].full_name,
                                @opponent[1].full_name, @opponent[2].full_name))
        end
        @opponent.each_with_index do |trainer, i|
          @scene.pbShowOpponent(i)
          msg = trainer.lose_text
          msg = "..." if !msg || msg.empty?
          pbDisplayPaused(msg.gsub(/\\[Pp][Nn]/, pbPlayer.name))
        end
      end
      # Gain money from winning a trainer battle, and from Pay Day
      pbGainMoney if @decision != 4
      # Hide remaining trainer
      @scene.pbShowOpponent(@opponent.length) if trainerBattle? && @caughtPokemon.length > 0
    ##### LOSE, DRAW #####
    when 2, 5
      PBDebug.log("")
      PBDebug.log("***Player lost***") if @decision == 2
      PBDebug.log("***Player drew with opponent***") if @decision == 5
      if @internalBattle
        pbDisplayPaused(_INTL("You have no more Pokémon that can fight!"))
        if trainerBattle?
          case @opponent.length
          when 1
            pbDisplayPaused(_INTL("You lost against {1}!", @opponent[0].full_name))
          when 2
            pbDisplayPaused(_INTL("You lost against {1} and {2}!",
                                  @opponent[0].full_name, @opponent[1].full_name))
          when 3
            pbDisplayPaused(_INTL("You lost against {1}, {2} and {3}!",
                                  @opponent[0].full_name, @opponent[1].full_name, @opponent[2].full_name))
          end
        end
        if wildBattle?
          foeParty = pbParty(1)
          case foeParty.length
            when 1
            pbDisplayPaused(_INTL("{1} panicked and tried to escape, but tripped!",self.pbPlayer.name))
            damagePlayer(rand(15)+5)
		pbSEPlay("normaldamage")
            pbDisplayPaused(_INTL("The Wild {1} started charging at you!",foeParty[0].name))
          when 2
            pbDisplayPaused(_INTL("{1} panicked and tried to escape, but tripped!",self.pbPlayer.name))
            damagePlayer(rand(15)+5)
		pbSEPlay("normaldamage")
            pbDisplayPaused(_INTL("Oh! A wild {1} and {2} started charging at you!",foeParty[0].name,
               foeParty[1].name))
          when 3
            pbDisplayPaused(_INTL("{1} panicked and tried to escape, but tripped!",self.pbPlayer.name))
            damagePlayer(rand(15)+5)
		pbSEPlay("normaldamage")
            pbDisplayPaused(_INTL("The Wild {1}, {2} and {3} all started charging at once!",foeParty[0].name,
               foeParty[1].name,foeParty[2].name))
          end
      end
        # Lose money from losing a battle
        pbLoseMoney
        pbDisplayPaused(_INTL("You blacked out!")) if !@canLose
      elsif @decision == 2   # Lost in a Battle Frontier battle
        if @opponent
          @opponent.each_with_index do |trainer, i|
            @scene.pbShowOpponent(i)
            msg = trainer.win_text
            msg = "..." if !msg || msg.empty?
            pbDisplayPaused(msg.gsub(/\\[Pp][Nn]/, pbPlayer.name))
          end
        end
      end
    ##### CAUGHT WILD POKÉMON #####
    when 4
      @scene.pbWildBattleSuccess if !Settings::GAIN_EXP_FOR_CAPTURE
    end
    # Register captured Pokémon in the Pokédex, and store them
    pbRecordAndStoreCaughtPokemon
    # Collect Pay Day money in a wild battle that ended in a capture
  #  pbGainMoney if @decision == 4
    # Pass on Pokérus within the party
    if @internalBattle
      infected = []
      $player.party.each_with_index do |pkmn, i|
	     next if pkmn.nil?
        infected.push(i) if pkmn.pokerusStage == 1
      end
      infected.each do |idxParty|
        strain = $player.party[idxParty].pokerusStrain
        if idxParty > 0 && $player.party[idxParty - 1].pokerusStage == 0 && rand(3) == 0   # 33%
          $player.party[idxParty - 1].givePokerus(strain)
        end
        if idxParty < $player.party.length - 1 && $player.party[idxParty + 1].pokerusStage == 0 && rand(3) == 0   # 33%
          $player.party[idxParty + 1].givePokerus(strain)
        end
      end
    end
    # Clean up battle stuff
    @scene.pbEndBattle(@decision)
    @battlers.each do |b|
      next if !b
      pbCancelChoice(b.index)   # Restore unused items to Bag
      Battle::AbilityEffects.triggerOnSwitchOut(b.ability, b, true) if b.abilityActive?
    end
    pbParty(0).each_with_index do |pkmn, i|
      next if !pkmn
      @peer.pbOnLeavingBattle(self, pkmn, @usedInBattle[0][i], true)   # Reset form
      pkmn.item = @initialItems[0][i]
    end
    return @decision
  end


end




def pbBattleOnStepTaken(repel_active)
#  return if $player.able_pokemon_count == 0
  return if !$PokemonEncounters.encounter_possible_here?
  encounter_type = $PokemonEncounters.encounter_type
  return if !encounter_type
  return if !$PokemonEncounters.encounter_triggered?(encounter_type, repel_active)
  $game_temp.encounter_type = encounter_type
  encounter = $PokemonEncounters.choose_wild_pokemon(encounter_type)
  EventHandlers.trigger(:on_wild_species_chosen, encounter)
  if $PokemonEncounters.allow_encounter?(encounter, repel_active)
    if $PokemonEncounters.have_double_wild_battle?
      encounter2 = $PokemonEncounters.choose_wild_pokemon(encounter_type)
      EventHandlers.trigger(:on_wild_species_chosen, encounter2)
      WildBattle.start(encounter, encounter2, can_override: true)
    else
      WildBattle.start(encounter, can_override: true)
    end
    $game_temp.encounter_type = nil
    $game_temp.encounter_triggered = true
  end
  $game_temp.force_single_battle = false
end






class Battle::Move

  def pbCalcDamage(user, target, numTargets = 1)
    return if statusMove?
    if target.damageState.disguise || target.damageState.iceFace
      target.damageState.calcDamage = 1
      return
    end
    stageMul = [2, 2, 2, 2, 2, 2, 2, 3, 4, 5, 6, 7, 8]
    stageDiv = [8, 7, 6, 5, 4, 3, 2, 2, 2, 2, 2, 2, 2]
    # Get the move's type
    type = @calcType   # nil is treated as physical
    # Calculate whether this hit deals critical damage
    target.damageState.critical = pbIsCritical?(user, target)
    # Calcuate base power of move
    baseDmg = pbBaseDamage(@baseDamage, user, target)
    # Calculate user's attack stat
    atk, atkStage = pbGetAttackStats(user, target)
    if !target.hasActiveAbility?(:UNAWARE) || @battle.moldBreaker
      atkStage = 6 if target.damageState.critical && atkStage < 6
      atk = (atk.to_f * stageMul[atkStage] / stageDiv[atkStage]).floor
    end
    # Calculate target's defense stat
    defense, defStage = pbGetDefenseStats(user, target)
    if !user.hasActiveAbility?(:UNAWARE)
      defStage = 6 if target.damageState.critical && defStage > 6
      defense = (defense.to_f * stageMul[defStage] / stageDiv[defStage]).floor
    end
    # Calculate all multiplier effects
    multipliers = {
      :base_damage_multiplier  => 1.0,
      :attack_multiplier       => 1.0,
      :defense_multiplier      => 1.0,
      :final_damage_multiplier => 1.0
    }
    pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
	multipliers[:base_damage_multiplier]*= 1.25 if !user.pbOwnedByPlayer?
	multipliers[:final_damage_multiplier]*= 1.25 if !user.pbOwnedByPlayer?
    # Main damage calculation
    baseDmg = [(baseDmg * multipliers[:base_damage_multiplier]).round, 1].max
    atk     = [(atk     * multipliers[:attack_multiplier]).round, 1].max
    defense = [(defense * multipliers[:defense_multiplier]).round, 1].max
    damage  = ((((2.0 * user.level / 5) + 2).floor * baseDmg * atk / defense).floor / 50).floor + 2
    damage  = [(damage * multipliers[:final_damage_multiplier]).round, 1].max
    target.damageState.calcDamage = damage
  end



end











class Battle


  
   def pbGainEVsOne(idxParty, defeatedBattler)
     pkmn = pbParty(0)[idxParty]
     pkmn.gain_ev(defeatedBattler.pokemon, @initialItems[0][idxParty])
   end
  



  def pbGainExpOne(idxParty, defeatedBattler, numPartic, expShare, expAll, showMessages = true)
    pkmn = pbParty(0)[idxParty]   # The Pokémon gaining Exp from defeatedBattler
   result = pkmn.gain_exp(
    defeatedBattler.pokemon,
    defeatedBattler.participants.include?(idxParty),
    numPartic,
    expShare,
    expAll,
    @initialItems[0][idxParty],
    trainerBattle?,
    @internalBattle,
    showMessages,
	self 
  )
   if result && @internalBattle
  old_exp, exp_final, cur_level, new_level, exp_gained = result

  battler = pbFindBattler(idxParty)
  temp_exp = old_exp

  loop do
    level_min_exp = pkmn.growth_rate.minimum_exp_for_level(cur_level)
    level_max_exp = pkmn.growth_rate.minimum_exp_for_level(cur_level + 1)
    temp_exp2 = [level_max_exp, exp_final].min

    @scene.pbEXPBar(
      battler,
      level_min_exp,
      level_max_exp,
      temp_exp,
      temp_exp2
    )

    temp_exp = temp_exp2
    cur_level += 1

    if cur_level > new_level
      battler&.pbUpdate(false)
      @scene.pbRefreshOne(battler.index) if battler
      break
    end
  end
  
   
   
   
   
   end 
	
   pkmn.apply_levels(showMessages, false, @internalBattle, self)
  end


  def pbGainExp
    # Play wild victory music if it's the end of the battle (has to be here)
    @scene.pbWildBattleSuccess if wildBattle? && pbAllFainted?(1) && !pbAllFainted?(0)
    return if !@internalBattle || !@expGain
    # Go through each battler in turn to find the Pokémon that participated in
    # battle against it, and award those Pokémon Exp/EVs
    expAll = $player.has_exp_all || $bag.has?(:EXPALL)
    p1 = pbParty(0)
    @battlers.each do |b|
      next unless b&.opposes?   # Can only gain Exp from fainted foes
      next if b.participants.length == 0
      next unless b.fainted? || b.captured
      # Count the number of participants
      numPartic = 0
      b.participants.each do |partic|
        next unless p1[partic]&.able? && pbIsOwner?(0, partic)
        numPartic += 1
      end
      # Find which Pokémon have an Exp Share
      expShare = []
      if !expAll
        eachInTeam(0, 0) do |pkmn, i|
          next if !pkmn.able?
          next if !pkmn.hasItem?(:EXPSHARE) && GameData::Item.try_get(@initialItems[0][i]) != :EXPSHARE
          expShare.push(i)
        end
      end
      # Calculate EV and Exp gains for the participants
      if numPartic > 0 || expShare.length > 0 || expAll
        # Gain EVs and Exp for participants
        eachInTeam(0, 0) do |pkmn, i|
          next if !pkmn.able?
          next unless b.participants.include?(i) || expShare.include?(i)
          pbGainEVsOne(i, b)
          pbGainExpOne(i, b, numPartic, expShare, expAll)
        end
        # Gain EVs and Exp for all other Pokémon because of Exp All
        if expAll
          showMessage = true
          eachInTeam(0, 0) do |pkmn, i|
            next if !pkmn.able?
            next if b.participants.include?(i)
            pbDisplayPaused(_INTL("Your other Pokémon also gained Exp. Points!")) if showMessage
            showMessage = false
            pbGainEVsOne(i, b)
            pbGainExpOne(i, b, numPartic, expShare, expAll, false)
            pbPlayerEXP(b.pokemon)
          end
        end
      end
      # Clear the participants array
      b.participants = []
    end
  end

end









class Game_Temp
  attr_accessor :disable_intro_anim

  def disable_intro_anim
    @disable_intro_anim = false if @disable_intro_anim.nil?
    return @disable_intro_anim
  end

end
if false

#===============================================================================
# Shows the battle scene fading in while elements slide around into place
#===============================================================================
class Battle::Scene::Animation::Intro2 < Battle::Scene::Animation
  def initialize(sprites, viewport, battle)
    @battle = battle
    super(sprites, viewport)
  end

  def createProcesses
    appearTime = 20   # This is in 1/20 seconds
    # Background
    if @sprites["battle_bg2"]
      makeSlideSprite("battle_bg", 0.5, appearTime)
      makeSlideSprite("battle_bg2", 0.5, appearTime)
    end
    # Bases
    makeSlideSprite("base_0", 1, appearTime, PictureOrigin::BOTTOM)
    makeSlideSprite("base_1", -1, appearTime, PictureOrigin::CENTER)
    # Player sprite, partner trainer sprite
	if $PokemonGlobal.in_dungeon==true
	
	elsif $game_temp.disable_intro_anim==true

	else
    @battle.player.each_with_index do |_p, i|
      makeSlideSprite("player_#{i + 1}", 1, appearTime, PictureOrigin::BOTTOM)
    end
	end
    # Opposing trainer sprite(s) or wild Pokémon sprite(s)
    if @battle.trainerBattle?
      @battle.opponent.each_with_index do |_p, i|
        makeSlideSprite("trainer_#{i + 1}", -1, appearTime, PictureOrigin::BOTTOM)
      end
    else   # Wild battle
      @battle.pbParty(1).each_with_index do |_pkmn, i|
        idxBattler = (2 * i) + 1
        makeSlideSprite("pokemon_#{idxBattler}", -1, appearTime, PictureOrigin::BOTTOM)
      end
    end
    # Shadows
    @battle.battlers.length.times do |i|
      makeSlideSprite("shadow_#{i}", (i.even?) ? 1 : -1, appearTime, PictureOrigin::CENTER)
    end
    # Fading blackness over whole screen
    blackScreen = addNewSprite(0, 0, "Graphics/Battle animations/black_screen")
    blackScreen.setZ(0, 999)
    blackScreen.moveOpacity(0, 8, 0)
    # Fading blackness over command bar
    blackBar = addNewSprite(@sprites["cmdBar_bg"].x, @sprites["cmdBar_bg"].y,
                            "Graphics/Battle animations/black_bar")
    blackBar.setZ(0, 998)
    blackBar.moveOpacity(appearTime * 3 / 4, appearTime / 4, 0)
  end

  def makeSlideSprite(spriteName, deltaMult, appearTime, origin = nil)
    # If deltaMult is positive, the sprite starts off to the right and moves
    # left (for sprites on the player's side and the background).
    return if !@sprites[spriteName]
    s = addSprite(@sprites[spriteName], origin)
    s.setDelta(0, (Graphics.width * deltaMult).floor, 0)
    s.moveDelta(0, appearTime, (-Graphics.width * deltaMult).floor, 0)
  end
end








#===============================================================================
# Shows a Pokémon being sent out on the player's side (including by a partner).
# Includes the Poké Ball being thrown.
#===============================================================================
class Battle::Scene::Animation::PokeballPlayerSendOut2 < Battle::Scene::Animation
  include Battle::Scene::Animation::BallAnimationMixin

  def initialize(sprites, viewport, idxTrainer, battler, startBattle, idxOrder = 0)
    @idxTrainer     = idxTrainer
    @battler        = battler
    @showingTrainer = startBattle
    @idxOrder       = idxOrder
    @trainer        = @battler.battle.pbGetOwnerFromBattlerIndex(@battler.index)
    sprites["pokemon_#{battler.index}"].visible = false
    @shadowVisible = sprites["shadow_#{battler.index}"].visible
    sprites["shadow_#{battler.index}"].visible = false
    super(sprites, viewport)
  end

  def createProcesses
    batSprite = @sprites["pokemon_#{@battler.index}"]
    shaSprite = @sprites["shadow_#{@battler.index}"]
    traSprite = @sprites["player_#{@idxTrainer}"]
    # Calculate the Poké Ball graphic to use
    poke_ball = (batSprite.pkmn) ? batSprite.pkmn.poke_ball : nil
    # Calculate the color to turn the battler sprite
    col = getBattlerColorFromPokeBall(poke_ball)
    col.alpha = 255
    # Calculate start and end coordinates for battler sprite movement
    ballPos = Battle::Scene.pbBattlerPosition(@battler.index, batSprite.sideSize)
    battlerStartX = ballPos[0]   # Is also where the Ball needs to end
    battlerStartY = ballPos[1]   # Is also where the Ball needs to end + 18
    battlerEndX = batSprite.x
    battlerEndY = batSprite.y

    # Set up battler sprite
    battler = addSprite(batSprite, PictureOrigin::BOTTOM)
    battler.setXY(0, battlerStartX, battlerStartY)
    battler.setZoom(0, 0)
    battler.setColor(0, col)
    # Battler animation
    delay = 0
    battlerAppear(battler, delay, battlerEndX, battlerEndY, batSprite, col)
    if @shadowVisible
      # Set up shadow sprite
      shadow = addSprite(shaSprite, PictureOrigin::CENTER)
      shadow.setOpacity(0, 0)
      # Shadow animation
      shadow.setVisible(delay, @shadowVisible)
      shadow.moveOpacity(delay + 5, 10, 255)
    end
  end
end


class Battle::Scene2
 def pbInitSprites
    @sprites = {}
    # The background image and each side's base graphic
    pbCreateBackdropSprites
    # Create message box graphic
    messageBox = pbAddSprite("messageBox", 0, Graphics.height - 96,
                             "Graphics/Pictures/Battle/overlay_message", @viewport)
    messageBox.z = 195
    # Create message window (displays the message)
    msgWindow = Window_AdvancedTextPokemon.newWithSize(
      "", 16, Graphics.height - 96 + 2, Graphics.width - 32, 96, @viewport
    )
    msgWindow.z              = 200
    msgWindow.opacity        = 0
    msgWindow.baseColor      = MESSAGE_BASE_COLOR
    msgWindow.shadowColor    = MESSAGE_SHADOW_COLOR
    msgWindow.letterbyletter = true
    @sprites["messageWindow"] = msgWindow
    # Create command window
    @sprites["commandWindow"] = CommandMenu.new(@viewport, 200)
    # Create fight window
    @sprites["fightWindow"] = FightMenu.new(@viewport, 200)
    # Create targeting window
    @sprites["targetWindow"] = TargetMenu.new(@viewport, 200, @battle.sideSizes)
    pbShowWindow(MESSAGE_BOX)
    # The party lineup graphics (bar and balls) for both sides
    2.times do |side|
      partyBar = pbAddSprite("partyBar_#{side}", 0, 0,
                             "Graphics/Pictures/Battle/overlay_lineup", @viewport)
      partyBar.z       = 120
      partyBar.mirror  = true if side == 0   # Player's lineup bar only
      partyBar.visible = false
      NUM_BALLS.times do |i|
        ball = pbAddSprite("partyBall_#{side}_#{i}", 0, 0, nil, @viewport)
        ball.z       = 121
        ball.visible = false
      end
      # Ability splash bars
      if USE_ABILITY_SPLASH
        @sprites["abilityBar_#{side}"] = AbilitySplashBar.new(side, @viewport)
      end
    end
    # Player's and partner trainer's back sprite
    @battle.player.each_with_index do |p, i|
	   if $PokemonGlobal.in_dungeon==true && !@battle.opposes?(i)
	
	  elsif $game_temp.disable_intro_anim==true && !@battle.opposes?(i)

	  else
      pbCreateTrainerBackSprite(i, p.trainer_type, @battle.player.length)
	  end
    end
    # Opposing trainer(s) sprites
    if @battle.trainerBattle?
      @battle.opponent.each_with_index do |p, i|
        pbCreateTrainerFrontSprite(i, p.trainer_type, @battle.opponent.length)
      end
    end
    # Data boxes and Pokémon sprites
    @battle.battlers.each_with_index do |b, i|
      next if !b
      @sprites["dataBox_#{i}"] = PokemonDataBox.new(b, @battle.pbSideSize(i), @viewport)
      pbCreatePokemonSprite(i)
    end
    # Wild battle, so set up the Pokémon sprite(s) accordingly
    if @battle.wildBattle?
      @battle.pbParty(1).each_with_index do |pkmn, i|
        index = (i * 2) + 1
        pbChangePokemon(index, pkmn)
        pkmnSprite = @sprites["pokemon_#{index}"]
        pkmnSprite.tone    = Tone.new(-80, -80, -80)
        pkmnSprite.visible = true
      end
    end
  end
  
  def pbCreateTrainerBackSprite(idxTrainer, trainerType, numTrainers = 1)
    if idxTrainer == 0   # Player's sprite
      trainerFile = GameData::TrainerType.player_back_sprite_filename(trainerType)
    else   # Partner trainer's sprite
      trainerFile = GameData::TrainerType.back_sprite_filename(trainerType)
    end
    spriteX, spriteY = Battle::Scene.pbTrainerPosition(0, idxTrainer, numTrainers)
    trainer = pbAddSprite("player_#{idxTrainer + 1}", spriteX, spriteY, trainerFile, @viewport)
    return if trainer.nil?
    return if !trainer.bitmap
    # Alter position of sprite
    trainer.z = 80 + idxTrainer
    if trainer.bitmap.width > trainer.bitmap.height * 2
      trainer.src_rect.x     = 0
      trainer.src_rect.width = trainer.bitmap.width / 5
    end
    trainer.ox = trainer.src_rect.width / 2
    trainer.oy = trainer.bitmap.height
  end


  #=============================================================================
  # Animates a trainer's sprite and party lineup hiding (if they are visible).
  # Animates a Pokémon being sent out into battle, then plays the shiny
  # animation for it if relevant.
  # sendOuts is an array; each element is itself an array: [idxBattler,pkmn]
  #=============================================================================
  def pbSendOutBattlers(sendOuts, startBattle = false)
    return if sendOuts.length == 0
    # If party balls are still appearing, wait for them to finish showing up, as
    # the FadeAnimation will make them disappear.
    while inPartyAnimation?
      pbUpdate
    end
    @briefMessage = false
    # Make all trainers and party lineups disappear (player-side trainers may
    # animate throwing a Poké Ball)
    if @battle.opposes?(sendOuts[0][0])
      fadeAnim = Animation::TrainerFade.new(@sprites, @viewport, startBattle)
    else
      fadeAnim = Animation::PlayerFade.new(@sprites, @viewport, startBattle)
    end
    # For each battler being sent out, set the battler's sprite and create two
    # animations (the Poké Ball moving and battler appearing from it, and its
    # data box appearing)
    sendOutAnims = []
    sendOuts.each_with_index do |b, i|
      pkmn = @battle.battlers[b[0]].effects[PBEffects::Illusion] || b[1]
      pbChangePokemon(b[0], pkmn)
      pbRefresh
      if @battle.opposes?(b[0])
        sendOutAnim = Animation::PokeballTrainerSendOut.new(
          @sprites, @viewport, @battle.pbGetOwnerIndexFromBattlerIndex(b[0]) + 1,
          @battle.battlers[b[0]], startBattle, i
        )
      else
        sendOutAnim = Animation::PokeballPlayerSendOut.new(
          @sprites, @viewport, @battle.pbGetOwnerIndexFromBattlerIndex(b[0]) + 1,
          @battle.battlers[b[0]], startBattle, i
        )
      end
      dataBoxAnim = Animation::DataBoxAppear.new(@sprites, @viewport, b[0])
      mementoAnim = Animation::BattlerMemento.new(@sprites, @viewport, @battle, b[0])
      sendOutAnims.push([sendOutAnim, mementoAnim, dataBoxAnim, false])
    end
    # Play all animations
    loop do
      fadeAnim.update
      sendOutAnims.each do |a|
        next if a[3]
        a[0].update 
        a[1].update if a[0].animDone?
        a[2].update if a[1].animDone?
        a[3] = true if a[2].animDone?
      end
      pbUpdate
      if !inPartyAnimation? && sendOutAnims.none? { |a| !a[3] }
        break
      end
    end
    fadeAnim.dispose
    sendOutAnims.each do |a|
      a[0].dispose
      a[1].dispose
      a[1].dispose
      a[2].dispose
    end
    # Play shininess animations for shiny Pokémon
    sendOuts.each do |b|
      next if !@battle.showAnims || !@battle.battlers[b[0]].shiny?
      if Settings::SUPER_SHINY && @battle.battlers[b[0]].super_shiny?
        pbCommonAnimation("SuperShiny", @battle.battlers[b[0]])
      else
        pbCommonAnimation("Shiny", @battle.battlers[b[0]])
      end
    end
  end


end



end

class Battle
  #=============================================================================
  # Running from battle
  #=============================================================================
  def pbCanRun?(idxBattler)
    return false if trainerBattle?
    battler = @battlers[idxBattler]
    return false if !@canRun && !battler.opposes?
    #EDIT
    return false if $player.playerstamina<15
    return true if battler.pbHasType?(:GHOST) && Settings::MORE_TYPE_EFFECTS
    return true if battler.abilityActive? &&
                   Battle::AbilityEffects.triggerCertainEscapeFromBattle(battler.ability, battler)
    return true if battler.itemActive? &&
                   Battle::ItemEffects.triggerCertainEscapeFromBattle(battler.item, battler)
    return false if battler.trappedInBattle?
    allOtherSideBattlers(idxBattler).each do |b|
      return false if b.abilityActive? &&
                      Battle::AbilityEffects.triggerTrappingByTarget(b.ability, battler, b, self)
      return false if b.itemActive? &&
                      Battle::ItemEffects.triggerTrappingByTarget(b.item, battler, b, self)
    end
    return true
  end

  # Return values:
  # -1: Failed fleeing
  #  0: Wasn't possible to attempt fleeing, continue choosing action for the round
  #  1: Succeeded at fleeing, battle will end
  # duringBattle is true for replacing a fainted Pokémon during the End Of Round
  # phase, and false for choosing the Run command.
  def pbRun(idxBattler, duringBattle = false)
    battler = @battlers[idxBattler]
    if battler.opposes?
      return 0 if trainerBattle?
      @choices[idxBattler][0] = :Run
      @choices[idxBattler][1] = 0
      @choices[idxBattler][2] = nil
      return -1
    end
    # Fleeing from trainer battles
    if trainerBattle?
      if $DEBUG && Input.press?(Input::CTRL)
        if pbDisplayConfirm(_INTL("Treat this battle as a win?"))
          @decision = 1
          return 1
        elsif pbDisplayConfirm(_INTL("Treat this battle as a loss?"))
          @decision = 2
          return 1
        end
      elsif @internalBattle
        pbDisplayPaused(_INTL("No! There's no running from a Trainer battle!"))
      elsif pbDisplayConfirm(_INTL("Would you like to forfeit the match and quit now?"))
        pbSEPlay("Battle flee")
        pbDisplay(_INTL("{1} forfeited the match!", self.pbPlayer.name))
        @decision = 3
        return 1
      end
      return 0
    end
    # Fleeing from wild battles
    if $DEBUG && Input.press?(Input::CTRL)
      pbSEPlay("Battle flee")
      pbDisplayPaused(_INTL("You got away safely!"))
      @decision = 3
      return 1
    end
    if $player.is_it_this_class?(:RANGER)
      pbSEPlay("Battle flee")
      pbDisplayPaused(_INTL("You got away safely!"))
      @decision = 3
      return 1
    end
    if !@canRun
      pbDisplayPaused(_INTL("You can't escape!"))
      return 0
    end
    if !duringBattle
      #EDIT
      if battler.pbHasType?(:GHOST) && Settings::MORE_TYPE_EFFECTS && 1==2
        pbSEPlay("Battle flee")
        pbDisplayPaused(_INTL("You got away safely!"))
        @decision = 3
        return 1
      end
      # Abilities that guarantee escape
      if battler.abilityActive? &&
         Battle::AbilityEffects.triggerCertainEscapeFromBattle(battler.ability, battler)
        pbShowAbilitySplash(battler, true)
        pbHideAbilitySplash(battler)
        pbSEPlay("Battle flee")
        pbDisplayPaused(_INTL("You got away safely!"))
        @decision = 3
        return 1
      end
      # Held items that guarantee escape
      if battler.itemActive? &&
         Battle::ItemEffects.triggerCertainEscapeFromBattle(battler.item, battler)
        pbSEPlay("Battle flee")
        pbDisplayPaused(_INTL("{1} fled using its {2}!", battler.pbThis, battler.itemName))
        @decision = 3
        return 1
      end
      # Other certain trapping effects
      if battler.trappedInBattle?
        pbDisplayPaused(_INTL("You can't escape!"))
        return 0
      end
      # Trapping abilities/items
      allOtherSideBattlers(idxBattler).each do |b|
        next if !b.abilityActive?
        if Battle::AbilityEffects.triggerTrappingByTarget(b.ability, battler, b, self)
          pbDisplayPaused(_INTL("{1} prevents escape with {2}!", b.pbThis, b.abilityName))
          return 0
        end
      end
      allOtherSideBattlers(idxBattler).each do |b|
        next if !b.itemActive?
        if Battle::ItemEffects.triggerTrappingByTarget(b.item, battler, b, self)
          pbDisplayPaused(_INTL("{1} prevents escape with {2}!", b.pbThis, b.itemName))
          return 0
        end
      end
    end
    # Fleeing calculation
    # Get the speeds of the Pokémon fleeing and the fastest opponent
    # NOTE: Not pbSpeed, because using unmodified Speed.
    #EDIT
    @runCommand += 1 if !duringBattle && rand(100)<25  # Make it easier to flee next time
    runInjury=rand(100)
    injury = rand(25)+1
    playercrit = rand(24)+1
    $player.playerstamina -= 5 if $player.playerstamina > 0
    if $player.playerstamina < 0
      $player.playerstamina = 0
    end
    speedPlayer = @battlers[idxBattler].speed
    speedEnemy = 1
    allOtherSideBattlers(idxBattler).each do |b|
      speed = b.speed
      speedEnemy = speed if speedEnemy < speed
    end
    # Compare speeds and perform fleeing calculation
      rate = (speedPlayer * 128) / speedEnemy
      rate += @runCommand * 5
      if @battlers[idxBattler].loyalty <=50
        pbDisplayPaused(_INTL("{1} tried to run away, but {2} wouldn't listen!",self.pbPlayer.name,@battlers[idxBattler]))
        return -1
      end
      if runInjury > 80 && $player.playerstamina<50
        if playercrit == 1
          injury = injury*2
        end
        pbDisplayPaused(_INTL("{1} is too out of breath, they can't run away!",self.pbPlayer.name))
        if rand(2) == 1
        pbDisplayPaused(_INTL("{1} got hit with an attack! It did {2} damage!",self.pbPlayer.name,injury))
        end
        @runCommand -= 2 if !duringBattle
        damagePlayer(injury)
		pbSEPlay("normaldamage")
       return -1
      end
    if @battleAI.pbAIRandom(256) < rate && $player.playerstamina != 0
      pbSEPlay("Battle flee")
      if runInjury > 70
        if playercrit == 1
          injury = injury*2
        end
        pbDisplayPaused(_INTL("While {1} was running away, they got nicked by an attack! It did {2} damage!",self.pbPlayer.name,injury))
        damagePlayer(injury)
		pbSEPlay("normaldamage")
        @decision = 3
      return 1
      else
      pbDisplayPaused(_INTL("You got away safely!"))
      @decision = 3
      return 1
      end
    end
    pbDisplayPaused(_INTL("You couldn't get away!"))
    return -1
  end
end


class Battle::Battler

  def canConsumeArgBerry?(check_gluttony = true)
    return false if !canConsumeBerry?
    return true if !battler.able
    return false
  end


 def pbObedienceCheck?(choice)
    return true if usingMultiTurnAttack?
    return true if choice[0]!=:UseMove
    return true if !@battle.internalBattle
    return true if !@battle.pbOwnedByPlayer?(@index)
	return true if $player.is_it_this_class?(:COORDINATOR,false)

    disobedient = false
    # Pokémon may be disobedient; calculate if it is
    badgeLevel = 10 * ($player.badge_count + 1)
    r = @battle.pbRandom(256)
    badgeLevel = GameData::GrowthRate.max_level if $player.badge_count >= 8
    if @pokemon.foreign?($player) && @level>badgeLevel
	
      a = ((@level+badgeLevel)*@battle.pbRandom(256)/256).floor
      disobedient |= (a>=badgeLevel)
	  
    end
#EDIT
    return pbDisobey(choice, badgeLevel) if rand(100)+1<= PbCalculate_disobedience_chance(pkmn.loyalty,pkmn.happiness)
#END EDIT
    disobedient |= !pbHyperModeObedience(choice[2])
    return true if !disobedient
    # Pokémon is disobedient; make it do something else
#    return pbDisobey(choice,badgeLevel)
  end

  def pbDisobey(choice,badgeLevel)
    move = choice[2]
    PBDebug.log("[Disobedience] #{pbThis} disobeyed")
    @effects[PBEffects::Rage] = false
    # Do nothing if using Snore/Sleep Talk
    if @status == :SLEEP && move.usableWhenAsleep?
      @battle.pbDisplay(_INTL("{1} ignored orders and kept sleeping!",pbThis))
      return false
    end
    c = @level-badgeLevel
    r = @battle.pbRandom(90)
    # Fall asleep
    if r <= 10  && pbCanSleep?(self,false)
      pbSleepSelf(_INTL("{1} began to nap!",pbThis))
      return false
    end
    # Hurt self in confusion
    if r <= 10 && @status != :SLEEP
      pbConfusionDamage(_INTL("{1} won't obey! It hurt itself in its confusion!",pbThis))
      return false
    end
    #EDIT
    if r <= 20 && r >= 10 && @status != :SLEEP && @pokemon.happiness <= 149
      injury = rand(10)+2
      @battle.pbDisplay(_INTL("{1} turned around and attacked you for {2} damage!",pbThis, injury))
	  damagePlayer(injury)
		pbSEPlay("normaldamage")
      return false 
    end
    if r <= 20 && r >= 10 && @status != :SLEEP && @pokemon.happiness >= 199
      @battle.pbDisplay(_INTL("{1} wants to play!",pbThis))
      return false 
    end
    if r <= 30 && r >= 20 && @status != :SLEEP && @pokemon.happiness <= 50
      injury = rand(10)+2
      @battle.pbDisplay(_INTL("{1} turned around rushed you down, hurting you for {2} damage!",pbThis, injury))
	  damagePlayer(injury)
		pbSEPlay("normaldamage")
      return false 
    end
    if r <= 30 && r >= 20 && @status != :SLEEP && @pokemon.happiness >= 200
      @battle.pbDisplay(_INTL("{1} wants you to praise it before it does anything!",pbThis))
      return false 
    end
    # Use another move
    if (r <= 40 && r >= 30 && @status != :SLEEP) || (r <= 40 && r >= 30 && @status != :SLEEP  && @pokemon.happiness >= 199)
      @battle.pbDisplay(_INTL("{1} ignored orders!",pbThis))
      return false if !@battle.pbCanShowFightMenu?(@index)
      otherMoves = []
      eachMoveWithIndex do |_m,i|
        next if i==choice[1]
        otherMoves.push(i) if @battle.pbCanChooseMove?(@index,i,false)
      end
      return false if otherMoves.length==0   # No other move to use; do nothing
      newChoice = otherMoves[@battle.pbRandom(otherMoves.length)]
      choice[1] = newChoice
      choice[2] = @moves[newChoice]
      choice[3] = -1
      return true
    end
    # Show refusal message and do nothing
    case @battle.pbRandom(4)
    when 0 then @battle.pbDisplay(_INTL("{1} won't obey!",pbThis))
    when 1 then @battle.pbDisplay(_INTL("{1} turned away!",pbThis))
    when 2 then @battle.pbDisplay(_INTL("{1} is loafing around!",pbThis))
    when 3 then @battle.pbDisplay(_INTL("{1} pretended not to notice!",pbThis))
    end
    return false
  end

def PbCalculate_disobedience_chance(loyalty,happiness)
 amt = 0
  case loyalty
  when 0..10
    amt = 80
  when 11..50
    amt = 60
  when 51..64
    amt = 45
  when 65..149
    amt = 30
  when 150..224
    amt = 20
  when 225..254
    amt = 10
  when 255
    amt = 0 
  else
    amt = 0
  end
  amt-= (happiness/20).floor
  amt = 0 if amt<0
end

  end
