
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
	puts item_data.is_hmitem?
    if item_data.is_dart?
		return decreaseStamina(4)
    elsif item_data.is_poke_ball?
	return decreaseStamina(8)
    elsif item_data.is_weapon?
	  case item
	   when :MACHETE
	  return decreaseStamina(5)
	   when :STONE
	  return decreaseStamina(4)
	   when :BAIT
	 return decreaseStamina(4)
	  end
    elsif item_data.is_hmitem?
     case item
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
	  puts "SHE CALLS MEEEE"
	  return decreaseStamina(5)
     when :POLE
	  return decreaseStamina(5)
	  else
	  return decreaseStamina(5)
     end
	else
     case item
     when :SNATCHER
		return decreaseStamina(4)
     when :SNATCHER
	 else
		return decreaseStamina(1)
     end
	
    end
    return true
end




def powerGenerators(type)
action = []
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=0
end
case type
when :COALGENERATOR
commands=[]
commands.push(_INTL"Fuel")
commands.push(_INTL("Check Power")) 
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
	  #Fueling
elsif commandMail == 1
   pbMessage(_INTL("#{GameData::Item.try_get(type).name} has #{localMeter} power."))
elsif commandMail == 2
 #Connection UI
elsif commandMail == 3
 if pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(type).name}?"))
	  $bag.add(type)
	  if !$map_factory
  $game_map.removeThisEventfromMap(key_id)
else
  mapId = $game_map.map_id
  $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
end
      deletefromSIData(key_id)
 end
else
	 return -1
end




when :SOLARGENERATOR
commands=[]
commands.push(_INTL("Check Power")) 
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
   pbMessage(_INTL("#{GameData::Item.try_get(type).name} has #{localMeter} power."))
elsif commandMail == 1
 #Connection UI
elsif commandMail == 2
 if pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(type).name}?"))
	  $bag.add(type)
	  if !$map_factory
  $game_map.removeThisEventfromMap(key_id)
else
  mapId = $game_map.map_id
  $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
end
      deletefromSIData(key_id)
 end
else
	 return -1
end





when :WINDGENERATOR
commands=[]
commands.push(_INTL("Check Power")) 
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
   pbMessage(_INTL("#{GameData::Item.try_get(type).name} has #{localMeter} power."))
elsif commandMail == 1
 #Connection UI
elsif commandMail == 2
 if pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(type).name}?"))
	  $bag.add(type)
	  if !$map_factory
  $game_map.removeThisEventfromMap(key_id)
else
  mapId = $game_map.map_id
  $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
end
      deletefromSIData(key_id)
 end
else
	 return -1
end






when :HYDROGENERATOR
commands=[]
commands.push(_INTL("Check Power")) 
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
   pbMessage(_INTL("#{GameData::Item.try_get(type).name} has #{localMeter} power."))
elsif commandMail == 1
 #Connection UI
elsif commandMail == 2
 if pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(type).name}?"))
	  $bag.add(type)
	  if !$map_factory
  $game_map.removeThisEventfromMap(key_id)
else
  mapId = $game_map.map_id
  $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
end
      deletefromSIData(key_id)
 end
else
	 return -1
end






when :POKEGENERATOR
commands=[] 
commands.push(_INTL("Assign")) 
commands.push(_INTL("Check Power")) 
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
elsif commandMail == 1
   pbMessage(_INTL("#{GameData::Item.try_get(type).name} has #{localMeter} power."))
elsif commandMail == 2
 #Connection UI
elsif commandMail == 3
 if pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(type).name}?"))
	  $bag.add(type)
	  if !$map_factory
  $game_map.removeThisEventfromMap(key_id)
else
  mapId = $game_map.map_id
  $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
end
      deletefromSIData(key_id)
 end
else
	 return -1
end







end

end




def powerConsumersCrafting(type)
action = []
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=0
end

#pbSetSelfSwitch(this_event, "A", true)
commands=[]
commands.push(_INTL"Craft")
commands.push(_INTL("Turn Off")) 
commands.push(_INTL("Check Power")) 
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
	  pbCraftingBench(type)
elsif commandMail == 1
 #Turn On/Off
elsif commandMail == 2
   pbMessage(_INTL("#{GameData::Item.try_get(type).name} has #{localMeter} power."))
elsif commandMail == 3
 #Connection UI
elsif commandMail == 4
 if pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(type).name}?"))
	  $bag.add(type)
	  if !$map_factory
  $game_map.removeThisEventfromMap(key_id)
else
  mapId = $game_map.map_id
  $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
end
      deletefromSIData(key_id)
 end
else
	 return -1
end


end

def powerConsumersStorage(type)
action = []
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=0
end

#pbSetSelfSwitch(this_event, "A", true)
commands=[]
commands.push(_INTL"Craft")
commands.push(_INTL("Turn Off")) 
commands.push(_INTL("Check Power")) 
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
	  pbCraftingBench(type)
elsif commandMail == 1
 #Turn On/Off
elsif commandMail == 2
   pbMessage(_INTL("#{GameData::Item.try_get(type).name} has #{localMeter} power."))
elsif commandMail == 3
 #Connection UI
elsif commandMail == 4
 if pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(type).name}?"))
	  $bag.add(type)
	  if !$map_factory
  $game_map.removeThisEventfromMap(key_id)
else
  mapId = $game_map.map_id
  $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
end
      deletefromSIData(key_id)
 end
else
	 return -1
end


end



def powerTransmitters(type)
action = []
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=0
end
commands=[]
commands.push(_INTL("Check Power")) 
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
   pbMessage(_INTL("#{GameData::Item.try_get(type).name} has #{localMeter} power."))
elsif commandMail == 1
 #Connection UI
elsif commandMail == 2
 if pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(type).name}?"))
	  $bag.add(type)
	  if !$map_factory
  $game_map.removeThisEventfromMap(key_id)
else
  mapId = $game_map.map_id
  $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
end
      deletefromSIData(key_id)
end
else
	 return -1
end





end

def item_crates
action = []
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
storage = interp.getVariable
$PokemonGlobal.itemStorageSystems = {} if $PokemonGlobal.itemStorageSystems.nil?



if !storage
commands0=[]
if $PokemonGlobal.itemStorageSystems.keys.length>0
$PokemonGlobal.itemStorageSystems.keys.each do |i|
   next if $PokemonGlobal.itemStorageSystems[i][2]==true
commands0.push("#{i}")
end
if commands0.length > 0
commands0.push("[ADD NEW]")
end
commandMail0 = pbMessage(_INTL("Which Crate is this?"),commands0, -1)
storage_key = $PokemonGlobal.itemStorageSystems.keys[commandMail0]
storage = $PokemonGlobal.itemStorageSystems[storage_key]
storage[2]=true
interp.setVariable(storage)
storage = interp.getVariable
inventory = storage[0]
end
end



if !storage
creation=PCItemStorage.new
storage_key = creation.name
$PokemonGlobal.itemStorageSystems[storage_key] = [creation,false]
storage = $PokemonGlobal.itemStorageSystems[storage_key]
storage[2]=true
interp.setVariable(storage)
storage = interp.getVariable
end

if storage
inventory = storage[0]
end


if Input.press?(Input::SHIFT)
pickMeUp(key_id,:ITEMCRATE)
else

commands=[]
commands.push(_INTL"Use Storage ")
commands.push(_INTL("Set Storage Name")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
	  pbMoveRoute(this_event, [PBMoveRoute::Graphic,"crateileft.png",0,this_event.direction,0])
     @move_route_waiting = true if !$game_temp.in_battle
     pbSEPlay("Voltorb Flip tile")
     pbTrainerCrate(inventory)
     pbMoveRoute(this_event, [PBMoveRoute::Graphic,"crateidown.png",0,this_event.direction,0])
     @move_route_waiting = true if !$game_temp.in_battle
elsif commandMail == 1
      name = pbFreeTextNoWindow("#{inventory.name}",false,256,Graphics.width,false)
      if name != "" && !name.nil?
	    inventory.changeName(name)
	   pbMessage(_INTL("#{inventory.name} is now #{name}."))
	  else
	   pbMessage(_INTL("#{inventory.name} has not had their name changed."))
	  end
elsif commandMail == 3
 if pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(:ITEMCRATE).name}?"))
	  $bag.add(:ITEMCRATE)
     storage[2]=false
	  if !$map_factory
  $game_map.removeThisEventfromMap(key_id)
else
  mapId = $game_map.map_id
  $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
end
      deletefromSIData(key_id)
 end
else
	 return -1
end
end




end


def pokemon_crates


action = []
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
storage = interp.getVariable
$PokemonGlobal.pokemonStorageSystems = {} if $PokemonGlobal.pokemonStorageSystems.nil?
if !storage
commands0=[]
if $PokemonGlobal.pokemonStorageSystems.keys.length>0
$PokemonGlobal.pokemonStorageSystems.keys.each do |i|
   next if $PokemonGlobal.pokemonStorageSystems[i][2]==true
commands0.push("#{i}")
end
if commands0.length > 0
commands0.push("[ADD NEW]")
end
commandMail0 = pbMessage(_INTL("Which Crate is this?"),commands0, -1)
storage_key = $PokemonGlobal.pokemonStorageSystems.keys[commandMail0]
storage = $PokemonGlobal.pokemonStorageSystems[storage_key]
storage[2]=true
interp.setVariable(storage)
storage = interp.getVariable
inventory = storage[0]
end
end
if !storage
creation=PokemonStorage.new
storage_key = creation.name
$PokemonGlobal.pokemonStorageSystems[storage_key] = [creation,false]
storage = $PokemonGlobal.pokemonStorageSystems[storage_key]
storage[2]=true
interp.setVariable(storage)
storage = interp.getVariable
end
if storage
inventory = storage[0]
end


if Input.press?(Input::SHIFT)
pickMeUp(key_id,:PKMNCRATE)
else

commands=[]
commands.push(_INTL"Use Storage ")
commands.push(_INTL("Set Storage Name")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
	  pbMoveRoute(this_event, [PBMoveRoute::Graphic,"crateleft.png",0,this_event.direction,0])
     @move_route_waiting = true if !$game_temp.in_battle
     pbSEPlay("Voltorb Flip tile")
     pbStorageCrateMenu(inventory)
	 $PokemonStorage = inventory
     pbMoveRoute(this_event, [PBMoveRoute::Graphic,"cratedown.png",0,this_event.direction,0])
     @move_route_waiting = true if !$game_temp.in_battle
elsif commandMail == 1
      name = pbFreeTextNoWindow("#{inventory.name}",false,256,Graphics.width,false)
      if name != "" && !name.nil?
	    inventory.changeName(name)
	   pbMessage(_INTL("#{inventory.name} is now #{name}."))
	  else
	   pbMessage(_INTL("#{inventory.name} has not had their name changed."))
	  end
elsif commandMail == 3
 if pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(:PKMNCRATE).name}?"))
	  $bag.add(:PKMNCRATE)
	 if $PokemonStorage == inventory
      $PokemonGlobal.pokemonStorageSystems.keys.each do |i|
      next if $PokemonGlobal.pokemonStorageSystems[i][2]==false
        $PokemonStorage = $PokemonGlobal.pokemonStorageSystems[i][0]
	     pbMessage(_INTL("Storage has been redirected to #{$PokemonStorage.name}."))
      end
	  if $PokemonStorage == inventory
	   $PokemonStorage == nil
	  end
	 end 

     storage[2]=false
	  if !$map_factory
  $game_map.removeThisEventfromMap(key_id)
else
  mapId = $game_map.map_id
  $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
end
      deletefromSIData(key_id)
 end
else
	 return -1
end
end







end

def leggomyeggo
elec = false
action = []
this_event = pbMapInterpreter.get_self
key_id = this_event.id
pkmn = this_event.type
if true
hpiv = pkmn.iv[:HP] & 15
ativ = pkmn.iv[:ATTACK] & 15
dfiv = pkmn.iv[:DEFENSE] & 15
saiv = pkmn.iv[:SPECIAL_ATTACK] & 15
sdiv = pkmn.iv[:SPECIAL_DEFENSE] & 15
spiv = pkmn.iv[:SPEED] & 15
hpev = pkmn.ev[:HP] & 15
atev = pkmn.ev[:ATTACK] & 15
dfev = pkmn.ev[:DEFENSE] & 15
saev = pkmn.ev[:SPECIAL_ATTACK] & 15
sdev = pkmn.ev[:SPECIAL_DEFENSE] & 15
spev = pkmn.ev[:SPEED] & 15
end

if Input.press?(Input::SHIFT)
pickMeUp(key_id,type)
else

commands=[]
commands.push(_INTL"Check the Egg")
commands.push(_INTL("Pat the Egg")) 
commands.push(_INTL("Shake the Egg"))
commands.push(_INTL("Pick Up the Egg"))
commands.push(_INTL("Store Egg in Inventory"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
   pbEggCheck(pkmn)
 elsif commandMail == 1
   pbMessage(_INTL("The Egg seems to bounce slightly."))
   if pkmn.steps_to_hatch >= 3000
    pkmn.steps_to_hatch -= 100
    pkmn.happiness += 6
    pkmn.loyalty += 6
   elsif pkmn.steps_to_hatch >= 2000
    pkmn.steps_to_hatch -= 75
    pkmn.happiness += 6
    pkmn.loyalty += 6
   elsif pkmn.steps_to_hatch < 1000
    pkmn.steps_to_hatch -= 50
    pkmn.happiness += 6
    pkmn.loyalty += 6
   end
 elsif commandMail == 2
   pbMessage(_INTL("You shake the Egg. It does not do anything in response."))
   if pkmn.steps_to_hatch >= 3750
    pkmn.steps_to_hatch -= 200
    pkmn.happiness += 2
    pkmn.loyalty -= 1
   elsif pkmn.steps_to_hatch >= 3000
    pkmn.steps_to_hatch -= 150
    pkmn.happiness += 2
    pkmn.loyalty -= 1
   elsif pkmn.steps_to_hatch >= 2500
    pkmn.steps_to_hatch -= 100
    pkmn.happiness += 2
    pkmn.loyalty -= 1
   end
 
 elsif commandMail == 3
  pickMeUp(key_id,pkmn)

 elsif commandMail == 4
 if !$player.party_full?
 if pbConfirmMessage(_INTL("Would you like to pick up the Egg?"))
	  $player.party.push(egg)
	  if !$map_factory
  $game_map.removeThisEventfromMap(key_id)
else
  mapId = $game_map.map_id
  $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
end
      deletefromSIData(key_id)
end
 else
   pbMessage(_INTL("You do not have enough space for the egg."))
 end

 else
	 return -1
end










end
end

def pbGetObjectFunc(object,event)
elec = false
action = []
this_event = pbMapInterpreter.get_self
key_id = this_event.id
case object
when "Egg"

return
when :CRAFTINGBENCH
action = [_INTL("Craft"),object] 

when :UPGRADEDCRAFTINGBENCH
action = [_INTL("Craft"),object] 

when :APRICORNCRAFTING
action = [_INTL("Craft"),object] 

when :FURNACE
action = [_INTL("Craft"),object] 

when :CAULDRON
pbCommonEvent(17)
return

when :GRINDER
action = [_INTL("Craft"),object] 

when :MEDICINEPOT
action = [_INTL("Craft"),object] 

when :ELECTRICPRESS
  powerConsumersCrafting(object)

return

when :ELECTRICICEBOX
  powerConsumersStorage(object)

return

when :SEWINGMACHINE
  powerConsumersCrafting(object)

return

when :APRICORNMACHINE
  powerConsumersCrafting(object)

return

when :ELECTRICFURNACE
  powerConsumersCrafting(object)

return

when :ELECTRICGRINDER
  powerConsumersCrafting(object)

return

when :COALGENERATOR
  powerGenerators(object)

return

when :SOLARGENERATOR
  powerGenerators(object)

return

when :WINDGENERATOR
  powerGenerators(object)

return

when :HYDROGENERATOR
  powerGenerators(object)

return

when :POKEGENERATOR
  powerGenerators(object)

return

when :MEDICINEPOT
action = [_INTL("Craft"),object] 
elec = true

when :MACHINEBOX
  powerTransmitters(object)
return
when :ITEMCRATE
item_crates
return

when :PKMNCRATE
pokemon_crates
return

when :BEDROLL
if Input.press?(Input::SHIFT)
pickMeUp(key_id,object)
else
pbBedCore()
end
return

when :PORTABLECAMP
pbMessage(_INTL("It's a Campsite Tent."))
when "CampsiteDoor"
$PokemonGlobal.pokecenterX = pbMapInterpreter.get_self.x
$PokemonGlobal.pokecenterY = pbMapInterpreter.get_self.y+1
$PokemonGlobal.pokecenterMapId = $game_map.map_id
$PokemonGlobal.pokecenterDirection = 2
    pbFadeOutIn {
      $game_temp.player_new_map_id    = 398
      $game_temp.player_new_x         = 2
      $game_temp.player_new_y         = 6
      $game_temp.player_new_direction = 8
      pbDismountBike
      $scene.transfer_player
      $game_map.autoplay
      $game_map.refresh
    }
end
if object!="CampsiteDoor"
if Input.press?(Input::SHIFT)
    type = $ExtraEvents.objects[key_id][2]
	pickMeUp(key_id,type)
	 return
end
if object==:PORTABLECAMP

	 return
end
commands=[]
commands.push(action[0])
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
	  pbCraftingBench(action[1])
elsif commandMail == 1
 if pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(action[1]).name}?"))
	  $bag.add(action[1])
	  if !$map_factory
  $game_map.removeThisEventfromMap(key_id)
else
  mapId = $game_map.map_id
  $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
end
      deletefromSIData(key_id)
end
else
	 return -1
end
end
	  
	  


end

ItemHandlers::UseFromBag.add(:PORTABLECAMP,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    if $game_map.metadata&.outdoor_map
    x = 0
	y = 0
    x = $game_player.x-1
	y = $game_player.y-1
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
    pbMessage(_INTL("You can't use that here."))
    next 0
	end
	end
	}
})



ItemHandlers::UseFromBag.add(:ITEMCRATE,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
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
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
    pbMessage(_INTL("You can't use that here."))
    next 0
	end



	end
	}
})
ItemHandlers::UseFromBag.add(:PKMNCRATE,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
     maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
  next 2
	else
    pbMessage(_INTL("You can't use that here."))
    next 0
	end
	end
	}
})

ItemHandlers::UseFromBag.add(:CRAFTINGBENCH,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {

     maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
     next 2
	end
	else
     pbMessage(_INTL("You can't use that here."))
     next 0
	end
	}
})



ItemHandlers::UseFromBag.add(:APRICORNCRAFTING,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
     maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
    pbMessage(_INTL("You can't use that here."))
    next 0
	end
	end

	}
})
ItemHandlers::UseFromBag.add(:MEDICINEPOT,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
    pbMessage(_INTL("You can't use that here."))
    next 0
	end
	end

	}
})
ItemHandlers::UseFromBag.add(:BEDROLL,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
     maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
    pbMessage(_INTL("You can't use that here."))
    next 0
	end
	end
	}
})
ItemHandlers::UseFromBag.add(:GRINDER,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
     maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
    pbMessage(_INTL("You can't use that here."))
    next 0
	end
	end
	}
})
ItemHandlers::UseFromBag.add(:FURNACE,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
    next 0
	end
	end
	}
})
ItemHandlers::UseFromBag.add(:CAULDRON,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
     maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
    pbMessage(_INTL("You can't use that here."))
    next 0
	end
	end
	}
})
ItemHandlers::UseFromBag.add(:UPGRADEDCRAFTINGBENCH,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})

ItemHandlers::UseFromBag.add(:ELECTRICPRESS,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})
ItemHandlers::UseFromBag.add(:ELECTRICGRINDER,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})

ItemHandlers::UseFromBag.add(:MACHINEBOX,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})

ItemHandlers::UseFromBag.add(:MEDICINEPOT,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})

ItemHandlers::UseFromBag.add(:POKEGENERATOR,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.outdoor_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})

ItemHandlers::UseFromBag.add(:HYDROGENERATOR,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.outdoor_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})

ItemHandlers::UseFromBag.add(:WINDGENERATOR,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.outdoor_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})

ItemHandlers::UseFromBag.add(:SOLARGENERATOR,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.outdoor_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})

ItemHandlers::UseFromBag.add(:COALGENERATOR,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})

ItemHandlers::UseFromBag.add(:ELECTRICFURNACE,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})

ItemHandlers::UseFromBag.add(:APRICORNMACHINE,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})

ItemHandlers::UseFromBag.add(:SEWINGMACHINE,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})

ItemHandlers::UseFromBag.add(:ELECTRICICEBOX,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
	if $game_map.metadata&.base_map
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})













