#===============================================================================
# Badgecase UI
#===============================================================================
# Adding another badge? Easy!
# [Name, Type, Gym leader name, Location, Ace Pokemon, Gym leader sprite]
# The gym leader sprite should be the name of his sprite from "Graphics/Trainers/"
#===============================================================================
module Badgecase

  # List of badges
  BADGES = [
    ["Boulder Badge","Rock","Brock","Pewter City","ONIX","LEADER_Brock"],
    ["Cascade Badge","Water","Misty","Cerulean City","STARMIE","LEADER_Misty"],
    ["Thunder Badge","Electric","Lt. Surge","Vermilion City","RAICHU","LEADER_Surge"],
    ["Rainbow Badge","Grass","Erika","Celadon City","VILEPLUME","LEADER_Erika"],
    ["Soul Badge","Poison","Koga","Fuchsia City","WEEZING","LEADER_Koga"],
    ["Marsh Badge","Psychic","Sabrina","Saffron City","ALAKAZAM","LEADER_Sabrina"],
    ["Volcano Badge","Fire","Blaine","Cinnabar Island","ARCANINE","LEADER_Blaine"],
    ["Earth Badge","Ground","Giovanni","Viridian City","RHYHORN","LEADER_Giovanni"],
    ["Zephyr Badge","Flying","Falkner","Violet City","PIDGEOTTO","LEADER_Falkner"],
    ["Hive Badge","Bug","Bugsy","Azalea City","SCYTHER","LEADER_Bugsy"],
    ["Plain Badge","Normal","Whitney","Goldenrod City","MILTANK","LEADER_Whitney"],
    ["Fog Badge","Ghost","Morty","Ecruteak City","GENGAR","LEADER_Morty"],
    ["Storm Badge","Fighting","Chuck","Cianwood City","POLIWRATH","LEADER_Chuck"],
    ["Mineral Badge","Steel","Jasmine","Olivine City","STEELIX","LEADER_Jasmine"],
    ["Glacier Badge","Ice","Pryce","Mahogany City","PILOSWINE","LEADER_Pryce"],
    ["Rising Badge","Dragon","Clair","Blackthorn City","KINGDRA","LEADER_Clair"],
    ["Stone Badge","Rock","Roxanne","Rustboro City","NOSEPASS","LEADER_Roxanne"],
    ["Knuckle Badge","Fighting","Brawly","Dewford City","MAKUHITA","LEADER_Brawly"],
    ["Dynamo Badge","Electric","Wattson","Mauville City","MANECTRIC","LEADER_Wattson"],
    ["Heat Badge","Fire","Falnnery","Lavaridge City","TORKOAL","LEADER_Flannery"],
    ["Balance Badge","Normal","Norman","Petalburg City","SLAKING","LEADER_Norman"],
    ["Feather Badge","Flying","Winona","Fortree City","ALTARIA","LEADER_Winona"],
    ["Mind Badge","Psychic","Tate and Liza","Mossdeep City","SOLROCK","LEADER_Tate_and_Liza"],
    ["Rain Badge","Water","Juan","Sootopolis City","KINGDRA","LEADER_Juan"],
    ["Coal Badge","Rock","Roark","Oreburgh City","CRANIDOS","LEADER_Roark"],
    ["Forest Badge","Grass","Gardenia","Eterna City","ROSERADE","LEADER_Gardenia"],
    ["Cobble Badge","Fighting","Maylene","Veilstone City","LUCARIO","LEADER_Maylene"],
    ["Fan Badge","Water","Crasher Wake","Pastoria City","FLOATZEL","LEADER_Crasher_Wake"],
    ["Relic Badge","Ghost","Fantina","Hearthome City","MISMAGIUS","LEADER_Fantina"],
    ["Mine Badge","Steel","Byron","Canalave City","BASTIODON","LEADER_Byron"],
    ["Icicle Badge","Ice","Candice","Snowpoint City","FROSLASS","LEADER_Candice"],
    ["Beacon Badge","Electric","Volkner","Sunyshore City","ELECTIVIRE","LEADER_Volkner"]
  ]
end

# Should the UI show the ace Pokemon?
BADGE_SHOW_ACE_POKEMON = true
# Should the UI show the location?
BADGE_SHOW_LOCATION = true
# Should the UI show the type?
BADGE_SHOW_TYPE = true
# Should the UI show matching backgroung to type?
BADGE_MATCH_BACKGROUND = true