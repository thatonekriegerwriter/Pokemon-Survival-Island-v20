def pbCookMeat(home=false,poke=nil)
     Kernel.pbMessage(_INTL("You decide to use this POKeMON for food."))
	   if home==true
	   pkmn = pbGetPokemon(1)
	   poke = pkmn
	   puts pbGetPokemon(1)
	   end
	   if !poke.nil?
	   pkmn = poke
	   end
	   if $bag.add(GameData::Item.get(pkmn.poke_ball).id,1)
	   puts pkmn.poke_ball
	   end
	   if pkmn== :MAGIKARP
	    if home==true
	    Kernel.pbMessage(_INTL("Wow, there is no meat on the Magikarp."))
		else
        pbDisplayPaused(_INTL("Wow, there is no meat on the Magikarp."))
		end
	   elsif pkmn == :SLOWPOKE
		$bag.add(:MEAT,(rand(3)+4))
		$bag.add(:SLOWPOKETAIL,(rand(3)+4))
	   elsif pkmn == :SNORLAX
		$bag.add(:MEAT,(rand(3)+4))
	   elsif pkmn.type1 == :FLYING
		$bag.add(:BIRDMEAT,(rand(3)+1))
	   elsif pkmn.type1 == :NORMAL
		$bag.add(:MEAT,(rand(3)+1))
	   elsif pkmn.type1 == :FIGHTING
		$bag.add(:MEAT,(rand(3)+1))
	   elsif pkmn.type1 == :POISON
		$bag.add(:POISONOUSMEAT,(rand(3)+1))
	   elsif pkmn.type1 == :GROUND
		$bag.add(:ROCKYMEAT,(rand(3)+1))
	   elsif pkmn.type1 == :ROCK
		$bag.add(:ROCKYMEAT,(rand(3)+1))
	   elsif pkmn.type1 == :BUG
		$bag.add(:BUGMEAT,(rand(3)+1))
	   elsif pkmn.type1 == :GHOST
	    if home==true
        Kernel.pbMessage(_INTL("You can't kill a ghost."))
		else
        pbDisplayPaused(_INTL("Wow, there is no meat on the Magikarp."))
		end
	   elsif pkmn.type1 == :STEEL
		$bag.add(:STEELYMEAT,(rand(3)+1))
	   elsif pkmn.type1 == :WATER
		$bag.add(:SUSHI,(rand(3)+1))
	   elsif pkmn.type1 == :GRASS
		$bag.add(:LEAFYMEAT,(rand(3)+1))
	   elsif pkmn.type1 == :ELECTRIC
		$bag.add(:MEAT,(rand(3)+1))
	   elsif pkmn.type1 == :PSYCHIC
		$bag.add(:MEAT,(rand(3)+1))
	   elsif pkmn.type1 == :ICE
		$bag.add(:FROZENMEAT,(rand(3)+1))
	   elsif pkmn.type1 == :DRAGON
		$bag.add(:DRAGONMEAT,(rand(3)+1))
	   elsif pkmn.type1 == :DARK
		$bag.add(:MEAT,(rand(3)+1))
	   elsif pkmn.type1 == :CRYSTAL
		$bag.add(:EDIABLESCRYSTAL,(rand(3)+1))
	   elsif pkmn.type1 == :WIND
		$bag.add(:MEAT,(rand(3)+1))
	   else
	    $bag.add(:MEAT,(rand(6)+1))
	   end
	   if home==true
       $player.remove_pokemon_at_index(pbGet(1))
	   end
	  end






