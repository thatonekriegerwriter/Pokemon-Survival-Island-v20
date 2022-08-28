module BerryBlender
	class Show

		def show
			# Create
			create_scene
			# Draw name and animation
			draw_name
			# Fade
			pbFadeInAndShow(@sprites) { update }
			# Choose berry
			notplay = false
			berry   = nil
			loop do
				berry = BerryPoffin.playerChoosed
				if berry.nil? || berry == 0
					notplay = !pbConfirmMessage(_INTL("Do you want to choose again?"))
					break if notplay
				else
					break
				end
			end
			return if notplay
			# Set berry
			@berry << berry
			if @player == 4
				@berry << BerryPoffin.randomExpert
			else
				@player.times { @berry << BerryPoffin.random }
			end
			# Animation berry
			@berry.each_with_index { |b, i| animationBerry(b, i) }
			# Zoom
			zoom_circle_before_start
			# Count
			count_and_start
			loop do
				update_ingame
				break if @exit
				# Fade
				fade_out if @countFade == 2
				# Update
				update_main
				# Draw text
				draw_main
				# Input
				set_input
				# Increase frames
				@frames += 1
			end
		end

		#--------------#
		# Create scene #
		#--------------#
		def create_scene
			# Create scene
			create_sprite("behind", "Behind", @viewport)
			# Create time bar
			create_sprite("time bar", "Time", @viewport)
			x = 188 - @sprites["time bar"].bitmap.width
			y = 5
			set_xy_sprite("time bar", x, y)
			# Last is player and special
			arr = ["OnePlayer", "TwoPlayers", "ThreePlayers", "FourPlayers", "TwoPlayers"]
			create_sprite("scene", arr[@player], @viewport)
			# Name text (playing)
			create_sprite_2("name text", @viewport)
			# Speed text (playing)
			create_sprite_2("speed text", @viewport)
			# Create circle
			create_sprite("circle", "Circle", @viewport)
			ox = @sprites["circle"].bitmap.width / 2
			oy = @sprites["circle"].bitmap.height / 2
			set_oxoy_sprite("circle", ox, oy)
			x = Graphics.width / 2
			y = Graphics.height / 2
			set_xy_sprite("circle", x, y)
			set_zoom_sprite("circle", 3, 3)
			set_visible_sprite("circle")
			# Create number
			create_sprite("number icon", "1", @viewport)
			ox = @sprites["number icon"].bitmap.width / 2
			oy = @sprites["number icon"].bitmap.height / 2
			set_oxoy_sprite("number icon", ox, oy)
			set_xy_sprite("number icon", x, y)
			set_visible_sprite("number icon")
			# Start (image)
			create_sprite("start icon", "Start", @viewport)
			ox = @sprites["start icon"].bitmap.width / 2
			oy = @sprites["start icon"].bitmap.height / 2
			set_oxoy_sprite("start icon", ox, oy)
			set_xy_sprite("start icon", x, y)
			set_visible_sprite("start icon")
			# Effect
			draw_effect
			# Result (scene)
			create_sprite("result scene", "results", @viewport)
			set_visible_sprite("result scene")
			# Text
			create_sprite_2("result text", @viewport)
			create_sprite_2("result icon text", @viewport)
		end

		#----------------#
		# Zoom in circle #
		#----------------#
		def zoom_circle_before_start
			set_visible_sprite("circle", true)
			num = 0.5
			4.times { |i|
				update_ingame
				@sprites["circle"].zoom_x -= num
				@sprites["circle"].zoom_y -= num
			}
		end

		#----------------#
		# Count to start #
		#----------------#
		def count_and_start
			number = 2
			pbWait(30)
			set_visible_sprite("number icon", true)
			pbSEPlay("Berry Blender Countdown", 100, 100)
			pbWait(30)
			2.times { |i|
				update_ingame
				set_sprite("number icon", "#{number}")
				pbSEPlay("Berry Blender Countdown", 100, 100)
				pbWait(30)
				number += 1
			}
			set_visible_sprite("number icon")
			set_visible_sprite("start icon", true)
			pbSEPlay("Berry Blender Start", 100, 100)
			pbWait(30)
			set_visible_sprite("start icon")
		end

		#---------------------------------#
		# Set feature perfect, good, miss #
		#---------------------------------#
		# pos: define player
		# angle: angle to define position of bitmap
		def angle_circle(method, angle, pos=0)
			case method
			# Perfect
			when :perfect
				# Increase feature
				@count[@name[pos]][:perfect] += 1
				# Update speed
				update_speed_increse(6)
				# Show effect
				@showEffect = true
				# Update time bar
				update_time_bar(6)
				# Draw bitmap
				draw_perfect_good_miss(angle, 0, pos)
				pbSEPlay("Berry Blender Perfect", 100, 100)
			# Good
			when :good
				# Increase feature
				@count[@name[pos]][:good] += 1
				# Update speed
				update_speed_increse(2)
				# Update time bar
				update_time_bar(3)
				# Draw bitmap
				draw_perfect_good_miss(angle, 1, pos)
				pbSEPlay("Berry Blender Good", 100, 100)
			# Miss
			when :miss
				# Increase feature
				@count[@name[pos]][:miss] += 1
				# Update speed
				update_speed_decrease(3)
				# Draw bitmap
				draw_perfect_good_miss(angle, 2, pos)
				pbSEPlay("Berry Blender Miss", 100, 100)
			end
		end

		# Draw bitmap #
		FEATURE_VISIBLE_FALSE = 5
		def draw_perfect_good_miss(angle, feature=0, pos=0)
			arr  = ["Perfect", "Good", "Miss"]
			name = feature == 0 ? :perfect : feature == 1 ? :good : :miss
			spritename = "#{arr[feature]} #{@count[@name[pos]][name]}"
			return if @sprites[spritename]
			create_sprite(spritename, arr[feature], @viewport)
			ox = @sprites[spritename].bitmap.width / 2
			oy = @sprites[spritename].bitmap.height / 2
			set_oxoy_sprite(spritename, ox, oy)
			x = angle == 40 || angle == 140 ? 186 : 326
			y = angle == 40 || angle == 320 ? 113 : 271
			set_xy_sprite(spritename, x, y)
			@showFeature[@name[pos]][name] << FEATURE_VISIBLE_FALSE
		end

		# Draw effect when press perfect #
		def draw_effect
			2.times { |j|
				10.times { |i|
					create_sprite("effect #{j} #{i}", "Effect_#{j+1}", @viewport)
					ox = @sprites["effect #{j} #{i}"].bitmap.width / 2
					oy = @sprites["effect #{j} #{i}"].bitmap.height / 2
					set_oxoy_sprite("effect #{j} #{i}", ox, oy)
					set_visible_sprite("effect #{j} #{i}")
				}
			}
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

	end
end