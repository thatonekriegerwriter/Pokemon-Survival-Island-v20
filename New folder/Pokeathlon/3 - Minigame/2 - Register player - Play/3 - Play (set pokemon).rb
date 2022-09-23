module Pokeathlon

	class Play_Athlon < Minigame_Main
		# Set id of event (event of Examiner)
		# Change number when you edit in map `Play Athlon`
		EXAMINER = 1
		# You can set one string or multi-strings or not.
		# If it's multi, it will choose randomly
		# If it's [], it will use graphic of event
		# Use string and it's name of files that you stored in folder 'Graphics\Characters'
		GRAPHIC_EXAMINER = []

		# Set name of trainer (custom)
		SET_NAME = ["Alice", "Joy", "Rachen", "Lily", "John"]
		# Set id of event (Event of candidats)
		# Change number when you edit in map `Play Athlon`
		CANDIDATS = [2, 3, 4]
		# If you want image of NPC (candidats) change, first set RANDOM_GRAPHIC_CANDIDAT true
		RANDOM_GRAPHIC_CANDIDAT = false
		# If you want image of 3 candidats use in one array (random), set SAME_RANDOM_CANDIDAT true and add in ARRAY_SAME_RANDOM_CANDIDAT
		# If not, it will separate and add in ARRAY_SEPARATE_RANDOM_CANDIDAT
		# Use string and it's name of files that you stored in folder 'Graphics\Characters'
		SAME_RANDOM_CANDIDAT = true
		ARRAY_SAME_RANDOM_CANDIDAT = ["trainer_TEAMROCKET_M", "trainer_POKEMONTRAINER_Brendan"]
		ARRAY_SEPARATE_RANDOM_CANDIDAT = [
			# First candidat
			["NPC 11", "NPC 10"],
			# Second candidat
			["NPC 01", "NPC 02"],
			# Third candidat
			["trainer_ROCKER", "trainer_RIVAL2"]
		]

		def initialize
			super

			# Viewport
			@vp2 = Viewport.new(0, 0, Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT)
			@vp2.z = 99999

			@vpall = Viewport.new(0, 0, Graphics.width, Graphics.height)
			@vpall.z = 99999

			# Set pokemon
			species = Pokeathlon.pkmn_id
			pkmn = []
			9.times { |i| pkmn << species.sample }
			form = []
			pkmn.each { |i| form << set_form(i) }
			pkmntrainer = []
			pkmn.each_with_index { |pk, i| pkmntrainer << Pokemon.new(pk, 1) }
			pkmntrainer = pkmntrainer.each_with_index { |pk, i| pk.form = form[i] }
			count = -1
			namef = nil
			pkmntrainer.each_with_index { |pk, i|
				if i % 3 == 0
					count += 1
					namef  = SET_NAME.sample
				end
				name = !SET_NAME.is_a?(Array) || SET_NAME.size == 0 ? "#{count}" : namef
				Pokeathlon.set_pkmn_infor_course(pk, name)
			}

		end

		def set_form(pkmn)
			form = []
			GameData::Species.each { |s| form << s.form if s.id == pkmn }
			return form.sample
		end

		def create_sprite(spritename, filename, vp, dir="00 - Main")
			super(spritename, filename, vp, dir)
		end

		def set_sprite(spritename, filename, dir="00 - Main")
			super(spritename, filename, dir)
		end

		def fade_in(vp=@vpall)
			super(vp)
		end

		def fade_out(vp=@vpall)
			super(vp)
		end

		def endScene
			super
			@vp2.dispose
			@vpall.dispose
		end

	end

	def self.play_athlon
		f = Play_Athlon.new
		f.play
	end

end