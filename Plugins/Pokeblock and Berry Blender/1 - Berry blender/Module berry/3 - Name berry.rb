class PokemonGlobalMetadata
  attr_accessor :berry_blender

	alias berry_blender_ini initialize
  def initialize
		berry_blender_ini
		@berry_blender = {}
		arr = [
			"Red",    "Blue",   "Pink",  "Green",     "Yellow",
			"Purple", "Indigo", "Brown", "Lite Blue", "Olive",
			"Gold", "Black", "White", "Gray"
		]
		arr.each { |i|
			@berry_blender[i] = {
				flavor: [],
				sheen: [],
				level: []
			}
		}
	end

end