#The Level Buff is a function wherein the Pokemon just gets a level increase based on how long you have had it.
#I added it personally because in the setup within Survival Island itself, it implied you've had the Pokemon for a while.
#So a natural extension of the idea is actually allowing the POKeMON to be leveled... semi accordingly. 
#In my own game, I actually have a bit more complex logic, where the player themselves can set their age, and the level of the Pokemon can be capped within reason
#You wouldn't let your 1 year old have a Pokemon.
#Default False
LEVELBUFF = true
#This is something I wanted to add just for the option.
#Theres two types
# LEVELBUFFTYPE = "add"
# LEVELBUFFTYPE = "rand"
#add just takes the input base level from pbStarterSelection(level) and adds the amount of years you have had to it.
#rand rolls the buff and adds that to the level.
#Default Add.
LEVELBUFFTYPE = "add"
#This just gives the buff a cap, in case you don't want people inputing level 100 Pokemon as their starters.
#Default 5.
LEVELBUFFCAP = pbGet(326)
#Taking a few queues from Pokémon Colosseum, Wes has two starters in that game.
#This just makes it to where you can set a max amount of starters for the user to choose from.
#If it is greater than 1, it will allow the user to choose a second POKeMON.
#Default 1
AMOUNT=2
OBTAINLOCATION=true
#Pokemon that aren't legendaries or are debated to be legendaries that you just... dont want people selecting.
BANLIST=["SCYTHER","ROTOM"]



def generateStarter(pkmn,level)
   newpkmn = Pokemon.new(pkmn,level)
   newpkmn.loyalty = 255
   newpkmn.happiness = 255
   newpkmn.starter = true
   newpkmn.lifespan = 50
   newpkmn.water = 100
   newpkmn.food = 100
   newpkmn.lifespan = 50
   newpkmn.starter = true
   if OBTAINLOCATION == true
     pbMessage(_INTL("Where did you get them?"))
     newpkmn.obtain_text = pbEnterText("Enter a Region name.", 1, 10, "", 0, nil, true)
   end
   newpkmn.calc_stats
   return newpkmn
end

def pbihaveacommentonthatpokemoninparticular(pokemon)
 case pokemon
    when "MAGIKARP"
	   pbMessage(_INTL("{1} is too... Magikarp.",pokemon))
	   if pbConfirmMessage(_INTL("Are you sure you want it?"))
	   return false
	   else
	   return true
	   end
	when "PHIONE"
	   pbMessage(_INTL("Okay, look.",pokemon))
	   pbMessage(_INTL("I know that Phione's status as a Legendary Pokemon is disputed.",pokemon))
	   pbMessage(_INTL("But I'm still gonna say no.",pokemon))
	   pbMessage(_INTL("Sorry :(",pokemon))
	   return true
 end
end

def pbFixSpellingErrors(pkmn)
  if pkmn=="MR MIME"||pkmn=="MR. MIME"||pkmn=="MR.MIME"||pkmn=="MISTERMIME" 
    pkmn="MRMIME"
  end
  if pkmn=="JINX" 
    pkmn="JYNX"
  end
  if pkmn=="ONYX" 
    pkmn="ONIX"
  end
  if pkmn=="POOCHYEENA"||pkmn=="POOCHEENA"
    pkmn="POOCHYENA"
  end
  if pkmn=="MAGICARP"||pkmn=="MAJIKARP"||pkmn=="MAJICARP"
    pkmn="MAGIKARP"
  end
  if pkmn=="RATATA"||pkmn=="RATAATA"||pkmn=="RAATATA"
    pkmn="RATTATA"
  end
  if pkmn=="EGGSECUTE"||pkmn=="EGGSEQUTE"||pkmn=="EGGSACUTE"||pkmn=="EXEGCUTE"
    pkmn="EXEGGCUTE"
  end
  if pkmn=="MISDREAVOUS"||pkmn=="MISDREVIOUS"||pkmn=="MISDREEVUS"||pkmn=="MISSDREVOUS"
    pkmn="MISDREAVUS"
  end
  if pkmn=="QUILLFISH"
    pkmn="QWILFISH"
  end
  if pkmn=="TREEKO"
    pkmn="TREECKO"
  end
  if pkmn=="GROUNDDON"
    pkmn="GROUDON"
  end
  if pkmn=="MANKY"
    pkmn="MANKEY"
  end
  if pkmn=="PRIMEAPE"
    pkmn="PRIMAPE"
  end
  if pkmn=="FARFETCH'D"||pkmn=="FARFECH'D"||pkmn=="FARFECHD"
    pkmn="FARFETCHD"
  end
  if pkmn=="GHASTLY"||pkmn=="GASTLEY"
    pkmn="GASTLY"
  end
  if pkmn=="HO-OH"||pkmn=="HO OH"||pkmn=="HO HO"||pkmn=="HO-HO"||pkmn=="HOHO"
    pkmn="HOOH"
  end
  if pkmn=="PORYGON 2"
    pkmn="PORYGON2"
  end
  if pkmn=="FLAFFY"||pkmn=="FLAAFY"
    pkmn="FLAAFFY"
  end
  if pkmn=="VICTREEBELL"||pkmn=="VICTORYBELL"
    pkmn="VICTREEBEL"
  end
  if pkmn=="FERALIGATOR"||pkmn=="FERALLIGATOR"
    pkmn="FERALIGATR"
  end
  if pkmn=="NINETAILS"
    pkmn="NINETALES"
  end
  if pkmn=="VENASAUR"
    pkmn="VENUSAUR"
  end
  if pkmn=="GARADOS"||pkmn=="GARYDOS"||pkmn=="GYRADOS"
    pkmn="GYARADOS"
  end
  if pkmn=="CHARAZARD"
    pkmn="CHARIZARD"
  end
  if pkmn=="DIGLET"||pkmn=="DIGGLET"||pkmn=="DIGGLETT"
    pkmn="DIGLETT"
  end
  if pkmn=="POLITOAD"||pkmn=="POLYTOAD"
    pkmn="POLITOED"
  end
  if pkmn=="NIDORAN"
    command=pbShowCommands(nil,
       [_INTL("Male?"),
       _INTL("Female?")],
       -1)
      if command==0 # Male
        pkmn="NIDORANmA"
      elsif command==1 # Female
        pkmn="NIDORANfE"
      end
  end
  if pkmn=="NIDORAN♀"||pkmn=="NIDORANF"
    pkmn="NIDORANfE"
  end
  if pkmn=="NIDORAN♂"||pkmn=="NIDORANM"
    pkmn="NIDORANmA"
  end
  return pkmn
end



def pbStarterSelection(level)
    amt = 0
    lvlbuff = 0
	location = 0
	if AMOUNT > 1
	loop do
    msgwindow = pbCreateMessageWindow(nil,nil)
    params = ChooseNumberParams.new
    params.setMaxDigits(3)
    params.setRange(0,AMOUNT)
    pbMessageDisplay(msgwindow,_INTL("How many Pokemon do you want to start with?"))
    amt = pbChooseNumber(msgwindow,params)
    pbDisposeMessageWindow(msgwindow)
	if amt > AMOUNT
	   pbMessage(_INTL("You cannot have that many Pokemon."))
	elsif amt == 0
	   pbMessage(_INTL("You cannot start with zero Pokemon."))
	else
	 if pbConfirmMessage(_INTL("You want to start with {1} Pokemon?",amt))
	  break
	 else 
	  amt = 0
	 end
	end
	end
	end
	if LEVELBUFF == true
	loop do
     msgwindow = pbCreateMessageWindow(nil,nil)
     pbMessageDisplay(msgwindow,_INTL("How long ago did you get them?"))
	puts $game_variables[326]
    params = ChooseNumberParams.new
    params.setMaxDigits(3)
    params.setRange(0,$game_variables[326])
	 lvlbuff = pbChooseNumber(msgwindow,params)
     pbDisposeMessageWindow(msgwindow)
	 if lvlbuff > $game_variables[326]
	   pbMessage(_INTL("You can't have a Pokemon that high of a level."))
	 else
	 if pbConfirmMessage(_INTL("You got them {1} years ago?",lvlbuff))
	    break
	 else
	   pbMessage(_INTL("It's hard to remember sometimes."))
	 end
    end
    end
	end
    if amt == 0
	 amt = 1
	end 
  
    amt.times do
	 loop do
	pkmn = pbEnterText("Enter a Pokemon name.", 1, 10, "", 0, nil, true)
	pkmn = pkmn.upcase
	pkmn = pbFixSpellingErrors(pkmn)
	pkmn = pbRandomCheck(pkmn)
	if !GameData::Species.try_get(pkmn).id
	  pbMessage(_INTL("That's not a Pokemon!"))
	else
	pkmnid = GameData::Species.try_get(pkmn).id
    if pbLegendaryStarter?(pkmn)
	   pbMessage(_INTL("{1} is too powerful.",pkmn))
	elsif pbihaveacommentonthatpokemoninparticular(pkmn)
	elsif BANLIST.include?(pkmn)
	   pbMessage(_INTL("{1} cannot be selected.",pkmn))
	elsif pkmnid!=GameData::Species.get(pkmnid).get_baby_species 
	   pbMessage(_INTL("{1} is an evolved Pokemon, {2} will be used instead.",pkmn,GameData::Species.get(pkmnid).get_baby_species))
	   pkmnid = GameData::Species.get(pkmnid).get_baby_species
	   pkmn = GameData::Species.get(pkmnid).name
	   	 if pbConfirmMessage(_INTL("Are you sure you want to select {1}?",pkmn))
	    if LEVELBUFF == false
	    pkmnlevel = level
		elsif LEVELBUFFTYPE == "add"
	    pkmnlevel = level+lvlbuff
		elsif LEVELBUFFTYPE == "rand"
	    pkmnlevel = level+rand(lvlbuff)
		end
	    pkmn = generateStarter(pkmnid,pkmnlevel)
		pbAddPokemon(pkmn)
	    if pbConfirmMessage(_INTL("Do you want to view the Summary Screen for {1}?",pkmn))
		  pbFadeOutIn {
            summary_scene = PokemonSummary_Scene.new
            summary_screen = PokemonSummaryScreen.new(summary_scene, true)
            summary_screen.pbStartScreen(pkmn, 0)
          }
		end
		break
	  end
	else 
	 if pbConfirmMessage(_INTL("Are you sure you want to select {1}?",pkmn))
	    if LEVELBUFF == false
	    pkmnlevel = level
		elsif LEVELBUFFTYPE == "add"
	    pkmnlevel = level+lvlbuff
		elsif LEVELBUFFTYPE == "rand"
	    pkmnlevel = level+rand(lvlbuff)
		end
	    pkmn = generateStarter(pkmnid,pkmnlevel)
		pkmn.age = lvlbuff
		pbAddPokemon(pkmn)
	    if pbConfirmMessage(_INTL("Do you want to view the Summary Screen for {1}?",pkmn.name))
		  pbFadeOutIn {
            summary_scene = PokemonSummary_Scene.new
            summary_screen = PokemonSummaryScreen.new(summary_scene, true)
            summary_screen.pbStartScreen([pkmn], 0)
          }
	      if pbConfirmMessageSerious(_INTL("Do you want to reset?",pkmn.name))  
           $scene = nil
           Graphics.transition(20) # changed line (from 40 to 1)
           go_to_title # added line
		  end
		end
		break
	  end
	end 	
	end
	end
end
end



def pbStarterSelectionDemo(level,verify=true)
    amt = 0
    lvlbuff = 5
	location = 0
	 amt = 1
  
    amt.times do
	 loop do
	pkmn = pbEnterText("Enter a Pokemon name.", 1, 10, "", 0, nil, true)
	pkmn = pkmn.upcase
	pkmn = pbFixSpellingErrors(pkmn)
	pkmn = pbRandomCheck(pkmn)
	if !GameData::Species.try_get(pkmn).id
	  pbMessage(_INTL("That's not a Pokemon!"))
	else
	pkmnid = GameData::Species.try_get(pkmn).id
    if pbLegendaryStarter?(pkmn) && verify==true
	   pbMessage(_INTL("{1} is too powerful.",pkmn))
	elsif pbihaveacommentonthatpokemoninparticular(pkmn)
	elsif BANLIST.include?(pkmn) && verify==true
	   pbMessage(_INTL("{1} cannot be selected.",pkmn))
	elsif pkmnid!=GameData::Species.get(pkmnid).get_baby_species && verify==true
	   pbMessage(_INTL("{1} is an evolved Pokemon, {2} will be used instead.",pkmn,GameData::Species.get(pkmnid).get_baby_species))
	   pkmnid = GameData::Species.get(pkmnid).get_baby_species
	   pkmn = GameData::Species.get(pkmnid).name
	   	 if pbConfirmMessage(_INTL("Are you sure you want to select {1}?",pkmn))
	    pkmnlevel = level
	    pkmn = generateStarter(pkmnid,pkmnlevel)
		$game_variables[3] = pkmn
	    if pbConfirmMessage(_INTL("Do you want to view the Summary Screen for {1}?",pkmn))
		  pbFadeOutIn {
            summary_scene = PokemonSummary_Scene.new
            summary_screen = PokemonSummaryScreen.new(summary_scene, true)
            summary_screen.pbStartScreen(pkmn, 0)
          }
		end
		break
	  end
	else 
	 if pbConfirmMessage(_INTL("Are you sure you want to select {1}?",pkmn))
	    pkmnlevel = level
	    pkmn = generateStarter(pkmnid,pkmnlevel)
		pkmn.age = lvlbuff
		$game_variables[3] = pkmn
	    if pbConfirmMessage(_INTL("Do you want to view the Summary Screen for {1}?",pkmn.name))
		  pbFadeOutIn {
            summary_scene = PokemonSummary_Scene.new
            summary_screen = PokemonSummaryScreen.new(summary_scene, true)
            summary_screen.pbStartScreen([pkmn], 0)
          }
	      if pbConfirmMessageSerious(_INTL("Do you want to reset?",pkmn.name))  
           $scene = nil
           Graphics.transition(20) # changed line (from 40 to 1)
           go_to_title # added line
		  end
		end
		break
	  end
	end 	
	end
	end
end
end

class Pokemon
  attr_accessor :starter

alias _SI_Starter_init initialize
def initialize(species, level, owner = $player, withMoves = true, recheck_form = true)
 _SI_Starter_init(species, level, owner = $player, withMoves = true, recheck_form = true)
    @starter          = false
end
end



def pbLegendaryStarter?(starter)
  return true if
    starter=="ARTICUNO" ||
    starter=="ZAPDOS" ||
    starter=="MOLTRES" ||
    starter=="MEWTWO" ||
    starter=="MEW" ||
    starter=="RAIKOU" ||
    starter=="ENTEI" ||
    starter=="SUICUNE" ||
    starter=="LUGIA" ||
    starter=="HOOH" ||
    starter=="CELEBI" ||
    starter=="REGIROCK" ||
    starter=="REGICE" ||
    starter=="REGISTEEL" ||
    starter=="LATIAS" ||
    starter=="LATIOS" ||
    starter=="KYOGRE" ||
    starter=="GROUDON" ||
    starter=="RAYQUAZA" ||
    starter=="JIRACHI" ||
    starter=="DEOXYS" ||
    starter=="UXIE" ||
    starter=="MESPRIT" ||
    starter=="AZELF" ||
    starter=="DIALGA" ||
    starter=="PALKIA" ||
    starter=="HEATRAN" ||
    starter=="REGIGIGAS" ||
    starter=="GIRATINA" ||
    starter=="CRESSELIA" ||
    starter=="MANAPHY" ||
    starter=="DARKRAI" ||
    starter=="SHAYMIN" ||
    starter=="ARCEUS" ||
    starter=="VICTINI" ||
    starter=="COBALION" ||
    starter=="TERRAKION" ||
    starter=="VIRIZION" ||
    starter=="TORNADUS" ||
    starter=="THUNDURUS" ||
    starter=="RESHIRAM" ||
    starter=="ZEKROM" ||
    starter=="LANDORUS" ||
    starter=="KYUREM" ||
    starter=="KELDEO" ||
    starter=="MELOETTA" ||
    starter=="GENESECT"||
    starter=="XERNEAS"||
    starter=="YVELTAL"||
    starter=="ZYGARDE"||
    starter=="TYPENULL"||
    starter=="SILVALLY"||
    starter=="TAPUBULU"||
    starter=="TAPUFINI"||
    starter=="TAPULELE"||
    starter=="TAPUKOKO"||
    starter=="COSMOG"||
    starter=="COSMOEM"||
    starter=="SOLGALEO"||
    starter=="LUNALA"||
    starter=="NECROZMA"||
    starter=="NIHILEGO"||
    starter=="ZACIAN"||
    starter=="ZAMAZENTA"||
    starter=="ETERNATUS"||
    starter=="KUBFU"||
    starter=="URSHIFU"||
    starter=="REGIELEKI"||
    starter=="REGIDRAGO"||
    starter=="GLASTRIER"||
    starter=="SPECTRIER"||
    starter=="CALYREX"
  return false
end

def pbRandomCheck(pkmn)
  if pkmn=="RANDOM"||pkmn=="ANYTHING"||pkmn=="NONE"
    pkmn=pbRandomStarter("NONE")
	return pkmn
  end
  GameData::Type.each do |t|
  if pkmn == t.real_name.upcase
    pkmn=pbRandomStarter(pkmn)
	return pkmn
  end
  end
  return pkmn
end


def pbRandomStarter(type)
  pokemonavil = []
  GameData::Species.each_species do |sp|
    if type!="NONE"
	   sp.types.each do |i|
	     type2 = i.name
	     type2 = type2.upcase
	     if type2 == type
		 pokemonavil << sp.id
		 end
	   end
	else
	   pokemonavil << sp.id
	end
  end  
  loop do
  choose = rand(pokemonavil.length)
  pkmn = pokemonavil[choose]
  if GameData::Species.get(pkmn).id!=GameData::Species.get(GameData::Species.get(pkmn).id).get_baby_species 
     pkmn = GameData::Species.get(GameData::Species.get(pkmn).id).get_baby_species 
  end
  if pbLegendaryStarter?(pkmn.name.upcase)
  elsif BANLIST.include?(pkmn)
  else
  return pkmn
  end
end
end



