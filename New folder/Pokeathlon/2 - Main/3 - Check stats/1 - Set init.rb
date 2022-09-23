module Pokeathlon

	class CheckStats

		def initialize
			@sprites = {}
			# Viewport
      @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z = 99999
			# Value
			@pkmn = {}
			@pkmn[:size] = $player.party.size
			$player.party.each_with_index { |pkmn, i|
				next if pkmn.egg?
				@pkmn[:name]  = pkmn
				@pkmn[:index] = i
				break
			}
			# Check to change
			@pkmn[:party] = $player.party.map { |pkmn| !pkmn.egg? }
			@position = @pkmn[:index]
			# Finish
			@exit = false
		end

	end

	def self.check_stats
		if $player.party.size == 0
			pbMessage(_INTL("You don't have any pokemon."))
			return
		end
		allegg = $player.party.count { |pkmn| pkmn.egg? }
		if allegg == $player.party.size
			pbMessage(_INTL("Your pokemons are egg."))
			return
		end
		pbFadeOutIn {
			f = CheckStats.new
			f.show
			f.endScene
		}
	end

end