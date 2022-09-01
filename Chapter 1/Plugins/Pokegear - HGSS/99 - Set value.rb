=begin

Guide:

** Register feature **
Use PokegearHGSS.list(name, hash)
	'name' defines feature, must be unique
	'hash' defines properties of this feature

	Values must write in this hash
		order -> arrange features in this gear (Pokegear) (Numeric)
		graphic -> graphic uses to show in this script (HGSS) (Hash)
			dir   -> dir stores graphic (sub dir) - Can set or not (String)
			scene -> graphic of scene (store in \Pokegear HGSS\Scene -> default) (String)
			mini  -> graphic of this feature in bar (below of scene) (store in \Pokegear HGSS\Mini -> default) (String)
		start -> stores method to display (Just write class method - use def start to play)

** Set seen or not feature **
Use PokegearHGSS.seen(name, value)
	'name' defines feature, set like PokegearHGSS.list if you want this feature opened
	'value' defines seen or not, use Boolean (true or false)
-> Use this method in 'Intro' event or before get pokegear
Example: PokegearHGSS.seen("Main", true)

=end

# Fisrt feature, you can find with keyword 'class FirstFeature'
# This method shows background and time (or whatever you want)
PokegearHGSS.list("Main", {
	:order => 0,
	:graphic => {
		:dir   => "Main", # Dir
		:scene => "Main_", # Filename
		:mini   => "Main_"  # Filename
	},
	:start => PokegearHGSS::FirstFeature.new
})

# Second feature, you can find with keyword 'class SecondFeature'
# This method changes background
PokegearHGSS.list("Customize", {
	:order => 1,
	:graphic => {
		:dir   => "Customize", # Dir
		:scene => "Customize_", # Filename
		:mini   => "Customize_"  # Filename
	},
	:start => PokegearHGSS::SecondFeature.new
})

# Custom feature, you can find with keyword 'class CustomFeature2'
# This method shows background (to detail what script do) and description (brief)
# There are one rectangle to show this feature that you set
# With this feature, CustomFeature2, you need to add new function
#
# Example:
# 	PokegearHGSS::CustomFeature2.new(name, hash)
#			'name' defines feature, must be unique 
#					but you can set it like name of PokegearHGSS.list
#			'hash' defines properties of this feature
# 		
# 		Value must write in this hash:
#				dir -> dir stores graphic (subdir - in Detail) - Can set or not (String)
#				bg -> store graphic to detail this custom (store in Detail) (String)
#				detail -> show line to present this custom (String)
#
# -> Check example if you don't know how to add
PokegearHGSS.list("Map", {
	:order => 2,
	:graphic => {
		:dir   => "Map", # Dir
		:scene => "Map_", # Filename
		:mini   => "Map_"  # Filename
	},
	:start => PokegearHGSS::CustomFeature2.new("map", {
							:dir => "Map",
							:bg => "Map",
							:detail => "Show map to check"
						})
})

# Test with custom feature, use mining game to test
PokegearHGSS.list("Mininggame", {
	:order => 3,
	:graphic => {
		:dir   => "Map", # Dir
		:scene => "Map_", # Filename
		:mini   => "Map_"  # Filename
	},
	:start => PokegearHGSS::CustomFeature2.new("mininggame", {
							:dir => "Map",
							:bg => "Map",
							:detail => "Play minigame"
						})
})

# Third feature, you can find with keyword 'class ThirdFeature'
# This method shows list with page use in 'class StorePage'
PokegearHGSS.list("Radio", {
	:order => 4,
	:graphic => {
		:dir   => "Radio", # Dir
		:scene => "Radio_", # Filename
		:mini   => "Radio_"  # Filename
	},
	:start => PokegearHGSS::ThirdFeature.new
})

# Fourth feature, you can find with keyword 'class FourthFeature'
PokegearHGSS.list("Phone", {
	:order => 5,
	:graphic => {
		:dir   => "Phone", # Dir
		:scene => "Phone_", # Filename
		:mini   => "Phone_"  # Filename
	},
	:start => PokegearHGSS::FourthFeature.new
})