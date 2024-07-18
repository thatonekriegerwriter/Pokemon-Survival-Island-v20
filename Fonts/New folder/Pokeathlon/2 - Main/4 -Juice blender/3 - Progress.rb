module Pokeathlon
	class JuiceBlender

		def  show
			# Create
			create_scene
			loop do
				update_ingame
				break if @exit
				# Choose
				choose_feature_main
			end
		end

		def create_scene
			create_sprite("bg", "Scene", @viewport)
			@sprites["stripes"] = AnimatedPlane.new(@viewport)
			@sprites["stripes"].setBitmap("Graphics/Pokeathlon/Apriblender/Stripes")
			# Bottle of aprijuice
			create_sprite("bottle", "Bottle", @viewport)
			w = @sprites["bottle"].bitmap.width / 6
			h = @sprites["bottle"].bitmap.height
			set_src_wh_sprite("bottle", w, h)
			# Set src-rect x
			update_graphics_bottle
			x = (Graphics.width - w) / 2
			y = (Graphics.height - h) / 2
			set_xy_sprite("bottle", x, y)
			# Lid
			create_sprite("lid", "Lid", @viewport)
			w = @sprites["lid"].bitmap.width / 2
			h = @sprites["lid"].bitmap.height
			set_src_wh_sprite("lid", w, h)
			x = @sprites["bottle"].x + 6
			y = @sprites["bottle"].y + 16 - @sprites["lid"].src_rect.height
			set_xy_sprite("lid", x, y)
			# Description
			arr = arr_choose_feature_first
			@sprites["textbox"] = pbCreateMessageWindow
			@sprites["textbox"].letterbyletter = false
			@sprites["textbox"].text = arr[0][1]
			# Window
			create_mess_window(arr.map(&:first))
		end

		def create_mess_window(commands)
			# List
			dispose("cmdwindow") if @sprites["cmdwindow"]
			@sprites["cmdwindow"] = Window_CommandPokemonEx.new(commands)
			cmdwindow = @sprites["cmdwindow"]
			cmdwindow.resizeToFit(commands)
			cmdwindow.viewport = @viewport
			set_visible_sprite("cmdwindow", true)
		end

	end
end