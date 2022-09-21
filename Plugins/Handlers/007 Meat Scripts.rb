def pbCookMeat
     Kernel.pbMessage(_INTL("You decide to use this POKeMON for food."))
	   if pbGetPokemon(1)== :MAGIKARP
        $player.remove_pokemon_at_index(pbGet(1))
	    Kernel.pbMessage(_INTL("Wow, there is no meat on the Magikarp."))
	   elsif pbGetPokemon(1) == :SNORLAX
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:MEAT,(rand(3)+4))
	   elsif pbGetPokemon(1).type1 == :FLYING
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:BIRDMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :NORMAL
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:MEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :FIGHTING
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:MEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :POISON
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:POISONOUSMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :GROUND
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:ROCKYMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :ROCK
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:ROCKYMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :BUG
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:BUGMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :GHOST
        Kernel.pbMessage(_INTL("You can't kill a ghost."))
	   elsif pbGetPokemon(1).type1 == :STEEL
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:STEELYMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :WATER
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:SUSHI,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :GRASS
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:LEAFYMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :ELECTRIC
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:MEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :PSYCHIC
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:MEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :ICE
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:ICEYROCKS,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :DRAGON
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:DRAGONMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :DARK
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:MEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :CRYSTAL
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:EDIABLESCRYSTAL,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :WIND
        $player.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:MEAT,(rand(3)+1))
	   else
        $player.remove_pokemon_at_index(pbGet(1))
	    Kernel.pbReceiveItem(:MEAT,(rand(6)))
	   end
	  end






