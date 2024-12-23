



class OverworldCombat


def wild_should_attack?(opponent)
 return false if opponent.attacked_last_call==true
 return false if opponent.battle_timer>0
 return true if $game_temp.bossfight==true
 puts "hi"
 attack_chance = rand(100)
 rate = 36
 rate*=1.5 if opponent.pokemon.is_aggressive?
 
 return attack_chance<=rate
end

def update_package
  Graphics.update           # Updates the screen and game visuals
  Input.update              # Checks for player input
  $scene.update
end

def grace_period(amt)
  loops = 0
  loop do
    update_package
	 break if loops==amt
    loops+=1
  
  end
end

def opponentChoice(attacker,target,distance,bonus=0,type=:DEFAULT)
result = false
@hard_hitting =  bonus

attacker.cannot_move=true if defined?(attacker.cannot_move)
loop do
  update_package
   should = pbShouldAttack?(attacker,target)
  if should
   
    move = chooseMove(attacker,target,distance)

	 if move!=false && !move.nil?
	   break if attacker.is_a?(Game_PokeEvent) && attacker.battle_timer>0 && type!=:SURROUNDING
	   next if attacker.attacking==true if defined?(attacker.attacking)
	   next if attacker.attacking==true if defined?(attacker.attacking)
     if move.category == 0
	   next if attacker.attacking==true if defined?(attacker.attacking)
	  if distance==1 
         attacker.attacking=true if defined?(attacker.cannot_move)
	   result = move_physical_close(attacker,target,move)
	  elsif $game_temp.bossfight=true
         attacker.attacking=true if defined?(attacker.cannot_move)
	   result = move_physical_close(attacker,target,move)
	  else
         attacker.attacking=true if defined?(attacker.cannot_move)
	   result = move_physical(attacker,target,move)
	  end
	 elsif move.category == 1
         attacker.attacking=true if defined?(attacker.cannot_move)
	   result = move_special(attacker,target,move)
	 else
	   next if attacker.attacking==true if defined?(attacker.attacking)
         attacker.attacking=true if defined?(attacker.cannot_move)
	   result = move_other(attacker,target,move)
	 end
     end
       attacker.attacking==false if defined?(attacker.attacking)
     break
  else
   break
  end
  

end

attacker.cannot_move=false if defined?(attacker.cannot_move)
return result
end

def movement_attack(attacker,target,distance)
 	 return if @currentlyinbattle==true
	 result = false
 	 @currentlyinbattle=true
 	 get_overworld_pokemon
	 start_glow(attacker)
 	 turning_prep(attacker,target)
 	 result = opponentChoice(attacker,target,distance,3)
 	 @currentlyinbattle=false
	 return result
end

def ov_combat_loop(opponent)
 	 return if status_checks(opponent)==true
 	 return if opponent.dont_attack==true
    return if $PokemonGlobal.fishing == true
    return if $game_temp.in_menu == true
    return if $game_temp.message_window_showing == true && $PokemonGlobal.alternate_control_mode==false
	theresult = false
	duris = wild_should_attack?(opponent)
	if duris
	 addEnemy(opponent.id,opponent)
	 opponent.dont_attack = true
 	 get_overworld_pokemon
 	 target,distance = get_distance(opponent)
	 
	 
    
	 return if distance>opponent.counter
 	 return if target.nil?
	 
     opponent.move_type_toward_event(target)
	 @backattack,@sideattack,@baddir = getdirissues(opponent,@controlled)
 	 theresult = opponentChoice(opponent,target,distance)
 	 opponent.battle_timer=opponent.get_battle_timer if opponent.battle_timer==0
 	 opponent.dont_attack = false
 	 @turn+=1
	 
    set_bgm 
	 opponent.times_not_attacking=0
	 
	 
	 if theresult==true
	 opponent.attacked_last_call=true
 	 opponent.battle_timer=opponent.get_battle_timer
	 opponent.remaining_steps+=1
	 end


	 
	 
	 
	 
	 
	elsif opponent.attacked_last_call==true
	 opponent.attacked_last_call=false
	 opponent.battle_timer-=1
	 
	 
	 
	 
	 
	elsif opponent.attacked_last_call==false
	
	
	
	
	 opponent.times_not_attacking+=1
	 opponent.battle_timer-=opponent.times_not_attacking
	 opponent.battle_timer= 0 if opponent.battle_timer<0
	 opponent.times_not_attacking=0



	 
	end


end


end