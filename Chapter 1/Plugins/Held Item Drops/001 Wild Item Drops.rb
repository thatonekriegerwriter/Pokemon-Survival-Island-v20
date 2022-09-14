#Settings



class Battle::Scene
  def pbWildBattleSuccess
    @battle.battlers.each {|b|
    next if !b
    next if !b.opposes?
    pkmn = b.pokemon
    next if !pkmn
    next if pkmn.wildHoldItems.nil?
    wildDrop = pkmn.wildHoldItems
    firstqty = ItemDropsConfig::Common_Item_Quantity
    secondqty = ItemDropsConfig::Uncommon_Item_Quantity
    thirdqty = ItemDropsConfig::Rare_Item_Quantity
	firstPkmn = $player.first_pokemon
    chances = [ItemDropsConfig::Common_Item_Chance,ItemDropsConfig::Uncommon_Item_Chance,ItemDropsConfig::Rare_Item_Chance]
  if firstPkmn
    case firstPkmn.ability_id
    when :COMPOUNDEYES
      chances = [ItemDropsConfig::Common_Compound_Chance,ItemDropsConfig::Uncommon_Compound_Chance,ItemDropsConfig::Rare_Compound_Chance]
      chances = [60,40,15]
    when :SUPERLUCK
      chances = [ItemDropsConfig::Common_SuperLuck_Chance,ItemDropsConfig::Uncommon_SuperLuck_Chance,ItemDropsConfig::Rare_SuperLuck_Chance]
      chances = [50,50,50]
    end
  end
    droprnd = rand(100)
      if (wildDrop[0]==wildDrop[1] && wildDrop[1]==wildDrop[2]) || droprnd<chances[0]
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
      if droprnd<chances[1]
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
      if droprnd<chances[2]
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
    @battleEnd = true
    pbBGMPlay(pbGetWildVictoryBGM)
  end

end