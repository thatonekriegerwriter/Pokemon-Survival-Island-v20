class ExtraEvents
attr_reader   :objects
attr_reader   :pokemon
attr_reader   :special
attr_accessor   :ovpokemon

def initialize
    @objects = {}
    @pokemon = {}
    @special = {}
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


class Game_ObjectEvent < Game_Event
  attr_accessor :event

  def initialize(type, map_id, event, map=nil)
    super(map_id, event, map)
  end
end
class Game_ObjectEvent < Game_Event
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
  attr_accessor :fighting
  attr_accessor :sending_handshake
  attr_accessor :recieving_handshake
  attr_accessor :making_an_egg
  
  alias o_initialize initialize
  def initialize(type, map_id, event, map=nil)
    o_initialize(type, map_id, event, map)
    @type  = type
    @visible                  = true
    @invisible_after_transfer = false
	@event = event
	@movement_timer = 0
	@movement_type = :WANDER
	@movement_type = :MOVEBEHINDPLAYER if alreadyfollowing==false
	@still_timer = 0
	@random_attacking = true
	if @type.is_a?(Pokemon)
	@random_attacking = @type.random_attacking if !@type.random_attacking.nil?
	end
	@attack_mode = :COMMAND
	if @type.is_a?(Pokemon)
	@attack_mode = @type.attack_mode if !@type.attack_mode.nil?
	end
	@autobattle = true
	if @type.is_a?(Pokemon)
	@autobattle = @type.autobattle if !@type.autobattle.nil?
	end
	@playercoords = [0,0]
	@fighting = nil
	@sending_handshake = []
	@recieving_handshake = []
	@making_an_egg = false
	@fucking_timer = 0
  end
  
  def type=(value)
    @type = value
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


def pkmnmovement
    event = self
    pokemon = self.pokemon
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	$game_temp.interactingwithpokemon=false if $game_temp.interactingwithpokemon.nil?
	$game_temp.auto_move=false if $game_temp.auto_move.nil?
	
	$game_temp.following_ov_pokemon = false if $game_temp.following_ov_pokemon==[@id,@type] && @movement_type != :FOLLOW 
	if $game_temp.following_ov_pokemon!=false
	if $game_temp.following_ov_pokemon[0]!=@id && $game_temp.following_ov_pokemon[1] == @type && @movement_type == :FOLLOW 
	$game_temp.following_ov_pokemon=[@id,@type,self]
	end
	end
   event.move_frequency=4 if @movement_type != :FOLLOW 
   event.move_frequency=6 if @movement_type == :FOLLOW 



 


	if !@fighting.nil?
	
	
	 if @movement_timer<=0
		  thefight = @fighting.ov_battle
		  thefight.autobattle(self) 
		  @movement_timer = 120
	      if @fighting.pokemon.fainted?
		    @fighting=nil
		  end
	 else
	   @movement_timer-=1
	
	 end


	else
	
	if true
	  






   $game_temp.preventspawns=true
  pkmn = event.pbSurroundingEvent
  if !pkmn.nil? && rand(100)<16 && @movement_type == :WANDER && @random_attacking==true
  if besidethis?(event,pkmn) && pkmn.name[/vanishingEncounter/]
       pbTurnTowardEvent(event, pkmn)
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
	  pbSingleOrDoubleWildBattle( $game_map.map_id, pkmn.x, pkmn.y, pkmn.pokemon )
	  $PokemonGlobal.battlingSpawnedPokemon = false
	  pkmn.removeThisEventfromMap
	  pbResetTempAfterBattle()
   $game_temp.preventspawns=false
      end
     elsif @autobattle==true
	   	event, distance = get_target_player(self)
		if !event.nil? 
		if !event.is_a? Integer
		if event.ov_battle.nil?
		 event.ov_battle=OverworldCombat.new(event)			    
		end
		  thefight = event.ov_battle
		  thefight.autobattle(self) 
		  @fighting = event
		  @movement_timer = 120
		end

	 end
	end
	end
  end
  $game_temp.preventspawns=false
 return if $game_temp.interactingwithpokemon==true && $game_temp.auto_move==true
  end
 

 
 
  @making_an_egg=false if @movement_type!=:MAKINGANEGG && @making_an_egg==true
 
 
 if @movement_type == :WANDER && maps.include?($game_map.map_id) && rand(100)<10 && @recieving_handshake.empty? && @sending_handshake.empty? 
    pokemonlist = pokemon_in_world
	daycare = $PokemonGlobal.day_care
	if pokemonlist.length>1
	    pokemonlist.each_with_index do |pkmn2|
		   next if pkmn2 == pokemon
          next if daycare.compatibility(pkmn2,pkmn2)==0
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
   compat = compatibility(@sending_handshake[0],@sending_handshake[3])
   egg_chance = [0, 20, 50, 70][compat]
   egg_chance = [0, 40, 80, 88][compat] if $bag.has?(:OVALCHARM)
   daycare.egg_generated = true if rand(100) < egg_chance
   else
    @fucking_timer-=1 if @fucking_timer>0
    $scene.spriteset.addUserAnimation(30,event.x,event.y)
   end 
   if daycare.egg_generated == true
        egg = EggGenerator.generate(@sending_handshake[0],@sending_handshake[3])
        raise _INTL("Couldn't generate the egg.") if egg.nil
        if !$map_factory
           event = $game_map.generateEvent(@sending_handshake[0].x+1,@sending_handshake[0].y+1,egg,false,false,2)
       else
          mapId = $game_map.map_id
          spawnMap = $map_factory.getMap(mapId)
          event = spawnMap.generateEvent(x,y,object,false,false,2)
       end
	    @movement_type = :WANDER
   end 
  
  
  when :MOVEBEHINDPLAYER
  $game_temp.preventspawns=true
  $game_temp.following_ov_pokemon=[@id,@type,self]
  self.move_toward_player
  $game_temp.preventspawns=false
	@movement_type = :FOLLOW
  when :FOLLOW
    if @playercoords!= [$game_player.x,$game_player.y]
    follow_leader($game_player) if $game_temp.current_pkmn_controlled==false
    follow_leader($game_temp.current_pkmn_controlled) if $game_temp.current_pkmn_controlled!=false
	 @playercoords = [$game_player.x,$game_player.y]
	end
  when :WANDER
     if true
    pbMoveRoute2(event, [PBMoveRoute::Random])
  if maps.include?($game_map.map_id) && rand(100)<51 
    pbMoveRoute2(event, [PBMoveRoute::TurnTowardPlayer])
    pbMoveRoute2(event, [PBMoveRoute::TowardPlayer])
  end 
    end
  when :STILL
    if true
    @still_timer-=1 if @still_timer>0
	if @still_timer==0
	@movement_type = :WANDER
	end
    end
  when :POINTER
     if true
	  $game_temp.preventspawns=true
      if move_with_maps(map_id,*get_tile_mouse_on)
	  @movement_type = :STILL
	  @still_timer=30
      end
	 $game_temp.preventspawns=false
	end
  when :FINDENEMY
    if true
     return if maps.include?($game_map.map_id)
     return if $game_temp.preventspawns==true
     $game_temp.preventspawns=true
     pkmn = getRandomOverworldOtherPokemon(event)
     if !pkmn.nil?
	 if pbMoveTowardCoordinates(self,pkmn.x,pkmn.y)
       if pkmn.name[/vanishingEncounter/] && @random_attacking==true 
	    if @attack_mode == :COMMAND && @autobattle==true && event.pbSurroundingEvent == pkmn
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
           pbSingleOrDoubleWildBattle( $game_map.map_id, pkmn.x, pkmn.y, pkmn.pokemon )
           $PokemonGlobal.battlingSpawnedPokemon = false
           pkmn.removeThisEventfromMap
           pbResetTempAfterBattle()
              $game_temp.preventspawns=false
		 elsif @autobattle==true
	     end
	   end
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
if theself.nil?
 theself=self
 end
command = 0
  loop do
    Graphics.update
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
			  if event.ov_battle.nil?
			    event.ov_battle=OverworldCombat.new(event)			    
			  end
			  thefight = event.ov_battle
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
			  if event.ov_battle.nil?
			    event.ov_battle=OverworldCombat.new(event)			    
			  end
			  thefight = event.ov_battle
			  thefight.player_pokemonattack(self,event,self.pokemon.moves[1], distance)
			  end
              else
			   break
			  end
      elsif cmdMove3 >= 0 && command == cmdMove3   # Summary
			  event, distance = get_target_player(self)
			  if !event.nil? 
			  if !event.is_a? Integer
			  if event.ov_battle.nil?
			    event.ov_battle=OverworldCombat.new(event)			    
			  end
			  thefight = event.ov_battle
			  thefight.player_pokemonattack(self,event,self.pokemon.moves[2], distance)
			  end

              else
			   break
			   end

      elsif cmdMove4 >= 0 && command == cmdMove4   # Summary
			  event, distance = get_target_player(self)
			  if !event.nil? 
			  if !event.is_a? Integer
			  if event.ov_battle.nil?
			    event.ov_battle=OverworldCombat.new(event)			    
			  end
			  thefight = event.ov_battle
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
        self.pbTriggerOverworldMon
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
      commands[cmdFights  = commands.length]      = _INTL("Starting Fights: Off") if theself.random_attacking == true
      commands[cmdFights  = commands.length]      = _INTL("Starting Fights: On")  if theself.random_attacking == false
      commands[cmdAutobattle  = commands.length]  = _INTL("Auto-Battle: Off") if theself.autobattle == true
      commands[cmdAutobattle  = commands.length]  = _INTL("Auto-Battle: On")  if theself.autobattle == false
      commands[commands.length]                   = _INTL("Cancel")
      command = pbShowCommands(nil, commands)
      if cmdFollow >= 0 && command == cmdFollow      # Send to Boxes
          @movement_type = :MOVEBEHINDPLAYER if alreadyfollowing==false
	  pbMessage("\\ts[]" + (_INTL"#{@pokemon.name} can follow if another Pokemon is following!\\wtnp[10]")) if alreadyfollowing==true
		  
		  break
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
		   $game_temp.following_ov_pokemon=false
          pbReturnPokemon(@id,true)
		  break
      elsif cmdFights >= 0 && command == cmdFights && @random_attacking == true  # Summary
         theself.random_attacking = false
		  @type.random_attacking = false
      elsif cmdFights >= 0 && command == cmdFights && @random_attacking == false  # Summary
         theself.random_attacking = true
		  @type.random_attacking = true
		 puts @random_attacking
      elsif cmdAutobattle >= 0 && command == cmdAutobattle && @autobattle == false   # Summary
         theself.autobattle = true
		  @type.autobattle = true
		 puts @autobattlew
      elsif cmdAutobattle >= 0 && command == cmdAutobattle && @autobattle == true  # Summary
         theself.autobattle = false
		  @type.autobattle = false
		 puts @autobattle
	  elsif Input.trigger?(Input::BACK)
	    break
	  else
	    break
      end
end
end



  def removeThisEventfromMap
    if $game_map.events.has_key?(@id) and $game_map.events[@id]==self
      if defined?($scene.spritesets)
        for sprite in $scene.spritesets[$game_map.map_id].character_sprites
          if sprite.character==self
            $scene.spritesets[$game_map.map_id].character_sprites.delete(sprite)
            sprite.dispose
            break
          end
        end
      end
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
            map.events.delete(@id)
            break
          end
        end
      else
        raise ArgumentError.new(_INTL("Actually, this should not be possible"))
      end
    end
  end

  def pbTriggerOverworldMon
    return if $game_system.map_interpreter.running?
	 return if $game_temp.current_pkmn_controlled==false
    # All event loops
    $game_map.events.each_value do |event|
      next if !event.name[/counter\((\d+)\)/i]
      distance = pbDetectTargetPokemon(event,$game_temp.current_pkmn_controlled)
      next if !pbEventFacesPlayer?(event, $game_temp.current_pkmn_controlled, distance)
      next if event.jumping? || event.over_trigger?
      event.start
	  return true
    end
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

def move_with_maps(mapA,x,y)
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
    if !pbMoveTowardCoordinates(self,target[1],target[2])
      fancy_moveto(target[1], target[2])
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


def alreadyfollowing
 
	if pokemon_in_world.length>0
	   pokemon_in_world.each do |pkmn|
	     event_id = getOverworldPokemonfromPokemon(pkmn)
		 if !event_id.nil?
		  if $game_map.events[event_id].movement_type==:FOLLOW
	 		  return true
		  end
		 end
	   end
	end


return false
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