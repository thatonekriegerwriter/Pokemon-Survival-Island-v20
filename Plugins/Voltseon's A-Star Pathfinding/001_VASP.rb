#####################################################################
#
#                  Voltseon's A-Star Pathfinding
#                 Made for Pokémon Essentials v19
#
#               Credit: Voltseon and Golisopod User
#
#####################################################################
#
# How A-Star (A*) works:
#
# There's 3 values given to every tile that is being calculated.
# G-Cost = Distance between this tile & starting point.
# H-Cost = Distance between this tile & destination point.
# F-Cost = The sum of G-Cost and H-Cost.
#
# First there's an object made using the event's location (current)
# Until current reaches its destination it calculates the costs for the tiles surrounding it.
# It then stores these in tile objects. These are used to calculate which path is the best route.
# The neighbour is stored and saves the tile that found it as its parent.
# It moves the tile to the tile that has the smallest F-Cost.
# If the tile is impassable it skips that tile.
#
# If there are multiple tiles with the same F-Cost, it should look for the minimum H-Cost.
# If there are multiple tiles with the same F-Cost and H-Cost it should look for the maximum G-Cost. (This should never happen)
#
# If it is stuck (surrounded by impassable tiles) it should stop the calculation.
# It adds every movement calculation to a variable (moveroute)
#
# There's also two arrays that store tiles their data
# Open Tiles = All the tiles that are yet to be calculated
#              But they are still close to the path
# Closed Tiles = All the tiles that benefit the move route
#
# When the tile has reached the goal it stops the loop
# And starts the moveroute for the event.
#
#####################################################################

# Banned Terrain Tags
TERRAIN_BLOCKS = [GameData::TerrainTag.get(:Ice), GameData::TerrainTag.get(:Ledge)]

# Used for storing all the map's impassable tiles
$impassable_tiles = []

# A tile contains the following data:
# x and y position
# g- h- and f-costs
# A parent which is also a tile
class PathfindingTile
  attr_writer :x
  attr_writer :y
  attr_writer :map_id
  attr_writer :g_cost
  attr_writer :h_cost
  attr_writer :f_cost
  attr_writer :parent

  def initialize(x, y, map_id = nil)
    @x = x
    @y = y
    @map_id = map_id
    @g_cost = self.g_cost
    @h_cost = self.h_cost
    @f_cost = self.f_cost
    @parent = self.parent
  end

  def x; return @x; end
  def y; return @y; end
  def map_id; return @map_id; end

  def g_cost; return @g_cost; end

  def h_cost; return @h_cost; end

  def f_cost
    @f_cost = @g_cost + @h_cost if @g_cost && @h_cost
    return @f_cost
  end

  def parent; return @parent; end

  # map_id defaults to nil (see calc_path_through, which never sets it) -
  # only calc_path's A* actually needs map identity to distinguish tiles.
  def same_tile?(map_id, x, y)
    @map_id == map_id && @x == x && @y == y
  end
end

# Calls whenever you change maps
# Updates the array with all the tiles that are passable
EventHandlers.add(:on_enter_map, :update_passable_tiles,
  proc { |_sender, e|
    update_passable_tiles
  }
)

# Moves the designated event to the defined coordinates
# Usage: move_to_location(EventID,X,Y,WaitForComplete,MapID)
# Example: move_to_location(20,77,52,true)
# Example (explicit map): move_to_location(20,10,5,true,12)
def move_to_location(event = nil, desired_x = 0, desired_y = 0, wait_for_completion = false, desired_map_id = nil)
  # Get the event from the specified event ID if specified
  event = get_event_from_id(event) if (event.is_a?(Integer) || event.is_a?(String))
  # Make event the current one if none is specified
  event = pbMapInterpreter.get_character(0) if event.nil? && pbMapInterpreter
  # Return if the event is already at the desired location
  return false if !event
  desired_map_id ||= event.map.map_id
  return true if (event.map.map_id == desired_map_id && event.x == desired_x && event.y == desired_y)
  # Calculates the pathfinding
  if event.through || ((event.is_a?(Game_PokeEventA) || event.is_a?(Game_PokeEvent)) && event.pokemon.types.include?(:FLYING) )
    moveroute = calc_path_through(event,[desired_x, desired_y], desired_map_id)
  else
    moveroute = calc_path(event,[desired_x, desired_y], desired_map_id)
  end
  
  pbAStarMoveRoute(event,moveroute,wait_for_completion) if !moveroute.is_a?(TrueClass) && !moveroute.is_a?(FalseClass)
  return true if (event.map.map_id == desired_map_id && event.x == desired_x && event.y == desired_y)
  return false
end

# Moves the designated event to the defined event
# Usage: move_to_event(EventID1,EventID2,WaitForComplete)
# Example: move_to_event(20,34,true)
def move_to_event(event_a = nil, event_b = nil, wait_for_completion = false)
  # Get the event from the specified event ID if specified
  event_a = get_event_from_id(event_a) if (event_a.is_a?(Integer) || event_a.is_a?(String))
  event_b = get_event_from_id(event_b) if (event_b.is_a?(Integer) || event_b.is_a?(String))
  # Sets a default event if none is specified
  event_a = pbMapInterpreter.get_character(0) if event_a.nil? && pbMapInterpreter
  event_b = pbMapInterpreter.get_character(-1) if event_b.nil? && pbMapInterpreter
  # Return if the event is already at the desired location
  return true if (!event_a || !event_b) || (event_a.map.map_id == event_b.map.map_id && event_a.x == event_b.x && event_a.y == event_b.y)
  # event_b.x/event_b.y are coordinates on event_b's OWN map, not event_a's -
  # translate into event_a's frame first (may end up overflowing onto a
  # connected map, same as any other destination calc_path/calc_path_through take).
  delta = $map_factory.getThisAndOtherEventRelativePos(event_a, event_b)
  destination = [event_a.x + delta[0], event_a.y + delta[1]]
  # Calculates the pathfinding based on whether through is on
  if event_a.through
    moveroute = calc_path_through(event_a, destination)
  else
    moveroute = calc_path(event_a, destination)
  end
  
  # Performs the moveroute
  pbAStarMoveRoute(event_a, moveroute, wait_for_completion) if !moveroute.is_a?(TrueClass) && !moveroute.is_a?(FalseClass)
  return true if (!event_a || !event_b) || (event_a.map.map_id == event_b.map.map_id && event_a.x == event_b.x && event_a.y == event_b.y)
  return false
end

# Calculates the pathfinding liniar
# event = designated event to move
# destination = an array of the desired location [x,y]
def calc_path_through(event, destination, destination_map_id = nil)
  # Array containing the move route
  move_route = []
  # destination_map_id lets a caller name the target map directly, same as
  # calc_path. Translate it into a coordinate relative to event's own map
  # (may overflow past its bounds) so the straight-line stepping below
  # stays meaningful across a seam. NOTE: like every other use of
  # getRelativePos in this file, this only resolves a DIRECT connection -
  # a destination map more than one hop away won't translate correctly.
  if destination_map_id && destination_map_id != event.map.map_id
    delta = $map_factory.getRelativePos(event.map.map_id, event.x, event.y, destination_map_id, destination[0], destination[1])
    destination = [event.x + delta[0], event.y + delta[1]]
  end
  # Currently selected tile
  this_tile = PathfindingTile.new(event.x, event.y)
  # Target tile of where to move towards
  destination_tile = PathfindingTile.new(destination[0], destination[1])
  # Loop until the selected tile is at the target
  loop do
    # Move the selection based on whether the
    # x or y value of the target is smaller
    # or bigger than the selected one's.
    if this_tile.x < destination_tile.x
      this_tile.x += 1
    elsif this_tile.x > destination_tile.x
      this_tile.x -= 1
    elsif this_tile.y > destination_tile.y
      this_tile.y -= 1
    elsif this_tile.y < destination_tile.y
      this_tile.y += 1
    end
    # Break the loop if at the location
    break if this_tile.x == destination_tile.x && this_tile.y == destination_tile.y
    # Store the move route needed to move towards the target
    movement = calc_move_route(this_tile, destination_tile)
    # Add movement to the move route
    move_route.push(movement)
  end
  return move_route
end




# Calculates the pathfinding (A*)
# initial = start location
# destination = an array of the desired location [x,y]
def calc_path2(event, destination)
  # Updates the array with all the tiles that are passable
  update_passable_tiles(event)
  # Starting point is always on the designated event
  initial_point = [event.x, event.y]
  # The bare minimum distance that needs to be traveled
  distance_needed = calc_dist(initial_point, destination)
  # Array containing the move route
  move_route = []
  # Array containing all the possible movable tiles that have not been checked
  open_tiles = []
  # Array containing the path that's best suited for moving to the destination
  closed_tiles = []
  # Defining tiles
  initial_tile = PathfindingTile.new(initial_point[0], initial_point[1])
  destination_tile = PathfindingTile.new(destination[0], destination[1])
  # Adds the first tile to the open tiles
  open_tiles.push(initial_tile)
  # Loops until every possible tile is checked
  while open_tiles.length > 0
    # Select the first tile
    current = open_tiles[0]
    # Select the tile with the lowest f-cost
    for i in 1...open_tiles.length
      if open_tiles[i].f_cost <= current.f_cost && open_tiles[i].h_cost < current.h_cost
        current = open_tiles[i]
      end
    end
    # Remove the selected tile from open and add to closed
    open_tiles.delete(current)
    closed_tiles.push(current)
    # Save the selected location
    current_location = [current.x, current.y]
    # Stop when the destination is not reachable
    return false if $impassable_tiles.any? { |new_tile| destination[0] == new_tile[0] && destination[1] == new_tile[1] }
    # Stop when it has reached its destination
    return true if current_location == destination
    # Select a neighbour and save it
    current_neighbours = get_neighbours(current, closed_tiles, open_tiles)
    # Calculate the costs of the selected tile
    calc_tile_costs(current, initial_point, destination)
    # Get data from all 4 neighbours
    for neighbour in current_neighbours
      # Get the selected neighbour's location
      neighbour_location = [neighbour.x, neighbour.y]
      # Get the cost between current and neighbour
      cost_to_neighbour = current.g_cost + calc_dist(current_location, neighbour_location)
      # Set costs of the neighbour
      neighbour.g_cost = cost_to_neighbour
      neighbour.h_cost = calc_dist(neighbour_location, destination)
      # Make the selected tile a parent of the neighbour
      neighbour.parent = current
      # Add neighbour to the open tiles
      open_tiles.push(neighbour)
    end
  end
  # Sort the path (it's reversed at first)
  move_route = calc_sorted_path(closed_tiles)
  return move_route
end

# Core A* search - returns the closed_tiles chain, or [] if unreachable.
# Shared by calc_path_segments (the only thing that should call this
# directly); calc_path itself is now a thin single-segment wrapper below.
def run_astar_search(event, dest_map_id, dest_x, dest_y)
  open_tiles = [PathfindingTile.new(event.x, event.y, event.map.map_id)]
  closed_tiles = []
  while open_tiles.length > 0
    current = open_tiles[0]
    for i in 1...open_tiles.length
      if open_tiles[i].f_cost <= current.f_cost && open_tiles[i].h_cost < current.h_cost
        current = open_tiles[i]
      end
    end
    open_tiles.delete(current)
    closed_tiles.push(current)
    break if current.same_tile?(dest_map_id, dest_x, dest_y)
    current_neighbours = get_neighbours(current, closed_tiles, open_tiles, event)
    for neighbour in current_neighbours
      cost_to_neighbour = current.g_cost.to_i + calc_dist([current.x, current.y], [neighbour.x, neighbour.y])
      neighbour.g_cost = cost_to_neighbour
      neighbour.h_cost = calc_heuristic_dist(neighbour.map_id, neighbour.x, neighbour.y, dest_map_id, dest_x, dest_y)
      neighbour.parent = current
      open_tiles.push(neighbour)
    end
  end
  closed_tiles
end

# Same idea as calc_sorted_path, but returns the actual tile chain
# (start to destination, inclusive) instead of direction codes, so
# calc_path_segments can inspect map_id per tile before converting
# anything to moves.
def calc_sorted_tile_path(closed_tiles)
  return [] if closed_tiles.empty?
  path = []
  current_checking = closed_tiles[closed_tiles.length - 1]
  loop do
    path.unshift(current_checking)
    break if !current_checking.parent
    current_checking = current_checking.parent
  end
  path
end

# Calculates the pathfinding (A*), across as many connected maps as
# needed, but returns it split into one route PER MAP CROSSED. This
# matters because ordinary stepping (Game_Character#passable?) hard-blocks
# ever leaving self.map's own bounds - a single force_move_route handed a
# route that crosses a seam doesn't fail loudly, it silently no-ops
# through every remaining command (pbAStarMoveRoute sets skippable=true),
# meaning the event never appears to move at all. Each returned segment
# is guaranteed to be executable as one force_move_route on one map; the
# caller is responsible for reparenting the event onto the next segment's
# map_id (at its start_x/start_y) before playing it - see
# move_to_location_multi_map/advance_multi_map_route below for the
# reference implementation of that.
def calc_path_segments(event, destination, destination_map_id = nil)
  destination_map_id ||= event.map.map_id
  resolved = $map_factory.getRealTilePos(destination_map_id, destination[0], destination[1])
  return [] unless resolved
  dest_map_id, dest_x, dest_y = resolved
  return [] unless isPassableForPathfinding?(dest_map_id, dest_x, dest_y, event)

  tile_path = calc_sorted_tile_path(run_astar_search(event, dest_map_id, dest_x, dest_y))
  return [] if tile_path.empty?

  runs = []
  current_map_id = tile_path[0].map_id
  current_run = [tile_path[0]]
  tile_path[1..-1].each do |tile|
    if tile.map_id != current_map_id
      runs.push([current_map_id, current_run])
      current_run = [tile]
      current_map_id = tile.map_id
    else
      current_run.push(tile)
    end
  end
  runs.push([current_map_id, current_run])

  runs.each_with_index.map do |(map_id, tiles), idx|
    route = (1...tiles.length).map { |i| calc_move_route_inverted(tiles[i], tiles[i - 1]) }
    # Every run except the last ends at the map-connection seam - the
    # tile right before the event gets reparented onto the next map.
    # Ordinary move_down/left/right/up refuse that step (the same reason
    # move_fancy/move_through exist for followers crossing maps), so swap
    # the final command in the run for its move_fancy equivalent.
    if idx < runs.length - 1 && !route.empty?
      route[-1] = fancy_move_code(route[-1])
    end
    { map_id: map_id, route: route,
      start_x: tiles.first.x, start_y: tiles.first.y,
      end_x: tiles.last.x, end_y: tiles.last.y }
  end
end
# Maps a plain PBMoveRoute direction code to the custom move_fancy command
# code Game_PokeEventA#move_type_custom understands (46-49). Falls back to
# returning the code unchanged if it isn't one of the four directions.
def fancy_move_code(direction_code)
  case direction_code
  when PBMoveRoute::Down  then 46
  when PBMoveRoute::Left  then 47
  when PBMoveRoute::Right then 48
  when PBMoveRoute::Up    then 49
  else direction_code
  end
end

# initial = start location
# destination = an array of the desired location [x,y]
def calc_path(event, destination, destination_map_id = nil)
  # destination_map_id lets a caller name the target map directly (its x/y
  # are then that map's own coordinates, no overflow math needed). If
  # omitted, destination is instead treated as relative to event's own
  # map and may overflow onto a connected one - same convention
  # fancy_moveto/getRealTilePos already use elsewhere.
  #
  # Only returns the FIRST segment - see calc_path_segments above for why
  # a route can never safely span more than one map in one go. Existing
  # callers (calc_path_through's own translation, move_to_event) only
  # ever needed one segment's worth anyway; callers that actually need to
  # walk across a seam should use calc_path_segments directly instead.
  segments = calc_path_segments(event, destination, destination_map_id)
  return [] if segments.empty?
  segments.first[:route]
end

# Starts (or continues towards) a destination that may be multiple
# connected maps away. Issues the first segment now and remembers the
# rest on the event itself; advance_multi_map_route (below) plays them
# out one at a time as each prior segment naturally finishes. Returns
# false only if no path exists at all.
def move_to_location_multi_map(event, destination_map_id, x, y)
  segments = calc_path_segments(event, [x, y], destination_map_id)
  return false if segments.empty?
  event.instance_variable_set(:@pending_multi_map_segments, segments[1..-1] || [])
  pbAStarMoveRoute(event, segments.first[:route]) unless segments.first[:route].empty?
  true
end

# Call once a route issued by move_to_location_multi_map has fully
# finished (event not moving/jumping/move_route_forcing) but the overall
# destination hasn't been reached yet. Reparents onto the next segment's
# map via the same deferred @transitioned_map mechanism move_with_maps'
# cross-map branch already uses (so real_x/real_y stay bundled with the
# reparent, avoiding the visual drift bug that mechanism exists to
# prevent), then plays that segment's already-precomputed route - no
# fresh pathfind happens here, so this is cheap to call every time a
# segment completes. Returns false once there's nothing left queued.
def advance_multi_map_route(event)
  segments = event.instance_variable_get(:@pending_multi_map_segments)
  return false if segments.nil? || segments.empty?
  return true if event.moving? || event.jumping? || event.move_route_forcing

  segment = segments.shift
  if event.map.map_id != segment[:map_id] || event.x != segment[:start_x] || event.y != segment[:start_y]
    event.instance_variable_set(:@transitioned_map, [segment[:map_id], segment[:start_x], segment[:start_y], false])
  end
  pbAStarMoveRoute(event, segment[:route]) unless segment[:route].empty?
  return true
end



# Sort a reversed path
# closed_tiles = Array containing the path backwards
def calc_sorted_path(closed_tiles)
  # Default values
  move_route = []
  current_checking = closed_tiles[closed_tiles.length-1]
  # Loop until there are no more parents
  loop do
    break if !current_checking.parent
    # Get the inverted move route from last position to its parent
    inverted_move_route = calc_move_route_inverted(current_checking, current_checking.parent)
    # Add the inverted move route to the first position in the
    move_route.insert(0, inverted_move_route)
    # Select the parent of this tile
    current_checking = current_checking.parent
  end
  return move_route
end

# Turns towards the designated event
def look_at_event(event_a,event_b)
  # Get the event from the specified event ID if specified
  event_a = get_event_from_id(event_a) if event_a && event_a != $game_player
  event_b = get_event_from_id(event_b) if event_b && event_b != $game_player
  # Sets a default event if none is specified
  event_a = get_character(0) if !event_a
  event_b = get_character(1) if !event_b
  # Get distance between x values and y values
  distance_x = (event_a.x - event_b.x).abs
  distance_y = (event_a.y - event_b.y).abs
  # Turn the event based on the other event's location (Y-Axis is prioritized if both distances are the same)
  if distance_x <= distance_y
    # Prioritize Y
    if event_a.y<event_b.y; pbMoveRoute(event_a,[PBMoveRoute::TurnDown])
    elsif event_a.y>event_b.y; pbMoveRoute(event_a,[PBMoveRoute::TurnUp])
    elsif event_a.x<event_b.x; pbMoveRoute(event_a,[PBMoveRoute::TurnRight])
    elsif event_a.x>event_b.x; pbMoveRoute(event_a,[PBMoveRoute::TurnLeft])
    end
  else
    # Prioritize X
    if event_a.x<event_b.x; pbMoveRoute(event_a,[PBMoveRoute::TurnRight])
    elsif event_a.x>event_b.x; pbMoveRoute(event_a,[PBMoveRoute::TurnLeft])
    elsif event_a.y<event_b.y; pbMoveRoute(event_a,[PBMoveRoute::TurnDown])
    elsif event_a.y>event_b.y; pbMoveRoute(event_a,[PBMoveRoute::TurnUp])
    end
  end
end

# Turns towards the designated location
def look_at_location(event,x,y)
  # Get the event from the specified event ID if specified
  event = get_event_from_id(event) if event && !event.is_a?(Game_Event) && event != $game_player
  # Sets a default event if none is specified
  return if !event
  #event = get_character(0) if !event
  destination = [x, y]
  # Get distance between x values and y values
  distance_x = (event.x - x).abs
  distance_y = (event.y - y).abs
  # Turn the event based on the other event's location (Y-Axis is prioritized if both distances are the same)
  if distance_x <= distance_y
    # Prioritize Y
    if event.y<destination[1]; pbMoveRoute(event,[PBMoveRoute::TurnDown])
    elsif event.y>destination[1]; pbMoveRoute(event,[PBMoveRoute::TurnUp])
    elsif event.x<destination[0]; pbMoveRoute(event,[PBMoveRoute::TurnRight])
    elsif event.x>destination[0]; pbMoveRoute(event,[PBMoveRoute::TurnLeft])
    end
  else
    # Prioritize X
    if event.x<destination[0]; pbMoveRoute(event,[PBMoveRoute::TurnRight])
    elsif event.x>destination[0]; pbMoveRoute(event,[PBMoveRoute::TurnLeft])
    elsif event.y<destination[1]; pbMoveRoute(event,[PBMoveRoute::TurnDown])
    elsif event.y>destination[1]; pbMoveRoute(event,[PBMoveRoute::TurnUp])
    end
  end
end

# Get the neighbours of the selected tile - resolved through connected maps,
# so a tile off the edge of tile.map_id can still come back as a valid
# neighbour on whichever map it actually falls on.
def get_neighbours(tile, closed_tiles, open_tiles, traveller = nil)
  # Array containing all the neighbouring tiles
  neighbours = []
  checking_tiles = [[1,0], [0,1], [-1,0], [0,-1]]
  checking_tiles.each do |new_tile|
    x = new_tile[0]; y = new_tile[1]
    # Resolve the candidate coordinate - may land on a different, connected
    # map if it's off the edge of tile's own map
    resolved = $map_factory.getRealTilePos(tile.map_id, tile.x + x, tile.y + y)
    next unless resolved   # off the edge of the world entirely - no connection there
    map_id, check_x, check_y = resolved
    # Checks if the tile is actually passable
    next unless isPassableForPathfinding?(map_id, check_x, check_y, traveller)
    # Checks whether tile has already been parsed
    next if closed_tiles.any? { |closed_tile| closed_tile.same_tile?(map_id, check_x, check_y) }
    next if open_tiles.any? { |open_tile| open_tile.same_tile?(map_id, check_x, check_y) }
    # Add the neighbouring tile to the array
    neighbours.push(PathfindingTile.new(check_x, check_y, map_id))
  end
  return neighbours
end

# Passability check dedicated to pathfinding - kept separate from
# $map_factory.isPassable? so the two exceptions below (walking through a
# berry plant, walking through the player) never affect anything else that
# calls isPassable?/Game_Map#passable? for real collision purposes.
def isPassableForPathfinding?(mapID, x, y, traveller = nil)
  map = $map_factory.getMapNoAdd(mapID)
  return false if !map || !map.valid?(x, y)
  return true if traveller&.through

  # Temporarily let the traveller ignore a berry plant at this tile, then
  # run the real check - keeps all of map.passable?'s terrain/surf/ice
  # logic intact instead of re-deriving it here.
  exempted = berry_plant_exception(mapID, x, y, traveller)
  was_through = exempted&.through
  exempted.through = true if exempted

  passable = map.passable?(x, y, 0, traveller)

  exempted.through = was_through if exempted
  return false unless passable

  # map.passable? never checks the player's own position at all (the
  # player isn't one of its @events) - add that here. Blocked by default,
  # except a travelling Pokemon may walk through, same exception
  # update_passable_tiles used to grant.
  if $game_map.map_id == mapID && $game_player.x == x && $game_player.y == y &&
     !$game_player.through && !traveller.is_a?(Game_PokeEventA)
    return false
  end

  if $PokemonGlobal && $PokemonGlobal.dependentEvents
    return false if $PokemonGlobal.dependentEvents.any? { |e| e[3] == x && e[4] == y }
  end
  true
end

def berry_plant_exception(mapID, x, y, traveller)
  return nil unless traveller.is_a?(Game_PokeEventA)
  map = $map_factory.getMapNoAdd(mapID)
  event = map.events[map.check_event(x, y)]
  event && event.name[/berryplant/i] ? event : nil
end



# Updates the array with all the tiles that are passable
# NOTE: calc_path (the live pathfinding entry point) no longer uses this -
# it checks passability on-demand per tile via isPassableForPathfinding?
# instead, since a single precomputed grid can't represent multiple
# connected maps. Left in place because calc_path2 (currently unused -
# nothing calls it) still references it.
def update_passable_tiles(traveller = nil)
  # Initialize the impassable tiles array
  $impassable_tiles = [] if !$impassable_tiles
  # Reset the impassable tiles array
  $impassable_tiles.clear
  # Go through all the possible tiles in the map
  for i in 0...$game_map.width
    for j in 0...$game_map.height
      # Checks whether the current tile is impassable or is a blocked terrain tag
	  event_id=$game_map.check_event(i, j)
	  potato = $game_map.events[event_id]
      next if $game_map.passable?(i, j, 0)
      next if potato && potato.name[/berryplant/i] && traveller && traveller.is_a?(Game_PokeEventA)
      next if TERRAIN_BLOCKS.include?($game_map.terrain_tag(i, j))
      # Add current tile to the array
      $impassable_tiles.push([i, j])
    end
  end
  # Add the player's location to the array
  $impassable_tiles.push([$game_player.x, $game_player.y]) unless traveller && traveller.is_a?(Game_PokeEventA)
  # Add dependent events to impassable tiles
  if $PokemonGlobal && $PokemonGlobal.dependentEvents
    $PokemonGlobal.dependentEvents.each_with_index do |e, i|
      $impassable_tiles.push([e[3], e[4]])
    end
  end
end

# Calculate the needed move route
def calc_move_route(position_a, position_b)
  return PBMoveRoute::Right if position_a.x < position_b.x
  return PBMoveRoute::Left if position_a.x > position_b.x
  return PBMoveRoute::Up if position_a.y > position_b.y
  return PBMoveRoute::Down if position_a.y < position_b.y
end

# Calculate the needed move route but inverted
def calc_move_route_inverted(position_a, position_b)
  return PBMoveRoute::Right if position_a.x > position_b.x
  return PBMoveRoute::Left if position_a.x < position_b.x
  return PBMoveRoute::Up if position_a.y < position_b.y
  return PBMoveRoute::Down if position_a.y > position_b.y
end

# Calculates all the costs of a tile
def calc_tile_costs(tile, start, destination)
  tile.g_cost = calc_dist([tile.x,tile.y],start)
  tile.h_cost = calc_dist([tile.x,tile.y],destination)
  tile.f_cost = tile.g_cost + tile.h_cost
end

# Calculates a Distance
def calc_dist(coordinate_a, coordinate_b)
  return Math.sqrt(((coordinate_a[0] - coordinate_b[0])**2) + ((coordinate_a[1] - coordinate_b[1])**2))
end

# Distance estimate used only for A*'s h_cost heuristic, where the two
# points being compared aren't guaranteed to be adjacent (unlike g_cost,
# which is always between two directly-adjacent tiles and so stays
# correct on raw coordinates alone - see get_neighbours). When the two
# points are on different maps, translate through the connection first so
# the estimate reflects real distance instead of two unrelated maps'
# arbitrary coordinate numbers. NOTE: like every other use of
# getRelativePos, this only resolves a DIRECT connection - if the two
# points are more than one map-hop apart, this quietly falls back to
# reading them as though adjacent (getRelativePos's own [0,0] fallback),
# which under-estimates distance rather than failing outright. That can
# make A* explore that branch first, but never makes it incorrect - the
# same_tile? check in calc_path is what actually decides arrival.
def calc_heuristic_dist(map_id_a, x_a, y_a, map_id_b, x_b, y_b)
  return calc_dist([x_a, y_a], [x_b, y_b]) if map_id_a == map_id_b
  delta = $map_factory.getRelativePos(map_id_a, x_a, y_a, map_id_b, x_b, y_b)
  calc_dist([0, 0], delta)
end

# Get event from event ID
def get_event_from_id(id)
  return $game_map.events[id]
end

# New move route functionality
def pbAStarMoveRoute(event, commands, waitComplete = false)
puts commands.inspect
commands_duplicate = commands.map do |command|
  case command
  when 1
    "Down"
  when 2
    "Left"
  when 3
    "Right"
  when 4
    "Up"
  else
    command # In case of any other values, keep them as they are
  end
end
  route = RPG::MoveRoute.new
  route.repeat    = false
  route.skippable = true
  route.list.clear
  i = 0
  while i<commands.length
    Graphics.update
	 Input.update
	 $scene.miniupdate
    event.decrease_attack_opportunity(6) if event.attack_opportunity>0 if event.is_a?(Game_PokeEventA)
    case commands[i]
    when PBMoveRoute::Wait, PBMoveRoute::SwitchOn, PBMoveRoute::SwitchOff,
       PBMoveRoute::ChangeSpeed, PBMoveRoute::ChangeFreq, PBMoveRoute::Opacity,
       PBMoveRoute::Blending, PBMoveRoute::PlaySE, PBMoveRoute::Script
      route.list.push(RPG::MoveCommand.new(commands[i],[commands[i+1]]))
      i += 1
    when PBMoveRoute::ScriptAsync
      route.list.push(RPG::MoveCommand.new(PBMoveRoute::Script,[commands[i+1]]))
      route.list.push(RPG::MoveCommand.new(PBMoveRoute::Wait,[0]))
      i += 1
    when PBMoveRoute::Jump
      route.list.push(RPG::MoveCommand.new(commands[i],[commands[i+1],commands[i+2]]))
      i += 2
    when PBMoveRoute::Graphic
      route.list.push(RPG::MoveCommand.new(commands[i],
         [commands[i+1],commands[i+2],commands[i+3],commands[i+4]]))
      i += 4
    else
      route.list.push(RPG::MoveCommand.new(commands[i]))
    end
    i += 1
  end
   
  route.list.push(RPG::MoveCommand.new(0))
  if event
    event.force_move_route(route)
    #pbMapInterpreter.command_210 if waitComplete
  end
  return route
end
