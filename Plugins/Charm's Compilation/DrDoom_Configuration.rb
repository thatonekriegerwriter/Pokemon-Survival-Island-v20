#===============================================================================
# * Charm Configuration
#===============================================================================

module DrCharmConfig
  #=======Elemental Charm Encounter Rate=======#
  # # Note: MAX 100
  # Default: 40	
  ELEMENTAL_CHARM_ENCOUNTER_RATE = 40

  # Added settings for the Elemental Charms. Added the ability to have the
  # Elemental Charm add a change of multiplying the chance to capture given Elemental
  # when Charm is active. (For reference, frozen and sleep status multiply by 2.5)

  # t/f. Turns the option on or off for added capture chance.
  ELEMENTAL_CHARM_TOGGLE = true

  # Multiplies capture chance for given type when Charm is active.
  # Default: 2.5
  ELEMENTAL_CHARM_CAPTURE_MODIFIER = 2.5

  #=======Promo Charm========#
  # Setting will change the chance of encountering Pokemon at max encounter level.
  # Default: 30 
  # Note: MAX 100
  PROMO_CHARM = 30

  #======Clover Charm=====#
  # Setting will change the chance of Pokemon having held items. Similar to Compound
  # Eyes(CE) and Superluck(SL).
  # Default Clover Charm(CC): 60, 20, 5
  # Rates are for common, uncommon, rare respectively.
  # Note: MAX 100
  CLOVERCOMMON = 60
  CLOVERUNCOMMON = 20
  CLOVERRARE = 5

  # Default combined CC / CE / SL: 75, 35, 15
  # Rates are for common, uncommon, rare respectively.
  # Note: MAX 100
  COMBINEDCOMMON = 110
  COMBINEDUNCOMMON = 35
  COMBINEDRARE = 15

  #=====Shiny Charm====#
  # Changes retry chance of Wild Pokemon being shiny.
  # Default: 2
  SHINY_CHANCE_RETRIES = 2

  #=====Lure Charm====#
  # Changes retry chance of Wild Pokemon being shiny if has Lure Charm
  # Default: 2
  LURE_CHARM_RETRIES = 2

  #=====Viral Charm====#
  # Increases chance of Wild Pokemon having PokeRus.
  # Game default for this is in Settings::POKERUS_CHANCE / 65536.
  # Note: MAX 100
  # Default: 10 %
  VIRAL_CHARM_POKERUS = 10

  #=====Smart Charm====#
  # Increases chance to encounter Pokemon with Egg or Tutor move.
  # Note: MAX 100
  # Default: 30%
  SMARTCHARM_EGGTUTOR_MOVE = 30

  #=====Key Charm====#
  # Increases chance to encounter Pokemon with Hidden Ability.
  # Note: MAX 100
  # Default: 30%
  KEYCHARM_HIDDEN_ABILITY = 30

  #=====Catching Charm====#
  # Multiplies chance of Critical Capture.
  # Default: 2 (*2)
  CATCHING_CHARM_CRIT = 2

  #=====Heart Charm====#
  # Adjusts the flee rate
  # Higher value means more chance to flee, when charm is active.
  # Note: MAX 100
  # Default: 50
  HEART_CHARM_FLED = 50

  #=====IV Charm====#
  # Adds 5 IV to every stat in Wild Pokemon encounter.
  IV_CHARM_ADD_IV = 5

  #=====Gene Charm====#
  # Precent change of maxing one stat on Wild Pokemon.
  # Note: MAX 100
  # Default: 40
  GENE_CHARM_ONE_MAX = 40

  #=======Gold Charm====#
  # Multiplies gold after Trainer Battle. Also adds a set amount of Gold every battle.
  # Default: 2 (*2)
  GOLD_CHARM_PAY_DAY = 2

  # Gold gain per battle. Adds this amount after every battle.
  # Default: 500
  GOLD_CHARM_GET_GOLD = 500

  #=======Healing Charm====#
  # Multiplies effect of restore items and adds HP on steps
  # Restore items * ?
  # Default: 2
  HEALING_CHARM_MULTIPLY = 2

  # HP on steps. This value is the interval in which 1 HP is given. 
  # By default, it's 1 HP every 35 steps.
  # Default: 35
  HEALING_CHARM_HEAL_ON_STEP = 35

  #=======Eggs==========#
  #=======Oval Charm====#
  # Setting changes the chance of generating egg
  # Default is 0, 40, 70, 80
  # TBA

  #=====IV Charm Daycare====#
  # Setting adjusts the added IV values. It adds setting to every IV by default.
  # Default: 5
  IVCHARM_IV_EGG_ADD = 5

  #====Shiny Charm Eggs ======= $
  # Adds 3 more Shiny Retries to the breeding process is one of the parents are Shiny.
  # This setting will turn the option on or off, altogether.
  # Default: true
  FATHERMOTHER_SHINY = true

  # Adds 3 extra Shiny Retries if one of the Parents are Shiny.
  #Default: 3
  MOTHERFATHER_EGG_SHINY_CHANCE = 3

  # Adds 2 more Shiny Retries if player has the Shiny Charm active.
  # Default: 2
  SHINYCHARM_SHINY_RETRY_EGG = 2

  #=======Wishing Charm=======#
  # The Wishing Charm is meant to give a Pokemon or Item every day.
  # I made two options for this. First is a random generator that will give any Pokemon 
  # other than Legendary and starter. This option can give you anything from a Magikarp to a Charizard.
  # Second option is a manually set list.

  # Wishing Star refresh time
  # Value listed is in hours.
  # Default: 24 (hours)
  WISHING_CHARM_REFRESH = 24

  # If you keep this option true, it will be set to pull from a random list.
  # If you set it to false, it will use the set list.
  WISHING_CHARM_USE_AUTO = true

  # This setting will change wether or not Legendary Pokemon are 
  # to be considered for an Eligable Pokemon.
  # true is no legendry in auto generation, false means is will include Legendary in the pool
  NO_LEGENDARY_AUTO = true

  # Setting for using a the Blacklist auto generated Pokemon
  # true means it will, false means it will not use the Blacklist when generating Pokemon.
  AUTO_USE_BLACKLIST = true

  # Set given Pokemon's level
  WISHING_CHARM_PKMN_LEVEL = 5

  # If you choose to use list, this is the list that needs to be populated with your Pokemon.
  # Comes pre-loaded with Pseudo Legs and a few rarer Pokemon from the games.
  # If you modify this, please ensure the proper format is followed, or it will throw an error.
  # Proper format [:POKEMON1, :POKEMON2, :POKEMON3]
  WISHING_CHARM_APPROVED_LIST = [
    :DRATINI, :LARVITAR, :BAGON, :BELDUM, :GIBLE, :DEINO, :GOOMY, :JANGMOO,
    :DREEPY, :FRIGIBAX, :DITTO, :EEVEE, :CHANSEY, :RIOLU, :SNORLAX, :TOGEPI
    ]

  WISHING_CHARM_BLACK_LIST = [
    :BULBASAUR, :IVYSASUR, :VENUSAUR, :SQUIRTLE, :WARTORTLE, :BLASTOISE, :TOTODILE, :CROCONAW, :FERALIGATR,
    :MUDKIP, :MARSHTOMP, :SWAMPERT, :PIPLUP, :PRINPLUP, :EMPOLEON, :CHARMANDER, :CHARMELEON, :CHARIZARD,
    :TREECKO, :GROVYLE, :SCEPTILE, :TORCHIC, :COMBUSKEN, :BLAZIKEN, :TURTWIG, :GROTILE, :TORTERRA,
    :CHIMCHAR, :MONFERNO, :INFERNAPE, :SNIVY, :SERVINE, :SERPERIOR, :TEPIG, :PIGNITE, :EMBOAR,
    :OSHAWOTT, :DEWOTT, :SAMUROTT, :CHESPIN, :QUILLADIN, :CHESNAUGHT, :FENNEKIN, :BRAIXEN, :DELPHOX, 
    :FROAKIE, :FROGADIER, :GRENINJA, :ROWLET, :DARTRIX, :DECIDUEYE, :LITTEN, :TORRACAT, :INCINEROAR,
    :POPPLIO, :BRIONNE, :PRIMARINA, :GROOKEY, :THWACKEY, :RILLABOOM, :SCORBUNNY, :RABOOT, :CINDERACE,
    :SOBBLE, :DRIZZILE, :INTELEON, :SPRIGATITO, :FLORAGATO, :MEOWSCARADA, :FUECOCO, :CROCALOR, :SKELEDIRGE,
    :QUAXLY, :QUAXWELL, :QUAQUAVAL, :MANAPHY, :PHIONE
    ]

  # This setting will allow rare items to be added to the pool, as well. If true, it will have
  # a chance to either give and Item or a Pokemon. If false, will always give Pokemon.
  WISHING_CHARM_LIST_AND_POKE = true

  # This is a list of possible items that will be given, if an item is awarded instead of a Pokemon.
  # Please keep the proper format: [:ITEM1, :ITEM2, :ITEM3]
  WISHING_CHARM_ITEM_LIST = [
    :NUGGET, :STARPIECE, :BALMMUSHROOM, :BIGNUGGET, :COMETSHARD, :PEARLSTRING, :ABILITYPATCH, :ABILITYCAPSULE,
    :AMULETCOIN, :MASTERBALL
    ]
end