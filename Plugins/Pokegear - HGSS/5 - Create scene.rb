module PokegearHGSS
	class Show

		# Start
		def start
			# Set (initialize)
			set_begin_game
			set_bg
			set_list_and_feature
			loop do
				# Start here
				@posfeature = @list[@feature[@posfeature]][:start].start(@posfeature, @list, @feature)
				# Break
				break if @posfeature < 0 || @posfeature == @feature.size
			end
		end

		# Create layer, it is mask when you select different features
		def create_layer
			2.times { |i|
				create_sprite_2("layer #{i}", @viewport)
				@sprites["layer #{i}"].opacity = 200
				@sprites["layer #{i}"].z = 100
			}
			position_and_draw_layer
		end

		# Draw layer
		def position_and_draw_layer
			2.times { |i| clearTxt("layer #{i}") }
			w = @sprites["bar"].bitmap.width
			h = @sprites["bar"].bitmap.height
			if @chosebar
				h = Graphics.height - h
				@sprites["layer 0"].bitmap.fill_rect( 0, 0, w, h, Color.new( 181, 181, 181) )
			else
				@sprites["layer 1"].bitmap.fill_rect( 0, @sprites["bar"].y, w, h, Color.new( 181, 181, 181) )
			end
		end

		# Create bar, layer
		def create_bar
			create_sprite_bar("bar", "Bar_#{@background+1}", @viewport)
			x = 0
			y = Graphics.height - @sprites["bar"].bitmap.height
			set_xy_sprite("bar", x, y)
			@sprites["bar"].z = 50
			# Layer on screen
			create_layer
		end

		# Create mini bar
		def create_mini_bar(first=false)
			return if !@sprites["bar"]
			# Reset position of icon 
			@storeposicon = []
			file = storeIcon
			# Run
			file.size.times { |i|
				case file[i]
				when "Exit", "Next", "Prev"
					if @sprites["mini #{i}"]
						set_sprite_detail("mini #{i}", "#{file[i]}")
					else
						create_sprite_detail("mini #{i}", "#{file[i]}", @viewport)
					end
					w = @sprites["mini #{i}"].bitmap.width / 2
					h = @sprites["mini #{i}"].bitmap.height / MAX_BACKGROUND
					set_src_wh_sprite("mini #{i}", w, h)
					if !@sprites["mini #{i}"]
						y = h * @background
						set_src_xy_sprite("mini #{i}", 0, y)
					end
				else
					subdir = file[i][:dir] ? file[i][:dir] : nil
					if @sprites["mini #{i}"]
						set_sprite_mini("mini #{i}", "#{file[i][:mini]}#{@background+1}", subdir)
					else
						create_sprite_mini("mini #{i}", "#{file[i][:mini]}#{@background+1}", @viewport, subdir)
					end
					w = @sprites["mini #{i}"].bitmap.width / 2
					h = @sprites["mini #{i}"].bitmap.height
					set_src_wh_sprite("mini #{i}", w, h)
				end
				# Set position
				set_position_icon(i)
				@sprites["mini #{i}"].z = @sprites["bar"].z + 1
			}
			if first
				# Set current position
				@storeposfeature = @posfeature
				# Store value with @poscuricon
				storeIcon(@posfeature, true)
			end
		end

		# Store name to display
		def storeIcon(pos=@posfeature, value=false, storenum=false)
			return if @exit
			# Store in array 'file'
			file = []
			# Store in array 'keys', store key for check
			keys = []
			# Store number in array 'number'
			# number.size = file.size - 1
			number = []
			case @feature.size
			when 1
				file.push(@list[@feature[pos]][:graphic], "Exit")
				# Keys
				keys << @feature[pos]
				# Number
				number << pos
			when 2
				file << @list[@feature[pos]][:graphic]
				# Keys
				keys << @feature[pos]
				# Number
				number << pos
				if (pos + 1) == @feature.size
					file.unshift(@list[@feature[pos-1]][:graphic])
					# Keys
					keys.unshift(@feature[pos-1])
					# Number
					number.unshift(pos-1)
				else
					file << @list[@feature[pos+1]][:graphic]
					# Keys
					keys << @feature[pos+1]
					# Number
					number << (pos+1)
				end
				file << "Exit"
			else
				t = MAX_ICON_BAR
				half = t.odd? ? (t - 1) / 2 : (t - 2) / 2
				file << @list[@feature[pos]][:graphic]
				# Keys
				keys << @feature[pos]
				# Number
				number << pos
				if pos == (@feature.size - 1)
					(t - 1).times { |i|
						file.unshift(@list[@feature[pos-i-1]][:graphic])
						# Keys
						keys.unshift(@feature[pos-i-1])
						# Number
						number.unshift(pos-i-1)
					}
				elsif pos == 0
					(t - 1).times { |i|
						file << @list[@feature[pos+i+1]][:graphic]
						# Keys
						keys << @feature[pos+i+1]
						# Number
						number << (pos+i+1)
					}
				else
					disb  = pos - half
					disb -= 1 if t.even?
					disb  = 0 if disb < 0
					# Add number before pos
					if t.even?
						file.unshift(@list[@feature[pos-1]][:graphic])
						# Keys
						keys.unshift(@feature[pos-1])
						# Number
						number.unshift(pos-1)
						(disb...pos-1).each { |i|
							file.unshift(@list[@feature[i]][:graphic])
							# Keys
							keys.unshift(@feature[i])
							# Number
							number.unshift(i)
						}
					else
						(disb...pos).each { |i|
							file.unshift(@list[@feature[i]][:graphic])
							# Keys
							keys.unshift(@feature[i])
							# Number
							number.unshift(i)
						}
					end
					# Add number after pos
					disa = t - file.size
					disa.times { |i|
						file << @list[@feature[pos+i+1]][:graphic]
						# Keys
						keys << @feature[pos+i+1]
						# Number
						number << (pos+i+1)
					}
				end
				file[0] = "Prev" if keys[0] != @feature[0]
				file << (keys[keys.size-1] == @feature[@feature.size-1] ? "Exit" : "Next")
			end
			# Number
			return number if storenum
			# Store value with @poscuricon
			if value
				file.size.times { |i|
					next if @feature[pos] != keys[i]
					@poscuricon = i
				}
				return
			end
			return file
		end

		# Set position 'Icon on bar'
		def set_position_icon(number)
			w = @sprites["mini #{number}"].src_rect.width
			h = @sprites["mini #{number}"].src_rect.height
			quant = storeIcon.size
			# Set distance (x, y)
			disx = (Graphics.width - w * quant) / (quant + 1)
			disy = (@sprites["bar"].bitmap.height - h) / 2
			# Show error if it exists
			PokegearHGSS.error("You need to modify graphics (icon on bar)") if disx <= 0 || disy <= 0
			# Set x, y
			x = disx + (disx + w) * number
			y = @sprites["bar"].y + disy
			set_xy_sprite("mini #{number}", x, y)
			@storeposicon << [x, y, w, h]
		end

		# Set src_rect if icon chose
		def chose_icon
			return if @exit
			create_mini_bar
			# Reset value if player doesn't choose bar
			if !@chosebar
				@posfeature = @storeposfeature
				storeIcon(@posfeature, true)
			end
			file = storeIcon
			file.size.times { |i|
				x = i == @poscuricon ? @sprites["mini #{i}"].src_rect.width : 0
				case file[i]
				when "Exit", "Next", "Prev"
					set_src_xy_sprite("mini #{i}", x, @sprites["mini #{i}"].bitmap.height / MAX_BACKGROUND * @background)
				else
					set_src_xy_sprite("mini #{i}", x, 0)
				end
			}
		end
		
		# Create scene
		def create_scene
			# Scene
			graphic = @list[@feature[@posfeature]][:graphic]
			file    = graphic[:scene]
			subdir  = graphic[:dir]
			create_sprite_scene("bg", "#{file}#{@background+1}", @viewport, subdir)
		end

	end
end