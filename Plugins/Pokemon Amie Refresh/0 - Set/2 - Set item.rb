module PkmnAR
	# Set maximum of amie stats
	MAX_AMIE = 255
	# Hungry (steps)
	HUNGRY_STEP = 50
	# Set item to eat
	# You can add like example
	EAT = [
		:LAVACOOKIE, :OLDGATEAU, :CASTELIACONE, :RAGECANDYBAR, :SWEETHEART,
		:RARECANDY, :FRESHWATER, :SODAPOP, :LEMONADE, :MOOMOOMILK, :ENERGYPOWDER,
		:ENERGYROOT, :HEALPOWDER, :REVIVALHERB
	]

	# Old: feedAmie
	def self.feed(pkmn, item)
		return if pkmn.food >= 100 || pkmn.amie_stats(1) == 5
		return unless item.is_a?(Symbol)
		return unless EAT.include?(item)
		if GameData::Item.get(item).is_berry?
			ber   = GameData::BerryPlant.get(item) ? GameData::BerryPlant.get(item).hours_per_stage : 3
			aff   = ber + rand(4)
			full  = ber
			enjoy = 0
		else
			aff   = rand(4) + 3
			full  = 100
			enjoy = 0
		end
		$PokemonBag.pbDeleteItem(item)
		self.add_new_num_amie(pkmn, aff, full, enjoy)
	end

	# Changes the happiness of this Pokémon depending on what happened to change it.
	# Old: changeAmieStats
	def self.change_amie_stats(pkmn, method=nil)
    aff   = 0
    full  = 0
    enjoy = 0
		case method
		# Walk approx
		when :walk
			full  = -1
			enjoy = -1
		# Send Pokemon in to a battle
		when :send_battle
			full  = -25
			enjoy = -25
		# Feed Pokémon a whole Plain Bean
		when :feed_plain_bean
			aff  = 3
			full = rand(2) + 100
		# Feed Pokémon a whole Pattern Bean
		when :feed_pattern_bean
			aff  = 5
			full = rand(2) + 100
		# Feed Pokémon a whole Rainbow Bean
		when :feed_rainbow_bean
			aff  = 125
			full = rand(2) + 100
		# Feed Pokemon a malasada (SunMoon) or a Shirogi bread (ColMerc)
		when :feed_malasada
			full = 255
			aff  = 5
		when :feed_malasada_dislike
			full = 255
			aff  = 3
		when :feed_malasada_like
			full = 255
			aff  = 10
		# Pet Pokemon. No spots implemented due to engine limitations.
		when :pet
			aff   = rand(4) + 2
			enjoy = rand(20) + 20
		else
			pbMessage(_INTL("Unknown stat-changing method."))
		end
		self.add_new_num_amie(pkmn, aff, full, enjoy)
	end

	def self.add_new_num_amie(pkmn, aff, full, enjoy)
		pkmn.happiness += aff
		pkmn.happiness  = MAX_AMIE if pkmn.happiness > 255
		pkmn.amie_enjoyment += enjoy
		pkmn.amie_enjoyment  = MAX_AMIE if pkmn.amie_enjoyment > 255
	end

end
#-------------#
# Count steps #
#-------------#
