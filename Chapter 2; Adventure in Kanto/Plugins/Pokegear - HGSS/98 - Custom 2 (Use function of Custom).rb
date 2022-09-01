module PokegearHGSS

	# Custom feature 2 stores value and displays in CustomFeature
	class CustomFeature2

		def initialize(name=nil,hash=nil)
			return if !name
			return if !hash
			if !hash.is_a?(Hash)
				self.error("Set custom with Hash! Please, read or see examples!")
				return
			end
			@custom = {}
			@custom[name.to_sym] = hash
			@name = name.to_sym
		end

		def start(pos, list, feature)
			custom = CustomFeature.new
			custom.set_value_custom(@custom[@name])
			custom.start(pos, list, feature)
			loop do
				break if custom.exit || custom.changed
				# Show / Play
				if custom.play
					set_play
					custom.play = false
				else
					custom.show
				end
			end
			# End (return @posfeature)
			return custom.finish
		end

		def set_play
			case @name
			# Show map
			when :map
				pbShowMap(-1,false)
			# Other example
			# You can delete this example or add =begin and =end
			# Start at 'when :mininggame' and finish at '}'
			when :mininggame
				pbFadeOutIn {
					scene = MiningGameScene.new
					screen = MiningGame.new(scene)
					screen.pbStartScreen
				}
			# Add new feature below this line
			# when :something
			# 	do something

			end
		end

	end
end