module Pokeblock

	class Show

		def initialize(style)
			@sprites = {}
			# Viewport
      @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z = 99999
			# Set style
			@style = style
			# Use in pokeblock
			if @style == 0
				arr = [
					"Red",    "Blue",   "Pink",  "Green",     "Yellow",
					"Purple", "Indigo", "Brown", "Lite Blue", "Olive",
					"Gold", "Black", "White", "Gray"
				]
				@flavor  = []
				@nameFla = []
				$PokemonGlobal.berry_blender.each { |k, v|
					next if v[:flavor].size == 0
					v[:flavor].size.times { |i|
						@nameFla << k
						@flavor  << [v[:flavor][i], v[:sheen][i], v[:level][i]]
					}
				}
				@flavorPos = 0
				@processPkBlock = 0
			end
			# Use in 2 cases
			@pkmn = {}
			@pkmn[:size] = $Trainer.party.size
			$Trainer.party.each_with_index { |pkmn, i|
				next if pkmn.egg? || !pkmn.able?
				@pkmn[:name]  = pkmn
				@pkmn[:index] = i
				break
			}
			@pkmn[:party] = $Trainer.party.map { |pkmn| pkmn.able? }
			@cancelButton = false
			# Count (fade)
			@countFade = 0
			@fade = false
			# Finish
			@exit = false
		end

	end

	def self.show(style=0)
		if !GameData::Item.exists?(:POKEBLOCK) || !GameData::Item.exists?(:POKENAV)
			pbMessage(_INTL("You need to add Pokeblock or Pokenav in PBS file!"))
			return
		elsif style == 0
			if GameData::Item.exists?(:POKEBLOCK) && !$PokemonBag.pbHasItem?(:POKEBLOCK)
				pbMessage(_INTL("Oh! You need to have Pokeblock!"))
				return
			end
		elsif style == 1
			if GameData::Item.exists?(:POKENAV) && !$PokemonBag.pbHasItem?(:POKENAV)
				pbMessage(_INTL("Oh! You need to have Pokenav!"))
				return
			end
		elsif $Trainer.party.size == 0
			pbMessage(_INTL("You don't have any pokemon."))
			return
		end
		allegg = 0
		$Trainer.party.each { |pkmn| allegg += 1 if pkmn.egg? }
		able = $Trainer.party.map { |pkmn| pkmn.able? }
		if allegg == $Trainer.party.size
			pbMessage(_INTL("Your pokemons are egg."))
			return
		elsif !able.include?(true)
			pbMessage(_INTL("Your pokemons doesn't play this."))
			return
		end
		pbFadeOutIn {
			f = Show.new(style)
			f.show
			f.endScene
		}
	end

end

ItemHandlers::UseFromBag.add(:POKEBLOCK,proc{|item|
	next Pokeblock.show(0) ? 1 : 0
})

ItemHandlers::UseFromBag.add(:POKENAV,proc{|item|
	next Pokeblock.show(1) ? 1 : 0
})