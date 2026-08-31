class OverworldCombat::Opponent
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
   score += OverworldCombat::Scoring.hostility_score(attacker, target)
   score += OverworldCombat::Scoring.player_score(attacker, target)
   score += OverworldCombat::Scoring.last_attacked_score(attacker, target)
   
   score += OverworldCombat::Scoring.can_use_move_score(attacker, move, target)
   score += OverworldCombat::Scoring.movement_penalty(attacker, move, target)
   score += OverworldCombat::Scoring.type_match_score(attacker, target)
   if move.function_code.include?("UserFaints")
     score -= 100
   end
   score -= 100 if move.function_code.include?("BurnTarget") && target.pokemon.status != :NONE
   score -= 100 if move.function_code.include?("PoisonTarget") && target.pokemon.status != :NONE
   score -= 100 if move.function_code.include?("ParalyzeTarget") && target.pokemon.status != :NONE
   score -= 100 if move.function_code.include?("SleepTarget") && target.pokemon.status != :NONE
   score -= 100 if move.function_code.include?("FreezeTarget") && target.pokemon.status != :NONE
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
  
  
  def self.can_attack?(attacker)
    return false unless defined?(attacker.pokemon)
    return false if OverworldCombat.fainted_check(attacker)
    return false if attacker.dont_attack
    return false if $PokemonGlobal.fishing
    return false if $game_temp.in_menu
    return false if $game_temp.message_window_showing &&
                  !$PokemonGlobal.alternate_control_mode

    return true
  end

end 



class OverworldCombat
def self.attack_distance(unit, target)
  directions = [2,4,6,8]

  distances = directions.filter_map do |dir|
    pbGetTargetInDirection(unit, dir, target)
  end
   distance = distances.any? ? distances.min : (unit.x - target.x).abs + (unit.y - target.y).abs + 2
  # puts "ATTACKER #{unit.pokemon.name} (Player Side? #{OverworldCombat.player_side?(unit)}): #{unit.x}, #{unit.y} dir #{unit.direction}"
  # puts "TARGET #{target.pokemon.name} (Player Side? #{OverworldCombat.player_side?(target)}): #{target.x}, #{target.y} dir #{target.direction}"
  # puts "DISTANCE #{distance}"

   return distance 
end

def wild_should_attack?(opponent)
 return false if opponent.attacked_last_call==true
 return false if opponent.battle_timer>0
 return true if $game_temp.bossfight==true

 return OverworldCombat.attack_rate(opponent)
end

def self.attack_rate(opponent)
  attack_chance = rand(100) + 1
  rate = opponent.pokemon.is_aggressive? ? 40 : 10
  rate += opponent.times_not_attacking * 10
 rate /= 1.5 if opponent.pokemon.hp == opponent.pokemon.totalhp
 rate = 90 if rate > 90

 return attack_chance<=rate
end 

def grace_period(amt)
  loops = 0
  loop do
    OverworldCombat.update_package
	 break if loops==amt
    loops+=1
  
  end
end



def process_ai_action(attacker)
   return unless OverworldCombat::Opponent.can_attack?(attacker)
   should_attack = wild_should_attack?(attacker)
   puts "#{attacker.pokemon.name} (#{attacker.id}) has #{attacker.battle_timer} left on it's timer, has not attacked #{attacker.times_not_attacking} times, and #{attacker.battle_timer==0 ? "#{should_attack ? "is attacking." : "is not attacking."}" : "cannot attack."}."
   if should_attack
     attacker.cannot_move = true if defined?(attacker.cannot_move)
     acted = perform_ai_attack(attacker)
     attacker.cannot_move = false if defined?(attacker.cannot_move)
     unless acted
       attacker.times_not_attacking += 1
       attacker.battle_timer -= attacker.times_not_attacking
       attacker.battle_timer = 0 if attacker.battle_timer < 0
     end
   elsif attacker.attacked_last_call==true
	 attacker.battle_timer-=1
	 attacker.attacked_last_call = false
   elsif attacker.attacked_last_call==false
	 attacker.times_not_attacking+=1
	 attacker.battle_timer-=1
	 attacker.battle_timer= 0 if attacker.battle_timer<0
	 attacker.times_not_attacking=0
   end 
	

end 
alias ov_combat_loop process_ai_action


def perform_ai_attack(attacker)
  if attacker.pokemon.effects[PBEffects::Confusion]>0
    damagePokemon(attacker, attacker.pokemon.totalhp/6)
      return false
  end 
  action = OverworldCombat::Moves.choose_action(attacker)
#   puts "#{attacker.pokemon.name} (#{attacker.id}) is in the attacking logic, and action #{!action.nil? ? "does exist, and it's attacking #{action[1].pokemon.name} with #{action[0].name}" : "does not exist."}."
  return false unless action
  
  move, target, score = action
  
  
  addEnemy(attacker.id, attacker)
  attacker.dont_attack = true
  begin
  attacker.turn_toward_event(target)
  result = execute_move(attacker, move, target)
  ensure
  attacker.dont_attack = false
  end
  @turn += 1
  status_checks(attacker)
  set_bgm

  if result
    attacker.attacked_last_call = true
    attacker.remaining_steps += 1
	attacker.times_not_attacking = 0
  end
  return result
end 



end