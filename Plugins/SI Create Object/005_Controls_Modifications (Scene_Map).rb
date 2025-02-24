class Game_Player < Game_Character
  attr_accessor :moved_this_frame
   def stages
    return $player.stages
   end
   
   def effects
    return $player.effects
   end
   
  def update_command_new
    dir = Input.dir4
    unless pbMapInterpreterRunning? || ($game_temp.message_window_showing && $PokemonGlobal.alternate_control_mode==false) || $game_temp.in_menu || $game_temp.no_moving
      # Move player in the direction the directional button is being pressed
	   if $game_temp.lockontarget==false
      if $game_temp.current_pkmn_controlled!=false
        current_pkmn_controlled_behavior(dir)

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
     else
      dir = locked_on_behavior(dir)
     end



    end
    # Record last direction input
      @lastdirframe = System.uptime if dir != @lastdir
    @lastdir      = dir
  end

  def move_generic(dir, turn_enabled = true)
    turn_generic(dir, true) if turn_enabled
    if !$game_temp.encounter_triggered
      if can_move_in_direction?(dir)
        x_offset = (dir == 4) ? -1 : (dir == 6) ? 1 : 0
        y_offset = (dir == 8) ? -1 : (dir == 2) ? 1 : 0
		  if $game_map
		   event_id = $game_map.check_event(@x + x_offset,@y + y_offset)
		   if event_id.is_a?(Integer)
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
        return if pbLedge(x_offset, y_offset)
        return if pbEndSurf(x_offset, y_offset)
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
        pbCameraSpeed(1.7) if FancyCamera::INCREASE_WHEN_RUNNING
        self.move_speed = (type == :cycling_jumping) ? 3 : 5
      end
      new_charset = pbGetPlayerCharset(meta.cycle_charset)
    when :running
      pbCameraSpeed(1.4) if FancyCamera::INCREASE_WHEN_RUNNING
      self.move_speed = 3.50 if !@move_route_forcing && ($player.playershoes.id == :NORMALSHOES || $player.playershoes == :SEASHOES)
      self.move_speed = 3.65 if !@move_route_forcing && $player.is_it_this_class?(:TRIATHLETE,false)
      self.move_speed = 3.65 if !@move_route_forcing && $player.playershoes.id == :MAKESHIFTRUNNINGSHOES
      self.move_speed = 3.75 if !@move_route_forcing && $player.is_it_this_class?(:HIKER) && $game_map&.name&.downcase&.include?("mountain") && $bag.has?(:POLE)
      self.move_speed = 3.75 if !@move_route_forcing && $player.playershoes.id == :RUNNINGSHOES
      self.move_speed = 4 if !@move_route_forcing && $player.has_running_shoes
      new_charset = pbGetPlayerCharset(meta.run_charset)
    when :ice_sliding
      pbCameraSpeed(1.4) if FancyCamera::INCREASE_WHEN_RUNNING
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
    return false if $game_temp.in_menu || $game_temp.in_battle || pbMapInterpreterRunning? || $player.playerstamina==0
    return false if jumping?
    #return false if $PokemonGlobal.partner (!$player.has_running_shoes && ($player.playershoes.id == :NORMALSHOES || $player.playershoes.id == :SEASHOES))&&
    return false if pbTerrainTag.must_walk
    return $player.running #^ ($PokemonSystem.runstyle == 1)
  end
  
  def can_run_unforced?
    return false if $game_temp.in_menu || $game_temp.in_battle || pbMapInterpreterRunning? || $player.playerstamina==0
    return false if jumping?
    #return false if $PokemonGlobal.partner (!$player.has_running_shoes && ($player.playershoes.id == :NORMALSHOES || $player.playershoes.id == :SEASHOES))&&
    return false if pbTerrainTag.must_walk
    return $player.running #^ ($PokemonSystem.runstyle == 1)
  end
end



def breathing_sound?
   ret = ($player.playerstamina <= ($player.playermaxstamina/10)) && !DialogueSound.is_playing?
	return true
  return ret
end

class Scene_Map
  
  alias modif_transfer_player transfer_player
  def transfer_player(cancel_swimming = true)
  $PokemonGlobal.reset_selected_pokemon
  modif_transfer_player(cancel_swimming)
  
  end
  def update
   $PokemonGlobal.addNewFrameCount
    loop do
      pbMapInterpreter.update
      $game_player.update
      updateMaps
      $game_system.update
      $game_screen.update
	  $ExtraEvents.update_objects_remotely
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
   $game_temp.relock_prevention-=1 if $game_temp.relock_prevention>0
	
	
	
	
   
   
		 
	  
	
	
	
	
    unless $game_player.moving?
      if $game_temp.menu_calling && $game_temp.current_pkmn_controlled==false
        call_menu
      elsif $game_temp.debug_calling
        call_debug
      elsif $game_temp.ready_menu_calling
        $game_temp.ready_menu_calling = false
        $game_player.straighten
        pbUseKeyItem
      elsif $game_temp.interact_calling
        $game_temp.interact_calling = false
        $game_player.straighten
        EventHandlers.trigger(:on_player_interact)
      elsif $game_temp.notebook_calling
	  
        $game_temp.notebook_calling = false
        $game_player.straighten
        pbFadeOutIn(99999) {NoteOpen.openWindow}
      end
    end
  end
  
	
  def activate_target_event
	  target = pbDetectTarget
	  target.start if  !target.is_a?(Integer)  && !target.is_a?(Array) &&  !target.nil?
  end
  def lock_on_target_behavior
	   if Input.press?(Input::LOCKON) && $game_temp.position_calling == false && $game_temp.currently_throwing_pkmn == false
	  $selection_arrows.remove_sprite("Arrow#{$game_temp.lockontarget.id}")
	     $game_temp.lockontarget=false
		 pbCameraReset
		 $game_temp.relock_prevention=45
	   elsif Input.trigger?(Input::WHATISTHIS) && $game_temp.position_calling == false && $game_temp.currently_throwing_pkmn == false
	     pbGetMeTheDeetsJimmy
	  end
  end
  def behavior_type
      if $game_temp.position_calling == true #Input Logic for Placing Overworld Objects
	    positioning_controls
      elsif $game_temp.current_pkmn_controlled!=false
	    pokemon_controls
      elsif $PokemonGlobal.ball_hud_enabled == true
	    ball_hud_controls
      else #Default Logic
	    default_controls
      end
  end
  def controls_for_all_seasons
    if Input.trigger?(Input::AUX2) && $DEBUG && Input.pressex?(0x12)
		 pbEkansGame
	elsif Input.triggerex?(Keys::CONTROLS_LIST["Home"])
	    pbHistoryScreenshot
	elsif Input.press?(Input::F9)
       $game_temp.debug_calling = true if $DEBUG
	elsif Input.press?(Input::LOCKON) && $game_temp.position_calling == false && $game_temp.in_throwing==false
		 if $game_temp.relock_prevention==0
	  	 $game_temp.lockontarget=false
		  target = pbGetLockOnTarget
	  	 $game_temp.lockontarget=target if target!=false
		 end
	elsif Input.trigger?(Input::CYCLEMOUSETYPE)
	  $mouse.change_mode
	elsif false && Input.double_tap?(Input::BACK) 
	  if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon) && $PokemonGlobal.ball_hud_enabled == true
	     if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].inworld == true
           pbThrowPokemon
	     end
	  end

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
  
	duriscannon = nil
	event_id = nil
	if $PokemonGlobal.get_selected_pokemon.length==1
		pkmn = $PokemonGlobal.selected_pokemon_cleaned[0]
	   event_id = pkmn.associatedevent
	elsif $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon)
	  event_id = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].associatedevent
	elsif !$PokemonGlobal.cur_stored_pokemon.nil?
	   event_id = $PokemonGlobal.cur_stored_pokemon.associatedevent
	end
	duriscannon = $game_map.events[event_id] if !event_id.nil?
	
	
	
	
	
	
	
	if !duriscannon.nil? && duriscannon.is_a?(Game_PokeEventA) && duriscannon.pokemon.is_a?(Pokemon)
	   duriscannon.pokemon.attacking=false if duriscannon.pokemon.attacking.nil?
	  facingEvent = duriscannon.pbFacingEvent4
	   event, distance = get_target_player(duriscannon)
	   if (facingEvent && facingEvent.name[/BerryPlant/i]) || (event && event.is_a?(Game_PokeEvent))
    if Input.triggerex?(Keys::CONTROLS_LIST["1"]) && !Input.press?(Input::SHIFT) && !duriscannon.pokemon.moves[0].nil?
	   $PokemonGlobal.cur_stored_pokemon = duriscannon.pokemon if $PokemonGlobal.cur_stored_pokemon!=duriscannon.pokemon
		   
	           index = $PokemonGlobal.ball_order.index(duriscannon.pokemon.moves[0])
			     if index
				    $PokemonGlobal.ball_order[index]
				  end
             if facingEvent && facingEvent.name[/BerryPlant/i] && (duriscannon.pokemon.moves[0].display_type(duriscannon.pokemon) == :FIRE || duriscannon.pokemon.types.include?(:FIRE))
                        berrydata = get_other_data(facingEvent.id)
						   return if berrydata.nil?
			 			 if pbConfirmMessage(_INTL("Would you like to burn this Berry Tree down?"))
						   berry = berrydata.berry_id
                        berry = GameData::Item.get(berry)
	                    qty = berrydata.berry_yield
						   berry_name = (qty > 1) ? berry.name_plural : berry.name
						   berrydata.reset
						   qnt = rand(5)+2
						   item_id = :CHARCOAL
                        item = GameData::Item.get(item_id)
						   item_name = (qnt > 1) ? item.name_plural : item.name
                        pbMessage(_INTL("You burned down the #{qty} \\c[1]#{berry_name}\\c[0], and got #{qnt} \\c[1]#{item_name}\\c[0]."))
	                    $bag.add(item_id,qnt)
			 			 end

			  elsif !event.nil? 
			  if !event.is_a? Integer
			  if event!=$game_player
              if duriscannon.pokemon.attacking==false
			  thefight = pbOverworldCombat
			  duriscannon.pokemon.attacking=true
		  duriscannon.autoattack_opportunity += 90
                  DialogueSound.reset
				       text = "#{duriscannon.pokemon.name} use #{GameData::Move.get(duriscannon.pokemon.moves[0].id).real_name}!"
		             sideDisplay(text,false,3,false)
					     text.length.times do |i|
						  Graphics.update
						  Input.update
						  $scene.miniupdate
                   DialogueSound.play_sound_effect(i, text)
				        end
			  
			  thefight.player_pokemonattack(duriscannon,event,duriscannon.pokemon.moves[0], distance) if !duriscannon.pokemon.moves[0].nil?
			  duriscannon.pokemon.attacking=false
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves[0].id).real_name}.")
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves[0].id).real_name}.")
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves[0].id).real_name}.")
			 end
  

  end
    if Input.triggerex?(Keys::CONTROLS_LIST["2"]) && !Input.press?(Input::SHIFT) && !duriscannon.pokemon.moves[1].nil?
	   $PokemonGlobal.cur_stored_pokemon = duriscannon.pokemon if $PokemonGlobal.cur_stored_pokemon!=duriscannon.pokemon
	  
	           index = $PokemonGlobal.ball_order.index(duriscannon.pokemon.moves[1])
			     if index
				    $PokemonGlobal.ball_order[index]
				  end
			  
			  if facingEvent && facingEvent.name[/BerryPlant/i] && (duriscannon.pokemon.moves[1].display_type(duriscannon.pokemon) == :FIRE || duriscannon.pokemon.types.include?(:FIRE))
                        berrydata = get_other_data(facingEvent.id)
						   return if berrydata.nil?
			 			 if pbConfirmMessage(_INTL("Would you like to burn this Berry Tree down?"))
						   berry = berrydata.berry_id
                        berry = GameData::Item.get(berry)
	                    qty = berrydata.berry_yield
						   berry_name = (qty > 1) ? berry.name_plural : berry.name
						   berrydata.reset
						   qnt = rand(5)+2
						   item_id = :CHARCOAL
                        item = GameData::Item.get(item_id)
						   item_name = (qnt > 1) ? item.name_plural : item.name
                        pbMessage(_INTL("You burned down the #{qty} \\c[1]#{berry_name}\\c[0], and got #{qnt} \\c[1]#{item_name}\\c[0]."))
	                    $bag.add(item_id,qnt)
			 			 end

			  elsif !event.nil? 
			  if !event.is_a? Integer
			  if event!=$game_player

			  duriscannon.pokemon.attacking=false if duriscannon.pokemon.attacking.nil?
              if duriscannon.pokemon.attacking==false
			  thefight = pbOverworldCombat
			  duriscannon.pokemon.attacking=true
		  duriscannon.autoattack_opportunity += 90
                  DialogueSound.reset
				       text = "#{duriscannon.pokemon.name} use #{GameData::Move.get(duriscannon.pokemon.moves[1].id).real_name}!"
		             sideDisplay(text,false,3,false)
					     text.length.times do |i|
						  Graphics.update
						  Input.update
						  $scene.miniupdate
                   DialogueSound.play_sound_effect(i, text)
				        end
			  
			  thefight.player_pokemonattack(duriscannon,event,duriscannon.pokemon.moves[1], distance) if !duriscannon.pokemon.moves[1].nil?
			  duriscannon.pokemon.attacking=false
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves[1].id).real_name}.")
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves[1].id).real_name}.")
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves[1].id).real_name}.")
			  end
    end
    if Input.triggerex?(Keys::CONTROLS_LIST["3"]) && !Input.press?(Input::SHIFT) && !duriscannon.pokemon.moves[2].nil?
	   $PokemonGlobal.cur_stored_pokemon = duriscannon.pokemon if $PokemonGlobal.cur_stored_pokemon!=duriscannon.pokemon
	     
	           index = $PokemonGlobal.ball_order.index(duriscannon.pokemon.moves[2])
			     if index
				    $PokemonGlobal.ball_order[index]
				  end
             if facingEvent && facingEvent.name[/BerryPlant/i] && (duriscannon.pokemon.moves[2].display_type(duriscannon.pokemon) == :FIRE || duriscannon.pokemon.types.include?(:FIRE))
                        berrydata = get_other_data(facingEvent.id)
						   return if berrydata.nil?
			 			 if pbConfirmMessage(_INTL("Would you like to burn this Berry Tree down?"))
						   berry = berrydata.berry_id
                        berry = GameData::Item.get(berry)
	                    qty = berrydata.berry_yield
						   berry_name = (qty > 1) ? berry.name_plural : berry.name
						   berrydata.reset
						   qnt = rand(5)+2
						   item_id = :CHARCOAL
                        item = GameData::Item.get(item_id)
						   item_name = (qnt > 1) ? item.name_plural : item.name
                        pbMessage(_INTL("You burned down the #{qty} \\c[1]#{berry_name}\\c[0], and got #{qnt} \\c[1]#{item_name}\\c[0]."))
	                    $bag.add(item_id,qnt)
			 			 end

			  elsif !event.nil? 
			  if !event.is_a? Integer
			  if event!=$game_player

			  duriscannon.pokemon.attacking=false if duriscannon.pokemon.attacking.nil?
              if duriscannon.pokemon.attacking==false
			  thefight = pbOverworldCombat
			  duriscannon.pokemon.attacking=true
		  duriscannon.autoattack_opportunity += 90
                  DialogueSound.reset
				       text = "#{duriscannon.pokemon.name} use #{GameData::Move.get(duriscannon.pokemon.moves[2].id).real_name}!"
		             sideDisplay(text,false,3,false)
					     text.length.times do |i|
						  Graphics.update
						  Input.update
						  $scene.miniupdate
                   DialogueSound.play_sound_effect(i, text)
				        end
			  
			  thefight.player_pokemonattack(duriscannon,event,duriscannon.pokemon.moves[2], distance) if !duriscannon.pokemon.moves[2].nil?
			  duriscannon.pokemon.attacking=false
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves[2].id).real_name}.")
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves[2].id).real_name}.")
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves[2].id).real_name}.")

			 end
    end
    if Input.triggerex?(Keys::CONTROLS_LIST["4"]) && !Input.press?(Input::SHIFT) && !duriscannon.pokemon.moves[3].nil?
	   $PokemonGlobal.cur_stored_pokemon = duriscannon.pokemon if $PokemonGlobal.cur_stored_pokemon!=duriscannon.pokemon
	   
	           index = $PokemonGlobal.ball_order.index(duriscannon.pokemon.moves[3])
			     if index
				    $PokemonGlobal.ball_order[index]
				  end
			  
if facingEvent && facingEvent.name[/BerryPlant/i] && (duriscannon.pokemon.moves[3].display_type(duriscannon.pokemon) == :FIRE || duriscannon.pokemon.types.include?(:FIRE))
                        berrydata = get_other_data(facingEvent.id)
						   return if berrydata.nil?
			 			 if pbConfirmMessage(_INTL("Would you like to burn this Berry Tree down?"))
						   berry = berrydata.berry_id
                        berry = GameData::Item.get(berry)
	                    qty = berrydata.berry_yield
						   berry_name = (qty > 1) ? berry.name_plural : berry.name
						   berrydata.reset
						   qnt = rand(5)+2
						   item_id = :CHARCOAL
                        item = GameData::Item.get(item_id)
						   item_name = (qnt > 1) ? item.name_plural : item.name
                        pbMessage(_INTL("You burned down the #{qty} \\c[1]#{berry_name}\\c[0], and got #{qnt} \\c[1]#{item_name}\\c[0]."))
	                    $bag.add(item_id,qnt)
			 			 end
			  elsif !event.nil? 
			  if !event.is_a? Integer
			  if event!=$game_player

			  duriscannon.pokemon.attacking=false if duriscannon.pokemon.attacking.nil?
              if duriscannon.pokemon.attacking==false
			  thefight = pbOverworldCombat
			  duriscannon.pokemon.attacking=true
		  duriscannon.autoattack_opportunity += 90
                  DialogueSound.reset
				       text = "#{duriscannon.pokemon.name} use #{GameData::Move.get(duriscannon.pokemon.moves[3].id).real_name}!"
		             sideDisplay(text,false,3,false)
					     text.length.times do |i|
						  Graphics.update
						  Input.update
						  $scene.miniupdate
                   DialogueSound.play_sound_effect(i, text)
				        end
			  thefight.player_pokemonattack(duriscannon,event,duriscannon.pokemon.moves[3], distance) if !duriscannon.pokemon.moves[3].nil?
			  duriscannon.pokemon.attacking=false
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves[3].id).real_name}.")
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves[3].id).real_name}.")
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves[3].id).real_name}.")

			 end
    end

    if Input.triggerex?(Keys::CONTROLS_LIST["5"]) && !Input.press?(Input::SHIFT) && !duriscannon.pokemon.moves2[0].nil?
	   $PokemonGlobal.cur_stored_pokemon = duriscannon.pokemon if $PokemonGlobal.cur_stored_pokemon!=duriscannon.pokemon
	  
	           index = $PokemonGlobal.ball_order.index(duriscannon.pokemon.moves2[0])
			     if index
				    $PokemonGlobal.ball_order[index]
				  end
			  
             if facingEvent && facingEvent.name[/BerryPlant/i] && (duriscannon.pokemon.moves2[0].display_type(duriscannon.pokemon) == :FIRE || duriscannon.pokemon.types.include?(:FIRE))
                        berrydata = get_other_data(facingEvent.id)
						   return if berrydata.nil?
			 			 if pbConfirmMessage(_INTL("Would you like to burn this Berry Tree down?"))
						   berry = berrydata.berry_id
                        berry = GameData::Item.get(berry)
	                    qty = berrydata.berry_yield
						   berry_name = (qty > 1) ? berry.name_plural : berry.name
						   berrydata.reset
						   qnt = rand(5)+2
						   item_id = :CHARCOAL
                        item = GameData::Item.get(item_id)
						   item_name = (qnt > 1) ? item.name_plural : item.name
                        pbMessage(_INTL("You burned down the #{qty} \\c[1]#{berry_name}\\c[0], and got #{qnt} \\c[1]#{item_name}\\c[0]."))
	                    $bag.add(item_id,qnt)
			 			 end

			  elsif !event.nil? 
			  if !event.is_a? Integer
			  if event!=$game_player
              if duriscannon.pokemon.attacking==false
			  thefight = pbOverworldCombat
			  duriscannon.pokemon.attacking=true
		  duriscannon.autoattack_opportunity += 90
                  DialogueSound.reset
				       text = "#{duriscannon.pokemon.name} use #{GameData::Move.get(duriscannon.pokemon.moves2[0].id).real_name}!"
		             sideDisplay(text,false,3,false)
					     text.length.times do |i|
						  Graphics.update
						  Input.update
						  $scene.miniupdate
                   DialogueSound.play_sound_effect(i, text)
				        end
			  thefight.player_pokemonattack(duriscannon,event,duriscannon.pokemon.moves2[0], distance) if !duriscannon.pokemon.moves2[0].nil?
			  duriscannon.pokemon.attacking=false
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves2[0].id).real_name}.")
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves2[0].id).real_name}.")
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves2[0].id).real_name}.")
			 end
  

  end
    if Input.triggerex?(Keys::CONTROLS_LIST["6"]) && !Input.press?(Input::SHIFT) && !duriscannon.pokemon.moves2[1].nil?
	   $PokemonGlobal.cur_stored_pokemon = duriscannon.pokemon if $PokemonGlobal.cur_stored_pokemon!=duriscannon.pokemon
	  	           index = $PokemonGlobal.ball_order.index(duriscannon.pokemon.moves2[1])
			     if index
				    $PokemonGlobal.ball_order[index]
				  end
			  
			  if facingEvent && facingEvent.name[/BerryPlant/i] && (duriscannon.pokemon.moves2[1].display_type(duriscannon.pokemon) == :FIRE || duriscannon.pokemon.types.include?(:FIRE))
                        berrydata = get_other_data(facingEvent.id)
						   return if berrydata.nil?
			 			 if pbConfirmMessage(_INTL("Would you like to burn this Berry Tree down?"))
						   berry = berrydata.berry_id
                        berry = GameData::Item.get(berry)
	                    qty = berrydata.berry_yield
						   berry_name = (qty > 1) ? berry.name_plural : berry.name
						   berrydata.reset
						   qnt = rand(5)+2
						   item_id = :CHARCOAL
                        item = GameData::Item.get(item_id)
						   item_name = (qnt > 1) ? item.name_plural : item.name
                        pbMessage(_INTL("You burned down the #{qty} \\c[1]#{berry_name}\\c[0], and got #{qnt} \\c[1]#{item_name}\\c[0]."))
	                    $bag.add(item_id,qnt)
			 			 end

			  elsif !event.nil? 
			  if !event.is_a? Integer
			  if event!=$game_player

			  duriscannon.pokemon.attacking=false if duriscannon.pokemon.attacking.nil?
              if duriscannon.pokemon.attacking==false
			  thefight = pbOverworldCombat
			  duriscannon.pokemon.attacking=true
		  duriscannon.autoattack_opportunity += 90
                  DialogueSound.reset
				       text = "#{duriscannon.pokemon.name} use #{GameData::Move.get(duriscannon.pokemon.moves2[1].id).real_name}!"
		             sideDisplay(text,false,3,false)
					     text.length.times do |i|
						  Graphics.update
						  Input.update
						  $scene.miniupdate
                   DialogueSound.play_sound_effect(i, text)
				        end
			  thefight.player_pokemonattack(duriscannon,event,duriscannon.pokemon.moves2[1], distance) if !duriscannon.pokemon.moves2[1].nil?
			  duriscannon.pokemon.attacking=false
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves2[1].id).real_name}.")
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves2[1].id).real_name}.")
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves2[1].id).real_name}.")
			  end
    end
    if Input.triggerex?(Keys::CONTROLS_LIST["7"]) && !Input.press?(Input::SHIFT) && !duriscannon.pokemon.moves2[2].nil?
	   $PokemonGlobal.cur_stored_pokemon = duriscannon.pokemon if $PokemonGlobal.cur_stored_pokemon!=duriscannon.pokemon
	  	           index = $PokemonGlobal.ball_order.index(duriscannon.pokemon.moves2[2])
			     if index
				    $PokemonGlobal.ball_order[index]
				  end
			  
             if facingEvent && facingEvent.name[/BerryPlant/i] && (duriscannon.pokemon.moves2[2].display_type(duriscannon.pokemon) == :FIRE || duriscannon.pokemon.types.include?(:FIRE))
                        berrydata = get_other_data(facingEvent.id)
						   return if berrydata.nil?
			 			 if pbConfirmMessage(_INTL("Would you like to burn this Berry Tree down?"))
						   berry = berrydata.berry_id
                        berry = GameData::Item.get(berry)
	                    qty = berrydata.berry_yield
						   berry_name = (qty > 1) ? berry.name_plural : berry.name
						   berrydata.reset
						   qnt = rand(5)+2
						   item_id = :CHARCOAL
                        item = GameData::Item.get(item_id)
						   item_name = (qnt > 1) ? item.name_plural : item.name
                        pbMessage(_INTL("You burned down the #{qty} \\c[1]#{berry_name}\\c[0], and got #{qnt} \\c[1]#{item_name}\\c[0]."))
	                    $bag.add(item_id,qnt)
			 			 end

			  elsif !event.nil? 
			  if !event.is_a? Integer
			  if event!=$game_player

			  duriscannon.pokemon.attacking=false if duriscannon.pokemon.attacking.nil?
              if duriscannon.pokemon.attacking==false
			  thefight = pbOverworldCombat
			  duriscannon.pokemon.attacking=true
		  duriscannon.autoattack_opportunity += 90
                  DialogueSound.reset
				       text = "#{duriscannon.pokemon.name} use #{GameData::Move.get(duriscannon.pokemon.moves2[2].id).real_name}!"
		             sideDisplay(text,false,3,false)
					     text.length.times do |i|
						  Graphics.update
						  Input.update
						  $scene.miniupdate
                   DialogueSound.play_sound_effect(i, text)
				        end
			  thefight.player_pokemonattack(duriscannon,event,duriscannon.pokemon.moves[2], distance) if !duriscannon.pokemon.moves[2].nil?
			  duriscannon.pokemon.attacking=false
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves2[2].id).real_name}.")
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves2[2].id).real_name}.")
			  end

			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves2[2].id).real_name}.")
			 end
    end
    if Input.triggerex?(Keys::CONTROLS_LIST["8"]) && !Input.press?(Input::SHIFT) && !duriscannon.pokemon.moves2[3].nil?
	   $PokemonGlobal.cur_stored_pokemon = duriscannon.pokemon if $PokemonGlobal.cur_stored_pokemon!=duriscannon.pokemon
	   	           index = $PokemonGlobal.ball_order.index(duriscannon.pokemon.moves2[3])
			     if index
				    $PokemonGlobal.ball_order[index]
				  end
			  
if facingEvent && facingEvent.name[/BerryPlant/i] && (duriscannon.pokemon.moves2[3].display_type(duriscannon.pokemon) == :FIRE || duriscannon.pokemon.types.include?(:FIRE))
                        berrydata = get_other_data(facingEvent.id)
						   return if berrydata.nil?
			 			 if pbConfirmMessage(_INTL("Would you like to burn this Berry Tree down?"))
						   berry = berrydata.berry_id
                        berry = GameData::Item.get(berry)
	                    qty = berrydata.berry_yield
						   berry_name = (qty > 1) ? berry.name_plural : berry.name
						   berrydata.reset
						   qnt = rand(5)+2
						   item_id = :CHARCOAL
                        item = GameData::Item.get(item_id)
						   item_name = (qnt > 1) ? item.name_plural : item.name
                        pbMessage(_INTL("You burned down the #{qty} \\c[1]#{berry_name}\\c[0], and got #{qnt} \\c[1]#{item_name}\\c[0]."))
	                    $bag.add(item_id,qnt)
			 			 end
			  elsif !event.nil? 
			  if !event.is_a? Integer
			  if event!=$game_player

			  duriscannon.pokemon.attacking=false if duriscannon.pokemon.attacking.nil?
              if duriscannon.pokemon.attacking==false
			  thefight = pbOverworldCombat
			  duriscannon.pokemon.attacking=true
                  DialogueSound.reset
				       text = "#{duriscannon.pokemon.name} use #{GameData::Move.get(duriscannon.pokemon.moves2[3].id).real_name}!"
		             sideDisplay(text,false,3,false)
					     text.length.times do |i|
						  Graphics.update
						  Input.update
						  $scene.miniupdate
                   DialogueSound.play_sound_effect(i, text)
				        end
						
		  duriscannon.autoattack_opportunity += 90
			  thefight.player_pokemonattack(duriscannon,event,duriscannon.pokemon.moves2[3], distance) if !duriscannon.pokemon.moves2[3].nil?
			  duriscannon.pokemon.attacking=false
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves2[3].id).real_name}.")
			  end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves2[3].id).real_name}.")
			  end

			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(duriscannon.pokemon.moves2[3].id).real_name}.")
			 end
    end



    if Input.triggerex?(Keys::CONTROLS_LIST["9"]) && !Input.press?(Input::SHIFT)
	index = $PokemonGlobal.ball_order.index("Interact")
			     if index
				    $PokemonGlobal.ball_order[index]
				  end
	   $PokemonGlobal.cur_stored_pokemon = duriscannon.pokemon if $PokemonGlobal.cur_stored_pokemon!=duriscannon.pokemon
        duriscannon.pbTriggerOverworldMon(duriscannon)
    end
      end
	if !$PokemonGlobal.cur_stored_pokemon.nil?
   if Input.triggerex?(Keys::CONTROLS_LIST["X"])
	   $PokemonGlobal.set_ball_hud_type(:PKMN,true) 
   end
   end


   if Input.double_tap?(Input::MOUSERIGHT)  
     if duriscannon.pokemon == $PokemonGlobal.cur_stored_pokemon
	   $PokemonGlobal.set_ball_hud_type(:PKMN,true) 
	 
	 end
	   duriscannon.pokemon.inworld=false
      pbReturnPokemon(duriscannon.id,true)
	       
	end
	
	
	end
  




  
  
  end
  def running_stuff
    return if $game_temp.current_pkmn_controlled == true
	if $game_temp.disable_running==true
	 $player.running=false
    elsif Input.double_tap_dir4? && $player.playerstamina>0 && $PokemonSystem.runstyle == 0
	 $player.running=true
	elsif (Input.press?(Input::RUNNING) || Input.trigger?(Input::RUNNING)) && ($game_player.moved_last_frame || $game_player.moved_this_frame) && get_keyname("Running")!="None" && $player.playerstamina>0
	 $player.running=true
	elsif $player.playerstamina<=0 && $player.running==true
	 $player.running=false
	elsif !$game_player.moving? && $player.running==true && !$game_player.moved_last_frame
	 $player.running=false
	end
  end
 
  def punching_controls
    return if $game_temp.current_pkmn_controlled == true
    return if $game_temp.position_calling == true
    $player.punch_cooldown-=1 if $player.punch_cooldown>0
    $player.weapon_cooldown-=1 if $player.weapon_cooldown>0
    if Input.trigger?(Input::PUNCH)
	     if $player.punch_cooldown<=0
           event, distance = get_target_player($game_player)
           if !distance.nil?
			  if distance==1
			   if !event.nil? 
			    if !event.is_a? Integer
			     thefight = pbOverworldCombat
			     thefight.player_action(event,"Punch",$game_player.direction)
			    end
			   end
			  end
           end
	     else
           sideDisplay("You are too winded from your last attack still!")
	     end
    end
  end
  def mouse_detection
    if Input.time?(Input::MOUSELEFT) >= 0.3 && Input.mouse_in_window? && Input.time?(Input::MOUSELEFT) <= 0.65
	     $game_temp.preventspawns=true
	     event_id=$game_map.check_event(*get_tile_mouse_on)
	     if event_id.is_a?(Integer)
	      if $game_map.events[event_id].is_a?(Game_PokeEventA)
	       if $game_map.events[event_id].name=="PlayerPkmn" && $player.party.include?($game_map.events[event_id].pokemon)
	        $game_map.events[event_id].pokemon.deselecttimer = 50
	        pbSelectThisPokemon($game_map.events[event_id].pokemon)
	       end
	      end
	     end
        
	      $game_temp.preventspawns=false
    end


    if Input.double_tap?(Input::MOUSELEFT) && Input.mouse_in_window? 
		tiles = *get_tile_with_direction
		event_in_question = $game_map.check_event(tiles[0],tiles[1])
		nuevent = $game_map.events[event_in_question] if event_in_question.is_a?(Integer)
		nuevent = event_in_question if event_in_question.is_a?(Game_Player)
		active_directed=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
	  if Input.press?(Input::CTRL) 
		   event_in_question=$game_map.check_event(*get_tile_mouse_on)
		   if event_in_question.is_a?(Integer)
		     nuevent = $game_map.events[event_in_question]
		     if $DEBUG	  
		      puts "You are clicking on: #{$game_map.events[event_in_question].name}" if $DEBUG
		      puts "You are clicking on: #{nuevent.event.pages[0].move_route.list[0].code}" if event_in_question.name=="PlayerPkmn" && $DEBUG
		     end

		   end
	  elsif active_directed!=:MULTISELECT && nuevent.is_a?(Game_PokeEventA)
	   pbTogglePokemonSelection(nuevent.pokemon)
	  else
		   events = []
		   if $PokemonGlobal.get_selected_pokemon.length>1 && active_directed==:MULTISELECT
		      $PokemonGlobal.selected_pokemon_cleaned.each do |pkmn|
		        next if pkmn==0
		        events << $game_map.events[pkmn.associatedevent]
		      end
          elsif $PokemonGlobal.get_selected_pokemon.length==1
		    thispokemon = $PokemonGlobal.get_single_selected_pokemon
		      if !thispokemon.nil?
		        events << $game_map.events[thispokemon.associatedevent]
		      end
            

		   elsif $PokemonGlobal.ball_hud_enabled==true && active_directed.is_a?(Pokemon)
		      associatedeveneiefg = active_directed.associatedevent
			   return if associatedeveneiefg.nil?
		      eventinquestion = $game_map.events[associatedeveneiefg]
		      if !eventinquestion.nil?
		        events << eventinquestion
		      end


		   end

          return if events.empty?


		   events.each do |event|
		      next if event.nil?
		      next if !event.respond_to?("pokemon")
			    pkmn = event.pokemon
		      next if pkmn.nil?
			  
			  
			   if pkmn.effects[PBEffects::Confusion]!=0
				 sideDisplay("#{pkmn.name} is confused! It won't listen!")
			     next
			   end
			   if nuevent.is_a?(Game_PokeEventA)
			      pbTogglePokemonSelection(nuevent.pokemon)
			      next
			   end
			   
			   puts "#{event.pokemon.name} is on: X: #{event.x}, Y: #{event.y}" if $DEBUG
			   

	         if $mouse.current_mode==:FOLLOW  
		       $game_temp.preventspawns=true
			   
			    if get_cur_player == nuevent
                 event.following = get_cur_player
                 event.movement_type = :MOVEBEHINDPLAYER 
		          sideDisplay("#{$game_map.events[pkmn.associatedevent].type.name} is now following #{nuevent.pokemon.name}.")
			      next
			    end
			   
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
				  break if within_one_tile?(event.x, event.y, tiles[0],tiles[1])
				  break if loops>=60 && !event.moving?
				 end
               if within_one_tile?(event.x, event.y, tiles[0],tiles[1])
				 if event_in_question.is_a?(Integer)
                  look_at_location(event.id,nuevent.x,nuevent.y)
				  if nuevent.is_a?(Game_PokeEvent)
				    event.add_target(event_in_question,nuevent) 
                 event.following = nuevent
				    event.movement_type = :FOLLOW
				 end
					 nuevent.start if nuevent.name.include?("inter")
				 elsif event_in_question==$game_player
				 else
                 event.move_toward_the_coordinate(tiles[0],tiles[1]) if [event.x, event.y]!=[tiles[0],tiles[1]]
			     end
              end
               end
		      end

		   $game_temp.preventspawns=false 
           end 
		   end
		   
		   
		   







       end







     end

  end
   
  def positioning_controls
    return if $game_temp.position_calling == false
    return if $game_temp.current_pkmn_controlled == true
	return if $player.held_item.nil?
	return if $player.held_item_object.nil?
	
	#$PokemonGlobal.ball_hud_enabled = false if $PokemonGlobal.ball_hud_enabled==true
 
	if $PokemonGlobal.get_positioning_controls_window_text==""
	 name = GameData::Item.try_get($player.held_item).name if ($player.held_item.is_a? Symbol) || ($player.held_item.is_a? ItemData)
	 name = $player.held_item if $player.held_item.is_a? String
	 if $player.held_item.is_a?(Pokemon)
		name = "Egg" if $player.held_item.egg?
		name = $player.held_item.name if !$player.held_item.egg?
	 end
	 return if name.nil?
	 $PokemonGlobal.set_positioning_controls_window_text(name)
	end

	key_id = $player.held_item_object
	event = $game_map.events[key_id]
	return if event.nil?
	currentdir = event.direction
	if Input.trigger?(Input::USE)
	  if pbPlaceorHold
	   $PokemonGlobal.set_positioning_controls_window_text()
	   $game_system.save_disabled = false
	   $game_temp.position_calling = false
	  end
	elsif Input.triggerex?(:DOWN)
		 event.direction = 8
	elsif Input.triggerex?(:UP)
		 event.direction = 2
	elsif Input.triggerex?(:LEFT)
		 event.direction = 4
	elsif Input.triggerex?(:RIGHT)
		 event.direction = 6
	elsif Input.scroll_v==1
	  case currentdir
	   when 2
		 event.direction = 6
	   when 4 
		 event.direction = 2
	   when 6
		 event.direction = 8
	   when 8
		 event.direction = 4
	  end
	elsif Input.scroll_v==-1
	  case currentdir
	   when 2
		 event.direction = 4
	   when 4 
		 event.direction = 8
	   when 6
		 event.direction = 2
	   when 8
		 event.direction = 6
	  end
	end
  end
  
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
    elsif Input.trigger?(Input::PKMNCONTROL)
    elsif Input.trigger?(Input::USE)
	  if $PokemonGlobal.hud_selector!=4
	   facingEvent, distance = get_target_player(event)
	   if !facingEvent.nil? 
		 if !facingEvent.is_a? Integer
			thefight = pbOverworldCombat
			thefight.player_pokemonattack(event,facingEvent,pkmn.moves[$PokemonGlobal.hud_selector], distance)
		 end
	   end
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
      $game_temp.in_menu = true
    item = nil
    pbFadeOutIn(99999) {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene,$bag)
      item = screen.pbStartScreen
    }
      $game_temp.in_menu = false
    if item
      pbUseKeyItemInField(item)
    end
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
  def ball_hud_controls
    if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].nil?
	 $PokemonGlobal.ball_hud_index+=1
     $PokemonGlobal.ball_hud_index=0 if $PokemonGlobal.ball_hud_index>=$PokemonGlobal.ball_order.length
	end

 return if $PokemonGlobal.ball_hud_enabled == false
    return if $game_temp.current_pkmn_controlled == true
    return if $game_temp.position_calling == true
	$PokemonGlobal.alt_control_move=false if  $PokemonGlobal.ball_hud_type!=:PKMN
    if Input.trigger?(Input::USE)
      $game_temp.interact_calling = true
	 elsif Input.trigger?(Input::TOGGLEHUD) #X
      $PokemonGlobal.ball_hud_enabled = false
	 elsif Input.double_tap?(Input::TOGGLETYPE)
	    $game_temp.radial_enabled= !$game_temp.radial_enabled
	     pbSEPlay("GUI sel decision", 60) 
	elsif Input.double_tap?(Input::ALTMENU) 
	    if $PokemonGlobal.ball_hud_type==:PKMN
       if $PokemonGlobal.selected_pokemon.length>0 && $PokemonGlobal.alt_control_move==false && $PokemonGlobal.ball_hud_enabled == true
	     pbDeselectThisPokemon($PokemonGlobal.ball_order[0]) if $PokemonGlobal.ball_order[0]!=0
	     pbSelectThisPokemon($PokemonGlobal.ball_order[0],true) if $PokemonGlobal.ball_order[0]!=0
	     $PokemonGlobal.set_ball_hud_type(:MULTISELECT,true) 
	     pbSEPlay("GUI sel decision", 60) 
       elsif $PokemonGlobal.alt_control_move==true && $PokemonGlobal.ball_hud_enabled == true
	     $PokemonGlobal.set_ball_hud_type(:PKMN,true) 
	     pbSEPlay("GUI sel decision", 60) 
       end
	   end
	 elsif Input.trigger?(Input::SPECIAL)
    elsif Input.trigger?(Input::INVENTORY)
      $game_temp.in_menu = true
    item = nil
    pbFadeOutIn(99999) {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene,$bag)
      item = screen.pbStartScreen
    }
      $game_temp.in_menu = false
    if item
      pbUseKeyItemInField(item)
    end
	 elsif Input.trigger?(Input::ACTION)
      unless $game_system.menu_disabled || $game_player.moving?
        $game_temp.menu_calling = true
        $game_temp.menu_beep = true
      end

	 elsif Input.trigger?(Input::EXPAND)
	 if $PokemonGlobal.ball_order.length > 1
	  $PokemonGlobal.set_extended_hud=!$PokemonGlobal.set_extended_hud 
	  pbSEPlay("GUI sel decision", 60) 
	 end
	 elsif Input.trigger?(Input::JUMPDOWN) || Input.scroll_v==-1 
      if $game_temp.in_throwing==false
        $PokemonGlobal.ball_hud_index-=1
        $PokemonGlobal.ball_hud_index=($PokemonGlobal.ball_order.length-1) if $PokemonGlobal.ball_hud_index<0
        pbSEPlay("GUI sel cursor", 60)if $PokemonGlobal.ball_order.length>1
      end

	 elsif Input.trigger?(Input::JUMPUP) || Input.scroll_v==1 #D
      if $game_temp.in_throwing==false
        $PokemonGlobal.ball_hud_index+=1
        $PokemonGlobal.ball_hud_index=0 if $PokemonGlobal.ball_hud_index>=$PokemonGlobal.ball_order.length
        pbSEPlay("GUI sel cursor", 60) if $PokemonGlobal.ball_order.length>1
      end
	 elsif Input.trigger?(Input::PKMNCONTROL)

	 elsif Input.trigger?(Input::TOGGLETYPE)
     # $PokemonGlobal.set_extended_hud=false if $PokemonGlobal.set_extended_hud==true
	     if $PokemonGlobal.ball_hud_type==:PKMN
	       $PokemonGlobal.set_ball_hud_type(:ITEM,true)
		  elsif $PokemonGlobal.ball_hud_type==:ITEM
	       $PokemonGlobal.set_ball_hud_type(:PKMN,true)
		  end
	  pbSEPlay("GUI sel decision", 60) 
	 elsif  Input.press?(Input::NOTEBOOK)
	  $game_temp.notebook_calling=true
	 else#if
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
    elsif Input.triggerex?(Keys::CONTROLS_LIST["5"]) && Input.press?(Input::SHIFT)
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_weapon_permanent
    elsif Input.triggerex?(Keys::CONTROLS_LIST["6"]) && Input.press?(Input::SHIFT)
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:BATTLE,true)
   elsif Input.triggerex?(Keys::CONTROLS_LIST["7"]) && Input.press?(Input::SHIFT)
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:PLACE,true)
   elsif  Input.triggerex?(Keys::CONTROLS_LIST["8"]) && Input.press?(Input::SHIFT)
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
    elsif Input.triggerex?(Keys::CONTROLS_LIST["5"])
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_weapon_permanent
    elsif Input.triggerex?(Keys::CONTROLS_LIST["6"])
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:BATTLE,true)
   elsif Input.triggerex?(Keys::CONTROLS_LIST["7"])
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_item_hud(:PLACE,true)
   elsif  Input.triggerex?(Keys::CONTROLS_LIST["8"])
    end
	   end
  	  
	 end
  end
  def default_controls
    return if $PokemonGlobal.ball_hud_enabled == true
    return if $game_temp.current_pkmn_controlled == true
    return if $game_temp.position_calling == true
    if Input.trigger?(Input::USE)
      $game_temp.interact_calling = true
    elsif Input.trigger?(Input::INVENTORY)
      $game_temp.in_menu = true
    item = nil
    pbFadeOutIn(99999) {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene,$bag)
      item = screen.pbStartScreen
    }
      $game_temp.in_menu = false
    if item
      pbUseKeyItemInField(item)
    end
    elsif Input.trigger?(Input::ACTION)
      unless $game_system.menu_disabled || $game_player.moving?
	    $game_temp.menu_calling = true
	    $game_temp.menu_beep = true
      end
    elsif Input.trigger?(Input::SPECIAL)
      #unless $game_player.moving?
 	   # $game_temp.ready_menu_calling = true
      #end

    elsif Input.trigger?(Input::PKMNCONTROL)

    elsif Input.trigger?(Input::TOGGLEHUD)
      if !pbSeenTipCard?(:HUD)
	    pbShowTipCardsGrouped(:HUDSTUFF)
      end
      $PokemonGlobal.ball_hud_enabled = true
	   
	elsif  Input.press?(Input::NOTEBOOK)
	  $game_temp.notebook_calling=true
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
   x = (((Input.mouse_x * Game_Map::X_SUBPIXELS) + $game_map.display_x)/Game_Map::REAL_RES_X).round
   y = (((Input.mouse_y * Game_Map::Y_SUBPIXELS) + $game_map.display_y)/Game_Map::REAL_RES_Y).round
   tile_x = Input.mouse_x % Game_Map::TILE_WIDTH
   tile_y = Input.mouse_y  % Game_Map::TILE_HEIGHT

  puts "You are clicking on: X: #{x}, Y: #{y}" if $DEBUG

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
	 $game_temp.preventspawns=true
    facingEvent = $game_player.pbFacingEvent4
	 on_player = $game_map.check_event($game_player.x,$game_player.y)
	 potato = on_player if on_player!=$game_player
	 $game_temp.preventspawns=false
    next if facingEvent.nil?
    next if potato!=false && $game_map.events[potato].through==true
    next if facingEvent.through==false
	if facingEvent && facingEvent.name[/BerryPlant/i]
     facingEvent.start
	 else 
	 next
	end
  }
)

def pbDetectTarget(source=$game_player,lockon=false)
  3.times do |i|
  start_coord=[source.x,source.y]
  landing_coord=[source.x,source.y]
  case source.direction
  when 2; landing_coord[1]+=i+1
  when 4; landing_coord[0]-=i+1
  when 6; landing_coord[0]+=i+1
  when 8; landing_coord[1]-=i+1
  end
      event_id=$game_map.check_event(*landing_coord)
	  if event_id.is_a?(Integer)
	     
      if event_id > 0 && $game_map.events[event_id].name[/vanishingEncounter/]
        event=$game_map.events[event_id]
	  end
	  if $game_switches[556]==true && event_id > 0 && $game_map.events[event_id].name[/tutorialvanishingEncounter/]
        event=$game_map.events[event_id]
        return event
	  end
     if lockon==false
      return event, i+1
     end
    end
     if event_id==$game_player && source!=$game_player
       return $game_player, i+1
	 end
end

end

def pbGetTargetDistance(source=$game_player,amt=3)
  events = []
  closest_events = []
  amt.times do |i|
  start_coord=[source.x,source.y]
  landing_coord=[source.x,source.y]
  case source.direction
  when 2; landing_coord[1]+=i+1
  when 4; landing_coord[0]-=i+1
  when 6; landing_coord[0]+=i+1
  when 8; landing_coord[1]-=i+1
  end
  event_id=$game_map.check_event(*landing_coord)
	next if !event_id.is_a?(Integer) && event_id != $game_player
     events << [event_id,i+1]
end
  theevent = events.min_by { |event| event[1] }
  if !theevent.nil?
  min_distance = theevent[1]
  closest_events = events.select { |event| event[1] == min_distance }
  end
  return closest_events
end



def pbGetLockOnTarget(source=$game_player)
  return if source==$game_player && $game_temp.lockontarget!=false
	do_it = false
    do_it,amt,start_end = throwing_range_logic(do_it, amt)
	if do_it==true
  event_id=$game_map.check_event(start_end[1][0],start_end[1][1])
  if event_id.is_a?(Integer) && event_id > 0 #&& ($game_map.events[event_id].name[/vanishingEncounter/] || $game_map.events[event_id].name[/tutorialvanishingEncounter/])
     event=$game_map.events[event_id]
        secondarye = event
		 
		 key = [secondarye.map_id, secondarye.id, "A"]
	 return false if event.name.downcase.include?("backpack") && $game_self_switches[key] == true && $game_switches[154] == true
	 return false if event.name.include?("hiddenitem")
	 return false if event.name.include?("ExitArrow")
	 return false if event.name.match?(/^EV\d{3}$/)
	 return false if event.name.match?(/^EV\d{3}(\s.*)?$/)
	 return false if event.name.match?(/^EV\d{3}\..*$/)
	 return false if event.name.start_with?("size")
	  
     return event
  elsif event_id.is_a?(Game_Player)
     return $game_player
  end
    else
	 return false
	end
end


def pbDetectTargetPokemon(source,target=$game_player)
  potato=false
  carrot=0
  amt = sight_line(source)
  amt.times do |i|
  start_coord=[source.x,source.y]
  landing_coord=[source.x,source.y]
  case source.direction
  when 2; landing_coord[1]+=i+1
  when 4; landing_coord[0]-=i+1
  when 6; landing_coord[0]+=i+1
  when 8; landing_coord[1]-=i+1
  end
   if !target.nil?
	if target.x==landing_coord[0] && target.y==landing_coord[1]
   carrot=i+1
	end
	end
  end


  return carrot
end

def pokemon_in_world
 pkmnw = []
 $player.party.each do |pkmn|
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



EventHandlers.add(:on_player_interact, :throw_item,
  proc {
	next if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:NO || $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:NONE
	 next if $PokemonGlobal.ball_hud_enabled == false
	 next if $game_temp.current_pkmn_controlled!=false
	next if $game_temp.currently_selecting==true
	next if $game_temp.position_calling == true
	next if $mouse.current_mode==:FOLLOW #&& Input.press?(Input::ALTERNATEMOUSEMODE)
	next if $mouse.current_mode==:SQUARE 
	
	
	 $game_temp.preventspawns=true
    facingEvent = $game_player.pbFacingEvent
    facingEvent2 = $game_player.pbFacingEvent4
	 $game_temp.preventspawns=false
    next if $PokemonGlobal.diving
    next if $PokemonGlobal.surfing
    next if facingEvent && facingEvent.name[/strengthboulder/i]
    next if facingEvent2 && facingEvent2.name[/BerryPlant/i]
    next if facingEvent && facingEvent.name[/FollowerPkmn/i]
    next if facingEvent && defined?(facingEvent.pokemon)==false
    next if facingEvent && facingEvent.trigger==0
     activate_item_box_item
  }
)

def activate_item_box_item
    #return if $mouse.current_mode==:FOLLOW
    $player.acting=true
    active_item=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
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
	 elsif active_item==:RADIAL
	   $PokemonGlobal.set_ball_hud_type(:RADIAL,true)
	 elsif active_item==:WEAPONS
	   $PokemonGlobal.set_ball_hud_type(:ITEM,true) 
	   $PokemonGlobal.set_weapon_permanent
	 elsif active_item.is_a?(Pokemon::Move)
	    if !$PokemonGlobal.cur_stored_pokemon.nil?
		   duriscannon = $game_map.events[$PokemonGlobal.cur_stored_pokemon.associatedevent]
	      duriscannon.pokemon.attacking=false if duriscannon.pokemon.attacking.nil?
	      facingEvent = duriscannon.pbFacingEvent4
		   event, distance = get_target_player(duriscannon)
         if facingEvent && facingEvent.name[/BerryPlant/i] && (active_item.display_type(duriscannon.pokemon) == :FIRE || duriscannon.pokemon.types.include?(:FIRE))
             berrydata = get_other_data(facingEvent.id)
					if !berrydata.nil?
			 			 if pbConfirmMessage(_INTL("Would you like to burn this Berry Tree down?"))
						   berry = berrydata.berry_id
                    berry = GameData::Item.get(berry)
	                 qty = berrydata.berry_yield
						   berry_name = (qty > 1) ? berry.name_plural : berry.name
						   berrydata.reset
						   qnt = rand(5)+2
						   item_id = :CHARCOAL
                    item = GameData::Item.get(item_id)
						   item_name = (qnt > 1) ? item.name_plural : item.name
						   titem = ItemData.new(item_id)
						   if $bag.can_add?(titem, qnt)
                       pbMessage(_INTL("You burned down the #{qty} \\c[1]#{berry_name}\\c[0], and got #{qnt} \\c[1]#{item_name}\\c[0]."))
	                    $bag.add(titem,qnt)
						   end
			 			 end
              end
			 elsif !event.nil? 
			  if !event.is_a? Integer
			    if event!=$game_player
              if duriscannon.pokemon.attacking==false
			         thefight = pbOverworldCombat
			         duriscannon.pokemon.attacking=true
                  DialogueSound.reset
				       text = "#{duriscannon.pokemon.name} use #{GameData::Move.get(active_item.id).real_name}!"
		             sideDisplay(text,false,3,false)
					     text.length.times do |i|
						  Graphics.update
						  Input.update
						  $scene.miniupdate
                   DialogueSound.play_sound_effect(i, text)
				        end
		            duriscannon.autoattack_opportunity += 90
			         thefight.player_pokemonattack(duriscannon,event,active_item, distance) if !active_item.nil?
			         duriscannon.pokemon.attacking=false
              end
			    else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(active_item.id).real_name}.")
			    end
				else
				
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(active_item.id).real_name}.")
			  end
           else 
		  sideDisplay("#{duriscannon.type.name} has no reason to use #{GameData::Move.get(active_item.id).real_name}.")
			 end
  
  
  
  
       end
	 elsif active_item.is_a?(String)
	    if !$PokemonGlobal.cur_stored_pokemon.nil?
		   event = $game_map.events[$PokemonGlobal.cur_stored_pokemon.associatedevent]
	   direct_pokemon_sub(event,get_cur_player)
	     end
	 else
	ItemHandlers.triggerUseFromBox(active_item)
	 end
    $player.acting=false
end


def direct_pokemon_movement_main
    active_directed =$PokemonGlobal.stored_ball_order
    if active_directed == :MULTISELECT
         $PokemonGlobal.selected_pokemon.each_with_index do |pkmn, index|
			  next if pkmn.is_a?(Symbol)
		      next if pkmn==0
			  next if pkmn.inworld==false
	           event_id = pkmn.associatedevent
			  next if event_id.nil?
			  if (index==0 && pkmn!=0) || ($PokemonGlobal.selected_pokemon[0]==0 && index==1)
		     direct_pokemon_sub($game_map.events[event_id],$game_player)
			  elsif $PokemonGlobal.selected_pokemon[index-1]==0
			  else
		     direct_pokemon_sub($game_map.events[event_id],$game_map.events[$PokemonGlobal.selected_pokemon[index-1].associatedevent])
			  end
		  end
    else
	        event_id = active_directed.associatedevent
			return if event_id.nil?
		    direct_pokemon_sub($game_map.events[event_id])
    end
end

def direct_pokemon_sub(event,target=nil)

    active_direction=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
    active_directed = event
    case active_direction
      when "Follow"
	       if !target.nil?
          active_directed.following = target
          active_directed.movement_type = :MOVEBEHINDPLAYER 
          DialogueSound.reset
			text = "#{active_directed.type.name}, follow me!"
		   sideDisplay(text,false,3,false)
			text.length.times do |i|
				Graphics.update
				Input.update
				$scene.miniupdate
             DialogueSound.play_sound_effect(i, text)
			end
		  sideDisplay("#{active_directed.type.name} is now following.")
		    end
      when "Wait"
          active_directed.movement_type = :STILL 
          active_directed.still_timer = -1
          DialogueSound.reset
			text = "#{active_directed.type.name}, wait!"
		   sideDisplay(text,false,3,false)
			text.length.times do |i|
				Graphics.update
				Input.update
				$scene.miniupdate
             DialogueSound.play_sound_effect(i, text)
			end
		  sideDisplay("#{active_directed.type.name} will wait.")
      when "Wander"
          active_directed.movement_type = :WANDER 
			text = "#{active_directed.type.name}, do as you like."
		   sideDisplay(text,false,3,false)
			text.length.times do |i|
				Graphics.update
				Input.update
				$scene.miniupdate
             DialogueSound.play_sound_effect(i, text)
			end
		  sideDisplay("#{active_directed.type.name} will wander.")
      when "Search"
	    if pbConfirmMessage(_INTL("Would you like to have #{active_directed.type.name} search for hidden items?"))
			text = "#{active_directed.type.name}, are there any items around here?"
		   sideDisplay(text,false,3,false)
			text.length.times do |i|
				Graphics.update
				Input.update
				$scene.miniupdate
             DialogueSound.play_sound_effect(i, text)
			end
          active_directed.movement_type = :SEARCH 
		end
      when "Use Item"
      when "Hunt"
	    if pbConfirmMessage(_INTL("Would you like to have #{active_directed.type.name} hunt a POKeMON to fight?"))
			text = "#{active_directed.type.name}, hunt down a Pokemon!"
		   sideDisplay(text,false,3,false)
			text.length.times do |i|
				Graphics.update
				Input.update
				$scene.miniupdate
             DialogueSound.play_sound_effect(i, text)
			end
          active_directed.movement_type = :FINDENEMY 
		end
      when "Recall"
	      active_directed.pokemon.inworld=false
          pbReturnPokemon(active_directed.id,true)
	
	 end
end



def pokemonsearch(pokemon=nil)
   if get_overworld_pokemon_length > 0
		
          $game_temp.preventspawns=true
		   pkmn = pokemon.pokemon if !pokemon.nil?
		   pkmn = get_an_inworld_pokemon  if pokemon.nil?
		   pokemon = $game_map.events[getOverworldPokemonfromPokemon(pkmn)] if pokemon.nil?
           maxsize = [$game_map.width, $game_map.height].max
		   if !pokemon.nil?
            event = pbClosestHiddenItemPokemon(pokemon)
			if !event.nil?
            sideDisplay(_INTL("{1}'s has found something!", pkmn.name))
            sideDisplay(_INTL("There's an item around here!"))
            direction = nil
            offsetX = nil
            offsetY = nil
            offsetxold = nil
            offsetyold = nil
			 $game_temp.auto_move=true
            offsetX = event.x - pokemon.x
            offsetY = event.y - pokemon.y
            offsetX1 = event.x - $game_player.x
            offsetY1 = event.y - $game_player.y
            direction = pokemon.direction
            direction1 = $game_player.direction
              if offsetX.abs > offsetY.abs
                direction = (offsetX < 0) ? 4 : 6
              else
                direction = (offsetY < 0) ? 8 : 2
              end
              if offsetX1.abs > offsetY1.abs
                direction1 = (offsetX1 < 0) ? 4 : 6
              else
                direction1 = (offsetY1 < 0) ? 8 : 2
              end
              case direction
              when 2 then pokemon.move_down
              when 4 then pokemon.move_left
              when 6 then pokemon.move_right
              when 8 then pokemon.move_up
              end

            return if !pbEventCanReachPlayer?(pokemon, event, maxsize) && ( offsetxold == offsetX && offsetyold == offsetY)
            offsetxold = offsetX
			 offsetyold = offsetY
            return if offsetX == 0 && offsetY == 0   # Standing on the item, spin around





			if offsetX == 0 && offsetY == 0
              4.times do
                pbWait(Graphics.frame_rate * 2 / 10)
                pokemon.turn_right_90
              end
              pbWait(Graphics.frame_rate * 3 / 10)
              sideDisplay(_INTL("{1} is right on top of it!", pkmn.name))
			   pbMoveRoute(pokemon, [PBMoveRoute::Wait, 60])
			   event.start
			elsif !pbEventCanReachPlayer?(pokemon, event, maxsize)
			  
              sideDisplay(_INTL("{1} is close by, but can't get to it directly!", pkmn.name))
              case direction
              when 2 then pokemon.turn_down
              when 4 then pokemon.turn_left
              when 6 then pokemon.turn_right
              when 8 then pokemon.turn_up
              end
			   pbMoveRoute(pokemon, [PBMoveRoute::Wait, 30])
			end
            $game_temp.auto_move=false
          else
            sideDisplay(_INTL("...", pkmn.name))
            sideDisplay(_INTL("...", pkmn.name))
            sideDisplay(_INTL("...", pkmn.name))
            sideDisplay(_INTL("{1} cannot find anything.", pkmn.name))
			end
           end







	end
         $game_temp.preventspawns=false
	end
