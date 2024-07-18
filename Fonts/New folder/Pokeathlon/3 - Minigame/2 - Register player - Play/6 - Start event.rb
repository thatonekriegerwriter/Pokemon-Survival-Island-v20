module Pokeathlon
	class Play_Athlon

		#------------#
		# Background #
		#------------#
		# Set background and anything related to it
		def show_start_event(str="", first=false)
			set_sprite("bg start event", "Start event", "00 - Main") if first
			set_visible_sprite("bg start event", true)
			draw_start_finish_event(false, str)
		end

		#------------------#
		# Draw information #
		#------------------#
		def start_show_infor_course(graphicname)
			set_sprite("bg each event", graphicname)
			ox = @sprites["bg each event"].bitmap.width  / 2
			oy = @sprites["bg each event"].bitmap.height / 2
			set_oxoy_sprite("bg each event", ox, oy)
			x = Settings::SCREEN_WIDTH / 2
			y = 168 + oy
			set_xy_sprite("bg each event", x, y)
			zoom = 5
			set_zoom_sprite("bg each event", zoom, zoom)
			set_visible_sprite("bg each event")
			set_visible_sprite("bg start event", true)
			@sprites["black"].opacity = 255
		end

		def animation_show_infor_course
			set_visible_sprite("bg each event", true)
			zoom = 5
			16.times {
				update_ingame
				zoom -= 0.25
				set_zoom_sprite("bg each event", zoom, zoom)
			}
		end

		# All of draw information (start event)
		def step_draw_infor_each_course(graphicname)
			start_show_infor_course(graphicname)
			fade_out
			# Wait
			pbWait(10)
			animation_show_infor_course
		end

		#-------------#
		# Description #
		#-------------#
		# Just graphic
		def show_description(eventname)
			set_sprite("descrip event", eventname, "00 - Main")
			set_visible_sprite("descrip event", true)
		end

		# After show information
		def hide_start_things
			set_visible_sprite("bg start event")
			set_visible_sprite("descrip event")
			set_visible_sprite("bg each event")
			clearTxt("event text")
		end

		# Wait to read
		def wait_to_read_guide
			loop do
				update_ingame
				break if checkInput(Input::USE) || checkInput(Input::BACK)
			end
		end

	end
end