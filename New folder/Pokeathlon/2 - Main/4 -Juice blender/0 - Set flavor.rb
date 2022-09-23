module Pokeathlon
	module_function

	# Use when you put apricorn (need item)
	def plus_minus_flavor(item, arr)
		case item
		# Black
		when :BLACKAPRICORN then arr = arr.map { |a| a += 2 }
		# White
		when :WHITEAPRICORN then arr = arr.map { |a| a -= 2 }
		# Other
		else
			o = [:REDAPRICORN, :YELLOWAPRICORN, :BLUEAPRICORN, :GREENAPRICORN, :PINKAPRICORN]
			index1 = o.index(item)
			index2 = item == o.last ? 0 : (index1 + 1)
			arr[index1] += 4
			arr[index2] -= 2
		end
		return arr
	end

	# Flavor: calculate (use when player buy aprijuice)
	# Flavors are Power, Stamina, Skill, Jump, and Speed
	# It's different with PBS
	def calc_flavor_marchand(arr)
		if arr.size != 5
			echoln "Event: Buy aprijuice"
			echoln "Set 5 numbers in array to set flavor!"
			return
		end
		arr.map! { |a| a > 63 ? 63 : a < 0 ? 0 : a }
		arrhash1 = [:first, :second, :third, :fourth, :fifth]
		arrhash2 = arr
		hash = {}
		arr.size.times { |i| hash[arrhash1[i]] = arrhash2[i] }
		hash = hash.sort_by(&:last)
		sum  = arr.inject(:+)
		first  = arrhash1.index(hash[0][0])
		second = arrhash1.index(hash[1][0])
		third  = arrhash1.index(hash[2][0])
		last   = arrhash1.index(hash.last[0])
		return first, second, third, last, sum
	end

	# Calculate daily + aprijuice
	# pkmn  -> pokemon change stats
	# infor -> [first, second, third, last, sum of flavor]
	def calc_flavor_all(pkmn, infor=nil, buy=false, buynumber=0)
		arr = []
		day = Time.now.mday
		pID = pkmn.personalID & 0xFFFF
		pID = pID.to_s.split(//).map!(&:to_i)
		# Calculate: Day of month
		# Power, Stamina, Skill, Jump and Speed (number to calculate) -> 0, 1, 2, 3, 4
		# Order: speed, power, skill, stamina and jump
		st = [4, 0, 2, 1, 3]
		5.times { |i| arr << (((day + st[i] + 3) * (day - st[i] + 7) + pID[i]) % 10 * 2 - 9) }
		# Calculate: Nature
		# Special (Neutral)
		case pkmn.nature.id
		when :HARDY
			arr[1] += 10
			arr[0] -= 10
		when :DOCILE
			arr[3] += 10
			arr[4] -= 10
		when :QUIRKY
			arr[2] += 10
			arr[3] -= 10
		when :BASHFUL
			arr[4] += 10
			arr[1] -= 10
		when :SERIOUS
			arr[0] += 10
			arr[2] -= 10
		end
		# Normal (Non-neutral)
		# Decrease
		case pkmn.nature.id
		when :BOLD,    :MODEST,  :CALM,    :TIMID then arr[1] -= 35
		when :LONELY,  :MILD,    :GENTLE,  :HASTY then arr[3] -= 35
		when :ADAMANT, :IMPISH,  :CAREFUL, :JOLLY then arr[4] -= 35
		when :NAUGHTY, :LAX,     :RASH,    :NAIVE then arr[2] -= 35
		when :BRAVE,   :RELAXED, :QUIET,   :SASSY then arr[0] -= 35
		end
		# Increase
		case pkmn.nature.id
		when :LONELY, :ADAMANT, :NAUGHTY, :BRAVE   then arr[1] += 35
		when :BOLD,   :IMPISH,  :LAX,     :RELAXED then arr[3] += 35
		when :MODEST, :MILD,    :RASH,    :QUIET   then arr[4] += 35
		when :CALM,   :GENTLE,  :CAREFUL, :SASSY   then arr[2] += 35
		when :TIMID,  :HASTY,   :JOLLY,   :NAIVE   then arr[0] += 35
		end
		# Calculate: Aprijuice
		if pkmn.athlon_feed_juice
			arr.map! { |a| a += pkmn.athlon_change }
			# Case: see in party not feed pokemon
			# @athlon_daily
			return arr
		else
			# Use when player checks pokemon who doesn't drink
			# @athlon_daily
			return arr if infor.nil?
		end
		fake = [0, 0, 0, 0, 0]
		# Change position: first, second, third and last to same method define order: speed, power, skill, stamina and jump
		4.times { |i|
			next if infor[i].nil?
			infor[i] = st[infor[i]]
		}
		# Strongest
		sumfla = 0
		if infor[0]
			fake[infor[0]] += (infor.last * 1.5 + 10).to_i
			fake[infor[1]] += (infor.last * 1.5).to_i
			sumfla = fake[infor[0]] + fake[infor[1]]
		else
			fake[infor[1]] += (infor.last * 1.5 + 10).to_i
			fake[infor[2]] += (infor.last * 1.5).to_i
			sumfla = fake[infor[1]] + fake[infor[2]]
		end
		# Lowest
		number = buy ? buynumber : $PokemonGlobal.apricorn_juice_mildness
		decr =
			case number
			when 0..199   then 1 - 0.1 * (number / 25)
			when 200..254 then 0.2
			when 255      then 0.1
			end
		fake[infor[3]] -= decr * sumfla
		arr.map!.with_index { |a, i| a += fake[i] }
		# @athlon_daily, @athlon_change
		return arr, fake
	end

	# Add daily + aprijuice + stats
	def real_stats(pkmn)
		# Daily + aprijuice
		daily = pkmn.athlon_daily.clone
		min   = pkmn.athlon_normal.clone
		max   = pkmn.athlon_max.clone
		changed = pkmn.athlon_normal_changed.clone
		min.each_with_index { |s, i|
			nocare = daily[i].abs
			diff =
				case nocare
				when 80..119 then 3
				when 40..79  then 2
				when 15..39  then 1
				when 0..14   then 0
				else
					4
				end
			diff *= -1 if daily[i] < 0
			changed[i] = s + diff > max[i] ? max[i] : s + diff < 0 ? 0 : (s + diff)
		}
		return changed
	end
end