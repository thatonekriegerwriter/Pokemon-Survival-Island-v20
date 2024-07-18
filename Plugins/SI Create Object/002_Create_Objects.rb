class Game_Map

  def generateEvent(x,y,object,aat=false,store=false,direction=nil)
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    #--- nessassary properties ----------------------------------------
    if $ExtraEvents.objects.nil?
	$ExtraEvents.objects = {}
	end 
    key_id = ((@events.keys.max)|| -1) + 1
    event.id = key_id
    event.x = x
    event.y = y
	if object == :PORTABLECAMP
    event.name = "Size(3,3).noshadow"
	elsif object == :BEDROLL
    event.name = "Size(1,2).noshadow"
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
	case object
	when "CampsiteDoor"
    event.pages[0].trigger = 1 #Player Touch
	else
    event.pages[0].trigger = 0 #Action Button
	end
    #--- event commands of the event -------------------------------------
    mapId = $game_map.map_id
	if object == "CampsiteDoor"
    Compiler::push_script(event.pages[0].list,sprintf("caniusethis('#{object}',#{key_id})"))
	else
    Compiler::push_script(event.pages[0].list,sprintf("caniusethis(:#{object},#{key_id})"))
    end
    #Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
    #--- creating and adding the Game_Event ------------------------------------
    gameEvent = Game_ObjectEvent.new(object, @map_id, event, self)
    gameEvent.id = key_id
	if object == :PORTABLECAMP && store==true
    $ExtraEvents.objects[key_id] = [mapId,event,object,x-1,y]
    gameEvent.moveto(x-1,y)
	else
    $ExtraEvents.objects[key_id] = [mapId,event,object,x,y]
    gameEvent.moveto(x,y)
	end
    gameEvent.type = object
	if !direction.nil?

    gameEvent.direction = direction
	end
	@events[key_id] = gameEvent
    #--- updating the sprites --------------------------------------------------------
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
    $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
    # alternatively: updating the sprites (old and slow but working):
    #$scene.disposeSpritesets
    #$scene.createSpritesets
	if store==true
	$player.held_item_object = key_id
	$player.held_item = object
	$game_temp.position_calling = true
	$game_system.save_disabled = true
	end
  end



  def recreateEvent(key_id,subtype)
    event=subtype[key_id][1]
	object=subtype[key_id][2]
	x=subtype[key_id][3]
	y=subtype[key_id][4]
	return if @events[key_id]
    #--- generating a new event ---------------------------------------
	if subtype != $ExtraEvents.pokemon
    gameEvent = Game_ObjectEvent.new(object, @map_id, event, self)
    gameEvent.type = object
	else
    gameEvent = Game_PokeEvent.new(@map_id, event, self)
    gameEvent.pokemon = object
	end
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
    @events[key_id] = gameEvent
    #--- updating the sprites --------------------------------------------------------
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
	#if defined?(spritesets)
    $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
	#end
    # alternatively: updating the sprites (old and slow but working):
    #$scene.disposeSpritesets
    #$scene.createSpritesets
	return true
  end



  def recreateEvent2(event)
    #--- generating a new event ---------------------------------------
	theevent = event.event
    key_id = ((@events.keys.max)|| -1) + 1
	theevent.id = key_id
    gameEvent = Game_ObjectEvent.new(event.pokemon, @map_id, theevent, self)
    gameEvent.type                     = event.pokemon
    gameEvent.id                       = key_id
    @events[key_id] = gameEvent
    #--- updating the sprites --------------------------------------------------------
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
	#if defined?(spritesets)
    @events[key_id].opacity = 0
    $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
    @events[key_id].invisible_after_transfer = true
	@events[key_id].direction = $game_player.direction
  case $game_player.direction
  when 2 
   x= $game_player.x
   y= $game_player.y-1
  when 4
   x= $game_player.x+1
   y= $game_player.y
  when 6
   x= $game_player.x-1
   y= $game_player.y
  when 8
   x= $game_player.x
   y= $game_player.y+1
  end
    @events[key_id].moveto(x,y)
    @events[key_id].move_frequency=6
    @events[key_id].opacity = 255
    @events[key_id].follow_leader($game_player) if $game_temp.current_pkmn_controlled==false
    @events[key_id].follow_leader($game_temp.current_pkmn_controlled) if $game_temp.current_pkmn_controlled!=false
	@events[key_id].direction = $game_player.direction
	#$game_temp.check_for_invisible_events = true
	#end
    # alternatively: updating the sprites (old and slow but working):
    #$scene.disposeSpritesets
    #$scene.createSpritesets
	return true
  end




end



def deletefromSIData(id)
    if $ExtraEvents.objects.has_key?(id)
      $ExtraEvents.objects.delete(id)
    end
end
def deletefromSISData(id)
    if $ExtraEvents.special.has_key?(id)
      $ExtraEvents.special.delete(id)
    end
end

def caniusethis(object,event)
	 if object!="Campsite"
	   pbGetObjectFunc(object,event)
	 elsif object=="Campsite"
	   pbGetObjectFunc(object,event)
	 else
	   pbMessage(_INTL("You cannot use #{object} here!"))
	 end
end

def getObjectImage(object)
	case object #CAULDRON, CraftingStation, 
	when :CRAFTINGBENCH  || :ELECTRICPRESS  || :SEWINGMACHINE
	 image = "CraftingStation"
	when :UPGRADEDCRAFTINGBENCH
	 image = "CraftingStation"
	when :APRICORNCRAFTING || :APRICORNMACHINE
	 image = "PokeballStationUp"
	when :FURNACE || :ELECTRICFURNACE || :MACHINEBOX 
	 image = "FurnaceUp"
	when :GRINDER || :ELECTRICGRINDER
	 image = "Furnace"
	when :CAULDRON
	 image = "Cauldron"
	when :SPRINKLER
	 image = "sprink"
	when :MEDICINEPOT
	 image = "pot"
	when :PORTABLECAMP
	 image = "Tent"
	when :PKMNCRATE
	 image = "cratedown"
	when :ITEMCRATE || :ICEBOX || :ELECTRICICEBOX
	 image = "crateidown"
	when :COALGENERATOR
	 image = "FurnaceUp"
	when :SOLARGENERATOR
	 image = "FurnaceUp"
	when :WINDGENERATOR
	 image = "FurnaceUp"
	when :HYDROGENERATOR
	 image = "FurnaceUp"
	when :POKEGENERATOR
	 image = "FurnaceUp"
    when :BEDROLL
	 image = "bed"
    when "Egg"
	 image = "egg"
    when "CampsiteDoor"
	 image = nil
	else
	 image = nil
	puts "ERROR"
	end

 return image
end

def pbPlaceObject(x,y,object,aat=false,direction=nil)
  # place event with random movement with overworld sprite
  # We define the event, which has the sprite of the pokemon and activates the wildBattle on touch
  if pbObjectIsPossible(x,y)
  if !$map_factory
    event = $game_map.generateEvent(x,y,object,aat,false,direction)
  else
    mapId = $game_map.map_id
    spawnMap = $map_factory.getMap(mapId)
    event = spawnMap.generateEvent(x,y,object,aat,false,direction)
  end
  if !event.nil?
  $player.held_item_object = event
  end
  return true
  else
  pbMessage(_INTL("You cannot place that there!"))
  $bag.add(object)
  end 
 # Play the pokemon cry of encounter
end

def pbHoldingObject(x,y,object,aat=false)
  # place event with random movement with overworld sprite
  # We define the event, which has the sprite of the pokemon and activates the wildBattle on touch
  if pbObjectIsPossible(x,y)
  if !$map_factory
    $game_map.generateEvent(x,y,object,aat,true)
  else
    mapId = $game_map.map_id
    spawnMap = $map_factory.getMap(mapId)
    spawnMap.generateEvent(x,y,object,aat,true)
  end
  return true
  else
  pbMessage(_INTL("You cannot place that there!"))
  $bag.add(object)
  end 
 # Play the pokemon cry of encounter
end

def pbObjectIsPossible(x,y)
  if !$game_map.valid?(x,y) #check if the tile is on the map
    return false
  else
    tile_terrain_tag = $game_map.terrain_tag(x,y)
  end
  for event in $game_map.events.values
    if event.x==x && event.y==y
	 if !$player.held_item_object.nil?
	 if event.x != $game_map.events[$player.held_item_object].x && event.y != $game_map.events[$player.held_item_object].y
      return false
	 elsif $player.held_item == :BEDROLL && ($game_map.events[$player.held_item_object].direction==4||$game_map.events[$player.held_item_object].direction==6)
	 else 
      return false
	 end
	 else
      return false
	 end
    
	end
  end
  return false if !tile_terrain_tag
  #check if it's a valid grass, water or cave etc. tile
  return false if tile_terrain_tag.ice
  return false if tile_terrain_tag.ledge
  return false if tile_terrain_tag.waterfall
  return false if tile_terrain_tag.waterfall_crest
  return false if tile_terrain_tag.id == :Rock
  return false if tile_terrain_tag.can_surf
  return false if !$game_map.passableStrict?(x, y, 0)
  return true
end

def pickMeUp(event,type)
key_id = event
$player.held_item=type
$player.held_item_object=event
if type == :BEDROLL
pbMoveRoute($game_map.events[key_id], [PBMoveRoute::Graphic,"Packed.png",0,$game_map.events[key_id].direction,0])
end
if type == :PORTABLECAMP
pbMoveRoute($game_map.events[key_id], [PBMoveRoute::Graphic,"Packed.png",0,$game_map.events[key_id].direction,0])
campdoor = nil
$ExtraEvents.objects.each_with_index do |(key, value),index|
    type2 = value[2]
	if type2 == "CampsiteDoor"
	  campdoor = key
	  break
	end
end

if !campdoor.nil?

  $game_map.removeThisEventfromMap(campdoor)
else
  mapId = $game_map.map_id
  $map_factory.getMap(mapId).removeThisEventfromMap(campdoor)
end
deletefromSIData(campdoor)
end

pbMoveRoute2($game_map.events[key_id], [PBMoveRoute::ThroughOn,PBMoveRoute::AlwaysOnTopOn,
PBMoveRoute::ChangeSpeed,$game_player.move_speed,PBMoveRoute::ChangeFreq,2])
if type != :PORTABLECAMP
$game_map.events[key_id].fancy_moveto2($game_player.x,$game_player.y-1,$game_player)
elsif type == :PORTABLECAMP
$game_map.events[key_id].fancy_moveto2($game_player.x-1,$game_player.y-1,$game_player)
end
$game_temp.position_calling = true
$game_system.save_disabled = true
end

def pbPlaceorHold(item=$player.held_item,x=nil,y=nil)
if $player.held_item.nil?
    $player.hold(item)
	return true
else
   if $player.held_item_object.is_a?(Pokemon) &&  Input.trigger(Input::SHIFT) && x.nil? && y.nil? 
    
   start_coord=[$game_player.x,$game_player.y]
   landing_coord=[$game_player.x,$game_player.y]
   case $game_player.direction
   when 2; landing_coord[1]+=3
   when 4; landing_coord[0]-=3
   when 6; landing_coord[0]+=3
   when 8; landing_coord[1]-=3
   end
    $scene.spriteset.addUserSprite(OWThrowSpriteEgg.new([start_coord,landing_coord],"egg",$game_map,Spriteset_Map.viewport))
	  pbMessage("\\ts[]" + (_INTL"#{$player.name} threw the Egg at the wall!\\wtnp[10]"))
    $player.held_item_object.steps_to_hatch -= 1750
    $player.held_item_object.happiness -= 25
   $player.held_item_object.loyalty -= 50
    $player.held_item_object.nature = :HATEFUL if rand(255)<=25 
    
   
   
   elsif x.nil? && y.nil?
	case item
		when :PORTABLECAMP
    x = $game_player.x-1
	y = $game_player.y-1
	
		when :BEDROLL
    case $game_player.direction
    when 2 #then event.move_down
	 x = $game_player.x
	 y = $game_player.y+2
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

	else
		
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

		end
    
   
   $player.place(x,y)
   if item == :PORTABLECAMP
    pbPlaceObject(x+1,y,"CampsiteDoor")
   end
   end
	return true
end

	return false
end


