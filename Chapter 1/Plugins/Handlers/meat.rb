def pbCookMeat


     Kernel.pbMessage(_INTL("You decide to use this POKeMON for food."))
	   if pbGetPokemon(1)== :MAGIKARP
        $Trainer.remove_pokemon_at_index(pbGet(1))
	    Kernel.pbMessage(_INTL("Wow, there is no meat on the Magikarp."))
	   elsif pbGetPokemon(1) == :SNORLAX
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:MEAT,(rand(3)+4))
	   elsif pbGetPokemon(1).type1 == :FLYING
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:BIRDMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :NORMAL
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:MEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :FIGHTING
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:MEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :POISON
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:POISONOUSMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :GROUND
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:ROCKYMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :ROCK
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:ROCKYMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :BUG
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:BUGMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :GHOST
        Kernel.pbMessage(_INTL("You can't kill a ghost."))
	   elsif pbGetPokemon(1).type1 == :STEEL
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:STEELYMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :WATER
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:SUSHI,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :GRASS
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:LEAFYMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :ELECTRIC
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:MEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :PSYCHIC
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:MEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :ICE
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:ICEYROCKS,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :DRAGON
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:DRAGONMEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :DARK
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:MEAT,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :CRYSTAL
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:EDIABLESCRYSTAL,(rand(3)+1))
	   elsif pbGetPokemon(1).type1 == :WIND
        $Trainer.remove_pokemon_at_index(pbGet(1))
		Kernel.pbReceiveItem(:MEAT,(rand(3)+1))
	   else
        $Trainer.remove_pokemon_at_index(pbGet(1))
	    Kernel.pbReceiveItem(:MEAT,(rand(6)))
	   end
	  end






