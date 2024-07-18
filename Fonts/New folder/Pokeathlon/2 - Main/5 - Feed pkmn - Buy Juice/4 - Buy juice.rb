module Pokeathlon
	# Set price when you buy. In case, player isn't set event
	PRICE_APRIJUICE = 1000
	# Set mildness to calculate when player buy aprijuice.
	# In case, player isn't set event
	MILDNESS_BUY = 255

	def self.buy_juice(arr=nil, price=0, buynumber=0)
		mess = "What do you want to do?"
		cmd  = pbMessage(mess,[_INTL("Buy"),_INTL("Cancel")], 2) == 0
		unless cmd
			pbMessage("See Ya!")
			return
		end
		mess = "Coins or Money?"
		cmd2 = pbMessage(mess,[_INTL("Coins"),_INTL("Money")], 2)
		# Fake
		fp = price == 0 ? PRICE_APRIJUICE : price
		case cmd2
		when 0
			if $player.coins - fp < 0
				pbMessage("You don't have enough coins!")
				return
			end
			$player.coins -= fp
		when 1
			if $player.money - fp < 0
				pbMessage("You don't have enough money!")
				return
			end
			$player.money -= fp
		end
		ret = Pokeathlon.chose_not_condition
		if ret < 0
			pbMessage("Oh! You don't want to feed!")
			val = cmd2 == 0 ? "coins" : "money"
			pbMessage("Here! Your #{val}!")
			case cmd2
			when 0 then $player.coins += fp
			when 1 then $player.money += fp
			end
			return
		end
		if arr
			arr1 = Pokeathlon.calc_flavor_marchand(arr)
		else
			mess = "What aprijuice you want?"
			arr  = ["Power", "Stamina", "Skill", "Jump", "Speed", "Cancel"]
			cmd3 = pbMessage(mess, arr, arr.size)
			if cmd3 == arr.size - 1
				pbMessage("See Ya!")
				return
			end
			arr1 = [0, 0, 0, 0, 0]
			arr1[cmd3] = 80
			arr1 = Pokeathlon.calc_flavor_marchand(arr1)
		end
		pbMessage("Here! Your aprijuice!")
		buynumber = MILDNESS_BUY if buynumber == 0
		buynumber = 0 if buynumber < 0
		buynumber = 255 if buynumber > 255
		Pokeathlon.feed_juice_feed($player.party[ret], ret) {
			$player.party[ret].athlon_feed_juice = false
			$player.party[ret].athlon_daily, $player.party[ret].athlon_change = Pokeathlon.calc_flavor_all($player.party[ret], arr1, true, buynumber)
			$player.party[ret].athlon_normal_changed = Pokeathlon.real_stats($player.party[ret])
			# Set feed
			$player.party[ret].athlon_feed_juice = true
		}
		pbMessage("Thank you! See Ya!")
	end

end