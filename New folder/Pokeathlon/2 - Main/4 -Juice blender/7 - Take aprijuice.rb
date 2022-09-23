module Pokeathlon
	class JuiceBlender

		#------------#
		# Take juice #
		#------------#
		def choose_feature_1_choose_2
			return if @choose != 2
			update_message("Choose pokemon to feed it.")

			if $player.party.size == 0
				update_message("You don't have any pokemon")
				@choose = 0
				return
			end
			# Feed pokemon
			ret = Pokeathlon.chose_not_condition
			# Break
			if ret < 0
				update_message("Oh! Take it next times.")
				@choose = 0
				return
			end

			# Calculate, here
			# Add new stats
			first  = $PokemonGlobal.apricorn_juice_strongest_first
			second = $PokemonGlobal.apricorn_juice_strongest_second
			third  = $PokemonGlobal.apricorn_juice_strongest_third
			last   = $PokemonGlobal.apricorn_juice_strongest_lowest
			sum = $PokemonGlobal.apricorn_juice_flavor.inject(:+)
			sum = 100 if sum > 100
			arr = [first, second, third, last, sum]

			# Show scene
			Pokeathlon.feed_juice_feed($player.party[ret], ret) {
				$player.party[ret].athlon_feed_juice = false
				$player.party[ret].athlon_daily, $player.party[ret].athlon_change = Pokeathlon.calc_flavor_all($player.party[ret], arr)
				$player.party[ret].athlon_normal_changed = Pokeathlon.real_stats($player.party[ret])
				# Set feed
				$player.party[ret].athlon_feed_juice = true
				# Update bottle
				set_src_xy_sprite("bottle", 0, 0)
			}
			
			# Reset global
			reset_global

			# Return
			@choose = 0
		end

		def reset_global
			$PokemonGlobal.apricorn_juice_step          = 0
			$PokemonGlobal.apricorn_juice_chose         = []
			$PokemonGlobal.apricorn_juice_first         = []
			$PokemonGlobal.apricorn_juice_chose_first   = false
			$PokemonGlobal.apricorn_juice_put           = 0
			$PokemonGlobal.apricorn_juice_flavor        = [0, 0, 0, 0, 0]
			$PokemonGlobal.apricorn_juice_mildness      = 0
			$PokemonGlobal.apricorn_juice_can_count     = false
			$PokemonGlobal.apricorn_juice_not_boost     = [true, true, true, true, true]
			$PokemonGlobal.apricorn_juice_strongest_100 = false
			$PokemonGlobal.apricorn_juice_strongest_first  = nil
			$PokemonGlobal.apricorn_juice_strongest_second = nil
			$PokemonGlobal.apricorn_juice_strongest_third  = nil
			$PokemonGlobal.apricorn_juice_strongest_lowest = nil
		end

	end
end