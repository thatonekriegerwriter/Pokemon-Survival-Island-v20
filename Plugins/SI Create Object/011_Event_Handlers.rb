
EventHandlers.add(:on_leave_tile, :update_sprite_position,
  proc {|event|
    next if !$scene.is_a?(Scene_Map)
    next if event != $game_player
    if ($player.held_item_object.nil? && !$player.held_item.nil?) || (!$player.held_item_object.nil? && $player.held_item.nil?)
    $player.held_item_object=nil
    $player.held_item=nil
	end
	
	
    next if $player.held_item_object.nil?
    next if $player.held_item.nil?
	
	
	type = $player.held_item
	key_id = $player.held_item_object
	
	
    pbMoveRoute2($game_map.events[key_id], [PBMoveRoute::ThroughOn,PBMoveRoute::AlwaysOnTopOn,
	PBMoveRoute::ChangeSpeed,$game_player.move_speed,PBMoveRoute::ChangeFreq,2])
	
	 if !$game_map.events[key_id].nil?
	if type != :PORTABLECAMP
      $game_map.events[key_id].fancy_moveto2($game_player.x,$game_player.y-1,$game_player)
   elsif type == :PORTABLECAMP
      $game_map.events[key_id].fancy_moveto2($game_player.x-1,$game_player.y-1,$game_player)
   end
    end
  }
)


EventHandlers.add(:on_leave_map, :update_sprite_position2,
  proc {
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
EventHandlers.add(:on_leave_map, :update_sprite_position2,
  proc {
    next
	$game_map.events.each do |id,event|
	if event.name == "PlayerPkmn"
	deletefromSISData(event.id,$game_map,map_id)
	pbReturnPokemon(event.id)
	end
	end
    
  }
)



EventHandlers.add(:on_leave_tile, :spawn_queued_events,
  proc { |event|
  
    next if !$scene.is_a?(Scene_Map)
    next if event != $game_player
    if $game_switches[556]==true && !$game_map.check_event(28,18)
       manuallyGenerate(28,18,8)
    end
    if $game_temp.spawnqueue.length > 0 && $game_temp.preventspawns==false && !pbMapInterpreterRunning? && false
	  completed_events = []
	  $game_temp.spawnqueue.each_with_index do |i,index|
	   next if $game_temp.preventspawns==true
	   gameEvent = i[0]
	   event = i[1]
	   next if $game_map.map_id!=gameEvent.map_id
       key_id = ($game_map.events.keys.max || -1) + 1
      event.id = key_id
	   mapId=gameEvent.map_id
	   pokemon=gameEvent.pokemon
      $player.pokedex.set_seen(pokemon.species)
	   x=gameEvent.x
	   y=gameEvent.y
    $ExtraEvents.pokemon[key_id] = [mapId,event,pokemon,x,y]
	 next if key_id.nil?
    $game_map.events[key_id] = gameEvent
    #--- updating the sprites --------------------------------------------------------
    sprite = Sprite_Character.new(Spriteset_Map.viewport,$game_map.events[key_id])
    $scene.spritesets[$game_map.map_id]=Spriteset_Map.new($game_map) if $scene.spritesets[$game_map.map_id]==nil
    $scene.spritesets[$game_map.map_id].character_sprites.push(sprite)
	completed_events << index
	 end
	 completed_events.each do |i|
	  $game_temp.spawnqueue.delete_at(i)
	 end
	end
  }
)


EventHandlers.add(:on_map_or_spriteset_change, :populateextraevents, proc{
    next if $scene.to_s.include?("#<Scene_DebugIntro")
    next if $scene.to_s.include?("#<Scene_Intro")

    if $ExtraEvents.objects.nil?
	$ExtraEvents.objects = {}
	end 
	mapId = $game_map.map_id
	
	$ExtraEvents.objects.each_key do |i|
	  if $ExtraEvents.objects[i].map_id==mapId
       spawnMap = $map_factory.getMap(mapId)
	    spawnMap.recreateEvent($ExtraEvents.objects[i],$ExtraEvents.objects)
	  end
    end
		tempspawnspokemon = []
	$ExtraEvents.pokemon.each_key do |i|
	  if $ExtraEvents.pokemon[i].map_id==mapId
	  if $game_temp.in_temple==false
	   result = rand(3)==0 
	   if result
        spawnMap = $map_factory.getMap(mapId)
	    spawnMap.recreateEvent($ExtraEvents.pokemon[i],$ExtraEvents.pokemon)
		else
		 tempspawnspokemon << i
		end
	  
	  else
        spawnMap = $map_factory.getMap(mapId)
	    spawnMap.recreateEvent($ExtraEvents.pokemon[i],$ExtraEvents.pokemon)
	  end
	  end
    end

	tempspawnspokemon.each do |i|
	  $ExtraEvents.pokemon.delete(i)
	end
	$ExtraEvents.special.each_key do |i|
	  if $ExtraEvents.special[i].map_id==mapId
	    if $ExtraEvents.special[i].pokemon.name != "PlayerPkmn"
        spawnMap = $map_factory.getMap(mapId)
	    spawnMap.recreateEvent($ExtraEvents.special[i],$ExtraEvents.special)
		end
	  end
    end
  
	$ExtraEvents.misc.each_key do |i|
	  if $ExtraEvents.misc[i].map_id==mapId
       spawnMap = $map_factory.getMap(mapId)
	    spawnMap.recreateEvent($ExtraEvents.misc[i],$ExtraEvents.misc)
	  end
    end

})
 

EventHandlers.add(:on_enter_map, :populateextraevents, proc{
    next if $scene.to_s.include?("#<Scene_DebugIntro")
    next if $scene.to_s.include?("#<Scene_Intro")
    next
    if $ExtraEvents.objects.nil?
	$ExtraEvents.objects = {}
	end 
	mapId = $game_map.map_id
	
	$ExtraEvents.objects.each_key do |i|
	  if $ExtraEvents.objects[i].map_id==mapId
       spawnMap = $map_factory.getMap(mapId)
	    spawnMap.recreateEvent($ExtraEvents.objects[i],$ExtraEvents.objects)
	  end
    end
		tempspawnspokemon = []
	$ExtraEvents.pokemon.each_key do |i|
	  if $ExtraEvents.pokemon[i].map_id==mapId
	   result = rand(3)==0 
	   if result
        spawnMap = $map_factory.getMap(mapId)
	    spawnMap.recreateEvent($ExtraEvents.pokemon[i],$ExtraEvents.pokemon)
		else
		 tempspawnspokemon << i
		end
	  end
	  
    end

	tempspawnspokemon.each do |i|
	  $ExtraEvents.pokemon.delete(i)
	end
	$ExtraEvents.misc.each_key do |i|
	  if $ExtraEvents.misc[i].map_id==mapId
       spawnMap = $map_factory.getMap(mapId)
	    spawnMap.recreateEvent($ExtraEvents.misc[i],$ExtraEvents.misc)
	  end
    end

})


