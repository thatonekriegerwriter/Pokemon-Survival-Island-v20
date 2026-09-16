
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

