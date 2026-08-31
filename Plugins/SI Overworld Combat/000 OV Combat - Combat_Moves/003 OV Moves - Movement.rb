class OverworldCombat::Movement

  def self.cardinal_attack(user, target)
    return false unless OverworldCombat.adjacent?(user, target)
    user.turn_toward_event(target)
    return false unless OverworldCombat.target_in_front?(user, target)
	return true
  end

  def self.rushdown(user, target, push = false)
     steps = 0
	 user.turn_toward_event(target)
	 loop do 
	  return target if OverworldCombat.target_in_front?(user, target) && !push
	  break if steps >= OverworldCombat.sight_line(user)
      unless user.can_move_in_direction?(user.direction)
        event_id = $game_map.check_event(*OverworldCombat.tile_in_front(user))
        event = $game_map.events[event_id] if event_id 
        if event && (event.is_a?(Game_PokeEvent) || event.is_a?(Game_PokeEventA))
         if push
          unless event.move_forward
           return event
          end
         loop do
          OverworldCombat.update_package
          break unless user.moving?
        end
         else
          return event
         end
        else
          return :COLLIDED_WALL
        end
      end
      user.move_forward
      loop do
        OverworldCombat.update_package
        break unless user.moving?
      end

      steps += 1 unless OverworldCombat.within_cardinal_sight?(user, target) && !push
	 end 
     nil 
  end
  
  def self.projectile_attack(user, target, move, piercing = false)
    user.turn_toward_event(target)
     x, y = OverworldCombat.tile_in_front(user)

     projectile = $DynamicEvents.spawnTempEvent(x, y, move, user.direction)
     projectile.counter = user.counter
     steps = 0
	 hits = []
	 begin
     result = loop do
	   break :OUT_OF_RANGE if steps >= move.overworld_range

       if projectile.x == target.x && projectile.y == target.y
         hits << target if piercing
         break target unless piercing
       end


       if OverworldCombat.target_in_front?(projectile, target)
         hits << target if piercing
         break target unless piercing
       end
       unless projectile.can_move_in_direction?(projectile.direction)
         event_id = $game_map.check_event(*OverworldCombat.tile_in_front(projectile))
        detected_event = $game_map.events[event_id] if event_id 

         if detected_event &&(detected_event.is_a?(Game_PokeEvent) || detected_event.is_a?(Game_PokeEventA))
           if piercing
             hits << detected_event
           else
             break detected_event
           end
         else
           break :COLLIDED_WALL
         end
       end
      

       projectile.move_forward

       loop do
         OverworldCombat.update_package
         break unless projectile.moving?
       end

       steps += 1 unless OverworldCombat.within_cardinal_sight?(projectile, target)
	 end 
	 ensure
      projectile.removeThisEventfromMap if projectile
     end 
	 puts result 
     return piercing ? hits : result
  end 

  def self.displace(user, target)
    dx = target.x - user.x
    dy = target.y - user.y

    if dx.abs > dy.abs
      if dy > 0
        target.move_down_slide(false)
      else
        target.move_up_slide(false)
      end
    else
      if dx > 0
        target.move_right_slide(false)
      else
        target.move_left_slide(false)
      end
    end
  end
  def self.instant_transmission(user, target, move = nil)
    user.turn_toward_event(target)
    positions = []
  case target.direction
  when 2 # facing down
    positions << [target.x, target.y - 1]
  when 4 # facing left
    positions << [target.x + 1, target.y]
  when 6 # facing right
    positions << [target.x - 1, target.y]
  when 8 # facing up
    positions << [target.x, target.y + 1]
  end
  case target.direction
  when 2, 8
    positions << [target.x - 1, target.y]
    positions << [target.x + 1, target.y]
  when 4, 6
    positions << [target.x, target.y - 1]
    positions << [target.x, target.y + 1]
  end
  case target.direction
  when 2
    positions << [target.x, target.y + 1]
  when 4
    positions << [target.x - 1, target.y]
  when 6
    positions << [target.x + 1, target.y]
  when 8
    positions << [target.x, target.y - 1]
  end
  positions.each do |x, y|
    next unless $game_map.valid?(x, y)
    
    event = $game_map.check_event(x, y)
    next if event
    
    user.moveto(x, y)
    user.turn_toward_event(target)
	if move
    move.physical? ? pbSEPlay("Anim/PRSFX- Quick Attack") : pbSEPlay("Anim/PRSFX- Teleport") 
	end
    return target
  end
  nil
  end 
  def self.instant_transmission_random(user, target, move = nil)
    user.turn_toward_event(target)
    positions = [
    [target.x, target.y - 1],
    [target.x + 1, target.y],
    [target.x, target.y + 1],
    [target.x - 1, target.y]
  ]
  positions.shuffle.each do |x, y|
    next unless $game_map.valid?(x, y)
    
    event = $game_map.check_event(x, y)
    next if event
    
    user.moveto(x, y)
    user.turn_toward_event(target)
	if move
    move.physical? ? pbSEPlay("Anim/PRSFX- Quick Attack") : pbSEPlay("Anim/PRSFX- Teleport") 
	end
    return target
  end
  nil
  end 

  def self.area_surrounding(user, range = 1, include_corners = true)
    targets = []

    (-range..range).each do |x|
     (-range..range).each do |y|
        next if x == 0 && y == 0

        distance = x.abs + y.abs

        next if !include_corners && distance > range

        event_id = $game_map.check_event(user.x + x, user.y + y)
        event = $game_map.events[event_id] if event_id 
        if event && (event.is_a?(Game_PokeEvent) || event.is_a?(Game_PokeEventA))
          targets << event
        end
      end
    end

    targets
  end

  def self.cone_attack(user, target, move)
    user.turn_toward_event(target)
	targets = []
    x, y = OverworldCombat.tile_in_front(user)
    projectile = $DynamicEvents.spawnTempEvent(x, y, move)
    projectile.counter = user.counter
    projectile.direction = user.direction
    range = move.overworld_range
	 begin
      1.upto(range) do |distance|
        width = distance - 1

        case user.direction
        when 2 # down
          y = user.y + distance
          (-width..width).each do |offset|
            event_id = $game_map.check_event(user.x + offset, y)
			event = $game_map.events[event_id] if event_id 
            targets << event if event && !targets.include?(event)
          end

        when 8 # up
          y = user.y - distance
          (-width..width).each do |offset|
            event_id = $game_map.check_event(user.x + offset, y)
			event = $game_map.events[event_id] if event_id 
            targets << event if event && !targets.include?(event)
          end

        when 6 # right
          x = user.x + distance
          (-width..width).each do |offset|
            event_id = $game_map.check_event(x, user.y + offset)
			event = $game_map.events[event_id] if event_id 
            targets << event if event && !targets.include?(event)
          end

        when 4 # left
          x = user.x - distance
          (-width..width).each do |offset|
            event_id = $game_map.check_event(x, user.y + offset)
			event = $game_map.events[event_id] if event_id 
            targets << event if event && !targets.include?(event)
          end
    end
  end
	  ticks = 0 
	  loop do
        OverworldCombat.update_package
		ticks+=1
        break if ticks>60
      end
	 
	 
	 
	 
	 ensure
      projectile.removeThisEventfromMap if projectile
     end 
	return targets
  end 

  def self.arc_movement(user, target, move, explode = false)
    result = []
    user.turn_toward_event(target)
     x, y = OverworldCombat.tile_in_front(user)
     
     projectile = $DynamicEvents.spawnTempEvent(x, y, move)
     projectile.counter = user.counter
     projectile.direction = user.direction
	 target_x = target.x
	 target_y = target.y 
	 begin
     
       if projectile.x == target_x && projectile.y == target_y
         return [target]
       end

       dx = target_x - projectile.x
       dy = target_y - projectile.y
       distance = Math.sqrt(dx * dx + dy * dy)
	   if distance > move.overworld_range
	     scale = move.overworld_range.to_f / distance
	     dx = (dx * scale).round
		 dy = (dy * scale).round
	   end
	   
       projectile.forced_jump(dx, dy)
	   

       loop do
         OverworldCombat.update_package
         break unless projectile.moving?
       end
        event_id = $game_map.check_event(projectile.x, projectile.y, projectile)
	    detected_event = $game_map.events[event_id] if event_id 
	   if explode
	    result = OverworldCombat::Movement.area_surrounding(projectile)
		result << detected_event if detected_event && (detected_event.is_a?(Game_PokeEvent) || detected_event.is_a?(Game_PokeEventA)) && !result.include?(detected_event)
	   else
        result =  [detected_event] if detected_event && (detected_event.is_a?(Game_PokeEvent) || detected_event.is_a?(Game_PokeEventA))
       end 



       
	 ensure
      projectile.removeThisEventfromMap if projectile
     end 
     return result
  
  
  
  end 


  def self.beam_attack(user, target, move)
    result = []
    user.turn_toward_event(target)
    projectile = $DynamicEvents.spawnTempEvent(user.x, user.y, move, user.direction)
    projectile.counter = user.counter
	range = move.overworld_range
	time = move.beam_time
	
     steps = 0
	 begin
     loop do
       case projectile.direction
       when 2 # down
         1.upto(range) do |distance|
           event_id = $game_map.check_event(projectile.x, projectile.y + distance, projectile)
           result << $game_map.events[event_id] if event_id && !result.include?($game_map.events[event_id])
         end

       when 8 # up
         1.upto(range) do |distance|
           event_id = $game_map.check_event(projectile.x, projectile.y - distance, projectile)
           result << $game_map.events[event_id] if event_id && !result.include?($game_map.events[event_id])
         end

       when 6 # right
         1.upto(range) do |distance|
           event_id = $game_map.check_event(projectile.x + distance, projectile.y, projectile)
           result << $game_map.events[event_id] if event_id && !result.include?($game_map.events[event_id])
         end

       when 4 # left
         1.upto(range) do |distance|
           event_id = $game_map.check_event(projectile.x - distance, projectile.y, projectile)
           result << $game_map.events[event_id] if event_id && !result.include?($game_map.events[event_id])
         end
       end
       OverworldCombat.update_package
       steps += 1
       break if steps > time
	 end 
	 ensure
      projectile.removeThisEventfromMap if projectile
     end 
     return result
  end 

def self.orbit_step(projectile, user, clockwise = true)
  offsets = [
    [ 0,-1],  # N
    [ 1,-1],  # NE
    [ 1, 0],  # E
    [ 1, 1],  # SE
    [ 0, 1],  # S
    [-1, 1],  # SW
    [-1, 0],  # W
    [-1,-1]   # NW
  ]

  dx = projectile.x - user.x
  dy = projectile.y - user.y

  index = offsets.index([dx, dy])

  unless index
    best = 0
    best_dist = Float::INFINITY

    offsets.each_with_index do |(ox, oy), i|
      dist = (dx - ox) ** 2 + (dy - oy) ** 2
      if dist < best_dist
        best = i
        best_dist = dist
      end
    end

    index = best
  end

  index += clockwise ? 1 : -1
  index %= offsets.length

  ox, oy = offsets[index]

  target_x = user.x + ox
  target_y = user.y + oy

  if target_x > projectile.x
    projectile.move_right
  elsif target_x < projectile.x
    projectile.move_left
  end

  if target_y > projectile.y
    projectile.move_down
  elsif target_y < projectile.y
    projectile.move_up
  end
end

  def self.orbiting_attack(user, target, move, random = false)
    user.turn_toward_event(target)
     x, y = OverworldCombat.tile_in_front(user)

     projectile = $DynamicEvents.spawnTempEvent(x, y, move)
     projectile.counter = user.counter
     projectile.direction = user.direction
     steps = 0
     steps2 = 0
	 hits = []
	 time = random ? rand(50)+10 : move.attack_time

   
	 begin
	 loop do
    	break if steps2 >= time
   	    OverworldCombat::Movement.orbit_step(projectile, user)
    	OverworldCombat.update_package



    	   event_id = $game_map.check_event(projectile.x, projectile.y, projectile)
    	   detected_event = $game_map.events[event_id] if event_id

    	   if detected_event &&
     	     (detected_event.is_a?(Game_PokeEvent) ||
     	      detected_event.is_a?(Game_PokeEventA))
      	   return detected_event
     	  end
           steps2 += 1
    end

	 
	 projectile.turn_toward_event(target)
	 
     result = loop do
	   break :OUT_OF_RANGE if steps >= move.overworld_range

       if projectile.x == target.x && projectile.y == target.y
         break target
       end


       if OverworldCombat.target_in_front?(projectile, target)
         break target
       end
       unless projectile.can_move_in_direction?(projectile.direction)
         event_id = $game_map.check_event(*OverworldCombat.tile_in_front(projectile))
        detected_event = $game_map.events[event_id] if event_id 

         if detected_event &&(detected_event.is_a?(Game_PokeEvent) || detected_event.is_a?(Game_PokeEventA))
             break detected_event
         else
           break :COLLIDED_WALL
         end
       end
      

       projectile.move_forward

       loop do
         OverworldCombat.update_package
         break unless projectile.moving?
       end

       steps += 1 unless OverworldCombat.within_cardinal_sight?(projectile, target)
	 end 
	 ensure
      projectile.removeThisEventfromMap if projectile
     end 
     return result
  end 


  def self.aura_surrounding(user, target, move)
     result = []
    user.turn_toward_event(target)
    projectile = $DynamicEvents.spawnTempEvent(user.x, user.y, move, user.direction)
    projectile.counter = user.counter
	 time = move.attack_time
     steps = 0
	 begin

       loop do
         result.concat(OverworldCombat::Movement.area_surrounding(user))
         OverworldCombat.update_package
         steps += 1
         break if steps > time
       end
     ensure
      projectile.removeThisEventfromMap if projectile
	 end 
	 
 
     return result
  end 

  def self.summon_move(user, move)
   old_x = user.x
   old_y = user.y
   old_direction = user.direction
   return unless move_to_available_space(user)
   health = [user.totalhp / 4, 1].max
   summon = $DynamicEvents.spawnTempEvent(old_x, old_y, move, old_direction, health)
   summon.counter = user.counter

   return [summon]
  end 

def self.move_to_available_space(user)
  directions = [
    :move_down,
    :move_up,
    :move_right,
    :move_left
  ]

  directions.each do |direction|
    x = user.x
    y = user.y

    case direction
    when :move_down
      y += 1
    when :move_up
      y -= 1
    when :move_right
      x += 1
    when :move_left
      x -= 1
    end

    next unless user.passable?(x, y, 0)

    user.send(direction)
    return true
  end

  false
end

  def self.trapped_move(user, move)
    trap = $DynamicEvents.spawnTempEvent(user.x, user.y, move, user.direction)
    summon.counter = user.counter
  
  
    return [trap]
  end 
  
  def self.dissappearance_move(user, target, move)
    ticks = 0
    time = move.attack_time
    loop do
      OverworldCombat.update_package
      ticks += 1
      break if ticks >= time
    end
    result = OverworldCombat::Movement.cardinal_attack(user, target)
    return result
  end 

end

class Game_Character
  def move_backward_slide
    last_direction_fix = @direction_fix
    @direction_fix = true
    case @direction
    when 2 then move_up_slide(false)
    when 4 then move_right_slide(false)
    when 6 then move_left_slide(false)
    when 8 then move_down_slide(false)
    end
    @direction_fix = last_direction_fix
  end
  def move_forward_slide
    case @direction
    when 2 then return move_down_slide(false)
    when 4 then return move_left_slide(false)
    when 6 then return move_right_slide(false)
    when 8 then return move_up_slide(false)
    end
  end
  def move_generic_slide(dir, turn_enabled = true)
    turn_generic(dir) if turn_enabled
    if can_move_in_direction?(dir)
      @x += (dir == 4) ? -1 : (dir == 6) ? 1 : 0
      @y += (dir == 8) ? -1 : (dir == 2) ? 1 : 0
      increase_steps
	  return true 
    else
      check_event_trigger_touch(dir)
	  return false 
    end
  end

  def move_down_slide(turn_enabled = true)
    return move_generic_slide(2, turn_enabled)
  end

  def move_left_slide(turn_enabled = true)
    return move_generic_slide(4, turn_enabled)
  end

  def move_right_slide(turn_enabled = true)
    return move_generic_slide(6, turn_enabled)
  end

  def move_up_slide(turn_enabled = true)
    return move_generic_slide(8, turn_enabled)
  end

  def forced_jump(x_plus, y_plus)
    if x_plus != 0 || y_plus != 0
      if x_plus.abs > y_plus.abs
        (x_plus < 0) ? turn_left : turn_right
      else
        (y_plus < 0) ? turn_up : turn_down
      end
      each_occupied_tile { |i, j| return if !passable_no_events?(i + x_plus, j + y_plus, 0) }
    end
    @x = @x + x_plus
    @y = @y + y_plus
    real_distance = Math.sqrt((x_plus * x_plus) + (y_plus * y_plus))
    distance = [1, real_distance].max
    @jump_peak = distance * Game_Map::TILE_HEIGHT * 3 / 8   # 3/4 of tile for ledge jumping
    @jump_distance = [x_plus.abs * Game_Map::REAL_RES_X, y_plus.abs * Game_Map::REAL_RES_Y].max
    @jump_distance_left = 1   # Just needs to be non-zero
    if real_distance > 0   # Jumping to somewhere else
      @jump_count = 0
    else   # Jumping on the spot
      @jump_speed_real = nil   # Reset jump speed
      @jump_count = Game_Map::REAL_RES_X / jump_speed_real   # Number of frames to jump one tile
    end
    @stop_count = 0
    triggerLeaveTile
  end


  def passable_no_events?(x, y, d, strict = false)
    new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
    new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
    return false unless self.map.valid?(new_x, new_y)
    return true if @through
    if strict
      return false unless self.map.passableStrict?(x, y, d, self)
      return false unless self.map.passableStrict?(new_x, new_y, 10 - d, self)
    else
      return false unless self.map.passable?(x, y, d, self)
      return false unless self.map.passable?(new_x, new_y, 10 - d, self)
    end
    return true
  end
end 



