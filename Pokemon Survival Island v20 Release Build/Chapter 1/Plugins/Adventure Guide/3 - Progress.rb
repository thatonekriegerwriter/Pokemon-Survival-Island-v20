module AdventureGuide
	class Show

		def show
			# Store value
			store_text
			# Create
			create_scene
			loop do
				break if @exit
				# Update
				update_ingame
				update_arrow
				update_bg
				update_choice
				update_text
				# Input
				set_input
			end
		end

		def store_text
			description = []
			3.times {
				@text << []
				@description << []
				description << []
				@lines << []
				@position << 0
			}
			i = 0
			@list.each { |list|
				@text[0] << list[:name]
				description[0] << list[:description]
				@text[1] << []
				description[2] << []
				@description[2] << []
				list[:sub].each { |sublist|
					@text[1][i] << sublist[:name]
					description[2][i] << sublist[:description]
				}
				i += 1
			}
			@text[0] << "Exit"
			@text[1].each { |i| i << "Return" } 
			# Re_write
			width = [470, 0, 450]
			description.size.times { |i|
				next if i == 1
				if i == 0
					description[i].each { |j| @description[i] << split_text(j, width[i]) }
				else
					description[i].size.times { |j| description[i][j].each { |k| @description[i][j] << split_text(k, width[i]) } }
				end
			}
		end

		def split_text(text1, width)
			i = 0
			str = ""
			text2 = []
			length = text1.length
			real = length * 12
			# Use to define 'Space'
			space = 0
			first = true
			strfake = ""
			loop do
				break if i == text1.length
				if first
					if text1[i] == " "
						i += 1
						next
					end
					first = false
				end
				space += 1 if text1[i] == " "
				str << text1[i] if space < 1
				if space > 0
					if text1[i] == "\n"
						text2 << (str + strfake)
						strfake = ""
						str = ""
						space = 0
					else
						strfake << text1[i]
						if space == 2 && i+1 != text1.length
							if (str.length + strfake.length) * 12 > width
								text2 << str
								str = strfake
							else
								str << strfake
							end
							strfake = ""
							space = 1
						elsif i+1 == text1.length
							text2 << (str + strfake)
						end
					end
				else
					if text1[i] == "\n"
						text2 << str
						str = ""
					else
						text2 << str if i+1 == text1.length
					end
				end
				i += 1
			end
			return text2
		end

		#--------#
		# Create #
		#--------#
		def create_scene
			# Background
			create_sprite("bg", "Scene_#{@page+1}", @viewport)
			# Text
			["text", "title", "description"].each { |i| create_sprite_2(i, @viewport) }
			# Other bitmap
			create_sprite("choice", "Choice", @viewport)
			update_choice
			set_visible_sprite("choice")
			2.times { |i|
				create_sprite("arrow #{i}", "Arrow", @viewport)
				w = @sprites["arrow #{i}"].bitmap.width
				h = @sprites["arrow #{i}"].bitmap.height / 2
				set_src_wh_sprite("arrow #{i}", w, h)
				set_src_xy_sprite("arrow #{i}", 0, h * i)
				x = Graphics.width / 2
				y = 43 + (241 - h) * i
				set_xy_sprite("arrow #{i}", x, y)
				set_visible_sprite("arrow #{i}")
			}
			# Text
			update_text
		end

		#--------#
		# Update #
		#--------#
		def update_bg
			return if @oldpage == @page
			# Sprite
			file = @page == 2 && @description[@page][@position[@page-2]][@position[@page-1]].size > limit_text_3 ? "Scene_#{@page+1}_1" : "Scene_#{@page+1}"
			set_sprite("bg", file)
			# Page
			@oldpage = @page
		end
		
		def update_text
			draw_title
			draw_text
			draw_description
		end

		def update_choice
			set_visible_sprite("choice", @page != 2)
			x = @page == 0 ? 2 : 30
			y = (@page == 0 ? 55 : 87) + 28 * pos_choice
			set_xy_sprite("choice", x, y)
		end

		def update_arrow
			2.times { |i|
				h = @sprites["arrow #{i}"].src_rect.height
				x = Graphics.width / 2
				y = 
					case @page
					when 0 then 43 + (241 - h) * i
					when 1, 2 then 78 + 286 * i
					end
				set_xy_sprite("arrow #{i}", x, y)
			}
			case @page
			when 0
				maxshow = limit_text_1
				limit = @text[@page].size
				seen = @position[@page] < (limit - maxshow + 3)
			when 1
				maxshow = limit_text_2
				limit = @text[@page][@position[@page-1]].size
				seen = @position[@page] < (limit - maxshow + 4)
			when 2
				maxshow = limit_text_3
				limit = @description[@page][@position[@page-2]][@position[@page-1]].size
				seen = @position[@page] < (limit - maxshow)
			end
			set_visible_sprite("arrow 0", @page == 2 ? @position[@page] > 0 : @position[@page] >= maxshow / 2)
			set_visible_sprite("arrow 1", seen)
		end

		#-----------#
		# Draw text #
		#-----------#
		def draw_title
			clearTxt("title")
			return if @page == 0
			title = @page == 1 ? @text[@page-1][@position[@page-1]] : @text[@page-1][@position[@page-2]][@position[@page-1]]
			text = []
			string = title
			x = 20
			y = 45
			text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			drawTxt("title", text)
		end

		def draw_text
			clearTxt("text")
			return if @page == 2
			textpage = @page == 0 ? @text[@page] : @text[@page][@position[@page-1]]
			position = @position[@page]
			max = textpage.size
			maxshow = @page == 0 ? limit_text_1 : limit_text_2
			if max > 0 && max < maxshow
				pos = 0
			else
				if position < maxshow / 2
					pos = 0
				elsif position >= maxshow / 2 && position < max - maxshow / 2
					pos = position - (maxshow / 2 - 1)
				else
					pos = max - maxshow
				end
			end
			endnum = (max > 0 && max < maxshow)? max : maxshow
			text = []
			endnum.times { |i|
				string = textpage[pos+i]
				x = @page == 0 ? 18 : 50
				y = (@page == 0 ? 53 : 85) + (20 + 8) * i - 10
				text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			}
			drawTxt("text", text)
		end

		def draw_description
			clearTxt("description")
			return if @page == 1
			x = @page == 0 ? 40 : 50
			str = @page == 0 ? @description[@page][@position[@page]] : @description[@page][@position[@page-2]][@position[@page-1]]
			return if !str
			base   = Color.new(0,0,0)
			shadow = Color.new(255,255,255)
			text = []
			case @page
			when 0
				# Animated
				startnum = 0
				endnum = str.size
				if str.size > 3
					@frames += 1
					@frames  = 0 if @frames > 32
					@pos_des_per_frames += 1 if @frames == 0
					@pos_des_per_frames  = 0 if @pos_des_per_frames + 3 > str.size
					startnum = @pos_des_per_frames
					endnum = @pos_des_per_frames + 3
				end
				pos_start_y = 0
				(startnum...endnum).each { |i|
					string = str[i]
					y = (@page == 0 ? 289 : 85) + (20 + 8) * pos_start_y - 10
					pos_start_y += 1
					text << [string, x, y, 0, base, shadow]
				}
			when 2
				max = str.size
				maxshow = limit_text_3
				pos = max > 0 && max < maxshow ? 0 : @position[@page]
				endnum = max > 0 && max < maxshow ? max : maxshow
				endnum.times { |i|
					string = str[pos+i]
					y = (@page == 0 ? 293 : 85) + (20 + 8) * i - 10
					text << [string, x, y, 0, shadow, base]
				}
			end
			drawTxt("description", text)
		end

		#-------#
		# Limit #
		#-------#
		3.times { |i| define_method("limit_text_#{i+1}".to_sym) { return [8, 10, 10][i] } }
		
		#------------------------#
		# Set position of choice #
		#------------------------#
		def pos_choice
			return 0 if @page == 2
			textpage = @page == 0 ? @text[@page] : @text[@page][@position[@page-1]]
			max = textpage.size
			maxshow = @page == 0 ? limit_text_1 : limit_text_2
			return @position[@page] if max > 0 && max < maxshow
			return @position[@page] if @position[@page] < maxshow / 2
			return maxshow / 2 - 1 if @position[@page] < max - maxshow / 2
			return (maxshow - 1) - ((max - 1) - @position[@page])
		end

		#-------#
		# Input #
		#-------#
		def set_input
			if @page == 0 || @page == 1
				textpage = @page == 0 ? @text[@page] : @text[@page][@position[@page-1]]
				size = textpage.size
			end
			# Input
			if checkInput(Input::BACK)
				@page == 0 ? (@exit = true) : (@page -= 1)
				reset_position
			elsif checkInput(Input::USE)
				case @page
				when 0, 1 then @position[@page] != (size - 1) ? (@page += 1) : @page == 0 ? (@exit = true) : (@page -= 1)
				else @page -= 1
				end
				reset_position
			elsif checkInput(Input::UP)
				@position[@page] -= 1
				if @page == 2
					@position[@page] = 0 if @position[@page] < 0
					return
				end
				@position[@page] = size - 1 if @position[@page] < 0
			elsif checkInput(Input::DOWN)
				@position[@page] += 1
				if @page == 2
					limit = @description[@page][@position[@page-2]][@position[@page-1]].size
					if limit < limit_text_3
						@position[@page] = 0
					else
						limit -= limit_text_3
						@position[@page] = limit if @position[@page] > limit
					end
					return
				end
				@position[@page]  = 0 if @position[@page] >= size
			end
		end

		def reset_position
			case @page
			when 0
				@position.size.times { |i| @position[i] = 0 }
				# Reset frames
				@frames = 0
				@pos_des_per_frames = 0
			when 1 then @position.size.times { |i| @position[i] = 0 if i != 0 }
			end
		end

	end
end