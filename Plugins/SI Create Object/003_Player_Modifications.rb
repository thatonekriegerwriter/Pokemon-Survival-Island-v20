



class Game_Character
  def move_through2(direction)
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
  def fancy_moveto2(new_x, new_y, leader)
    if self.x - new_x == 1 && self.y == new_y
      move_fancy2(4)
    elsif self.x - new_x == -1 && self.y == new_y
      move_fancy2(6)
    elsif self.x == new_x && self.y - new_y == 1
      move_fancy2(8)
    elsif self.x == new_x && self.y - new_y == -1
      move_fancy2(2)
    elsif self.x - new_x == 2 && self.y == new_y
      jump_fancy2(4, leader)
    elsif self.x - new_x == -2 && self.y == new_y
      jump_fancy2(6, leader)
    elsif self.x == new_x && self.y - new_y == 2
      jump_fancy2(8, leader)
    elsif self.x == new_x && self.y - new_y == -2
      jump_fancy2(2, leader)
    elsif self.x != new_x || self.y != new_y
      moveto(new_x, new_y)
    end
  end
  def move_fancy2(direction)
    delta_x = (direction == 6) ? 1 : (direction == 4) ? -1 : 0
    delta_y = (direction == 2) ? 1 : (direction == 8) ? -1 : 0
    new_x = self.x + delta_x
    new_y = self.y + delta_y
    # Move if new position is the player's, or the new position is passable,
    # or self's current position is not passable
    if ($game_player.x == new_x && $game_player.y == new_y) ||
       location_passable2?(new_x, new_y, 10 - direction) ||
       !location_passable2?(self.x, self.y, direction)
      move_through2(direction)
    end
  end
    def jump_fancy2(direction, leader)
    delta_x = (direction == 6) ? 2 : (direction == 4) ? -2 : 0
    delta_y = (direction == 2) ? 2 : (direction == 8) ? -2 : 0
    half_delta_x = delta_x / 2
    half_delta_y = delta_y / 2
    if location_passable2?(self.x + half_delta_x, self.y + half_delta_y, 10 - direction)
      # Can walk over the middle tile normally; just take two steps
      move_fancy2(direction)
      move_fancy2(direction)
    elsif location_passable2?(self.x + delta_x, self.y + delta_y, 10 - direction)
      # Can't walk over the middle tile, but can walk over the end tile; jump over
      if location_passable2?(self.x, self.y, direction)
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
        move_through2(direction)
        move_through2(direction)
      end
    end
  end

  def location_passable2?(x, y, direction)
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


  def move_toward_player(target=$game_player)
      target = $game_map.events[target] if target.is_a?(Integer)
    sx = @x + (@width / 2.0) - (target.x + (target.width / 2.0))
    sy = @y - (@height / 2.0) - (target.y - (target.height / 2.0))
    return if sx == 0 && sy == 0
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      (rand(2) == 0) ? abs_sx += 1 : abs_sy += 1
    end
    if abs_sx > abs_sy
      (sx > 0) ? move_left : move_right
      if !moving? && sy != 0
        (sy > 0) ? move_up : move_down
      end
    else
      (sy > 0) ? move_up : move_down
      if !moving? && sx != 0
        (sx > 0) ? move_left : move_right
      end
    end
  end


end







 
def pbMoveTowardEvent9(event,target)
  maxsize = [$game_map.width, $game_map.height].max
  #return false if $game_temp.preventspawns==true
  return false if !pbEventCanReachPlayer?(event, target, maxsize)
  loop do
    x = event.x
    y = event.y
    event.move_toward_target(target)
    break if event.x == x && event.y == y
    while event.moving?
      Graphics.update
      Input.update
      pbUpdateSceneMap
    end
  end
  pbMoveRoute2(event, [PBMoveRoute::Wait, (Graphics.frame_rate*(rand(4)+1))])
  return true
end

class Game_Character
  def move_toward_target(target)
    sx = @x + (@width / 2.0) - (target.x + (target.width / 2.0))
    sy = @y - (@height / 2.0) - (target.y - (target.height / 2.0))
    return if sx == 0 && sy == 0
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      (rand(2) == 0) ? abs_sx += 1 : abs_sy += 1
    end
    if abs_sx > abs_sy
      (sx > 0) ? move_left : move_right
      if !moving? && sy != 0
        (sy > 0) ? move_up : move_down
      end
    else
      (sy > 0) ? move_up : move_down
      if !moving? && sx != 0
        (sx > 0) ? move_left : move_right
      end
    end
  end
end

def didMoveTowardsPlayer?(event)
pbMoveTowardPlayer9(event)
return true
end


def pbMoveTowardPlayer9(event)
  maxsize = [$game_map.width, $game_map.height].max
  #return false if $game_temp.preventspawns==true
  return if !pbEventCanReachPlayer?(event, $game_player, maxsize)
  loop do
    x = event.x
    y = event.y
    event.move_toward_player
    break if event.x == x && event.y == y
    while event.moving?
      Graphics.update
      Input.update
      pbUpdateSceneMap
    end
  end
end




# Set up various data related to the new map
EventHandlers.add(:on_enter_map, :recreate_follower_event,
  proc { |old_map_id|   # previous map ID, is 0 if no map ID
    next if old_map_id == 0 || old_map_id == $game_map.map_id
    next if $game_temp.following_ov_pokemon.empty?
	  $game_temp.following_ov_pokemon.keys.each do |key|
	         event_id = key
		     next if event_id.nil?
		     theevent = $game_temp.following_ov_pokemon[key][2]
			 next if theevent.nil?
          if theevent.following != get_cur_player
		     theevent.following=nil
			 next 
		   end
			 puts "Hey this is running while map interpA" if $game_system.map_interpreter.running?
			 $game_map.recreateEvent2(theevent) if theevent.movement_type == :FOLLOW
			 pkmn.inworld=false if theevent.movement_type != :FOLLOW
			 theevent.removeThisEventfromMap


      end

}
)

EventHandlers.add(:on_map_transfer, :recreate_follower_event,
  proc { |old_map_id|   # previous map ID, is 0 if no map ID
  
  
    next if old_map_id == 0 || old_map_id == $game_map.map_id
    next if $game_temp.following_ov_pokemon.empty?
	  $game_temp.following_ov_pokemon.keys.each do |key|
	         event_id = key
		     next if event_id.nil?
		     theevent = $game_temp.following_ov_pokemon[key][2]
			 next if theevent.nil?
          if theevent.following != get_cur_player
		     theevent.following=nil
			  next 
		   end
			 $game_map.recreateEvent2(theevent) if theevent.movement_type == :FOLLOW
			 pkmn.inworld=false if theevent.movement_type != :FOLLOW
			 theevent.removeThisEventfromMap


      end
}
)

def pbRemoveFollowerPokemon(id)
  $game_temp.following_ov_pokemon.delete(id)
end


