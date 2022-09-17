module ContestHall
	class Show

		#-----------------------------------------#
		# Adjusts hearts via movefunctions.
		# New move functions go in case statement
		#-----------------------------------------#
		# Old: pbFunctionsAdjustHearts
		def func_adjust_hearts
			data = SetContestMoves.r_move
			pos  = data[:id].index(@currentmove)
			@currentfunction = data[:function][pos]
			@currentjam = data[:jam][pos]
			file  = "Graphics/Pictures/Contest/choice 29"
			width = 340
			i = @currentpos - 1
			case @currentfunction
			when 1
				@AvoidOnce[i] = 1
				oblivious_graphic
			when 2
				@Oblivious[i] = true
				oblivious_graphic
			when 3 then @MoveUp[i] = true
			when 4 then @UpCondition[i] = true
			when 5
				pbCustomMessage(_INTL("\\l[3]It tried to startle the other Pokemon!"), file, nil, width)
				if @currentpos > 1
					(@currentpos - 1).times { |j|
						num = @currentpos - 1 - 1 - j
						func_5_adjust_hearts(num, file, width)
					}
				else
					pbCustomMessage(_INTL("\\l[3]But it failed.."), file, nil, width)  
				end
			when 6 then @currenthearts = @currenpos == 4 ? (@currentpos + 1) : @currentpos
			when 7
				3.times { |j|
					next unless @hasattention[j] && j != @currentpos - 1
					if @Oblivious[j]
						pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it", @pokeorder[j].name), file, nil, width)
					elsif @AvoidOnce[j] > 0
						pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it", @pokeorder[j].name), file, nil, width)
						@AvoidOnce[j]=0
						oblivious_graphic
					else
						startle_graphic(j-1)
						set_jam(@currentjam, @pokeorder[j])
						decrease_hearts(@pokeorder[j], j+1)
						startle_graphic(j-1, j-1)
					end
				}
			when 8
				pbCustomMessage(_INTL("\\l[3]It tried to startle the previous Pokemon!"), file, nil, width)
				if @currentpos > 1
					(@currentpos - 1).times { |j|
						num = @currentpos - 1 - 1 - j
						func_5_adjust_hearts(num, file, width)
					}
				else
					pbCustomMessage(_INTL("\\l[3]But it failed.."), file, nil, width)
				end
			when 9
				@currenthearts = @priorhearts[@currentpos-1] >= 3 ? @currenthearts * 2 : 1
			when 10 then @easilystartled[i] = true
			when 11 then @MoveDown[i] = true
			when 12
				4.times { |j|
					next if @priorhearts[j] <= 3
					if @Oblivious[j]
						pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it", @pokeorder[j].name), file, nil, width)
					elsif @AvoidOnce[j] > 0
						pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it", @pokeorder[j].name), file, nil, width)
						@AvoidOnce[j]=0
						oblivious_graphic
					else
						startle_graphic(j-1)
						set_jam(@currentjam, @pokeorder[j])
						decrease_hearts(@pokeorder[j], j+1)
						startle_graphic(j-1, j-1)
					end
				}
			when 13
				pbCustomMessage(_INTL("\\l[3]The crowd died down!"), file, nil, width)
				@crowdexcitment = false
			when 14
				if @currentpos == 1
					pbCustomMessage(_INTL("\\l[3]The standout {1} hustled even more!", @pokeorder[i].name), file, nil, width)
					@currenthearts *= 2
				end
			when 16
				set_miss_turn
				pbCustomMessage(_INTL("\\l[3]It tried to startle the other Pokemon!"), file, nil, width)
				if @currentpos > 1
					(@currentpos - 1).times { |j|
						num = @currentpos - 1 - 1 - j
						func_5_adjust_hearts(num, file, width)
					}
				else
					pbCustomMessage(_INTL("\\l[3]But it failed.."), file, nil, width)
				end
			when 17
				if @currentpos.between?(1, 3)
					(@currentpos..3).each { |j|
						pbCustomMessage(_INTL("\\l[3]{1} became nervous.", @pokeorder[j].name), file, nil, width)
						@nervous[j] = true
					}
				end
				nervous_graphic
			when 18 then set_no_more_moves
			when 19 then @currenthearts = @applause + 1
			when 20 then @currenthearts = rand(5) + 1
			when 21
				if @currentpos == 4
					pbCustomMessage(_INTL("\\l[3]The standout {1} hustled even more!", @pokeorder[i].name), file, nil, width)
					@currenthearts = 5
				end
			when 22  
				if @currentpos == 0
					pbCustomMessage(_INTL("\\l[3]But it failed."), file, nil, width)
				else
					(@currentpos - 1).times { |j| decrease_star_graphic(j, 1) }
				end
			when 23 then @currenthearts = @currenpos == 4 ? (@currentpos + 1) : @currentpos
			when 24
				pbCustomMessage(_INTL("\\l[3]{1} scrambled up the order for the next turn!", @pokeorder[i].name), file, nil, width)
				@Scramble = true
			when 25 then @currenthearts = @currenthearts * 2 if @moveType == @lastmoveType
			when 26 then @MoveDown[i] = true
			when 27
				set_double_next
				pbCustomMessage(_INTL("\\l[3]{1} is getting prepared.", @pokeorder[i].name), file, nil, width)
				@currenthearts = 1
			when 28 then @currenthearts = rand(5) + 1
			when 29 then @currenthearts = @currentpos == 1 ? 1 : @priorhearts[@currentpos-1] < 3 ? (@currenthearts * 2) : 1
			when 30 then @currenthearts = @currentpos == 1 ? 1 : (@priorhearts[currentpos-1] / 2).to_f
			when 31
				@applause = 5
				crowd("notnil")
			when 32
				if @currentpos == 0
					pbCustomMessage(_INTL("\\l[3]But if failed."), file, nil, width)
				else
					@currentpos.times { |j| decrease_star_graphic(j, 1) if @stars[j] > 0 }
				end
			when 33 then @currenthearts = @applause
			when 34 then @currenthearts = @priorhearts[@currentpos-1]
			when 35 then @currenthearts = @stars[@currentpos-1]    
			when 36 then @currenthearts = @movetype == @contestType ? (@currenthearts + 1) : @currenthearts
			when 37 then @currenthearts = @currenthearts + @priorhearts[@currentpos-1]
			when 38  
				currentApplause = @applause
				currentApplause = 5 if currentApplause < 0 || currentApplause > 5
				@currenthearts  = 6 - currentApplause
			when 39 then @currenthearts = @round + 1
			when 40
				if @currentpos > 1
					@currenthearts = @currenthearts * 2 if @priorhearts[@currentpos-1] > 3
				else
					@currenthearts = 1
				end
			when 41 then @currenthearts = @applause
			else @currenthearts = @currenthearts
			end
		end

		def func_5_adjust_hearts(num, file, width)
			if @Oblivious[num]
				pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it", @pokeorder[num].name), file, nil, width)
			elsif @AvoidOnce[num] > 0
				pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it", @pokeorder[num].name), file, nil, width)
				@AvoidOnce[num] = 0
				oblivious_graphic
			else
				startle_graphic(num)
				set_jam(@currentjam, @pokeorder[num])
				decrease_hearts(@pokeorder[num], num + 1)
				startle_graphic(num, num)
			end
		end

	end
end