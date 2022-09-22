# Feature
module Pokeathlon
	# Count step
	STEP_APRIJUICE = 100

	class JuiceBlender
		# Max number, player can put apricorn when aprijuice mixed
		MAX_LIMIT_MIXED = 32

		def initialize
			@sprites = {}
			# Viewport
      @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z = 99999
			# Value
			@changeBottle = false
			# Define selection (kind of selection)
			@choose = 0
			# Apricorn
			arr = []
			GameData::Item.each { |i| arr << i.id if GameData::Item.get(i.id).is_apricorn? }
			@apricorn = []
			arr.each { |apricorn| @apricorn << apricorn if $PokemonBag.pbHasItem?(apricorn) }
			# Finish
			@exit = false
		end

	end

	def self.juice_blender
		pbFadeOutIn {
			f = JuiceBlender.new
			f.show
			f.endScene
		}
	end

end

# Create item
ItemHandlers::UseFromBag.add(:JUICEBLENDER,proc{|item|
	Pokeathlon.juice_blender
	next 1
})
EventHandlers.add(:on_player_step_taken_can_transfer, :aprijuice,
  proc {
	if $PokemonGlobal.apricorn_juice_first.size > 0
		$PokemonGlobal.apricorn_juice_step += 1
		$PokemonGlobal.apricorn_juice_can_count = true if $PokemonGlobal.apricorn_juice_step % Pokeathlon::STEP_APRIJUICE == 0
		if $PokemonGlobal.apricorn_juice_can_count
			$PokemonGlobal.apricorn_juice_can_count  = false
			$PokemonGlobal.apricorn_juice_mildness  += 1
		end
	end
})