module Pokeathlon
	# If set true, screen will expand to right. If not, screen will expand to down
	# Don't touch it
	SHOW_WIDTH = true

	class ShowStatsInMenu < FeedJuice
		attr_reader :fade
		
		def initialize
			@sprites = {}
			# Viewport
      @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z = 99999
			# Value
			@pkmn = {}
			@fade = false
		end

		#----------#
		# Set x, y #
		#----------#
		def set_xy_sprite(spritename,x,y)
			SHOW_WIDTH ? (x += Settings::SCREEN_WIDTH) : (y += Settings::SCREEN_HEIGHT)
			@sprites["#{spritename}"].x = x
			@sprites["#{spritename}"].y = y
		end

		#------#
		# Fade #
		#------#
		def fade_in
			return if @fade
			numFrames = (Graphics.frame_rate*0.4).floor
  		alphaDiff = (255.0/numFrames).ceil
			(0..numFrames).each { |i|
				@viewport.color = Color.new(0, 0, 0, i * alphaDiff)
				pbWait(1)
			}
			@fade = true
		end

		def fade_out
			return unless @fade
			numFrames = (Graphics.frame_rate*0.4).floor
  		alphaDiff = (255.0/numFrames).ceil
			(0..numFrames).each { |i|
				@viewport.color = Color.new(0, 0, 0, (numFrames - i) * alphaDiff)
				pbWait(1)
			}
			@fade = false
		end

		#------#
		# Main #
		#------#
		def create_custom(pkmn, medal)
			return unless pkmn
			return if pkmn == Settings::MAX_PARTY_SIZE
			return if @sprites["pkmn"]
			@pkmn[:index] = pkmn
			pkmn = $player.party[pkmn]
			return unless pkmn.able?
			@pkmn[:name] = pkmn
			# Scene
			create_scene
			# Play cry
			cry_pkmn
			# Update
			update_marking
			# Draw text
			draw_information(true)

			# Draw medal
			return unless medal
			create_sprite("bar medal", "Bar Medal", @viewport)
			set_xy_sprite("bar medal", 0, 0)
			5.times { |i|
				create_sprite("medal #{i}", "Medal", @viewport)
				w = @sprites["medal #{i}"].bitmap.width / 5
				h = @sprites["medal #{i}"].bitmap.height
				set_src_wh_sprite("medal #{i}", w, h)
				x = i * w
				set_src_xy_sprite("medal #{i}", x, 0)
				x = 60 + i * w
				set_xy_sprite("medal #{i}", x, 0)
				set_visible_sprite("medal #{i}", false)
			}
		end

		def update_main(pkmn=nil, medal=false)
			if !pkmn || pkmn == Settings::MAX_PARTY_SIZE || !$player.party[pkmn].able?
				fade_in
				return
			end
			# Create
			create_custom(pkmn, medal)
			# Update
			update
			# Check pokemon
			if pkmn != @pkmn[:index]
				@pkmn[:index] = pkmn
				@pkmn[:name]  = $player.party[pkmn]
				# Update graphics
				update_pkmn
				# Play cry
				cry_pkmn
			end
			# Update
			update_marking
			# Draw text
			draw_information(true)
			# Update star
			update_star(12)

			# Update medal of each pokemon
			5.times { |i| set_visible_sprite("medal #{i}", @pkmn[:name].athlon_medal[i]) } if medal

			# Fade
			fade_out if @fade
		end

	end

	def self.chose_not_condition
		ret = -1
		pbFadeOutIn {
			# Expand
			Change_Screen_Choose_pkmn.expand

			scene  = Party_Scene_Athlon.new
			screen = PartyScreen_Athlon.new(scene, $player.party)
			screen.pbStartScene(_INTL("Choose pokemon to feed"), false)
			loop do
				chosen = screen.pbChoosePokemon
				break if chosen < 0
				pokemon = $player.party[chosen]
				if pokemon.egg?
					pbMessage(_INTL("Eggs can't eat.")) { screen.pbUpdate }
				else
					ret = chosen
					break
				end
			end

			# Narrow
			Change_Screen_Choose_pkmn.narrow

			screen.pbEndScene
		}
		return ret
	end

	def self.chose_condition(number, medal=false)
		ret = nil
		pbFadeOutIn {
			# Expand
			Change_Screen_Choose_pkmn.expand
			
			scene  = Party_Scene_Athlon.new
			screen = PartyScreen_Athlon.new(scene, $player.party)
			# show = ShowStatsInMenu.new
			ret = screen.pbPokemonMultipleEntryScreenEx(number, medal)

			# Narrow
			Change_Screen_Choose_pkmn.narrow

			screen.pbEndScene
		}
		return ret
	end

end