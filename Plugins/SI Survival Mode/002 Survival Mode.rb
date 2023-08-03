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
  attr_accessor :happiness
  attr_accessor :loyalty
  attr_accessor :starter
  attr_accessor :water
  attr_accessor :food
  attr_accessor :sleep
  attr_accessor :age
  attr_accessor :maxage
  attr_accessor :lifespan
  attr_reader :hue
  
  
alias _SI_Pokemon_species= species=
def species=(species_id)
  _SI_Pokemon_species=(species_id)
end
alias _SI_Pokemon_init initialize
def initialize(species, level, owner = $player, withMoves = true, recheck_form = true)
 _SI_Pokemon_init(species, level, owner = $player, withMoves = true, recheck_form = true)
    @hue = nil
    @happiness        = species_data.happiness || 100
    @loyalty          = species_data.loyalty || 100
    @starter          = false
    @food             = species_data.food || 100
    @water            = species_data.water || 100
    @sleep            = species_data.sleep || 100
    @maxage          = species_data.maxage || 100
    @lifespan          = species_data.lifespan || 100

end

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
  attr_reader :playerwater  #206
  attr_reader :playerfood   #205
  attr_reader :playersleep   #208
  attr_reader :playerbasewater  #206
  attr_reader :playerbasefood   #205
  attr_reader :playerbasesleep   #208
  attr_reader :playerwatermod  #206
  attr_reader :playermaxwater
  attr_reader :playerfoodmod  #205
  attr_reader :playermaxfood
  attr_reader :playersleepmod   #208
  attr_reader :playermaxsleep
  attr_reader :playersaturation #207
  attr_reader :playerhealth #225
  attr_reader :playerbasehealth #225
  attr_reader :playerhealthmod #225
  attr_reader :playermaxhealth
  attr_reader :playerstamina
  attr_reader :playertemperature
  attr_reader :playerbasestamina
  attr_reader :playermaxstamina
  attr_reader :playerstaminamod
  attr_accessor :rocket_unlocked
  attr_accessor :chapter2_unlocked
  attr_reader :playershirt 
  attr_reader :playerpants
  attr_reader :playershoes  
  attr_reader :rocketplaythrough
  attr_reader :rocketbadges
  attr_reader :rocketstealing
  attr_reader :rocketstealcount
  attr_reader :playerwrath
  attr_reader :playerharmony
  attr_reader :playermoral
  attr_reader :playerclass
  attr_reader :playerclasslevel
  attr_reader :partner1 #207
  attr_reader :partner2 #207
  attr_reader :partner3 #207
  attr_reader :partner4 #207
  attr_reader :partner5 #207
  attr_reader :partner6 #207
  attr_reader :partner7 #207
  attr_reader :partner8 #207
  attr_reader :partner1affinity #207
  attr_reader :partner2affinity #207
  attr_reader :partner3affinity #207
  attr_reader :partner4affinity #207
  attr_reader :partner5affinity #207
  attr_reader :partner6affinity #207
  attr_reader :partner7affinity #207
  attr_reader :partner8affinity #207
  attr_reader :blueaffinity #207
  attr_reader :redaffinity #207
  attr_reader :runpartner1 #207
  attr_reader :runpartner2 #207
  attr_reader :runpartner3 #207
  attr_reader :runpartner4 #207
  attr_reader :runpartner5 #207
  attr_reader :runpartner6 #207
  attr_reader :runpartner7 #207
  attr_reader :demotimer #207
  attr_reader :playermode #207
  
  
  
  def playersaturation=(value)
    validate value => Integer
    @playersaturation = value.clamp(0, 100)
  end
  def playersleep=(value)
    validate value => Integer
    @playersleep = value.clamp(0, 9999)
  end
  def playerwater=(value)
    validate value => Integer
    @playerwater = value.clamp(0, 9999)
  end
  def playerfood=(value)
    validate value => Integer
    @playerfood = value.clamp(0, 9999)
  end

  def playertemperature=(value)
    validate value => Integer
    @playertemperature = value.clamp(0, 9999)
  end


  def playerbasesleep=(value)
    validate value => Integer
    @playerbasesleep = value.clamp(0, 200)
  end
  def playerbasewater=(value)
    validate value => Integer
    @playerbasewater = value.clamp(0, 100)
  end
  def playerbasefood=(value)
    validate value => Integer
    @playerbasefood = value.clamp(0, 100)
  end



  def playermaxwater=(value)
    validate value => Integer
    @playermaxwater = value.clamp(0, 9999)
  end
  def playermaxsleep=(value)
    validate value => Integer
    @playermaxsleep = value.clamp(0, 9999)
  end
  def playermaxfood=(value)
    validate value => Integer
    @playermaxfood = value.clamp(0, 9999)
  end


  def playersleepmod=(value)
    validate value => Integer
    @playersleepmod = value.clamp(0, 9999)
  end 
  def playerwatermod=(value)
    validate value => Integer
    @playerwatermod = value.clamp(0, 9999)
  end  
  def playerfoodmod=(value)
    validate value => Integer
    @playerfoodmod = value.clamp(0, 9999)
  end

  def playerhealthmod=(value)
    validate value => Integer
    @playerhealthmod = value.clamp(0, 9999)
  end
  def playerhealth=(value)
    validate value => Integer
    @playerhealth = value.clamp(0, 9999)
  end
  def playerbasehealth=(value)
    validate value => Integer
    @playerbasehealth = value.clamp(0, 100)
  end
  def playermaxhealth=(value)
    validate value => Integer
    @playermaxhealth = value.clamp(0, 9999)
  end


  def playerstamina=(value)
    validate value => Float
    @playerstamina = value.clamp(0, 9999)
  end
  def playerbasestamina=(value)
    validate value => Float
    @playerstamina = value.clamp(0, 9999)
  end
  def playermaxstamina=(value)
    validate value => Float
    @playermaxstamina = value.clamp(0, 9999)
  end
  def playerstaminamod=(value)
    validate value => Float
    @playerstaminamod = value.clamp(0, 50)
  end
  
  def playermoral=(value)
    validate value => Integer
    @playermoral = value.clamp(0, 9999)
  end
  def playerharmony=(value)
    validate value => Integer
    @playerharmony = value.clamp(0, 9999)
  end
  def playerwrath=(value)
    validate value => Integer
    @playerwrath = value.clamp(0, 9999)
  end
  def rocketplaythrough=(value)
    validate value => Integer
    @rocketplaythrough = value.clamp(0, 1)
  end
  def rocketbadges=(value)
    validate value => Integer
    @rocketbadges = 0
  end
  def rocketstealing=(value)
    validate value => Integer
    @rocketstealing = 0
  end
  def rocketstealcount=(value)
    validate value => Integer
    @rocketstealcount = value.clamp(0, 9999)
  end
  def playerclass=(value)
    @playerclass = value
  end
  def playerclasslevel=(value)
    validate value => Integer
    @playerclasslevel = value.clamp(0, 100)
  end
  
  def partner1=(value)
    @partner1 = value
  end
  def partner2=(value)
    @partner2 = value
  end
  def partner3=(value)
    @partner3 = value
  end
  def partner4=(value)
    @partner4 = value
  end
  def partner5=(value)
    @partner5 = value
  end
  def partner6=(value)
    @partner6 = value
  end
  def partner7=(value)
    @partner7 = value
  end
  def partner8=(value)
    @partner8 = value
  end
  def partner1affinity=(value)
    validate value => Integer
    @partner1affinity = value.clamp(0, 100)
  end
  def partner2affinity=(value)
    validate value => Integer
    @partner2affinity = value.clamp(0, 100)
  end
  def partner3affinity=(value)
    validate value => Integer
    @partner3affinity = value.clamp(0, 100)
  end
  def partner4affinity=(value)
    validate value => Integer
    @partner4affinity = value.clamp(0, 100)
  end
  def partner5affinity=(value)
    validate value => Integer
    @partner5affinity = value.clamp(0, 100)
  end
  def partner6affinity=(value)
    validate value => Integer
    @partner6affinity = value.clamp(0, 100)
  end
  def partner7affinity=(value)
    validate value => Integer
    @partner7affinity = value.clamp(0, 100)
  end
  def partner8affinity=(value)
    validate value => Integer
    @partner7affinity = value.clamp(0, 100)
  end
  def blueaffinity=(value)
    validate value => Integer
    @blueaffinity = value.clamp(0, 100)
  end
  def redaffinity=(value)
    validate value => Integer
    @redaffinity = value.clamp(0, 100)
  end
  def runpartner1=(value)
    @runpartner1 = value
  end
  def runpartner2=(value)
    @runpartner2 = value  
  end
  def runpartner3=(value)
    @runpartner2 = value  
  end
  def runpartner4=(value)
    @runpartner4 = value
  end
  def runpartner5=(value)
    @runpartner5 = value
  end
  def runpartner6=(value)
    @runpartner6 = value
  end
  def runpartner7=(value)
    @runpartner7 = value
  end
  
  
  
  def demotimer=(value)
    validate value => Integer
    @demotimer = value.clamp(0, 691200)
  end
  
  
  
  
  
  def playershirt=(value)
    @playershirt = value
  end
  def playerpants=(value)
    @playerpants = value
  end
  def playershoes=(value)
    @playershoes = value
  end

  
  def playermode=(value)
    @playermode = value
  end

   alias _SI_Player_Init initialize
  def initialize(name, trainer_type)
    _SI_Player_Init(name, trainer_type)
    @playerpants           = :NORMALPANTS
    @playershirt           = :NORMALSHIRT
    @playershoes           = :NORMALSHOES
    @rocket_unlocked = false
    @chapter2_unlocked = false
    @playerwater   = 100   # Text speed 
    @playerfood = 100     # Battle effects (animations) (0=on, 1=off)
    @playerhealth  = 100     # Default window frame (see also Settings::MENU_WINDOWSKINS)
    @playersaturation = 200     # Battle style (0=switch, 1=set)
    @playersleep = 100     # Battle style (0=switch, 1=set)
    @playerstamina  = 50.0     # Speech frame
    @playerbasestamina  = 100.0     # Speech frame
    @playermaxstamina  = 100.0     # Speech frame
    @playermaxsleep  = 100     # Speech frame
    @playermaxhealth  = 100     # Speech frame
    @playertemperature  = 50     # Speech frame
    @playermaxfood  = 100     # Speech frame
    @playermaxwater  = 100     # Speech frame
    @playerstaminamod  = 0     # Speech frame
    @playerfoodmod  = 0     # Speech frame
    @playerwatermod  = 0     # Speech frame
    @playersleepmod  = 0     # Speech frame
    @playerhealthmod  = 0     # Speech frame
    @playerbasesleep = 100     # Battle style (0=switch, 1=set)
    @playerbasewater   = 100   # Text speed 
    @playerbasefood = 100     # Battle effects (animations) (0=on, 1=off)
    @playerbasehealth  = 100     # Default window frame (see also Settings::MENU_WINDOWSKINS)
    @rocketplaythrough                  = 0
    @rocketbadges                  = 0
    @rocketstealing                 = 0
    @rocketstealcount                 = 0
    @playerwrath                 = 0
    @playerharmony                 = 0
    @playermoral                 = 0
    @playerclass           = "None"
    @playerclasslevel                 = 1
    @partner1          = 1
    @partner2          = 2
    @partner3          = 3
    @partner4          = 4
    @partner5          = 5
    @partner6          = 6
    @partner7          = 7
    @partner8          = 8
    @partner1affinity          = 50
    @partner2affinity          = 50
    @partner3affinity          = 50
    @partner4affinity          = 50
    @partner5affinity          = 50
    @partner6affinity          = 50
    @partner7affinity          = 50
    @partner8affinity          = 50
    @blueaffinity          = 50
    @redaffinity          = 50
    @runpartner1          = 0
    @runpartner2          = 0
    @runpartner3          = 0
    @runpartner4          = 0
    @runpartner5          = 0
    @runpartner6          = 0
    @runpartner7          = 0 
    @runpartner6          = 0
    @runpartner7          = 0 
    @demotimer            = 691200 
    @playermode     = 1     # Text input mode (0=PSID, 1=PSIA)
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
puts vari
  if !vari.nil?
  $player.playersleep = $player.playersleep.to_i-(wari*9)
  else
  $player.playersleep = $player.playersleep.to_i+(wari*9)
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

return true
when :LEMONADE
pkmn.water+=100
return true
$bag.add(:GLASSBOTTLE,1)

return true
when :HONEY
pkmn.water+=20
pkmn.food+=60
return true
when :MOOMOOMILK
pkmn.water+=100
$bag.add(:GLASSBOTTLE,1)

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
pkmn.food+=70
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
case item
when :WATER
$player.playerwater+=10
$player.playerhealth -= 7
$bag.add(:GLASSBOTTLE,1)
return true
when :MEAT
$player.playerfood+=15
$player.playerhealth -= 7
return true
when :BIRDMEAT
$player.playerfood+=10
$player.playerhealth -= 7
return true
when :POISONOUSMEAT
$player.playerfood+=10
$player.playerhealth -= 25
return true
when :ROCKYMEAT
$player.playerfood+=10
$player.playerhealth -= 10
return true
when :BUGMEAT
$player.playerfood+=2
$player.playerhealth -= 2
return true
when :STEELYMEAT
$player.playerfood+=3
$player.playerhealth -= 10
return true
when :SUSHI
$player.playerfood+=15
$player.playerhealth -= 6
return true
when :LEAFYMEAT
$player.playerfood+=10
$player.playerhealth -= 6
return true
when :FROZENMEAT
$player.playerfood+=6
$player.playerhealth -= 15
return true
when :DRAGONMEAT
$player.playerfood+=20
$player.playerhealth -= 15
return true
when :EDIABLESCRYSTAL
$player.playerfood+=6
$player.playerhealth -= 15
return true
when :ORANBERRY
$player.playerfood+=1
$player.playerhealth += 1
return true
when :LEPPABERRY
$player.playerfood+=1
return true
when :CHERIBERRY
$player.playerfood+=1
return true
when :CHESTOBERRY
$player.playerfood+=1
return true
when :PECHABERRY
$player.playerfood+=1
return true
when :RAWSTBERRY
$player.playerfood+=1
return true
when :ASPEARBERRY
$player.playerfood+=1
return true
when :PERSIMBERRY
$player.playerfood+=1
return true
when :LUMBERRY
$player.playerfood+=1
return true
when :FIGYBERRY
$player.playerfood+=1
return true
when :WIKIBERRY
$player.playerfood+=1
return true
when :MAGOBERRY
$player.playerfood+=1
return true
when :AGUAVBERRY
$player.playerfood+=1
return true
when :IAPAPABERRY
$player.playerfood+=1
return true
when :IAPAPABERRY
$player.playerfood+=1
return true
when :SITRUSBERRY
$player.playerfood+=1
$player.playerhealth +=1
return true
when :BERRYJUICE
$player.playerwater+=4
$player.playerhealth += 2
$bag.add(:BOWL,1)
return true
when :FRESHWATER
$player.playerwater+=20
$bag.add(:GLASSBOTTLE,1)
return true
#You can add more if you want
when :ATKCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return true
when :SATKCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return true
when :SPEEDCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return true
when :SPDEFCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return true
when :ACCCURRY
$player.playerfood+=8
$player.playersaturation+=12
$player.playerwater-=7
return true
when :DEFCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return true
when :CRITCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return true
when :GSCURRY
$player.playerfood+=8#205 is Hunger
$player.playersaturation+=15#207 is Saturation
$player.playerwater-=7#206 is Thirst
return true
when :RAGECANDYBAR #chocolate
$player.playerfood+=10
$player.playersaturation+=3
$player.playersleep+=7
return true
when :SWEETHEART #chocolate
$player.playerfood+=10#205 is Hunger
$player.playersaturation+=5#207 is Saturation
$player.playersleep+=6#208 is Sleep
return true
when :SODAPOP
$player.playerwater-=11#206 is Thirst
$player.playersaturation+=30#207 is Saturation
$player.playersleep+=25#208 is Sleep
$bag.add(:GLASSBOTTLE,1)
return true
when :LEMONADE
$player.playersaturation+=11#207 is Saturation
$player.playerwater+=10#206 is Thirst
$player.playersleep+=7#208 is Sleep
$bag.add(:GLASSBOTTLE,1)
return true
when :HONEY
$player.playersaturation+=20#207 is Saturation
return true
when :MOOMOOMILK
$player.playersaturation+=10
$player.playerwater+=15
$bag.add(:GLASSBOTTLE,1)
return true
when :CSLOWPOKETAIL
$player.playersaturation+=20#207 is Saturation
$player.playerfood+=20#205 is Hunger
return true
when :BAKEDPOTATO
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=4#206 is Thirst
$player.playerfood+=7#205 is Hunger
return true
when :APPLE
$player.playerwater+=1#206 is Thirst
$player.playerfood+=1#205 is Hunger
return true
when :CHOCOLATE
$player.playersaturation+=5#207 is Saturation
$player.playerfood+=7#205 is Hunger
return true
when :LEMON
$player.playerfood+=1#205 is Hunger
return true
when :OLDGATEAU
$player.playersaturation+=6#207 is Saturation
$player.playerwater+=2#206 is Thirst
$player.playerfood+=6#205 is Hunger
return true
when :LAVACOOKIE
$player.playersaturation+=5#207 is Saturation
$player.playerwater-=3#206 is Thirst
$player.playerfood+=6#205 is Hunger
return true
when :CASTELIACONE
$player.playerwater+=7#206 is Thirst
$player.playerfood+=7#205 is Hunger
return true
when :LUMIOSEGALETTE
$player.playersaturation+=5#207 is Saturation
$player.playerfood+=6#205 is Hunger
return true
when :SHALOURSABLE
$player.playersaturation+=8#207 is Saturation
$player.playerfood+=8#205 is Hunger
return true
when :BIGMALASADA
$player.playersaturation+=8#207 is Saturation
$player.playerfood+=8#205 is Hunger
return true
when :ONION
$player.playerwater+=1#206 is Thirst
$player.playerfood+=1#205 is Hunger
return true
when :COOKEDORAN
$player.playersaturation+=2#207 is Saturation
$player.playerhealth+=2#206 is Thirst
$player.playerfood+=6#205 is Hunger
return true
when :CARROT
$player.playersaturation+=6#207 is Saturation
$player.playerwater+=1#206 is Thirst
$player.playerfood+=1#205 is Hunger
return true
when :BREAD
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=7#206 is Thirst
$player.playerfood+=11#205 is Hunger
return true
when :TEA
$player.playersaturation+=15#207 is Saturation
$player.playerwater+=8#206 is Thirst
$player.playerfood+=2#205 is Hunger
return true
when :CARROTCAKE
$player.playersaturation+=15#207 is Saturation
$player.playerwater+=15#206 is Thirst
$player.playerfood+=10#205 is Hunger
return true
when :COOKEDMEAT
$player.playersaturation+=40#207 is Saturation
$player.playerfood+=10#205 is Hunger
return true
when :SITRUSJUICE
$player.playersaturation+=20#207 is Saturation
$player.playerwater+=6#206 is Thirst
$player.playerfood+=0#205 is Hunger
$player.playerhealth+= 25#205 is Hunger
$bag.add(:GLASSBOTTLE,1)
return true
when :BERRYMASH
$player.playersaturation+=5#207 is Saturation
$player.playerwater+=5#206 is Thirst
$player.playerfood+=5#205 is Hunger
return true
when :LARGEMEAL
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
when :COOKEDBIRDMEAT
$player.playersaturation+=40#207 is Saturation
$player.playerfood+=12#205 is Hunger
return true
when :COOKEDROCKYMEAT
$player.playersaturation+=40#207 is Saturation
$player.playerfood+=15#205 is Hunger
$player.playerhealth -= 2
return true
when :COOKEDBUGMEAT
$player.playersaturation+=40#207 is Saturation
$player.playerfood+=6#205 is Hunger
return true
when :COOKEDSTEELYMEAT
$player.playersaturation+=40#207 is Saturation
$player.playerfood+=30#205 is Hunger
$player.playerhealth -= 20
return true
when :COOKEDSUSHI
$player.playersaturation+=10#207 is Saturation
$player.playerfood+=5#205 is Hunger
$player.playerwater+=5#205 is Hunger
return true
when :COOKEDLEAFYMEAT
$player.playersaturation+=5#207 is Saturation
$player.playerfood+=20#205 is Hunger
return true
when :COOKEDDRAGONMEAT
$player.playersaturation+=100#207 is Saturation
return true
when :COOKEDEDIABLESCRYSTAL
$player.playersaturation+=0#207 is Saturation
$player.playerfood+=20#205 is Hunger
return true
when :MEATSANDWICHBIRD
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=7#206 is Thirst
$player.playerfood+=11#205 is Hunger
$player.playersaturation+=40#207 is Saturation
$player.playerfood+=12#205 is Hunger
return true
when :MEATSANDWICHSLOWPOKETAIL
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=7#206 is Thirst
$player.playerfood+=11#205 is Hunger
$player.playersaturation+=30#207 is Saturation
$player.playerfood+=30#205 is Hunger
return true
when :MEATSANDWICHROCKY
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=7#206 is Thirst
$player.playerfood+=11#205 is Hunger
$player.playersaturation+=40#207 is Saturation
$player.playerfood+=15#205 is Hunger
$player.playerhealth -= 2
return true
when :MEATSANDWICHBUG
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=7#206 is Thirst
$player.playerfood+=11#205 is Hunger
$player.playersaturation+=40#207 is Saturation
$player.playerfood+=6#205 is Hunger
return true
when :MEATSANDWICHSTEELY
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=10#206 is Thirst
$player.playerfood+=10#205 is Hunger
$player.playersaturation+=40#207 is Saturation
$player.playerfood+=30#205 is Hunger
$player.playerhealth -= 20
return true
when :MEATSANDWICHSUS
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=10#206 is Thirst
$player.playerfood+=15#205 is Hunger
$player.playersaturation+=10#207 is Saturation
$player.playerfood+=5#205 is Hunger
$player.playerwater+=5#205 is Hunger
return true
when :MEATSANDWICHLEAFY
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=7#206 is Thirst
$player.playerfood+=15#205 is Hunger
$player.playersaturation+=5#207 is Saturation
$player.playerfood+=20#205 is Hunger
return true
when :MEATSANDWICHMJ
$player.playerwater+=7#206 is Thirst
$player.playerfood+=25#205 is Hunger
$player.playersaturation+=100#207 is Saturation
return true
when :MEATSANDWICHCRYSTAL
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=7#206 is Thirst
$player.playerfood+=11#205 is Hunger
$player.playersaturation+=0#207 is Saturation
$player.playerfood+=20#205 is Hunger
return true
when :MEATSANDWICH
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=7#206 is Thirst
$player.playerfood+=11#205 is Hunger
$player.playersaturation+=40#207 is Saturation
$player.playerfood+=20#205 is Hunger
return true
when :EGGEDIBLE
$player.playersaturation+=20#207 is Saturation
$player.playerfood+=1#205 is Hunger
return true
when :CHERUBIBALL
$player.playerwater+=7#206 is Thirst
$player.playerfood+=7#205 is Hunger
return true
when :POTATOSTEW
$player.playerfood+=19
$player.playerwater+=17
return true
when :MEATKABOB
$player.playerfood+=24
$player.playerwater+=7
return true
when :FISHSOUP
$player.playerfood+=34
$player.playerwater+=37
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