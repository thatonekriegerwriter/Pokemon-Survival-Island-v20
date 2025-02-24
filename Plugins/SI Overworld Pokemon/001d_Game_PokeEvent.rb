class Game_Event < Game_Character
  def should_update?(recalc = false)
    return @to_update if !recalc
    return true if @trigger && (@trigger == 3 || @trigger == 4)
    return true if @move_route_forcing || @moveto_happened
    return true if @event.name[/update/i]
    return true if @event.name[/vanishingEncounter/]
    return true if @event.name[/PlayerPkmn/]
    range = 2   # Number of tiles
    return false if self.screen_x - (@sprite_size[0] / 2) > Graphics.width + (range * Game_Map::TILE_WIDTH)
    return false if self.screen_x + (@sprite_size[0] / 2) < -range * Game_Map::TILE_WIDTH
    return false if self.screen_y_ground - @sprite_size[1] > Graphics.height + (range * Game_Map::TILE_HEIGHT)
    return false if self.screen_y_ground < -range * Game_Map::TILE_HEIGHT
    return true
  end
end

def pbBridgeLeapDown?
return $PokemonGlobal.bridge > 0 && get_cur_player.direction == 2

end
def pbBridgeLeapUp?
return $PokemonGlobal.bridge > 0 && get_cur_player.direction == 8

end
def pbNoBridgeInteractUp?
return $PokemonGlobal.bridge == 0 && get_cur_player.direction == 8

end
def pbNoBridgeInteractDown?
return $PokemonGlobal.bridge > 0 && get_cur_player.direction == 2

end
class Game_Player < Game_Character
  def pbFacingEvent4(ignoreInterpreter = false)
    return nil if $game_system.map_interpreter.running? && !ignoreInterpreter
    # Check the tile in front of the player for events
    new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    return nil if !$game_map.valid?(new_x, new_y)
    $game_map.events.each_value do |event|


      next if !event.at_coordinate?(new_x, new_y)
      next if event.jumping?
      return event
    end
    # If the tile in front is a counter, check one tile beyond that for events
    if $game_map.counter?(new_x, new_y)
      new_x += (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
      new_y += (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
      $game_map.events.each_value do |event|
        next if !event.at_coordinate?(new_x, new_y)
        next if event.jumping? || event.over_trigger?
        return event
      end
    end
    return nil
  end



end
class Interpreter
  def command_209
    character = get_character(@parameters[0])
	 if character == $game_player
	   character = get_cur_player
	 end
    if @follower_move_route
      character = Followers.get(@follower_move_route_id)
      @follower_move_route = false
      @follower_move_route_id = nil
    end
    return true if character.nil?
    character.force_move_route(@parameters[1])
    return true
  end

end
class Game_Character
  def move_type_toward_player2
    sx = @x + (@width / 2.0) - ($game_player.x + ($game_player.width / 2.0))
    sy = @y - (@height / 2.0) - ($game_player.y - ($game_player.height / 2.0))
    if sx.abs + sy.abs >= 20
      move_random
      return
    end
    case rand(6)
    when 0..4 then move_toward_player
    when 5    then move_random
    end
  end

  def move_frequency
    return @move_frequency
  end

  def lock
    return if @locked
    @prelock_direction = 0   # Was @direction but disabled
    turn_toward_player if !self.is_a?(Game_PokeEvent)
    @locked = true
  end

  def move_speed
    return @move_speed
  end
end

 def pbMovePokeEventTowardsPlayer(event,target)
	event.follow_target(target)
 end
 class Game_Character
   def move_type_random_smart
    case rand(6)
    when 0..3 then move_random_smart
    when 4    then move_forward
    when 5    then @stop_count = 0
    end
  end
  
  
   def turn_random_smart
    if $player.running==true 
    case rand(6)
    when 0 
	  move_down(false)
    when 1
	  move_left(false)
    when 2 
	  move_right(false)
    when 3 
	  move_up(false)
    when 4
	   look_at_event(self.id,get_cur_player)
    when 5
	   look_at_event(self.id,get_cur_player)
    end
	
	
	 else
    case rand(4)
    when 0 then turn_up
    when 1 then turn_right
    when 2 then turn_left
    when 3 then turn_down
    end
	end
  end
   def move_random_smart
    
	  rand = rand(4) if $player.running==false 
	  rand = rand(6) if $player.running==true 
	
     case rand
      when 0
	  move_down(false)
      when 1
	  move_left(false)
      when 2
	  move_right(false)
      when 3
	  move_up(false)
      when 4
	  move_to_another_event(get_cur_player)
      when 5
	  move_to_another_event(get_cur_player)
     end
  end
 
def move_to_another_event_blocked(target, blocked)
    sx = @x + (@width / 2.0) - (target.x + (target.width / 2.0))
    sy = @y - (@height / 2.0) - (target.y - (target.height / 2.0))
    return if sx == 0 && sy == 0
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      (rand(2) == 0) ? abs_sx += 1 : abs_sy += 1
    end
	
    potential_x = @x
    potential_y = @y
    if abs_sx > abs_sy
	     if sx > 0
          potential_x -= 1
        else
          potential_x += 1
        end
        if blocked.include?([potential_x, @y])
	        return
	     end
	
	
      (sx > 0) ? move_left : move_right
	  
      if !moving? && sy != 0
        if sy > 0
          potential_y -= 1
          if blocked.include?([@x, potential_y])
            return
          end
          move_up
        else
          potential_y += 1
          if blocked.include?([@x, potential_y])
            return
          end
          move_down
        end
      end
	  
	  
    else
	
      if sy > 0
        potential_y -= 1
      else
        potential_y += 1
      end
      if blocked.include?([@x, potential_y])
        return
      end	  
	  
      (sy > 0) ? move_up : move_down
	  
	  
      if !moving? && sx != 0
        if sx > 0
          potential_x -= 1
          if blocked.include?([potential_x, @y])
            return
          end
          move_left
        else
          potential_x += 1
          if blocked.include?([potential_x, @y])
            return
          end
          move_right
        end
      end
	  
	  
	  
    end
end


def move_toward_the_coordinate_blocked(x, y, blocked)
    sx = @x + (@width / 2.0) - (x)
    sy = @y - (@height / 2.0) - (y)
    return if sx == 0 && sy == 0
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      (rand(2) == 0) ? abs_sx += 1 : abs_sy += 1
    end
	
    potential_x = @x
    potential_y = @y
    if abs_sx > abs_sy
	     if sx > 0
          potential_x -= 1
        else
          potential_x += 1
        end
        if blocked.include?([potential_x, @y])
	        return
	     end
	
	
      (sx > 0) ? move_left : move_right
	  
      if !moving? && sy != 0
        if sy > 0
          potential_y -= 1
          if blocked.include?([@x, potential_y])
            return
          end
          move_up
        else
          potential_y += 1
          if blocked.include?([@x, potential_y])
            return
          end
          move_down
        end
      end
	  
	  
    else
	
      if sy > 0
        potential_y -= 1
      else
        potential_y += 1
      end
      if blocked.include?([@x, potential_y])
        return
      end	  
	  
      (sy > 0) ? move_up : move_down
	  
	  
      if !moving? && sx != 0
        if sx > 0
          potential_x -= 1
          if blocked.include?([potential_x, @y])
            return
          end
          move_left
        else
          potential_x += 1
          if blocked.include?([potential_x, @y])
            return
          end
          move_right
        end
      end
	  
	  
	  
    end
end

  
  
    def can_move_from_coordinate_blocked?(start_x, start_y, dir, blocked, strict = false)
    case dir
    when 2, 8   # Down, up
      y_diff = (dir == 8) ? @height - 1 : 0
      (start_x...(start_x + @width)).each do |i|
        return false if blocked.include?([i, start_y - y_diff])
        return false if !passable?(i, start_y - y_diff, dir, strict)
      end
      return true
    when 4, 6   # Left, right
      x_diff = (dir == 6) ? @width - 1 : 0
      ((start_y - @height + 1)..start_y).each do |i|
        return false if blocked.include?([start_x + x_diff, i])
        return false if !passable?(start_x + x_diff, i, dir, strict)
      end
      return true
    when 1, 3   # Down diagonals
      # Treated as moving down first and then horizontally, because that
      # describes which tiles the character's feet touch
      (start_x...(start_x + @width)).each do |i|
        return false if !passable?(i, start_y, 2, strict)
      end
      x_diff = (dir == 3) ? @width - 1 : 0
      ((start_y - @height + 1)..start_y).each do |i|
        return false if blocked.include?([start_x + x_diff, i + 1])
        return false if !passable?(start_x + x_diff, i + 1, dir + 3, strict)
      end
      return true
    when 7, 9   # Up diagonals
      # Treated as moving horizontally first and then up, because that describes
      # which tiles the character's feet touch
      x_diff = (dir == 9) ? @width - 1 : 0
      ((start_y - @height + 1)..start_y).each do |i|
        return false if blocked.include?([start_x + x_diff, i])
        return false if !passable?(start_x + x_diff, i, dir - 3, strict)
      end
      x_tile_offset = (dir == 9) ? 1 : -1
      (start_x...(start_x + @width)).each do |i|
        return false if blocked.include?([i + x_tile_offset, start_y - @height + 1])
        return false if !passable?(i + x_tile_offset, start_y - @height + 1, 8, strict)
      end
      return true
    end
    return false
  end
  
  
  
  
  def move_type_random_blocked(blocked)
    result = -1
    case rand(6)
    when 0..3 then result=0#move_random_blocked(blocked)
    when 4    then result=1#move_forward_blocked(blocked)
    when 5    then result=2#@stop_count = 0
    end
	 case result 
	   when 0
	     move_random_blocked(blocked)
	   when 1
		  move_forward if can_move_from_coordinate_blocked?(@x, @y, @direction, blocked)
	   when 2
	    @stop_count = 0
	 end
  end
  
  def move_random_blocked(blocked)
    
	  rand = rand(4) if $player.running==false 
	  rand = rand(6) if $player.running==true 
	
     case rand
      when 0
	  move_down(false) if can_move_from_coordinate_blocked?(@x, @y, 2, blocked)
      when 1
	  move_left(false) if can_move_from_coordinate_blocked?(@x, @y, 4, blocked)
      when 2
	  move_right(false) if can_move_from_coordinate_blocked?(@x, @y, 6, blocked)
      when 3
	  move_up(false) if can_move_from_coordinate_blocked?(@x, @y, 8, blocked)
      when 4
	  move_to_another_event_blocked(get_cur_player,blocked)
      when 5
	  move_to_another_event_blocked(get_cur_player,blocked)
     end
  
  
  end
end
 
 def bridge_hopping
 
 
 
 end
 
 def pokeevent_functionality
  $game_temp.preventspawns=true
   object = get_own_event
  $game_temp.preventspawns=false
   return if object.nil?
   return if !object.is_a?(Game_PokeEvent)
   object.thinking
 
 
 end
 
class Game_PokeEvent < Game_Event
  attr_accessor :event
  attr_accessor :id
  attr_accessor :pokemon # contains the original pokemon of class Pokemon
  attr_accessor :remaining_steps #counts the remaining steps of an overworld encounter before vanishing 
  attr_accessor :parasteps_steps
  attr_accessor :map_id # contains the map_id
  attr_accessor :battle_timer # contains the map_id
  attr_accessor :movement_type # contains the map_id
  attr_accessor :movement_timer # contains the map_id
  attr_accessor :still_timer # contains the map_id
  attr_accessor :angry_at # contains the map_id
  attr_accessor :angy_at_cur_tar # contains the map_id
  attr_accessor :attacked_last_call # contains the map_id
  attr_accessor :dont_attack # contains the map_id
  attr_accessor :times_not_attacking # contains the map_id
  attr_accessor :counter # the sight line of the pokemon
  attr_accessor :movement_hit_logic # contains the map_id
  attr_accessor :default_move_frequency # contains the map_id
  attr_accessor :default_move_speed # contains the map_id
  attr_accessor :steps_taken # contains the map_id
  attr_accessor :youarealreadydead # contains the map_id
  attr_accessor :iveattacked # contains the map_id
  attr_accessor :pathing # contains the map_id
  attr_accessor :cur_path # contains the map_id
  attr_accessor :isshovement # contains the map_id
  attr_accessor :disable_despawn # contains the map_id
  attr_accessor :can_pause # contains the map_id
  attr_accessor :intelligent # contains the map_id
  attr_accessor :stuck # contains the map_id
  attr_accessor :blockedtiles # contains the map_id
  attr_accessor :height_level # contains the map_id
  attr_accessor :miniboss # contains the map_id
  attr_accessor :boss # contains the map_id
  attr_accessor :movement_type_locked # contains the map_id
  attr_accessor :barreling # contains the map_id
  
  def initialize(map_id, event, pokemon, map=nil)
    super(map_id, event, map)
	@event = event
    @id  = event.id
    @map_id  = map_id
    @pokemon  = pokemon
	@iveattacked = false
	@remaining_steps  = VisibleEncounterSettings::DEFAULT_STEPS_BEFORE_VANISH
    @parasteps_steps  = 7
	@angry_at = []
    @angy_at_cur_tar  = nil
	@steps_taken  = 0
	@youarealreadydead  = false
	
	
	@movement_type = :WANDER
	@cannot_move = false
	@movement_timer = 0
	@ov_movement_timer = 7
	@still_timer = 0
	sight_line = my_sight_line
	@counter = sight_line
	
    @battle_timer  = 0
    @battle_timer  = get_battle_timer
	@times_not_attacking = 0
	@attacked_last_call = false
	@dont_attack = false
	@attacking = false
	@movement_hit_logic = false
	@pathing = []
	@blockedtiles = []
	@cur_path = 0
	@isshovement = false
	@disable_despawn = false
	@can_pause = true
	@intelligent = false
	@stuck = 0
	@height_level = 0
	@miniboss = false
	@boss = false
	@movement_type_locked = false
	@barreling = false
	
	
	@default_move_frequency = self.move_frequency
	@default_move_speed = self.move_speed
  end
  def copied_values
    return [
    :parasteps_steps,
    :angry_at,
    :angy_at_cur_tar,
    :steps_taken,
    :youarealreadydead,
    :movement_type,
    :cannot_move,
    :movement_timer,
    :ov_movement_timer,
    :still_timer,
    :counter,
    :battle_timer,
    :times_not_attacking,
    :attacked_last_call,
    :dont_attack,
    :attacking,
    :movement_hit_logic,
    :pathing,
    :blockedtiles,
    :cur_path,
    :isshovement,
    :disable_despawn,
    :can_pause,
    :intelligent,
    :stuck,
    :height_level,
    :miniboss,
    :boss,
    :movement_type_locked,
    :barreling,
    :default_move_frequency,
    :default_move_speed
  ]
  
  
  end
  def transferrable_data
   return copied_values.map { |var| instance_variable_get("@#{var}") }
  end
  
  def set_data(values)
   copied_values.each_with_index do |value, index|
      instance_variable_set("@#{value}", values[index])
   
   end
  
  end
  
  def thinking
  
   $PokemonGlobal.ov_combat.ov_combat_loop(self)
  end
  
  
  
   def attackment_actions(event,pokemon)
   	 
	 
     if rand(2)==0
       target = $game_player
     else
       target = nil
     end
	 
	 
	  rate = $PokemonGlobal.ov_combat.getRate1(event,target)
	  @battle_timer-=1 if @battle_timer>0
	  @battle_timer= 0 if @battle_timer<0
	  @ov_movement_timer-=1 if @ov_movement_timer>0
	  @ov_movement_timer= 0 if @ov_movement_timer<0
	  



   if @movement_hit_logic == false && @ov_movement_timer <= 0 && !@starting && rand(100)<=rate
     self.start
     @movement_hit_logic = true
   end
   
    return rate
   end
   def attackment_actions2(event,pokemon,rate)
   if @movement_hit_logic == false && @ov_movement_timer <= 0 && !@starting && rand(100)<=rate
     self.start
   end
   end

   def movement_actions(event,pokemon)
     return if @cannot_move == true
     return if @movement_hit_logic == true
     case @movement_type
       when :WANDER
          event.move_type_random_smart
       when :WANDERP
	       
			 yes = false
			  if @movement_type_locked==false
			anything_there1 = am_i_looking_at_something(self, 3)
				if !anything_there1.nil?
				 if anything_there1.is_a?(Game_PokeEventA) || anything_there1.is_a?(Game_Player)
					   if anything_there1.is_a?(Game_Player) && self.height_level==$PokemonGlobal.bridge
					@angy_at_cur_tar = anything_there1
					 @still_timer=0
		          @movement_type = :CHASEP
                event.move_frequency=@angy_at_cur_tar.move_frequency
                event.move_toward_the_coordinate_blocked(@angy_at_cur_tar.x,@angy_at_cur_tar.y,@blockedtiles)
				    yes = true
					  end
				 end

				end
				 if yes == false
			anything_there = am_i_looking_at_something_basic(self, 3)
				if !anything_there.nil?
				 if anything_there.is_a?(Game_PokeEventA) || anything_there.is_a?(Game_Player)
					   if anything_there1.is_a?(Game_Player) && self.height_level==$PokemonGlobal.bridge
					@angy_at_cur_tar = anything_there1
					 @still_timer=0
		          @movement_type = :CHASEP
                event.move_frequency=@angy_at_cur_tar.move_frequency
                event.move_toward_the_coordinate_blocked(@angy_at_cur_tar.x,@angy_at_cur_tar.y,@blockedtiles)
					   else
          event.move_type_random_blocked(@blockedtiles)
					  end
             else
			  
          event.move_type_random_blocked(@blockedtiles)
				 end
         else
          event.move_type_random_blocked(@blockedtiles)

				end
             end
           else
		  
          event.move_type_random_blocked(@blockedtiles) 
		     end
       when :STILLP
          @still_timer-=1 if @still_timer>0
		    event.turn_random_smart
			
				     if @movement_type_locked==false
			anything_there1 = am_i_looking_at_something(self, 3)
			 yes = false
				if !anything_there1.nil?
				 if anything_there1.is_a?(Game_PokeEventA) || anything_there1.is_a?(Game_Player)
					   if anything_there1.is_a?(Game_Player) && self.height_level!=$PokemonGlobal.bridge
					   else
					@angy_at_cur_tar = anything_there1
					 @still_timer=0
		          @movement_type = :CHASEP
                event.move_frequency=@angy_at_cur_tar.move_frequency
                event.move_toward_the_coordinate_blocked(@angy_at_cur_tar.x,@angy_at_cur_tar.y,@blockedtiles)
				    yes = true
					  end
				 end
         else

				end
				 if yes == false
			anything_there = am_i_looking_at_something_basic(self, 3)
				if !anything_there.nil?
				 if anything_there.is_a?(Game_PokeEventA) || anything_there.is_a?(Game_Player)
					   if anything_there1.is_a?(Game_Player) && self.height_level==$PokemonGlobal.bridge
					@angy_at_cur_tar = anything_there1
					 @still_timer=0
		          @movement_type = :CHASEP
                event.move_frequency=@angy_at_cur_tar.move_frequency
                event.move_toward_the_coordinate_blocked(@angy_at_cur_tar.x,@angy_at_cur_tar.y,@blockedtiles)
					    
					   else
          event.move_type_random_blocked(@blockedtiles)
					  end
				 end
				end
				
				end
               end
         @movement_type = :PATROLLING if @still_timer==0 && @movement_type == :STILLP
       when :IMMOBILE
       when :PATROLLING
	   
	   
	   
	   
         if @pathing.length==0
		     @movement_type = :WANDERP
		   else
		      override = false
	       if [self.x,self.y]!=@pathing[@cur_path] && !event.moving? && @isshovement == false
             	@isshovement = true
	         if true#move_to_location(@id,@pathing[@cur_path][0],@pathing[@cur_path][1])
				 loops = 0
			     if [self.x,self.y]!=@pathing[@cur_path]
			       while !within_one_tile?(self.x, self.y, @pathing[@cur_path][0],@pathing[@cur_path][1])
	              Input.update
                  Graphics.update
				    $scene.miniupdate
					if rand(255)<1 && @can_pause
               	  @still_timer = rand(20)+11
		            @movement_type = :STILLP
             	@isshovement = false
					   break
					end
				   if !event.moving?
				    loops += 1 
				   end
				     if @movement_type_locked==false
				   anything_there1 = am_i_looking_at_something(self, 3)
				    if !anything_there1.nil?
				     if anything_there1.is_a?(Game_PokeEventA) || anything_there1.is_a?(Game_Player)
					   if anything_there1.is_a?(Game_Player) && self.height_level==$PokemonGlobal.bridge
					@angy_at_cur_tar = anything_there1
					 @still_timer=0
		          @movement_type = :CHASEP
                event.move_frequency=@angy_at_cur_tar.move_frequency
                event.move_toward_the_coordinate_blocked(@angy_at_cur_tar.x,@angy_at_cur_tar.y,@blockedtiles)
				    override = true
					    break
					  end

						end
					 end
				   anything_there1 = am_i_looking_at_something_basic(self, special_counter)
				    if !anything_there1.nil?
				     if anything_there1.is_a?(Game_PokeEventA) || anything_there1.is_a?(Game_Player)
					   if anything_there1.is_a?(Game_Player) && self.height_level==$PokemonGlobal.bridge
					@angy_at_cur_tar = anything_there1
					 @still_timer=0
		          @movement_type = :CHASEP
                event.move_frequency=@angy_at_cur_tar.move_frequency
                event.move_toward_the_coordinate_blocked(@angy_at_cur_tar.x,@angy_at_cur_tar.y,@blockedtiles)
				    override = true
					    break
					  end

						end
					 end
                 end
               event.move_toward_the_coordinate_blocked(@pathing[@cur_path][0],@pathing[@cur_path][1],@blockedtiles)
				  break if within_one_tile?(self.x, self.y, @pathing[@cur_path][0],@pathing[@cur_path][1])
				  break if loops>=60 && !event.moving?
				   end
				  end
               event.move_toward_the_coordinate_blocked(@pathing[@cur_path][0],@pathing[@cur_path][1],@blockedtiles) if [self.x,self.y]!=@pathing[@cur_path] && override == false
			   
			      if [self.x,self.y]==@pathing[@cur_path]  && override == false
               	@still_timer = 11 + rand(20)
		         @movement_type = :STILLP
				  
				   end
			   end
			   
			   
			   
          elsif @isshovement == true && [self.x,self.y]!=@pathing[@cur_path]
		      @stuck=0 if @stuck.nil?
		       @stuck+=1
			    if @stuck>60
				    @isshovement=false
		       @stuck=0
				 end
          elsif [self.x,self.y]==@pathing[@cur_path]
		     if @cur_path+1<@pathing.length
		      @cur_path+=1 
			  else
		      @cur_path=0
			  end
             	@isshovement = false
		    end
         end












       when :CHASE
          if @angy_at_cur_tar.nil? && @angry_at.length>0
	         @angy_at_cur_tar = @angry_at[rand(@angry_at.length)]
          elsif @angry_at.length>1 && rand(100)==1
	         target = change_angry_at_target
		      @angy_at_cur_tar = target if !target.nil?
          end
		    if !@angy_at_cur_tar.nil?
			  if !within_one_tile?(self.x,self.y,@angy_at_cur_tar.x,@angy_at_cur_tar.y)
		      event.move_toward_the_coordinate(@angy_at_cur_tar.x,@angy_at_cur_tar.y) 
			  else
			   event.turn_toward_event(@angy_at_cur_tar)
			  end
          end


       when :CHASEP
	   
          if @angy_at_cur_tar.nil? && @angry_at.length>0
	         @angy_at_cur_tar = @angry_at[rand(@angry_at.length)]
          elsif @angry_at.length>1 && rand(100)==1
	         target = change_angry_at_target
		      @angy_at_cur_tar = target if !target.nil?
          end
		  
		  if !@angy_at_cur_tar.nil?
		  if pbAbsoluteDistance(@angy_at_cur_tar.x, @angy_at_cur_tar.y, self.x, self.y)<=special_counter
		    if !@angy_at_cur_tar.nil?
			  if !within_one_tile?(self.x,self.y,@angy_at_cur_tar.x,@angy_at_cur_tar.y)
		      event.move_toward_the_coordinate_blocked(@angy_at_cur_tar.x,@angy_at_cur_tar.y,@blockedtiles)
			  else
			   event.turn_toward_event(@angy_at_cur_tar)
			  end
          end
        else
		    @angy_at_cur_tar = nil
          @movement_type = :PATROLLING
			 
		  end
        else
          @movement_type = :PATROLLING
		  end



       when :FINDENEMY
          return if $game_temp.preventspawns==true
          $game_temp.preventspawns=true
          pkmn_event = getRandomOverworldOtherPokemon(event)
          if !pkmn_event.nil?
		     makeAggressiveAtPokemon(self,pkmn_event)
          end
          $game_temp.preventspawns=false
           @movement_type = :STILL
           @still_timer=120
       else
          event.move_type_random_smart
     end
     



   
   
   
   end



   def pkmnmovement2
	  event,pokemon = setup_actions
     rate = attackment_actions(event,pokemon)
     movement_actions(event,pokemon)
     attackment_actions2(event,pokemon,rate)



     @movement_hit_logic = false
    end

 
  
 
  
  
  
  
  
  
  
  
  
   def setup_actions
	@can_pause = true if @can_pause.nil?
	 @isshovement = false if @isshovement.nil?
	 @pathing = [] if @pathing.nil?
	 @cur_path = 0 if @cur_path.nil?
	 @default_move_frequency =  event.move_frequency if @default_move_frequency.nil?
	 @default_move_speed = event.move_speed if @default_move_speed.nil?
     event = self
     pokemon = self.pokemon
   
     makeAggressive(event) if $PokemonGlobal.cur_challenge!=false && !pokemon.is_aggressive?
     if is_close_patrol?
      event.move_frequency=@angy_at_cur_tar.move_frequency
      event.move_speed=@angy_at_cur_tar.move_speed+0.25 
	  
	  elsif @movement_type == :CHASE 
       event.move_frequency=@default_move_frequency+1
	  elsif @movement_type == :CHASEP
       event.move_frequency=@angy_at_cur_tar.move_frequency
	  else
     event.move_frequency=@default_move_frequency if event.move_frequency != @default_move_frequency
     event.move_speed=@default_move_speed if event.move_speed != @default_move_speed
	  
	  end
    return event,pokemon
   end
   
   def is_close_patrol?
     return false if @angy_at_cur_tar.nil?
     return false if @movement_type != :PATROL
     return true if pbAbsoluteDistance(@angy_at_cur_tar.x, @angy_at_cur_tar.y, self.x, self.y)<=3
     return false
   end
   
   def ya_running_boy
     return $player.running==true 
   end
   def special_counter
    return @counter*2 if ya_running_boy
    return @counter
   end
   

  
   def stages
    return @pokemon.stages
   end
   def dont_attack
	 @dont_attack = false if @dont_attack.nil?
    return @dont_attack
   end
   def effects
    return @pokemon.effects
   end
   
    def attack_cooldowns
     return [@battle_timer]
   end


   def get_battle_timer
    return @battle_timer + rand(Graphics.frame_rate)+Graphics.frame_rate
   end
  
  alias original_update update
  def update

    if !$game_temp.in_menu

      for anim in VisibleEncounterSettings::Perma_Enc_Animations
        anim_method = anim[0]
        anim_value = anim[1]
        anim_id = anim[2]
        if self.pokemon.method(anim_method).call == anim_value && $data_animations[anim_id]
          #spam every (animationframes + 4) frames
          if Graphics.frame_count % ($data_animations[anim_id].frames.length + 4) == 0
            #check if event on screen
            if (self.screen_x >= 0 && self.screen_x <= Graphics.width) || (self.screen_y-16 >= 0 && self.screen_y-16 <= Graphics.height)
              #Show shiny animation
              #check if event on same map as player
              if @map_id!= $game_map.map_id #different map
                sx = self.screen_x - $game_player.screen_x
                sy = self.screen_y - $game_player.screen_y
                newx = $game_player.x + (sx/32)
                newy = $game_player.y + (sy/32)
                $scene.spriteset.addUserAnimation(anim_id,newx,newy,true,1)
              else #same map
                $scene.spriteset.addUserAnimation(anim_id,x,y,true,1)
              end
            end
          end
        end
      end
    end
    original_update
  end
   
def my_sight_line
     counter_match = @event.name.match(/surrounding\(\d+\)/)
	 counter = counter_match[0] if counter_match
	 number_match = counter.match(/\d+/) if counter
	 number = number_match[0] if number_match

  return number.to_i if number
  return 3 
end

  def type
   return @pokemon
  end
  
   def id=(value)
     @event.id = value
   end

 def change_angry_at_target
 
 
    return nil
 end


  def pbFacingEvent4(ignoreInterpreter = false)
    return nil if $game_system.map_interpreter.running? && !ignoreInterpreter
    # Check the tile in front of the player for events
    new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    return nil if !$game_map.valid?(new_x, new_y)
	
	
    $game_map.events.each_value do |event|
      next if !event.at_coordinate?(new_x, new_y)
      next if event.jumping?
      return event
    end
    # If the tile in front is a counter, check one tile beyond that for events
    if $game_map.counter?(new_x, new_y)
      new_x += (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
      new_y += (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
      $game_map.events.each_value do |event|
        next if !event.at_coordinate?(new_x, new_y)
        next if event.jumping? || event.over_trigger?
        return event
      end
    end
    return nil
  end


  def is_the_styler_near_me
    mouse_loc = get_tile_mouse_on
    distance = (self.x - mouse_loc[0]).abs + (self.y - mouse_loc[1]).abs
    return distance <= 3
  end


  alias original_increase_steps increase_steps
  def increase_steps
   if self.is_a?(Game_PokeEvent)
    if @parasteps_steps.nil?
    @parasteps_steps  = 7
	end
    if @parasteps_steps <= 0 && @pokemon.status = :PARALYSIS
      @pokemon.status = :NONE
      @parasteps_steps  = 7
    else
      @parasteps_steps-=1
    end
    if @remaining_steps <= 0 && $PokemonGlobal.cur_challenge==false && @disable_despawn==false
	  removeThisEventfromMap if !($game_temp.lockontarget!=false && defined?($game_temp.lockontarget.pokemon) && $game_temp.lockontarget.pokemon == @pokemon)  
    else
      @remaining_steps-=1 if @remaining_steps>0
      @remaining_steps=40 if @remaining_steps>40
    end
   end

  end

 
  def remaining_steps
	sideDisplay("#{@pokemon.name} has #{@remaining_steps} steps left!") if @remaining_steps<11 && $PokemonGlobal.cur_challenge!=false
   @remaining_steps=40 if @remaining_steps>40
   return @remaining_steps
  end
  
  def removeThisEventfromMap
    if @pokemon.fainted?
	  pbSEPlay("faint")
	end
	 
	 pbOverworldCombat.removeEnemy(@id)
	 $selection_arrows.clear_lock_on if $game_temp.lockontarget==self
	
    if $game_map.events.has_key?(@id) and $game_map.events[@id]==self
	 pbRemoveParticleEffectfromEvent(self)
      if defined?($scene.spritesets)
        for sprite in $scene.spritesets[$game_map.map_id].character_sprites
          if sprite.character==self
            $scene.spritesets[$game_map.map_id].character_sprites.delete(sprite)
            sprite.dispose
            break
          end
        end
      end
		$ExtraEvents.removethisEvent(:POKEMON,@id,$game_map.map_id)
      $game_map.events.delete(@id)
    else
      if $map_factory
        for map in $map_factory.maps
          if map.events.has_key?(@id) and map.events[@id]==self
            if defined?($scene.spritesets) && $scene.spritesets[self.map_id] && $scene.spritesets[self.map_id].character_sprites
              for sprite in $scene.spritesets[self.map_id].character_sprites
                if sprite.character==self
                  $scene.spritesets[map.map_id].character_sprites.delete(sprite)
                  sprite.dispose
                  break
                end
              end
            end
		    $ExtraEvents.removethisEvent(:POKEMON,@id,map.map_id)
            map.events.delete(@id)
            break
          end
        end
      else
        raise ArgumentError.new(_INTL("Actually, this should not be possible"))
      end
    end
  end


  def pbFacingEvent(ignoreInterpreter = false)
    return nil if $game_system.map_interpreter.running? && !ignoreInterpreter
    # Check the tile in front of the player for events
    new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    return nil if !$game_map.valid?(new_x, new_y)
    $game_map.events.each_value do |event|
      next if !event.at_coordinate?(new_x, new_y)
      next if event.jumping? || event.over_trigger?
      return event
    end
    # If the tile in front is a counter, check one tile beyond that for events
    if $game_map.counter?(new_x, new_y)
      new_x += (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
      new_y += (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
      $game_map.events.each_value do |event|
        next if !event.at_coordinate?(new_x, new_y)
        next if event.jumping? || event.over_trigger?
        return event
      end
    end
    return nil
  end



end



