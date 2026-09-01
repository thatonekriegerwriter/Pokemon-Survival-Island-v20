ItemHandlers::UseFromBag.addIf(proc { |item| GameData::Item&.try_get(item).is_placeable? }, proc { |item, event|
    next 0 if Placeable.cant_place?
	placeable = GameData::Placeable.get(item.id)
	unless placeable.usable_here?
	 sideDisplay(_INTL("You can't use that here."))
	 next 0 
	end 
    if Placeable.begin_place(item)
	next 2 
	end
	#pbFadeOutIn {   }
	next 0



 }
)


module Placeable
 class << self 
def can_place?
  return false if !$player.held_item.nil?
  return false if !$player.held_item_object.nil?
  return true 
end 

def cant_place?
  !can_place?
end 

def begin_place(item)
  if place_or_hold(item)
	$bag.remove(item)
	return true 
  end
  return false
end 

def coordinates
  item_id = $player.held_item.id
  player_event = get_cur_player
  direction = $game_player.direction
  offset = GameData::Placeable.get(item_id).placement_offset(direction)
  return [player_event.x + offset[0], player_event.y + offset[1]]
end

def assignable?(item, pkmn)
   return GameData::Placeable.get(item.id).assignable?(item, pkmn)
end 

def place_or_hold(item = $player.held_item, x = nil, y = nil)
  if item.id==:PORTABLECAMP 
    held_event = $player.held_item_event
    if $DynamicEvents.block_data_for_map.any? { |event| event.type && event.type.is_a?(ItemData) && held_event != event && event.type.id == item.id }
	 sideDisplay(_INTL("There is already a Campsite around here!"))
     return false 
    end 
  end 
  unless $player.held_item?
    pbSEPlay("page2", 60)
    $player.hold(item)
	return true
  end   
  if throwable?(x, y)
    throw
	return false 
  end
  
  x,  y = coordinates if x.nil? || y.nil?
  
  
  return false unless $player.place(x, y)
  place(x + 1, y, "CampsiteDoor") if item.id == :PORTABLECAMP
  return true 
end 


def place(x, y, object, always_on_top = false, direction = nil, sound = false )
  unless object == "OvPot" || pbObjectIsPossible(x,y)
    sideDisplay(_INTL("You cannot place that there!"))
    return nil
  end 
  key_id = $DynamicEvents.generateEvent(x, y, object, always_on_top, false, direction)
  pbSEPlay("place") if key_id && sound 
  return key_id
end 

def hold(x, y, object, always_on_top = false, store = true )
    $player.held_item_object = $DynamicEvents.generateEvent(x , y, object, always_on_top, store)
end 

def pick_up(event_id, item)
 pbSEPlay("pickup")
 $player.held_item = item
 $player.held_item_object = event_id
 event = $player.held_item_event 
 return unless event 
 event.width = 1
 event.height = 1
 item_id = item.id
 if item_id == :BEDROLL
   pbMoveRoute(event, [PBMoveRoute::Graphic,"Packed.png",0,event.direction,0])
 end 
 if item_id == :ADVENTURECAMP
   pbMoveRoute(event, [PBMoveRoute::Graphic,"Packed.png",0,event.direction,0])
 end 
 if item_id == :PORTABLECAMP
   pbMoveRoute(event, [PBMoveRoute::Graphic,"Packed.png",0,event.direction,0])
   $DynamicEvents.block_data_for_map.each do |placeable|
       next unless placeable.type == "CampsiteDoor"
       placeable.removeThisEventfromMap
       deletefromSIData(placeable, $game_map.map_id)
   end 
 end
 pbMoveRoute2(event, [PBMoveRoute::ThroughOn,PBMoveRoute::AlwaysOnTopOn,PBMoveRoute::ChangeSpeed,$game_player.move_speed,PBMoveRoute::ChangeFreq,2])
 if item_id != :PORTABLECAMP
   event.fancy_moveto2($game_player.x,$game_player.y-1,$game_player)
 else
   event.fancy_moveto2($game_player.x-1,$game_player.y-1,$game_player)
 end
 $game_temp.position_calling = true
 $game_system.save_disabled = true
end 

def bedroll_possible?(event)
  return false unless $player.held_item&.id == :BEDROLL
  return event.direction==4 || event.direction==6

end 

def invalid_tile_tag(x,y)
  tile_terrain_tag = $game_map.terrain_tag(x,y)
  return false if tile_terrain_tag.nil?
  return true if tile_terrain_tag.ice
  return true if tile_terrain_tag.ledge
  return true if tile_terrain_tag.waterfall
  return true if tile_terrain_tag.waterfall_crest
  return true if tile_terrain_tag.id == :Rock
  return true if tile_terrain_tag.can_surf
  return false 

end 

def possible?(x, y)
  return false if !$game_map.valid?(x,y)
  return false if invalid_tile_tag(x,y)
  object_event = $player.held_item_event
  return false if !$game_map.passableStrict?(x, y, 0) && !bedroll_possible?(object_event)
  events = $game_map.events.values + $DynamicEvents.events_for_map
  for event in events
    next if $player.held_item_object.nil?
    next if event==object_event
    if event.x==x && event.y==y
	  # Multi-tile event collision handling
	  next if event.x != object_event.x && event.y != object_event.y
      return false
    end 
  end
  return true
end 

def throwable?(x, y)
  return true if $player.held_item.is_a?(Pokemon) &&  Input.trigger(Input::RUNNING) && x.nil? && y.nil? 
  return true if $player.held_item == "OvPot"
  return false 
end 
def throw
   throwable = $player.held_item
   start_coord=[$game_player.x,$game_player.y]
   landing_coord=[$game_player.x,$game_player.y]
   case $game_player.direction
   when 2; landing_coord[1]+=3
   when 4; landing_coord[0]-=3
   when 6; landing_coord[0]+=3
   when 8; landing_coord[1]-=3
   end
   unless throwable.is_a?(Pokemon)
      $scene.spriteset.addUserSprite(OWThrowSpriteEgg.new([start_coord,landing_coord],"egg",$game_map,Spriteset_Map.viewport))
	  sideDisplay("\\ts[]" + (_INTL"#{$player.name} threw the Egg at the wall!\\wtnp[10]"))
      throwable.steps_to_hatch -= 1750
      throwable.happiness -= 25
      throwable.loyalty -= 50
      throwable.nature = :HATEFUL if rand(255)<=25 
	  return
   end 
   
end 
 end 
end

def pbObjectIsPossible(x,y)
  return Placeable.possible?(x,y)
end

def can_map_transition?
    return true if $game_temp.position_calling == false && !$player.held_item? && !$game_temp.assigning?
	return false


end 

def cant_map_transition?
  !can_map_transition?
end 

class Scene_Map

  def positioning_controls
    return if $game_temp.position_calling == false
    return if $game_temp.current_pkmn_controlled == true
	return if $player.held_item.nil?
	return if $player.held_item_object.nil?
	event = $player.held_item_event
	return if event.nil?
	
	
	currentdir = event.direction
	
	
	if Input.trigger?(Input::USE)
	  if Placeable.place_or_hold
	   $game_system.save_disabled = false
	   $game_temp.position_calling = false
	  end
	elsif Input.trigger?(Input::INVENTORY)
	    if !$player.held_item.is_a?(Pokemon)
		 $bag.last_viewed_pocket=Settings.bag_pocket_names.length
		 $game_temp.position_calling = false
	   $game_system.save_disabled = false
	     inventory_logic 
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
  

end 



def is_bedroll_or_camp? #SHOULD BE UNSURE, IF CALLED, RAISE WILL FLAG.
  raise
  return false if $player.held_item.nil?
 return ((GameData::Item.get($player.held_item).id == :BEDROLL || GameData::Item.get($player.held_item).id == :PORTABLECAMP ) && $game_player.direction==8)
end




EventHandlers.add(:on_leave_tile, :update_held_item,
  proc {|event|
    next if !$scene.is_a?(Scene_Map)
    next if event != $game_player
    if ($player.held_item_object.nil? && !$player.held_item.nil?) || (!$player.held_item_object.nil? && $player.held_item.nil?)
    $player.held_item_object=nil
    $player.held_item=nil
	end
    next if $player.held_item_object.nil?
    next if $player.held_item.nil?
	
	
	item_id = $player.held_item.id
	event = $player.held_item_event
	next if event.nil?
    pbMoveRoute2(event, [PBMoveRoute::ThroughOn,PBMoveRoute::AlwaysOnTopOn,PBMoveRoute::ChangeSpeed,$game_player.move_speed,PBMoveRoute::ChangeFreq,2])
	if item_id != :PORTABLECAMP
      event.fancy_moveto2($game_player.x,$game_player.y-1,$game_player)
    elsif item_id == :PORTABLECAMP
      event.fancy_moveto2($game_player.x-1,$game_player.y-1,$game_player)
    end
  }
)



EventHandlers.add(:on_leave_map, :update_held_item,
  proc {
    #THIS HAS BEEN DISABLED FOR UNCLEAR REASONS
    next
    if ($player.held_item_object.nil? && !$player.held_item.nil?) || (!$player.held_item_object.nil? && $player.held_item.nil?)
    $player.held_item_object=nil
    $player.held_item=nil
	end
    next if $player.held_item_object.nil?
    next if $player.held_item.nil?
	key_id = $player.held_item_object
	$game_map.events[key_id].moveto($game_player.x,$game_player.y-5)
    pbMoveRoute($game_map.events[key_id], [PBMoveRoute::ThroughOff,PBMoveRoute::AlwaysOnTopOff])
    $ExtraEvents.objects[key_id][1].x=$game_player.x
	$ExtraEvents.objects[key_id][1].y=$game_player.y-5
    $ExtraEvents.objects[key_id][1] = false
    $ExtraEvents.objects[key_id][1] = false
    $player.held_item_object=nil
    $player.held_item=nil
  }
)