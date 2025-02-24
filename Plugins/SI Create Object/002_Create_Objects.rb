def get_own_event
	interp = pbMapInterpreter
    this_event = interp.get_self
    return this_event
 end
 def get_own_interp
	interp = pbMapInterpreter
    this_event = interp.get_self
    statue = interp.getVariableOther(this_event.id)
    return statue
 end

 def get_other_data(id)
	interp = pbMapInterpreter
    berryplant_data = interp.getVariableOther(id)
    return berryplant_data
 end



def deletefromSIData(id,mapid=$game_map.map_id)
  $ExtraEvents.removethisEvent(:OBJECT,id,mapid)
end
def deletefromSISData(id,mapid)
  $ExtraEvents.removethisEvent(:SPECIAL,id,mapid)
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
	when :GRINDER || :ELECTRICGRINDER || :TORCH
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
    when "OvPot"
	 image = "pot"
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

def pbResetPlacing


end

def pbPlaceObject(x,y,object,aat=false,direction=nil)
  # place event with random movement with overworld sprite
  # We define the event, which has the sprite of the pokemon and activates the wildBattle on touch
    update_variable = nil
  if !$player.held_item_object.nil? && !$player.held_item.nil?
    if $player.held_item.is_a?(ItemData)
	   localMeter = pbMapInterpreter.getVariableOther($player.held_item_object)
	   if !localMeter.nil?
	      	update_variable = localMeter.dup 
			pbMapInterpreter.deleteVariableOther($player.held_item_object)
	   end
    end
  end

  if object=="OvPot" || pbObjectIsPossible(x,y)
  if !$map_factory
    key_id = $game_map.generateEvent(x,y,object,aat,false,direction)
  else
    mapId = $game_map.map_id
    spawnMap = $map_factory.getMap(mapId)
    key_id = spawnMap.generateEvent(x,y,object,aat,false,direction)
  end
  if !key_id.nil?
  $player.held_item_object = key_id
  end
  if !update_variable.nil?
	   pbMapInterpreter.setVariableOther(update_variable,$player.held_item_object)
	   localMeter2 = pbMapInterpreter.getVariableOther($player.held_item_object)
  end
  return true
  else
  pbMessage(_INTL("You cannot place that there!"))
  #$bag.add(object)
  return false
  end 
 # Play the pokemon cry of encounter
end

def pbHoldingObject(x,y,object,aat=false)
  # place event with random movement with overworld sprite
  # We define the event, which has the sprite of the pokemon and activates the wildBattle on touch
  
  
    update_variable = nil
    puts !$player.held_item_object.nil? && !$player.held_item.nil?
    puts $player.held_item.is_a?(ItemData)
  if !$player.held_item_object.nil? && !$player.held_item.nil?
    if $player.held_item.is_a?(ItemData)
	   localMeter = pbMapInterpreter.getVariableOther($player.held_item_object)
        puts localMeter.fuel.to_s
	   if !localMeter.nil?
	      	update_variable = localMeter.dup 
        puts update_variable.fuel.to_s
			pbMapInterpreter.deleteVariableOther($player.held_item_object)
	   end
    end
  end
  
  
  if pbObjectIsPossible(x,y)
  if !$map_factory
    key_id = $game_map.generateEvent(x,y,object,aat,true)
  else
    mapId = $game_map.map_id
    spawnMap = $map_factory.getMap(mapId)
    key_id = spawnMap.generateEvent(x,y,object,aat,true)
  end
  if !update_variable.nil?
	   pbMapInterpreter.setVariableOther(update_variable,$player.held_item_object)
	   localMeter2 = pbMapInterpreter.getVariableOther($player.held_item_object)
        puts localMeter2.fuel.to_s
  end
  return true
  else
  pbMessage(_INTL("You cannot place that there!"))
  #$bag.add(object)
  return false
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
    next if event==$game_map.events[$player.held_item_object]
    if event.x==x && event.y==y
	
	 if !$player.held_item_object.nil?
	 
	 if event.x != $game_map.events[$player.held_item_object].x && event.y != $game_map.events[$player.held_item_object].y
      next
	 elsif is_bedroll?
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
   potato = !$game_map.passableStrict?(x, y, 0) && !is_bedroll?
  return false if potato
  return true
end
def is_bedroll_or_camp?
 return (($player.held_item == :BEDROLL || $player.held_item == :PORTABLECAMP ) && $game_player.direction==8)
end
def is_bedroll?
 return ($player.held_item == :BEDROLL && ($game_map.events[$player.held_item_object].direction==4||$game_map.events[$player.held_item_object].direction==6))
end
def pickMeUp(event,type)
key_id = event
$player.held_item=type
$player.held_item_object=event
if !$game_map.events[key_id].nil?


if GameData::Item.get(type).id == :BEDROLL
pbMoveRoute($game_map.events[key_id], [PBMoveRoute::Graphic,"Packed.png",0,$game_map.events[key_id].direction,0])
end
if GameData::Item.get(type).id == :PORTABLECAMP



pbMoveRoute($game_map.events[key_id], [PBMoveRoute::Graphic,"Packed.png",0,$game_map.events[key_id].direction,0])
campdoor = nil



$ExtraEvents.objects.each_with_index do |(key, value),index|
    type2 = value.type
	if type2 == "CampsiteDoor"
	  campdoor = key
	  break
	end
end





if !campdoor.nil?
$game_map.events[campdoor].removeThisEventfromMap(campdoor)
deletefromSIData(campdoor,$game_map.map_id)
end

end



pbMoveRoute2($game_map.events[key_id], [PBMoveRoute::ThroughOn,PBMoveRoute::AlwaysOnTopOn,
PBMoveRoute::ChangeSpeed,$game_player.move_speed,PBMoveRoute::ChangeFreq,2])

if GameData::Item.get(type).id != :PORTABLECAMP
$game_map.events[key_id].fancy_moveto2($game_player.x,$game_player.y-1,$game_player)
elsif type.id == :PORTABLECAMP
$game_map.events[key_id].fancy_moveto2($game_player.x-1,$game_player.y-1,$game_player)
end
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
	case GameData::Item.get(item).id
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
    
   
   if $player.place(x,y)
   if GameData::Item.get(item).id == :PORTABLECAMP
    pbPlaceObject(x+1,y,"CampsiteDoor")
   end
   
	return true
   else
    return false
   end
   end
end

	return false
end


