module Pokeathlon
	@@pkmn = {}
	@@form = {}

	module_function

	def pkmn_clone = @@pkmn.clone
	def form_clone = @@form.clone
	def pkmn = @@pkmn
	def form = @@form

	# Write file basic
	def pkmn_id
		species = []
		GameData::Species.each { |s| species << s.id if s.form == 0 }
		return species
	end

	def write_pkmn
		id = self.pkmn_id
		File.open("pokemon.txt", 'wb') { |f|
			id.each { |i| f.write("#{i},\n") }
		}
	end

	# Store pbs
	DIR_TXT = "Plugins/Pokeathlon/1 - PBS"
	# if true, it will announce when you miss something in pbs
	MISS_PART_TXT = false

	def store_pbs_pkmn
		file = "pokemon.txt"
		name = "#{DIR_TXT}/#{file}"
		unless File.file?(name)
			echoln "You miss file #{file}"
			return
		end
		pkmn = self.pkmn
		pkmnname = nil
		File.foreach(name) { |line|
			word  = line.chars
			str   = ""
			count = 0
			word.each_with_index { |w, i|
				if count == 0
					if w == ","
						pkmnname = str.to_sym
						pkmn[pkmnname] = {}
						str = ""
						count += 1
					end
				else
					if count == 1
						if w == "," && word[i-1] == "]"
							pkmn[pkmnname][:max] = str.scan(/\d+/).map(&:to_i)
							str = ""
							count += 1
						end
					else
						if w == "]"
							pkmn[pkmnname][:min] = str.scan(/\d+/).map(&:to_i)
							break
						end
					end
				end
				str += w
			}
			# Check when pbs miss a part
			next unless MISS_PART_TXT
			error  = ""
			error += "-- Add max stats: #{pkmnname} " if pkmn[pkmnname][:max].nil?
			error += "-- Add min stats: #{pkmnname} " if pkmn[pkmnname][:min].nil?
			echoln error if error != ""
		}
	end

	def store_pbs_form
		file = "form.txt"
		name = "#{DIR_TXT}/#{file}"
		unless File.file?(name)
			echoln "You miss file #{file}"
			return
		end
		form = self.form
		pkmnname = nil
		File.foreach(name) { |line|
			word  = line.chars
			str   = ""
			count = 0
			arrf  = ""
			word.each_with_index { |w, i|
				if count == 0
					if w == ","
						pkmnname = str.to_sym
						form[pkmnname] = {} if form[pkmnname].nil?
						str = ""
						count += 1
					end
				else
					if count.between?(1, 2)
						if w == "," && word[i-1] == "]"
							if count == 1
								arrf = str.scan(/\d+/).map(&:to_i)
								form[pkmnname][arrf] = {}
							elsif count == 2
								form[pkmnname][arrf][:max] = str.scan(/\d+/).map(&:to_i)
							end
							str = ""
							count += 1
						end
					else
						if w == "]"
							form[pkmnname][arrf][:min] = str.scan(/\d+/).map(&:to_i)
							break
						end
					end
				end
				str += w
			}
		}
	end
end

# Store in game
Pokeathlon.store_pbs_pkmn
Pokeathlon.store_pbs_form