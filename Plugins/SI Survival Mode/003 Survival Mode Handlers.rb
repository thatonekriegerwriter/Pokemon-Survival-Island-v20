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

  EventHandlers.add(:on_frame_update, :healthplayer,
  proc {
  if $player.playerhealth <= 0
    pbStartOver
  end 
  if $PokemonSystem.survivalmode==0 && !$game_temp.in_menu && $PokemonGlobal.in_dungeon==false
   if $player.playerwater < 1
    damagePlayer(3) if rand(256) <= 1
		pbSEPlay("normaldamage")
   end
   if $player.playersleep < 1
    damagePlayer(3) if rand(256) <= 1
		pbSEPlay("normaldamage")
   end
   if $player.playerfood < 1
    damagePlayer(3) if rand(256) <= 1
		pbSEPlay("normaldamage")
   end


  end
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

  EventHandlers.add(:on_frame_update, :stamina,
  proc {
  if $PokemonGlobal.in_dungeon==false
	if $player.playerstamina.is_a? Integer
    $player.playerstamina = $player.playerstamina.to_f
	end
	if $player.playermaxstamina.is_a? Integer
    $player.playermaxstamina = $player.playermaxstamina.to_f
	end
	if $player.playerstaminamod.is_a? Integer
	$player.playerstaminamod = $player.playerstaminamod.to_f
	end
    oldsta = $player.playerstamina
	if $player.playermaxstamina.nil?
	$player.playermaxstamina = 100.0
	end
	if $player.playerstaminamod.nil?
	$player.playerstaminamod = 0.0
	end
	if $player.playerstamina < 0 && Input.press?(Input::BACK) && $game_player.moving? && Input.press?(Input::BACK) && !$game_temp.in_menu
	  damagePlayer(1) if rand(30) == 1
		pbSEPlay("normaldamage")
	end
    if $player.playerstamina < 0 && (!Input.press?(Input::BACK))
	   $player.playerstamina=0
	end
	if $player.playerstamina > $player.playermaxstamina
	   $player.playerstamina = $player.playermaxstamina
	end
	if ($player.playershoes == :RUNNINGSHOES || $player.playershoes == :MAKESHIFTRUNNINGSHOES) && $game_player.moving? && Input.press?(Input::BACK) && !$game_temp.in_menu && !$PokemonGlobal.partner
	   $player.playerstamina-=4 if rand(30) == 1
	else
	  if !$game_player.moving? && (!Input.press?(Input::BACK) && (!Input.press?(Input::LEFT) || !Input.press?(Input::UP) || !Input.press?(Input::RIGHT) || !Input.press?(Input::DOWN))) && (oldsta == $player.playerstamina)
	   if $player.playerstamina < 1
	   $player.playerstamina+=1 if rand(60) == 1
	   else
	   $player.playerstamina+=3 if rand(30) == 1
	   end
	  elsif oldsta == $player.playerstamina
	  if $player.playerstamina < 1
	   $player.playerstamina+=1 if rand(90) == 1
	   else
	   $player.playerstamina+=3 if rand(60) == 1
	   end
	  end
	end
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
      pkmn.permadeath=true
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


# Poison party Pokémon
EventHandlers.add(:on_player_step_taken_can_transfer, :kill_party,
  proc { |handled|
    # handled is an array: [nil]. If [true], a transfer has happened because of
    # this event, so don't do anything that might cause another one
    next if handled[0]
    next if $PokemonGlobal.stepcount % 4 != 0
    flashed = false
    $player.party.each do |pkmn|
	  next if pkmn.hp!=0
      if !flashed
        pbFlash(Color.new(255, 0, 0, 128), 8)
        flashed = true
      end
      pkmn.lifespan -= 1 if pkmn.lifespan > 1
      if pkmn.lifespan == 0
        pkmn.changeHappiness("faint",pkmn)
        pkmn.permadeath=true
        pbMessage(_INTL("{1} died...", pkmn.name))
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

  EventHandlers.add(:on_frame_update, :demotimer,
  proc {
    next if $game_temp.in_menu == true
    next if $game_temp.in_storage == true
    next if $game_temp.in_battle == true
   if $PokemonSystem.playermode == 0	
   $player.demotimer-=1
   end

  }
)
  EventHandlers.add(:on_frame_update, :gametimer,
  proc {
    next if $game_temp.in_menu == true
   if $PokemonSystem.playermode == 0	
   $player.demotimer+=1
   end


  }
)


EventHandlers.add(:on_enter_map, :setup_new_map23,
  proc { |old_map_id|
  return if false
  map_metadata = GameData::MapMetadata.try_get($game_map.map_id)
  if map_metadata&.outdoor_map == false || map_metadata&.outdoor_map.nil?
   $game_screen.weather(:None, 0, 0)
  else
  if $PokemonSystem.survivalmode == 0 && $PokemonSystem.temperature == 0 && map_metadata&.outdoor_map

    map_infos = pbLoadMapInfos
    new_map_metadata = $game_map.metadata
    weather_chance = rand(100)
    next if $game_screen.weather_type != :None
  if $game_map.name == map_infos[old_map_id].name
      old_map_metadata = GameData::MapMetadata.try_get(old_map_id)
      next if old_map_metadata&.weather
   elsif pbIsSpring == true
   $game_screen.weather(:None, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 40 && ($game_map.name  == "Temperate Plains" || $game_map.name  == "Temperate Shore")
   elsif  pbIsSummer == true
#######################################################################################################################################
   $game_screen.weather(:None, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Sun, rand(9)+1, rand(19)+1)  if weather_chance <= 25 
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 50 && ($game_map.name  == "Temperate Plains" || $game_map.name  == "Temperate Shore")
   elsif pbIsAutumn  == true
################################################################################################################################################
   $game_screen.weather(:None, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:HeavyRain, rand(9)+1, rand(19)+1) if weather_chance <= 15
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 50 && ($game_map.name  == "Temperate Plains" || $game_map.name  == "Temperate Shore")
   $game_screen.weather(:HeavyRain, rand(9)+1, rand(19)+1)  if weather_chance <= 90 && ($game_map.name  == "Temperate Plains" || $game_map.name  == "Temperate Shore")
   elsif pbIsWinter  == true
################################################################################################################################################
   $game_screen.weather(:None, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Snow, rand(9)+1, rand(19)+1) if weather_chance <= 15 && !$game_screen.weather_type==:Blizzard
   $game_screen.weather(:Blizzard, rand(9)+1, rand(19)+1) if weather_chance <= 40 && !$game_screen.weather_type==:Snow
   $game_screen.weather(:Snow, rand(9)+1, rand(19)+1) if weather_chance <= 15 && (!$game_screen.weather_type==:Blizzard || !$game_screen.weather_type==:Rain)&& ($game_map.name  == "Temperate Plains" || $game_map.name  == "Temperate Shore")
   $game_screen.weather(:Blizzard, rand(9)+1, rand(19)+1) if weather_chance <= 50 && (!$game_screen.weather_type==:Snow || !$game_screen.weather_type==:Rain)&& ($game_map.name  == "Temperate Plains" || $game_map.name  == "Temperate Shore")
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 35 && ($game_map.name  == "Temperate Plains" || $game_map.name  == "Temperate Shore") && (!$game_screen.weather_type==:Blizzard || !$game_screen.weather_type==:Snow)
  end
   case $game_variables[382] #Day
   when 0

   when 1

   when 2

   when 3

   when 4

   when 5

   when 6

 end

if checkHours(23)
 pbAmbientTemperature
 pbSetTemperature
end 
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
end
  end

})


MenuHandlers.add(:debug_menu, :kill_me, {
  "name"        => _INTL("Kill me!"),
  "parent"      => :player_menu,
  "description" => _INTL("Kill the player."),
  "effect"      => proc {
    $player.playerhealth = 0
    pbMessage(_INTL("YOU DIE!"))
  }
})

MenuHandlers.add(:debug_menu, :set_hp, {
  "name"        => _INTL("Set Health"),
  "parent"      => :player_menu,
  "description" => _INTL("Edit the player's Health."),
  "effect"      => proc {
    params = ChooseNumberParams.new
    params.setRange(0, 200)
    $player.playerhealth = pbMessageChooseNumber(_INTL("Set the player's health."), params)
  }
})

MenuHandlers.add(:debug_menu, :set_sleep, {
  "name"        => _INTL("Set Sleep"),
  "parent"      => :player_menu,
  "description" => _INTL("Edit the player's Sleep."),
  "effect"      => proc {
    params = ChooseNumberParams.new
    params.setRange(0, 200)
    $player.playersleep = pbMessageChooseNumber(_INTL("Set the player's sleep."), params)
  }
})

MenuHandlers.add(:debug_menu, :set_water, {
  "name"        => _INTL("Set Water"),
  "parent"      => :player_menu,
  "description" => _INTL("Edit the player's Water."),
  "effect"      => proc {
    params = ChooseNumberParams.new
    params.setRange(0, 200)
    $player.playerwater = pbMessageChooseNumber(_INTL("Set the player's water."), params)
  }
})

MenuHandlers.add(:debug_menu, :set_food, {
  "name"        => _INTL("Set Food"),
  "parent"      => :player_menu,
  "description" => _INTL("Edit the player's Food."),
  "effect"      => proc {
    params = ChooseNumberParams.new
    params.setRange(0, 200)
    $player.playerfood = pbMessageChooseNumber(_INTL("Set the player's food."), params)
  }
})

MenuHandlers.add(:debug_menu, :set_saturation, {
  "name"        => _INTL("Set Saturation"),
  "parent"      => :player_menu,
  "description" => _INTL("Edit the player's Saturation."),
  "effect"      => proc {
    params = ChooseNumberParams.new
    params.setRange(0, 200)
    $player.playersaturation = pbMessageChooseNumber(_INTL("Set the player's saturation."), params)
  }
})

MenuHandlers.add(:debug_menu, :demo_mode, {
  "name"        => _INTL("Control Demo Mode!"),
  "parent"      => :player_menu,
  "description" => _INTL("Demo Mode."),
  "effect"      => proc {
    trainerCmd = 0
    loop do
      trainerCmds = []
      break if trainerCmd < 0
	  if $PokemonSystem.playermode == 1
	  trainerCmds.push(_INTL("[Enable Demo Mode]"))
	  elsif $PokemonSystem.playermode == 0
	  trainerCmds.push(_INTL("[Disable Demo Mode]"))
	  end
	  trainerCmds.push(_INTL("Cancel"))
      trainerCmd = pbShowCommands(nil, trainerCmds, -1, trainerCmd)
	  if trainerCmd == 0
	  if $PokemonSystem.playermode == 1
	    $PokemonSystem.playermode = 0
	  elsif $PokemonSystem.playermode == 0
	    $PokemonSystem.playermode = 1
	  end
	  
	  else
	    break
	  end
	end
  }
})


MenuHandlers.add(:debug_menu, :set_timer, {
  "name"        => _INTL("Set Timer"),
  "parent"      => :player_menu,
  "description" => _INTL("Edit the player's Timer."),
  "effect"      => proc {
    params = ChooseNumberParams.new
    params.setRange(0, 99999)
	amt = pbMessageChooseNumber(_INTL("Add to the player's Timer."), params)
	if amt > 86400
	 amt = 86400
	end
    $player.demotimer += amt
  }
})