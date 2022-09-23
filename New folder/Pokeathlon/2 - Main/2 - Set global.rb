class PokemonGlobalMetadata
	attr_accessor :apricorn_juice_step, :apricorn_juice_chose, :apricorn_juice_first, :apricorn_juice_chose_first
	attr_accessor :apricorn_juice_put, :apricorn_juice_flavor, :apricorn_juice_mildness, :apricorn_juice_can_count
	attr_accessor :apricorn_juice_not_boost, :apricorn_juice_strongest_100
	attr_accessor :apricorn_juice_strongest_first, :apricorn_juice_strongest_second, :apricorn_juice_strongest_third, :apricorn_juice_strongest_lowest

	attr_accessor :athlon_sum_points, :athlon_points_play

	alias pokeathlon_step initialize
	def initialize
		# Old
		pokeathlon_step

		# Count step
		# Each 100 steps, increase mildness
		@apricorn_juice_step = 0

		# Store when player add new apricorn
		@apricorn_juice_chose = []

		# Store first time, player put it
		@apricorn_juice_first = []
		@apricorn_juice_chose_first = false

		# Store limit, player can put apricorn after mixing
		@apricorn_juice_put = 0 # Max 12

		# Store flavor, use this to calculate (aprijuice)
		# Power, Stamina, Skill, Jump, Speed are different with PBS file: Speed, Power, Skill, Stamina and Jump
		@apricorn_juice_flavor = [0, 0, 0, 0, 0]

		# Store 'mildness', 'can count mild'
		@apricorn_juice_mildness = 0
		@apricorn_juice_can_count = false

		# Store 'not boost flavor', check when sum of flavor is greater than 100
		@apricorn_juice_not_boost = [true, true, true, true, true]
		# Check 'Define strongest when sum of flavor is greater than 100'
		@apricorn_juice_strongest_100 = false

		# Set index, strongest, second and lowest flavor
		@apricorn_juice_strongest_first  = nil
		@apricorn_juice_strongest_second = nil
		@apricorn_juice_strongest_third  = nil
		@apricorn_juice_strongest_lowest = nil

		# Store points to get item
		@athlon_sum_points  = 0 # Sum
		@athlon_points_play = 0 # Points after playing
	end
end