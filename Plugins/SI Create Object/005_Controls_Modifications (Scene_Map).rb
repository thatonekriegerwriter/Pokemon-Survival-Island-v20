class Game_Player < Game_Character
  def update_command_new
    dir = Input.dir4
    unless pbMapInterpreterRunning? || $game_temp.message_window_showing ||
           $game_temp.in_mini_update || $game_temp.in_menu
      # Move player in the direction the directional button is being pressed

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
    # Record last direction input
      @lastdirframe = System.uptime if dir != @lastdir
    @lastdir      = dir
  end
end
class Scene_Map
$window2 = nil
  def call_HUD
#    $game_temp.hud_calling = false
#    $game_temp.in_menu = true
#    $game_player.straighten
#    $game_map.update
#    sscene = PokemonHUDMenu_Scene.new
#    sscreen = PokemonHUDMenu.new(sscene)
#    sscreen.pbStartHUDMenu
#    $game_temp.in_menu = false
  end		
  
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
    return if $game_temp.message_window_showing
	
	
	
	
	
	
	
	
	
	
	
    if !$game_system.map_interpreter.running?
	  if $game_temp.position_calling.nil?
	    $game_temp.position_calling=false
	  end
	  
   
    if $game_switches[556]==true
	  target = pbDetectTarget
	  if  !target.is_a?(Integer)  && !target.is_a?(Array) &&  !target.nil?
	     target.start
	  
	  end
	
	end



	 if $game_temp.lockontarget!=false
	 if $game_temp.lockontarget.pokemon.hp<1
	   $game_temp.lockontarget=false
	 end
	 end
	 if $game_temp.lockontarget!=false
	 
	  if Input.trigger?(Input::UP) && Input.trigger?(Input::LEFT)
	       $game_player.move_upper_left
      elsif Input.trigger?(Input::RIGHT) && Input.trigger?(Input::UP)
	$game_player.move_upper_right
      elsif Input.trigger?(Input::DOWN) && Input.trigger?(Input::LEFT)
	$game_player.move_lower_left
      elsif Input.trigger?(Input::RIGHT) && Input.trigger?(Input::DOWN)
	$game_player.move_lower_right
	  elsif Input.trigger?(Input::RIGHT) #&& (!Input.trigger?(Input::DOWN) && !Input.trigger?(Input::UP))
	$game_player.move_right
	  elsif Input.trigger?(Input::LEFT) #&& (!Input.trigger?(Input::DOWN) && !Input.trigger?(Input::UP))
	$game_player.move_left
	  elsif Input.trigger?(Input::DOWN) #&& (!Input.trigger?(Input::RIGHT) && !Input.trigger?(Input::LEFT))
	$game_player.move_down
	  elsif Input.trigger?(Input::UP) #&& (!Input.trigger?(Input::RIGHT) && !Input.trigger?(Input::LEFT))
	$game_player.move_up
	  end
	pbTurnTowardEvent($game_player,$game_temp.lockontarget)
	pbCameraToEvent($game_temp.lockontarget.id)
	end




	 if $game_temp.current_pkmn_controlled!=false
	 if $game_temp.current_pkmn_controlled.type.hp<1
	   $game_temp.current_pkmn_controlled=false
	 end
	 if $game_temp.current_pkmn_controlled!=false
	 if $game_temp.current_pkmn_controlled.type.inworld==false
	   $game_temp.current_pkmn_controlled=false
	 end
	 end
    end


	 if $game_temp.current_pkmn_controlled!=false
	 if Input.trigger?(Input::RIGHT) || Input.repeat?(Input::RIGHT)
	$game_temp.current_pkmn_controlled.move_right
	  elsif Input.trigger?(Input::LEFT) || Input.repeat?(Input::LEFT)
	$game_temp.current_pkmn_controlled.move_left
	  elsif Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN)
	$game_temp.current_pkmn_controlled.move_down
	  elsif Input.trigger?(Input::UP) || Input.repeat?(Input::UP)
	$game_temp.current_pkmn_controlled.move_up
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
     behavior_type
    if Input.trigger?(Input::LOCKON) #Lock on. Currently is the Roll lock button.
	 puts "LOCK ON"
	 $game_temp.lockontarget=false if $game_temp.lockontarget.nil?
	if $game_temp.lockontarget!=false
	 $game_temp.lockontarget=false
	 puts "LOCK ON2"
	else
	 puts "LOCK ON3"
	 pbDetectTarget
	end
  end

    end
	
	
	
	
	
	
	
	
	
	
	
	
	
    unless $game_player.moving?
      if $game_temp.menu_calling && $game_temp.current_pkmn_controlled==false
        call_menu
#      elsif $game_temp.hud_calling
#        call_HUD
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
        NoteOpen.openWindow
      end
    end
  end


  



  def behavior_type
      if $game_temp.position_calling == true #Input Logic for Placing Overworld Objects
	   $PokemonGlobal.ball_hud_enabled = false
	    if true
	      key_id = $player.held_item_object
		  if $player.held_item.is_a? Symbol
	      name = GameData::Item.try_get($player.held_item).name
		  elsif $player.held_item.is_a? String
		    name = $player.held_item
		  elsif $player.held_item.is_a?(Pokemon)
		   if $player.held_item.egg?
		    name = "Egg"
		   else
		    name = $player.held_item.name
			end
		  end
		  if name.nil?
		   return
		  end
		if $window2.nil?
	    $window2 = Window_UnformattedTextPokemon.newWithSize(name, 270, 0, 240, 64)
        $window2.visible = true
        $window2.z = 99999
		end
         if Input.trigger?(Input::USE) || Input.trigger?(Input::MOUSELEFT) 
		
	       if pbPlaceorHold
           $window2.dispose
           $window2=nil
		   $game_system.save_disabled = false
		   $game_temp.position_calling = false
		   else
		   end
	   elsif Input.trigger?(Input::SEARCH)
	     #pokemonsearch
		 
       elsif Input.trigger?(Input::JUMPUP)  || Input.scroll_v==1#A
		 currentdir = $game_map.events[key_id].direction
		 case currentdir
		 when 2
		   $game_map.events[key_id].direction = 6
		 when 4 
		   $game_map.events[key_id].direction = 2
		 when 6
		   $game_map.events[key_id].direction = 8
		 when 8
		   $game_map.events[key_id].direction = 4
		 end
         elsif Input.trigger?(Input::JUMPDOWN)  || Input.scroll_v==-1#D
		 currentdir = $game_map.events[key_id].direction
		 case currentdir
		 when 2
		   $game_map.events[key_id].direction = 4
		 when 4 
		   $game_map.events[key_id].direction = 8
		 when 6
		   $game_map.events[key_id].direction = 2
		 when 8
		   $game_map.events[key_id].direction = 6
		 end

		elsif Input.trigger?(Input::TOGGLETYPE)
		  if $PokemonGlobal.ball_hud_type==:PKMN
	      $PokemonGlobal.ball_hud_pkmn_index=$PokemonGlobal.ball_hud_index
		  else 
		   if $PokemonGlobal.ball_hud_item_type==:TOOL
	      $PokemonGlobal.ball_hud_pkmn_index=$PokemonGlobal.ball_hud_item_index
		  else
	      $PokemonGlobal.ball_hud_pkmn_index=$PokemonGlobal.ball_hud_place_index
		  end
        end 
          $PokemonGlobal.ball_hud_type_toggle
		  getCurrentItemOrder
		 end
        end
      elsif $game_temp.current_pkmn_controlled!=false
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
	     if $ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon)
	      if $ball_order[$PokemonGlobal.ball_hud_index].inworld
            $game_temp.preventspawns=true
            $game_map.events[getOverworldPokemonfromPokemon($ball_order[$PokemonGlobal.ball_hud_index])].pokemonchoices
            $game_temp.preventspawns=false
	   
	   
	      end
	     end
         elsif Input.trigger?(Input::USE)
		    if $PokemonGlobal.hud_selector!=4
			  event, distance = get_target_player($game_temp.current_pkmn_controlled)
			  #event = $game_temp.current_pkmn_controlled.pbFacingEvent
			  if !event.nil? 
			  if !event.is_a? Integer
			  if event.ov_battle.nil?
			    event.ov_battle=OverworldCombat.new(event)			    
			  end
			  thefight = event.ov_battle
			  thefight.player_pokemonattack($game_temp.current_pkmn_controlled,event,pkmn.moves[$PokemonGlobal.hud_selector], distance)
			  end
			  end

			else
			  facingEvent = $game_temp.current_pkmn_controlled.pbFacingEvent
			  if !facingEvent.nil?
			 if facingEvent==$game_player
            pbMessage(_INTL("That's #{$player.name}!", ))
			 end
			 if facingEvent.trigger==0 && facingEvent.name.include?("pokeinter")
			   facingEvent.list.each do |command|
			    #puts command.code
			   end
             #$game_temp.interact_calling = true
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
      elsif $PokemonGlobal.ball_hud_enabled == true
         if true
         if Input.trigger?(Input::USE)
         $game_temp.interact_calling = true
         elsif Input.trigger?(Input::TOGGLEHUD) #X
		   $PokemonGlobal.ball_hud_enabled = false
      elsif Input.trigger?(Input::ACTION)
        unless $game_system.menu_disabled || $game_player.moving?
          $game_temp.menu_calling = true
          $game_temp.menu_beep = true
        end
         elsif Input.trigger?(Input::JUMPUP) || Input.scroll_v==1 #A
        $PokemonGlobal.ball_hud_index-=1
        $PokemonGlobal.ball_hud_index=($ball_order.length-1) if $PokemonGlobal.ball_hud_index<0
	    if defined?($ball_order[$PokemonGlobal.ball_hud_index].species)
		$player.party.each_with_index do |pkmn,index|
		next if pkmn != $ball_order[$PokemonGlobal.ball_hud_index]
		newid = 0
		oldid = index
		tmp = $player.party[oldid]
        $player.party[oldid] = $player.party[newid]
        $player.party[newid] = tmp
	    end
		end
		elsif Input.trigger?(Input::JUMPDOWN) || Input.scroll_v==-1 #D
        $PokemonGlobal.ball_hud_index+=1
        $PokemonGlobal.ball_hud_index=0 if $PokemonGlobal.ball_hud_index>=$ball_order.length
		
	    if defined?($ball_order[$PokemonGlobal.ball_hud_index].species)
		$player.party.each_with_index do |pkmn,index|
		next if pkmn != $ball_order[$PokemonGlobal.ball_hud_index]
		newid = 0
		oldid = index
		tmp = $player.party[oldid]
        $player.party[oldid] = $player.party[newid]
        $player.party[newid] = tmp
	    end
		end
       elsif Input.trigger?(Input::SEARCH)
	     if $ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon)
	      if $ball_order[$PokemonGlobal.ball_hud_index].inworld
            $game_temp.preventspawns=true
            event = $game_map.events[getOverworldPokemonfromPokemon($ball_order[$PokemonGlobal.ball_hud_index])]
            $game_temp.preventspawns=false
	        event.pokemonchoices(event)
	   
	      end
	     end

		elsif Input.trigger?(Input::TOGGLETYPE)
		  if $PokemonGlobal.ball_hud_type==:PKMN
	      $PokemonGlobal.ball_hud_pkmn_index=$PokemonGlobal.ball_hud_index
		  else 
		   if $PokemonGlobal.ball_hud_item_type==:TOOL
	      $PokemonGlobal.ball_hud_pkmn_index=$PokemonGlobal.ball_hud_item_index
		  else
	      $PokemonGlobal.ball_hud_pkmn_index=$PokemonGlobal.ball_hud_place_index
		  end
        end 
          $PokemonGlobal.ball_hud_type_toggle
		  getCurrentItemOrder
        end
       end
      else #Default Logic
      if Input.trigger?(Input::USE)
        $game_temp.interact_calling = true
      elsif Input.trigger?(Input::ACTION)
        unless $game_system.menu_disabled || $game_player.moving?
          $game_temp.menu_calling = true
          $game_temp.menu_beep = true
        end
      elsif Input.trigger?(Input::SPECIAL)
        unless $game_player.moving?
          $game_temp.ready_menu_calling = true
        end
      elsif Input.trigger?(Input::TOGGLEHUD)
	    if !pbSeenTipCard?(:HUD)
		 pbShowTipCardsGrouped(:HUDSTUFF)
		end
	    $PokemonGlobal.ball_hud_enabled = true
	   elsif Input.trigger?(Input::SEARCH)
      elsif Input.press?(Input::F9)
        $game_temp.debug_calling = true if $DEBUG
      end

    if Input.trigger?(Input::AUX2)
    end
    if Input.trigger?(Input::CYCLEFOLLOWER)
      
    end
      end

      if Input.press?(Input::AUX1)

      end

      if Input.press?(Input::NOTESMENU)
        $game_temp.notebook_calling = true if $game_system.menu_disabled==false
      end
	  
	     if $player.punch_cooldown.nil?
		  $player.punch_cooldown=0
		 end
		 if $player.punch_cooldown>0
		    $player.punch_cooldown-=1
		 end 
      if Input.trigger?(Input::PUNCH)
	     if $player.punch_cooldown<=0
			  event, distance = get_target_player($game_player)
			  #event = $game_temp.current_pkmn_controlled.pbFacingEvent
			  if !distance.nil?
			  if distance==1
			  if !event.nil? 
			  if !event.is_a? Integer
			  if event.ov_battle.nil?
			    event.ov_battle=OverworldCombat.new(event)			    
			  end
			  thefight = event.ov_battle
		      thefight.player_action(event,"Punch",$game_player.direction)
			  end
			  end
			  end
             end
		 end
      end


     if Input.mouse_in_window? && $ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon)
	  if Input.trigger?(Input::MOUSELEFT) && !Input.press?(Input::CTRL) && $ball_order[$PokemonGlobal.ball_hud_index].in_world==true
		if $game_temp.preventspawns.nil?
		  $game_temp.preventspawns=false
		end
		  $game_temp.preventspawns=true
	   event = $game_map.events[getOverworldPokemonfromPokemon($ball_order[$PokemonGlobal.ball_hud_index])]
		  $game_temp.preventspawns=false
	   if !event.nil?
	   event.movement_type = :POINTER
	  
	  
	  
	  end
	  
	  
	  
      event_id=$game_map.check_event(*get_tile_mouse_on)
      if event_id.is_a?(Integer)
	    puts "You are clicking on: #{$game_map.events[event_id].name}"
	    puts "You are clicking on: #{$game_map.events[event_id].event.pages[0].move_route.list[0].code}" if $game_map.events[event_id].name=="PlayerPkmn"
	    puts "You are clicking on: #{$game_map.events[event_id].event.pages[0].move_route.list[0].parameters}" if $game_map.events[event_id].name=="PlayerPkmn"
	  end
     end
	  end
        if $ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon) && $PokemonGlobal.ball_hud_enabled == true
		if Input.repeat?(Input::BACK) && $ball_order[$PokemonGlobal.ball_hud_index].inworld == true
		pbThrowPokemon
		$game_temp.following_ov_pokemon=false
		end
        end
 if Input.pressex?(0x65) && Input.pressex?(0x62) && Input.pressex?(0x68) && Input.pressex?(0x67) && Input.pressex?(0x69) && $DEBUG
 
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



end

def get_tile_mouse_on
   x = (((Input.mouse_x * Game_Map::X_SUBPIXELS) + $game_map.display_x)/Game_Map::REAL_RES_X).round
   y = (((Input.mouse_y * Game_Map::Y_SUBPIXELS) + $game_map.display_y)/Game_Map::REAL_RES_Y).round
   return x,y
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

EventHandlers.add(:on_frame_update, :set_shovel, proc { 
    next if !PBDayNight.isMidnight?
	 puts "The Shovel Logic fired."
	 $PokemonGlobal.collection_maps_count+=1
	next if $PokemonGlobal.collection_maps_count < 3
	 $PokemonGlobal.collection_maps_count=0
	$PokemonGlobal.collection_maps = {}
	
  }
)


def activate_item_box_item
		if $game_temp.pokemon_calling.nil?
		  $game_temp.pokemon_calling=false
		end
        $game_player.straighten
		if $game_temp.preventspawns.nil?
		  $game_temp.preventspawns=false
		end

		if $game_temp.pokemon_calling==false
        active_ball=$ball_order[$PokemonGlobal.ball_hud_index]
		
		if !active_ball.nil?
		
	    if defined?($ball_order[$PokemonGlobal.ball_hud_index].species)
		itm = nil
		else
         itm = GameData::Item.get(active_ball)
		end
		if itm.nil?
		return if $ball_order[$PokemonGlobal.ball_hud_index].egg?
		if $game_temp.pokemon_calling.nil?
		  $game_temp.pokemon_calling=false
		end
       if $game_temp.pokemon_calling==false
		$game_temp.pokemon_calling=true
		if $ball_order[$PokemonGlobal.ball_hud_index].inworld.nil?
		  $ball_order[$PokemonGlobal.ball_hud_index].inworld=false
		end
		pbThrowPokemon if $ball_order[$PokemonGlobal.ball_hud_index].inworld == false && $game_player.pbFacingTerrainTag.can_surf_freely==false
		end
		elsif itm.is_poke_ball?
		pbSEPlay("Battle throw")
        pbThrowOWBall
		else
		pbgetOWEffect
		end
		end        
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
			if event
            pbMessage(_INTL("{1}'s has found something!", pkmn.name))
            pbMessage(_INTL("There's an item around here!"))
            direction = nil
            offsetX = nil
            offsetY = nil
            offsetxold = nil
            offsetyold = nil
			 $game_temp.auto_move=true
			 loop do
			       pbMapInterpreter.update
			       $game_player.update
			       pokemon.update
			       updateMaps
			       $game_system.update
			       $game_screen.update
			     updateSpritesets
			       Graphics.update
			       Input.update
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

            break if !pbEventCanReachPlayer?(pokemon, event, maxsize) && ( offsetxold == offsetX && offsetyold == offsetY)
            offsetxold = offsetX
			 offsetyold = offsetY
            break if offsetX == 0 && offsetY == 0   # Standing on the item, spin around
            end
			if offsetX == 0 && offsetY == 0
              4.times do
                pbWait(Graphics.frame_rate * 2 / 10)
                pokemon.turn_right_90
              end
              pbWait(Graphics.frame_rate * 3 / 10)
              pbMessage(_INTL("{1} is right on top of it!", pkmn.name))
			   pbMoveRoute(pokemon, [PBMoveRoute::Wait, 60])
			   event.start
			elsif !pbEventCanReachPlayer?(pokemon, event, maxsize)
			  
              pbMessage(_INTL("{1} is close by, but can't get to it directly!", pkmn.name))
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
            pbMessage(_INTL("... \\wt[10]... \\wt[10]... \\wt[10]...\\wt[10]{1} cannot find anything.", pkmn.name))
          end







		   end
         $game_temp.preventspawns=false
	end


end