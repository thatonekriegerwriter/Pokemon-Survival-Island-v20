module Pokeathlon
	class Minigame_HurdleDash

		def draw_main
			draw_times
		end

		def draw_times
			return if !@nearfinish.include?(false)
			clearTxt("times text")
			text = []
			m   = @totaltimes[0]
			s   = sprintf("%02d", @totaltimes[1])
			s10 = @totaltimes[2]
			string = "#{m} : #{s} : #{s10}"
			x = Graphics.width - 5
			y = Graphics.height - 55
			text << [string, x, y, 0, Color.new(0, 0, 0), Color.new(255, 255, 255)]
			drawTxt("times text", text, nil, 50, 2)
		end

		def draw_points(wait=false)
			clearTxt("total points text")
			text = []
			time = sprintf("%0.1f", @scoreSpecial[0]) if !wait
			string = wait ? "Wait..." : "Total time: #{time}"
			x = Graphics.width / 2
			y = Graphics.height / 2 + 60
			text << [string, x, y, 0, Color.new(0, 0, 0), Color.new(255, 255, 255)]
			drawTxt("total points text", text, nil, 50, 1)
		end

	end
end