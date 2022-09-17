=begin
You need to write in file -> '0 - Set Moves.txt' like this:

1, MEGAHORN, Megahorn, Cool, 6, 0, 018, "Makes a great appeal, but allows no more to the end."

Format:
Each line is structured as follows, with commas separating each part:
1. ID number
This number must be different for each move. It must be a whole number greater than 0.
You can skip numbers (e.g. the sequence 23,24,25,197,198,199,... is allowed).
The order in which moves are numbered is not important.
Ex: 1

2. Internal name
This is how the scripts refer to the move.
Typically this is the same as the move name but written in all capital letters and with no spaces or symbols.
The internal name is never seen by the player.
Ex: MEGAHORN

3. Display name
The name of the move, as seen by the player.
Ex: Megahorn

4. Contest Type
"Cool","Beauty","Cute","Smart","Tough"
Ex: Cool

5. Hearts
Ex: 6 (for cool)

6. Jam
Jamming is a term used in Pokémon Contests and is a feature only in Pokémon Ruby, Sapphire, Emerald and in their Generation VI remakes Omega Ruby and Alpha Sapphire.
A Pokémon can only jam other Pokémon which have already appealed this round.
Jamming causes the other Pokémon to become startled, lowering the appeal points of the startled Pokémon by the number of black hearts for each move.
In Generation III, if not executed correctly, it only says that the move messed up, and it still gains appeal points and any other extra.
For example, if a move that affects all Pokémon after the user is played last.
On the other hand, if the move backfires on the user, it causes them to lose appeal points.
(Bulbapedia)
Ex: 0

7. Function Code
You can find this in 'def pbFunctionsAdjustHearts'
Ex: 018
You can define 123 or 5124 but you need to add this function in def above

8. Description
The move's description.
Ex: "Makes a great appeal, but allows no more to the end."

In this pbs 4 moves:
1. First Impression
2. Pollen Puff
3. Lunge
4. Leafage
I just copy of megahorn moves. So, you need to edit if you want to use.
=end

module SetContestMoves
	# Set dir and file
	# You can change 2 strings if you changed name of file
	DIR_TXT  = "Plugins/Pokemon contest/0 - Move/"
	FILE_TXT = "0 - Set Moves"
	# Value
	@@move = {
		:id_number => [],
		:id => [],
		:name => [],
		:type => [],
		:heart => [],
		:jam => [],
		:function => [],
		:description => []
	}

	def self.push_str(pos=0)
		@@move[:id_number][pos] = ""
		@@move[:id][pos] = ""
		@@move[:name][pos] = ""
		@@move[:type][pos] = ""
		@@move[:heart][pos] = ""
		@@move[:jam][pos] = ""
		@@move[:function][pos] = ""
		@@move[:description][pos] = ""
	end

	def self.r_move = @@move
	def self.r_func(name) = @@move[name]
	
	def self.set_moves
		name = "#{FILE_TXT}.txt"
		return unless File.file?("#{DIR_TXT}#{name}")
		file = "#{DIR_TXT}#{name}"
		pos = 0
		File.foreach(file) { |line|
			count = 0
			self.push_str(pos)
			word = line.chars if !word
			word.each { |w|
				next if w == "\n"
				if w == ',' && count < 7
					count += 1
					next
				end
				case count
				when 0 then @@move[:id_number][pos] += w
				when 1 then @@move[:id][pos] += w
				when 2 then @@move[:name][pos] += w
				when 3 then @@move[:type][pos] += w
				when 4 then @@move[:heart][pos] += w
				when 5 then @@move[:jam][pos] += w
				when 6 then @@move[:function][pos] += w
				when 7 then @@move[:description][pos] += w
				end
			}
			pos += 1
		}
	end

	def self.modify_description
		des = @@move[:description]
		des.each_with_index { |d, i|
			w = d.chars
			@@move[:description][i] = d[1...(w.size-1)]
		}
	end

	def self.change_number(name) = @@move[name].each_with_index { |num, i| @@move[name][i] = num.to_i }

	def self.modify_number
		number = [:id_number, :heart, :jam, :function]
		number.each { |name| self.change_number(name) }
	end

	def self.modify_id = @@move[:id].each_with_index { |id, i| @@move[:id][i] = id.to_sym }
end
# Save in data
SetContestMoves.set_moves
SetContestMoves.modify_description
SetContestMoves.modify_number
SetContestMoves.modify_id