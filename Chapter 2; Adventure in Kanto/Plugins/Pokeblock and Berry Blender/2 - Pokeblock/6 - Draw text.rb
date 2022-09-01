module Pokeblock
	class Show

		def draw_text
			draw_list_flavor
			draw_pokemon
		end

		#------------------#
		# Draw list flavor #
		#------------------#
		def draw_list_flavor
			return if @style != 0
			clearTxt("list text")
			return if @processPkBlock != 0
			# Set position
			max = @flavor.size
			maxshow  = max_list_flavor
			position = @flavorPos
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
			# Text
			text = []
			endnum.times { |i|
				# Name
				string = @nameFla[pos+i]
				x = 255 + 20
				y = 18 - 10 + 44 * i
				text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
				# Level
				flavor = @flavor[pos+i]
				next if flavor[2] == 0
				bitmap = @sprites["list text"].bitmap
				string = "Lv. #{flavor[2]}"
				x = 255 - bitmap.text_size(string).width + 230
				y = 18 - 10 + 44 * i
				text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			}
			# Sheen
			string = "FEEL: #{@flavor[position][1]}"
			x = 107
			y = 344 - 10
			text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			drawTxt("list text", text)
		end

		#--------------#
		# Draw pokemon #
		#--------------#
		def draw_pokemon
			clearTxt("pkmn text")
			return if @style == 0 && @processPkBlock < 1
			text = []
			# Name + gender
			string = @pkmn[:name].name + " "
			string += @pkmn[:name].male? ? _INTL("♂") : @pkmn[:name].female? ? _INTL("♀") : ""
			x = 206
			y = 16
			text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			# Level
			string = "Level: #{@pkmn[:name].level}"
			y += 20 + 15
			text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			# Nature
			string = @pkmn[:name].nature.name
			x = 10
			y = 302
			text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			drawTxt("pkmn text", text)
		end

	end
end