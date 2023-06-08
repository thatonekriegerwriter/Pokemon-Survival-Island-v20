#==============================================================================#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
#==============================================================================#
#                                                                              #
#                             Survival Mode                                    #
#                          By thatonekriegerwriter                             #
#                 Original Hunger Script by Maurili and Vendily                #
#                                                                              #
#                                                                              #
#                                                                              #
#==============================================================================#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
#==============================================================================#
#Thanks Maurili and Vendily for the Original Hunger Script  

class Pokemon


  def changeFood
    if @food.nil?
	 @food = 100
	end
    gain = 0
    food_range = @food / 100
    gain = [-1, -2, -2][food_range]
    @food = (@food + gain).clamp(0, 255)
  end
  
  def changeWater
    if @water.nil?
	 @water = 100
	end
    gain = 0
    water_range = @water / 100
    gain = [-1, -2, -2][water_range]
    @water = (@water + gain).clamp(0, 255)
  end
  
  def changeSleep
    if @sleep.nil?
	 @sleep = 100
	end
    gain = 0
    sleep_range = @sleep / 100
    gain = [-1, -2, -2][sleep_range]
    @sleep = (@sleep + gain).clamp(0, 255)
  end
  
  def changeLifespan(method,pkmn)
    if @lifespan.nil?
	 @lifespan = 50
	end
    gain = 0
    lifespan_range = @lifespan / 100
      case method
      when "age"
        gain = [-1, -1, -1][lifespan_range]
      when "dehydrated"
        gain = [-2, -1, -2][lifespan_range]
      when "starving"
        gain = [-2, -2, -1][lifespan_range]
      when "dehydratedbadly"
        gain = [-9, -10, -9][lifespan_range]
      when "starvingbadly"
        gain = [-9, -10, -9][lifespan_range]
	  end
    @lifespan = (@lifespan + gain).clamp(0, 255)
  end
  
  def changeAge
    if @age.nil?
	 @age = 1
	end
    gain = 0
    age_range = @age / 100
    gain = [1, 1, 1][age_range]
    @age = (@age + gain).clamp(0, 255)
  end
  
  
  
end

class Player < Trainer

  def playerwater=(value)
    validate value => Integer
    @playerwater = value.clamp(0, 100)
  end
  def playerfood=(value)
    validate value => Integer
    @playerfood = value.clamp(0, 100)
  end
  def playersaturation=(value)
    validate value => Integer
    @playersaturation = value.clamp(0, 100)
  end
  def playersleep=(value)
    validate value => Integer
    @playersleep = value.clamp(0, 200)
  end
  def playerhealth=(value)
    validate value => Integer
    @playerhealth = value.clamp(0, 100)
  end
  def playerstamina=(value)
    validate value => Float
    @playerstamina = value.clamp(0, 1000)
  end
  def playermaxstamina=(value)
    validate value => Float
    @playermaxstamina = value.clamp(0, 9999)
  end
  def playerstaminamod=(value)
    validate value => Float
    @playerstaminamod = value.clamp(0, 50)
  end
end

def pbSetTemperature
  $PokemonSystem.temperaturemeasurement = 18 if (pbGetTimeNow.mon==3 && pbGetTimeNow.day==22)
  $PokemonSystem.temperaturemeasurement = 35 if (pbGetTimeNow.mon==6 && pbGetTimeNow.day==21)
  $PokemonSystem.temperaturemeasurement = 12 if (pbGetTimeNow.mon==9 && pbGetTimeNow.day==21)
  $PokemonSystem.temperaturemeasurement = 0 if (pbGetTimeNow.mon == 10 && pbGetTimeNow.day ==22)
end

def pbAmbientTemperature
   case pbGetTimeNow.mon
   when 0 #Jan
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement-7 #ambienttemperature
   when 1 #Feb
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement-5
   when 2 #Mar
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement-1
   when 3 #April
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement-0
   when 4 #may
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+1
   when 5 #june
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+2
   when 6 #july
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+5
   when 7 #august
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+7
   when 8 #september
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+1
   when 9 #october
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+3
   when 10 #november
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+4
   when 11 #december
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+6
 end

end

def pbSleepRestore(wari,vari=nil)
##########PLAYER###################
#       Stamina   #
  $player.playerstamina = $player.playermaxstamina
#       Sleep     #
  if vari.nil?
  $player.playersleep = $player.playersleep.to_i+(wari*9)
  else
  $player.playersleep = $player.playersleep.to_i-(wari*9)
  end
  if $player.playersleep > 200
  $player.playersleep = 200  
  end
  if $player.playersleep < 0
  $player.playersleep = 0  
  end
#       FoodWater     #
 if $player.playersaturation==0
   $player.playerfood=$player.playerfood-(wari*2)
   $player.playerwater=$player.playerwater-(wari*2)
  else
   if $player.playersaturation-(wari*7) < 0
    potato = $player.playersaturation-(wari*7)
	$player.playersaturation=0
   $player.playerfood=$player.playerfood+(potato*2)
   $player.playerwater=$player.playerwater+(potato*2)
   else
   $player.playersaturation=$player.playersaturation-(wari*7)
   end
 end

##########POKEMON###################

				party = $player.party
                 for i in 0...party.length
				pkmn = party[i]
				if pkmn.sleep.nil?
				 pkmn.sleep = 100
				end
				 pkmn.sleep=pkmn.sleep+(wari*9)
				 if pkmn.sleep > 100
				 pkmn.sleep= 100  
				 end
				 pkmn.food=pkmn.food-(wari*2)
				 pkmn.water=pkmn.water-(wari*2)
				 end
#       Daycare     #
  deposited = DayCare.count
  if deposited==2 && $PokemonGlobal.daycareEgg==0
    $PokemonGlobal.daycareEggSteps = 0 if !$PokemonGlobal.daycareEggSteps
    $PokemonGlobal.daycareEggSteps += (1*wari*10)
  end
 end
 
 
 
 def pbEatingPkmn(pkmn,item=nil)
 if item.nil?
 item = 0
pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
item = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_foodwater? })
}
 end
if item
pbMessage(_INTL("You offered {1} a {2}.",pkmn.name,GameData::Item.get(item).name))
$bag.remove(item)
pbMessage(_INTL("{1} takes it happily!",pkmn.name,GameData::Item.get(item).name))
case item
when :ORANBERRY
pkmn.food+=25
pkmn.water+=25
return true
when :LEPPABERRY
pkmn.food+=50
pkmn.water+=25
return true
when :CHERIBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :CHESTOBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :PECHABERRY
pkmn.food+=50
pkmn.water+=25
return true
when :RAWSTBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :ASPEARBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :PERSIMBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :LUMBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :FIGYBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :WIKIBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :MAGOBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :AGUAVBERRY
pkmn.food+=50
pkmn.water+=25
return true
when :IAPAPABERRY
pkmn.food+=50
pkmn.water+=25
return true
when :IAPAPABERRY
pkmn.food+=50
pkmn.water+=25
return true
when :SITRUSBERRY
pkmn.food+=50
pkmn.water+=10
return true
when :BERRYJUICE
pkmn.food+=25
pkmn.water+=100
return true
when :FRESHWATER
pkmn.water+=100
$bag.add(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return true
when :ATKCURRY
pkmn.food+=80
return true
when :SATKCURRY
pkmn.food+=80
return true
when :SPEEDCURRY
pkmn.food+=80
return true
when :SPDEFCURRY
pkmn.food+=80
return true
when :ACCCURRY
pkmn.food+=80
return true
when :DEFCURRY
pkmn.food+=80
return true
when :CRITCURRY
pkmn.food+=80
return true
when :GSCURRY
pkmn.food+=80
return true
when :RAGECANDYBAR #chocolate
pkmn.food+=100
return true
when :SWEETHEART #chocolate
pkmn.food+=100
return true
when :SODAPOP
pkmn.water-=100
return true
$bag.add(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return true
when :LEMONADE
pkmn.water+=100
return true
$bag.add(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return true
when :HONEY
pkmn.water+=20
pkmn.food+=60
return true
when :MOOMOOMILK
pkmn.water+=100
$bag.add(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return true
when :CSLOWPOKETAIL
pkmn.food+=100
return true
when :BAKEDPOTATO
pkmn.water+=40
pkmn.food+=70
return true
when :APPLE
pkmn.water+=30
pkmn.food+=30
return true
when :CHOCOLATE
pkmn.food+=70
return true
when :LEMON
pkmn.water+=30
pkmn.food+=40
return true
when :OLDGATEAU
pkmn.water+=20
pkmn.food+=60
return true
when :LAVACOOKIE
pkmn.food+=60
return true
when :CASTELIACONE
pkmn.water+=70
pkmn.food+=70
return true
when :LUMIOSEGALETTE
pkmn.food+=60
return true
when :SHALOURSABLE
pkmn.food+=80
return true
when :BIGMALASADA
pkmn.food+=80
return true
when :ONION
pkmn.water+=30
pkmn.food+=30
return true
when :COOKEDORAN
pkmn.water+=10
pkmn.food+=60
return true
when :CARROT
pkmn.water+=30
pkmn.food+=30
return true
when :BREAD
pkmn.water+=70
return true
when :TEA
pkmn.water+=80
pkmn.food+=20
return true
when :CARROTCAKE
pkmn.water+=100
pkmn.food+=100
return true
when :COOKEDMEAT
pkmn.food+=100
return true
when :SITRUSJUICE
pkmn.water+=100
$bag.add(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return true
when :BERRYMASH
pkmn.water+=50
pkmn.food+=50
return true
when :LARGEMEAL
pkmn.water+=500#206 is Thirst
pkmn.food+=500#205 is Hunger
party = $player.party
 for i in 0...party.length
   pkmn = party[i]
   pkmn.ev[:DEFENSE] += 1
   pkmn.ev[:HP] += 1
 end
return true
else
$bag.add(item,1)
return false
end
end
end

 
 def pbEating(bag=nil,item=nil)
 if item.nil?
 item = 0
pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
item = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_foodwater? })
}
 end
if $bag.remove(item,1)
if item == :ORANBERRY
$player.playerfood+=1
$player.playerhealth += 1
return true
elsif item == :LEPPABERRY
$player.playerfood+=1
return true
elsif item == :CHERIBERRY

$player.playerfood+=1
return true
elsif item == :CHESTOBERRY

$player.playerfood+=1
return true
elsif item == :PECHABERRY

$player.playerfood+=1
return true
elsif item == :RAWSTBERRY

$player.playerfood+=1
return true
elsif item == :ASPEARBERRY

$player.playerfood+=1
return true
elsif item == :PERSIMBERRY

$player.playerfood+=1
return true
elsif item == :LUMBERRY

$player.playerfood+=1
return true
elsif item == :FIGYBERRY

$player.playerfood+=1
return true
elsif item == :WIKIBERRY

$player.playerfood+=1
return true
elsif item == :MAGOBERRY

$player.playerfood+=1
return true
elsif item == :AGUAVBERRY

$player.playerfood+=1
return true
elsif item == :IAPAPABERRY

$player.playerfood+=1
return true
elsif item == :IAPAPABERRY

$player.playerfood+=1
return true
elsif item == :SITRUSBERRY

$player.playerfood+=1
$player.playerhealth += ($player.playerhealth/4)
return true
elsif item == :BERRYJUICE

$player.playerwater+=10
$player.playerhealth += 5
return true
elsif item == :FRESHWATER

$player.playerwater+=20
$bag.add(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return true
#You can add more if you want
elsif item == :ATKCURRY

$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return true
elsif item == :SATKCURRY

$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return true
elsif item == :SPEEDCURRY

$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return true
elsif item == :SPDEFCURRY

$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return true
elsif item == :ACCCURRY

$player.playerfood+=8
$player.playersaturation+=12
$player.playerwater-=7
return true
elsif item == :DEFCURRY

$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return true
elsif item == :CRITCURRY

$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return true
elsif item == :GSCURRY

$player.playerfood+=8#205 is Hunger
$player.playersaturation+=15#207 is Saturation
$player.playerwater-=7#206 is Thirst
return true
elsif item == :RAGECANDYBAR #chocolate

$player.playerfood+=10
$player.playersaturation+=3
$player.playersleep+=7
return true
elsif item == :SWEETHEART #chocolate

$player.playerfood+=10#205 is Hunger
$player.playersaturation+=5#207 is Saturation
$player.playersleep+=6#208 is Sleep
return true
elsif item == :SODAPOP

$player.playerwater-=11#206 is Thirst
$player.playersaturation+=30#207 is Saturation
$player.playersleep+=25#208 is Sleep
return true
$bag.add(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return true
elsif item == :LEMONADE

$player.playersaturation+=11#207 is Saturation
$player.playerwater+=10#206 is Thirst
$player.playersleep+=7#208 is Sleep
return true
$bag.add(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return true
elsif item == :HONEY

$player.playersaturation+=20#207 is Saturation
return true
elsif item == :MOOMOOMILK

$player.playersaturation+=10
$player.playerwater+=15
$bag.add(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return true
elsif item == :CSLOWPOKETAIL

$player.playersaturation+=20#207 is Saturation
$player.playerfood+=20#205 is Hunger
return true
elsif item == :BAKEDPOTATO

$player.playersaturation+=10#207 is Saturation
$player.playerwater+=4#206 is Thirst
$player.playerfood+=7#205 is Hunger
return true
elsif item == :APPLE

$player.playerwater+=1#206 is Thirst
$player.playerfood+=1#205 is Hunger
return true
elsif item == :CHOCOLATE

$player.playersaturation+=5#207 is Saturation
$player.playerfood+=7#205 is Hunger
return true
elsif item == :LEMON

$player.playerfood+=1#205 is Hunger
return true
elsif item == :OLDGATEAU

$player.playersaturation+=6#207 is Saturation
$player.playerwater+=2#206 is Thirst
$player.playerfood+=6#205 is Hunger
return true
elsif item == :LAVACOOKIE

$player.playersaturation+=5#207 is Saturation
$player.playerwater-=3#206 is Thirst
$player.playerfood+=6#205 is Hunger
return true
elsif item == :CASTELIACONE

$player.playerwater+=7#206 is Thirst
$player.playerfood+=7#205 is Hunger
return true
elsif item == :LUMIOSEGALETTE

$player.playersaturation+=5#207 is Saturation
$player.playerfood+=6#205 is Hunger
return true
elsif item == :SHALOURSABLE

$player.playersaturation+=8#207 is Saturation
$player.playerfood+=8#205 is Hunger
return true
elsif item == :BIGMALASADA

$player.playersaturation+=8#207 is Saturation
$player.playerfood+=8#205 is Hunger
return true
elsif item == :ONION

$player.playerwater+=1#206 is Thirst
$player.playerfood+=1#205 is Hunger
return true
elsif item == :COOKEDORAN

$player.playersaturation+=2#207 is Saturation
$player.playerhealth+=2#206 is Thirst
$player.playerfood+=6#205 is Hunger
return true
elsif item == :CARROT

$player.playersaturation+=6#207 is Saturation
$player.playerwater+=1#206 is Thirst
$player.playerfood+=1#205 is Hunger
return true
elsif item == :BREAD

$player.playersaturation+=10#207 is Saturation
$player.playerwater+=7#206 is Thirst
$player.playerfood+=11#205 is Hunger
return true
elsif item == :TEA

$player.playersaturation+=15#207 is Saturation
$player.playerwater+=8#206 is Thirst
$player.playerfood+=2#205 is Hunger
return true
elsif item == :CARROTCAKE

$player.playersaturation+=15#207 is Saturation
$player.playerwater+=15#206 is Thirst
$player.playerfood+=10#205 is Hunger
return true
elsif item == :COOKEDMEAT

$player.playersaturation+=40#207 is Saturation
$player.playerfood+=10#205 is Hunger
return true
elsif item == :SITRUSJUICE

$player.playersaturation+=20#207 is Saturation
$player.playerwater+=6#206 is Thirst
$player.playerfood+=0#205 is Hunger
$player.playerhealth+= 25#205 is Hunger
$bag.add(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return true
elsif item == :BERRYMASH

$player.playersaturation+=5#207 is Saturation
$player.playerwater+=5#206 is Thirst
$player.playerfood+=5#205 is Hunger
return true
elsif item == :LARGEMEAL
pbMessage(_INTL("You feasted on the {1}.",GameData::Item.get(item).name))
$player.playersaturation+=50#207 is Saturation
$player.playerwater+=50#206 is Thirst
$player.playerfood+=50#205 is Hunger
$player.playerstaminamod+=15#205 is Hunger
 if @pokemon_count==6
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[2].ev[:DEFENSE] += 1
  @party[3].ev[:DEFENSE] += 1
  @party[4].ev[:DEFENSE] += 1
  @party[5].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
  @party[2].ev[:HP] += 1
  @party[3].ev[:HP] += 1
  @party[4].ev[:HP] += 1
  @party[5].ev[:HP] += 1
 elsif @pokemon_count==5
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[2].ev[:DEFENSE] += 1
  @party[3].ev[:DEFENSE] += 1
  @party[4].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
  @party[2].ev[:HP] += 1
  @party[3].ev[:HP] += 1
  @party[4].ev[:HP] += 1
 elsif @pokemon_count==4
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[2].ev[:DEFENSE] += 1
  @party[3].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
  @party[2].ev[:HP] += 1
  @party[3].ev[:HP] += 1
 elsif @pokemon_count==3
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[2].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
  @party[2].ev[:HP] += 1
 elsif @pokemon_count==2
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
 elsif @pokemon_count==1
  @party[0].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
 end
return true
else
$bag.add(item,1)
return false
end
else
pbMessage(_INTL("What the fuck.",GameData::Item.get(item).name))
end
end



 def pbMedicine(bag=nil,item=nil)
return if $player.playerhealth == 100
pbMessage(_INTL("You used {1} to heal yourself.",GameData::Item.get(item).name))
$bag.remove(item)
#205 is Hunger, 207 is Saturation, 206 is Thirst, 208 is Sleep
if item == :POTION
$player.playerhealth += 20
return true
elsif item == :SUPERPOTION
$player.playerhealth += 40
return true
elsif item == :HYPERPOTION
$player.playerhealth += 60
return true
elsif item == :FULLRESTORE
$player.playerhealth += 100
return true
else
$bag.add(item,1)
return 0
#full belly
end
end



def checkSeconds(seconds)
  timeNow= pbGetTimeNow
  timeSeconds = seconds
  return true if timeNow >= timeSeconds
end

def pbGeneralCheck
  if pbGetTimeNow-$PokemonGlobal.generalTime>=24*60*60
   return true
  else 
   return false
  end
end

def checkHours(hour) # Hour is 0..23
  timeNow = pbGetTimeNow.hour
  timeHour = hour
  return true if timeNow == timeHour 
end

class PokemonSystem
  attr_accessor :survivalmode
  attr_accessor :temperature

  def initialize
    @textspeed     = 1     # Text speed (0=slow, 1=normal, 2=fast)
    @battlescene   = 0     # Battle effects (animations) (0=on, 1=off)
    @battlestyle   = 0     # Battle style (0=switch, 1=set)
    @sendtoboxes   = 0     # Send to Boxes (0=manual, 1=automatic)
    @givenicknames = 0     # Give nicknames (0=give, 1=don't give)
    @frame         = 0     # Default window frame (see also Settings::MENU_WINDOWSKINS)
    @textskin      = 0     # Speech frame
    @screensize    = (Settings::SCREEN_SCALE * 2).floor - 1   # 0=half size, 1=full size, 2=full-and-a-half size, 3=double size
    @language      = 0     # Language (see also Settings::LANGUAGES in script PokemonSystem)
    @runstyle      = 0     # Default movement speed (0=walk, 1=run)
    @bgmvolume     = 100   # Volume of background music and ME
    @sevolume      = 100   # Volume of sound effects
    @textinput     = 0     # Text input mode (0=cursor, 1=keyboard)
    @temperature = 1     # Default Temperature Mode (0=on, 1=off)	 
    @nuzlockemode = 1     # Default Nuzlocke Mode (0=on, 1=off)
  end
end




MenuHandlers.add(:options_menu, :survivalmode, {
  "name"        => _INTL("Survival Mode"),
  "order"       => 37,
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "description" => _INTL("Choose whether or not you play in Survival Mode."),
  "get_proc"    => proc { next $PokemonSystem.survivalmode },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.survivalmode = value }
})

MenuHandlers.add(:options_menu, :temperature, {
  "name"        => _INTL("Ambient Temperature"),
  "order"       => 39,
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "description" => _INTL("Choose whether or not Survival Mode has Temperature Mechanics."),
  "get_proc"    => proc { next $PokemonSystem.temperature },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.temperature = value }
})