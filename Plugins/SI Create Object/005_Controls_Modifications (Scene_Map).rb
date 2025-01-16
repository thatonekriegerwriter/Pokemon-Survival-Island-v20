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
    unless pbMapInterpreterRunning? || ($game_temp.message_window_showing && $PokemonGlobal.alternate_control_mode==false) ||
           ($game_temp.in_mini_update && $PokemonGlobal.alternate_control_mode==false) || $game_temp.in_menu || $game_temp.no_moving
      # Move player in the direction the directional button is being pressed
      if $game_temp.current_pkmn_controlled!=false
        current_pkmn_controlled_behavior

      end
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
    # Record last direction input
      @lastdirframe = System.uptime if dir != @lastdir
    @lastdir      = dir
  end
  
	def current_pkmn_controlled_behavior
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
        self.move_speed = (type == :cycling_jumping) ? 3 : 5
      end
      new_charset = pbGetPlayerCharset(meta.cycle_charset)
    when :running
      self.move_speed = 3.50 if !@move_route_forcing && ($player.playershoes == :NORMALSHOES || $player.playershoes == :SEASHOES)
      self.move_speed = 3.75 if !@move_route_forcing && $player.is_it_this_class?(:TRIATHLETE,false)
      self.move_speed = 3.75 if !@move_route_forcing && $player.playershoes == :MAKESHIFTRUNNINGSHOES
      self.move_speed = 4 if !@move_route_forcing && $player.is_it_this_class?(:HIKER) && $game_map&.name&.downcase&.include?("mountain") && $bag.has?(:POLE)
      self.move_speed = 4 if !@move_route_forcing && $player.playershoes == :RUNNINGSHOES
      self.move_speed = 4 if !@move_route_forcing && $player.has_running_shoes
      new_charset = pbGetPlayerCharset(meta.run_charset)
    when :ice_sliding
      self.move_speed = 4 if !@move_route_forcing
      new_charset = pbGetPlayerCharset(meta.walk_charset)
    else   # :walking, :jumping, :walking_stopped
      self.move_speed = 3 if !@move_route_forcing
      new_charset = pbGetPlayerCharset(meta.walk_charset)
    end
    @character_name = new_charset if new_charset
  end


  def can_run?
    return @move_speed > 3 if @move_route_forcing
    return false if $game_temp.in_menu || $game_temp.in_battle || pbMapInterpreterRunning? || $player.playerstamina==0
    return false if jumping?
    #return false if $PokemonGlobal.partner (!$player.has_running_shoes && ($player.playershoes == :NORMALSHOES || $player.playershoes == :SEASHOES))&&
    return false if pbTerrainTag.must_walk
    return $player.running #^ ($PokemonSystem.runstyle == 1)
  end
  
  def can_run_unforced?
    return false if $game_temp.in_menu || $game_temp.in_battle || pbMapInterpreterRunning? || $player.playerstamina==0
    return false if jumping?
    #return false if $PokemonGlobal.partner (!$player.has_running_shoes && ($player.playershoes == :NORMALSHOES || $player.playershoes == :SEASHOES))&&
    return false if pbTerrainTag.must_walk
    return $player.running #^ ($PokemonSystem.runstyle == 1)
  end
end





class Scene_Map

  def update
    $PokemonGlobal.addNewFrameCount
    loop do
      pbMapInterpreter.update
      $game_player.update
      updateMaps
      $game_system.update
      $game_screen.update
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
	   
        $game_temp.lockontarget=false if $game_temp.lockontarget.pokemon.hp<1
	    return if $game_temp.lockontarget==false
		  event = $game_player if $game_temp.current_pkmn_controlled==false
		  event = $game_temp.current_pkmn_controlled if $game_temp.current_pkmn_controlled!=false
	       if false
	   if Input.double_tap?(Input::UP) && Input.trigger?(Input::LEFT)
        $game_player.move_upper_left
	   elsif Input.double_tap?(Input::UP)
        $game_player.move_upper_right
	   elsif Input.double_tap?(Input::DOWN) && Input.trigger?(Input::LEFT)
        $game_player.move_lower_left
	   elsif Input.double_tap?(Input::DOWN)
        $game_player.move_lower_right
	   elsif Input.single_tap?(Input::RIGHT) #&& (!Input.trigger?(Input::DOWN) && !Input.trigger?(Input::UP))
        $game_player.move_right
	   elsif Input.single_tap?(Input::LEFT) #&& (!Input.trigger?(Input::DOWN) && !Input.trigger?(Input::UP))
        $game_player.move_left
	   elsif Input.single_tap?(Input::DOWN) #&& (!Input.trigger?(Input::RIGHT) && !Input.trigger?(Input::LEFT))
        $game_player.move_down
	   elsif Input.single_tap?(Input::UP) #&& (!Input.trigger?(Input::RIGHT) && !Input.trigger?(Input::LEFT))
        $game_player.move_up
	   end
	      end
	   if Input.trigger?(Input::UP) && Input.trigger?(Input::LEFT)
        event.move_upper_left
	   elsif Input.trigger?(Input::RIGHT) && Input.trigger?(Input::UP)
        event.move_upper_right
	   elsif Input.trigger?(Input::DOWN) && Input.trigger?(Input::LEFT)
        event.move_lower_left
	  elsif Input.trigger?(Input::RIGHT) && Input.trigger?(Input::DOWN)
        event.move_lower_right
	   elsif Input.trigger?(Input::RIGHT) #&& (!Input.trigger?(Input::DOWN) && !Input.trigger?(Input::UP))
        event.move_right
	   elsif Input.trigger?(Input::LEFT) #&& (!Input.trigger?(Input::DOWN) && !Input.trigger?(Input::UP))
        event.move_left
	   elsif Input.trigger?(Input::DOWN) #&& (!Input.trigger?(Input::RIGHT) && !Input.trigger?(Input::LEFT))
        event.move_down
	   elsif Input.trigger?(Input::UP) #&& (!Input.trigger?(Input::RIGHT) && !Input.trigger?(Input::LEFT))
        event.move_up
	   end
	   pbTurnTowardEvent(event,$game_temp.lockontarget)
	   pbCameraToEvent($game_temp.lockontarget.id)
	
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
	elsif Input.press?(Input::F9)
       $game_temp.debug_calling = true if $DEBUG
	elsif Input.press?(Input::LOCKON) && $game_temp.position_calling == false
       $game_temp.lockontarget=false if $game_temp.lockontarget.nil?
       if $game_temp.lockontarget!=false
	     $game_temp.lockontarget=false
       else
	     pbDetectTarget
       end
	elsif Input.double_tap?(Input::ALTMENU) 
       if $PokemonGlobal.selected_pokemon.length>0 && $PokemonGlobal.alt_control_move==false && $PokemonGlobal.ball_hud_enabled == true
	     pbDeselectThisPokemon($PokemonGlobal.ball_order[0]) if $PokemonGlobal.ball_order[0]!=0
	     pbSelectThisPokemon($PokemonGlobal.ball_order[0],true) if $PokemonGlobal.ball_order[0]!=0
	     $PokemonGlobal.set_extended_hud=false
	     $PokemonGlobal.alt_control_move=true
	     pbSEPlay("GUI sel decision", 60) 
	     getCurrentItemOrder(true)
       elsif $PokemonGlobal.alt_control_move==true && $PokemonGlobal.ball_hud_enabled == true
	     $PokemonGlobal.alt_control_move=false
	     pbSEPlay("GUI sel decision", 60) 
	     getCurrentItemOrder(true)
       end

	elsif Input.trigger?(Input::CYCLEMOUSETYPE)
	  $mouse.change_mode
	elsif Input.double_tap?(Input::BACK)  
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
	if $PokemonGlobal.get_selected_pokemon_length==1
		$PokemonGlobal.selected_pokemon.each do |pkmn|
			next if pkmn==0
	        event_id = pkmn.associatedevent
		end
	else
	  event_id = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].associatedevent if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon)
	
	end
	duriscannon = $game_map.events[event_id] if !event_id.nil?
	if !duriscannon.nil?
    if Input.triggerex?(0x31) 
	
			  event, distance = get_target_player(duriscannon)
			  if !event.nil? 
			  if !event.is_a? Integer
			  if event!=$game_player

			  thefight = pbOverworldCombat
			  thefight.player_pokemonattack(duriscannon,event,duriscannon.pokemon.moves[0], distance) if !duriscannon.pokemon.moves[0].nil?
			  end
			  end
			  end
    end
    if Input.triggerex?(0x32) 
	
			  event, distance = get_target_player(duriscannon)
			  if !event.nil? 
			  if !event.is_a? Integer
			  if event!=$game_player

			  thefight = pbOverworldCombat
			  thefight.player_pokemonattack(duriscannon,event,duriscannon.pokemon.moves[1], distance) if !duriscannon.pokemon.moves[1].nil?
			  end
			  end
			  end
    end
    if Input.triggerex?(0x33)
	  
			  event, distance = get_target_player(duriscannon)
			  if !event.nil? 
			  if !event.is_a? Integer
			  if event!=$game_player

			  thefight = pbOverworldCombat
			  thefight.player_pokemonattack(duriscannon,event,duriscannon.pokemon.moves[2], distance) if !duriscannon.pokemon.moves[2].nil?
			  end
			  end
			  end
    end
    if Input.triggerex?(0x34)
	   
			  event, distance = get_target_player(duriscannon)
			  if !event.nil? 
			  if !event.is_a? Integer
			  if event!=$game_player

			  thefight = pbOverworldCombat
			  thefight.player_pokemonattack(duriscannon,event,duriscannon.pokemon.moves[3], distance) if !duriscannon.pokemon.moves[3].nil?
			  end
			  end
			  end
    end
    if Input.triggerex?(0x35)
	  
        duriscannon.pbTriggerOverworldMon(duriscannon)
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
	      $game_temp.preventspawns=false
	      end
	     end
    end


    if Input.double_tap?(Input::MOUSELEFT) && Input.mouse_in_window? 
           dont=false
		   event_id=$game_map.check_event(*get_tile_mouse_on)
		   if event_id.is_a?(Integer) || event_id==$game_player
            active_directed=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
			  if !active_directed.nil?
		     event_in_question = $game_map.events[event_id] if event_id.is_a?(Integer) 
		     event_in_question = event_id if event_id==$game_player
            if event_in_question.is_a?(Game_PokeEvent) && $PokemonGlobal.get_selected_pokemon_length>0
				if active_directed==:MULTISELECT
		      $PokemonGlobal.selected_pokemon.each do |pkmn|
		        next if pkmn==0
				if pkmn.effects[PBEffects::Confusion]==0
				 #next $game_map.events[pkmn.associatedevent].nil?
		        move_to_location($game_map.events[pkmn.associatedevent],event_in_question.x,event_in_question.y)
			    pbTurnTowardEvent($game_map.events[pkmn.associatedevent],event_in_question)
				$game_map.events[pkmn.associatedevent].add_target(event_id,event_in_question)
				else
				 sideDisplay("#{pkmn.name} is confused! It won't listen!")
				end
		      end
             elsif $PokemonGlobal.get_selected_pokemon_length==1 && active_directed != $PokemonGlobal.get_single_selected_pokemon
			   pkmn = $PokemonGlobal.get_single_selected_pokemon
			   if pkmn.is_a?(Pokemon)
				if pkmn.effects[PBEffects::Confusion]==0
		        move_to_location($game_map.events[pkmn.associatedevent],event_in_question.x,event_in_question.y)
			    pbTurnTowardEvent($game_map.events[pkmn.associatedevent],event_in_question)
				$game_map.events[pkmn.associatedevent].add_target(event_id,event_in_question)
				else
				 sideDisplay("#{pkmn.name} is confused! It won't listen!")
				end
			   end
           else
			   if active_directed.is_a?(Pokemon)
			    return if active_directed.associatedevent.nil?
				if active_directed.associatedevent[PBEffects::Confusion]==0
		        move_to_location($game_map.events[active_directed.associatedevent],event_in_question.x,event_in_question.y)
			    pbTurnTowardEvent($game_map.events[active_directed.associatedevent],event_in_question)
				$game_map.events[active_directed.associatedevent].add_target(event_id,event_in_question)
				else
				 sideDisplay("#{active_directed.name} is confused! It won't listen!")
				end
			   end
			  
			     dont=true
			  end
            elsif event_in_question == $game_player
				if active_directed==:MULTISELECT
		      $PokemonGlobal.selected_pokemon.each do |pkmn|
		        next if pkmn==0
				 #next $game_map.events[pkmn.associatedevent].nil?
				if pkmn.effects[PBEffects::Confusion]==0
             $game_map.events[pkmn.associatedevent].following = $game_player
             $game_map.events[pkmn.associatedevent].movement_type = :MOVEBEHINDPLAYER 
		      sideDisplay("#{$game_map.events[pkmn.associatedevent].type.name} is now following.")
			   count+=1
				 dont=true
				else
				 sideDisplay("#{pkmn.name} is confused! It won't listen!")
				end
		      end

             elsif $PokemonGlobal.get_selected_pokemon_length==1 && active_directed != $PokemonGlobal.get_single_selected_pokemon
			   pkmn = $PokemonGlobal.get_single_selected_pokemon
			   if pkmn.is_a?(Pokemon)
				if pkmn.effects[PBEffects::Confusion]==0
             $game_map.events[pkmn.associatedevent].following = $game_temp.current_pkmn_controlled
             $game_map.events[pkmn.associatedevent].movement_type = :MOVEBEHINDPLAYER 
		      sideDisplay("#{$game_map.events[pkmn.associatedevent].type.name} is now following.")
				 dont=true
				else
				 sideDisplay("#{pkmn.name} is confused! It won't listen!")
				end
			   end
			  else
			   if active_directed.is_a?(Pokemon)
			    return if active_directed.associatedevent.nil?
				if active_directed.effects[PBEffects::Confusion]==0
             $game_map.events[active_directed.associatedevent].following = $game_player
             $game_map.events[active_directed.associatedevent].movement_type = :MOVEBEHINDPLAYER 
		      sideDisplay("#{$game_map.events[active_directed.associatedevent].type.name} is now following.")
				 dont=true
				else
				 sideDisplay("#{active_directed.name} is confused! It won't listen!")
				end
			   end
			  
			  end
            elsif event_in_question == $game_temp.current_pkmn_controlled && $game_temp.current_pkmn_controlled!=false
				if active_directed==:MULTISELECT
		      $PokemonGlobal.selected_pokemon.each do |pkmn|
		        next if pkmn==0
				 #next $game_map.events[pkmn.associatedevent].nil?
				if pkmn.effects[PBEffects::Confusion]==0
             $game_map.events[pkmn.associatedevent].following = $game_temp.current_pkmn_controlled
             $game_map.events[pkmn.associatedevent].movement_type = :MOVEBEHINDPLAYER 
		      sideDisplay("#{$game_map.events[pkmn.associatedevent].type.name} is now following.")
				else
				 sideDisplay("#{pkmn.name} is confused! It won't listen!")
				end
		      end
             elsif $PokemonGlobal.get_selected_pokemon_length==1 && active_directed != $PokemonGlobal.get_single_selected_pokemon
			   pkmn = $PokemonGlobal.get_single_selected_pokemon
			   if pkmn.is_a?(Pokemon)
				if pkmn.effects[PBEffects::Confusion]==0
             $game_map.events[pkmn.associatedevent].following = $game_temp.current_pkmn_controlled
             $game_map.events[pkmn.associatedevent].movement_type = :MOVEBEHINDPLAYER 
		      sideDisplay("#{$game_map.events[pkmn.associatedevent].type.name} is now following.")
				else
				 sideDisplay("#{pkmn.name} is confused! It won't listen!")
				end
			   end
			  else
			   if active_directed.is_a?(Pokemon)
			    return if active_directed.associatedevent.nil?
				if active_directed.effects[PBEffects::Confusion]==0
             $game_map.events[active_directed.associatedevent].following = $game_temp.current_pkmn_controlled
             $game_map.events[active_directed.associatedevent].movement_type = :MOVEBEHINDPLAYER 
		      sideDisplay("#{$game_map.events[active_directed.associatedevent].type.name} is now following.")
				else
				 sideDisplay("#{active_directed.name} is confused! It won't listen!")
				end
			   end
			  
			  end
            elsif event_in_question.name.include?("inter")
				if active_directed==:MULTISELECT
		      $PokemonGlobal.selected_pokemon.each do |pkmn|
		        next if pkmn==0
				 myid = pkmn.associatedevent
				 $game_map.events[pkmn.associatedevent].currently_moving=true
				 move_to_location($game_map.events[pkmn.associatedevent],event_in_question.x,event_in_question.y,true)
			    pbTurnTowardEvent($game_map.events[pkmn.associatedevent],event_in_question)
				 event_in_question.start
				 dont=true
				 end
             elsif $PokemonGlobal.get_selected_pokemon_length==1 && active_directed != $PokemonGlobal.get_single_selected_pokemon
			   pkmn = $PokemonGlobal.get_single_selected_pokemon
			   if pkmn.is_a?(Pokemon)
				 move_to_location($game_map.events[pkmn.associatedevent],event_in_question.x,event_in_question.y,true)
			    pbTurnTowardEvent($game_map.events[pkmn.associatedevent],event_in_question)
				 event_in_question.start
				 dont=true
			   end
			  else
			   if active_directed.is_a?(Pokemon)
			    
			    return if active_directed.associatedevent.nil?
				 move_to_location($game_map.events[active_directed.associatedevent],event_in_question.x,event_in_question.y,true)
			    pbTurnTowardEvent($game_map.events[active_directed.associatedevent],event_in_question)
				 event_in_question.start
				 dont=true
			   end
			  
			  end
            elsif event_in_question.is_a?(Game_PokeEventA)
			   pbTogglePokemonSelection(event_in_question.pokemon)
            end
            end
			end

	   if $PokemonGlobal.ball_hud_enabled==true && $mouse.current_mode==:FOLLOW && dont==false
		   $game_temp.preventspawns=true
		   events = []
		   if $PokemonGlobal.get_selected_pokemon_length>0
		      $PokemonGlobal.selected_pokemon.each do |pkmn|
		        next if pkmn==0
		        events << $game_map.events[pkmn.associatedevent]
		      end
		   else
		      associatedeveneiefg = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].associatedevent if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon)
			   return if associatedeveneiefg.nil?
		      eventinquestion = $game_map.events[associatedeveneiefg] if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon)
		      if !eventinquestion.nil?
		        events << eventinquestion
		      end
		   end
		   events.each do |event|
		      next if event.nil?
		      if event.move_with_maps(event.map_id,*get_tile_with_direction)
		        event.movement_type = :STILL
		        event.still_timer=-1
		      end
		   end
		   $game_temp.preventspawns=false
		

	   elsif Input.press?(Input::CTRL) 
		   event_id=$game_map.check_event(*get_tile_mouse_on)
		   if event_id.is_a?(Integer)
		     event_in_question = $game_map.events[event_id]
		     if $DEBUG	  
		      puts "You are clicking on: #{$game_map.events[event_id].name}" if $DEBUG
		      puts "You are clicking on: #{event_in_question.event.pages[0].move_route.list[0].code}" if event_in_question.name=="PlayerPkmn" && $DEBUG
		     end

		   end
       else
       end

    end
  end
   
  def positioning_controls
    return if $game_temp.position_calling == false
    return if $game_temp.current_pkmn_controlled == true
	return if $player.held_item.nil?
	return if $player.held_item_object.nil?
	
	$PokemonGlobal.ball_hud_enabled = false if $PokemonGlobal.ball_hud_enabled==true
 
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
	  event.pokemonchoices(event)
    elsif Input.trigger?(Input::USE)
	  if $PokemonGlobal.hud_selector!=4
	   facingEvent, distance = get_target_player(event)
	   if !facingEvent.nil? 
		 if !facingEvent.is_a? Integer
			facingEvent.ov_battle=OverworldCombat.new(facingEvent) if facingEvent.ov_battle.nil?
			thefight = facingEvent.ov_battle
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
    return if $PokemonGlobal.ball_hud_enabled == false
    return if $game_temp.current_pkmn_controlled == true
    return if $game_temp.position_calling == true
    if Input.trigger?(Input::USE)
      $game_temp.interact_calling = true
	 elsif Input.trigger?(Input::TOGGLEHUD) #X
      $PokemonGlobal.ball_hud_enabled = false
	 elsif Input.trigger?(Input::SPECIAL)
	 if $PokemonGlobal.ball_hud_enabled==true
	   if $hud.is_broseph?
	   $PokemonGlobal.display_moves = !$PokemonGlobal.display_moves
	  pbSEPlay("GUI sel decision", 60) 
	   end
	  end
	 elsif Input.trigger?(Input::ACTION)
      unless $game_system.menu_disabled || $game_player.moving?
        $game_temp.menu_calling = true
        $game_temp.menu_beep = true
      end

	 elsif Input.trigger?(Input::EXPAND)
	 if $PokemonGlobal.ball_order.length > 1 && $PokemonGlobal.ball_hud_type==:PKMN
	  $PokemonGlobal.set_extended_hud=!$PokemonGlobal.set_extended_hud 
	  pbSEPlay("GUI sel decision", 60) 
	 end
	 elsif Input.trigger?(Input::JUMPUP) || Input.scroll_v==1 
      if $game_temp.in_throwing==false
        $PokemonGlobal.ball_hud_index-=1
        $PokemonGlobal.ball_hud_index=($PokemonGlobal.ball_order.length-1) if $PokemonGlobal.ball_hud_index<0
        pbSEPlay("GUI sel cursor", 60)if $PokemonGlobal.ball_order.length>1
      end

	 elsif Input.trigger?(Input::JUMPDOWN) || Input.scroll_v==-1 #D
      if $game_temp.in_throwing==false
        $PokemonGlobal.ball_hud_index+=1
        $PokemonGlobal.ball_hud_index=0 if $PokemonGlobal.ball_hud_index>=$PokemonGlobal.ball_order.length
        pbSEPlay("GUI sel cursor", 60) if $PokemonGlobal.ball_order.length>1
      end
	 elsif Input.trigger?(Input::PKMNCONTROL)
      if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon)
        if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].inworld
		   pkmn = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
          $game_temp.preventspawns=true
          pokemon = pkmn.associatedevent
          event = $game_map.events[pokemon]
          $game_temp.preventspawns=false
          event.pokemonchoices(event)
        end
      end
	 elsif Input.trigger?(Input::TOGGLETYPE)
      $PokemonGlobal.set_extended_hud=false if $PokemonGlobal.set_extended_hud==true
      if $PokemonGlobal.alt_control_move==true
        $PokemonGlobal.alt_control_move=false
      else
        if $PokemonGlobal.ball_hud_type==:PKMN
	      $PokemonGlobal.ball_hud_pkmn_index=$PokemonGlobal.ball_hud_index
        else 
		   if $PokemonGlobal.ball_hud_item_type==:TOOL
	         $PokemonGlobal.ball_hud_item_index=$PokemonGlobal.ball_hud_index
		   else
	         $PokemonGlobal.ball_hud_place_index=$PokemonGlobal.ball_hud_index
		   end
        end 
      end
      $PokemonGlobal.ball_hud_type_toggle
      getCurrentItemOrder(true)
	 elsif  Input.press?(Input::NOTEBOOK)
	  $game_temp.notebook_calling=true
	 end
  end
  def default_controls
    return if $PokemonGlobal.ball_hud_enabled == true
    return if $game_temp.current_pkmn_controlled == true
    return if $game_temp.position_calling == true
    if Input.trigger?(Input::USE)
      $game_temp.interact_calling = true
    elsif Input.trigger?(Input::ACTION)
      unless $game_system.menu_disabled || $game_player.moving?
	    $game_temp.menu_calling = true
	    $game_temp.menu_beep = true
      end
    elsif Input.trigger?(Input::SPECIAL)
	 if $PokemonGlobal.ball_hud_enabled==true
	   if $hud.is_broseph?
	   $PokemonGlobal.display_moves = !$PokemonGlobal.display_moves
	  pbSEPlay("GUI sel decision", 60) 
	   end
	  end
      #unless $game_player.moving?
 	  #  $game_temp.ready_menu_calling = true
      #end

    elsif Input.trigger?(Input::PKMNCONTROL)
      if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon) && $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].inworld
	    $game_temp.preventspawns=true
	    pokemon = getOverworldPokemonfromPokemon($PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index])
	    event = $game_map.events[pokemon]
	    $game_temp.preventspawns=false
	    event.pokemonchoices(event)
      end
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

def pbDetectTarget(source=$game_player,lockon=true)
  3.times do |i|
  start_coord=[source.x,source.y]
  landing_coord=[source.x,source.y]
  next if source==$game_player && $game_temp.lockontarget!=false && lockon==true
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
  else
	  	 $game_temp.lockontarget=false
	  	 $game_temp.lockontarget=event
  end
    end
     if event_id==$game_player && source!=$Game_Player
  if lockon==false
   return $game_player, i+1
  else
	  	 $game_temp.lockontarget=false
	  	 $game_temp.lockontarget=$game_player
  end
	 
	 end
end

end



def pbDetectTargetPokemon(source,target=$game_player)
  potato=false
  carrot=0
  3.times do |i|
  start_coord=[source.x,source.y]
  landing_coord=[source.x,source.y]
  case source.direction
  when 2; landing_coord[1]+=i+1
  when 4; landing_coord[0]-=i+1
  when 6; landing_coord[0]+=i+1
  when 8; landing_coord[1]-=i+1
  end
	if target.x==landing_coord[0] && target.y==landing_coord[1]
   carrot=i+1
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
	 $game_temp.preventspawns=true
    facingEvent = $game_player.pbFacingEvent
    facingEvent2 = $game_player.pbFacingEvent4
	 $game_temp.preventspawns=false
	 next if $PokemonGlobal.ball_hud_enabled == false
	 next if $game_temp.current_pkmn_controlled!=false
    next if $PokemonGlobal.diving
    next if $PokemonGlobal.surfing
    next if facingEvent && facingEvent.name[/strengthboulder/i]
    next if facingEvent2 && facingEvent2.name[/BerryPlant/i]
    next if facingEvent && facingEvent.name[/FollowerPkmn/i]
    next if facingEvent && defined?(facingEvent.pokemon)==false
    next if facingEvent && facingEvent.trigger==0
	next if $game_temp.position_calling == true
     activate_item_box_item
  }
)

def activate_item_box_item
    return if $mouse.current_mode==:FOLLOW
    $player.acting=true
    active_item=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
	return if active_item.nil?
	 if active_item.is_a?(String) && $PokemonGlobal.alt_control_move==true
	 direct_pokemon_movement_main
	 elsif active_item==:MULTISELECT
	 else
	ItemHandlers.triggerUseFromBox(active_item)
	 end
    $player.acting=false
end


def direct_pokemon_movement_main
    active_directed =$PokemonGlobal.stored_ball_order
    if active_directed == :MULTISELECT
         $PokemonGlobal.selected_pokemon.each_with_index do |pkmn, index|
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
          active_directed.following = target
          active_directed.movement_type = :MOVEBEHINDPLAYER 
		  sideDisplay("#{active_directed.type.name} is now following.")
      when "Wait"
          active_directed.movement_type = :STILL 
          active_directed.still_timer = -1
		  sideDisplay("#{active_directed.type.name} will wait.")
      when "Wander"
          active_directed.movement_type = :WANDER 
		  sideDisplay("#{active_directed.type.name} will wander.")
      when "Search (I)"
	    if pbConfirmMessage(_INTL("Would you like to have #{active_directed.type.name} search for hidden items?"))
          active_directed.movement_type = :SEARCH 
		end
      when "Search (E)"
	    if pbConfirmMessage(_INTL("Would you like to have #{active_directed.type.name} hunt a POKeMON to fight?"))
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
