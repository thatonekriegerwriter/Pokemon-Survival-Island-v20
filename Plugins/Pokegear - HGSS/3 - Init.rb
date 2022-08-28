module PokegearHGSS
	# Set class
	class Show

		def set_begin_game
			# Check mouse and use
			@oldm = [0,0]
			@delay = 0
			# Position current of icon
			@poscuricon   = nil
			@storeposicon = []
			# Set position of feature
			@posfeature = 0
			# Store @posfeature when it changed
			@storeposfeature = nil
			# Trigger when choosing bar
			@chosebar = false
			# Check when press new icon on bar
			@changed = false
			# Check if exit
			@exit = false
		end

		def set_sprites_viewport
			@sprites = {}
			# Viewport
      @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z = 99999
		end

		def set_bg
			# Store background
			@background = $PokemonGlobal.backgroundPokegear
		end

		def set_list_and_feature
			# Store list
			@list = PokegearHGSS.rList
			# Store feature
			@feature = PokegearHGSS.features
		end

		# Store value when you want to use again
		def save_bg
			$PokemonGlobal.backgroundPokegear = @background rescue 0
		end
		
	end

	# Set show
	def self.show
		# Check error
		self.error("Set MAX_ICON_BAR with number greater than 2") if MAX_ICON_BAR < 3
		if PokegearHGSS.seenGear.size <= 0
			pbMessage(_INTL("You don't have any features!"))
			return
		end
		# Start
		g = Show.new
		g.start
		#g.endScene
	end
end

#--------------------------------------------------#
#                    Set again                     #
#--------------------------------------------------#
class PokemonPokegear_Scene
	def start
		PokegearHGSS.show # New
	end
end

class PokemonPokegearScreen
  def initialize(scene)
    @scene = scene
  end
  
  def pbStartScreen
    @scene.start
  end
end