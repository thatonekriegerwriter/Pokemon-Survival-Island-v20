module Pokeathlon
	
	class Register_Athlon
		# Set quantity of pokemon who can play in this course
		# Don't touch it
		SIZE_PKMN = 3

		def self.talk
			registered = false

			# NPC
			pbMessage("Welcome!\nThis is reception for admission.")
			mess = "Will you try the Pokeathlon?"
			arr  = ["Join", "Exit"]
			cmd  = pbMessage(mess, arr, arr.size) == 1
			if cmd
				pbMessage("Good bye! See you again!")
				return
			end
			arr = [
				"Speed",
				"Power",
				"Skill",
				"Stamina",
				"Jump",
				"Cancel"
			]
			mess = "Which course would you like to try?"
			cmd  = pbMessage(mess, arr, arr.size)
			case cmd
			when arr.size - 1 then pbMessage("Good bye! See you again!")
			else
				if $player.party.size == 0
					pbMessage("Oh! You don't have any pokemon!")
					pbMessage("Good bye! See you again!")
					return
				end
				infor = Pokeathlon.infor_course

				# Menu choose pokemon
				number = SIZE_PKMN
				ret   = Pokeathlon.chose_condition(number, true)
				if ret
					index = ret.values
					ret   = ret.keys
				end
				if !ret || ret.size < number
					pbMessage("Oh! You don't want to play!")
					pbMessage("Good bye! See you again!")
					return registered
				end

				mess = "You want to try #{arr[cmd]} Course?"
				if !pbConfirmMessage(mess)
					pbMessage("Oh! You don't want to play!")
					pbMessage("Good bye! See you again!")
					return registered
				end

				pbMessage("Please come this way.")

				Pokeathlon.set_course_name(arr[cmd])
				ret.each_with_index { |pk, i| Pokeathlon.set_pkmn_infor_course(pk, $player.name, index[i]) }

				registered = true
			end

			return registered
		end
	end

	def self.register_athlon = Register_Athlon.talk

end