module Pokeathlon
	class Minigame_Main
		attr_accessor :scorep, :missp, :scoreSpecial, :scorePersonal

		# Set delay of mouse
		DELAY_MOUSE = 0

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
			# Fade
			@fade = false
			# Frames (check something)
			@frames = 0

			# Store value
			@store = {}
			
			# List of pokemon
			@list_pkmn_id = Pokeathlon.pkmn_id.clone

			# Use in minigame
			@scorep = []
			@missp  = []
			@scoreSpecial = []
			@scorePersonal = []
			12.times {
				@missp << 0
				@scorePersonal << 0
			}

			# Exit
			@exit = false
		end

	end
end