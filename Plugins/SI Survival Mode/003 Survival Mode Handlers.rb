  EventHandlers.add(:on_frame_update, :foodstepsplayer,
  proc {
  if $PokemonSystem.survivalmode==0
  if $PokemonGlobal.in_dungeon==false
  $PokemonGlobal.playerfoodSteps = 0 if !$PokemonGlobal.playerfoodSteps
  $PokemonGlobal.playerfoodSteps += 1
  if $PokemonGlobal.playerfoodSteps>=100
    decreaseFood(1) if rand(90) == 1 && $player.playersaturation == 0
    $PokemonGlobal.playerfoodSteps = 0
  end
  end
  end
  }
)

  EventHandlers.add(:on_frame_update, :iframes,
  proc {
  if $player.iframes>0
    $player.iframes-=1
  end
  $player.party.each do |pkmn|
    if pkmn.iframes>0
      pkmn.iframes-=1
    end
  end
  }
)


  EventHandlers.add(:on_frame_update, :sleepstepsplayer,
  proc {
  if  $PokemonSystem.survivalmode==0 && !$game_temp.in_menu && $PokemonGlobal.in_dungeon==false
  $PokemonGlobal.playersleepSteps = 0
  $PokemonGlobal.playersleepSteps += 1
  if $PokemonGlobal.playersleepSteps>=100
    decreaseSleep(3) if rand(256) <= 75
    $PokemonGlobal.playersleepSteps = 0
  end
  end
  }
)
  EventHandlers.add(:on_frame_update, :waterstepsplayer,
  proc {
  if $PokemonSystem.survivalmode==0 && !$game_temp.in_menu && $PokemonGlobal.in_dungeon==false
  $PokemonGlobal.playerwaterSteps = 0 if !$PokemonGlobal.playerwaterSteps
  $PokemonGlobal.playerwaterSteps += 1
  if $PokemonGlobal.playerwaterSteps>=100
    decreaseWater(1) if rand(90) == 1 && $player.playersaturation == 0
    $PokemonGlobal.playerwaterSteps = 0
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


  EventHandlers.add(:on_frame_update, :saturationstepsplayer,
  proc {
  if  $PokemonSystem.survivalmode==0 && !$game_temp.in_menu && $PokemonGlobal.in_dungeon==false && $PokemonSystem.nuzlockemode==0
  $PokemonGlobal.playersaturationSteps = 0 if !$PokemonGlobal.playersaturationSteps
  $PokemonGlobal.playersaturationSteps += 1
  if $PokemonGlobal.playersaturationSteps>=100
    decreaseSaturation(1) if rand(256) <= 75
    $PokemonGlobal.playersaturationSteps = 0
  end
  end
  }
)

  EventHandlers.add(:on_frame_update, :healthplayer,
  proc {
   if $PokemonGlobal.cur_challenge==true && $player.playerhealth<=0
     pbChallengeOver 
	  next
   end
   next if $PokemonGlobal.in_dungeon==true
   next if $PokemonSystem.survivalmode == 1
   next if $game_temp.in_menu
   
   pbStartOver if $player.playermaxhealth2<=0
   pbRespawnAtBed if $player.playerhealth<=0
   next if $player.playerhealth<=0
  
   waterchance = rand(100) <= 10
   foodchance = rand(100) <= 10
   sleepchance = rand(100) <= 10
   damaged = 0
   damaged += 1 if $player.playerwater < 1 && waterchance
   damaged += 1 if $player.playersleep < 1 && sleepchance
   damaged += 1 if $player.playerfood < 1 && foodchance
    next if damaged==0
   damagePlayer(3*damaged) 
   pbSEPlay("normaldamage")
  }
)


  EventHandlers.add(:on_frame_update, :stamina,
  proc {
  if $PokemonGlobal.in_dungeon==false
  
  
  
  
	
    $player.playerstamina = $player.playerstamina.to_f if $player.playerstamina.is_a? Integer
    $player.playermaxstamina = $player.playermaxstamina.to_f if $player.playermaxstamina.is_a? Integer
	$player.playerstaminamod = $player.playerstaminamod.to_f if $player.playerstaminamod.is_a? Integer

	
	$player.playermaxstamina = 100.0 if $player.playermaxstamina.nil?
	
	$player.playerstaminamod = 0.0 if $player.playerstaminamod.nil?



		pbSEPlay("breath") if $player.playerstamina <= ($player.playermaxstamina/10)

	   duris = rand(30) == 1
   
	
	if $game_player.can_run_unforced? && !$game_temp.in_menu && $player.running
	
	   decreaseStamina(4) if duris && ($player.playershoes == :NORMALSHOES || $player.playershoes == :SEASHOES) && !$player.is_it_this_class?(:TRIATHLETE,false)
	   decreaseStamina(3) if duris && $player.playershoes == :MAKESHIFTRUNNINGSHOES && !$player.is_it_this_class?(:TRIATHLETE,false)
	   decreaseStamina(2) if duris && $player.playershoes == :RUNNINGSHOES && !$player.is_it_this_class?(:TRIATHLETE,false)
	   decreaseStamina(1) if rand(140) == 1 && $player.is_it_this_class?(:TRIATHLETE,false)
	   
	   
	else
	  prereqs = !$player.acting && $player.held_item.nil?
	  if  prereqs
      if !$game_player.moving? && !$game_player.can_run_unforced? && (!Input.press?(Input::LEFT) || !Input.press?(Input::UP) || !Input.press?(Input::RIGHT) || !Input.press?(Input::DOWN))
      
	   if $player.playerstamina < 1
	   $player.playerstamina+=3 if rand(60) == 1
	   else
	   $player.playerstamina+=1 if rand(30) == 1
	   end
	  
	  elsif !$game_player.can_run_unforced? && (Input.press?(Input::LEFT) || Input.press?(Input::UP) || Input.press?(Input::RIGHT) || Input.press?(Input::DOWN))

	   $player.playerstamina+=1 if rand(140) == 1
	  end






	  end
	end




	   $player.playerstamina = $player.playermaxstamina if $player.playerstamina > $player.playermaxstamina

  end
  }
)




  EventHandlers.add(:on_frame_update, :agestepspkmn,
  proc {
  if $PokemonSystem.survivalmode==0 && Nuzlocke.on? && pbIsWeekday(0)
  $player.pokemon_party.each do |pkmn|
	pkmn.changeAge
	pkmn.changeLifespan("age",pkmn)
    if pkmn.lifespan == 0 
      pkmn.permaFaint=true
      pbMessage(_INTL("{1} has died!"))
      pkmn.hp = 0
	  next
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
    $player.party.each do |pkmn|
	  next if !pkmn.fainted?
	  next if pkmn.dead?
      if !flashed
        pbFlash(Color.new(102, 3, 0, 128), 8)
	     pbSEPlay("dying")
        flashed = true
      end
      pkmn.lifespan -= 3
	  puts "#{pkmn.name}'s lifespan is now #{pkmn.lifespan} wellness."
      if pkmn.lifespan <= 0
	     pbSEPlay("DeathDQ")
        pkmn.changeHappiness("faint",pkmn)
        pkmn.changeHappiness("powder",pkmn)
        pkmn.changeLoyalty("faint",pkmn)
        pkmn.permaFaint=true
        pbMessage(_INTL("{1} died...", pkmn.name))
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
