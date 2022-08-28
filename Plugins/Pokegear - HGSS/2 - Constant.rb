module PokegearHGSS

	# Quantity of icon bar (not included last icon: next or exit)
	# Don't set number less than 3
	MAX_ICON_BAR = 4 # 5 (Real number)

	# Check "can phone"
	# [ value, [map id 1, map id 2] ]
	# value: true -> show icon for check and vice-versa
	# If not, script doesn't use [map id 1, map id 2]
	# If true, in the map in [map id 1, map id 2], player can't call
	CANT_PHONE = [
		true,
		[2, 32]
	]

	class Show

		# Set delay of mouse
		# Don't change it
		DelayMouse = 0
		
		# Set maximum number of @background
		# Need bitmap if you set it
		MAX_BACKGROUND = 6

	end

	class FirstFeature < Show

		# Set x, y of each background, [ [x1, y1], [x2, y2] ]
		# Size of this array depends MAX_BACKGROUND, not less than number of MAX_BACKGROUND
		# Start at 0
		# If you set "middle", it will set in middle of axe (x or y)
		X_Y = [
			["middle", 66 + 9],
			["middle", 66 + 9],
			[100, 78],
			[96, 68],
			["middle", 22],
			[108, 78]
		]

		# Store days
		DAY_OF_WEEK = [
			"Sunday",
			"Monday",
			"Tuesday",
			"Wednesday",
			"Thursday",
			"Friday",
			"Saturday"
		]

	end

	class SecondFeature < Show

		# Set x, y of bitmap (bitmap to change background), only show one bitmap
		# If you set "middle", it will set in middle of axe (x or y)
		X_Y = ["middle", 50]

		# Set title of each background
		# [title 1, title 2, title 3]
		# Size of this array depends MAX_BACKGROUND, not less than number of MAX_BACKGROUND
		TITLE = [
			"Blue screen",
			"Pink screen",
			"Rocket screen",
			"Japanese screen",
			"Pokemon League screen",
			"Silph Co. screen"
		]
		
	end

	# Set quantity list that shows in background
	# Used in ThirdFeature and FourthFeature
	QUANTITY_LIST = 6

end