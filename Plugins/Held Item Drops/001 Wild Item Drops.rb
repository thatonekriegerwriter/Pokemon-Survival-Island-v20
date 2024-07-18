#Settings
def pbHeldItemDropOW(pkmn,meat=false)
if meat==true
pbCookMeat(false,pkmn,true,true)
end
return if pkmn.wildHoldItems.nil?
    wildDrop = pkmn.wildHoldItems
    firstqty = ItemDropsConfig::Common_Item_Quantity
    secondqty = ItemDropsConfig::Uncommon_Item_Quantity
    thirdqty = ItemDropsConfig::Rare_Item_Quantity
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
		itemAnim(item,firstqty)
        end
		end
      end
      if droprnd<(chances[1]+bonus)
	    item = wildDrop[1].sample
	    if item.nil?
		else
		item = GameData::Item.get(item)
        if $bag.add(item,secondqty)
		itemAnim(item,secondqty)
        end
		end
      end
      if droprnd<(chances[2]+bonus)
	    item = wildDrop[2].sample
	    if item.nil?
		else
		item = GameData::Item.get(item)
        if $bag.add(item,thirdqty)
		itemAnim(item,thirdqty)
        end
	   end
     end
	

end

def pbItemThieving(pkmn)
return if pkmn.wildHoldItems.nil?
    wildDrop = pkmn.wildHoldItems
    firstqty = ItemDropsConfig::Common_Item_Quantity
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
	if pbInSafari?
	puts @battle.battlers[1].pokemon
	puts @battle.battlers[0].pokemon
	b = @battle.battlers[1]
    pkmn = @battle.battlers[1].pokemon
    if !pkmn
	@battleEnd = true
	end
    if pkmn.wildHoldItems.nil?
	@battleEnd = true
	end
    wildDrop = pkmn.wildHoldItems
    firstqty = ItemDropsConfig::Common_Item_Quantity
    secondqty = ItemDropsConfig::Uncommon_Item_Quantity
    thirdqty = ItemDropsConfig::Rare_Item_Quantity
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
    firstqty = ItemDropsConfig::Common_Item_Quantity
    secondqty = ItemDropsConfig::Uncommon_Item_Quantity
    thirdqty = ItemDropsConfig::Rare_Item_Quantity
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