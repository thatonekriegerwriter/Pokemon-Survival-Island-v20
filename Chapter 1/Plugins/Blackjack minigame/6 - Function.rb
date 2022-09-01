module BlackJack
	class Play
		
		# Set name, position of card, position of player, number of cards, cards, bet
		def setStruct(name)
			@player[name] = {
				:name => nil, # Set name of player
				:position => [nil,nil,5], # Set position of card (x, y, z) - z = 5 or higher
				:player => false, # Set position of player
				:card => [], # Cards
				:status => [], # Status of card (open or not)
				:sum => 0, # Number of card (value)
				:bet => 0, # Coin
				# For checking coin when finish (interest or deficit)
				:interest => 0,
				:deficit  => 0,
				:blackjack => false, # Check blackjack
				:fivecards => false, # Check player reaches 5 cards (5 cards <= 21 points), it's bigger than black jack
				:insurance => [0,false], # Bet (insurance)
				:giveup => false, # Player give up (don't want to play)
				:lost => false # Check if player has score greater than or equal to 28, he lose and pays all players (include dealer) for his mistake
			}
		end
		# Set symbol, string
		def sym2str(sym)
			return sym.to_s
		end
		def str2sym(str)
			return str.to_sym
		end
		# Set total chips, player can bet
		def totalBet(sum=false,coins=nil)
			total = 0
			coins = $Trainer.coins if coins.nil?
			# Value each chip
			value = []
			# ValueChips[0], ValueChips[1], etc
			ValueChips.size.times { |i| value << 0 }
			ValueChips.size.times { |i|
				j = ValueChips.size-(i+1)
				if coins / ValueChips[j] > 0
					num = coins / ValueChips[j] * ValueChips[j]
					total += num
					value[j] = coins / ValueChips[j]
					coins -= num
				end
			}
			return total if sum
			return value
		end
		# Calculate scores
		def calcSPerCard(values)
			if !values.is_a?(Array)
				p "Check value for calculating. It must be Array."
				Kernel.exit!
			end
			result   = 0 if !result
			countace = 0 if !countace
			values.each { |value|
				case value / 4
				# Ace
				when 0
					countace += 1
					result   += 11
				# J, Q, K
				when 10, 11, 12; result += 10
				# 2, 3, 4, 5, 6, 7, 8, 9, 10
				else; result += value / 4 + 1
				end
			}
			return 21 if countace==2 && values.size==2
			result -= countace * 10 if result > 21
			return result
		end

	end
end