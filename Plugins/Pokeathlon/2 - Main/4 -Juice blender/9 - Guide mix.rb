module Pokeathlon
	class JuiceBlender

		# Write guide
		def guide_mess
			arr = [
				"You can put form 1 to 5 apricorn at once but this will not produce a drink instantly.",
				"You must walk or cycle 100 steps to mix up Apricorns.",
				"Once a batch of Aprijuice is finished mixing, then more Apricorns can be added.",
				"You can check flavor to know flavor of Aprijuice.",
				"If sum of flavors is greater than 100, the strongest flavor among those that were not boosted by the addition of the Apricorn is chosen",
				"(if there is a tie, the first among the order of Power, Stamina, Skill, Jump, and Speed is chosen)",
				"a random flavor is chosen if a Black Apricorn was added, and no flavor is chosen if a White Apricorn was added.",
				"In 'Check flavor', just show 100 if sum of flavors is greater than 100.",
				"Every 100 steps taken increases the mildness of an Aprijuice by 1, up to a maximum of 255."
			]
			arr.each { |i| update_message(i) }
		end

	end
end