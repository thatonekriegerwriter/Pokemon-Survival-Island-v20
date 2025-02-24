class OverworldCombat

  
def check_battle_obedience(event,directing=false)
  pkmn = event.pokemon
 

  return disobeying(pkmn,directing) if rand(100)+1<= pkmn.calculate_disobedience_chance(pkmn.loyalty,pkmn.happiness)


  disobedient |= !pbHyperModeObedience(choice[2])
  return true if !disobedient
end  

  
def disobeying(pkmn,controlling)
  r = rand(256)
  if pkmn.status == :SLEEP
	  sideDisplay((_INTL"#{pkmn.name} ignored you and continued sleeping."))
      return false
  end
    if r <= 10  && pkmn.status==:NONE
	  pkmn.status=:SLEEP
	  sideDisplay((_INTL"#{pkmn.name} began to nap!"))
      return false
    end
     if r <= 10 && @status != :SLEEP && controlling==false
      sideDisplay(("#{pkmn.name} won't obey! It hurt itself in its confusion!"))
	  pkmn.hp-=rand(25)+5
      return false
    end
    if r <= 20 && r >= 10 && @status != :SLEEP && pkmn.loyalty <= 50 && controlling==false
      injury = rand(10)+2
      sideDisplay(("#{pkmn.name} turned around and attacked you for #{injury} damage!"))
	  damagePlayer(injury)
		pbSEPlay("normaldamage")
      return false 
    end

    if r <= 30 && r >= 20 && @status != :SLEEP && @pokemon.happiness >= 200 && controlling==false
      sideDisplay(("#{pkmn.name} wants you to praise it before it does anything!"))
      return false 
    end
    if r <= 20 && r >= 10 && @status != :SLEEP && pkmn.happiness >= 199 && controlling==false
      sideDisplay(("#{pkmn.name} wants to play!"))
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


def player_pokemonattack(user,target,move,distance)
   if move.pp == 0
	  sideDisplay("#{move.name} does not have enough PP!")
   return 
   end
   #return if !check_battle_obedience(event)
   if user.attack_opportunity>0
	  sideDisplay("#{user.pokemon.name} is too winded to use #{move.name}!")
	  return 
   end
    addAlly(user.id,user) if !hasAlly?(user.id,user)
    pokemon = user
    target = target
	pokemon.add_target(target.id,target)
   accuracy   = move.accuracy
   accbonus = 0
   user_target = move.category == 2 && move.target == :User
   will_hit = rand(100) < (accuracy+accbonus)
   will_hit = true if user_target
   start_glow(user) if will_hit && !user_target
   if !will_hit
      sideDisplay("#{pokemon.pokemon.name} missed!")
      pbSEPlay("Miss")
      user.attack_opportunity+=30
      return
   end
   move.pp -= 1
   move.pp = 0 if move.pp<0 
   pbMessage("\\ts[]" + (_INTL"#{pokemon.name} used #{move.name} with a distance of zero!")) if move.category==0 && distance==0
   sideDisplay("#{pokemon.pokemon.name} began rushing #{target.pokemon.name} down!") if move.category==0 && distance>1
   sideDisplay("#{pokemon.pokemon.name} is gathering energy!") if move.category==1
   sideDisplay("#{pokemon.pokemon.name} focused!") if move.category==2



   
   if move.category!=2
   if move.category==0 and distance>1
      moving = attack_movement(pokemon,target,3)
	  if moving==false
      sideDisplay("#{pokemon.pokemon.name} missed!")
      pbSEPlay("Miss")
      user.attack_opportunity+=30
      return 
	  end
   end
   
   user.last_attacked = target if !user_target
   is_hitting(user,target,move,distance)
   if target.is_a?(Game_PokeEvent)
	target.angry_at << user if !target.angry_at.include?(user)
	target.battle_timer-=5 if target.battle_timer>0
	target.battle_timer=0 if target.battle_timer<0
	target.remaining_steps+=1 if target.remaining_steps
   end
   else
  	  if doesStatus?(move)
	    sideDisplay("#{pokemon.pokemon.name} used #{move.name}!")
	    target.status_turns=0 if target.status_turns.nil?
	    target.status_turns-=1 if  target.status_turns>0
	    target.status=:NONE if target.status_turns==0
	    returneffects = applyStatus(pokemon,target,move,pokemon.pokemon,target.pokemon,0) if rand(100) < 26
	  else
	    sideDisplay("#{move.name} has not been implemented!")
	  end
   end
   
   

   
   user.attack_opportunity+=30
	$hud.createaChargeBar(user) if user.attack_opportunity>=0
   return
end

def autobattle(attacker,target,distance) 

   move = chooseMove(attacker,target,distance)
   player_pokemonattack(attacker,target,move,distance)
end


end

