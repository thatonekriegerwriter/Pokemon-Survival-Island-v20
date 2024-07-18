﻿#===============================================================================
# * Frugal Charm
#===============================================================================

class PokemonMartAdapter
  def getPrice(item, selling = false)
    if $game_temp.mart_prices && $game_temp.mart_prices[item]
      if selling
        return $game_temp.mart_prices[item][1] if $game_temp.mart_prices[item][1] >= 0
      elsif $game_temp.mart_prices[item][0] > 0
        puts "elsif"
        return $game_temp.mart_prices[item][0]
      end
    end
    return GameData::Item.get(item).sell_price if selling
    return ($player.activeCharm?(:FRUGALCHARM) ? (GameData::Item.get(item).price / 2).round : GameData::Item.get(item).price )
  end
end