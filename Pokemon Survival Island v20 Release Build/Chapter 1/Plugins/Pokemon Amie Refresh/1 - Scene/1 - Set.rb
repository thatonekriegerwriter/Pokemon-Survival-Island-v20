module PkmnAR

	class Show
		# Don't touch it
		DELAY_MOUSE = 0
		# Count time
		# Maximum (cursor moves around pokemon)
		MAX_AROUND = 30

		def initialize
			@sprites = {}
			# Viewport
      @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z = 99999
			# Check mouse and use
			@oldm = [0, 0]
			@delay = 0
			# Set mouse sounds when move
			@semouse = 0
			# Value
			@pkmn = {}
			@pkmn[:size] = $Trainer.party.size
			$Trainer.party.each_with_index { |pkmn, i|
				next if pkmn.egg? || !pkmn.able?
				@pkmn[:name]  = pkmn
				@pkmn[:index] = i
				break
			}
			# Check to change
			@pkmn[:party] = $Trainer.party.map { |pkmn| pkmn.able? }

			# Set background
			@bg = 0 # 0: first, 1: second
			@bgSwitch = @pkmn[:index] # Name of bgswitch
			# Mouse
			@time  = { pkmn: 0, feedshow: 0 }
			# Comapare @oldm
			@movem = { pkmn: [0, 0], feedshow: [0, 0] }
			# Store position of pixel pkmn to check (not exact to run faster)
			@sizePkmn = [0, 0, 0, 0] # x, y, w, h

			# Set item
			@item  = [] # Store
			@itemF = [] # Show, use it
			EAT.each { |item|
				next unless $PokemonBag.pbHasItem?(item)
				@item << item
			}
			# Use to check item when player moves bar
			@posItem = 0
			# Store position of pixel item to check (not exact to run faster) - each item
			@storeItem = []
			# Store name of item to check
			@itemName = nil
			# Store numbers when items change position on feed bar
			@storeNItCPL = 0
			@storeNItCPR = 0
			
			# Count when pokemon eat
			@eatCount = 0

			# Check: open or close feedshow
			@feedshow = false
			# Check when player take or not item
			@feed = false
			# Check when cursor moves around pokemon
			@around = 0

			# Frames (animated)
			@frames   = 0
			@animated = []
			@pkmn[:size].times { @animated << 0 }
			# Fade
			@fade = false
			# Exit
			@exit = false
		end

	end

	def self.show
		if $Trainer.party.size == 0
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
		Graphics.show_cursor = false
		pbFadeOutIn {
			f = Show.new
			f.show
			f.endScene
		}
		Graphics.show_cursor = true
	end

end