module PokegearHGSS
	
	class StorePage
		@@page = {}

		def set_content(name=nil,hash=nil)
			return if !name
			if !hash.is_a?(Hash)
				self.error("Use #{name} with Hash! Please, read or see examples!")
				return
			end
			@@page[name.to_sym] = hash
		end

		# Create new def to store and call again in new class
		# Don't create new def with name that is same name of old def
		# See 'def set_sprites_viewport' of 'class ThirdFeature' to learn
		#
		# Form:
		# 		set_content(name, hash)
		# 			'name' defines feature, must be unique
		# 			'hash' defines properties of this feature
		#
		# 			Value must write in this hash
		#					order -> arrange page
		# 				content -> store content to display
		#
		# Here, just create 2 page
		# If you need to create more, I suggest add value like next to check when next and previous to check when back
		def radio_content
			# First page
			set_content("first", {
				:order => 0,
				:content => [
					# Form: [name to display in game (string), action (use lamda]
					# 	The last of this array shows name to display then it goes next page or previous page
					# March
					["Radio - March", ->{
						pbBGMPlay("Radio - March", 100, 100)
						$PokemonMap.whiteFluteUsed = true if $PokemonMap
						$PokemonMap.blackFluteUsed = false if $PokemonMap
					}],
					# Lullaby
					["Radio - Lullaby", ->{
						pbBGMPlay("Radio - Lullaby", 100, 100)
						$PokemonMap.blackFluteUsed = true if $PokemonMap
						$PokemonMap.whiteFluteUsed = false if $PokemonMap
					}],
					# Oak
					["Radio - Oak", ->{
						pbBGMPlay("Radio - Oak", 100, 100)
						$PokemonMap.whiteFluteUsed = false if $PokemonMap
						$PokemonMap.blackFluteUsed = false if $PokemonMap
					}],
					# Next page
					["Custom", nil]
				]
			})
			# Second page
			files = [ ["Default"] ]
			Dir.chdir("Audio/BGM/") {
				Dir.glob("*.mp3") { |f| files.push([f]) }
				Dir.glob("*.MP3") { |f| files.push([f]) }
				Dir.glob("*.ogg") { |f| files.push([f]) }
				Dir.glob("*.OGG") { |f| files.push([f]) }
				Dir.glob("*.wav") { |f| files.push([f]) }
				Dir.glob("*.WAV") { |f| files.push([f]) }
				Dir.glob("*.mid") { |f| files.push([f]) }
				Dir.glob("*.MID") { |f| files.push([f]) }
				Dir.glob("*.midi") { |f| files.push([f]) }
				Dir.glob("*.MIDI") { |f| files.push([f]) }
			}
			files.size.times { |i|
				name = i == 0 ? nil : files[i][0]
				files[i].push(->{
					$game_system.setDefaultBGM(name)
					$PokemonMap.whiteFluteUsed = false if $PokemonMap
					$PokemonMap.blackFluteUsed = false if $PokemonMap
				})
			}
			files << ["Return", nil]
			set_content("second", {
				:order => 1,
				:content => files
			})
			return @@page
		end

	end
end