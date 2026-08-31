#===============================================================================
# Hit Calculations and Damage
#===============================================================================
class Game_Character

def at_coordinate_or_beside?(event, check_x, check_y)
  case event.direction
  when 2, 8   # Down or Up
    return (check_x >= @x - 1 && check_x <= @x + 1) &&
           (check_y == @y)
  when 4, 6   # Left or Right
    return (check_x == @x) &&
           (check_y >= @y - 1 && check_y <= @y + 1)
  else
    return false
  end
end


end
class Game_Map

  def check_event_and_adjacents(attacker, x, y)
     eventslist = self.events.dup
	 eventslist[$game_player] = $game_player
    eventslist.each_value do |event|
	   if event.at_coordinate?(x, y)
      return $game_player if event == $game_player
      return event.id if event != $game_player
	  end
    end
  end


  def check_event_and_adjacents2(attacker, target)
     eventslist = []
	 eventslist << $game_player
	 eventslist = eventslist + self.events.values
    eventslist.each do |event|
	   if event.at_coordinate_or_beside?(attacker, event.x, event.y)
      return true if event == target && event==$game_player
      return true if event == target
	  end
    end
   return false
  end
end
class OverworldCombat 



def who_am_i_hitting(attacker,target=nil,immune=nil)
  amt = OverworldCombat.sight_line(attacker)
  start_coord,landing_coord = getLandingCoords(amt,attacker)
  startx = start_coord[0]
  starty = start_coord[1]
    event = nil
	targets = who_am_i_hitting2(attacker)
	
	
	
    return false if attacker.is_a?(Game_PokeEvent) && attacker.battle_timer>0




	 targets.dup.each_with_index do |atarget, index|
	  if atarget.pokemon.iframes>0
	    targets.delete_at(index)
	  end
	  if immune==atarget
	    targets.delete_at(index)
	  end
	 end
	 
	 
	 
	 
	 
    return targets if targets.length>0
	return false
  
end





def who_am_i_hitting2(attacker)
    targets = [] 
  amt = OverworldCombat.sight_line(attacker)
  start_coord,landing_coord = getLandingCoords(amt,attacker)
  startx = start_coord[0]
  starty = start_coord[1]

  amt.times do |i|
    break if attacker.is_a?(Game_PokeEvent) && attacker.battle_timer>0 
    number = i+1
    case attacker.direction
     when 2
	   id = $game_map.check_event_and_adjacents(attacker, startx, starty+number)
	    if id.is_a? Integer
		  if $game_map.events[id] && ($game_map.events[id].is_a?(Game_PokeEvent) || $game_map.events[id].is_a?(Game_PokeEventA))
            targets << $game_map.events[id]
		  end
		elsif id == $game_player
            targets << $game_player
		end
     when 4
	   id = $game_map.check_event_and_adjacents(attacker, startx-number,starty)
	    if id.is_a? Integer
		  if $game_map.events[id] && ($game_map.events[id].is_a?(Game_PokeEvent) || $game_map.events[id].is_a?(Game_PokeEventA))
            targets << $game_map.events[id]
		  end
		elsif id == $game_player
            targets << $game_player
		end
     when 6
	   id = $game_map.check_event_and_adjacents(attacker, startx+number,starty)
	    if id.is_a? Integer
		  if $game_map.events[id] && ($game_map.events[id].is_a?(Game_PokeEvent) || $game_map.events[id].is_a?(Game_PokeEventA))
            targets << $game_map.events[id]
		  end
		elsif id == $game_player
            targets << $game_player
		end
      when 8
	   id = $game_map.check_event_and_adjacents(attacker, startx,starty-number)
	    if id.is_a? Integer
		  if $game_map.events[id] && ($game_map.events[id].is_a?(Game_PokeEvent) || $game_map.events[id].is_a?(Game_PokeEventA))
            targets << $game_map.events[id]
		  end
		elsif id == $game_player
            targets << $game_player
		end
  end


  end
 return targets


end





def who_around_me_is_a_target(attacker)
    targets = [] 
  amt = OverworldCombat.sight_line(attacker)
  start_coord,landing_coord = getLandingCoords(amt,attacker)
  startx = start_coord[0]
  starty = start_coord[1]
  amt.times do |i|
    number = i+1
	
    break if attacker.is_a?(Game_PokeEvent) && attacker.battle_timer>0 

	   id = $game_map.check_event_and_adjacents(attacker, startx,starty+number)
	    if id.is_a? Integer
		  if $game_map.events[id] && ($game_map.events[id].is_a?(Game_PokeEvent) || $game_map.events[id].is_a?(Game_PokeEventA))
            targets << $game_map.events[id]
		  end
		elsif id == $game_player
            targets << $game_player
		end
       id = nil
	   id = $game_map.check_event_and_adjacents(attacker, startx-number,starty)
	    if id.is_a? Integer
		  if $game_map.events[id] && ($game_map.events[id].is_a?(Game_PokeEvent) || $game_map.events[id].is_a?(Game_PokeEventA))
            targets << $game_map.events[id]
		  end
		elsif id == $game_player
            targets << $game_player
		end
       id = nil
	   id = $game_map.check_event_and_adjacents(attacker, startx+number,starty)
	    if id.is_a? Integer
		  if $game_map.events[id] && ($game_map.events[id].is_a?(Game_PokeEvent) || $game_map.events[id].is_a?(Game_PokeEventA))
            targets << $game_map.events[id]
		  end
		elsif id == $game_player
            targets << $game_player
		end
       id = nil
	   id = $game_map.check_event_and_adjacents(attacker, startx,starty-number)
	    if id.is_a? Integer
		  if $game_map.events[id] && ($game_map.events[id].is_a?(Game_PokeEvent) || $game_map.events[id].is_a?(Game_PokeEventA))
            targets << $game_map.events[id]
		  end
		elsif id == $game_player
            targets << $game_player
		end
       id = nil


  end
  if !targets.any? { |obj| (obj.is_a?(Game_Player) || obj.is_a?(Game_PokeEventA))} && !targets.any? { |obj| (attacker.angry_at.include?(obj))} 
    targets = []
  end
  return targets
	 


end

def pbShouldAttack?(attacker,target)
  return false if attacker.pokemon.fainted?
  return false if attacker.pokemon.status == :SLEEP
  return false if attacker.pokemon.status == :PARALYSIS
  return false if attacker.pokemon.status == :FROZEN
  potato2 = true
  amt = rand(60)
  potato2 = amt<getRate1(attacker,target)
  return potato2

end

def changeTarget(attacker,target)
thetargets = []
distances = []
distances << 0


get_player_and_allies.each do |event|
 next if event==target
 thetargets << event
 distances << pbDetectTargetPokemon(attacker,event)
end

minimum = distances.min
max_index = distances.index(minimum)


target = get_player_and_allies[max_index]
distance = distances[max_index]
	 
	



 return target,distance
end



  def getAttackStats(user,target, move)
  user.stages = {} if user.stages.nil?
    if move.category == 1 
      return user.spatk, user.stages[:SPECIAL_ATTACK].to_i + 6
    end
    return user.attack, user.stages[:ATTACK].to_i + 6

  end



def outSpeeds?(attacker,target, move)
  unless target == $game_player
   return true if !defined?(target.pokemon)
   return true if !defined?(attacker.pokemon)
   return true if !defined?(attacker.pokemon.speed)
  end
  targetspeed = target.pokemon.speed
  targetspeed = (target.pokemon.speed*1.8).to_i if target == $game_player && is_assassin?
  attackerspeed = attacker.pokemon.speed + move.accuracy
  targetspeed -= rand((target.pokemon.speed/2).to_i)
  #puts "#{attacker.pokemon.name} is outsped by #{target.pokemon.name}? #{targetspeed>=attackerspeed}"
  return true if targetspeed>=attackerspeed
  return false
end


def getDefenseStats(user,target, move)
   if target.is_a?(Pokemon)
  target.stages = {} if target.stages.nil?
    if move.category == 1 
      return target.spdef, target.stages[:SPECIAL_DEFENSE].to_i + 6
    end
    return target.defense, target.stages[:DEFENSE].to_i + 6
	else
	 return $player.equipmentdefbuff, 0
	end
end

def getDefenseStatsforplayer(target)
   if target.is_a?(Pokemon)
  target.stages = {} if target.stages.nil?
    return target.defense, target.stages[:DEFENSE].to_i + 6
	end
end



def get_the_multipliers(mult, user, target, move, effects)
 
		 mult[:final_damage_multiplier] *= 1
		 if pbThisHasType?(user,move.type)
		   if user.hasAbility?(:ADAPTABILITY)
		     mult[:final_damage_multiplier] *= 2
		   else
		     mult[:final_damage_multiplier] *= 1.5 
		   end 
		 end
		 mult[:final_damage_multiplier] *= 1.5 if is_a_crit?(user, target, move, effects)
		 return mult
end

def inflictStatus(move, user, target, newStatus, newStatusCount = 0, sound = true, msg = nil)
    return {} if target.nil?
    return {} if target.status != :NONE 
	     target.status_turns=newStatusCount
         target.status=newStatus
    if msg && !msg.empty?
      sideDisplay(msg)
    else
      case newStatus
      when :SLEEP
	      sideDisplay("#{target.name} fell asleep!")
      when :POISON
        if newStatusCount > 0
	       sideDisplay("#{target.name} was poisoned!")
        else
	       sideDisplay("#{target.name} was badly poisoned!")
        end
      when :BURN
        sideDisplay(_INTL("#{target.name} was burned!"))
      when :PARALYSIS
	      sideDisplay("#{target.name} is paralyzed!")
      when :FROZEN
        sideDisplay(_INTL("#{target.name} was frozen solid! It won't be able to move!"))
      end
    end
    anim_name = GameData::Status.get(newStatus).animation if sound==true
    sound_from_animation(anim_name, target) if anim_name
	pbSEPlay("FollowEmote_Poison") if newStatus==:POISON
	return {} 
end


  def lower_that_power_based_on_hp(user)
    ret = 20
    n = 48 * user.hp / user.totalhp
    if n < 2
      ret = 200
    elsif n < 5
      ret = 150
    elsif n < 10
      ret = 100
    elsif n < 17
      ret = 80
    elsif n < 33
      ret = 40
    end
    return ret
  end
  
  def pbConfuse(pkmn,msg = nil)
    pkmn.effects[PBEffects::Confusion] = pbConfusionDuration
    msg = _INTL("{1} became confused!", pkmn.name) if nil_or_empty?(msg)
    sideDisplay(msg)
    # Confusion cures
    #pbItemStatusCureCheck
    #pbAbilityStatusCureCheck
  end


  def pbItemStatusCureCheck(pkmn, item_to_use = nil, fling = false)
    return if fainted?
    return if !item_to_use && !itemActive?
   # itm = item_to_use || self.item
    #if Battle::ItemEffects.triggerStatusCure(itm, pkmn, nil, !item_to_use.nil?)
   #   pbHeldItemTriggered(itm, item_to_use.nil?, fling)
   # end
  end

  def pbAbilityStatusCureCheck
    if abilityActive?
      Battle::AbilityEffects.triggerStatusCure(self.ability, self)
    end
  end

  def pbConfusionDuration(duration = -1)
    duration = Graphics.frame_rate * 3 + rand(Graphics.frame_rate * 3) if duration <= 0
    return duration
  end
  
  
  def is_a_crit?(user, target, move, effects)
    c = 0
    return false if c<0
	case effects[:critical]
	when 1 then return true
	when -1 then return false
	end
    return true if c > 50   # Merciless
    return true if user.effects[PBEffects::LaserFocus] > 0
    c += 1 if move.flags.include?("HighCriticalHitRate")
    c += user.effects[PBEffects::FocusEnergy]
    c += 4 if user.shadowPokemon?
    c += 2 if user.inHyperMode? 
    c += 3 if user.purifiedPokemon?
    
    ratios = Battle::Move::CRITICAL_HIT_RATIOS
    c = ratios.length - 1 if c >= ratios.length
    return true if ratios[c] == 1
    r = rand(ratios[c])
	return true if r == 0
	return true if r == 1 && user.happiness >=240
	return false 
  end 


  
  def get_base_damage(user, move, effects)
    baseDmg = move.base_damage
    baseDmg = effects[:new_base_damage] if effects[:new_base_damage]
    return baseDmg
  end
  
  
def getDamager(event,target,move,multiplier=0)
	effects = OverworldCombat::MoveAttributes.apply({
	 move: move,
     user_event: event,
     target_event: target,
     target: target.pokemon,
     user: event.pokemon,
	})
  #pbCalcDamage
	 baseDmg = get_base_damage(event.pokemon, move, effects)
     #puts "#{event.pokemon.name} used #{move.name} - #{move.category}! (Accuracy: #{move.accuracy}, Base Power: #{baseDmg})"
     atk, atkStage = getAttackStats(event.pokemon, target.pokemon, move)
    defense, defStage = getDefenseStats(event.pokemon, target.pokemon, move)
    multipliers = {
      :base_damage_multiplier  => 1.0,
      :attack_multiplier       => 1.0,
      :defense_multiplier      => 1.0,
      :final_damage_multiplier => 1.0
    }
	multipliers = get_the_multipliers(multipliers, event.pokemon, target.pokemon, move, effects)
	#value = Effectiveness.calculate(move.type, *target.pokemon.types)
	multipliers[:final_damage_multiplier] *= OverworldCombat::Moves.type_mod(move.type, event.pokemon, target.pokemon)&.to_f / Effectiveness::NORMAL_EFFECTIVE
    # pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
    # Main damage calculation
    baseDmg = [(baseDmg * multipliers[:base_damage_multiplier]).round, 1].max
    atk     = [(atk     * multipliers[:attack_multiplier]).round, 1].max
    defense = [(defense * multipliers[:defense_multiplier]).round, 1].max
    damage  = ((((2.0 * event.pokemon.level / 5) + 2).floor * baseDmg).floor / 50).floor + 2
    damage  = [(damage * multipliers[:final_damage_multiplier]).round, 1].max
	damage += (multiplier*5)
	result = damage.floor
	result = effects[:fixed_damage] if effects[:fixed_damage]
     return result
end



def getRate(event,target)
         rate=15
		 if defined?(target.pokemon.types)
	  event.pokemon.types.each do |i|
		 value = Effectiveness.calculate(i, *target.pokemon.types)
         rate*=2 if Effectiveness.super_effective?(value)
         rate/=2 if Effectiveness.not_very_effective?(value)
	   end
	    end
	  rate+=10 if event.pokemon.is_aggressive?
		 
		 
		 
		 
	   if target == $game_player
      rate+=5 if $player.playerstamina <= 75 && $player.playerstamina > 50
      rate+=10 if $player.playerstamina <= 50 && $player.playerstamina > 25
      rate+=20 if $player.playerstamina <= 25
      rate+=20 if $player.playerhealth <= 25
      rate+=10 if $player.playerhealth <= 50 && $player.playerhealth > 25
      rate+=5 if $player.playerhealth <= 75 && $player.playerhealth > 50
       end



	  return rate
end
def getRate1(event,target)
         rate=35
		 if defined?(target.pokemon.types)
	  event.pokemon.types.each do |i|
		 value = Effectiveness.calculate(i, *target.pokemon.types)
         rate*=2 if Effectiveness.super_effective?(value)
         rate/=2 if Effectiveness.not_very_effective?(value)
	   end
	    end
	  rate+=10 if event.pokemon.is_aggressive?
		 
		 
		 
		 
	   if target == $game_player
      rate+=5 if $player.playerstamina <= 75 && $player.playerstamina > 50
      rate+=10 if $player.playerstamina <= 50 && $player.playerstamina > 25
      rate+=20 if $player.playerstamina <= 25
      rate+=20 if $player.playerhealth <= 25
      rate+=10 if $player.playerhealth <= 50 && $player.playerhealth > 25
      rate+=5 if $player.playerhealth <= 75 && $player.playerhealth > 50
       end



	  return rate
end

def getRate2(event,target)
         rate=35
	if defined?(target.pokemon.types)
	  event.pokemon.types.each do |i|
		value = Effectiveness.calculate(i, *target.pokemon.types)
       rate*=2 if Effectiveness.super_effective?(value)
       rate/=2 if Effectiveness.not_very_effective?(value)
	   end
	end
	if defined?(target.pokemon.is_aggressive?)
	  rate+=10 if target.pokemon.is_aggressive?
	end
		 rate+=rand(10)+1
		 




	  return rate
end


  
  def status_checks(event)
    return nil if !defined?(event.pokemon)
    pkmn = event.pokemon
  	if pkmn.status_turns.nil?
		 pkmn.status_turns=0
	end
	pkmn.status_turns-=1 if pkmn.status_turns>0
	if pkmn.status_turns==0 && pkmn.status!=:NONE
	 pkmn.status=:NONE
	 if event.movement_type==:IMMOBILE
	   makeAggressive(event)
	 end
	end
	  return OverworldCombat.fainted_check(event)
  end  


end
