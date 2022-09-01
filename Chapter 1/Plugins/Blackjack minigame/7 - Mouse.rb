module BlackJack
	class Play

		# Check delay
		def delayMouse(num=5)
			m = self.posMouse
			@delay += 1
			@delay  = 0 if @oldm!=m && @delay>num
			return true if @delay<num
			@oldm = m
			return false
		end
		# Position of rectangle 'Bet'
		# Single area
		def posBetArea(pos)
			x = 34 + pos * 122
			y = 222
			w = 66
			h = 45
			return [x, y, w, h]
		end
		# All areas
		def posAllBet
			pos = []
			QuantityPlayer.times { |i| pos << self.posBetArea(i) }
			return pos
		end
		# Bet
		def rectBet
			QuantityPlayer.times { |i| return i if areaMouse?(self.posAllBet[i]) }
			return nil
		end
		# Position of rectangle 'Card'
		# Player
		def posCardPlayer(pos,quant=0)
			x = 12 + pos * 122
			y = 132
			w = 50 + 15 * quant
			h = 80
			return [x, y, w, h]
		end
		# Dealer
		def posCardDealer(quant=0)
			x = (Graphics.width - 110) / 2
			y = 32
			w = 50 + 15 * quant
			h = 80
			return [x, y, w, h]
		end
		# Determine
		def rectCard
			return -1 if areaMouse?(self.posCardDealer(@player[:dealer][:card].size-1))
			QuantityPlayer.times { |i|
				sym = self.str2sym("player #{i}")
				if areaMouse?(self.posCardPlayer(i,@player[sym][:card].size-1))
					return nil if @player[sym][:name].nil?
					return -2  if @player[sym][:player]
					return i
				end
			}
			return nil
		end
		# Position when choosing chip
		# Single
		def posChipChoose(pos)
			x = 45 + 7 + pos*(16 + 7 + 60)
			y = 337
			r = 8
			return [x, y, r]
		end
		# All
		def posAllChipChoose
			pos = []
			6.times { |i| pos << self.posChipChoose(i) }
			return pos
		end
		# Determine
		def circleChip
			6.times { |i| return i if circleMouse?(self.posAllChipChoose[i]) }
			return nil
		end
		# Rectangle 'Ok' when betting, [x, y, w, h]
		# You don't need to set w and h, it will set with your graphic
		RectOkBet = [ 432, 290, 0, 0 ]
		# Size of bitmap "Message Box"
		# If you don't change this bitmap, don't change it
		# You need to know how to determine and write. If not, please, don't touch it
		# [w,h]
		RectMessBox = [
			# Left, Right
			[4,4], # Top
			[4,2], # Mid
			[4,4], # Bottom
			# Middle
			[2,4], # Top
			[2,2], # Mid
			[2,4]  # Bot
		]
		# Signal [w,h]
		# Icon of lost all has this form [w*2,h]
		RectSignal = [33,14]
		# Rectangle exit, [x, y]
		# Use graphic "Choice", find 'def drawExit' for changing bitmap
		RectExit = [0, 0]
		# Rectangle Arrow, [x,y]
		RectArrow = [
			[400,87], # Up
			[400,87+100+10]  # Down
		]
		
	end
end