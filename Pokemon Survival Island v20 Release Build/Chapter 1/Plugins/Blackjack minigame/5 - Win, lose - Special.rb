module BlackJack
	class Play
		
		# Win (Blackjack)
		def winBlackJack(cards,sum)
			return if cards.size!=2
			ace = 0 if !ace
			cards.each { |j| ace += 1 if j/4 == 0 }
			return true if (ace==1 && sum==21) || ace==2
			return false
		end

		# Win (five cards)
		def winFiveCards(cards)
			return false if !cards.is_a?(Array)
			return false if cards.size < 5
			return false if self.calcSPerCard(cards) > 21
			return true
		end

		# Lose (lost all)
		def payLostAll(name)
			money = 0
			@player.each { |k,v|
				next if k==:dealer
				if k==name
					money += v[:bet]
					next
				end
				money += v[:bet]
				@player[k][:interest] += v[:bet]
			}
			@player[name][:deficit] += money
		end

	end
end