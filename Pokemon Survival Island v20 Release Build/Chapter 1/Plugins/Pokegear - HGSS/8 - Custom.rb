module PokegearHGSS

	# Set custom class (basic)
	class CustomFeature < Show
		attr_accessor :play
		attr_reader   :changed, :exit

		def set_value_custom(hash=nil)
			return if !hash
			if !hash.is_a?(Hash)
				self.error("Set custom with Hash! Please, read or see examples!")
				return
			end
			@custom = hash
		end

		def start(pos, list, feature)
			# Set (initialize)
			set_begin_game
			@posfeature = pos
			@list = list
			@feature = feature
			# Set sprites and viewport
			set_sprites_viewport
			# Set background
			set_bg
			# Create scene and bar (should have these lines)
			create_scene
			create_bar
			create_mini_bar(true)
			# Create (new) background and play
			create_bg_to_show
			draw_description
			create_click_button
		end

		def show
			# Fade
			chose_icon # Chose before scene appears
			pbFadeInAndShow(@sprites) { update }
			# Run
			loop do
				# Update
				update_ingame
				break if @changed || @exit || @play
				# Set layer (should have this)
				position_and_draw_layer
				# Input (should have this)
				# Keyboard
				input_bar
				# Mouse
				mouse_use_on_bar
				# Input (in custom)
				# Keyboard
				input_bg
				# Mouse
				mouse_bg
				# Set bitmap after choose
				chose_icon
			end
		end

		# Create background
		def create_bg_to_show
			subdir = @custom[:dir]
			create_sprite_detail("bg detail", "#{@custom[:bg]}", @viewport, subdir)
			x = (Graphics.width - @sprites["bg detail"].bitmap.width) / 2
			y = 50
			set_xy_sprite("bg detail", x, y)
		end

		# Create 'description'
		def draw_description
			create_sprite_2("description", @viewport)
			clearTxt("description")
			text = []
			string = @custom[:detail]
			x = @sprites["bg detail"].x + @sprites["bg detail"].bitmap.width / 2
			y = @sprites["bg detail"].y + @sprites["bg detail"].bitmap.height
			text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			drawTxt("description", text, nil, nil, 1)
		end

		# Create button to display feature
		def create_click_button
			create_sprite_detail("start", "Start Custom", @viewport)
			w = @sprites["start"].bitmap.width / 2
			h = @sprites["start"].bitmap.height
			set_src_wh_sprite("start", w, h)
			set_src_xy_sprite("start", 0, 0)
			x = @sprites["bg detail"].x + (@sprites["bg detail"].bitmap.width - w) / 2
			y = @sprites["bg detail"].y + @sprites["bg detail"].bitmap.height + @sprites["description"].bitmap.text_size(@custom[:detail]).height + 20
			set_xy_sprite("start", x, y)
			@storeclick = [x, y, w, h]
		end


		#-------#
		# Input #
		#-------#

		#-------#
		# Mouse #
		#-------#
		# Return position of each feature
		def mouse_position_of
			return true if areaMouse?(@storeclick)
			return false
		end

		# Set in 'def mouse_use_on_bar' -> Don't call again delayMouse
		def mouse_bg
			return if @chosebar
			pos = mouse_position_of if @delay > DelayMouse
			# Click
			if clickedMouse?
				return if !pos
				animate
				@play = true
			end
		end

		#----------#
		# Keyboard #
		#----------#
		# Doesn't check Input::BACK, used it to check 'chose bar'
		def input_bg
			return if @chosebar
			if checkInput(Input::USE)
				animate
				@play = true
			end
		end

		def animate
			t = 5
			loop do
				break if t <= 0
				@sprites["start"].src_rect.x = @sprites["start"].src_rect.width
				pbWait(1)
				t -= 1
			end
			@sprites["start"].src_rect.x = 0
		end

		# Finish
		def finish
			# End
			endScene
			return @posfeature
		end

	end
end