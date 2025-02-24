module ItemHandlers
  attr_reader :hash
  UseFromBox          = ItemHandlerHash.new
  UseFromEvent          = ItemHandlerHash.new



  def self.hasUseText(item)
    return !UseText[item].nil?
  end

  def self.hasOutHandler(item)                       # Shows "Use" option in Bag
    return !UseFromBag[item].nil? || !UseInField[item].nil? || !UseOnPokemon[item].nil?
  end

  def self.hasUseInFieldHandler(item)           # Shows "Register" option in Bag
    return !UseInField[item].nil?
  end

  def self.hasUseOnPokemon(item)
    return !UseOnPokemon[item].nil?
  end

  def self.hasUseOnPokemonMaximum(item)
    return !UseOnPokemonMaximum[item].nil?
  end

  def self.hasUseInBattle(item)
    return !UseInBattle[item].nil?
  end

  def self.hasBattleUseOnBattler(item)
    return !BattleUseOnBattler[item].nil?
  end

  def self.hasBattleUseOnPokemon(item)
    return !BattleUseOnPokemon[item].nil?
  end

  # Returns text to display instead of "Use"
  def self.getUseText(item)
    return UseText.trigger(item)
  end

  # Return value:
  # 0 - Item not used
  # 1 - Item used, don't end screen
  # 2 - Item used, end screen
  def self.triggerUseFromBag(item)
    ret = 0
    ret = UseFromBag.trigger(item) if UseFromBag[item]
    # No UseFromBag handler exists; check the UseInField handler if present
    if UseInField[item]
      ret = (UseInField.trigger(item)) ? 1 : 0
    end
    pbEatingPkmn(pkmn,item) if (item.data.is_berry? || item.data.is_foodwater?) && ret==1 && !UseInField[item]
    return ret
  end

  # Returns whether item can be used
  def self.triggerConfirmUseInField(item)
    return true if !ConfirmUseInField[item]
    return ConfirmUseInField.trigger(item)
  end

  # Return value:
  # -1 - Item effect not found
  # 0  - Item not used
  # 1  - Item used
  def self.triggerUseInField(item)
    ret = -1 if !UseInField[item]
    ret = (UseInField.trigger(item)) ? 1 : 0
    pbEatingPkmn(pkmn,item) if (item.data.is_berry? || item.data.is_foodwater?) && ret==1
    return ret
  end

  # Returns whether item was used
  def self.triggerUseOnPokemon(item, qty, pkmn, scene)
    return false if !UseOnPokemon[item] && !UseOnPokemon[item.id]
    ret = UseOnPokemon.trigger(item, qty, pkmn, scene)
    pbEatingPkmn(pkmn,item) if (item.data.is_berry? || item.data.is_foodwater?) && ret==true
    return ret
  end

  # Returns the maximum number of the item that can be used on the Pokémon at once.
  def self.triggerUseOnPokemonMaximum(item, pkmn)
    return 1 if !UseOnPokemonMaximum[item]
    return 1 if !Settings::USE_MULTIPLE_STAT_ITEMS_AT_ONCE
    return [UseOnPokemonMaximum.trigger(item, pkmn), 1].max
  end

  def self.triggerCanUseInBattle(item, pkmn, battler, move, firstAction, battle, scene, showMessages = true)
    ret = false
    ret = true if !CanUseInBattle[item]   # Can use the item by default
    ret = CanUseInBattle.trigger(item, pkmn, battler, move, firstAction, battle, scene, showMessages)
    pbEatingPkmn(pkmn,item) if (item.data.is_berry? || item.data.is_foodwater?) && ret==true
    return ret 
  end

  def self.triggerUseInBattle(item, battler, battle)
    ret = UseInBattle.trigger(item, battler, battle)
    pbEatingPkmn(pkmn,item) if (item.data.is_berry? || item.data.is_foodwater?) && ret==true
    return ret
  end

  # Returns whether item was used
  def self.triggerBattleUseOnBattler(item, battler, scene)
    return false if !BattleUseOnBattler[item]
    pbEatingPkmn(pkmn,item) if item.data.is_berry? || item.data.is_foodwater?
    ret = BattleUseOnBattler.trigger(item, battler, scene)
    pbEatingPkmn(pkmn,item) if (item.data.is_berry? || item.data.is_foodwater?) && ret==true
    return ret
  end

  # Returns whether item was used
  def self.triggerBattleUseOnPokemon(item, pkmn, battler, choices, scene)
    return false if !BattleUseOnPokemon[item]
    ret = BattleUseOnPokemon.trigger(item, pkmn, battler, choices, scene)
    pbEatingPkmn(pkmn,item) if (item.data.is_berry? || item.data.is_foodwater?) && ret==true
    return ret
  end


  def self.hasUseFromBox(item)
    return !UseFromBox[item].nil?
  end

  def self.hasUseFromEvent(item)
    return !UseFromEvent[item].nil?
  end
  
  def self.triggerUseFromBox(item, event=nil)
	  return if item.nil?
    return UseFromBox.triggerpokemon(item, event) if item.is_a? Pokemon
    return UseFromBox.trigger(item, event) if UseFromBox[item]
    if UseInField[item]
      return (UseInField.trigger(item)) ? 1 : 0
    end
    if UseFromBag[item]
      return (UseFromBag.trigger(item)) ? 1 : 0
    end
    return 0
  end
  

  def self.triggerUseFromEvent(item, *args)
    item = ItemStorageHelper.get_item_data(item) if item.is_a?(Symbol)
    return UseFromEvent.trigger(item, *args) if UseFromEvent[item]
    return 0
  end
end
class HandlerHash2

  def trigger(sym, *args)
    handler = self[sym.id] if sym.respond_to?("id") 
    return handler&.call(sym, *args)
  end
  def triggerpokemon(sym, *args)
    handler = self[sym]
    return handler&.call(sym, *args)
  end
  
  def [](sym)
    return @hash[sym.id] if sym && sym.respond_to?("id")  && @hash[sym.id]
    return @hash[sym] if sym && !sym.respond_to?("id") && @hash[sym]
    @add_ifs.each do |add_if|
      return add_if[1] if add_if[0].call(sym)
    end
    return nil
  end
  
  def add(sym, handler = nil, &handlerBlock)
    if ![Proc, Hash].include?(handler.class) && !block_given?
      raise ArgumentError, "#{self.class.name} for #{sym.inspect} has no valid handler (#{handler.inspect} was given)"
    end
    @hash[sym] = handler || handlerBlock if sym
  end

  def addIf(conditionProc, handler = nil, &handlerBlock)
    if ![Proc, Hash].include?(handler.class) && !block_given?
      raise ArgumentError, "addIf call for #{self.class.name} has no valid handler (#{handler.inspect} was given)"
    end
    @add_ifs.push([conditionProc, handler || handlerBlock])
  end


end

class CraftingStationData
    attr_accessor :event
    attr_accessor :type
    attr_accessor :type_data
    attr_accessor :time_last_updated
    attr_accessor :time_active
    attr_accessor :fuel
    attr_accessor :crafting_time
    attr_accessor :crafting_recipe
	
	
    attr_accessor :electronic
    attr_accessor :on
	
    attr_accessor :storage
	
    attr_accessor :power
    attr_accessor :connected_to
    attr_accessor :time_running
    attr_accessor :network


	
  def initialize(event = nil)
    @event = event if !event.nil?
	 @type_data =  @event.type if @event.type.is_a?(ItemData)
	 @type_data =  ItemData.new(@event.type) if !@event.type.is_a?(ItemData)
	 @type = @type_data.id 
    @time_last_updated = pbGetTimeNow.to_i
    @crafting_time = 0
    @crafting_time = 1350 if @type == :FURNACE
    @crafting_recipe = []
	
    @storage = []
	
	
    @time_active         = 0
    @fuel = 0.0
	
	
	
    @electronic = false
    @time_running       = 0
    @on = 0
    @power = 0
    @connected_to = nil
    @network = {}
  end
  
  def still_me?
    this_event = pbMapInterpreter.get_self
	  return false if this_event.nil?
	  if !this_event.is_a?(Game_OVEvent)
        otherdata = pbMapInterpreter.getVariableOther(this_event.id)
		  if otherdata && otherdata==self
         pbMapInterpreter.deleteVariableOther(this_event.id)
	     end
	  end
	  if !@event.is_a?(Game_OVEvent)
        otherdata = pbMapInterpreter.getVariableOther(@event.id)
		  if otherdata && otherdata==self
         pbMapInterpreter.deleteVariableOther(@event.id)
	     end
	  end
	  return false if this_event.is_a?(Game_PokeEvent)
	  return false if this_event.is_a?(Game_PokeEventA)
	  
	  
	 if this_event && defined?(this_event.type) 
	  if @event.map_id == this_event.map_id
	 if @event!=this_event
    @event = this_event
	 @type_data =  @event.type if @event.type.is_a?(ItemData)
	 @type_data =  ItemData.new(@event.type) if !@event.type.is_a?(ItemData)
	 @type = @type_data.id 
    @crafting_time = 1350 if @type == :FURNACE && @crafting_time==0
    @crafting_time = 1350 if @type != :FURNACE && @crafting_time==1350
	 
	 end
     end
	 end 
	  return true 
  end
  
  def update
    time_now = pbGetTimeNow
    time_delta = time_now.to_i - @time_last_updated.to_i
    return if time_delta <= 0
    if still_me?
	
	  time = time_delta/3600
	  time = [time,1].max
     if @electronic == true
     @time_last_updated = time_now
	   return
	 end
	 if @fuel>0
	   
	  @time_active += time_delta
	  if @time_active >= @crafting_time
	   if @fuel-(1 * time)>=0
	  @fuel-=(1 * time)
	   else
	  @fuel=0
	   
	   end
	   @time_active = 0
	  end
	 end
	 
     @time_last_updated = time_now
	 else
	 
	 end
  end
end


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
    elsif item_data.is_weapon?
	  case item.id
	   when :MACHETE
	  return decreaseStamina(5)
	   when :STONE
	  return decreaseStamina(4)
	   when :BAIT
	 return decreaseStamina(4)
	  end
    elsif item_data.is_hmitem?
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
	  return decreaseStamina(5)
     when :POLE
	  return decreaseStamina(5)
	  else
	  return decreaseStamina(5)
     end
	else
     case item.id
     when :SNATCHER
		return decreaseStamina(4)
     when :SNATCHER
	 else
		return decreaseStamina(1)
     end
	
    end
    return false
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
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=CraftingStationData.new(this_event)
interp.setVariable(localMeter)
end

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
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=CraftingStationData.new(this_event)
interp.setVariable(localMeter)
end


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
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=CraftingStationData.new(this_event)
interp.setVariable(localMeter)
end


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
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=CraftingStationData.new(this_event)
interp.setVariable(localMeter)
end

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

def item_crates(item=:ITEMCRATE)
$PokemonGlobal.itemStorageSystems = {} if $PokemonGlobal.itemStorageSystems.nil?
action = []
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
if item.is_a?(Symbol)
storage = interp.getVariable
item = ItemStorageHelper.get_item_data(item) 
item.crate_storage = storage[0] if storage.is_a? Array
item.crate_storage = storage if !storage.is_a? Array
storage_key = storage[0].name if storage.is_a? Array
storage_key = storage.name if !storage.is_a? Array
$PokemonGlobal.itemStorageSystems[storage_key] = item.crate_storage
else 
storage = item.crate_storage
end

if storage.empty?
creation=PCItemStorage.new
storage_key = creation.name
$PokemonGlobal.itemStorageSystems[storage_key] = creation
storage = $PokemonGlobal.itemStorageSystems[storage_key]
item.crate_storage = storage
end

commands=[]
commands.push(_INTL"Use Storage")
commands.push(_INTL("Set Storage Name")) 
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
	  pbMoveRoute(this_event, [PBMoveRoute::Graphic,"crateileft.png",0,this_event.direction,0])
     @move_route_waiting = true if !$game_temp.in_battle
     pbSEPlay("Voltorb Flip tile")
     pbTrainerCrate(storage)
	  storage.active=true
      item.crate_storage = storage
     storage_key = storage.name
     $PokemonGlobal.itemStorageSystems[storage_key] = item.crate_storage
     pbMoveRoute(this_event, [PBMoveRoute::Graphic,"crateidown.png",0,this_event.direction,0])
     @move_route_waiting = true if !$game_temp.in_battle
elsif commandMail == 1
      name = pbFreeTextNoWindow("#{storage.name}",false,256,Graphics.width,false)
      if name != "" && !name.nil?
	    storage.changeName(name)
    item.crate_storage = storage
    storage_key = storage.name
    $PokemonGlobal.itemStorageSystems[storage_key] = item.crate_storage
	   pbMessage(_INTL("#{storage.name} is now #{name}."))
	  else
	   pbMessage(_INTL("#{storage.name} has not had their name changed."))
	  end
elsif commandMail == 2
 if pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(item).name}?"))
   
	  storage.active=false
    item.crate_storage = storage
    storage_key = storage.name
    $PokemonGlobal.itemStorageSystems[storage_key] = item.crate_storage
	  $bag.add(item)
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


def pokemon_crates(item=:PKMNCRATE)

$PokemonGlobal.pokemonStorageSystems = {} if $PokemonGlobal.pokemonStorageSystems.nil?

action = []
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id


if item.is_a?(Symbol)
storage = interp.getVariable
item = ItemStorageHelper.get_item_data(item) 
item.crate_storage = storage[0] if storage.is_a? Array
item.crate_storage = storage if !storage.is_a? Array
storage_key = storage[0].name if storage.is_a? Array
storage_key = storage.name if !storage.is_a? Array
$PokemonGlobal.pokemonStorageSystems[storage_key] = item.crate_storage
else
storage = item.crate_storage
end

if !storage.is_a?(PokemonStorage) && storage.empty?
creation=PokemonStorage.new(1)
storage_key = creation.name
$PokemonGlobal.pokemonStorageSystems[storage_key] = creation
storage = $PokemonGlobal.pokemonStorageSystems[storage_key]
item.crate_storage = storage
end



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
      storage.active=true
      item.crate_storage = storage
      storage_key = storage.name
      $PokemonGlobal.pokemonStorageSystems[storage_key] = item.crate_storage
      $PokemonStorage = storage
      pbStorageCrateMenu(storage)
      pbMoveRoute(this_event, [PBMoveRoute::Graphic,"cratedown.png",0,this_event.direction,0])
      @move_route_waiting = true if !$game_temp.in_battle
elsif commandMail == 1
      name = pbFreeTextNoWindow("#{storage.name}",false,256,Graphics.width,false)
      if name != "" && !name.nil?
	    storage.changeName(name)
	    item.crate_storage = storage
	    storage_key = storage.name
	    $PokemonGlobal.pokemonStorageSystems[storage_key] = item.crate_storage
        $PokemonStorage = storage
	    pbMessage(_INTL("#{storage.name} is now #{name}."))
	  else
	    pbMessage(_INTL("#{storage.name} has not had their name changed."))
	  end
elsif commandMail == 2
 if pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(item).name}?"))
      $bag.add(item)
      storage.active=false
      item.crate_storage = storage
      storage_key = storage.name
      $PokemonStorage = storage
      $PokemonGlobal.pokemonStorageSystems[storage_key] = item.crate_storage
      if $PokemonStorage == storage
      $PokemonGlobal.pokemonStorageSystems.keys.each do |i|
	  next if !$PokemonGlobal.pokemonStorageSystems[i].active?
	  next if $PokemonGlobal.pokemonStorageSystems[i].full?
        $PokemonStorage = $PokemonGlobal.pokemonStorageSystems[i]
	     pbMessage(_INTL("Storage has been redirected to #{$PokemonStorage.name}."))
      end
	  if $PokemonStorage == storage
	   $PokemonStorage == nil
	  end
	 end 

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


ItemHandlers::UseFromEvent.add(:CRAFTINGBENCH, proc { |item, key_id|
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=CraftingStationData.new(this_event)
interp.setVariable(localMeter)
end
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
commands=[]
commands.push(_INTL("Craft"))
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
	  pbCraftingBench(item.id, localMeter)
 elsif commandMail == 1 && pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(item).name}?"))
	  $bag.add(item)
	  if !$map_factory
       $game_map.removeThisEventfromMap(key_id)
      else
       mapId = $game_map.map_id
       $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
      end
	  deletefromSIData(key_id)
 end
end
}
)

ItemHandlers::UseFromEvent.add(:UPGRADEDCRAFTINGBENCH, proc { |item, key_id|
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=CraftingStationData.new(this_event)
interp.setVariable(localMeter)
end
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
commands=[]
commands.push(_INTL("Craft"))
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
	  pbCraftingBench(item.id, localMeter)
 elsif commandMail == 1 && pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(item).name}?"))
	  $bag.add(item)
	  if !$map_factory
       $game_map.removeThisEventfromMap(key_id)
      else
       mapId = $game_map.map_id
       $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
      end
	  deletefromSIData(key_id)

 end
end
}
)

ItemHandlers::UseFromEvent.add(:APRICORNCRAFTING, proc { |item, key_id|
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=CraftingStationData.new(this_event)
interp.setVariable(localMeter)
end
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
commands=[]
commands.push(_INTL("Craft"))
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
	  pbCraftingBench(item.id, localMeter)
 elsif commandMail == 1 && pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(item).name}?"))
	  $bag.add(item)
	  if !$map_factory
       $game_map.removeThisEventfromMap(key_id)
      else
       mapId = $game_map.map_id
       $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
      end
	  deletefromSIData(key_id)
 
 end
end
}
)

ItemHandlers::UseFromEvent.add(:FURNACE, proc { |item, key_id|
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=CraftingStationData.new(this_event)
interp.setVariable(localMeter)
end
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
commands=[]
commands.push(_INTL("Craft"))
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
	  pbCraftingBench(item.id, localMeter)
 elsif commandMail == 1 && pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(item).name}?"))
	  $bag.add(item)
	  if !$map_factory
       $game_map.removeThisEventfromMap(key_id)
      else
       mapId = $game_map.map_id
       $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
      end
	  deletefromSIData(key_id)
 
 end
end
}
)

ItemHandlers::UseFromEvent.add(:CAULDRON, proc { |item, key_id|
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=CraftingStationData.new(this_event)
interp.setVariable(localMeter)
end
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else


commands=[]
commands.push(_INTL("Cook"))
commands.push(_INTL("Prepare Meat"))
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
	  pbCraftingBench(item.id, localMeter)
 elsif commandMail == 1
    pkmn = pbChoosePokemon()
	if pkmn 
	 if !pkmn.egg? && !pkmn.shadowPokemon?
    if pbConfirmMessage(_INTL("Are you sure you want to prepare your #{pkmn.name} for food?"))
	 pbCookMeat(pkmn)
	end
	end
	end
 elsif commandMail == 2 && pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(item).name}?"))
	  $bag.add(item)
	  if !$map_factory
       $game_map.removeThisEventfromMap(key_id)
      else
       mapId = $game_map.map_id
       $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
      end
	  deletefromSIData(key_id)
 
 end



#pbCommonEvent(17)







end
}
)

ItemHandlers::UseFromEvent.add(:GRINDER, proc { |item, key_id|
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=CraftingStationData.new(this_event)
interp.setVariable(localMeter)
end
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
commands=[]
commands.push(_INTL("Craft"))
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
	  pbCraftingBench(item.id, localMeter)
 elsif commandMail == 1 && pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(item).name}?"))
	  $bag.add(item)
	  if !$map_factory
       $game_map.removeThisEventfromMap(key_id)
      else
       mapId = $game_map.map_id
       $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
      end
	  deletefromSIData(key_id)
 
 end


end
}
)

ItemHandlers::UseFromEvent.add(:MEDICINEPOT, proc { |item, key_id|
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=CraftingStationData.new(this_event)
interp.setVariable(localMeter)
end
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
commands=[]
commands.push(_INTL("Craft"))
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0
	  pbCraftingBench(item.id, localMeter)
 elsif commandMail == 1 && pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(item).name}?"))
	  $bag.add(item)
	  if !$map_factory
       $game_map.removeThisEventfromMap(key_id)
      else
       mapId = $game_map.map_id
       $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
      end
	  deletefromSIData(key_id)
 
 end
end
}
)


ItemHandlers::UseFromEvent.add(:ELECTRICPRESS, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  powerConsumersCrafting(item)
end
}
)

ItemHandlers::UseFromEvent.add(:ELECTRICICEBOX, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  powerConsumersCrafting(item)
end
}
)

ItemHandlers::UseFromEvent.add(:SEWINGMACHINE, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  powerConsumersCrafting(item)
end
}
)

ItemHandlers::UseFromEvent.add(:APRICORNMACHINE, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  powerConsumersCrafting(item)
end
}
)

ItemHandlers::UseFromEvent.add(:ELECTRICFURNACE, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  powerConsumersCrafting(item)
end
}
)

ItemHandlers::UseFromEvent.add(:ELECTRICGRINDER, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  powerConsumersCrafting(item)
end
}
)

ItemHandlers::UseFromEvent.add(:COALGENERATOR, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  powerGenerators(item)
end
}
)

ItemHandlers::UseFromEvent.add(:SOLARGENERATOR, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  powerGenerators(item)
end
}
)

ItemHandlers::UseFromEvent.add(:WINDGENERATOR, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  powerGenerators(item)
end
}
)

ItemHandlers::UseFromEvent.add(:HYDROGENERATOR, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  powerGenerators(item)
end
}
)

ItemHandlers::UseFromEvent.add(:POKEGENERATOR, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  powerGenerators(item)
end
}
)

ItemHandlers::UseFromEvent.add(:HYDROGENERATOR, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  powerGenerators(item)
end
}
)

ItemHandlers::UseFromEvent.add(:MACHINEBOX, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  powerTransmitters(item)
end
}
)

ItemHandlers::UseFromEvent.add(:ITEMCRATE, proc { |item, key_id|\
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  item_crates(item)
end
}
)

ItemHandlers::UseFromEvent.add(:PKMNCRATE, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
  pokemon_crates(item)
end
}
)

ItemHandlers::UseFromEvent.add(:TORCH, proc { |item, key_id|
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=CraftingStationData.new(this_event)
interp.setVariable(localMeter)
end
if Input.press?(Input::SHIFT)
pickMeUp(key_id,item)
else
commands=[]
commands.push(_INTL("Pick Up"))
commands.push(_INTL("Cancel"))
commandMail = pbMessage(_INTL("What are you going to do?"),commands, -1)
 if commandMail == 0 && pbConfirmMessage(_INTL("Would you like to pick up #{GameData::Item.try_get(item).name}?"))
	  $bag.add(item)
	  if !$map_factory
       $game_map.removeThisEventfromMap(key_id)
      else
       mapId = $game_map.map_id
       $map_factory.getMap(mapId).removeThisEventfromMap(key_id)
      end
	  deletefromSIData(key_id)
 
 end

end
}
)


ItemHandlers::UseFromEvent.add(:BEDROLL, proc { |item, key_id|
interp = pbMapInterpreter
this_event = interp.get_self
key_id = this_event.id
localMeter = interp.getVariable
if !localMeter
localMeter=CraftingStationData.new(this_event)
interp.setVariable(localMeter)
end
if Input.press?(Input::SHIFT)
pbErasePokemonCenter($game_map.map_id)
pickMeUp(key_id,item)
else
pbBedCore(item)
end
}
)

ItemHandlers::UseFromEvent.add(:PORTABLECAMP, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pbErasePokemonCenter(398)
pickMeUp(key_id,item)
else
pbMessage(_INTL("It's a Campsite Tent."))
end
}
)


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
	 if Input.trigger?(Input::USE) && !start_end.nil? && (start_end[1][0]!=start_end[0][0]) && (start_end[1][1]!=start_end[0][1])
	   
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


def throwing_range_logic2(do_it, amt)

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
	 if Input.trigger?(Input::USE) && !start_end.nil? && (start_end[1][0]!=start_end[0][0]) && (start_end[1][1]!=start_end[0][1])
	   
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
  return do_it,amt,start_end
end



ItemHandlers::UseFromBox.addIf(proc { |item| item.is_a?(Pokemon) }, proc { |pkmn, event|
    if pkmn.inworld==true && !pkmn.associatedevent.nil?
	 if $game_map.events[pkmn.associatedevent].nil?
	   pkmn.inworld=false
	 end
	end
    if pkmn.inworld==false && !pkmn.associatedevent.nil?
	 if !$game_map.events[pkmn.associatedevent].nil?
	   pkmn.inworld=true
	 end
	end
    next false if $game_temp.preventspawns == true
    next false if $game_temp.pokemon_calling==true
    next false if pkmn.fainted?
    next false if pkmn.egg?
    next false if pkmn.dead?
	next false if $game_temp.in_throwing==true
    active_item=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
	 pkmn = active_item
	 if pkmn.inworld==true && Input.press?(Input::CTRL)
	    $game_temp.preventspawns = true
       event = getOverworldPokemonfromPokemon(pkmn)
	    $game_temp.preventspawns = false
	   if !event.nil?
	   pbReturnPokemon(event,true)
	   else
	   pkmn.inworld==false
	   end

    elsif pkmn.inworld==true
	  if $PokemonGlobal.cur_stored_pokemon!=pkmn
	   $PokemonGlobal.set_ball_hud_type(:MOVES,true,pkmn)
	  end
	else
	if pbOverworldCombat.battle_rules.include?("Only-One-Mon") && get_overworld_pokemon_length == 1
	  sideDisplay(_INTL("You can only have one Pokemon on the map right now!"))
	  next false
	end
	amt=1
	do_it = false
	 $game_temp.currently_throwing_pkmn = true
    do_it,amt,start_end = throwing_range_logic2(do_it, amt)
	 $game_temp.currently_throwing_pkmn = false
	if do_it==true
     pbSEPlay("Battle throw")
	 can_do = decreaseStamina(3.55*amt)
	 if can_do == true && $game_player.pbFacingTerrainTag.can_surf_freely==false
	 FollowingPkmn.toggle_off if FollowingPkmn.get_pokemon == pkmn
	 #item.damage_bonus=amt
     $game_temp.preventspawns=true
     spriteindex = $scene.spriteset.addUserSprite(OWPokemonReleaseSprite.new(start_end,pkmn,$game_map,Spriteset_Map.viewport))
	 holding_pattern(spriteindex)
      id=$game_map.check_event(*start_end[1])
     $game_temp.preventspawns=false
      id=$game_map.check_event(*start_end[1])
  if id&.is_a?(Integer)
   event = $game_map.events[id]
     if event.is_a?(Game_PokeEvent)
		poke = event.pokemon 
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
		if poke.status==:PARALYSIS||poke.status==:SLEEP||poke.status==:FROZEN
        sideDisplay(_INTL("#{pkmn.name} got a quick hit on #{poke.name}!\\wtnp[10]"))
        damage = getDamager(poke,1,:TACKLE,false)
        poke.hp-= damage
		end
	  
		if poke.fainted?
        event.removeThisEventfromMap
        pbPlayerEXP(poke,$player.able_party)
        pbHeldItemDropOW(poke,true)
		else
        pbSingleOrDoubleWildBattle( $game_map.map_id, event.x, event.y, poke )
        $PokemonGlobal.battlingSpawnedPokemon = false
        event.removeThisEventfromMap
        pbResetTempAfterBattle()
		end
       else

	   next if pkmn.in_world==true
	    x,y = start_end[1]
		pbSEPlay("Battle recall")
		$game_temp.preventspawns=false if $DEBUG && Input.press?(Input::CTRL)
	   next if pkmn.in_world==true
	    pbPlacePokemon(x, y,pkmn)
	    event_id = getOverworldPokemonfromPokemon(pkmn)
		if !event_id.nil?
		poke_event = $game_map.events[event_id]
		pkmn.set_in_world(true,poke_event)
       $game_temp.preventspawns=false
		end
		end
    else
	   
	   next if pkmn.in_world==true
	    x,y = start_end[1]
		pbSEPlay("Battle recall")
		$game_temp.preventspawns=false if $DEBUG && Input.press?(Input::CTRL)
	   next if pkmn.in_world==true
	    pbPlacePokemon(x, y,pkmn)
	    event_id = getOverworldPokemonfromPokemon(pkmn)
		if !event_id.nil?
		poke_event = $game_map.events[event_id]
		pkmn.set_in_world(true,poke_event)
       $game_temp.preventspawns=false
		end
    end
	end
	end
	
	end
	
	
	
   $game_temp.preventspawns=false
	next true
  }
)

ItemHandlers::UseFromBox.addIf(proc { |item| GameData::Item&.try_get(item).is_poke_ball? }, proc { |item, event|
    next if $player.is_it_this_class?(:RANGER,false)
	next if $game_temp.in_throwing==true
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




ItemHandlers::UseFromBag.add(:HOE,proc{|item, event|
	 facing = $game_player.pbFacingTile($game_player.direction, $game_player)
    terrain = $game_map.terrain_tag(facing[1], facing[2], true)
	next 0 if !$game_map.metadata&.outdoor_map
	can_do = reduceStaminaBasedOnItem(item)
	 next 0 if can_do == false
    if !pbObjectIsPossible(facing[1],facing[2])
	  	 pbSEPlay("shovelhittingrock")
	     next 0 
	end

 if item.decrease_durability(1)
	  if !pbSeenTipCard?(:HOE)
	    pbShowTipCard(:HOE)
	  end
	  pbSEPlay("shovel")
	  pbPlaceBerryPlant(facing[1],facing[2])
      next 2









 end
     next 0

	}
)
def fuck_mothering_rabbit(item)
return (GameData::Item.get(item).is_berry? && GameData::Item.get(item).name.include?("Berry")) || GameData::Item.get(item).is_foodwater? || GameData::Item.get(item).name.include?("Potion") || GameData::Item.get(item).id==:REVIVALHERB || GameData::Item.get(item).id==:HEALPOWDER || GameData::Item.get(item).id==:ENERGYPOWDER || GameData::Item.get(item).id==:ENERGYROOT
end

ItemHandlers::UseFromBox.addIf(proc { |item| fuck_mothering_rabbit(item) }, proc { |item, event|
    item_data = item.data
	amt=1
	do_it = false
    do_it,amt,start_end = selection_mouse_logic(do_it, amt)
   amt = amt.to_i
   if do_it
   id=$game_map.check_event(*start_end[1])
   if id&.is_a?(Game_Player)
       if item_data.is_foodwater? || item_data.is_berry?
        ret = pbEating($bag,item)
        next 2
	   
	   elsif item_data.is_medicine?
        ret = pbMedicine($bag,item)
        next 2
	   
	   else
	   
	   end
   elsif id&.is_a?(Integer)
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
        sideDisplay(_INTL("{2} doesn't need (a) {1} right now.", item.name,pkmn.name)) 
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
        ret = pbEating($bag,item)
        next 2
	  elsif commands.length == 1 && commands[0]== _INTL("Eat")
        ret = pbEating($bag,item)
        next 2
	  elsif commands.length == 1 && commands[0]== _INTL("Use (Self)")
        ret = pbMedicine($bag,item)
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
        ret = pbMedicine($bag,item)
          $PokemonGlobal.alternate_control_mode=false
        next 2
      elsif cmdEat >=0 && command==cmdEat   # Eat
        ret = pbEating($bag,item)
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
	 
	 if !facingEvent.nil? && facingEvent.name[/berryplant/i]
	    
	     berry_plant = facingEvent.variable
		 if berry_plant
	     pbTurnBerryPlant(facingEvent,berry_plant)
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
	   pbSEPlay("can_fill") if p_sound
	     pbWait(15)
        end
		break if !Input.press?(Input::USE)
	  end
      next 2
	end


      if item.water>=10
	   if !facingEvent.nil? && facingEvent.name[/berryplant/i]
        if item.decrease_durability(1)
	     berry_plant = facingEvent.variable
		  if berry_plant
		    
			    if item.decrease_water(10)
		          berry_plant_refills(berry_plant,item)
                  pbSEPlay("can_empty")
			    else
                  pbSEPlay("glug")
				end
		  end
	    end
       end
      else
        pbSEPlay("glug")
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

  if id&.is_a?(Integer)
   event = $game_map.events[id]
     if event.is_a?(Game_PokeEvent)
   pkmn = event.pokemon
   pbSEPlay("Battle ball hit")
	thefight = pbOverworldCombat
	thefight.player_action(event,item,dir)
	next true
	elsif terrain.land_wild_encounters
   if pbConfirmMessage(_INTL("Pokemon began building around the bait you through in the grass. Battle one?"))
      spriteindex = $scene.spriteset.addUserSprite(OWItemUseSprite.new(start_end,:POKEBALLC,$game_map,Spriteset_Map.viewport))
	  holding_pattern(spriteindex)
   pbSEPlay("Battle ball hit")
      pbEncounter(:Bait)
	next true
   end
	 
	 end
  elsif terrain.land_wild_encounters
   if pbConfirmMessage(_INTL("Pokemon began building around the bait you through in the grass. Battle one?"))
      spriteindex = $scene.spriteset.addUserSprite(OWItemUseSprite.new(start_end,:POKEBALLC,$game_map,Spriteset_Map.viewport))
	  holding_pattern(spriteindex)
   pbSEPlay("Battle ball hit")
      pbEncounter(:Bait)
	next true
   end
  end
  end



next false
  }
)
ItemHandlers::UseFromBag.add(:BAIT,proc { |item|
   amt = 3
     next 2
   start_end = getLandingCoords(amt)
   spriteindex = $scene.spriteset.addUserSprite(OWItemUseSprite.new(start_end,item,$game_map,Spriteset_Map.viewport))
   holding_pattern(spriteindex)
    $bag.remove(item)
   pbSEPlay("Battle ball hit")
   if pbConfirmMessage(_INTL("POKeMON began fighting over the bait you threw in the grass. Battle one?"))
    spriteindex =  $scene.spriteset.addUserSprite(OWItemUseSprite.new(start_end,:POKEBALLC,$game_map,Spriteset_Map.viewport))
	 holding_pattern(spriteindex)
   pbSEPlay("Battle ball hit")
     pbEncounter(:Bait)
     
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
	item.damage_bonus=amt
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
  if id&.is_a?(Integer)
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



ItemHandlers::UseFromBox.add(:MACHETE, proc { |item, event|
     facingEvent = event
	 facingEvent = $game_player.pbFacingEvent4 if event.nil?
	 next false if facingEvent.nil?
   can_do = decreaseStamina(5)
	next false if can_do == false
 if item.decrease_durability(1)
 if item.durability>0
   #pbSEPlay("Sword")
   start_end = getLandingCoords(1)
	 facingEvent = $game_player.pbFacingEvent
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

  if id&.is_a?(Integer)
   event = $game_map.events[id]
     if event.is_a?(Game_PokeEvent)
   pkmn = event.pokemon
	thefight = pbOverworldCombat
	thefight.player_action(event,item,dir)
	next true
	 elsif facingEvent
	   if facingEvent.name[/cuttree/i]
         $stats.cut_count += 1
         pbSmashEvent(facingEvent)
		  next true
	   end
	 
	 end
  elsif facingEvent
	   if facingEvent.name[/cuttree/i]
         $stats.cut_count += 1
         pbSmashEvent(facingEvent)
		  next true
	   end
  
  end
 end
 end

next false
  }
)
ItemHandlers::UseFromBox.add(:IRONPICKAXE,proc{|item, event|
     facingEvent = event
	 facingEvent = $game_player.pbFacingEvent4 if event.nil?
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

  if id&.is_a?(Integer)
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

 if item.decrease_durability(1)
	can_do = decreaseStamina(8)
	next 0 if can_do == false
	   case $game_player.direction
	     when 2 
		    jump(0, 3)   # down
			 next 2
	     when 4 
		    jump(-3, 0)    # left
			 next 2
	     when 6 
		    jump(3, 0)   # right
			 next 2
	     when 8 
		    jump(0, -3)    # up 
			 next 2
	   end
 end
    next 0	   

	}
)
class Interpreter


  def getVariableOther(event_id,map_id=$game_map.map_id)
      return nil if !$PokemonGlobal.eventvars
      return $PokemonGlobal.eventvars[[map_id, event_id]]
  end


  def setVariableOther(setting,event_id,map_id=$game_map.map_id)
      $PokemonGlobal.eventvars = {} if !$PokemonGlobal.eventvars
      $PokemonGlobal.eventvars[[map_id, event_id]] = setting
  end
  
  def deleteVariableOther(event_id,map_id=$game_map.map_id)
   $PokemonGlobal.eventvars.delete([map_id, event_id])
  end
end






ItemHandlers::UseFromBag.add(:SHOVEL,proc{|item, event|
	 $PokemonGlobal.collection_maps[$game_map.map_id] = [] if $PokemonGlobal.collection_maps[$game_map.map_id].nil?
	 
	 facingEvent = event
	 facingEvent = $game_player.pbFacingEvent4 if event.nil?
	 facing = $game_player.pbFacingTile($game_player.direction, $game_player)
	 coords = [facing[1],facing[2]]
    terrain = $game_map.terrain_tag(facing[1], facing[2], true)
	can_do = reduceStaminaBasedOnItem(item)
	 next 0 if can_do == false
	 next 0 if facingEvent.nil? && !terrain.can_dig
    next 0 if $PokemonGlobal.collection_maps[$game_map.map_id].include?(coords)


 if item.decrease_durability(1)
	  if !pbSeenTipCard?(:SHOVEL)
	    pbShowTipCard(:SHOVEL)
	  end
	  
	  
	  if !facingEvent.nil? && facingEvent.name[/berryplant/i] && false
	     berry_plant = pbMapInterpreter.getVariableOther(facingEvent.id)
		  if berry_plant
		  berry = berry_plant.berry_obj
    if berry_plant.growing? && berry_plant.growth_stage == 1
        if pbConfirmMessage(_INTL("You may be able to dig up the berry. Dig up the {1}?", GameData::Item.get(berry).name))
            berry_plant.reset
            if rand(100) < 50 || $player.is_it_this_class?(:GARDENER)
                $bag.add(berry)
                pbMessage(_INTL("The dug up {1} was in good enough condition to keep.",GameData::Item.get(berry).name))
            else
                pbMessage(_INTL("The dug up {1} broke apart in your hands.",GameData::Item.get(berry).name))
            end
               next 2
        end
    end
         end
	   
     elsif terrain.can_dig
	   $PokemonGlobal.collection_maps[$game_map.map_id] = [] if $PokemonGlobal.collection_maps[$game_map.map_id].nil?
	   if !$PokemonGlobal.collection_maps[$game_map.map_id].include?(coords)
	     pbSEPlay("shovel")
	     pbCollectionMain2
		  amt = 1
	      amt = 2 if $player.is_it_this_class?(:COLLECTOR)
	     $PokemonGlobal.collection_maps[$game_map.map_id] << coords
         next 2
	   else
	  	 pbSEPlay("shovelhittingrock")
	 
	   end

	  end
 end
     next 0

	}
)





ItemHandlers::UseFromBag.add(:PORTABLECAMP,proc{|item|
    next 0 if !$player.held_item_object.nil?
    next 0 if !$player.held_item.nil?
  pbFadeOutIn {
    if $game_map.metadata&.outdoor_map || $game_map.name.include?("Test")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.outdoor_map || $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.outdoor_map  || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.outdoor_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.outdoor_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.metadata&.outdoor_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
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
	if $game_map.metadata&.base_map || $game_map.name.include?("Test") || $game_map.name.include?("Challenge")
    if pbPlaceorHold(item)
	$bag.remove(item)
    next 2
	else
	end
	end
	}
})













