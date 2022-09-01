module BerryBlender

	class Show
		# Set name of AI
		NAME_AI = ["A", "B", "C"] # Need have size that is greater than 0
		NAME_SPECIAL = "D" # Can 1 name or multiple name (String or Array)
		# Set max speed (decrease)
		MAX_SPEED = 5

		def initialize(player)
			@sprites = {}
			# Viewport
      @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z = 99999
			# Values
			# Set number to define player, quantity of players
			@player = player
			# Set name
			@name = []
			@name << $Trainer.name
			player.times { @name << NAME_AI.sample } if player != 0 && player != 4
			if player == 4
				if NAME_SPECIAL.is_a?(String)
					@name << NAME_SPECIAL
				elsif NAME_SPECIAL.is_a?(Array)
					@name << NAME_SPECIAL.sample
				end
			end
			if @name.uniq.size != @name.size
				count = {}
				@name.each { |name|
					if count[name].nil?
						count[name] = [false, 0]
					else
						count[name][0]  = true
						count[name][1] += 1
					end
				}
				num = {}
				count.each { |k, _| num[k] = 0 }
				realname = []
				@name.each_with_index { |name, i|
					if count[name][1] == 0
						realname << name
						next
					end
					realname[i] = "#{name} '#{num[name]+1}'"
					num[name] += 1
				}
				@name = realname
			end
			# Store berry
			@berry = []
			# Set speed of circle
			@speed  = MAX_SPEED
			@frames = 0
			# Set frame to increase angle
			@frames_rate = 0
			@old_frames_rate = Graphics.frame_rate
			# Speed to define PokeBlock
			@speedTxt = 7
			@notPress = @player == 0 ? 400 : 100 * @player
			@maxSpeed = 0
			# Count good, miss, perfect
			@count = {}
			@showFeature = {}
			@pressCheck  = []
			@name.each { |name|
				@count[name] = { perfect: 0, good: 0, miss: 0 }
				@showFeature[name] = { perfect: [], good: [], miss: [] }
				# Use to check if player press (AI)
				@pressCheck << false
			}
			@showEffect = false
			@trigger_effect = {}
			10.times { |i| @trigger_effect[i] = [false, 0] }
			# Result (show result)
			@result = false
			@checkall = false
			@showPage = 0
			# Set name of flavor after playing
			@flavorGet = ""
			# Set order
			@order = nil
			@orderNum = []
			# Fade
			@fade = false
			@countFade = 0
			# Finish
			@exit = false
		end

	end

	# 0: 1 player
	# 1: 2 players
	# 2: 3 players
	# 3: 4 players
	# 4: player + special player
	def self.show(player=0)
		# Check Berry
		has = false
		item = []
		GameData::Item.each { |i| item << i.id }
		item.each { |i| has = true if $PokemonBag.pbQuantity(i)>0 && GameData::Item.get(i).is_berry? }
		if !has
			pbMessage(_INTL("You don't have any berry!"))
			return
		end
    again = true
    # Play
    loop do
			if again
				pbFadeOutIn {
					f = Show.new(player)
					f.show
					f.endScene
				}
				again = false
			else
				again = true if pbConfirmMessage(_INTL("Do you want to continue?"))
				break if !again
			end
		end
	end

end