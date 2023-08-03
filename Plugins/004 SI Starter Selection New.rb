#The Level Buff is a function wherein the Pokemon just gets a level increase based on how long you have had it.
#I added it personally because in the setup within Survival Island itself, it implied you've had the Pokemon for a while.
#So a natural extension of the idea is actually allowing the POKeMON to be leveled... semi accordingly. 
#In my own game, I actually have a bit more complex logic, where the player themselves can set their age, and the level of the Pokemon can be capped within reason
#You wouldn't let your 1 year old have a Pokemon.
LEVELBUFF = false
#This is something I wanted to add just for the option.
#Theres two types
# LEVELBUFFTYPE = add
# LEVELBUFFTYPE = rand
#add just takes the input base level from pbStarterSelection(level) and adds the amount of years you have had to it.
#rand rolls the buff and adds that to the level.
LEVELBUFFTYPE = "add"
#This just gives the buff a cap, in case you don't want people inputing level 100 Pokemon as their starters.
LEVELBUFFCAP = 5
#Taking a few queues from Pokémon Colosseum, Wes has two starters in that game.
#This just makes it to where you can set a max amount of starters for the user to choose from.
#If it is greater than 1, it will allow the user to choose a second POKeMON.
AMOUNT=1




def generateStarter(pkmn,level)
   newpkmn = Pokemon.new(pkmn,level)
   #
   # Just putting blank space here for any code that might want to be added.
   # In my case, its
   # newpkmn.loyalty = 255
   # newpkmn.happiness = 255
   newpkmn.starter = true
   return newpkmn
end

def pbihaveacommentonthatpokemoninparticular(pokemon)
 case pokemon
    when MAGIKARP
	when PHIONE
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

end



def pbStarterSelection(level)
	if AMOUNT > 1
	loop do
    msgwindow = pbCreateMessageWindow(nil,nil)
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
	 lvlbuff = pbChooseNumber(msgwindow,params)
     pbDisposeMessageWindow(msgwindow)
	 if lvlbuff > LEVELBUFFCAP
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
    pkmn = (pbTextEntry("Enter a Pokemon name.",0,10,3)).upcase
	pkmn = pbFixSpellingErrors(pkmn)
	pkmn = pbRandomCheck(pkmn)
	if !GameData::Species.exists?(pkmn)
	  pbMessage(_INTL("That's not a Pokemon!"))
	else
	pkmnid = GameData::Species.get(pkmn).id
    if pbLegendaryStarter?(pkmn)
	   pbMessage(_INTL("{1} is too powerful.",pkmn))
	elsif pbLegendaryStarter?(pkmn)
	  
	elsif pkmnid!=GameData::Species.get(pkmnid).get_baby_species 
	   pbMessage(_INTL("{1} is an evolved Pokemon, {2} will be used instead.",$game_variables[3],GameData::Species.get(pkmnid).get_baby_species))
	   pkmnid = GameData::Species.get(pkmnid).get_baby_species
	   pkmn = GameData::Species.get(pkmnid).name
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
  if pkmn = t.real_name.upcase
    pkmn=pbRandomStarter(pkmn)
	return pkmn
  end
  end
end


def pbRandomStarter(type)
  loop do
  pokemonavil = []
  GameData::Species.each_species do |sp|
    if type!="NONE"
	   sp.types.each do |i|
	     if i == type
		 pokemonavil << sp.id
		 end
	   end
	else
	   pokemonavil << sp.id
	end
  end
  pkmn = pokemonavil[rand(pokemonavil)]
  if !pbLegendaryStarter?(pkmn)
    return pkmn
  end
end
end



