module PokegearHGSS
	class Show

		#-------#
		# Input #
		#-------#
		# Put this in loop, add Input.update to use
		def input_bar
			if checkInput(Input::BACK)
				@chosebar = !@chosebar
				return if @chosebar
				# Re-create
				chose_icon
			end
			return if !@chosebar
			# Input
			if checkInput(Input::USE)
				# Return if not change
				return if storeIcon(@posfeature, false, true)[@poscuricon] == @storeposfeature && !(@poscuricon == 0 && storeIcon[@poscuricon] == "Prev")
				change_feature_when_press
			end
			# Store content of icon
			icon = storeIcon
			if checkInput(Input::LEFT)
				@poscuricon -= 1
				@poscuricon  = icon.size - 1 if @poscuricon < 0
			elsif checkInput(Input::RIGHT)
				@poscuricon += 1
				@poscuricon  = 0 if @poscuricon >= icon.size
			end
		end

		#-------#
		# Mouse #
		#-------#
		# Check mouse when choosing bar or not
		def mouse_bar?
			x = 0
			y = @sprites["bar"].y
			w = @sprites["bar"].src_rect.width
			h = @sprites["bar"].src_rect.height
			return true if areaMouse?([x, y, w, h])
			return false
		end

		# Return number of icon when choosing
		def mouse_pos_icon
			@storeposicon.size.times { |i| return i if areaMouse?(@storeposicon[i]) }
			return nil
		end

		# Check when using mouse (use in loop)
		# Add Input.update if using
		def mouse_use_on_bar
			# Delay
			delayMouse
			if @delay > DelayMouse
				# Check chose bar
				chose = mouse_bar?
				# Check position of icon
				if @chosebar
					pos = mouse_pos_icon
					@poscuricon = pos if pos
				end
			end
			# Click
			if clickedMouse?
				(@chosebar = chose.nil? ? false : chose) if !pos
				if !@chosebar
					# Re-create
					chose_icon
					return
				end
				# Return if not change
				return if storeIcon(@posfeature, false, true)[@poscuricon] == @storeposfeature
				change_feature_when_press
			end
		end

		# Change features when player presses button or clicks
		def change_feature_when_press
			# Store content of icon
			icon = storeIcon
			case @poscuricon
			# First
			when 0
				if icon[@poscuricon] == "Prev"
					@posfeature = @feature.size - 2 if icon[icon.size-1] == "Exit" && @posfeature == @feature.size - 1
					@posfeature -= 1
					# Re-create
					create_mini_bar
				else
					@posfeature = 0
					# Check change
					@changed = true
				end
			# Last but one
			when icon.size - 1
				case icon[@poscuricon]
				when "Next"
					@posfeature  = icon.size - 3 if @posfeature < icon.size - 3
					@posfeature += 1
					# Re-create
					create_mini_bar
				when "Exit"
					@posfeature = @feature.size
					# Check change
					@exit = true
				end
			# Other (number)
			else
				@posfeature = storeIcon(@posfeature, false, true)[@poscuricon]
				storeIcon(@posfeature, true)
				# Check change
				@changed = true
			end
		end

	end
end