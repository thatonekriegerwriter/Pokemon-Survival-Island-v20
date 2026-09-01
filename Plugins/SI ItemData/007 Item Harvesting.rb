module ItemDropsConfig
# Config for amount dropped by each.
Common_Item_Quantity=rand(6)+1
Uncommon_Item_Quantity=rand(4)+1
Rare_Item_Quantity=rand(2)+1

#Normal Chances
Common_Item_Chance=75
Uncommon_Item_Chance=50
Rare_Item_Chance=40

#Compound Eyes Chances
Common_Compound_Chance=90
Uncommon_Compound_Chance=55
Rare_Compound_Chance=50

#Super Luck Chances
Common_SuperLuck_Chance=100
Uncommon_SuperLuck_Chance=60
Rare_SuperLuck_Chance=60

end
   
  def pbPrepareMeat(pkmn)
    return if pkmn.types.include?(:GHOST)

  
   if pkmn.species==:MAGIKARP && !$player.is_it_this_class?(:FISHER)
    if $player.party.include?(pkmn)
		index = $player.party.index(pkmn)
		$player.remove_pokemon_at_index(index)
		ball = pkmn.poke_ball if pkmn.poke_ball.is_a?(ItemData)
		ball = GameData::Item.get(pkmn.poke_ball).id if !pkmn.poke_ball.is_a?(ItemData)
		$bag.add(ball,1)
    end
    if rand(2)==0
	    geoiag= rand(2)+1
        bone = ItemData.new(:RAREBONE)
		if $bag.add(bone,geoiag)
		itemAnim(bone,geoiag) if !$game_temp.in_battle
		end
	end
   
    return
   end


    food_item = ItemData.new(:MEAT)
    weight = pkmn.weight
	puts "Weight for #{pkmn.name}: #{weight}"
	amt = Math.sqrt(weight) * 0.05
    amt = amt.round
    amt = [amt, 1].max
	amt += rand(2)
	amt = (amt * 1.5).round if $player.is_it_this_class?(:FISHER,false)
	amt = 1 if pkmn.species==:MAGIKARP && $player.is_it_this_class?(:FISHER)
	
    total_ivs = pkmn.iv[:HP] + pkmn.iv[:ATTACK] + pkmn.iv[:DEFENSE] + pkmn.iv[:SPECIAL_ATTACK] + pkmn.iv[:SPECIAL_DEFENSE] + pkmn.iv[:SPEED]
    max_ivs = 31 * 6
	
	
	
	
	
    food_item.quality=((total_ivs.to_f / max_ivs * 4).round)+1
    food_item.stats.priority=3
    food_item.stats.servings=1
	
	
	
	
	type = pkmn.types.sample
	case type
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

    return [food_item, amt]
  end   
   
  
  def pbCookMeat(pkmn)
    puts caller.join("\n")
    return if pkmn.types.include?(:GHOST)
    food_item, amt = pbPrepareMeat(pkmn)
	return unless food_item
	return unless amt 
    if pkmn.species == :SLOWPOKE
	  if $bag.add(:SLOWPOKETAIL,1)
		itemAnim(:SLOWPOKETAIL,1) if !$game_temp.in_battle
	  end
	end 
	if $bag.add(food_item,amt)
		itemAnim(food_item.id,amt) if !$game_temp.in_battle
	end
	if rand(12)==0
	    geoiag = rand(2)+1
        bone = ItemData.new(:RAREBONE)
		if $bag.add(bone,geoiag)
		  itemAnim(bone,geoiag) if !$game_temp.in_battle
		end
	end



    if $player.party.include?(pkmn)
		index = $player.party.index(pkmn)
		$player.remove_pokemon_at_index(index)
		ball = pkmn.poke_ball if pkmn.poke_ball.is_a?(ItemData)
		ball = GameData::Item.get(pkmn.poke_ball).id if !pkmn.poke_ball.is_a?(ItemData)
		$bag.add(ball,1)
    end


  end






def pbHeldItemDropOW(pkmn,meat=false)


pbCookMeat(pkmn) if meat==true


if pkmn.types.include?(:ROCK)
  amt = rand(2)+1
        if $bag.add(:STONE,amt)
		itemAnim(:STONE,amt)
        end
end
if pkmn.types.include?(:STEEL)
        if $bag.add(:IRON2,1)
		itemAnim(:IRON2,1)
        end
end
if pkmn.types.include?(:FLYING)
    feathers = [:PRETTYFEATHER, :PRETTYFEATHER, :PRETTYFEATHER, :HEALTHFEATHER, :HEALTHFEATHER, :HEALTHFEATHER, :HEALTHFEATHER, :MUSCLEFEATHER, :RESISTFEATHER, :GENIUSFEATHER, :CLEVERFEATHER, :SWIFTFEATHER] 
	item = feathers[rand(feathers.length)]
        if $bag.add(item,1)
		itemAnim(item,1)
        end
end



return if pkmn.wildHoldItems.nil?
    wildDrop = pkmn.wildHoldItems
    firstqty = rand(6)+1
    secondqty = rand(4)+1
    thirdqty = rand(2)+1
	bonus = 0
	if pbInSafari?
	 bonus+=10
	end
	firstPkmn = $player.first_pokemon
    chances = [ItemDropsConfig::Common_Item_Chance,ItemDropsConfig::Uncommon_Item_Chance,ItemDropsConfig::Rare_Item_Chance]
  if firstPkmn
    case firstPkmn.ability_id
    when :COMPOUNDEYES
      chances = [ItemDropsConfig::Common_Compound_Chance,ItemDropsConfig::Uncommon_Compound_Chance,ItemDropsConfig::Rare_Compound_Chance]
    when :SUPERLUCK
      chances = [ItemDropsConfig::Common_SuperLuck_Chance,ItemDropsConfig::Uncommon_SuperLuck_Chance,ItemDropsConfig::Rare_SuperLuck_Chance]
    end
  end
    droprnd = rand(100)




	if wildDrop[0] == wildDrop[1] && wildDrop[1] == wildDrop[2]
  	  item = wildDrop[0].sample
	  unless item.nil?
        item = GameData::Item.get(item)
        itemAnim(item, firstqty) if $bag.add(item, firstqty)
	  end
	else
	  if droprnd < chances[0] + bonus
        item = wildDrop[0].sample
        unless item.nil?
         item = GameData::Item.get(item)
         itemAnim(item, firstqty) if $bag.add(item, firstqty)
        end
	  end

	  if droprnd < chances[1] + bonus
        item = wildDrop[1].sample
        unless item.nil?
         item = GameData::Item.get(item)
         itemAnim(item, secondqty) if $bag.add(item, secondqty)
        end
	  end

	  if droprnd < chances[2] + bonus
        item = wildDrop[2].sample
        unless item.nil?
         item = GameData::Item.get(item)
         itemAnim(item, thirdqty) if $bag.add(item, thirdqty)
        end
	  end
	end


end

def pbItemThieving(pkmn)
return if pkmn.wildHoldItems.nil?
    wildDrop = pkmn.wildHoldItems
    firstqty = rand(6)+1
	bonus = 0
    if wildDrop[0] && rand(33) < 10
	    item = wildDrop[0].sample
	    if item.nil?
		else
		item = GameData::Item.get(item) 
        if $bag.add(item,firstqty)
		itemAnim(item,firstqty)
		return true
        end
		end
    end
	return false
end



class Battle::Scene
  def pbWildBattleSuccess
    pbBGMPlay(pbGetWildVictoryBGM)
	if pbInSafari? && @decision == 1
	b = @battle.battlers[1]
    pkmn = @battle.battlers[1].pokemon
    if !pkmn
	@battleEnd = true
	end
    if pkmn.wildHoldItems.nil?
	@battleEnd = true
	end
    wildDrop = pkmn.wildHoldItems
    firstqty = rand(6)+1
    secondqty = rand(4)+1
    thirdqty = rand(2)+1
	bonus = 0
	if pbInSafari?
	 bonus+=10
	end
	firstPkmn = $player.first_pokemon
    chances = [ItemDropsConfig::Common_Item_Chance,ItemDropsConfig::Uncommon_Item_Chance,ItemDropsConfig::Rare_Item_Chance]
  if firstPkmn
    case firstPkmn.ability_id
    when :COMPOUNDEYES
      chances = [ItemDropsConfig::Common_Compound_Chance,ItemDropsConfig::Uncommon_Compound_Chance,ItemDropsConfig::Rare_Compound_Chance]
    when :SUPERLUCK
      chances = [ItemDropsConfig::Common_SuperLuck_Chance,ItemDropsConfig::Uncommon_SuperLuck_Chance,ItemDropsConfig::Rare_SuperLuck_Chance]
    end
  end
    droprnd = rand(100)
      if (wildDrop[0]==wildDrop[1] && wildDrop[1]==wildDrop[2]) || droprnd<(chances[0]+bonus)
	    item = wildDrop[0].sample
	    if item.nil?
		else
		item = GameData::Item.get(item) 
        if $bag.add(item,firstqty)
          itemname = GameData::Item.get(item).name
          pocket = item.pocket
          @battle.pbDisplayPaused(_INTL("{1} dropped\n{2} <icon=bagPocket#{pocket}> x{3}!",b.pbThis,itemname,firstqty))
        end
		end
      end
      if droprnd<(chances[1]+bonus)
	    item = wildDrop[1].sample
	    if item.nil?
		else
		item = GameData::Item.get(item)
        if $bag.add(item,secondqty)
          itemname = GameData::Item.get(item).name
          pocket = item.pocket
          @battle.pbDisplayPaused(_INTL("{1} dropped\n{2} <icon=bagPocket#{pocket}> x{3}!",b.pbThis,itemname,secondqty))
        end
		end
      end
      if droprnd<(chances[2]+bonus)
	    item = wildDrop[2].sample
	    if item.nil?
		else
		item = GameData::Item.get(item)
        if $bag.add(item,thirdqty)
          itemname = GameData::Item.get(item).name
          pocket = item.pocket
          @battle.pbDisplayPaused(_INTL("{1} dropped\n{2} <icon=bagPocket#{pocket}> x{3}!",b.pbThis,itemname,thirdqty))
        end
	   end
     end
	else
    @battle.battlers.each {|b|
    next if !b
	if !pbInSafari?
    next if !b.opposes?
	end
    pkmn = b.pokemon
    next if !pkmn
    next if pkmn.wildHoldItems.nil?
    wildDrop = pkmn.wildHoldItems
    firstqty = rand(6)+1
    secondqty = rand(4)+1
    thirdqty = rand(2)+1
	bonus = 0
	if pbInSafari?
	 bonus+=10
	end
	firstPkmn = $player.first_pokemon
    chances = [ItemDropsConfig::Common_Item_Chance,ItemDropsConfig::Uncommon_Item_Chance,ItemDropsConfig::Rare_Item_Chance]
  if firstPkmn
    case firstPkmn.ability_id
    when :COMPOUNDEYES
      chances = [ItemDropsConfig::Common_Compound_Chance,ItemDropsConfig::Uncommon_Compound_Chance,ItemDropsConfig::Rare_Compound_Chance]
    when :SUPERLUCK
      chances = [ItemDropsConfig::Common_SuperLuck_Chance,ItemDropsConfig::Uncommon_SuperLuck_Chance,ItemDropsConfig::Rare_SuperLuck_Chance]
    end
  end
    droprnd = rand(100)
      if (wildDrop[0]==wildDrop[1] && wildDrop[1]==wildDrop[2]) || droprnd<(chances[0]+bonus)
	    item = wildDrop[0].sample
	    if item.nil?
		else
		item = GameData::Item.get(item) 
        if $bag.add(item,firstqty)
          itemname = GameData::Item.get(item).name
          pocket = item.pocket
          @battle.pbDisplayPaused(_INTL("{1} dropped\n{2} <icon=bagPocket#{pocket}> x{3}!",b.pbThis,itemname,firstqty))
        end
		end
      end
      if droprnd<(chances[1]+bonus)
	    item = wildDrop[1].sample
	    if item.nil?
		else
		item = GameData::Item.get(item)
        if $bag.add(item,secondqty)
          itemname = GameData::Item.get(item).name
          pocket = item.pocket
          @battle.pbDisplayPaused(_INTL("{1} dropped\n{2} <icon=bagPocket#{pocket}> x{3}!",b.pbThis,itemname,secondqty))
        end
		end
      end
      if droprnd<(chances[2]+bonus)
	    item = wildDrop[2].sample
	    if item.nil?
		else
		item = GameData::Item.get(item)
        if $bag.add(item,thirdqty)
          itemname = GameData::Item.get(item).name
          pocket = item.pocket
          @battle.pbDisplayPaused(_INTL("{1} dropped\n{2} <icon=bagPocket#{pocket}> x{3}!",b.pbThis,itemname,thirdqty))
        end
	   end
      end
    }
    end
  
	@battleEnd = true
  end

end