module BlackJack
	class Play

		# Play and check condition when play again
		def play
			if @nameai.size<=0 || !@nameai.is_a?(Array)
				p "Check NameAI, it is array and its size is greater than 0"
				Kernel.exit!
			end
			loop do
				# Update
				self.update_ingame
				# Play
				self.progress
				if @finish
					self.playerGet
					break
				end
			end
		end

		# Set card, play and wait
		def progress
			# Create scene
			self.create_scene
			# Set player, dealer, bet
			self.setPlayer
			# Bet coin before play
			self.bet
			# Coin
			self.drawChips
			# Distribute
			self.distribute
			# Players distribute cards
			self.playerPlay
			# Check information
			self.finish
		end

		# Player, AI and dealer distribute cards
		def playerPlay
			loop do
				# Update
				self.update_ingame
				# Action (AI)
				self.action
				# Draw signal
				self.drawSignal
				# Player bet
				self.playerBet
				break if @checkInfor
			end
		end

		# Finish, game over
		def finish
			# Draw rectangle "exit"
			self.drawExit
			# Draw rectangle "history"
			self.drawHistory
			# Draw information
			self.drawTextFinish
			loop do
				# Update
				self.update_ingame
				# Clear chips
				self.drawChips(true)
				# Draw information again, if anyone need it
				self.checkInforFinish
				break if @finish
			end
		end

	end
end