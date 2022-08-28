module BerryBlender
	class Show

		def draw_name
			text = []
			time = @player != 4 ? (@player + 1) : 2
			time.times { |i|
				string = @name[i]
				x = 15 + 358 * (i % 2) + 5
				y = 113 - 10 + 11 + 115 * (i / 2)
				text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			}
			drawTxt("name text", text)
		end

		#-----------#
		# Draw text #
		#-----------#
		def draw_main
			draw_speed
			draw_result
		end

		def draw_speed
			clearTxt("speed text")
			return if @result
			text = []
			string = "#{@speedTxt}"
			x = 210
			y = 326 - 10
			text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			drawTxt("speed text", text, 20)
		end

		def draw_result
			clearTxt("result text")
			return unless @result
			clearTxt("name text")
			# Draw bitmap
			draw_bitmap_features_text
			# Draw name, berry
			draw_players_text
		end

		def draw_bitmap_features_text
			clearTxt("result icon text")
			return if @showPage == 1
			arr = ["Perfect","Good","Miss"]
			bitmap = @sprites["result icon text"].bitmap
			imgpos = []
			arr.each_with_index { |a, i| imgpos << [ "Graphics/Pictures/Berry Blender/#{a}", 240 + 80 * i, 90 + 10, 0, 0, -1, -1 ] }
			pbDrawImagePositions(bitmap, imgpos)
		end

		def draw_players_text
			bitmap = @sprites["result text"].bitmap
			maxy = 0
			text = []
			# Max speed
			string = "Max speed: #{@maxSpeed}"
			x = (Graphics.width - bitmap.text_size(string).width) / 2
			y = 48 + 5
			text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			# Order
			@order.each_with_index { |order, i|
				string = "#{@orderNum[i]}. #{order[0][0]}"
				x = 5
				y = 130 + (20 + 25) * i
				maxy = y if maxy < y
				text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
				if @showPage == 1
					string = GameData::Item.get(order[0][1]).name
					x = 240
					text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
				end
				next if @showPage != 0
				order[0][2].each_with_index { |a, j|
					string = "#{a}"
					x = 240 + 80 * j
					text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
				}
			}
			# Flavor name
			string = "You got #{@flavorGet}"
			x = (Graphics.width - bitmap.text_size(string).width) / 2
			y = maxy + 20 + 20
			text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			drawTxt("result text", text)
		end

	end
end