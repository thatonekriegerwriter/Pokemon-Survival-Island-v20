
class ElectricityPower
	attr_reader :users
	attr_reader :producers
	attr_reader :pokemonpowered
	attr_reader :globalPower
	
	
def initialize
	@producers = []
	@users      = []
	@pokemonpowered      = []
	@globalPower      = 0
end

def users
return @users
end
def producers
return @producers
end
def pokemonpowered
return @pokemonpowered
end
def globalPower
return @globalPower
end

  def users=(value)
    @users = value
  end
  def producers=(value)
    @producers = value
  end
  def pokemonpowered=(value)
    @pokemonpowered = value
  end
  def globalPower=(value)
    @globalPower = value
  end
end


SaveData.register(:electricity) do
  ensure_class :ElectricityPower 
  save_value { $ElectricityPower  }
  load_value { |value| $ElectricityPower = value }
  new_game_value {
    ElectricityPower.new
  }
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
pbDisposeMessageWindow(powerwindow)
powerwindow = pbDisplayPowerWindow(msgwindow)
message=_INTL("Do you want to toss {1} in again?",GameData::Item.get(coal).name)
if pbConfirmMessage(message)
else
pbDisposeMessageWindow(powerwindow)
pbDisposeMessageWindow(msgwindow)
 break
end
end

message=_INTL("Do you want to toss something else in?")
end
if pbConfirmMessage(message) && coal
else
interp.setVariable(localPower)
localPower = interp.getVariable
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
localMeter=amtpsec
interp.setVariable(localMeter)
end

def pbLocalPowerConsumption(amtpsec)
interp = pbMapInterpreter
this_event = interp.get_self
localMeter = interp.getVariable
if !localMeter
localMeter=0
end
localMeter=amtpsec
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
  return pbLocalPowerGeneration($ElectricityPower.pokemonpowered.length)
end

def pbAddPokemonToGeneration(pkmn)
$ElectricityPower.pokemonpowered.append(pkmn)
end
def pbRemovePokemonToSanity(pkmn)
pbStorePokemon(pkmn)
$ElectricityPower.pokemonpowered.delete(pkmn)
end
#This is the main logic line that the script is working from.
def pbPowerManagement
	pbPowerProducer
	pbPowerUser
	  amt = 0
	globalMeter = $PokemonGlobal.eventvars[[41,62]]
    if globalMeter
	  $ElectricityPower.producers.each do |sub_array|
	  if sub_array[0]==4143
	   amt+=sub_array[1]
	   $ElectricityPower.producers.delete_if { |sub_array| sub_array[0] == 4143 }
	  else
	   amt+=sub_array[1] if rand(1700) < 1 && !$game_temp.in_menu
	  end
	  end
	  globalMeter+=amt
	  if globalMeter!=0
	  end
	  $ElectricityPower.users.each do |sub_array|
	   amt+=sub_array[1]
	  end
	   globalMeter-=amt if rand(1800) < 1 && !$game_temp.in_menu
	  if globalMeter<=0
	    globalMeter=0
	  elsif globalMeter>=100
	    globalMeter=100
	  else
	  end
	$ElectricityPower.globalPower = globalMeter
   $PokemonGlobal.eventvars[[41,62]] = $ElectricityPower.globalPower
    end
end
def pbSetPower(wari)
$ElectricityPower.globalPower = wari
$PokemonGlobal.eventvars[[41,62]] = wari
end
#For produce, it is producing energy every time it can.
def pbPowerProducer
    coalPower = $PokemonGlobal.eventvars[[41,43]]
	if $PokemonGlobal.eventvars[[41,43]]!=0
	end
	if coalPower!=0
	end
    if coalPower
	 exists = $ElectricityPower.producers.any? { |sub_array| sub_array[0] == 4143 }
	 if coalPower>0 && !exists
       $ElectricityPower.producers.append([4143,coalPower])
	   coalPower = 0
	   $PokemonGlobal.eventvars[[41,43]] = 0
	 elsif exists && coalPower!=0
	    matches = $ElectricityPower.producers.any? { |sub_array| sub_array[1] == pokePower }
	  if !matches 
	   $ElectricityPower.producers.delete_if { |sub_array| sub_array[0] == 4150 }
       $ElectricityPower.producers.append([4150,pokePower])
	  end 
	 else
	   $ElectricityPower.producers.delete_if { |sub_array| sub_array[0] == 4143 }
	 end
    end
    return false if pbPowerOut?
    if $game_variables[422]==true
    pokePower = $PokemonGlobal.eventvars[[41,50]]
	exists = $ElectricityPower.producers.any? { |sub_array| sub_array[0] == 4150 }
    if pokePower
       $ElectricityPower.producers.append([4150,pokePower])
	 elsif exists && pokePower!=0
	    matches = $ElectricityPower.producers.any? { |sub_array| sub_array[1] == pokePower }
	  if !matches 
	   $ElectricityPower.producers.delete_if { |sub_array| sub_array[0] == 4150 }
       $ElectricityPower.producers.append([4150,pokePower])
	  end 
	 else
	   $ElectricityPower.producers.delete_if { |sub_array| sub_array[0] == 4150 }
    end
    end
    if $game_variables[420]==true
	windPower = $PokemonGlobal.eventvars[[54,2]]
	exists = $ElectricityPower.producers.any? { |sub_array| sub_array[0] == 5443 }
    if windPower
       $ElectricityPower.producers.append([5443,windPower])
	 elsif exists && windPower!=0
	    matches = $ElectricityPower.producers.any? { |sub_array| sub_array[1] == windPower }
	  if !matches 
	   $ElectricityPower.producers.delete_if { |sub_array| sub_array[0] == 5443 }
       $ElectricityPower.producers.append([5443,windPower])
	  end 
	 else
	   $ElectricityPower.producers.delete_if { |sub_array| sub_array[0] == 5443 }
    end
    end
    if $game_variables[418]==true
    solarPower = $PokemonGlobal.eventvars[[54,22]]
	exists = $ElectricityPower.producers.any? { |sub_array| sub_array[0] == 5422 }
    if solarPower
	   $ElectricityPower.producers.delete_if { |sub_array| sub_array[0] == 5422 }
       $ElectricityPower.producers.append([5422,solarPower])
	 elsif exists && solarPower!=0
	    matches = $ElectricityPower.producers.any? { |sub_array| sub_array[1] == solarPower }
	  if !matches 
	   $ElectricityPower.producers.delete_if { |sub_array| sub_array[0] == 5422 }
       $ElectricityPower.producers.append([5422,solarPower])
	  end 
	
	 else
	   $ElectricityPower.producers.delete_if { |sub_array| sub_array[0] == 5422 }
    end
    end
end
#For use, it merely checks to see if the Machine is on to drain power.
#If a machine is currently at use, the power drain is higher,
#It will always drain some power, however.
#If use is at 0, the machine is off.
def pbPowerUser
return false if pbPowerOut?
    grinderUse = $PokemonGlobal.eventvars[[41,44]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 5422 }
    if grinderUse
	 if grinderUse>0 && !exists
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4144 }
       $ElectricityPower.users.append([4144,grinderUse])
	 elsif exists && grinderUse!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == grinderUse }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4144 }
       $ElectricityPower.users.append([4144,solarPower])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4144 }
	 end
    end
    furnaceUse = $PokemonGlobal.eventvars[[41,45]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 4145 }
    if furnaceUse
	 if furnaceUse>0 && !exists
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4145 }
       $ElectricityPower.users.append([4145,furnaceUse])
	 elsif exists && furnaceUse!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == furnaceUse }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4145 }
       $ElectricityPower.users.append([4145,furnaceUse])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4145 }
	 end
    end
    apricornUse = $PokemonGlobal.eventvars[[41,46]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 4144 }
    if apricornUse
	 if apricornUse>0 && !exists
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4144 }
       $ElectricityPower.users.append([4146,apricornUse])
	 elsif exists && apricornUse!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == apricornUse }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4146 }
       $ElectricityPower.users.append([4146,apricornUse])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4144 }
	 end
    end
    pressUse = $PokemonGlobal.eventvars[[41,48]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 4148 }
    if pressUse
	 if pressUse>0 && !exists
       $ElectricityPower.users.append([4148,pressUse])
	 elsif exists && pressUse!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == pressUse }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4148 }
       $ElectricityPower.users.append([4148,pressUse])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4148 }
	 end
    end
    sewingUse = $PokemonGlobal.eventvars[[41,49]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 4149 }
    if sewingUse
	 if sewingUse>0 && !exists
       $ElectricityPower.users.append([4149,sewingUse])
	 elsif exists && sewingUse!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == sewingUse }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4149 }
       $ElectricityPower.users.append([4149,sewingUse])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4149 }
	 end
    end
    cutterUse = $PokemonGlobal.eventvars[[41,53]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 4153 }
    if cutterUse
	 if cutterUse>0 && !exists
       $ElectricityPower.users.append([4153,cutterUse])
	 elsif exists && cutterUse!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == cutterUse }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4153 }
       $ElectricityPower.users.append([4153,cutterUse])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 4153 }
	 end
    end
    sprinkler1Use = $PokemonGlobal.eventvars[[148,39]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 14839 }
    if sprinkler1Use
	 if sprinkler1Use>0 && !exists
       $ElectricityPower.users.append([14839,sprinkler1Use])
	 elsif exists && sprinkler1Use!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler1Use }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 14839 }
       $ElectricityPower.users.append([14839,sprinkler1Use])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 14839 }
	 end
    end
    sprinkler2Use = $PokemonGlobal.eventvars[[149,39]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 14939 }
    if sprinkler2Use
	 if sprinkler2Use>0
       $ElectricityPower.users.append([14939,sprinkler2Use])
	 elsif exists && sprinkler2Use!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler2Use }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 14939 }
       $ElectricityPower.users.append([14939,sprinkler2Use])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 14939 }
	 end
    end
    sprinkler3Use = $PokemonGlobal.eventvars[[155,38]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 15538 }
    if sprinkler3Use
	 if sprinkler3Use>0
       $ElectricityPower.users.append([15538,sprinkler3Use])
	 elsif exists && sprinkler3Use!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler3Use }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 15538 }
       $ElectricityPower.users.append([15538,sprinkler3Use])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 15538 }
	 end
    end
    sprinkler4Use = $PokemonGlobal.eventvars[[150,39]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 15039 }
    if sprinkler4Use
	 if sprinkler4Use>0
       $ElectricityPower.users.append([15039,sprinkler4Use])
	 elsif exists && sprinkler4Use!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler4Use }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 15039 }
       $ElectricityPower.users.append([15039,sprinkler4Use])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 15039 }
	 end
    end
    sprinkler5Use = $PokemonGlobal.eventvars[[151,39]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 15139 }
    if sprinkler5Use
	 if sprinkler5Use>0
       $ElectricityPower.users.append([15139,sprinkler5Use])
	 elsif exists && sprinkler5Use!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler5Use }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 15139 }
       $ElectricityPower.users.append([15139,sprinkler5Use])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 15139 }
	 end
    end
    sprinkler6Use = $PokemonGlobal.eventvars[[155,39]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 15539 }
    if sprinkler6Use
	 if sprinkler6Use>0
       $ElectricityPower.users.append([15539,sprinkler6Use])
	 elsif exists && sprinkler6Use!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler6Use }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 15539 }
       $ElectricityPower.users.append([15539,sprinkler6Use])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 15539 }
	 end
    end
    sprinkler7Use = $PokemonGlobal.eventvars[[147,39]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 14739 }
    if sprinkler7Use
	 if sprinkler7Use>0
       $ElectricityPower.users.append([14739,sprinkler7Use])
	 elsif exists && sprinkler7Use!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler7Use }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 14739 }
       $ElectricityPower.users.append([14739,sprinkler7Use])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 14739 }
	 end
    end
    sprinkler8Use = $PokemonGlobal.eventvars[[153,38]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 15338 }
    if sprinkler8Use
	 if sprinkler8Use>0
       $ElectricityPower.users.append([15338,sprinkler8Use])
	 elsif exists && sprinkler8Use!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler8Use }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 15338 }
       $ElectricityPower.users.append([15338,sprinkler8Use])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 15338 }
	 end
    end
    sprinkler9Use = $PokemonGlobal.eventvars[[154,39]]
	exists = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 15439 }
    if sprinkler9Use
	 if sprinkler9Use>0
       $ElectricityPower.users.append([15439,sprinkler9Use])
	 elsif exists && sprinkler9Use!=0
	    matches = $ElectricityPower.users.any? { |sub_array| sub_array[1] == sprinkler9Use }
	  if !matches 
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 15439 }
       $ElectricityPower.users.append([15439,sprinkler9Use])
	  end 
	 else
	   $ElectricityPower.users.delete_if { |sub_array| sub_array[0] == 15439 }
	 end
    end
return true
end

def pbPowerOut?
  globalMeter = $PokemonGlobal.eventvars[[41,62]]
  if globalMeter.nil?
  $PokemonGlobal.eventvars[[41,62]] = 0
  globalMeter = $PokemonGlobal.eventvars[[41,62]]
  end
  return true if globalMeter<1
  return false
end

def pbCurrentPower?
  return $ElectricityPower.globalPower
end

def pbCurrentPowerBiggerThan?(wari)
  if $PokemonGlobal.eventvars[[41,62]] > wari
  return true
  else
  return false
  end
end

def pbBerryWatering?(sprinkler)
    if sprinkler == 1
	exists1 = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 14839 }
	existsa1 = $ElectricityPower.users.any? { |sub_array| sub_array[1] != 0 }
	  return true
	end
    if sprinkler == 2
	exists2 = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 14939 }
	existsa2 = $ElectricityPower.users.any? { |sub_array| sub_array[1] != 0 }
	  return true
	end
    if sprinkler == 3
	exists3 = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 15538 }
	existsa3 = $ElectricityPower.users.any? { |sub_array| sub_array[1] != 0 }
	  return true
	end
    if sprinkler == 4
	exists4 = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 15039 }
	existsa4 = $ElectricityPower.users.any? { |sub_array| sub_array[1] != 0 }
	  return true
	end
    if sprinkler == 5
	exists5 = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 15139 }
	existsa5 = $ElectricityPower.users.any? { |sub_array| sub_array[1] != 0 }
	  return true
	end
    if sprinkler == 6
	exists6 = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 15539 }
	existsa6 = $ElectricityPower.users.any? { |sub_array| sub_array[1] != 0 }
	  return true
	end
    if sprinkler == 7
	exists7 = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 14739 }
	existsa7 = $ElectricityPower.users.any? { |sub_array| sub_array[1] != 0 }
	  return true
	end
    if sprinkler == 8
	exists8 = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 15338 }
	existsa8 = $ElectricityPower.users.any? { |sub_array| sub_array[1] != 0 }
	  return true
	end
    if sprinkler == 9
	exists9 = $ElectricityPower.users.any? { |sub_array| sub_array[0] == 15439 }
	existsa9 = $ElectricityPower.users.any? { |sub_array| sub_array[1] != 0 }
	  return true
	end
	return false
end


def pbMassBerryWater(num1,num2,map=nil)
  map = $game_map.map_id if map == nil
  for i in num1..num2
    berryData = $PokemonGlobal.eventvars[[map,i]]
    if berryData
        berryData.water(100)
        berryData.penaltymod(100)
    end
end
end





EventHandlers.add(:on_player_step_taken_can_transfer, :gegegegegegegeeg2,
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

if $game_switches[409]==true
pbPowerManagement
end

if pbBerryWatering?(1)
  pbMassBerryWater(2,36,155)
end
if pbBerryWatering?(2)
  pbMassBerryWater(2,36,147)
end
if pbBerryWatering?(3)
  pbMassBerryWater(2,36,148)
end
if pbBerryWatering?(4)
  pbMassBerryWater(2,36,149)
end
if pbBerryWatering?(5)
  pbMassBerryWater(2,36,150)
end
if pbBerryWatering?(6)
  pbMassBerryWater(2,36,151)
end
if pbBerryWatering?(7)
  pbMassBerryWater(2,36,152)
end
if pbBerryWatering?(8)
  pbMassBerryWater(2,36,153)
end
if pbBerryWatering?(9)
  pbMassBerryWater(2,36,154)
end
})

