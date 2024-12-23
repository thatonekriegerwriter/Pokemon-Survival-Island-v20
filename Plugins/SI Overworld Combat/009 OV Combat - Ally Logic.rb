class OverworldCombat

  
def check_battle_obedience(event,directing=false)
  pkmn = event.pokemon
  return true if event.is_a?(Game_PokeEvent)
  return disobeying(pkmn,directing) if rand(100)+1<= pkmn.calculate_disobedience_chance(pkmn.loyalty,pkmn.happiness)

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
   return if move.category == 2
	 if user.attack_opportunity>0
	  sideDisplay("#{user.pokemon.name} is too winded to use #{move.name}!")
	  return 
	 end
	 puts user.id
	 puts user
	 puts user.pokemon.name
   if addAlly(user.id,user)
   pokemon = user
   target = target
	pokemon.add_target(target.id,target)
   accuracy   = move.accuracy
   accbonus = 0
   will_hit = rand(100) < (accuracy+accbonus)
   @backattack,@sideattack,@baddir = getdirissues(target.direction,user.direction)
   return if move.pp == 0
   start_glow(user) if will_hit
   
   
   
	  return if user.attack_opportunity>0
     if move.category == 0 && distance==1
	 
	 
	    #pbMessage("\\ts[]" + (_INTL"#{pokemon.name} used #{move.name}!\\wtnp[10]"))
	 
	 
	 
	 
	 
	 
	 
	 
	 
    if will_hit==true
	  move.pp -= 1
	  move.pp = 0 if move.pp<0
	  return if user.attack_opportunity>0
       is_hitting(user,target,move)
	    
	    if target.is_a?(Game_PokeEvent)
		target.angry_at << user if !target.angry_at.include?(user)
		target.battle_timer-=5 if target.battle_timer>0
		target.battle_timer=0 if target.battle_timer<0
		end
    else
	      sideDisplay("#{pokemon.pokemon.name} missed!")
      pbSEPlay("Miss")
	  #pbMessage("\\ts[]" + (_INTL"#{pokemon.name} missed!\\wtnp[10]"))
    end


	 
	 
	 
	 
	 
	 
     
	 elsif move.category == 0 && distance>1
	 
	 
	  sideDisplay("#{pokemon.pokemon.name} is too far away to use #{move.name}!")
	 
	 
	 
	 
	 
	    
	 elsif move.category == 1
	 
	  sideDisplay("#{pokemon.pokemon.name} is gathering energy!!")
	 
	 
	 
    if will_hit==true
	  move.pp -= 1
	  move.pp = 0 if move.pp<0
	  return if user.attack_opportunity>0
       is_hitting(user,target,move)
	   
	    if target.is_a?(Game_PokeEvent)
		target.angry_at << user if !target.angry_at.include?(user)
		target.battle_timer-=5 if target.battle_timer>0
		target.battle_timer=0 if target.battle_timer<0
		end
    else
	  sideDisplay("#{pokemon.pokemon.name} missed!")
      pbSEPlay("Miss")
    end


	 
	 
	 elsif move.category == 2
    if will_hit==true
	  move.pp -= 1
	  move.pp = 0 if move.pp<0
	  if doesStatus?(move)
	  sideDisplay("#{pokemon.pokemon.name} used #{move.name}!")
	  if will_hit==true
	  if target.status_turns.nil?
		 target.status_turns=0
		end
		target.status_turns-=1 if  target.status_turns>0
		if target.status_turns==0
		 target.status=:NONE
		end
	 returneffects = applyStatus(pokemon,target,move,pokemon.pokemon,target.pokemon,0) if rand(100) < 26
	  end
	  else
	  sideDisplay("#{move.name} has not been implemented!")
	  return
	  end
	 end
	 end



   elsif hasAlly?(user.id,user)
   
   
   pokemon = user
   target = target
   accuracy   = move.accuracy
   accbonus = 0
   will_hit = rand(100) < (accuracy+accbonus)
   @backattack,@sideattack,@baddir = getdirissues(target,user)
   
   
   
   
   
	  return if user.attack_opportunity>0
     if move.category == 0 && distance==1
	 
	 
	 
	 
	 
	    #pbMessage("\\ts[]" + (_INTL"#{pokemon.name} used #{move.name}!\\wtnp[10]"))
	 
	 
	 
	 
	 
	 
	 
	 
	 
    if will_hit==true
	  move.pp -= 1
	  move.pp = 0 if move.pp<0
	  #return if move.pp == 0
	  return if user.attack_opportunity>0
       is_hitting(user,target,move)
	    
	    if target.is_a?(Game_PokeEvent)
		target.angry_at << user if !target.angry_at.include?(user)
		target.battle_timer-=5 if target.battle_timer>0
		target.battle_timer=0 if target.battle_timer<0
		end
    else
	  sideDisplay("#{pokemon.pokemon.name} missed!")
      pbSEPlay("Miss")
	  #pbMessage("\\ts[]" + (_INTL"#{pokemon.name} missed!\\wtnp[10]"))
    end


	 
	 
	 
	 
	 
	 
     
	 elsif move.category == 0 && distance>1
	 
	 
	  sideDisplay("#{pokemon.pokemon.name} is too far away to use #{move.name}!")
	  user.attack_opportunity=0
	  return
	 
	    #pbMessage("\\ts[]" + (_INTL"#{pokemon.name} is too far away to use #{move.name}!\\wtnp[10]"))
	 
	 
	 
	 
	    
	 elsif move.category == 1
	 
	 
	 
	  sideDisplay("#{pokemon.pokemon.name} is gathering energy!")

	 
    if will_hit==true
	  move.pp -= 1
	  move.pp = 0 if move.pp<0
	  return if user.attack_opportunity>0
       is_hitting(user,target,move)
	   
	    if target.is_a?(Game_PokeEvent)
		target.angry_at << user if !target.angry_at.include?(user)
		target.battle_timer-=5 if target.battle_timer>0
		target.battle_timer=0 if target.battle_timer<0
		end
    else
	  sideDisplay("#{pokemon.pokemon.name} missed!")
      pbSEPlay("Miss")
    end


	 
	 
	 elsif move.category == 2
    if will_hit==true
	  move.pp -= 1
	  move.pp = 0 if move.pp<0
	  if doesStatus?(move)
	  if will_hit==true
	  if target.status_turns.nil?
		 target.status_turns=0
		end
		target.status_turns-=1 if  target.status_turns>0
		if target.status_turns==0
		 target.status=:NONE
		end
	 returneffects = applyStatus(pokemon,target,move,pokemon,target,0) if rand(100) < 26
	  end
	  else
	  sideDisplay("#{move.name} has not been implemented!")
	  user.attack_opportunity=0
	  return
	  end
	 end
	 end



   else
   
   
   
   
   
     raise _INTL("Could not add \"{1}\".", user.pokemon.name)
	 
	 
	 
   end
   user.attack_opportunity+=30
   
       target.battle_timer = 5 if target.is_a?(Game_PokeEvent)
	   #puts "Battle Timer: #{target.battle_timer}"
	 target.remaining_steps+=1 if target.remaining_steps
end

def autobattle(attacker) 
   
end


end

