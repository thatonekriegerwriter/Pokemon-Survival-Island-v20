module BerryBlender
	class Show

		def set_order_result
			hash = {}
			@name.each_with_index { |name, i|
				arr1 = [name, @berry[i], []]
				arr2 = [:perfect, :good, :miss]
				sum  = 0
				arr2.each_with_index { |a, i|
					arr1[2] << @count[name][a]
					sum +=
						if i != 2
							10 ** (4 - i * 2) * @count[name][a]
						else
							- @count[name][a]
						end
				}
				hash[arr1] = sum
			}
			hash  = hash.sort_by(&:last).reverse.to_h
			num   = 0
			value = hash.values
			value.each_with_index { |v, i|
				num += 1
				if i == 0
					@orderNum << num
				else
					if value[i] == value[i-1]
						@orderNum[i] = @orderNum[i-1]
						num -= 1
					else
						@orderNum << num
					end
				end
			}
			@order = hash
			# Store in global
			store_in_global_result
		end

		def store_in_global_result
			sheen = BerryBlender.smooth(@berry, @player==0)
			if @berry.uniq.size != @berry.size
				# Black
				store_flavor_global_black(sheen)
			else
				list   = BerryPoffin.listBerry
				flavor = []
				@berry.each { |berry| flavor << BerryBlender.play(list, berry) }
				sum = [0, 0, 0, 0, 0]
				flavor.each { |fla|
					fla.each_with_index { |f, i| sum[i] += f }
				}
				sum.map! { |s| s * 10 }
				sum.map! { |s| s <= 0 ? (s - 1) : s }
				sum.map! { |s| s <= 0 ? 0 : s }
				vitess = @maxSpeed == 110 ? 1.33 : (@maxSpeed / 333 + 1).round(2)
				sum.map! { |s| s * vitess }
				sum.map! { |s| s.round }
				# Set global
				positive = sum.select { |s| s > 0 }
				level    = positive.max
				positionofmax = sum.index(level)
				flavorplus50  = sum.select { |s| s > 50 }.size > 0
				case positive.size
				when 0 then store_flavor_global_black(sheen)
				# 1 flavor
				when 1
					if flavorplus50
						name = "Gold"
					else
						arr  = ["Red", "Blue", "Pink", "Green", "Yellow"]
						name = arr[positionofmax]
					end
				# 2 flavors
				when 2
					if flavorplus50
						name = "Gold"
					else
						arr = ["Purple", "Indigo", "Brown", "Lite Blue", "Olive"]
						name = arr[positionofmax]
					end
				# Gray
				when 3 then name = "Gray"
				# White
				when 4, 5 then name = "White"
				end
				return if positive.size == 0
				$PokemonGlobal.berry_blender[name][:flavor] << sum
				$PokemonGlobal.berry_blender[name][:sheen]  << sheen
				$PokemonGlobal.berry_blender[name][:level]  << level
				# Set name
				@flavorGet = "#{name} Lv. #{level}"
			end
		end

		# Black flavor
		def store_flavor_global_black(sheen)
			arr  = []
			fake = []
			loop do
				random = rand(5)
				fake << random
				if fake.size == 3
					fake = [] if fake.uniq.size != fake.size
					break if fake.size == 3
				end
			end
			5.times { |i|
				if fake.include?(i)
					arr[i] = 2
					fake.delete(i)
				else
					arr << 0
				end
			}
			$PokemonGlobal.berry_blender["Black"][:flavor] << arr
			$PokemonGlobal.berry_blender["Black"][:sheen]  << sheen
			$PokemonGlobal.berry_blender["Black"][:level]  << 0
			# Set name
			@flavorGet = "Black"
		end

	end
end