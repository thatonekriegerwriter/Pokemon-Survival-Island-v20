class Interpreter
  # Used in boulder events. Allows an event to be pushed.
  def pbPushThisEvent(event = nil)
    event = get_self if event.nil?
	source = event.interaction_source
	pusher = source.nil? ? $game_player : source
    old_x  = event.x
    old_y  = event.y
    # Apply strict version of passable, which treats tiles that are passable
    # only from certain directions as fully impassible
    return if !event.can_move_in_direction?(pusher.direction, true)
    $stats.strength_push_count += 1
    case pusher.direction
    when 2 then event.move_down
    when 4 then event.move_left
    when 6 then event.move_right
    when 8 then event.move_up
    end
    $PokemonMap&.addMovedEvent(@event_id)
    if old_x != event.x || old_y != event.y
      pusher.lock
      loop do
        Graphics.update
        Input.update
        pbUpdateSceneMap
        break if !event.moving?
      end
      pusher.unlock
    end
  end

  def pbPushThisBoulder
    event = get_self
	source = event.interaction_source
	if source.nil?
	 if $player.playerstamina == $player.playermaxstamina
      $player.playerstamina = 0.0
      pbPushThisEvent 
	 elsif $player.playerstamina < $player.playermaxstamina 
	  sideDisplay(_INTL("You are too winded!"))
	 end 
	  return false 
	end 
    if (source.is_a?(Game_PokeEvent) || source.is_a?(Game_PokeEventA))
	 if source.pokemon.hasMove?(:STRENGTH)
      pbPushThisEvent(event)
      return true
	 else
	  sideDisplay(_INTL("#{source.pokemon.name} does not have the Strength!"))
     end
	end 
	return false 
  end




end 

def pbStrength
  if $PokemonMap.strengthUsed
    pbMessage(_INTL("Strength made it possible to move boulders around."))
    return false
  end
  move = :STRENGTH
  movefinder = $player.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_STRENGTH, false) || (!$DEBUG && !movefinder)
    pbMessage(_INTL("It's a big boulder, but a Pokémon may be able to push it aside."))
    return false
  end
  pbMessage(_INTL("It's a big boulder, but you may be able to push it aside with a hidden move.\1"))
  if pbConfirmMessage(_INTL("Would you like to use Strength?"))
    speciesname = (movefinder) ? movefinder.name : $player.name
    pbMessage(_INTL("{1} used {2}!", speciesname, GameData::Move.get(move).name))
    pbHiddenMoveAnimation(movefinder)
    pbMessage(_INTL("Strength made it possible to move boulders around!"))
    $PokemonMap.strengthUsed = true
    return true
  end
  return false
end

def pbSurf
  return false if $game_player.pbFacingEvent
  return false if $game_temp.lockontarget!=false
  return false if !$game_player.can_ride_vehicle_with_follower?
  move = :SURF
  movefinder = $player.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_SURF, false) || (!$bag.has?(:RAFT) && !movefinder) 
    return false
  end
  if pbConfirmMessage(_INTL("The water is a deep blue color... Would you like to use Surf on it?"))
    speciesname = (movefinder) ? movefinder.name : $player.name
    movename = (movefinder) ? move.name : "Raft"
    pbMessage(_INTL("{1} used {2}!", speciesname, movename))
    pbCancelVehicles
    pbHiddenMoveAnimation(movefinder)
    surfbgm = GameData::Metadata.get.surf_BGM
    pbCueBGM(surfbgm, 0.5) if surfbgm
    pbStartSurfing
    return true
  end
  return false
end

def pbStartSurfing
  pbCancelVehicles
  $PokemonEncounters.reset_step_count
  $PokemonGlobal.surfing = true
  $stats.surf_count += 1
  pbUpdateVehicle
  $game_temp.surf_base_coords = $map_factory.getFacingCoords($game_player.x, $game_player.y, $game_player.direction)
  pbJumpToward
  $game_temp.surf_base_coords = nil
  $game_player.check_event_trigger_here([1, 2])
end

def pbEndSurf(_xOffset, _yOffset, dir)
  return false if !$PokemonGlobal.surfing
  x = $game_player.x
  y = $game_player.y
  if $game_map.terrain_tag(x, y).can_surf && !$game_player.pbFacingTerrainTag.can_surf
    $game_temp.surf_base_coords = [x, y]
    if pbJumpToward(1, false, true, dir)
      $game_map.autoplayAsCue
      $game_player.increase_steps
      result = $game_player.check_event_trigger_here([1, 2])
      pbOnStepTaken(result)
    end
    $game_temp.surf_base_coords = nil
    return true
  end
  return false
end

def has_move_or_held_item(move_id, item_id)

  movefinder = $player.get_pokemon_with_move(move_id)
  return true if movefinder
  return true if isSelectedThisItem?(item_id)
  return false
end 


EventHandlers.add(:on_player_interact, :strength_event,
  proc {
    next 
    facingEvent = $game_player.pbFacingEvent
    pbStrength if facingEvent && facingEvent.name[/strengthboulder/i]
  }
)

HiddenMoveHandlers::CanUseMove.add(:STRENGTH, proc { |move, pkmn, showmsg|
    next false
  next false if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_STRENGTH, showmsg)
  if $PokemonMap.strengthUsed
    pbMessage(_INTL("Strength is already being used.")) if showmsg
    next false
  end
  next true
})

HiddenMoveHandlers::UseMove.add(:STRENGTH, proc { |move, pokemon|
    next 
  if !pbHiddenMoveAnimation(pokemon)
    pbMessage(_INTL("{1} used {2}!\1", pokemon.name, GameData::Move.get(move).name))
  end
  pbMessage(_INTL("Strength made it possible to move boulders around!"))
  $PokemonMap.strengthUsed = true
  next true
})