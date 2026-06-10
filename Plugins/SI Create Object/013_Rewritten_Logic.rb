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
	 if $DynamicEvents.block_data.has_key?(@id) && $DynamicEvents.block_data[@id]==self
	    pbRemoveParticleEffectfromEvent(self)
		pbRemoveLightEffectfromThisEvent(self)
        $DynamicEvents.block_data.delete(@id)
	    $DynamicEvents.update!
	 end 
  end
  
  
  def update
   super
   if type != :BERRYPLANT
    data = self.variable
    if data
	  data.update if data.respond_to?(:update)
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
  event = $DynamicEvents.generateBerryPlant(x,y)
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
    event = $DynamicEvents.generateEvent(x,y,object,aat,store,direction)
	return event
  end



  def generateEvent(x,y,object,aat=false,store=false,direction=nil)
    event = $DynamicEvents.generateEvent(x,y,object,aat,store,direction)
	return event.id
  end





  def recreateEvent(storedevent,subtype)
     raise ""
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
	 if @events[key_id].type!=:BERRYPLANT
    #--- updating the sprites --------------------------------------------------------
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
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
     raise ""
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


