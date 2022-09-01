module PkmnAR
	class Show

		#-------------#
		# Check delay #
		#-------------#
		def delayMouse(num=1)
			m = self.posMouse
			@delay += 1
			@delay  = 0 if @oldm!=m && @delay>num
			return true if @delay<num
			@oldm = m
			return false
		end

		#-------#
		# Click #
		#-------#
		# Old: pbClickSprite
		def click_sprite_zoom(name)
			5.times { |i|
				update_ingame
				@sprites["#{name}"].zoom_x -= 0.1 ** (i + 1)
				@sprites["#{name}"].zoom_y -= 0.1 ** (i + 1)
			}
			5.times { |i|
				update_ingame
				@sprites["#{name}"].zoom_x += 0.1 ** (i + 1)
				@sprites["#{name}"].zoom_y += 0.1 ** (i + 1)
			}
		end

		def check_mouse
			return :back if pixelMouse?(@sprites["back"])
			case @bg
			when 0
				return :feed if pixelMouse?(@sprites["feed"])
				return :switch if pixelMouse?(@sprites["switch"])
				if @feedshow && @item.size > 0
					return :mouse_on_bar if areaMouse?([90, @sprites["feed"].y - @sprites["feedshow"].oy, Graphics.width - 90, @sprites["feedshow"].src_rect.height])
				end
			when 1 then 6.times { |i| return i if circleMouse?([42+i*76, 201, 57/2.0]) }
			end
			# Reset when mouse isn't on feed show (feed bar)
			@movem[:feedshow] = @oldm.clone
			@time[:feedshow]  = 0
			# Other case
			return nil
		end

	end
end