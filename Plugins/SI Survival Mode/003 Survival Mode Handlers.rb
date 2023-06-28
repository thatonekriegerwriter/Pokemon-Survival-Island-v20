  EventHandlers.add(:on_frame_update, :foodstepsplayer,
  proc {
  if $PokemonSystem.survivalmode==0
  if $game_switches[485]==false
  $PokemonGlobal.playerfoodSteps = 0 if !$PokemonGlobal.playerfoodSteps
  $PokemonGlobal.playerfoodSteps += 1
  if $PokemonGlobal.playerfoodSteps>=100
    $player.playerfood -= 1 if rand(90) == 1 && $player.playersaturation == 0
    $PokemonGlobal.playerfoodSteps = 0
  end
  end
  end
  }
)
  EventHandlers.add(:on_frame_update, :sleepstepsplayer,
  proc {
  if  $PokemonSystem.survivalmode==0 && !$game_temp.in_menu && $game_switches[485]==false
  $PokemonGlobal.playersleepSteps = 0
  $PokemonGlobal.playersleepSteps += 1
  if $PokemonGlobal.playersleepSteps>=100
    $player.playersleep -= 3 if rand(256) <= 75
    $PokemonGlobal.playersleepSteps = 0
  end
  end
  }
)
  EventHandlers.add(:on_frame_update, :waterstepsplayer,
  proc {
  if $PokemonSystem.survivalmode==0 && !$game_temp.in_menu && $game_switches[485]==false
  $PokemonGlobal.playerwaterSteps = 0 if !$PokemonGlobal.playerwaterSteps
  $PokemonGlobal.playerwaterSteps += 1
  if $PokemonGlobal.playerwaterSteps>=100
    $player.playerwater -= 1 if rand(90) == 1 && $player.playersaturation == 0
    $PokemonGlobal.playerwaterSteps = 0
  end
  end
  }
)

  EventHandlers.add(:on_frame_update, :healthplayer,
  proc {
  if $PokemonSystem.survivalmode==0 && !$game_temp.in_menu && $game_switches[485]==false
   if $player.playerwater < 1
    $player.playerhealth -= 3 if rand(256) <= 1
   end
   if $player.playersleep < 1
    $player.playerhealth -= 3 if rand(256) <= 1
   end
   if $player.playerfood < 1
    $player.playerhealth -= 3 if rand(256) <= 1
   end
   if $player.playerhealth == 0
    pbStartOver
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


  EventHandlers.add(:on_frame_update, :agestepspkmn,
  proc {
  if $PokemonSystem.survivalmode==0 && Nuzlocke.on?
  $player.pokemon_party.each do |pkmn|
  if pkmn.hp<1
    pkmn.permaFaint = true
  end
  if $game_switches[168]==false && pbIsWeekday(6) 
    $game_switches[168] == true
    if pkmn.lifespan == 0 
      pkmn.permadeath=true
      pbMessage(_INTL("{1} has died!"))
      pkmn.hp = 0
	  return
    end
	pkmn.changeAge
	pkmn.changeLifespan("age",pkmn)
  elsif !pbIsWeekday(6)
    $game_switches[168] = false
  end
  end
end
  }
)



  EventHandlers.add(:on_frame_update, :saturationstepsplayer,
  proc {
  if  $PokemonSystem.survivalmode==0 && !$game_temp.in_menu && $game_switches[485]==false && $PokemonSystem.nuzlockemode==0
  $PokemonGlobal.playersaturationSteps = 0 if !$PokemonGlobal.playersaturationSteps
  $PokemonGlobal.playersaturationSteps += 1
  if $PokemonGlobal.playersaturationSteps>=100
    $player.playersaturation -= 1 if rand(256) <= 75
    $PokemonGlobal.playersaturationSteps = 0
  end
  end
  }
)

  EventHandlers.add(:on_frame_update, :stamina,
  proc {
  if $PokemonSystem.survivalmode==0
  if $game_switches[485]==false
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
	  $player.playerhealth-=1 if rand(30) == 1
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
  end
  }
)



  EventHandlers.add(:on_frame_update, :foodstepspkmn,
  proc {
  if $PokemonSystem.survivalmode==0 && !$game_temp.in_menu && $game_switches[485]==false && Nuzlocke.on?
  $PokemonGlobal.pkmnfoodSteps = 0 if !$PokemonGlobal.pkmnfoodSteps
  $PokemonGlobal.pkmnfoodSteps += 1
  if $PokemonGlobal.pkmnfoodSteps>=100
    if rand(100)==1
       $player.pokemon_party.each do |pkmn|
          pkmn.changeFood
       end
    end
    $PokemonGlobal.pkmnfoodSteps = 0
  end
  end
  }
)

  EventHandlers.add(:on_frame_update, :waterstepspkmn,
  proc {
  if $PokemonSystem.survivalmode==0 && !$game_temp.in_menu && $game_switches[485]==false && Nuzlocke.on?
  $PokemonGlobal.pkmnthirstSteps = 0 if !$PokemonGlobal.pkmnthirstSteps
  $PokemonGlobal.pkmnthirstSteps += 1
  if $PokemonGlobal.pkmnthirstSteps>=100
    if rand(100)==1
       $player.pokemon_party.each do |pkmn|
          pkmn.changeWater
       end
    end
    $PokemonGlobal.pkmnthirstSteps = 0
  end
  end
  }
)

  EventHandlers.add(:on_frame_update, :sleepstepspkmn,
  proc {
  if $PokemonSystem.survivalmode==0 && !$game_temp.in_menu && $game_switches[485]==false && Nuzlocke.on?
  $PokemonGlobal.pkmnsleepSteps = 0 if !$PokemonGlobal.pkmnsleepSteps
  $PokemonGlobal.pkmnsleepSteps += 1
  if $PokemonGlobal.pkmnsleepSteps>=100
    if rand(100)==1
       $player.pokemon_party.each do |pkmn|
          pkmn.changeSleep
       end
    end
    $PokemonGlobal.pkmnsleepSteps = 0
  end
  end
  }
)


  EventHandlers.add(:on_frame_update, :starvingpokemon,
  proc {
  if $PokemonSystem.survivalmode==0 && !$game_temp.in_menu && $game_switches[485]==false && Nuzlocke.on?
				party = $player.party
                 for i in 0...party.length
                 pkmn = party[i]
				 if pkmn.lifespan.nil?
				  pkmn.lifespan = 50
				 end
				 if pkmn.food.nil?
				  pkmn.food = 100
				 end
				 if pkmn.water.nil?
				  pkmn.water = 100
				 end
				 if pkmn.food > 0 && pkmn.food < 25
				   pkmn.changeLifespan("starving",pkmn)
				 elsif pkmn.food == 0
				   pkmn.changeLifespan("starvingbadly",pkmn)
				 end
				 if pkmn.water > 0 && pkmn.water < 25
				   pkmn.changeLifespan("dehydrated",pkmn)
				 elsif pkmn.water == 0
				   pkmn.changeLifespan("dehydratedbadly",pkmn)
				 end
  end
end
  }
)



EventHandlers.add(:on_enter_map, :setup_new_map,
  proc { |old_map_id|
  if $PokemonSystem.survivalmode == 0 && $PokemonSystem.temperature == 0 && GameData::MapMetadata.get($game_map.map_id).outdoor_map && GameData::MapMetadata.get($game_map.map_id)!=1

    map_infos = pbLoadMapInfos
    new_map_metadata = $game_map.metadata
    weather_chance = rand(100)
  if $game_map.name == map_infos[old_map_id].name
      old_map_metadata = GameData::MapMetadata.try_get(old_map_id)
      next if old_map_metadata&.weather
   elsif pbIsSpring == true
   $game_screen.weather(:None, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 30 && $game_map.name  == "Temperate Zone"
   elsif  pbIsSummer == true
#######################################################################################################################################
   $game_screen.weather(:None, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Sun, rand(9)+1, rand(19)+1)  if weather_chance <= 25 
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 50 && $game_map.name  == "Temperate Zone"
   elsif pbIsAutumn  == true
################################################################################################################################################
   $game_screen.weather(:None, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:HeavyRain, rand(9)+1, rand(19)+1) if weather_chance <= 15
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 50 && $game_map.name  == "Temperate Zone"
   $game_screen.weather(:HeavyRain, rand(9)+1, rand(19)+1)  if weather_chance <= 90 && $game_map.name  == "Temperate Zone"
   elsif pbIsWinter  == true
################################################################################################################################################
   $game_screen.weather(:None, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Snow, rand(9)+1, rand(19)+1) if weather_chance <= 15 && !$game_screen.weather_type==:Blizzard
   $game_screen.weather(:Blizzard, rand(9)+1, rand(19)+1) if weather_chance <= 40 && !$game_screen.weather_type==:Snow
   $game_screen.weather(:Snow, rand(9)+1, rand(19)+1) if weather_chance <= 15 && (!$game_screen.weather_type==:Blizzard || !$game_screen.weather_type==:Rain)&& $game_map.name  == "Temperate Zone"
   $game_screen.weather(:Blizzard, rand(9)+1, rand(19)+1) if weather_chance <= 50 && (!$game_screen.weather_type==:Snow || !$game_screen.weather_type==:Rain)&& $game_map.name  == "Temperate Zone"
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 35 && $game_map.name  == "Temperate Zone" && (!$game_screen.weather_type==:Blizzard || !$game_screen.weather_type==:Snow)
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


})