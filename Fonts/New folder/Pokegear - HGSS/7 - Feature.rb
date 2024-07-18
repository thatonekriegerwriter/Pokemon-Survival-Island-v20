module PokegearHGSS
	
	# Just show text
	class FirstFeature
		
		# Re-write
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
			# Show
			show
			# End
			endScene
			return @posfeature
		end

		def show
			# Create scene and bar (should have these lines)
			create_scene
			create_bar
			create_mini_bar(true)
			# Fade
			chose_icon # Chose before scene appears
			pbFadeInAndShow(@sprites) {
				update
				# Draw information
				draw_infor
			}
			# Run
			loop do
				# Update
				update_ingame
				break if @changed || @exit
				# Draw information
				draw_infor
				# Set layer (should have this)
				position_and_draw_layer
				# Input (should have this)
				# Keyboard
				input_bar
				# Mouse
				mouse_use_on_bar
				# Set bitmap after choose
				chose_icon
			end
		end

		def draw_infor
			# Set text
			create_sprite_2("text", @viewport) if !@sprites["text"]
			bitmap = @sprites["text"].bitmap
			@sprites["text"].z = 1
			clearTxt("text")
			text = []
			time = Time.now
			hour = time.hour
			min = time.min
			hour = "0#{hour}" if hour < 10
			min = "0#{min}" if min < 10
			string = "#{hour} : #{min}  #{DAY_OF_WEEK[time.wday]}"
			halfx = bitmap.text_size(string).width / 2
			x = X_Y[@background][0] == "middle" ? Graphics.width  / 2 : (X_Y[@background][0] + halfx)
			y = X_Y[@background][1] == "middle" ? Graphics.height / 2 : X_Y[@background][1]
			text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			drawTxt("text", text, nil, nil, 1)
			# Set signal
			create_sprite_detail("signal", "Signal", @viewport) if !@sprites["signal"]
			w = @sprites["signal"].bitmap.width  / 2
			h = @sprites["signal"].bitmap.height
			set_src_wh_sprite("signal", w, h)
			set_src_xy_sprite("signal", w * (CANT_PHONE[0] && CANT_PHONE[1].include?($game_map.map_id) ? 1 : 0), 0)
			x += halfx + 10
			y += 5
			set_xy_sprite("signal", x, y)
		end

	end

	#-------------------------------------------------------------------------------------------------------------------------------------------
	#
	#
	#-------------------------------------------------------------------------------------------------------------------------------------------

	# Change style
	class SecondFeature

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
			# Show
			show
			# End
			endScene
			# Set background in global and save it
			save_bg
			return @posfeature
		end

		def show
			# Store input in this value
			# :name => [x, y, w, h]
			@storeinput = {}
			# Store background to change
			@fakebg = @background

			# Create scene and bar (should have these lines)
			create_scene
			create_bar
			create_mini_bar(true)

			# Create (new) in background
			create_bg_to_choose
			create_choose_to_change
			draw_arrow

			# Fade
			chose_icon # Chose before scene appears
			pbFadeInAndShow(@sprites) { update }
			# Run
			loop do
				# Update
				update_ingame
				break if @changed || @exit
				# Set layer (should have this)
				position_and_draw_layer
				
				# Input (should have this)
				# Keyboard
				input_bar
				# Mouse
				mouse_use_on_bar
				# Set bitmap after choose
				chose_icon

				# Reset after show animation
				choose_change_bg
				chose_arrow(true)
				# Input (in this feature)
				# Keyboard
				input_bg
				# Mouse
				mouse_bg

			end
		end

		# Draw background to choose
		def create_bg_to_choose
			graphic = @list[@feature[@posfeature]][:graphic]
			file    = graphic[:scene]
			subdir  = graphic[:dir]
			create_sprite_detail("bg choose", "#{file}#{@fakebg+1}", @viewport, subdir) if !@sprites["bg choose"]
			set_sprite_detail("bg choose", "#{file}#{@fakebg+1}", subdir)
			w = @sprites["bg choose"].bitmap.width
			h = @sprites["bg choose"].bitmap.height
			x = X_Y[0] == "middle" ? (Graphics.width  - w) / 2 : X_Y[0]
			y = X_Y[1] == "middle" ? (Graphics.height - h) / 2 : X_Y[1]
			set_xy_sprite("bg choose", x, y)
		end

		# Draw title of each backgraound (redraw if change)
		def draw_title
			create_sprite_2("title", @viewport) if !@sprites["title"]
			clearTxt("title")
			text = []
			string = TITLE[@fakebg]
			x = @sprites["bg choose"].x + @sprites["bg choose"].bitmap.width / 2
			y = @sprites["bg choose"].y + @sprites["bg choose"].bitmap.height
			# Japan screen
			if @background == 3
				text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			else
				text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			end
			drawTxt("title", text, nil, nil, 1)
			return y
		end

		# Create bitmap to change
		def create_choose_to_change
			create_sprite_detail("change", "Choose customize", @viewport)
			w = @sprites["change"].bitmap.width  / 2
			h = @sprites["change"].bitmap.height
			set_src_wh_sprite("change", w, h)
			set_src_xy_sprite("change", 0, 0)
			x = @sprites["bg choose"].x + (@sprites["bg choose"].bitmap.width - w) / 2
			y = draw_title + @sprites["title"].bitmap.text_size(TITLE[@background]).height + 20
			set_xy_sprite("change", x, y)
			# Store position
			@storeinput[:change] = [x, y, w, h]
		end

		# Redraw rectangle "change"
		def choose_change_bg(pressed=false)
			w = @sprites["change"].bitmap.width  / 2
			@sprites["change"].src_rect.x = w * (pressed ? 1 : 0)
		end

		# Draw arrow (to move next or previous style)
		def draw_arrow
			file   = @list[@feature[@posfeature]][:graphic]
			subdir = file[:dir]
			name   = ["next", "prev"]
			2.times { |i|
				create_sprite_detail(name[i], name[i].capitalize, @viewport, subdir)
				w = @sprites[name[i]].bitmap.width  / 2
				h = @sprites[name[i]].bitmap.height
				set_src_wh_sprite(name[i], w, h)
				set_src_xy_sprite(name[i], 0, 0)
				x = @sprites["bg choose"].x + (i==1 ? -(10 + w) : 10 + @sprites["bg choose"].bitmap.width)
				y = @sprites["bg choose"].y + (@sprites["bg choose"].bitmap.height - h) / 2
				set_xy_sprite(name[i], x, y)
				# Store position
				@storeinput[name[i].to_sym] = [x, y, w, h]
			} 
		end

		# Redraw arrow
		def chose_arrow(name=nil)
			return if !name
			real = ["next", "prev"]
			real.each { |i| @sprites[i].src_rect.x = 0 }
			return if !real.include?(name)
			@sprites[name].src_rect.x = @sprites[name].src_rect.width
		end

		#-------#
		# Input #
		#-------#

		#-------#
		# Mouse #
		#-------#
		# Return position of each feature
		def mouse_position_of
			arr = ["change", "next", "prev"]
			arr.each { |i| return i if areaMouse?(@storeinput[i.to_sym]) }
			return nil
		end

		# Set in 'def mouse_use_on_bar' -> Don't call again delayMouse
		def mouse_bg
			return if @chosebar
			pos = mouse_position_of if @delay > DelayMouse
			# Click
			if clickedMouse?
				return if !pos
				case pos
				when "change"
					animate("change")
					return if @background == @fakebg
					@background = @fakebg
					# Recreate
					graphic = @list[@feature[@storeposfeature]][:graphic]
					file    = graphic[:scene]
					subdir  = graphic[:dir]
					set_sprite_scene("bg", "#{file}#{@background+1}", subdir)
					set_sprite_bar("bar", "Bar_#{@background+1}")
					create_mini_bar
					draw_title
				when "next"
					animate("next")
					@fakebg += 1
					@fakebg  = 0 if @fakebg >= MAX_BACKGROUND
					# Redraw if changed
					create_bg_to_choose
					draw_title
				when "prev"
					animate("prev")
					@fakebg -= 1
					@fakebg  = MAX_BACKGROUND - 1 if @fakebg < 0
					# Redraw if changed
					create_bg_to_choose
					draw_title
				end
			end
		end

		#----------#
		# Keyboard #
		#----------#
		# Doesn't check Input::BACK, used it to check 'chose bar'
		def input_bg
			return if @chosebar
			if checkInput(Input::USE)
				animate("change")
				return if @background == @fakebg
				@background = @fakebg
				# Recreate
				graphic = @list[@feature[@posfeature]][:graphic]
				file    = graphic[:scene]
				subdir  = graphic[:dir]
				set_sprite_scene("bg", "#{file}#{@background+1}", subdir)
				set_sprite_bar("bar", "Bar_#{@background+1}")
				create_mini_bar
				draw_title
			elsif checkInput(Input::LEFT)
				animate("prev")
				@fakebg -= 1
				@fakebg  = MAX_BACKGROUND - 1 if @fakebg < 0
				# Redraw if changed
				create_bg_to_choose
				draw_title
			elsif checkInput(Input::RIGHT)
				animate("next")
				@fakebg += 1
				@fakebg  = 0 if @fakebg >= MAX_BACKGROUND
				# Redraw if changed
				create_bg_to_choose
				draw_title
			end
		end

		# Set animated if press or click
		def animate(name=nil)
			return if !name
			t = 5
			loop do
				break if t <= 0
				Graphics.update
				case name
				when "change" then choose_change_bg(true)
				when "next", "prev" then chose_arrow(name)
				end
				t -= 1
			end
		end

	end

	#-------------------------------------------------------------------------------------------------------------------------------------------
	#
	#
	#-------------------------------------------------------------------------------------------------------------------------------------------
	
	# Show text and choose page
	class ThirdFeature < Show

		def set_sprites_viewport
			super
			number    = []
			@pagekeys = {}
			@pagename = []
			name      = []
			@pageproc = []
			nameproc  = []
			pages = StorePage.new.radio_content
			pages.each { |k,v|
				number << v[:order]
				@pagekeys[k] = v[:order]
			}
			check = number.uniq!
			self.error("Check order number!") if !check.nil?
			@pagekeys = @pagekeys.sort_by(&:last)
			@pagekeys.size.times { |i|
				content = pages[@pagekeys[i][0]][:content]
				content.size.times { |i|
					name << content[i][0]
					nameproc << content[i][1]
				}
				@pagename << name
				@pageproc << nameproc
				name     = []
				nameproc = []
			}
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
			# Show
			show
			# End
			endScene
			# Set background in global and save it
			save_bg
			return @posfeature
		end

		def show
			# Store number page
			@page = 0
			# Set position of list (note), player chose it
			@poscurlist = 0
			# Store input in this value
			# :name => [x, y, w, h]
			@storeinput = {}

			# Create scene and bar (should have these lines)
			create_scene
			create_bar
			create_mini_bar(true)

			# Create (new) in background
			create_list(true)
			create_arrow(true)
			draw_list

			# Fade
			chose_icon # Chose before scene appears
			pbFadeInAndShow(@sprites) { update }
			# Run
			loop do
				# Update
				update_ingame
				break if @changed || @exit
				# Set layer (should have this)
				position_and_draw_layer
				
				# Input (should have this)
				# Keyboard
				input_bar
				# Mouse
				mouse_use_on_bar
				# Set bitmap after choose
				chose_icon

				# Input (new feature) in background
				# Keyboard
				input_bg
				# Mouse
				mouse_bg
				# Reset list
				create_list
				draw_list
				create_arrow

			end
		end

		# Create list and use when click
		def create_list(first=false)
			@storeinput[:list] = [] if first
			QUANTITY_LIST.times { |i|
				if !@sprites["list #{i}"]
					create_sprite_detail("list #{i}", "List", @viewport, "Radio")
					w = @sprites["list #{i}"].bitmap.width
					h = @sprites["list #{i}"].bitmap.height / 2
					set_src_wh_sprite("list #{i}", w, h)
				end
				y = i == position_list ? @sprites["list #{i}"].src_rect.height : 0
				set_src_xy_sprite("list #{i}", 0, y)
				x = 36
				y = 22 + (@sprites["list #{i}"].src_rect.height + 6) * i
				set_xy_sprite("list #{i}", x, y)
				@storeinput[:list] << [x, y, w, h] if first
			}
		end

		# Create arrow and use when change
		def create_arrow(first=false, up=false, down=false)
			@storeinput[:arrow] = [] if first
			2.times { |i|
				if !@sprites["arrow #{i}"]
					create_sprite_detail("arrow #{i}", "Arrow_#{@background+1}", @viewport, "Arrow Up Down")
					w = @sprites["arrow #{i}"].bitmap.width  / 2
					h = @sprites["arrow #{i}"].bitmap.height / 2
					set_src_wh_sprite("arrow #{i}", w, h)
				end
				x = (up && i == 0) || (down && i == 1) ? @sprites["arrow #{i}"].src_rect.width : 0
				y = i == 0 ? 0 : @sprites["arrow #{i}"].src_rect.height
				set_src_xy_sprite("arrow #{i}", x, y)
				x = Graphics.width - @sprites["arrow #{i}"].src_rect.width - 2
				y = 38
				y += @sprites["arrow #{i}"].src_rect.height + 32 if i == 1
				set_xy_sprite("arrow #{i}", x, y)
				@storeinput[:arrow] << [x, y, w, h] if first
			}
		end

		# Draw list
		def draw_list
			create_sprite_2("text", @viewport) if !@sprites["text"]
			clearTxt("text")
			max = @pagename[@page].size
			maxshow = QUANTITY_LIST
			if max > 0 && max < maxshow
				pos = 0
			else
				if @poscurlist < maxshow / 2
					pos = 0
				elsif @poscurlist >= maxshow / 2 && @poscurlist < max - maxshow / 2
					pos = @poscurlist - (maxshow / 2 - 1)
				else
					pos = max - maxshow
				end
			end
			endnum = (max > 0 && max < maxshow)? max : maxshow
			bitmap = @sprites["text"].bitmap
			text = []
			endnum.times { |i|
				string = @pagename[@page][pos+i]
				x = @sprites["list #{i}"].x + 12
				y = @sprites["list #{i}"].y
				text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			}
			drawTxt("text", text)
		end
		
		# Position of arrow
		def position_list
			max = @pagename[@page].size
			maxshow = QUANTITY_LIST
			return @poscurlist if max > 0 && max < maxshow
			return @poscurlist if @poscurlist < maxshow / 2
			return maxshow / 2 - 1 if @poscurlist < max - maxshow / 2
			return (maxshow - 1) - ((max - 1) - @poscurlist)
		end

		#-------#
		# Input #
		#-------#

		#-------#
		# Mouse #
		#-------#
		# Return position of each feature
		def mouse_position_arrow
			arr = @storeinput[:arrow]
			arr.size.times { |i| return i if areaMouse?(arr[i]) }
			return nil
		end

		def mouse_position_list
			arr = @storeinput[:list]
			arr.size.times { |i| return true if areaMouse?(arr[i]) && i == position_list }
			return false
		end

		# Set in 'def mouse_use_on_bar' -> Don't call again delayMouse
		def mouse_bg
			return if @chosebar
			if @delay > DelayMouse
				arrow = mouse_position_arrow
				list  = mouse_position_list
			end
			# Click
			if clickedMouse?
				if arrow
					case arrow
					when 0
						animate("up")
						@poscurlist -= 1
						@poscurlist  = @pagename[@page].size - 1 if @poscurlist < 0
					when 1
						animate("down")
						@poscurlist += 1
						@poscurlist  = 0 if @poscurlist >= @pagename[@page].size
					end
				elsif list
					if @poscurlist == @pagename[@page].size - 1
						@page == 0 ? @page += 1 : @page -= 1
						@poscurlist = 0
					else
						@pageproc[@page][@poscurlist].call
					end
				end
			end
		end

		#----------#
		# Keyboard #
		#----------#
		# Doesn't check Input::BACK, used it to check 'chose bar'
		def input_bg
			return if @chosebar
			if checkInput(Input::USE)
				if @poscurlist == @pagename[@page].size - 1
					@page == 0 ? @page += 1 : @page -= 1
					@poscurlist = 0
				else
					@pageproc[@page][@poscurlist].call
				end
			elsif checkInput(Input::UP)
				animate("up")
				@poscurlist -= 1
				@poscurlist  = @pagename[@page].size - 1 if @poscurlist < 0
			elsif checkInput(Input::DOWN)
				animate("down")
				@poscurlist += 1
				@poscurlist  = 0 if @poscurlist >= @pagename[@page].size
			end
		end
		
		# Set animated if press or click
		def animate(name=nil)
			return if !name
			t = 5
			loop do
				break if t <= 0
				Graphics.update
				case name
				when "up" then create_arrow(false, true)
				when "down" then create_arrow(false, false, true)
				end
				t -= 1
			end
		end
		
	end

	#-------------------------------------------------------------------------------------------------------------------------------------------
	#
	#
	#-------------------------------------------------------------------------------------------------------------------------------------------

	# Show text and choose to call
	# Feature: 'can call' used in 'class FirstFeature'
	class FourthFeature < Show

		def set_phone_numbers
			@trainers = []
			return if !$PokemonGlobal.phoneNumbers
			$PokemonGlobal.phoneNumbers.each { |num|
				next if !num[0]
				num.length == 8 ? @trainers.push([num[1],num[2],num[6],(num[4]>=2)]) : @trainers.push([num[1],num[2],num[3]])
			}
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
			# Show
			show
			# End
			endScene
			return @posfeature
		end

		def show
			# Check if player is seeing information
			@checkinfor = false
			# Set position of list (note), player chose it
			@poscurlist = 0
			# Set position of 'select' when player choose action
			@select = 0
			# Check if player selected
			@selected = false
			# Store input in this value
			# :name => [x, y, w, h]
			@storeinput = {}
			# Store phone numbers
			set_phone_numbers
			# Store rematch number
			@rematch = 0
			@trainers.each { |trainer|
				next if trainer.size != 4 || !trainer[3]
				@rematch += 1
			}

			# Create scene and bar (should have these lines)
			create_scene
			create_bar
			create_mini_bar(true)

			# Create (new) in background
			create_list(true)
			create_arrow(true)
			draw_list
			draw_choose_action(true)
			create_information_bar
			create_bitmap_information
			draw_information

			# Fade
			chose_icon # Chose before scene appears
			pbFadeInAndShow(@sprites) { update }
			# Run
			loop do
				# Update
				update_ingame
				break if @changed || @exit
				# Set layer (should have this)
				position_and_draw_layer
				
				# Input (should have this)
				# Keyboard
				input_bar
				# Mouse
				mouse_use_on_bar
				# Set bitmap after choose
				chose_icon

				# Input (new feature) in background
				# Keyboard
				input_bg
				# Mouse
				mouse_bg
				# Re-create
				create_list
				create_arrow
				draw_list
				draw_choose_action
				move_with_bar_information
				# Reset
				@select = 0 if !@selected

			end
		end

		# Create list and use when click
		def create_list(first=false)
			@storeinput[:list] = [] if first
			QUANTITY_LIST.times { |i|
				if !@sprites["list #{i}"]
					create_sprite_detail("list #{i}", "List_#{@background+1}", @viewport, "Phone")
					w = @sprites["list #{i}"].bitmap.width
					h = @sprites["list #{i}"].bitmap.height / 4
					set_src_wh_sprite("list #{i}", w, h)
				end
				if i.even?
					y = i == position_list && @trainers.size > 0 ? @sprites["list #{i}"].src_rect.height : 0
				else
					y = @sprites["list #{i}"].src_rect.height * (i == position_list && @trainers.size > 0 ?  3 : 2)
				end
				set_src_xy_sprite("list #{i}", 0, y)
				x = 36
				y = 22 + (@sprites["list #{i}"].src_rect.height + 6) * i
				set_xy_sprite("list #{i}", x, y)
				@storeinput[:list] << [x, y, w, h] if first
			}
		end

		# Create arrow and use when change
		def create_arrow(first=false, up=false, down=false)
			@storeinput[:arrow] = [] if first
			2.times { |i|
				if !@sprites["arrow #{i}"]
					create_sprite_detail("arrow #{i}", "Arrow_#{@background+1}", @viewport, "Arrow Up Down")
					w = @sprites["arrow #{i}"].bitmap.width  / 2
					h = @sprites["arrow #{i}"].bitmap.height / 2
					set_src_wh_sprite("arrow #{i}", w, h)
				end
				x = (up && i == 0) || (down && i == 1) ? @sprites["arrow #{i}"].src_rect.width : 0
				y = i == 0 ? 0 : @sprites["arrow #{i}"].src_rect.height
				set_src_xy_sprite("arrow #{i}", x, y)
				x = Graphics.width - @sprites["arrow #{i}"].src_rect.width - 2
				y = 38
				y += @sprites["arrow #{i}"].src_rect.height + 32 if i == 1
				set_xy_sprite("arrow #{i}", x, y)
				@storeinput[:arrow] << [x, y, w, h] if first
			}
		end

		# Draw list
		def draw_list
			return if @trainers.size <= 0
			create_sprite_2("text", @viewport) if !@sprites["text"]
			clearTxt("text")
			max = @trainers.size
			maxshow = QUANTITY_LIST
			if max > 0 && max < maxshow
				pos = 0
			else
				if @poscurlist < maxshow / 2
					pos = 0
				elsif @poscurlist >= maxshow / 2 && @poscurlist < max - maxshow / 2
					pos = @poscurlist - (maxshow / 2 - 1)
				else
					pos = max - maxshow
				end
			end
			endnum = (max > 0 && max < maxshow)? max : maxshow
			bitmap = @sprites["text"].bitmap
			text = []
			endnum.times { |i|
				string = @trainers[pos+i].size == 4 ? pbGetMessageFromHash(MessageTypes::TrainerNames,@trainers[pos+i][1]) : @trainers[pos+i][1]
				x = @sprites["list #{i}"].x + 12
				y = @sprites["list #{i}"].y
				text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
				next if @trainers[pos+i].size != 4
				string = GameData::TrainerType.get(@trainers[pos+i][0]).name
				x += 170
				text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			}
			drawTxt("text", text)
		end

		# Draw choose action when player choose
		def draw_choose_action(first=false)
			@storeinput[:select] = [] if first
			if !@sprites["choice"]
				create_sprite_detail("choice", "Choice", @viewport, "Phone")
				x = Graphics.width - @sprites["choice"].bitmap.width
				y = @sprites["bar"].y - @sprites["choice"].bitmap.height
				set_xy_sprite("choice", x, y)
				set_visible_sprite("choice")
				3.times { |i|
					create_sprite_detail("select #{i}", "Select", @viewport, "Phone")
					w = @sprites["select #{i}"].bitmap.width
					h = @sprites["select #{i}"].bitmap.height / 3
					set_src_wh_sprite("select #{i}", w, h)
					y = @sprites["select #{i}"].src_rect.height * i
					set_src_xy_sprite("select #{i}", 0, y)
					x = @sprites["choice"].x + 8
					y = @sprites["choice"].y + 10 + (@sprites["select #{i}"].src_rect.height + 4) * i
					set_xy_sprite("select #{i}", x, y)
					@storeinput[:select] << [x, y, w, h] if first
					set_visible_sprite("select #{i}")
				}
			end
			set_visible_sprite("choice", @selected)
			3.times { |i| set_visible_sprite("select #{i}") }
			return if @trainers.size <= 0 || !@selected || @checkinfor
			3.times { |i| set_visible_sprite("select #{i}", i == @select) }
		end

		def create_information_bar
			create_sprite_detail("infor bar", "Information_#{@background+1}", @viewport, "Phone")
			x = -@sprites["infor bar"].bitmap.width
			y = 0
			set_xy_sprite("infor bar", x, y)
		end

		def create_bitmap_information
			return if @trainers.size <= 0
			@sprites["icon"] = IconSprite.new(0,0,@viewport) if !@sprites["icon"]
			filename = @trainers[@poscurlist].size==4 ? GameData::TrainerType.charset_filename(@trainers[@poscurlist][0]) : sprintf("Graphics/Characters/phone%03d",@trainers[@poscurlist][0])
			@sprites["icon"].setBitmap(filename)
			charwidth  = @sprites["icon"].bitmap.width
			charheight = @sprites["icon"].bitmap.height
			@sprites["icon"].src_rect = Rect.new(0,0,charwidth/4,charheight/4)
			@sprites["icon"].x = @sprites["infor bar"].x + 10
			@sprites["icon"].y = @sprites["infor bar"].y + 10
		end

		def animate_icon
			return if @trainers.size <= 0
			if !@checkinfor
				@sprites["icon"].src_rect.x = 0
				return
			end
			# Set x, y
			@sprites["icon"].x = @sprites["infor bar"].x + 10
			@sprites["icon"].y = @sprites["infor bar"].y + 10
			# Animate
			@animation ||= 0
			@animation += 1
			return unless @animation%8 == 0
			@sprites["icon"].src_rect.x += @sprites["icon"].src_rect.width
			@sprites["icon"].src_rect.x  = 0 if @sprites["icon"].src_rect.x >= @sprites["icon"].bitmap.width
		end

		def draw_information
			create_sprite_2("infor bitmap", @viewport) if !@sprites["infor bitmap"]
			clearTxt("infor bitmap")
			bitmap = @sprites["infor bitmap"].bitmap
			return if @trainers.size <= 0
			text = []
			string = @trainers[@poscurlist][2] ? "Location: #{pbGetMessage(MessageTypes::MapNames,@trainers[@poscurlist][2])}" : ""
			x = @sprites["icon"].x
			y = @sprites["icon"].y + @sprites["icon"].src_rect.height
			text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			string = "Waiting for a rematch: #{@rematch}"
			x = @sprites["infor bar"].x + 10
			y = @sprites["infor bar"].y + 105
			text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			y += bitmap.text_size(string).height + 15
			string = "Registered: #{@trainers.size}"
			text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			drawTxt("infor bitmap", text)
			return if @trainers[@poscurlist].size != 4 || !@trainers[@poscurlist][3]
			@sprites["rematch"] = AnimatedBitmap.new("Graphics/Pictures/phoneRematch").deanimate if !@sprites["rematch"]
			x = @sprites["infor bar"].x + @sprites["infor bar"].src_rect.width - 10 - @sprites["rematch"].width
			y = @sprites["infor bar"].y + 14
			bitmap.blt(x, y, @sprites["rematch"], Rect.new(0, 0, @sprites["rematch"].width, @sprites["rematch"].height))
		end

		def move_with_bar_information
			animate_icon
			draw_information
		end

		# Position of arrow
		def position_list
			max = @trainers.size
			maxshow = QUANTITY_LIST
			return @poscurlist if max > 0 && max < maxshow
			return @poscurlist if @poscurlist < maxshow / 2
			return maxshow / 2 - 1 if @poscurlist < max - maxshow / 2
			return (maxshow - 1) - ((max - 1) - @poscurlist)
		end

		#-------#
		# Input #
		#-------#

		#-------#
		# Mouse #
		#-------#
		# Return position of each feature
		def mouse_position_arrow
			return nil if @selected || @trainers.size <= 0
			arr = @storeinput[:arrow]
			arr.size.times { |i| return i if areaMouse?(arr[i]) }
			return nil
		end

		def mouse_position_list
			return false if @selected || @trainers.size <= 0
			arr = @storeinput[:list]
			arr.size.times { |i| return true if areaMouse?(arr[i]) && i == position_list }
			return false
		end

		def mouse_position_select
			return nil if !@selected || @trainers.size <= 0
			arr = @storeinput[:select]
			arr.size.times { |i| return i if areaMouse?(arr[i]) }
			return nil
		end

		# Set in 'def mouse_use_on_bar' -> Don't call again delayMouse
		def mouse_bg
			return if @chosebar
			if @delay > DelayMouse
				arrow  = mouse_position_arrow
				list   = mouse_position_list
				select = mouse_position_select
				@select = select if select
			end
			# Click
			if clickedMouse?
				if @checkinfor
					animate("in")
					@checkinfor = false
					return
				elsif arrow
					case arrow
					when 0
						if @selected
							@select -= 1
							@select  = 2 if @select < 0
						else
							animate("up")
							@poscurlist -= 1
							@poscurlist  = @trainers.size - 1 if @poscurlist < 0
						end
					when 1
						if @selected
							@select += 1
							@select  = 0 if @select > 2
						else
							animate("down")
							@poscurlist += 1
							@poscurlist  = 0 if @poscurlist >= @trainers.size
						end
					end
				elsif list
					@selected = true
				elsif select
					case select
					when 0
						@selected = false
						draw_choose_action
						if CANT_PHONE[0] && CANT_PHONE[1].include?($game_map.map_id)
							pbMessage(_INTL("You can't call here!"))
						else
							pbCallTrainer(@trainers[@poscurlist][0],@trainers[@poscurlist][1])
						end
					when 1
						@selected = false
						create_bitmap_information
						draw_choose_action
						@checkinfor = true
						animate("out")
					when 2 then @selected = false
					end
				end
			end
		end

		#----------#
		# Keyboard #
		#----------#
		# Doesn't check Input::BACK, used it to check 'chose bar'
		def input_bg
			return if @chosebar
			if checkInput(Input::ACTION)
				return if !@checkinfor
				animate("in")
				@checkinfor = false
			elsif checkInput(Input::USE)
				return if @trainers.size <= 0 || @checkinfor
				if @selected
					case @select
					when 0
						@selected = false
						draw_choose_action
						if CANT_PHONE[0] && CANT_PHONE[1].include?($game_map.map_id)
							pbMessage(_INTL("You can't call here!"))
						else
							pbCallTrainer(@trainers[@poscurlist][0],@trainers[@poscurlist][1])
						end
					when 1
						@selected = false
						create_bitmap_information
						draw_choose_action
						@checkinfor = true
						animate("out")
					when 2 then @selected = false
					end
				else
					@selected = true
				end
			elsif checkInput(Input::UP)
				return if @trainers.size <= 0 || @checkinfor
				if @selected
					@select -= 1
					@select  = 2 if @select < 0
				else
					animate("up")
					@poscurlist -= 1
					@poscurlist  = @trainers.size - 1 if @poscurlist < 0
				end
			elsif checkInput(Input::DOWN)
				return if @trainers.size <= 0 || @checkinfor
				if @selected
					@select += 1
					@select  = 0 if @select > 2
				else
					animate("down")
					@poscurlist += 1
					@poscurlist  = 0 if @poscurlist >= @trainers.size
				end
			end
		end

		# Set animated if press or click
		def animate(name=nil)
			return if !name
			t = 5
			loop do
				break if t <= 0
				Graphics.update
				case name
				when "up" then create_arrow(false, true)
				when "down" then create_arrow(false, false, true)
				when "out"
					@sprites["infor bar"].x += @sprites["infor bar"].bitmap.width / 10
					move_with_bar_information
					if @sprites["infor bar"].x > 0
						@sprites["infor bar"].x = 0
						t = 0
					else
						t = 2
					end
				when "in"
					@sprites["infor bar"].x -= @sprites["infor bar"].bitmap.width / 10
					move_with_bar_information
					if @sprites["infor bar"].x < -@sprites["infor bar"].bitmap.width
						@sprites["infor bar"].x = -@sprites["infor bar"].bitmap.width
						t = 0 
					else
						t = 2
					end
				end
				t -= 1
			end
		end
		
	end

end