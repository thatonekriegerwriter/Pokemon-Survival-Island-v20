



class OverworldCombat


def wild_should_attack?(opponent)
 return false if opponent.attacked_last_call==true
 return false if opponent.battle_timer>0
 return true if $game_temp.bossfight==true
 attack_chance = rand(90)+10
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

def opponentChoice(attacker,target,target_x,target_y,distance,bonus=0,type=:DEFAULT)
result = false
@hard_hitting =  bonus

attacker.cannot_move=true if defined?(attacker.cannot_move)
loop do
  update_package
   should = pbShouldAttack?(attacker,target)
   previousmove=false
   attempts=0
	puts "#{attacker.pokemon.name} reconsiders the opportunity? #{should}" if attacker.battle_timer<1
  if should
   
    move = chooseMove(attacker,target,distance)

	 if move!=false && !move.nil? && move!=previousmove
	   break if attacker.is_a?(Game_PokeEvent) && attacker.battle_timer>0 && type!=:SURROUNDING
	   next if attacker.attacking==true if defined?(attacker.attacking)
	   next if attacker.attacking==true if defined?(attacker.attacking)
     if move.category == 0
	   next if attacker.attacking==true if defined?(attacker.attacking)
	    puts "#{attacker.pokemon.name} can move to attack? #{distance<=sight_line(attacker) && distance>1}" if attacker.battle_timer<1
	  if distance==1 
         attacker.attacking=true if defined?(attacker.cannot_move)
	   result = move_physical_close(attacker,target,move,distance,target_x,target_y)
	  elsif distance<=sight_line(attacker) && distance>1
	     
         attacker.attacking=true if defined?(attacker.cannot_move)
	   result = move_physical(attacker,target,move,distance,target_x,target_y)
	  elsif $game_temp.bossfight==true
         attacker.attacking=true if defined?(attacker.cannot_move)
	   result = move_physical_close(attacker,target,move,distance,target_x,target_y)
	  end
	 elsif move.category == 1
         attacker.attacking=true if defined?(attacker.cannot_move)
	   result = move_special(attacker,target,move,distance,target_x,target_y)
	 else
	   next if attacker.attacking==true if defined?(attacker.attacking)
         attacker.attacking=true if defined?(attacker.cannot_move)
	   result = move_other(attacker,target,move,distance,target_x,target_y)
	 end
    
     attacker.attacking==false if defined?(attacker.attacking)
     break
	elsif attempts>2
	 break
    else
	  previousmove = move
	  attempts+=1
    end
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
	 target_x = target.x.dup
	 target_y = target.y.dup
 	 turning_prep(attacker,target)
 	 result = opponentChoice(attacker,target,target_x,target_y,distance,3)
 	 @currentlyinbattle=false
	 return result
end

def ov_combat_loop(opponent)
    return if !defined?(opponent.pokemon)
 	 return if status_checks(opponent)==true
 	 return if opponent.dont_attack==true
    return if $PokemonGlobal.fishing == true
    return if $game_temp.in_menu == true
    return if $game_temp.message_window_showing == true && $PokemonGlobal.alternate_control_mode==false
	
	
	theresult = false
	duris = wild_should_attack?(opponent)
	#puts "#{opponent.pokemon.name} has an opportunity? #{duris}" if opponent.battle_timer<1
	
	
	if duris
	 addEnemy(opponent.id,opponent)
	 opponent.dont_attack = true
 	 get_overworld_pokemon
 	 target,distance = get_distance(opponent)
	 #puts "#{opponent.pokemon.name} is #{distance} tiles away from #{target.pokemon.name}" if distance>0
	 
    if target.nil?
 	 opponent.dont_attack = false
 	 return 
	 end
	 target_x = target.x
	 target_y = target.y
	 puts "#{opponent.pokemon.name} is targeting #{target.pokemon.name}."
     #opponent.move_type_toward_event(target)
	 
     opponent.turn_toward_event(target)
     if distance<1
 	 opponent.dont_attack = false
 	 return 
	 end
 	 theresult = opponentChoice(opponent,target,target_x,target_y,distance)
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