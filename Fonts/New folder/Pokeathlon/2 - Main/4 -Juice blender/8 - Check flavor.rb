module Pokeathlon
	class JuiceBlender

		#--------------#
		# Check flavor #
		#--------------#
		def choose_feature_2_choose_3
			return if @choose != 3
			if !@sprites["check window"]
				text  = ""
				sum = $PokemonGlobal.apricorn_juice_flavor.inject(:+)
				sum = 100 if sum > 100
				text += "<ac>Check Flavor - Sum of flavors: #{sum}<ac>\n"
				text += text_check_flavor
				text += "<ac>Press USE or BACK key to exit<ac>"
				@sprites["check window"] = Window_AdvancedTextPokemon.new(_INTL(text))
				@sprites["check window"].resizeToFit(@sprites["check window"].text, Graphics.width)
				x = (Graphics.width - @sprites["check window"].width) / 2
				set_xy_sprite("check window", x, 0)
				@sprites["check window"].viewport = @viewport
			end

			loop do
				update_ingame
				# Update
				update_scene
				break if checkInput(Input::BACK) || checkInput(Input::USE)
			end

			# Dispose
			dispose("check window")
			@choose = 0
		end

		def text_check_flavor
			text = ""
			arr  = [:spicy, :sour, :dry, :bitter, :sweet]
			first  = $PokemonGlobal.apricorn_juice_strongest_first
			second = $PokemonGlobal.apricorn_juice_strongest_second
			third  = $PokemonGlobal.apricorn_juice_strongest_third
			flavor = $PokemonGlobal.apricorn_juice_flavor
			present = flavor.count { |f| f > 0 }
			# Strongest
			if !first.nil? && flavor[first] > 0
				arrtxt = [
					["It's a spicy flavor.", "A little sour.", "A refined, dry taste.", "A somewhat bitter taste.", "A sweet taste."],
					["A pungent flavor.", "An invigorating flavor.", "A strong, dry taste!", "A slightly bitter flavor.", "A nice, sweet taste."],
					["So spicy, you'll sweat!", "Mmmmmph! Sour!", "Incredibly dry!", "An intense bitterness!", "Very sweet!"],
					["So spicy, it causes coughing!", "Unbearably sour!", "A pervadingly dry taste!", "A massively bitter taste!", "A sickly-sweet flavor!"],
					["A resounding spiciness!", "A deep sourness!", "A deep-seated, dry taste!", "A sinking bitterness!", "A melt-in-your-mouth sweetness."],
					["The ultimate spiciness!", "An extremely sour taste!", "An extremely dry taste!", "The peak of bitterness!", "So incredibly sweet!"]
				]
				txt = 
					case flavor[first]
					when 1..20  then arrtxt[0][first]
					when 21..30 then arrtxt[1][first]
					when 31..40 then arrtxt[2][first]
					when 41..50 then arrtxt[3][first]
					when 51..62 then arrtxt[4][first]
					when 63     then arrtxt[5][first]
					end
				text += "<ac>#{txt}<ac>\n"
			end
			# Second (strongest)
			if flavor[second] > 0
				arrtxt = [
					["A hint of spicy taste.", "A hint of sourness.", "A slight dry taste.", "Barely a hint of bitterness.", "Barely a hint of sweetness."],
					["A little salty.", "A little sour.", "A light dry taste.", "Just a little bitter.", "Just a little sweet."],
					["Quite spicy.", "Quite sour.", "A quite dry taste.", "A strongly bitter taste.", "A strongly sweet taste."],
					["A strong spiciness.", "Intensely sour.", "An intensely dry taste.", "Intensely bitter.", "An intensely sweet taste."]
				]
				txt = 
					case flavor[second]
					when 1..20  then arrtxt[0][second]
					when 21..30 then arrtxt[1][second]
					when 31..40 then arrtxt[2][second]
					else
						arrtxt[3][second]
					end
				text += "<ac>#{txt}<ac>\n"
			end
			# Third
			if flavor[third] && present != 5
				arrtxt = [
					["A very faint spiciness.", "A very faint sourness.", "A very faint dry taste.", "A very faint bitterness.", "A very faint sweetness."],
					["Merely a hint of spiciness.", "Merely a hint of sourness.", "A hint of dry taste.", "Merely a hint of bitterness.", "Merely a hint of sweetness."],
					["The spiciness comes through.", "The sourness comes through.", "The dryness comes through.", "The bitterness comes through.", "The sweetness comes through."]
				]
				txt = 
					case flavor[third]
					when 1..10  then arrtxt[0][third]
					when 11..20 then arrtxt[1][third]
					else
						arrtxt[2][third]
					end
				text += "<ac>#{txt}<ac>\n"
			end
			# Add new text
			if present >= 4
				# 1 - 7
				text += "<ac>quite weak<ac>\n" if (!first.nil? && flavor[first].between?(1, 7)) || (first.nil? && second && flavor[second].between?(1, 7))
				# 8 - 20
				if (!first.nil? && flavor[first].between?(8, 20)) || (first.nil? && second && flavor[second].between?(8, 20))
					if present == 4
						text += "<ac>Unspeakably incredible<ac>\n" if (!first.nil? && second && (flavor[first] - flavor[second]).between?(1, 12)) || (first.nil? && second && third && (flavor[second] - flavor[third]).between?(1, 12))
					elsif present == 5
						text += "<ac>Evenly balanced<ac>\n" if (!first.nil? && second && flavor[second].between?(1, 12)) || (first.nil? && second && third && flavor[third].between?(1, 12))
					end
				# 21 +
				elsif (!first.nil? && flavor[first] > 20) || (first.nil? && second && flavor[second] > 20)
					txt = present == 4 ? "Incredibly unspeakable" : "Competing"
					text += "<ac>#{txt}<ac>\n"
				end
			end
			# New text
			text += "<ac>Refreshing aftertaste<ac>\n" if present.between?(1, 2)
			text += "<ac>Disgusting aftertaste<ac>\n" if present == 5
			if present == 4
				index = flavor.index(0)
				text += "<ac>Eliminating #{arr[index]}<ac>\n"
			end
			return text
		end

	end
end