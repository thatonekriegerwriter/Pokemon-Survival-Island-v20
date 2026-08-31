class OverworldCombat::MoveAttributes
  def self.apply(context)
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

  def self.unimplemented(function_code, context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	puts function_code.to_s
    return {}
  end
  def self.FixedDamageMove(context, fixed_damage)
	effects = self.NeverCriticalHit(context)
    effects[:fixed_damage] = fixed_damage
    return effects
  end 
  
  def self.FixedDamage20(context)
    return self.FixedDamageMove(context, 20)
  end
  
  def self.FixedDamage40(context)
    return self.FixedDamageMove(context, 40)
  end
  
  def self.FixedDamageHalfTargetHP(context)
    target = context[:target]
    return self.FixedDamageMove(context, (target.hp / 2.0).round)
  end
  
  def self.FixedDamageUserLevel(context)
    user = context[:user]
    return self.FixedDamageMove(context, user.level)
  end
  
  def self.FixedDamageUserLevelRandom(context)
    user = context[:user]
	min = (user.level / 2).floor
    max = (user.level * 3 / 2).floor
    return self.FixedDamageMove(context, min + rand(max - min + 1))
  end
  
  def self.LowerTargetHPToUserHP(context)
    event = context[:user_event]
    target = context[:target]
    user = context[:user]
    if user.hp >= target.hp
      sideDisplay(_INTL("But it failed!")) if event.is_a?(Game_PokeEventA)
	  return {}
	end
    return self.FixedDamageMove(context, target.hp - user.hp)
  end

  

  
  def self.AlwaysCriticalHit(context)
    return { critical: 1 }
  end 

  def self.NeverCriticalHit(context)
    return { critical: -1 }
  end 
  
  def self.PowerLowerWithUserHP(context)
    user = context[:user]
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
    return {new_base_damage: ret}
  end
  def self.PowerHigherWithConsecutiveUse(context)
    user = context[:user]
    move = context[:move]
    oldVal = user.effects[PBEffects::FuryCutter] || 0
    maxMult = 1
    while (move.base_damage << (maxMult - 1)) < 160
      maxMult += 1  
	end 
    user.effects[PBEffects::FuryCutter] = (oldVal >= maxMult) ? maxMult : oldVal + 1
	baseDmg = move.base_damage << (user.effects[PBEffects::FuryCutter] - 1)
	return {new_base_damage: baseDmg}
  end 
  def self.PowerHigherWithConsecutiveUseOnUserSide(context)
    user = context[:user]
    move = context[:move]
  end 
end 