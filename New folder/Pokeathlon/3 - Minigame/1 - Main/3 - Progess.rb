module Pokeathlon
	class Minigame_Main

		#------#
		# Fade #
		#------#
		def fade_in(vp=@viewport)
			return if @fade
			numFrames = (Graphics.frame_rate*0.4).floor
  		alphaDiff = (255.0/numFrames).ceil
			(0..numFrames).each { |i|
				vp.color = Color.new(0, 0, 0, i * alphaDiff)
				pbWait(1)
			}
			@fade = true
		end

		def fade_out(vp=@viewport)
			return unless @fade
			numFrames = (Graphics.frame_rate*0.4).floor
  		alphaDiff = (255.0/numFrames).ceil
			(0..numFrames).each { |i|
				vp.color = Color.new(0, 0, 0, (numFrames - i) * alphaDiff)
				pbWait(1)
			}
			@fade = false
		end

		#-------#
		# Mouse #
		#-------#
		# Check delay
		def delayMouse(num=1)
			m = self.posMouse
			if m.nil?
				@oldm = nil
				return true
			end
			@delay += 1
			@delay  = 0 if @oldm != m && @delay > num
			return true if @delay < num
			@oldm = m
			return false
		end

		def check_mouse
		end

		def update_mouse
			delay = delayMouse(DELAY_MOUSE)
			return :no_mouse if delay
			return check_mouse
		end

		#--------------#
		# Announcement #
		#--------------#
		def announcement
			# Number
			create_sprite("announ num", "Count", @viewport, "00 - Main")
			w = @sprites["announ num"].bitmap.width / 3
			h = @sprites["announ num"].bitmap.height
			set_src_wh_sprite("announ num", w, h)
			set_src_xy_sprite("announ num", w * 2, 0)
			set_oxoy_sprite("announ num", w / 2, h / 2)
			set_zoom_sprite("announ num", 3, 3)
			x = Graphics.width / 2
			y = Graphics.height / 2
			set_xy_sprite("announ num", x, y)
			set_visible_sprite("announ num")
			# Start
			create_sprite("announ start", "Start", @viewport, "00 - Main")
			w = @sprites["announ start"].bitmap.width / 2
			h = @sprites["announ start"].bitmap.height / 2
			set_oxoy_sprite("announ start", w, h)
			set_zoom_sprite("announ start", 2, 2)
			x = Graphics.width / 2
			y = Graphics.height / 2
			set_xy_sprite("announ start", x, y)
			set_visible_sprite("announ start")
			# Finish
			create_sprite("announ finish", "Finish", @viewport, "00 - Main")
			w = @sprites["announ finish"].bitmap.width / 2
			h = @sprites["announ finish"].bitmap.height / 2
			set_oxoy_sprite("announ finish", w, h)
			set_zoom_sprite("announ finish", 2, 2)
			x = Graphics.width / 2
			y = Graphics.height / 2
			set_xy_sprite("announ finish", x, y)
			set_visible_sprite("announ finish")
		end

		def announcement_anim
			num = 20
			pbWait(num)
			set_visible_sprite("announ num", true)
			pbWait(num)
			2.times { |i|
				@sprites["announ num"].src_rect.x -= @sprites["announ num"].src_rect.width
				pbWait(num)
			}
			set_visible_sprite("announ num")
			set_visible_sprite("announ start", true)
			pbWait(num)
			set_visible_sprite("announ start")
		end

		#-----------------------------------------------#
		# Create sweats (use when pokemon is exhausted) #
		#-----------------------------------------------#
		def create_sweats(num=1)
			return if num < 1
			num.times { |i|
				create_sprite("sweats #{i}", "Sweats", @viewport, "00 - Main")
				w = @sprites["sweats #{i}"].bitmap.width / 2
				h = @sprites["sweats #{i}"].bitmap.height
				set_src_wh_sprite("sweats #{i}", w, h)
				set_oxoy_sprite("sweats #{i}", w / 2, h / 2)
				set_visible_sprite("sweats #{i}")
			}
		end

		#------------------------#
		# Create stun - animated #
		#------------------------#
		def create_stun_bitmap(num=1)
			return if num < 1
			num.times { |i|
				create_sprite("stun #{i}", "Stun", @viewport, "00 - Main")
				w = @sprites["stun #{i}"].bitmap.width / 3
				h = @sprites["stun #{i}"].bitmap.height
				set_src_wh_sprite("stun #{i}", w, h)
				set_oxoy_sprite("stun #{i}", w / 2, h / 2)
				set_visible_sprite("stun #{i}")
			}
		end

		#---------------#
		# Create shadow #
		#---------------#
		def create_black_shadow(num=1, big=false)
			return if num < 1
			num.times { |i|
				if big
					create_sprite("big black shadow #{i}", "Big black shadow", @viewport, "00 - Main")
					ox = @sprites["big black shadow #{i}"].bitmap.width / 2
					oy = @sprites["big black shadow #{i}"].bitmap.height / 2
					set_oxoy_sprite("big black shadow #{i}", ox, oy)
				else
					create_sprite("black shadow #{i}", "Black shadow", @viewport, "00 - Main")
					ox = @sprites["black shadow #{i}"].bitmap.width / 2
					oy = @sprites["black shadow #{i}"].bitmap.height / 2
					set_oxoy_sprite("black shadow #{i}", ox, oy)
				end
			}
		end

		#---------------#
		# Create switch #
		#---------------#
		def create_switch_icon
			create_sprite("switch icon", "Switch", @viewport, "00 - Main")
			w = @sprites["switch icon"].bitmap.width / 2
			h = @sprites["switch icon"].bitmap.height
			set_src_wh_sprite("switch icon", w, h)
		end

	end
end