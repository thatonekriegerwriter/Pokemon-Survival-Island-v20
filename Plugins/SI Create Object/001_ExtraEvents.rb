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

class Game_Character
  def passable?(x, y, d, strict = false)
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
    self.map.events.each_value do |event|
      next if self == event || !event.at_coordinate?(new_x, new_y) || event.through
	   return true if self == $game_player && event.name[/PlayerPkmn/]
      return false if self != $game_player || event.character_name != ""
    end
    if $game_player.x == new_x && $game_player.y == new_y &&
       !$game_player.through && @character_name != ""# && !
      return false
    end
    return true
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
 
 def extra_events_id
   @extra_events_id = @event.id if @extra_events_id.nil?
  return @extra_events_id
 end

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
    @pokemon   = {}
  end
  
  def update_objects_remotely
    @berry_plants = {} if @berry_plants.nil?
    @objects.each_key do |i|
	   storedevent = @objects[i]
	   next if storedevent.type==:BERRYPLANT
	   next if storedevent.map_id==$game_map.map_id
	   event = storedevent.event
	   map_id = storedevent.map_id
	   event_id = event.id
	   data = pbMapInterpreter.getVariableOther(event_id,map_id)
	   data.update if data
	end
	@berry_plants.each_key do |i|
	   storedevent = @berry_plants[i]
	   next if storedevent.map_id==$game_map.map_id && storedevent.type!=:STATUE
	   event = storedevent.event
	   map_id = storedevent.map_id
	   event_id = event.id
	   data = pbMapInterpreter.getVariableOther(event_id,map_id)
	   data.update if data
	end

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
end




class Game_PokeEventA < Game_Event
  attr_accessor :event
  attr_accessor :type
  attr_accessor :x
  attr_accessor :y
  attr_accessor :visible
  attr_accessor :invisible_after_transfer
  attr_accessor :trigger
  attr_accessor :movement_timer
  attr_accessor :movement_type
  attr_accessor :still_timer
  attr_accessor :random_attacking
  attr_accessor :attack_mode
  attr_accessor :autobattle
  attr_accessor :playercoords
  attr_accessor :steps_taken
  attr_accessor :fighting
  attr_accessor :targets
  attr_accessor :following
  attr_accessor :sending_handshake
  attr_accessor :recieving_handshake
  attr_accessor :making_an_egg
  attr_accessor :attack_opportunity
  attr_accessor :autoattack_opportunity
  attr_accessor :attack_cooldown
  attr_accessor :fucking_timer
  attr_accessor :currently_moving
  attr_accessor :last_attacked
  attr_accessor :youarealreadydead # contains the map_id
  attr_accessor :pathing 
  
  def initialize(type, map_id, event, map=nil)
   super(map_id, event, map)
   @type  = type
   @visible                  = true
   @invisible_after_transfer = false
	@event = event
	@steps_taken  = 0
	@movement_timer = 0
	@movement_type = :WANDER
	@still_timer = 0
	@random_attacking = true
	@last_attacked = false
	@attack_mode = :COMMAND
	@autobattle = false
	@playercoords = [0,0]
	@fighting = nil
	@sending_handshake = []
	@recieving_handshake = []
	@targets = {}
	@making_an_egg = false
	@fucking_timer = 0
	@attack_opportunity = 0
	@autoattack_opportunity = 0
	@currently_moving = false
	@attacking = false
	@youarealreadydead  = false
	@target = nil
	@target2 = nil
	@pathing = []
	
	if @type.is_a?(Pokemon)
	@random_attacking = @type.random_attacking if !@type.random_attacking.nil?
	@attack_mode = @type.attack_mode if !@type.attack_mode.nil?
	@autobattle = @type.autobattle if !@type.autobattle.nil?
	@type.associatedevent=@id if @type.associatedevent.nil? || @type.associatedevent!= @id
	end
	
	
	
  end

def pkmnmovement
	@pathing = [] if @pathing.nil?
    event,pokemon,maps = setup_actions
	
    $game_temp.preventspawns=true
	 @target = get_target if @target.nil?
   # $game_temp.preventspawns=false
	if @target && @target.is_a?(Game_PokeEvent)
	  @attacking = false if @attacking.nil?
	 if @autoattack_opportunity<=0
	   if @attacking==false
		  @autoattack_opportunity += 90
	     @attacking=true
		  thefight = $PokemonGlobal.ov_combat
		  distance = get_event_distance(@target,3)
		  if !distance.nil?
		  thefight.autobattle(self,@target,distance) 
		  @target = nil if @target.pokemon.fainted?
		  end
	     @attacking=false
		end
	 else
	   @autoattack_opportunity-=1
	 end

	end
    $game_temp.preventspawns=false
	  




   if false
  if !@target.nil? && rand(100)<16 && @movement_type == :WANDER && @random_attacking==true



  if besidethis?(event,@target) && @target.name[/vanishingEncounter/]
       pbTurnTowardEvent(event, @target)
	 if @attack_mode == :COMMAND
	  if true
       pbStoreTempForBattle()
    if $PokemonGlobal.roamEncounter!=nil # i.e. $PokemonGlobal.roamEncounter = [i,species,poke[1],poke[4]]
      parameter1 = $PokemonGlobal.roamEncounter[0].to_s
      parameter2 = $PokemonGlobal.roamEncounter[1].to_s
      parameter3 = $PokemonGlobal.roamEncounter[2].to_s
      $PokemonGlobal.roamEncounter[3] != nil ? (parameter4 = '"'+$PokemonGlobal.roamEncounter[3].to_s+'"') : (parameter4 = "nil")
      $PokemonGlobal.roamEncounter = ["+parameter1+",:"+parameter2+","+parameter3+","+parameter4+"]
    else
      $PokemonGlobal.roamEncounter = nil
    end
	  $PokemonGlobal.battlingSpawnedPokemon = true
	  pbSingleOrDoubleWildBattle( $game_map.map_id, @target.x, @target.y, @target.pokemon )
	  $PokemonGlobal.battlingSpawnedPokemon = false
	  @target.removeThisEventfromMap
	  pbResetTempAfterBattle()
      $game_temp.preventspawns=false
      end
     elsif @autobattle==true
	   	event, distance = get_target_player(self)
		if !event.nil? 
		if !event.is_a? Integer
		  thefight = $PokemonGlobal.ov_combat
		  thefight.autobattle(self) 
		  @fighting = event
		  @movement_timer = 120
		end

	 end
	end
	end



  end
   end



  return if $game_temp.interactingwithpokemon==true && $game_temp.auto_move==true 
 making_an_egg(event,pokemon,maps)
 live_movement(event,pokemon,maps)
 
 
 





   end

def making_an_egg(event,pokemon,maps)
  @making_an_egg=false if @movement_type!=:MAKINGANEGG && @making_an_egg==true
 
 
 if @movement_type == :WANDER && maps.include?($game_map.map_id) && rand(100)<10 && @recieving_handshake.empty? && @sending_handshake.empty? 
    pokemonlist = pokemon_in_world
	daycare = $PokemonGlobal.day_care
	if pokemonlist.length>1
	    pokemonlist.each_with_index do |pkmn2|
		   next if pkmn2 == pokemon
          next if !@recieving_handshake.empty?
		  
		  
		  
		  
          $game_temp.preventspawns=true
		  
		  
	        event_id2 = getOverworldPokemonfromPokemon(pkmn2)
			
			
		      if !event_id2.nil?
			     @sending_handshake = [self,false,$game_map.events[event_id]]
		        $game_map.events[event_id].recieving_handshake=[self,false,$game_map.events[event_id]]
			  end
			  
			  
          $game_temp.preventspawns=false
		  
		  
		  
		  
		end
   end
 end
 
 
 
 if !@recieving_handshake[0].nil?
  
 if @recieving_handshake[0].sending_handshake[1]==false && @recieving_handshake[1] == false 
      
	 @recieving_handshake[0].sending_handshake[1] = true
    @recieving_handshake[1] = true
 
 
 
 end
 if @recieving_handshake[0].sending_handshake[1]==true && @recieving_handshake[1] == true 
 
	@movement_type = :MAKINGANEGG
 end
 end
 
end
def live_movement(event,pokemon,maps)
 
 
 
 
 
 if effects[PBEffects::Confusion]>0
 
    pbMoveRoute2(event, [PBMoveRoute::Random])
	decrease_attack_opportunity(2) if @attack_opportunity>0 && rand(10)<6
 else
 case @movement_type
  when :MAKINGANEGG
	daycare = $PokemonGlobal.day_care
    if @making_an_egg==false
    event.move_type_toward_event(@sending_handshake[0]) if @sending_handshake[0]!=self
    event.move_type_toward_event(@sending_handshake[3]) if @sending_handshake[3]!=self
    @move_route_waiting = true if !$game_temp.in_battle
	@making_an_egg=true
	@fucking_timer = 260 
	end
	if @fucking_timer <= 0 
	
   compat = $PokemonGlobal.day_care.get_compatibility2(@sending_handshake[0],@sending_handshake[3])
   egg_chance = [0, 20, 50, 70][compat]
   egg_chance += 10 if $bag.has?(:OVALCHARM) && compat>0
   egg_chance += 10 if $player.is_it_this_class?(:BREEDER) && compat>0
   egg_chance += 10 if $player.is_it_this_class?(:BREEDER) && $bag.has?(:OVALCHARM) && compat>0
   egg_chance += 1 if $player.is_it_this_class?(:BREEDER) && $bag.has?(:OVALCHARM) && compat==0
   daycare.egg_generated = true if rand(100) < egg_chance
   else
    @fucking_timer-=1 if @fucking_timer>0
    $scene.spriteset.addUserAnimation(30,event.x,event.y)
   end 
   if daycare.egg_generated == true
        egg = EggGenerator.generate(@sending_handshake[0],@sending_handshake[3])
        raise _INTL("Couldn't generate the egg.") if egg.nil?
        if !$map_factory
           event = $game_map.generateEvent(@sending_handshake[0].x+1,@sending_handshake[0].y+1,egg,false,false,2)
       else
          mapId = $game_map.map_id
          spawnMap = $map_factory.getMap(mapId)
          event = spawnMap.generateEvent(@sending_handshake[0].x+1,@sending_handshake[0].y+1,egg,false,false,2)
       end
	    @movement_type = :WANDER
   end 
  
  
  when :MOVEBEHINDPLAYER
  $game_temp.preventspawns=true
  $game_temp.following_ov_pokemon[@id]=[@id,@type,self]
	if @following.nil?
	 if alreadyfollowing==false
	  if $game_temp.current_pkmn_controlled!=false
	    @following = $game_temp.current_pkmn_controlled if @following!=$game_temp.current_pkmn_controlled
	   else
	    @following = $game_player if @following!=$game_player
	  end
     elsif alreadyfollowingmon.id != @id
	  @following = alreadyfollowingmon
	 end
	 end
	decrease_attack_opportunity(1) if @attack_opportunity>0 
  self.move_toward_player(@following)
  $game_temp.preventspawns=false
	@movement_type = :FOLLOW
  when :FOLLOW
    
	decrease_attack_opportunity(1) if @attack_opportunity>0 && rand(10)<6
    if @playercoords!= [@following.x,@following.y]
	if @following.nil?
	 if alreadyfollowing==false
	  if $game_temp.current_pkmn_controlled!=false
	    @following = $game_temp.current_pkmn_controlled if @following!=$game_temp.current_pkmn_controlled
	   else
	    @following = $game_player if @following!=$game_player
	  end
     elsif alreadyfollowingmon.id != @id
	  @following = alreadyfollowingmon
	 end
	 end
         follow_leader(@following) 
		 
       look_at_location(@event.id,@following.x,@following.y)
	 @playercoords = [@following.x,@following.y]
	end
  when :WANDER
     if true
    pbMoveRoute2(event, [PBMoveRoute::Random])
	
  if maps.include?($game_map.map_id) && rand(100)<51 
    pbMoveRoute2(event, [PBMoveRoute::TurnTowardPlayer])
    pbMoveRoute2(event, [PBMoveRoute::TowardPlayer])
  end 
  
	decrease_attack_opportunity(2) if @attack_opportunity>0 && rand(10)<6
    end
  when :STILL
  
	decrease_attack_opportunity(3) if @attack_opportunity>0 && rand(10)<3
    if true
    @still_timer-=1 if @still_timer>0
	if @still_timer==0
	@movement_type = :WANDER
	end
    end
  when :POINTER
   #  if true
	#  $game_temp.preventspawns=true
  #    if move_with_maps(map_id,*get_tile_with_direction)
	#  @movement_type = :STILL
	#  @still_timer=-1
  #    end
	# $game_temp.preventspawns=false
	#end
  when :FINDENEMY
    if true
     return if maps.include?($game_map.map_id)
     $game_temp.preventspawns=true
     @target2 = getRandomOverworldOtherPokemon(event) if @target2.nil?
     if !@target2.nil?
	 if self.move_with_maps(self.map_id, @target2.x,@target2.y)
				 loops = 0
				 if [self.x, self.y]!=[@target2.x,@target2.y]
			     while !within_one_tile?(self.x, self.y, @target2.x,@target2.y)
	              Input.update
                  Graphics.update
				    $scene.miniupdate
					
				   if !self.moving?
				    loops += 1 
				   end
				  break if within_one_tile?(self.x, self.y, @target2.x,@target2.y)
				  break if loops>=60 && !self.moving?
				 end
               if within_one_tile?(self.x, self.y, @target2.x,@target2.y)
				 if @target2.is_a?(Game_PokeEvent)
                  look_at_location(self.id,nuevent.x,nuevent.y)
				      self.add_target(event_in_question,nuevent) 
                  self.following = nuevent
				     self.movement_type = :FOLLOW
				 elsif @target2.is_a?(Game_Player)
				 else
                 self.move_toward_the_coordinate(@target2.x,@target2.y) 
			     end
              end
              end
     end
	 if @attack_opportunity<=0
		  thefight = $PokemonGlobal.ov_combat
		  distance = get_event_distance(@target2,3)
		  if !distance.nil?
		  thefight.autobattle(self,@target2,distance) 
		  @attack_opportunity += 90
		  @target2 = nil if @target2.pokemon.fainted?
		  end
	 else
	   @attack_opportunity-=1
	 end


	 end
     $game_temp.preventspawns=false
      
	  @movement_type = :STILL
     @still_timer=120
    end
  when :SEARCH
     if true
    pokemonsearch(event)
	  @movement_type = :STILL
     @still_timer=120
	 end
  else
    pbMoveRoute2(event, [PBMoveRoute::Random])
  end
 end
 

 
 




end

def pokemonchoices(theself=nil)

 theself=self if theself.nil?
 $PokemonGlobal.alternate_control_mode=true
command = 0
  loop do
  Graphics.update           # Updates the screen and game visuals
  Input.update              # Checks for player input
      cmdMove  = -1
      cmdAttack   = -1
      cmdStatus   = -1
      commands = []
      commands[cmdMove  = commands.length]   = _INTL("Move")
      commands[cmdAttack  = commands.length] = _INTL("Action")
      commands[cmdStatus = commands.length]  = _INTL("Status")
      commands[commands.length]              = _INTL("Cancel")
      command = pbShowCommands(nil, commands)
      if cmdMove >= 0 && command == cmdMove      # Send to Boxes
	     directmovement(theself)
		 break
      elsif cmdAttack >= 0 && command == cmdAttack   # Summary
	     pokemonattacks(theself)
		 break
      elsif cmdStatus >= 0 && command == cmdStatus   # Summary
         pkmninteraction(self)
		 break
	  elsif Input.trigger?(Input::BACK)
	    break
	  else
	    break
      end
end

 $PokemonGlobal.alternate_control_mode=false
end

def pokemonattacks(theself)
command = 0
  loop do
    Graphics.update
      cmdMove1  = -1
      cmdMove2   = -1
      cmdMove3   = -1
      cmdMove4 = -1
      cmdChangeMoveset = -1
      cmdInteract = -1
      commands = []
      commands[cmdMove1  = commands.length] = _INTL("#{self.pokemon.moves[0].name}") if !self.pokemon.moves[0].nil?
      commands[cmdMove2  = commands.length] = _INTL("#{self.pokemon.moves[1].name}") if !self.pokemon.moves[1].nil?
      commands[cmdMove3 = commands.length] = _INTL("#{self.pokemon.moves[2].name}") if !self.pokemon.moves[2].nil?
      commands[cmdMove4 = commands.length] = _INTL("#{self.pokemon.moves[3].name}") if !self.pokemon.moves[3].nil?
      commands[cmdChangeMoveset = commands.length] = _INTL("Change Movesets") if self.pokemon.moves2.length > 0
      commands[cmdInteract = commands.length] = _INTL("Interact")
      commands[commands.length]              = _INTL("Cancel")
      command = pbShowCommands(nil, commands)
      if cmdMove1 >= 0 && command == cmdMove1      # Send to Boxes
			  event, distance = get_target_player(self)
			  if !event.nil? 
			  if !event.is_a? Integer
			  thefight = $PokemonGlobal.ov_combat
			  break if pokemon.moves[0].nil?
			  thefight.player_pokemonattack(self,event,self.pokemon.moves[0], distance)
			  end
              else
			   break
			  end
      elsif cmdMove2 >= 0 && command == cmdMove2   # Summary
          #if pbConfirmMessage(_INTL("Do you want to take a nap?"))
			  event, distance = get_target_player(self)
			  if !event.nil? 
			  if !event.is_a? Integer
			  thefight = $PokemonGlobal.ov_combat
			  break if pokemon.moves[1].nil?
			  thefight.player_pokemonattack(self,event,self.pokemon.moves[1], distance)
			  end
              else
			   break
			  end
      elsif cmdMove3 >= 0 && command == cmdMove3   # Summary
			  event, distance = get_target_player(self)
			  if !event.nil? 
			  if !event.is_a? Integer
		      thefight = $PokemonGlobal.ov_combat
			  break if pokemon.moves[2].nil?
			  thefight.player_pokemonattack(self,event,self.pokemon.moves[2], distance)
			  end

              else
			   break
			   end

      elsif cmdMove4 >= 0 && command == cmdMove4   # Summary
			  event, distance = get_target_player(self)
			  if !event.nil? 
			  if !event.is_a? Integer
		      thefight = $PokemonGlobal.ov_combat
			  break if pokemon.moves[3].nil?
			  thefight.player_pokemonattack(self,event,self.pokemon.moves[3], distance)
			  end
              else
			   break
			  end
      elsif cmdChangeMoveset >= 0 && command == cmdChangeMoveset   # Summary
	    self.pokemon.storedmoveset = self.pokemon.moves.clone
		self.pokemon.moves = self.pokemon.moves2.clone
		self.pokemon.moves2 = self.pokemon.storedmoveset
		self.pokemon.storedmoveset = []
      elsif cmdInteract >= 0 && command == cmdInteract   # Summary
        self.pbTriggerOverworldMon(self)
		 break
	  elsif Input.trigger?(Input::BACK)
	    break
	  else
	    break
      end
end
end


def directmovement(theself)
command = 0
  loop do
      cmdFollow  = -1
      cmdWait   = -1
      cmdWander   = -1
      cmdFind = -1
      cmdSearch = -1
      cmdRecall = -1
      cmdFights = -1
      commands = []
      commands[cmdFollow = commands.length]       = _INTL("Follow")
      commands[cmdWait = commands.length]         = _INTL("Wait")
      commands[cmdWander = commands.length]       = _INTL("Wander")
      commands[cmdFind  = commands.length]        = _INTL("Find Pokemon")
      commands[cmdSearch = commands.length]       = _INTL("Search for Item")
      commands[cmdRecall = commands.length]       = _INTL("Recall")
      commands[commands.length]                   = _INTL("Cancel")
      command = pbShowCommands(nil, commands)
      if cmdFollow >= 0 && command == cmdFollow      # Send to Boxes
          @movement_type = :MOVEBEHINDPLAYER 
      elsif cmdWait >= 0 && command == cmdWait   # Summary
          @movement_type = :STILL
          @still_timer=-1
		  break
      elsif cmdWander >= 0 && command == cmdWander   # Summary
          @movement_type = :WANDER
		  break
      elsif cmdFind >= 0 && command == cmdFind   # SummarypbReturnPokemon
          @movement_type = :FINDENEMY
		  break
      elsif cmdSearch >= 0 && command == cmdSearch   # Summary
          @movement_type = :SEARCH
		  break
      elsif cmdRecall >= 0 && command == cmdRecall   # Summary
	      self.pokemon.inworld=false
          pbReturnPokemon(@id,true)
		  break
	  elsif Input.trigger?(Input::BACK)
	    break
	  else
	    break
      end
end
end


def setup_actions
    event = self
    pokemon = self.pokemon
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
    @autoattack_opportunity = @attack_opportunity if @autoattack_opportunity.nil?
	 removeThisEventfromMap if pokemon.fainted?
	 pokemon.associatedevent=@id if pokemon.associatedevent.nil? || pokemon.associatedevent!= @id
	
	
	
	
	pbRemoveFollowerPokemon(@id) if $game_temp.following_ov_pokemon[@id] && $game_temp.following_ov_pokemon[@id][1]==@type && @movement_type != :FOLLOW 
	$game_temp.following_ov_pokemon[@id]=[@id,@type,self] if !$game_temp.following_ov_pokemon[@id] && @movement_type == :FOLLOW 
   event.following = nil if @movement_type != :FOLLOW && @movement_type != :MOVEBEHINDPLAYER
   
   if !event.following.nil? && @movement_type == :FOLLOW 
   event.move_frequency=following.move_frequency
   event.move_speed=event.following.move_speed+0.25 
   elsif @movement_type != :FOLLOW 
   event.move_speed=3 
   event.move_frequency=4
   end
   
   
   
   


 return event,pokemon,maps
end
		   # pbGetTargetDistance(self).each do |target|
			#   value = target[0]
			# end
#pbGetTargetDistance(self,3)
#rate = $PokemonGlobal.ov_combat.getRate2(self,value)
#active << 
  def get_event_distance(event,amt=3)
    distance = (self.x - event.x).abs + (self.y - event.y).abs
    return distance if distance<=amt
	return nil
  end

	     #         Input.update
       #           Graphics.update
		#		    $scene.miniupdate
def get_target
     surrounding = self.pbSurroundingEvents
	    active = []
	   if !surrounding.nil?
	    surrounding.each do |i|
         if @targets.keys.include?(i)
		     theevent = $game_map.events[i]
            if get_events_in_range(self,theevent,3)
			    rate = $PokemonGlobal.ov_combat.getRate2(self,theevent)
				 active << [theevent,rate]
			   end
		   end
	    end
       rate2= active.max_by { |item| item[1] }
	     if !rate2.nil?
       highest_rate = rate2[1]
       highest_rate_items = active.select { |item| item[1] == highest_rate }
        ret = highest_rate_items[rand(highest_rate_items.length)][0]
	     end
	   end
   # ret = self.pbSurroundingEvent if ret.nil?
  return ret 
end



  def removeThisEventfromMap
    @type.associatedevent=nil
	if @type.inworld && @type.fainted?
	  sideDisplay(_INTL("{1} has fainted!",  @type.name))
	  @type.changeHappiness("faintbad",@type)
      @type.changeLoyalty("faintbad",@type)
	  pbSEPlay("faint")
	  
	end
	 pbOverworldCombat.removeAlly(@id)
	  $selection_arrows.remove_sprite("Arrow#{@id}#{@type.name}")
	  $hud.removeaChargeBar(@id)
    @type.inworld=false
	pbDeselectThisPokemon(@type)
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
		$ExtraEvents.removethisEvent(:SPECIAL,@id,$game_map.map_id)
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
	  	     $ExtraEvents.removethisEvent(:SPECIAL,@id,map.map_id)
            map.events.delete(@id)
            break
          end
        end
      else
        raise ArgumentError.new(_INTL("Actually, this should not be possible"))
      end
    end
  end


  alias original_increase_steps64 increase_steps
  def increase_steps
   if self.is_a?(Game_PokeEventA) || self.is_a?(Game_PokeEvent)
    
    @steps_taken  += 1
	
  end
  end



  
  def type=(value)
    @type = value
  end
  
  def last_attacked
   @last_attacked = false if @last_attacked.nil?
   return @last_attacked
  end 
  
   def attack_cooldowns
     return [@attack_opportunity]
   end


  def add_target(event_id,object)
    return if event_id.nil?
    return if object.nil?
    if @targets[event_id]
	  if @targets[event_id]!=object
	    @targets[event_id]=object
	  end
    else
	    @targets[event_id]=object
	 end
  end
  def remove_target(event_id)
    return if event_id.nil?
    return if object.nil?
    if @targets[event_id]
	  @targets[event_id].delete
	 end
  end
  
  def pokemon
   return @type if @type.is_a?(Pokemon)
   return nil
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
  # self.map_id bzw. @map_id
  
   def stages
    return @type.stages
   end
   def effects
    return @type.effects
   end
  
  def decrease_attack_opportunity(amt)
  
    @attack_opportunity-=amt if @attack_opportunity>0
	if @attack_opportunity<=0
    @attack_opportunity=0 
	pbSEPlay("Vs flash")
	sideDisplay("#{@type.name} can attack again.")
	end
  
  end













  def pbTriggerOverworldMon(user=$game_temp.current_pkmn_controlled)
    return if $game_system.map_interpreter.running?
    # All event loops
      event = user.pbFacingEvent
	  return false if event.nil?
      return false if !event.name.include?(".inter")
      return false if event.jumping?
	  $game_temp.pokemon_interacting=true
      event.start
	  return true
   return false
  end

  def visible?
    return @visible && !@invisible_after_transfer
  end


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

  def fancy_moveto(new_x, new_y, leader=nil)
    if self.x - new_x == 1 && self.y == new_y
      move_fancy(4)
    elsif self.x - new_x == -1 && self.y == new_y
      move_fancy(6)
    elsif self.x == new_x && self.y - new_y == 1
      move_fancy(8)
    elsif self.x == new_x && self.y - new_y == -1
      move_fancy(2)
    elsif self.x - new_x == 2 && self.y == new_y && !leader.nil?
      jump_fancy(4, leader)
    elsif self.x - new_x == -2 && self.y == new_y && !leader.nil?
      jump_fancy(6, leader)
    elsif self.x == new_x && self.y - new_y == 2 && !leader.nil?
      jump_fancy(8, leader)
    elsif self.x == new_x && self.y - new_y == -2 && !leader.nil?
      jump_fancy(2, leader)
    elsif self.x != new_x || self.y != new_y
      moveto(new_x, new_y)
    end
  end

  #=============================================================================



  def turn_towards_event(event)
    pbTurnTowardEvent(self, event)
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
	   puts "periwsh"
      moveto(target[1], target[2])
    else
	   puts "periwsh2"
      fancy_moveto(target[1], target[2], leader)
    end
  end

def move_with_maps(mapA,x,y,dir=nil)
    if self.x!=x || self.y!=y
      target = [mapA, x, y]
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
    if move_to_location(self,target[1], target[2])
	end
   # if !pbMoveTowardCoordinates(self,target[1],target[2])
	#  fancy_moveto(target[1], target[2])
	#end
	else
	if !dir.nil?
	 if dir!=self.direction
	   turn_generic(dir)
	 end
	end
    end
	return true
end


  def update_move
    was_jumping = jumping?
    super
    if was_jumping && !jumping?
      spriteset = $scene.spriteset(map_id)
      spriteset&.addUserAnimation(Settings::DUST_ANIMATION_ID, self.x, self.y, true, 1)
    end
  end






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

class Game_ObjectEvent < Game_PokeEventA
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