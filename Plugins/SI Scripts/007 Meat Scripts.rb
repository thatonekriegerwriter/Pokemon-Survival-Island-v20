  def pbCookMeat(pkmn)
   if pkmn.species==:MAGIKARP && $player.is_it_this_class?(:FISHER)
    if $player.party.include?(pkmn)
		index = $player.party.index(pkmn)
		$player.remove_pokemon_at_index(index)
		ball = pkmn.poke_ball if pkmn.poke_ball.is_a?(ItemData)
		ball = GameData::Item.get(pkmn.poke_ball).id if !pkmn.poke_ball.is_a?(ItemData)
		$bag.add(ball,1)
    end
    if rand(2)==0
		$bag.add(:RAREBONE,3)
		itemAnim(:RAREBONE,3) if !$game_temp.in_battle
	end
   
    return
   end
    food_item = ItemData.new(:MEAT)
     weight = pkmn.weight
	 amt = (weight*10)
     amt = 4 if amt>4
     amt = 1 if amt<1
     total_ivs = pkmn.iv[:HP] + pkmn.iv[:ATTACK] + pkmn.iv[:DEFENSE] + pkmn.iv[:SPECIAL_ATTACK] + pkmn.iv[:SPECIAL_DEFENSE] + pkmn.iv[:SPEED]
     max_ivs = 31 * 6
     food_item.food_water_stats["Quality"]=(total_ivs.to_f / max_ivs * 4).round
     food_item.food_water_stats["Priority"]=3
     food_item.food_water_stats["Servings"]=1
	  amt *= 1.5 if $player.is_it_this_class?(:FISHER,false)
	  amt = 1 if pkmn.species==:MAGIKARP && $player.is_it_this_class?(:FISHER)
    if pkmn.species == :SLOWPOKE
		$bag.add(food_item,amt)
		$bag.add(:SLOWPOKETAIL,1)
		itemAnim(food_item,amt) if !$game_temp.in_battle
		itemAnim(:SLOWPOKETAIL,1) if !$game_temp.in_battle
	    
	    
	else
      case pkmn.type1
        when :FLYING
		  food_item.id = :BIRDMEAT
        when :POISON
		  food_item.id = :POISONOUSMEAT
        when :GROUND
		  food_item.id = :ROCKYMEAT
        when :ROCK
		  food_item.id = :ROCKYMEAT
        when :BUG
		  food_item.id = :BUGMEAT
        when :GHOST
		  return
        when :STEEL
		  food_item.id = :STEELYMEAT
        when :WATER
		  food_item.id = :SUSHI
        when :GRASS
		  food_item.id = :LEAFYMEAT
        when :ICE
		  food_item.id = :FROZENMEAT
        when :DRAGON
		  food_item.id = :DRAGONMEAT
        when :CRYSTAL
		  food_item.id = :EDIABLESCRYSTAL
	  
	  
	  
	  
	  end
    end
    if pkmn.species != :SLOWPOKE
		$bag.add(food_item,amt)
		itemAnim(:RAREBONE,1) if !$game_temp.in_battle
	end
    if rand(12)==0
		$bag.add(:RAREBONE,1)
		itemAnim(:RAREBONE,1) if !$game_temp.in_battle
	end
    if $player.party.include?(pkmn)
		index = $player.party.index(pkmn)
		$player.remove_pokemon_at_index(index)
		ball = pkmn.poke_ball if pkmn.poke_ball.is_a?(ItemData)
		ball = GameData::Item.get(pkmn.poke_ball).id if !pkmn.poke_ball.is_a?(ItemData)
		$bag.add(ball,1)
    end
  end






