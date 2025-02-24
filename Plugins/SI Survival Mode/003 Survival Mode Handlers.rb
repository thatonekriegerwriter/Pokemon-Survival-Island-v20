

  EventHandlers.add(:on_frame_update, :iframes,
  proc {
  if $player.iframes>0
    $player.iframes-=1
  end
  $player.party.each do |pkmn|
    next if pkmn.nil?
    if pkmn&.iframes>0
      pkmn&.iframes-=1
    end
  end
  }
)


EventHandlers.add(:on_player_step_taken, :nurse_healing,
  proc {
   next if $player.playerwater < 1
   next if $player.playersleep < 1
   next if $player.playerfood < 1
   next if $player.playerfood < 1
   next if !$player.is_it_this_class?(:NURSE,false)
     increaseHealth(1)



  }
)


  EventHandlers.add(:on_frame_update, :sleepstepsplayer,
  proc {
  next if $PokemonGlobal.in_dungeon==true
  next if $player.playersleep == 0
  
	 time_now = pbGetTimeNow
	 rain_delta = time_now.to_i - $player.time_last_slept
	 tps = 0.25
	 tps = 0.5 if $player.playerstamina >= 0.5 * $player.playermaxstamina
	 tps = 1 if $player.playerstamina >= 0.9 * $player.playermaxstamina
	 tps = 4 if $game_temp.in_temple==true
	# puts "#{rain_delta} = #{time_now.to_i} - #{$player.time_last_slept} < #{(tps * 240)} and is #{rain_delta < (tps * 240)}"
    next if rain_delta < (tps * 3600)
	  time = rain_delta/3600
     puts "Decrease Sleep"
	  time = [time,1].max
    decreaseSleep(8 * time)
    $player.time_last_slept = time_now.to_i+rand(1800)+1

  
  
  }
)

  EventHandlers.add(:on_frame_update, :foodstepsplayer,
  proc {
  next if $PokemonGlobal.in_dungeon==true
  next if $player.playersaturation > 0
  next if $player.playerfood == 0
  
	 time_now = pbGetTimeNow
	 rain_delta = time_now.to_i - $player.time_last_food
	 tps = 0.25
	 tps = 0.5 if $player.playerstamina >= 0.5 * $player.playermaxstamina
	 tps = 1 if $player.playerstamina >= 0.9 * $player.playermaxstamina
	 tps = 4 if $game_temp.in_temple==true
	 
	 #puts "#{rain_delta} = #{time_now.to_i} - #{$player.time_last_food} < #{(tps * 120)} and is #{rain_delta < (tps * 120)}"
    next if rain_delta < (tps * 1800)
	  time = rain_delta/3600
    puts "Decrease Food"
	  time = [time,1].max
    decreaseFood(6 * time)
    $player.time_last_food = time_now.to_i+rand(900)+1
  }
)

  EventHandlers.add(:on_frame_update, :waterstepsplayer,
  proc {
  next if $PokemonGlobal.in_dungeon==true
  next if $player.playersaturation > 0
  next if $player.playerwater == 0
  
	 time_now = pbGetTimeNow
	 rain_delta = time_now.to_i - $player.time_last_watered
	 tps = 0.25
	 tps = 0.5 if $player.playerstamina >= 0.5 * $player.playermaxstamina
	 tps = 1 if $player.playerstamina >= 0.9 * $player.playermaxstamina
	 tps = 4 if $game_temp.in_temple==true
	# puts "#{rain_delta} = #{time_now.to_i} - #{$player.time_last_watered} < #{(tps * 120)} and is #{rain_delta < (tps * 120)}"
    next if rain_delta < (tps * 1800)
	  time = rain_delta/3600
     puts "Decrease Water"
	  time = [time,1].max
    decreaseWater(6 * time)
    $player.time_last_watered = time_now.to_i+rand(900)+1
  
  }
)



  EventHandlers.add(:on_frame_update, :saturationstepsplayer,
  proc {
  next if $PokemonGlobal.in_dungeon==true
  next if $player.playersaturation == 0
	 time_now = pbGetTimeNow
	 rain_delta = time_now.to_i - $player.time_last_saturated
	 tps = 0.25
	 tps = 0.5 if $player.playerstamina >= 0.5 * $player.playermaxstamina
	 tps = 1 if $player.playerstamina >= 0.9 * $player.playermaxstamina
	 tps = 4 if $game_temp.in_temple==true
	 #puts "#{rain_delta} = #{time_now.to_i} - #{$player.time_last_saturated} < #{(tps * 80)} and is #{rain_delta < (tps * 80)}"
    next if rain_delta < (tps * 1200)
	  time = rain_delta/3600
     puts "Decrease Saturation"
	  time = [time,1].max
    decreaseSaturation(3 * time)
    $player.time_last_saturated = time_now.to_i+rand(600)+1
  
  
  }
)


  EventHandlers.add(:on_frame_update, :stamina,
  proc {
  next if $PokemonGlobal.in_dungeon==true
    the_stamina_functions
	 
    if drain_stamina
	 pbSEPlay("breath") if $player.playerstamina <= ($player.playermaxstamina/10)
	  next 
	 end
	 
	 pbSEPlay("breath") if $player.playerstamina <= ($player.playermaxstamina/10)
    next if $player.playerstamina == $player.playermaxstamina
	 time_now = pbGetTimeNow
	 rain_delta = time_now.to_i - $player.time_last_stamina
	 if $player.playerstamina >= $player.playermaxstamina
	   $player.playerstamina=$player.playermaxstamina
	 next
	 end
    next if rain_delta < 10
	 
	 
	 
    restore_stamina
    $player.time_last_stamina = time_now.to_i
  }
)






  EventHandlers.add(:on_frame_update, :healthplayer,
  proc {
   if $PokemonGlobal.cur_challenge==true && $player.playerhealth<=0
     pbChallengeOver 
	  next
   end
   next if $PokemonGlobal.in_dungeon==true
   next if $game_temp.in_menu
   #next if $game_temp.dead
   
   pbStartOver 
   next if $player.playerhealth<=0 || $player.playermaxhealth2<=0
  
	 time_now = pbGetTimeNow
	 rain_delta = time_now.to_i - $player.time_last_health
    next if rain_delta < 150
   waterchance = rand(50)+1 <= 10
   foodchance = rand(50)+1 <= 10
   sleepchance = rand(50)+1 <= 10
   damaged = 0
    if $player.playerwater < 1 && waterchance
	 pbSEPlay("Drink")
	 pbSEPlay("")
   damaged += 1
   end
    if $player.playersleep < 1 && sleepchance
	 pbSEPlay("Yawn")
   damaged += 1
   end
    if $player.playerfood < 1 && foodchance
	 pbSEPlay("Eat")
   damaged += 1
    end
   $player.time_last_health=time_now.to_i
    next if damaged==0
   damagePlayer(3*(damaged+2)) 
   pbSEPlay("normaldamage")
  }
)

def restore_stamina
 return if $player.running == true
 return if $game_temp.in_menu
  prereqs = !$player.acting && $player.held_item.nil?
  if prereqs
	 if $game_player.moved_this_frame==false && $game_player.moved_last_frame==false
	     if rand(2) == 1
         puts "Increase Stamina - No Moving+"
	      $player.playerstamina+=1
		  end
    elsif $game_player.moved_this_frame==false
	     if rand(10) == 1
         puts "Increase Stamina - No Moving"
	      $player.playerstamina+=3
		  end
	 elsif rand(60) == 1
       puts "Increase Stamina - While Moving"
      $player.playerstamina+=6
	 end



  end
end

def drain_stamina
	   duris = rand(30) == 1
if $game_player.moved_this_frame && !$game_temp.in_menu && $player.running
	return decreaseStamina(4) if duris && ($player.playershoes.id == :NORMALSHOES || $player.playershoes.id == :SEASHOES) && !$player.is_it_this_class?(:TRIATHLETE,false)
	return decreaseStamina(3) if duris && $player.playershoes.id == :MAKESHIFTRUNNINGSHOES && !$player.is_it_this_class?(:TRIATHLETE,false)
	return decreaseStamina(2) if duris && $player.playershoes.id == :RUNNINGSHOES && !$player.is_it_this_class?(:TRIATHLETE,false)
	return decreaseStamina(1) if rand(140) == 1 && $player.is_it_this_class?(:TRIATHLETE,false)
end
return false
end

def the_stamina_functions

    $player.playerstamina = $player.playerstamina.to_f if $player.playerstamina.is_a? Integer
    $player.playermaxstamina = $player.playermaxstamina.to_f if $player.playermaxstamina.is_a? Integer
	$player.playerstaminamod = $player.playerstaminamod.to_f if $player.playerstaminamod.is_a? Integer

	
	$player.playermaxstamina = 100.0 if $player.playermaxstamina.nil?
	
	$player.playerstaminamod = 0.0 if $player.playerstaminamod.nil?

end

def stamina_management_for_ov

  if $PokemonGlobal.in_dungeon==false
  
  
  
  
	





	   duris = rand(30) == 1
   
	
	if $game_player.can_run_unforced? && !$game_temp.in_menu && $player.running
	
	   decreaseStamina(4) if duris && ($player.playershoes.id == :NORMALSHOES || $player.playershoes.id == :SEASHOES) && !$player.is_it_this_class?(:TRIATHLETE,false)
	   decreaseStamina(3) if duris && $player.playershoes.id == :MAKESHIFTRUNNINGSHOES && !$player.is_it_this_class?(:TRIATHLETE,false)
	   decreaseStamina(2) if duris && $player.playershoes.id == :RUNNINGSHOES && !$player.is_it_this_class?(:TRIATHLETE,false)
	   decreaseStamina(1) if rand(140) == 1 && $player.is_it_this_class?(:TRIATHLETE,false)
	   
	   
	else
	end




	   $player.playerstamina = $player.playermaxstamina if $player.playerstamina > $player.playermaxstamina

  end




end



  EventHandlers.add(:on_frame_update, :agestepspkmn,
  proc {
  if $PokemonSystem.survivalmode==0 && Nuzlocke.on? && pbIsWeekday(0)
   indexes = []
    data = Nuzlocke.rules; data = [] if data.nil?
  $player.party.each_with_index do |pkmn, index|
	pkmn.changeAge
	pkmn.changeLifespan("age",pkmn)
    if pkmn.lifespan == 0 
      pkmn.permaFaint=true
      pbMessage(_INTL("{1} has died!"))
      pkmn.hp = 0
	  if data.include?(:PERMADEATH)
	    indexes << index
	  end
	  next
    end
  end
	  if data.include?(:PERMADEATH)
   indexes.each do |index|
     $player.party.delete_at(index)
   
   end
	  end
  end

  }
)



EventHandlers.add(:on_step_taken, :play_walk_sfx,
  proc { |event|
    next if !$scene.is_a?(Scene_Map)
    next if event != $game_player
    currentTag = $game_player.pbTerrainTag
    if currentTag.id == :None
	  pbSEPlay("Dirty")
	elsif currentTag.id == :Grass
	  pbSEPlay("GrassyStep")
	elsif currentTag.id == :Bridge
	  pbSEPlay("woodyStep")
	elsif currentTag.id == :Snow
	  pbSEPlay("snowyStep")
	elsif currentTag.id == :Rock
	  pbSEPlay("stoneStep")
	elsif currentTag.id == :Sand
	    case rand(4)
		 when 0
	  pbSEPlay("sand1",50)
		 when 1
	  pbSEPlay("sand2",50)
		 when 2
	  pbSEPlay("sand3",50)
		 when 3
	  pbSEPlay("sand4",50)
	     else
	  pbSEPlay("sand1",50)
	  end
	elsif currentTag.id == :Beach
	  pbSEPlay("sandyStep",50)
	 else
	  pbSEPlay("Dirty")
    end
  }
)


EventHandlers.add(:on_step_taken, :play_water_sounds,
  proc { |event|
    next if !$scene.is_a?(Scene_Map)
    next if !$game_map.map_id==11
    next if event != $game_player
    if is_near_water($game_player.x, $game_player.y)
	 if !$PokemonGlobal.water_playing
	  pbSEPlay("babbling_brook")
	  $PokemonGlobal.water_playing=true
	 end
	else
	  if $PokemonGlobal.water_playing
	   pbSEStop
	  $PokemonGlobal.water_playing=false
	  
	  end
	end

  }
)


def is_near_water(x, y)
  (-3..3).each do |dx|
    (-3..3).each do |dy|
      if $game_map.terrain_tag(x+dx,y+dy) == GameData::TerrainTag.get(:Water)
        return true
      end
    end
  end
  return false
end


# Kill dead pokemon
EventHandlers.add(:on_step_taken, :kill_party,
  proc { |event|
    next if !$scene.is_a?(Scene_Map)
    next if $PokemonGlobal.stepcount % 4 != 0
	if event == $game_player
	duris = false
	elsif event&.name.include?("PlayerPkmn")
	duris = false
	else
	duris = true
	end
    next if duris
    flashed = false
   indexes = []
    data = Nuzlocke.rules; data = [] if data.nil?
    $player.party.each.each_with_index do |pkmn, index|
	  next if !pkmn.fainted?
	  next if pkmn.dead?
      if !flashed
        pbFlash(Color.new(102, 3, 0, 128), 8)
	     pbSEPlay("dying")
        flashed = true
      end
      pkmn.lifespan -= 3
	  pbShowTipCard(:CRITICALCONDITION) if !pbSeenTipCard?(:CRITICALCONDITION)
	  puts "#{pkmn.name}'s lifespan is now #{pkmn.lifespan} wellness."
      if pkmn.lifespan <= 0
	     pbSEPlay("DeathDQ")
        pkmn.changeHappiness("faint",pkmn)
        pkmn.changeHappiness("powder",pkmn)
        pkmn.changeLoyalty("faint",pkmn)
        pkmn.hp = 0
        pkmn.permaFaint=true
        pbMessage(_INTL("{1} died...", pkmn.name))
	  if data.include?(:PERMADEATH)
	    indexes << index
	  end
      end


    end

	  if data.include?(:PERMADEATH)
   indexes.each do |index|
     $player.party.delete_at(index)
   
   end
	  end
  }
)




# Poison party Pokémon
EventHandlers.add(:on_player_step_taken_can_transfer, :poison_party,
  proc { |handled|
    # handled is an array: [nil]. If [true], a transfer has happened because of
    # this event, so don't do anything that might cause another one
    next if handled[0]
    next if $PokemonGlobal.stepcount % 4 != 0
    flashed = false
    $player.able_party.each do |pkmn|
      next if pkmn.status != :POISON || pkmn.hasAbility?(:IMMUNITY)
      if !flashed
        pbFlash(Color.new(255, 0, 0, 128), 8)
        flashed = true
	     pbSEPlay("SFX_POISONED")
      end
	  damage = 1
      pkmn.hp -= damage
        pkmn.changeHappiness("damaged",pkmn)
        pkmn.changeLoyalty("damaged",pkmn)
      if pkmn.hp > 0 && rand(100)<1
        pkmn.status = :NONE
        sideDisplay(_INTL("{1} survived the poisoning.\\nThe poison faded away!\1", pkmn.name))
        next
      elsif pkmn.hp <= 0
        pkmn.changeHappiness("faint",pkmn)
        pkmn.status = :NONE
	    sideDisplay("#{pkmn.name} fainted from poison!")
      end
    end
  }
)






  EventHandlers.add(:on_frame_update, :levelcap,
  proc {
  case $game_variables[234]
   when 0
    $game_system.level_cap = $game_variables[234]
   when 1
    $game_system.level_cap = $game_variables[234]
   when 2
    $game_system.level_cap = $game_variables[234]
   when 3
    $game_system.level_cap = $game_variables[234]
   when 4
    $game_system.level_cap = $game_variables[234]-1
   when 5
    $game_system.level_cap = $game_variables[234]-1
   when 6
    $game_system.level_cap = $game_variables[234]-1
   when 7
    $game_system.level_cap = $game_variables[234]-1
   when 8
    $game_system.level_cap = $game_variables[234]-1
   when 9
    $game_system.level_cap = $game_variables[234]-1
   when 10
    $game_system.level_cap = $game_variables[234]-1
end
  }
)


MenuHandlers.add(:debug_menu, :kill_me, {
  "name"        => _INTL("Kill me!"),
  "parent"      => :player_menu,
  "description" => _INTL("Kill the player."),
  "effect"      => proc {
    $player.playerhealth = 0
  }
})

MenuHandlers.add(:debug_menu, :set_hp, {
  "name"        => _INTL("Set Health"),
  "parent"      => :player_menu,
  "description" => _INTL("Edit the player's Health."),
  "effect"      => proc {
    params = ChooseNumberParams.new
    params.setRange(0, $player.playermaxhealth)
    $player.playerhealth = (pbMessageChooseNumber(_INTL("Set the player's health."), params)).to_f
  }
})

MenuHandlers.add(:debug_menu, :set_sleep, {
  "name"        => _INTL("Set Sleep"),
  "parent"      => :player_menu,
  "description" => _INTL("Edit the player's Sleep."),
  "effect"      => proc {
    params = ChooseNumberParams.new
    params.setRange(0, $player.playermaxsleep)
    $player.playersleep = (pbMessageChooseNumber(_INTL("Set the player's sleep."), params)).to_f
  }
})

MenuHandlers.add(:debug_menu, :set_water, {
  "name"        => _INTL("Set Water"),
  "parent"      => :player_menu,
  "description" => _INTL("Edit the player's Water."),
  "effect"      => proc {
    params = ChooseNumberParams.new
    params.setRange(0, $player.playermaxwater)
    $player.playerwater = (pbMessageChooseNumber(_INTL("Set the player's water."), params)).to_f
  }
})

MenuHandlers.add(:debug_menu, :set_food, {
  "name"        => _INTL("Set Food"),
  "parent"      => :player_menu,
  "description" => _INTL("Edit the player's Food."),
  "effect"      => proc {
    params = ChooseNumberParams.new
    params.setRange(0, $player.playermaxfood)
    $player.playerfood = (pbMessageChooseNumber(_INTL("Set the player's food."), params)).to_f
  }
})

MenuHandlers.add(:debug_menu, :set_saturation, {
  "name"        => _INTL("Set Saturation"),
  "parent"      => :player_menu,
  "description" => _INTL("Edit the player's Saturation."),
  "effect"      => proc {
    params = ChooseNumberParams.new
    params.setRange(0, 200)
    $player.playersaturation = (pbMessageChooseNumber(_INTL("Set the player's saturation."), params)).to_f
  }
})
