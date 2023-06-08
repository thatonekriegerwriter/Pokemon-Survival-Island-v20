def pbRandomEvent
   if rand(256) >= 1 && rand(256) <= 5
    if $game_switches[132]==true && $game_switches[226]==true
     Kernel.pbMessage(_INTL("It sounds like something crashed."))   #Comet
     $game_switches[450]=true 
     $game_switches[451]=true 
	else
     Kernel.pbMessage(_INTL("The Sky looks beautiful tonight."))   #Comet
	end
=begin
   elsif rand(100) == 6
     
   elsif rand(100) == 7
     
   elsif rand(100) == 8
     
   elsif rand(100) == 9
     
   elsif rand(100) == 10
=end
end
end



def pbGrassEvolutionStone
pbChooseNonEggPokemon(1,3)
  case $game_variables[3]
     when "Gloom"
    Kernel.pbMessage(_INTL("Gloom evolves into Vileplume."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:VILEPLUME)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Weepingbell"
    Kernel.pbMessage(_INTL("Weepingbell evolves into Victreebell."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:VECTREEBEL)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Exeggcute" 
    Kernel.pbMessage(_INTL("Exeggcute evolves into Exeggcutor."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:EXEGGCUTOR)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Eevee"
    Kernel.pbMessage(_INTL("Eevee evolves into Leafeon."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:LEAFEON)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Nuzleaf"
    Kernel.pbMessage(_INTL("Nuzleaf evolves into Shiftry."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:SHIFTRY)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Pansage"
    Kernel.pbMessage(_INTL("Pansage evolves into Semisage."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:SEMISAGE)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Cherubi"
    Kernel.pbMessage(_INTL("Cherubi evolves into Cherrim."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:STEENEE)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
    Kernel.pbMessage(_INTL("OH! How abnormal!"))
     when "Bounsweet"
    Kernel.pbMessage(_INTL("Bounsweet evolves into Steenee."))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:CHERRIM)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
    Kernel.pbMessage(_INTL("OH! How abnormal!"))
	 else
    Kernel.pbMessage(_INTL("That does not seem to be able to evolve with this stone."))
  end
end


def pbEeveelution
pbChooseNonEggPokemon(1,3)
  case $game_variables[3]
     when "Eevee"
    Kernel.pbMessage(_INTL("We can't do anything with Eevee, just Eeveelutions."))
	
     when "Jolteon","Vaporeon","Sylveon","Leafeon","Flareon","Glaceon","Umbreon","Espeon"
    Kernel.pbMessage(_INTL("Stand back!"))
	pkmn=$player.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:EEVEE)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
	 else
    Kernel.pbMessage(_INTL("That... isn't an Eevee"))
  end
end


def pbDayChecker(month,day,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month && d == day #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
 end

def pbIndigoPlateauDays(month1,day1,day2,day3,day4,day5,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month1 && d == day1 || m == month1 && d == day2 || m == month1 && d == day3 || m == month1 && d == day4 || m == month1 && d == day5  #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
end

def pbIndigoPlateauDays2(month1,day1,month2,day2,month3,day3,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month1 && d == day1 || m == month2 && d == day2 || m == month3 && d == day3  #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
end




	
def pbNextChampionShip
    $game_variables[421]=rand(40)
end



def pbCheckName
name = pbEnterPlayerName(_INTL("What do you put?"), 0, Settings::MAX_PLAYER_NAME_SIZE)
if name.nil? || name.empty?
  return false
else
 $game_variables[4974]=name
  Kernel.pbMessage(_INTL("You are unsure on what it would have done."))
  return true
end
end
