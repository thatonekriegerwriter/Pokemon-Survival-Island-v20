class ElectricityPower
	attr_accessor :users
	attr_accessor :producers
	attr_accessor :pokemonpowered
	attr_accessor :globalPower
	
	
def initialize
	@producers = []
	@users      = []
	@pokemonpowered      = []
	@globalPower      = $PokemonGlobal.eventvars[[41,62]] : 0
end
end
#This is how your power the Coal Generator.
def pbChargeUp
interp = pbMapInterpreter
this_event = interp.get_self
localPower = interp.getVariable
if !localPower
localPower=0 
end
coal=0
loop do
pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
coal = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_coal? })
}
if coal
loop do
$PokemonBag.pbDeleteItem(coal,1)
msgwindow = pbCreateMessageWindow(nil,nil)
powerwindow = pbDisplayPowerWindow(msgwindow)
Kernel.pbMessage(_INTL("You toss a {1} in the Power Station.. ",GameData::Item.get(coal).name))
case coal 
 when :CHARCOAL
 localPower+=8
 when :WOODENPLANKS
 localPower+=3
 when :WOODENLOG
 localPower+=5
when :ACORN
 localPower+=1
 when :HEATROCK
 localPower+=25
 when :FIRESTONE
 localPower+=25
else
pbMessage(_INTL("It got burnt up."))
end
powerwindow = pbDisplayPowerWindow(msgwindow)
message=_INTL("Do you want to toss {1} in again?",GameData::Item.get(coal).name)
if pbConfirmMessage(message)
else
pbDisposeMessageWindow(msgwindow)
pbDisposeMessageWindow(powerwindow)
 break
end
end

message=_INTL("Do you want to toss something else in?")
end
if pbConfirmMessage(message) && coal
else
interp.setVariable(localPower)
break
end
end
end

#This is what the management event calls to set itself up.
def pbStartUp
interp = pbMapInterpreter
this_event = interp.get_self
globalMeter = interp.getVariable
if !globalMeter
globalMeter=0
interp.setVariable(globalMeter)
end
pbSetSelfSwitch(this_event, "A", true)
end


#So, this should be called every frame/step and it will passively increase/decrease power gen.
# This is not called for the Coal Generator
def pbLocalPowerGeneration(amtpsec)
interp = pbMapInterpreter
this_event = interp.get_self
localMeter = interp.getVariable
if !localMeter
localMeter=0
end
localMeter+=amtpsec
interp.setVariable(localMeter)
end

def pbLocalPowerConsumption(amtpsec)
interp = pbMapInterpreter
this_event = interp.get_self
localMeter = interp.getVariable
if !localMeter
localMeter=0
end
localMeter+=amtpsec
interp.setVariable(localMeter)
end

def pbSetPowerGeneration(map,machine,amtpsec)
localMeter = $PokemonGlobal.eventvars[[map,machine]]
if !localMeter
localMeter=0
end
localMeter+=amtpsec
interp.setVariable(localMeter)
end

def pbHowMuchPowerAmIGeneratingAgain?
  return pbLocalPowerGeneration(ElectricityPower.pokemonpowered.length)
end

def pbAddPokemonToGeneration(pkmn)
ElectricityPower.pokemonpowered.append(pkmn)
end
def pbRemovePokemonToSanity(pkmn)
pbStorePokemon(pkmn)
ElectricityPower.pokemonpowered.delete(pkmn)
end
#This is the main logic line that the script is working from.
def pbPowerManagement
    puts potato
    $PokemonGlobal.eventvars = {} if !$PokemonGlobal.eventvars
	pbPowerProducer
	pbPowerUser
	interp = pbMapInterpreter
	this_event = interp.get_self
	globalMeter = interp.getVariable
    puts globalMeter
    if globalMeter
	  ElectricityPower.producers.each do |sub_array|
	  if sub_array[0]==4143
	   globalMeter+=sub_array[1]
	   ElectricityPower.producers.delete_if { |sub_array| sub_array.first == 4143 }
	  else
	   globalMeter+=sub_array[1]
	  end
	  end
	  ElectricityPower.users.each do |sub_array|
	   globalMeter-=sub_array[1]
	  end
	  if globalMeter<=0
	    globalMeter=0
		ElectricityPower.users = []
		ElectricityPower.producers = []
	  elsif globalMeter>100
	    globalMeter=100
	  else
	  end
       interp.setVariable(globalMeter)
	   
	ElectricityPower.globalPower = globalMeter
    end
end
#For produce, it is producing energy every time it can.
def pbPowerProducer
    $PokemonGlobal.eventvars = {} if !$PokemonGlobal.eventvars
    coalPower = $PokemonGlobal.eventvars[[41,43]]
    if coalPower
	 exists = ElectricityPower.producers.any? { |sub_array| sub_array.first == 4143 }
	 if coalPower>0 && !exists
       ElectricityPower.producers.append([4143,coalPower])
	   coalPower = 0
	 elsif exists && coalPower!=0
	 else
	   ElectricityPower.producers.delete_if { |sub_array| sub_array.first == 4143 }
	 end
    end
    return false if pbPowerOut?
    pokePower = $PokemonGlobal.eventvars[[41,50]]
	exists = ElectricityPower.producers.any? { |sub_array| sub_array.first == 4150 }
    if pokePower
       ElectricityPower.producers.append([4150,pokePower])
	 elsif exists && pokePower!=0
	    matches = ElectricityPower.producers.any? { |sub_array| sub_array[1] == pokePower }
	  if !matches 
	   ElectricityPower.producers.delete_if { |sub_array| sub_array.first == 4150 }
       ElectricityPower.producers.append([4150,pokePower])
	  end 
	 else
	   ElectricityPower.producers.delete_if { |sub_array| sub_array.first == 4150 }
    end
    windPower = $PokemonGlobal.eventvars[[54,2]]
	exists = ElectricityPower.producers.any? { |sub_array| sub_array.first == 5443 }
    if windPower
       ElectricityPower.producers.append([5443,windPower])
	 elsif exists && windPower!=0
	    matches = ElectricityPower.producers.any? { |sub_array| sub_array[1] == windPower }
	  if !matches 
	   ElectricityPower.producers.delete_if { |sub_array| sub_array.first == 5443 }
       ElectricityPower.producers.append([5443,windPower])
	  end 
	 else
	   ElectricityPower.producers.delete_if { |sub_array| sub_array.first == 5443 }
    end
    solarPower = $PokemonGlobal.eventvars[[54,22]]
	exists = ElectricityPower.producers.any? { |sub_array| sub_array.first == 5422 }
    if solarPower
	   ElectricityPower.producers.delete_if { |sub_array| sub_array.first == 5422 }
       ElectricityPower.producers.append([5422,solarPower])
	 elsif exists && solarPower!=0
	    matches = ElectricityPower.producers.any? { |sub_array| sub_array[1] == solarPower }
	  if !matches 
	   ElectricityPower.producers.delete_if { |sub_array| sub_array.first == 5422 }
       ElectricityPower.producers.append([5422,solarPower])
	  end 
	 else
	   ElectricityPower.producers.delete_if { |sub_array| sub_array.first == 5422 }
    end
return true
end
#For use, it merely checks to see if the Machine is on to drain power.
#If a machine is currently at use, the power drain is higher,
#It will always drain some power, however.
#If use is at 0, the machine is off.
def pbPowerUser
$PokemonGlobal.eventvars = {} if !$PokemonGlobal.eventvars
return false if pbPowerOut?
    grinderUse = $PokemonGlobal.eventvars[[41,44]]
	exists = ElectricityPower.users.any? { |sub_array| sub_array.first == 5422 }
    if grinderUse
	 if grinderUse>0 && !exists
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4144 }
       ElectricityPower.users.append([4144,grinderUse])
	 elsif exists && grinderUse!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == grinderUse }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4144 }
       ElectricityPower.users.append([4144,solarPower])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4144 }
	 end
    end
    furnaceUse = $PokemonGlobal.eventvars[[41,45]]
    if furnaceUse
	 if furnaceUse>0 && !exists
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4145 }
       ElectricityPower.users.append([4145,furnaceUse])
	 elsif exists && furnaceUse!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == furnaceUse }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4145 }
       ElectricityPower.users.append([4145,furnaceUse])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4145 }
	 end
    end
    apricornUse = $PokemonGlobal.eventvars[[41,46]]
    if apricornUse
	 if apricornUse>0 && !exists
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4144 }
       ElectricityPower.users.append([4146,apricornUse])
	 elsif exists && apricornUse!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == apricornUse }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4146 }
       ElectricityPower.users.append([4146,apricornUse])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4144 }
	 end
    end
    pressUse = $PokemonGlobal.eventvars[[41,48]]
    if pressUse
	 if pressUse>0 && !exists
       ElectricityPower.users.append([4148,pressUse])
	 elsif exists && pressUse!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == pressUse }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4148 }
       ElectricityPower.users.append([4148,pressUse])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4148 }
	 end
    end
    sewingUse = $PokemonGlobal.eventvars[[41,49]]
    if sewingUse
	 if sewingUse>0 && !exists
       ElectricityPower.users.append([4149,sewingUse])
	 elsif exists && sewingUse!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == sewingUse }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4149 }
       ElectricityPower.users.append([4149,sewingUse])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4149 }
	 end
    end
    cutterUse = $PokemonGlobal.eventvars[[41,53]]
    if cutterUse
	 if cutterUse>0 && !exists
       ElectricityPower.users.append([4153,cutterUse])
	 elsif exists && cutterUse!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == cutterUse }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4153 }
       ElectricityPower.users.append([4153,cutterUse])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 4153 }
	 end
    end
    sprinkler1Use = $PokemonGlobal.eventvars[[148,39]]
    if sprinkler1Use
	 if sprinkler1Use>0 && !exists
       ElectricityPower.users.append([14839,sprinkler1Use])
	 elsif exists && sprinkler1Use!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler1Use }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 14839 }
       ElectricityPower.users.append([14839,sprinkler1Use])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 14839 }
	 end
    end
    sprinkler2Use = $PokemonGlobal.eventvars[[149,39]]
    if sprinkler2Use
	 if sprinkler2Use>0
       ElectricityPower.users.append([14939,sprinkler2Use])
	 elsif exists && sprinkler2Use!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler2Use }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 14939 }
       ElectricityPower.users.append([14939,sprinkler2Use])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 14939 }
	 end
    end
    sprinkler3Use = $PokemonGlobal.eventvars[[155,38]]
    if sprinkler3Use
	 if sprinkler3Use>0
       ElectricityPower.users.append([15538,sprinkler3Use])
	 elsif exists && sprinkler3Use!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler3Use }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 15538 }
       ElectricityPower.users.append([15538,sprinkler3Use])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 15538 }
	 end
    end
    sprinkler4Use = $PokemonGlobal.eventvars[[150,39]]
    if sprinkler4Use
	 if sprinkler4Use>0
       ElectricityPower.users.append([15039,sprinkler4Use])
	 elsif exists && sprinkler4Use!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler4Use }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 15039 }
       ElectricityPower.users.append([15039,sprinkler4Use])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 15039 }
	 end
    end
    sprinkler5Use = $PokemonGlobal.eventvars[[151,39]]
    if sprinkler5Use
	 if sprinkler5Use>0
       ElectricityPower.users.append([15139,sprinkler5Use])
	 elsif exists && sprinkler5Use!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler5Use }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 15139 }
       ElectricityPower.users.append([15139,sprinkler5Use])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 15139 }
	 end
    end
    sprinkler6Use = $PokemonGlobal.eventvars[[155,39]]
    if sprinkler6Use
	 if sprinkler6Use>0
       ElectricityPower.users.append([15539,sprinkler6Use])
	 elsif exists && sprinkler6Use!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler6Use }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 15539 }
       ElectricityPower.users.append([15539,sprinkler6Use])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 15539 }
	 end
    end
    sprinkler7Use = $PokemonGlobal.eventvars[[147,39]]
    if sprinkler7Use
	 if sprinkler7Use>0
       ElectricityPower.users.append([14739,sprinkler7Use])
	 elsif exists && sprinkler7Use!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler7Use }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 14739 }
       ElectricityPower.users.append([14739,sprinkler7Use])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 14739 }
	 end
    end
    sprinkler8Use = $PokemonGlobal.eventvars[[153,38]]
    if sprinkler8Use
	 if sprinkler8Use>0
       ElectricityPower.users.append([15338,sprinkler8Use])
	 elsif exists && sprinkler8Use!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler8Use }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 15338 }
       ElectricityPower.users.append([15338,sprinkler8Use])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 15338 }
	 end
    end
    sprinkler9Use = $PokemonGlobal.eventvars[[154,39]]
    if sprinkler9Use
	 if sprinkler9Use>0
       ElectricityPower.users.append([15439,sprinkler9Use])
	 elsif exists && sprinkler9Use!=0
	    matches = ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler9Use }
	  if !matches 
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 15439 }
       ElectricityPower.users.append([15439,sprinkler9Use])
	  end 
	 else
	   ElectricityPower.users.delete_if { |sub_array| sub_array.first == 15439 }
	 end
    end
return true
end

def pbPowerOut?
  globalMeter = $PokemonGlobal.eventvars[[41,62]]
  return true if globalMeter<=0
end

def pbCurrentPower?
  return ElectricityPower.globalPower
end

def pbCurrentPowerBiggerThan?(wari)
  if ElectricityPower.globalPower > wari
  return true
  else
  return false
  end
end

def pbBerryWatering?(sprinkler)
	exists1 = ElectricityPower.users.any? { |sub_array| sub_array.first == 14839 }
    if sprinkler == 1 && exists1
	  return true
	end
	exists2 = ElectricityPower.users.any? { |sub_array| sub_array.first == 14939 }
    if sprinkler == 2 && exists2
	  return true
	end
	exists3 = ElectricityPower.users.any? { |sub_array| sub_array.first == 15538 }
    if sprinkler == 3 && exists3
	  return true
	end
	exists4 = ElectricityPower.users.any? { |sub_array| sub_array.first == 15039 }
    if sprinkler == 4 && exists4
	  return true
	end
	exists5 = ElectricityPower.users.any? { |sub_array| sub_array.first == 15139 }
    if sprinkler == 5 && exists5
	  return true
	end
	exists6 = ElectricityPower.users.any? { |sub_array| sub_array.first == 15539 }
    if sprinkler == 6 && exists6
	  return true
	end
	exists7 = ElectricityPower.users.any? { |sub_array| sub_array.first == 14739 }
    if sprinkler == 7 && exists7
	  return true
	end
	exists8 = ElectricityPower.users.any? { |sub_array| sub_array.first == 15338 }
    if sprinkler == 8 && exists8
	  return true
	end
	exists9 = ElectricityPower.users.any? { |sub_array| sub_array.first == 15439 }
    if sprinkler == 9 && exists9
	  return true
	end
end


def pbMassBerryWater(num1,num2,map=nil)
  map = $game_map.map_id if map == nil
  for i in num1..num2
    berryData = $PokemonGlobal.eventvars[[map,i]]
    if berryData
      berryToReceive=berryData[1]
      if berryData[1] && berryData[4]<100
        berryData.water(100)
        berryData.penaltymod(100)
      end
    end
end
end






EventHandlers.add(:on_frame_update, :gegegegegegegeeg,
  proc {

if $game_switches[418]==true
pbLocalPowerGeneration(4)
end
if $game_switches[420]==true
pbLocalPowerGeneration(2)
end
if $game_switches[422]==true
pbHowMuchPowerAmIGeneratingAgain?
end

if pbBerryWatering?(1)
  pbLocalPowerConsumption(2)
  pbMassBerryWater(2,36,155)
end
if pbBerryWatering?(2)
  pbLocalPowerConsumption(2)
  pbMassBerryWater(2,36,147)
end
if pbBerryWatering?(3)
  pbLocalPowerConsumption(2)
  pbMassBerryWater(2,36,148)
end
if pbBerryWatering?(4)
  pbLocalPowerConsumption(2)
  pbMassBerryWater(2,36,149)
end
if pbBerryWatering?(5)
  pbLocalPowerConsumption(2)
  pbMassBerryWater(2,36,150)
end
if pbBerryWatering?(6)
  pbLocalPowerConsumption(2)
  pbMassBerryWater(2,36,151)
end
if pbBerryWatering?(7)
  pbLocalPowerConsumption(2)
  pbMassBerryWater(2,36,152)
end
if pbBerryWatering?(8)
  pbLocalPowerConsumption(2)
  pbMassBerryWater(2,36,153)
end
if pbBerryWatering?(9)
  pbLocalPowerConsumption(2)
  pbMassBerryWater(2,36,154)
end

})

