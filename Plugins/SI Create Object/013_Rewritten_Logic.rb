class Game_OVEvent < Game_Event
  attr_accessor :event
  attr_accessor :type
  attr_accessor :moveable
  attr_accessor :attackable
  attr_accessor :x
  attr_accessor :y

  def initialize(type, map_id, event, map=nil)
    super(map_id, event, map)
    @type  = type
	@event = event
	@moveable = false
	@attackable = false
  end
  def pokemon
   return @type if @type.is_a?(ItemData)
   return ItemData.new(@type) if !@type.is_a?(ItemData)
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
		$ExtraEvents.removethisEvent(:OBJECT,@id,$game_map.map_id)
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
	  	     $ExtraEvents.removethisEvent(:OBJECT,@id,map.map_id)
            map.events.delete(@id)
            break
          end
        end
      else
        raise ArgumentError.new(_INTL("Actually, this should not be possible"))
      end
    end
  end
  
  
  def update
   super
   if type != :BERRYPLANT
    data = self.variable
    if data
	  data.update
	end
   end
  end
end


 def get_surrounding_terrain(x,y)
 directions = [
  [-1,  0],  # West
  [ 1,  0],  # East
  [ 0, -1],  # North
  [ 0,  1],  # South
  [-1, -1],  # North-West
  [ 1, -1],  # North-East
  [-1,  1],  # South-West
  [ 1,  1],  # South-East
]
terrain_tags_with_coords = directions.map do |dx, dy|
  sx, sy = x + dx, y + dy
  if $game_map.valid?(sx, sy)
    terrain_tag = $game_map.terrain_tag(sx, sy, true)
    [[sx, sy], terrain_tag]
  else
    nil
  end
end.compact
 return terrain_tags_with_coords
 end

 def any_acceptable_water_tiles_for_hoe(x,y)
  terrains = get_surrounding_terrain(x,y)
   terrains.each do |terrain|
      return true if terrain[1].id == :DeepWater || terrain[1].id == :StillWater || terrain[1].id == :Water
   
   
   end 
 
 
   return false
 end


def pbPlaceBerryPlant(x,y)
  if pbObjectIsPossible(x,y)
  if !$map_factory
    event = $game_map.generateBerryPlant(x,y)
  else
    mapId = $game_map.map_id
    spawnMap = $map_factory.getMap(mapId)
    event = spawnMap.generateBerryPlant(x,y)
  end
  return event
  else
  pbMessage(_INTL("You can't farm there!"))
  return nil
  end 
end


class Game_Map


    alias original_setup setup
  def setup(map_id)
    original_setup(map_id)
	if false
    $ExtraEvents.objects.each_key do |i|
	    if $ExtraEvents.objects[i].is_a?(Array)
		  $ExtraEvents.objects[map_id,i] = StoredEvent.new($ExtraEvents.objects[i][0],$ExtraEvents.objects[i][1],$ExtraEvents.objects[i][3])
		
		end
	    mapId = $ExtraEvents.objects[i].map_id
		 next if mapId != @map_id
		key_id = (@events.keys.max || -1) + 1
	    event = $ExtraEvents.objects[i].event
	    type = $ExtraEvents.objects[i].type
		 loop do
		 if !@events[key_id]
		event.id = key_id
      @events[key_id]          = Game_OVEvent.new(type, @map_id, event, self) 
	    break
	    else
		  key_id+=1
		end
	    end
    end
	tempspawnspokemon = []
    $ExtraEvents.pokemon.each_key do |i|
	    mapId = $ExtraEvents.pokemon[i].map_id
		 next if mapId != @map_id
	   result = rand(3)==0 
	     if result
		key_id = (@events.keys.max || -1) + 1
	    event = $ExtraEvents.pokemon[i].event
	    pokemon = $ExtraEvents.pokemon[i].pokemon
		 tempspawnspokemon << i
		 loop do
		 if !@events[key_id]
		event.id = key_id
		#(map_id, event, pokemon, map=nil)
      @events[key_id]          = Game_PokeEvent.new(@map_id, event, pokemon, self) 
	    break
	    else
		  key_id+=1
		end
	    end

		end
    end
	tempspawnspokemon.each do |i|
	  $ExtraEvents.pokemon.delete(i)
	end
    $ExtraEvents.special.each_key do |i|
	    mapId = $ExtraEvents.special[i].map_id
		 next if mapId != @map_id
		key_id = (@events.keys.max || -1) + 1
	    event = $ExtraEvents.special[i].event
	    pokemon = $ExtraEvents.special[i].pokemon
		
		 loop do
		 if !@events[key_id]
		event.id = key_id
      @events[key_id]          = Game_PokeEventA.new(pokemon, @map_id, event, self) 
	    break
	    else
		  key_id+=1
		end
	    end

    end
    $ExtraEvents.misc.each_key do |i|
	    mapId = $ExtraEvents.misc[i].map_id
		 next if mapId != @map_id
		key_id = (@events.keys.max || -1) + 1
	    event = $ExtraEvents.misc[i].event
	    type = $ExtraEvents.misc[i].type
		 loop do
		 if !@events[key_id]
		event.id = key_id
      @events[key_id]          = Game_OVEvent.new(type, @map_id, event, self)
	    break
	    else
		  key_id+=1
		end
	    end
    end
	end
  end


  def generateBerryPlant(x,y)
    event = RPG::Event.new(x,y)
    event.name = "BerryPlant.center"
    key_id = ((@events.keys.max)|| -1) + 1
    event.id = key_id
    mapId = $game_map.map_id
    event.x = x
    event.y = y
    event.pages[0].move_speed = 2 #Sets movement speed.
    event.pages[0].move_frequency = 2 #Sets movement frequency.
    event.pages[0].move_type = 0 #Sets movement type.
    event.pages[0].direction_fix = true
    event.pages[0].walk_anime = false #Sets movement type.
    event.pages[0].step_anime = true #Sets movement type.
    event.pages[0].always_on_top = false #Sets movement type.
    event.pages[0].through = true #Sets movement type.
    event.pages[0].trigger = 0
    Compiler::push_script(event.pages[0].list,sprintf("pbBerryPlant"))
    Compiler::push_end(event.pages[0].list)
	
    gameEvent = Game_OVEvent.new(:BERRYPLANT, @map_id, event, self)
    gameEvent.id = key_id
	$ExtraEvents.objects[[@map_id,key_id]] = StoredEvent.new(@map_id,event,:BERRYPLANT)
	 $ExtraEvents.objects[[@map_id,key_id]].eventdata = gameEvent
	@events[key_id] = gameEvent
    berry_plant = $PokemonGlobal.eventvars[[@map_id, key_id]]
    if !berry_plant
       berry_plant = BerryPlantData.new(@events[key_id])
       berry_plant.jit=true
	   berry_plant.beside_water=any_acceptable_water_tiles_for_hoe(x,y)
       $PokemonGlobal.eventvars[[@map_id, key_id]] = berry_plant
    end
	    map = @map_id
		 viewport = Spriteset_Map.viewport
        sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
        $scene.spritesets[self.map_id].character_sprites.push(sprite)
       $scene.spritesets[self.map_id].addUserSprite(BerryPlantGroundSprite.new(@events[key_id], map, viewport))
       $scene.spritesets[self.map_id].addUserSprite(BerryPlantMoistureSprite.new(@events[key_id], map, viewport))
       $scene.spritesets[self.map_id].addUserSprite(BerryPlantMulchSprite.new(@events[key_id], map, viewport))
       $scene.spritesets[self.map_id].addUserSprite(BerryPlantSprite.new(@events[key_id], map, viewport))
       $scene.spritesets[self.map_id].addUserSprite(BerryPlantWeedSprite.new(@events[key_id], map, viewport))
  
  
    return @events[key_id]
  end



  def generateEvent(x,y,object,aat=false,store=false,direction=nil)
    true_object = nil
    true_object = object if object.is_a?(ItemData)
    true_object = ItemStorageHelper.get_item_data(object) if object.is_a?(Symbol)
    object = object.id if object.is_a?(ItemData)
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    #--- nessassary properties ----------------------------------------
    key_id = ((@events.keys.max)|| -1) + 1
    event.id = key_id
	if object == :PORTABLECAMP
    event.name = "Size(3,3).noshadow"
	elsif object == :BEDROLL
    event.name = "Size(1,2).noshadow"
	elsif object == :TORCH
    event.name = "playertorch(3,3)"
	elsif object == "CampsiteDoor"
    event.name = ".noshadow"
	else 
    event.name = ".noshadow"
	end
    image = getObjectImage(object)
	fname = "#{image}.png"
	if store==true && (object==:BEDROLL||object==:PORTABLECAMP||object==:HOME )
	fname = "Packed.png"
	end
	
	if !direction.nil?
	if object == :BEDROLL && (direction == 4 || direction == 6)
    case $game_player.direction
    when 2 #then event.move_down
	 x = $game_player.x
	 y = $game_player.y+1
    when 4 #then event.move_left
	 x = $game_player.x-1
	 y = $game_player.y
    when 6 #then event.move_right
	 x = $game_player.x+1
	 y = $game_player.y
    when 8 #then event.move_up
	 x = $game_player.x
	 y = $game_player.y-1
    end
    event.name = "Size(2,1).noshadow"
	fname = "bedsideways.png"
    event.x = x
    event.y = y
	end
    end
    event.pages[0].graphic.character_name = fname
    #--- movement of the event --------------------------------
    event.pages[0].move_speed = 0 #Sets movement speed.
    event.pages[0].move_frequency = 0 #Sets movement frequency.
    event.pages[0].move_type = 0 #Sets movement type.
    event.pages[0].direction_fix = true
    event.pages[0].walk_anime = false #Sets movement type.
    event.pages[0].always_on_top = aat #Sets movement type.
    event.pages[0].through = aat #Sets movement type.
    event.pages[0].trigger = 0 if object != "CampsiteDoor"
    event.pages[0].trigger = 1 if object == "CampsiteDoor"
    #--- event commands of the event -------------------------------------
    mapId = $game_map.map_id
	if object == "CampsiteDoor"
    Compiler::push_script(event.pages[0].list,sprintf("campsiteDoorEntry"))
	elsif object == "OvPot"
	elsif object == "Egg"
    Compiler::push_script(event.pages[0].list,sprintf("leggomyeggo"))
	else
    Compiler::push_script(event.pages[0].list,("object = get_own_event"))
    Compiler::push_script(event.pages[0].list,("ItemHandlers.triggerUseFromEvent(object.type,#{key_id}) if defined?(object.type)"))
    end
	
    #Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
    #--- creating and adding the Game_Event ------------------------------------
	true_object = object if true_object.nil?
	
	if object == :PORTABLECAMP && store==true
    event.x = x-1
    event.y = y
	end
	
	
	
    gameEvent = Game_OVEvent.new(true_object, @map_id, event, self)
    gameEvent.id = key_id
    gameEvent.direction = direction if !direction.nil?
    #$ExtraEvents.objects[key_id] = [mapId,event,true_object,x,y]
	
	$ExtraEvents.objects[[mapId,key_id]] = StoredEvent.new(mapId,event,true_object)
	 $ExtraEvents.objects[[mapId,key_id]].eventdata = gameEvent
	@events[key_id] = gameEvent
    #--- updating the sprites --------------------------------------------------------
	
	
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
    $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
	
	
	
	
	
	
	if store==true
	$player.held_item_object = key_id
	$player.held_item = true_object
	$game_temp.position_calling = true
	$game_system.save_disabled = true
	end
	
	
	 return key_id
  end





  def recreateEvent(storedevent,subtype)
	 event = storedevent.event
	 object = storedevent.type
	 key_id = event.id
	return if @events[key_id]
    #--- generating a new event ---------------------------------------
	if storedevent.eventdata.nil?
	 case subtype
	  when $ExtraEvents.misc
      gameEvent          = Game_OVEvent.new(object, @map_id, event, self)
	  when $ExtraEvents.special
      gameEvent          = Game_PokeEventA.new(object, @map_id, event, self) 
	  when $ExtraEvents.pokemon
      gameEvent          = Game_PokeEvent.new(@map_id, event, object, self) 
	  when $ExtraEvents.objects
      gameEvent          = Game_OVEvent.new(object, @map_id, event, self) 
	 
	 
	 end
	  storedevent.eventdata = gameEvent
	else
	 case subtype
	  when $ExtraEvents.misc
      gameEvent          = Game_OVEvent.new(object, @map_id, event, self)
	  when $ExtraEvents.special
      gameEvent          = Game_PokeEventA.new(object, @map_id, event, self) 
	  when $ExtraEvents.pokemon
      gameEvent          = Game_PokeEvent.new(@map_id, event, object, self) 
	  when $ExtraEvents.objects
      gameEvent          = Game_OVEvent.new(object, @map_id, event, self) 
	 
	 
	 end
	  if subtype == $ExtraEvents.pokemon
	    gameEvent2 = storedevent.eventdata
	    gameEvent.set_data(gameEvent2.transferrable_data)
	  end
	end
    @events[key_id] = gameEvent
	 puts @events[key_id].event.pages[0].graphic.character_name
	 if @events[key_id].type!=:BERRYPLANT
    #--- updating the sprites --------------------------------------------------------
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
	 puts sprite.character.event.pages[0].graphic.character_name
	#if defined?(spritesets)
    $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
	 else

    berry_plant = $PokemonGlobal.eventvars[[@map_id, key_id]]
    if !berry_plant
       berry_plant = BerryPlantData.new(@events[key_id])
       berry_plant.jit=true
       $PokemonGlobal.eventvars[[@map_id, key_id]] = berry_plant
    end
	    map = @map_id
		 viewport = Spriteset_Map.viewport
        sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
       $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
       $scene.spritesets[self.map_id].character_sprites.push(sprite)
     #  $scene.spritesets[self.map_id].addUserSprite(BerryPlantGroundSprite.new(@events[key_id], map, viewport))
     #  $scene.spritesets[self.map_id].addUserSprite(BerryPlantMoistureSprite.new(@events[key_id], map, viewport))
     #  $scene.spritesets[self.map_id].addUserSprite(BerryPlantMulchSprite.new(@events[key_id], map, viewport))
     #  $scene.spritesets[self.map_id].addUserSprite(BerryPlantWeedSprite.new(@events[key_id], map, viewport))
      # $scene.spritesets[self.map_id].addUserSprite(BerryPlantSprite.new(@events[key_id], map, viewport))
	 end
	#end
	return key_id
  end





  def recreateEvent2(event)
    #--- generating a new event ---------------------------------------
	theevent = event.event
    key_id = ((@events.keys.max)|| -1) + 1
	theevent.id = key_id
    event.type.associatedevent=key_id
    gameEvent = Game_PokeEventA.new(event.type, @map_id, theevent, self)
    gameEvent.type                     = event.type
    gameEvent.id                       = key_id
    @events[key_id] = gameEvent
    #--- updating the sprites --------------------------------------------------------
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
	#if defined?(spritesets)
    @events[key_id].opacity = 0
    $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
    @events[key_id].invisible_after_transfer = true
	 if alreadyfollowing==false
	  if $game_temp.current_pkmn_controlled!=false
	    @events[key_id].following = $game_temp.current_pkmn_controlled if @events[key_id].following!=$game_temp.current_pkmn_controlled
	   elsif !alreadyfollowingmon.nil? && alreadyfollowingmon.id != @id
	    @events[key_id].following = $game_player if @events[key_id].following!=$game_player
	  end
     elsif !alreadyfollowingmon.nil?
	  @events[key_id].following = alreadyfollowingmon
	 end
	@events[key_id].direction = @events[key_id].following.direction
  case @events[key_id].following.direction
  when 2 
   x= @events[key_id].following.x
   y= @events[key_id].following.y-1
  when 4
   x= @events[key_id].following.x+1
   y= @events[key_id].following.y
  when 6
   x= @events[key_id].following.x-1
   y= @events[key_id].following.y
  when 8
   x= @events[key_id].following.x
   y= @events[key_id].following.y+1
  end
    @events[key_id].moveto(x,y)
    @events[key_id].move_frequency=6
    @events[key_id].opacity = 255
    @events[key_id].follow_leader(@events[key_id].following) 
	@events[key_id].direction = @events[key_id].direction
	#$game_temp.check_for_invisible_events = true
	#end
    # alternatively: updating the sprites (old and slow but working):
    #$scene.disposeSpritesets
    #$scene.createSpritesets
	return true
  end




end


