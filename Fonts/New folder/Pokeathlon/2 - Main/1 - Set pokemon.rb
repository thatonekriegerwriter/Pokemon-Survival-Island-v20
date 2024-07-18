class Pokemon
	# speed, power, skill, stamina and jump (max, normal)
	attr_accessor :athlon_max, :athlon_normal, :athlon_normal_changed, :athlon_daily, :athlon_change
	# Check if pokemon drank
	attr_accessor :athlon_feed_juice
	# Medal of pokemon: array -> speed, power, skill, stamina and jump
	attr_accessor :athlon_medal

	alias pokeatlon_init initialize
	def initialize(species, level, owner = $player, withMoves = true, recheck_form = true)
		pokeatlon_init(species, level, owner, withMoves, recheck_form)
		# Stats (new)
		pkmn = Pokeathlon.pkmn_clone
		id   = GameData::Species.get(species).id
		if pkmn[id].nil?
			echoln "Add #{id} in file pbs of plugin Pokeathlon"
			return
		end
		@athlon_max = pkmn[id][:max].nil? ? [rand(5)+1, rand(5)+1, rand(5)+1, rand(5)+1, rand(5)+1] : pkmn[id][:max]

		# Check error - Maximum
		error = "Maximum check - Error"
		@athlon_max.each_with_index { |s, i|
			next if s.between?(1, 5)
			error += "-- #{id}'stats is less than or equal to 0, position: #{i} --" if s <= 0
			error += "-- #{id}'stats is greater than 5, position: #{i} --" if s > 5
		}
		echoln error if error != "Maximum check - Error"

		if pkmn[id][:min].nil?
			arr = []
			@athlon_normal = []
			@athlon_max.each { |i| arr << (rand(i) + 1) }
			@athlon_normal = arr
			@athlon_normal_changed = arr
		else
			@athlon_normal = pkmn[id][:min]
			@athlon_normal_changed = pkmn[id][:min]
		end

		# Check error - Normal
		error = "Normal check - Error"
		@athlon_normal.each_with_index { |s, i|
			next if s.between?(1, 5)
			error += "-- #{id}'stats is less than or equal to 0, position: #{i} --" if s <= 0
			error += "-- #{id}'stats is greater than 5, position: #{i} --" if s > 5
			error += "-- #{id}'stats is greater than maximum number '#{@athlon_max[i]}', position: #{i} --" if s > @athlon_max[i]
		}
		echoln error if error != "Normal check - Error"

		# Set to increase or decrease
		@athlon_daily  = [0, 0, 0, 0, 0]
		@athlon_change = [0, 0, 0, 0, 0]
		# Check if pokemon drank aprijuice
		@athlon_feed_juice = false
		# Change stats if it's necessaire
		change_form_pokeathlon_stats

		# Store medal if pokemon got it
		# Course: speed, power, skill, stamina and jump
		@athlon_medal = [false, false, false, false, false]
	end

	def change_form_pokeathlon_stats
		return if @form == 0
		id   = GameData::Species.get(@species).id
		form = Pokeathlon.form_clone
		return if form[id].nil?
		pkmn = form[id]
		arr  = []
		# Check if change stats
		change = false
		pkmn.each { |k, _|
			arr = k
			next unless arr.include?(@form)
			change = true
			break
		}
		return unless change
		@athlon_max = pkmn[arr][:max]
		@athlon_normal = pkmn[arr][:min]
	end

	alias pokeathlon_calc_stats calc_stats
	def calc_stats
		pokeathlon_calc_stats
		# Change stats if it's necessaire
		change_form_pokeathlon_stats
	end

	def reset_pokeathlon_ate_juice
		@athlon_daily  = [0, 0, 0, 0, 0]
		@athlon_change = [0, 0, 0, 0, 0]
		@athlon_normal_changed = @athlon_normal.clone
		@athlon_feed_juice = false
	end
end