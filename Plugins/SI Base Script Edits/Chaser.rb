class Game_Chaser < Game_Event
  attr_writer :map

  def initialize(event_data)
    # Create RPG::Event to base self on
    rpg_event = RPG::Event.new(event_data.x, event_data.y)
    rpg_event.id = event_data.event_id
    rpg_event.name = event_data.event_name
    if event_data.common_event_id
      # Must setup common event list here and now
      common_event = Game_CommonEvent.new(event_data.common_event_id)
      rpg_event.pages[0].list = common_event.list
    end
    # Create self
    super(event_data.original_map_id, rpg_event, $map_factory.getMap(event_data.current_map_id))
    # Modify self
    self.character_name = event_data.character_name
    self.character_hue  = event_data.character_hue
    case event_data.direction
    when 2 then turn_down
    when 4 then turn_left
    when 6 then turn_right
    when 8 then turn_up
    end
  end

  #=============================================================================

  def move_through(direction)
    old_through = @through
    @through = true
    case direction
    when 2 then move_down
    when 4 then move_left
    when 6 then move_right
    when 8 then move_up
    end
    @through = old_through
  end

  def move_fancy(direction)
    delta_x = (direction == 6) ? 1 : (direction == 4) ? -1 : 0
    delta_y = (direction == 2) ? 1 : (direction == 8) ? -1 : 0
    new_x = self.x + delta_x
    new_y = self.y + delta_y
    # Move if new position is the player's, or the new position is passable,
    # or self's current position is not passable
    if ($game_player.x == new_x && $game_player.y == new_y) ||
       location_passable?(new_x, new_y, 10 - direction) ||
       !location_passable?(self.x, self.y, direction)
      move_through(direction)
    end
  end

  def jump_fancy(direction, leader)
    delta_x = (direction == 6) ? 2 : (direction == 4) ? -2 : 0
    delta_y = (direction == 2) ? 2 : (direction == 8) ? -2 : 0
    half_delta_x = delta_x / 2
    half_delta_y = delta_y / 2
    if location_passable?(self.x + half_delta_x, self.y + half_delta_y, 10 - direction)
      # Can walk over the middle tile normally; just take two steps
      move_fancy(direction)
      move_fancy(direction)
    elsif location_passable?(self.x + delta_x, self.y + delta_y, 10 - direction)
      # Can't walk over the middle tile, but can walk over the end tile; jump over
      if location_passable?(self.x, self.y, direction)
        if leader.jumping?
          @jump_speed_real = leader.jump_speed_real
        else
          # This is doubled because self has to jump 2 tiles in the time it
          # takes the leader to move one tile.
          @jump_speed_real = leader.move_speed_real * 2
        end
        jump(delta_x, delta_y)
      else
        # self's current tile isn't passable; just take two steps ignoring passability
        move_through(direction)
        move_through(direction)
      end
    end
  end

  def fancy_moveto(new_x, new_y, leader)
    if self.x - new_x == 1 && self.y == new_y
      move_fancy(4)
    elsif self.x - new_x == -1 && self.y == new_y
      move_fancy(6)
    elsif self.x == new_x && self.y - new_y == 1
      move_fancy(8)
    elsif self.x == new_x && self.y - new_y == -1
      move_fancy(2)
    elsif self.x - new_x == 2 && self.y == new_y
      jump_fancy(4, leader)
    elsif self.x - new_x == -2 && self.y == new_y
      jump_fancy(6, leader)
    elsif self.x == new_x && self.y - new_y == 2
      jump_fancy(8, leader)
    elsif self.x == new_x && self.y - new_y == -2
      jump_fancy(2, leader)
    elsif self.x != new_x || self.y != new_y
      moveto(new_x, new_y)
    end
  end

  #=============================================================================

  def turn_towards_leader(leader)
    pbTurnTowardEvent(self, leader)
  end

  def follow_leader(leader, instant = false, leaderIsTrueLeader = true)
    maps_connected = $map_factory.areConnected?(leader.map.map_id, self.map.map_id)
    target = nil
    # Get the target tile that self wants to move to
    if maps_connected
      behind_direction = 10 - leader.direction
      target = $map_factory.getFacingTile(behind_direction, leader)
      if target && $map_factory.getTerrainTag(target[0], target[1], target[2]).ledge
        # Get the tile above the ledge (where the leader jumped from)
        target = $map_factory.getFacingTileFromPos(target[0], target[1], target[2], behind_direction)
      end
      target = [leader.map.map_id, leader.x, leader.y] if !target
    else
      # Map transfer to an unconnected map
      target = [leader.map.map_id, leader.x, leader.y]
    end
    # Move self to the target
    if self.map.map_id != target[0]
      vector = $map_factory.getRelativePos(target[0], 0, 0, self.map.map_id, @x, @y)
      @map = $map_factory.getMap(target[0])
      # NOTE: Can't use moveto because vector is outside the boundaries of the
      #       map, and moveto doesn't allow setting invalid coordinates.
      @x = vector[0]
      @y = vector[1]
      @real_x = @x * Game_Map::REAL_RES_X
      @real_y = @y * Game_Map::REAL_RES_Y
    end
    if instant || !maps_connected
      moveto(target[1], target[2])
    else
      fancy_moveto(target[1], target[2], leader)
    end
  end

  #=============================================================================

  def update_move
    was_jumping = jumping?
    super
    if was_jumping && !jumping?
      spriteset = $scene.spriteset(map_id)
      spriteset&.addUserAnimation(Settings::DUST_ANIMATION_ID, self.x, self.y, true, 1)
    end
  end

  #=============================================================================

  private

  def location_passable?(x, y, direction)
    this_map = self.map
    return false if !this_map || !this_map.valid?(x, y)
    return true if @through
    passed_tile_checks = false
    bit = (1 << ((direction / 2) - 1)) & 0x0f
    # Check all events for ones using tiles as graphics, and see if they're passable
    this_map.events.each_value do |event|
      next if event.tile_id < 0 || event.through || !event.at_coordinate?(x, y)
      tile_data = GameData::TerrainTag.try_get(this_map.terrain_tags[event.tile_id])
      next if tile_data.ignore_passability
      next if tile_data.bridge && $PokemonGlobal.bridge == 0
      return false if tile_data.ledge
      passage = this_map.passages[event.tile_id] || 0
      return false if passage & bit != 0
      passed_tile_checks = true if (tile_data.bridge && $PokemonGlobal.bridge > 0) ||
                                   (this_map.priorities[event.tile_id] || -1) == 0
      break if passed_tile_checks
    end
    # Check if tiles at (x, y) allow passage for followe
    if !passed_tile_checks
      [2, 1, 0].each do |i|
        tile_id = this_map.data[x, y, i] || 0
        next if tile_id == 0
        tile_data = GameData::TerrainTag.try_get(this_map.terrain_tags[tile_id])
        next if tile_data.ignore_passability
        next if tile_data.bridge && $PokemonGlobal.bridge == 0
        return false if tile_data.ledge
        passage = this_map.passages[tile_id] || 0
        return false if passage & bit != 0
        break if tile_data.bridge && $PokemonGlobal.bridge > 0
        break if (this_map.priorities[tile_id] || -1) == 0
      end
    end
    # Check all events on the map to see if any are in the way
    this_map.events.each_value do |event|
      next if !event.at_coordinate?(x, y)
      return false if !event.through && event.character_name != ""
    end
    return true
  end
end


class ChaserData
  attr_accessor :original_map_id
  attr_accessor :event_id
  attr_accessor :event_name
  attr_accessor :current_map_id
  attr_accessor :x, :y
  attr_accessor :direction
  attr_accessor :character_name, :character_hue
  attr_accessor :name
  attr_accessor :common_event_id
  attr_accessor :visible
  attr_accessor :invisible_after_transfer

  def initialize(original_map_id, event_id, event_name, current_map_id, x, y,
                 direction, character_name, character_hue)
    @original_map_id          = original_map_id
    @event_id                 = event_id
    @event_name               = event_name
    @current_map_id           = current_map_id
    @x                        = x
    @y                        = y
    @direction                = direction
    @character_name           = character_name
    @character_hue            = character_hue
    @name                     = nil
    @common_event_id          = nil
    @visible                  = true
    @invisible_after_transfer = false
  end

  def visible?
    return @visible && !@invisible_after_transfer
  end

  def interact(event)
    return if !event || event.list.size <= 1
    return if !@common_event_id
    # Start event
    $game_map.refresh if $game_map.need_refresh
    event.lock
    pbMapInterpreter.setup(event.list, event.id, event.map.map_id)
  end
end

#===============================================================================
# Permanently stores data of follower events (i.e. in save files).
#===============================================================================
class PokemonGlobalMetadata
  attr_writer   :chaser

  def chaser
    @chaser = [] if !@chaser
    return @chaser
  end
end

#===============================================================================
# Stores Game_Chaser instances just for the current play session.
#===============================================================================
class Game_Temp
  attr_writer :chasers

  def chasers
    @chasers = Game_ChaserFactory.new if !@chasers
    return @chasers
  end
end

#===============================================================================
#
#===============================================================================
class Game_ChaserFactory
  attr_reader :last_update

  def initialize
    @events      = []
    $PokemonGlobal.chaser.each do |follower|
      @events.push(create_chaser_object(follower))
    end
    @last_update = -1
  end

  #=============================================================================

  def add_chaser(event, name = nil, common_event_id = nil)
    return if !event
    followers = $PokemonGlobal.chaser
    if followers.any? { |data| data.original_map_id == $game_map.map_id && data.event_id == event.id }
      return   # Event is already dependent
    end
    eventData = ChaserData.new($game_map.map_id, event.id, event.name,
                                 $game_map.map_id, event.x, event.y, event.direction,
                                 event.character_name.clone, event.character_hue)
    eventData.name            = name
    eventData.common_event_id = common_event_id
    newEvent = create_chaser_object(eventData)
    followers.push(eventData)
    @events.push(newEvent)
    @last_update += 1
  end

  def remove_chaser_by_event(event)
    followers = $PokemonGlobal.chaser
    map_id = $game_map.map_id
    followers.each_with_index do |follower, i|
      next if follower.current_map_id != map_id
      next if follower.original_map_id != event.map_id
      next if follower.event_id != event.id
      followers[i] = nil
      @events[i] = nil
      @last_update += 1
    end
    followers.compact!
    @events.compact!
  end

  def remove_chaser_by_name(name)
    followers = $PokemonGlobal.chaser
    followers.each_with_index do |follower, i|
      next if follower.name != name
      followers[i] = nil
      @events[i] = nil
      @last_update += 1
    end
    followers.compact!
    @events.compact!
  end

  def remove_all_followers
    $PokemonGlobal.chaser.clear
    @events.clear
    @last_update += 1
  end

  def get_follower_by_index(index = 0)
    @events.each_with_index { |event, i| return event if i == index }
    return nil
  end

  def get_follower_by_name(name)
    each_follower { |event, follower| return event if follower&.name == name }
    return nil
  end

  def each_follower
    $PokemonGlobal.chaser.each_with_index { |chaser, i| yield @events[i], chaser }
  end

  #=============================================================================

  def turn_followers
    leader = $game_player
    $PokemonGlobal.chaser.each_with_index do |follower, i|
      event = @events[i]
      event.turn_towards_leader(leader)
      follower.direction = event.direction
      leader = event
    end
  end

  def move_followers
    leader = $game_player
    $PokemonGlobal.chaser.each_with_index do |follower, i|
      event = @events[i]
      event.follow_leader(leader, false, (i == 0))
      follower.x              = event.x
      follower.y              = event.y
      follower.current_map_id = event.map.map_id
      follower.direction      = event.direction
      leader = event
    end
  end

  def map_transfer_followers
    $PokemonGlobal.chaser.each_with_index do |follower, i|
      event = @events[i]
      event.map = $game_map
      event.moveto($game_player.x, $game_player.y)
      event.direction = $game_player.direction
      event.opacity   = 255
      follower.x                        = event.x
      follower.y                        = event.y
      follower.current_map_id           = event.map.map_id
      follower.direction                = event.direction
      follower.invisible_after_transfer = true
    end
  end

  def follow_into_door
    # Setting an event's move route also makes it start along that move route,
    # so we need to record all followers' current positions first before setting
    # any move routes
    follower_pos = []
    follower_pos.push([$game_player.map.map_id, $game_player.x, $game_player.y])
    $PokemonGlobal.chaser.each_with_index do |follower, i|
      event = @events[i]
      follower_pos.push([event.map.map_id, event.x, event.y])
    end
    # Calculate and set move route from each follower to player
    move_route = []
    $PokemonGlobal.chaser.each_with_index do |follower, i|
      event = @events[i]
      leader = follower_pos[i]
      vector = $map_factory.getRelativePos(event.map.map_id, event.x, event.y,
                                           leader[0], leader[1], leader[2])
      if vector[0] != 0
        move_route.prepend((vector[0] > 0) ? PBMoveRoute::Right : PBMoveRoute::Left)
      elsif vector[1] != 0
        move_route.prepend((vector[1] > 0) ? PBMoveRoute::Down : PBMoveRoute::Up)
      end
      pbMoveRoute(event, move_route + [PBMoveRoute::Opacity, 0])
    end
  end

  # Used when coming out of a door.
  def hide_followers
    $PokemonGlobal.chaser.each_with_index do |follower, i|
      event = @events[i]
      event.opacity = 0
    end
  end

  # Used when coming out of a door. Makes all followers invisible until the
  # player starts moving.
  def put_followers_on_player
    $PokemonGlobal.chaser.each_with_index do |follower, i|
      event = @events[i]
      event.moveto($game_player.x, $game_player.y)
      event.opacity = 255
      follower.x                        = event.x
      follower.y                        = event.y
      follower.invisible_after_transfer = true
    end
  end

  #=============================================================================

  def update
    followers = $PokemonGlobal.chaser
    return if followers.length == 0
    # Update all followers
    leader = $game_player
    player_moving = $game_player.moving? || $game_player.jumping?
    followers.each_with_index do |follower, i|
      event = @events[i]
      next if !@events[i]
      if follower.invisible_after_transfer && player_moving
        follower.invisible_after_transfer = false
        event.turn_towards_leader($game_player)
      end
      event.move_speed  = leader.move_speed
      event.transparent = !follower.visible?
      if $PokemonGlobal.sliding
        event.straighten
        event.walk_anime = false
      else
        event.walk_anime = true
      end
      if event.jumping? || event.moving? || !player_moving
        event.update
      elsif !event.starting
        event.set_starting
        event.update
        event.clear_starting
      end
      follower.direction = event.direction
      leader = event
    end
    # Check event triggers
    if Input.trigger?(Input::USE) && !$game_temp.in_menu && !$game_temp.in_battle &&
       !$game_player.move_route_forcing && !$game_temp.message_window_showing &&
       !pbMapInterpreterRunning?
      # Get position of tile facing the player
      facing_tile = $map_factory.getFacingTile
      # Assumes player is 1x1 tile in size
      each_follower do |event, follower|
        if event.at_coordinate?($game_player.x, $game_player.y)   # Underneath player
          next if !event.over_trigger?
        elsif facing_tile && event.map.map_id == facing_tile[0] &&
              event.at_coordinate?(facing_tile[1], facing_tile[2])   # On facing tile
          next if event.over_trigger?
        else   # Somewhere else
          next
        end
        next if event.jumping?
        follower.interact(event)
      end
    end
  end

  #=============================================================================

  private

  def create_chaser_object(event_data)
    return Game_Chaser.new(event_data)
  end
end

#===============================================================================
#
#===============================================================================
class ChaserSprites
  def initialize(viewport)
    @viewport    = viewport
    @sprites     = []
    @last_update = nil
    @disposed    = false
  end

  def dispose
    return if @disposed
    @sprites.each { |sprite| sprite.dispose }
    @sprites.clear
    @disposed = true
  end

  def disposed?
    return @disposed
  end

  def refresh
    @sprites.each { |sprite| sprite.dispose }
    @sprites.clear
    $game_temp.chasers.each_follower do |event, follower|
      @sprites.push(Sprite_Character.new(@viewport, event))
    end
  end

  def update
    if $game_temp.chasers.last_update != @last_update
      refresh
      @last_update = $game_temp.chasers.last_update
    end
    @sprites.each { |sprite| sprite.update }
  end
end

#===============================================================================
# Helper module for adding/removing/getting followers.
#===============================================================================
module Chaser
  module_function

  # @param event_id [Integer] ID of the event on the current map to be added as a follower
  # @param name [String] identifier name of the follower to be added
  # @param common_event_id [Integer] ID of the Common Event triggered when interacting with this follower
  def add(event_id, name, common_event_id)
    $game_temp.chasers.add_chaser($game_map.events[event_id], name, common_event_id)
  end

  # @param event [Game_Event] map event to be added as a follower
  def add_event(event)
    $game_temp.chasers.add_chaser(event)
  end

  # @param name [String] identifier name of the follower to be removed
  def remove(name)
    $game_temp.chasers.remove_chaser_by_name(name)
  end

  # @param event [Game_Event] map event to be removed as a follower
  def remove_event(event)
    $game_temp.chasers.remove_chaser_by_event(event)
  end

  # Removes all followers.
  def clear
    $game_temp.chasers.remove_all_followers
  end

  # @param name [String, nil] name of the follower to get, or nil for the first follower
  # @return [Game_Chaser, nil] follower object
  def get(name = nil)
    return $game_temp.chasers.get_follower_by_name(name) if name
    return $game_temp.chasers.get_follower_by_index
  end
  
  def follow_into_door
    $game_temp.chasers.follow_into_door
  end

  def hide_followers
    $game_temp.chasers.hide_followers
  end

  def put_followers_on_player
    $game_temp.chasers.put_followers_on_player
  end
end


class Game_Player < Game_Character
  def update
    last_real_x = @real_x
    last_real_y = @real_y
    super
    update_stop if $game_temp.in_menu && @stopped_last_frame
    update_screen_position(last_real_x, last_real_y)
    # Update dependent events
    if (!@moved_last_frame || @stopped_last_frame ||
       (@stopped_this_frame && $PokemonGlobal.sliding)) && (moving? || jumping?)
      $game_temp.followers.move_followers
    end
    $game_temp.followers.update
    if (!@moved_last_frame || @stopped_last_frame ||
       (@stopped_this_frame && $PokemonGlobal.sliding)) && (moving? || jumping?)
      $game_temp.chasers.move_followers
    end
    $game_temp.chasers.update
    # Count down the time between allowed bump sounds
    @bump_se -= 1 if @bump_se && @bump_se > 0
    # Finish up dismounting from surfing
    if $game_temp.ending_surf && !moving?
      pbCancelVehicles
      $game_temp.surf_base_coords = nil
      $game_temp.ending_surf = false
    end
    update_event_triggering
  end
end

class Spriteset_Global
  attr_reader :playersprite

  @@viewport2 = Viewport.new(0, 0, Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT)
  @@viewport2.z = 200

  def initialize
    @follower_sprites = FollowerSprites.new(Spriteset_Map.viewport)
    @chaser_sprites = ChaserSprites.new(Spriteset_Map.viewport)
    @playersprite = Sprite_Character.new(Spriteset_Map.viewport, $game_player)
    @picture_sprites = []
    (1..100).each do |i|
      @picture_sprites.push(Sprite_Picture.new(@@viewport2, $game_screen.pictures[i]))
    end
    @timer_sprite = Sprite_Timer.new
    update
  end

  def dispose
    @follower_sprites.dispose
    @follower_sprites = nil
    @chaser_sprites.dispose
    @chaser_sprites = nil
    @playersprite.dispose
    @playersprite = nil
    @picture_sprites.each { |sprite| sprite.dispose }
    @picture_sprites.clear
    @timer_sprite.dispose
    @timer_sprite = nil
  end

  def update
    @follower_sprites.update
    @chaser_sprites.update
    @playersprite.update
    @picture_sprites.each { |sprite| sprite.update }
    @timer_sprite.update
  end
end





def pbheshowedup
if $DEBUG && Input.press?(Input::CTRL)
return true
end
if rand(100)<31
return true
else
return false
end
end

#if $PokemonSystem.playermode == 0
class Game_Follower < Game_Event
  attr_writer :map

  def initialize(event_data)
    # Create RPG::Event to base self on
    rpg_event = RPG::Event.new(event_data.x, event_data.y)
    rpg_event.id = event_data.event_id
    rpg_event.name = event_data.event_name
    if event_data.common_event_id
      # Must setup common event list here and now
      common_event = Game_CommonEvent.new(event_data.common_event_id)
      rpg_event.pages[0].list = common_event.list
    end
    # Create self
    super(event_data.original_map_id, rpg_event, $map_factory.getMap(event_data.current_map_id))
    # Modify self
    self.character_name = event_data.character_name
    self.character_hue  = event_data.character_hue
    case event_data.direction
    when 2 then turn_down
    when 4 then turn_left
    when 6 then turn_right
    when 8 then turn_up
    end
  end

  #=============================================================================

  def move_through(direction)
    old_through = @through
    @through = true
    case direction
    when 2 then move_down
    when 4 then move_left
    when 6 then move_right
    when 8 then move_up
    end
    @through = old_through
  end

  def move_fancy(direction)
	
	#if $PokemonSystem.playermode != 0
    delta_x = (direction == 6) ? 1 : (direction == 4) ? -1 : 0
    delta_y = (direction == 2) ? 1 : (direction == 8) ? -1 : 0
    new_x = self.x + delta_x
    new_y = self.y + delta_y
    # Move if new position is the player's, or the new position is passable,
    # or self's current position is not passable
    if ($game_player.x == new_x && $game_player.y == new_y) ||
       location_passable?(new_x, new_y, 10 - direction) ||
       !location_passable?(self.x, self.y, direction)
      move_through(direction)
    end
  end

  def jump_fancy(direction, leader)
    delta_x = (direction == 6) ? 2 : (direction == 4) ? -2 : 0
    delta_y = (direction == 2) ? 2 : (direction == 8) ? -2 : 0
    half_delta_x = delta_x / 2
    half_delta_y = delta_y / 2
    if location_passable?(self.x + half_delta_x, self.y + half_delta_y, 10 - direction)
      # Can walk over the middle tile normally; just take two steps
      move_fancy(direction)
      move_fancy(direction)
    elsif location_passable?(self.x + delta_x, self.y + delta_y, 10 - direction)
      # Can't walk over the middle tile, but can walk over the end tile; jump over
      if location_passable?(self.x, self.y, direction)
        if leader.jumping?
          @jump_speed_real = leader.jump_speed_real
        else
          # This is doubled because self has to jump 2 tiles in the time it
          # takes the leader to move one tile.
          @jump_speed_real = leader.move_speed_real * 2
        end
        jump(delta_x, delta_y)
      else
        # self's current tile isn't passable; just take two steps ignoring passability
        move_through(direction)
        move_through(direction)
      end
    end
  end

  def fancy_moveto(new_x, new_y, leader)
    if self.x - new_x == 1 && self.y == new_y
      move_fancy(4)
    elsif self.x - new_x == -1 && self.y == new_y
      move_fancy(6)
    elsif self.x == new_x && self.y - new_y == 1
      move_fancy(8)
    elsif self.x == new_x && self.y - new_y == -1
      move_fancy(2)
    elsif self.x - new_x == 2 && self.y == new_y
      jump_fancy(4, leader)
    elsif self.x - new_x == -2 && self.y == new_y
      jump_fancy(6, leader)
    elsif self.x == new_x && self.y - new_y == 2
      jump_fancy(8, leader)
    elsif self.x == new_x && self.y - new_y == -2
      jump_fancy(2, leader)
    elsif self.x != new_x || self.y != new_y
      moveto(new_x, new_y)
    end
  end

  #=============================================================================

  def turn_towards_leader(leader)
    pbTurnTowardEvent(self, leader)
  end

  def follow_leader(leader, instant = false, leaderIsTrueLeader = true)
    maps_connected = $map_factory.areConnected?(leader.map.map_id, self.map.map_id)
    target = nil
    # Get the target tile that self wants to move to
    if maps_connected
      behind_direction = 10 - leader.direction
      target = $map_factory.getFacingTile(behind_direction, leader)
      if target && $map_factory.getTerrainTag(target[0], target[1], target[2]).ledge
        # Get the tile above the ledge (where the leader jumped from)
        target = $map_factory.getFacingTileFromPos(target[0], target[1], target[2], behind_direction)
      end
      target = [leader.map.map_id, leader.x, leader.y] if !target
    else
      # Map transfer to an unconnected map
      target = [leader.map.map_id, leader.x, leader.y]
    end
    # Move self to the target
    if self.map.map_id != target[0]
      vector = $map_factory.getRelativePos(target[0], 0, 0, self.map.map_id, @x, @y)
      @map = $map_factory.getMap(target[0])
      # NOTE: Can't use moveto because vector is outside the boundaries of the
      #       map, and moveto doesn't allow setting invalid coordinates.
      @x = vector[0]
      @y = vector[1]
      @real_x = @x * Game_Map::REAL_RES_X
      @real_y = @y * Game_Map::REAL_RES_Y
    end
    if instant || !maps_connected
      moveto(target[1], target[2])
    else
      fancy_moveto(target[1], target[2], leader)
    end
  end

  #=============================================================================

  def update_move
    was_jumping = jumping?
    super
    if was_jumping && !jumping?
      spriteset = $scene.spriteset(map_id)
      spriteset&.addUserAnimation(Settings::DUST_ANIMATION_ID, self.x, self.y, true, 1)
    end
  end

  #=============================================================================

  private

  def location_passable?(x, y, direction)
    this_map = self.map
    return false if !this_map || !this_map.valid?(x, y)
    return true if @through
    passed_tile_checks = false
    bit = (1 << ((direction / 2) - 1)) & 0x0f
    # Check all events for ones using tiles as graphics, and see if they're passable
    this_map.events.each_value do |event|
      next if event.tile_id < 0 || event.through || !event.at_coordinate?(x, y)
      tile_data = GameData::TerrainTag.try_get(this_map.terrain_tags[event.tile_id])
      next if tile_data.ignore_passability
      next if tile_data.bridge && $PokemonGlobal.bridge == 0
      return false if tile_data.ledge
      passage = this_map.passages[event.tile_id] || 0
      return false if passage & bit != 0
      passed_tile_checks = true if (tile_data.bridge && $PokemonGlobal.bridge > 0) ||
                                   (this_map.priorities[event.tile_id] || -1) == 0
      break if passed_tile_checks
    end
    # Check if tiles at (x, y) allow passage for followe
    if !passed_tile_checks
      [2, 1, 0].each do |i|
        tile_id = this_map.data[x, y, i] || 0
        next if tile_id == 0
        tile_data = GameData::TerrainTag.try_get(this_map.terrain_tags[tile_id])
        next if tile_data.ignore_passability
        next if tile_data.bridge && $PokemonGlobal.bridge == 0
        return false if tile_data.ledge
        passage = this_map.passages[tile_id] || 0
        return false if passage & bit != 0
        break if tile_data.bridge && $PokemonGlobal.bridge > 0
        break if (this_map.priorities[tile_id] || -1) == 0
      end
    end
    # Check all events on the map to see if any are in the way
    this_map.events.each_value do |event|
      next if !event.at_coordinate?(x, y)
      return false if !event.through && event.character_name != ""
    end
    return true
  end
end

#===============================================================================
# Data saved in $PokemonGlobal.followers.
#===============================================================================
class FollowerData
  attr_accessor :original_map_id
  attr_accessor :event_id
  attr_accessor :event_name
  attr_accessor :current_map_id
  attr_accessor :x, :y
  attr_accessor :direction
  attr_accessor :character_name, :character_hue
  attr_accessor :name
  attr_accessor :common_event_id
  attr_accessor :visible
  attr_accessor :invisible_after_transfer

  def initialize(original_map_id, event_id, event_name, current_map_id, x, y,
                 direction, character_name, character_hue)
    @original_map_id          = original_map_id
    @event_id                 = event_id
    @event_name               = event_name
    @current_map_id           = current_map_id
    @x                        = x
    @y                        = y
    @direction                = direction
    @character_name           = character_name
    @character_hue            = character_hue
    @name                     = nil
    @common_event_id          = nil
    @visible                  = true
    @invisible_after_transfer = false
  end

  def visible?
    return @visible && !@invisible_after_transfer
  end

  def interact(event)
    return if !event || event.list.size <= 1
    return if !@common_event_id
    # Start event
    $game_map.refresh if $game_map.need_refresh
    event.lock
    pbMapInterpreter.setup(event.list, event.id, event.map.map_id)
  end
end

#===============================================================================
# Permanently stores data of follower events (i.e. in save files).
#===============================================================================
class PokemonGlobalMetadata
  attr_accessor :dependentEvents   # Deprecated
  attr_writer   :followers

  def followers
    @followers = [] if !@followers
    return @followers
  end
end

#===============================================================================
# Stores Game_Follower instances just for the current play session.
#===============================================================================
class Game_Temp
  attr_writer :followers

  def followers
    @followers = Game_FollowerFactory.new if !@followers
    return @followers
  end
end

#===============================================================================
#
#===============================================================================
class Game_FollowerFactory
  attr_reader :last_update

  def initialize
    @events      = []
    $PokemonGlobal.followers.each do |follower|
      @events.push(create_follower_object(follower))
    end
    @last_update = -1
  end

  #=============================================================================

  def add_follower(event, name = nil, common_event_id = nil)
    return if !event
    followers = $PokemonGlobal.followers
    if followers.any? { |data| data.original_map_id == $game_map.map_id && data.event_id == event.id }
      return   # Event is already dependent
    end
    eventData = FollowerData.new($game_map.map_id, event.id, event.name,
                                 $game_map.map_id, event.x, event.y, event.direction,
                                 event.character_name.clone, event.character_hue)
    eventData.name            = name
    eventData.common_event_id = common_event_id
    newEvent = create_follower_object(eventData)
    followers.push(eventData)
    @events.push(newEvent)
    @last_update += 1
  end

  def remove_follower_by_event(event)
    followers = $PokemonGlobal.followers
    map_id = $game_map.map_id
    followers.each_with_index do |follower, i|
      next if follower.current_map_id != map_id
      next if follower.original_map_id != event.map_id
      next if follower.event_id != event.id
      followers[i] = nil
      @events[i] = nil
      @last_update += 1
    end
    followers.compact!
    @events.compact!
  end

  def remove_follower_by_name(name)
    followers = $PokemonGlobal.followers
    followers.each_with_index do |follower, i|
      next if follower.name != name
      followers[i] = nil
      @events[i] = nil
      @last_update += 1
    end
    followers.compact!
    @events.compact!
  end

  def remove_all_followers
    $PokemonGlobal.followers.clear
    @events.clear
    @last_update += 1
  end

  def get_follower_by_index(index = 0)
    @events.each_with_index { |event, i| return event if i == index }
    return nil
  end

  def get_follower_by_name(name)
    each_follower { |event, follower| return event if follower&.name == name }
    return nil
  end

  def each_follower
    $PokemonGlobal.followers.each_with_index { |follower, i| yield @events[i], follower }
  end

  #=============================================================================

  def turn_followers
    leader = $game_player
    $PokemonGlobal.followers.each_with_index do |follower, i|
      event = @events[i]
      event.turn_towards_leader(leader)
      follower.direction = event.direction
      leader = event
    end
  end

  def move_followers
    leader = $game_player
    $PokemonGlobal.followers.each_with_index do |follower, i|
      event = @events[i]
      event.follow_leader(leader, false, (i == 0))
      follower.x              = event.x
      follower.y              = event.y
      follower.current_map_id = event.map.map_id
      follower.direction      = event.direction
      leader = event
    end
  end

  def map_transfer_followers
    $PokemonGlobal.followers.each_with_index do |follower, i|
      event = @events[i]
      event.map = $game_map
      event.moveto($game_player.x, $game_player.y)
      event.direction = $game_player.direction
      event.opacity   = 255
      follower.x                        = event.x
      follower.y                        = event.y
      follower.current_map_id           = event.map.map_id
      follower.direction                = event.direction
      follower.invisible_after_transfer = true
    end
  end

  def follow_into_door
    # Setting an event's move route also makes it start along that move route,
    # so we need to record all followers' current positions first before setting
    # any move routes
    follower_pos = []
    follower_pos.push([$game_player.map.map_id, $game_player.x, $game_player.y])
    $PokemonGlobal.followers.each_with_index do |follower, i|
      event = @events[i]
      follower_pos.push([event.map.map_id, event.x, event.y])
    end
    # Calculate and set move route from each follower to player
    move_route = []
    $PokemonGlobal.followers.each_with_index do |follower, i|
      event = @events[i]
      leader = follower_pos[i]
      vector = $map_factory.getRelativePos(event.map.map_id, event.x, event.y,
                                           leader[0], leader[1], leader[2])
      if vector[0] != 0
        move_route.prepend((vector[0] > 0) ? PBMoveRoute::Right : PBMoveRoute::Left)
      elsif vector[1] != 0
        move_route.prepend((vector[1] > 0) ? PBMoveRoute::Down : PBMoveRoute::Up)
      end
      pbMoveRoute(event, move_route + [PBMoveRoute::Opacity, 0])
    end
  end

  # Used when coming out of a door.
  def hide_followers
    $PokemonGlobal.followers.each_with_index do |follower, i|
      event = @events[i]
      event.opacity = 0
    end
  end

  # Used when coming out of a door. Makes all followers invisible until the
  # player starts moving.
  def put_followers_on_player
    $PokemonGlobal.followers.each_with_index do |follower, i|
      event = @events[i]
      event.moveto($game_player.x, $game_player.y)
      event.opacity = 255
      follower.x                        = event.x
      follower.y                        = event.y
      follower.invisible_after_transfer = true
    end
  end

  #=============================================================================

  def update
    followers = $PokemonGlobal.followers
    return if followers.length == 0
    # Update all followers
    leader = $game_player
    player_moving = $game_player.moving? || $game_player.jumping?
    followers.each_with_index do |follower, i|
      event = @events[i]
      next if !@events[i]
      if follower.invisible_after_transfer && player_moving
        follower.invisible_after_transfer = false
        event.turn_towards_leader($game_player)
      end
      event.move_speed  = leader.move_speed
      event.transparent = !follower.visible?
      if $PokemonGlobal.sliding
        event.straighten
        event.walk_anime = false
      else
        event.walk_anime = true
      end
      if event.jumping? || event.moving? || !player_moving
        event.update
      elsif !event.starting
        event.set_starting
        event.update
        event.clear_starting
      end
      follower.direction = event.direction
      leader = event
    end
    # Check event triggers
    if Input.trigger?(Input::USE) && !$game_temp.in_menu && !$game_temp.in_battle &&
       !$game_player.move_route_forcing && !$game_temp.message_window_showing &&
       !pbMapInterpreterRunning?
      # Get position of tile facing the player
      facing_tile = $map_factory.getFacingTile
      # Assumes player is 1x1 tile in size
      each_follower do |event, follower|
        if event.at_coordinate?($game_player.x, $game_player.y)   # Underneath player
          next if !event.over_trigger?
        elsif facing_tile && event.map.map_id == facing_tile[0] &&
              event.at_coordinate?(facing_tile[1], facing_tile[2])   # On facing tile
          next if event.over_trigger?
        else   # Somewhere else
          next
        end
        next if event.jumping?
        follower.interact(event)
      end
    end
  end

  #=============================================================================

  private

  def create_follower_object(event_data)
    return Game_Follower.new(event_data)
  end
end

#===============================================================================
#
#===============================================================================
class FollowerSprites
  def initialize(viewport)
    @viewport    = viewport
    @sprites     = []
    @last_update = nil
    @disposed    = false
  end

  def dispose
    return if @disposed
    @sprites.each { |sprite| sprite.dispose }
    @sprites.clear
    @disposed = true
  end

  def disposed?
    return @disposed
  end

  def refresh
    @sprites.each { |sprite| sprite.dispose }
    @sprites.clear
    $game_temp.followers.each_follower do |event, follower|
      @sprites.push(Sprite_Character.new(@viewport, event))
    end
  end

  def update
    if $game_temp.followers.last_update != @last_update
      refresh
      @last_update = $game_temp.followers.last_update
    end
    @sprites.each { |sprite| sprite.update }
  end
end

#===============================================================================
# Helper module for adding/removing/getting followers.
#===============================================================================
module Followers
  module_function

  # @param event_id [Integer] ID of the event on the current map to be added as a follower
  # @param name [String] identifier name of the follower to be added
  # @param common_event_id [Integer] ID of the Common Event triggered when interacting with this follower
  def add(event_id, name, common_event_id)
    $game_temp.followers.add_follower($game_map.events[event_id], name, common_event_id)
  end

  # @param event [Game_Event] map event to be added as a follower
  def add_event(event)
    $game_temp.followers.add_follower(event)
  end

  # @param name [String] identifier name of the follower to be removed
  def remove(name)
    $game_temp.followers.remove_follower_by_name(name)
  end

  # @param event [Game_Event] map event to be removed as a follower
  def remove_event(event)
    $game_temp.followers.remove_follower_by_event(event)
  end

  # Removes all followers.
  def clear
    $game_temp.followers.remove_all_followers
    pbDeregisterPartner rescue nil
  end

  # @param name [String, nil] name of the follower to get, or nil for the first follower
  # @return [Game_Follower, nil] follower object
  def get(name = nil)
    return $game_temp.followers.get_follower_by_name(name) if name
    return $game_temp.followers.get_follower_by_index
  end

  def follow_into_door
    $game_temp.followers.follow_into_door
  end

  def hide_followers
    $game_temp.followers.hide_followers
  end

  def put_followers_on_player
    $game_temp.followers.put_followers_on_player
  end
end