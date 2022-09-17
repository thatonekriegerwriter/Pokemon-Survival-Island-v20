module ContestHall
	class Show

		# Old: pbResultsScene
		def result_scene
			pbMessage(_INTL("MC: That's it for judging!"))
			pbMessage(_INTL("Thank you all for a most wonderful display of quality appeals!"))
			pbMessage(_INTL("This concludes all judging! Thank you for your fine efforts!"))
			pbMessage(_INTL("Now, all that remains is the pulse-pounding proclamation of the winner."))
			pbMessage(_INTL("The JUDGE looks ready to make the annoucement!"))
			pbMessage(_INTL("JUDGE: We will now declare the winner!"))
			# Draw bitmap
			store = @contest[:pospkmn]
			create_sprite("bg", "Background", @viewport)
			@sprites["bg"].z = 10
			4.times { |i|
				create_sprite("color #{i}", "Color_Bar", @viewport)
				w = @sprites["color #{i}"].bitmap.width
				h = @sprites["color #{i}"].bitmap.height / 5
				set_src_wh_sprite("color #{i}", w, h)
				set_src_xy_sprite("color #{i}", 0, h * @contest[:number])
				x = -93
				y = 128 + i * 50
				set_xy_sprite("color #{i}", x, y)
				@sprites["color #{i}"].z = 10
			}
			# Set background
			create_sprite("bg2", "Background_2", @viewport)
			@sprites["bg2"].z = 10
			# Set result
			create_sprite("results", "resultsbg", @viewport)
			@sprites["results"].z = 10
			# Draw poke icons
			@pkmn1sprite = PokemonIconSprite.new(@pkmn1,@viewport)
			@pkmn2sprite = PokemonIconSprite.new(@pkmn2,@viewport)
			@pkmn3sprite = PokemonIconSprite.new(@pkmn3,@viewport)
			@pkmn4sprite = PokemonIconSprite.new(@pkmn4,@viewport)
			@pkmn1sprite.z = @pkmn2sprite.z = @pkmn3sprite.z = @pkmn4sprite.z = 10
			# # Positions poke icons
			@pkmn1sprite.x = @pkmn2sprite.x = @pkmn3sprite.x = @pkmn4sprite.x = 86
			@pkmn1sprite.y = 93
			@pkmn2sprite.y = @pkmn1sprite.y + 50
			@pkmn3sprite.y = @pkmn2sprite.y + 50
			@pkmn4sprite.y = @pkmn3sprite.y + 50
			# Bitmap to draw text on, instead of pbMessage
			create_sprite_2("textbitmap", @viewport)
			@sprites["textbitmap"].z = 10
			# Color for rectangles, determined by contest type
			rectcolor = 
				case @contestType
				when "Cool"   then Color.new(178, 34, 34)
				when "Beauty" then Color.new(0, 0, 255)
				when "Cute"   then Color.new(255, 0, 255)
				when "Smart"  then Color.new(0, 100, 0)
				when "Tough"  then Color.new(255, 215, 0)
				end
			# Points Preliminary
			prelim1 = 0
			prelim2 = 0
			prelim3 = 0
			prelim4 = 0
			case @contestType
			when "Cool"
				prelim1 += 20 if $Trainer.party[store].hasItem?(:REDSCARF)
				prelim1 += $Trainer.party[store].cool
				prelim2 += @pkmn2.cool
				prelim3 += @pkmn3.cool
				prelim4 += @pkmn4.cool
			when "Beauty"
				prelim1 += 20 if $Trainer.party[store].hasItem?(:BLUESCARF)
				prelim1 += $Trainer.party[store].beauty
				prelim2 += @pkmn2.beauty
				prelim3 += @pkmn3.beauty
				prelim4 += @pkmn4.beauty
			when "Cute"
				prelim1 += 20 if $Trainer.party[store].hasItem?(:PINKSCARF)
				prelim1 += $Trainer.party[store].cute
				prelim2 += @pkmn2.cute
				prelim3 += @pkmn3.cute
				prelim4 += @pkmn4.cute
			when "Smart"
				prelim1 += 20 if $Trainer.party[store].hasItem?(:GREENSCARF)
				prelim1 += $Trainer.party[store].smart
				prelim2 += @pkmn2.smart
				prelim3 += @pkmn3.smart
				prelim4 += @pkmn4.smart
			when "Tough"
				prelim1 += 20 if $Trainer.party[store].hasItem?(:YELLOWSCARF)
				prelim1 += $Trainer.party[store].tough
				prelim2 += @pkmn2.tough
				prelim3 += @pkmn3.tough
				prelim4 += @pkmn4.tough
			end
			# Extra points if it's shiny
			prelim1 += 25 if $Trainer.party[store].shiny?
			prelim2 += 25 if @pkmn2.shiny?
			prelim3 += 25 if @pkmn3.shiny?
			prelim4 += 25 if @pkmn4.shiny?
			# Gives points for "scarves".
			# Pokemon won't actually have any.
			# Less likely to
			case DIFFICULT.index(@difficulty)
			when 1
				prelim2 += 20 if rand(4) == 0
				prelim3 += 20 if rand(4) == 0
				prelim4 += 20 if rand(4) == 0
			when 2
				prelim2 += 20 if rand(2) == 0
				prelim3 += 20 if rand(2) == 0
				prelim4 += 20 if rand(2) == 0
			when 3
				prelim2 += 20
				prelim3 += 20
				prelim4 += 20
			end
			# Method for determine winner
			nummulti = 
				case DIFFICULT.index(@difficulty)
				when 0 then 10
				when 1 then 15
				when 2 then 20
				when 3 then 25
				end
			hash = {
				@pkmn1 => ((@pkmn1total + @pkmn1stars) * nummulti + prelim1),
				@pkmn2 => ((@pkmn2total + @pkmn2stars) * nummulti + prelim2),
				@pkmn3 => ((@pkmn3total + @pkmn3stars) * nummulti + prelim3),
				@pkmn4 => ((@pkmn4total + @pkmn4stars) * nummulti + prelim4)
			}
			value1 = hash.values
			hash = hash.sort_by(&:last).reverse.to_h
			@order_winner = hash.keys
			value2        = hash.values
			@player_win = true if @order_winner[0] == @pkmn1 && number[0] != number[1]
			@quantity_winner = 5 - hash.values.uniq.size
			# Array of the scores to use
			maxprelim = 255 + 20 + 25
			total = []
			4.times { |i|
				pos = 
					case @order_winner[i]
					when @pkmn1 then 0
					when @pkmn2 then 1
					when @pkmn3 then 2
					when @pkmn4 then 3
					end
				if value2[0] <= 0
					total[pos] = 0
					next
				end
				total[pos] = value1[pos] * 260.0 / value2[0]
				total[pos] = 0 if total[pos] <= 0
			}
			prelim  = [prelim1, prelim2, prelim3, prelim4]
			rate    = []
			result  = []
			result2 = []
			4.times { |i|
				if total[i] == 0
					result  << 0
					result2 << 0
					next
				end
				rate    << (prelim[i].to_f / value1[i].to_f)
				result  << (rate[i] * total[i])
				result2 << (total[i] - result[i])
			}
			contestover = false
			loop do
				# Update
				update_ingame
				break if Input.trigger?(Input::C) && contestover
				next if contestover
				# Start
				textpos = []
				textpos << [_INTL("Announcing the results!"), Graphics.width / 3, 309, 0, rectcolor, Color.new(136,168,208)]
				pbDrawTextPositions(@sprites["textbitmap"].bitmap,textpos)
				pbWait(3)
				textpos.clear
				# Draw rectangles, using the prelims as the initial
				@sprites["textbitmap"].bitmap.clear
				textpos << [_INTL("The preliminary results!"), Graphics.width / 3, 309, 0, rectcolor, Color.new(136,168,208)]
				pbDrawTextPositions(@sprites["textbitmap"].bitmap,textpos)
				10.times {
					4.times { |i|
						@sprites["color #{i}"].x += (result[i] / 10).to_f
						pbWait(1)
					}
				}
				pbWait(20)
				# Second results
				textpos.clear
				@sprites["textbitmap"].bitmap.clear
				textpos << [_INTL("Round 2 results!"), Graphics.width / 3, 309, 0, rectcolor, Color.new(136, 168, 208)]
				pbDrawTextPositions(@sprites["textbitmap"].bitmap, textpos)
				10.times {
					4.times { |i|
						@sprites["color #{i}"].x += (result2[i] / 10).to_f
						pbWait(1)
					}
				}
				4.times { |i|
					next if total[i] == 0
					next if @sprites["color #{i}"].x == total[i] - 93
					@sprites["color #{i}"].x = total[i] - 93
				}
				textpos.clear
				@sprites["textbitmap"].bitmap.clear
				# Determine winner
				string =
					case @quantity_winner
					when 1 then _INTL("{1} is the winner!", @order_winner[0].name)
					when 2 then _INTL("{1} and {2} are the winners!", @order_winner[0].name, @order_winner[1].name)
					when 3 then _INTL("{1},{2} and {3} are the winners!", @order_winner[0].name, @order_winner[1].name, @order_winner[2].name)
					when 4 then _INTL("{1},{2},{3} and {4} are the winners!", @order_winner[0].name, @order_winner[1].name, @order_winner[2].name, @order_winner[3].name)
					end
				textpos << [string, Graphics.width / 3, 309, 0, rectcolor, Color.new(136, 168, 208)]
				pbDrawTextPositions(@sprites["textbitmap"].bitmap, textpos)
				$Trainer.party[store].giveRibbon(@ribbonnum) if !($Trainer.party[store].hasRibbon?(@ribbonnum)) && @player_win
				# Allows scene to exit loop and end
				contestover = true
			end
		end

	end
end