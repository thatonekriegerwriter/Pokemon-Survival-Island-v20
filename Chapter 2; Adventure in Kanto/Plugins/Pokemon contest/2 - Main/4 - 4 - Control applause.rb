module ContestHall
	class Show

		#-------------------------#
		# Controls Applause meter #
		#-------------------------#
		# Old: pbCrowd
		def crowd(move=nil)
			xPos = -172
			create_sprite("Applause Bar", "applause", @viewport)
			set_xy_sprite("Applause Bar", xPos, 0)
			@sprites["applausemeter"] = IconSprite.new(xPos + 19, 50, @viewport)
			@sprites["applausemeter"].setBitmap("Graphics/Pictures/Contest/applause#{@applause}")
			@appear = 0
			43.times{
				xPos += 4
				@sprites["applausemeter"].x = xPos + 19
				@sprites["Applause Bar"].x  = xPos 
				pbWait(1)
			}
			if move.nil?
				file  = "Graphics/Pictures/Contest/choice 29"
				width = 340
				pkmnname = @pokeorder[@currentpos-1].name
				if @moveType == @contestType
					@applause = @applause + 1
					@sprites["applausemeter"].setBitmap("Graphics/Pictures/Contest/applause#{@applause}")
					mess = @moveType == "Beauty" ? _INTL("\\l[3]{1}'s {2} went over great!", pkmnname, @contestType) : _INTL("\\l[3]{1}'s {2}ness went over great!", pkmnname, @contestType)
					pbCustomMessage(mess, file, nil, width)
					@currenthearts = 1
					display_positive_hearts
				else
					mess = @moveType == "Beauty" ? _INTL("\\l[3]{1}'s {2} didn't go over very well!", pkmnname, @moveType) : _INTL("\\l[3]{1}'s {2}ness didn't go over very well!", pkmnname, @moveType)
					pbCustomMessage(mess, file, nil, width)
					if @applause > 0
						@applause -= 1
						@sprites["applausemeter"].setBitmap("Graphics/Pictures/Contest/applause#{@applause}")
						set_jam(1, @pokeorder[@currentpos-1])
						decrease_hearts(@pokeorder[@currentpos-1], @currentpos, "notnil")
					else
						@applause = 0
						@sprites["applausemeter"].setBitmap("Graphics/Pictures/Contest/applause#{@applause}")
					end
				end
				if @crowdexcitment && @applause == 5
					pbCustomMessage(_INTL("\\l[3]{1}'s {2} really got the crowd going!", pkmnname, @moveType), file, nil, width)
					@currenthearts = 5
					display_positive_hearts
					@applause = 0
					@sprites["applausemeter"].setBitmap("Graphics/Pictures/Contest/applause#{@applause}")
				end
				43.times {
					xPos -= 4
					@sprites["Applause Bar"].x  = xPos
					@sprites["applausemeter"].x = xPos + 19 if @sprites["applausemeter"]
					pbWait(1)
				}
				dispose(@sprites, "Applause Bar")  if @sprites["Applause Bar"]
				dispose(@sprites, "applausemeter") if @sprites["applausemeter"]
			end
		end
	 
		# Old: pbJam
		def set_jam(jam, target)
			case target
			when @pkmn1 then @pkmn1jam = jam
			when @pkmn2 then @pkmn2jam = jam
			when @pkmn3 then @pkmn3jam = jam
			when @pkmn4 then @pkmn4jam = jam
			end
		end

	end
end