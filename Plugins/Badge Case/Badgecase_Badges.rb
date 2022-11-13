#===============================================================================
# Badgecase UI
# Are you tired of the old fashion badge case inside your trainer card? This plugin is for you!
#===============================================================================
# Badgecase_Badges
# List of badges you want in your game
#===============================================================================
# Adding another badge? Easy!
# Just add the following lines (anything between asterisks* should be deleted or changed):
#
# { *delete: Don't forget this line!!*
#   :ID => *change: Badge ID*
#   :NAME => *change: Badge name*
#   :TYPE => *change: Gym type speciality*
#   :LEADERNAME => *change: Gym leader name*
#   :LOCATION => *change: Location of the gym*
#   :ACEPOKEMON => *change: Gym leader's ace Pokemon*
#   :LEADERSPRITE => *change: Gym leader sprite (from Graphics/Trainers)*
# }, *delete: Don't forget this line!!*
#
#===============================================================================
module Badges
  BADGES = [
    {
      :ID => "BOULDERBADGE",
      :NAME => "Boulder Badge",
      :TYPE => "Rock",
      :LEADERNAME => "Brock",
      :LOCATION => "Pewter City",
      :ACEPOKEMON => "ONIX",
      :LEADERSPRITE => "LEADER_Brock"
    },

    {
      :ID => "CASCADEBADGE",
      :NAME => "Cascade Badge",
      :TYPE => "Water",
      :LEADERNAME => "Misty",
      :LOCATION => "Cerulean City",
      :ACEPOKEMON => "STARMIE",
      :LEADERSPRITE => "LEADER_Misty"
    },

    {
      :ID => "THUNDERBADGE",
      :NAME => "Thunder Badge",
      :TYPE => "Electric",
      :LEADERNAME => "Lt. Surge",
      :LOCATION => "Vermilion City",
      :ACEPOKEMON => "RAICHU",
      :LEADERSPRITE => "LEADER_Surge"
    },

    {
      :ID => "RAINBOWBADGE",
      :NAME => "Rainbow Badge",
      :TYPE => "Grass",
      :LEADERNAME => "Erika",
      :LOCATION => "Celadon City",
      :ACEPOKEMON => "VILEPLUME",
      :LEADERSPRITE => "LEADER_Erika"
    },

    {
      :ID => "SOULBADGE",
      :NAME => "Soul Badge",
      :TYPE => "Poison",
      :LEADERNAME => "Koga",
      :LOCATION => "Fuchsia City",
      :ACEPOKEMON => "WEEZING",
      :LEADERSPRITE => "LEADER_Koga"
    },

    {
      :ID => "MARSHBADGE",
      :NAME => "Marsh Badge",
      :TYPE => "Psychic",
      :LEADERNAME => "Sabrina",
      :LOCATION => "Saffron City",
      :ACEPOKEMON => "ALAKAZAM",
      :LEADERSPRITE => "LEADER_Sabrina"
    },

    {
      :ID => "VOLCANOBADGE",
      :NAME => "Volcano Badge",
      :TYPE => "Fire",
      :LEADERNAME => "Blaine",
      :LOCATION => "Cinnabar Island",
      :ACEPOKEMON => "ARCANINE",
      :LEADERSPRITE => "LEADER_Blaine"
    },

    {
      :ID => "EARTHBADGE",
      :NAME => "Earth Badge",
      :TYPE => "Ground",
      :LEADERNAME => "Giovanni",
      :LOCATION => "Viridian City",
      :ACEPOKEMON => "RHYHORN",
      :LEADERSPRITE => "LEADER_Giovanni"
    },

    {
      :ID => "ZEPHYRBADGE",
      :NAME => "Zephyr Badge",
      :TYPE => "Flying",
      :LEADERNAME => "Falkner",
      :LOCATION => "Violet City",
      :ACEPOKEMON => "PIDGEOTTO",
      :LEADERSPRITE => "LEADER_Falkner"
    },

    {
      :ID => "HIVEBADGE",
      :NAME => "Hive Badge",
      :TYPE => "Bug",
      :LEADERNAME => "Bugsy",
      :LOCATION => "Azalea City",
      :ACEPOKEMON => "SCYTHER",
      :LEADERSPRITE => "LEADER_Bugsy"
    },

    {
      :ID => "PLAINBADGE",
      :NAME => "Plain Badge",
      :TYPE => "Normal",
      :LEADERNAME => "Whitney",
      :LOCATION => "Goldenrod City",
      :ACEPOKEMON => "MILTANK",
      :LEADERSPRITE => "LEADER_Whitney"
    },

    {
      :ID => "FOGBADGE",
      :NAME => "Fog Badge",
      :TYPE => "Ghost",
      :LEADERNAME => "Morty",
      :LOCATION => "Ecruteak City",
      :ACEPOKEMON => "GENGAR",
      :LEADERSPRITE => "LEADER_Morty"
    },

    {
      :ID => "STORMBADGE",
      :NAME => "Storm Badge",
      :TYPE => "Fighting",
      :LEADERNAME => "Chuck",
      :LOCATION => "Cianwood City",
      :ACEPOKEMON => "POLIWRATH",
      :LEADERSPRITE => "LEADER_Chuck"
    },

    {
      :ID => "MINERALBADGE",
      :NAME => "Mineral Badge",
      :TYPE => "Steel",
      :LEADERNAME => "Jasmine",
      :LOCATION => "Olivine City",
      :ACEPOKEMON => "STEELIX",
      :LEADERSPRITE => "LEADER_Jasmine"
    },

    {
      :ID => "GLACIERBADGE",
      :NAME => "Glacier Badge",
      :TYPE => "Ice",
      :LEADERNAME => "Pryce",
      :LOCATION => "Mahogany City",
      :ACEPOKEMON => "PILOSWINE",
      :LEADERSPRITE => "LEADER_Pryce"
    },

    {
      :ID => "RISINGBADGE",
      :NAME => "Rising Badge",
      :TYPE => "Dragon",
      :LEADERNAME => "Clair",
      :LOCATION => "Blackthorn City",
      :ACEPOKEMON => "KINGDRA",
      :LEADERSPRITE => "LEADER_Clair"
    },

    {
      :ID => "STONEBADGE",
      :NAME => "Stone Badge",
      :TYPE => "Rock",
      :LEADERNAME => "Roxanne",
      :LOCATION => "Rustboro City",
      :ACEPOKEMON => "NOSEPASS",
      :LEADERSPRITE => "LEADER_Roxanne"
    },

    {
      :ID => "KNUCKLEBADGE",
      :NAME => "Knuckle Badge",
      :TYPE => "Fighting",
      :LEADERNAME => "Brawly",
      :LOCATION => "Dewford City",
      :ACEPOKEMON => "MAKUHITA",
      :LEADERSPRITE => "LEADER_Brawly"
    },

    {
      :ID => "DYNAMOBADGE",
      :NAME => "Dynamo Badge",
      :TYPE => "Electric",
      :LEADERNAME => "Wattson",
      :LOCATION => "Mauville City",
      :ACEPOKEMON => "MANECTRIC",
      :LEADERSPRITE => "LEADER_Wattson"
    },

    {
      :ID => "HEATBADGE",
      :NAME => "Heat Badge",
      :TYPE => "Fire",
      :LEADERNAME => "Falnnery",
      :LOCATION => "Lavaridge City",
      :ACEPOKEMON => "TORKOAL",
      :LEADERSPRITE => "LEADER_Flannery"
    },

    {
      :ID => "BALANCEBADGE",
      :NAME => "Balance Badge",
      :TYPE => "Normal",
      :LEADERNAME => "Norman",
      :LOCATION => "Petalburg City",
      :ACEPOKEMON => "SLAKING",
      :LEADERSPRITE => "LEADER_Norman"
    },

    {
      :ID => "FEATHERBADGE",
      :NAME => "Feather Badge",
      :TYPE => "Flying",
      :LEADERNAME => "Winona",
      :LOCATION => "Fortree City",
      :ACEPOKEMON => "ALTARIA",
      :LEADERSPRITE => "LEADER_Winona"
    },

    {
      :ID => "MINDBADGE",
      :NAME => "Mind Badge",
      :TYPE => "Psychic",
      :LEADERNAME => "Tate and Liza",
      :LOCATION => "Mossdeep City",
      :ACEPOKEMON => "SOLROCK",
      :LEADERSPRITE => "LEADER_Tate_and_Liza"
    },

    {
      :ID => "RAINBADGE",
      :NAME => "Rain Badge",
      :TYPE => "Water",
      :LEADERNAME => "Juan",
      :LOCATION => "Sootopolis City",
      :ACEPOKEMON => "KINGDRA",
      :LEADERSPRITE => "LEADER_Juan"
    },

    {
      :ID => "COALBADGE",
      :NAME => "Coal Badge",
      :TYPE => "Rock",
      :LEADERNAME => "Roark",
      :LOCATION => "Oreburgh City",
      :ACEPOKEMON => "CRANIDOS",
      :LEADERSPRITE => "LEADER_Roark"
    },

    {
      :ID => "FORESTBADGE",
      :NAME => "Forest Badge",
      :TYPE => "Grass",
      :LEADERNAME => "Gardenia",
      :LOCATION => "Eterna City",
      :ACEPOKEMON => "ROSERADE",
      :LEADERSPRITE => "LEADER_Gardenia"
    },

    {
      :ID => "COBBLEBADGE",
      :NAME => "Cobble Badge",
      :TYPE => "Fighting",
      :LEADERNAME => "Maylene",
      :LOCATION => "Veilstone City",
      :ACEPOKEMON => "LUCARIO",
      :LEADERSPRITE => "LEADER_Maylene"
    },

    {
      :ID => "FANBADGE",
      :NAME => "Fan Badge",
      :TYPE => "Water",
      :LEADERNAME => "Crasher Wake",
      :LOCATION => "Pastoria City",
      :ACEPOKEMON => "FLOATZEL",
      :LEADERSPRITE => "LEADER_Crasher_Wake"
    },

    {
      :ID => "RELICBADGE",
      :NAME => "Relic Badge",
      :TYPE => "Ghost",
      :LEADERNAME => "Fantina",
      :LOCATION => "Hearthome City",
      :ACEPOKEMON => "MISMAGIUS",
      :LEADERSPRITE => "LEADER_Fantina"
    },

    {
      :ID => "MINEBADGE",
      :NAME => "Mine Badge",
      :TYPE => "Steel",
      :LEADERNAME => "Byron",
      :LOCATION => "Canalave City",
      :ACEPOKEMON => "BASTIODON",
      :LEADERSPRITE => "LEADER_Byron"
    },

    {
      :ID => "ICICLEBADGE",
      :NAME => "Icicle Badge",
      :TYPE => "Ice",
      :LEADERNAME => "Candice",
      :LOCATION => "Snowpoint City",
      :ACEPOKEMON => "FROSLASS",
      :LEADERSPRITE => "LEADER_Candice"
    },

    {
      :ID => "BEACONBADGE",
      :NAME => "Beacon Badge",
      :TYPE => "Electric",
      :LEADERNAME => "Volkner",
      :LOCATION => "Sunyshore City",
      :ACEPOKEMON => "ELECTIVIRE",
      :LEADERSPRITE => "LEADER_Volkner"
    }
  ]
end