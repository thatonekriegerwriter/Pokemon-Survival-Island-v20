module Pokeathlon

	class FeedJuice < CheckStats

		def initialize(chose=true, pkmn=nil, index=0)
			@sprites = {}
			# Viewport
      @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z = 99999
			# Value
			@pkmn = {}
			if chose
				if pkmn.nil?
					echoln "pkmn is nil. Check Pokeathlon.feed_juice_feed(pkmn)"
					return
				end
				@pkmn[:name]  = pkmn
				@pkmn[:index] = index
			else
				register_pkmn
			end
			# Finish
			@exit = false
		end

		def register_pkmn
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
		end

	end

	def self.feed_juice_show
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
			f = FeedJuice.new(false)
			f.show
			f.endScene
		}
	end

	def self.feed_juice_feed(pkmn=nil, index=0, &block)
		pbFadeOutIn {
			f = FeedJuice.new(true, pkmn, index)
			f.show2(&block)
			f.endScene
		}
	end

end