module Pokeathlon
	class JuiceBlender

		#-----------------#
		# Choose features #
		#-----------------#
		def choose_feature_main
			choice_before_show
			choose_feature_0_choose_1
			choose_feature_1_choose_2
			choose_feature_2_choose_3
		end

		#---------------------#
		# Use with choose = 0 #
		#---------------------#
		def arr_choose_feature_first
			arr = [
				["Choose apricorn", "You can choose apricorn to create juice"],
				["Take juice", "You can take juice."],
				["Check flavor", "You can check flavor."],
				["Guide", "You can know more in this feature."],
				["Cancel", "Bye!"]
			]
			return arr
		end

		def choice_before_show
			return if @choose != 0
			# Window
			arr = arr_choose_feature_first
			create_mess_window(arr.map(&:first))
			@sprites["textbox"].text = arr[0][1]
			set_visible_sprite("textbox", true)
			# Start
			ret = 0
			loop do
				update_ingame
				break if ret < 0 || Input.trigger?(Input::USE)
				update_main
				@sprites["textbox"].text = arr[ret][1]
				ret = Input.trigger?(Input::BACK) ? -1 : @sprites["cmdwindow"].index
			end
			pbPlayCloseMenuSE
			dispose("cmdwindow")
			set_visible_sprite("textbox")
			case ret
			# Put apricorn
			when 0
				
				# Can't put
				if $PokemonGlobal.apricorn_juice_first.size > 0 && $PokemonGlobal.apricorn_juice_step < STEP_APRIJUICE
					set_visible_sprite("textbox", true)
					update_message("You can't put it anymore! Walk or cycle to mix up Apricorns.")
					return
				elsif $PokemonGlobal.apricorn_juice_put >= MAX_LIMIT_MIXED
					set_visible_sprite("textbox", true)
					update_message("You can't put it anymore! Take your aprijuice or walk / cycle and take it later.")
					return
				elsif @apricorn.size == 0
					set_visible_sprite("textbox", true)
					update_message("You don't have any apricorns.")
				# Put
				else
					@changeBottle = true
					update_bottle
					@choose = 1
				end

			# Take aprijuice
			when 1

				if $PokemonGlobal.apricorn_juice_first.size == 0
					set_visible_sprite("textbox", true)
					update_message("You don't have any Apricorns in Aprijuice, put it to create Aprijuice.")
					return
				elsif $PokemonGlobal.apricorn_juice_step < STEP_APRIJUICE
					set_visible_sprite("textbox", true)
					update_message("You can't take it now! Walk or cycle to mix up Apricorns.")
					return
				end
				@choose = 2

			# Check flavor
			when 2

				if $PokemonGlobal.apricorn_juice_first.size == 0
					set_visible_sprite("textbox", true)
					update_message("You don't have any Apricorns in Aprijuice, put it to create Aprijuice.")
					return
				elsif $PokemonGlobal.apricorn_juice_step < STEP_APRIJUICE
					set_visible_sprite("textbox", true)
					update_message("You can't take it now! Walk or cycle to mix up Apricorns.")
					return
				end
				@choose = 3

			# Guide
			when 3 then guide_mess
			# Exit
			when 4, -1 then @exit = true
			end
		end

	end
end