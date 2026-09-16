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