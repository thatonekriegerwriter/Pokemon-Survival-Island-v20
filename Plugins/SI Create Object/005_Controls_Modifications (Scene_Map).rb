

class Game_Player < Game_Character
  attr_accessor :moved_this_frame
   def stages
    return $player.stages
   end
   
   def effects
    return $player.effects
   end
   
  def update_command_new
    WorldMapDiscovery.discover_player_position unless $game_temp.current_pkmn_controlled!=false
    #puts $game_system.map_interpreter.method(:command_end).source_location
    dir = Input.dir4
    unless pbMapInterpreterRunning? || ($game_temp.message_window_showing && $PokemonGlobal.alternate_control_mode==false) || $game_temp.in_menu || $game_temp.no_moving
      # Move player in the direction the directional button is being pressed
	 if $game_temp.lockontarget!=false
      dir = locked_on_behavior(dir)
	  
	 elsif $game_temp.current_pkmn_controlled!=false
        current_pkmn_controlled_behavior(dir)
	    return
	 elsif $player.blocking
	  dir = blocking_behavior(dir)
	 else
	  if effects[PBEffects::Confusion]>0
	  
      if @moved_last_frame ||(dir > 0 && dir == @lastdir && System.uptime - @lastdirframe >= 0.075) && $game_temp.lockontarget==false && $game_temp.current_pkmn_controlled==false
        case dir
        when 8 then move_down
        when 6 then move_left
        when 4 then move_right
        when 2 then move_up
        end
      elsif dir != @lastdir  && $game_temp.lockontarget==false  && $game_temp.current_pkmn_controlled==false
        case dir
        when 8 then turn_down
        when 6 then turn_left
        when 4 then turn_right
        when 2 then turn_up
        end
      end
	  
	  
	  else
	  
      if @moved_last_frame ||(dir > 0 && dir == @lastdir && System.uptime - @lastdirframe >= 0.075) && $game_temp.lockontarget==false && $game_temp.current_pkmn_controlled==false
        case dir
        when 2 then move_down
        when 4 then move_left
        when 6 then move_right
        when 8 then move_up
        end
      elsif dir != @lastdir  && $game_temp.lockontarget==false  && $game_temp.current_pkmn_controlled==false
        case dir
        when 2 then turn_down
        when 4 then turn_left
        when 6 then turn_right
        when 8 then turn_up
        end
      end
	  
	  
	  end

     end
   


    end
    # Record last direction input
      @lastdirframe = System.uptime if dir != @lastdir
    @lastdir      = dir
	if false 
    puts "========================"
    puts "REAL_X, REAL_Y"
    puts @real_x
	puts @real_y
    puts "X, Y"
	puts @x * Game_Map::REAL_RES_X
	puts @y * Game_Map::REAL_RES_Y
    puts "MOVING"
	puts moving?
	end
  end

  def move_generic(dir, turn_enabled = true)
    turn_generic(dir, true) if turn_enabled
    if !$game_temp.encounter_triggered
      if can_move_in_direction?(dir)
        x_offset = (dir == 4) ? -1 : (dir == 6) ? 1 : 0
        y_offset = (dir == 8) ? -1 : (dir == 2) ? 1 : 0
		  if $game_map
		   event_id = $game_map.check_event(@x + x_offset,@y + y_offset)
		   if $game_map.events[event_id]
		      event = $game_map.events[event_id]
		     if event.name.include?("border")
			    type = pbEventCommentInput(event, 1, "Border")
				 if !type.nil?
				  if type=="down" && dir==2
				    return
				  elsif type=="up" && dir==8
				    return
				  elsif type=="left" && dir==4
				    return
				  elsif type=="right" && dir==6
				    return
				  end
				 end
			  end
		   end
		  end
        return if pbLedge(x_offset, y_offset, dir)
        return if pbEndSurf(x_offset, y_offset, dir)
        turn_generic(dir, true)
        if !$game_temp.encounter_triggered
          @x += x_offset
          @y += y_offset
          if $PokemonGlobal&.diving || $PokemonGlobal&.surfing
            $stats.distance_surfed += 1
          elsif $PokemonGlobal&.bicycle
            $stats.distance_cycled += 1
          else
            $stats.distance_walked += 1
          end
          $stats.distance_slid_on_ice += 1 if $PokemonGlobal.sliding
          increase_steps
        end
      elsif !check_event_trigger_touch(dir)
        bump_into_object
      end
    end
    $game_temp.encounter_triggered = false
  end    
	def blocking_behavior(dir)
      event = get_cur_player
      dir = Input.dir8
	  @direction_fix = true 
      if @moved_last_frame ||(dir > 0 && dir == @lastdir && System.uptime - @lastdirframe >= 0.075)
	   case dir
        when 9 then event.move_upper_right
        when 8 then event.move_up(false)
        when 6 then event.move_right(false)
        when 7 then event.move_upper_left
        when 4 then event.move_left(false)
        when 3 then event.move_lower_right
        when 2 then event.move_down(false)
        when 1 then event.move_lower_left
       end
      end	  

	  @direction_fix = false 
      return dir	
	end 
	def locked_on_behavior(dir)
	    $game_temp.lockontarget=false if $game_temp.player_transferring == true
        $game_temp.lockontarget=false if defined?($game_temp.lockontarget.pokemon) && $game_temp.lockontarget.pokemon.hp<1
	    return dir if $game_temp.lockontarget==false
		event = $game_player if $game_temp.current_pkmn_controlled==false
		event = $game_temp.current_pkmn_controlled if $game_temp.current_pkmn_controlled!=false
        dir = Input.dir8
		 
      if @moved_last_frame ||(dir > 0 && dir == @lastdir && System.uptime - @lastdirframe >= 0.075)
		         case dir
        when 9 then event.move_upper_right
        when 8 then event.move_up(false)
        when 6 then event.move_right(false)
        when 7 then event.move_upper_left
        when 4 then event.move_left(false)
        when 3 then event.move_lower_right
        when 2 then event.move_down(false)
        when 1 then event.move_lower_left
        end
		 
	  elsif dir != @lastdir && false
        case dir
        when 8 then event.turn_down
        when 6 then event.turn_left
        when 4 then event.turn_right
        when 2 then event.turn_up
        end


     end	  







	   pbTurnTowardEvent(event,$game_temp.lockontarget)
	   pbCameraToEvent($game_temp.lockontarget.id)
	   return dir
	end
	def current_pkmn_controlled_behavior(dir)
	   $game_temp.current_pkmn_controlled=false if $game_temp.current_pkmn_controlled.type.hp<1 || $game_temp.current_pkmn_controlled.type.inworld==false
	    return if $game_temp.current_pkmn_controlled==false

	  if $game_temp.current_pkmn_controlled.type.effects[PBEffects::Confusion]>0
	  
      if @moved_last_frame ||(dir > 0 && dir == @lastdir && System.uptime - @lastdirframe >= 0.075) && $game_temp.lockontarget==false && $game_temp.current_pkmn_controlled==false
        case dir
        when 8 then $game_temp.current_pkmn_controlled.move_down
        when 6 then $game_temp.current_pkmn_controlled.move_left
        when 4 then $game_temp.current_pkmn_controlled.move_right
        when 2 then $game_temp.current_pkmn_controlled.move_up
        end
      elsif dir != @lastdir  && $game_temp.lockontarget==false  && $game_temp.current_pkmn_controlled==false
        case dir
        when 8 then $game_temp.current_pkmn_controlled.turn_down
        when 6 then $game_temp.current_pkmn_controlled.turn_left
        when 4 then $game_temp.current_pkmn_controlled.turn_right
        when 2 then $game_temp.current_pkmn_controlled.turn_up
        end
      end
	  
	  
	  else
     if @moved_last_frame ||(dir > 0 && dir == @lastdir && System.uptime - @lastdirframe >= 0.075) && $game_temp.lockontarget==false
        case dir
        when 2 then $game_temp.current_pkmn_controlled.move_down
        when 4 then $game_temp.current_pkmn_controlled.move_left
        when 6 then $game_temp.current_pkmn_controlled.move_right
        when 8 then $game_temp.current_pkmn_controlled.move_up
        end
      elsif dir != @lastdir  && $game_temp.lockontarget==false 
        case dir
        when 2 then $game_temp.current_pkmn_controlled.turn_down
        when 4 then $game_temp.current_pkmn_controlled.turn_left
        when 6 then $game_temp.current_pkmn_controlled.turn_right
        when 8 then $game_temp.current_pkmn_controlled.turn_up
        end
      end	   
	   end







	 pbCameraToEvent($game_temp.current_pkmn_controlled.id)
	 
	 
	 
	 
	 
     if defined?(potato24)
      potato24 -= 1 if potato24>0
	  if potato24 == 0
	    potato24=nil
	  end
	 else
	 if $game_temp.current_pkmn_controlled.pbTriggerOverworldMon
      potato24 = 60
	 end
	 end
	end

#alias _SI_Player_Updating update
#  def update
#    _SI_Player_Updating
#  end






  def update_move
     
    if !@moved_last_frame || @stopped_last_frame   # Started a new step
      if pbTerrainTag.ice
        set_movement_type(:ice_sliding)
      else#if !@move_route_forcing
        faster = can_run?
        if $PokemonGlobal&.diving
          set_movement_type((faster) ? :diving_fast : :diving)
        elsif $PokemonGlobal&.surfing
          set_movement_type((faster) ? :surfing_fast : :surfing)
        elsif $PokemonGlobal&.bicycle
          set_movement_type((faster) ? :cycling_fast : :cycling)
        else
          set_movement_type((faster) ? :running : :walking)
        end
      end
      if jumping?
        if $PokemonGlobal&.diving
          set_movement_type(:diving_jumping)
        elsif $PokemonGlobal&.surfing
          set_movement_type(:surfing_jumping)
        elsif $PokemonGlobal&.bicycle
          set_movement_type(:cycling_jumping)
        else
          set_movement_type(:jumping)   # Walking speed/charset while jumping
        end
      end
    end
    super
  end


  def set_movement_type(type)
    meta = GameData::PlayerMetadata.get($player&.character_ID || 1)
    new_charset = nil
    case type
    when :fishing
      new_charset = pbGetPlayerCharset(meta.fish_charset)
    when :surf_fishing
      new_charset = pbGetPlayerCharset(meta.surf_fish_charset)
    when :diving, :diving_fast, :diving_jumping, :diving_stopped
      self.move_speed = 3 if !@move_route_forcing
      new_charset = pbGetPlayerCharset(meta.dive_charset)
    when :surfing, :surfing_fast, :surfing_jumping, :surfing_stopped
      if !@move_route_forcing
        self.move_speed = (type == :surfing_jumping) ? 3 : 4
      end
      new_charset = pbGetPlayerCharset(meta.surf_charset)
    when :cycling, :cycling_fast, :cycling_jumping, :cycling_stopped
      if !@move_route_forcing
        pbCameraSpeed(2) if FancyCamera::INCREASE_WHEN_RUNNING
        self.move_speed = (type == :cycling_jumping) ? 3 : 5
      end
      new_charset = pbGetPlayerCharset(meta.cycle_charset)
    when :running
      pbCameraSpeed(1.5) if FancyCamera::INCREASE_WHEN_RUNNING
      self.move_speed = 3.50 if !@move_route_forcing && $player.playershoes && ($player.playershoes.id == :NORMALSHOES || $player.playershoes == :SEASHOES)
      self.move_speed = 3.65 if !@move_route_forcing && $player.is_it_this_class?(:TRIATHLETE,false)
      self.move_speed = 3.65 if !@move_route_forcing && $player.playershoes && $player.playershoes.id == :MAKESHIFTRUNNINGSHOES
      self.move_speed = 3.75 if !@move_route_forcing && $player.is_it_this_class?(:HIKER) && $game_map&.name&.downcase&.include?("mountain") && $bag.has?(:POLE)
      self.move_speed = 3.75 if !@move_route_forcing && $player.playershoes && $player.playershoes.id == :RUNNINGSHOES
      self.move_speed = 4 if !@move_route_forcing && $player.has_running_shoes
      new_charset = pbGetPlayerCharset(meta.run_charset)
    when :ice_sliding
      pbCameraSpeed(1.5) if FancyCamera::INCREASE_WHEN_RUNNING
      self.move_speed = 4 if !@move_route_forcing
      new_charset = pbGetPlayerCharset(meta.walk_charset)
    else   # :walking, :jumping, :walking_stopped
      pbCameraSpeed(1) if FancyCamera::INCREASE_WHEN_RUNNING
      self.move_speed = 3 if !@move_route_forcing
      new_charset = pbGetPlayerCharset(meta.walk_charset)
    end
    if @bumping
      pbCameraSpeed(1) if FancyCamera::INCREASE_WHEN_RUNNING
      self.move_speed = 3
    end
    @character_name = new_charset if new_charset
  end


  def can_run?
    return @move_speed > 3 if @move_route_forcing
    return false if $game_temp.position_calling
    return false if $game_temp.in_menu || $game_temp.in_battle || pbMapInterpreterRunning? || $player.playerstamina==0
    return false if jumping?
    #return false if $PokemonGlobal.partner (!$player.has_running_shoes && ($player.playershoes.id == :NORMALSHOES || $player.playershoes.id == :SEASHOES))&&
    return false if pbTerrainTag.must_walk
    return $player.running #^ ($PokemonSystem.runstyle == 1)
  end
  
  def can_run_unforced?
    return false if $game_temp.position_calling
    return false if $game_temp.in_menu || $game_temp.in_battle || pbMapInterpreterRunning? || $player.playerstamina==0
    return false if jumping?
    #return false if $PokemonGlobal.partner (!$player.has_running_shoes && ($player.playershoes.id == :NORMALSHOES || $player.playershoes.id == :SEASHOES))&&
    return false if pbTerrainTag.must_walk
    return $player.running #^ ($PokemonSystem.runstyle == 1)
  end
end



def pbLedge(_xOffset, _yOffset, dir)
  if $game_player.pbFacingTerrainTag(dir).ledge
    if pbJumpToward(2, true, false, dir)
      $scene.spriteset.addUserAnimation(Settings::DUST_ANIMATION_ID, $game_player.x, $game_player.y, true, 1)
      $game_player.increase_steps
      $game_player.check_event_trigger_here([1, 2])
    end
    return true
  end
  return false
end

def pbJumpToward(dist = 1, playSound = false, cancelSurf = false, direction = $game_player.direction)
  x = $game_player.x
  y = $game_player.y
  case direction
  when 2 then $game_player.jump(0, dist)    # down
  when 4 then $game_player.jump(-dist, 0)   # left
  when 6 then $game_player.jump(dist, 0)    # right
  when 8 then $game_player.jump(0, -dist)   # up
  end
  if $game_player.x != x || $game_player.y != y
    pbSEPlay("Player jump") if playSound
    $PokemonEncounters.reset_step_count if cancelSurf
    $game_temp.ending_surf = true if cancelSurf
    while $game_player.jumping?
      Graphics.update
      Input.update
      pbUpdateSceneMap
    end
    return true
  end
  return false
end


def breathing_sound?
   ret = ($player.playerstamina <= ($player.playermaxstamina/10)) && !DialogueSound.is_playing?
	return true
  return ret
end

class Scene_Map

  def transfer_player(cancel_swimming = true)
   $PokemonGlobal.reset_selected_pokemon
    $game_temp.player_transferring = false
    old_map_id = $game_map.map_id
	if $game_temp.player_new_map_id<1000
	 $game_temp.player_new_map_id = $disk_manager.map_id($disk_manager.current_disk_id, $game_temp.player_new_map_id)
	end 
	
	
    pbCancelVehicles($game_temp.player_new_map_id, cancel_swimming)
    autofade($game_temp.player_new_map_id)
    pbBridgeOff
    @spritesetGlobal.playersprite.clearShadows
    if $game_map.map_id != $game_temp.player_new_map_id || $game_temp.disc_changing == true 
      $map_factory.setup($game_temp.player_new_map_id)
    end
    $game_temp.disc_changing=false
    $game_player.moveto($game_temp.player_new_x, $game_temp.player_new_y, true)
    case $game_temp.player_new_direction
    when 2 then $game_player.turn_down
    when 4 then $game_player.turn_left
    when 6 then $game_player.turn_right
    when 8 then $game_player.turn_up
    end
    $game_player.straighten
    $game_temp.followers.map_transfer_followers
    $PokemonGlobal.follower_pkmn.transfer_followers
    EventHandlers.trigger(:on_map_transfer, old_map_id)
    $game_map.update
    disposeSpritesets
    RPG::Cache.clear
    createSpritesets
    if $game_temp.transition_processing
      $game_temp.transition_processing = false
      Graphics.transition
    end
    $game_map.autoplay
    Graphics.frame_reset
    Input.update
  end

  def update
   $PokemonGlobal.addNewFrameCount
    loop do
      pbMapInterpreter.update
      $game_player.update
      updateMaps
      $game_system.update
      $game_screen.update
	  #$ExtraEvents.update_objects_remotely
      break unless $game_temp.player_transferring
      transfer_player(false)
      break if $game_temp.transition_processing
    end
    updateSpritesets
    if $game_temp.title_screen_calling
      SaveData.mark_values_as_unloaded
      $scene = pbCallTitle
      return
    end
    if $game_temp.transition_processing
      $game_temp.transition_processing = false
      if $game_temp.transition_name == ""
        Graphics.transition
      else
        Graphics.transition(40, "Graphics/Transitions/" + $game_temp.transition_name)
      end
    end

    return if $game_temp.message_window_showing && $PokemonGlobal.alternate_control_mode==false
    return if $game_system.map_interpreter.running?
    activate_target_event if $game_switches[556]==true
    lock_on_target_behavior if $game_temp.lockontarget!=false
    behavior_type
    controls_for_all_seasons
    directing_pokemon_attacks
    running_stuff
    punching_controls
    mouse_detection
	
   $game_temp.inv_cooldown-=1 if $game_temp.inv_cooldown>0 && $game_temp.in_inventory==false
   $game_temp.relock_prevention-=1 if $game_temp.relock_prevention>0
   $PokemonGlobal.alt_control_move = false if $PokemonGlobal.selected_pokemon_cleaned.length == 0
	
	
	
	
   
   
		 
	  
	
	
	
	
    unless $game_player.moving?
      if $game_temp.menu_calling && $game_temp.current_pkmn_controlled==false
        call_menu
      elsif $game_temp.debug_calling
        call_debug
      elsif $game_temp.ready_menu_calling
        $game_temp.ready_menu_calling = false
        $game_player.straighten
        pbUseKeyItem
      elsif $game_temp.interact_calling && !$game_temp.assigning? && $game_temp.assignment_cooldown==0
        $game_temp.interact_calling = false
        $game_player.straighten
        EventHandlers.trigger(:on_player_interact)
      elsif $game_temp.notebook_calling
	  
        $game_temp.notebook_calling = false
        $game_player.straighten
        pbFadeOutIn(99999) {NoteOpen.openWindow}
      end
    end
    
	$game_temp.assignment_cooldown -= 1 if $game_temp.assignment_cooldown>0
  end
  
	
  def activate_target_event
	  target = pbDetectTarget
	  target.start if  !target.is_a?(Integer)  && !target.is_a?(Array) &&  !target.nil?
  end



  def lock_on_target_behavior
	   if Input.press?(Input::LOCKON) && $game_temp.position_calling == false && $game_temp.currently_throwing_pkmn == false
	   
	  $selection_arrows.remove_sprite("Arrow#{$game_temp.lockontarget.id}#{$game_temp.lockontarget.name}")
	     $game_temp.lockontarget=false
		 pbCameraReset
		 $game_temp.relock_prevention=45
	   elsif Input.trigger?(Input::WHATISTHIS) && $game_temp.position_calling == false && $game_temp.currently_throwing_pkmn == false
	     LockOnScreen.get_lock_on_text
	  end
  end
  def behavior_type
      if $game_temp.position_calling == true #Input Logic for Placing Overworld Objects
	    positioning_controls
      elsif $game_temp.assigning?
	    pokemon_assignment
      elsif $game_temp.current_pkmn_controlled!=false
	    pokemon_controls
		pbDeselectAllSelected if Input.triggerex?(:TAB)
      elsif $PokemonGlobal.ball_hud_enabled == true
	    ball_hud_controls
		pbDeselectAllSelected if Input.triggerex?(:TAB)
      else #Default Logic
	    default_controls
		pbDeselectAllSelected if Input.triggerex?(:TAB)
      end
  end
  
  def pokemon_assignment
   if @assignment_marker.nil?
    @assignment_marker = PositionMarker.new($game_player.x, $game_player.y)
   end
   @assignment_marker.update 
   eventdata = $game_temp.assignment_source
   pkmn = eventdata.pokemon 
   text = _INTL("Assigning #{pkmn.name}...")
   x = $game_player.x
   y = $game_player.y
   
   case $game_player.direction
   when 2 then y += 1
   when 4 then x -= 1
   when 6 then x += 1
   when 8 then y -= 1
   end

   @assignment_marker.x = x
   @assignment_marker.y = y
   
   event_id = $game_map.check_event(x, y)
   event = $game_map.events[event_id]
   is_egg = event && event.is_a?(Game_PokeEventA) && event.pokemon.egg?
   if is_egg
    events = $DynamicEvents.block_data_at(x,y,:PETBED)
	if events.empty?
     events = $DynamicEvents.block_data_at(x,y,:PETBEDOUTDOOR)
	end 
	raise if events.length>1
	if events.length>0
	event = events[0]
	event_id = event.id
	end
   end 
   can_assign = event && event.is_a?(Game_OVEvent) && Placeable.assignable?(event.type, pkmn)
   text = _INTL("Assign #{pkmn.name} to work at #{event.station_name}?") if can_assign
   if Input.press?(Input::USE)
    if can_assign
    eventdata = $game_temp.assignment_source
    eventdata.assigned_job = event.id
	event.workers.add(pkmn.associatedevent)
    @assignment_marker.dispose
    @assignment_marker = nil 
    $game_temp.assignment_source = nil
    $game_temp.assignment_mode = false
    text = _INTL("Assigned #{pkmn.name} to work at #{event.station_name}.") if event && event.is_a?(Game_OVEvent)
	$game_temp.assignment_cooldown = 20
	end 
   elsif Input.press?(Input::BACK)
    @assignment_marker.dispose
    @assignment_marker = nil 
    $game_temp.assignment_source = nil
    $game_temp.assignment_mode = false
    text = _INTL("Cancelled Assignment for #{pkmn.name}.")
   end 
   $sidedisplay.clear_text
   sideDisplay(text, true)
  end 
  
  def controls_for_all_seasons
    if Input.trigger?(Input::AUX2) && $DEBUG && Input.pressex?(0x12)
	#	 pbEkansGame
	   # if Input.press?(Input::SHIFT)
		#  $graphics_manager.width+=50
		#  $graphics_manager.height+=50
		#  $graphics_manager.offset_x+=50
		#  $graphics_manager.offset_y-=50
		#else
		#  $graphics_manager.width-=50
		#  $graphics_manager.height-=50
		#  $graphics_manager.offset_x-=50
		#  $graphics_manager.offset_y+=50
		#end 
	#    pbShowTeleportMap
#		pbTeleportToLocation
	
 #   pbFadeOutIn { transfer_disc(1032, 0, 18, 6) }
	elsif Input.trigger?(Input::AUX2)
	elsif Input.triggerex?(Keys::CONTROLS_LIST["Home"])
	    pbHistoryScreenshot
	elsif Input.press?(Input::F9)
       $game_temp.debug_calling = true if $DEBUG
	elsif Input.press?(Input::LOCKON) && $game_temp.position_calling == false && $game_temp.in_throwing==false && $PokemonGlobal.cur_stored_fishing_rod.nil?
		 if $game_temp.relock_prevention==0
	  	 $game_temp.lockontarget=false
		  target = pbGetLockOnTarget
	  	  $game_temp.lockontarget=target if target
		 end
#	elsif Input.trigger?(Input::CYCLEMOUSETYPE)
#	  $mouse.change_mode
#	elsif false && Input.double_tap?(Input::BACK) 
#	  if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon) && $PokemonGlobal.ball_hud_enabled == true
#	     if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].inworld == true
#           pbThrowPokemon
#	     end
#	  end

	elsif Input.pressex?(0x65) && Input.pressex?(0x62) && Input.pressex?(0x68) && Input.pressex?(0x67) && Input.pressex?(0x69) && $DEBUG
	  pbFadeOutIn {
	     pbSEPlay("Fly")
	     $game_temp.player_new_map_id    = 3
	     $game_temp.player_new_x         = 24
	     $game_temp.player_new_y         = 17
	     $game_temp.player_new_direction = 2
	     $game_temp.fly_destination = nil
	     pbDismountBike
	     $scene.transfer_player
	     $game_map.autoplay
	     $game_map.refresh
	     yield if block_given?
	     pbWait(Graphics.frame_rate / 4)
	  }
	end
  end

  

  
  def directing_pokemon_attacks
	 selected_pkmn = get_selected_pokemon_event
	 return if selected_pkmn.nil?
	 return unless selected_pkmn.is_a?(Game_PokeEventA) && selected_pkmn.pokemon.is_a?(Pokemon)
	 facingEvent = selected_pkmn.pbFacingEventIgnoreOverTrigger
	 coords, terrain = get_terrain_and_coords(selected_pkmn) 
	 handle_pokemon_interaction_input(selected_pkmn, facingEvent, coords, terrain)
     set_ball_hud_type_if_x
     handle_pokemon_callback(selected_pkmn)

	
	
  




  
  
  end
  
  def handle_pokemon_interaction_input(selected_pkmn, facingEvent, coords, terrain)
		if selected_pkmn.effects[PBEffects::Confusion]!=0
			sideDisplay("#{selected_pkmn.name} is confused! It won't listen!")
			return
		end
	if Input.triggerex?(Keys::CONTROLS_LIST["9"]) && !Input.press?(Input::SHIFT)
	 overworld_interaction(selected_pkmn)
	 return 
	end  
	omniacted = false 
	(0...8).each do |i|
	 next if omniacted
     next unless Input.triggerex?(Keys::CONTROLS_LIST[(i + 1).to_s])
     next if Input.press?(Input::SHIFT)
     move = i < 4 ?  selected_pkmn.pokemon.moves[i] : selected_pkmn.pokemon.moves2[i - 4]
	 next if move.nil?
     omniacted = handle_pokemon_interaction(selected_pkmn, move, facingEvent, coords, terrain)
	end 
	
  end 
  
  def handle_pokemon_interaction(selected_pkmn, move, facingEvent, coords, terrain)
     berry_tree = (facingEvent && facingEvent.name.match?(/berryplant/i))
	 diggable_terrain = $game_map.can_dig_here?(coords, terrain) if coords && terrain
	 usable_move = move.id == :TELEPORT 
	 acted = false 
	 acted_combat = false 
	 if berry_tree
	   acted = burn_berry_tree(selected_pkmn, facingEvent, move)
	   acted = water_berry_tree(selected_pkmn, facingEvent, move) if acted == false 
	   acted = dig_berry_tree(selected_pkmn, facingEvent, move) if acted == false 
	 elsif diggable_terrain && !event_line
	   acted = dig_here(coords, move)
	 end
	 acted_combat = use_overworld_move(selected_pkmn, move)
	 acted_combat = use_overworld_special_move(selected_pkmn, move) if !acted_combat
	 acted = acted_combat if acted_combat
	 sideDisplay("#{selected_pkmn.type.name} has no reason to use #{GameData::Move.get(move.id).real_name}.") unless acted
      
	 return true if acted
	 return false
  end 
  
  def get_terrain_and_coords(event)
    facing = pbFacingTile(event.direction, event)
	coords = [facing[1],facing[2]]
    terrain = $game_map.terrain_tag(facing[1], facing[2], true)
	return coords, terrain
  end 
  
  def overworld_interaction(selected_pkmn)
  
	$PokemonGlobal.cur_stored_pokemon = selected_pkmn.pokemon if $PokemonGlobal.cur_stored_pokemon!=selected_pkmn.pokemon
    selected_pkmn.pbTriggerOverworldMon(selected_pkmn)
  end 
  
  def use_overworld_special_move(selected_pkmn, move)
	if move.pp==0
	 sideDisplay("#{selected_pkmn.pokemon.name} does not have enough PP to use that move!")
	 return false
	end 
  target_data = OverworldCombat::Moves.target_data(move.id)
	return if target_data.id != :User
  	  effects = OverworldCombat::MoveEffects.apply_primary({
        move: move,
		target_event: selected_pkmn,
		target: selected_pkmn.pokemon, 
        user_event: selected_pkmn,
        user: selected_pkmn.pokemon
      })
	  return false unless effects
	 move.pp-=1
     return true 
  end 
  
  def use_overworld_move(selected_pkmn, move)
    return false unless selected_pkmn.pokemon.attacking==false
    thefight = pbOverworldCombat
	selected_pkmn.pokemon.attacking=true
	selected_pkmn.autoattack_opportunity += 90
    DialogueSound.reset
	text = "#{selected_pkmn.pokemon.name} use #{GameData::Move.get(move.id).real_name}!"
	sideDisplay(text,false,3,false)
	text.length.times do |i|
		Graphics.update
		Input.update
		$scene.miniupdate
        DialogueSound.play_sound_effect(i, text)
	end
	result = thefight.perform_player_attack(selected_pkmn, move)
	selected_pkmn.pokemon.attacking=false
	return result
  end


  def handle_pokemon_callback(selected_pkmn)
   if Input.double_tap?(Input::MOUSERIGHT)  
      if selected_pkmn.pokemon == $PokemonGlobal.cur_stored_pokemon
	    $PokemonGlobal.set_ball_hud_type(:PKMN,true) 
	  end
	  selected_pkmn.pokemon.inworld=false
	  selected_pkmn.pokemon.effects[PBEffects::Confusion] = 0
      pbReturnPokemon(selected_pkmn.id,true)
	       
   end
  end 
  def set_ball_hud_type_if_x
   return if $PokemonGlobal.cur_stored_pokemon.nil?
   return unless Input.triggerex?(Keys::CONTROLS_LIST["X"])
   $PokemonGlobal.set_ball_hud_type(:PKMN,true) 
  end 

  def burn_berry_tree(selected_pkmn, facingEvent, move)
    return false unless move.display_type(selected_pkmn.pokemon) == :FIRE
    berrydata = get_other_data(facingEvent.id)
	# puts berrydata.nil?
	return false if berrydata.nil?
	if move.pp==0
	 sideDisplay("#{selected_pkmn.pokemon.name} does not have enough PP to use that move!")
	 return false
	end 
	berry_id = berrydata.berry_id
	return false if berry_id.nil?
    berry = GameData::Item.get(berry_id)
	berry_name = berry.name
	qnt = berrydata.berry_yield
	qnt += 1 if berrydata.cropsticks
	berrydata.reset
	berrydata.cropsticks=false
	item_id = :CHARCOAL
    item = GameData::Item.get(item_id)
	item_name = (qnt > 1) ? item.name_plural : item.name
	text = "#{selected_pkmn.pokemon.name} use #{GameData::Move.get(move.id).real_name}!"
	sideDisplay(text,false,3,false)
	if $bag.can_add?(item_id,qnt)
	  sideDisplay("#{selected_pkmn.pokemon.name} burnt down #{berry_name}, and got #{qnt} #{item_name}.")
	  itemdata = ItemData.new(item_id)
	  $bag.add(itemdata,qnt)
	  itemAnim(itemdata,qnt)
	else
	  sideDisplay("#{selected_pkmn.pokemon.name} burnt down the #{berry_name} tree!")
	end
	move.pp-=1
	return true 
  end 
  def dig_berry_tree(selected_pkmn, facingEvent, move)
    return false unless move.id == :DIG
	if move.pp==0
	 sideDisplay("#{selected_pkmn.pokemon.name} does not have enough PP to use that move!")
	 return false
	end 
	if pbDigUpBerryPlant(facingEvent)
	  move.pp-=1
	  return true 
	end 
    return false 
  end
  def dig_here(selected_pkmn, coords, move)
    return false unless move.id == :DIG
	if move.pp==0
	 sideDisplay("#{selected_pkmn.pokemon.name} does not have enough PP to use that move!")
	 return false
	end 
    if pbDigTheGround(coords, false)
	 move.pp-=1
	 return true
	
	else
	 sideDisplay("#{selected_pkmn.pokemon.name} cannot burrow any deeper!")
	 return false
	end
  end 
  def water_berry_tree(selected_pkmn, facingEvent, move)
    return false unless move.display_type(selected_pkmn.pokemon) == :WATER
    berrydata = get_other_data(facingEvent.id)
	return false if berrydata.nil?
	if move.pp==0
	 sideDisplay("#{selected_pkmn.pokemon.name} does not have enough PP to use that move!")
	 return false
	end 
	amt = move.base_damage
	berry_id = berrydata.berry_id
    berry = GameData::Item.get(berry_id)
	berry_name = berry.name
	text = "#{selected_pkmn.pokemon.name} use #{GameData::Move.get(move.id).real_name}!"
	sideDisplay(text,false,3,false)
	sideDisplay("#{selected_pkmn.pokemon.name} watered the #{berry_name} tree!")
	berrydata.water(amt)
	move.pp-=1
	return true 
  end 


  def run_button?
    (Input.press?(Input::RUNNING) || Input.trigger?(Input::RUNNING)) && get_keyname("Running")!="None"
  end 
  
  def running_stuff
    if $game_temp.position_calling == true
	 $player.running=false
     return 
	end
	if $game_temp.current_pkmn_controlled == true
	 $player.running=false
     return 
	end
	if $game_temp.disable_running==true
	 $player.running=false
    elsif Input.double_tap_dir4? && $player.playerstamina>0 && $PokemonSystem.runstyle == 0
	 $player.running=true
	elsif ($game_player.moved_last_frame || $game_player.moved_this_frame) && $player.playerstamina>0 && run_button?
	 $player.running=true
	 $player.run_pressed=true
	elsif $player.playerstamina<=0 && $player.running==true
	 $player.running=false
	elsif !$game_player.moving? && $player.running==true && !$game_player.moved_last_frame
	 $player.running=false
	end
	 $player.run_pressed=false if !run_button? && $player.run_pressed==true
  end
 
  def punching_controls
    return if $game_temp.current_pkmn_controlled != false
    return if $game_temp.position_calling == true
    $player.punch_cooldown-=1 if $player.punch_cooldown>0
    $player.weapon_cooldown-=1 if $player.weapon_cooldown>0
    if Input.trigger?(Input::PUNCH)
	    if $player.quick_access == :PUNCH
	     if $player.punch_cooldown<=0
           event, distance = pbGetTarget($game_player)
           if !distance.nil?
			  if distance==1
			   if !event.nil? 
			    if !event.is_a? Integer
			     thefight = pbOverworldCombat
			     thefight.player_action(event,:PUNCH,$game_player.direction)
			    end
			   end
			  end
           end
	     else
           sideDisplay("You are too winded from your last attack still!")
	     end
        elsif $player.quick_access == $PokemonGlobal.cur_stored_pokemon
        else
	     ItemHandlers.triggerUseFromBox($player.quick_access)
		
		end 
    end
  end
  
  def inventory_logic
     if $game_temp.inv_cooldown==0 && $game_system.menu_disabled==false && !get_cur_player.moving? && $PokemonGlobal.cur_stored_fishing_rod.nil?
	   
	  $player.store_in_inv if $player.held_item? && !$player.held_item.is_a?(Pokemon)
	  pbSEPlay("GUI menu open")
      item = Inventory.invWindow
	  pbSEPlay("GUI menu close")
      pbUseKeyItemInField(item) if item
     end 
  
  end 


  def get_selected_pokemon_event
	event_id = nil
	if $PokemonGlobal.get_selected_pokemon.length==1
		pkmn = $PokemonGlobal.selected_pokemon_cleaned[0]
	   event_id = pkmn.associatedevent
	elsif $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon)
	  event_id = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].associatedevent
	elsif !$PokemonGlobal.cur_stored_pokemon.nil?
	   event_id = $PokemonGlobal.cur_stored_pokemon.associatedevent
	end
    return nil if event_id.nil?
    return nil if $game_map.events[event_id].nil?
	$game_map.events[event_id].pokemon.attacking||=false
    return $game_map.events[event_id] 
  end 

  def mouse_detection
    if Input.double_tap?(Input::MOUSELEFT) && Input.mouse_in_window?
	     event_id=$game_map.check_event(*get_tile_mouse_on)
		#active_directed=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
	     if event_id && $game_map.events[event_id]
		  #if $game_map.events[event_id].is_a?(Game_PokeEventA) && active_directed!=:MULTISELECT && $game_map.events[event_id].name=="PlayerPkmn" && $player.party.include?($game_map.events[event_id].pokemon)
		#   if !$PokemonGlobal.selected_pokemon.include?($game_map.events[event_id].pokemon) && $game_map.events[event_id].pokemon.deselecttimer==0
		#    pbTogglePokemonSelection(pkmn)
		#   else
	    #    $game_map.events[event_id].pokemon.deselecttimer = 50
	    #    pbTogglePokemonSelection(pkmn)
		#   end
          if Input.press?(Input::CTRL) && $DEBUG 
		     if $DEBUG	  
		     nuevent = $game_map.events[event_in_question]
		      puts "You are clicking on: #{nuevent.name}" if $DEBUG
		      puts "You are clicking on: #{nuevent.event.pages[0].move_route.list[0].code}" if event_in_question.name=="PlayerPkmn" && $DEBUG
		     end
		   
		  end
	     end
    end
    if Input.double_tap?(Input::TOGGLETYPE) && Input.mouse_in_window?
	   current_order = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
       selected = $PokemonGlobal.selected_pokemon_cleaned.dup
	   multiselect = selected.length>0
	   tiles = *get_tile_with_direction
	   event_id = $game_map.check_event(tiles[0],tiles[1])
	   selected_event = event_id.is_a?(Game_Player) ? event_id : $game_map.events[event_id]
       if !multiselect && selected_event.is_a?(Game_PokeEventA) && selected_event.pokemon.deselecttimer==0 && selected_event.pokemon.able?
         if $PokemonGlobal.selected_pokemon.include?(selected_event.pokemon)
            pbDeselectThisPokemon(selected_event.pokemon)
		 else
	        selected_event.pokemon.deselecttimer = 50
	        pbSelectThisPokemon(selected_event.pokemon)
		 end 
		 return
       end 
		active_directed=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
		pokemon_list = []
		if multiselect
         return if selected.length <= 1
		 pokemon_list = selected.reject { |pkmn| pkmn == 0 }.map { |pkmn| pkmn.associatedevent }
        elsif $PokemonGlobal.ball_hud_enabled && current_order.is_a?(Pokemon)
		 pokemon_list << current_order.associatedevent
        elsif !$PokemonGlobal.cur_stored_pokemon.nil?
		 pokemon_list << $PokemonGlobal.cur_stored_pokemon.associatedevent
        elsif (single = $PokemonGlobal.get_single_selected_pokemon)
		 pokemon_list << single.associatedevent
        end
		return if pokemon_list.empty?
        pokemon_list.each do |list_event_id| 
		  next if list_event_id.nil?
          event = $game_map.events[list_event_id]
		  next if event.nil?
		  next if !event.respond_to?("pokemon")
		  pkmn = event.pokemon
		  next if pkmn.nil?
		  process_pokemon(tiles,event,selected_event,pkmn,event_id)
		end
	end
  end
  
  def process_pokemon(tiles,event,target_event,pkmn,event_id)
		if pkmn.effects[PBEffects::Confusion]!=0
			sideDisplay("#{pkmn.name} is confused! It won't listen!")
			return
		end
		puts "#{pkmn.name} is on: X: #{event.x}, Y: #{event.y}" if $DEBUG
		
		  x_plus = tiles[0] - event.x
          y_plus = tiles[1] - event.y

          direction =  if x_plus.abs > y_plus.abs
           x_plus < 0 ? 4 : 6
          else
           y_plus < 0 ? 8 : 2
          end

          if event.direction != direction
            event.direction = direction
			puts "#{event.pokemon.name} is turning"
            return
          end
  
		if true
		  if get_cur_player == target_event
            event.following = get_cur_player
            event.movement_type = :MOVEBEHINDPLAYER 
		    sideDisplay("#{event.type.name} is now following #{target_event.pokemon.name}.")
			return
		  end



			puts "#{event.pokemon.name} is walking."
		  if event.move_with_maps(event.map_id, tiles[0],tiles[1])
		  
		  
		  
            event.movement_type = :STILL
            event.still_timer=-1
            loops = 0
            if [event.x, event.y]!=[tiles[0],tiles[1]]
			   while !within_one_tile?(event.x, event.y, tiles[0],tiles[1])
	             Input.update
                 Graphics.update
				 self.miniupdate
				 if !event.moving?
				  loops += 1 
				 end
		         #puts "Not within one tile"
				 if within_one_tile?(event.x, event.y, tiles[0],tiles[1])
		            #puts "within one tile"
				    break 
				 end
				 if loops>=60 && !event.moving?
		            puts "broke loop"
				    break
				 end 
			   end
               if within_one_tile?(event.x, event.y, tiles[0],tiles[1])
	             if (event_id.is_a?(Integer) || event_id.is_a?(String))
                  look_at_location(event.id,target_event.x,target_event.y)
				  if target_event.is_a?(Game_PokeEvent)
				    event.add_target(event_id,target_event) 
                    event.following = target_event
				    event.movement_type = :FOLLOW
				  end
				  if target_event.name.include?("inter") && !event.moving?
			      target_event.interaction_source = event
                  target_event.start 
				  look_at_location(event.id,target_event.x,target_event.y)
				  end
	             elsif event_id==$game_player
	             end
              end
            end







		  else
            puts "It's failing"
		  end

        end 
        #puts event.movement_type if $DEBUG
  end
  
  
   # positioning_controls is in 004 Placeable Logic. 
  

  def pokemon_controls
    return if $game_temp.current_pkmn_controlled == false
    return if $game_temp.position_calling == true
    $PokemonGlobal.ball_hud_enabled = false
	 event = $game_temp.current_pkmn_controlled
    pkmn = $game_temp.current_pkmn_controlled.type
    if Input.triggerex?(0x31)
	  $PokemonGlobal.hud_selector = 0
    elsif Input.triggerex?(0x32)
	  $PokemonGlobal.hud_selector = 1
    elsif Input.triggerex?(0x33)
	  $PokemonGlobal.hud_selector = 2
    elsif Input.triggerex?(0x34)
	  $PokemonGlobal.hud_selector = 3
    elsif Input.triggerex?(0x35)
	  $PokemonGlobal.hud_selector = 4
    elsif Input.trigger?(Input::BACK)
	  $game_temp.interact_calling = true
	 elsif Input.trigger?(Input::QUICKACCESSREGISTER) 
      current_selection=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
	  if current_selection.is_a?(Symbol) || current_selection.is_a?(Pokemon)  || current_selection.is_a?(Pokemon) 
	     if $player.quick_access == current_selection
		    $player.quick_access = :PUNCH
	        sideDisplay(_INTL("You are now unarmed."))
		 else
		    $player.quick_access = current_selection
	        sideDisplay(_INTL("You will now use #{current_selection.name} instead of punching."))
		 end 
	  end
    elsif Input.trigger?(Input::JUMPUP) || Input.scroll_v==1
	  if $PokemonGlobal.hud_selector == 0
		$PokemonGlobal.hud_selector = 4
	  else 
		$PokemonGlobal.hud_selector -= 1
	  end
    elsif Input.trigger?(Input::JUMPDOWN) || Input.scroll_v==-1
	  if $PokemonGlobal.hud_selector == 4
		$PokemonGlobal.hud_selector = 0
	  else 
		$PokemonGlobal.hud_selector += 1
	  end
    elsif Input.trigger?(Input::USE)
		if pkmn.effects[PBEffects::Confusion]!=0
			sideDisplay("#{pkmn.name} is confused! It won't listen!")
			return
		end
	  if $PokemonGlobal.hud_selector!=4
	        use_overworld_move(event, pkmn.moves[$PokemonGlobal.hud_selector])
	  else
	   facingEvent = event.pbFacingEvent
	   if !facingEvent.nil?
		 if facingEvent==$game_player
			pbMessage(_INTL("That's #{$player.name}!", ))
		 elsif facingEvent.name.include?("inter")
		 end
	   end
	  end
 

 elsif Input.trigger?(Input::INVENTORY)
     inventory_logic
    elsif Input.trigger?(Input::ACTION)
	  if $game_temp.menu_calling==false
		 $game_temp.menu_calling = true
		 $game_temp.menu_beep = true
	  else
		 $game_temp.menu_calling = false
		 $game_temp.menu_beep = false
	  end
	end
  end
  def is_buckler?(current_selection)
    return false unless current_selection.is_a?(ItemData)
    return true if current_selection.id == :BUCKLER
	return false 
  end 
 
  def ball_hud_controls
    if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].nil?
	 $PokemonGlobal.ball_hud_index+=1
     $PokemonGlobal.ball_hud_index=0 if $PokemonGlobal.ball_hud_index>=$PokemonGlobal.ball_order.length
	end

    return if $PokemonGlobal.ball_hud_enabled == false
    return if $game_system.menu_disabled
    return if $game_temp.current_pkmn_controlled == true
    return if $game_temp.position_calling == true
	$PokemonGlobal.alt_control_move=false if  $PokemonGlobal.ball_hud_type!=:PKMN
    current_selection=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
	
	blocking = Input.held_for?(Input::USE) > 10 && is_buckler?(current_selection)
	unless blocking
     $player.stop_blocking
    if Input.trigger?(Input::USE)
      $game_temp.interact_calling = true
	elsif Input.trigger?(Input::QUICKACCESSREGISTER) 
	  if current_selection.is_a?(Symbol) || current_selection.is_a?(Pokemon)  || current_selection.is_a?(ItemData) 
	     if $player.quick_access == current_selection
		    $player.quick_access = :PUNCH
	        sideDisplay(_INTL("You are now unarmed."))
		 else
		    $player.quick_access = current_selection
	        sideDisplay(_INTL("You will now use #{current_selection.name} instead of punching."))
		 end 
	  end
	 
	 elsif Input.trigger?(Input::TOGGLEHUD) #X
	   if $PokemonGlobal.cur_stored_fishing_rod.nil?
	   if $PokemonGlobal.alt_control_move==false && $PokemonGlobal.cur_stored_pokemon.nil? 
         $PokemonGlobal.ball_hud_enabled = false
	   else
	    $PokemonGlobal.set_ball_hud_type($PokemonGlobal.ball_hud_type_old)
	   end
	   end
	 elsif Input.double_tap?(Input::TOGGLETYPE)
	#    $game_temp.radial_enabled= !$game_temp.radial_enabled
	#     pbSEPlay("GUI sel decision", 60) 
	#  $mouse.set_mode(:FOLLOW)
	 elsif Input.trigger?(Input::SPECIAL)
	  amt = $PokemonGlobal.selected_pokemon_cleaned.length
      $PokemonGlobal.ball_hud_enabled = false if $PokemonGlobal.alt_control_move==true || !$PokemonGlobal.cur_stored_pokemon.nil?
      if amt==1
	    pkmn = $PokemonGlobal.selected_pokemon_cleaned[0]
	   if $PokemonGlobal.cur_stored_pokemon!=pkmn
	    $PokemonGlobal.set_ball_hud_type(:MOVES,true,pkmn)
	   end

	  elsif amt>1
	   if $PokemonGlobal.alt_control_move==false
	     pbDeselectThisPokemon($PokemonGlobal.ball_order[0]) if $PokemonGlobal.ball_order[0]!=0
	     pbSelectThisPokemon($PokemonGlobal.ball_order[0],true) if $PokemonGlobal.ball_order[0]!=0
	     $PokemonGlobal.set_ball_hud_type(:MULTISELECT,true) 
	     pbSEPlay("GUI sel decision", 60) 
	   
	   
	   else
	     $PokemonGlobal.set_ball_hud_type(:PKMN,true) 
	     pbSEPlay("GUI sel decision", 60) 
	   
	   
	   end
      end
    elsif Input.trigger?(Input::INVENTORY)
      inventory_logic
	 elsif Input.trigger?(Input::ACTION)
      unless $game_system.menu_disabled || $game_player.moving?
        $game_temp.menu_calling = true
        $game_temp.menu_beep = true
      end

	 elsif Input.trigger?(Input::EXPAND)
	 if $PokemonGlobal.ball_order.length > 1
	  $PokemonGlobal.set_extended_hud=!$PokemonGlobal.set_extended_hud 
	  $OverworldMenu.should_refresh = true 
	  pbSEPlay("GUI sel decision", 60) 
	 end
	 elsif Input.trigger?(Input::JUMPDOWN) || Input.scroll_v==-1 
      if $game_temp.in_throwing==false
	  if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon) && $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].inworld
	     pbDeselectThisPokemon($PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index])
	  end 
        $PokemonGlobal.ball_hud_index-=1
        $PokemonGlobal.ball_hud_index=($PokemonGlobal.ball_order.length-1) if $PokemonGlobal.ball_hud_index<0

        pbSEPlay("GUI sel cursor", 60)if $PokemonGlobal.ball_order.length>1
        $OverworldMenu.should_refresh=true 
      end

	 elsif Input.trigger?(Input::JUMPUP) || Input.scroll_v==1 #D
      if $game_temp.in_throwing==false
	  if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon) && $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].inworld
	     pbDeselectThisPokemon($PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index])
	  end 
        $PokemonGlobal.ball_hud_index+=1
        $PokemonGlobal.ball_hud_index=0 if $PokemonGlobal.ball_hud_index>=$PokemonGlobal.ball_order.length
        pbSEPlay("GUI sel cursor", 60) if $PokemonGlobal.ball_order.length>1
       $OverworldMenu.should_refresh=true 
      end

	 elsif Input.trigger?(Input::TOGGLETYPE)
     # $PokemonGlobal.set_extended_hud=false if $PokemonGlobal.set_extended_hud==true
	#     if $PokemonGlobal.ball_hud_type==:PKMN
	#       $PokemonGlobal.set_ball_hud_type(:ITEM,true)
	#	  elsif $PokemonGlobal.ball_hud_type==:ITEM
	#       $PokemonGlobal.set_ball_hud_type(:PKMN,true)
	#	  end
	#  pbSEPlay("GUI sel decision", 60) 
	 elsif  Input.press?(Input::NOTEBOOK) && $game_system.menu_disabled==false && $PokemonGlobal.cur_stored_fishing_rod.nil?
	  $game_temp.notebook_calling=true
	 else#if
	  if $PokemonGlobal.cur_stored_fishing_rod.nil?
      if !$PokemonGlobal.cur_stored_pokemon.nil?

    if Input.triggerex?(Keys::CONTROLS_LIST["1"]) && Input.press?(Input::SHIFT) 
	   $PokemonGlobal.set_ball_hud_type(:RADIAL,true)
    elsif Input.triggerex?(Keys::CONTROLS_LIST["2"]) && Input.press?(Input::SHIFT)
	   $PokemonGlobal.set_ball_hud_type(:FAVORITES,true)
    elsif Input.triggerex?(Keys::CONTROLS_LIST["3"]) && Input.press?(Input::SHIFT)
	   $PokemonGlobal.set_ball_hud_type(:PKMN,true) 
    elsif Input.triggerex?(Keys::CONTROLS_LIST["4"]) && Input.press?(Input::SHIFT)
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:TOOL,true)
	     pbSEPlay("GUI sel decision", 60) 
    elsif Input.triggerex?(Keys::CONTROLS_LIST["5"]) && Input.press?(Input::SHIFT)
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_weapon_permanent
	     pbSEPlay("GUI sel decision", 60) 
    elsif Input.triggerex?(Keys::CONTROLS_LIST["6"]) && Input.press?(Input::SHIFT)
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:BATTLE,true)
	     pbSEPlay("GUI sel decision", 60) 
   elsif Input.triggerex?(Keys::CONTROLS_LIST["7"]) && Input.press?(Input::SHIFT)
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:PLACE,true)
	     pbSEPlay("GUI sel decision", 60) 
   elsif  Input.triggerex?(Keys::CONTROLS_LIST["8"]) && Input.press?(Input::SHIFT)
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:CROPS,true)
	     pbSEPlay("GUI sel decision", 60) 
    end



	  
	  
      elsif $PokemonGlobal.cur_stored_pokemon.nil?
	  
    if Input.triggerex?(Keys::CONTROLS_LIST["1"])
	   $PokemonGlobal.set_ball_hud_type(:RADIAL,true)
    elsif Input.triggerex?(Keys::CONTROLS_LIST["2"])
	   $PokemonGlobal.set_ball_hud_type(:FAVORITES,true)
    elsif Input.triggerex?(Keys::CONTROLS_LIST["3"])
	   $PokemonGlobal.set_ball_hud_type(:PKMN,true) 
    elsif Input.triggerex?(Keys::CONTROLS_LIST["4"])
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:TOOL,true)
	     pbSEPlay("GUI sel decision", 60) 
    elsif Input.triggerex?(Keys::CONTROLS_LIST["5"])
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_weapon_permanent
	     pbSEPlay("GUI sel decision", 60) 
    elsif Input.triggerex?(Keys::CONTROLS_LIST["6"])
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:BATTLE,true)
	     pbSEPlay("GUI sel decision", 60) 
   elsif Input.triggerex?(Keys::CONTROLS_LIST["7"])
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:PLACE,true)
	     pbSEPlay("GUI sel decision", 60) 
   elsif  Input.triggerex?(Keys::CONTROLS_LIST["8"])
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:CROPS,true)
	     pbSEPlay("GUI sel decision", 60) 
    end
	   end
  	  end 
	 end
    else 
     $player.begin_blocking
    end 


  end
  def default_controls
    return if $PokemonGlobal.ball_hud_enabled == true
    return if $game_temp.current_pkmn_controlled == true
    return if $game_temp.position_calling == true
    if Input.trigger?(Input::USE)
      $game_temp.interact_calling = true
    elsif Input.trigger?(Input::INVENTORY)
       inventory_logic
    elsif Input.trigger?(Input::ACTION)
      unless $game_system.menu_disabled || $game_player.moving?
	    $game_temp.menu_calling = true
	    $game_temp.menu_beep = true
      end
    elsif Input.trigger?(Input::SPECIAL)
      if !pbSeenTipCard?(:HUD)
	    pbShowTipCardsGrouped(:HUDSTUFF)
      end
	  amt = $PokemonGlobal.selected_pokemon_cleaned.length
      if amt==1
	    pkmn = $PokemonGlobal.selected_pokemon_cleaned[0]
	   if $PokemonGlobal.cur_stored_pokemon!=pkmn
	    $PokemonGlobal.set_ball_hud_type(:MOVES,true,pkmn)
      $PokemonGlobal.ball_hud_enabled = true if $PokemonGlobal.ball_hud_enabled==false
	   end

	  elsif amt>1
	   if $PokemonGlobal.alt_control_move==false
	     pbDeselectThisPokemon($PokemonGlobal.ball_order[0]) if $PokemonGlobal.ball_order[0]!=0
	     pbSelectThisPokemon($PokemonGlobal.ball_order[0],true) if $PokemonGlobal.ball_order[0]!=0
	     $PokemonGlobal.set_ball_hud_type(:MULTISELECT,true) 
	     pbSEPlay("GUI sel decision", 60) 
      $PokemonGlobal.ball_hud_enabled = true if $PokemonGlobal.ball_hud_enabled==false
	   
	   
	   else
	     $PokemonGlobal.set_ball_hud_type(:PKMN,true) 
	     pbSEPlay("GUI sel decision", 60) 
      $PokemonGlobal.ball_hud_enabled = true if $PokemonGlobal.ball_hud_enabled==false
	   
	   
	   end
      end

    elsif Input.trigger?(Input::TOGGLEHUD)
      if !pbSeenTipCard?(:HUD)
	    pbShowTipCardsGrouped(:HUDSTUFF)
      end
	   # $PokemonGlobal.set_ball_hud_type($PokemonGlobal.ball_hud_type_old)
      $PokemonGlobal.ball_hud_enabled = true
	   
	elsif  Input.press?(Input::NOTEBOOK) && $game_system.menu_disabled==false && $PokemonGlobal.cur_stored_fishing_rod.nil?
	  $game_temp.notebook_calling=true
    elsif Input.triggerex?(Keys::CONTROLS_LIST["\|"])#Input.triggerex?(:TAB)
	#  item = ItemData.new(:APIARY)
	  
    #  key_id = $DynamicEvents.generateEvent($game_player.x, $game_player.y-1, item, false, false, $game_player.direction)
	  #Placeable.begin_place(item)
    end

  end



end



def within_one_tile?(x1, y1, x2, y2)
  return (x2 - x1).abs + (y2 - y1).abs == 1
end

def get_cur_player
 return $game_temp.current_pkmn_controlled if $game_temp.current_pkmn_controlled!=false
 return $game_player 
end

def get_direction(x1, y1, x2, y2)
  dx = x2 - x1
  dy = y2 - y1

  if (dx.abs == 1 && dy == 0) || (dx == 0 && dy.abs == 1)
    direction = case
                when dx == 1 && dy == 0 then 6 #RIGHT
                when dx == -1 && dy == 0 then 4 #LEFT
                when dx == 0 && dy == 1 then 8 #UP 
                when dx == 0 && dy == -1 then 2  #DOWN
                end
	
    return direction
  else
    return nil
  end
end

def get_tile_mouse_on
   x = (((Input.mouse_x * Game_Map::X_SUBPIXELS) + $game_map.display_x)/Game_Map::REAL_RES_X).round
   y = (((Input.mouse_y * Game_Map::Y_SUBPIXELS) + $game_map.display_y)/Game_Map::REAL_RES_Y).round
   return x,y
 end

def get_tile_from_screen_pos(screen_x,screen_y)
   x = (((screen_x * Game_Map::X_SUBPIXELS) + $game_map.display_x)/Game_Map::REAL_RES_X).round
   y = (((screen_y * Game_Map::Y_SUBPIXELS) + $game_map.display_y)/Game_Map::REAL_RES_Y).round
   return x,y
 end

def get_tile_from_screen_pos2(screen_x,screen_y)
   x = (((screen_x * Game_Map::X_SUBPIXELS) + $game_map.display_x)/Game_Map::REAL_RES_X)
   y = (((screen_y * Game_Map::Y_SUBPIXELS) + $game_map.display_y)/Game_Map::REAL_RES_Y)
   return x,y
 end

def get_screen_from_tile_pos(x, y)
   screen_x = ((x * Game_Map::REAL_RES_X - $game_map.display_x) / Game_Map::X_SUBPIXELS).to_f
   screen_y = ((y * Game_Map::REAL_RES_Y - $game_map.display_y) / Game_Map::Y_SUBPIXELS).to_f
   return screen_x, screen_y
end

def get_tile_with_direction
   x = (((Input.mouse_x * Game_Map::X_SUBPIXELS) + $game_map.display_x)/Game_Map::REAL_RES_X).floor
   y = (((Input.mouse_y * Game_Map::Y_SUBPIXELS) + $game_map.display_y)/Game_Map::REAL_RES_Y).floor
   tile_x = Input.mouse_x % Game_Map::TILE_WIDTH
   tile_y = Input.mouse_y  % Game_Map::TILE_HEIGHT

  puts "You are clicking on: X: #{x}, Y: #{y} in get_tile_with_direction" if $DEBUG
   if tile_x < Game_Map::TILE_WIDTH / 2 && tile_y < Game_Map::TILE_HEIGHT / 2
     dir = 2  # Down
	direc = "Down"
   elsif tile_x >= Game_Map::TILE_WIDTH / 2 && tile_y < Game_Map::TILE_HEIGHT / 2
     dir = 4  # Left
	direc = "Left"
   elsif tile_x < Game_Map::TILE_WIDTH / 2 && tile_y >= Game_Map::TILE_HEIGHT / 2
     dir = 6  # Right
	direc = "Right"
   else
     dir = 8  # Up
	direc = "Up"
   end
   return x,y,dir
 end

EventHandlers.add(:on_player_interact, :interact_with_through_trees,
  proc {
     potato = false
    facingEvent = $game_player.pbFacingEventIgnoreOverTrigger
	 on_player = $game_map.check_event($game_player.x,$game_player.y)
	 potato = on_player if on_player!=$game_player
    next if facingEvent.nil?
    next if potato!=false && $game_map.events[potato].through==true
    next if facingEvent.through==false
	if facingEvent && (facingEvent.name[/BerryPlant/i] || facingEvent.is_a?(Game_OVEvent))
     facingEvent.start
	 else 
	 next
	end
  }
)

EventHandlers.add(:on_player_interact, :interact_with_tree,
  proc {
   next false unless $game_player.pbFacingTerrainTag.can_knockdown
     message=(_INTL("Want to collect some acorns?"))
    if pbConfirmMessage(message)
       item.decrease_durability(1)
       $bag.add(:ACORN,(rand(4)+1))
	    next true
	end
	
  }
)

 def can_use_in_overworld?(item_id)
   [:SHEARS,:WATERBOTTLE,:GLASSBOTTLE,:POKEMONBRUSH].include?(item_id)
 end 

EventHandlers.add(:on_player_interact, :use_on_follower,
  proc {
 	 next if $PokemonGlobal.ball_hud_enabled == false 
	 next if $game_temp.current_pkmn_controlled!=false
     facingEvent = $game_player.pbFacingEvent4
     next unless facingEvent.is_a?(Game_PokeEventA)
	 next if facingEvent.pokemon.egg?
	 next if facingEvent.pokemon.fainted?
	 next if facingEvent.pokemon.dead?
     current_selection = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
	 next unless current_selection.is_a?(ItemData)
	 
	 next unless can_use_in_overworld?(current_selection.id)
	 
	ItemHandlers.triggerUseFromBox(current_selection, facingEvent)
	 
  }
)

EventHandlers.add(:on_player_interact, :check_ov_egg,
  proc {
	 next if $game_temp.current_pkmn_controlled!=false
     facingEvent = $game_player.pbFacingEvent4
     next if facingEvent.nil?
     next unless facingEvent.is_a?(Game_PokeEventA)
	 pkmn = facingEvent.pokemon
	 next unless pkmn.egg?
	 next if pkmn.fainted?
	 next if pkmn.dead?
	 if $player.is_it_this_class?(:BREEDER)
      time_delta = pbGetTimeNow.to_i - pkmn.time_last_pet
	  unless time_delta < 1800
	   pkmn.steps_to_hatch -= 275
	   pkmn.time_last_pet = pbGetTimeNow.to_i
	   pkmn.update_interacted
	   pbSEPlay("pet", 80)
	  end
	 end 
     eggstate = _INTL("It looks like this Egg will take a long time to hatch.")
     eggstate = _INTL("What will hatch from this? It doesn't seem close to hatching.") if pkmn.steps_to_hatch < 10_200
     eggstate = _INTL("It appears to move occasionally. It may be close to hatching.") if pkmn.steps_to_hatch < 2550
     eggstate = _INTL("Sounds can be heard coming from inside! It will hatch soon!") if pkmn.steps_to_hatch < 1275
	 sideDisplay(eggstate)
  }
)

EventHandlers.add(:on_player_interact, :pet_follower,
  proc {
 	 next if $PokemonGlobal.ball_hud_enabled == true
	 next if $game_temp.current_pkmn_controlled!=false
    facingEvent = $game_player.pbFacingEvent4
    next if facingEvent.nil?
    next unless facingEvent.is_a?(Game_PokeEventA)
	pkmn = facingEvent.pokemon
	 next if pkmn.fainted?
	 next if pkmn.dead?
	 next if pkmn.egg?
    time_delta = pbGetTimeNow.to_i - pkmn.time_last_pet
	
	 next if time_delta < 1800
	  pkmn.time_last_pet = pbGetTimeNow.to_i
	  unless facingEvent.sleeping?
	  pkmn.update_interacted
      pkmn.changeHappiness("groom",pkmn)
	  pbSEPlay("pet", 80)
	  if pkmn.happiness>=240
	   $scene.spriteset.addUserAnimation(51,facingEvent.x,facingEvent.y,true,1)
      elsif pkmn.happiness<=30
	   $scene.spriteset.addUserAnimation(35,facingEvent.x,facingEvent.y,true,1)
	  else
	   $scene.spriteset.addUserAnimation(50,facingEvent.x,facingEvent.y,true,1)
	  end
	  else
	  facingEvent.wake_up
	  end 
    
  }
)

def pbDetectTarget(source = $game_player)
  3.times do |i|
    distance = i + 1
    x, y = source.x, source.y
    case source.direction
     when 2 then y += distance
     when 4 then x -= distance
     when 6 then x += distance
     when 8 then y -= distance
    end
	event_id = $game_map.check_event(x, y)
	if source != $game_player && event_id == $game_player
	 return [$game_player, i+1]
	end 
	event = $game_map.events[event_id]
	next unless event
	if event.name[/tutorialvanishingEncounter/] && $game_switches[556]
      return event 	
	end 
	next unless event.name[/vanishingEncounter/]
	return [event, distance]
  end 
  return nil
end
alias pbGetTarget pbDetectTarget
alias get_target_player pbDetectTarget
def pbGetLockOnTarget(source=$game_player)
  return if source==$game_player && $game_temp.lockontarget!=false
	do_it = false
    do_it,amt,start_end = throwing_range_logic(do_it, amt)
	if do_it==true
      event_id=$game_map.check_event(start_end[1][0],start_end[1][1])
      if $game_map.events[event_id]
        event=$game_map.events[event_id]
		key = [event.map_id, event.id, "A"]
	    return nil if event.name.downcase.include?("backpack") && $game_self_switches[key] == true && $game_switches[154] == true
	    return nil if event.name.include?("hiddenitem")
	    return nil if event.name.include?("ExitArrow")
	    return nil if event.name.match?(/^EV\d{3}$/)
	    return nil if event.name.match?(/^EV\d{3}(\s.*)?$/)
	    return nil if event.name.match?(/^EV\d{3}\..*$/)
	    return nil if event.name.start_with?("size")
	    return event
      elsif event_id.is_a?(Game_Player)
       return $game_player
      end
    else
	  return nil
	end
end


#def pbGetTargetDistance(source=$game_player,amt=3)
#  events = []
#  closest_events = []
#  amt.times do |i|
#  start_coord=[source.x,source.y]
#  landing_coord=[source.x,source.y]
#  case source.direction
#  when 2; landing_coord[1]+=i+1
#  when 4; landing_coord[0]-=i+1
#  when 6; landing_coord[0]+=i+1
#  when 8; landing_coord[1]-=i+1
#  end
#  event_id=$game_map.check_event(*landing_coord)
#	next if !$game_map.events[event_id] && event_id != $game_player
#     events << [event_id,i+1]
#end
#  theevent = events.min_by { |event| event[1] }
#  if !theevent.nil?
#  min_distance = theevent[1]
#  closest_events = events.select { |event| event[1] == min_distance }
#  end
#  return closest_events
#end






def pokemon_in_world
 pkmnw = []
 $player.party.each do |pkmn|
	  next unless pkmn 
   if pkmn.egg?
    pkmn.inworld=false
	next
   end
   pkmn.inworld = false if pkmn.inworld.nil?
  next if pkmn.inworld==false
   pkmnw << pkmn
 end

 return pkmnw
end



EventHandlers.add(:on_player_interact, :use_item,
  proc {
	next if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:NO || $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:NONE
	next if $PokemonGlobal.ball_hud_enabled == false
	next if $game_temp.current_pkmn_controlled!=false
	next if $game_temp.currently_selecting==true
	next if $game_temp.position_calling == true
	next if $mouse.current_mode==:FOLLOW #&& Input.press?(Input::ALTERNATEMOUSEMODE)
	next if $mouse.current_mode==:SQUARE 
	next if !$PokemonGlobal.cur_stored_fishing_rod.nil?
    facingEvent = $game_player.pbFacingEvent
    facingEvent2 = $game_player.pbFacingEventIgnoreOverTrigger
    next if $PokemonGlobal.diving
    next if $PokemonGlobal.surfing
    next if facingEvent && facingEvent.name[/strengthboulder/i]
    next if facingEvent2 && facingEvent2.name[/BerryPlant/i]
    next if facingEvent && facingEvent.name[/FollowerPkmn/i]
    next if facingEvent && defined?(facingEvent.pokemon)==false
    next if facingEvent && facingEvent.trigger==0
     activate_item_box_item(facingEvent)
	$OverworldMenu.should_refresh=true 
  }
)




def activate_item_box_item(passed_event)
    #return if $mouse.current_mode==:FOLLOW
    $player.acting=true
	#This is to actually set the item box.
    active_item=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
	puts active_item.is_a?(String) && $PokemonGlobal.alt_control_move==true
	return if active_item.nil?
	 if active_item.is_a?(String) && $PokemonGlobal.alt_control_move==true
	   direct_pokemon_movement_main
	 elsif active_item==:MULTISELECT
	 elsif active_item==:BATTLE
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:BATTLE,true)
	 elsif active_item==:TOOL
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:TOOL,true)
	 elsif active_item==:PKMN
	   $PokemonGlobal.set_ball_hud_type(:PKMN,true) 
	 elsif active_item==:PLACE
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:PLACE,true)
	 elsif active_item==:FAVORITES
	   $PokemonGlobal.set_ball_hud_type(:FAVORITES,true)
	 elsif active_item==:CROPS
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true)
	   $PokemonGlobal.set_item_hud(:CROPS,true)
	 elsif active_item==:RADIAL
	   $PokemonGlobal.set_ball_hud_type(:RADIAL,true)
	 elsif active_item==:WEAPONS
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_weapon_permanent
	 elsif active_item.is_a?(Pokemon::Move)
	 
        return if !$scene.is_a?(Scene_Map)
	    if !$PokemonGlobal.cur_stored_pokemon.nil?
	        selected_pkmn = $scene.get_selected_pokemon_event
	        return if selected_pkmn.nil?
	        return unless selected_pkmn.is_a?(Game_PokeEventA) && selected_pkmn.pokemon.is_a?(Pokemon)
	        facingEvent = selected_pkmn.pbFacingEventIgnoreOverTrigger
	        coords, terrain = $scene.get_terrain_and_coords(selected_pkmn)
			$scene.handle_pokemon_interaction(selected_pkmn, active_item, facingEvent, coords, terrain)
       end


	 elsif active_item.is_a?(String)
	    if !$PokemonGlobal.cur_stored_pokemon.nil?
		   event = $PokemonGlobal.cur_stored_pokemon.event 
	       direct_pokemon_sub(event,get_cur_player) if event
	     end
	 else
	ItemHandlers.triggerUseFromBox(active_item, passed_event)
	 end
    $player.acting=false
end



def direct_pokemon_movement_main
    current_order =$PokemonGlobal.stored_ball_order
    if $PokemonGlobal.alt_control_move==true
	    selected = $PokemonGlobal.selected_pokemon.dup
         selected.each_with_index do |pkmn, index|
			  next unless pkmn.is_a?(Pokemon)
			  next if pkmn.inworld==false
			   event = pkmn.event
			   next if !event
			   next if event.map_id != $game_map.map_id
		       direct_pokemon_sub(event, get_cur_player)
		  end
    elsif current_order && current_order.is_a?(Pokemon)
	        event = current_order.pokemon
			return unless event
		    direct_pokemon_sub(event, get_cur_player)
    end
end

def direct_pokemon_sub(event,target=nil)
    current_order=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
    case current_order
      when "Follow"
             event.movement_type = :MOVEBEHINDPLAYER 
             DialogueSound.reset
			 text = "#{event.type.name}, follow me!"
		     sideDisplay(text,false,3,false)
			 text.length.times do |i|
				Graphics.update
				Input.update
				$scene.miniupdate
               DialogueSound.play_sound_effect(i, text)
			  end
		     sideDisplay("#{event.type.name} is now following.")
      when "Wait"
          event.movement_type = :STILL 
          event.still_timer = -1
          DialogueSound.reset
			text = "#{event.type.name}, wait!"
		   sideDisplay(text,false,3,false)
			text.length.times do |i|
				Graphics.update
				Input.update
				$scene.miniupdate
             DialogueSound.play_sound_effect(i, text)
			end
		  sideDisplay("#{event.type.name} will wait.")
      when "Wander"
          event.movement_type = :WANDER 
			text = "#{event.type.name}, do as you like."
		   sideDisplay(text,false,3,false)
			text.length.times do |i|
				Graphics.update
				Input.update
				$scene.miniupdate
             DialogueSound.play_sound_effect(i, text)
			end
		  sideDisplay("#{event.type.name} will wander.")
      when "Search"
	    if pbConfirmMessage(_INTL("Would you like to have #{event.type.name} search for hidden items?"))
			text = "#{event.type.name}, are there any items around here?"
		   sideDisplay(text,false,3,false)
			text.length.times do |i|
				Graphics.update
				Input.update
				$scene.miniupdate
             DialogueSound.play_sound_effect(i, text)
			end
          event.movement_type = :SEARCH 
		end
      when "Use Item"
      when "Hunt"
	    if pbConfirmMessage(_INTL("Would you like to have #{event.type.name} hunt a POKeMON to fight?"))
			text = "#{event.type.name}, hunt down a Pokemon!"
		   sideDisplay(text,false,3,false)
			text.length.times do |i|
				Graphics.update
				Input.update
				$scene.miniupdate
             DialogueSound.play_sound_effect(i, text)
			end
          event.movement_type = :FINDENEMY 
		end
      when "Recall"
	      event.pokemon.inworld=false
	      event.pokemon.effects[PBEffects::Confusion] = 0
          pbReturnPokemon(event.id,true)
	
	 end
end



