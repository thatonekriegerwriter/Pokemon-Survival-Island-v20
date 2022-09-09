module ContestHall
	class Show

		#----------------------------------------------------------------------------------------#
		#  Determines order for first round - based condition (cool, beauty, tough, cute, smart) #
		#----------------------------------------------------------------------------------------#
		# Round 1 (use this method)
		def sort_poke_base_number
			name = [@pkmn1, @pkmn2, @pkmn3, @pkmn4]
			@pokeorder = []
			poke =
				case @contest[:number]
				when 0 then [@pkmn1.cool,   @pkmn2.cool,   @pkmn3.cool,   @pkmn4.cool]   # Cool
				when 1 then [@pkmn1.beauty, @pkmn2.beauty, @pkmn3.beauty, @pkmn4.beauty] # Beauty
				when 2 then [@pkmn1.cute,   @pkmn2.cute,   @pkmn3.cute,   @pkmn4.cute]   # Cute
				when 3 then [@pkmn1.smart,  @pkmn2.smart,  @pkmn3.smart,  @pkmn4.smart]  # Smart
				when 4 then [@pkmn1.tough,  @pkmn2.tough,  @pkmn3.tough,  @pkmn4.tough]  # Tough
				end
			# order = poke.sort.reverse
			hash = {}
			4.times { |i| hash[name[i]] = poke[i] }
			hash = hash.sort_by(&:last).reverse.to_h
			@pokeorder = hash.keys
		end

		#--------------------------------#
		# Determine order for next round #
		#--------------------------------#
		# Old: pbOrder
		def set_order
			@stars = [] 
			order = []
			mosthearts = @roundtotals.sort.reverse
			# Move up
			if @MoveUp.include?(true)
				@MoveUp.each_with_index { |mu, i|
					next unless mu && !@MoveDown[i]
					newpoke = @pokeorder[i]
					order.push(newpoke)
					newstars = newpoke == @pkmn1 ? @pkmn1stars : newpoke == @pkmn2 ? @pkmn2stars : newpoke == @pkmn3 ? @pkmn3stars : @pkmn4stars
					@stars.push(newstars)
				}
			end
			if order.length < 4
				4.times { |i|
					newpoke = nil
					newpoke = @pkmn1 if mosthearts[i] == @pkmn1total && !order.include?(@pkmn1) && !@MoveDown[pkmn_current(@pkmn1)]
					newpoke = @pkmn2 if mosthearts[i] == @pkmn2total && !order.include?(@pkmn2) && !@MoveDown[pkmn_current(@pkmn2)]
					newpoke = @pkmn3 if mosthearts[i] == @pkmn3total && !order.include?(@pkmn3) && !@MoveDown[pkmn_current(@pkmn3)]
					newpoke = @pkmn4 if mosthearts[i] == @pkmn4total && !order.include?(@pkmn4) && !@MoveDown[pkmn_current(@pkmn4)]
					next if newpoke.nil?
					order.push(newpoke)
					newstars = newpoke == @pkmn1 ? @pkmn1stars : newpoke == @pkmn2 ? @pkmn2stars : newpoke == @pkmn3 ? @pkmn3stars : @pkmn4stars
					@stars.push(newstars)
				}
			end
			# Move Down
			if @MoveDown.include?(true)
				@MoveDown.each_with_index { |md, i|
					next unless md && !@MoveUp[i]
					newpoke = @pokeorder[i]
					order.push(newpoke)
					newstars = newpoke == @pkmn1 ? @pkmn1stars : newpoke == @pkmn2 ? @pkmn2stars : newpoke == @pkmn3 ? @pkmn3stars : @pkmn4stars
					@stars.push(newstars)
				}
			end
			# Random order for Scramble
			if @Scramble && @round <= 5
				orders = [@pkmn1, @pkmn2, @pkmn3, @pkmn4]
				@stars = [@pkmn1stars, @pkmn2stars, @pkmn3stars, @pkmn4stars]
				# seed RNG with fixed value depending on date (reseed RNG)
				srand 
				neworders = orders.shuffle
				order = neworders
				neworders.each_with_index { |nor, i| @stars[i] = nor == @pkmn1 ? @pkmn1stars : nor == @pkmn2 ? @pkmn2stars : nor == @pkmn3 ? @pkmn3stars : @pkmn4stars }
			end
			@pokeorder.clear
			@pokeorder = order
		end

		# End round reset
		# Old: pbResetContestMoveEffects
		def reset_move_effect
			@Oblivious      = [false, false, false, false]
			@AvoidOnce      = [0, 0, 0, 0]
			@Scramble       = false
			@MoveUp         = [false, false, false, false]
			@MoveDown       = [false, false, false, false]
			@UpCondition    = [false, false, false, false]
			@previoushearts = 0
			@crowdexcitment = true
			@goodappeal     = [false, false, false, false]
			@easilystartled = [false, false, false, false]
			@nervous        = [false, false, false, false]
			@jamaffected    = [false, false, false, false]
			@hasattention   = [false, false, false, false]
			# Set again
			nervous_graphic
			oblivious_graphic
		end

		def reset_order
			reset_move_effect
			pbDrawText
		end

	end
end