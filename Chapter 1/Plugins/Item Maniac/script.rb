#===============================================================================
#  Sets the ItemManiac prices without a need for another PBS file
#===============================================================================
class ItemManiacAdapter < PokemonMartAdapter
  def getPrice(item, multiplier, selling = false)
    if $game_temp.mart_prices && $game_temp.mart_prices[item]
      if selling
        return $game_temp.mart_prices[item][1] if $game_temp.mart_prices[item][1] >= 0
      else
        return $game_temp.mart_prices[item][0] if $game_temp.mart_prices[item][0] > 0
      end
    end
    return (GameData::Item.get(item).price * multiplier).round() # Set the Item Maniac price increase multiplier here
  end
end

#===============================================================================
#  Removes the automatic /2 price shown through the Scene
#===============================================================================
class ItemManiac_Scene < PokemonMart_Scene
  def pbChooseNumber(helptext,item,maximum,multiplier)
    curnumber = 1
    ret = 0
    helpwindow = @sprites["helpwindow"]
    itemprice = @adapter.getPrice(item,multiplier,!@buying)
    pbDisplay(helptext, true)
    using(numwindow = Window_AdvancedTextPokemon.new("")) {   # Showing number of items
      qty = @adapter.getQuantity(item)
      using(inbagwindow = Window_AdvancedTextPokemon.new("")) {   # Showing quantity in bag
        pbPrepareWindow(numwindow)
        pbPrepareWindow(inbagwindow)
        numwindow.viewport = @viewport
        numwindow.width = 224
        numwindow.height = 64
        numwindow.baseColor = Color.new(88, 88, 80)
        numwindow.shadowColor = Color.new(168, 184, 184)
        inbagwindow.visible = @buying
        inbagwindow.viewport = @viewport
        inbagwindow.width = 190
        inbagwindow.height = 64
        inbagwindow.baseColor = Color.new(88, 88, 80)
        inbagwindow.shadowColor = Color.new(168, 184, 184)
        inbagwindow.text = _INTL("In Bag:<r>{1}  ", qty)
        numwindow.text = _INTL("x{1}<r>$ {2}", curnumber, (curnumber * itemprice).to_s_formatted)
        pbBottomRight(numwindow)
        numwindow.y -= helpwindow.height
        pbBottomLeft(inbagwindow)
        inbagwindow.y -= helpwindow.height
        loop do
          Graphics.update
          Input.update
          numwindow.update
          inbagwindow.update
          self.update
          if Input.repeat?(Input::LEFT)
            pbPlayCursorSE
            curnumber -= 10
            curnumber = 1 if curnumber < 1
            numwindow.text = _INTL("x{1}<r>$ {2}", curnumber, (curnumber * itemprice).to_s_formatted)
          elsif Input.repeat?(Input::RIGHT)
            pbPlayCursorSE
            curnumber += 10
            curnumber = maximum if curnumber > maximum
            numwindow.text = _INTL("x{1}<r>$ {2}", curnumber, (curnumber * itemprice).to_s_formatted)
          elsif Input.repeat?(Input::UP)
            pbPlayCursorSE
            curnumber += 1
            curnumber = 1 if curnumber > maximum
            numwindow.text = _INTL("x{1}<r>$ {2}", curnumber, (curnumber * itemprice).to_s_formatted)
          elsif Input.repeat?(Input::DOWN)
            pbPlayCursorSE
            curnumber -= 1
            curnumber = maximum if curnumber < 1
            numwindow.text = _INTL("x{1}<r>$ {2}", curnumber, (curnumber * itemprice).to_s_formatted)
          elsif Input.trigger?(Input::USE)
            pbPlayDecisionSE
            ret = curnumber
            break
          elsif Input.trigger?(Input::BACK)
            pbPlayCancelSE
            ret = 0
            break
          end
        end
      }
    }
    helpwindow.visible = false
    return ret
  end
end

#===============================================================================
#  Screen specific for the ItemManiac
#===============================================================================

class ItemManiacScreen < PokemonMartScreen

  def initialize(scene,stock)
    @scene = scene
	@stock = stock
	@adapter = ItemManiacAdapter.new
  end

  def pbSellScreenManiac(multiplier)
    item=@scene.pbStartBuyOrSellScene(false,@stock,@adapter)
    loop do
	  @scene.pbShowMoney
      item=@scene.pbChooseBuyItem
      break if !item
      itemname=@adapter.getDisplayName(item)
      price=@adapter.getPrice(item,multiplier,true)
      qty=@adapter.getQuantity(item)
	  if qty==0
	    pbMessage(_INTL("You do not currently have any {1}",GameData::Item.get(item).name_plural))
		next
      end
      @scene.pbShowMoney
      if qty>1
        qty=@scene.pbChooseNumber(
           _INTL("{1}? How many would you like to sell?",GameData::Item.get(item).name_plural),item,qty,multiplier)
      end
      if qty==0
        @scene.pbHideMoney
        next
      end
      price*=qty
      if pbConfirm(_INTL("I can pay ${1}. Would that be OK?",price.to_s_formatted))
        @adapter.setMoney(@adapter.getMoney+price)
        qty.times do
          @adapter.removeItem(item)
        end
        pbDisplayPaused(_INTL("Turned over the {1} and received ${2}.",itemname,price.to_s_formatted)) { pbSEPlay("Mart buy item") }
        @scene.pbRefresh
      end
      @scene.pbHideMoney
    end
    @scene.pbEndSellScene
  end
end


#===============================================================================
#  Initializes the ItemManiac conversation
#===============================================================================
def pbItemManiac(stock,multiplier=5,initiate_speech="Do you have any mushrooms? I will pay extra for any you have!",end_speech="Come back if you find any mushrooms!")
  # This is the text when you initiate a conversation with the item maniac
  pbMessage(_INTL(initiate_speech))
  for i in 0...stock.length
    stock[i] = GameData::Item.get(stock[i]).id
    stock[i] = nil if GameData::Item.get(stock[i]).is_important? && $PokemonBag.pbHasItem?(stock[i])
  end
  stock.compact!
  scene = ItemManiac_Scene.new
  screen = ItemManiacScreen.new(scene,stock)
  screen.pbSellScreenManiac(multiplier)
  # This is the text when you stop talking to the item maniac
  pbMessage(_INTL(end_speech))
  $game_temp.clear_mart_prices
end