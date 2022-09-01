module BlackJack
	class Play
		
		# Double
		def double(name)
			num = @player[name][:bet]
			return false if name==@mainplayer[:symbol] && ($Trainer.coins<=0 || $Trainer.coins-num<num)
			@player[name][:bet] += num
			self.distributeCard(name)
			self.drawCard(name, @player[name][:card].size-1)
			# Draw chips
			self.drawChips
			return true
		end

		# Insure
		def insure(name)
			return if (@player[:dealer][:card][0] / 4 != 0) || (name == :dealer)
			return if @player[name][:insurance][1]
			num = @player[name][:insurance][0] + @player[name][:bet]
			return if name==@mainplayer[:symbol] && ($Trainer.coins<=0 || $Trainer.coins<num)
			@player[name][:insurance][1] = true
			# Draw chips
			self.drawChips
			# Draw signal
			self.drawSignal
		end

		# AI
		def action
			# Dealer
			if @turn >= QuantityPlayer
				player = @player[:dealer]
				player[:status].size.times { |i|
					@player[:dealer][:status][i] = true
					self.drawCard(:dealer, i)
				}
				# Lost all
				if player[:sum] >= 28
					@player.each { |k,v|
						next if k==:dealer
						self.dealerOpen(k) # Open all players
						@player[k][:interest] += v[:bet]
					}
					@checkInfor = true # Show informations before finish
					return
				# Win Black jack (insurance)
				elsif player[:card].size == 2 && self.winBlackJack(player[:card],player[:sum])
					@player[:dealer][:blackjack] = true
					# Open cards of players
					@player.each { |k,v|
						next if k==:dealer || v[:name].nil?
						self.dealerOpen(k)
					}
				# Five cards
				elsif player[:card].size == 5 && self.winFiveCards(player[:card])
					@player[:dealer][:fivecards] = true
					# Open cards of players
					@player.each { |k,v|
						next if k==:dealer || v[:name].nil?
						self.dealerOpen(k)
					}
				end
				# Normal
				if player[:sum] < 15 && !player[:fivecards]
					self.distributeCard(:dealer, true)
					self.drawCard(:dealer, player[:card].size-1)
				else
					notopen = false if !notopen
					order = -1 if !order
					needopen = 0 if !needopen
					# Check cards
					@player.each { |k,v|
						next if k==:dealer
						order += 1
						if v[:name].nil? && !@opened[order]
							@opened[order] = true
							next
						end
						# Check if give up
						if v[:giveup] && !@opened[order]
							@history << "#{v[:name]} gave up!"
							@opened[order] = true
							next
						# Next if player lost
						elsif v[:lost] && !@opened[order]
							@history << "#{v[:name]} paid for his mistake!"
							@opened[order] = true
							next
						end
						# Open card
						if !player[:fivecards] && !player[:blackjack]
							next if @opened[order]
							case player[:sum]
							when 15
								# Open card
								if v[:card].size == 4
									random = rand(1000)
									if random < 500
										self.dealerOpen(k)
										@opened[order] = true
									end
								end
							when 16
								if v[:card].size > 2 && v[:card].size < 5
									random = rand(1000)
									if random < 600
										self.dealerOpen(k)
										@opened[order] = true
									end
								end
							when 17
								random = rand(1000)
								if (random < 500 && v[:card].size == 2) || (random < 600 && v[:card].size > 2 && v[:card].size < 5)
									self.dealerOpen(k)
									@opened[order] = true
								end
							when 18
								random = rand(1000)
								if random < 900
									self.dealerOpen(k)
									@opened[order] = true
								end
							else
								self.dealerOpen(k)
								@opened[order] = true
							end
							@opened[order] = true if v[:blackjack] || v[:fivecards]
							next if !@opened[order]
						end
						next if v[:name].nil?
						# Check insurance
						case self.blackjackDealer(k)
						when "nil"
							p "Error: check blackjack"
							Kernel.exit!
						when true
							@player[k][:interest] += v[:insurance][0]
						end
						# Store in history
						if v[:blackjack] || v[:fivecards]
							@history << "#{v[:name]} has five cards" if v[:fivecards]
							@history << "#{v[:name]} has blackjack" if v[:blackjack]
						else
							@history << "Dealer opened #{v[:name]}"
							@history << "Dealer: #{player[:sum]}"
							@history << "Player: #{v[:sum]}"
						end
						# Compare values
						case self.compareValue(k)
						when "nil"
							p "Error: compare"
							Kernel.exit!
						# Five cards, blackjack
						when "greater five", "greater blackjack"
							@player[k][:deficit] += v[:bet] * 2
							# Store in history
							@history << "With his five cards...Dealer won" if self.compareValue(k)=="greater five"
							@history << "With his blackjack...Dealer won" if self.compareValue(k)=="greater blackjack"
						when "less five", "less blackjack"
							@player[k][:interest] += v[:bet] * 2
							# Store in history
							@history << "With his five cards...Player won" if self.compareValue(k)=="less five"
							@history << "With his blackjack...Player won" if self.compareValue(k)=="less blackjack"
						# Normal case
						when "greater"
							@player[k][:deficit] += v[:bet]
							# Store in history
							@history << "With his numbers...Dealer won"
						when "less"
							@player[k][:interest] += v[:bet]
							# Store in history
							@history << "With his numbers...Player won"
						when "draw" then @history << "I can't believe...It's draw" # Store in history
						end
						@opened[order] = true if player[:fivecards] || player[:blackjack]
					}
					if !@opened.include?(false)
						@checkInfor = true # Show informations before finish
						return
					end
					# Continue distribute
					random = rand(1000)
					return unless (random < 500 && player[:sum] < 18) || (random < 50 && player[:sum] == 18)
					self.distributeCard(:dealer, true)
					self.drawCard(:dealer, player[:card].size-1)
				end
				return
			end
			# Player
			name = self.str2sym("player #{@turn}")
			if @player[name][:name].nil? || @player[name][:blackjack]
				@turn += 1
				return
			end
			if @player[name][:player]
				@playertime = true
				return
			end
			player = @player[name]
			case player[:card].size
			when 5 # Player has 5 cards
				self.drawFiveCcase(name)
				@player[name][:fivecards] = true if self.winFiveCards(player[:card])
				@turn += 1
				return
			when 2 # Insurance
				if (@player[:dealer][:card][0] / 4) == 0
					random = rand(1000)
					self.insure(name) if random<300
				end
			end
			# Hit or stand or give up or lost with decision of AI
			case self.canDistribute(player[:sum],player[:card].size==4)
			when "hit"
				self.distributeCard(name)
				self.drawCard(name, player[:card].size-1)
			# Player hits and bets double coin
			when "double"
				self.double(name)
			# Next turn, player stay here
			when "stand" then @turn += 1
			# Next turn, player give up
			when "give up"
				@player[name][:giveup] = true
				@player[name][:interest] += @player[name][:bet] / 2
				@player[name][:deficit] += @player[name][:bet] / 2
				self.dealerOpen(name)
				@turn += 1
			# Lost, player pays all players (include dealer)
			when "lost all"
				@player[name][:lost] = true
				self.payLostAll(name) # Pay coins
				self.dealerOpen(name) # open his cards
				@turn += 1
			end
		end

		# Return player choice
		def canDistribute(sum,fourcard=false)
			if sum < 16
				return "hit" # 'Force' hit
			elsif sum >= 28
				return "lost all" # Player must pay coin to all players with their chips value (except dealer, you must to pay your coin)
			end
			hadcard = 0
			case sum
			when 16
				card = [0,1,2,3,4]
				card.each { |i| hadcard += 1 if self.cardOpened(i) }
				per  = 1.0 / (card.size * 4.0) * 100
				rate = hadcard * per
				random = rand(1000)
				if (random<500 && rate < 30) || (fourcard && rate<4*per)
					return "double"
				elsif (random<600 && rate < 50) || (fourcard && rate<4*2*per)
					return "hit"
				else
					return "stand"
				end
			when 17
				card = [0,1,2,3]
				card.each { |i| hadcard += 1 if self.cardOpened(i) }
				per  = 1.0 / (card.size * 4.0) * 100
				rate = hadcard * per
				random = rand(1000)
				if (random<200 && rate < 20) || (fourcard && rate<per && random<100)
					return "double"
				elsif (random<400 && rate < 30) || (fourcard && rate<4*per && random<200)
					return "hit"
				else
					return "stand"
				end
			when 18
				card = [0,1,2]
				card.each { |i| hadcard += 1 if self.cardOpened(i) }
				per  = 1.0 / (card.size * 4.0) * 100
				rate = hadcard * per
				random = rand(1000)
				if (random<100 && rate<=per) || (fourcard && rate<2*per && random<30)
					return "hit"
				else
					return "stand"
				end
			when 19
				card = [0,1]
				card.each { |i| hadcard += 1 if self.cardOpened(i) }
				per  = 1.0 / (card.size * 4.0) * 100
				rate = hadcard * per
				random = rand(1000)
				if (random<50 && rate<per) || (fourcard && rate<per && random<10)
					return "hit"
				else
					return "stand"
				end
			when 20
				hadcard += 1 if self.cardOpened(0)
				per  = 1.0 / 4.0 * 100
				rate = hadcard * per
				random = rand(1000)
				if fourcard
					return "stand"
				elsif (random<10 && rate<per)
					return "hit"
				else
					return "stand"
				end
			when 21
				return "stand"
			else
				return "give up"
			end
		end

		# Check card opened, AI decide hit or stand
		def cardOpened(num=nil)
			return false if num.nil?
			card = []
			@player.each { |k,v|
				next if v[:name].nil?
				card << (v[:card][0] / 4)
			}
			return true if card.include?(num)
			return false
		end

		# Dealer opens cards of player
		def dealerOpen(name)
			return if name.nil?
			player = @player[name]
			return if name==:dealer || player[:name].nil?
			@player[name][:status].size.times { |i| 
				@player[name][:status][i] = true
				self.drawCard(name, i)
			}
		end

		# Compare value
		def compareValue(name)
			return "nil" if name.nil?
			player = @player[name]
			return "nil" if name==:dealer || player[:name].nil?
			dealer = @player[:dealer]
			# Dealer
			# Five cards
			if dealer[:fivecards]
				if dealer[:sum] <= 21 && ( (player[:fivecards] && player[:sum] < 21 && dealer[:sum] > player[:sum]) || !player[:fivecards] )
					return "greater five"
				elsif dealer[:sum] == player[:sum] || (player[:sum] > 21 && dealer[:sum] > 21)
					return "draw"
				elsif player[:fivecards] && player[:sum] <= 21 && ((player[:sum] > dealer[:sum]) || dealer[:sum] > 21)
					return "less five"
				end
				return "less"
			# Blackjack
			elsif dealer[:blackjack]
				return "draw" if player[:blackjack]
				return "less five" if player[:fivecards] && player[:sum] <= 21
				return "greater blackjack"
			# Normal
			elsif dealer[:sum] == player[:sum]
				return "draw"
			elsif dealer[:sum] <= 21
				if player[:fivecards] && player[:sum] <= 21
					return "less five"
				elsif player[:blackjack]
					return "less blackjack"
				elsif (dealer[:sum] > player[:sum] && player[:sum] < 21) || player[:sum] > 21
					return "greater"
				end
			elsif dealer[:sum] > 21
				player[:sum] > 21 ? (return "draw") : (return "less")
			end
			return "less"
		end

		# Check 
		def blackjackDealer(name)
			return "nil" if name.nil?
			player = @player[name]
			dealer = @player[:dealer]
			return true if player[:insurance][1] && dealer[:blackjack]
			return false
		end

		# Player get coins after playing
		def playerGet
			player = @player[@mainplayer[:symbol]]
			$Trainer.coins += player[:interest] - player[:deficit]
			$Trainer.coins -= player[:bet] / 2 if player[:giveup]
		end

	end
end