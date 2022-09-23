module Pokeathlon
	@@infor_course = {}
	@@course_name  = ""

	module_function

	def infor_course = @@infor_course
	def course_name  = @@course_name
	def set_course_name(str="")
		@@course_name = str
	end
	
	# Create this def to confirm: This value reset
	def reset_infor_course
		@@infor_course = {}
	end

	# pkmn: name of pokemon
	# team: name of trainer
	# miss: pokemon miss in course (it counts) - it's different original game.
	# Effort bonus has only `missed collecting the most points`
	def set_pkmn_infor_course(pkmn, team, pos=0)
		@@infor_course[pkmn] = {
			position: pos,
			id: pkmn.species,
			form: pkmn.form,
			team: team
		}
	end
end