#===============================================================================
# Move Calculations
#===============================================================================
class OverworldCombat #Move Calculations

def can_choose_move?(event,move,showMessages=false)
  pkmn = event.pokemon
  if move.pp == 0 && move.total_pp > 0
	  sideDisplay("There's no PP left for this move!") if showMessages
	#pbMessage("\\ts[]" + (_INTL"There's no PP left for this move!\\wtnp[30]")) if showMessages
    return false
  end
  if event.effects[PBEffects::Encore]>0
    return false
  end
  if event.effects[PBEffects::Disable]>0
    return false
  end
  if event.effects[PBEffects::Taunt] >0
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




def chooseMove(attacker,target,distance)
   skill=(($PokemonSystem.difficulty+1)*$PokemonSystem.difficultymodifier)+(rand(80)+1)	
   potato = []
   potato2 = []
   attacker.pokemon.moves.each do |m|
      duris = get_ov_move_score(m,attacker.pokemon,target,skill,distance)
      if can_choose_move?(attacker,m)
      potato << duris
	  else
      potato << 0
	  end
   end

   attacker.pokemon.moves2.each do |m|
      duris = get_ov_move_score(m,attacker.pokemon,target,skill,distance)
      if can_choose_move?(attacker,m)
      potato2 << duris
	  else
      potato2 << 0
	  end
   end
   if potato.empty?
      potato << 0
   end
   if potato2.empty?
      potato2 << 0
   end
   largest = potato.max
   largest2 = potato2.max
   largeroftwo = [largest,largest2].max
   if largeroftwo==0
    return false
   else
   max_index1 = [largest,largest2].index(largeroftwo)
    if max_index1==0
   max_index = potato.index(largest)
   return attacker.pokemon.moves[max_index]
    else
   max_index = potato2.index(largest2)
   return attacker.pokemon.moves2[max_index]
    end
   end

end

def sight_line(seer)
     counter_match = seer.name.match(/counter\(\d+\)/)
	 counter = counter_match[0] if counter_match
	 number_match = counter.match(/\d+/) if counter
	 number = number_match[0] if number_match

  return number.to_i if number
  return 3 
end

def move_physical(attacker,target,move,type=:DEFAULT)
      puts "1.#{move.name}"
	  attacker.cannot_move=false if defined?(attacker.cannot_move)
      turning_prep(attacker,target)
	  amt = sight_line(attacker)
	  amt.times do |i|
	  attacker.move_to_another_event(target)
      attacker.turn_toward_event(target)
	  end 
	  moving = true
     start_coord,landing_coord = getLandingCoords(amt,attacker)
     startx = start_coord[0]
      starty = start_coord[1]
	  moving = $game_map.check_event_and_adjacents2(attacker, target)
	    puts "#{attacker.pokemon.name} is trying to move and the result? #{moving}" if attacker.battle_timer<1
	  if moving
	  attacker.cannot_move=true if defined?(attacker.cannot_move)
	  if outSpeeds?(attacker,target) #Player Outspeeds
		if (nutarget = who_am_i_hitting(attacker,target,false))
	       sideDisplay("#{attacker.pokemon.name} is rearing back!!") if !target.is_a?(Game_PokeEvent)
		   return false if nutarget==false
	   start_glow(attacker)
		   if nutarget.is_a?(Array)
		     nutarget.each do |target2|
			   update_package if type!=:DEFAULT
			   offensive_turn_finishing(attacker,target2,move)
			 end
		   else
	      return offensive_turn_finishing(attacker,nutarget,move)
		   end
        else
		  return
		end
	  else
	    sideDisplay("#{attacker.pokemon.name} was outsped by #{target.pokemon.name}!!") if !target.is_a?(Game_PokeEvent)
	    pbSEPlay("phenomenon_grass")
		if (nutarget = who_am_i_hitting(attacker,target,true))
		   return false if nutarget==false
		   return false if target==nutarget
	   start_glow(attacker)
		   if nutarget.is_a?(Array)
		     nutarget.each do |target2|
			   update_package if type!=:DEFAULT
			   offensive_turn_finishing(attacker,target2,move)
			 end
		   else
	      return offensive_turn_finishing(attacker,nutarget,move)
		   end



        else
		  return
		end
     end
      end
end


def move_physical_close(attacker,target,move,type=:DEFAULT)
      puts "2.#{move.name}"
      turning_prep(attacker,target)
     start_coord,landing_coord = getLandingCoords(1,attacker)
     startx = start_coord[0]
      starty = start_coord[1]
	  moving = $game_map.check_event_and_adjacents2(attacker, target)
	  if moving
	  if outSpeeds?(attacker,target) #Player Outspeeds
		if (nutarget = who_am_i_hitting(attacker,target,false))
		   return false if nutarget==false
	      start_glow(attacker)
		   if nutarget.is_a?(Array)
		     nutarget.each do |target2|
			   update_package if type!=:DEFAULT
			   offensive_turn_finishing(attacker,target2,move)
			 end
		   else
	      return offensive_turn_finishing(attacker,nutarget,move)
		   end
        else
		  return
		end
	  else
	    sideDisplay("#{attacker.pokemon.name} was outsped by #{target.pokemon.name}!!") if !target.is_a?(Game_PokeEvent)
	    pbSEPlay("phenomenon_grass")
		if (nutarget = who_am_i_hitting(attacker,target,true))
		   return false if nutarget==false
		   return false if target==nutarget
	       start_glow(attacker)
		   if nutarget.is_a?(Array)
		     nutarget.each do |target2|
			   update_package if type!=:DEFAULT
			   offensive_turn_finishing(attacker,target2,move)
			 end
		   else
	      return offensive_turn_finishing(attacker,nutarget,move)
		   end



        else
		  return
		end
     end
     end
end


def move_special(attacker,target,move,type=:DEFAULT)
	  #pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} is gathering energy!\\wtnp[10]"))
      turning_prep(attacker,target)
      puts "3. #{move.name}"
	  if outSpeeds?(attacker,target) #Player Outspeeds
		if (nutarget = who_am_i_hitting(attacker,target,false))
		   return false if nutarget==false
	   start_glow(attacker)
	      sideDisplay("#{attacker.pokemon.name} is gathering energy!") if !target.is_a?(Game_PokeEvent)
		   if nutarget.is_a?(Array)
		     nutarget.each do |target2|
			   update_package if type!=:DEFAULT
			   offensive_turn_finishing(attacker,target2,move)
			 end
		   else
	      return offensive_turn_finishing(attacker,nutarget,move)
		   end
        else
		  return
		end
	  else
	    sideDisplay("#{attacker.pokemon.name} was outsped by #{target.pokemon.name}!!") if !target.is_a?(Game_PokeEvent)
	    pbSEPlay("phenomenon_grass")
		if (nutarget = who_am_i_hitting(attacker,target,true))
		   return false if nutarget==false
		   return false if target==nutarget
	   start_glow(attacker)
	      sideDisplay("#{attacker.pokemon.name} is gathering energy!")
		   if nutarget.is_a?(Array)
		     nutarget.each do |target2|
			   update_package if type!=:DEFAULT
			   offensive_turn_finishing(attacker,target2,move)
			 end
		   else
	      return offensive_turn_finishing(attacker,nutarget,move)
		   end



        else
		  return
		end
     end

end


def move_other(attacker,target,move,type=:DEFAULT)
      turning_prep(attacker,target)
	  sideDisplay("#{attacker.pokemon.name} focused!")if !target.is_a?(Game_PokeEvent)
	  #pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} focused!\\wtnp[10]"))
      return false
end


def offensive_turn_finishing(attacker,target,move,evasionbonus=0)
   accuracy   = move.accuracy
   accbonus=0
   if attacker.stages.key?(:ACCURACY)
    
   end
	#pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} used #{move.name}!\\wtnp[10]"))
    will_hit = rand(100)+($player.shoespeed/2) < (accuracy+accbonus) if target == $game_player
    will_hit = rand(100)+evasionbonus < (accuracy+accbonus) if target != $game_player
   
    move.record_move_use(attacker.pokemon, target.pokemon)
	#if will_hit==true
	  move.pp -= 1
	  move.pp = 0 if move.pp<0
	    
       is_hitting(attacker,target,move)
   @currentlyinbattle = false
	   return true
    #else
	#  sideDisplay("#{attacker.pokemon.name} missed!")
    #  pbSEPlay("Miss")
	  #pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} missed!\\wtnp[10]"))
	#  return false
    #end
   
   
   
   

end







 def is_hitting(attacker,target,move) 
    
   sideDisplay("#{attacker.pokemon.name} used #{move.name}!") if !target.is_a?(Game_PokeEvent)
     puts "#{attacker.pokemon.name} used #{move.name} - #{move.category}! (Accuracy: #{move.accuracy}, Base Power: #{move.base_damage})"
	  multiplier = 1
	  multiplier = 1.5 if @backattack
	  multiplier = 1.25 if @sideattack
	   if attacker.is_a?(Game_PokeEventA)
	  return if attacker.attack_opportunity>0
	   end
	   sound_from_move(move.id,attacker.pokemon)
 	if move.id == :EARTHQUAKE || move.id == :MAGNITUDE
     counter_match = attacker.name.match(/counter\(\d+\)/)
	 counter = counter_match[0] if counter_match
	 number_match = counter.match(/\d+/) if counter
	 number = number_match[0] if number_match
	 currentDistance = number if number
	 results = get_events_in(currentDistance,attacker.x,attacker.y)
	 results.each do |target|
     thedamage = getDamager(attacker,target,move,multiplier)


	 if target == $game_player
		pbSEPlay("Battle damage super") if @backattack
		pbSEPlay("Battle damage normal") if @sideattack
		pbSEPlay("Battle damage weak") if !@sideattack && !@backattack
		pbWait(6)
		pbExclaim($game_player,17) if $player.playerhealth >= 80
		pbExclaim($game_player,16) if $player.playerhealth >= 50 && $player.playerhealth < 80
		pbExclaim($game_player,15) if $player.playerhealth >= 25 && $player.playerhealth < 50
        pbExclaim($game_player,14) if $player.playerhealth <= 24
	    if rand(255)+1 < 16 && $PokemonGlobal.in_dungeon==false && $game_temp.bossfight==false && target == $game_player && $player.playerhealth-thedamage<=0
          damagePlayer($player.playerhealth-1,true)
	      sideDisplay("#{attacker.pokemon.name} knocked #{$player.name} down!")
	      #pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} knocked #{$player.name} down!\\wtnp[10]"))
	      if true
	      $game_temp.encounter_type = $game_temp.encounter_type
	      pbStoreTempForBattle()
	      $PokemonGlobal.battlingSpawnedPokemon = true
	      $game_temp.in_safari = true
	      pbSingleOrDoubleWildBattle($game_map.map_id, attacker.x, attacker.y, attacker.pokemon)
	      $game_temp.in_safari = false
	      $PokemonGlobal.battlingSpawnedPokemon = false
	      pbResetTempAfterBattle()
          attacker.removeThisEventfromMap
	      end
       else
	     if thedamage>$player.playerhealth && $player.playerhealth==$player.playermaxhealth
		   thedamage=$player.playerhealth-1
		 end
        damagePlayer(thedamage,true)
       end









     else 
		pbSEPlay("Battle damage super") if @backattack
		pbSEPlay("Battle damage normal") if @sideattack
		pbSEPlay("Battle damage weak") if !@sideattack && !@backattack
	   if attacker.is_a?(Game_PokeEventA)
	  return if attacker.attack_opportunity>0
	   end
	  start_attacked_glow(target,attacker)
	  returneffects = applyStatus(attacker,target,move,attacker.pokemon,target.pokemon,thedamage) if rand(100) < 26
	  thedamage = returneffects[:ABSOLUTEDAMAGE] if returneffects[:ABSOLUTEDAMAGE]
	 
	  target.angry_at << attacker if defined?(target.angry_at)
	  damagePokemon(target,thedamage)


	 end

 
 
	 
	 end
  

  else
     thedamage = getDamager(attacker,target,move,multiplier)

	 if target == $game_player
		pbSEPlay("Battle damage super") if @backattack
		pbSEPlay("Battle damage normal") if @sideattack
		pbSEPlay("Battle damage weak") if !@sideattack && !@backattack
		pbWait(6)
		pbExclaim($game_player,17) if $player.playerhealth >= 80
		pbExclaim($game_player,16) if $player.playerhealth >= 50 && $player.playerhealth < 80
		pbExclaim($game_player,15) if $player.playerhealth >= 25 && $player.playerhealth < 50
        pbExclaim($game_player,14) if $player.playerhealth <= 24
	    if rand(255)+1 < 16 && $PokemonGlobal.in_dungeon==false && $game_temp.bossfight==false && target == $game_player && $player.playerhealth-thedamage<=0
          damagePlayer($player.playerhealth-1,true)
		  sideDisplay(_INTL"#{attacker.pokemon.name} knocked #{$player.name} down!")
	      #pbMessage("\\ts[]" + 
	      if true
	      $game_temp.encounter_type = $game_temp.encounter_type
	      pbStoreTempForBattle()
	      $PokemonGlobal.battlingSpawnedPokemon = true
	      $game_temp.in_safari = true
	      pbSingleOrDoubleWildBattle($game_map.map_id, attacker.x, attacker.y, attacker.pokemon)
	      $game_temp.in_safari = false
	      $PokemonGlobal.battlingSpawnedPokemon = false
	      pbResetTempAfterBattle()
          attacker.removeThisEventfromMap
	      end
       else
	     if thedamage>$player.playerhealth && $player.playerhealth==$player.playermaxhealth
		   thedamage=$player.playerhealth-1
		 end
	     if thedamage>$player.playerhealth && $player.playerhealth==$player.playermaxhealth
		   thedamage=$player.playerhealth-1
		 end
        damagePlayer(thedamage,true)
       end









     else 
	 
		pbSEPlay("Battle damage super") if @backattack
		pbSEPlay("Battle damage normal") if @sideattack
		pbSEPlay("Battle damage weak") if !@sideattack && !@backattack
	   if attacker.is_a?(Game_PokeEventA)
	  return if attacker.attack_opportunity>0
	   end
	  start_attacked_glow(target,attacker)
	  returneffects = applyStatus(attacker,target,move,attacker.pokemon,target.pokemon,thedamage) if rand(100) < 26
	  
	   target.angry_at << attacker if defined?(target.angry_at)
	  damagePokemon(target,thedamage)


	 end

 
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
	      score += 40
	   end

	   if move.function_code.include?("ParalyzeTarget" )
	      score += 40
	   end
	   
	   
	   if move.function_code.include?("PoisonTarget")
	      score += 40
	   end


	   
	   if move.function_code.include?("BurnTarget")
	      score += 40
	   end


	   
	   if move.function_code.include?("FreezeTarget")
	      score += 40
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
		  if target.is_a?(Pokemon)
        score += 20 if target.item
		  end
	   end
	   if move.function_code == "DestroyTargetBerryOrGem"
	   score += 30
	   end
	   if move.function_code == "HealUserHalfOfTotalHP"
	    score+30
	   end

	   if move.function_code == "FixedDamage20"
	   score += 80
	   end
	   if move.function_code == "FixedDamage40"
	   score += 80
	   end
	   if move.function_code == "FixedDamageHalfTargetHP"
	   score += 80
	   end
	   if move.function_code == "FixedDamageUserLevel"
	   score += 80
	   end
	   


	  end

	   if move.function_code == "UserFaintsExplosive"
	    score -= user.hp * 100 / user.totalhp
	   end



        score -= 40 if move.category == 2
        score += 80 if move.category == 1 && distance>1 #SPECIAL - HITTING WITH THE WAPOW
        score += 40 if move.category == 1 && distance==1 #SPECIAL - HITTING WITH THE WAPOW
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
	 if rand(2)==0
	score+= rand(30)
	 else
	score-= rand(30)
	 end
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

def doesStatus?(move)
   return true if move.function_code.include?("SleepTarget") || move.function_code.include?("ParalyzeTarget") || move.function_code.include?("PoisonTarget") ||
   move.function_code.include?("BurnTarget") || move.function_code.include?("FreezeTarget") || move.function_code == "GiveUserStatusToTarget" || 
   move.function_code == "BindTarget"
   return false
end
def pbGetAttackStat2(user,move)
    if move.category == 1 
      return user.spatk
    end
    return user.attack
  end



end