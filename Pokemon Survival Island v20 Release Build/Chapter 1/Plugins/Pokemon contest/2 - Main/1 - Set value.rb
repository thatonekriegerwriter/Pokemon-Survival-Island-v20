module ContestHall
	@@contest = {}

	def self.r_contest = @@contest
#==============================================================================#
#
#                                     Variables
#
#==============================================================================#

	def self.position_pkmn_contest(num) = (@@contest[:pospkmn] = num)

	# Set difficult, here
	# Easy -> Difficult
	DIFFICULT = [25, 50, 75, 100]

	def self.name_contest(num, num2)
		@@contest[:number] = num
		name = ["Cool", "Beauty", "Cute", "Smart", "Tough"]
		@@contest[:name] = name[num]
		@@contest[:difficult] = DIFFICULT[num2%4-1]
		@@contest[:ribbon] = num2
	end

#==============================================================================#
#
#          ID for the event and map used to move the player
#
#==============================================================================#
# Some event that I think you should don't delete it is 1, 2, 3, 4, 5, 6, 13
	# Event id in map contest
	EVENT_ID_CONTEST = 13
	# NPC id
	CONTEST_MAP_BEFORE_PLAY = 301
	CONTEST_MOVE_EVENT = 9
	# Door id (event - open door for NPC)
	CONTEST_DOOR_EVENT = [1, 3]
	# Form: map, x, y, facing down
	COORIDINATE_WHEN_FINISH_CONTEST = [CONTEST_MAP_BEFORE_PLAY, 1, 5, true]
#==============================================================================#
#
#         Information pertining to the start position on the CONTEST
#
#         Format is as following: [map_id, map_x, map_y]
#
#==============================================================================#
	# This is map id and coordinate of player after player transferred
	# 4 values are 4 ranks: normal, super, hyper and master
	# If you want contest that shows in same map, just set like the first value
	# ID
	MAP_ID = [302, 303, 304, 305]
	# x, y
	MAP_X  = [11, 11, 11, 11]
	MAP_Y  = [9,   9,  9,  9]
	def self.map_data(num) = [MAP_ID[num], MAP_X[num], MAP_Y[num]]

# If SET_MYSELF is true, you need to add pokemon when call script.
# If not and you set when you call script, script set move and name (if you wrote) not pokemon
# Add: pokemon
SET_MYSELF = false
# If true, the pokemons in Contest are random
RANDOM_POKEMONS = false
# If true, there are the cases: the similar pokemons
SIMILAR_POKEMONS = false
# You can set Pokemon in Contest with this (of course, the condition is RANDOM_POKEMONS = false)
# If true, the method for check is each contest will is the different Pokemons.
EACH_CONTEST = true
# This is Pokemon for all Contest (it uses random to choose)
# Add this if EACH_CONTEST = false
POKEMON_CONTEST = [
	[], # First (player)
	[], # Second (player)
	[]  # Third (player)
]
# This is Pokemon for each Contest (use random to choose)
# Cool
POKEMON_COOL = [
	[:LEDYBA, :MAKUHITA, :MIGHTYENA, :LOTAD, :POOCHYENA], # First (player)
	[:ARON, :POOCHYENA, :AGGRON, :ILLUMISE, :TRAPINCH], # Second (player)
	[:TOTODILE, :WHISMUR, :VOLBEAT, :WAILMER, :CORPHISH] # Third (player)
]
# Beauty
POKEMON_BEAUTY = [
	[:MILOTIC, :TYMPOLE, :VENIPEDE, :SCRAGGY, :TIRTOUGA], # First (player)
	[:SOLOSIS, :JOLTIK, :CHANDELURE, :SERPERIOR, :SAMUROTT], # Second (player)
	[:STOUTLAND, :MILOTIC, :LUCARIO, :ROSERADE, :INFERNAPE] # Third (player)
]
# Cute
POKEMON_CUTE = [
	[:RALTS, :PLUSLE, :MINUN, :ESPEON, :UMBREON], # First (player)
	[:EEVEE, :VAPOREON, :JOLTEON, :PORYGON, :PONYTA], # Second (player)
	[:DODUO, :GROWLITHE, :ESPEON, :GARDEVOIR, :LUVDISC] # Third (player)
]
# Smart
POKEMON_SMART = [
	[:CHIMCHAR, :AMBIPOM, :PANSAGE, :ZORUA, :RUFFLET], # First (player)
	[:MANDIBUZZ, :ZOROAK, :CUBONE, :GENGAR, :ZUBAT], # Second (player)
	[:ZOROAK, :ZORUA, :SNEASEL, :WEAVILE, :ARIADOS] # Third (player)
]
# Tough
POKEMON_TOUGH = [
	[:HARIYAMA, :WAILORD, :WHISCASH, :ABSOL, :PACHIRISU], # First (player)
	[:WAILORD, :BASTIODON, :LUCARIO, :TOXICROAK, :LICKILICKY], # Second (player)
	[:WAIMER, :WAILORD, :ARCHEN,:EMOLGA, :GALVANTULA] # Third (player)
]
#================
# Set level
# If true, you can change this level in array. If false, level will set like:
# Normal = 25  ;  Super = 50  ; Hyper = 75  ; Master = 100
SET_LEVEL_CONTEST = true
# Here, the order is level pokemon second, third and fourth
LEVEL_POKEMON_CONTEST_NORMAL = [25,  25,  25]
LEVEL_POKEMON_CONTEST_SUPER  = [50,  50,  50]
LEVEL_POKEMON_CONTEST_HYPER  = [75,  75,  75]
LEVEL_POKEMON_CONTEST_MASTER = [100, 100, 100]
#===============================================================================
#  Define Contest Combos here
#===============================================================================
# Define all combos here.
# First entry in array starts the combo, the rest are the options to follow it.
# Name them by their name used in the game, not the internal name.

combo1  = ["Belly Drum","Rest"]
combo2  = ["Calm Mind","Confusion","Dream Eater","Future Sight","Light Screen","Luster Purge","Meditate","Mist Ball","Psybeam","Psychic","Psycho Boost","Psywave","Reflect"]
combo3  = ["Charge","Shock Wave","Spark","Thunder","Thunderbolt","Thunder Punch","Thunder Shock","Thunder Wave","Volt Tackle","Zap Cannon"]
combo4  = ["Charm","Flatter","Growl","Rest","Tail Whip"]
combo5  = ["Confusion","Future Sight","Kinesis","Psychic","Teleport"]
combo6  = ["Curse","Destiny Bond","Grudge","Mean Look","Spite"]
combo7  = ["Defense Curl","Rollout","Tackle"]
combo8  = ["Dive","Surf"]
combo9  = ["Double Team","Agility","Quick Attack","Teleport"]
combo10 = ["Dragon Breath","Dragon Claw","Dragon Dance","Dragon Rage"]
combo11 = ["Dragon Dance","Dragon Breath","Dragon Claw","Dragon Rage"]
combo12 = ["Dragon Rage","Dragon Breath","Dragon Claw","Dragon Dance"]
combo13 = ["Earthquake","Eruption","Fissure"]
combo14 = ["Endure","Flail","Reversal"]
combo15 = ["Fake Out","Arm Thrust","Feint Attack","Knock Off","Seismic Toss","Vital Throw"]
combo16 = ["Fire Punch","Ice Punch","Thunder Punch"]
combo17 = ["Focus Energy","Arm Thrust","Brick Break","Cross Chop","Double Edge","DynamicPunch","Focus Punch","Headbutt","Karate Chop","Sky Uppercut","Take Down"]
combo18 = ["Growth","Absorb","Bullet Seed","Frenzy Plant","Giga Drain","Leech Seed","Magical Leaf","Mega Drain","Petal Dance","Razor Leaf","SolarBeam","Vine Whip"]
combo19 = ["Hail","Aurora Beam","Blizzard","Haze","Ice Ball","Ice Beam","Icicle Spear","Icy Wind","Powder Snow","Sheer Cold","Weather Ball"]
combo20 = ["Harden","Double Edge","Protect","Rollout","Tackle","Take Down"]
combo21 = ["Horn Attack","Horn Drill","Fury Attack"]
combo22 = ["Hypnosis","Dream Eater"]
combo23 = ["Ice Punch","Fire Punch","Thunder Punch"]
combo24 = ["Kinesis","Confusion","Future Sight","Psychic","Teleport"]
combo25 = ["Leer","Bite","Feint Attack","Glare","Horn Attack","Scary Face","Scratch","Stomp","Tackle"]
combo26 = ["Lock-On","Superpower","Thunder","Tri Attack","Zap Cannon"]
combo27 = ["Mean Look","Destiny Bond","Perish Song"]
combo28 = ["Metal Sound","Metal Claw"]
combo29 = ["Mind Reader","DynamicPunch","Hi Jump Kick","Sheer Cold","Submission","Superpower"]
combo30 = ["Mud Sport","Mud-Slap","Water Gun","Water Sport"]
combo31 = ["Peck","Drill Peck","Fury Attack"]
combo32 = ["Pound","Double Slap","Feint Attack","Slam"]
combo33 = ["Powder Snow","Blizzard"]
combo34 = ["Psychic","Confusion","Teleport","Future Sight","Kinesis"]
combo35 = ["Rage","Leer","Scary Face","Thrash"]
combo36 = ["Rain Dance","Bubble","Bubblebeam","Clamp","Crabhammer","Dive","Hydro Cannon","Hydro Pump","Muddy Water","Octazooka","Surf","Thunder","Water Gun",
	"Water Pulse","Water Sport","Water Spout","Waterfall","Weather Ball","Whirlpool"]
combo37 = ["Rest","Sleep Talk","Snore"]
combo38 = ["Rock Throw","Rock Slide","Rock Tomb"]
combo39 = ["Sand-Attack","Mud-Slap"]
combo40 = ["Sandstorm","Mud Shot","Mud-Slap","Mud Sport","Sand Tomb","Sand-Attack","Weather Ball"]
combo41 = ["Scary Face","Bite","Crunch","Leer"]
combo42 = ["Scratch","Fury Swipes","Slash"]
combo43 = ["Sing","Perish Song","Refresh"]
combo44 = ["Sludge","Sludge Bomb"]
combo45 = ["Sludge Bomb","Sludge"]
combo46 = ["Smog","Smokescreen"]
combo47 = ["Stockpile","Spit Up","Swallow"]
combo48 = ["Sunny Day","Blast Burn","Blaze Kick","Ember","Eruption","Fire Blast","Fire Punch","Fire Spin","Flame Wheel","Flamethrower","Heat Wave","Moonlight",
	"Morning Sun","Overheat","Sacred Fire","SolarBeam","Synthesis","Weather Ball","Will-o-Wisp"]
combo49 = ["Surf","Dive"]
combo50 = ["Sweet Scene","Poison Powder","Sleep Powder","Stun Spore"]
combo51 = ["Swords Dance","Crabhammer","Crush Claw","Cut","False Swipe","Fury Cutter","Slash"]
combo52 = ["Taunt","Counter","Detect","Mirror Coat"]
combo53 = ["Thunder Punch","Fire Punch","Ice Punch"]
combo54 = ["Vice Grip","Bind","Guillotine"]
combo55 = ["Water Sport","Mud Sport","Refresh","Water Gun"]
combo56 = ["Yawn","Rest","Slack Off"]

# Add more combos here...
# Then add them to this array below

CONTESTCOMBOS = [combo1,combo2,combo3,combo4,combo5,combo6,combo7,combo8,combo9,
combo10,combo11,combo12,combo13,combo14,combo15,combo16,combo17,combo18,combo19,
combo20,combo21,combo22,combo23,combo24,combo25,combo26,combo27,combo28,combo29,
combo30,combo31,combo32,combo33,combo34,combo35,combo36,combo37,combo38,combo39,
combo40,combo41,combo42,combo43,combo44,combo45,combo46,combo47,combo48,combo49,
combo50,combo51,combo52,combo53,combo54,combo55,combo56]

end