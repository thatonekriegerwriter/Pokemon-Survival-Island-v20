def pbRandomEvent
   if rand(256) <= 5
    if $game_switches[132]==true && $game_switches[226]==true
     Kernel.pbMessage(_INTL("It sounds like something crashed."))   #Comet
     $game_switches[450]=true 
     $game_switches[451]=true 
	else
     Kernel.pbMessage(_INTL("The Sky looks beautiful tonight."))   #Comet
	end
=begin
   elsif rand(100) == 6
     
   elsif rand(100) == 7
     
   elsif rand(100) == 8
     
   elsif rand(100) == 9
     
   elsif rand(100) == 10
=end
end
end



def pbGrassEvolutionStone
pbChooseNonEggPokemon(1,3)
  case $game_variables[3]
     when "Gloom"
    Kernel.pbMessage(_INTL("Gloom evolves into Vileplume."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:VILEPLUME)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Weepingbell"
    Kernel.pbMessage(_INTL("Weepingbell evolves into Victreebell."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:VECTREEBEL)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Exeggcute" 
    Kernel.pbMessage(_INTL("Exeggcute evolves into Exeggcutor."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:EXEGGCUTOR)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Eevee"
    Kernel.pbMessage(_INTL("Eevee evolves into Leafeon."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:LEAFEON)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Nuzleaf"
    Kernel.pbMessage(_INTL("Nuzleaf evolves into Shiftry."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:SHIFTRY)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Pansage"
    Kernel.pbMessage(_INTL("Pansage evolves into Semisage."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:SEMISAGE)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Cherubi"
    Kernel.pbMessage(_INTL("Cherubi evolves into Cherrim."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:STEENEE)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
    Kernel.pbMessage(_INTL("OH! How abnormal!"))
     when "Bounsweet"
    Kernel.pbMessage(_INTL("Bounsweet evolves into Steenee."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:CHERRIM)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
    Kernel.pbMessage(_INTL("OH! How abnormal!"))
	 else
    Kernel.pbMessage(_INTL("That does not seem to be able to evolve with this stone."))
  end
end


def pbEeveelution
pbChooseNonEggPokemon(1,3)
  case $game_variables[3]
     when "Eevee"
    Kernel.pbMessage(_INTL("We can't do anything with Eevee, just Eeveelutions."))
	
     when "Jolteon","Vaporeon","Sylveon","Leafeon","Flareon","Glaceon","Umbreon","Espeon"
    Kernel.pbMessage(_INTL("Stand back!"))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:EEVEE)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
	 else
    Kernel.pbMessage(_INTL("That... isn't an Eevee"))
  end
end


def pbDayChecker(month,day,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month && d == day #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
 end

def pbIndigoPlateauDays(month1,day1,day2,day3,day4,day5,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month1 && d == day1 || m == month1 && d == day2 || m == month1 && d == day3 || m == month1 && d == day4 || m == month1 && d == day5  #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
end

def pbIndigoPlateauDays2(month1,day1,month2,day2,month3,day3,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month1 && d == day1 || m == month2 && d == day2 || m == month3 && d == day3  #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
end




	
def pbNextChampionShip
    $game_variables[421]=rand(40)
end



def pbCheckName
name = pbEnterPlayerName(_INTL("What do you put?"), 0, Settings::MAX_PLAYER_NAME_SIZE)
if name.nil? || name.empty?
  return false
else
 $game_variables[4974]=name
  Kernel.pbMessage(_INTL("You are unsure on what it would have done."))
  return true
end
end


class PokemonGlobalMetadata
 attr_accessor :skysurfing

  alias :skysurfinit :initialize
  def initialize
    @skysurfing              = false
   skysurfinit
  end
  
end
module HiddenMoveHandlers

def pbSkySurf
  return false if $game_player.pbFacingEvent
  return false if !$game_player.can_ride_vehicle_with_follower?
  move = :FLY
  movefinder = $player.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_SURF, false) || (!$DEBUG && !movefinder) || (!$bag.has?(:PARAGLIDER) && !movefinder) 
    return false
  end
  if pbConfirmMessage(_INTL("The Sky is clear. Would you like to take a trip?"))
    speciesname = (movefinder) ? movefinder.name : $player.name
    movename = (movefinder) ? move.name : "Paraglider"
    pbMessage(_INTL("{1} used {2}!", speciesname, movename))
    pbCancelVehicles
    pbHiddenMoveAnimation(movefinder)
    pbStartSSurfing
    return true
  end
  return false
end


def pbStartSkySurfing
  pbCancelVehicles
  $PokemonEncounters.reset_step_count
  $PokemonGlobal.skysurfing = true
  pbUpdateVehicle
  $game_temp.surf_base_coords = $map_factory.getFacingCoords($game_player.x, $game_player.y, $game_player.direction)
  pbJumpToward
  $game_temp.surf_base_coords = nil
  $game_player.check_event_trigger_here([1, 2])
end

def pbEndSkySurf(_xOffset, _yOffset)
  return false if !$PokemonGlobal.skysurfing
  x = $game_player.x
  y = $game_player.y
  if $game_map.terrain_tag(x, y).can_skysurf && !$game_player.pbFacingTerrainTag.can_skysurf
    $game_temp.surf_base_coords = [x, y]
    if pbJumpToward(1, false, true)
      $game_player.increase_steps
      result = $game_player.check_event_trigger_here([1, 2])
      pbOnStepTaken(result)
    end
    $game_temp.surf_base_coords = nil
    return true
  end
  return false
end

end


def pbSkySurfDecend
  if $PokemonGlobal.skysurfing.nil?
    $PokemonGlobal.skysurfing=false
  end
  return false if $game_player.pbFacingEvent
  return false if $PokemonGlobal.skysurfing == false
  return false if $PokemonGlobal.skysurfing.nil?
  map = pbGetMapNameFromId($game_map.map_id)
  case map 
   when "Temperate Skies"
      map_id = 9
      map_x =  37
      map_y =  15
   when "Shore Skies"
      map_id = 5
      map_x =  16
      map_y =  41
   when "Mountain Skies"
      map_id = 24
      map_x =  19
      map_y =  33
  end
  if pbConfirmMessage(_INTL("Would you like to decend?"))
      $game_player.increase_steps
    pbFadeOutIn {
      $game_temp.surf_base_coords = nil
      $game_temp.player_new_map_id    = map_id
      $game_temp.player_new_x         = map_x
      $game_temp.player_new_y         = map_y
      $game_temp.player_new_direction = 2
      pbUpdateVehicle
      $PokemonGlobal.skysurfing = false
      $scene.transfer_player(false)
      $game_map.autoplay
      $game_map.refresh
    }
	return true
  end 
  return false
end


EventHandlers.add(:on_player_interact, :decendcheck,
  proc {
    pbSkySurfDecend


})

EventHandlers.add(:on_player_interact, :start_surfing,
  proc {
    next if !$game_player.pbFacingTerrainTag.can_surf
    next if $PokemonGlobal.surfing
    next if $game_map.metadata&.always_bicycle
    next if !$game_map.passable?($game_player.x, $game_player.y, $game_player.direction, $game_player)
    pbSurf
  }
)

EventHandlers.add(:on_player_interact, :start_skysurfing,
  proc {
    next if $PokemonGlobal.skysurfing
    next if $game_map.metadata&.always_bicycle
 #   next if !$game_player.pbFacingTerrainTag.can_skysurf
    next if !$game_map.passable?($game_player.x, $game_player.y, $game_player.direction, $game_player)
#    pbSkySurf
  }
)