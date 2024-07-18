module Pokeathlon
	class Play_Athlon

		# eventname: Name of event defines name of graphics
		# arrpr: array of proc -> use proc to call event
		# arrre: array (string) -> Show string in result scene.
		# 	Ex: "Total Time: ", " Seconds" (attention: it's 1 event) - if size of 1 event in arrre, string will show float number
		def general_3_events(eventname, arrpr, arrre)

			# Draw information each course - Left screen
			step_draw_infor_each_course(eventname[0])
			# Show guide - Right screen
			guide = eventname.map { |e| e += " Guide" }
			show_description(guide[0])
			pbWait(10)
			15.times {
				update_ingame
				@sprites["black"].opacity -= 17
			}
			# Wait to press button
			wait_to_read_guide
			# Fade
			fade_in
			hide_start_things

			# First event
			arr = arrpr[0].call
			@store[:scoref][0] = arr[0]
			@store[:miss].map!.with_index { |m, i| m += arr[1][i] }
			@store[:score_special] = arr[2]
			@store[:score_individual].map!.with_index { |m, i| m += arr[3][i] }

			# Draw before showing
			show_create_between_2_events

			# Fade
			fade_out

			# Result
			mess("All right! Results of the first event!?") { update_animated_result_mess(false) }
			str = arrre[0]
			move_result_bar(str[0], str[1], str[2], str[3])
			mess("<fs=80>Team #{@store[:champ_fake]}</fs>", true) { update_animated_result_mess }
			mess("Congratulations on First Place!") { update_animated_result_mess }
			mess("This event's results will be determined by points!") { update_animated_result_mess }
			# Fade
			fade_in

			# Draw points
			update_number_on_table(@store[:scoref][0])

			fade_out
			mess("Aim to score the most points in the next competition as well!") { update_animated_result_mess }

			# Reset position (result)
			fade_in
			reset_position_result
			
			# New event
			show_start_event("Event 2", true)
			step_draw_infor_each_course(eventname[1])
			show_description(guide[1])
			pbWait(10)
			15.times {
				update_ingame
				@sprites["black"].opacity -= 17
			}
			# Wait to press button
			wait_to_read_guide
			# Fade
			fade_in
			hide_start_things

			# Second event
			arr = arrpr[1].call
			@store[:scoref][1] = arr[0]
			@store[:miss].map!.with_index { |m, i| m += arr[1][i] }
			@store[:score_special] = arr[2]
			@store[:score_individual].map!.with_index { |m, i| m += arr[3][i] }

			# Draw before showing
			show_create_between_2_events

			# Fade
			fade_out

			# Result
			mess("So exciting! How was the second event!?") { update_animated_result_mess(false) }
			str = arrre[1]
			move_result_bar(str[0], str[1], str[2], str[3])
			mess("<fs=80>Team #{@store[:champ_fake]}</fs>", true) { update_animated_result_mess }
			mess("Congratulations on First Place!") { update_animated_result_mess }
			mess("This event's results will be determined by points!") { update_animated_result_mess }
			# Fade
			fade_in

			# Draw points
			update_number_on_table(@store[:scoref][1])

			fade_out
			mess("Suddenly, we're at the final event! Victory could be in anyone's grasp!") { update_animated_result_mess }

			# Reset position (result)
			fade_in
			reset_position_result

			# New event
			show_start_event("Event 3", true)
			step_draw_infor_each_course(eventname[2])
			show_description(guide[2])
			pbWait(10)
			15.times {
				update_ingame
				@sprites["black"].opacity -= 17
			}
			# Wait to press button
			wait_to_read_guide
			# Fade
			fade_in
			hide_start_things

			# Third event
			arr = arrpr[2].call
			@store[:scoref][2] = arr[0]
			@store[:miss].map!.with_index { |m, i| m += arr[1][i] }
			@store[:score_special] = arr[2]
			@store[:score_individual].map!.with_index { |m, i| m += arr[3][i] }

			# Draw before showing
			show_create_between_2_events

			# Fade
			fade_out

			# Result
			mess("The end! How was the third event?!") { update_animated_result_mess(false) }
			str = arrre[2]
			move_result_bar(str[0], str[1], str[2], str[3])
			mess("<fs=80>Team #{@store[:champ_fake]}</fs>", true) { update_animated_result_mess }
			mess("Congratulations on First Place!") { update_animated_result_mess }
			mess("This event's results will be determined by points!") { update_animated_result_mess }
			# Fade
			fade_in

			# Draw points
			update_number_on_table(@store[:scoref][2])

			fade_out
			mess("Everyone gave it their best!\nI'll announce the final results!") { update_animated_result_mess }

		end

	end
end