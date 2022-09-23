module Pokeathlon

	def self.shop_exchange(stock, speech=nil)
		stock.each_with_index { |stk, i|
			stock[i][0] = GameData::Item.get(stk[0]).id
			stock[i][0] = nil if GameData::Item.get(stk[0]).is_important? && $PokemonBag.pbHasItem?(stk[0])
		}
		stock.compact!
		commands = []
		cmdBuy  = -1
		cmdQuit = -1
		commands[cmdBuy = commands.length]  = _INTL("Buy")
		commands[cmdQuit = commands.length] = _INTL("Quit")
		cmd = pbMessage(speech ? speech : _INTL("What do you want?"), commands, cmdQuit+1)
		loop do
			if cmdBuy>=0 && cmd==cmdBuy
				scene  = Pokeathlon::Exchange_Scene.new
				screen = Pokeathlon::ExchangeScreen.new(scene, stock)
				screen.pbBuyScreen
			else
				pbMessage(_INTL("Please come again!"))
				break
			end
			cmd = pbMessage(_INTL("Is there anything else I can help you with?"), commands, cmdQuit+1)
		end
		$game_temp.clear_mart_prices
	end

	class ExchangeAdap < PokemonMartAdapter

		def initialize(stock)
			@stock = stock
		end

		def getMoney = $PokemonGlobal.athlon_sum_points

		def setMoney(value)
			$PokemonGlobal.athlon_sum_points = value
		end

		def getPrice(item, selling = false)
			@stock.each { |i| return i[1] if i[0] == item }
			return 1000
		end

	end

	class ExchangeScreen < PokemonMartScreen
		def initialize(scene, stock)
			@scene = scene
			@stock = []
			@adapter = Pokeathlon::ExchangeAdap.new(stock)
			stock.each { |i| @stock << i.first }
		end

		def pbBuyScreen
			@scene.pbStartBuyScene(@stock, @adapter)
			item = nil
			loop do
				item = @scene.pbChooseBuyItem
				break if !item
				quantity = 0
				itemname = @adapter.getDisplayName(item)
				price = @adapter.getPrice(item)
				if @adapter.getMoney < price
					pbDisplayPaused(_INTL("You don't have enough points."))
					next
				end
				if GameData::Item.get(item).is_important?
					if !pbConfirm(_INTL("Certainly. You want {1}. That will be ${2}. OK?", itemname, price.to_s_formatted))
						next
					end
					quantity = 1
				else
					maxafford = (price <= 0) ? Settings::BAG_MAX_PER_SLOT : @adapter.getMoney / price
					maxafford = Settings::BAG_MAX_PER_SLOT if maxafford > Settings::BAG_MAX_PER_SLOT
					quantity = @scene.pbChooseNumber(_INTL("{1}? Certainly. How many would you like?", itemname), item, maxafford)
					next if quantity == 0
					price *= quantity
					next if !pbConfirm(_INTL("{1}, and you want {2}. That will be ${3}. OK?", itemname, quantity, price.to_s_formatted))
				end
				if @adapter.getMoney < price
					pbDisplayPaused(_INTL("You don't have enough points."))
					next
				end
				added = 0
				quantity.times do
					break if !@adapter.addItem(item)
					added += 1
				end
				if added != quantity
					added.times { raise _INTL("Failed to delete stored items") if !@adapter.removeItem(item) }
					pbDisplayPaused(_INTL("You have no more room in the Bag."))
				else
					@adapter.setMoney(@adapter.getMoney - price)
					(0...@stock.length).each { |i| @stock[i] = nil if GameData::Item.get(@stock[i]).is_important? && $PokemonBag.pbHasItem?(@stock[i]) }
					@stock.compact!
					pbDisplayPaused(_INTL("Here you are! Thank you!")) { pbSEPlay("Mart buy item") }
				end
			end
			@scene.pbEndBuyScene
		end
	end

	class Exchange_Scene < PokemonMart_Scene

		def pbRefresh
			if @subscene
				@subscene.pbRefresh
			else
				itemwindow = @sprites["itemwindow"]
				@sprites["icon"].item = itemwindow.item
				@sprites["itemtextwindow"].text = (itemwindow.item) ? @adapter.getDescription(itemwindow.item) : _INTL("Quit shopping.")
				itemwindow.refresh
			end
			points = $PokemonGlobal.athlon_sum_points ? $PokemonGlobal.athlon_sum_points.to_s_formatted : "0"
			@sprites["moneywindow"].text = _INTL("Points:\r\n<r>{1}", points)
		end

	end

end