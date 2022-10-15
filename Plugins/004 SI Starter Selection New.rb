AMOUNT=0
PLAYERAGE = $game_variables[326]
LEVEL = 5 
def pbStarterSelection
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("How many Pokemon do you want to start with?"))
    command = pbShowCommands(msgwindow,
                    [_INTL("One"),
                    _INTL("Two")],0)
	pbDisposeMessageWindow(msgwindow)
	case command 
    when 0  
      AMOUNT=1	
    when 1   
      AMOUNT=2
	end
	loop do
     msgwindow = pbCreateMessageWindow(nil,nil)
     pbMessageDisplay(msgwindow,_INTL("How long ago did you get them?"))
	 years = pbChooseNumber(msgwindow,params)
     pbDisposeMessageWindow(msgwindow)
	 if pbConfirmMessage(_INTL("You got them {1} years ago?",years))
	    break
	 else
	   pbMessage(_INTL("It's hard to remember sometimes."))
	 end
    LEVEL = PLAYERAGE-years
	if $player.name=="ADALYNN"||$player.name=="Adalynn"||$player.name=="adalynn"
	   pkmn = Pokemon.new(:VULPIII,LEVEL+rand(6))
	   pkmn2 = Pokemon.new(:VULPIII,LEVEL+rand(6))
	   pkmn.name = "Xander"
	   pkmn2.name = "Aurora"
	   pkmn2.form = 1
	   pkmn2.obtain_text = "Hoenn"
	   pkmn2.reset_moves
	   pkmn2.loyalty = 100
	   pkmn2.water = 100
	   pkmn2.food = 100
	   pkmn2.age = pbGet(328)
	   pkmn2.calc_stats
	   pkmn.obtain_text = "Hoenn"
	   pkmn.makeMale
	   $player.pokedex.register(pkmn)
	   $player.pokedex.register(pkmn2)
	   pkmn.loyalty = 100
	   pkmn.water = 100
	   pkmn.food = 100
	   pkmn.age = pbGet(328)
	   pkmn.calc_stats
	else
	loop do
	  if AMOUNT == 2
      	pbTextEntry("Enter a Pokemon name.",0,10,3)
	  pkmn = pbGet(3)
	  pkmnid = GameData::Species.get(pbGet(3)).id
	  if !GameData::Species.exists?(pkmn)
	   pbMessage(_INTL("That's not a Pokemon!"))
	  else 
	  elsif pbLegendaryStarter?(3)
	   pbMessage(_INTL("{1} is too powerful.",$game_variables[3]))
	  elsif pkmn == "PHIONE"
	  elsif pkmnid!=GameData::Species.get(pkmnid).get_baby_species 
	   pbMessage(_INTL("{1} is an evolved Pokemon, {2} will be used instead.",$game_variables[3],GameData::Species.get(pkmnid).get_baby_species))
	   pkmnid = GameData::Species.get(pkmnid).get_baby_species
	   pkmn = GameData::Species.get(pkmnid).name
	  else 
	    if pbConfirmMessage(_INTL("Are you sure you want to select {1}?",pkmn))
		 pbAddPokemon(pkmnid,LEVEL+rand(6))
		end
	  end 
	  end
	   pbTextEntry("Enter a Pokemon name.",0,10,3)
	  pkmn = pbGet(3)
	  pkmnid = GameData::Species.get(pbGet(3)).id
	  if !GameData::Species.exists?(pkmn)
	   pbMessage(_INTL("That's not a Pokemon!"))
	  else 
	  elsif pbLegendaryStarter?(3)
	   pbMessage(_INTL("{1} is too powerful.",$game_variables[3]))
	  elsif pkmn == "PHIONE"
	  elsif pkmnid!=GameData::Species.get(pkmnid).get_baby_species 
	   pbMessage(_INTL("{1} is an evolved Pokemon, {2} will be used instead.",$game_variables[3],GameData::Species.get(pkmnid).get_baby_species))
	   pkmnid = GameData::Species.get(pkmnid).get_baby_species
	   pkmn = GameData::Species.get(pkmnid).name
	  else 
	    if pbConfirmMessage(_INTL("Are you sure you want to select {1}?",pkmn))
		 pbAddPokemon(pkmnid,LEVEL+rand(6))
		 break
		end
	  end 
	
	end
    end
	end
	
end




def pbLegendaryStarter?(variable)
    starter=$game_variables[variable]
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


def pbIsLowestEvolutionStarter?(variable)
  starter=$game_variables[variable]
  pkmn=GameData::Species.get(starter).id
  return true if pkmn==GameData::Species.get(pkmn).get_baby_species
  return false
end



def pbSetBaseEvolutionStarter(variable)
  pkmn = GameData::Species.get($game_variables[variable]).get_baby_species
  $game_variables[variable] = pkmn
end

def pbSetGameVariables(variable,wariable)
  $game_variables[variable] = $game_variables[wariable]
end

###---END NEW---###
