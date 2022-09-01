module BerryBlender
	class Show

		def set_input
			player_press
			press_AI_top_right
			press_AI_bottom_left
			press_AI_bottom_right
			press_AI_special
		end

		#-------------#
		# Player play #
		#-------------#
		def player_press
			@exit = true if checkInput(Input::BACK) && @showPage == 1
			return unless checkInput(Input::USE)
			if @result
				@showPage == 0 ? (@showPage = 1) : (@exit = true)
				return
			end
			angle = @sprites["circle"].angle
			case angle
			when 40 then angle_circle(:perfect, 40)
			when 30, 50 then angle_circle(:good, 40)
			else angle_circle(:miss, 40)
			end
		end

		#------------------------#
		# Set AI play, not input #
		#------------------------#
		def press_AI_normal(num, angle)
			return if @result
			return if @player < num || @player == 4
			if @sprites["circle"].angle != angle
				@pressCheck[num] = false
				return
			end
			return if @pressCheck[num]
			random = rand(6)
			case random
			when 0 then angle_circle(:perfect, angle, num)
			when 1 then angle_circle(:good, angle, num)
			when 2, 3 then angle_circle(:miss, angle, num)
			end
			@pressCheck[num] = true
		end

		def press_AI_top_right = press_AI_normal(1, 320)

		def press_AI_bottom_left = press_AI_normal(2, 140)

		def press_AI_bottom_right = press_AI_normal(3, 220)

		def press_AI_special
			return if @result
			return if @player != 4
			if @sprites["circle"].angle != 320
				@pressCheck[1] = false
				return
			end
			return if @pressCheck[1]
			random = rand(5)
			case random
			when 0, 1 then angle_circle(:perfect, 320, 1)
			when 2, 3 then angle_circle(:good, 320, 1)
			end
			@pressCheck[1] = true
		end

	end
end