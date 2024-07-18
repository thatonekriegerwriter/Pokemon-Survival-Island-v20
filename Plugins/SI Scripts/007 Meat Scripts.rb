def pbCookMeat(home=false,poke=nil,combat=false,anim=false)
	   if home==true
	   pkmn = pbGetPokemon(1)
	   poke = pkmn
	   end
	   if !poke.nil?
	   pkmn = poke
	   end
	   if combat==false
	   if $bag.add(GameData::Item.get(pkmn.poke_ball).id,1)
	   end
	   end
	   if pkmn == :SLOWPOKE
		b=(rand(2)+2)
	    a=(rand(2)+2)
		$bag.add(:MEAT,a)
		$bag.add(:SLOWPOKETAIL,b)
		if anim==true
		itemAnim(:MEAT,a)
		itemAnim(:SLOWPOKETAIL,b)
		end
	   elsif pkmn == :SNORLAX
	    a=(rand(3)+4)
		$bag.add(:MEAT,a)
		if anim==true
		itemAnim(:MEAT,a)
		end
	   elsif pkmn.type1 == :FLYING
	    a=(rand(2)+1)
		$bag.add(:BIRDMEAT,a)
		if anim==true
		itemAnim(:BIRDMEAT,a)
		end
	   elsif pkmn.type1 == :NORMAL
	    a=(rand(2)+1)
		$bag.add(:MEAT,a)
		if anim==true
		itemAnim(:MEAT,a)
		end
	   elsif pkmn.type1 == :FIGHTING
	    a=(rand(2)+1)
		$bag.add(:MEAT,a)
		if anim==true
		itemAnim(:MEAT,a)
		end
	   elsif pkmn.type1 == :POISON
	    a=(rand(2)+1)
		$bag.add(:POISONOUSMEAT,a)
		if anim==true
		itemAnim(:POISONOUSMEAT,a)
		end
	   elsif pkmn.type1 == :GROUND
	    a=(rand(2)+1)
		$bag.add(:ROCKYMEAT,a)
		if anim==true
		itemAnim(:ROCKYMEAT,a)
		end
	   elsif pkmn.type1 == :ROCK
	    a=(rand(2)+1)
		$bag.add(:ROCKYMEAT,a)
		if anim==true
		itemAnim(:ROCKYMEAT,a)
		end
	   elsif pkmn.type1 == :BUG
	    a=(rand(2)+1)
		$bag.add(:BUGMEAT,a)
		if anim==true
		itemAnim(:BUGMEAT,a)
		end
	   elsif pkmn.type1 == :GHOST
	    if home==true
        Kernel.pbMessage(_INTL("You can't kill a ghost."))
		else
        pbDisplayPaused(_INTL("You can't kill a ghost."))
		end
	   elsif pkmn.type1 == :STEEL
	    a=(rand(2)+1)
		$bag.add(:STEELYMEAT,a)
		if anim==true
		itemAnim(:STEELYMEAT,a)
		end
	   elsif pkmn.type1 == :WATER
	    a=(rand(2)+1)
		$bag.add(:SUSHI,a)
		if anim==true
		itemAnim(:SUSHI,a)
		end
	   elsif pkmn.type1 == :GRASS
	    a=(rand(2)+1)
		$bag.add(:LEAFYMEAT,a)
		if anim==true
		itemAnim(:LEAFYMEAT,a)
		end
	   elsif pkmn.type1 == :ELECTRIC
	    a=(rand(2)+1)
		$bag.add(:MEAT,a)
		if anim==true
		itemAnim(:MEAT,a)
		end
	   elsif pkmn.type1 == :PSYCHIC
	    a=(rand(2)+1)
		$bag.add(:MEAT,a)
		if anim==true
		itemAnim(:MEAT,a)
		end
	   elsif pkmn.type1 == :ICE
	    a=(rand(2)+1)
		$bag.add(:FROZENMEAT,a)
		if anim==true
		itemAnim(:FROZENMEAT,a)
		end
	   elsif pkmn.type1 == :DRAGON
	    a=(rand(2)+1)
		$bag.add(:DRAGONMEAT,a)
		if anim==true
		itemAnim(:DRAGONMEAT,a)
		end
	   elsif pkmn.type1 == :DARK
	    a=(rand(2)+1)
		$bag.add(:MEAT,a)
		if anim==true
		itemAnim(:MEAT,a)
		end
	   elsif pkmn.type1 == :CRYSTAL
	    a=(rand(2)+1)
		$bag.add(:EDIABLESCRYSTAL,a)
		if anim==true
		itemAnim(:EDIABLESCRYSTAL,a)
		end
	   elsif pkmn.type1 == :WIND
	    a=(rand(2)+1)
		$bag.add(:MEAT,a)
		if anim==true
		itemAnim(:MEAT,a)
		end
	   else
	    a=(rand(2)+1)
	    $bag.add(:MEAT,a)
		if anim==true
		itemAnim(:MEAT,a)
		end
	   end
	    if rand(4)==0
		$bag.add(:RAREBONE,1)
		if anim==true
		itemAnim(:RAREBONE,1)
		end
		end
	   if home==true
       $player.remove_pokemon_at_index(pbGet(1))
	   end
	  end






