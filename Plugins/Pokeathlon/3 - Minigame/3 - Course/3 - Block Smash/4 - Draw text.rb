module Pokeathlon
	class Minigame_BlockSmash

		def draw_main
			time_text
			pkmn_name_text
			pieces_text
		end

		# Draw time
		def time_text
			text = []
			bitmap = @sprites["time text"].bitmap
			string = sprintf("%02d", @times)
			x = Settings::SCREEN_WIDTH - bitmap.text_size(string).width - 10
			y = Settings::SCREEN_HEIGHT - 20 - 10 - 20
			text << [string, x, y, 0, Color.new(255, 255, 255), Color.new(0, 0, 0)]
			drawTxt("time text", text, nil, 40)
		end

		# Draw name pokemon (right screen)
		def pkmn_name_text
			text = []
			string = "Next #{@orderPkmn[0][:pkmn][1].species}"
			x = Settings::SCREEN_WIDTH + 10
			y = Settings::SCREEN_HEIGHT - 20 - 10 - 6
			text << [string, x, y, 0, Color.new(255, 255, 255), Color.new(0, 0, 0)]
			drawTxt("name pkmn right screen text", text)
		end

		# Draw: count pieces
		def pieces_text
			text = []
			num = sprintf("%03d", @scoreSpecial[0])
			string = "#{num} pcs"
			x = 10
			y = Settings::SCREEN_HEIGHT - 20 - 10 - 20
			text << [string, x, y, 0, Color.new(255, 255, 255), Color.new(0, 0, 0)]
			drawTxt("pieces text", text, nil, 40)
		end

		# Draw result
		def result_txt
			text = []
			bitmap = @sprites["total text"].bitmap
			string = "Pokemon total: #{@scoreSpecial[0]} Pieces"
			x = (Settings::SCREEN_WIDTH - bitmap.text_size(string).width) / 2 
			y = Settings::SCREEN_HEIGHT / 2 + 50 + 10
			text << [string, x, y, 0, Color.new(255, 255, 255), Color.new(14, 94 ,23)]
			drawTxt("total text", text, nil, 50)
		end

	end
end