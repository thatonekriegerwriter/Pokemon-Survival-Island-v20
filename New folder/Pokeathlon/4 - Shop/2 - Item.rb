module Pokeathlon
	module_function

	def shop_points(speech=nil)
		items = [
			# Form: [ [item, price], [item, price] ]
			# Sunday
			[ [:REDAPRICORN, 200], [:BLUEAPRICORN, 200], [:KINGSROCK, 3000], [:HEARTSCALE, 2000] ],
			# Monday
			[ [:REDAPRICORN, 200], [:BLUEAPRICORN, 200], [:MOONSTONE, 3000], [:RARECANDY, 2000] ],
			# Tuesday
			[ [:YELLOWAPRICORN, 200], [:PINKAPRICORN, 200], [:FIRESTONE, 3000], [:PPUP, 2000] ],
			# Wednesday
			[ [:BLUEAPRICORN, 200], [:PINKAPRICORN, 200], [:WATERSTONE, 3000], [:HEARTSCALE, 2000] ],
			# Thursday
			[ [:YELLOWAPRICORN, 200], [:PINKAPRICORN, 200], [:THUNDERSTONE, 3000], [:PPUP, 2000] ],
			# Friday
			[ [:REDAPRICORN, 200], [:YELLOWAPRICORN, 200], [:METALCOAT, 3000], [:NUGGET, 2000] ],
			# Saturday
			[ [:GREENAPRICORN, 200], [:WHITEAPRICORN, 200], [:BLACKAPRICORN, 200], [:LEAFSTONE, 3000], [:RARECANDY, 2000] ]
		]
		item = items[pbGetTimeNow.wday]
		self.shop_exchange(item, speech)
	end

end