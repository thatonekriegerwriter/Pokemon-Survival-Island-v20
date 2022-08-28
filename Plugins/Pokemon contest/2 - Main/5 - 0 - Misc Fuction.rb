module ContestHall
	class Show

		# Return position of array to check, using @currentpoke
		def position_arr_pkmn
			arr = [@pkmn1, @pkmn2, @pkmn3, @pkmn4]
			arr.each_with_index { |pkmn, i|
				next if @currentpoke != pkmn
				return i
			}
		end

		# Old: pbAssignLastMove
		def assign_last_move
			case @currentpoke
			when @pkmn1 then @pkmn1lastmove = @currentmovename
			when @pkmn2 then @pkmn2lastmove = @currentmovename
			when @pkmn3 then @pkmn3lastmove = @currentmovename
			when @pkmn4 then @pkmn4lastmove = @currentmovename
			end
		end

		# Old: pbCheckLast
		def check_last
			case @currentpoke
			when @pkmn1
				return unless @pkmn1lastmove
				return @currentmovename == @pkmn1lastmove
			when @pkmn2
				return unless @pkmn2lastmove
				return @currentmovename == @pkmn2lastmove
			when @pkmn3
				return unless @pkmn3lastmove
				return @currentmovename == @pkmn3lastmove
			when @pkmn4
				return unless @pkmn4lastmove
				return @currentmovename == @pkmn4lastmove
			end
		end

		# Old: pbmoveType
		def move_type(moveType) = (@moveType = moveType)

		# Checks if pokemon can use moves
		# Old: pbNoMore
		def no_more
			arr      = [@pkmn1nomoremoves, @pkmn2nomoremoves, @pkmn3nomoremoves, @pkmn4nomoremoves]
			position = position_arr_pkmn
			return arr[position]
		end

		# Checks if pokemon misses this turn
		# Old: pbMissTurn
		def miss_turn
			arr      = [@pkmn1MissTurn, @pkmn2MissTurn, @pkmn3MissTurn, @pkmn4MissTurn]
			position = position_arr_pkmn
			return arr[position]
		end

		# Check if it should double hearts
		# Old: pbDoubleNext
		def double_next
			arr      = [@pkmn1DoubleNext, @pkmn2DoubleNext, @pkmn3DoubleNext, @pkmn4DoubleNext]
			position = position_arr_pkmn
			return arr[position]
		end

		# Old: pbSetNoMoreMoves
		def set_no_more_moves
			case @currentpoke
			when @pkmn1 then @pkmn1nomoremoves = true
			when @pkmn2 then @pkmn2nomoremoves = true
			when @pkmn3 then @pkmn3nomoremoves = true
			when @pkmn4 then @pkmn4nomoremoves = true
			end
		end

		# Old: pbSetMissTurn
		def set_miss_turn
			case @currentpoke
			when @pkmn1 then @pkmn1MissTurn = true
			when @pkmn2 then @pkmn2MissTurn = true
			when @pkmn3 then @pkmn3MissTurn = true
			when @pkmn4 then @pkmn4MissTurn = true
			end
		end

		# Old: pbSetDoubleNext
		def set_double_next
			case @currentpoke
			when @pkmn1 then @pkmn1DoubleNext = true
			when @pkmn2 then @pkmn2DoubleNext = true
			when @pkmn3 then @pkmn3DoubleNext = true
			when @pkmn4 then @pkmn4DoubleNext = true
			end
		end

		# Old: pbReverseMissTurn
		def reverse_miss_turn
			case @currentpoke
			when @pkmn1 then @pkmn1MissTurn = false
			when @pkmn2 then @pkmn2MissTurn = false
			when @pkmn3 then @pkmn3MissTurn = false
			when @pkmn4 then @pkmn4MissTurn = false
			end
		end

		# Old: pbReverseDoubleNext
		def reverse_double_next
			case @currentpoke
			when @pkmn1 then @pkmn1DoubleNext = false
			when @pkmn2 then @pkmn2DoubleNext = false
			when @pkmn3 then @pkmn3DoubleNext = false
			when @pkmn4 then @pkmn4DoubleNext = false
			end
		end

	end
end