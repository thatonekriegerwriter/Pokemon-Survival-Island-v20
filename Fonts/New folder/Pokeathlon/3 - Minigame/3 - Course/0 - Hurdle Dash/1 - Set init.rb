module Pokeathlon
	class Minigame_HurdleDash < Minigame_Main
		NUMBER_STUN = 10 # Real: NUMBER_STUN * 2

		def initialize(pkmn, species)
			super()

			# class Pokemon
			@pkmn = pkmn.clone
			# ID of pokemon
			@species = species.clone

			# Boost - 4 boosts
			# Use to calculate
			@boost = []
			12.times { @boost << 0 }
			# Use to show boost of pokemon: @boost[0..2]

			# Jump
			# Use to calculate - use (@acceleration * @boost[] + @oriSpeed[]) when pokemon jumps and minus this number to 0
			@jump = []
			12.times { @jump << 0 }
			# Use to show jump of pokemon: @jump[0..2]
			@jumped = [false, false, false]

			# Original
			# Use stats to calculate
			@oriSpeed = []
			@oriSkill = []
			@oriJump  = []
			@pkmn.each { |pk|
				@oriSpeed << pk.athlon_normal_changed[0].clone   # Movement speed
				@oriSkill << pk.athlon_normal_changed[2].clone   # Acceleration rate
				@oriJump  << pk.athlon_normal_changed.last.clone # Length of jump
			}
			# Convert into numbers
			# Minimum: 1, Maximum: 6
			@oriSpeed.map! { |st| st * 1 + 1 }
			# Rate: number / 100, Minimum: 1, Maximum: 51
			@oriSkill.map! { |st| st * 10 + 1 }
			# Depend speed
			@oriJump.map!.with_index { |st, i| (st + 40) * @oriSpeed[i] }

			# Speed use when pokemon increases speed
			@acceleration = 2

			# Information of this minigame
			# Length of this race
			@lengthRace = 8400
			# In this distance, there aren't 'Fence'
			# Start and finish place
			@emptyStart  = 200
			@emptyFinish = 200
			# Between two fences
			@emptyBetween = 300

			# Random fence, 3 types: one, two near and two far
			@fence = []
			distance = @lengthRace - @emptyStart - @emptyFinish
			(distance / @emptyBetween).times {
				random = rand(4)
				add =
					case random
					when 0 then nil
					when 1 then :one
					when 2 then :twonear
					when 3 then :twofar
					end
				@fence << add
			}
			# Distance of :twonear, :twofar -> [:twonear, :twofar]
			distancetwo = [10, 30]
			# Store position of fence, use to move fence
			positionFence = []
			count = 0
			hastwo = false
			@fence.each_with_index { |f, i|
				num2 = count - (hastwo ? 2 : 1)
				num  = i == 0 ? @emptyStart : (positionFence[num2].is_a?(Array) ? positionFence[num2][1] : positionFence[num2]) + @emptyBetween
				case f
				when nil
					positionFence << [nil, num]
					hastwo = false
				when :one
					positionFence << num
					hastwo = false
				when :twonear, :twofar
					2.times { |j|
						if j.even? # 0
							positionFence << num
							count += 1
						else
							num = f == :twonear ? 0 : 1
							positionFence << (positionFence[count-1] + distancetwo[num])
						end
					}
					hastwo = true
				end
				count += 1
			}
			positionFence.map! { |pos| pos.is_a?(Array) ? pos[0] : pos }
			positionFence.compact!
			@positionFence = []
			12.times { @positionFence << positionFence.clone }

			# Times, count times
			@times = []
			12.times { @times << [0, 0, 0] } # Minutes, Seconds, 1 / 10 of second
			# After 10 times of third position, second will increases 1
			# 1m = 60s
			# General (times)
			@totaltimes = [0, 0, 0]

			# Order of pokemon, rank
			# class Pokemon => Distance (pokemon walked)
			@distance = {}
			12.times { |i| @distance[@pkmn[i]] = 0 }
			@rank = []
			@rank = sort_rank(@distance)
			# Redraw (mini bar)
			@redrawmini = false

			# Stun: check if pokemon stuns
			@stun = []
			@timesStun = [] # Count-down: times is NUMBER_STUN * 2
			12.times {
				@stun << false
				@timesStun << 0
			}

			# Crash: check fence
			@crashed = []
			12.times { |i|
				@crashed[i] = []
				@positionFence.size.times { @crashed[i] << false }
			}

			# Check: pokemon passed fence
			@passed = []
			12.times { |i|
				@passed[i] = []
				@positionFence.size.times { @passed[i] << false }
			}

			# Check if pokemon finish
			@nearfinish = [false, false, false]

			# Check if result calculated
			@calculated = false

			# Check if script set y of line
			@setLine = [false, false, false]
		end

		def sort_rank(hash) = hash.sort_by(&:last).reverse.to_h.keys

		def create_sprite(spritename, filename, vp, dir="01 - Hurdle Dash")
			super(spritename, filename, vp, dir)
		end

		def set_sprite(spritename, filename, dir="01 - Hurdle Dash")
			super(spritename, filename, dir)
		end

	end

	def self.minigame_hurdle_dash(pkmn, species)
		cs = Pokeathlon::Change_Screen_Choose_pkmn
		
		score = nil
		miss  = nil
		scorespecial = nil
		scoreindividual = nil

		pbFadeOutIn {
			# Change screen
			cs.expand_num(0, Settings::SCREEN_HEIGHT)

			f = Minigame_HurdleDash.new(pkmn, species)
			f.show

			score = f.scorep
			miss  = f.missp
			scorespecial = f.scoreSpecial
			scoreindividual = f.scorePersonal

			f.endScene

			# Change screen
			cs.expand_num(Settings::SCREEN_WIDTH)
		}
		return score, miss, scorespecial, scoreindividual
	end

end