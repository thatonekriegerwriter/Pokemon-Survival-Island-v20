module PkmnAR
	class Show
		
		#------#
		# Text #
		#------#
		def draw_text
			draw_name
			draw_quantity
			# draw_items
		end

		def draw_name
			clearTxt("pkmn text")
			return if @bg == 0
			text = []
			# Pokemon name
			string = "#{@pkmn[:name].name}"
			x = 48
			y = 8
			text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			# Features
			string = ["Affection", "Fullness", "Enjoyment"]
			3.times { |i|
				x = 32
				y = 64 + 32 * i
				text << [string[i], x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			}
			# Title
			string = "Select pokemon you'd like to play with!"
			x = 74
			y = 339
			text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			drawTxt("pkmn text", text)
		end

		def draw_quantity
			clearTxt("quantity text")
			return unless @feedshow
			return if @itemF.size <= 0
			text = []
			@itemF.each_with_index { |item, i|
				string = "x #{$PokemonBag.pbQuantity(item)}"
				# 48: length of bitmap 'item', 15 is distance between two bitmaps
				x = 80 + 48 + (48 + 15) * i
				y = @sprites["feed"].y - @sprites["item #{i}"].src_rect.height / 2 - 10 * 2
				text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			}
			drawTxt("quantity text", text, 5, nil, 2)
		end

	end
end