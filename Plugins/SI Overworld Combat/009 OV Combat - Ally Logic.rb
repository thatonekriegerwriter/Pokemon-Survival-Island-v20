class OverworldCombat::Ally
  def self.can_attack?(attacker)
    return false unless defined?(attacker.pokemon)
    return false if attacker.dont_attack
    return false if $PokemonGlobal.fishing
    return false if $game_temp.in_menu
    return false if $game_temp.message_window_showing &&
                  !$PokemonGlobal.alternate_control_mode

    return true
  end
  def self.score_target(attacker, move, target, skill)
    case OverworldCombat::Moves.target_data(move.id)
     when :User
      return score_self_target(attacker, move, skill)

     when :NearAlly, :AllAllies, :UserAndAllies, :UserOrNearAlly
       return score_ally_target(attacker, move, target, skill)

     else
       return score_hostile_target(attacker, move, target, skill)
    end
  end
  def self.score_self_target(attacker, move, skill)
    score = 0 
    if attacker.hp < (attacker.totalhp/2).round
      score += 50 if move.function_code.include?("Heal")
      score += 0 if move.function_code.include?("UserEnduresFaintingThisTurn")
      score += 0 if move.function_code.include?("EnsureNextCriticalHit")
      score += 50 if move.function_code.include?("UserMakeSubstitute")
    else
      score -= 40 if move.function_code.include?("Heal")
    end
    if attacker.hp < (attacker.totalhp/4).round
      score += 50 if move.function_code.include?("UserEnduresFaintingThisTurn")
      score += 40 if move.function_code.include?("EnsureNextCriticalHit")
    end
    if attacker.hp < (attacker.totalhp/6).round
	  score += 100
    end
    if attacker.pokemon.status != :NONE
      score += 50 if move.function_code.include?("Cure")
      score += 50 if move.function_code.include?("HealUserStatus")
    end
   if attacker.hp > attacker.totalhp / 2
     score += 30 if move.function_code.include?("RaiseUser")
   end
   score += 0 if move.function_code.include?("RedirectAllMovesToUser")
   score += 0 if move.function_code.include?("StealAndUseBeneficialStatusMove")
   score += 0 if move.function_code.include?("StartUserAirborne")
   score += 0 if move.function_code.include?("ProtectUser")
   score += 0 if move.function_code.include?("RestoreUserConsumedItem")
   score += 0 if move.function_code.include?("CurseTargetOrLowerUserSpd1RaiseUserAtkDef1")
   score += 0 if move.function_code.include?("StartHealUserEachTurnTrapUserInBattle")
   score += 0 if move.function_code.include?("UseRandomMoveFromUserParty")
   score += 0 if move.function_code.include?("UseRandomUserMoveIfAsleep")
   score += 0 if move.function_code.include?("UseRandomMove")
   score += 0 if move.function_code.include?("MaxUserAttackLoseHalfOfTotalHP")
   score += 0 if move.function_code.include?("SwitchOutUserPassOnEffects")
   score += 0 if move.function_code.include?("DoesNothingCongratulations")
   score += 0 if move.function_code.include?("SetUserTypesToUserMoveType")
   score += 0 if move.function_code.include?("UseLastMoveUsed")
   score += 0 if move.function_code.include?("DoesNothingUnusableInGravity")
   score += 0 if move.function_code.include?("UserSwapsPositionsWithAlly")
   score += 0 if move.function_code.include?("DisableTargetMovesKnownByUser")
   score += 0 if move.function_code.include?("BounceBackProblemCausingStatusMoves")
   score += 0 if move.function_code.include?("UserSwapBaseAtkDef")
   score += 0 if move.function_code.include?("SwitchOutUserStatusMove")
   if move.function_code.include?("UserFaints")
     score -= 100
   end
   return score
  end 
  
  def self.score_ally_target(attacker, move, target, skill)
   distance = OverworldCombat.attack_distance(attacker, target)
   return nil unless distance
   score = 0
    if target.hp < (target.totalhp/2).round
	  score += 15
      score += 50 if move.function_code.include?("Heal")
	else
      score -= 40 if move.function_code.include?("Heal")
	
	end 
    if target.pokemon.status != :NONE
	  score += 50
      score += 50 if move.function_code.include?("Cure")
      score += 50 if move.function_code.include?("HealUserStatus")
    end

  if move.function_code.include?("RaiseTarget")
    score += target.pokemon.level / 2
  end
   score += OverworldCombat::Scoring.closer_score(attacker, distance)
   score += OverworldCombat::Scoring.adjacent_score(attacker, target)
   score += OverworldCombat::Scoring.sightline_score(attacker, distance)
   score += OverworldCombat::Scoring.can_use_move_score(attacker, move, target)
   score += OverworldCombat::Scoring.movement_penalty(attacker, move, target)
   return score
  end 
  
  def self.score_hostile_target(attacker, move, target, skill)
   distance = OverworldCombat.attack_distance(attacker, target)
   return nil unless distance
   score = 0
   score += OverworldCombat::Scoring.closer_score(attacker, distance)
   score += OverworldCombat::Scoring.adjacent_score(attacker, target)
   score += OverworldCombat::Scoring.sightline_score(attacker, distance)
   score += OverworldCombat::Scoring.last_attacked_score(attacker, target)
   
   
   score += OverworldCombat::Scoring.hostility_score(attacker, target)
   
   score += OverworldCombat::Scoring.can_use_move_score(attacker, move, target)
   score += OverworldCombat::Scoring.movement_penalty(attacker, move, target)
   score += OverworldCombat::Scoring.type_match_score(attacker, target)
   if move.function_code.include?("UserFaints")
     score -= 100
   end
   score += OverworldCombat::Scoring.get_ov_damage_score(score, move, attacker, target, skill)
   if target.pokemon.is_a?(Pokemon)
		   value = Effectiveness.calculate(move.type, *target.pokemon.types)
	else
		   value = Effectiveness.calculate(move.type, :NORMAL)
	end
    score += 60 if Effectiveness.super_effective?(value)
    score -= 60 if Effectiveness.not_very_effective?(value)
    score -= 60 if Effectiveness.resistant?(value)
    score = 0 if Effectiveness.ineffective?(value)
   
   score
  end 
  
  
  
  def self.target_score(attacker, target, skill)
   distance = OverworldCombat.attack_distance(attacker, target)
   return nil unless distance
   score = 0
   score += closer_score(distance)
   score += adjacent_score(attacker, target)
   score += sightline_score(attacker, target)
   score += hostility_score(attacker, target)
   score += player_score(attacker, target)
   
   score += can_use_move_score(attacker, target)
   score += movement_penalty(attacker, target)
   score += type_match_score(attacker, target)
   
   
   
   score
  end 

end 

class OverworldCombat

  
def check_obedience(event)
  pkmn = event.pokemon
  disobedient = pkmn.should_disobey?
  return true unless disobedient
  disobey = resolve_disobedience(event)
  puts "#{pkmn.name} has disobeyed."
  return disobey
end  
def check_hypermode_disobedience(event, move, target)
  pkmn = event.pokemon
  disobedient = !pkmn.pbHyperModeObedience(move)
  return true unless disobedient
  resolve_hypermode_disobedience(event, move, target)
end 
  
def resolve_hypermode_disobedience(event, move, target)
  pkmn = event.pokemon
  r = rand(256)
  if r <= 60 && pkmn.status != :SLEEP
     action = OverworldCombat::Moves.choose_move(event, get_cur_player)
     return false unless action
  
     sub_move, sub_target, score = action
     damage = getDamager(event, sub_target, sub_move)
     sideDisplay(("#{pkmn.name} turned around and attacked you for #{damage} damage!"))
     damagePlayer(damage)
     return false 
  end
  if r <= 120 && pkmn.status == :NONE
     action = OverworldCombat::Moves.choose_move(event, event)
     return false unless action
  
     sub_move, sub_target, score = action
     damage = getDamager(event, sub_target, sub_move)
     sideDisplay(("#{pkmn.name} won't obey! It hurt itself in its confusion!"))
	 damagePokemon(event, damage)
     return false
  end
  if r <= 150 && pkmn.status != :SLEEP
    new_move = nil 
	attempts = 0
    loop do 
	 break if attempts > 10
     action = OverworldCombat::Moves.choose_move(event, target)
	 attempts +=1
     next unless action
    
     new_move, target, score = action
	  break if move != new_move
	end
	if new_move
    sideDisplay(("#{pkmn.name} used #{new_move.name} instead!")) 
    return new_move
	end
  end 
  if r <= 165
     sideDisplay(("#{pkmn.name} went back into it's Poké Ball!"))
     pbReturnPokemon(event,true)
     return false
  end
  
  
  case rand(4)
  when 0 then sideDisplay(("#{pkmn.name} won't obey!"))
  when 1 then sideDisplay(("#{pkmn.name} turned away!"))
  when 2 then sideDisplay(("#{pkmn.name} is loafing around!"))
  when 3 then sideDisplay(("#{pkmn.name} pretended not to notice!"))
  end
  return false
end 

def resolve_disobedience(event)
  pkmn = event.pokemon
  r = rand(256)
  if pkmn.status == :SLEEP
	  sideDisplay((_INTL"#{pkmn.name} ignored you and continued sleeping."))
      return false
  end
  if r <= 10 && pkmn.status == :NONE
     action = OverworldCombat::Moves.choose_move(event, event)
     return false unless action
  
     move, target, score = action
     damage = getDamager(event, target, move)
     sideDisplay(("#{pkmn.name} won't obey! It hurt itself in its confusion!"))
	 damagePokemon(event, damage)
     return false
  end
  if r <= 20 && r >= 10 && pkmn.status != :SLEEP && pkmn.loyalty <= 50
     action = OverworldCombat::Moves.choose_move(event, get_cur_player)
     return false unless action
  
     move, target, score = action
     damage = getDamager(event, target, move)
     sideDisplay(("#{pkmn.name} turned around and attacked you for #{damage} damage!"))
     damagePlayer(damage)
     pbSEPlay("normaldamage")
     return false 
  end
  if r <= 30 && r >= 20 && pkmn.status != :SLEEP && pkmn.happiness >= 200
      sideDisplay(("#{pkmn.name} isn't listening!"))
      sideDisplay(("#{pkmn.name} wants you to praise it before it does anything!"))
      return false 
  end
  if r <= 20 && r >= 10 && pkmn.status != :SLEEP && pkmn.happiness >= 199
      sideDisplay(("#{pkmn.name} isn't listening!"))
      sideDisplay(("#{pkmn.name} wants to play!"))
      return false 
  end
  if r <= 40  && pkmn.status==:NONE
	  pkmn.status=:SLEEP
	  sideDisplay((_INTL"#{pkmn.name} began to nap!"))
      return false
  end




  case rand(4)
  when 0 then sideDisplay(("#{pkmn.name} won't obey!"))
  when 1 then sideDisplay(("#{pkmn.name} turned away!"))
  when 2 then sideDisplay(("#{pkmn.name} is loafing around!"))
  when 3 then sideDisplay(("#{pkmn.name} pretended not to notice!"))
  end
  return false
end  


def perform_player_attack(user, move = nil, target = nil, forced = false)
   return false unless user
   addAlly(user.id, user) unless hasAlly?(user.id, user)
  if user.pokemon.effects[PBEffects::Confusion]>0
    damagePokemon(user, user.pokemon.totalhp/6)
      return false
  end 
   if move && forced==false && get_cur_player != user
      return false unless check_obedience(user)
   end 
   if move.nil? && get_cur_player != user
    action = OverworldCombat::Moves.choose_action(user)
    return false unless action

    move, alt_target, score = action
   end
   return false if move.nil?
   if move.pp == 0
	  sideDisplay("#{move.name} does not have enough PP!")
      return false
   end
  if user.attack_opportunity > 0 && !forced
    sideDisplay("#{user.pokemon.name} is too winded to use #{move.name}!")
    return false
  end
  if (new_move = check_hypermode_disobedience(user, move, target))
    if new_move.is_a?(Pokemon::Move)
	 move = new_move
	elsif new_move==false
	  return false 
	end 
  
  end 
  target = OverworldCombat::Moves.choose_target(user, move) if target.nil?
  puts "No Target for #{user.pokemon.name}!" if target.nil?
  return false unless target
  user.dont_attack = true if defined?(user.dont_attack)
  begin
    user.turn_toward_event(target)
    result = execute_move(user, move, target)
  ensure
    user.dont_attack = false if defined?(user.dont_attack)
  end
  user.last_attacked = target if result
  $hud.createaChargeBar(user) if user.attack_opportunity >= 0
  result
end


def autobattle(attacker) 
  perform_player_attack(attacker)
end


end

