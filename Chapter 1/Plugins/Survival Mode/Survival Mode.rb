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
#Thanks Maurili and Vendily for the Original Hunger Script                     #
class PokemonGlobalMetadata

  attr_accessor :pkmnfoodSteps
  attr_accessor :pkmnthirstSteps
  attr_accessor :playerfoodSteps
  attr_accessor :playerwaterSteps
  attr_accessor :playersleepSteps
  attr_accessor :playersaturationSteps
  
  
  EventHandlers.add(:on_step_taken, :foodstepsplayer,
  proc {
  $PokemonGlobal.playerfoodSteps = 0 if !$PokemonGlobal.playerfoodSteps
  $PokemonGlobal.playerfoodSteps += 1 if $SurvivalMode.playersaturation == 0
  if $PokemonGlobal.playerfoodSteps>=100
    $player.playerfood -= 1 if rand(100) == 1
    $PokemonGlobal.playerfoodSteps = 0
  end
  }
)

  EventHandlers.add(:on_step_taken, :waterstepsplayer,
  proc {
  $PokemonGlobal.playerwaterSteps = 0 if !$PokemonGlobal.playerwaterSteps
  $PokemonGlobal.playerwaterSteps += 1 if $SurvivalMode.playersaturation == 0
  if $PokemonGlobal.playerwaterSteps>=100
    $player.playerwater -= 1 if rand(100) == 1
    $PokemonGlobal.playerwaterSteps = 0
  end
  }
)

  EventHandlers.add(:on_step_taken, :saturationstepsplayer,
  proc {
  $PokemonGlobal.playersaturationSteps = 100 if !$PokemonGlobal.playersaturationSteps
  $PokemonGlobal.playersaturationSteps += 1
  if $PokemonGlobal.playersaturationSteps>=100
    $player.playersaturation -= 1 if rand(100) <= 3
    $PokemonGlobal.playersaturationSteps = 0
  end
  }
)


end


class SurvivalMode
  attr_reader :playerwater  #206
  attr_reader :playerfood   #205
  attr_reader :playersleep   #208
  attr_reader :playersaturation #207
  attr_reader :playerhealth #225
  attr_reader :playerstamina
  attr_reader :playermaxstamina
  attr_reader :playerstaminamod



  
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
    validate value => Integer
    @playerstamina = value.clamp(0, 1000)
  end
  
  def initialize  
    @playerwater   = 100   # Text speed (0=slow, 1=normal, 2=fast)
    @playerfood = 100     # Battle effects (animations) (0=on, 1=off)
    @playersaturation = 200     # Battle style (0=switch, 1=set)
    @playersleep = 100     # Battle style (0=switch, 1=set)
    @playerhealth  = 100     # Default window frame (see also Settings::MENU_WINDOWSKINS)
    @playerstamina  = 50     # Speech frame
  end



  def pbchangeFood
    if $player.playerfood < 0
	   $player.playerfood=0
	end
    if $player.playerfood>100
        $player.playerfood=100
    end
    $player.playerfood -= 1 if rand(100) == 1
  end

  def pbchangeWater
    if $player.playerwater < 0
	   $player.playerwater=0
	end
    if $player.playerwater>100
        $player.playerwater=100  #sleep
	end
    $player.playerwater -= 1 if rand(100) == 1 && $player.playersaturation==0
    $player.playerwater += 1 if rand(100) == 1 && $game_variables[256]==(:LCLOAK) && !$player.playersaturation==0
    $player.playerwater += 0 if rand(100) == 1 && $game_variables[256]==(:LCLOAK) && $player.playersaturation==0
    $player.playerwater += 2 if rand(100) == 1 && $game_variables[256]==(:SEASHOES) && $PokemonGlobal.surfing
	
	
    end
      
  def pbchangeSleep
    if $player.playersleep < 0
	   $player.playersleep=0
	end
    if $player.playersleep>200
        $player.playersleep=200  #sleep
	end
      gain = 0
	  base = 0
	  bonus = 0
      base = -1 if PBDayNight.isDay?(pbGetTimeNow)
      base = 0 if PBDayNight.isMorning?(pbGetTimeNow)
      base = -1 if PBDayNight.isAfternoon?(pbGetTimeNow)
      base = -2 if PBDayNight.isEvening?(pbGetTimeNow)
      base = -3 if PBDayNight.isNight?(pbGetTimeNow)
      bonus = -4 if $player.playerstamina < 0
    $player.playersleep += (gain + base + bonus) if rand(100) <= 1
  end

  def pbchangeSaturation
    if $player.playersaturation < 1
	   $player.playersaturation=0
	end
    $player.playersaturation -= 1 if rand(100) <= 3
    $player.playersaturation -= 4 if rand(100) == 1 && $game_variables[256]==(:LCLOAK)#take from saturation
	end

  def pbchangeStamina
  if $PokemonSystem.survivalmode == 1
  
  else
	if PBDayNight.isDay?(pbGetTimeNow) && 
	   $player..playerstaminamod=100+$player.playerstaminamod
	end
	if PBDayNight.isMorning?(pbGetTimeNow)
	   $player.playermaxstamina=100+$player.playerstaminamod
	end
	if PBDayNight.isAfternoon?(pbGetTimeNow)
	   $player.playermaxstamina=100+$player.playerstaminamod
	end
	if PBDayNight.isEvening?(pbGetTimeNow)
	   $player.playermaxstamina=70+$player.playerstaminamod
	end
	if PBDayNight.isNight?(pbGetTimeNow)
	   $player.playermaxstamina=25+$player.playerstaminamod
	end
    if $player.playerstamina < 0
	   $player.playerstamina=0
	end
	if $player.playerstamina > $player.playermaxstamina
	   $player.playerstamina = $player.playermaxstamina
	end
	if $game_player.can_run?
	   $player.playerstamina-=1 if rand(25) == 1
	else
	   $player.playerstamina+=3 if rand(50) == 1
	end
	end
end

  def pbchangeHealth
    if $player.playerhealth < 0
	   $player.playerhealth=0
	end
	if $game_variables[256]==(:IRONARMOR)
	    if $player.playerhealth>150
         $player.playerhealth=150
		end
		
    else 
	  if $player.playerhealth>100
        $player.playerhealth=100 
	   end
	end
  end


	

EventHandlers.add(:on_step_taken, :feehshtrsgAWAEGEA,
  proc {

if $PokemonSystem.survivalmode==0
pbchangeFood
pbchangeWater
pbchangeHealth
pbchangeSaturation
pbchangeSleep


end



SurvivalModeConfig::POKEMON_SURVIVAL


if rand(255)==1
 $player.pokemon_party.each do |pkmn|
  pkmn.changeWater
end
end

$player.pokemon_party.each do |pkmn|
  if pkmn.sleep == 120
    pkmn.permadeath=true
    pbMessage(_INTL("{1} seems to have passed due to old age!"))
  end
end


})

EventHandlers.add(:on_enter_map, :setup_new_map,
  proc { |old_map_id|
  if $PokemonSystem.survivalmode == 0 && $PokemonSystem.temperature == 0 && GameData::MapMetadata.get($game_map.map_id).outdoor_map

    map_infos = pbLoadMapInfos
    new_map_metadata = $game_map.metadata
    weather_chance = rand(100)
  if $game_map.name == map_infos[old_map_id].name
      old_map_metadata = GameData::MapMetadata.try_get(old_map_id)
      next if old_map_metadata&.weather
   elsif pbIsSpring == true
   $game_screen.weather(:None, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 30 && $game_map.name  == "Temperate Zone"
   elsif  pbIsSummer == true
#######################################################################################################################################
   $game_screen.weather(:None, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Sun, rand(9)+1, rand(19)+1)  if weather_chance <= 25 
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 50 && $game_map.name  == "Temperate Zone"
   elsif pbIsAutumn  == true
################################################################################################################################################
   $game_screen.weather(:None, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:HeavyRain, rand(9)+1, rand(19)+1) if weather_chance <= 15
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 50 && $game_map.name  == "Temperate Zone"
   $game_screen.weather(:HeavyRain, rand(9)+1, rand(19)+1)  if weather_chance <= 90 && $game_map.name  == "Temperate Zone"
   elsif pbIsWinter  == true
################################################################################################################################################
   $game_screen.weather(:None, rand(9)+1, rand(19)+1)  if weather_chance <= 25
   $game_screen.weather(:Snow, rand(9)+1, rand(19)+1) if weather_chance <= 15 && !$game_screen.weather_type==:Blizzard
   $game_screen.weather(:Blizzard, rand(9)+1, rand(19)+1) if weather_chance <= 40 && !$game_screen.weather_type==:Snow
   $game_screen.weather(:Snow, rand(9)+1, rand(19)+1) if weather_chance <= 15 && (!$game_screen.weather_type==:Blizzard || !$game_screen.weather_type==:Rain)&& $game_map.name  == "Temperate Zone"
   $game_screen.weather(:Blizzard, rand(9)+1, rand(19)+1) if weather_chance <= 50 && (!$game_screen.weather_type==:Snow || !$game_screen.weather_type==:Rain)&& $game_map.name  == "Temperate Zone"
   $game_screen.weather(:Rain, rand(9)+1, rand(19)+1)  if weather_chance <= 35 && $game_map.name  == "Temperate Zone" && (!$game_screen.weather_type==:Blizzard || !$game_screen.weather_type==:Snow)
  end
  


 case $game_variables[382] #Day
   when 0

   when 1

   when 2

   when 3

   when 4

   when 5

   when 6

 end

if checkHours(23)
 pbAmbientTemperature
 pbSetTemperature
end 
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
end


})





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

def pbSleepRestore
 $player.playerstamina = $player.playermaxstamina
 if $player.playersleep<200
  $player.playersleep=$player.playersleep+($game_variables[247]*9)
 end
 if $player.playersaturation<1
   $player.playerfood=$player.playerfood-($game_variables[247]*2)
   $player.playerwater=$player.playerwater-($game_variables[247]*2)
   
  else
   $player.playersaturation=$player.playersaturation-($game_variables[247]*2)
 end
  deposited = DayCare.count
  if deposited==2 && $PokemonGlobal.daycareEgg==0
    $PokemonGlobal.daycareEggSteps = 0 if !$PokemonGlobal.daycareEggSteps
    $PokemonGlobal.daycareEggSteps += (1*$game_variables[247]*10)
  end
 end

 
 def pbEating(bag,item)
 
$PokemonBag.pbDeleteItem(item)
if item == :ORANBERRY
$player.playerfood+=4
$player.playersaturation+=3
$player.playerwater+=1
$player.playerhealth += 1
return 1
elsif item == :LEPPABERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :CHERIBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :CHESTOBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :PECHABERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :RAWSTBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :ASPEARBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :PERSIMBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :LUMBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :FIGYBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :WIKIBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :MAGOBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :AGUAVBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :IAPAPABERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :IAPAPABERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :SITRUSBERRY
$player.playerfood+=5
$player.playersaturation+=7
$player.playerwater+=1
$player.playerhealth += 4
return 1
elsif item == :BERRYJUICE
$player.playerfood+=2
$player.playersaturation+=2
$player.playerwater+=10
$player.playerhealth += 2
return 1
elsif item == :FRESHWATER
$player.playerwater+=20
$player.playersaturation+=10#207 is Saturation
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
#You can add more if you want
elsif item == :ATKCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return 1
elsif item == :SATKCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return 1
elsif item == :SPEEDCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return 1
elsif item == :SPDEFCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return 1
elsif item == :ACCCURRY
$player.playerfood+=8
$player.playersaturation+=12
$player.playerwater-=7
return 1
elsif item == :DEFCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return 1
elsif item == :CRITCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return 1
elsif item == :GSCURRY
$player.playerfood+=8#205 is Hunger
$player.playersaturation+=5#207 is Saturation
$player.playerwater-=7#206 is Thirst
return 1
elsif item == :RAGECANDYBAR #chocolate
$player.playerfood+=10
$player.playersaturation+=3
$player.playersleep+=7
return 1
elsif item == :SWEETHEART #chocolate
$player.playerfood+=10#205 is Hunger
$player.playersaturation+=5#207 is Saturation
$player.playersleep+=6#208 is Sleep
return 1
elsif item == :SODAPOP
$player.playerwater-=11#206 is Thirst
$player.playersaturation+=11#207 is Saturation
$player.playersleep+=10#208 is Sleep
return 1
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
elsif item == :LEMONADE
$player.playersaturation+=11#207 is Saturation
$player.playerwater+=10#206 is Thirst
$player.playersleep+=7#208 is Sleep
return 1
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
elsif item == :HONEY
$player.playersaturation+=20#207 is Saturation
$player.playerwater+=2#206 is Thirst
$player.playerfood+=6#205 is Hunger
return 1
elsif item == :MOOMOOMILK
$player.playersaturation+=10
$player.playerwater+=15
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
elsif item == :CSLOWPOKETAIL
$player.playersaturation+=10#207 is Saturation
$player.playerfood+=10#205 is Hunger
return 1
elsif item == :BAKEDPOTATO
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=4#206 is Thirst
$player.playerfood+=7#205 is Hunger
return 1
elsif item == :APPLE
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=3#206 is Thirst
$player.playerfood+=3#205 is Hunger
return 1
elsif item == :CHOCOLATE
$player.playersaturation+=5#207 is Saturation
$player.playerfood+=7#205 is Hunger
return 1
elsif item == :LEMON
$player.playersaturation+=3#207 is Saturation
$player.playerwater+=3#206 is Thirst
$player.playerfood+=4#205 is Hunger
return 1
elsif item == :OLDGATEAU
$player.playersaturation+=6#207 is Saturation
$player.playerwater+=2#206 is Thirst
$player.playerfood+=6#205 is Hunger
return 1
elsif item == :LAVACOOKIE
$player.playersaturation+=5#207 is Saturation
$player.playerwater-=3#206 is Thirst
$player.playerfood+=6#205 is Hunger
return 1
elsif item == :CASTELIACONE
$player.playerwater+=7#206 is Thirst
$player.playerfood+=7#205 is Hunger
return 1
elsif item == :LUMIOSEGALETTE
$player.playersaturation+=5#207 is Saturation
$player.playerfood+=6#205 is Hunger
return 1
elsif item == :SHALOURSABLE
$player.playersaturation+=8#207 is Saturation
$player.playerfood+=8#205 is Hunger
return 1
elsif item == :BIGMALASADA
$player.playersaturation+=8#207 is Saturation
$player.playerfood+=8#205 is Hunger
return 1
elsif item == :ONION
$player.playersaturation+=5#207 is Saturation
$player.playerwater+=3#206 is Thirst
$player.playerfood+=3#205 is Hunger
return 1
elsif item == :COOKEDORAN
$player.playersaturation+=6#207 is Saturation
$player.playerwater+=6#206 is Thirst
$player.playerfood+=6#205 is Hunger
return 1
elsif item == :CARROT
$player.playersaturation+=6#207 is Saturation
$player.playerwater+=3#206 is Thirst
$player.playerfood+=3#205 is Hunger
return 1
elsif item == :BREAD
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=7#206 is Thirst
$player.playerfood+=11#205 is Hunger
return 1
elsif item == :TEA
$player.playersaturation+=15#207 is Saturation
$player.playerwater+=8#206 is Thirst
$player.playerfood+=2#205 is Hunger
return 1
elsif item == :CARROTCAKE
$player.playersaturation+=15#207 is Saturation
$player.playerwater+=15#206 is Thirst
$player.playerfood+=10#205 is Hunger
return 1
elsif item == :COOKEDMEAT
$player.playersaturation+=40#207 is Saturation
$player.playerwater+=0#206 is Thirst
$player.playerfood+=20#205 is Hunger
return 1
elsif item == :SITRUSJUICE
$player.playersaturation+=20#207 is Saturation
$player.playerwater+=25#206 is Thirst
$player.playerfood+=0#205 is Hunger
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
elsif item == :BERRYMASH
$player.playersaturation+=5#207 is Saturation
$player.playerwater+=5#206 is Thirst
$player.playerfood+=5#205 is Hunger
return 1
elsif item == :LARGEMEAL
$player.playersaturation+=50#207 is Saturation
$player.playerwater+=50#206 is Thirst
$player.playerfood+=50#205 is Hunger
$player.playerstaminamod+=15#205 is Hunger
 if $player.pokemon_count==6
  $player.party[0].ev[:DEFENSE] += 1
  $player.party[1].ev[:DEFENSE] += 1
  $player.party[2].ev[:DEFENSE] += 1
  $player.party[3].ev[:DEFENSE] += 1
  $player.party[4].ev[:DEFENSE] += 1
  $player.party[5].ev[:DEFENSE] += 1
  $player.party[0].ev[:HP] += 1
  $player.party[1].ev[:HP] += 1
  $player.party[2].ev[:HP] += 1
  $player.party[3].ev[:HP] += 1
  $player.party[4].ev[:HP] += 1
  $player.party[5].ev[:HP] += 1
 elsif $player.pokemon_count==5
  $player.party[0].ev[:DEFENSE] += 1
  $player.party[1].ev[:DEFENSE] += 1
  $player.party[2].ev[:DEFENSE] += 1
  $player.party[3].ev[:DEFENSE] += 1
  $player.party[4].ev[:DEFENSE] += 1
  $player.party[0].ev[:HP] += 1
  $player.party[1].ev[:HP] += 1
  $player.party[2].ev[:HP] += 1
  $player.party[3].ev[:HP] += 1
  $player.party[4].ev[:HP] += 1
 elsif $player.pokemon_count==4
  $player.party[0].ev[:DEFENSE] += 1
  $player.party[1].ev[:DEFENSE] += 1
  $player.party[2].ev[:DEFENSE] += 1
  $player.party[3].ev[:DEFENSE] += 1
  $player.party[0].ev[:HP] += 1
  $player.party[1].ev[:HP] += 1
  $player.party[2].ev[:HP] += 1
  $player.party[3].ev[:HP] += 1
 elsif $player.pokemon_count==3
  $player.party[0].ev[:DEFENSE] += 1
  $player.party[1].ev[:DEFENSE] += 1
  $player.party[2].ev[:DEFENSE] += 1
  $player.party[0].ev[:HP] += 1
  $player.party[1].ev[:HP] += 1
  $player.party[2].ev[:HP] += 1
 elsif $player.pokemon_count==2
  $player.party[0].ev[:DEFENSE] += 1
  $player.party[1].ev[:DEFENSE] += 1
  $player.party[0].ev[:HP] += 1
  $player.party[1].ev[:HP] += 1
 elsif $player.pokemon_count==1
  $player.party[0].ev[:DEFENSE] += 1
  $player.party[0].ev[:HP] += 1
 end
return 1
else
$PokemonBag.pbStoreItem(item,1)
return 0
end
end



 def pbMedicine(bag,item)
 
$PokemonBag.pbDeleteItem(item)
#205 is Hunger, 207 is Saturation, 206 is Thirst, 208 is Sleep
if item == :POTION
$player.playerhealth += 20
return 1
elsif item == :SUPERPOTION
$player.playerhealth += 40
return 1
elsif item == :HYPERPOTION
$player.playerhealth += 60
return 1
elsif item == :FULLRESTORE
$player.playerhealth += 100
return 1
else
$PokemonBag.pbStoreItem(item,1)
return 0
#full belly
end
end

def pbEndGame
 if $PokemonSystem.survivalmode = 0
  if $scene.is_a?(Scene_Map)
      pbFadeOutIn(99999){
         $game_temp.player_transferring = true
         $game_temp.player_new_map_id=292  
         $game_temp.player_new_x=002
         $game_temp.player_new_y=007
         $game_temp.player_new_direction=$PokemonGlobal.pokecenterDirection
         $scene.transfer_player
         $game_map.refresh
		 $scene = nil
		 exit!
    	 menu.pbShowMenu
      }
    end
  end
end



def pbRandomEvent
   if rand(100) == 1
     Kernel.pbMessage(_INTL("There was a sound outside."))   #Comet
     $game_switches[450]==true 
     $game_switches[451]==true 
=begin
   elsif rand(1000) == 2
     
   elsif rand(1000) == 3
     
   elsif rand(1000) == 4
     
   elsif rand(1000) == 5
     
   elsif rand(1000) == 6
=end
end
end



class Pokemon

  def changeFood
    gain = 0
    food_range = @food / 100
    gain = [-1, -2, -2][food_range]
    @food = (@food + gain).clamp(0, 255)
  end
  
  def changeWater
    gain = 0
    water_range = @water / 100
    gain = [-1, -2, -2][water_range]
    @water = (@water + gain).clamp(0, 255)
  end
  
  def changeAge
    gain = 0
    age_range = @age / 100
    gain = [-1, -2, -2][age_range]
    @age = (@age + gain).clamp(0, 255)
  end
  
  
  
  
  def pbPokeAging(pkmn)
   oldtimenow=0
   timenow=0
   time=0
  oldtimenow = timenow
  timenow = pbGetTimeNow.to_i
   time = timenow-oldtimenow
   if time >= 11059200 && !timenow=0 && !pkmn.egg?
     pkmn.sleep+=1
   end
   if pkmn.sleep >=180
     pkmn.permadeath=true
   end
end
end





end



def checkHours(hour) # Hour is 0..23
  timeNow = pbGetTimeNow.hour
  timeHour = hour
  return true if timeNow == timeHour 
end
