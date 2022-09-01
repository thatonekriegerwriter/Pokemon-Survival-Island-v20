module ContestHall
	class Show

		def add_sprite_hearts(heart, heartid, namesprite)
			@currenthearts.times {
				heart += 1
				file   = "Graphics/Pictures/Contest/heart#{heart}" if heart < 21
				pbWait(1)
				x = 399
				y = 45 + (@currentpos - 1) * 96
				@heartsprites[namesprite] = IconSprite.new(x, y,@viewport) if !@heartsprites[namesprite]
      	@heartsprites[namesprite].setBitmap(file)
			}
			case heartid
			when 0 then @pkmn1hearts = heart
			when 1 then @pkmn2hearts = heart
			when 2 then @pkmn3hearts = heart
			when 3 then @pkmn4hearts = heart
			end
			@priorhearts = heart
		end

		# Old: pbDisplayAddingPositiveHearts
		def display_positive_hearts
			case @currentpoke
			when @pkmn1 then add_sprite_hearts(@pkmn1hearts, 0, "firstpokehearts")
			when @pkmn2 then add_sprite_hearts(@pkmn2hearts, 1, "secondpokehearts")
			when @pkmn3 then add_sprite_hearts(@pkmn3hearts, 2, "thirdpokehearts")
			when @pkmn4 then add_sprite_hearts(@pkmn4hearts, 3, "fourthpokehearts")
			end
		end

		def add_sprite_deacrease_hearts(position, jam, heart, heartid, namesprite)
			jam *= 2 if @easilystartled[position-1]
      jam.times {
				if !@heartsprites[namesprite]
					x = 399
					y = 45 + (position - 1) * 96
					@heartsprites[namesprite] = IconSprite.new(x, y,@viewport)
				end
				heart -= 1
				if heart >= 0 && heart < 21
					file = "Graphics/Pictures/Contest/heart#{heart}"
				elsif heart < 0 && heart > -21
					file = "Graphics/Pictures/Contest/negaheart#{heart.abs}"
				end
				@heartsprites[namesprite].setBitmap(file)
				pbWait(1)
			}
			case heartid
			when 0
				@pkmn1hearts = heart
				@pkmn1jam    = jam
			when 1
				@pkmn2hearts = heart
				@pkmn2jam    = jam
			when 2
				@pkmn3hearts = heart
				@pkmn3jam    = jam
			when 3
				@pkmn4hearts = heart
				@pkmn4jam    = jam
			end
      @priorhearts = heart
		end

		# Old: pbDecreaseHearts
		def decrease_hearts(target, position, selfjam=nil)
			if selfjam.nil?
				file  = "Graphics/Pictures/Contest/choice 29"
				width = 340
				mess  = @currentjam == 1 ? _INTL("\\l[3]{1} looked down out of distraction!", target.name) : _INTL("\\l[3]{1} couldn't help leaping up!", target.name)
				pbCustomMessage(mess, file, nil, width)
			end
			case target
			when @pkmn1 then add_sprite_deacrease_hearts(position, @pkmn1jam, @pkmn1hearts, 0, "firstpokehearts")
			when @pkmn2 then add_sprite_deacrease_hearts(position, @pkmn2jam, @pkmn2hearts, 1, "secondpokehearts")
			when @pkmn3 then add_sprite_deacrease_hearts(position, @pkmn3jam, @pkmn3hearts, 2, "thirdpokehearts")
			when @pkmn4 then add_sprite_deacrease_hearts(position, @pkmn4jam, @pkmn4hearts, 3, "fourthpokehearts")
			end
		end

		#------------------------------------------------------------------#
		# Get rid of hearts graphics at end round, and add up heart totals #
		#------------------------------------------------------------------#
		# Old: pbResetHearts
		def reset_hearts
			arr = ["firstpokestars",  "secondpokestars",  "thirdpokestars",  "fourthpokestars"]
			# Dispose heart
			dispose(@heartsprites)
			# Dispose star
			arr.each { |a| dispose(@sprites, a) if @sprites[a] }
			# Record (total)
			@pkmn1total += @pkmn1hearts
			@pkmn2total += @pkmn2hearts
			@pkmn3total += @pkmn3hearts
			@pkmn4total += @pkmn4hearts
			# Record (round)
			@roundtotals = [@pkmn1total, @pkmn2total, @pkmn3total, @pkmn4total]
			# Set heart (again)
			@pkmn1hearts = 0
			@pkmn2hearts = 0
			@pkmn3hearts = 0
			@pkmn4hearts = 0
		end

	end
end