EventHandlers.add(:on_wild_pokemon_created, :make_shadow_switch,
  proc { |pkmn|
  chance = rand(1024)
  if $game_switches[1194]==true &&  5 > chance && (pkmn.species != :XATU || pkmn.species != :NATU || pkmn.species != :SHAYMIN)
    pkmn.makeShadow 
  end
  }
)




# Used in the random dungeon map. Makes the levels of all wild Pokémon in that
# map depend on the levels of Pokémon in the player's party.
# This is a simple method, and can/should be modified to account for evolutions
# and other such details.  Of course, you don't HAVE to use this code.


maps= [54]

EventHandlers.add(:on_wild_pokemon_created, :level_depends_on_party2,
  proc { |pkmn|
next
if maps.include?($game_map.map_id) && GameData::EncounterType.get($PokemonTemp.encounterType).type == :land
if $game_variables[4974]=="ADALYNN"||$game_variables[4974]=="Adalynn"||$game_variables[4974]=="adalynn"
  pkmn = e[0]
  if rand(8)==0
  pkmn.species = :VULPIX
  pkmn.level = 80
  pkmn.happiness = 255
  pkmn.learn_move(:FLAMETHROWER)
  pkmn.learn_move(:HEADBUTT)
  pkmn.learn_move(:FIREBLAST)
  pkmn.learn_move(:AURORABEAM)
  pkmn.item = :LUCKYEGG
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Pallet Town @ Day"
  pkmn.iv[:HP] = 22
  pkmn.iv[:ATTACK] = 31
  pkmn.iv[:DEFENSE] = 12
  pkmn.iv[:SPECIAL_ATTACK] = 18
  pkmn.iv[:SPECIAL_DEFENSE] = 18
  pkmn.iv[:SPEED] = 10
  pkmn.calc_stats
  elsif rand(8)==1
  pkmn.species = :POLITOED
  pkmn.level = 80
pkmn.happiness = 255
pkmn.learn_move(:SURF)
pkmn.learn_move(:LOVELYKISS)
pkmn.learn_move(:CROSSCHOP)
pkmn.learn_move(:WHIRLPOOL)
pkmn.item = :LUCKYEGG
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Route 22 @ Night"
pkmn.iv[:HP] = 14
pkmn.iv[:ATTACK] = 20
pkmn.iv[:DEFENSE] = 26
pkmn.iv[:SPECIAL_ATTACK] = 2
pkmn.iv[:SPECIAL_DEFENSE] = 2
pkmn.iv[:SPEED] = 13
  pkmn.calc_stats
  elsif rand(8)==2
  pkmn.species = :DRAGONITE
  pkmn.level = 80
pkmn.happiness = 255
pkmn.learn_move(:HYPERBEAM)
pkmn.learn_move(:THUNDERBOLT)
pkmn.learn_move(:EARTHQUAKE)
pkmn.learn_move(:OUTRAGE)
pkmn.item = :LUCKYEGG
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Goldenrod City @ Day"
pkmn.iv[:HP] = 20
pkmn.iv[:ATTACK] = 22
pkmn.iv[:SPECIAL_ATTACK] = 14
pkmn.iv[:SPECIAL_DEFENSE] = 14
pkmn.iv[:DEFENSE] = 20
pkmn.iv[:SPEED] = 22
  pkmn.calc_stats
  elsif rand(8)==3
  pkmn.species = :ESPEON
  pkmn.level = 80
pkmn.happiness = 255
pkmn.learn_move(:PSYBEAM)
pkmn.learn_move(:SANDATTACK)
pkmn.learn_move(:PSYCHIC)
pkmn.learn_move(:PSYCHUP)
pkmn.item = :LUCKYEGG
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Celadon City @ Day"
pkmn.iv[:HP] = 20
pkmn.iv[:ATTACK] = 2
pkmn.iv[:SPECIAL_ATTACK] = 4
pkmn.iv[:SPECIAL_DEFENSE] = 4
pkmn.iv[:DEFENSE] = 8
pkmn.iv[:SPEED] = 31
  pkmn.calc_stats
  elsif rand(8)==4
  pkmn.species = :CROBAT
  pkmn.level = 80
pkmn.happiness = 255
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Mt Moon @ Night"
pkmn.learn_move(:WINDATTACK)
pkmn.learn_move(:FLY)
pkmn.learn_move(:GIGADRAIN)
pkmn.learn_move(:SHADOWBALL)
pkmn.item = :LUCKYEGG
pkmn.iv[:HP] = 24
pkmn.iv[:ATTACK] = 14
pkmn.iv[:SPECIAL_ATTACK] = 20
pkmn.iv[:SPECIAL_DEFENSE] = 20
pkmn.iv[:DEFENSE] = 14
pkmn.iv[:SPEED] = 12
  pkmn.calc_stats
  elsif rand(8)==5
  pkmn.species = :DONPHAN
  pkmn.level = 80
pkmn.happiness = 255
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Route 34 @ Night"
pkmn.learn_move(:EARTHQUAKE)
pkmn.learn_move(:ANCIENTPOWER)
pkmn.learn_move(:RAPIDSPIN)
pkmn.learn_move(:STRENGTH)
pkmn.item = :LUCKYEGG
pkmn.iv[:HP] = 20
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 4
pkmn.iv[:SPECIAL_DEFENSE] = 4
pkmn.iv[:DEFENSE] = 20
pkmn.iv[:SPEED] = 31
  pkmn.calc_stats
  elsif rand(8)==6
  pkmn.species = :BELLOSSOM
  pkmn.name = "Adalyne"
  pkmn.level = 47
pkmn.happiness = 255
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Goldenrod City"
pkmn.learn_move(:HIDDENPOWER)
pkmn.learn_move(:STUNSPORE)
pkmn.learn_move(:SLEEPPOWDER)
pkmn.learn_move(:ACID)
pkmn.item = :EXPSHARE
pkmn.shiny = true
pkmn.iv[:HP] = 8
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 20
pkmn.iv[:SPECIAL_DEFENSE] = 20
pkmn.iv[:DEFENSE] = 20
pkmn.iv[:SPEED] = 20
  pkmn.calc_stats
elsif rand(8)==7
  pkmn.species = :MAGNEMITE
  pkmn.level = 5
pkmn.happiness = 255
pkmn.owner.id = 56656
pkmn.shiny = true
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Route 34 @ Day"
pkmn.iv[:HP] = 0
pkmn.iv[:ATTACK] = 4
pkmn.iv[:SPECIAL_ATTACK] = 20
pkmn.iv[:SPECIAL_DEFENSE] = 20
pkmn.iv[:DEFENSE] = 20
pkmn.iv[:SPEED] = 20
  pkmn.calc_stats
  elsif rand(8)==8
  pkmn.species = :WOBBUFFET
  pkmn.level = 10
pkmn.happiness = 255
pkmn.owner.id = 56656
pkmn.owner.name = "ADALYNN"
pkmn.obtain_text = "Dark Cave @ Night"
pkmn.learn_move(:COUNTER)
pkmn.learn_move(:MIRRORCOAT)
pkmn.learn_move(:SAFEGUARD)
pkmn.learn_move(:DESTINYBOND)
pkmn.item = :EXPSHARE
pkmn.iv[:HP] = 31
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 31
pkmn.iv[:SPECIAL_DEFENSE] = 31
pkmn.iv[:DEFENSE] = 14
pkmn.iv[:SPEED] = 26
  pkmn.calc_stats
end
elsif $game_variables[4974]=="SNOW"||$game_variables[4974]=="Snow"||$game_variables[4974]=="snow"
  if rand(4)==0
  pkmn.species = :MEGANIUM
  pkmn.name = "Peepo"
  pkmn.level = 65
pkmn.happiness = 255
pkmn.learn_move(:CUT)
pkmn.learn_move(:ANCIENTPOWER)
pkmn.learn_move(:SOLARBEAM)
pkmn.learn_move(:RAZORLEAF)
pkmn.item = :LUCKYEGG
pkmn.owner.id = 57002
pkmn.owner.name = "SNOW"
pkmn.obtain_text = "Pallet Town"
pkmn.iv[:HP] = 6
pkmn.iv[:ATTACK] = 28
pkmn.iv[:SPECIAL_ATTACK] = 14
pkmn.iv[:SPECIAL_DEFENSE] = 14
pkmn.iv[:DEFENSE] = 12
pkmn.iv[:SPEED] = 2
  pkmn.calc_stats
  elsif rand(4)==1
  pkmn.species = :SCIZOR
  pkmn.name = "Lilac"
  pkmn.level = 40
pkmn.happiness = 255
pkmn.learn_move(:FALSESWIPE)
pkmn.learn_move(:FLY)
pkmn.learn_move(:METALCLAW)
pkmn.learn_move(:GUILLOTINE)
pkmn.item = :QUICKCLAW
pkmn.owner.id = 57002
pkmn.owner.name = "SNOW"
pkmn.obtain_text = "National Park"
pkmn.iv[:HP] = 31
pkmn.iv[:ATTACK] = 2
pkmn.iv[:SPECIAL_ATTACK] = 26
pkmn.iv[:SPECIAL_DEFENSE] = 26
pkmn.iv[:DEFENSE] = 22
pkmn.iv[:SPEED] = 22
  pkmn.calc_stats
  elsif rand(4)==2
  pkmn.species = :GYARADOS
  pkmn.name = "Finn"
  pkmn.level = 35
pkmn.happiness = 255
pkmn.shiny = true
pkmn.learn_move(:WHIRLPOOL)
pkmn.learn_move(:SURF)
pkmn.learn_move(:STRENGTH)
pkmn.learn_move(:ROCKSMASH)
pkmn.item = :EXPSHARE
pkmn.owner.id = 57002
pkmn.owner.name = "SNOW"
pkmn.obtain_text = "Route 3 @ Night"
pkmn.iv[:HP] = 16
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 10
pkmn.iv[:SPECIAL_DEFENSE] = 10
pkmn.iv[:DEFENSE] = 10
pkmn.iv[:SPEED] = 10
  pkmn.calc_stats
  elsif rand(4)==3
  pkmn.species = :VENUSAUR
  pkmn.name = "Sunflower"
  pkmn.level = 41
pkmn.happiness = 255
pkmn.learn_move(:GIGADRAIN)
pkmn.learn_move(:RAZORLEAF)
pkmn.learn_move(:LEECHSEED)
pkmn.learn_move(:ANCIENTPOWER)
pkmn.item = :EXPSHARE
pkmn.owner.id = 57002
pkmn.owner.name = "SNOW"
pkmn.obtain_text = "Ilex Forest @ Day"
pkmn.iv[:HP] = 0
pkmn.iv[:ATTACK] = 20
pkmn.iv[:SPECIAL_ATTACK] = 4
pkmn.iv[:SPECIAL_DEFENSE] = 4
pkmn.iv[:DEFENSE] = 12
pkmn.iv[:SPEED] = 12
  pkmn.calc_stats
  elsif rand(4)==4
  pkmn.species = :VAPOREON
  pkmn.name = "Noel"
  pkmn.level = 32
pkmn.happiness = 255
pkmn.learn_move(:ICEBEAM)
pkmn.learn_move(:BITE)
pkmn.learn_move(:SANDATTACK)
pkmn.learn_move(:HEADBUTT)
pkmn.item = :EXPSHARE
pkmn.owner.id = 57002
pkmn.owner.name = "SNOW"
pkmn.obtain_text = "Goldenrod City @ Night"
pkmn.iv[:HP] = 18
pkmn.iv[:ATTACK] = 26
pkmn.iv[:SPECIAL_ATTACK] = 10
pkmn.iv[:SPECIAL_DEFENSE] = 10
pkmn.iv[:DEFENSE] = 28
pkmn.iv[:SPEED] = 8
  pkmn.calc_stats
end
elsif $game_variables[4974]=="TWIGS"||$game_variables[4974]=="Twigs"||$game_variables[4974]=="twigs"
pkmn.species = :ONIX
pkmn.level = 16
pkmn.happiness = 255
pkmn.owner.name = "TWIGS"
pkmn.obtain_text = "Granite Cave"
pkmn.learn_move(:IRONTAIL)
pkmn.learn_move(:EXPLOSION)
pkmn.learn_move(:FLAMETHROWER)
pkmn.learn_move(:DIG)
pkmn.iv[:HP] = 28
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 0
pkmn.iv[:SPECIAL_DEFENSE] = 0
pkmn.iv[:DEFENSE] = 31
pkmn.iv[:SPEED] = 31
pkmn.calc_stats
elsif $game_variables[4974]=="POTS"||$game_variables[4974]=="Pots"||$game_variables[4974]=="pots"
if rand(4)==0
pkmn.species = :SKARMORY
pkmn.level = 100
pkmn.happiness = 255
pkmn.learn_move(:DRILLPECK)
pkmn.learn_move(:STEELWING)
pkmn.learn_move(:RETURN)
pkmn.learn_move(:SPIKES)
pkmn.owner.id = 57002
pkmn.owner.name = "POTS"
pkmn.obtain_text = "Goldenrod City @ Night"
pkmn.iv[:HP] = 28
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 0
pkmn.iv[:SPECIAL_DEFENSE] = 0
pkmn.iv[:DEFENSE] = 18
pkmn.iv[:SPEED] = 31
pkmn.calc_stats
elsif rand(4)==1
pkmn.species = :DRAGONITE
pkmn.name = "Wyrmheim"
pkmn.level = 100
pkmn.item = :KINGSROCK
pkmn.happiness = 255
pkmn.learn_move(:WATERFALL)
pkmn.learn_move(:OUTRAGE)
pkmn.learn_move(:EXTREMESPEED)
pkmn.learn_move(:HYPERBEAM)
pkmn.owner.id = 57002
pkmn.owner.name = "POTS"
pkmn.obtain_text = "Goldenrod City @ Night"
pkmn.iv[:HP] = 31
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 22
pkmn.iv[:SPECIAL_DEFENSE] = 22
pkmn.iv[:DEFENSE] = 31
pkmn.iv[:SPEED] = 22
  pkmn.calc_stats
  elsif rand(4)==2
  pkmn.species = :ALAKAZAM
  pkmn.level = 100
pkmn.item = :AMULETCOIN
pkmn.happiness = 255
pkmn.learn_move(:PSYCHIC)
pkmn.learn_move(:ICEPUNCH)
pkmn.learn_move(:THIEF)
pkmn.learn_move(:RECOVER)
pkmn.owner.id = 57002
pkmn.owner.name = "POTS"
pkmn.obtain_text = "Goldenrod City @ Night"
pkmn.iv[:HP] = 31
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 18
pkmn.iv[:SPECIAL_DEFENSE] = 18
pkmn.iv[:DEFENSE] = 22
pkmn.iv[:SPEED] = 14
  pkmn.calc_stats
  elsif rand(4)==3
  pkmn.species = :PORYGON2
  pkmn.name = "Big Duckum"
  pkmn.level = 100
pkmn.item = :LEFTOVERS
pkmn.happiness = 255
pkmn.learn_move(:ICEBEAM)
pkmn.learn_move(:TRIATTACK)
pkmn.learn_move(:RECOVER)
pkmn.learn_move(:THUNDERBOLT)
pkmn.owner.id = 57002
pkmn.owner.name = "POTS"
pkmn.obtain_text = "Goldenrod City @ Night"
pkmn.iv[:HP] = 24
pkmn.iv[:ATTACK] = 10
pkmn.iv[:SPECIAL_ATTACK] = 16
pkmn.iv[:SPECIAL_DEFENSE] = 16
pkmn.iv[:DEFENSE] = 22
pkmn.iv[:SPEED] = 24
  pkmn.calc_stats
  elsif rand(4)==4
  pkmn.species = :UMBREON
  pkmn.level = 100
pkmn.item = :LUCKYEGG
pkmn.happiness = 255
pkmn.learn_move(:FEINTATTACK)
pkmn.learn_move(:CONFUSERAY)
pkmn.learn_move(:SANDATTACK)
pkmn.learn_move(:TRIATTACK)
pkmn.owner.id = 57002
pkmn.owner.name = "POTS"
pkmn.obtain_text = "Goldenrod City @ Night"
pkmn.iv[:HP] = 31
pkmn.iv[:ATTACK] = 31
pkmn.iv[:SPECIAL_ATTACK] = 22
pkmn.iv[:SPECIAL_DEFENSE] = 22
pkmn.iv[:DEFENSE] = 5
pkmn.iv[:SPEED] = 14
  pkmn.calc_stats
  elsif rand(4)==5
  pkmn.species = :TOGETIC
  pkmn.level = 100
pkmn.happiness = 255
pkmn.learn_move(:FEINTATTACK)
pkmn.learn_move(:CONFUSERAY)
pkmn.learn_move(:SANDATTACK)
pkmn.learn_move(:TRIATTACK)
pkmn.owner.id = 57002
pkmn.owner.name = "POTS"
pkmn.obtain_text = "Goldenrod City @ Night"
pkmn.iv[:HP] = 0
pkmn.iv[:ATTACK] = 0
pkmn.iv[:SPECIAL_ATTACK] = 20
pkmn.iv[:SPECIAL_DEFENSE] = 20
pkmn.iv[:DEFENSE] = 28
pkmn.iv[:SPEED] = 20
  pkmn.calc_stats
end
  
else
end
end
}
)

#EventHandlers.add(:on_wild_pokemon_created, :level_depends_on_party,
#  proc { |pkmn|
#
#   pokemon=e[0]
#   if $game_switches[76]#Earthquakes
#     pokemon.name="Jörmungandr"
#     pokemon.form=1
#     pokemon.learn_move(:BIND)
#     pokemon.learn_move(:EARTHQUAKE)
#     pokemon.learn_move(:MAGNITUDE)
#     pokemon.learn_move(:IRONTAIL)
#   elsif $game_switches[77]#Sea#DONE
#     pokemon.name="Aegir"
#     pokemon.form=1
#   elsif $game_switches[78]#Storms
#     pokemon.name="Tempestas"
#     pokemon.form=1
#   elsif $game_switches[79]#Snow#DONE
#     pokemon.name="Ullr"
#     pokemon.form=1
#   elsif $game_switches[80]#Forests
#     pokemon.name="Silvanus"
#     pokemon.form=1
#   elsif $game_switches[81]#Underworld
#     pokemon.name="Veles"
#     pokemon.form=1
#    elsif $game_switches[83]#Fire#DONE
#    pokemon.name="Hestia"
#     pokemon.form=1
#   end
#  }
#)


# This is the basis of a trainer modifier. It works both for trainers loaded
# when you battle them, and for partner trainers when they are registered.
# Note that you can only modify a partner trainer's Pokémon, and not the trainer
# themselves nor their items this way, as those are generated from scratch
# before each battle.
#EventHandlers.add(:on_trainer_load, :put_a_name_here,
#  proc { |trainer|
#    if trainer   # An NPCTrainer object containing party/items/lose text, etc.
#      YOUR CODE HERE
#    end
#  }
#)

