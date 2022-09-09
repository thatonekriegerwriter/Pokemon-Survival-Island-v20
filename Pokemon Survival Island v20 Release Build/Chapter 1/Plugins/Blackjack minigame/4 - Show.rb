module BlackJack
	class Play

		# Create scene
		def create_scene
			# Background
			addBackgroundPlane(@sprites,"bg","BlackJack/Background",@viewport) if !@sprites["bg"]
			# Draw message box
			3.times { |i|
				@sprites["left mess #{i}"] = BitmapWrapper.new(Graphics.width,Graphics.height) if !@sprites["left mess #{i}"]
				@sprites["mid mess #{i}"] = BitmapWrapper.new(Graphics.width,Graphics.height) if !@sprites["mid mess #{i}"]
				@sprites["right mess #{i}"] = BitmapWrapper.new(Graphics.width,Graphics.height) if !@sprites["right mess #{i}"]
			}
			@sprites["mess"] = AnimatedBitmap.new("Graphics/Pictures/BlackJack/Message Box").deanimate if !@sprites["mess"]
			@sprites["signal"] = AnimatedBitmap.new("Graphics/Pictures/BlackJack/Signal").deanimate if !@sprites["signal"]
			# Draw text in the bottom
			self.create_sprite_2("text",@viewport) if !@sprites["text"]
			@sprites["text"].z = 40
			self.clearTxt("text")
		end

		# Set position of player
		def setPlayer
			# Dealer
			self.setStruct(:dealer)
			@player[:dealer][:name] = "Dealer"
			@player[:dealer][:position][0] = self.posCardDealer[0]
			@player[:dealer][:position][1] = self.posCardDealer[1]
			# Player
			QuantityPlayer.times { |i|
				sym = self.str2sym("player #{i}")
				self.setStruct(sym)
				@player[sym][:position][0] = self.posAllBet[i][0]
				@player[sym][:position][1] = self.posAllBet[i][1]
			}
			bitmap = @sprites["text"].bitmap
			text = []
			string = "Choose your position"
			x = Graphics.width / 2 
			y = 337
			text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			drawTxt("text",text,nil,40,1,false,1)
			# Create 'choose text'
			self.create_sprite_2("choose text",@viewport) if !@sprites["choose text"]
			@sprites["choose text"].z = 1
			self.clearTxt("choose text")
			# Check position of player
			quantpos = []
			QuantityPlayer.times { |i| quantpos << false }
			pos = nil
			# Player chooses position
			loop do
				# Update
				self.update_ingame
				# Mouse
				# Delay mouse
				self.delayMouse(DelayMouse)
				pos = self.rectBet if @delay>DelayMouse
				text = []
				QuantityPlayer.times { |i|
					string = !pos.nil? && pos==i ? "Choose" : "#{i+1}"
					arr = self.posBetArea(i)
					x = arr[0] + arr[2] / 2
					y = arr[1] + arr[3] / 2
					text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
				}
				drawTxt("choose text",text,nil,nil,1,false,2)
				if self.clickedMouse?
					if !pos.nil?
						sym = self.str2sym("player #{pos}")
						@player[sym][:name] = $Trainer.name
						@player[sym][:player] = true
						positioncard = self.posCardPlayer(pos)
						@player[sym][:position][0] = positioncard[0]
						@player[sym][:position][1] = positioncard[1]
						quantpos[pos] = true
						create_sprite("chose Rect","Chose",@viewport) if !@sprites["chose Rect"]
						set_xy_sprite("chose Rect",self.posAllBet[pos][0],self.posAllBet[pos][1])
						# Store in @mainplayer
						@mainplayer = {
							:position => pos,
							:symbol => sym
						}
						break
					end
				end
			end
			self.clearTxt("choose text")
			# Set player 'virtual'
			quantity = rand(QuantityPlayer)
			return if quantity <= 0
			num = nil
			quantity.times { |i|
				loop do
					num = rand(QuantityPlayer)
					break if !quantpos[num]
				end
				sym = self.str2sym("player #{num}")
				randname = rand(@nameai.size)
				@player[sym][:name] = @nameai[randname]
				@nameai.delete_at(randname) if @nameai.size>1
				positioncard = self.posCardPlayer(num)
				@player[sym][:position][0] = positioncard[0]
				@player[sym][:position][1] = positioncard[1]
				quantpos[num] = true
			}
		end

		# Bet
		def bet
			# Create bitmap All - in
			@sprites["coin"] = AnimatedBitmap.new("Graphics/Pictures/BlackJack/Chip").deanimate if !@sprites["coin"]
      if !@sprites["red chip"]
        create_sprite_2("red chip",@viewport)
        bm = @sprites["red chip"].bitmap
				r = 8
				(0..2*r).each { |i| 
					(0..2*r).each { |j|
						equation = (i-r)**2 + (j-r)**2
						next if equation>(r**2)
						bm.fill_rect( i, j, 1, 1, Color.new( 239, 37, 37) ) 
					} 
				}
        @sprites["red chip"].visible = false
			end
			if !@sprites["green chip"]
				create_sprite_2("green chip",@viewport)
				bm = @sprites["green chip"].bitmap
				r = 8
				(0..2*r).each { |i| 
					(0..2*r).each { |j|
						equation = (i-r)**2 + (j-r)**2
						next if equation>(r**2)
						bm.fill_rect( i, j, 1, 1, Color.new( 48, 213, 118) ) 
					} 
				}
				@sprites["green chip"].visible = false
      end
			# Draw text 'Bet'
			self.drawTxtBet
			# Draw coin
			self.drawNumBet
			# Value for draw
			draw = false
			newtext = nil
			# Check when you have surplus, bet = 0
			redraw = nil
			# Set for checking position
			circle = nil # Circle 'bet'
			rectok = false # Rectangle 'Ok'
			# Set for break
			ext = false
			# Player bets
			loop do
				# Update
				self.update_ingame
				break if ext
				if draw
					drawTxtBet(newtext)
					draw = false
					newtext = nil
				elsif !redraw.nil?
					redraw-=1
					if redraw<=0
						drawTxtBet(newtext)
						redraw = nil
					end
				end
				# Delay
				self.delayMouse(DelayMouse)
				# Click
				if @delay>DelayMouse
					circle = self.circleChip
					rectok = areaMouse?(RectOkBet) ? true : false
					self.drawNumBet(circle,rectok)
				end
				if self.clickedMouse?
					if !circle.nil?
						@player.each { |k,v|
							next if !v[:player]
							if circle!=5
								if (v[:bet] + ValueChips[circle]) > self.totalBet(true)
									newtext = "You can't bet anymore!!!"
									redraw  = 25
								else
									@player[k][:bet] += ValueChips[circle]
								end
							else
								@player[k][:bet] = self.totalBet(true)
							end
							draw = true
							break
						}
					elsif rectok
						if @player[@mainplayer[:symbol]][:bet]==0
							draw = true
							newtext = "You need to bet!!!"
							redraw = 25
						else
							@player[@mainplayer[:symbol]][:insurance][0] = @player[@mainplayer[:symbol]][:bet] / 2
							ext = true
						end
					end
				end
			end
			# AI bet
			@player.each { |k,v|
				next if v[:name].nil? || v[:player] || k==:dealer
				num = rand(6)
				(num+1).times {
					pos = rand(ValueChips.size)
					@player[k][:bet] += ValueChips[pos]
				}
				@player[k][:insurance][0] = v[:bet] / 2
			}
			# Dispose sprite
			self.dispose("red chip") if @sprites["red chip"]
			self.dispose("green chip") if @sprites["green chip"]
			self.dispose("rect ok") if @sprites["rect ok"]
			self.dispose("coin") if @sprites["coin"]
			# Clear text
			self.clearTxt("text")
			self.clearTxt("choose text")
		end

		# Draw text when bet
		def drawTxtBet(newtext=nil,showbet=true)
			self.clearTxt("text")
			return if !newtext && !showbet
			# Draw text
			text = []
			sym = @mainplayer[:symbol]
			if showbet
				string = "Bet: #{@player[sym][:bet]}"
				x = Graphics.width / 2
				y = 320
				text << [ string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0) ]
			end
			if newtext
				# Draw bitmap
				bitmap = @sprites["text"].bitmap
				self.drawMess(bitmap,newtext)
				# Draw text
				x = Graphics.width / 2
				y = Graphics.height / 2
				text << [ newtext, x, y, 0, Color.new(0,0,0), Color.new(255,255,255) ]
			end
			self.drawTxt("text",text,nil,nil,1,false,2,false,false)
		end

		# Set sprite Message
		def setSizeMess(*arg)
			name, origin, rnew, rold = arg
			return if !rnew.is_a?(Array) || !rold.is_a?(Array) 
			return if rnew.size<4 || rold.size < 4 
			return if !@sprites["#{name}"] || !@sprites["#{origin}"]
			@sprites["#{name}"].stretch_blt(
				Rect.new(rnew[0],rnew[1],rnew[2],rnew[3]),
				@sprites["#{origin}"],
				Rect.new(rold[0],rold[1],rold[2],rold[3])
			)
		end

		# Draw blt Message
		def drawBltMess(*arg)
			bitmap, x, y, sprite, rnew = arg
			return if !rnew.is_a?(Array)
			return if rnew.size < 4
			bitmap.blt(x, y, sprite, Rect.new(rnew[0],rnew[1],rnew[2],rnew[3]))
		end

		# Draw box of message
		def drawMess(bitmap,text=nil,wmax=nil,hmax=nil)
			return if bitmap.nil?
			wmax = (Graphics.width - bitmap.text_size(text).width) / 2   if !wmax
			hmax = Graphics.height / 2 - bitmap.text_size(text).height + 5 if !hmax
			suml = summ = sumr = sumh = 0
			rnewl = rnewm = rnewr = []
			4.times {
				rnewl << 0
				rnewm << 0
				rnewr << 0
			}
			3.times { |i|
				# Left, Right
				wl = RectMessBox[i][0]
				hl = RectMessBox[i][1]
				suml += RectMessBox[i-1][1] if i!=0
				# Middle
				wm = RectMessBox[i+3][0]
				hm = RectMessBox[i+3][1]
				summ += RectMessBox[i+3-1][1] if i!=0
				# Set
				if i==1 # Middle
					# Left
					rnewl = [0, 0, wl*2, bitmap.text_size(text).height]
					# Middle
					rnewm = [0, 0, bitmap.text_size(text).width, bitmap.text_size(text).height]
					# Right
					rnewr = [0, 0, wl*2, bitmap.text_size(text).height]
				else # Left, Right
					# Left
					rnewl = [0, 0, wl*2, hl*2]
					# Middle
					rnewm = [0, 0, bitmap.text_size(text).width, hl*2]
					# Right
					rnewr = [0, 0, wl*2, hl*2]
				end
				# Left
				roldl = [0, suml, wl, hl]
				# Middle
				roldm = [wl, summ, wm, hm]
				# Right
				roldr = [wl+wm, suml, wl, hl]
				# Set sprite
				self.setSizeMess("left mess #{i}", "mess", rnewl, roldl)
				self.setSizeMess("mid mess #{i}", "mess", rnewm, roldm)
				self.setSizeMess("right mess #{i}", "mess", rnewr, roldr)
				# Draw bitmap
				sumh += (i==1 ? hl*2 : bitmap.text_size(text).height) if i!=0
				x = wmax - wl*2
				y = hmax + sumh
				self.drawBltMess(bitmap, x, y, @sprites["left mess #{i}"], rnewl)
				x += rnewl[2]
				self.drawBltMess(bitmap, x, y, @sprites["mid mess #{i}"], rnewm)
				x += rnewm[2]
				self.drawBltMess(bitmap, x, y, @sprites["right mess #{i}"], rnewr)
			}
		end

		# Draw number for bet (first time)
		def drawNumBet(chip=nil,accept=false)
			text = []
			bitmap = @sprites["choose text"].bitmap
			6.times { |i|
				pos = self.posChipChoose(i)
				string = i!=5 ? "#{ValueChips[i]}" : "All-in"
				text << [ string, pos[0], pos[1], 0, Color.new(255,255,255), Color.new(0,0,0) ]
			}
			drawTxt("choose text",text,nil,nil,1,false,1,true)
			# Draw chip
			r = posChipChoose(0)[2]
			d = 2*r
			6.times { |i|
				pos = self.posChipChoose(i)

				if i!=5
					rect = chip==i ? Rect.new(d*i, d, d, d) : Rect.new(d*i, 0, d, d)
					bitmap.blt( pos[0], pos[1], @sprites["coin"], rect )
				# All - in
				else
					bm = chip==i ? @sprites["green chip"].bitmap : @sprites["red chip"].bitmap
					bitmap.blt( pos[0], pos[1], bm, Rect.new(0, 0, d, d) )
				end
			}
			if !@sprites["rect ok"]
				self.create_sprite("rect ok","Ok",@viewport)
				w = @sprites["rect ok"].bitmap.width
				h = @sprites["rect ok"].bitmap.height
				x = RectOkBet[0]
				y = RectOkBet[1]
				RectOkBet.replace([x, y, w, h])
				set_xy_sprite("rect ok", x, y)
			end
			# 'Ok'
			text2 = []
			string = accept ? "Click" : "Ok"
			x = RectOkBet[0] + RectOkBet[2] / 2
			y = RectOkBet[1] + RectOkBet[3] / 2
			text2 << [ string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0) ]
			self.drawTxt("choose text",text2,nil,nil,1,false,2,false,false)
		end

		# Progress distribute
		def distribute
			2.times {
				@player.each { |k,v|
					next if v[:name].nil?
					self.distributeCard(k, v[:status].size==0)
					self.drawCard(k, v[:card].size-1)
				}
			}
			# Check blackjack for player
			@player.each { |k,v|
				next if v[:name].nil?
				next if !self.winBlackJack(v[:card],v[:sum])
				@player[k][:blackjack] = true
				next if k==:dealer
				self.redrawCard(k)
			}
		end

		# Distribute card
		def distributeCard(name,status=false)
			random = rand(@card.size)
			@player[name][:card] << @card[random]
			@card.delete_at(random)
			@player[name][:status] << status
			@player[name][:sum] = self.calcSPerCard(@player[name][:card])
		end

		# Draw new card
		def drawCard(*arr)
			return if !arr.is_a?(Array) || arr.size < 2
			name, position = arr
			return if !name.is_a?(Symbol) && !name.is_a?(String)
			name = self.str2sym(name) if name.is_a?(String)
			namesprite = "#{name} #{position}"
			if @sprites["#{namesprite}"]
				self.dispose("#{namesprite}")
				@sprites["#{namesprite}"] = nil
			end
			create_sprite(namesprite, "Card", @viewport)
			# Position of this card
			card = @player[name][:position]
			# Open
			if @player[name][:status][position]
				w = self.posCardPlayer(0)[2]
				h = self.posCardPlayer(0)[3]
				set_src_wh_sprite(namesprite, w, h)
				x = @player[name][:card][position] % 4 * w
				y = @player[name][:card][position] / 4 * h
				set_src_xy_sprite(namesprite, x, y)
			# Closed
			else
				@sprites["#{namesprite}"].bitmap = Bitmap.new("Graphics/Pictures/BlackJack/Behind")
			end
			@sprites["#{namesprite}"].z = card[2] + (@player[name][:status][position] ?  position : -position) 
			set_xy_sprite(namesprite, card[0] + position*15, card[1])
		end

		# Draw card (Opened)
		def redrawCard(name)
			@player[name][:card].size.times { |i|
				@player[name][:status][i] = true
				self.drawCard(name, i)
			}
		end

		# Draw chips of player
		def drawChips(invisible=false)
			QuantityPlayer.times { |i|
				sym = self.str2sym("player #{i}")
				next if @player[sym][:name].nil?
				value = self.totalBet(false,@player[sym][:bet])
				value.size.times { |j|
					namesprite = "#{sym} pos #{j} chip"
					if value[j]<=0
						set_visible_sprite(namesprite) if @sprites["#{namesprite}"]
						next
					end
					create_sprite(namesprite, "Chip", @viewport) if !@sprites["#{namesprite}"]
					set_visible_sprite(namesprite,!invisible)
					area = self.posBetArea(i)
					chip = self.posChipChoose(j)
					r = chip[2]
					set_src_wh_sprite(namesprite, 2*r, 2*r)
					x = j * 2 * r
					y = 0
					set_src_xy_sprite(namesprite, x, y)
					x = area[0] + 4 + (2*r + 5) * (j==0 ? 0 : (j==1 || j==2)? 1 : 2)
					y = area[1] + (j==0 ? area[3]/2-r : (5 + (j%2==1 ? 0 : 3+2*r )) )
					set_xy_sprite(namesprite, x, y)
				}
			}
		end

		# Draw information of player or dealer
		def drawInfor(position,finish=false)
			return if position.nil?
			if !@sprites["bg infor"]
				self.create_sprite("bg infor","Information",@viewport)
				@sprites["bg infor"].z = 50
			end
			if !@sprites["text infor"]
				self.create_sprite_2("text infor", @viewport)
				@sprites["text infor"].z = 50
			end
			self.clearTxt("text infor")
			bitmap = @sprites["text infor"].bitmap
			# Draw card
			position = @mainplayer[:position] if position==-2
			sym = position==-1 ? :dealer : self.str2sym("player #{position}")
			# Check player card (not your)
			allopen = true if !allopen
			@player[sym][:card].size.times { |i|
				namesprite = "card infor #{i}"
				self.create_sprite(namesprite,"card",@viewport) if !@sprites[namesprite]
				# Open
				if (@player[sym][:status][i] && !@player[sym][:player]) || @player[sym][:player]
					w = self.posCardPlayer(0)[2]
					h = self.posCardPlayer(0)[3]
					self.set_src_wh_sprite(namesprite, w, h)
					x = @player[sym][:card][i] % 4 * w
					y = @player[sym][:card][i] / 4 * h
					self.set_src_xy_sprite(namesprite, x, y)
				# Closed
				else
					allopen = false
					@sprites["#{namesprite}"].bitmap = Bitmap.new("Graphics/Pictures/BlackJack/Behind")
				end
				x = (Graphics.width - self.posCardPlayer(0)[2] * @player[sym][:card].size) / (@player[sym][:card].size + 1) * (i+1) + self.posCardPlayer(0)[2] * i
				y = (Graphics.height - self.posCardPlayer(0)[3]) / 2
				self.set_xy_sprite(namesprite, x, y)
				@sprites["#{namesprite}"].z = 100
			}
			# Text
			text = []
			if sym!=:dealer
				string = "Bet: #{@player[sym][:bet]}"
				if finish
					if (@player[sym][:interest] - @player[sym][:deficit]) > 0
						string += "| Wow! Your interest is #{@player[sym][:interest] - @player[sym][:deficit]} coins"
					elsif (@player[sym][:deficit] - @player[sym][:interest]) > 0
						string += "| Hmm! Your deficit is #{@player[sym][:deficit] - @player[sym][:interest]} coins"
					else
						string += "| You don't have interest"
					end
				end
				x = Graphics.width / 2
				y = 100
				text << [ string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)  ]
				if @player[sym][:giveup]
					string = "You gave up! Try it next time!"
					text << [ string, x, y+35, 0, Color.new(0,0,0), Color.new(255,255,255)  ]
				end
			end
			string = "Name: #{@player[sym][:name]}"
			x = Graphics.width  / 2
			y = Graphics.height - 100
			text << [ string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255) ]
			if allopen
				string = "Score: #{@player[sym][:sum]}"
				string += "| You got blackjack! Congratulation!" if @player[sym][:blackjack]
				x = Graphics.width  / 2
				y = Graphics.height - 65
				text << [ string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255) ]
			end
			# Draw text
			drawTxt("text infor",text,nil,30,1,false,2,false)
			# Draw signal (bitmap)
			bitmap = @sprites["text infor"].bitmap
			x = 20
			y = 20
			w = RectSignal[0]
			h = RectSignal[1]
			bitmap.blt(x, y, @sprites["signal"], Rect.new(0, 0, w, h)) if @player[sym][:insurance][1]
			if @player[sym][:fivecards]
				y += 14 + 10 if @player[sym][:insurance][1]
				bitmap.blt(x, y, @sprites["signal"], Rect.new(w, 0, w, h))
			end
			if @player[sym][:lost]
				y += 14 + 10 if @player[sym][:insurance][1]
				y += 14 + 10 if @player[sym][:fivecards]
				bitmap.blt(x, y, @sprites["signal"], Rect.new(0, h, w*2, h))
			end
		end

		def clearInfor
			self.dispose("text infor") if @sprites["text infor"]
			self.dispose("bg infor") if @sprites["bg infor"]
			5.times { |i|
				next if !@sprites["card infor #{i}"]
				self.dispose("card infor #{i}")
			}
			self.dispose("card not open") if @sprites["card not open"]
		end

		# Click for showing information (when player playing)
		def clickInfor
			# Delay mouse (action)
			card = self.rectCard if @delay>DelayMouse
			# Click
			if self.clickedMouse?
				# Clear information if player seeing it
				if @information
					@information = false
					self.clearInfor
				else
					# Draw information
					if !card.nil?
						@information = true
						self.drawInfor(card)
					end
				end
			end
		end

		# Create rectangle for choosing
		def createRectforChoice
			return if @createdchoice
			# Array stores choice
			name1 = ["Hit", "Stand"]
			name2 = ["Double", "Give Up", "Insure"]
			if !@sprites["choice form"]
				self.create_sprite("choice form","Choice",@viewport)
				self.set_visible_sprite("choice form")
			end
			self.create_sprite_2("bitmap choice",@viewport) if !@sprites["bitmap choice"]
			bitmap = @sprites["bitmap choice"].bitmap
			self.clearTxt("bitmap choice")
			# Set width, height
			w = @sprites["choice form"].bitmap.width
			h = @sprites["choice form"].bitmap.height / 2
			# Set quantity
			quant = @sprites["choice form"].bitmap.width < 80 ? (name1.size + name2.size) : [name1.size + 1, name2.size + 1]
			# Draw rectangle
			storesrc = []
			q = (quant.is_a?(Array) ? quant[0] : quant)
			q.times { |i|
				dist = (Graphics.width - q * w) / (q + 1)
				x = dist + (dist + w) * i
				y = Graphics.height - (15 + h)
				src = [x, y, w, h]
				storesrc << src
				rect = Rect.new(0, 0, w, h)
				bitmap.blt( x, y, @sprites["choice form"].bitmap, rect )
			}
			# Store in @choice
			if quant.is_a?(Array)
				storesrc = []
				quant.size.times { |i|
					clone = []
					quant[i].times { |j|
						dist = (Graphics.width - quant[i] * w) / (quant[i] + 1)
						x = dist + (dist + w) * j
						y = Graphics.height - (15 + h)
						clone << [x, y, w, h]
					}
					storesrc << clone
				}
			end
			@choice = {
				:name1 => name1,
				:name2 => name2,
				:quantity => quant,
				:page => 0, # Store page if quant is Array, start at 0
				:rect => storesrc # Store rectangle of each value
			}
			@createdchoice = true
		end

		# Check mouse for rectangle 'Choice'
		def rectChoice
			q = @choice[:quantity].is_a?(Array) ? @choice[:quantity][@choice[:page]] : @choice[:quantity]
			q.times { |i| return i if areaMouse?(@choice[:quantity].is_a?(Array) ? @choice[:rect][@choice[:page]][i] : @choice[:rect][i]) }
			return nil
		end

		# Recreate rectangle for choosing (if graphics has width greater than or equal to 80)
		def recreateRectforChoice(chose=nil)
			bitmap = @sprites["bitmap choice"].bitmap
			self.clearTxt("bitmap choice")
			w = @sprites["choice form"].bitmap.width
			h = @sprites["choice form"].bitmap.height / 2
			q = @choice[:quantity].is_a?(Array) ? @choice[:quantity][@choice[:page]] : @choice[:quantity]
			q.times { |i|
				dist = (Graphics.width - q * w) / (q + 1)
				x = dist + (dist + w) * i
				y = Graphics.height - (15 + h)
				rect = Rect.new(0, (chose==i ? h : 0), w, h)
				bitmap.blt( x, y, @sprites["choice form"].bitmap, rect )
			}
		end

		# Draw choose for betting (player's turn)
		def drawBetPlaying
			q = @choice[:quantity].is_a?(Array) ? @choice[:quantity][@choice[:page]] : @choice[:quantity]
			string = @choice[:quantity].is_a?(Array) ? ( @choice[:page]==0 ? @choice[:name1] << "Next page" : @choice[:name2].unshift("Prev page") ) : @choice[:name1].concat(@choice[:name2])
			rect = @choice[:quantity].is_a?(Array) ? @choice[:rect][@choice[:page]] : @choice[:rect]
			text = []
			q.times { |i| text << [string[i], rect[i][0]+rect[i][2]/2, rect[i][1]+rect[i][3]/2, 0, Color.new(0,0,0), Color.new(255,255,255) ] }
			drawTxt("choose text",text,nil,nil,1,false,2)
			return if !@choice[:quantity].is_a?(Array)
			@choice[:name1].delete("Next page") if @choice[:name1].include?("Next page")
			@choice[:name2].delete("Prev page") if @choice[:name2].include?("Prev page")
		end

		# Clear choose
		def clearBetPlaying
			self.clearTxt("bitmap choice") if @sprites["bitmap choice"]
			self.clearTxt("text")
			self.clearTxt("choose text")
			self.dispose("choice form") if @sprites["choice form"]
		end

		# Draw card when player has 5 cards
		def drawFiveCcase(name)
			5.times { |i|
				@player[name][:status][i] = true
				self.drawCard(name, i)
			}
		end

		def playerBet
			@playertime = @turn==@mainplayer[:position]
			if !@playertime
				self.clearBetPlaying
				return
			end
			# Create rectangle for choice
			self.createRectforChoice
			# Draw name of box
			self.drawBetPlaying
			# Set value
			redraw = 0
			newtext = nil
			loop do
				# Update
				self.update_ingame
				# Break
				if !@playertime
					self.clearBetPlaying
					# Next turn
					@turn += 1
					break
				end
				# Delay mouse
				self.delayMouse(DelayMouse)
				# Click information
				self.clickInfor
				# Check lost all (value of cards is greater than or equal to 28)
				if self.calcSPerCard(@player[@mainplayer[:symbol]][:card])>=28
					@player[@mainplayer[:symbol]][:lost] = true
					# Pay coins
					self.payLostAll(@mainplayer[:symbol])
					# Open his cards
					self.dealerOpen(@mainplayer[:symbol])
					@playertime = false
				# Check five cards
				elsif @player[@mainplayer[:symbol]][:card].size==5
					self.drawFiveCcase(@mainplayer[:symbol])
					@player[@mainplayer[:symbol]][:fivecards] = true if self.winFiveCards(@player[@mainplayer[:symbol]][:card])
					@playertime = false
				end
				# Draw text
				if redraw && redraw>0
					redraw -= 1
					newtext = nil if redraw<=0
				end
				self.drawTxtBet(newtext,false)
				# Delay mouse (action)
				if @delay>DelayMouse
					rect = self.rectChoice
					# Redraw when choose
					self.recreateRectforChoice(rect)
				end
				# Click
				if self.clickedMouse? && !rect.nil?
					if @choice[:quantity].is_a?(Array)
						case @choice[:page]
						# Page 1
						when 0
							case rect
							# Hit
							when 0
								redraw = 25
								newtext = "You distributed card"
								self.distributeCard(@mainplayer[:symbol])
								self.drawCard(@mainplayer[:symbol], @player[@mainplayer[:symbol]][:card].size-1)
							# Stand
							when 1
								if @player[@mainplayer[:symbol]][:sum] < 16
									redraw = 25
									newtext = "Your cards need to have value greater than 15"
								else
									@playertime = false
								end
							# Next page
							else
								@choice[:page] += 1
								# Redraw
								self.drawBetPlaying
							end
						# Page 2
						when 1
							case rect
							# Double
							when 1
								redraw = 25
								newtext = self.double(@mainplayer[:symbol]) ? "You distributed card and chose double" : "You can't do it"
							# Give up
							when 2
								@player[@mainplayer[:symbol]][:giveup] = true
								@player[@mainplayer[:symbol]][:interest] += @player[@mainplayer[:symbol]][:bet] / 2
								@player[@mainplayer[:symbol]][:deficit] += @player[@mainplayer[:symbol]][:bet] / 2
								self.dealerOpen(@mainplayer[:symbol])
								@playertime = false
							# Insure
							when 3
								redraw = 25
								self.insure(@mainplayer[:symbol])
								newtext = @player[@mainplayer[:symbol]][:insurance][1] ? "You betted insurance" : "You can't do it"
							# Previous page
							else
								@choice[:page] -= 1
								# Redraw
								self.drawBetPlaying
							end
						end
					# When rectangle of choice (bitmap) is less than 80 pixel
					else
						case rect
						# Hit
						when 0
							redraw = 25
							newtext = "You distributed card"
							self.distributeCard(@mainplayer[:symbol])
							self.drawCard(@mainplayer[:symbol], @player[@mainplayer[:symbol]][:card].size-1)
						# Stand
						when 1
							if @player[@mainplayer[:symbol]][:sum] < 16
								redraw = 25
								newtext = "Your cards need to have value greater than 15"
							else
								@playertime = false
							end
						# Double
						when 2
							redraw = 25
							newtext = self.double(@mainplayer[:symbol]) ? "You distributed card and chose double" : "You can't do it"
						# Give up
						when 3
							@player[@mainplayer[:symbol]][:giveup] = true
							@player[@mainplayer[:symbol]][:interest] += @player[@mainplayer[:symbol]][:bet] / 2
							@player[@mainplayer[:symbol]][:deficit] += @player[@mainplayer[:symbol]][:bet] / 2
							self.dealerOpen(@mainplayer[:symbol])
							@playertime = false
						# Insure
						when 4
							redraw = 25
							self.insure(@mainplayer[:symbol])
							newtext = @player[@mainplayer[:symbol]][:insurance][1] ? "You betted insurance" : "You can't do it"
						end
					end
				end
			end
		end

		# Draw signal for player (insurance, lost all, five cards)
		def drawSignal
			self.create_sprite_2("icon bitmap",@viewport) if !@sprites["icon bitmap"]
			self.clearTxt("icon bitmap")
			bitmap = @sprites["icon bitmap"].bitmap
			QuantityPlayer.times { |i|
				sym = self.str2sym("player #{i}")
				next if @player[sym][:name].nil?
				pos = self.posBetArea(i)
				x = pos[0]
				y = pos[1] + pos[3]
				w = RectSignal[0]
				h = RectSignal[1]
				bitmap.blt(x, y, @sprites["signal"], Rect.new(0, 0, w, h)) if @player[sym][:insurance][1]
				bitmap.blt(x+w, y, @sprites["signal"], Rect.new(w, 0, w, h)) if @player[sym][:fivecards]
				bitmap.blt(x, y+h, @sprites["signal"], Rect.new(0, h, w*2, h)) if @player[sym][:lost]
			}
		end

		# Draw infor when player need it
		def checkInforFinish
			# Delay mouse
			self.delayMouse(DelayMouse)
			# Delay mouse (action)
			if @delay>DelayMouse
				card = self.rectCard
				chose = self.rectExit
				history = self.rectHistory
				# Redraw rectangle exit
				self.drawExit(chose)
				# Redraw rectangle history
				self.drawHistory(history)
			end
			# Click
			if self.clickedMouse?
				# Clear information if player seeing it
				if @information
					@information = false
					self.clearInfor
				else
					# Draw information
					if !card.nil?
						@information = true
						self.drawInfor(card,true)
					elsif chose
						@finish = true
					elsif history
						self.showHistory
					end
				end
			end
		end

		# Draw text before finish
		def drawTextFinish
			self.clearTxt("text")
			bitmap = @sprites["text"].bitmap
			text = []
			string = "Click cards for more information"
			x = Graphics.width / 2
			y = (Graphics.height - 310) / 2 + 310
			text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			string = "Exit"
			x = RectExit[0] + @sprites["finish rect"].bitmap.width / 2
			y = RectExit[1] + @sprites["finish rect"].bitmap.height / 4
			text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			string = "History"
			x = (Graphics.width - @sprites["history rect"].bitmap.width) + @sprites["history rect"].bitmap.width / 2
			y = 0 + @sprites["history rect"].bitmap.height / 4
			text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			self.drawTxt("text",text,nil,nil,1,false,2)
		end

		# Draw exit rectangle for this game
		def drawExit(chose=false)
			if @sprites["finish rect"]
				h = @sprites["finish rect"].bitmap.height / 2
				self.set_src_xy_sprite("finish rect", 0, (chose ? h : 0))
				return
			end
			self.create_sprite("finish rect","Choice",@viewport)
			w = @sprites["finish rect"].bitmap.width
			h = @sprites["finish rect"].bitmap.height / 2
			self.set_src_wh_sprite("finish rect", w, h)
			self.set_src_xy_sprite("finish rect", 0, (chose ? h : 0))
			self.set_xy_sprite("finish rect", RectExit[0], RectExit[1])
		end

		# Rectangle exit (mouse)
		def rectExit
			w = @sprites["finish rect"].bitmap.width
			h = @sprites["finish rect"].bitmap.height / 2
			rect = [RectExit[0], RectExit[1], w, h]
			return true if self.areaMouse?(rect)
			return false
		end

		# Draw history rectangle for this game
		def drawHistory(chose=false)
			if @sprites["history rect"]
				h = @sprites["history rect"].bitmap.height / 2
				self.set_src_xy_sprite("history rect", 0, (chose ? h : 0))
				return
			end
			self.create_sprite("history rect","Choice",@viewport)
			w = @sprites["history rect"].bitmap.width
			h = @sprites["history rect"].bitmap.height / 2
			self.set_src_wh_sprite("history rect", w, h)
			self.set_src_xy_sprite("history rect", 0, (chose ? h : 0))
			x = Graphics.width - w
			y = 0
			self.set_xy_sprite("history rect", x, y)
		end

		# Rectangle history (mouse)
		def rectHistory
			w = @sprites["history rect"].bitmap.width
			h = @sprites["history rect"].bitmap.height / 2
			x = Graphics.width - w
			y = 0
			rect = [x, 0, w, h]
			return true if self.areaMouse?(rect)
			return false
		end

		# Show text in history
		def showHistory
			# Create scene
			self.create_sprite("bg history","History",@viewport)
			@sprites["bg history"].z = 50
			# Draw arrow
			self.arrowHistory
			loop do
				# Update
				self.update_ingame
				# Draw text
				self.textHistory
				# Set visible arrow
				max  = @history.size
				up   = max > self.maxTextHistory && @poshistory > 0
				down = max > self.maxTextHistory && @poshistory < max-self.maxTextHistory
				# Delay mouse
				self.delayMouse(DelayMouse)
				if @delay>DelayMouse
					arrow = self.rectArrow
					arrow = nil if (arrow==0 && !up) || (arrow==1 && !down)
					self.showArrow(up, down, arrow)
				end
				# Click
				if self.clickedMouse?
					case arrow
					when 0
						@poshistory -= 1
						@poshistory  = 0 if @poshistory<0
					when 1
						@poshistory += 1
						@poshistory  = max-1 if @poshistory>=max
					when nil
						self.clearHistory
						@poshistory = 0
						break
					end
				end
			end
		end

		# Max number of lines
		def maxTextHistory; return 6; end

		# Draw arrow
		def arrowHistory
			2.times { |i|
				if !@sprites["arrow his #{i}"]
					self.create_sprite("arrow his #{i}","History Arrow",@viewport)
					w = @sprites["arrow his #{i}"].bitmap.width / 2
					h = @sprites["arrow his #{i}"].bitmap.height / 2
					self.set_src_wh_sprite("arrow his #{i}", w, h)
					self.set_src_xy_sprite("arrow his #{i}", w*i, 0)
					x = RectArrow[i][0]
					y = RectArrow[i][1]	
					self.set_xy_sprite("arrow his #{i}", x, y)
					self.set_visible_sprite("arrow his #{i}")
					@sprites["arrow his #{i}"].z = 50
				end
			}
		end

		def showArrow(*arr)
			return if !arr.is_a?(Array) || arr.size < 2
			2.times { |i|
				self.set_visible_sprite("arrow his #{i}", arr[i])
				if @sprites["arrow his #{i}"].visible
					x = @sprites["arrow his #{i}"].bitmap.width / 2 * i
					y = arr[2] && arr[2]==i ? @sprites["arrow his #{i}"].bitmap.height / 2 : 0
					self.set_src_xy_sprite("arrow his #{i}", x, y)
				end
			}
		end

		def rectArrow
			rect = []
			2.times { |i|
				x = RectArrow[i][0]
				y = RectArrow[i][1]
				w = @sprites["arrow his #{i}"].bitmap.width / 2
				h = @sprites["arrow his #{i}"].bitmap.height / 2
				rect << [x, y, w, h]
			}
			2.times { |i| return i if self.areaMouse?(rect[i])}
			return nil
		end

		# Draw text in history
		def textHistory
			if !@sprites["bitmap history"]
				self.create_sprite_2("bitmap history",@viewport)
				@sprites["bitmap history"].z = 50
			end
			self.clearTxt("bitmap history")
			max = @history.size
			text = []
			pos = (max > 0 && max < self.maxTextHistory)? 0 : (@poshistory >= max-self.maxTextHistory)? max-self.maxTextHistory : @poshistory
			endnum = (max > 0 && max < self.maxTextHistory)? max : self.maxTextHistory
			(0...endnum).each { |i|
				hist   = @history[pos+i]
				string = "#{hist.to_s}"
				x      = 75
				y      = 106 + 30*i
				text << [string, x, y, 0, Color.new(0,0,0), Color.new(192,192,192)]
			}
			self.drawTxt("bitmap history",text)
		end

		# Clear
		def clearHistory
			self.dispose("bg history") if @sprites["bg history"]
			self.dispose("bitmap history") if @sprites["bitmap history"]
			2.times { |i| self.dispose("arrow his #{i}") if @sprites["arrow his #{i}"] }
		end

	end
end