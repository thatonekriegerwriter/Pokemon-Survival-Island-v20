module Pokeathlon
	class Change_Screen_Choose_pkmn

		# Expand screen (use in choose menu)
		def self.expand
			w = Settings::SCREEN_WIDTH
			h = Settings::SCREEN_HEIGHT
			SHOW_WIDTH ? (w *= 2) : (h *= 2)
			Graphics.resize_screen(w, h)
			Graphics.center if !Graphics.fullscreen
		end

		# Narrow screen (default screen)
		def self.narrow = self.expand_num

		# Expand screen
		def self.expand_num(disx=0, disy=0)
			w = Settings::SCREEN_WIDTH
			h = Settings::SCREEN_HEIGHT
			Graphics.resize_screen(w + disx, h + disy)
			Graphics.center if !Graphics.fullscreen
		end

		def self.resize_exact(w=Settings::SCREEN_WIDTH, h=Settings::SCREEN_HEIGHT)
			Graphics.resize_screen(w, h)
			Graphics.center if !Graphics.fullscreen
		end

	end
end