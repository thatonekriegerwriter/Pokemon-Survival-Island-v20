#===============================================================================
# Core Combat Functions
#===============================================================================


    #when 2 then event.move_down
    #when 4 then event.move_left
    #when 6 then event.move_right
    #when 8 then event.move_up

class OverworldCombat
  attr_accessor :battlers           # Currently active fighters,
  attr_accessor :currentlyinbattle           # Currently active fighters,

   def initialize(opponent)
     @opponent = opponent
     @controlled = pokeadefined
     @currentlyinbattle = false
	 @pokemono=@opponent.pokemon
	 @opponent_dir = @opponent.direction
	 @pokemona= nil
	 @controlleddir= @controlled.direction
	 @target = nil
   end


def pokeadefined
    return $game_temp.current_pkmn_controlled if $game_temp.current_pkmn_controlled !=false
    return $game_player
  end


def update
	 @backattack,@sideattack,@baddir = getdirissues
     @pokemonspeed = @pokemono.speed
     @playerspeed = getUserSpeed
end


def ov_combat_loop
if @opponent.battle_timer<0
 @opponent.battle_timer=10
end
if @opponent.trigger!=0
if @opponent.battle_timer<=0
	 calledpkmndis = 99
	 playerdis = 99
	 calledpkmndis = pbDetectTargetPokemon(@opponent,@pokemona) if !@pokemona.nil?
	 playerdis = pbDetectTargetPokemon(@opponent,@controlled)
 
	 
    if playerdis < calledpkmndis
	  @target = @controlled
	  distance = playerdis
	 elsif playerdis == calledpkmndis
	  @target = @controlled
	  distance = playerdis
	 elsif playerdis > calledpkmndis
	  @target = @pokemona.pokemon
	  distance = calledpkmndis
	 end
 	 counter_match = @opponent.name.match(/counter\(\d+\)/)
	 counter = counter_match[0] if counter_match
	 number_match = counter.match(/\d+/) if counter
	 number = number_match[0] if number_match
	 currentDistance = number.to_i if number
if distance <= currentDistance && distance > 0
if distance < 4 && distance > 0
 if rand(100)<36
 
	 $game_temp.stopmoving=true
	 if @pokemona.nil?
	 @pokemona = getpokemona
	 end
    update
     
	 

	 


	   
	   
    	return if @target.nil?
	  opponentChoice(distance) if distance<4 && distance > 0 && @currentlyinbattle==false && !@pokemono.fainted?

	   
	   
	   
	   
	   
	   
	$game_temp.stopmoving=false
 end
 else

@opponent.battle_timer-=1 if @opponent.battle_timer>0
end
else

@opponent.battle_timer-=1 if @opponent.battle_timer>0
end
else 
@opponent.battle_timer-=1 if @opponent.battle_timer>0
end

end
end





def opponentChoice(distance)
@opponent.setTrigger(0)
@currentlyinbattle = true
$game_temp.preventspawns=true
  if pbShouldAttack?
    move = chooseMove(distance)
	 if move!=false
	  if distance==1 && move.category == 0
	   move_physical_close(@pokemono,move)
	  elsif rand(100)<51
       if move.category == 0
	      move_physical(@pokemono,move)
	   elsif move.category == 1
	      move_special(@pokemono,move,distance)
	   elsif rand(50)<5
	      move_other(@pokemono,move)
	   end
      





     end
     end
  end
$game_temp.preventspawns=false
@currentlyinbattle = false
@opponent.setTrigger(4)
@opponent.battle_timer=255
end


def turning_prep

     pbTurnTowardEvent(@opponent,@controlled) if @target == @controlled
     pbTurnTowardEvent(@opponent,@pokemona) if @target != @controlled && @target.is_a?(Pokemon)
     pbTurnTowardEvent(@opponent,$game_player) if @target != @controlled && !@target.is_a?(Pokemon)

end


def move_physical(pkmn,move)
     turning_prep
	  pbMessage("\\ts[]" + (_INTL"#{pkmn.name} is rearing back!\\wtnp[10]"))
      pbMoveRoute(@target, [PBMoveRoute::Wait, 30])
	  pbMoveTowardEvent9(@opponent,@target)
	  if outSpeeds? #Player Outspeeds
	    dir = staminaManagement if @target == $game_player
	    dir = inputDetection if @target != $game_player
		if can_move_there?(@opponent,dir)
	     pbMoveRoute(@target, [PBMoveRoute::ScriptAsync, "move_generic(#{@controlleddir}, false)"]) #PBMoveRoute::Wait, 2
		 if @target == $game_player
	     if advanced_shoes2
	         decreaseStamina(15)
		  elsif default_sta2
	         decreaseStamina(10)
		  else
	         decreaseStamina($player.playerstamina) 
			  pbExclaim(@target,48)
	         offensive_turn_finishing(move)
		  end
        else
			  pbExclaim(@target,48)
	         offensive_turn_finishing(move)
		  end
       else
	    offensive_turn_finishing(move)
		end
	  else
	    pbMessage("\\ts[]" + (_INTL"#{$player.name} was outsped by #{@pokemono.name}!\\wtnp[30]")) if @target == $game_player
	    pbMessage("\\ts[]" + (_INTL"#{@pokemona.name} was outsped by #{@pokemono.name}!\\wtnp[30]")) if @target != $game_player
	    pbSEPlay("phenomenon_grass")
	    offensive_turn_finishing(move)
     end

end


def move_physical_close(pkmn,move)
     turning_prep
	  if outSpeeds? #Player Outspeeds
	    dir = staminaManagement if @target == $game_player
	    dir = inputDetection if @target != $game_player
		if can_move_there?(@opponent,dir)
	     pbMoveRoute(@target, [PBMoveRoute::ScriptAsync, "move_generic(#{@controlleddir}, false)"]) #PBMoveRoute::Wait, 2
		 if @target == $game_player
	     if advanced_shoes2
	         decreaseStamina(15)
		  elsif default_sta2
	         decreaseStamina(10)
		  else
	         decreaseStamina($player.playerstamina) 
			  pbExclaim(@target,48)
	         offensive_turn_finishing(move)
		  end
        else
			  pbExclaim(@target,48)
	         offensive_turn_finishing(move)
		  end
       else
	    offensive_turn_finishing(move)
       end
	  else
	    pbMessage("\\ts[]" + (_INTL"#{$player.name} was outsped by #{@pokemono.name}!\\wtnp[30]")) if @target == $game_player
	    pbMessage("\\ts[]" + (_INTL"#{@pokemona.name} was outsped by #{@pokemono.name}!\\wtnp[30]")) if @target != $game_player
	    pbSEPlay("phenomenon_grass")
	    offensive_turn_finishing(move)
     end


end


def move_special(pkmn,move,distance)
     turning_prep
	  pbMessage("\\ts[]" + (_INTL"#{pkmn.name} is gathering energy!\\wtnp[10]"))
	  timepass = 0
	  loop do 
        timepass+=1

	    break if timepass > 29
	  end



	  if outSpeeds? #Player Outspeeds
	    dir = staminaManagement if @target == $game_player
	    dir = inputDetection if @target != $game_player
		if can_move_there?(@opponent,dir)
	     pbMoveRoute(@target, [PBMoveRoute::ScriptAsync, "move_generic(#{dir}, false)"]) #PBMoveRoute::Wait, 2
		 if @target == $game_player
	     if advanced_shoes2
	         decreaseStamina(15)
		  elsif default_sta2
	         decreaseStamina(10)
		  else
	         decreaseStamina($player.playerstamina) 
			  pbExclaim(@target,48)
	         offensive_turn_finishing(move)
		  end
        else
	         offensive_turn_finishing(move)
		  end
       else
	         offensive_turn_finishing(move)
       end
	  else
	    pbMessage("\\ts[]" + (_INTL"#{$player.name} was outsped by #{@pokemono.name}!\\wtnp[30]")) if @target == $game_player
	    pbMessage("\\ts[]" + (_INTL"#{@pokemona.name} was outsped by #{@pokemono.name}!\\wtnp[30]")) if @target != $game_player
	    pbSEPlay("phenomenon_grass")
	    offensive_turn_finishing(move)
     end

	  
	  




end

def move_other(pkmn,move)
	  #pbMessage("\\ts[]" + (_INTL"#{pkmn.name} focused!\\wtnp[10]"))

end


def offensive_turn_finishing(move)
   accuracy   = move.accuracy
   accbonus = 0
   if @opponent.stages.key?(:ACCURACY)
    
   end
	pbMessage("\\ts[]" + (_INTL"#{@pokemono.name} used #{move.name}!\\wtnp[10]"))
    will_hit = rand(100)+($player.shoespeed/2) < (accuracy+accbonus) if @target == $game_player
    will_hit = rand(100) < (accuracy+accbonus) if @target != $game_player
   
    if will_hit==true
	  multiplier = 1
	  multiplier = 2 if @backattack
	  multiplier = 1.5 if @sideattack
     thedamage = getDamager(@pokemono,move,multiplier,move)
	 if @target == $game_player
	  if thedamage<(($player.playermaxhealth/4)*1.4)
        damagePlayer(thedamage)
		if @backattack
		pbSEPlay("Battle damage super")
		elsif @sideattack
		pbSEPlay("Battle damage normal")
		else
		pbSEPlay("Battle damage weak")
		end
		pbWait(6)
        if $player.playerhealth >= 80
		pbExclaim($game_player,17)
        elsif $player.playerhealth >= 50 && $player.playerhealth < 80
		pbExclaim($game_player,16)
        elsif $player.playerhealth >= 25 && $player.playerhealth < 50
		pbExclaim($game_player,15)
        elsif $player.playerhealth <= 24
		pbExclaim($game_player,14)
        end
      
	  if rand(255)+1 < 16 && $PokemonGlobal.in_dungeon==false
	  pbMessage("\\ts[]" + (_INTL"#{@pokemono.name} knocked #{$player.name} down!\\wtnp[10]"))
	  if true
	  $game_temp.encounter_type = $game_temp.encounter_type
	  pbStoreTempForBattle()
	  $PokemonGlobal.battlingSpawnedPokemon = true
	  $game_temp.in_safari = true
	  pbSingleOrDoubleWildBattle($game_map.map_id, @opponent.x, @opponent.y, @pokemono)
	  $game_temp.in_safari = false
	  $PokemonGlobal.battlingSpawnedPokemon = false
	  pbResetTempAfterBattle()
	  end
     end

      else
	  
	  	  
	  pbMessage("\\ts[]" + (_INTL"#{@pokemono.name} knocked #{$player.name} down!\\wtnp[10]"))
	  if $PokemonGlobal.in_dungeon==false
	  $game_temp.encounter_type = $game_temp.encounter_type
	  pbStoreTempForBattle()
	  $PokemonGlobal.battlingSpawnedPokemon = true
	  $game_temp.in_safari = true
	  pbSingleOrDoubleWildBattle($game_map.map_id, @opponent.x, @opponent.y, @pokemono)
	  $game_temp.in_safari = false
	  $PokemonGlobal.battlingSpawnedPokemon = false
	  pbResetTempAfterBattle()
	  end



	  
	  
	  
	  
      end
     elsif @target == @pokemona
	   applyStatus(move,@pokemono,@pokemona)
	  @pokemona.hp-=thedamage
	  @pokemona.hp = 0 if @pokemona.hp < 0
     else 
	   applyStatus(move,@pokemono,@target.type)
	  @target.type.hp-=thedamage
	  @target.type.hp = 0 if @target.type.hp.hp < 0
	 end
    else
	  pbMessage("\\ts[]" + (_INTL"#{@pokemono.name} missed!\\wtnp[10]"))
    end
   
   
   
   
	$game_temp.stopmoving=false

end




def inputDetection
    loops = 0
	dir = 0
	pbExclaim(@target,46)
	sprite = nil
	loop do
    dir = Input.dir4
	Input.update
    Graphics.update
	#pbExclaim($game_player,47)
	if sprite.nil? 
    spriteset = $scene.spriteset(@target.map_id)
    sprite = spriteset&.addUserAnimation(47, @target.x, @target.y, false, 2)
	end
    case dir 
	 when 8
	pbExclaim(@target,42) if dir != @baddir && dir != @opponent_dir
	pbExclaim(@target,48) if dir == @baddir && dir == @opponent_dir
	
	
	
	
	
	
	
	sprite.dispose
     break
	 
	 
	 
	 
	 when 2
	pbExclaim(@target,44) if dir != @baddir && dir != @opponent_dir
	pbExclaim(@target,48) if dir == @baddir && dir == @opponent_dir
	
	
	
	
	
	
	
	sprite.dispose
     break
	 
	 
	 
	 when 4 
	pbExclaim(@target,43) if dir != @baddir && dir != @opponent_dir
	pbExclaim(@target,48) if dir == @baddir && dir == @opponent_dir
	
	
	
	
	
	
	
	
	sprite.dispose
     break
	 
	 
	 
	 
	 
	 when 6
	
	pbExclaim(@target,45) if dir != @baddir && dir != @opponent_dir
	pbExclaim(@target,48) if dir == @baddir && dir == @opponent_dir
	sprite.dispose
     break
	 else
	loops += 1
	
	
	
	
	
	
	
	end
	
	
	
	
	
	sprite.dispose if loops > 10
	break if loops > 10
	end

  return dir
end

def staminaManagement
	  dir = 0
    if advanced_shoes
	  the_effect_of_stamina
	 elsif default_sta
	  the_effect_of_stamina
	 else
      dir = inputDetection
	 end
  return dir
end


end
class OverworldCombat
  


  def the_effect_of_stamina
	 pbExclaim($game_player,21)
	 pbMessage("\\ts[]" + (_INTL"#{$player.name} doesn't have enough Stamina to avoid #{@pokemono.name}!\\wtnp[30]"))
	 pbSEPlay("phenomenon_grass")
      damagePlayer($player.playermaxhealth/4)
	  if rand(100)+1 < 16 && $PokemonGlobal.in_dungeon==false
	  pbMessage("\\ts[]" + (_INTL"#{@pokemono.name} knocked #{$player.name} down!\\wtnp[10]"))
	  if true
	  $game_temp.encounter_type = $game_temp.encounter_type
	  pbStoreTempForBattle()
	  $PokemonGlobal.battlingSpawnedPokemon = true
	  $game_temp.in_safari = true
	  pbSingleOrDoubleWildBattle($game_map.map_id, @opponent.x, @opponent.y, @pokemono)
	  $game_temp.in_safari = false
	  $PokemonGlobal.battlingSpawnedPokemon = false
	  pbResetTempAfterBattle()
	  end
     end
	  return
  
  end
 
 
 
 
 
 
 
 
 def default_sta
  return $player.playerstamina<10
 end
 
 def default_sta2
  return $player.playerstamina>9
 end
 
  def advanced_shoes
   return $player.playershoes == :DASHBOOTS && $player.playerstamina<20
  end

  def advanced_shoes2
   return $player.playershoes == :DASHBOOTS && $player.playerstamina>19
  end

end
#===============================================================================
# Common Combat Calls
#===============================================================================
class OverworldCombat


def pbShouldAttack?
  return false if @pokemono.fainted?
  return false if @pokemono.status == :SLEEP
  return false if @pokemono.status == :PARALYSIS
  return false if @pokemono.status == :FROZEN
  if getRate < 1
   changeTarget
  end
  return rand(100)<getRate

end

def changeTarget
if @target == @pokemona
 @target = $game_player if $game_temp.current_pkmn_controlled==false
 @target = $game_temp.current_pkmn_controlled if $game_temp.current_pkmn_controlled!=false
 distance = pbDetectTargetPokemon(@opponent)
end
if @target == $game_player || @target == $game_temp.current_pkmn_controlled
 @target = @pokemona 
 distance = pbDetectTargetPokemon(@opponent,@controlled)
end

 types = distance > 1 ? [:PHYSICAL, :SPECIAL, :STATUS] : [:PHYSICAL, :STATUS]
 return types,distance
end

def getpokemona
pokemon=[]
$player.party.each_with_index do |pkmn,index|
 next if $game_temp.current_pkmn_controlled !=false && index==0
 next if $game_temp.current_pkmn_controlled !=false && index>2
 next if pkmn.inworld==false
  pokemon << pkmn
end
 return nil if pokemon.empty?
 return $game_map.events[getOverworldPokemonfromPokemon(pokemon[rand(pokemon.length)])]
end

def can_move_there?(event,dir)
return dir != 0 && dir != @baddir && dir != @opponent_dir && event.can_move_in_direction?(dir)
end

  def getAttackStats(user,target, move)
    if move.category == 1 
      return user.spatk, @opponent.stages[:SPECIAL_ATTACK].to_i + 6
    end
    return user.attack, @opponent.stages[:ATTACK].to_i + 6

  end


def is_assassin?
  return $player.playerclass == "Assassin"
end

def outSpeeds?
  speed = @playerspeed
  speed = (@playerspeed*1.8).to_i if is_assassin?
  return true if speed>=@pokemonspeed
  return false
end


def getDefenseStats(user,target, move)
   if @target.is_a?(Pokemon)
    if move.category == 1 
      return target.spdef, target.stages[:SPECIAL_DEFENSE].to_i + 6
    end
    return target.defense, target.stages[:DEFENSE].to_i + 6
	else
	 return $player.equipmentdefbuff, 0
	end
end

def get_the_multipliers(mult,pkmn,move)

		 mult[:final_damage_multiplier] *= 1
        mult[:final_damage_multiplier] *= 2 if @backattack
		 mult[:final_damage_multiplier] *= 1.5 if @sideattack
		 mult[:final_damage_multiplier] *= 1.5 if pbThisHasType?(pkmn,move.type)
		 return mult
end


def applyStatus(move,user,target)
	   if move.function_code.include?("SleepTarget")
 ability1=GameData::Ability.try_get(:INSOMNIA)
 ability2=GameData::Ability.try_get(:VITALSPIRIT)
  if target.status != :NONE && (target.ability==ability1 ||target.ability==ability2)
  else
     target.status=:SLEEP
	   if target.status_turns.nil?
	     target.status_turns=0
	   end
	     target.status_turns=(rand(4)+1)
  end
	   end

	   if move.function_code.include?("ParalyzeTarget" )
  if target.status != :NONE && target.pbHasType?(:GROUND)
  else
     target.status=:PARALYSIS
	 #makeParalyzed(target)
  end
	   end
	   
	   
	   if move.function_code.include?("PoisonTarget")

   if target && (target.status != :NONE || !target.pbHasType?(:STEEL) || !target.hasAbility?(:CORROSION))
     target.status=:POISON
	   if target.status_turns.nil?
	     target.status_turns=0
	   end
	     target.status_turns=(rand(4)+1)
		pbSEPlay("FollowEmote_Poison")
   end


	   end


	   
	   if move.function_code.include?("BurnTarget")
  if target.status != :NONE && target.pbHasType?(:FIRE)
  else
     target.status=:BURN
  end
	   end


	   
	   if move.function_code.include?("FreezeTarget")
  if target.status != :NONE  && target.pbHasType?(:ICE)
  else
     target.status=:FROZEN
  end
	   end


	   if move.function_code == "GiveUserStatusToTarget"
         if user.status != :NONE
		   target.status = user.status
		   user.status = :NONE
		 end
	   end



end

def getDamager(pkmn,move,multiplier=1,player=true)
  #pbCalcDamage
	  baseDmg = move.base_damage
     atk, atkStage = getAttackStats(pkmn, @target, move)
    defense, defStage = getDefenseStats(pkmn, @target, move)
    multipliers = {
      :base_damage_multiplier  => 1.0,
      :attack_multiplier       => 1.0,
      :defense_multiplier      => 1.0,
      :final_damage_multiplier => 1.0
    }
	multipliers = get_the_multipliers(multipliers,pkmn,move)
    # pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
    # Main damage calculation
    baseDmg = [(baseDmg * multipliers[:base_damage_multiplier]).round, 1].max
    atk     = [(atk     * multipliers[:attack_multiplier]).round, 1].max
    defense = [(defense * multipliers[:defense_multiplier]).round, 1].max
    damage  = ((((2.0 * pkmn.level / 5) + 2).floor * baseDmg * atk / defense).floor / 50).floor + 2
    damage  = [(damage * multipliers[:final_damage_multiplier]).round, 1].max





     return damage.floor
end



def getRate
      rate=10
	   if @target == @controlled
	    if @controlled==$game_player
      rate*=1.5 if $player.playerstamina <= 75 && $player.playerstamina > 50 &&
      rate*=3 if $player.playerstamina <= 50 && $player.playerstamina > 25
      rate*=4 if $player.playerstamina <= 25
      rate*=4 if $player.playerhealth <= 25
      rate*=3 if $player.playerhealth <= 50 && $player.playerhealth > 25
      rate*=1.5 if $player.playerhealth <= 75 && $player.playerhealth > 50
	  @pokemono.types.each do |i|
		   value = Effectiveness.calculate(i, :NORMAL)
      rate*=2 if Effectiveness.super_effective?(value)
      rate*=2 if Effectiveness.not_very_effective?(value)
	  rate=0 if Effectiveness.ineffective?(value)
	  end
           else
            @pokemono.types.each do |i|
		         value = Effectiveness.calculate(i, *@target.type.types)
                rate*=2 if Effectiveness.super_effective?(value)
                rate*=2 if Effectiveness.not_very_effective?(value)
	            rate=0 if Effectiveness.ineffective?(value)
			   end
		 
	  end
       if @target.is_a?(Pokemon)
	     if @target == @pokemona.pokemon
            @pokemono.types.each do |i|
		         value = Effectiveness.calculate(i, *@target.types)
                rate*=2 if Effectiveness.super_effective?(value)
                rate*=2 if Effectiveness.not_very_effective?(value)
	            rate=0 if Effectiveness.ineffective?(value)
			   end
		 
		 end
	   end
      rate*=4 if @pokemono.is_aggressive?
	  return rate
end



end


#===============================================================================
# Sub Combat Functions
#===============================================================================
end

class OverworldCombat

def can_choose_move?(pkmn,move,showMessages=false)
  if move.pp == 0 && move.total_pp > 0
	pbMessage("\\ts[]" + (_INTL"There's no PP left for this move!\\wtnp[30]")) if showMessages
    return false
  end
  if @opponent.battle_variables.key?("Encore")
    return false
  end
  if @opponent.battle_variables.key?("Disabled")
    return false
  end
  if @opponent.battle_variables.key?("Taunt")
    return false
  end
  if pkmn.status == :FROZEN
    return false
  end
  if pkmn.status == :PARALYSIS
    return false
  end
  if pkmn.status == :SLEEP
    return false
  end
  return true
end




def chooseMove(distance)
   skill=(($PokemonSystem.difficulty+1)*$PokemonSystem.difficultymodifier)+(rand(80)+1)	
   potato = []
   @pokemono.moves.each do |m|
      duris = get_ov_move_score(m,@pokemono,@target,skill,distance)
      if can_choose_move?(@pokemono,m)
      potato << duris
	  else
      potato << 0
	  end
   end
   largest = potato.max
   if potato.max == 0
    return false
   else
   max_index = potato.index(largest)
   return @pokemono.moves[max_index]
   end

end

def get_ov_move_score(move,user,target,skill,distance)
   # 1*40 = 40
   # 2*40 = 80
   # 3*40 = 120
   # 4*40 = 160
    score = 100
     if skill > 120
      # If user is asleep, prefer moves that are usable while asleep
      if user.status == :SLEEP && (move!=:SNORE||move!=:SLEEPTALK)
        user.moves.each do |m|
          next unless (m==:SNORE||m==:SLEEPTALK)
          score -= 60
          break
        end
      end
      # If user is frozen, prefer a move that can thaw the user
      if user.status == :FROZEN
        if move.flags.any? { |f| f[/^ThawsUser$/i] }
          score += 40
        else
          user.moves.each do |m|
            next unless m.flags.any? { |f| f[/^ThawsUser$/i] }
            score -= 60
            break
          end
        end
      end
      # If target is frozen, don't prefer moves that could thaw them
	  if target.is_a?(Pokemon)
      if target.status == :FROZEN
        user.moves.each do |m|
          next if m.flags.any? { |f| f[/^ThawsUser$/i] }
          score -= 60
          break
        end
      end
	  elsif target==$game_player
      if $player.playerstateffect == :FROZEN
        user.moves.each do |m|
          next if m.flags.any? { |f| f[/^ThawsUser$/i] }
          score -= 60
          break
        end
       end
     end	  
	   
	   if move.function_code.include?("SleepTarget")
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end

	   if move.function_code.include?("ParalyzeTarget" )
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end
	   
	   
	   if move.function_code.include?("PoisonTarget")
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end


	   
	   if move.function_code.include?("BurnTarget")
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end


	   
	   if move.function_code.include?("FreezeTarget")
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end


	   if move.function_code == "GiveUserStatusToTarget"
      if user.status == :NONE
        score -= 90
      else
        score += 40
	   end
	   end
	  end
     if skill > 160
	   	if move.function_code.include?("SwitchOut") 
	   score -= 100
	   end

	   if move.function_code == "TrapTargetInBattle"
	   score += 30
	   end
	   
	   if move.function_code == "PursueSwitchingFoe"
	   score += 80
	   end
	   

	  end
     if skill > 200
	 	if move.function_code == "RemoveTargetItem"
        score += 20 if target.item
	   end
	   if move.function_code == "DestroyTargetBerryOrGem"
	   score += 30
	   end
	   if move.function_code == "HealUserHalfOfTotalHP"
	    score+30
	   end

	   if move.function_code == "FixedDamage20"
	   score += 80 if !target.is_a?(Pokemon)
	   end
	   if move.function_code == "FixedDamage40"
	   score += 80 if !target.is_a?(Pokemon)
	   end
	   if move.function_code == "FixedDamageHalfTargetHP"
	   score += 80 if !target.is_a?(Pokemon)
	   end
	   if move.function_code == "FixedDamageUserLevel"
	   score += 80 if !target.is_a?(Pokemon)
	   end
	   


	  end

	   if move.function_code == "UserFaintsExplosive"
	    score -= user.hp * 100 / user.totalhp
	   end



        score -= 40 if move.category == 2
        score += 80 if move.category == 1 && distance>1 #SPECIAL - HITTING WITH THE WAPOW
        score += 80 if move.category == 0 && distance==1 #PHYSICAL _ IN YA FACE
        score += 40 if move.category == 0 && distance>1 #PHYSICAL - RAMMING
		get_ov_damage_score(score,move,user,target,skill)
		   if target.is_a?(Pokemon)
		   value = Effectiveness.calculate(move.type, *target.types)
		   else
		   value = Effectiveness.calculate(move.type, :NORMAL)
		   end
          score+=60 if Effectiveness.super_effective?(value)
          score=0 if Effectiveness.ineffective?(value)
          score-=60 if Effectiveness.not_very_effective?(value)
          score-=60 if Effectiveness.resistant?(value)

	   if move.function_code == "FleeFromBattle" 
	   score = 0
	   end

    score = score.to_i
    score = 0 if score < 0
    return score

end

def get_ov_damage_score(score,move,user,target,skill)
	 atk = pbGetAttackStat2(user,move)
    dmg = ((move.base_damage+atk)/2).floor
    if move.function_code == "AttackAndSkipNextTurn"
	  dmg *= 2 / 3
	end
    damagePercentage = dmg * 100.0 / target.hp if target.is_a?(Pokemon)
    damagePercentage = dmg * 100.0 / $player.playerhealth if !target.is_a?(Pokemon)
	if target.is_a?(Pokemon)
    damagePercentage *= 1.2 if user.level - 10 > target.level
	else
    damagePercentage *= 1.2 if dmg - 10 > $player.equipmentdefbuff
	end
	if skill > 160
    damagePercentage = 120 if damagePercentage > 120   # Treat all lethal moves the same
    damagePercentage += 40 if damagePercentage > 100   # Prefer moves likely to be lethal
   end
    score += damagePercentage.to_i
    return score
end

def getdirissues
   
	backattack = @opponent_dir == @controlleddir
	sideattack = (@controlleddir == 4 || @controlleddir == 6)  && (@opponent_dir == 2 || @opponent_dir == 8)
	baddir = if @opponent_dir == 8
            2
          elsif @opponent_dir == 4
            6
          elsif @opponent_dir == 2
            8
          elsif @opponent_dir == 6
            4
          else
            0
          end
	
  return backattack,sideattack,baddir

end






  def pbGetAttackStat2(user,move)
    if move.category == 1 
      return user.spatk
    end
    return user.attack
  end

def getUserSpeed
  if @controlled == $game_player
   bonus = 0
   $player.party.each do |pkmn|
    bonus += pkmn.speed
   end
   if bonus!=0
     bonus = (bonus/$player.party.length).to_i
   end
    return $player.shoespeed + bonus
  else
    return @controlled.type.speed
  end

end



def player_pokemonattack(pokemon,move,target)
   accuracy   = move.accuracy
   accbonus = 0
	pbMessage("\\ts[]" + (_INTL"#{pokemon.name} used #{move.name}!\\wtnp[10]"))
    will_hit = rand(100) < (accuracy+accbonus)
   
    if will_hit==true
	  multiplier = 1
	  multiplier = 2 if @backattack
	  multiplier = 1.5 if @sideattack
     thedamage = getDamager(pokemon,move,multiplier,move)
	 applyStatus(move,pokemon,target)
	  target.hp-=thedamage
	  target.hp = 0 if move.hp < 0
    else
	  pbMessage("\\ts[]" + (_INTL"#{pokemon.name} missed!\\wtnp[10]"))
    end
end










def getDamageold(pkmn,multiplier=1,player=true)
   potato = []

    if potato.length > 0
	  move = potato[rand(potato.length)]
	  atk = pbGetAttackStat2(pkmn,move)
	  damage = ((move.base_damage+atk)/2).floor
	  if pbThisHasType?(pkmn,move.type)
	   damage *= 1.75
	  end
	  pbMessage("\\ts[]" + (_INTL"#{pkmn.name} used #{move.name}!\\wtnp[10]")) if player==true
    else
	  damage = ((50+user.attack)/5).floor
	  pbMessage("\\ts[]" + (_INTL"#{pkmn.name} used Tackle!\\wtnp[10]")) if player==true
	  if pbThisHasType?(pkmn,:NORMAL)
	   damage *= 1.75
	  end
    end

  damage = ((damage*multiplier).floor)
  damage = damage-$player.equipmentdefbuff if player==true
  if damage<0
   damage=1
  end
     return damage.floor
	end

def endTurnold(event,getRate,backattack,sideattack,playerdir,dir,baddir,pokedir,amt)
       return if event.pokemon.fainted?
		 multiplier = 1
        multiplier = 2 if @backattack
		 multiplier = 1.5 if @sideattack
		 thedamage = getDamager(event.pokemon,multiplier,move)
		 if thedamage<(($player.playermaxhealth/4)*1.4)








        damagePlayer(thedamage)
		if @backattack
		pbSEPlay("Battle damage super")
		elsif @sideattack
		pbSEPlay("Battle damage normal")
		else
		pbSEPlay("Battle damage weak")
		end
		pbWait(6)
        if $player.playerhealth >= 80
		pbExclaim($game_player,17)
        elsif $player.playerhealth >= 50 && $player.playerhealth < 80
		pbExclaim($game_player,16)
        elsif $player.playerhealth >= 25 && $player.playerhealth < 50
		pbExclaim($game_player,15)
        elsif $player.playerhealth <= 24
		pbExclaim($game_player,14)
        end

		
    if dir == baddir || dir == pokedir
	 if dir == pokedir
	 pbMoveRoute($game_player, [PBMoveRoute::ScriptAsync, "move_generic(#{@controlleddir}, true)"]) #PBMoveRoute::Wait, 2
	 else
    pbMoveRoute($game_player, [PBMoveRoute::Wait, 15]) #PBMoveRoute::Wait, 2
	 end
   	amt = 3
	else
    pbMoveRoute($game_player, [PBMoveRoute::Wait, 15]) #PBMoveRoute::Wait, 2
	end
	amt.times do
    event.move_forward
    end














   elsif $PokemonGlobal.in_dungeon==false
   
   
   
   
   
      damagePlayer($player.playermaxhealth/4)
	  pbMessage("\\ts[]" + (_INTL"#{event.pokemon.name} knocked #{$player.name} down!\\wtnp[10]"))
	  
	  $game_temp.encounter_type = $game_temp.encounter_type
	  pbStoreTempForBattle()
	  $PokemonGlobal.battlingSpawnedPokemon = true
	  $game_temp.in_safari = true
	  pbSingleOrDoubleWildBattle($game_map.map_id, @opponent.x, @opponent.y, @pokemono)
	  $game_temp.in_safari = false
	  $PokemonGlobal.battlingSpawnedPokemon = false
	  pbResetTempAfterBattle()
   
   end
end

 
 def oldresponses
 
	   
	   
	   
	   	pbTurnTowardEvent($game_player,event)
    pbTurnTowardEvent(event,$game_player)
    pbMoveRoute($game_player, [PBMoveRoute::Wait, 15]) #PBMoveRoute::Wait, 2
	loops = 0
	loopamt = 10
	   
	   
	   
	   
	   
	if playerspeed>=pokemonspeed
	
	
	
	
	
	
	
	
	
	
	
	
	
	  if $player.playershoes == :DASHBOOTS && $player.playerstamina<20
	 pbExclaim($game_player,21)
	 pbMessage("\\ts[]" + (_INTL"#{$player.name} doesn't have enough Stamina to avoid #{pokemon.name}!\\wtnp[30]"))
	 pbSEPlay("phenomenon_grass")
      damagePlayer($player.playermaxhealth/4)
	  if rand(100)+1 < 16 && $PokemonGlobal.in_dungeon==false
	  pbMessage("\\ts[]" + (_INTL"#{pokemon.name} knocked #{$player.name} down!\\wtnp[10]"))
	  if true
	  $game_temp.encounter_type = $game_temp.encounter_type
	  pbStoreTempForBattle()
	  $PokemonGlobal.battlingSpawnedPokemon = true
	  $game_temp.in_safari = true
	  pbSingleOrDoubleWildBattle($game_map.map_id, @opponent.x, @opponent.y, @pokemono)
	  $game_temp.in_safari = false
	  $PokemonGlobal.battlingSpawnedPokemon = false
	  pbResetTempAfterBattle()
	  end
     end

	  return
	  elsif $player.playerstamina<10
	 pbExclaim($game_player,21)
	 pbMessage("\\ts[]" + (_INTL"#{$player.name} doesn't have enough Stamina to avoid #{pokemon.name}!\\wtnp[30]"))
	 pbSEPlay("phenomenon_grass")
      damagePlayer($player.playermaxhealth/4)
	  if rand(100)+1 < 16 && $PokemonGlobal.in_dungeon==false
	  
	  
	  
	  pbMessage("\\ts[]" + (_INTL"#{pokemon.name} knocked #{$player.name} down!\\wtnp[10]"))
	  if $PokemonGlobal.in_dungeon==false
	  $game_temp.encounter_type = $game_temp.encounter_type
	  pbStoreTempForBattle()
	  $PokemonGlobal.battlingSpawnedPokemon = true
	  $game_temp.in_safari = true
	  pbSingleOrDoubleWildBattle($game_map.map_id, @opponent.x, @opponent.y, @pokemono)
	  $game_temp.in_safari = false
	  $PokemonGlobal.battlingSpawnedPokemon = false
	  pbResetTempAfterBattle()
	  end



     end
	  return
	  else
      dir = inputDetection(dir,loopamt,loops,baddir,pokedir)
	  end

















    end

	   
	   
	   
	   
	
    if dir != 0 && dir != baddir && dir != pokedir && $game_player.can_move_in_direction?(dir)
	 if $player.playershoes == :DASHBOOTS && $player.playerstamina>19
	amt.times do
    event.move_forward
    end
	elsif $player.playerstamina>9
	 pbMoveRoute($game_player, [PBMoveRoute::ScriptAsync, "move_generic(#{dir}, true)"]) #PBMoveRoute::Wait, 2
	amt.times do
    event.move_forward
    end
	decreaseStamina(10)
	else
	 pbExclaim($game_player,48)
	 decreaseStamina($player.playerstamina)
	 endTurn(event,rate,backattack,@sideattack,@controlleddir,dir,baddir,pokedir,amt)
	 end

	else 
    endTurn(event,rate,backattack,@sideattack,@controlleddir,dir,baddir,pokedir,amt)
 end
   
    
 
 
 end

end

def get_target_player(source)

event = pbDetectTarget(source,false)
if !event.nil?
return event
else
return nil
end
end