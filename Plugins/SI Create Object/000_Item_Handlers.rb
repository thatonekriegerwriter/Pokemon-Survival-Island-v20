

def getCampExit
    pbFadeOutIn {
    $game_temp.player_new_map_id    = $PokemonGlobal.pokecenterMapId
    $game_temp.player_new_x         = $PokemonGlobal.pokecenterX
    $game_temp.player_new_y         = $PokemonGlobal.pokecenterY
    $game_temp.player_new_direction = $PokemonGlobal.pokecenterDirection
      pbDismountBike
      $scene.transfer_player
      $game_map.autoplay
      $game_map.refresh
    }

end


def reduceStaminaBasedOnItem(item)
    item_data=GameData::Item.get(item)
    if item_data.is_dart?
		return decreaseStamina(4)
    elsif item_data.is_poke_ball?
	return decreaseStamina(8)
    else
     case item.id
     when :STONEPICKAXE
	  return decreaseStamina(7)
     when :IRONPICKAXE
	  return decreaseStamina(7)
     when :STONEAXE
	  return decreaseStamina(7)
     when :IRONAXE
	  return decreaseStamina(7)
     when :STONEHAMMER
	  return decreaseStamina(7)
     when :IRONHAMMER
	  return decreaseStamina(7)
     when :SHOVEL
	  puts "Totsugeki"
	  return decreaseStamina(5)
     when :POLE
	  return decreaseStamina(5)
	   when :MACHETE
	  return decreaseStamina(5)
	   when :STONE
	  return decreaseStamina(4)
	   when :BAIT
	 return decreaseStamina(4)
     when :SNATCHER
		return decreaseStamina(4)
     when :SNATCHER
	 else
		return decreaseStamina(1)
     end
	end

    return false
end


class PositionMarker
  def initialize(x,y,viewport = Spriteset_Map.viewport, map = $game_map)
	 @map = map
    @real_x = x * Game_Map::REAL_RES_X
    @real_y = y * Game_Map::REAL_RES_Y
    @image1 = IconSprite.new(0, 0, viewport)
    @image1.setBitmap("Graphics/Pictures/OVMARKER/ovmarker.png")
    @image1.x = self.screen_x
    @image1.y = self.screen_y
    @image1.z = 1000
    @image2 = IconSprite.new(0, 0, viewport)
    @image2.setBitmap("Graphics/Pictures/OVMARKER/ovmarker2.png")
    @image2.x = @image1.x
    @image2.y = @image1.y - 6
    @image2.z = 1001
    @disposed = false
  end
  
  def visible=(value)
    @image1.visible = value
    @image2.visible = value
  end
  
  def x=(value)
    @real_x = value * Game_Map::REAL_RES_X
  
  end
  
  
  def y=(value)
    @real_y = value * Game_Map::REAL_RES_Y
  end
  
  def screen_x
    
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_x - @map.display_x) / Game_Map::X_SUBPIXELS).round
    #ret += 1 * Game_Map::TILE_WIDTH / 2
    return ret
  end
  
  def screen_y
	if @map.nil?
	@map=$game_map
	end
    ret = ((@real_y - @map.display_y) / Game_Map::Y_SUBPIXELS).round
    #ret += Game_Map::TILE_HEIGHT
    return ret
  end  

  def disposed?
    return @disposed
  end

  def dispose
    @image1.dispose
    @image2.dispose
    @map = nil
    @event = nil
    @disposed = true
  end


  def update
    return if !@image1 || !@image2 || @disposed
    @image1.update
    @image2.update
    @image1.x = self.screen_x
    @image1.y = self.screen_y
    @image2.x = @image1.x
    @image2.y = @image1.y - 6
  end
end


class Game_Player < Game_Character

  def move_generic24(dir, turn_enabled = true)
    turn_generic(dir, true) if turn_enabled
    if !$game_temp.encounter_triggered
      if can_move_in_direction?(dir)
        x_offset = (dir == 4) ? -1 : (dir == 6) ? 1 : 0
        y_offset = (dir == 8) ? -1 : (dir == 2) ? 1 : 0
        return true if pbLedge(x_offset, y_offset)
        return true if pbEndSurf(x_offset, y_offset)
        turn_generic(dir, true)
        if !$game_temp.encounter_triggered
          @x += x_offset
          @y += y_offset
          if $PokemonGlobal&.diving || $PokemonGlobal&.surfing
            $stats.distance_surfed += 1
          elsif $PokemonGlobal&.bicycle
            $stats.distance_cycled += 1
          else
            $stats.distance_walked += 1
          end
          $stats.distance_slid_on_ice += 1 if $PokemonGlobal.sliding
          increase_steps
          return true
        end
      elsif !check_event_trigger_touch(dir)
        bump_into_object
        return false
      else
        return false
      end
    end
    $game_temp.encounter_triggered = false
  end

end




def get_opposite_direction
  case $game_player.direction
  when 2
    return 8
  when 4
    return 6
  when 6
    return 4
  when 8
    return 2
  end


end

def getLandingCoords(amt,event=$game_player)
  start_coord=[event.x,event.y]
  landing_coord=[event.x,event.y]

  case event.direction
  when 2; landing_coord[1]+=amt
  when 4; landing_coord[0]-=amt
  when 6; landing_coord[0]+=amt
  when 8; landing_coord[1]-=amt
  end

  return [start_coord,landing_coord]
end

def getLandingCoordsAB(event,event2=$game_player)
  start_coord=[event2.x,event2.y]
  landing_coord=[event.x,event.y]
  return [start_coord,landing_coord]
end

def getLandingCoords2(event=$game_player)
  start_coord=[event.x,event.y]
  landing_coord=get_tile_mouse_on


  return [start_coord,landing_coord]
end

def player_turning_logic(x,y)
delta_x = x - $game_player.x
delta_y = y - $game_player.y

abs_delta_x = delta_x.abs
abs_delta_y = delta_y.abs
 desired_direction = $game_player.direction
  thereturn = 0
if abs_delta_x >= abs_delta_y
  if delta_x > 0
    desired_direction = 6 
  else
    desired_direction = 4 
  end
    thereturn = delta_x
else
  if delta_y > 0
    desired_direction = 2 
  else
    desired_direction = 8
  end
    thereturn = delta_y
end
  return desired_direction,thereturn
end 


def selection_mouse_logic(do_it, amt)
    start_end = getLandingCoords2#getLandingCoords(amt)
	$game_temp.currently_selecting=true
	 prior_mode = $mouse.current_mode
	 
	  $mouse.set_mode(:SELECTION)
	loop do
	Graphics.update
	Input.update
	$scene.update

	 temp = getLandingCoords2
	 if start_end!=temp
    start_end = temp
	 end
	 if Input.trigger?(Input::USE) && !start_end.nil?
	   
	    turn,amt = player_turning_logic(start_end[1][0],start_end[1][1])
	    $game_player.turn_generic(turn) if (start_end[1][0]!=start_end[0][0]) && (start_end[1][1]!=start_end[0][1])
	    do_it = true
	  pbSEPlay("GUI sel decision", 60) 
	   $game_temp.currently_selecting=false
	    break
	 elsif Input.trigger?(Input::BACK)
	   $game_temp.currently_selecting=false
	   break
	end
	
	end

	  $mouse.set_mode(prior_mode)

  return do_it,amt,start_end
end


def throwing_range_logic(do_it, amt)
   if $player.weapon_cooldown>0
	sideDisplay("You are too winded from your last attack still!")
    start_end = getLandingCoords2
    return do_it,amt,start_end
   end
	 if (Input.trigger?(Input::JUMPUP)  || Input.scroll_v==1) && false
	  if amt+1<=7
	  position_marker.visible=false
	    amt+=1
       start_end = getLandingCoords(amt)
	   if start_end[0]==start_end[1]
	    amt+=1 
       start_end = getLandingCoords(amt)
	   end
      position_marker.x=start_end[1][0]
	  position_marker.y=start_end[1][1]
      pbSEPlay("GUI storage pick up")
	  position_marker.visible=true
	  end
     elsif (Input.trigger?(Input::JUMPDOWN)  || Input.scroll_v==-1) && false
	  if amt-1>=-7
	  position_marker.visible=false
	    amt-=1
		
       start_end = getLandingCoords(amt)
	   if start_end[0]==start_end[1]
	    amt-=1 
       start_end = getLandingCoords(amt)
	   end
      position_marker.x=start_end[1][0]
	  position_marker.y=start_end[1][1]
      pbSEPlay("GUI storage put down")
	  position_marker.visible=true
	  end
	 end
	if $game_temp.lockontarget==false
    start_end = getLandingCoords2#getLandingCoords(amt)
	position_marker = PositionMarker.new(start_end[1][0],start_end[1][1])
	$game_temp.in_throwing=true
	$mouse.hide
	loop do
	Graphics.update
	Input.update
	$scene.update
	position_marker.update

	 temp = getLandingCoords2
	 if start_end!=temp
    start_end = temp
	position_marker.x=start_end[1][0]
	position_marker.y=start_end[1][1]
    pbSEPlay("GUI storage put down")
	 end
	 if Input.trigger?(Input::USE) && !start_end.nil?
	   
	    turn,amt = player_turning_logic(start_end[1][0],start_end[1][1])
	    $game_player.turn_generic(turn) 
	    do_it = true
	   $game_temp.in_throwing=false
		position_marker.dispose
	    break
	 elsif Input.trigger?(Input::BACK)
	   $game_temp.in_throwing=false
		position_marker.dispose
	   break
	end
	
	end
    $mouse.show
	else
	   event = $game_temp.lockontarget
	   start_end = getLandingCoordsAB(event)
	   turn,amt = player_turning_logic(start_end[1][0],start_end[1][1])
	   do_it = true
    end
  return do_it,amt,start_end
end


def throwing_range_logic_pokeball(amt)
	 $game_temp.currently_throwing_pkmn = true
     do_it = false 
	 if (Input.trigger?(Input::JUMPUP)  || Input.scroll_v==1) && false
	  if amt+1<=7
	  position_marker.visible=false
	    amt+=1
       start_end = getLandingCoords(amt)
	   if start_end[0]==start_end[1]
	    amt+=1 
       start_end = getLandingCoords(amt)
	   end
      position_marker.x=start_end[1][0]
	  position_marker.y=start_end[1][1]
      pbSEPlay("GUI storage pick up")
	  position_marker.visible=true
	  end
     elsif (Input.trigger?(Input::JUMPDOWN)  || Input.scroll_v==-1) && false
	  if amt-1>=-7
	  position_marker.visible=false
	    amt-=1
		
       start_end = getLandingCoords(amt)
	   if start_end[0]==start_end[1]
	    amt-=1 
       start_end = getLandingCoords(amt)
	   end
      position_marker.x=start_end[1][0]
	  position_marker.y=start_end[1][1]
      pbSEPlay("GUI storage put down")
	  position_marker.visible=true
	  end
	 end
    start_end = getLandingCoords2#getLandingCoords(amt)
	position_marker = PositionMarker.new(start_end[1][0],start_end[1][1])
	$game_temp.in_throwing=true
	
	$mouse.hide
	loop do
	Graphics.update
	Input.update
	$scene.update
	position_marker.update
	 temp = getLandingCoords2
	 if start_end!=temp
      start_end = temp
	  position_marker.x=start_end[1][0]
	  position_marker.y=start_end[1][1]
      pbSEPlay("GUI storage put down")
	 end
	 if Input.trigger?(Input::USE) && !start_end.nil? #&& (start_end[1][0]!=start_end[0][0]) && (start_end[1][1]!=start_end[0][1])
	   
	    turn,amt = player_turning_logic(start_end[1][0],start_end[1][1])
	    $game_player.turn_generic(turn) 
	    do_it = true
	   $game_temp.in_throwing=false
		position_marker.dispose
	    break
	 elsif Input.press?(Input::LOCKON) && $game_temp.lockontarget!=false
	   event = $game_temp.lockontarget
	   start_end = getLandingCoordsAB(event)
	   position_marker.x=start_end[1][0]
	   position_marker.y=start_end[1][1]
	   turn,amt = player_turning_logic(start_end[1][0],start_end[1][1])
	   do_it = true
	   $game_temp.in_throwing=false
		position_marker.dispose
	   break
	 elsif Input.trigger?(Input::BACK)
	   $game_temp.in_throwing=false
		position_marker.dispose
	   break
	end
	
	end
    $mouse.show
	 $game_temp.currently_throwing_pkmn = false
  return do_it,amt,start_end
end

 def can_throw_pkmn?
    return false if $game_temp.pokemon_calling==true
    return false if $game_temp.in_throwing==true
   # return false if $game_temp.preventspawns == true
	return true 
 end 

ItemHandlers::UseFromBox.addIf(proc { |item| item.is_a?(Pokemon) }, proc { |pkmn, event|
    pkmn.sanitize_in_world
    next false if pkmn.unavailable?
    next false if !can_throw_pkmn?
    if pkmn.inworld==true && $PokemonGlobal.cur_stored_pokemon!=pkmn
	  $PokemonGlobal.set_ball_hud_type(:MOVES,true,pkmn)
	  next true
	end 
	next true if pkmn.inworld==true
	if pbOverworldCombat.battle_rules.include?("Only-One-Mon") && refresh_overworld_pokemon_count == 1
	  sideDisplay(_INTL("You can only have one Pokemon on the map right now!"))
	  next false
	end
    do_it, amt, start_end = throwing_range_logic_pokeball(amt)
    next false if !do_it
	x,y = start_end[1]
	can_do = decreaseStamina(3.55*amt)
    next false unless can_do #&& $game_player.pbFacingTerrainTag.can_surf_freely==false
    pbSEPlay("Battle throw")
    sprite_index = $scene.spriteset.addUserSprite(OWPokemonReleaseSprite.new(start_end,pkmn,$game_map,Spriteset_Map.viewport))
	holding_pattern(sprite_index)
    event_id = $game_map.check_event(x, y)
	enemy_present = event_id && $game_map.events[event_id] && $game_map.events[event_id].is_a?(Game_PokeEvent)
    if enemy_present
	   poke = $game_map.events[event_id].pokemon 
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
	   if poke.status==:PARALYSIS || poke.status==:SLEEP || poke.status==:FROZEN
        sideDisplay(_INTL("#{pkmn.name} surprised #{poke.name}!\\wtnp[10]"))
        pbSEPlay("Battle damage normal")
        damage = pbOverworldCombat.getDamager(poke, 1, :TACKLE)
        pbOverworldCombat.damagePokemon($game_map.events[event_id], damage)
		next true if poke.fainted?
       end
       pbSingleOrDoubleWildBattle( $game_map.map_id, $game_map.events[event_id].x, $game_map.events[event_id].y, poke )
       $PokemonGlobal.battlingSpawnedPokemon = false
       $game_map.events[event_id].removeThisEventfromMap
       pbResetTempAfterBattle()
	   next true
	end 
	if !pbObjectIsPossible(x,y)
	 sideDisplay(_INTL("Your Pokeball bounced off for some reason."))
	 pbSEPlay("Player bump")
     next false 
	end
	pbSEPlay("Battle recall") 
	pbPlacePokemon(x, y, pkmn)
	event = pkmn.event
	next false if event.nil?
	pbShowTipCardsGrouped(:OVERWORLD_PKMN) if !pbSeenTipCard?(:OVERWORLDPOKEMON)
	
  }
)


ItemHandlers::UseFromBox.addIf(proc { |item| GameData::Item&.try_get(item).is_poke_ball? }, proc { |item, event|
    next if $player.is_it_this_class?(:RANGER,false)
	next if $game_temp.in_throwing==true
	if pbBoxesFull?
	  sideDisplay(_INTL("There's no room for Pokémon!"))
	  next
	end 
	if pbOverworldCombat.battle_rules.include?("Catchless")
	  sideDisplay(_INTL("You can't catch anything right now!"))
	next
	
	end
	if nuzlocke_has?(:NOOVCATCHING)
	  sideDisplay(_INTL("Overworld Catching is disabled!"))
	next
	end
	if nuzlocke_has?(:ONEROUTE)
      static = data.include?(:STATIC) && !$nuzx_static_enc
      shiny = data.include?(:SHINY) && @battlers[args[0]].shiny?
      map = $PokemonGlobal.nuzlockeData[$game_map.map_id]
	  if !map.nil? && !static && !shiny
	  sideDisplay(_INTL("Your enabled challenges say you cannot catch a wild Pokemon on this map!!"))  
	   next
	  end
	next
	end
	amt=1
	do_it = false
    do_it,amt,start_end = throwing_range_logic(do_it, amt)
	if do_it==true
    $bag.remove(item)
    pbSEPlay("Battle throw")
	can_do = decreaseStamina(2.5*amt)
	next false if can_do == false
    $scene.spriteset.addUserSprite(OWBallThrowSprite.new(start_end,item,$game_map,Spriteset_Map.viewport))
	next true
	else
	next false
	end
  }
)


ItemHandlers::UseFromBox.add(:POKEMONBRUSH,proc { |brush, facingEvent|
   next unless facingEvent
   pkmn = facingEvent.pokemon
   time_delta = pbGetTimeNow.to_i - pkmn.time_last_brush
   next if time_delta < 1800
   pkmn.time_last_brush = pbGetTimeNow.to_i
   pkmn.changeLoyalty("groom",pkmn)
   if pkmn.species_data.egg_groups.include?(:Flying) && rand(255) < 3
    item = ItemData.new(PetBedData::FEATHERS.sample)
    quantity = rand(4)+1
	if $bag.can_add?(item, quantity)
	 $bag.add(item, quantity)
	 itemAnim(item, quantity)
     itemname = (quantity > 1) ? item.name_plural : item.name
	 sideDisplay(_INTL("You brush out {1} {2} from {3}.", quantity, itemname, pkmn.name))
	end 
   
   end 
   pbSEPlay("pet", 80)
   if pkmn.loyalty>=240
	   $scene.spriteset.addUserAnimation(50,facingEvent.x,facingEvent.y,true,1)
   elsif pkmn.loyalty<=30
	   $scene.spriteset.addUserAnimation(36,facingEvent.x,facingEvent.y,true,1)
   else
	   $scene.spriteset.addUserAnimation(34,facingEvent.x,facingEvent.y,true,1)
   end
   pkmn.update_interacted
   brush.decrease_durability(1)
})

ItemHandlers::UseFromBag.add(:HOE,proc{|item, event|
	 facing = $game_player.pbFacingTile($game_player.direction, $game_player)
    terrain = $game_map.terrain_tag(facing[1], facing[2], true)
	next 0 if !$game_map.metadata&.outdoor_map
	can_do = reduceStaminaBasedOnItem(item)
	next 0 if can_do == false
    unless can_hoe_here?(facing, terrain)
	  pbSEPlay("shovelhittingrock")
	  next 0 
	end
    if item.decrease_durability(1)
	  pbShowTipCard(:HOE) if !pbSeenTipCard?(:HOE)
	  pbSEPlay("shovel")
	  pbPlaceBerryPlant(facing[1],facing[2])
      next 2
    end
    next 0

	}
)


def is_consumable_item?(item)
return (GameData::Item.get(item).is_berry? && GameData::Item.get(item).name.include?("Berry")) || GameData::Item.get(item).is_foodwater? || GameData::Item.get(item).name.include?("Potion") || GameData::Item.get(item).id==:REVIVALHERB || GameData::Item.get(item).id==:HEALPOWDER || GameData::Item.get(item).id==:ENERGYPOWDER || GameData::Item.get(item).id==:ENERGYROOT
end

ItemHandlers::UseFromBox.addIf(proc { |item| is_consumable_item?(item) }, proc { |item, event|
    item_data = item.data
	amt=1
	do_it = false
    do_it,amt,start_end = selection_mouse_logic(do_it, amt)
   amt = amt.to_i
   if do_it
   id=$game_map.check_event(*start_end[1])
   if id&.is_a?(Game_Player)
       if item_data.is_foodwater? || item_data.is_berry?
        ret = pbNeoEating(item)
		$bag.remove(item, 1)
        next 2
	   
	   elsif item_data.is_medicine?
        ret = pbNeoMedicine(item)
		$bag.remove(item, 1)
        next 2
	   
	   else
	   
	   end
   elsif id
     event = $game_map.events[id]
     if event.is_a?(Game_PokeEventA)
	    pkmn = event.pokemon
	   if (item.data.field_use == 1 || item.data.field_use == 2 || ItemHandlers.hasOutHandler(item))
	       if item.data.field_use==2
    intret = ItemHandlers.triggerUseFromBag(item)
    if intret >= 0
      bag.remove(item) if intret == 1 && item.data.consumed_after_use?
        next intret
    end
    sideDisplay(_INTL("Can't use that here."))
    next 0
		 elsif item.data.field_use == 1
           if pbCheckUseOnPokemon(item, pkmn, nil)  
        max_at_once = ItemHandlers.triggerUseOnPokemonMaximum(item, pkmn)
        max_at_once = [max_at_once, $bag.quantity(item)].min
		  qty = 1
        qty = pbChooseNumber(_INTL("How many {1} do you want to use?", GameData::Item.get(item).name), max_at_once) if max_at_once > 1
        if qty > 0
        ret = ItemHandlers.triggerUseOnPokemon(item, qty, pkmn, nil)
          sideDisplay(_INTL("You used {1} on {2}.", item.name, pkmn.name)) if ret==true
          sideDisplay(_INTL("{2} doesn't need a {1} right now.", item.name,pkmn.name))  if ret==false
        if ret && item.data.consumed_after_use?
          $bag.remove(item, qty)
          sideDisplay(_INTL("You used your last {1}.", item.name)) if !$bag.has?(item)
		   end
		   end
           else
		   
		   
          sideDisplay(_INTL("{2} doesn't need a {1} right now.", item.name,pkmn.name)) 
         end
       next 2
	   else
        sideDisplay(_INTL("{2} doesn't need {1} right now.", item.name,pkmn.name)) 
	 end
      else
        sideDisplay(_INTL("{2} doesn't need (a) {1} right now.", item.name,pkmn.name)) 
	  
	   end
     end
   end
    end
   if false 
      cmdEat     = -1
      cmdMedicate = -1
      cmdUse      = -1
      commands = []
      commands[cmdUse = commands.length]    = _INTL("Use") if item.data.field_use == 1 || ItemHandlers.hasOutHandler(item)
      commands[cmdMedicate = commands.length]       = _INTL("Use (Self)") if item.data.is_medicine?
	  
	   if item.data.is_foodwater? || item.data.is_berry?
	    if item.data.is_water?
      commands[cmdEat = commands.length]       = _INTL("Drink")
		else
      commands[cmdEat = commands.length]       = _INTL("Eat")
	    end
	   end
	  if commands.length == 1 && commands[0]== _INTL("Use")
        ret = pbUseItem($bag, item, $scene)
        next 2
	  elsif commands.length == 1 && commands[0]== _INTL("Drink")
        ret = pbNeoEating(item)
		$bag.remove(item, 1)
        next 2
	  elsif commands.length == 1 && commands[0]== _INTL("Eat")
        ret = pbNeoEating(item)
		$bag.remove(item, 1)
        next 2
	  elsif commands.length == 1 && commands[0]== _INTL("Use (Self)")
        ret = pbNeoMedicine(item)
		$bag.remove(item, 1)
        next 2
	  else
	  
      commands[commands.length]                 = _INTL("Cancel")
       $PokemonGlobal.alternate_control_mode=true
      command=pbShowCommands(nil,commands,0)
	  if cmdUse >= 0 && command == cmdUse   # Use item
        ret = pbUseItem($bag, item, $scene)
          $PokemonGlobal.alternate_control_mode=false
        next 2
      elsif cmdMedicate>=0 && command==cmdMedicate   # Medicate
        ret = pbNeoMedicine(item)
		$bag.remove(item, 1)
          $PokemonGlobal.alternate_control_mode=false
        next 2
      elsif cmdEat >=0 && command==cmdEat   # Eat
        ret = pbNeoEating(item)
		$bag.remove(item, 1)
          $PokemonGlobal.alternate_control_mode=false
        next 2
      elsif Input.trigger(Input::BACK)   # Eat
          $PokemonGlobal.alternate_control_mode=false
     next 0
	  else
          $PokemonGlobal.alternate_control_mode=false
     next 0
      end

          $PokemonGlobal.alternate_control_mode=false
      end
  end
     next 0
  }
)

def is_a_watering_can?(item)
 item = item.id if item.respond_to?("id")
 return GameData::BerryPlant::WATERING_CANS.include?(item)
end




ItemHandlers::UseFromBox.addIf(proc { |item| is_a_watering_can?(item) }, proc { |item, event|
     facingEvent = event
	 if facingEvent 
	  if facingEvent.name[/berryplant/i]
	     berry_plant = facingEvent.variable
		 if berry_plant
	      pbTurnBerryPlant(facingEvent,berry_plant)
	     end
      elsif facingEvent.is_a?(Game_OVEvent) && facingEvent.type.id == :BERRYPOT
	  end 
	 end
	 can_do = reduceStaminaBasedOnItem(item)
	 next 0 if can_do == false
	 if $game_player.pbFacingTerrainTag.can_can==true && facingEvent.nil? && item.water<100
	   while Input.press?(Input::USE)
	    p_sound = false
	     Graphics.update
		 Input.update
        $scene.update
	    if item.increase_water(5)
	    p_sound = true
	   SoundManager.play_se("can_fill") if p_sound
	     pbWait(15)
        end
		break if !Input.press?(Input::USE)
	  end
      next 2
	end


      if item.water>=10
	   if !facingEvent.nil? && (facingEvent.name[/berryplant/i] || facingEvent.is_a?(Game_OVEvent) && facingEvent.type.id == :BERRYPOT)
	     berry_plant = facingEvent.internal_data
		  if berry_plant
		  req = facingEvent.name[/berryplant/i] ? 9999 : 100
		 if berry_plant.moisture_level<req
        if item.decrease_durability(1)
		    
			    if item.decrease_water(10)
		          berry_plant_refills(berry_plant,item)
                  SoundManager.play_se("can_empty")
				  if facingEvent.is_a?(Game_OVEvent) && facingEvent.type.id == :BERRYPOT
				  text = berry_plant.moisture_level>=100 ? _INTL("It doesn't seem to need anymore water.") : _INTL("No harm in watering it more!")
				  
		          sideDisplay(text) 
				  
				  end 
			    else
                  SoundManager.play_se("glug")
				end
		  end
        else 
		 sideDisplay(_INTL("It doesn't seem to need anymore water.")) if facingEvent.is_a?(Game_OVEvent) && facingEvent.type.id == :BERRYPOT
	    end
         end 
       end
      else
        SoundManager.play_se("glug")
	  end
 



     next 0
  }
)

def berry_plant_refills(berry_plant,item)


   case item.id
     when :WOODENPAIL
		case berry_plant.mulch_id
		 when :DAMPMULCH
          berry_plant.water(20)
		 when :DAMPMULCH2
          berry_plant.water(40)
		 else
          berry_plant.water(10)
		end
	 when :SQUIRTBOTTLE
		case berry_plant.mulch_id
		 when :DAMPMULCH
          berry_plant.water(40)
		 when :DAMPMULCH2
          berry_plant.water(60)
		 else
          berry_plant.water(20)
		end
	 when :SPRAYDUCK
		case berry_plant.mulch_id
		 when :DAMPMULCH
          berry_plant.water(50)
		 when :DAMPMULCH2
          berry_plant.water(70)
		 else
          berry_plant.water(30)
		end
	 when :SPRINKLOTAD
		case berry_plant.mulch_id
		 when :DAMPMULCH
          berry_plant.water(60)
		 when :DAMPMULCH2
          berry_plant.water(80)
		 else
          berry_plant.water(40)
		end
	 when :WAILMERPAIL
		case berry_plant.mulch_id
		 when :DAMPMULCH
          berry_plant.water(80)
		 when :DAMPMULCH2
          berry_plant.water(100)
		 else
          berry_plant.water(60)
		end	  
  end
   
	  



end


def holding_pattern(spriteindex)
   loops=0
  loop do 
  
  Graphics.update           # Updates the screen and game visuals
  Input.update              # Checks for player input
  $scene.update
   break if ($scene.spriteset.usersprites[spriteindex].disposed? || $scene.spriteset.usersprites[spriteindex].nil?)
    loops+=1
	break if loops>20
  end


end

ItemHandlers::UseFromBox.add(:BAIT, proc { |item, event|
	next if $game_temp.in_throwing==true
	amt=1
	do_it = false
    do_it,amt,start_end = throwing_range_logic(do_it, amt)
	if do_it==true
     pbSEPlay("Battle throw")
     can_do = decreaseStamina(1.5*amt)
	 facing = $game_player.pbFacingTile($game_player.direction, $game_player)
     terrain = $game_map.terrain_tag(facing[1], facing[2], true)
     next false if can_do == false
     spriteindex = $scene.spriteset.addUserSprite(OWItemUseSprite.new(start_end,item,$game_map,Spriteset_Map.viewport))
	  holding_pattern(spriteindex)
     $bag.remove(item)
      id=$game_map.check_event(*start_end[1])
	  dir = 0
	  if true
    x_plus = start_end[1][0] - start_end[0][0]
    y_plus = start_end[1][1] - start_end[0][1]
    
    if x_plus != 0 || y_plus != 0
      if x_plus.abs > y_plus.abs
        dir = ((x_plus < 0) ? 1 : 2)
      else
        dir = ((y_plus < 0) ? 3 : 0)
      end
    end
	  end

     if id
      event = $game_map.events[id]
     if event.is_a?(Game_PokeEvent)
      pkmn = event.pokemon
      pbSEPlay("Battle ball hit")
	  pbSafariBattle(nil, nil, pkmn)
	  next true
	 elsif terrain.land_wild_encounters
       pbSEPlay("Battle ball hit")
     pbSpawnEncounter(:Bait, start_end[1][0], start_end[1][1])
	   next true
	 
	 end
     elsif terrain.land_wild_encounters
       pbSEPlay("Battle ball hit")
     pbSpawnEncounter(:Bait, start_end[1][0], start_end[1][1])
	next true
  end
  end



next false
  }
)
ItemHandlers::UseFromBag.add(:BAIT,proc { |item|
   amt = 3
     next 2
	do_it = false
    do_it,amt,start_end = throwing_range_logic(do_it, amt)
	if do_it==true
     pbSEPlay("Battle throw")
     can_do = decreaseStamina(1.5*amt)
     next false if can_do == false
   spriteindex = $scene.spriteset.addUserSprite(OWItemUseSprite.new(start_end,item,$game_map,Spriteset_Map.viewport))
   holding_pattern(spriteindex)
    $bag.remove(item)
   pbSEPlay("Battle ball hit")
     pbSpawnEncounter(:Bait, start_end[1][0], start_end[1][1])
    end 


})
ItemHandlers::UseFromBox.add(:STONE, proc { |item, event|
	next if $game_temp.in_throwing==true
	amt=1
	do_it = false
    do_it,amt,start_end = throwing_range_logic(do_it, amt)
   can_do = decreaseStamina(1.5*amt)
	next false if can_do == false
	if do_it==true
   pbSEPlay("Battle throw")
    $bag.remove(item)
  spriteindex = $scene.spriteset.addUserSprite(OWItemUseSprite.new(start_end,item,$game_map,Spriteset_Map.viewport))
  holding_pattern(spriteindex)
      id=$game_map.check_event(*start_end[1])
	  dir = 0
	  if true
    x_plus = start_end[1][0] - start_end[0][0]
    y_plus = start_end[1][1] - start_end[0][1]
    
    if x_plus != 0 || y_plus != 0
      if x_plus.abs > y_plus.abs
        dir = ((x_plus < 0) ? 1 : 2)
      else
        dir = ((y_plus < 0) ? 3 : 0)
      end
    end
	  end
  if id
   event = $game_map.events[id]
     if event.is_a?(Game_PokeEvent)
   pkmn = event.pokemon
   pbSEPlay("Battle ball hit")
	thefight = pbOverworldCombat
	thefight.player_action(event,item,dir)
	next true
	end
  end
  end


next false
  }
)
ItemHandlers::UseFromBox.add(:CAPTURESTYLER, proc { |item, event|
	if $styler.styler_on==true
     $styler.styler_on=false
    next true
    else
     $styler.styler_on=true
    next true
	end
next false
  }
)

#ItemHandlers::UseFromBox.add(:NOTEBOOK, proc { |item|
 #       pbFadeOutIn {
 #       NoteOpen.openWindow
#		 }
#  }
#)

ItemHandlers::UseFromBox.add(:WATERBOTTLE,proc { |canteen|
  if Input.press?(Input::SHIFT)
	next pbFillCanteen(canteen)
  end 
  next pbCanteen(canteen)
})

def pbCanteen(canteen, can_fill = true )
 return pbFillCanteen(canteen) if canteen.liquid_type.nil? && can_fill
 result = true 
  while Input.press?(Input::USE)
    break if $player.playerwater >= $player.playermaxwater
    result = canteen.drink(1)
    break unless result
    Graphics.update
    Input.update
    $scene.update
    pbWait(5)
  end
  return result
end 

def pbFillCanteen(canteen, drink=nil)
  if drink
   return false if canteen.liquid_type && canteen.liquid_type != drink.id 
   SoundManager.play_se("can_fill")
   result = canteen.fill(drink, 25)
  canteen.decrease_durability(1) if result 
   return result
  end
  facingEvent = $game_player.pbFacingEvent
  if $game_player.pbFacingTerrainTag.can_surf
	drink = ItemData.new(:WATER)
    return false if canteen.liquid_type && canteen.liquid_type != drink.id 
	result = fill_the_canteen(canteen, drink)
    canteen.decrease_durability(1) if result   
    return result
  elsif facingEvent && facingEvent.pokemon && facingEvent.pokemon.is_a?(Pokemon) && can_milk?(facingEvent.pokemon.species)
   if facingEvent.pokemon.can_harvest?
    drink = ItemData.new(:MOOMOOMILK)
    return false if canteen.liquid_type && canteen.liquid_type != drink.id 
    result = fill_the_canteen(canteen, drink, 25)
    canteen.decrease_durability(1) if result   
    facingEvent.pokemon.harvest if result
    return result
   else
    sideDisplay(_INTL("It needs some time to make more milk!"))
	return false
   end 
  end

  return false 
end 

def fill_the_canteen(canteen, item, cap = 100)
  return true if canteen.water >= cap

  filled = false

  while Input.press?(Input::USE)
    Graphics.update
    Input.update
    $scene.update

    break if canteen.water >= cap

    amount = [5, cap - canteen.water].min

    if canteen.fill(item, amount)
      filled = true
      SoundManager.play_se("can_fill")
      pbWait(5)
    end
  end

  filled
end

ItemHandlers::UseFromBox.add(:MACHETE, proc { |item, event|
     facingEvent = event
	 facingEvent = $game_player.pbFacingEventIgnoreOverTrigger if event.nil?
	 next false if facingEvent.nil?
   can_do = decreaseStamina(5)
	next false if can_do == false
 if item.decrease_durability(1)
 if item.durability>0
   #pbSEPlay("Sword")
   start_end = getLandingCoords(1)
   $scene.spriteset.addUserSprite(OWItemUseSprite.new(start_end,item,$game_map,Spriteset_Map.viewport,true))
   id=$game_map.check_event(*start_end[1])
   dir = 0
   x_plus = start_end[1][0] - start_end[0][0]
   y_plus = start_end[1][1] - start_end[0][1]
   if x_plus != 0 || y_plus != 0
      if x_plus.abs > y_plus.abs
        dir = ((x_plus < 0) ? 1 : 2)
      else
        dir = ((y_plus < 0) ? 3 : 0)
      end
   end
   if id
   event = $game_map.events[id]
   if event.is_a?(Game_PokeEvent)
     pkmn = event.pokemon
	 thefight = pbOverworldCombat
	 puts "COmbate"
	 thefight.player_action(event,item,dir)
	 next true
   elsif facingEvent
	   if facingEvent.name[/cuttree/i]
         $stats.cut_count += 1
         pbSmashEvent(facingEvent)
		  next true
	   end
	 
   end
   end
 end
 end

next false
  }
)

ItemHandlers::UseFromBox.add(:BUCKLER, proc { |item, event|
 if $player.playerstamina>=25
 if decreaseStamina(25)
    $player.blocking = true 
    next true
 end 
 end 
next false

  }
)


ItemHandlers::UseFromBox.add(:IRONPICKAXE,proc{|item, event|
     facingEvent = event
	 facingEvent = $game_player.pbFacingEventIgnoreOverTrigger if event.nil?
	 next false if facingEvent.nil?
	can_do = decreaseStamina(8)
	next false if can_do == false

 if item.decrease_durability(1)
	 facingEvent = $game_player.pbFacingEvent
   start_end = getLandingCoords(1)
  $scene.spriteset.addUserSprite(OWItemUseSprite.new(start_end,item,$game_map,Spriteset_Map.viewport,true))
      id=$game_map.check_event(*start_end[1])
	  dir = 0
	  if true
    x_plus = start_end[1][0] - start_end[0][0]
    y_plus = start_end[1][1] - start_end[0][1]
    
    if x_plus != 0 || y_plus != 0
      if x_plus.abs > y_plus.abs
        dir = ((x_plus < 0) ? 1 : 2)
      else
        dir = ((y_plus < 0) ? 3 : 0)
      end
    end
	  end

  if id
   event = $game_map.events[id]
     if event.is_a?(Game_PokeEvent)
   pkmn = event.pokemon
	thefight = pbOverworldCombat
	thefight.player_action(event,item,dir)
	next true
  elsif facingEvent
	   if facingEvent.name[/smashrock/i]
         $stats.cut_count += 1
         pbSmashEvent(facingEvent)
	     next true
	   end
  end
  elsif facingEvent
	   if facingEvent.name[/smashrock/i]
         $stats.cut_count += 1
         pbSmashEvent(facingEvent)
	     next true
	   end
  end
 end

next false

  }
)


ItemHandlers::UseFromBag.add(:POLE,proc{|item, event|
  next 0 unless $player.playerstamina>=4
  if pole_range_logic
   #item.decrease_durability(1)
   next 2 
  end 
  next 0
	}
)


def pole_range_logic
  
  
  max_range = [$player.playerstamina / 4, 3].min
  amt = 1
  charge = 0
  
  
  
  start_end = getLandingCoords(amt)
  return false if start_end.nil?

  position_marker = PositionMarker.new(start_end[1][0],start_end[1][1])
  position_marker.visible = true
 
  $game_temp.in_throwing = true
  $game_temp.no_moving = true 
  $mouse.hide
  cancelled = false 
  loop do
    Graphics.update
    Input.update
    $scene.update
    position_marker.update
    if Input.trigger?(Input::BACK)
    cancelled = true  
    break 
	
	end
    if Input.press?(Input::USE)
      charge += 1

      new_amt =
        if charge >= 65
          3
        elsif charge >= 35
          2
        else
          1
        end
      new_amt = [new_amt, max_range].min
	  
	  
      if new_amt != amt
          new_start_end = getLandingCoords(new_amt)

        unless new_start_end.nil?
          amt = new_amt
         start_end = new_start_end
		  
          position_marker.x = start_end[1][0]
          position_marker.y = start_end[1][1]
          pbSEPlay("GUI storage pick up")
        end
      end
    else
      break
    end
  end

  $game_temp.in_throwing = false
  $game_temp.no_moving = false 
  $mouse.show
  position_marker.dispose
  

  
  
  if cancelled
    return false 
  end
  
  decreaseStamina(amt * 4) if pbJumpToward(amt, true, false, $game_player.direction)
  return true
end

class Interpreter


  def getVariableOther(event_id,map_id=$game_map.map_id)
      return nil if !$PokemonGlobal.eventvars
	  if event_id.is_a?(String)
      return $PokemonGlobal.eventvars[event_id]
	  else
      return $PokemonGlobal.eventvars[[map_id, event_id]]
	  end
  end


  def setVariableOther(setting,event_id,map_id=$game_map.map_id)
      $PokemonGlobal.eventvars = {} if !$PokemonGlobal.eventvars
	  if event_id.is_a?(String)
      $PokemonGlobal.eventvars[event_id] = setting
	  else
      $PokemonGlobal.eventvars[[map_id, event_id]] = setting
	  end
  end
  
  def deleteVariableOther(event_id,map_id=$game_map.map_id)
	  if event_id.is_a?(String)
      $PokemonGlobal.eventvars.delete(event_id)
	  else
      $PokemonGlobal.eventvars.delete([map_id, event_id])
	  end
  end
end



class Game_Map
  def can_dig_here?(coords, terrain)
	 $PokemonGlobal.collection_maps[$game_map.map_id] ||= []
	return false if coords.nil?
	return false if terrain.nil?
    return false if $PokemonGlobal.collection_maps[$game_map.map_id].include?(coords)
	return terrain.can_dig
  end 
  def can_hoe_here?(coords, terrain)
	return false if coords.nil?
	return false if terrain.nil?
	x, y = coords 
	return false unless pbObjectIsPossible(x,y)
	return terrain.can_hoe
  
  
  end 

  
end 

def pbDigUpBerryPlant(berry_event)
    berry_plant = get_other_data(berry_event.id)
	berry_data = berry_plant.berry
    return false unless berry_plant
	return false unless berry_plant.growth_stage == 1
	if !$bag.can_add?(berry_data, 1)
	  sideDisplay("You do not have enough space!")
	  return false 
	end 
	berry_id = berry_plant.berry_id
	return false if berry_id.nil?
    berry = GameData::Item.get(berry_id)
	result = (rand(100) < 50 || $player.is_it_this_class?(:GARDENER))
	
	berry_plant.reset
	if result
	  sideDisplay("The dug up #{berry.name} was in good enough condition to keep.")
      $bag.add(berry_data, 1)
	  itemAnim(berry_data,qnt)
	else
	  sideDisplay("The dug up #{berry.name} broke apart while digging it up.")
	end 
    return true 
end 

def pbDigTheGround(coords, shovel=true)
    if $PokemonGlobal.collection_maps[$game_map.map_id].include?(coords)
      pbSEPlay("shovelhittingrock") if shovel
	  return false
    end 	
       shovel ? pbSEPlay("shovel") : pbSEPlay("Anim/PRSFX- Dig2")
      pbCollectionMain2
	  amt = 1
	  amt = 2 if $player.is_it_this_class?(:COLLECTOR)
	  $PokemonGlobal.collection_maps[$game_map.map_id] << coords
	  return true 

end 




ItemHandlers::UseFromBag.add(:SHOVEL,proc{|item, event|
	 $PokemonGlobal.collection_maps[$game_map.map_id] ||= []
	 facingEvent = event
	 facingEvent = $game_player.pbFacingEventIgnoreOverTrigger if event.nil?
	 facing = $game_player.pbFacingTile($game_player.direction, $game_player)
	 coords = [facing[1],facing[2]]
     terrain = $game_map.terrain_tag(facing[1], facing[2], true)
     berry_tree = (facingEvent && facingEvent.name.match?(/berryplant/i))
	 
	 
	 next 0 unless $game_map.can_dig_here?(coords, terrain)
	 can_do = reduceStaminaBasedOnItem(item)
	 next 0 if can_do == false
     if item.decrease_durability(1)
        pbShowTipCard(:SHOVEL) if !pbSeenTipCard?(:SHOVEL)
        if terrain.can_dig && !berry_tree
		  next 2 if pbDigTheGround(coords)
		elsif berry_tree
		  next 2 if pbDigUpBerryPlant(facingEvent)
		end 
	 end
     next 0
 
	}
)





def pbHPItem(pkmn, restoreHP, scene)
  if !pkmn.able? || pkmn.hp == pkmn.totalhp
    scene.pbDisplay(_INTL("It won't have any effect."))
    return false
  end
  hpGain = pbItemRestoreHP(pkmn, restoreHP)
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.", pkmn.name, hpGain))
  return true
end
def pbItemRestoreHP(pkmn, restoreHP)
  newHP = pkmn.hp + restoreHP
  newHP = pkmn.totalhp if newHP > pkmn.totalhp
  hpGain = newHP - pkmn.hp
  pkmn.hp = newHP
  return hpGain
end

ItemHandlers::UseOnPokemon.add(:POTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 20, scene)
})

ItemHandlers::UseOnPokemon.copy(:POTION, :BERRYJUICE, :SWEETHEART)
ItemHandlers::UseOnPokemon.copy(:POTION, :RAGECANDYBAR) if !Settings::RAGE_CANDY_BAR_CURES_STATUS_PROBLEMS

ItemHandlers::UseOnPokemon.add(:SUPERPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 60, scene)
})

ItemHandlers::UseOnPokemon.add(:HYPERPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 100, scene)
})

ItemHandlers::UseOnPokemon.add(:MAXPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, pkmn.totalhp - pkmn.hp, scene)
})

ItemHandlers::UseOnPokemon.add(:FRESHWATER, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 30, scene)
})

ItemHandlers::UseOnPokemon.add(:SODAPOP, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 60, scene)
})

ItemHandlers::UseOnPokemon.add(:LEMONADE, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 80, scene)
})

ItemHandlers::UseOnPokemon.add(:WEAKPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 10, scene)
})

ItemHandlers::UseOnPokemon.add(:MOOMOOMILK, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 50, scene)
})

ItemHandlers::UseOnPokemon.add(:ORANBERRY, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 10, scene)
})

ItemHandlers::UseOnPokemon.add(:SITRUSBERRY, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, pkmn.totalhp / 10, scene)
})



ItemHandlers::UseOnPokemon.add(:SUSPO,proc { |item, qty, pkmn, scene|
       chance = rand(4)
        if pkmn.happiness >= 75
		 if 0 == chance
          pkmn.species = pkmn.species_data.get_baby_species
          pkmn.exp           = 0
          pkmn.calc_stats
          pkmn.name           = _INTL("Egg")
          pkmn.steps_to_hatch = pkmn.species_data.hatch_steps
          pkmn.food  = 100
          pkmn.water  = 100
          pkmn.age  = 1
          pkmn.lifespan  = 100
		  pkmn.permaFaint = false if pkmn.permaFaint==true 
          next true
		 else
         scene.pbDisplay(_INTL("It was indigested, but had no effect."))
          next true
		 end
        else
         scene.pbDisplay(_INTL("It doesn't like you enough to reincarnate."))
         next false
        end
})



ItemHandlers::UseInField.add(:CALENDAR,proc { |item|
  openCalendar
  next 2
})


Battle::ItemEffects::HPHeal.add(:ARGOSTBERRY,
  proc { |item, battler, battle, forced|
    next false if battler.able
    battle.pbCommonAnimation("EatBerry", battler) if !forced
    battler.hp = 1
    itemName = GameData::Item.get(item).name
    if forced
      PBDebug.log("[Item triggered] Forced consuming of #{itemName}")
      battle.pbDisplay(_INTL("{1}'s was revived.", battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1} was revived!", battler.pbThis, itemName))
    end
    next true
  }
)


ItemHandlers::UseOnPokemon.add(:ARGOSTBERRY, proc { |item, qty, pkmn, scene|
    next false if !pkmn.fainted?
    next false if pkmn.permaFaint
    pkmn.hp = 1
    pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s was revived.", pkmn.name))
  next true
})


ItemHandlers::UseFromBag.add(:BAIT, proc { |item|
  next 2
})
ItemHandlers::UseInField.add(:BAIT,proc { |item|
  next true
})


ItemHandlers::UseFromBag.add(:GLASSBOTTLE,proc { |item|
  next 2
})

ItemHandlers::UseFromBag.add(:IRONAXE,proc { |item|
  next 2
})

 def can_shear?(species)
   GameData::Species.get(species).shearable?
 end 

 def can_milk?(species)
   GameData::Species.get(species).milkable?
 end 
 
 def fill_container(container, item)
  item.set_bottle(container)
  $bag.add(item, 1)
  itemAnim(item, 1) 
  $bag.remove(container, 1)
end

ItemHandlers::UseInField.add(:SHEARS,proc { |shears|
  facingEvent = $game_player.pbFacingEvent
if facingEvent && facingEvent.pokemon && facingEvent.pokemon.is_a?(Pokemon) && can_shear?(facingEvent.pokemon.species)
   if facingEvent.pokemon.can_harvest?
    item = ItemData.new(:WOOL)
	amt = rand(6)+1
    $bag.add(item, amt)
    itemAnim(item, amt) 
    shears.decrease_durability(1)
	 facingEvent.pokemon.harvest
    next true
   else
    sideDisplay(_INTL("It needs some time to make more wool!"))
	next false
   end 
end
})

ItemHandlers::UseInField.add(:WHISTLE,proc { |shears|
    followers = $DynamicEvents.allied_mobs_for_map
    next false if followers.empty?
	pbSEPlay("whistle", 80)
    x,y = get_tile_mouse_on
	$scene.spriteset.addUserAnimation(5,x,y,true,1)
	followers.each do |event|
     pkmn = event.pokemon
     next if pkmn.nil?

     distance = (x - event.x) ** 2 + (y - event.y) ** 2
     if distance <= 16
	  event.wake_up
      pbSelectThisPokemon(pkmn) 
	 end 
    end
 
})


ItemHandlers::UseInField.add(:GLASSBOTTLE,proc { |container|
  facingEvent = $game_player.pbFacingEvent
  if $game_player.pbFacingTerrainTag.can_surf
	item = ItemData.new(:WATER)
	 fill_container(container, item)
    next true
  elsif facingEvent && facingEvent.pokemon && facingEvent.pokemon.is_a?(Pokemon) && can_milk?(facingEvent.pokemon.species)
   if facingEvent.pokemon.can_harvest?
    item = ItemData.new(:MOOMOOMILK)
	 fill_container(container, item)
	 facingEvent.pokemon.harvest
    next true
   else 
    sideDisplay(_INTL("It needs some time to make more milk!"))
	next false
   end 
  end
	next false
})


ItemHandlers::UseInField.add(:BOWL,proc { |item2|
if $game_player.pbFacingTerrainTag.can_surf
     message=(_INTL("Drink some unpurified water?"))
    if pbConfirmMessage(message)
        item2.decrease_durability(1)
        increaseWater(10)
        damagePlayer(10.0)
	next true
	end
	next false
end
	next false
})

ItemHandlers::UseInField.add(:IRONAXE,proc { |item|
if $game_player.pbFacingTerrainTag.can_knockdown
     message=(_INTL("Want to knock down some branches?"))
    if pbConfirmMessage(message)
       item.decrease_durability(1)
       $bag.add(:WOODENSTICKS,(rand(2)+1))
	next true
	end
	next false
   else
	next false
end
})



def pbBait
  viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  viewport.z = 99999
  count = 0
  viewport.color.red   = 255
  viewport.color.green = 0
  viewport.color.blue  = 0
  viewport.color.alpha -= 10
  alphaDiff = 12 * 20 / Graphics.frame_rate
  loop do
    if count == 0 && viewport.color.alpha < 128
      viewport.color.alpha += alphaDiff
    elsif count > Graphics.frame_rate / 4
      viewport.color.alpha -= alphaDiff
    else
      count += 1
    end
    Graphics.update
    Input.update
    pbUpdateSceneMap
    break if viewport.color.alpha <= 0
  end
  viewport.dispose
  enctype = $PokemonEncounters.encounter_type
  if !enctype || !$PokemonEncounters.encounter_possible_here?
    pbMessage(_INTL("There appears to be nothing here..."))
  else
   pbMessage(_INTL("You throw the bait on the ground, and a POKeMON appeared!"))
	$game_temp.in_safari=true
   if pbEncounter(enctype)
   end
	$game_temp.in_safari=false
  end
end




def pbHasCrate?
 return true if $bag.has?(:PORTABLEPC)
 return true if $bag.has?(:ITEMCRATE)
end

def pbHasGrinder?
 return true if $bag.has?(:GRINDER)
 return true if $bag.has?(:ELECTRICGRINDER)
end

def pbHasApricorn?
 return true if $bag.has?(:APRICORNCRAFTING)
 return true if $bag.has?(:APRICORNMACHINE)
end

def pbHasFurnace?
 return true if $bag.has?(:FURNACE)
 return true if $bag.has?(:ELECTRICFURNACE)
end

def pbHasCrafting?
 return true if $bag.has?(:CRAFTINGBENCH)
 return true if $bag.has?(:UPGRADEDCRAFTINGBENCH)
end

ItemHandlers::UseOnPokemon.add(:GRITDUST,proc { |item, qty,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_ATTACK)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Attack increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})

ItemHandlers::UseOnPokemon.add(:GRITGRAVEL,proc { |item, qty,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_ATTACK)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Attack increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})
ItemHandlers::UseOnPokemon.add(:GRITPEBBLE,proc { |item, qty,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_ATTACK)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Attack increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})

ItemHandlers::UseOnPokemon.add(:GRITROCK,proc { |item, qty,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_ATTACK)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Attack increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})



ItemHandlers::UseOnPokemon.add(:SPEEDCOMET,proc { |item, qty,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:SPEED,40)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Speed increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})

ItemHandlers::UseOnPokemon.add(:DEFENDCOMET,proc { |item, qty,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_DEFENSE,20)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pbJustRaiseEffortValues(pkmn,:DEFENSE,20)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Defenses increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})

ItemHandlers::UseOnPokemon.add(:BALANCEDCOMET,proc { |item, qty,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:ATTACK,10)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_ATTACK,10)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_DEFENSE,10)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pbJustRaiseEffortValues(pkmn,:DEFENSE,10)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pbJustRaiseEffortValues(pkmn,:SPEED,10)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pbJustRaiseEffortValues(pkmn,:HP,10)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Attack increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})

ItemHandlers::UseOnPokemon.add(:ATKCOMET,proc { |item, qty,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:ATTACK,20)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_ATTACK,20)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Attack increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})


ItemHandlers::UseInField.add(:LCLOAK,proc{|item|
  if !$game_variables[256]==(:LCLOAK)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:LCLOAK)
  else
  $game_variables[256]=(:LCLOAK) 
  end
    next 2
})

ItemHandlers::UseInField.add(:PROTECTIVEVEST,proc{|item|
  if !$game_variables[256]==(:PROTECTIVEVEST)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:PROTECTIVEVEST)
  else
  $game_variables[256]=(:PROTECTIVEVEST) 
  end
    next 2
})

ItemHandlers::UseInField.add(:SEASHOES,proc{|item|
  if !$game_variables[256]==(:SEASHOES)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:SEASHOES)
  else
  $game_variables[256]=(:SEASHOES) 
  end
    next 2
})

ItemHandlers::UseInField.add(:LJACKET,proc{|item|
  if !$game_variables[256]==(:LJACKET)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:LJACKET)
  else
  $game_variables[256]=(:LJACKET) 
  end
    next 2
})

ItemHandlers::UseInField.add(:SSHIRT,proc{|item|
  if !$game_variables[256]==(:SSHIRT)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:SSHIRT)
  else
  $game_variables[256]=(:SSHIRT) 
  end
    next 2
})

ItemHandlers::UseInField.add(:GHOSTMAIL,proc{|item|
  if !$game_variables[256]==(:GHOSTMAIL)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:GHOSTMAIL)
  else
  $game_variables[256]=(:GHOSTMAIL) 
  end
    next 2
})

ItemHandlers::UseInField.add(:IRONARMOR,proc{|item|
  if !$game_variables[256]==(:IRONARMOR)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:IRONARMOR)
  else
  $game_variables[256]=(:IRONARMOR) 
  end
    next 2
})


ItemHandlers::UseInField.add(:BERRYBLENDER,proc{|item|
  pbCommonEvent(29)
    next 1
})

ItemHandlers::UseFromBag.add(:LVLDETECTOR,proc{|item|
        if $game_switches[240]==false
         $game_switches[240]=true
        elsif $game_switches[240]==true
         $game_switches[240]=false
        end
    next 1
})

ItemHandlers::UseInBattle.add(:POISONDART,proc { |item,battler,battle|
   if battler && battler.status == :NONE || !battler.pbHasType?(:STEEL)
     battle.pbDisplay(_INTL("You shoot a dart at the Pokemon, poisoning it."))
     battler.pbPoison(user) if target.pbCanPoison?(user,false,self)
     next true
   else
    battle.pbDisplay(_INTL("It won't have any effect."))
     next false
   end
   next true
})

ItemHandlers::UseInBattle.add(:SLEEPDART,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 ability1=GameData::Ability.try_get(:INSOMNIA)
 ability2=GameData::Ability.try_get(:VITALSPIRIT)
  if battler.status != :NONE || battler.ability==ability1 || battler.ability==ability2
     next false
  else
     battle.pbDisplay(_INTL("Enemy {1} was put to sleep by the {2}!",battler.name,itemname))
     battler.pbSleep
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:PARALYZDART,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:GROUND
  if battler.status != :NONE || battler.pbHasType?(:GROUND)
     battle.pbDisplay(_INTL("It won't have any effect."))
     next false
  else
     battle.pbDisplay(_INTL("Enemy {1} was paralyzed by the {2}!",battler.name,itemname))
     battler.pbParalyze(battler)
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:ICEDART,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:ICE
  if battler.status != :NONE  || battler.pbHasType?(:ICE)
     battle.pbDisplay(_INTL("It won't have any effect."))
     next false
  else
     battle.pbDisplay(_INTL("Enemy {1} was frozen solid by the {2}!",battler.name,itemname))
     battler.pbFreeze(battler)
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:FIREDART,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:FIRE
  if battler.status != :NONE || battler.pbHasType?(:FIRE)
     battle.pbDisplay(_INTL("It won't have any effect."))
     next false
  else
     scene.pbDisplay(_INTL("Enemy {1} was burned by the {2}!",battler.name,itemname))
     battler.pbBurn(battler)
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:MACHETE,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
  if battler.hp==1
       battle.pbReduceHP(1)
	   scene.pbDisplay(_INTL("You slashed at Enemy {1} with the {2}!",battler.name,itemname))
	   pbCookMeat(battler)
	   next false
  else
     battle.pbDisplay(_INTL("It won't have any effect."))
     next false
  end
})

ItemHandlers::UseInBattle.add(:RUSTEDPICKAXE,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:GROUND
 typeb=PBTypes::ROCK
  if battler.type1==type || battler.type2==typeb 
     battler.pbReduceHP(battler.totalhp/3)
	   battle.pbDisplay(_INTL("You axed at Enemy {1} with the {2}!",battler.name,itemname))
     next false
  else
     battle.pbDisplay(_INTL("It won't have any effect."))
     next true
  end
})

ItemHandlers::UseInBattle.add(:PICKAXE,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:GROUND
 typeb=PBTypes::ROCK
  if battler.type1==type || battler.type2==typeb 
     battler.pbReduceHP(battler.totalhp/5)
	   battle.pbDisplay(_INTL("You axed at Enemy {1} with the {2}!",battler.name,itemname))
     next false
  else
     battle.pbDisplay(_INTL("It won't have any effect."))
     next true
  end
})














