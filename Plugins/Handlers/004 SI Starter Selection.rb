###---NEW---###
def pbHasType?(type)
  for pokemon in $player.party
    next if pokemon.egg?
    return true if pokemon.type1==type || pokemon.type2==type
  end
  return false
end

def pbHasLegendaries?()
  for pokemon in $player.party
    next if pokemon.egg?
    return true if
    $player.has_species?(isSpecies?::ARTICUNO) ||
    $player.has_species?(isSpecies?::ZAPDOS) ||
    $player.has_species?(isSpecies?::MOLTRES) ||
    $player.has_species?(isSpecies?::MEWTWO) ||
    $player.has_species?(isSpecies?::MEW) ||
    $player.has_species?(isSpecies?::CELEBI) ||
    $player.has_species?(isSpecies?::ENTEI) ||
    $player.has_species?(isSpecies?::RAIKOU) ||
    $player.has_species?(isSpecies?::SUICUNE) ||
    $player.has_species?(isSpecies?::LUGIA) ||
    $player.has_species?(isSpecies?::HOOH) ||
    $player.has_species?(isSpecies?::REGICE) ||
    $player.has_species?(isSpecies?::REGISTEEL) ||
    $player.has_species?(isSpecies?::REGIROCK) ||
    $player.has_species?(isSpecies?::LATIOS) ||
    $player.has_species?(isSpecies?::LATIAS) ||
    $player.has_species?(isSpecies?::KYOGRE) ||
    $player.has_species?(isSpecies?::GROUDON) ||
    $player.has_species?(isSpecies?::RAYQUAZA) ||
    $player.has_species?(isSpecies?::JIRACHI) ||
    $player.has_species?(isSpecies?::DEOXYS)
  end
  return false
end

def pbSetUpcase(variable)
  $game_variables[variable]=$game_variables[variable].upcase
end

def pbLegendaryStarter?(variable)
    starter=$game_variables[variable]
  return true if
    starter=="ARTICUNO" ||
    starter=="ZAPDOS" ||
    starter=="MOLTRES" ||
    starter=="MEWTWO" ||
    starter=="MEW" ||
    starter=="RAIKOU" ||
    starter=="ENTEI" ||
    starter=="SUICUNE" ||
    starter=="LUGIA" ||
    starter=="HOOH" ||
    starter=="CELEBI" ||
    starter=="REGIROCK" ||
    starter=="REGICE" ||
    starter=="REGISTEEL" ||
    starter=="LATIAS" ||
    starter=="LATIOS" ||
    starter=="KYOGRE" ||
    starter=="GROUDON" ||
    starter=="RAYQUAZA" ||
    starter=="JIRACHI" ||
    starter=="DEOXYS" ||
    starter=="UXIE" ||
    starter=="MESPRIT" ||
    starter=="AZELF" ||
    starter=="DIALGA" ||
    starter=="PALKIA" ||
    starter=="HEATRAN" ||
    starter=="REGIGIGAS" ||
    starter=="GIRATINA" ||
    starter=="CRESSELIA" ||
    starter=="MANAPHY" ||
    starter=="DARKRAI" ||
    starter=="SHAYMIN" ||
    starter=="ARCEUS" ||
    starter=="VICTINI" ||
    starter=="COBALION" ||
    starter=="TERRAKION" ||
    starter=="VIRIZION" ||
    starter=="TORNADUS" ||
    starter=="THUNDURUS" ||
    starter=="RESHIRAM" ||
    starter=="ZEKROM" ||
    starter=="LANDORUS" ||
    starter=="KYUREM" ||
    starter=="KELDEO" ||
    starter=="MELOETTA" ||
    starter=="GENESECT"||
    starter=="XERNEAS"||
    starter=="YVELTAL"||
    starter=="ZYGARDE"||
    starter=="TYPENULL"||
    starter=="SILVALLY"||
    starter=="TAPUBULU"||
    starter=="TAPUFINI"||
    starter=="TAPULELE"||
    starter=="TAPUKOKO"||
    starter=="COSMOG"||
    starter=="COSMOEM"||
    starter=="SOLGALEO"||
    starter=="LUNALA"||
    starter=="NECROZMA"||
    starter=="NIHILEGO"||
    starter=="ZACIAN"||
    starter=="ZAMAZENTA"||
    starter=="ETERNATUS"||
    starter=="KUBFU"||
    starter=="URSHIFU"||
    starter=="REGIELEKI"||
    starter=="REGIDRAGO"||
    starter=="GLASTRIER"||
    starter=="SPECTRIER"||
    starter=="CALYREX"
  return false
end

def pbPhioneStarter?(variable)
    starter=$game_variables[variable]
  return true if starter=="PHIONE"
  return false
end

def pbMagikarpStarter?(variable)
    starter=$game_variables[variable]
  return true if starter=="MAGIKARP"
  return false
end

def pbRandomStarter(typ)
  allstarters=[
      "BULBASAUR",
      "IVYSAUR",
      "VENUSAUR",
      "CHARMANDER",
      "CHARMELEON",
      "CHARIZARD",
      "SQUIRTLE",
      "WARTORTLE",
      "BLASTOISE",
      "CATERPIE",
      "METAPOD",
      "BUTTERFREE",
      "WEEDLE",
      "KAKUNA",
      "BEEDRILL",
      "PIDGEY",
      "PIDGEOTTO",
      "PIDGEOT",
      "RATTATA",
      "RATICATE",
      "SPEAROW",
      "FEAROW",
      "EKANS",
      "ARBOK",
      "PIKACHU",
      "RAICHU",
      "SANDSHREW",
      "SANDSLASH",
      "NIDORANfE",
      "NIDORINA",
      "NIDOQUEEN",
      "NIDORANmA",
      "NIDORINO",
      "NIDOKING",
      "CLEFAIRY",
      "CLEFABLE",
      "VULPIX",
      "NINETALES",
      "JIGGLYPUFF",
      "WIGGLYTUFF",
      "ZUBAT",
      "GOLBAT",
      "ODDISH",
      "GLOOM",
      "VILEPLUME",
      "PARAS",
      "PARASECT",
      "VENONAT",
      "VENOMOTH",
      "DIGLETT",
      "DUGTRIO",
      "MEOWTH",
      "PERSIAN",
      "PSYDUCK",
      "GOLDUCK",
      "MANKEY",
      "PRIMEAPE",
      "GROWLITHE",
      "ARCANINE",
      "POLIWAG",
      "POLIWHIRL",
      "POLIWRATH",
      "ABRA",
      "KADABRA",
      "ALAKAZAM",
      "MACHOP",
      "MACHOKE",
      "MACHAMP",
      "BELLSPROUT",
      "WEEPINBELL",
      "VICTREEBEL",
      "TENTACOOL",
      "TENTACRUEL",
      "GEODUDE",
      "GRAVELER",
      "GOLEM",
      "PONYTA",
      "RAPIDASH",
      "SLOWPOKE",
      "SLOWBRO",
      "MAGNEMITE",
      "MAGNETON",
      "FARFETCHD",
      "DODUO",
      "DODRIO",
      "SEEL",
      "DEWGONG",
      "GRIMER",
      "MUK",
      "SHELLDER",
      "CLOYSTER",
      "GASTLY",
      "HAUNTER",
      "GENGAR",
      "ONIX",
      "DROWZEE",
      "HYPNO",
      "KRABBY",
      "KINGLER",
      "VOLTORB",
      "ELECTRODE",
      "EXEGGCUTE",
      "EXEGGUTOR",
      "CUBONE",
      "MAROWAK",
      "HITMONLEE",
      "HITMONCHAN",
      "LICKITUNG",
      "KOFFING",
      "WEEZING",
      "RHYHORN",
      "RHYDON",
      "CHANSEY",
      "TANGELA",
      "KANGASKHAN",
      "HORSEA",
      "SEADRA",
      "GOLDEEN",
      "SEAKING",
      "STARYU",
      "STARMIE",
      "MRMIME",
      "SCYTHER",
      "JYNX",
      "ELECTABUZZ",
      "MAGMAR",
      "PINSIR",
      "TAUROS",
      "MAGIKARP",
      "GYARADOS",
      "LAPRAS",
      "DITTO",
      "EEVEE",
      "VAPOREON",
      "JOLTEON",
      "FLAREON",
      "PORYGON",
      "OMANYTE",
      "OMASTAR",
      "KABUTO",
      "KABUTOPS",
      "AERODACTYL",
      "SNORLAX",
      "ARTICUNO",
      "ZAPDOS",
      "MOLTRES",
      "DRATINI",
      "DRAGONAIR",
      "DRAGONITE",
      "MEWTWO",
      "MEW",
      "CHIKORITA",
      "BAYLEEF",
      "MEGANIUM",
      "CYNDAQUIL",
      "QUILAVA",
      "TYPHLOSION",
      "TOTODILE",
      "CROCONAW",
      "FERALIGATR",
      "SENTRET",
      "FURRET",
      "HOOTHOOT",
      "NOCTOWL",
      "LEDYBA",
      "LEDIAN",
      "SPINARAK",
      "ARIADOS",
      "CROBAT",
      "CHINCHOU",
      "LANTURN",
      "PICHU",
      "CLEFFA",
      "IGGLYBUFF",
      "TOGEPI",
      "TOGETIC",
      "NATU",
      "XATU",
      "MAREEP",
      "FLAAFFY",
      "AMPHAROS",
      "BELLOSSOM",
      "MARILL",
      "AZUMARILL",
      "SUDOWOODO",
      "POLITOED",
      "HOPPIP",
      "SKIPLOOM",
      "JUMPLUFF",
      "AIPOM",
      "SUNKERN",
      "SUNFLORA",
      "YANMA",
      "WOOPER",
      "QUAGSIRE",
      "ESPEON",
      "UMBREON",
      "MURKROW",
      "SLOWKING",
      "MISDREAVUS",
      "UNOWN",
      "WOBBUFFET",
      "GIRAFARIG",
      "PINECO",
      "FORRETRESS",
      "DUNSPARCE",
      "GLIGAR",
      "STEELIX",
      "SNUBBULL",
      "GRANBULL",
      "QWILFISH",
      "SCIZOR",
      "SHUCKLE",
      "HERACROSS",
      "SNEASEL",
      "TEDDIURSA",
      "URSARING",
      "SLUGMA",
      "MAGCARGO",
      "SWINUB",
      "PILOSWINE",
      "CORSOLA",
      "REMORAID",
      "OCTILLERY",
      "DELIBIRD",
      "MANTINE",
      "SKARMORY",
      "HOUNDOUR",
      "HOUNDOOM",
      "KINGDRA",
      "PHANPY",
      "DONPHAN",
      "PORYGON2",
      "STANTLER",
      "SMEARGLE",
      "TYROGUE",
      "HITMONTOP",
      "SMOOCHUM",
      "ELEKID",
      "MAGBY",
      "MILTANK",
      "BLISSEY",
      "RAIKOU",
      "ENTEI",
      "SUICUNE",
      "LARVITAR",
      "PUPITAR",
      "TYRANITAR",
      "LUGIA",
      "HOOH",
      "CELEBI",
      "TREECKO",
      "GROVYLE",
      "SCEPTILE",
      "TORCHIC",
      "COMBUSKEN",
      "BLAZIKEN",
      "MUDKIP",
      "MARSHTOMP",
      "SWAMPERT",
      "POOCHYENA",
      "MIGHTYENA",
      "ZIGZAGOON",
      "LINOONE",
      "WURMPLE",
      "SILCOON",
      "BEAUTIFLY",
      "CASCOON",
      "DUSTOX",
      "LOTAD",
      "LOMBRE",
      "LUDICOLO",
      "SEEDOT",
      "NUZLEAF",
      "SHIFTRY",
      "TAILLOW",
      "SWELLOW",
      "WINGULL",
      "PELIPPER",
      "RALTS",
      "KIRLIA",
      "GARDEVOIR",
      "SURSKIT",
      "MASQUERAIN",
      "SHROOMISH",
      "BRELOOM",
      "SLAKOTH",
      "VIGOROTH",
      "SLAKING",
      "NINCADA",
      "NINJASK",
      "SHEDINJA",
      "WHISMUR",
      "LOUDRED",
      "EXPLOUD",
      "MAKUHITA",
      "HARIYAMA",
      "AZURILL",
      "NOSEPASS",
      "SKITTY",
      "DELCATTY",
      "SABLEYE",
      "MAWILE",
      "ARON",
      "LAIRON",
      "AGGRON",
      "MEDITITE",
      "MEDICHAM",
      "ELECTRIKE",
      "MANECTRIC",
      "PLUSLE",
      "MINUN",
      "VOLBEAT",
      "ILLUMISE",
      "ROSELIA",
      "GULPIN",
      "SWALOT",
      "CARVANHA",
      "SHARPEDO",
      "WAILMER",
      "WAILORD",
      "NUMEL",
      "CAMERUPT",
      "TORKOAL",
      "SPOINK",
      "GRUMPIG",
      "SPINDA",
      "TRAPINCH",
      "VIBRAVA",
      "FLYGON",
      "CACNEA",
      "CACTURNE",
      "SWABLU",
      "ALTARIA",
      "ZANGOOSE",
      "SEVIPER",
      "LUNATONE",
      "SOLROCK",
      "BARBOACH",
      "WHISCASH",
      "CORPHISH",
      "CRAWDAUNT",
      "BALTOY",
      "CLAYDOL",
      "LILEEP",
      "CRADILY",
      "ANORITH",
      "ARMALDO",
      "FEEBAS",
      "MILOTIC",
      "CASTFORM",
      "KECLEON",
      "SHUPPET",
      "BANETTE",
      "DUSKULL",
      "DUSCLOPS",
      "TROPIUS",
      "CHIMECHO",
      "ABSOL",
      "WYNAUT",
      "SNORUNT",
      "GLALIE",
      "SPHEAL",
      "SEALEO",
      "WALREIN",
      "CLAMPERL",
      "HUNTAIL",
      "GOREBYSS",
      "RELICANTH",
      "LUVDISC",
      "BAGON",
      "SHELGON",
      "SALAMENCE",
      "BELDUM",
      "METANG",
      "METAGROSS",
      "REGIROCK",
      "REGICE",
      "REGISTEEL",
      "LATIAS",
      "LATIOS",
      "KYOGRE",
      "GROUDON",
      "RAYQUAZA",
      "JIRACHI",
      "DEOXYS",
      "TURTWIG",
      "GROTLE",
      "TORTERRA",
      "CHIMCHAR",
      "MONFERNO",
      "INFERNAPE",
      "PIPLUP",
      "PRINPLUP",
      "EMPOLEON",
      "STARLY",
      "STARAVIA",
      "STARAPTOR",
      "BIDOOF",
      "BIBAREL",
      "KRICKETOT",
      "KRICKETUNE",
      "SHINX",
      "LUXIO",
      "LUXRAY",
      "BUDEW",
      "ROSERADE",
      "CRANIDOS",
      "RAMPARDOS",
      "SHIELDON",
      "BASTIODON",
      "BURMY",
      "WORMADAM",
      "MOTHIM",
      "COMBEE",
      "VESPIQUEN",
      "PACHIRISU",
      "BUIZEL",
      "FLOATZEL",
      "CHERUBI",
      "CHERRIM",
      "SHELLOS",
      "GASTRODON",
      "AMBIPOM",
      "DRIFLOON",
      "DRIFBLIM",
      "BUNEARY",
      "LOPUNNY",
      "MISMAGIUS",
      "HONCHKROW",
      "GLAMEOW",
      "PURUGLY",
      "CHINGLING",
      "STUNKY",
      "SKUNTANK",
      "BRONZOR",
      "BRONZONG",
      "BONSLY",
      "MIMEJR",
      "HAPPINY",
      "CHATOT",
      "SPIRITOMB",
      "GIBLE",
      "GABITE",
      "GARCHOMP",
      "MUNCHLAX",
      "RIOLU",
      "LUCARIO",
      "HIPPOPOTAS",
      "HIPPOWDON",
      "SKORUPI",
      "DRAPION",
      "CROAGUNK",
      "TOXICROAK",
      "CARNIVINE",
      "FINNEON",
      "LUMINEON",
      "MANTYKE",
      "SNOVER",
      "ABOMASNOW",
      "WEAVILE",
      "MAGNEZONE",
      "LICKILICKY",
      "RHYPERIOR",
      "TANGROWTH",
      "ELECTIVIRE",
      "MAGMORTAR",
      "TOGEKISS",
      "YANMEGA",
      "LEAFEON",
      "GLACEON",
      "GLISCOR",
      "MAMOSWINE",
      "PORYGONZ",
      "GALLADE",
      "PROBOPASS",
      "DUSKNOIR",
      "FROSLASS",
      "ROTOM",
      "UXIE",
      "MESPRIT",
      "AZELF",
      "DIALGA",
      "PALKIA",
      "HEATRAN",
      "REGIGIGAS",
      "GIRATINA",
      "CRESSELIA",
      "PHIONE",
      "MANAPHY",
      "DARKRAI",
      "SHAYMIN",
      "ARCEUS",
      "VICTINI",
      "SNIVY",
      "SERVINE",
      "SERPERIOR",
      "TEPIG",
      "PIGNITE",
      "EMBOAR",
      "OSHAWOTT",
      "DEWOTT",
      "SAMUROTT",
      "PATRAT",
      "WATCHOG",
      "LILLIPUP",
      "HERDIER",
      "STOUTLAND",
      "PURRLOIN",
      "LIEPARD",
      "PANSAGE",
      "SIMISAGE",
      "PANSEAR",
      "SIMISEAR",
      "PANPOUR",
      "SIMIPOUR",
      "MUNNA",
      "MUSHARNA",
      "PIDOVE",
      "TRANQUILL",
      "UNFEZANT",
      "BLITZLE",
      "ZEBSTRIKA",
      "ROGGENROLA",
      "BOLDORE",
      "GIGALITH",
      "WOOBAT",
      "SWOOBAT",
      "DRILBUR",
      "EXCADRILL",
      "AUDINO",
      "TIMBURR",
      "GURDURR",
      "CONKELDURR",
      "TYMPOLE",
      "PALPITOAD",
      "SEISMITOAD",
      "THROH",
      "SAWK",
      "SEWADDLE",
      "SWADLOON",
      "LEAVANNY",
      "VENIPEDE",
      "WHIRLIPEDE",
      "SCOLIPEDE",
      "COTTONEE",
      "WHIMSICOTT",
      "PETILIL",
      "LILLIGANT",
      "BASCULIN",
      "SANDILE",
      "KROKOROK",
      "KROOKODILE",
      "DARUMAKA",
      "DARMANITAN",
      "MARACTUS",
      "DWEBBLE",
      "CRUSTLE",
      "SCRAGGY",
      "SCRAFTY",
      "SIGILYPH",
      "YAMASK",
      "COFAGRIGUS",
      "TIRTOUGA",
      "CARRACOSTA",
      "ARCHEN",
      "ARCHEOPS",
      "TRUBBISH",
      "GARBODOR",
      "ZORUA",
      "ZOROARK",
      "MINCCINO",
      "CINCCINO",
      "GOTHITA",
      "GOTHORITA",
      "GOTHITELLE",
      "SOLOSIS",
      "DUOSION",
      "REUNICLUS",
      "DUCKLETT",
      "SWANNA",
      "VANILLITE",
      "VANILLISH",
      "VANILLUXE",
      "DEERLING",
      "SAWSBUCK",
      "EMOLGA",
      "KARRABLAST",
      "ESCAVALIER",
      "FOONGUS",
      "AMOONGUSS",
      "FRILLISH",
      "JELLICENT",
      "ALOMOMOLA",
      "JOLTIK",
      "GALVANTULA",
      "FERROSEED",
      "FERROTHORN",
      "KLINK",
      "KLANG",
      "KLINKLANG",
      "TYNAMO",
      "EELEKTRIK",
      "EELEKTROSS",
      "ELGYEM",
      "BEHEEYEM",
      "LITWICK",
      "LAMPENT",
      "CHANDELURE",
      "AXEW",
      "FRAXURE",
      "HAXORUS",
      "CUBCHOO",
      "BEARTIC",
      "CRYOGONAL",
      "SHELMET",
      "ACCELGOR",
      "STUNFISK",
      "MIENFOO",
      "MIENSHAO",
      "DRUDDIGON",
      "GOLETT",
      "GOLURK",
      "PAWNIARD",
      "BISHARP",
      "BOUFFALANT",
      "RUFFLET",
      "BRAVIARY",
      "VULLABY",
      "MANDIBUZZ",
      "HEATMOR",
      "DURANT",
      "DEINO",
      "ZWEILOUS",
      "HYDREIGON",
      "LARVESTA",
      "VOLCARONA",
      "COBALION",
      "TERRAKION",
      "VIRIZION",
      "TORNADUS",
      "THUNDURUS",
      "RESHIRAM",
      "ZEKROM",
      "LANDORUS",
      "KYUREM",
      "KELDEO",
      "MELOETTA",
      "GENESECT",
      "CHESPIN",
      "QUILLADIN",
      "CHESNAUGHT",
      "FENNEKIN",
      "BRAIXEN",
      "DELPHOX",
      "FROAKIE",
      "FROGADIER",
      "GRENINJA",
      "BUNNELBY",
      "DIGGERSBY",
      "FLETCHLING",
      "FLETCHINDER",
      "TALONFLAME",
      "SCATTERBUG",
      "SPEWPA",
      "VIVILLON",
      "LITLEO",
      "PYROAR",
      "FLABEBE",
      "FLOETTE",
      "FLORGES",
      "SKIDDO",
      "GOGOAT",
      "PANCHAM",
      "PANGORO",
      "FURFROU",
      "ESPURR",
      "MEOWSTIC",
      "HONEDGE",
      "DOUBLADE",
      "AEGISLASH",
      "SPRITZEE",
      "AROMATISSE",
      "SWIRLIX",
      "SLURPUFF",
      "INKAY",
      "MALAMAR",
      "BINACLE",
      "BARBARACLE",
      "SKRELP",
      "DRAGALGE",
      "CLAUNCHER",
      "CLAWITZER",
      "HELIOPTILE",
      "HELIOLISK",
      "TYRUNT",
      "TYRANTRUM",
      "AMAURA",
      "AURORUS",
      "SYLVEON",
      "HAWLUCHA",
      "DEDENNE",
      "CARBINK",
      "GOOMY",
      "SLIGGOO",
      "GOODRA",
      "KLEFKI",
      "PHANTUMP",
      "TREVENANT",
      "PUMPKABOO",
      "GOURGEIST",
      "BERGMITE",
      "AVALUGG",
      "NOIBAT",
      "NOIVERN",
      "XERNEAS",
      "YVELTAL",
      "ZYGARDE",
      "DIANCIE",
      "HOOPA",
      "VOLCANION",
      "ROWLET",
      "DARTRIX",
      "DECIDUEYE",
      "LITTEN",
      "TORRACAT",
      "INCINEROAR",
      "POPPLIO",
      "BRIONNE",
      "PRIMARINA",
      "PIKIPEK",
      "TRUMBEAK",
      "TOUCANNON",
      "YUNGOOS",
      "GUMSHOOS",
      "GRUBBIN",
      "CHARJABUG",
      "VIKAVOLT",
      "CRABRAWLER",
      "CRABOMINABLE",
      "ORICORIO",
      "CUTIEFLY",
      "RIBOMBEE",
      "ROCKRUFF",
      "LYCANROC",
      "WISHIWASHI",
      "MAREANIE",
      "TOXAPEX",
      "MUDBRAY",
      "MUDSDALE",
      "DEWPIDER",
      "ARAQUANID",
      "FOMANTIS",
      "LURANTIS",
      "MORELULL",
      "SHIINOTIC",
      "SALANDIT",
      "SALAZZLE",
      "STUFFUL",
      "BEWEAR",
      "BOUNSWEET",
      "STEENEE",
      "TSAREENA",
      "COMFEY",
      "ORANGURU",
      "PASSIMIAN",
      "WIMPOD",
      "GOLISOPOD",
      "SANDYGAST",
      "PALOSSAND",
      "PYUKUMUKU",
      "TYPENULL",
      "SILVALLY",
      "MINIOR",
      "KOMALA",
      "TURTONATOR",
      "TOGEDEMARU",
      "MIMIKYU",
      "BRUXISH",
      "DRAMPA",
      "DHELMISE",
      "JANGMOO",
      "HAKAMOO",
      "KOMMOO",
      "TAPUKOKO",
      "TAPULELE",
      "TAPUBULU",
      "TAPUFINI",
      "COSMOG",
      "COSMOEM",
      "SOLGALEO",
      "LUNALA",
      "NIHILEGO",
      "BUZZWOLE",
      "PHEROMOSA",
      "XURKITREE",
      "CELESTEELA",
      "KARTANA",
      "GUZZLORD",
      "NECROZMA",
      "MAGEARNA",
      "MARSHADOW",
      "POIPOLE",
      "NAGANADEL",
      "BLACEPHALON",
      "STAKATAKA",
      "ZERAORA",
      "MELTAN",
      "MELMETAL",
      "GROOKEY",
      "THWACKEY",
      "RILLABOOM",
      "SCORBUNNY",
      "RABOOT",
      "CINDERACE",
      "SOBBLE",
      "DRIZZILE",
      "INTELEON",
      "SKWOVET",
      "GREEDENT",
      "ROOKIDEE",
      "CORVISQUIRE",
      "CORVIKNIGHT",
      "BLIPBUG",
      "DOTTLER",
      "ORBEETLE",
      "NICKIT",
      "THIEVUL",
      "GOSSIFLEUR",
      "ELDEGOSS",
      "WOOLOO",
      "DUBWOOL",
      "CHEWTLE",
      "DREDNAW",
      "YAMPER",
      "BOLTUND",
      "ROLYCOLY",
      "CARKOL",
      "COALOSSAL",
      "APPLIN",
      "FLAPPLE",
      "APPLETUN",
      "SILICOBRA",
      "SANDACONDA",
      "CRAMORANT",
      "ARROKUDA",
      "BARRASKEWDA",
      "TOXEL",
      "TOXTRICITY",
      "SIZZLIPEDE",
      "CENTISKORCH",
      "CLOBBOPUS",
      "GRAPPLOCT",
      "SINISTEA",
      "POLTEAGEIST",
      "HATENNA",
      "HATTREM",
      "HATTERENE",
      "IMPIDIMP",
      "MORGREM",
      "GRIMMSNARL",
      "OBSTAGOON",
      "PERRSERKER",
      "CURSOLA",
      "SIRFETCHD",
      "MRRIME",
      "RUNERIGUS",
      "MILCERY",
      "ALCREMIE",
      "FALINKS",
      "PINCURCHIN",
      "SNOM",
      "FROSMOTH",
      "STONJOURNER",
      "EISCUE",
      "INDEEDEE",
      "MORPEKO",
      "CUFANT",
      "COPPERAJAH",
      "DRACOZOLT",
      "ARCTOZOLT",
      "DRACOVISH",
      "ARCTOVISH",
      "DURALUDON",
      "DREEPY",
      "DRAKLOAK",
      "DRAGAPULT",
      "ZACIAN",
      "ZAMAZENTA",
      "ETERNATUS",
      "KUBFU",
      "URSHIFU",
      "ZARUDE",
      "REGIELEKI",
      "REGIDRAGO",
      "GLASTRIER",
      "SPECTRIER",
      "CALYREX"]
  if typ=="NONE"
    rPoke=allstarters[rand(allstarters.length)]
    return rPoke
  else
    spoke=[]
    tyo=typ
    for i in 0...allstarters.length
      poke=Pokemon.new(GameData::Species.get(allstarters[i]),20,$player)
      if tyo==pbHasType?(poke.type1)||tyo==pbHasType?(poke.type2)
        spoke=spoke.push(allstarters[i])
      end 
    end
    tPoke=spoke[rand(spoke.length)]
    #fer=isSpecies?.getName(tPoke)
    return tPoke
  end
end

def pbFixCommonStarterSpellingErrors(variable)
    starter=$game_variables[variable]
  if starter=="MR MIME"||starter=="MR. MIME"||starter=="MR.MIME"||starter=="MISTERMIME" 
    $game_variables[variable]="MRMIME"
  end
  if starter=="JINX" 
    $game_variables[variable]="JYNX"
  end
  if starter=="ONYX" 
    $game_variables[variable]="ONIX"
  end
  if starter=="POOCHYEENA"||starter=="POOCHEENA"
    $game_variables[variable]="POOCHYENA"
  end
  if starter=="MAGICARP"||starter=="MAJIKARP"||starter=="MAJICARP"
    $game_variables[variable]="MAGIKARP"
  end
  if starter=="FARFETCH'D"||starter=="FARFECH'D"||starter=="FARFECHD"
    $game_variables[variable]="FARFETCHD"
  end
  if starter=="GHASTLY"||starter=="GASTLEY"
    $game_variables[variable]="GASTLY"
  end
  if starter=="HO-OH"||starter=="HO OH"
    $game_variables[variable]="HOOH"
  end
  if starter=="PORYGON 2"
    $game_variables[variable]="PORYGON2"
  end
  if starter=="FLAFFY"||starter=="FLAAFY"
    $game_variables[variable]="FLAAFFY"
  end
  if starter=="VICTREEBELL"||starter=="VICTORYBELL"
    $game_variables[variable]="VICTREEBEL"
  end
  if starter=="FERALIGATOR"||starter=="FERALLIGATOR"
    $game_variables[variable]="FERALIGATR"
  end
  if starter=="NINETAILS"
    $game_variables[variable]="NINETALES"
  end
  if starter=="VENASAUR"
    $game_variables[variable]="VENUSAUR"
  end
  if starter=="GARADOS"||starter=="GARYDOS"||starter=="GYRADOS"
    $game_variables[variable]="GYARADOS"
  end
  if starter=="DIGLET"||starter=="DIGGLET"||starter=="DIGGLETT"
    $game_variables[variable]="DIGLETT"
  end
  if starter=="POLITOAD"||starter=="POLYTOAD"
    $game_variables[variable]="POLITOED"
  end
  if starter=="NIDORAN"
    command=Kernel.pbShowCommands(nil,
       [_INTL("Male?"),
       _INTL("Female?")],
       -1)
      if command==0 # Male
        $game_variables[variable]="NIDORANmA"
      elsif command==1 # Female
        $game_variables[variable]="NIDORANfE"
      end
    end
    if starter=="NIDORAN♀"||starter=="NIDORANF"
      $game_variables[variable]="NIDORANfE"
    end
    if starter=="NIDORAN♂"||starter=="NIDORANM"
      $game_variables[variable]="NIDORANmA"
    end
    starter=$game_variables[variable]
  if starter=="RANDOM"||starter=="Random"||starter=="Anything"||starter=="ANYTHING" 
    $game_variables[variable]=pbRandomStarter("NONE")
  end
  if starter=="GRASS"||
    starter=="FIRE"||
    starter=="WATER"||
    starter=="NORMAL"||
    starter=="FLYING"||
    starter=="BUG"||
    starter=="FIGHTING"||
    starter=="POISON"||
    starter=="ROCK"||
    starter=="GROUND"||
    starter=="ELECTRIC"||
    starter=="ICE"||
    starter=="PSYCHIC"||
    starter=="DARK"||
    starter=="STEEL"||
    starter=="DRAGON"
      $game_variables[variable]=pbRandomStarter(starter)
  end
end

def pbIsLowestEvolutionStarter?(variable)
  starter=$game_variables[variable]
  pkmn=GameData::Species.get(starter).id
  return true if pkmn==GameData::Species.get(pkmn).get_baby_species
  return false
end

def pbCheckMoveType(type,va,wa)
  $player.pokemon_party.each do |pkmn|
    pkmn.moves.each do |m|
      if m.type == type
        $game_variables[va] = pkmn.name
        $game_variables[wa] = m.name
        return true
      end
    end
  end
  return false
end

def pbSetBaseEvolutionStarter(variable)
  pkmn = GameData::Species.get($game_variables[variable]).get_baby_species
  $game_variables[variable] = pkmn
end

def pbSetGameVariables(variable,wariable)
  $game_variables[variable] = $game_variables[wariable]
end

###---END NEW---###
