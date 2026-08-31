
ItemHandlers::UseFromEvent.add(:ELECTRICPRESS, proc { |item, key_id|
if Input.press?(Input::SHIFT)
Placeable.pick_up(key_id,item)
else
  powerConsumersCrafting(item)
end
}
)

ItemHandlers::UseFromEvent.add(:ELECTRICICEBOX, proc { |item, key_id|
if Input.press?(Input::SHIFT)
Placeable.pick_up(key_id,item)
else
  powerConsumersCrafting(item)
end
}
)

ItemHandlers::UseFromEvent.add(:SEWINGMACHINE, proc { |item, key_id|
if Input.press?(Input::SHIFT)
Placeable.pick_up(key_id,item)
else
  powerConsumersCrafting(item)
end
}
)

ItemHandlers::UseFromEvent.add(:APRICORNMACHINE, proc { |item, key_id|
if Input.press?(Input::SHIFT)
Placeable.pick_up(key_id,item)
else
  powerConsumersCrafting(item)
end
}
)

ItemHandlers::UseFromEvent.add(:ELECTRICFURNACE, proc { |item, key_id|
if Input.press?(Input::SHIFT)
Placeable.pick_up(key_id,item)
else
  powerConsumersCrafting(item)
end
}
)

ItemHandlers::UseFromEvent.add(:ELECTRICGRINDER, proc { |item, key_id|
if Input.press?(Input::SHIFT)
Placeable.pick_up(key_id,item)
else
  powerConsumersCrafting(item)
end
}
)

ItemHandlers::UseFromEvent.add(:COALGENERATOR, proc { |item, key_id|
if Input.press?(Input::SHIFT)
Placeable.pick_up(key_id,item)
else
  powerGenerators(item)
end
}
)

ItemHandlers::UseFromEvent.add(:SOLARGENERATOR, proc { |item, key_id|
if Input.press?(Input::SHIFT)
Placeable.pick_up(key_id,item)
else
  powerGenerators(item)
end
}
)

ItemHandlers::UseFromEvent.add(:WINDGENERATOR, proc { |item, key_id|
if Input.press?(Input::SHIFT)
Placeable.pick_up(key_id,item)
else
  powerGenerators(item)
end
}
)

ItemHandlers::UseFromEvent.add(:HYDROGENERATOR, proc { |item, key_id|
if Input.press?(Input::SHIFT)
Placeable.pick_up(key_id,item)
else
  powerGenerators(item)
end
}
)

ItemHandlers::UseFromEvent.add(:POKEGENERATOR, proc { |item, key_id|
if Input.press?(Input::SHIFT)
Placeable.pick_up(key_id,item)
else
  powerGenerators(item)
end
}
)

ItemHandlers::UseFromEvent.add(:HYDROGENERATOR, proc { |item, key_id|
if Input.press?(Input::SHIFT)
Placeable.pick_up(key_id,item)
else
  powerGenerators(item)
end
}
)

ItemHandlers::UseFromEvent.add(:MACHINEBOX, proc { |item, key_id|
if Input.press?(Input::SHIFT)
Placeable.pick_up(key_id,item)
else
  powerTransmitters(item)
end
}
)

ItemHandlers::UseFromEvent.add(:ITEMCRATE, proc { |item, key_id|
 if Input.press?(Input::SHIFT)
  storage = item.crate_storage
  storage.active = false if storage && storage.is_a?(PCItemStorage)
  Placeable.pick_up(key_id,item)
 else
  item_crates(item, key_id)
 end
}
)

ItemHandlers::UseFromEvent.add(:PKMNCRATE, proc { |item, key_id|
 if Input.press?(Input::SHIFT)
  storage = item.crate_storage
  storage.active = false if storage && storage.is_a?(PokemonStorage)
  Placeable.pick_up(key_id,item)
 else
  pokemon_crates(item, key_id)
 end
}
)

ItemHandlers::UseFromEvent.add(:ICEBOX, proc { |item, key_id|
 if Input.press?(Input::SHIFT)
  storage = item.crate_storage
  storage.active = false if storage && storage.is_a?(IceBoxStorage)
  Placeable.pick_up(key_id,item)
 else
  icebox_crates(item, key_id)
 end
}
)


def item_crates(item, key_id)
 storage = item.crate_storage
 storage.active = true
 this_event = $game_map.events[key_id]
 if storage.empty? || storage.nil?
  storage = PCItemStorage.new
  item.crate_storage = storage
 end
 localMeter = item.internal_data
 if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
  localMeter=CraftingStationData.new(key_id)
  item.internal_data=localMeter
 end
 localMeter.event_id = key_id if localMeter.event_id!=key_id
 pbMoveRoute(this_event, [PBMoveRoute::Graphic,"crateileft.png",0,this_event.direction,0])
 @move_route_waiting = true if !$game_temp.in_battle
 pbSEPlay("Voltorb Flip tile")
 Inventory.invWindow(:ITEMCRATE, localMeter, storage)
 pbMoveRoute(this_event, [PBMoveRoute::Graphic,"crateidown.png",0,this_event.direction,0])
 @move_route_waiting = true if !$game_temp.in_battle
end




def icebox_crates(item, key_id)
 storage = item.crate_storage
 storage.active = true
 this_event = $game_map.events[key_id]
 if storage.empty? || storage.nil?
  storage = IceBoxStorage.new
  item.crate_storage = storage
 end
 localMeter = item.internal_data
 if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
  localMeter=CraftingStationData.new(key_id)
  item.internal_data=localMeter
 end
 localMeter.event_id = key_id if localMeter.event_id!=key_id
 pbMoveRoute(this_event, [PBMoveRoute::Graphic,"crateileft.png",0,this_event.direction,0])
 @move_route_waiting = true if !$game_temp.in_battle
 pbSEPlay("Voltorb Flip tile")
 Inventory.invWindow(:ICEBOX,localMeter,item.crate_storage)
 pbMoveRoute(this_event, [PBMoveRoute::Graphic,"crateidown.png",0,this_event.direction,0])
 @move_route_waiting = true if !$game_temp.in_battle
end

def pokemon_crates(item, key_id)
 storage = item.crate_storage
 storage.active = true
 this_event = $game_map.events[key_id]
 if !storage.is_a?(PokemonStorage) && storage.empty?
  storage = PokemonStorage.new(1)
  item.crate_storage = storage
 end
 localMeter = item.internal_data
 if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
  localMeter=CraftingStationData.new(key_id)
  item.internal_data=localMeter
 end
 localMeter.event_id = key_id if localMeter.event_id!=key_id
 if item.crate_storage
  pbMoveRoute(this_event, [PBMoveRoute::Graphic,"crateleft.png",0,this_event.direction,0])
  @move_route_waiting = true if !$game_temp.in_battle
  pbSEPlay("Voltorb Flip tile")
  item.crate_storage.active = true 
  Inventory.invWindow(:PKMNCRATE,localMeter,item.crate_storage)
  pbMoveRoute(this_event, [PBMoveRoute::Graphic,"cratedown.png",0,this_event.direction,0])
  @move_route_waiting = true if !$game_temp.in_battle
 end 
end













def pbDisplayPowerWindow(msgwindow,statue)
  moneyString=_INTL("{1}/100",statue.power.to_s_formatted)
  goldwindow=Window_AdvancedTextPokemon.new(_INTL("Power: <ar>{1}</ar>",moneyString))
  #goldwindow.setSkin("Graphics/Windowskins/goldskin")
  goldwindow.resizeToFit(goldwindow.text,Graphics.width)
  goldwindow.width=160 if goldwindow.width<=160 
  if msgwindow.y==0
    goldwindow.y=Graphics.height-goldwindow.height
  else
    goldwindow.y=0
  end
  goldwindow.viewport=msgwindow.viewport
  goldwindow.z=msgwindow.z
  return goldwindow
end

def powerGenerators(type)
action = []
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end

localMeter.event_id = key_id if localMeter.event_id!=key_id
case type.id
when :COALGENERATOR
commands=[]
commands.push(_INTL"Fuel")
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
    msgwindow = pbCreateMessageWindow(nil,nil)
  powerwindow = pbDisplayPowerWindow(msgwindow,localMeter)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
   commandMail = pbShowCommands(msgwindow,commands,-1)
pbDisposeMessageWindow(msgwindow)
powerwindow.dispose
 if commandMail == 0
	  #Fueling
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




when :SOLARGENERATOR
commands=[]
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
    msgwindow = pbCreateMessageWindow(nil,nil)
  powerwindow = pbDisplayPowerWindow(msgwindow,localMeter)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
   commandMail = pbShowCommands(msgwindow,commands,-1)
pbDisposeMessageWindow(msgwindow)
powerwindow.dispose
 if commandMail == 0
 #Connection UI
elsif commandMail == 1
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
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
    msgwindow = pbCreateMessageWindow(nil,nil)
  powerwindow = pbDisplayPowerWindow(msgwindow,localMeter)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
   commandMail = pbShowCommands(msgwindow,commands,-1)
pbDisposeMessageWindow(msgwindow)
powerwindow.dispose
 if commandMail == 0
 #Connection UI
elsif commandMail == 1
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
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
    msgwindow = pbCreateMessageWindow(nil,nil)
  powerwindow = pbDisplayPowerWindow(msgwindow,localMeter)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
   commandMail = pbShowCommands(msgwindow,commands,-1)
pbDisposeMessageWindow(msgwindow)
powerwindow.dispose
 if commandMail == 0
 #Connection UI
elsif commandMail == 1
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
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
    msgwindow = pbCreateMessageWindow(nil,nil)
  powerwindow = pbDisplayPowerWindow(msgwindow,localMeter)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
   commandMail = pbShowCommands(msgwindow,commands,-1)
pbDisposeMessageWindow(msgwindow)
powerwindow.dispose
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
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

end

def powerConsumersCrafting(type)
action = []
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end

localMeter.event_id = key_id if localMeter.event_id!=key_id

#pbSetSelfSwitch(this_event, "A", true)
commands=[]
commands.push(_INTL("Craft"))
commands.push(_INTL("Turn Off")) 
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
    msgwindow = pbCreateMessageWindow(nil,nil)
  powerwindow = pbDisplayPowerWindow(msgwindow,localMeter)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
   commandMail = pbShowCommands(msgwindow,commands,-1)
pbDisposeMessageWindow(msgwindow)
powerwindow.dispose
 if commandMail == 0
	  pbCraftingBench(type, localMeter)
elsif commandMail == 1
 #Turn On/Off
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

def powerConsumersStorage(type)
action = []
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end


localMeter.event_id = key_id if localMeter.event_id!=key_id
#pbSetSelfSwitch(this_event, "A", true)
commands=[]
commands.push(_INTL("Store"))
commands.push(_INTL("Turn Off")) 
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
  msgwindow = pbCreateMessageWindow(nil,nil)
  powerwindow = pbDisplayPowerWindow(msgwindow,localMeter)
  pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
 commandMail = pbShowCommands(msgwindow,commands,-1)
pbDisposeMessageWindow(msgwindow)
powerwindow.dispose
 if commandMail == 0
	  pbCraftingBench(type, localMeter)
elsif commandMail == 1
 #Turn On/Off
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

def powerTransmitters(type)
action = []
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end

localMeter.event_id = key_id if localMeter.event_id!=key_id
commands=[]
commands.push(_INTL("Check Power")) 
commands.push(_INTL("Connect")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
  msgwindow = pbCreateMessageWindow(nil,nil)
  powerwindow = pbDisplayPowerWindow(msgwindow,localMeter)
  pbMessageDisplay(msgwindow,_INTL("What do you want to do?\\wtnp[1]"))
 commandMail = pbShowCommands(msgwindow,commands,-1)
pbDisposeMessageWindow(msgwindow)
powerwindow.dispose
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
Placeable.pick_up(key_id,type)
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
  Placeable.pick_up(key_id,pkmn)

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


def campsiteDoorEntry
 
 
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


def remove_dynamic_object(key_id)
    raise 
	  if !$map_factory
       $game_map.removeThisEventfromMap(key_id)
      else
       mapId = $game_map.map_id
       $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
      end
	  deletefromSIData(key_id)



end 