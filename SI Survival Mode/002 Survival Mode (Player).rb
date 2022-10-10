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
    validate value => Integer
    @playerstamina = value.clamp(0, 1000)
  end
  def playermaxstamina=(value)
    validate value => Integer
    @playermaxstamina = value.clamp(0, 9999)
  end
  def playerstaminamod=(value)
    validate value => Integer
    @playerstaminamod = value.clamp(0, 50)
  end
end

def pbSleepRestore(wari)
##########PLAYER###################
#       Stamina   #
  $player.playerstamina = $player.playermaxstamina
#       Sleep     #
  $player.playersleep = $player.playersleep.to_i+(wari*9)
  if $player.playersleep > 200
  $player.playersleep = 200  
  end
#       FoodWater     #
 if $player.playersaturation==0
   $player.playerfood=$player.playerfood-(wari*2)
   $player.playerwater=$player.playerwater-(wari*2)
  else
   $player.playersaturation=$player.playersaturation-(wari*2)
 end

##########POKEMON###################
if defined?(pbEatingPkmn)
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
end
if SurvivalModeConfig::SLEEPING_PROGRESSES_DAYCARE == true
#       Daycare     #
  deposited = DayCare.count
  if deposited==2 && $PokemonGlobal.daycareEgg==0
    $PokemonGlobal.daycareEggSteps = 0 if !$PokemonGlobal.daycareEggSteps
    $PokemonGlobal.daycareEggSteps += (1*wari*10)
  end
  end
 end


 
 def pbEating(bag,item)
 
pbMessage(_INTL("You ate/drank {1}.",item))
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
return 1
else
$PokemonBag.pbStoreItem(item,1)
return 0
end
end



 def pbMedicine(bag,item)
 return if $player.playerhealth == 100
pbMessage(_INTL("You used {1} to heal yourself.",item))
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


##############################################################
###########      Ambient Temperature             #############
##############################################################

def pbSetTemperature
  if SurvivalModeConfig::AMBIENT_TEMPERATURE == true
  $PokemonSystem.temperaturemeasurement = 18 if (pbGetTimeNow.mon==3 && pbGetTimeNow.day==22)
  $PokemonSystem.temperaturemeasurement = 35 if (pbGetTimeNow.mon==6 && pbGetTimeNow.day==21)
  $PokemonSystem.temperaturemeasurement = 12 if (pbGetTimeNow.mon==9 && pbGetTimeNow.day==21)
  $PokemonSystem.temperaturemeasurement = 0 if (pbGetTimeNow.mon == 10 && pbGetTimeNow.day ==22)
  end
end

def pbAmbientTemperature
  if SurvivalModeConfig::AMBIENT_TEMPERATURE == true
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
 

end


def pbEndGame
 if $PokemonSystem.survivalmode = 0 && $player.playerhealth <= 0
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

class PokemonSystem
  attr_accessor :survivalmode
  attr_accessor :temperature

  def initialize
    alias SIInit
    @temperaturemeasurement = 0     # Default Temperature Mode (0=on, 1=off)	 
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
