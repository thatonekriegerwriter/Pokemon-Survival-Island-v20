module Pokeathlon
	class FeedJuice

		# Use when player feed pokemon
		def show2(&block)
			# Scene
			create_scene
			# Play cry
			cry_pkmn
			# Update
			update_marking
			# Draw text
			draw_information
			# Animation
			feed_animation(&block)
			loop do
				update_ingame
				# Animation
				update_star
				break if checkInput(Input::USE) || checkInput(Input::BACK)
			end
			$player.party[@pkmn[:index]] = @pkmn[:name]
		end

		def feed_animation
			# Item
			create_sprite("item", "Icon item", @viewport)
			w = @sprites["item"].bitmap.width  / 2
			h = @sprites["item"].bitmap.height / 2
			set_oxoy_sprite("item", w, h)
			x = 308 + 182 / 2
			y = 128 + 182 / 2
			set_xy_sprite("item", x, y)
			# Item
			30.times {
				update_ingame
				@sprites["item"].y -= 2
			}
			10.times {
				update_ingame
				@sprites["item"].angle += 1
			}
			# Pokemon
			5.times {
				update_ingame
				@sprites["pkmn"].zoom_x -= 0.1
				@sprites["pkmn"].zoom_y += 0.05
			}
			set_visible_sprite("item")
			5.times {
				update_ingame
				@sprites["pkmn"].zoom_x += 0.1
				@sprites["pkmn"].zoom_y -= 0.05
			}
			# White screen
			alpha = 0
			15.times {
				update_ingame
				alpha += 17
				@viewport.color = Color.new(255, 255, 255, alpha)
			}
			# Decrease star here
			yield if block_given?
			update_star(4)
			# Normal screen
			15.times {
				update_ingame
				alpha -= 17
				@viewport.color = Color.new(255, 255, 255, alpha)
			}
			# Play cry
			cry_pkmn
			# Information (what changed?)
			st = ["Speed", "Power", "Skill", "Stamina", "Jump"]
			before = @pkmn[:name].athlon_normal
			after  = @pkmn[:name].athlon_normal_changed
			5.times { |i|
				next if before[i] == after[i]
				txt = before[i] > after[i] ? "decreased" : "increased"
				pbMessage(_INTL("#{st[i]} Performance #{txt}!")) {
					update
					update_star
				}
			}
		end

	end
end