def pbShowCommands(msgwindow,commands=nil,cmdIfCancel=0,defaultCmd=0)
  return 0 if !commands
  cmdwindow=Window_CommandPokemonEx.new(commands)
  cmdwindow.z=99999
  cmdwindow.visible=true
  cmdwindow.resizeToFit(cmdwindow.commands)
  pbPositionNearMsgWindow(cmdwindow,msgwindow,:right)
  cmdwindow.index=defaultCmd
  command=0
  if !$PokemonGlobal.nil?
  loop do
    Graphics.update
    Input.update
    cmdwindow.update
    msgwindow.update if msgwindow
	 $PokemonGlobal.addNewFrameCount
	 $scene.mouse_detection if $PokemonGlobal.alternate_control_mode==true
    yield if block_given?
    if Input.trigger?(Input::B)
      if cmdIfCancel>0
        command=cmdIfCancel-1
        break
      elsif cmdIfCancel<0
        command=cmdIfCancel
        break
      end
    end
    if Input.trigger?(Input::C) 
	  if (Input.trigger?(Input::MOUSELEFT) && $mouse.current_mode!=:DEFAULT )
	  else
      command=cmdwindow.index
      break
	  end
    end
    pbUpdateSceneMap
  end
  else
    loop do
    Graphics.update
    Input.update
    cmdwindow.update
    msgwindow.update if msgwindow
    yield if block_given?
    if Input.trigger?(Input::B)
      if cmdIfCancel>0
        command=cmdIfCancel-1
        break
      elsif cmdIfCancel<0
        command=cmdIfCancel
        break
      end
    end
    if Input.trigger?(Input::C)
      command=cmdwindow.index
      break
    end
    pbUpdateSceneMap
  end
  end
  ret=command
  cmdwindow.dispose
  Input.update
  return ret
end

def pbShowCommandsWithHelp(msgwindow,commands,help,cmdIfCancel=0,defaultCmd=0)
  msgwin=msgwindow
  msgwin=pbCreateMessageWindow(nil) if !msgwindow
  oldlbl=msgwin.letterbyletter
  msgwin.letterbyletter=false
  if commands
   
    cmdwindow=Window_CommandPokemonEx.new(commands)
    cmdwindow.z=99999
    cmdwindow.visible=true
    cmdwindow.resizeToFit(cmdwindow.commands)
    cmdwindow.height=msgwin.y if cmdwindow.height>msgwin.y
    cmdwindow.index=defaultCmd
    command=0
    msgwin.text=help[cmdwindow.index]
    msgwin.width=msgwin.width   # Necessary evil to make it use the proper margins
  if !$PokemonGlobal.nil?
    loop do
      Graphics.update
      Input.update
      oldindex=cmdwindow.index
      cmdwindow.update
	   $PokemonGlobal.addNewFrameCount
	   $scene.mouse_detection if $PokemonGlobal.alternate_control_mode==true
      if oldindex!=cmdwindow.index
        msgwin.text=help[cmdwindow.index]
      end
      msgwin.update
      yield if block_given?
      if Input.trigger?(Input::B)
        if cmdIfCancel>0
          command=cmdIfCancel-1
          break
        elsif cmdIfCancel<0
          command=cmdIfCancel
          break
        end
      end
      if Input.trigger?(Input::C) 
	  
	  if (Input.trigger?(Input::MOUSELEFT) && $mouse.current_mode!=:DEFAULT )
	  else
      command=cmdwindow.index
      break
	  end
      end
      pbUpdateSceneMap
    end
  else
    loop do
    Graphics.update
    Input.update
    cmdwindow.update
    msgwindow.update if msgwindow
    yield if block_given?
    if Input.trigger?(Input::B)
      if cmdIfCancel>0
        command=cmdIfCancel-1
        break
      elsif cmdIfCancel<0
        command=cmdIfCancel
        break
      end
    end
    if Input.trigger?(Input::C)
      command=cmdwindow.index
      break
    end
    pbUpdateSceneMap
  end

  
  end
    ret=command
    cmdwindow.dispose
    Input.update
  end
  msgwin.letterbyletter=oldlbl
  msgwin.dispose if !msgwindow
  return ret
end

class Game_Temp
  attr_accessor :just_update_anyways

  def just_update_anyways
    @just_update_anyways = false if !@just_update_anyways
    return @just_update_anyways
  end
end


def pbShowCommandsssss(statuewindow,statue,msgwindow,commands=nil,cmdIfCancel=0,defaultCmd=0)
  return 0 if !commands
  cmdwindow=Window_CommandPokemonEx.new(commands)
  cmdwindow.z=99999
  cmdwindow.visible=true
  cmdwindow.resizeToFit(cmdwindow.commands)
  pbPositionNearMsgWindow(cmdwindow,msgwindow,:right)
  cmdwindow.index=defaultCmd
  command=0
   $game_temp.just_update_anyways=true
  if !$PokemonGlobal.nil?
  loop do
    Graphics.update
    Input.update
    cmdwindow.update
	 if statue==$scene
	 else
    statue.update if statue
	 end
	 if statuewindow==$scene
	 else
    statuewindow.update if statuewindow
	 end
    msgwindow.update if msgwindow
	$PokemonGlobal.addNewFrameCount
	 $scene.mouse_detection if $PokemonGlobal.alternate_control_mode==true
    yield if block_given?
    if Input.trigger?(Input::B)
      if cmdIfCancel>0
        command=cmdIfCancel-1
        break
      elsif cmdIfCancel<0
        command=cmdIfCancel
        break
      end
    end
    if Input.trigger?(Input::C) 
	  if (Input.trigger?(Input::MOUSELEFT) && $mouse.current_mode!=:DEFAULT )
	  else
      command=cmdwindow.index
      break
	  end
    end
    pbUpdateSceneMap
  end
  else
    loop do
    Graphics.update
    Input.update
    cmdwindow.update
    msgwindow.update if msgwindow
    yield if block_given?
    if Input.trigger?(Input::B)
      if cmdIfCancel>0
        command=cmdIfCancel-1
        break
      elsif cmdIfCancel<0
        command=cmdIfCancel
        break
      end
    end
    if Input.trigger?(Input::C)
      command=cmdwindow.index
      break
    end
    pbUpdateSceneMap
  end
  end
 
   $game_temp.just_update_anyways=false 
 ret=command
  cmdwindow.dispose
  Input.update
  return ret
end


class SpriteWindow_Selectable < SpriteWindow_Base


def update
    super
    if self.active && @item_max > 0 && @index >= 0 && !@ignore_input
	   if !$PokemonGlobal.nil?
      if ((Input.repeat?(Input::UP) || Input.scroll_v==1) && $PokemonGlobal.alternate_control_mode==false) || ((Input.repeat?(Input::JUMPUP) || Input.scroll_v==1) && $PokemonGlobal.alternate_control_mode==true)
        if @index >= @column_max ||
           (Input.trigger?(Input::UP) && (@item_max % @column_max) == 0)
          oldindex = @index
          @index = (@index - @column_max + @item_max) % @item_max
          if @index != oldindex
            pbPlayCursorSE
            update_cursor_rect
          end
        end
      elsif ((Input.repeat?(Input::DOWN) || Input.scroll_v==-1) && $PokemonGlobal.alternate_control_mode==false) || ((Input.repeat?(Input::JUMPDOWN) || Input.scroll_v==-1) && $PokemonGlobal.alternate_control_mode==true)
        if @index < @item_max - @column_max ||
           (Input.trigger?(Input::DOWN) && (@item_max % @column_max) == 0)
          oldindex = @index
          @index = (@index + @column_max) % @item_max
          if @index != oldindex
            pbPlayCursorSE
            update_cursor_rect
          end
        end
      elsif (Input.repeat?(Input::LEFT) && $PokemonGlobal.alternate_control_mode==false) || (Input.repeat?(0x25) && $PokemonGlobal.alternate_control_mode==true)
        if @column_max >= 2 && @index > 0
          oldindex = @index
          @index -= 1
          if @index != oldindex
            pbPlayCursorSE
            update_cursor_rect
          end
        end
      elsif (Input.repeat?(Input::RIGHT) && $PokemonGlobal.alternate_control_mode==false) || (Input.repeat?(0x27) && $PokemonGlobal.alternate_control_mode==true)
        if @column_max >= 2 && @index < @item_max - 1
          oldindex = @index
          @index += 1
          if @index != oldindex
            pbPlayCursorSE
            update_cursor_rect
          end
        end
      elsif ((Input.repeat?(Input::JUMPUP)) && $PokemonGlobal.alternate_control_mode==false) || ($PokemonGlobal.alternate_control_mode==true && Input.repeat?(0x68))
        if @index > 0
          oldindex = @index
          @index = [self.index - self.page_item_max, 0].max
          if @index != oldindex
            pbPlayCursorSE
            self.top_row -= self.page_row_max
            update_cursor_rect
          end
        end
      elsif (Input.trigger?(Input::CYCLEMOUSETYPE))
        $mouse.change_mode
      elsif ((Input.repeat?(Input::JUMPDOWN)) && $PokemonGlobal.alternate_control_mode==false) || ($PokemonGlobal.alternate_control_mode==true && Input.repeat?(0x62))
        if @index < @item_max - 1
          oldindex = @index
          @index = [self.index + self.page_item_max, @item_max - 1].min
          if @index != oldindex
            pbPlayCursorSE
            self.top_row += self.page_row_max
            update_cursor_rect
          end
        end
      end
	   else
      if Input.repeat?(Input::UP)
        if @index >= @column_max ||
           (Input.trigger?(Input::UP) && (@item_max % @column_max) == 0)
          oldindex = @index
          @index = (@index - @column_max + @item_max) % @item_max
          if @index != oldindex
            pbPlayCursorSE
            update_cursor_rect
          end
        end
      elsif Input.repeat?(Input::DOWN)
        if @index < @item_max - @column_max ||
           (Input.trigger?(Input::DOWN) && (@item_max % @column_max) == 0)
          oldindex = @index
          @index = (@index + @column_max) % @item_max
          if @index != oldindex
            pbPlayCursorSE
            update_cursor_rect
          end
        end
      elsif Input.repeat?(Input::LEFT)
        if @column_max >= 2 && @index > 0
          oldindex = @index
          @index -= 1
          if @index != oldindex
            pbPlayCursorSE
            update_cursor_rect
          end
        end
      elsif Input.repeat?(Input::RIGHT)
        if @column_max >= 2 && @index < @item_max - 1
          oldindex = @index
          @index += 1
          if @index != oldindex
            pbPlayCursorSE
            update_cursor_rect
          end
        end
      elsif Input.repeat?(Input::JUMPUP)
        if @index > 0
          oldindex = @index
          @index = [self.index - self.page_item_max, 0].max
          if @index != oldindex
            pbPlayCursorSE
            self.top_row -= self.page_row_max
            update_cursor_rect
          end
        end
      elsif Input.repeat?(Input::JUMPDOWN)
        if @index < @item_max - 1
          oldindex = @index
          @index = [self.index + self.page_item_max, @item_max - 1].min
          if @index != oldindex
            pbPlayCursorSE
            self.top_row += self.page_row_max
            update_cursor_rect
          end
        end
      end	  
	  end
    end
end





end


class PokemonGlobalMetadata
  attr_writer :alternate_control_mode #$PokemonGlobal.hardcore = true

  def alternate_control_mode
    @alternate_control_mode = false if !@alternate_control_mode
    return @alternate_control_mode
  end
end

class Game_Event < Game_Character
attr_accessor   :extra_events_id
  attr_accessor :map
 
 def extra_events_id
   @extra_events_id = @event.id if @extra_events_id.nil?
  return @extra_events_id
 end
 
 #def map_id
 #  @map ? (@map.map_id) : $game_map.map_id
 #end 
 
 #def map
     #return @map if @map && $map_factory.maps[self.map_id].equal?(@map)
     #nu_map = $map_factory.maps[self.map_id]
	 #return nu_map if nu_map
	# return $map_factory.getMap(self.map_id)
 #end 
 
 
end


class ExtraEvents
attr_accessor   :objects
attr_accessor   :pokemon
attr_accessor   :special
attr_accessor   :misc
attr_accessor   :berry_plants

def initialize
    @objects   = {}
    @pokemon   = {}
    @special   = {}
    @misc = {}
    @berry_plants = {}
end
  def berry_plants
    @berry_plants = {} if @berry_plants.nil?
	return @berry_plants
  end 
  def clearOverworldPokemonMemory
	$DynamicEvents.hostile_mobs = {}
  end
  
  def update_objects_remotely

  end
  

  def update_map_id(event_id)
  
  
  end 
  
  def addMovedEvent(type,key_id,x=nil,y=nil,direction=nil) 
   #THIS IS PASSING KEY ID YOU NEED TO PASS EVENT.
     case type
      when :OBJECT
	   $ExtraEvents.objects[key_id].event.x=$game_map.events[key_id].x = x if !x.nil?
 	   $ExtraEvents.objects[key_id].event.y=$game_map.events[key_id].y = y if !y.nil?
	   $ExtraEvents.objects[key_id].event.y=$game_map.events[key_id].direction = direction if !direction.nil?
      when :POKEMON
	   $ExtraEvents.pokemon[key_id].event.x=$game_map.events[key_id].x if !x.nil?
	   $ExtraEvents.pokemon[key_id].event.y=$game_map.events[key_id].y if !y.nil?
	   $ExtraEvents.pokemon[key_id].event.y=$game_map.events[key_id].direction = direction if !direction.nil?
      when :SPECIAL
	   $ExtraEvents.special[key_id].event.x=$game_map.events[key_id].x if !x.nil?
	   $ExtraEvents.special[key_id].event.y=$game_map.events[key_id].y if !y.nil?
	   $ExtraEvents.special[key_id].event.y=$game_map.events[key_id].direction = direction if !direction.nil?
      when :MISC
	   $ExtraEvents.misc[key_id].event.x=$game_map.events[key_id].x
	   $ExtraEvents.misc[key_id].event.y=$game_map.events[key_id].y i if !x.nil?f !y.nil?
	   $ExtraEvents.misc[key_id].event.y=$game_map.events[key_id].direction = direction if !direction.nil?
  
     end
  end

  def removethisEvent(type,key_id,map_id)
     case type
      when :OBJECT
	   $ExtraEvents.objects.delete([map_id,key_id]) if $ExtraEvents.objects.has_key?([map_id,key_id])
      when :POKEMON
	   $ExtraEvents.pokemon.delete([map_id,key_id]) if $ExtraEvents.pokemon.has_key?([map_id,key_id])
      when :SPECIAL
	   $ExtraEvents.special.delete([map_id,key_id]) if $ExtraEvents.special.has_key?([map_id,key_id])
      when :MISC
	   $ExtraEvents.misc.delete([map_id,key_id]) if $ExtraEvents.misc.has_key?([map_id,key_id])
     end
  end

end
MenuHandlers.add(:debug_menu, :clear_stored_data, {
  "name"        => _INTL("Clear extra events data!"),
  "parent"      => :field_menu,
  "description" => _INTL("Kill the player."),
  "effect"      => proc {
	   $ExtraEvents.objects = {}
	   $ExtraEvents.pokemon = {}
	   $ExtraEvents.special = {}
	   $ExtraEvents.misc = {}
  }
})

class StoredEvent
  attr_accessor :map_id
  attr_accessor :event
  attr_accessor :type
  attr_accessor :x
  attr_accessor :y
  attr_accessor :eventdata
  
  def initialize(map_id,event,type)
   @event    = event
   @map_id   = map_id
   @type     = type
   @x = x
   @y = y
   @eventdata = nil
  end
  
  def pokemon
   return @type
  end
  
end


SaveData.register(:overworld_events) do
  ensure_class :ExtraEvents 
  save_value { $ExtraEvents  }
  load_value { |value| $ExtraEvents = value }
  new_game_value {
    ExtraEvents.new
  }
  reset_on_new_game
end




class Game_Temp
  attr_accessor :pokemon_interacting

  def pokemon_interacting
    @pokemon_interacting = false if @pokemon_interacting.nil?
    return @pokemon_interacting
  end

end



def alreadyfollowing
    $player.party.each do |pkmn|
	  next if pkmn.inworld==false
	  next if pkmn.associatedevent.nil?
	     event_id = pkmn.associatedevent
		 next if event_id.nil?
		 next if $game_map.events[event_id]
	      next if $game_map.events[event_id].following != $game_temp.current_pkmn_controlled && $game_map.events[event_id].following != $game_player
	   if $game_map.events[event_id].movement_type==:FOLLOW
	 		  return true
		end
	end

return false
end

def get_pokemon_that_are_in_world
    count = 0
    $player.party.each do |pkmn|
	  next if pkmn.inworld==false
	  next if pkmn.associatedevent.nil?
	     count+=1
	end

return count
end


def alreadyfollowingmon
    whoisbeingfollowedalready = []
    $player.party.each do |pkmn|
	  next if pkmn.inworld==false
	  next if pkmn.associatedevent.nil?
	     event_id = pkmn.associatedevent
		 next if event_id.nil?
		 whoisbeingfollowedalready << $game_map.events[event_id].following if !$game_map.events[event_id].following.nil?
		 next if whoisbeingfollowedalready.include?( $game_map.events[event_id])
	   if $game_map.events[event_id].movement_type==:FOLLOW
	 		  return $game_map.events[event_id]
		end
	end


return nil
end


class OVPokemonFactory
  attr_reader :last_update
  attr_accessor :events

  def initialize
    @events      = []
    pokemon_in_world.each do |follower|
     $game_temp.preventspawns=true
	  if getOverworldPokemonfromPokemon(follower).nil?
	   follower.inworld=false
	    next 
	  else
	   id = getOverworldPokemonfromPokemon(follower)
	  end 
	  
     $game_temp.preventspawns=false
      @events.push($game_map.events[id])
    end
    @last_update = -1
  end
  def events 
   return @events
  end
  def add_follower(event, name = nil, common_event_id = nil)
    return if !event
    @events.push(event)
    @last_update += 1
  end

  def remove_follower_by_event(event)
    return if !event
	  event.removeThisEventfromMap
      index = @events.index(event)
      @events.delete_at(index) if index
      @last_update += 1
  end

  def delete_all_followers
  $game_temp.preventspawns=true
    pokemon_in_world.each do |follower|
	  if getOverworldPokemonfromPokemon(follower).nil?
	   follower.inworld=false
	   next
	  else 
	     id = getOverworldPokemonfromPokemon(follower)
		 theevent = $game_map.events[id]
		 theevent.removeThisEventfromMap
	  end 
	  
	end
    @events.clear
    @last_update += 1
	
  $game_temp.preventspawns=false
  end

  def turn_followers
    leader = $game_player
    pokemon_in_world.each_with_index do |follower, i|
      event = @events[i]
      event.turn_towards_leader(leader)
      leader = event
    end
  end

  def move_followers
    leader = $game_player
    pokemon_in_world.each_with_index do |follower, i|
      event = @events[i]
	  next if event.movement_type != :FOLLOW
      event.follow_leader(leader, false, (i == 0))
      leader = event
    end
  end

  def map_transfer_followers

  end

  def follow_into_door
    # Setting an event's move route also makes it start along that move route,
    # so we need to record all followers' current positions first before setting
    # any move routes
    follower_pos = []
    follower_pos.push([$game_player.map.map_id, $game_player.x, $game_player.y])
    pokemon_in_world.each_with_index do |follower, i|
      event = @events[i]
      follower_pos.push([event.map.map_id, event.x, event.y])
    end
    # Calculate and set move route from each follower to player
    move_route = []
    pokemon_in_world.each_with_index do |follower, i|
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
  def hide
    pokemon_in_world.each_with_index do |follower, i|
      event = @events[i]
      event.opacity = 0
    end
  end

  # Used when coming out of a door. Makes all followers invisible until the
  # player starts moving.
  def put_followers_on_player
    pokemon_in_world.each_with_index do |follower, i|
      event = @events[i]
      event.moveto($game_player.x, $game_player.y)
      event.opacity = 255
      event.invisible_after_transfer = true
    end
  end



  def update
    followers = pokemon_in_world
    return if followers.length == 0
    # Update all followers
    leader = $game_player
    player_moving = $game_player.moving? || $game_player.jumping?
    followers.each_with_index do |follower, i|
      event = @events[i]
      next if !@events[i]
      if event.invisible_after_transfer && player_moving
        event.invisible_after_transfer = false
        event.turn_towards_leader($game_player)
      end
      event.move_speed  = leader.move_speed
      event.transparent = !event.visible?
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
      leader = event
    end

  end




end