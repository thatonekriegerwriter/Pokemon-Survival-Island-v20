#===============================================================================
#
#   Help book (adventure rules) by bo4p5687; graphics by Richard PT
#
#===============================================================================

ItemHandlers::UseFromBag.add(:ADVENTURERULES, proc{ |item|
	next AdventureGuide.show ? 1 : 0
})

module AdventureGuide
	class Show
	attr_reader :unlocked

		def initialize
			@sprites = {}
			# Viewport
      @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z = 99999
			# Value
			@page = 0
			@oldpage = 0
			@position = []
			@exit = false
			# Title, description
			@list = AdventureGuide.r_list
			@text = []
			@description = []
			@lines = []
			@unlocked = []
			@potato = false
			# Frames, reset frames
			@frames = 0
			@pos_des_per_frames = 0
		end

	end
	
	def self.show
		pbFadeOutIn {
			s = Show.new
			s.show
			s.endScene
		}
	end
end