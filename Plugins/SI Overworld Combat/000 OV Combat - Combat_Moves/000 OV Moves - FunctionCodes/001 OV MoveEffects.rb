class OverworldCombat::MoveEffects
  def self.apply_primary(context)
    move   = context[:move]
	
    validate move => Pokemon::Move
	
    code = move.function_code || "None"
	
    if code[/^\d/]   # Begins with a digit
      function_code = sprintf("Effect%s", code)
    else
      function_code = sprintf("%s", code)
    end
	
    return if function_code.nil?


    if respond_to?(function_code, true)
      return self.send(function_code, context)
	else 
	  return self.unimplemented(function_code, context)
    end
  end
  
  def self.apply_secondary(context)
    move = context[:move]
  
    return if move.effect_chance <= 0
    return if rand(100) >= move.effect_chance

    code = move.function_code

    if respond_to?(code, true)
      send(code, context)
    end
  end
  
  def self.unimplemented(function_code, context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	puts function_code.to_s
    if move.category==2
	 sideDisplay(_INTL("But it failed!"))
	 return { FAILED: true }
	end 
    return {}
  end



  def self.BurnTarget(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	return {} if !target

    return {} if target.pbHasType?(:FIRE)
	
    return pbOverworldCombat.inflictStatus(move, user, target, :BURN, rand(4)+1)
  end

  def self.PoisonTarget(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	return {} if !target

    return {} if target.pbHasType?(:POISON) || target.pbHasType?(:STEEL)
	
    return pbOverworldCombat.inflictStatus(move, user, target, :POISON, rand(4)+1)
  end

  def self.SleepTarget(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	return {} if !target
	return {} if (target.hasAbility?(:INSOMNIA) || target.hasAbility?(:VITALSPIRIT))
    return pbOverworldCombat.inflictStatus(move, user, target, :SLEEP, rand(4)+1) 
	return {}
  end

def self.ParalyzeTarget(context)
  user   = context[:user]
  target = context[:target]
  move   = context[:move]

  if target && !target.pbHasType?(:GROUND)
    pbOverworldCombat.inflictStatus(move, user, target, :PARALYSIS, rand(4)+1)
  end

  return {}
end

def self.BindTarget(context)
  user   = context[:user]
  target = context[:target]
  move   = context[:move]

  pbOverworldCombat.inflictStatus(move, user, target, :PARALYSIS, rand(6)+1, true, "#{target.name} was bound!")

  return {}
end

def self.FlinchTarget(context)
  target_event = context[:target_event]
  target_event.attack_cooldowns.map! { |cooldown| cooldown + 20 }
end 

def self.StatUpMove(context, stat, amt)
  target = context[:target]
  user = context[:user]
  move = context[:move]
  return {} if !target.can_raise_stat_stage?(stat, user, move)
  if target.raise_stat_stage(stat, amt, user)
  end
  
  return {}
end 
def self.StatDownMove(context, stat, amt)
  target = context[:target]
  user = context[:user]
  move = context[:move]
  return {} if !target.can_raise_stat_stage?(stat, user, move)
  if target.lower_stat_stage(stat, amt, user)
  end
  
  return {}
end 

def self.LowerTargetAttack1(context)
 return self.StatDownMove(context, :ATTACK, 1)
end
def self.LowerTargetAttack2(context)
 return self.StatDownMove(context, :ATTACK, 2)
end
def self.LowerTargetDefense1(context)
 return self.StatDownMove(context, :DEFENSE, 1)
end
def self.RaiseUserSpeed2(context)
 return self.StatUpMove(context, :SPEED, 2)
end
def self.RaiseUserAttack2(context)
 return self.StatUpMove(context, :ATTACK, 2)
end

def self.RaiseUserCriticalHitRate2(context)
  user = context[:user]
  if user.effects[PBEffects::FocusEnergy] >= 2
    sideDisplay(_INTL("But it failed!"))
	return { FAILED: true}
  end 
  user.effects[PBEffects::FocusEnergy] = 2
  sideDisplay(_INTL("{1} is getting pumped!", user.name))
  return {}
end


def self.RecoilQuarterOfDamageDealt(context)
  user   = context[:user]
  damage = context[:damage]

  pbOverworldCombat.damageTarget(user,(damage / 4).to_i)

  return {}
end
def self.HealUserByHalfOfDamageDone(context)
  user   = context[:user]
  damage = context[:damage]

  pbOverworldCombat.healTarget(user,(damage / 2).to_i)

  return {}
end

def self.ProtectUser(context)
  user = context[:user]

  user.effects[PBEffects::Protect] = true
  user.effects[PBEffects::ProtectRate] = 2

  return {}
end

def self.ConfuseTarget(context)
  target = context[:target]

  pbOverworldCombat.pbConfuse(target)

  return {}
end

def self.SwitchOutUserStatusMove(context)
  pkmn = context[:user]
  event = context[:user_event]
  move = context[:move]
  if event.following == $game_player
    if pbCanUseHiddenMove?(pkmn, move.id)
	 pbOverworldCombat.clear_angry_at_of(event)
     pbOverworldCombat.sound_from_move(move.id,pkmn)
	 pbUseHiddenMove(pkmn, move.id)
	 return {RESULT: true}
	end 
  else
    valid_tiles = []

    (-8..8).each do |dx|
      (-8..8).each do |dy|
        next if dx == 0 && dy == 0
    
        x = event.x + dx
        y = event.y + dy

		next if dx.abs + dy.abs < 3
        next if dx.abs + dy.abs > 8

        next if !event.passable?(x, y, 2) rescue false

        valid_tiles << [x, y]
      end
    end

    if valid_tiles.any?
      x, y = valid_tiles.sample
      event.moveto(x, y)
     pbOverworldCombat.sound_from_move(move.id,pkmn)
	 pbOverworldCombat.clear_angry_at_of(event)
	 return {RESULT: true}
    end
	 return {RESULT: false}
  end
	 return {RESULT: false}
  end 

#===============================================================================
# Launches target up to 10 tiles away, if they hit a wall they take fixed damage. If they hit another enemy, both take fixed damage.
# This is handled by OverworldState.
#===============================================================================
def self.SwitchOutTargetStatusMove(context)
  return {}
end
#===============================================================================
# Grounds any flying events for 30 seconds.
# (Gravity)
#===============================================================================
def self.StartGravity(context)
  return {}

end 
#===============================================================================
# User switches places with another active Pokemon on the field that is farthest from the enemies. (Ally Switch)
#===============================================================================
def self.UserSwapsPositionsWithAlly(context)

  return {}


end 
#===============================================================================
# User gains half the HP it inflicts as damage. Fails if target is not asleep.
# (Dream Eater)
#===============================================================================
def self.HealUserByHalfOfDamageDoneIfTargetAsleep(context)


  return {}

end 
end