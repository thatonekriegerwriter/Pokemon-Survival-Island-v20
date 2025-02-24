
def pbAbsoluteDistance(x1, y1, x2, y2)
  return (x2 - x1).abs + (y2 - y1).abs
end

def am_i_looking_at_something_basic(event, distance)
  return nil if event.nil?
  distance.times do |i|
  return nil if event.nil?
  start_coord=[event.x,event.y]
  landing_coord=[event.x,event.y]
  case event.direction
  when 2; landing_coord[1]+=i+1
  when 4; landing_coord[0]-=i+1
  when 6; landing_coord[0]+=i+1
  when 8; landing_coord[1]-=i+1
  end
  
	event2 = get_event_at(*landing_coord)
	if !event2.nil?
	  return event2
	end
  end

  
  return nil
end

def direction_to_angle(direction)
  case direction
  when 2  # Down
    return 90
  when 4  # Left
    return 180
  when 6  # Right
    return 0
  when 8  # Up
    return 270
  else
    return 0  # Default to right if something unexpected happens
  end
end


def am_i_looking_at_something(event, range)
  ex, ey = event.x, event.y
  angle =  direction_to_angle(event.direction)
  radians = angle * Math::PI / 180
  
  cone_width = 45 
  detected_event = nil

  (1..range).each do |i|
    x_offset = (i * Math.cos(radians)).round
    y_offset = (i * Math.sin(radians)).round

    (-cone_width..cone_width).step(10) do |angle_offset|
      offset_radians = (angle + angle_offset) * Math::PI / 180
      tx = ex + (i * Math.cos(offset_radians)).round
      ty = ey + (i * Math.sin(offset_radians)).round

      checked_event = get_event_at(tx, ty)

      if !checked_event.nil?
        detected_event = checked_event
        break
      end
    end
    break if detected_event 
  end

  return detected_event
end




def get_event_at(x,y)

id = $game_map.check_event(x,y)
return $game_player if id.is_a?(Game_Player)
return nil if !id.is_a?(Integer)
 return $game_map.events[id]
end
class FixedSizeArray

  def initialize(size)
    @array = []
	@array_size = size || 5
  end

  def add(element)
    @array.push(element)
    @array.shift if @array.size > @array_size
  end
  def remove(element)
    @array.delete(element)
  end
  def clear
    @array = []
  end
  def to_a
    @array
  end
  def empty?
    return @array.empty?
  end
  def length
    return @array.length
  end
  
  
  
  def how_many?(object,length)
    last_part = @array.last(length)
    count = last_part.count(object)
	return count
  end

  def next_position
    return @array.size
  end
end




def pbRandomEvent
   chance = rand(256)
   if chance > 5 && chance < 11
     Kernel.pbMessage(_INTL("It sounds like something crashed."))   #Comet
     $game_switches[450]=true 
     $game_switches[451]=true 
   elsif chance <= 1
     Kernel.pbMessage(_INTL("The Sky looks beautiful tonight."))   #Comet

      $player.able_party.each do |pkmn|
	       pkmn.level_cap+=1
        endexp = pkmn.growth_rate.minimum_exp_for_level(pkmn.level + 1)
		addexp = endexp-pkmn.exp-pkmn.stored_exp
		pkmn.stored_exp+=addexp
        pbDoLevelUps(pkmn)
      end
     
   elsif chance > 1 && chance < 5
     
   elsif chance == 13
     
   elsif chance == 14
     
   elsif chance == 15
end
end

def pbCut
  move = :CUT
  movefinder = $player.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_CUT, false) || (!$DEBUG && !movefinder) || (!$bag.has?(:MACHETE)  && !movefinder) 
    pbMessage(_INTL("This tree looks like it can be cut down."))
    return false
  end
  if pbConfirmMessage(_INTL("This tree looks like it can be cut down!\nWould you like to cut it?"))
    $stats.cut_count += 1
    pbSEPlay("Cut", 80)
    speciesname = (movefinder) ? movefinder.name : $player.name
    pbMessage(_INTL("{1} used {2}!", speciesname, GameData::Move.get(move).name))
    pbHiddenMoveAnimation(movefinder)
    return true
  end
  return false
end

def pbRockSmash
  move = :ROCKSMASH
  movefinder = $player.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_ROCKSMASH, false) || (!$DEBUG && !movefinder) ||  (!$bag.has?(:PICKAXE)  && !movefinder) 
    pbMessage(_INTL("It's a rugged rock, but a Pokémon may be able to smash it."))
    return false
  end
  if pbConfirmMessage(_INTL("This rock seems breakable with a hidden move.\nWould you like to use Rock Smash?"))
    $stats.rock_smash_count += 1
    pbSEPlay("Rock Smash", 80)
    speciesname = (movefinder) ? movefinder.name : $player.name
    movename = (movefinder) ? move.name : "Hammer"
    pbMessage(_INTL("{1} used {2}!", speciesname, movename))
    pbHiddenMoveAnimation(movefinder)
    return true
  end
  return false
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