  EventHandlers.add(:on_step_taken, :foodstepsplayer,
  proc {
  if $PokemonSystem.survivalmode==0
  $PokemonGlobal.playerfoodSteps = 0 if !$PokemonGlobal.playerfoodSteps
  $PokemonGlobal.playerfoodSteps += 1
  if $PokemonGlobal.playerfoodSteps>=100
    $player.playerfood -= 4 if rand(100) == 1 && $player.playersaturation == 0
    $PokemonGlobal.playerfoodSteps = 0
  end
  end
  }
)
  EventHandlers.add(:on_step_taken, :sleepstepsplayer,
  proc {
  if $PokemonSystem.survivalmode==0
  $PokemonGlobal.playersleepSteps = 0
  $PokemonGlobal.playersleepSteps += 1
  if $PokemonGlobal.playersleepSteps>=100
    $player.playersleep -= 6 if rand(100) == 1
    $PokemonGlobal.playersleepSteps = 0
  end
  end
  }
)
  EventHandlers.add(:on_step_taken, :waterstepsplayer,
  proc {
  if $PokemonSystem.survivalmode==0
  $PokemonGlobal.playerwaterSteps = 0 if !$PokemonGlobal.playerwaterSteps
  $PokemonGlobal.playerwaterSteps += 1
  if $PokemonGlobal.playerwaterSteps>=100
    $player.playerwater -= 4 if rand(100) == 1 && $player.playersaturation == 0
    $PokemonGlobal.playerwaterSteps = 0
  end
  end
  }
)

  EventHandlers.add(:on_step_taken, :agestepspkmn,
  proc {
  if $PokemonSystem.survivalmode==0
  $player.pokemon_party.each do |pkmn|
  if pbIsWeekday(6) 
    if pkmn.lifespan == 0 
      pkmn.permadeath=true
      pbMessage(_INTL("{1} has died!"))
      pkmn.hp = 0
	  return
    end
	pkmn.changeAge
	pkmn.changeLifespan("age",pkmn)
  end
  end
end
  }
)



  EventHandlers.add(:on_step_taken, :saturationstepsplayer,
  proc {
  if $PokemonSystem.survivalmode==0
  $PokemonGlobal.playersaturationSteps = 0 if !$PokemonGlobal.playersaturationSteps
  $PokemonGlobal.playersaturationSteps += 1
  if $PokemonGlobal.playersaturationSteps>=100
    $player.playersaturation -= 1 if rand(100) <= 3
    $PokemonGlobal.playersaturationSteps = 0
  end
  end
  }
)

  EventHandlers.add(:on_frame_update, :stamina,
  proc {
  if $PokemonSystem.survivalmode==0
  
    if $player.playerhealth < 1
      pbStartOver
    end 
    if $player.playerstamina < 0
	   $player.playerstamina=0
	end
	if $player.playerstamina > $player.playermaxstamina
	   $player.playerstamina = $player.playermaxstamina
	end
	if $game_player.can_run?
	   $player.playerstamina-=1 if rand(40) == 1
	else
	   $player.playerstamina+=3 if rand(25) == 1
	end
  end
  }
)



  EventHandlers.add(:on_step_taken, :foodstepspkmn,
  proc {
  if $PokemonSystem.survivalmode==0
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

  EventHandlers.add(:on_step_taken, :waterstepspkmn,
  proc {
  if $PokemonSystem.survivalmode==0
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

  EventHandlers.add(:on_step_taken, :sleepstepspkmn,
  proc {
  if $PokemonSystem.survivalmode==0
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


  EventHandlers.add(:on_step_taken, :starvingpokemon,
  proc {
  if $PokemonSystem.survivalmode==0
				party = $player.party
                 for i in 0...party.length
                 pkmn = party[i]
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