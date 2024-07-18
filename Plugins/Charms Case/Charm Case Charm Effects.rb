#===============================================================================#
# ================================ Item Call ================================== #
#===============================================================================#
ItemHandlers::UseInField.add(:CHARMCASE, proc { |item|
    pbFadeOutIn{
    scene = CharmCase_Scene.new
    screen = CharmCaseScreen.new(scene, $player.charmlist)
    choice = screen.pbBuyScreen
    }
})


#===============================================================================#
# =============================== Battle Stuff ================================ #
#===============================================================================#

#===============================================================================#
# ==== Clover Charm / Key Charm / Smart Charm / Spirit Charm / Viral Charm ==== #
#===============================================================================#
alias charm_pbGenerateWildPokemon pbGenerateWildPokemon

def pbGenerateWildPokemon(species, level, isRoamer = false)
  genwildpoke = charm_pbGenerateWildPokemon(species, level, isRoamer = false)
  items = genwildpoke.wildHoldItems
  first_pkmn = $player.first_pokemon
   chances = [50, 5, 1]
   
   # Settings start
  charmCommon = [CharmCaseSettings::CLOVERCOMMON, 100].min
  charmUncommon = [CharmCaseSettings::CLOVERUNCOMMON, 100].min
  charmRare = [CharmCaseSettings::CLOVERRARE, 100].min
  charmCombineCommon = [CharmCaseSettings::COMBINEDCOMMON, 100].min
  charmCombineUncommon = [CharmCaseSettings::COMBINEDUNCOMMON, 100].min
  charmCombineRare = [CharmCaseSettings::COMBINEDRARE, 100].min
  shinyCharmPokeRetry = CharmCaseSettings::SHINY_CHANCE_RETRIES
  lureCharmShiny = CharmCaseSettings::LURE_CHARM_RETRIES
  smartCharmEggTutorMove = [CharmCaseSettings::SMARTCHARM_EGGTUTOR_MOVE, 100].min
  viralCharmPokeRus = [CharmCaseSettings::VIRAL_CHARM_POKERUS, 100].min
  keyCharmHA = [CharmCaseSettings::KEYCHARM_HIDDEN_ABILITY, 100].min
  # End Settings
  
   # Clover Charm raises the chance that Wild Pokemon will have held items(Common, Uncommon, Rare)
 if $player.activeCharm?(:CLOVERCHARM)
    if first_pkmn
      if first_pkmn.ability_id == :COMPOUNDEYES || first_pkmn.ability_id == :SUPERLUCK
        chances = [charmCombineCommon, charmCombineUncommon, charmCombineRare]
      else
        chances = [charmCommon, charmUncommon, charmRare]
      end
    end
  end

  if !genwildpoke.shiny?
   shiny_retries = 0
   shiny_retries += shinyCharmPokeRetry if $player.activeCharm?(:SHINYCHARM)
   shiny_retries += lureCharmShiny if $player.activeCharm?(:LURECHARM) && $PokemonGlobal.fishing
  if Settings::HIGHER_SHINY_CHANCES_WITH_NUMBER_BATTLED
    values = [0, 0]
    case $player.pokedex.battled_count(species)
    when 0...50    then values = [0, 0]
    when 50...100  then values = [1, 15]
    when 100...200 then values = [2, 20]
    when 200...300 then values = [3, 25]
    when 300...500 then values = [4, 30]
    else                values = [5, 30]
    end
    shiny_retries += values[0] if values[1] > 0 && rand(1000) < values[1]
  end
  
   if shiny_retries > 0
    shiny_retries.times do
      break if genwildpoke.shiny?
      genwildpoke.shiny = nil   # Make it recalculate shininess
		end
	end
  end
  
  # Smart Charm has 30% chance to give Wild Pokemon an egg or tutor move.
  if ($player.activeCharm?(:SMARTCHARM) && rand(100) < smartCharmEggTutorMove)
    specialmoves = genwildpoke.species_data.tutor_moves + genwildpoke.species_data.get_egg_moves
    genwildpoke.learn_move(specialmoves.sample)
  end
  
  # Viral Charm has 10% chance of Wild Pokemon having PokeRus virus.
  genwildpoke.givePokerus if ($player.activeCharm?(:VIRALCHARM) && rand(100) < viralCharmPokeRus)
  
  # Key Charm has 30% chance of Wild Pokemon having their Hidden Ability.
  genwildpoke.ability_index = 2 if ($player.activeCharm?(:KEYCHARM) && rand(100) < keyCharmHA)
  return genwildpoke
end
  
#==============================================================================#
# ============================== Catching Charm ============================== #
#==============================================================================#
module Battle::CatchAndStoreMixin
alias charm_pbCaptureCalc pbCaptureCalc
 def pbCaptureCalc(pkmn, battler, catch_rate, ball)
     return 4 if $DEBUG && Input.press?(Input::CTRL)
    # Get a catch rate if one wasn't provided
    catch_rate = pkmn.species_data.catch_rate if !catch_rate
    # Modify catch_rate depending on the Poké Ball's effect
    if !pkmn.species_data.has_flag?("UltraBeast") || ball == :BEASTBALL
      catch_rate = Battle::PokeBallEffects.modifyCatchRate(ball, catch_rate, self, battler)
    else
      catch_rate /= 10
    end
	
	#Added in Elemental Charm effecting capture rate
	elemental_charm_type = nil
    charm_list = $player.elementCharmlist || []
    charms_active = $player.charmsActive || {}
    charm_list.each do |charm|
	   if charms_active[charm]
        type_effects = {
          :ELECTRICCHARM => :ELECTRIC,
          :FIRECHARM 	 => :FIRE,
          :WATERCHARM 	 => :WATER,
		  :GRASSCHARM 	 => :GRASS,
		  :NORMALCHARM 	 => :NORMAL,
		  :FIGHTINGCHARM => :FIGHTING,
		  :FLYINGCHARM	 => :FLYING,
		  :POISONCHARM 	 => :POISON,
		  :GROUNDCHARM 	 => :GROUND,
		  :ROCKCHARM 	 => :ROCK,
		  :BUGCHARM 	 => :BUG,
		  :GHOSTCHARM 	 => :GHOST,
		  :STEELCHARM 	 => :STEEL,
		  :PSYCHICCHARM  => :PSYCHIC,
		  :ICECHARM 	 => :ICE,
		  :DRAGONCHARM 	 => :DRAGON,
		  :DARKCHARM 	 => :DARK,
		  :FAIRYCHARM	 => :FAIRY
        }
        elemental_charm_type = type_effects[charm]
        break if elemental_charm_type
      end
    end

    # First half of the shakes calculation
    a = battler.totalhp
    b = battler.hp
    x = (((3 * a) - (2 * b)) * catch_rate.to_f) / (3 * a)
    # Calculation modifiers
    if battler.status == :SLEEP || battler.status == :FROZEN
      x *= 2.5
    elsif battler.status != :NONE
      x *= 1.5
    end
	if elemental_charm_type
      type_modifier = CharmCaseSettings::ELEMENTAL_CHARM_CAPTURE_MODIFIER
      if pkmn.hasType?(elemental_charm_type)
        x *= type_modifier
      end
    end
    x = x.floor
    x = 1 if x < 1
    # Definite capture, no need to perform randomness checks
    return 4 if x >= 255 || Battle::PokeBallEffects.isUnconditional?(ball, self, battler)
    # Second half of the shakes calculation
    y = (65_536 / ((255.0 / x)**0.1875)).floor
    if Settings::ENABLE_CRITICAL_CAPTURES
      dex_modifier = 0
      numOwned = $player.pokedex.owned_count
      if numOwned > 600
        dex_modifier = 5
      elsif numOwned > 450
        dex_modifier = 4
      elsif numOwned > 300
        dex_modifier = 3
      elsif numOwned > 150
        dex_modifier = 2
      elsif numOwned > 30
        dex_modifier = 1
      end
	  # Catching Charm increases chance of Critical Capture.(Guaranteed capture)
      dex_modifier *= CharmCaseSettings::CATCHING_CHARM_CRIT if $player.activeCharm?(:CATCHINGCHARM)
      c = x * dex_modifier / 12
      # Calculate the number of shakes
      if c > 0 && pbRandom(256) < c
        @criticalCapture = true
        return 4 if pbRandom(65_536) < y
        return 0
      end
    end
    # Calculate the number of shakes
    numShakes = 0
    4.times do |i|
      break if numShakes < i
      numShakes += 1 if pbRandom(65_536) < y
    end
    return numShakes
  end
end
	
#===============================================================================
# EXP Charm / EXP All Charm
#===============================================================================
class Battle
  alias charm_pbGainExp pbGainExp

  def pbGainExp
    @scene.pbWildBattleSuccess if wildBattle? && pbAllFainted?(1) && !pbAllFainted?(0)
    return if !@internalBattle || !@expGain
	# EXP All Charm divides EXP between all Pokemon in party.
	expAll = $player.has_exp_all || $bag.has?(:EXPALL) || $player.activeCharm?(:EXPALLCHARM)
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
          pbGainExpOne(i, b, numPartic, expShare, expAll, !pkmn.shadowPokemon?)
        end
        # Gain EVs and Exp for all other Pokémon because of Exp All
        if expAll
          showMessage = true
          eachInTeam(0, 0) do |pkmn, i|
            next if !pkmn.able?
            next if b.participants.include?(i) || expShare.include?(i)
            pbDisplayPaused(_INTL("Your other Pokémon also gained Exp. Points!")) if showMessage
            showMessage = false
            pbGainEVsOne(i, b)
            pbGainExpOne(i, b, numPartic, expShare, expAll, false)
          end
        end
      end
      # Clear the participants array
      b.participants = []
    end
  end

alias charm_pbGainExpOne pbGainExpOne
  def pbGainExpOne(idxParty, defeatedBattler, numPartic, expShare, expAll, showMessages = true)
   pkmn = pbParty(0)[idxParty]   # The Pokémon gaining Exp from defeatedBattler
    growth_rate = pkmn.growth_rate
    # Don't bother calculating if gainer is already at max Exp
    if pkmn.exp >= growth_rate.maximum_exp
      pkmn.calc_stats   # To ensure new EVs still have an effect
      return
    end
	isPartic    = defeatedBattler.participants.include?(idxParty)
    hasExpShare = expShare.include?(idxParty) || $player.activeCharm?(:EXPALLCHARM)
    level = defeatedBattler.level
    # Main Exp calculation
    exp = 0
    a = level * defeatedBattler.pokemon.base_exp
    if expShare.length > 0 && (isPartic || hasExpShare)
      if numPartic == 0   # No participants, all Exp goes to Exp Share holders
        exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? expShare.length : 1)
      elsif Settings::SPLIT_EXP_BETWEEN_GAINERS   # Gain from participating and/or Exp Share
        exp = a / (2 * numPartic) if isPartic
        exp += a / (2 * expShare.length) if hasExpShare
      else   # Gain from participating and/or Exp Share (Exp not split)
        exp = (isPartic) ? a : a / 2
      end
    elsif isPartic   # Participated in battle, no Exp Shares held by anyone
      exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? numPartic : 1)
	  # Adjust this for more EXP to other Party memebers, using EXP All
    elsif expAll
      exp = a / 2
    end
    return if exp <= 0
    # Pokémon gain more Exp from trainer battles
    exp = (exp * 1.5).floor if Settings::MORE_EXP_FROM_TRAINER_POKEMON && trainerBattle?
    # Scale the gained Exp based on the gainer's level (or not)
    if Settings::SCALED_EXP_FORMULA
      exp /= 5
      levelAdjust = ((2 * level) + 10.0) / (pkmn.level + level + 10.0)
      levelAdjust **= 5
      levelAdjust = Math.sqrt(levelAdjust)
      exp *= levelAdjust
      exp = exp.floor
      exp += 1 if isPartic || hasExpShare
    else
      exp /= 7
    end
    # Foreign Pokémon gain more Exp
    isOutsider = (pkmn.owner.id != pbPlayer.id ||
                 (pkmn.owner.language != 0 && pkmn.owner.language != pbPlayer.language))
    if isOutsider
      if pkmn.owner.language != 0 && pkmn.owner.language != pbPlayer.language
        exp = (exp * 1.7).floor
      else
        exp = (exp * 1.5).floor
      end
    end
    # Exp. Charm increases Exp gained
    exp = exp * 3 / 2 if $player.activeCharm?(:EXPCHARM)
	charm_pbGainExpOne(idxParty, defeatedBattler, numPartic, expShare, expAll, showMessages)
  end
 end

#==============================================================================#
# ======================== Heart Charm / Mercy Charm ========================= #
#==============================================================================#
class PokemonEncounters
  alias charm_encounter_triggered? encounter_triggered?

  def encounter_triggered?(enc_type, repel_active = false, triggered_by_step = true)
      if !enc_type || !GameData::EncounterType.exists?(enc_type)
      raise ArgumentError.new(_INTL("Encounter type {1} does not exist", enc_type))
    end
    return false if $game_system.encounter_disabled
    return false if !$player
    return false if $DEBUG && Input.press?(Input::CTRL)
    # Check if enc_type has a defined step chance/encounter table
    return false if !@step_chances[enc_type] || @step_chances[enc_type] == 0
    return false if !has_encounter_type?(enc_type)
    # Poké Radar encounters always happen, ignoring the minimum step period and
    # trigger probabilities
    return true if pbPokeRadarOnShakingGrass
    # Get base encounter chance and minimum steps grace period
    encounter_chance = @step_chances[enc_type].to_f
    min_steps_needed = (8 - (encounter_chance / 10)).clamp(0, 8).to_f
    # Apply modifiers to the encounter chance and the minimum steps amount
	# Mercy Chance divides encounter chance and multiples minimum steps needed for Wild Battle by 2
	# 	when Pokemon in party fainted. (Less chance of battles, less often)
    if $player.activeCharm?(:MERCYCHARM) && $player.able_pokemon_count < $player.pokemon_count
      encounter_chance /= 2
      min_steps_needed *= 2
    end
# Heart Charm multiples encounter chance and divides minimum steps needed for Wild Battles by 2.
#		(More chance of battles, more often)
    if $player.activeCharm?(:HEARTCHARM)
      encounter_chance *= 2
      min_steps_needed /= 2
    end
    return charm_encounter_triggered?(enc_type, repel_active, triggered_by_step)
  end
end

# Battle Section
class Battle::Battler
alias charm_pbProcessTurn pbProcessTurn
  def pbProcessTurn(choice, tryFlee = true)
    return false if fainted?
    # Wild roaming Pokémon always flee if possible
      if tryFlee && wild? &&
       @battle.rules["alwaysflee"] && @battle.pbCanRun?(@index) &&
       (!$player.activeCharm?(:HEARTCHARM) || (rand(1..100) <= CharmCaseSettings::HEART_CHARM_FLED))
      pbBeginTurn(choice)
      pbSEPlay("Battle flee")
      @battle.pbDisplay(_INTL("{1} fled from battle!", pbThis))
      @battle.decision = 3
      pbEndTurn(choice)
      return true
      end
	charm_pbProcessTurn(choice, tryFlee)
  end
end

	  # Party Pokémon gain happiness from walking
EventHandlers.add(:on_player_step_taken, :gain_happiness,
  proc {
    $PokemonGlobal.happinessSteps = 0 if !$PokemonGlobal.happinessSteps
    $PokemonGlobal.happinessSteps += 1
    next if $PokemonGlobal.happinessSteps < 128
    $player.able_party.each do |pkmn|
      if rand(2) == 0
        pkmn.changeHappiness("walking")
      end
      if $player.activeCharm?(:HEARTCHARM)
        pkmn.changeHappiness("walking")
      end
    end
    $PokemonGlobal.happinessSteps = 0
  }
)

#===============================================================================
# Balance Charm / Elemental Charms / Promo Charm
#===============================================================================
class PokemonEncounters
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
	end
	
	if favored_type.nil?
	    charm_list = $player.elementCharmlist || []
        charms_active = $player.charmsActive || {}
		scaling_factor ||= 0 
		elementCharmEncounter = [CharmCaseSettings::ELEMENTAL_CHARM_ENCOUNTER_RATE, 100].compact.min
        charm_list.each do |charm|
          if charms_active[charm] && Settings::MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS
            type_effects = {
              :ELECTRICCHARM => :ELECTRIC,
              :FIRECHARM => :FIRE,
              :WATERCHARM => :WATER,
              :GRASSCHARM => :GRASS,
              :NORMALCHARM => :NORMAL,
              :FIGHTINGCHARM => :FIGHTING,
              :FLYINGCHARM => :FLYING,
              :POISONCHARM => :POISON,
              :GROUNDCHARM => :GROUND,
              :ROCKCHARM => :ROCK,
              :BUGCHARM => :BUG,
              :GHOSTCHARM => :GHOST,
              :STEELCHARM => :STEEL,
              :PSYCHICCHARM => :PSYCHIC,
              :ICECHARM => :ICE,
              :DRAGONCHARM => :DRAGON,
              :DARKCHARM => :DARK,
              :FAIRYCHARM => :FAIRY
            }
			favored_type = type_effects[charm] if rand(100) < elementCharmEncounter
		  end
		end
	end  
	  

      if favored_type
        new_enc_list = []
        enc_list.each do |enc|
        species_data = GameData::Species.get(enc[1])
        new_enc_list.push(enc) if species_data.types.include?(favored_type)
        end
        enc_list = new_enc_list if new_enc_list.length > 0
      end
	  
	
		
	 # Balance charm makes probability of encounters the same for all species on map.
    if $player.activeCharm?(:BALANCECHARM)
       enc_list.each { |e| e[0] = 100 / enc_list.length }
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
    # Get the chosen species and level
    level = rand(encounter[2]..encounter[3])
    # Some abilities alter the level of the wild Pokémon
    if first_pkmn
      case first_pkmn.ability_id
      when :HUSTLE, :PRESSURE, :VITALSPIRIT
        level = encounter[3] if rand(100) < 50   # Highest possible level
      end
    end
	 promoCharmEncounter = CharmCaseSettings::PROMO_CHARM

      # Promo Charm increases the chance of encountering highest possible level on map. 30%
    level = encounter[3] if ($player.activeCharm?(:PROMOCHARM) && rand(100) < [promoCharmEncounter, 100].min)

    # Black Flute and White Flute alter the level of the wild Pokémon
	  if Essentials::VERSION <= "20.9"
        # Black Flute and White Flute alter the level of the wild Pokémon
        if Settings::FLUTES_CHANGE_WILD_ENCOUNTER_LEVELS
          if $PokemonMap.blackFluteUsed
            level = [level + rand(1..4), GameData::GrowthRate.max_level].min
          elsif $PokemonMap.whiteFluteUsed
            level = [level - rand(1..4), 1].max
          end
        end
        # Return [species, level]
        return [encounter[1], level]
      else
        # Black Flute and White Flute alter the level of the wild Pokémon
        if $PokemonMap.lower_level_wild_pokemon
          level = [level - rand(1..4), 1].max
        elsif $PokemonMap.higher_level_wild_pokemon
          level = [level + rand(1..4), GameData::GrowthRate.max_level].min
        end
        # Return [species, level]
        return [encounter[1], level]
      end
	  end
end
#==============================================================================#
# ================================= IV Charm ================================= #
#==============================================================================#
EventHandlers.add(:on_wild_pokemon_created, :charm_higher_IV, proc { |pkmn|
  ivcharm_active = $player.activeCharm?(:IVCHARM)
  ivCharmAddIv = CharmCaseSettings::IV_CHARM_ADD_IV
  if ivcharm_active
    pkmn.iv ||= {}
    GameData::Stat.each_main do |s|
      stat_id = s.id
	  # Adds 5 IVs to each stat.
      pkmn.iv[stat_id] = [pkmn.iv[stat_id] + ivCharmAddIv, 31].min if pkmn.iv[stat_id]
    end
  end
})
#===============================================================================
# * Lins Gene Charm (IV)
#===============================================================================
EventHandlers.add(:on_wild_pokemon_created, :charm_one_max_IV, proc { |pkmn|
  if $player.activeCharm?(:GENECHARM)
	  if rand(100) < [CharmCaseSettings::GENE_CHARM_ONE_MAX, 100].min
		stats = [:HP, :ATTACK, :DEFENSE, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, :SPEED]
		value = rand(1..6)
		indexList = []
		indexList = (0..5).to_a.sample(value)
			for index in indexList do
			  pkmn.iv[stats[index]] = 31
			end
		pkmn.calc_stats
	  end
   end
   }
   )
#==============================================================================#
# ======================= Minigame / Collectable Charms =======================#
#==============================================================================#

#==============================================================================#
# ================================ Berry Charm ================================#
#==============================================================================#  
def pbPickBerry(berry, qty = 1)
  qty *= 2 if $player.activeCharm?(:BERRYCHARM)
  berry = GameData::Item.get(berry)
  berry_name = (qty > 1) ? berry.name_plural : berry.name
  if qty > 1
    message = _INTL("There are {1} \\c[1]{2}\\c[0]!\nWant to pick them?", qty, berry_name)
  else
    message = _INTL("There is 1 \\c[1]{1}\\c[0]!\nWant to pick it?", berry_name)
  end
  return false if !pbConfirmMessage(message)
  if !$bag.can_add?(berry, qty)
    pbMessage(_INTL("Too bad...\nThe Bag is full..."))
    return false
  end
  $stats.berry_plants_picked += 1
  if qty >= GameData::BerryPlant.get(berry.id).maximum_yield
    $stats.max_yield_berry_plants += 1
  end
  $bag.add(berry, qty)
  if qty > 1
    pbMessage(_INTL("\\me[Berry get]You picked the {1} \\c[1]{2}\\c[0].\\wtnp[30]", qty, berry_name))
  else
    pbMessage(_INTL("\\me[Berry get]You picked the \\c[1]{1}\\c[0].\\wtnp[30]", berry_name))
  end
  pocket = berry.pocket
  pbMessage(_INTL("{1} put the \\c[1]{2}\\c[0] in the <icon=bagPocket{3}>\\c[1]{4}\\c[0] Pocket.\1",
                  $player.name, berry_name, pocket, PokemonBag.pocket_names[pocket - 1]))
  if Settings::NEW_BERRY_PLANTS
    pbMessage(_INTL("The soil returned to its soft and earthy state."))
  else
    pbMessage(_INTL("The soil returned to its soft and loamy state."))
  end
  this_event = pbMapInterpreter.get_self
  pbSetSelfSwitch(this_event.id, "A", true)
  return true
end

#===============================================================================#
# ================================ Coin Charm ================================= #
#===============================================================================#
  class VoltorbFlip
    def getInput
    if Input.trigger?(Input::UP)
      pbPlayCursorSE
      if @index[1] > 0
        @index[1] -= 1
        @sprites["cursor"].y -= 64
      else
        @index[1] = 4
        @sprites["cursor"].y = 256
      end
    elsif Input.trigger?(Input::DOWN)
      pbPlayCursorSE
      if @index[1] < 4
        @index[1] += 1
        @sprites["cursor"].y += 64
      else
        @index[1] = 0
        @sprites["cursor"].y = 0
      end
    elsif Input.trigger?(Input::LEFT)
      pbPlayCursorSE
      if @index[0] > 0
        @index[0] -= 1
        @sprites["cursor"].x -= 64
      else
        @index[0] = 4
        @sprites["cursor"].x = 256
      end
    elsif Input.trigger?(Input::RIGHT)
      pbPlayCursorSE
      if @index[0] < 4
        @index[0] += 1
        @sprites["cursor"].x += 64
      else
        @index[0] = 0
        @sprites["cursor"].x = 0
      end
    elsif Input.trigger?(Input::USE)
      if @cursor[0][3] == 64   # If in mark mode
        @squares.length.times do |i|
          if (@index[0] * 64) + 128 == @squares[i][0] && @index[1] * 64 == @squares[i][1] && @squares[i][3] == false
            pbSEPlay("Voltorb Flip mark")
          end
        end
        (@marks.length + 1).times do |i|
          if @marks[i].nil?
            @marks[i] = [@directory + "tiles", (@index[0] * 64) + 128, @index[1] * 64, 256, 0, 64, 64]
          elsif @marks[i][1] == (@index[0] * 64) + 128 && @marks[i][2] == @index[1] * 64
            @marks.delete_at(i)
            @marks.compact!
            @sprites["mark"].bitmap.clear
            break
          end
        end
        pbDrawImagePositions(@sprites["mark"].bitmap, @marks)
        pbWait(Graphics.frame_rate / 20)
      else
        # Display the tile for the selected spot
        icons = []
        @squares.length.times do |i|
          if (@index[0] * 64) + 128 == @squares[i][0] && @index[1] * 64 == @squares[i][1] && @squares[i][3] == false
            pbAnimateTile((@index[0] * 64) + 128, @index[1] * 64, @squares[i][2])
            @squares[i][3] = true
            # If Voltorb (0), display all tiles on the board
            if @squares[i][2] == 0
              pbSEPlay("Voltorb Flip explosion")
              # Play explosion animation
              # Part1
              animation = []
              3.times do |j|
                animation[0] = icons[0] = [@directory + "tiles", (@index[0] * 64) + 128, @index[1] * 64,
                                           704 + (64 * j), 0, 64, 64]
                pbDrawImagePositions(@sprites["animation"].bitmap, animation)
                pbWait(Graphics.frame_rate / 20)
                @sprites["animation"].bitmap.clear
              end
              # Part2
              animation = []
              6.times do |j|
                animation[0] = [@directory + "explosion", (@index[0] * 64) - 32 + 128, (@index[1] * 64) - 32,
                                j * 128, 0, 128, 128]
                pbDrawImagePositions(@sprites["animation"].bitmap, animation)
                pbWait(Graphics.frame_rate / 10)
                @sprites["animation"].bitmap.clear
              end
              # Unskippable text block, parameter 2 = wait time (corresponds to ME length)
              pbMessage(_INTL("\\me[Voltorb Flip game over]Oh no! You get 0 Coins!\\wtnp[50]"))
              pbShowAndDispose
              @sprites["mark"].bitmap.clear
              if @level > 1
                # Determine how many levels to reduce by
                newLevel = 0
                @squares.length.times do |j|
                  newLevel += 1 if @squares[j][3] == true && @squares[j][2] > 1
                end
                newLevel = @level if newLevel > @level
                if @level > newLevel
                  @level = newLevel
                  @level = 1 if @level < 1
                  pbMessage(_INTL("\\se[Voltorb Flip level down]Dropped to Game Lv. {1}!", @level.to_s))
                end
              end
              # Update level text
              @sprites["level"].bitmap.clear
              pbDrawShadowText(@sprites["level"].bitmap, 8, 154, 118, 28, "Level " + @level.to_s,
                               Color.new(60, 60, 60), Color.new(150, 190, 170), 1)
              @points = 0
              pbUpdateCoins
              # Revert numbers to 0s
              @sprites["numbers"].bitmap.clear
              5.times do |j|
                pbUpdateRowNumbers(0, 0, j)
                pbUpdateColumnNumbers(0, 0, j)
              end
              pbDisposeSpriteHash(@sprites)
              @firstRound = false
              pbNewGame
            else
              # Play tile animation
              animation = []
              4.times do |j|
                animation[0] = [@directory + "flipAnimation", (@index[0] * 64) - 14 + 128, (@index[1] * 64) - 16,
                                j * 92, 0, 92, 96]
                pbDrawImagePositions(@sprites["animation"].bitmap, animation)
                pbWait(Graphics.frame_rate / 20)
                @sprites["animation"].bitmap.clear
              end
              if @points == 0
                @points += @squares[i][2]
                pbSEPlay("Voltorb Flip point")
              elsif @squares[i][2] > 1
                @points *= @squares[i][2]
                pbSEPlay("Voltorb Flip point")
              end
              break
            end
          end
        end
      end
      count = 0
      @squares.length.times do |i|
        if @squares[i][3] == false && @squares[i][2] > 1
          count += 1
        end
      end
      pbUpdateCoins
      # Game cleared
      if count == 0
        @sprites["curtain"].opacity = 100
        pbMessage(_INTL("\\me[Voltorb Flip win]Game clear!\\wtnp[40]"))
#        pbMessage(_INTL("You've found all of the hidden x2 and x3 cards."))
#        pbMessage(_INTL("This means you've found all the Coins in this game, so the game is now over."))
        @points = @points * 3 if $player.activeCharm?(:COINCHARM) 
        pbMessage(_INTL("\\se[Voltorb Flip gain coins]{1} received {2} Coins!", $player.name, @points.to_s_formatted))
        # Update level text
        @sprites["level"].bitmap.clear
        pbDrawShadowText(@sprites["level"].bitmap, 8, 154, 118, 28, _INTL("Level {1}", @level.to_s),
                         Color.new(60, 60, 60), Color.new(150, 190, 170), 1)
        old_coins = $player.coins
        $player.coins += @points
        $stats.coins_won += $player.coins - old_coins if $player.coins > old_coins
        @points = 0
        pbUpdateCoins
        @sprites["curtain"].opacity = 0
        pbShowAndDispose
        # Revert numbers to 0s
        @sprites["numbers"].bitmap.clear
        5.times do |i|
          pbUpdateRowNumbers(0, 0, i)
          pbUpdateColumnNumbers(0, 0, i)
        end
        @sprites["curtain"].opacity = 100
        if @level < 8
          @level += 1
          pbMessage(_INTL("\\se[Voltorb Flip level up]Advanced to Game Lv. {1}!", @level.to_s))
          if @firstRound
#            pbMessage(_INTL("Congratulations!"))
#            pbMessage(_INTL("You can receive even more Coins in the next game!"))
            @firstRound = false
          end
        end
        pbDisposeSpriteHash(@sprites)
        pbNewGame
      end
    elsif Input.trigger?(Input::ACTION)
      pbPlayDecisionSE
      @sprites["cursor"].bitmap.clear
      if @cursor[0][3] == 0 # If in normal mode
        @cursor[0] = [@directory + "cursor", 128, 0, 64, 0, 64, 64]
        @sprites["memo"].visible = true
      else # Mark mode
        @cursor[0] = [@directory + "cursor", 128, 0, 0, 0, 64, 64]
        @sprites["memo"].visible = false
      end
    elsif Input.trigger?(Input::BACK)
      @sprites["curtain"].opacity = 100
      if @points == 0
        if pbConfirmMessage("You haven't found any Coins! Are you sure you want to quit?")
          @sprites["curtain"].opacity = 0
          pbShowAndDispose
          @quit = true
        end
      elsif pbConfirmMessage(_INTL("If you quit now, you will recieve {1} Coin(s). Will you quit?",
                                   @points.to_s_formatted))
        pbMessage(_INTL("{1} received {2} Coin(s)!", $player.name, @points.to_s_formatted))
        old_coins = $player.coins
        $player.coins += @points
        $stats.coins_won += $player.coins - old_coins if $player.coins > old_coins
        @points = 0
        pbUpdateCoins
        @sprites["curtain"].opacity = 0
        pbShowAndDispose
        @quit = true
      end
      @sprites["curtain"].opacity = 0
    end
    # Draw cursor
    pbDrawImagePositions(@sprites["cursor"].bitmap, @cursor)
  end
 end
 #==============================================================================#
# =============================== Mining Charm =============================== #
#==============================================================================#
 class MiningGameScene
	def pbHit
    hittype = 0
	actual_hits ||= 0
	if $player.activeCharm?(:MININGCHARM)
      charm = 0.75
    else
      charm = 1
    end
#Added value modification for having mining charm
    position = @sprites["cursor"].position
    if @sprites["cursor"].mode == 1   # Hammer
      pattern = [1, 2, 1,
                 2, 2, 2,
                 1, 2, 1]
#Passed the modified value onto the hammer hits, normal value if !miningcharm
        actual_hits += charm * @sprites["crack"].hits
		@sprites["crack"].hits += 2 * charm if !($DEBUG && Input.press?(Input::CTRL))
    else                            # Pick
      pattern = [0, 1, 0,
                 1, 2, 1,
                 0, 1, 0]
#Passed the modified value onto the pick hits, normal value if !miningcharm
        @sprites["crack"].hits += 1 * charm if !($DEBUG && Input.press?(Input::CTRL))
		actual_hits += charm * @sprites["crack"].hits
      end
    if @sprites["tile#{position}"].layer <= pattern[4] && pbIsIronThere?(position)
      @sprites["tile#{position}"].layer -= pattern[4]
      pbSEPlay("Mining iron")
      hittype = 2
    else
      3.times do |i|
        ytile = i - 1 + (position / BOARD_WIDTH)
        next if ytile < 0 || ytile >= BOARD_HEIGHT
        3.times do |j|
          xtile = j - 1 + (position % BOARD_WIDTH)
          next if xtile < 0 || xtile >= BOARD_WIDTH
          @sprites["tile#{xtile + (ytile * BOARD_WIDTH)}"].layer -= pattern[j + (i * 3)]
        end
      end
      if @sprites["cursor"].mode == 1   # Hammer
        pbSEPlay("Mining hammer")
      else
        pbSEPlay("Mining pick")
      end
    end
    update
    Graphics.update
    hititem = (@sprites["tile#{position}"].layer == 0 && pbIsItemThere?(position))
    hittype = 1 if hititem
    @sprites["cursor"].animate(hittype)
    revealed = pbCheckRevealed
    if revealed.length > 0
      pbSEPlay("Mining reveal full")
      pbFlashItems(revealed)
    elsif hititem
      pbSEPlay("Mining reveal")
    end
  end
 end
 

#==============================================================================#
# ========================= Slots Charm / Coin Charm ========================= #
#==============================================================================#
 class SlotMachineScene
#Payout
	def pbPayout
    @replay = false
    payout = 0
    bonus = 0
    wonRow = []
    # Get reel pictures
    reel1 = @sprites["reel1"].showing
    reel2 = @sprites["reel2"].showing
    reel3 = @sprites["reel3"].showing
    combinations = [[reel1[1], reel2[1], reel3[1]], # Centre row
                    [reel1[0], reel2[0], reel3[0]], # Top row
                    [reel1[2], reel2[2], reel3[2]], # Bottom row
                    [reel1[0], reel2[1], reel3[2]], # Diagonal top left -> bottom right
                    [reel1[2], reel2[1], reel3[0]]] # Diagonal bottom left -> top right
    combinations.length.times do |i|
      break if i >= 1 && @wager <= 1 # One coin = centre row only
      break if i >= 3 && @wager <= 2 # Two coins = three rows only
      wonRow[i] = true
      case combinations[i]
      when [1, 1, 1]   # Three Magnemites
        payout += 8
      when [2, 2, 2]   # Three Shellders
        payout += 8
      when [3, 3, 3]   # Three Pikachus
        payout += 15
      when [4, 4, 4]   # Three Psyducks
        payout += 15
      when [5, 5, 6], [5, 6, 5], [6, 5, 5], [6, 6, 5], [6, 5, 6], [5, 6, 6]   # 777 multi-colored
        payout += 90
        bonus = 1 if bonus < 1
      when [5, 5, 5], [6, 6, 6]   # Red 777, blue 777
        payout += 300
        bonus = 2 if bonus < 2
      when [7, 7, 7]   # Three replays
        @replay = true
      else
        if combinations[i][0] == 0   # Left cherry
          if combinations[i][1] == 0   # Centre cherry as well
            payout += 4
          else
            payout += 2
          end
        else
          wonRow[i] = false
        end
      end
    end
   if $player.activeCharm?(:COINCHARM) && $player.activeCharm?(:SLOTSCHARM)
  # If both charms are active, multiply by 5
      payout *= 5
   elsif $player.activeCharm?(:COINCHARM) || $player.activeCharm?(:SLOTSCHARM)
  # If only :COINCHARM or :SLOTSCHARM is active, multiply by 3
      payout *= 3
   end
    @sprites["payout"].score = payout
    frame = 0
    if payout > 0 || @replay
      if bonus > 0
        pbMEPlay("Slots big win")
      else
        pbMEPlay("Slots win")
      end
      # Show winning animation
      timePerFrame = Graphics.frame_rate / 8
      until frame == Graphics.frame_rate * 3
        Graphics.update
        Input.update
        update
        @sprites["window2"].bitmap&.clear
        @sprites["window1"].setBitmap(sprintf("Graphics/UI/Slot Machine/win"))
        @sprites["window1"].src_rect.set(152 * ((frame / timePerFrame) % 4), 0, 152, 208)
        if bonus > 0
          @sprites["window2"].setBitmap(sprintf("Graphics/UI/Slot Machine/bonus"))
          @sprites["window2"].src_rect.set(152 * (bonus - 1), 0, 152, 208)
        end
        @sprites["light1"].visible = true
        @sprites["light1"].src_rect.set(0, 26 * ((frame / timePerFrame) % 4), 96, 26)
        @sprites["light2"].visible = true
        @sprites["light2"].src_rect.set(0, 26 * ((frame / timePerFrame) % 4), 96, 26)
        (1..5).each do |i|
          if wonRow[i - 1]
            @sprites["row#{i}"].visible = (frame / timePerFrame).even?
          else
            @sprites["row#{i}"].visible = false
          end
        end
        frame += 1
      end
      @sprites["light1"].visible = false
      @sprites["light2"].visible = false
      @sprites["window1"].src_rect.set(0, 0, 152, 208)
      # Pay out
      loop do
        break if @sprites["payout"].score <= 0
        Graphics.update
        Input.update
        update
        @sprites["payout"].score -= 1
        @sprites["credit"].score += 1
        if Input.trigger?(Input::USE) || @sprites["credit"].score == Settings::MAX_COINS
          @sprites["credit"].score += @sprites["payout"].score
          @sprites["payout"].score = 0
        end
      end
      (Graphics.frame_rate / 2).times do
        Graphics.update
        Input.update
        update
      end
    else
      # Show losing animation
      timePerFrame = Graphics.frame_rate / 4
      until frame == Graphics.frame_rate * 2
        Graphics.update
        Input.update
        update
        @sprites["window2"].bitmap&.clear
        @sprites["window1"].setBitmap(sprintf("Graphics/UI/Slot Machine/lose"))
        @sprites["window1"].src_rect.set(152 * ((frame / timePerFrame) % 2), 0, 152, 208)
        frame += 1
      end
    end
    @wager = 0
  end
  # Changing the Background image depending on payout
  def pbStartScene(difficulty)
      @sprites = {}
      @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
      @viewport.z = 99999
	  if $player.activeCharm?(:COINCHARM) && $player.activeCharm?(:SLOTSCHARM)
		bg_image = "Graphics/UI/Slot Machine/bg2"  # Use this when both :COINCHARM and :SLOTSCHARM are active
	  elsif $player.activeCharm?(:COINCHARM) || $player.activeCharm?(:SLOTSCHARM)
		bg_image = "Graphics/UI/Slot Machine/bg1"  # Use this when only :COINCHARM is active
	  else
		bg_image = "Graphics/UI/Slot Machine/bg"   # Default option
	  end
	  bg_sprite = IconSprite.new(0, 0, @viewport)
	  bg_sprite.setBitmap(bg_image)
     # addBackgroundPlane(@sprites, "bg", bg_image, @viewport)
	if Essentials::VERSION <= "20.9"
		@sprites["reel1"] = SlotMachineReel.new(64, 112, difficulty)
		@sprites["reel2"] = SlotMachineReel.new(144, 112, difficulty)
		@sprites["reel3"] = SlotMachineReel.new(224, 112, difficulty)
	elsif Essentials::VERSION >= "21"
		@sprites["reel1"] = SlotMachineReel.new(64, 112, 1, difficulty)
		@sprites["reel2"] = SlotMachineReel.new(144, 112, 2, difficulty)
		@sprites["reel3"] = SlotMachineReel.new(224, 112, 3, difficulty)
	else
		pbMessage("Not supported")
	end
	    (1..3).each do |i|
			@sprites["button#{i}"] = IconSprite.new(68 + (80 * (i - 1)), 260, @viewport)
			@sprites["button#{i}"].setBitmap("Graphics/UI/Slot Machine/button")
			@sprites["button#{i}"].visible = false
		end
	    (1..5).each do |i|
        y = [170, 122, 218, 82, 82][i - 1]
        @sprites["row#{i}"] = IconSprite.new(2, y, @viewport)
        @sprites["row#{i}"].setBitmap(sprintf("Graphics/UI/Slot Machine/line%1d%s",
                                              1 + (i / 2), (i >= 4) ? ((i == 4) ? "a" : "b") : ""))
        @sprites["row#{i}"].visible = false
		end
      @sprites["light1"] = IconSprite.new(16, 32, @viewport)
      @sprites["light1"].setBitmap("Graphics/UI/Slot Machine/lights")
      @sprites["light1"].visible = false
      @sprites["light2"] = IconSprite.new(240, 32, @viewport)
      @sprites["light2"].setBitmap("Graphics/UI/Slot Machine/lights")
      @sprites["light2"].mirror = true
      @sprites["light2"].visible = false
      @sprites["window1"] = IconSprite.new(358, 96, @viewport)
      @sprites["window1"].setBitmap(_INTL("Graphics/UI/Slot Machine/insert"))
      @sprites["window1"].src_rect.set(0, 0, 152, 208)
      @sprites["window2"] = IconSprite.new(358, 96, @viewport)
      @sprites["credit"] = SlotMachineScore.new(360, 66, $player.coins)
      @sprites["payout"] = SlotMachineScore.new(438, 66, 0)
      @wager = 0
      update
      pbFadeInAndShow(@sprites)
	end
end
class SlotMachineReel < BitmapSprite
	if Essentials::VERSION <= "20.9"
	  def stopSpinning(noslipping = false)
		@stopping = true
		@slipping = SLIPPING[rand(SLIPPING.length)]
		@slipping = 0 if noslipping || $player.activeCharm?(:SLOTSCHARM)
	  end
	  def update
		self.bitmap.clear
		if @toppos == 0 && @stopping && @slipping == 0
		  @spinning = @stopping = false
		end
		if @spinning
		  speed = SCROLLSPEED
		  speed =(speed * 3 / 4).to_i if $player.activeCharm?(:SLOTSCHARM)
		  @toppos += speed
		  if @toppos > 0
			@toppos -= 48
			@index = (@index + 1) % @reel.length
			@slipping -= 1 if @slipping > 0
		  end
		end
		4.times do |i|
		  num = @index - i
		  num += @reel.length if num < 0
		  self.bitmap.blt(0, @toppos + (i * 48), @images.bitmap, Rect.new(@reel[num] * 64, 0, 64, 48))
		end
		self.bitmap.blt(0, 0, @shading.bitmap, Rect.new(0, 0, 64, 144))
	  end
	elsif Essentials::VERSION >= "20.0"
		def initialize(x, y, reel_num, difficulty = 1)
			@viewport = Viewport.new(x, y, 64, 144)
			@viewport.z = 99999
			super(64, 144, @viewport)
			@reel_num = reel_num
			@difficulty = difficulty
			@reel = ICONS_SETS[reel_num - 1].clone
			@toppos = 0
			@current_y_pos = -1
			@spin_speed = SCROLL_SPEED
			@spin_speed /= 1.5 if difficulty == 0
			@spin_speed = $player.activeCharm?(:SLOTSCHARM) ? 487 : 650
			@spinning = false
			@stopping = false
			@slipping = 0
			@index = rand(@reel.length)
			@images = AnimatedBitmap.new(_INTL("Graphics/UI/Slot Machine/images"))
			@shading = AnimatedBitmap.new("Graphics/UI/Slot Machine/ReelOverlay")
			update
		end
	end
	  def stopSpinning(noslipping = false)
		@stopping = true
		@slipping = SLIPPING.sample
		case @difficulty
			when 0   # Easy
			  second_slipping = SLIPPING.sample
			  @slipping = [@slipping, second_slipping].min
			when 2   # Hard
			  second_slipping = SLIPPING.sample
			  @slipping = [@slipping, second_slipping].max
			end
		@slipping = 0 if noslipping || $player.activeCharm?(:SLOTSCHARM)
	  end
end
# Finding Coins. Mimicing the "Hidden Item" like coins scattered on the ground
#	in the Game Corner. Call "pbReceiveCoins(10)" where 10 is the amount of coins found.
def pbReceiveCoins(quantity)
  if $player.activeCharm?(:COINCHARM)
    quantity *= 3
  end
  $player.coins += quantity
  pbMessage("You have received #{quantity} coins!")
end

#===============================================================================#
# ================================ MISC CHARMS ================================ #
#===============================================================================#

#===============================================================================
# Gold Charm
#===============================================================================
class Battle
  alias charm_pbGainMoney pbGainMoney
  def pbGainMoney
    return if !@internalBattle || !@moneyGain
	goldCharmPayDay = CharmCaseSettings::GOLD_CHARM_PAY_DAY
	goldCharmGetGold = CharmCaseSettings::GOLD_CHARM_GET_GOLD
	# Should return just the added Gold for Charm.
    if trainerBattle?
      tMoney = 0
      @opponent.each_with_index do |t, i|
        tMoney += pbMaxLevelInTeam(1, i) * t.base_money
      end
	  # Gold Charm multiples Trainer Battle gain by 2.
	  tMoney *= goldCharmPayDay if $player.activeCharm?(:GOLDCHARM)
      oldMoney = pbPlayer.money
      pbPlayer.money += tMoney
      moneyGained = pbPlayer.money - oldMoney
      if moneyGained > 0
        $stats.battle_money_gained += moneyGained
      end
	  @field.effects[PBEffects::PayDay] += goldCharmGetGold if $player.activeCharm?(:GOLDCHARM)
    
    end
	# Gives a flat 1,000 gold after each Trainer Battle.
    charm_pbGainMoney
  end
end

#==============================================================================#
# =============================== Healing Charm ============================== #
#==============================================================================#
# Doubles HP restored when using HP restoring items.
def pbItemRestoreHP(pkmn, restoreHP)
healingCharmMultiply = CharmCaseSettings::HEALING_CHARM_MULTIPLY
	restoreHP *= healingCharmMultiply if $player.activeCharm?(:HEALINGCHARM)
	newHP = pkmn.hp + restoreHP
	newHP = pkmn.totalhp if newHP > pkmn.totalhp
	hpGain = newHP - pkmn.hp
	pkmn.hp = newHP
  return hpGain
end
	#Every 35 steps heals 1 hp. Will not work on fainted Pokemon.
      # Check if there's at least one Pokémon in the party that needs healing
EventHandlers.add(:on_player_step_taken, :gain_HP,
  proc {

	healingCharmHealOnStep = CharmCaseSettings::HEALING_CHARM_HEAL_ON_STEP
    if $player.activeCharm?(:HEALINGCHARM)
      recovery_interval = healingCharmHealOnStep  # Recover 1 health every 35 steps
      steps_taken = $PokemonGlobal.happinessSteps

      # Check if there's at least one Pokémon in the party that needs healing
      if $player.party.any? { |pkmn| pkmn.able? && pkmn.hp < pkmn.totalhp }
        if steps_taken % recovery_interval == 0
           hp_to_recover = steps_taken / recovery_interval
           $player.party.each do |pkmn|
            if pkmn.able? && pkmn.hp < pkmn.totalhp && hp_to_recover > 0
              recovered_hp = [1, hp_to_recover].min  # Ensure we recover at most 1 HP
              pkmn.hp += recovered_hp
              hp_to_recover -= recovered_hp
              pkmn.hp = pkmn.totalhp if pkmn.hp > pkmn.totalhp
            end
          end
        end
      end
    end
  }
)
#==============================================================================#
# ================================ Twin Charm =================================#
#==============================================================================#
#Doubles Hidden Items found

def pbItemBall(item, quantity = 1)
  item = GameData::Item.get(item)
  return false if !item || quantity < 1
  event_name = $game_map.events[@event_id].name  # Use the event_id to get the event and its name
  quantity *= 2 if event_name[/hiddenitem/i] && $player.activeCharm?(:TWINCHARM)
  
  itemname = (quantity > 1) ? item.portion_name_plural : item.portion_name
  pocket = item.pocket
  move = item.move
  if $bag.add(item, quantity)   # If item can be picked up
    meName = (item.is_key_item?) ? "Key item get" : "Item get"
    if item == :DNASPLICERS
      pbMessage("\\me[#{meName}]" + _INTL("You found \\c[1]{1}\\c[0]!", itemname) + "\\wtnp[40]")
    elsif item.is_machine?   # TM or HM
      if quantity > 1
        pbMessage("\\me[Machine get]" + _INTL("You found {1} \\c[1]{2} {3}\\c[0]!",
                                              quantity, itemname, GameData::Move.get(move).name) + "\\wtnp[70]")
      else
        pbMessage("\\me[Machine get]" + _INTL("You found \\c[1]{1} {2}\\c[0]!",
                                              itemname, GameData::Move.get(move).name) + "\\wtnp[70]")
      end
	elsif item.is_charm? || item.is_echarm?
	#
    elsif quantity > 1
      pbMessage("\\me[#{meName}]" + _INTL("You found {1} \\c[1]{2}\\c[0]!", quantity, itemname) + "\\wtnp[40]")
    elsif itemname.starts_with_vowel?
      pbMessage("\\me[#{meName}]" + _INTL("You found an \\c[1]{1}\\c[0]!", itemname) + "\\wtnp[40]")
    else
      pbMessage("\\me[#{meName}]" + _INTL("You found a \\c[1]{1}\\c[0]!", itemname) + "\\wtnp[40]")
    end
    pbMessage(_INTL("You put the {1} in\\nyour Bag's <icon=bagPocket{2}>\\c[1]{3}\\c[0] pocket.",
                    itemname, pocket, PokemonBag.pocket_names[pocket - 1]))
    return true
  end
  # Can't add the item
  if item.is_machine?   # TM or HM
    if quantity > 1
      pbMessage(_INTL("You found {1} \\c[1]{2} {3}\\c[0]!", quantity, itemname, GameData::Move.get(move).name))
    else
      pbMessage(_INTL("You found \\c[1]{1} {2}\\c[0]!", itemname, GameData::Move.get(move).name))
    end
  elsif quantity > 1
    pbMessage(_INTL("You found {1} \\c[1]{2}\\c[0]!", quantity, itemname))
  elsif itemname.starts_with_vowel?
    pbMessage(_INTL("You found an \\c[1]{1}\\c[0]!", itemname))
  else
    pbMessage(_INTL("You found a \\c[1]{1}\\c[0]!", itemname))
  end
  pbMessage(_INTL("But your Bag is full..."))
  return false
end


#==============================================================================#
# Egg Stuff
#==============================================================================#  

#===============================================================================
# Oval Charm 
#===============================================================================
  def update_on_step_taken
    @step_counter += 1
    if @step_counter >= 256
      @step_counter = 0
      # Make an egg available at the Day Care
      if !@egg_generated && count == 2
        compat = compatibility
        egg_chance = [0, 20, 50, 70][compat]
        egg_chance = [0, 40, 70, 80][compat] if $player.activeCharm?(:OVALCHARM)
        @egg_generated = true if rand(100) < egg_chance
      end
      # Have one deposited Pokémon learn an egg move from the other
      # NOTE: I don't know what the chance of this happening is.
      share_egg_move if @share_egg_moves && rand(100) < 50
    end
    # Day Care Pokémon gain Exp/moves
    if @gain_exp
      @slots.each { |slot| slot.add_exp }
    end
  end
  
#===============================================================================#
# ====================== Shiny Charm / IV Charm for Eggs ====================== #
#===============================================================================#  
 class DayCare
  module EggGenerator
    module_function
       def generate(mother, father)
      if mother.male? || father.female? || mother.genderless?
        mother, father = father, mother
      end
	  
	  if PluginManager.installed?("Essentials Deluxe")
		  mother_data = [mother, fluid_egg_group?(mother.species_data.egg_groups)]
		  father_data = [father, fluid_egg_group?(father.species_data.egg_groups)]
      else
		  mother_data = [mother, mother.species_data.egg_groups.include?(:Ditto)]
		  father_data = [father, father.species_data.egg_groups.include?(:Ditto)]
	  end

	  species_parent = (mother_data[1]) ? father : mother
      baby_species = determine_egg_species(species_parent.species, mother, father)
      mother_data.push(mother.species_data.breeding_can_produce?(baby_species))
      father_data.push(father.species_data.breeding_can_produce?(baby_species))
      egg = generate_basic_egg(baby_species)
      inherit_form(egg, species_parent, mother_data, father_data)
      inherit_nature(egg, mother, father)
      inherit_ability(egg, mother_data, father_data)
      inherit_moves(egg, mother_data, father_data)
      inherit_IVs(egg, mother, father)
      inherit_poke_ball(egg, mother_data, father_data)
	  inherit_birthsign(egg, mother, father) if PluginManager.installed?("Pokémon Birthsigns")
      set_shininess(egg, mother, father)
      set_pokerus(egg)
      egg.calc_stats
      adjust_ivs(egg)
      return egg
    end

	def adjust_ivs(egg)
	ivCharmIvEggAdd = ::CharmCaseSettings::IVCHARM_IV_EGG_ADD
	  if activeCharm?(:IVCHARM)
		egg.iv ||= {}
		GameData::Stat.each_main do |s|
		  stat_id = s.id
		  egg.iv[stat_id] = [egg.iv[stat_id] + ivCharmIvEggAdd, 31].min if egg.iv[stat_id]
		end
	  end
	end
	  
	 def set_shininess(egg, mother, father)
	 # Start Settings #
	 fatherMotherShiny = true
	 motherFatherEggShinyChance = 0
	 shinyCharmShinyRetryEgg = 0
	 fatherMotherShiny = CharmCaseSettings::FATHERMOTHER_SHINY
	 motherFatherEggShinyChance = CharmCaseSettings::MOTHERFATHER_EGG_SHINY_CHANCE
	 shinyCharmShinyRetryEgg = CharmCaseSettings::SHINYCHARM_SHINY_RETRY_EGG
	 # End Settings #
      shiny_retries = 0
      if father.owner.language != mother.owner.language
        shiny_retries += (Settings::MECHANICS_GENERATION >= 8) ? 6 : 5
      end
	  if fatherMotherShiny
	  # I added in 3 extra retries (chances) if mother / father are shiny as well.
      shiny_retries += motherFatherEggShinyChance if father.shiny? || mother.shiny?
	  end
	  # Gives 2 extra retries(chances) with Shiny Charm.
      shiny_retries += shinyCharmShinyRetryEgg if $player.activeCharm?(:SHINYCHARM)
      return if shiny_retries == 0
      shiny_retries.times do
        break if egg.shiny?
        egg.shiny = nil   # Make it recalculate shininess
        egg.personalID = rand(2**16) | (rand(2**16) << 16)
        end
	end
end
end
#==============================================================================#
# ================================ Step Charm ================================ #
#==============================================================================#
# Step Charm reduces steps needed to hatch eggs
EventHandlers.add(:on_player_step_taken, :eggs_charm,
  proc {
    $player.party.each do |egg|
      next if egg.steps_to_hatch <= 0
      egg.steps_to_hatch -= 1 if $player.activeCharm?(:STEPCHARM)
      if egg.steps_to_hatch <= 0
        egg.steps_to_hatch = 0
        pbHatch(egg)
      end
    end
  }
)

#==============================================================================#
# ============================ Effort Charm (EV) ============================= #
#==============================================================================#
# Increases EV gain from Battle by 2.
class Battle
  alias charm_pbGainEVsOne pbGainEVsOne
  
  def pbGainEVsOne(idxParty, defeatedBattler)
    charm_pbGainEVsOne(idxParty, defeatedBattler) # Call the original method first
    
    # Double EV gain because of Effort Charm
    if $player.activeCharm?(:EFFORTCHARM)   # Charm is in the bag
      pkmn = pbParty(0)[idxParty]   # The Pokémon gaining EVs from defeatedBattler
      evYield = defeatedBattler.pokemon.evYield
      GameData::Stat.each_main do |s|
        evYield[s.id] *= 2
      end
    end
  end
end

#==============================================================================#
# ============================ Pokemon Mart Setup ============================ #
#==============================================================================#
# Allows purchasing and management of Charms from the normal Pokemon Mart call
class PokemonMartScreen
  def pbBuyScreen
    @scene.pbStartBuyScene(@stock, @adapter)
    item = nil
    loop do
      item = @scene.pbChooseBuyItem
      break if !item
      quantity       = 0
      itemname       = @adapter.getName(item)
      itemnameplural = @adapter.getNamePlural(item)
      price = @adapter.getPrice(item)
      if @adapter.getMoney < price
        pbDisplayPaused(_INTL("You don't have enough money."))
        next
      end
      if GameData::Item.get(item).is_important?
        next if !pbConfirm(_INTL("So you want the {1}?\nIt'll be ${2}. All right?",
                                 itemname, price.to_s_formatted))
        quantity = 1
      else
        maxafford = (price <= 0) ? Settings::BAG_MAX_PER_SLOT : @adapter.getMoney / price
        maxafford = Settings::BAG_MAX_PER_SLOT if maxafford > Settings::BAG_MAX_PER_SLOT
        quantity = @scene.pbChooseNumber(
          _INTL("So how many {1}?", itemnameplural), item, maxafford
        )
        next if quantity == 0
        price *= quantity
        if quantity > 1
          next if !pbConfirm(_INTL("So you want {1} {2}?\nThey'll be ${3}. All right?",
                                   quantity, itemnameplural, price.to_s_formatted))
        elsif quantity > 0
          next if !pbConfirm(_INTL("So you want {1} {2}?\nIt'll be ${3}. All right?",
                                   quantity, itemname, price.to_s_formatted))
        end
      end
      if @adapter.getMoney < price
        pbDisplayPaused(_INTL("You don't have enough money."))
        next
      end
      added = 0
      quantity.times do
        break if !@adapter.addItem(item)
        added += 1
      end
      if added == quantity
        $stats.money_spent_at_marts += price
        $stats.mart_items_bought += quantity
        @adapter.setMoney(@adapter.getMoney - price)
        @stock.delete_if { |itm| GameData::Item.get(itm).is_important? && $bag.has?(itm) }
        @stock.delete_if { |item| $player.charmlist.include?(item) }
		@stock.delete_if { |item| $player.elementCharmlist.include?(item) }
        pbDisplayPaused(_INTL("Here you are! Thank you!")) { pbSEPlay("Mart buy item") }
        if quantity >= 10 && GameData::Item.exists?(:PREMIERBALL)
          if Settings::MORE_BONUS_PREMIER_BALLS && GameData::Item.get(item).is_poke_ball?
            premier_balls_added = 0
            (quantity / 10).times do
              break if !@adapter.addItem(:PREMIERBALL)
              premier_balls_added += 1
            end
            ball_name = GameData::Item.get(:PREMIERBALL).portion_name
            ball_name = GameData::Item.get(:PREMIERBALL).portion_name_plural if premier_balls_added > 1
            $stats.premier_balls_earned += premier_balls_added
            pbDisplayPaused(_INTL("And have {1} {2} on the house!", premier_balls_added, ball_name))
          elsif !Settings::MORE_BONUS_PREMIER_BALLS && GameData::Item.get(item) == :POKEBALL
            if @adapter.addItem(:PREMIERBALL)
              ball_name = GameData::Item.get(:PREMIERBALL).name
              $stats.premier_balls_earned += 1
              pbDisplayPaused(_INTL("And have 1 {1} on the house!", ball_name))
            end
          end
        end
      else
        added.times do
          if !@adapter.removeItem(item)
            raise _INTL("Failed to delete stored items")
          end
        end
        pbDisplayPaused(_INTL("You have no room in your Bag."))
      end
    end
    @scene.pbEndBuyScene
  end
end


class PokemonMartAdapter
  alias charm_addItem addItem
  
  def addItem(item)
    if GameData::Item.get(item).is_charm?
      pbGainCharm(item)
	elsif GameData::Item.get(item).is_echarm?
	  pbGainElementCharm(item)
    else
      charm_addItem(item)
    end
  end


	alias charm_getPrice getPrice
  def getPrice(item, selling = false)
    if $game_temp.mart_prices && $game_temp.mart_prices[item]
      if selling
        return $game_temp.mart_prices[item][1] if $game_temp.mart_prices[item][1] >= 0
      elsif $game_temp.mart_prices[item][0] > 0
        return $game_temp.mart_prices[item][0]
      end
    end
	return GameData::Item.get(item).sell_price if selling
	return ($player.activeCharm?(:FRUGALCHARM) ? (GameData::Item.get(item).price / 2).round : GameData::Item.get(item).price )
  end
end

alias charm_pbPokemonMart pbPokemonMart
def pbPokemonMart(stock, speech = nil, cantsell = false)
  stock.delete_if { |item| $player.charmlist.include?(item) }
  stock.delete_if { |item| $player.elementCharmlist.include?(item) }
  charm_pbPokemonMart(stock, speech, cantsell)  
end

#==============================================================================#
# ============================== Wishing Charm =============================== #
#==============================================================================#
if PluginManager.installed?("Bag Screen w/int. Party")
  class PokemonBag_Scene
    def pbRefreshParty
      for i in 0...Settings::MAX_PARTY_SIZE
        if @party[i]
          @sprites["pokemon#{i}"] = PokemonBagPartyPanel.new(@party[i], i, @viewport)
          @sprites["pokemon#{i}"].pokemon = @party[i]
        else
          @sprites["pokemon#{i}"] = PokemonBagPartyBlankPanel.new(@party[i], i, @viewport)
        end
      end
    end
  end
end
# Every day, awards player with one random item or Pokemon. Pokemon can be selected
#	auto from the auto setting, or from an approved list. Both settings are found in the Settings
#	file. Auto will generate a random Pokemon that isn't a Legendary or a starter. (Can be changed
#	here, that's just my personal preference. Approved list is also found in the settings file.
# Add or remove Pokemon from the approved list to have it randomly give just the Pokemon from the list.

# If WISHING_CHARM_USE_AUTO is set to true, it will automaticly generate the eggs from all possible species
# that aren't blacklisted.

def pbWishingCharmPoke
wishingCharmBoth 		 = ::CharmCaseSettings::WISHING_CHARM_ITEM_AND_POKE
wishingCharmUseAuto 	 = ::CharmCaseSettings::WISHING_CHARM_USE_AUTO
# Wishing Charm setting for both items and Poke.
	if wishingCharmBoth
	# Chooses between items and Pokemon if true.
	  if rand(100) < 50
      give_random_item
      else
	# If auto populate is true, runs the list from all species.
		if wishingCharmUseAuto
		wishingCharmAutoPop
		else
		# If false, pulls data from approved list.
		wishingCharmApprovedList
		end
	  end
	else
	# If not items, jumps to just Pokemon. If use auto is on pulls auto.
		if wishingCharmUseAuto
			wishingCharmAutoPop
		else
		# Else pulls approved list.
			wishingCharmApprovedList
		end
	end
end
	
	
	# Call to give random item
def give_random_item
	wishingCharmItems 		 = ::CharmCaseSettings::WISHING_CHARM_ITEM_LIST
	if wishingCharmItems.empty?
		return "No approved items available."
	 else
		random_item = wishingCharmItems.sample
		pbReceiveItem(random_item)
	 end
end

	# Call for auto population of the list.
def wishingCharmAutoPop
	pool = []
	autoUseBlacklist = ::CharmCaseSettings::AUTO_USE_BLACKLIST
	blacklist = ::CharmCaseSettings::AUTO_GEN_BLACKLIST
	noLegendary = ::CharmCaseSettings::NO_LEGENDARY_AUTO
	wishingCharmLevel = ::CharmCaseSettings::WISHING_CHARM_PKMN_LEVEL
 #----Generate pool of possible Pokemon, no starters(blacklist), no legendaries---#(by default)
		GameData::Species.each do |species|
			species_id = species.id.to_sym
			# Will remove Legendary if setting is true
			if noLegendary
				next if species.egg_groups.include?(:Undiscovered)
			end
			# Will remove Blacklisted Pokemon if setting is true
			if autoUseBlacklist
				next if blacklist.include?(species_id)
			end
			next unless species
			pool.push(species)
			end
		 # Generate an Pokemon from the pool
		pkmn = pool.sample
		pbAddPokemon(pkmn, wishingCharmLevel)
end
	
# Generate pokemon from an approved list (settings file)	
def wishingCharmApprovedList
	wishingCharmLevel 		 = ::CharmCaseSettings::WISHING_CHARM_PKMN_LEVEL
	wishingCharmApprovedList = ::CharmCaseSettings::WISHING_CHARM_APPROVED_LIST
	pool = []
	 # Generate a pool of approved Pokémon
	wishingCharmApprovedList.each do |species_id|
		species = GameData::Species.get(species_id)
		pool.push(species)
		end

	# Check if the approved list is not empty
	if pool.empty?
		Kernel.pbMessage("No approved Pokémon found.")
		return
	end

	pkmn = pool.sample
	pbAddPokemon(pkmn, wishingCharmLevel)
end
		
#==============================================================================#
# ============================ Item Finder Charm ============================= #
#==============================================================================#	


#==============================================================================#
# =========================== Type Mastery Charm ============================= #
#==============================================================================#	


#==============================================================================#
# ========================= Purify Charm / Corrupt Charm ===================== #
#==============================================================================#
# Purify Charm will lessen the time it takes to Purify a Shadow Pokemon.
class Pokemon
  def change_heart_gauge(method, multiplier = 1)
    return if $player.activeCharm?(:CORRUPTCHARM)
    return if !shadowPokemon?
    heart_amounts = {
      # [sending into battle, call to, walking 256 steps, using scent]
      :HARDY   => [110, 300, 100,  90],
      :LONELY  => [ 70, 330, 100, 130],
      :BRAVE   => [130, 270,  90,  80],
      :ADAMANT => [110, 270, 110,  80],
      :NAUGHTY => [120, 270, 110,  70],
      :BOLD    => [110, 270,  90, 100],
      :DOCILE  => [100, 360,  80, 120],
      :RELAXED => [ 90, 270, 110, 100],
      :IMPISH  => [120, 300, 100,  80],
      :LAX     => [100, 270,  90, 110],
      :TIMID   => [ 70, 330, 110, 120],
      :HASTY   => [130, 300,  70, 100],
      :SERIOUS => [100, 330, 110,  90],
      :JOLLY   => [120, 300,  90,  90],
      :NAIVE   => [100, 300, 120,  80],
      :MODEST  => [ 70, 300, 120, 110],
      :MILD    => [ 80, 270, 100, 120],
      :QUIET   => [100, 300, 100, 100],
      :BASHFUL => [ 80, 300,  90, 130],
      :RASH    => [ 90, 300,  90, 120],
      :CALM    => [ 80, 300, 110, 110],
      :GENTLE  => [ 70, 300, 130, 100],
      :SASSY   => [130, 240, 100,  70],
      :CAREFUL => [ 90, 300, 100, 110],
      :QUIRKY  => [130, 270,  80,  90]
    }
    amt = 100
    case method
    when "battle"
      amt = (heart_amounts[@nature]) ? heart_amounts[@nature][0] : 100
    when "call"
      amt = (heart_amounts[@nature]) ? heart_amounts[@nature][1] : 300
    when "walking"
      amt = (heart_amounts[@nature]) ? heart_amounts[@nature][2] : 100
    when "scent"
      amt = (heart_amounts[@nature]) ? heart_amounts[@nature][3] : 100
      amt *= multiplier
    else
      raise _INTL("Unknown heart gauge-changing method: {1}", method.to_s)
    end
    amt *= 1.5 if $player.activeCharm?(:PURIFYCHARM)
    adjustHeart(-amt)
  end
end

#==============================================================================#
# ============================== Corrupt Charm =============================== #
#==============================================================================#
# Corrupt Charm will turn every Pokemon you capture while the Charm is active
# into Shadow Pokemon.
def pbCorruptCharm(amt)
  $player.able_party.each do |pkmn|
    next if pkmn.shadowPokemon?
    pkmn.makeShadow if rand(100) <= 20
  end
end

EventHandlers.add(:on_player_step_taken, :corrupt_charm,
  proc {
    pbCorruptCharm if $player.activeCharm?(:CORRUPTCHARM)
  }
)

module Battle::CatchAndStoreMixin
  #=============================================================================
  # Throw a Poké Ball
  #=============================================================================
  def pbThrowPokeBall(idxBattler, ball, catch_rate = nil, showPlayer = false)
    # Determine which Pokémon you're throwing the Poké Ball at
    battler = nil
    if opposes?(idxBattler)
      battler = @battlers[idxBattler]
    else
      battler = @battlers[idxBattler].pbDirectOpposing(true)
    end
    battler = battler.allAllies[0] if battler.fainted?
    # Messages
    itemName = GameData::Item.get(ball).name
    if battler.fainted?
      if itemName.starts_with_vowel?
        pbDisplay(_INTL("{1} threw an {2}!", pbPlayer.name, itemName))
      else
        pbDisplay(_INTL("{1} threw a {2}!", pbPlayer.name, itemName))
      end
      pbDisplay(_INTL("But there was no target..."))
      return
    end
    if itemName.starts_with_vowel?
      pbDisplayBrief(_INTL("{1} threw an {2}!", pbPlayer.name, itemName))
    else
      pbDisplayBrief(_INTL("{1} threw a {2}!", pbPlayer.name, itemName))
    end
    # Animation of opposing trainer blocking Poké Balls (unless it's a Snag Ball
    # at a Shadow Pokémon)
    if trainerBattle? && !(GameData::Item.get(ball).is_snag_ball? && battler.shadowPokemon?)
      @scene.pbThrowAndDeflect(ball, 1)
      pbDisplay(_INTL("The Trainer blocked your Poké Ball! Don't be a thief!"))
      return
    end
    # Calculate the number of shakes (4=capture)
    pkmn = battler.pokemon
    @criticalCapture = false
    numShakes = pbCaptureCalc(pkmn, battler, catch_rate, ball)
    PBDebug.log("[Threw Poké Ball] #{itemName}, #{numShakes} shakes (4=capture)")
    # Animation of Ball throw, absorb, shake and capture/burst out
    @scene.pbThrow(ball, numShakes, @criticalCapture, battler.index, showPlayer)
    # Outcome message
    case numShakes
    when 0
      pbDisplay(_INTL("Oh no! The Pokémon broke free!"))
      Battle::PokeBallEffects.onFailCatch(ball, self, battler)
    when 1
      pbDisplay(_INTL("Aww! It appeared to be caught!"))
      Battle::PokeBallEffects.onFailCatch(ball, self, battler)
    when 2
      pbDisplay(_INTL("Aargh! Almost had it!"))
      Battle::PokeBallEffects.onFailCatch(ball, self, battler)
    when 3
      pbDisplay(_INTL("Gah! It was so close, too!"))
      Battle::PokeBallEffects.onFailCatch(ball, self, battler)
    when 4
      pbDisplayBrief(_INTL("Gotcha! {1} was caught!", pkmn.name))
      @scene.pbThrowSuccess   # Play capture success jingle
      pbRemoveFromParty(battler.index, battler.pokemonIndex)
      # Gain Exp
      if Settings::GAIN_EXP_FOR_CAPTURE
        battler.captured = true
        pbGainExp
        battler.captured = false
      end
      battler.pbReset
      if pbAllFainted?(battler.index)
        @decision = (trainerBattle?) ? 1 : 4   # Battle ended by win/capture
      end
      # Modify the Pokémon's properties because of the capture
      if GameData::Item.get(ball).is_snag_ball?
        pkmn.owner = Pokemon::Owner.new_from_trainer(pbPlayer)
      end
      # Add to the shiny pokemon owned counter
      if pkmn.shiny?
        $game_variables[32] += 1
      end
      Battle::PokeBallEffects.onCatch(ball, self, pkmn)
      pkmn.poke_ball = ball
      pkmn.makeUnmega if pkmn.mega?
      pkmn.makeUnprimal
      pkmn.makeShadow if $player.activeCharm?(:CORRUPTCHARM)
      pkmn.update_shadow_moves if pkmn.shadowPokemon?
      pkmn.record_first_moves
      # Reset form
      pkmn.forced_form = nil if MultipleForms.hasFunction?(pkmn.species, "getForm")
      @peer.pbOnLeavingBattle(self, pkmn, true, true)
      # Make the Poké Ball and data box disappear
      @scene.pbHideCaptureBall(idxBattler)
      # Save the Pokémon for storage at the end of battle
      @caughtPokemon.push(pkmn)
    end
    if numShakes != 4
      @first_poke_ball = ball if !@poke_ball_failed
      @poke_ball_failed = true
    end
  end
end

#==============================================================================#
# ============================== Disable Charm =============================== #
#==============================================================================#
# 30% chance to disable Foe's last used Pokemon.
class Battle::Battler
alias charm_pbEffectsOnMakingHit pbEffectsOnMakingHit
	def pbEffectsOnMakingHit(move, user, target)
	  charm_pbEffectsOnMakingHit(move, user, target)
		   if activeCharm?(:DISABLECHARM) && !user.pbOwnedByPlayer?
			   if user.fainted? || user.effects[PBEffects::Disable] > 0
			   else
				regularMove = nil
				user.eachMove do |m|
				  next if m.id != user.lastRegularMoveUsed
				  regularMove = m
				  break
				  end
					if !regularMove || (regularMove.pp == 0 && regularMove.total_pp > 0) || battle.pbRandom(100) >= 30
					else
						if !move.pbMoveFailedAromaVeil?(target, user, Battle::Scene::USE_ABILITY_SPLASH)
						  user.effects[PBEffects::Disable]     = 3
						  user.effects[PBEffects::DisableMove] = regularMove.id
						  battle.pbDisplay(_INTL("{1}'s {2} was disabled by the Disable Charm!", user.pbThis, regularMove.name))
						  user.pbItemStatusCureCheck
						end
					end
				end
			end
	end
end

#==============================================================================#
# ================================ STAB Charm ================================ #
#==============================================================================#
# Adds 25% more damage to STAB Bonus.
class Battle::Move
	alias charm_pbCalcDamageMultipliers pbCalcDamageMultipliers
	def pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
	  charm_pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
		if type && user.pbHasType?(type) && activeCharm?(:STABCHARM) && user.pbOwnedByPlayer?
			multipliers[:final_damage_multiplier] *= 1.25
		end
	end
end

#===============================================================================
# * Easy Charm / Hard Charm
#===============================================================================

EventHandlers.add(:on_wild_pokemon_created, :difficulty_charms,
  proc { |pokemon|
    extra_level = 0
	extra_level = if $player.activeCharm?(:EASYCHARM)
					CharmCaseSettings::EASY_LEVEL
				  elsif $player.activeCharm?(:HARDCHARM)
					CharmCaseSettings::HARD_LEVEL
				  else
					0
				  end
    level = pokemon.level
    level += extra_level
    level = level.clamp(1, GameData::GrowthRate.max_level)
    pokemon.level = level
    pokemon.calc_stats
  }
)

EventHandlers.add(:on_trainer_load, :easy_hard_charms,
  proc { |trainer|
    extra_level = 0
	extra_level = if $player.activeCharm?(:EASYCHARM)
					CharmCaseSettings::EASY_LEVEL
				  elsif $player.activeCharm?(:HARDCHARM)
					CharmCaseSettings::HARD_LEVEL
				  else
					0
				  end
    if trainer
      for pokemon in trainer.party do
        level = pokemon.level
        level += extra_level
        level = level.clamp(1, GameData::GrowthRate.max_level)
        pokemon.level = level
        pokemon.calc_stats
      end
    end
    if CharmCaseSettings::EXTRA_POKEMON && !$player.activeCharm?(:HARDCHARM)
      position = trainer.party.length - 1 - CharmCaseSettings::POKEMON_POSITION
      trainer.remove_pokemon_at_index(position)
    end
  }
)