module Pokeathlon
	class Minigame_BlockSmash < Minigame_Main

		def initialize(pkmn, species)
			super()

			# class Pokemon
			@pkmn = pkmn.clone
			# ID of pokemon
			@species = species.clone

			# Score (use in event - general)
			4.times {
				@scoreSpecial << 0
				@scorep << 0
			}

			# Original
			# Use stats to calculate
			@oriPower   = []
			@oriSkill   = []
			@oriStamina = []
			@pkmn.each { |pk|
				@oriPower << pk.athlon_normal_changed[1].clone   # Efficiency (Stamina used per Hit)
				@oriSkill << pk.athlon_normal_changed[2].clone   # Ability to smash blocks (Quantity of Hits to smash a Block)
				@oriStamina << pk.athlon_normal_changed[3].clone # Endurance
			}
			# Convert into numbers
			# Each hit decreases this number
			num = []
			6.times { |i| num << (6 - i) }
			@oriPower.map! { |st| num[st] }
			# Number (quantity of hits)
			# Decrease % hp of blocks -> 1.0 / number * 100
			num = []
			6.times { |i| num << (6 - i) }
			@oriSkill.map! { |st| num[st] }
			# Stamina of pokemon (1 hits = 1 power (array))
			num = []
			6.times { |i| num << (10 + 30 * i) }
			@oriStamina.map! { |st| num[st] }

			# Order of pokemon
			# Use to check next pokemon
			@orderPkmn = []
			4.times { |i|
				@orderPkmn[i] = {
					pkmn: [],
					power: [],
					skill: [],
					stamina: [],
					position: []
				}
				3.times { |j|
					@orderPkmn[i][:pkmn] << @pkmn[3*i+j]
					@orderPkmn[i][:power] << @oriPower[3*i+j]
					@orderPkmn[i][:skill] << @oriSkill[3*i+j]
					@orderPkmn[i][:stamina] << @oriStamina[3*i+j]

					# Use to define position: 0, 1, 2, 3, 4, etc to calculate @scorePersonal
					@orderPkmn[i][:position] << 3 * i + j
				}
			}
			# When stamina has 25%, switch will be red (change color) and when stamina has 0%, it's black (change src_rect)

			# Blocks
			# If 0, block smash
			@blocksHP = []
			4.times { |i|
				@blocksHP[i] = []
				10.times { @blocksHP[i] << 100 }
			}
			# If true, block smashed
			@blocks = []
			4.times { |i|
				@blocks[i] = []
				10.times { @blocks[i] << false }
			}
			# Define position of blocks
			@posBlockSmash = []
			4.times { @posBlockSmash << 0 }
			# Trigger: @blocks[position][position2] = true
			# If 0, doesn't show block smashed
			@store[:wait_show_smashed_block] = 2
			@smashBlock = []
			4.times { |i|
				@smashBlock[i] = []
				10.times { @smashBlock[i] << @store[:wait_show_smashed_block] }
			}
			# Blocks icon (right screne)
			# If true, show blocks smashed
			# 1 block = 10 blocks smashed
			@blocksIcon = []
			4.times { |i|
				@blocksIcon[i] = []
				20.times { @blocksIcon[i] << false }
			}

			# Wait when add new block
			@store[:wait_add] = 4
			@waitAdd = []
			@triggerAdd = []
			4.times { |i|
				@triggerAdd << false
				@waitAdd[i] = []
				10.times { @waitAdd[i] << @store[:wait_add] }
			}

			# Time (to play this course) - Real = @times * @second
			# Decrease @second -> @second = 0 -> @times -= 1
			@times = 30
			@betweenT = 60
			@second = @betweenT
			
			# Wait to change pokemon (show bitmap - smoke)
			@waitChange = []
			@store[:wait_change] = 8
			# Check change to show bitmap
			@triggerChange = []
			4.times {
				@waitChange << @store[:wait_change]
				@triggerChange << false
			}

			# Boost:
			# 2 boosts
			# 	1. Smash immediately (4 blocks)
			# 	2. Smash immediately (4 blocks) - Not decrease stamina
			@smashImmediately = [2, 4] # [cracks, boost (many cracks)]
			@boost = []
			4.times { @boost << 0 }
			# After this, pokemon can't have this boost
			@timeBoost = [20, 10]
			@timeBoostParty = []
			4.times { |i| @timeBoostParty << 0 }
			# Store: quantity of cracks (touched) to get boost
			@gotCracks = []
			4.times { @gotCracks << 0 }
			@quantCracks = [2, 6]

			# Check stun of pokemon
			@stun = []
			@timeStun = []
			@store[:time_stun] = 5 * 2
			4.times {
				@stun << false
				@timeStun << @store[:time_stun]
			}

		end

		def create_sprite(spritename, filename, vp, dir="04 - Block Smash")
			super(spritename, filename, vp, dir)
		end

		def set_sprite(spritename, filename, dir="04 - Block Smash")
			super(spritename, filename, dir)
		end

		def clickedMouse?
			return true if Input.count(Input::MOUSERIGHT) > 0 || Input.count(Input::MOUSELEFT) > 0
			return false
		end

	end

	def self.minigame_block_smash(pkmn, species)
		cs  = Pokeathlon::Change_Screen_Choose_pkmn
		old = Graphics.width == Settings::SCREEN_WIDTH * 2 && Graphics.height == Settings::SCREEN_HEIGHT

		score = nil
		miss  = nil
		scorespecial = nil
		scoreindividual = nil

		pbFadeOutIn {
			# Change screen
			cs.expand_num(Settings::SCREEN_WIDTH, 0) unless old

			f = Minigame_BlockSmash.new(pkmn, species)
			f.show

			score = f.scorep
			miss  = f.missp
			scorespecial = f.scoreSpecial
			scoreindividual = f.scorePersonal

			f.endScene
		}
		return score, miss, scorespecial, scoreindividual
	end
end