


class Game_Player < Game_Character
  
    def can_run?
    return @move_speed > 3 if @move_route_forcing
    return false if $game_temp.in_menu || $game_temp.in_battle ||
                    $game_temp.message_window_showing || pbMapInterpreterRunning? || $player.playerstamina==0
    return false if (!$player.has_running_shoes && ($player.playershoes == :NORMALSHOES || $player.playershoes == :SEASHOES))&& !$PokemonGlobal.diving &&
                    !$PokemonGlobal.surfing && !$PokemonGlobal.bicycle
    return false if jumping?
    return false if $PokemonGlobal.partner
    return false if pbTerrainTag.must_walk
    return Input.press?(Input::RUNNING)
  end
  def set_movement_type(type)
    meta = GameData::PlayerMetadata.get($player&.character_ID || 1)
    new_charset = nil
    case type
    when :fishing
      new_charset = pbGetPlayerCharset(meta.fish_charset)
    when :surf_fishing
      new_charset = pbGetPlayerCharset(meta.surf_fish_charset)
    when :diving, :diving_fast, :diving_jumping, :diving_stopped
      self.move_speed = 3 if !@move_route_forcing
      new_charset = pbGetPlayerCharset(meta.dive_charset)
    when :surfing, :surfing_fast, :surfing_jumping, :surfing_stopped
      if !@move_route_forcing
        self.move_speed = (type == :surfing_jumping) ? 3 : 4
      end
      new_charset = pbGetPlayerCharset(meta.surf_charset)
    when :cycling, :cycling_fast, :cycling_jumping, :cycling_stopped
      if !@move_route_forcing
        self.move_speed = (type == :cycling_jumping) ? 3 : 5
      end
      new_charset = pbGetPlayerCharset(meta.cycle_charset)
    when :running
      self.move_speed = 4.25 if !@move_route_forcing && $player.has_running_shoes
      self.move_speed = 3.75 if !@move_route_forcing && $player.playershoes == :MAKESHIFTRUNNINGSHOES
      self.move_speed = 4.25 if !@move_route_forcing && $player.playershoes == :RUNNINGSHOES
      new_charset = pbGetPlayerCharset(meta.run_charset)
    when :ice_sliding
      self.move_speed = 4 if !@move_route_forcing
      new_charset = pbGetPlayerCharset(meta.walk_charset)
    else   # :walking, :jumping, :walking_stopped
      self.move_speed = 3 if !@move_route_forcing
      new_charset = pbGetPlayerCharset(meta.walk_charset)
    end
    @character_name = new_charset if new_charset
  end

end



class Player < Trainer

  attr_reader :held_item
  attr_reader :held_item_object
  attr_reader :equipped_item
  def held_item=(value)
    @held_item = value
  end
  def held_item_object=(value)
    @held_item_object = value
  end
     alias _SI2_Player_Init initialize
  def initialize(name, trainer_type)
    _SI2_Player_Init(name, trainer_type)
    @held_item           = nil
    @held_item_object = nil
    @equipped_item = nil
  end

    def hold(item)
    if !@held_item
        @held_item=item
	  if !pbSeenTipCard?(:OVERWORLDITEMS)
	    pbShowTipCard(:OVERWORLDITEMS)
	  end
        pbHoldingObject($game_player.x,$game_player.y-1,item,true)
		return true
	end
    return false
    end
    
    def equip(item)
    @equipped_item = item
	end
    def unequip
    @equipped_item = nil
	end

    def place(x,y)
    if !@held_item.nil?
	    item = @held_item
		key_id = @held_item_object
		direction = $game_map.events[key_id].direction
		if pbPlaceObject(x,y,item,false,direction)
		if !$map_factory
           $game_map.removeThisEventfromMap(key_id)
        else
           mapId = $game_map.map_id
           $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
        end
		deletefromSIData(key_id)
        @held_item=nil
		@held_item_object=nil
           return true
	    else
           return false
	    end
    else
      return false
    end
    end


end

class Game_Character
  def move_through2(direction)
    old_through = @through
    @through = true
    case direction
    when 2 then move_down
    when 4 then move_left
    when 6 then move_right
    when 8 then move_up
    end
    @through = old_through
  end
  def fancy_moveto2(new_x, new_y, leader)
    if self.x - new_x == 1 && self.y == new_y
      move_fancy2(4)
    elsif self.x - new_x == -1 && self.y == new_y
      move_fancy2(6)
    elsif self.x == new_x && self.y - new_y == 1
      move_fancy2(8)
    elsif self.x == new_x && self.y - new_y == -1
      move_fancy2(2)
    elsif self.x - new_x == 2 && self.y == new_y
      jump_fancy2(4, leader)
    elsif self.x - new_x == -2 && self.y == new_y
      jump_fancy2(6, leader)
    elsif self.x == new_x && self.y - new_y == 2
      jump_fancy2(8, leader)
    elsif self.x == new_x && self.y - new_y == -2
      jump_fancy2(2, leader)
    elsif self.x != new_x || self.y != new_y
      moveto(new_x, new_y)
    end
  end
  def move_fancy2(direction)
    delta_x = (direction == 6) ? 1 : (direction == 4) ? -1 : 0
    delta_y = (direction == 2) ? 1 : (direction == 8) ? -1 : 0
    new_x = self.x + delta_x
    new_y = self.y + delta_y
    # Move if new position is the player's, or the new position is passable,
    # or self's current position is not passable
    if ($game_player.x == new_x && $game_player.y == new_y) ||
       location_passable2?(new_x, new_y, 10 - direction) ||
       !location_passable2?(self.x, self.y, direction)
      move_through2(direction)
    end
  end
    def jump_fancy2(direction, leader)
    delta_x = (direction == 6) ? 2 : (direction == 4) ? -2 : 0
    delta_y = (direction == 2) ? 2 : (direction == 8) ? -2 : 0
    half_delta_x = delta_x / 2
    half_delta_y = delta_y / 2
    if location_passable2?(self.x + half_delta_x, self.y + half_delta_y, 10 - direction)
      # Can walk over the middle tile normally; just take two steps
      move_fancy2(direction)
      move_fancy2(direction)
    elsif location_passable2?(self.x + delta_x, self.y + delta_y, 10 - direction)
      # Can't walk over the middle tile, but can walk over the end tile; jump over
      if location_passable2?(self.x, self.y, direction)
        if leader.jumping?
          @jump_speed_real = leader.jump_speed_real
        else
          # This is doubled because self has to jump 2 tiles in the time it
          # takes the leader to move one tile.
          @jump_speed_real = leader.move_speed_real * 2
        end
        jump(delta_x, delta_y)
      else
        # self's current tile isn't passable; just take two steps ignoring passability
        move_through2(direction)
        move_through2(direction)
      end
    end
  end

  def location_passable2?(x, y, direction)
    this_map = self.map
    return false if !this_map || !this_map.valid?(x, y)
    return true if @through
    passed_tile_checks = false
    bit = (1 << ((direction / 2) - 1)) & 0x0f
    # Check all events for ones using tiles as graphics, and see if they're passable
    this_map.events.each_value do |event|
      next if event.tile_id < 0 || event.through || !event.at_coordinate?(x, y)
      tile_data = GameData::TerrainTag.try_get(this_map.terrain_tags[event.tile_id])
      next if tile_data.ignore_passability
      next if tile_data.bridge && $PokemonGlobal.bridge == 0
      return false if tile_data.ledge
      passage = this_map.passages[event.tile_id] || 0
      return false if passage & bit != 0
      passed_tile_checks = true if (tile_data.bridge && $PokemonGlobal.bridge > 0) ||
                                   (this_map.priorities[event.tile_id] || -1) == 0
      break if passed_tile_checks
    end
    # Check if tiles at (x, y) allow passage for followe
    if !passed_tile_checks
      [2, 1, 0].each do |i|
        tile_id = this_map.data[x, y, i] || 0
        next if tile_id == 0
        tile_data = GameData::TerrainTag.try_get(this_map.terrain_tags[tile_id])
        next if tile_data.ignore_passability
        next if tile_data.bridge && $PokemonGlobal.bridge == 0
        return false if tile_data.ledge
        passage = this_map.passages[tile_id] || 0
        return false if passage & bit != 0
        break if tile_data.bridge && $PokemonGlobal.bridge > 0
        break if (this_map.priorities[tile_id] || -1) == 0
      end
    end
    # Check all events on the map to see if any are in the way
    this_map.events.each_value do |event|
      next if !event.at_coordinate?(x, y)
      return false if !event.through && event.character_name != ""
    end
    return true
  end
end

class Battle
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
            pbPlayerEXP(b.pokemon,true)
          end
        end
      end
      # Clear the participants array
      b.participants = []
    end
  end
end
  
  def pokemonEXP(participants,caughtmon,pkmn)
    growth_rate = pkmn.growth_rate
      return if pkmn.egg?
    expAll = $player.has_exp_all || $bag.has?(:EXPALL)
      numPartic = 0
      participants.each do |partic|
        next unless partic.able?
        numPartic += 1
      end
	
      expShare = []
      if !expAll
        $player.party.each_with_index do |pkmn, i|
          next if !pkmn.able?
          next if !pkmn.hasItem?(:EXPSHARE)
          expShare.push(i)
        end
      end
	
	
    # Don't bother calculating if gainer is already at max Exp
    if pkmn.exp >= growth_rate.maximum_exp
      pkmn.calc_stats   # To ensure new EVs still have an effect
      return
    end


    isPartic    = participants.include?(pkmn)
    hasExpShare = expShare.include?(pkmn)
    level = caughtmon.level
    # Main Exp calculation
    exp = 0
    a = level * caughtmon.base_exp
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
    elsif expAll   # Didn't participate in battle, gaining Exp due to Exp All
      # NOTE: Exp All works like the Exp Share from Gen 6+, not like the Exp All
      #       from Gen 1, i.e. Exp isn't split between all Pokémon gaining it.
      exp = a / 2
	 else
      exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? numPartic : 1)
    end
    return if exp <= 0
    # Scale the gained Exp based on the gainer's level (or not)
    if Settings::SCALED_EXP_FORMULA
      exp /= 5
      levelAdjust = ((2 * level) + 10.0) / (pkmn.level + level + 10.0)
      levelAdjust = levelAdjust**5
      levelAdjust = Math.sqrt(levelAdjust)
      exp *= levelAdjust
      exp = exp.floor
      exp += 1 if isPartic || hasExpShare
    else
      exp /= 7
    end
    # Foreign Pokémon gain more Exp
    isOutsider = (pkmn.owner.id != $player.id ||
                 (pkmn.owner.language != 0 && pkmn.owner.language != $player.language))
    if isOutsider
      if pkmn.owner.language != 0 && pkmn.owner.language != $player.language
        exp = (exp * 1.7).floor
      else
        exp = (exp * 1.5).floor
      end
    end
    # Exp. Charm increases Exp gained
    exp = exp * 3 / 2 if $bag.has?(:EXPCHARM)
    # Modify Exp gain based on pkmn's held item
    i = Battle::ItemEffects.triggerExpGainModifier(pkmn.item, pkmn, exp)
    if i < 0
      i = Battle::ItemEffects.triggerExpGainModifier(pkmn.item, pkmn, exp)
    end
    exp = i if i >= 0
    # Boost Exp gained with high affection
    if pkmn.happiness >= 240 && !pkmn.mega?
      exp = exp * 6 / 5
      isOutsider = true   # To show the "boosted Exp" message
    end
    # Make sure Exp doesn't exceed the maximum
    expFinal = growth_rate.add_exp(pkmn.exp, exp)
    expGained = expFinal - pkmn.exp
    return if expGained <= 0
    # "Exp gained" message
      if isOutsider
	     pbMessage("\\ts[]" + (_INTL"#{pkmn.name} got a boosted #{expGained} Exp. Points!\\wtnp[10]"))
      else
        pbMessage(_INTL("{1} got {2} Exp. Points!", pkmn.name, expGained))
      end
    curLevel = pkmn.level
    newLevel = growth_rate.level_from_exp(expFinal)
    if newLevel < curLevel
      debugInfo = "Levels: #{curLevel}->#{newLevel} | Exp: #{pkmn.exp}->#{expFinal} | gain: #{expGained}"
      raise _INTL("{1}'s new level is less than its\r\ncurrent level, which shouldn't happen.\r\n[Debug: {2}]",
                  pkmn.name, debugInfo)
    end
    # Give Exp
    if pkmn.shadowPokemon?
        pkmn.exp += expGained
        $stats.total_exp_gained += expGained
      if pkmn.level == 20 && pkmn.shadowPokemon?
       return
	    end
    end
    $stats.total_exp_gained += expGained
    tempExp1 = pkmn.exp
    loop do   # For each level gained in turn...
      # EXP Bar animation
      levelMinExp = growth_rate.minimum_exp_for_level(curLevel)
      levelMaxExp = growth_rate.minimum_exp_for_level(curLevel + 1)
      tempExp2 = (levelMaxExp < expFinal) ? levelMaxExp : expFinal
      pkmn.exp = tempExp2
      tempExp1 = tempExp2
      curLevel += 1
      if curLevel > newLevel
        # Gained all the Exp now, end the animation
        pkmn.calc_stats
        break
      end
      oldTotalHP = pkmn.totalhp
      oldAttack  = pkmn.attack
      oldDefense = pkmn.defense
      oldSpAtk   = pkmn.spatk
      oldSpDef   = pkmn.spdef
      oldSpeed   = pkmn.speed
        pkmn.changeHappiness("levelup",pkmn)
        pkmn.changeLoyalty("levelup",pkmn)
      if pkmn.shadowPokemon?
         potato = pkmn.level
         if potato == 12
          if rand(100) <= 5
          pkmn.nature=:HATEFUL
          end
         elsif potato == 13
          if rand(100) <= 10
          pkmn.nature=:HATEFUL
          end
         elsif potato == 14
          if rand(100) <= 15
          pkmn.nature=:HATEFUL
          end
         elsif potato == 15
          if rand(100) <= 20
          pkmn.nature=:HATEFUL
          end
         elsif potato == 16
          if rand(100) <= 25
          pkmn.nature=:HATEFUL
          end
         elsif potato == 17
          if rand(100) <= 30
          pkmn.nature=:HATEFUL
          end
         elsif potato == 18
          if rand(100) <= 35
          pkmn.nature=:HATEFUL
          end
         elsif potato == 19
          if rand(100) <= 40
          pkmn.nature=:HATEFUL
          end
         elsif potato >= 20
          if rand(100) <= 50
          pkmn.nature=:HATEFUL
          end
         else
       end
      end
 
	 
      moveList = pkmn.getMoveList
      moveList.each { |m| pbLearnMove(pkmn, m[1]) if m[0] == curLevel }
      newspecies=pkmn.check_evolution_on_level_up
          if newspecies
            pbFadeOutInWithMusic(99999){
            evo=PokemonEvolutionScene.new
            evo.pbStartScreen(pkmn,newspecies)
            evo.pbEvolution
            evo.pbEndScreen
          }
        end
	   

 
  
  end
 end  
  def pbPlayerEXP(caughtmon,pkmnless=false)
    return false
    caughtmon_level=caughtmon.level
    pkmn = $player
      growth_rate = GameData::GrowthRate.get(:Slow)
	  if pkmn.exp.nil?
	    pkmn.exp=0
	  end
      # Don't bother calculating if gainer is already at max Exp
      #return if pkmn.exp>=100
      exp=(caughtmon_level*caughtmon.base_exp)/2
      # Scale the gained Exp based on the gainer's level (or not)
      # Make sure Exp doesn't exceed the maximum
       exp /= 7
       exp = exp * 3 / 2 if $bag.has?(:EXPCHARM)
      expFinal = growth_rate.add_exp(pkmn.exp, exp)
      expGained = expFinal-pkmn.exp
      return if expGained<=0
      curLevel = pkmn.playerclasslevel
      newLevel = growth_rate.level_from_exp(expFinal)
      tempExp1 = pkmn.exp
      loop do   # For each level gained in turn...
        # EXP Bar animation
        levelMaxExp = growth_rate.minimum_exp_for_level(curLevel + 1)
        tempExp2 = (levelMaxExp<expFinal) ? levelMaxExp : expFinal
        pkmn.exp = tempExp2
        tempExp1 = tempExp2
        curLevel += 1
		pbSEPlay("Pkmn exp gain")
        if curLevel>newLevel
          # Gained all the Exp now, end the animation
          break
        end
    end



     pbMessage("\\ts[]" + (_INTL"#{pkmn.name} leveled up to #{newLevel}!\\wtnp[10]"))
	 
	 
      pkmn.playerclasslevel=newLevel
	  
	  
	  
	  if pkmnless==false
	  exp = exp/4
	  $player.party.each do |pkmn|
	    next if pkmn.egg?
      expFinal = growth_rate.add_exp(pkmn.exp, exp)
      expGained = expFinal-pkmn.exp
      return if expGained<=0
      curLevel = pkmn.level
      newLevel = growth_rate.level_from_exp(expFinal)
      tempExp1 = pkmn.exp
      loop do   # For each level gained in turn...
        # EXP Bar animation
        levelMaxExp = growth_rate.minimum_exp_for_level(curLevel + 1)
        tempExp2 = (levelMaxExp<expFinal) ? levelMaxExp : expFinal
        pkmn.exp = tempExp2
        tempExp1 = tempExp2
        curLevel += 1
		pbSEPlay("Pkmn exp gain")
        if curLevel>newLevel
        pkmn.calc_stats
		 pbMessage("\\ts[]" + (_INTL"#{pkmn.name} leveled up to #{newLevel}!\\wtnp[10]"))
         break
        end
    end
      oldTotalHP = pkmn.totalhp
      oldAttack  = pkmn.attack
      oldDefense = pkmn.defense
      oldSpAtk   = pkmn.spatk
      oldSpDef   = pkmn.spdef
      oldSpeed   = pkmn.speed
        pkmn.changeHappiness("levelup",pkmn)
        pkmn.changeLoyalty("levelup",pkmn)
      if pkmn.shadowPokemon?
         potato = pkmn.level
         if potato == 12
          if rand(100) <= 5
          pkmn.nature=:HATEFUL
          end
         elsif potato == 13
          if rand(100) <= 10
          pkmn.nature=:HATEFUL
          end
         elsif potato == 14
          if rand(100) <= 15
          pkmn.nature=:HATEFUL
          end
         elsif potato == 15
          if rand(100) <= 20
          pkmn.nature=:HATEFUL
          end
         elsif potato == 16
          if rand(100) <= 25
          pkmn.nature=:HATEFUL
          end
         elsif potato == 17
          if rand(100) <= 30
          pkmn.nature=:HATEFUL
          end
         elsif potato == 18
          if rand(100) <= 35
          pkmn.nature=:HATEFUL
          end
         elsif potato == 19
          if rand(100) <= 40
          pkmn.nature=:HATEFUL
          end
         elsif potato >= 20
          if rand(100) <= 50
          pkmn.nature=:HATEFUL
          end
         else
       end
      end
 
	 
      moveList = pkmn.getMoveList
      moveList.each { |m| pbLearnMove(pkmn, m[1]) if m[0] == curLevel }
      newspecies=pkmn.check_evolution_on_level_up
          if newspecies
            pbFadeOutInWithMusic(99999){
            evo=PokemonEvolutionScene.new
            evo.pbStartScreen(pkmn,newspecies)
            evo.pbEvolution
            evo.pbEndScreen
          }
        end
	   
	  end
     end
  end

 
def pbMoveTowardEvent9(event,target)
  maxsize = [$game_map.width, $game_map.height].max
  return false if $game_temp.preventspawns==true
  return false if !pbEventCanReachPlayer?(event, target, maxsize)
  loop do
    x = event.x
    y = event.y
    event.move_toward_target(target)
    break if event.x == x && event.y == y
    while event.moving?
      Graphics.update
      Input.update
      pbUpdateSceneMap
    end
  end
  pbMoveRoute2(event, [PBMoveRoute::Wait, (Graphics.frame_rate*(rand(4)+1))])
  return true
end

class Game_Character
  def move_toward_target(target)
    sx = @x + (@width / 2.0) - (target.x + (target.width / 2.0))
    sy = @y - (@height / 2.0) - (target.y - (target.height / 2.0))
    return if sx == 0 && sy == 0
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      (rand(2) == 0) ? abs_sx += 1 : abs_sy += 1
    end
    if abs_sx > abs_sy
      (sx > 0) ? move_left : move_right
      if !moving? && sy != 0
        (sy > 0) ? move_up : move_down
      end
    else
      (sy > 0) ? move_up : move_down
      if !moving? && sx != 0
        (sx > 0) ? move_left : move_right
      end
    end
  end
end

def didMoveTowardsPlayer?(event)
pbMoveTowardPlayer9(event)
return true
end


def pbMoveTowardPlayer9(event)
  maxsize = [$game_map.width, $game_map.height].max
  return false if $game_temp.preventspawns==true
  return if !pbEventCanReachPlayer?(event, $game_player, maxsize)
  loop do
    x = event.x
    y = event.y
    event.move_toward_player
    break if event.x == x && event.y == y
    while event.moving?
      Graphics.update
      Input.update
      pbUpdateSceneMap
    end
  end
end




# Set up various data related to the new map
EventHandlers.add(:on_enter_map, :recreate_follower_event,
  proc { |old_map_id|   # previous map ID, is 0 if no map ID
    next if old_map_id == 0 || old_map_id == $game_map.map_id
    next if $game_temp.following_ov_pokemon==false
	         event_id = $game_temp.following_ov_pokemon[0]
		     next if event_id.nil?
		     theevent = $map_factory.getMap(old_map_id).events[event_id]
			 next if theevent.nil?
			 $game_map.recreateEvent2(theevent) if theevent.movement_type == :FOLLOW
			 pkmn.inworld=false if theevent.movement_type != :FOLLOW
			 theevent.removeThisEventfromMap



}
)

EventHandlers.add(:on_map_transfer, :recreate_follower_event,
  proc { |old_map_id|   # previous map ID, is 0 if no map ID
    next if old_map_id == 0 || old_map_id == $game_map.map_id
    next if $game_temp.following_ov_pokemon==false
	         event_id = $game_temp.following_ov_pokemon[0]
		     next if event_id.nil?
		     theevent = $game_temp.following_ov_pokemon[2]
			 next if theevent.nil?
			 $game_map.recreateEvent2(theevent) if theevent.movement_type == :FOLLOW
			 pkmn.inworld=false if theevent.movement_type != :FOLLOW
			 theevent.removeThisEventfromMap



}
)




