module ContestHall
	class Show

		#---------------------------------#
		# Miscellaneous Graphic functions #
		#---------------------------------#
		# Old: pbNervousGraphic
		def nervous_graphic
			arr = ["nervousone", "nervoustwo", "nervousthree", "nervousfour"]
			4.times { |i|
				if @nervous[i]
					next if @sprites[arr[i]]
					create_sprite(arr[i], "nervous", @viewport)
					x = 374
					y = 47 + 96 * i
					set_xy_sprite(arr[i], x, y)
				else
					next if !@sprites[arr[i]]
					dispose(@sprites, arr[i])
				end
			}
		end

		# Old: pbObliviousGraphic
		def oblivious_graphic
			arr = ["obliviousone", "oblivioustwo", "obliviousthree", "obliviousfour"]
			4.times { |i|
				if @Oblivious[i] || @AvoidOnce[i] > 0
					next if @sprites[arr[i]]
					create_sprite(arr[i], "oblivious", @viewport)
					x = 374
					y = 47 + 96 * (@currentpos - 1)
					set_xy_sprite(arr[i], x, y)
				else
					next if !@sprites[arr[i]]
					dispose(@sprites, arr[i])
				end
			}
		end

		# Old: pbStartleGraphic
		def startle_graphic(position, deletepos=5)
			arr = ["startleone", "startletwo", "startlethree", "startlefour"]
			4.times { |i|
				next if position != i || @sprites[arr[i]]
				create_sprite(arr[i], "startle", @viewport)
				x = 374
				y = 47 + 96 * i
				set_xy_sprite(arr[i], x, y)
			}
			if deletepos < 5
				4.times { |i|
					next if deletepos != i || !@sprites[arr[i]]
					dispose(@sprites, arr[i])
				}
			end
		end

		def change_star_f(number, graphic, change, decrease, position)
			(change + 1).times { |i|
				number -= 1 if decrease && number>0
				number += 1 if !decrease
				x = 350
				y = 78 + 94 * position
				@sprites[graphic] = IconSprite.new(x, y, @viewport) if !@sprites[graphic]
				file = "Graphics/Pictures/Contest/stars#{number}" if number <= 6
				@sprites[graphic].setBitmap(file)
				pbWait(2)
				break if number == 0
			}
		end

		# Old: pbDecreaseStarGraphics
		def decrease_star_graphic(position, change, decrease=true)
			case @stars[position]
			when @pkmn1stars then change_star_f(@pkmn1stars, "firstpokestars",  change, decrease, position)
			when @pkmn2stars then change_star_f(@pkmn2stars, "secondpokestars", change, decrease, position)
			when @pkmn3stars then change_star_f(@pkmn3stars, "thirdpokestars",  change, decrease, position)
			when @pkmn4stars then change_star_f(@pkmn4stars, "fourthpokestars", change, decrease, position)
			end
		end

	end
end