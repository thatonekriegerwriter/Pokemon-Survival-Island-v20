def pbCraftingBench(wari)
pbFadeOutIn {
  Crafts.craftWindow(:CRAFTINGBENCH ,3) if wari == :CRAFTINGBENCH 
  Crafts.craftWindow(:UPGRADEDCRAFTINGBENCH ,5) if wari == :UPGRADEDCRAFTINGBENCH 
  Crafts.craftWindow(:CAULDRON ,3) if wari == :CAULDRON 
  Crafts.craftWindow(:APRICORNCRAFTING ,4) if wari == :APRICORNCRAFTING || wari == :APRICORNMACHINE
  Crafts.craftWindow(:MEDICINEPOT ,5) if wari == :MEDICINEPOT
  Crafts.craftWindow(:POCKETCRAFTING ,2) if wari == :POCKETCRAFTING
  Crafts.craftWindow(:GRINDER ,1) if wari == :GRINDER || wari == :ELECTRICGRINDER
  Crafts.craftWindow(:FURNACE ,2) if wari == :FURNACE || wari == :ELECTRICFURNACE
  Crafts.craftWindow(:ELECTRICPRESS ,1) if wari == :ELECTRICPRESS
  Crafts.craftWindow(:SEWINGMACHINE ,3) if wari == :SEWINGMACHINE
  }
end




module CraftsList
  def self.getcrafts(type)
  
  
    @CraftsList = getcrafttypes(type)
    return @CraftsList
  end
  
  def self.getcrafttypes(type)
      case type
        when :CAULDRON
		   return CraftsList.cooking
        when :CRAFTINGBENCH
		   return CraftsList.crafting
        when :UPGRADEDCRAFTINGBENCH
		   return CraftsList.ucrafting
        when :APRICORNCRAFTING
		   return CraftsList.pokeball
        when :FURNACE
		   return CraftsList.furnace
        when :GRINDER
		   return CraftsList.grinder
        when :MEDICINEPOT
		   return CraftsList.medicine
        when :POCKETCRAFTING
		   return CraftsList.pocket
        when :ELECTRICPRESS
		   return CraftsList.press
        when :SEWINGMACHINE
		   return CraftsList.sewing
		 else
		   return CraftsList.crafting
      end
  end
  
  
  def self.cooking
      return [
    [:NO,:NO,:NO,:NO], 
    [:TEA,:FRESHWATER,:TEALEAF], 
    #RECIPE 2: 
    [:SWEETHEART,:SUGAR,:CHOCOLATE], 
    #RECIPE 3: 
    [:CARROTCAKE,:WHEAT,:SUGAR,:CARROT],
    #RECIPE 4:  
    [:LEMONADE,:LEMON,:SUGAR,:FRESHWATER], 
    #RECIPE 5:  
    [:BREAD,:WHEAT,:WHEAT,:WHEAT],
    #RECIPE 6: 
    [:CHOCOLATE,:SUGAR,:COCOABEAN],
    #RECIPE 7: 
    #[:GSCURRY,:MEAT,:STARFBERRY,:BOWL],
    #RECIPE 21: 
    [:LAXMINT,:SUGAR,:WHEAT],
    #RECIPE 22: 
    #RECIPE 26: 
    [:QUIETMINT,:SUGAR,:APPLE],
    #RECIPE 27: 
	#RECIPE 36:
    [:BERRYMASH,:ORANBERRY,:SITRUSBERRY,:SITRUSBERRY],
	#RECIPE 36:
    [:SITRUSJUICE,:SUGAR,:BERRYMASH,:WATERBOTTLE],
	#RECIPE 37:
    [:SUSPO,:ARGOSTBERRY,:FRESHWATER,:ENIGMABERRY],
	#RECIPE 37:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:ATKCURRY],
	#RECIPE 38:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:SATKCURRY],
	#RECIPE 39:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:SPEEDCURRY],
	#RECIPE 40:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:SPDEFCURRY],
	#RECIPE 41:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:ACCCURRY],
	#RECIPE 42:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:DEFCURRY],
	#RECIPE 43:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:CRITCURRY],
	#RECIPE 44:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:GSCURRY],
    [:MEATSANDWICHBIRD,:BREAD,:COOKEDBIRDMEAT],
    [:MEATSANDWICHROCKY,:BREAD,:COOKEDROCKYMEAT],
    [:MEATSANDWICHBUG,:BREAD,:COOKEDBUGMEAT],
    [:MEATSANDWICHSTEELY,:BREAD,:COOKEDSTEELYMEAT],
    [:MEATSANDWICHSUS,:BREAD,:COOKEDSUSHI],
    [:MEATSANDWICHLEAFY,:BREAD,:COOKEDLEAFYMEAT],
    [:MEATSANDWICHMJ,:BREAD,:COOKEDDRAGONMEAT],
    [:MEATSANDWICHCRYSTAL,:BREAD,:COOKEDEDIABLESCRYSTAL],
    [:MEATSANDWICH,:BREAD,:COOKEDMEAT],
    [:POTATOSTEW,:POTATO,:ONION,:CARROT],
    [:MEATKABOB,:POTATO,:ONION,:COOKEDMEAT],
    [:SOUPBROTH,:FRESHWATER,:RAREBONE,:BALMMUSHROOM],
    [:FISHSOUP,:SUSHI,:POTATO,:SOUPBROTH]
    ]

  end




  def self.press
      return [
    [:NO,:NO,:NO,:NO], 
[:FLAMEPLATE,[:REDSHARD,4]],
[:SPLASHPLATE,[:BLUESHARD,4]],
[:ZAPPLATE,[:YELLOWSHARD,4]],
[:MEADOWPLATE,[:GREENSHARD,4]],
[:ICICLEPLATE,[:BLUESHARD,2],[:YELLOWSHARD,2]],
[:FISTPLATE,[:REDSHARD,3],[:GREENSHARD,1]],
[:TOXICPLATE,[:GREENSHARD,2],[:REDSHARD,2]],
[:EARTHPLATE,[:GREENSHARD,2],[:BLUESHARD,2]],
[:SKYPLATE,[:GREENSHARD,2],[:YELLOWSHARD,2]],
[:MINDPLATE,[:YELLOWSHARD,2],[:BLUESHARD,2]],
[:INSECTPLATE,[:GREENSHARD,2],[:YELLOWSHARD,2]],
[:SPOOKYPLATE,[:REDSHARD,2],[:YELLOWSHARD,2]],
[:DRACOPLATE,[:REDSHARD,3],[:BLUESHARD,1]],
[:DREADPLATE,[:BLUESHARD,3],[:GREENSHARD,1]],
[:IRONPLATE,[:GREENSHARD,3],[:BLUESHARD,1]],
[:HARDSTONE,[:STONE,2]]
	]
  end


  def self.sewing
      return [ 
    [:NO,:NO,:NO,:NO], 
    [:CHOICESCARF,[:WOOL,4]],
[:EXPERTBELT,[:LEATHER,3]],
[:MUSCLEBAND,[:WOOL,3],[:LIECHIBERRY,3]],
[:BINDINGBAND,[:WOOL,2],[:IRON2,3]],
[:FOCUSBAND,[:WOOL,5],[:ARGOSTBERRY,4]],
[:FOCUSSASH,[:WOOL,2],[:ARGOSTBERRY,1]],
[:BLACKBELT,[:LEATHER,2],[:CHOPLEBERRY,2]],
[:SILKSCARF,[:SILK,2],[:WOOL,2]],
[:REDSCARF,[:REDSHARD,3],[:WOOL,2]],
[:BLUESCARF,[:BLUESHARD,2],[:WOOL,2]],
[:PINKSCARF,[:REDSHARD,2],[:WOOL,2]],
[:GREENSCARF,[:GREENSHARD,3],[:WOOL,2]],
[:YELLOWSCARF,[:YELLOWSHARD,3],[:WOOL,2]],
[:LUCKYPUNCH,[:LEATHER,6],[:LANSATBERRY,4]],
[:MACHOBRACE,[:WOOL,5],:IRON2,6,[:SILVER2,3]],
[:POWERBELT,[:WOOL,2],[:LEATHER,3]],
[:POWERBAND,[:WOOL,3],[:LEATHER,4]],
[:POWERANKLET,[:WOOL,1],[:LEATHER,2]],
[:LCLOAK,[:WOOL,12]],
[:SSHIRT,[:SILK,8],[:WOOL,3]],
[:LJACKET,[:LEATHER,6],[:WOOL,3]],
[:IRONARMOR,[:IRONPLATE,10],[:WOOL,10]],
[:SEASHOES,[:LEATHER,4],[:WOOL,2],[:SILK,2]],
[:PROTECTIVEVEST,[:IRON2,2],[:LEATHER,4]],
[:GHOSTMAIL,[:SILVER2,2],[:SPOOKYPLATE,10]],
[:SMOOCHUMDOLL,[:WOOL,2]],
[:TORCHICDOLL,[:WOOL,2]],
[:MEOWTHDOLL,[:WOOL,2]],
[:TREECKODOLL,[:WOOL,2]],
[:TREECKODOLL,[:WOOL,2]]
	
	
	
	
	
	]
  end

  def self.pocket
      return [ 
    [:NO,:NO,:NO,:NO], 
[:WOODENPLANKS,[:WOODENSTICKS,2]],
[[:WOODENPLANKS,2],[:WOODENLOG,1]],
[[:WOODENSTICKS,2],[:WOODENPLANKS,1]],
[:CRAFTINGBENCH,[:WOODENPLANKS,2],[:WOODENLOG,1]],
[[:HEALPOWDER,2],[:CHERIBERRY,1]],
[[:ENERGYPOWDER,2],[:SITRUSBERRY,1]],
[:BERRYJUICE,[:ORANBERRY,2],[:BOWL,1]],
[:GLASSBOTTLE,[:GLASS,1]],
[:STONE,[:HARDSTONE,1]],
[:SQUIRTBOTTLE,[:IRON2,9]]
 ]
  end

  def self.medicine
      return [ 
    [:NO,:NO,:NO,:NO], 
[:POTION,[:ORANBERRY,2],[:WATERBOTTLE,1]],
[:SUPERPOTION,[:POTION,1],[:SITRUSBERRY,2],[:ARGOSTBERRY,2]],
[:HYPERPOTION,[:SUPERPOTION,1],[:SITRUSBERRY,3],[:ARGOSTBERRY,3]],
[:FULLRESTORE,[:HYPERPOTION,1],[:SITRUSBERRY,3],[:ARGOSTBERRY,5],[:CHILANBERRY,5],[:JABOCABERRY,5]],
[:RARECANDY,[:MAXPLUMAGE,5],[:SWIFTFEATHER,5]],
[:HPUP,[:HEALTHFEATHER,10]],
[:PROTEIN,[:MUSCLEFEATHER,10]],
[:PPUP,[:MUSCLEFEATHER,10],[:CLEVERFEATHER,10]],
[:IRON,[:RESISTFEATHER,10]],
[:CALCIUM,[:GENIUSFEATHER,10]],
[:ZINC,[:CLEVERFEATHER,10]],
[:CARBOS,[:SWIFTFEATHER,10]],
[:MAXPLUMAGE,[:HEALTHFEATHER,1],[:MUSCLEFEATHER,1],[:RESISTFEATHER,1],[:GENIUSFEATHER,1],[:CLEVERFEATHER,1]]
]
  end




  def self.crafting
     crafting = []
     crafting += self.pocket
     ncrafting = [ 
         [:APRICORNCRAFTING,[:WOODENPLANKS,6],[:STONE,2]],
         [:FURNACE,[:STONE,3],[:WOODENLOG,1],[:STONE,3]],
         [:CAULDRON,[:IRON2,2],[:IRON2,1],[:IRON2,2]],
         [:GRINDER,[:STONE,2],[:IRON2,3],[:STONE,2]],
         [:MEDICINEPOT,[:CLAY2,2],[:CLAY2,1],[:CLAY2,2]],
         [:BEDROLL,[:WOODENPLANKS,3],[:WOOL,3]],
         [:WOODENPAIL,[:WOODENLOG,1],[:WOODENPLANKS,1],[:WOODENPLANKS,1]],
         [:ITEMCRATE,[:WOODENPLANKS,5],[:WOODENLOG,2]],
         [:PKMNCRATE,[:WOODENPLANKS,5],[:IRON2,3],[:POKEBALLC,5]],
         [:PORTABLECAMP,[:WOOL,5],[:WOODENPLANKS,5],[:COPPER2,2]],
         [:UPGRADEDCRAFTINGBENCH,[:WOODENPLANKS,5],[:SILVER2,4]],
         [:OLDROD,[:WOODENSTICKS,1],[:WOODENSTICKS,1]],
         [:BOWL,[:WOODENPLANKS,1],[:WOODENPLANKS,1],[:WOODENPLANKS,1]],
         [:WATERBOTTLE,[:IRON2,3],[:LEATHER,1]],
         [:GOODROD,[:OLDROD,1],[:IRON2,2]],
         [:MACHETE,[:IRON2,2],[:WOODENSTICKS,1]],
         [:SHOVEL,[:WOODENSTICKS,1],[:WOODENSTICKS,1],[:IRON2,1]],
         [:IRONHAMMER,[:IRON2,2],[:WOODENSTICKS,3],[:IRON2,2]],
         [:IRONPICKAXE,[:WOODENSTICKS,3],[:WOODENPLANKS,1],[:IRON2,5]],
		  [:MAKESHIFTRUNNINGSHOES,[:NORMALSHOES,1],[:SWIFTFEATHER,2]],
         [:CROPSTICKS,[:WOODENSTICKS,4]],
         [:GROWTHMULCH,[:BALMMUSHROOM,3],[:MOOMOOMILK,1]],
         [:DAMPMULCH,[:REDAPRICORN,2],[:FRESHWATER,3]],
         [:STABLEMULCH,[:MIRACLESEED,2],[:FRESHWATER,1]],
         [:GOOEYMULCH,[:MOOMOOMILK,1],[:BLUEAPRICORN,1]],
         [:PRODUCEMULCH,[:LEFTOVERS,1],[:MOOMOOMILK,2]],
         [:POTENTIALMULCH,[:BALMMUSHROOM,1],[:FRESHWATER,2]],
         [:DARTCASING,[:IRON2,1],[:SILVER2,2]],
         [[:POISONDART,1],[:DARTCASING,1],[:POISONBARB,1]],
         [[:SLEEPDART,1],[:DARTCASING,1],[:MOONSTONE,1]],
         [[:PARALYZDART,1],[:DARTCASING,1],[:THUNDERSTONE,1]],
         [[:ICEDART,1],[:DARTCASING,1],[:ICESTONE,1]],
         [[:FIREDART,1],[:DARTCASING,1],[:FIRESTONE,1]]
	]
     crafting += ncrafting





     
	  return crafting
  end
  def self.machinecrafting
    if $player.is_it_this_class?(:ENGINEER,false)
      ncrafting = [
        [:SPRINKLER,[:STONE,5],[:MACHINEBOX,1],false],
        [:ELECTRICGRINDER,[:CLAY2,6],[:CHARCOAL,3],[:GRINDER,1],false],
        [:ELECTRICFURNACE,[:COPPER2,8],[:IRON2,30],[:FURNACE,1],[:STONE,10],false],
        [:ELECTRICPRESS,[:COPPER2,2],[:IRON2,20],[:STONE,5],false],
        [:APRICORNMACHINE,[:COPPER2,8],[:SILVER2,2],[:APRICORNCRAFTING,2],[:STONE,20],false],
        [:SEWINGMACHINE,[:COPPER2,4],[:IRON2,5],[:CRAFTINGBENCH,2],[:STONE,5],false],
        [:CUTTER,[:COPPER2,4],[:IRON2,7],[:WOODENLOG,5],[:STONE,5],false],
        [:COALGENERATOR,[:COPPER2,8],[:IRON2,30],[:FURNACE,4],[:STONE,10],false],
        [:SOLARGENERATOR,[:COPPER2,8],[:IRON2,30],[:GLASS,20],[:STONE,10],false],
        [:WINDGENERATOR,[:COPPER2,8],[:IRON2,60],false],
        [:HYDROGENERATOR,[:COPPER2,8],[:IRON2,30],[:CAULDRON,4],[:STONE,10],false],
        [:POKEGENERATOR,[:COPPER2,8],[:IRON2,30],[:PKMNCRATE,2],[:STONE,10],false]
        ]
	else
      ncrafting = [
        [:SPRINKLER,[:STONE,5],[:MACHINEBOX,1],false],
        [:ELECTRICGRINDER,[:CLAY2,6],[:CHARCOAL,3],[:GRINDER,1],[:MACHINEBOX,1],false],
        [:ELECTRICFURNACE,[:COPPER2,8],[:IRON2,30],[:FURNACE,1],[:STONE,10],[:MACHINEBOX,1],false],
        [:ELECTRICPRESS,[:COPPER2,2],[:IRON2,20],[:STONE,5],[:MACHINEBOX,1],false],
        [:APRICORNMACHINE,[:COPPER2,8],[:SILVER2,2],[:APRICORNCRAFTING,2],[:STONE,20],[:MACHINEBOX,1],false],
        [:SEWINGMACHINE,[:COPPER2,4],[:IRON2,5],[:CRAFTINGBENCH,2],[:STONE,5],[:MACHINEBOX,1],false],
        [:CUTTER,[:COPPER2,4],[:IRON2,7],[:WOODENLOG,5],[:STONE,5],[:MACHINEBOX,1],false],
        [:COALGENERATOR,[:COPPER2,8],[:IRON2,30],[:FURNACE,4],[:STONE,10],[:MACHINEBOX,1],false],
        [:SOLARGENERATOR,[:COPPER2,8],[:IRON2,30],[:GLASS,20],[:STONE,10],[:MACHINEBOX,1],false],
        [:WINDGENERATOR,[:COPPER2,8],[:IRON2,60],[:MACHINEBOX,1],false],
        [:HYDROGENERATOR,[:COPPER2,8],[:IRON2,30],[:CAULDRON,4],[:STONE,10],[:MACHINEBOX,1],false]
        ]
    end
  
	  return ncrafting
  end

  def self.ucrafting
     crafting = []
     crafting += self.crafting
  
  
      ncrafting = [ 
        [:POLE,[:WOODENSTICKS,25],[:SILVER2,2]],
        [:RAFT,[:WOODENPLANKS,50],[:IRON2,3],[:IRONHAMMER,1],[:WOOL,5],[:SILVER2,2]],
        [:CLOCK,[:GOLD2,4],[:SILVER2,1]],
        [:CALENDAR,[:LEATHER,4],[:WOODENPLANKS,1]],
        [:EXPALL,[:EXPSHARE,5],[:IRON2,10]],
        [:GROWTHMULCH2,[:GROWTHMULCH,1],[:FERTILIZERMIX,1]],
        [:DAMPMULCH2,[:DAMPMULCH,1],[:FERTILIZERMIX,1]],
        [:STABLEMULCH2,[:STABLEMULCH,1],[:FERTILIZERMIX,1]],
        [:GOOEYMULCH2,[:GOOEYMULCH,1],[:FERTILIZERMIX,1]],
        [:PRODUCEMULCH2,[:PRODUCEMULCH,1],[:FERTILIZERMIX,1]],
        [:POTENTIALMULCH2,[:POTENTIALMULCH,1],[:FERTILIZERMIX,1]],
        [:FERTILIZERMIX,[:BONEDUST,1],[:FRESHWATER,1]],
        [[:REPEL,2],[:IRON2,2],[:LEAFSTONE,1]],
        [:SUPERREPEL,[:REPEL,1],[:MOONSTONE,1]],
        [:MAXREPEL,[:SUPERREPEL,1],[:THUNDERSTONE,1]],
        [:SNATCHER,[:IRON2,20],[:SILVER2,5],[:COPPER2,2]],
        [:MEGARING,[:MEGASTONE,1],[:SILVER2,3],false],
        [:JACKETEDCABLE,[:COPPER2,1],[:LEATHER,2],false],
        [:MACHINEBOX,[:THUNDERSTONE,1],[:IRON2,5],[:JACKETEDCABLE,5],false]
	  
	  ]

     crafting += ncrafting
     crafting += self.machinecrafting

	  return crafting
  end

  def self.pokeball
      return [ 
    [:NO,:NO,:NO,:NO], 
[:POKEBALLC,[:REDAPRICORN,4],[:TUMBLEROCK,2]],
[:GREATBALLC,[:POKEBALLC,1],[:BLUEAPRICORN,3],[:TUMBLEROCK,2]],
[:ULTRABALLC,[:BLACKAPRICORN,5],[:YELLOWAPRICORN,5],[:POKEBALLC,1],[:TUMBLEROCK,2]]
	  ]
  end

  def self.apricornmachine
     apricornmachine = []
     apricornmachine += self.pokeball
     newrecipes =  [
[:SUPERBALLC,[:WHITEAPRICORN,4],[:GREENAPRICORN,1],[:YELLOWAPRICORN,2],[:TUMBLEROCK,4]],
[:PREMIERBALLC,[:WHITEAPRICORN,1],[:POKEBALLC,1]],
[:MASTERBALLC,[:PURPLEAPRICORN,2],[:ENIGMABERRY,2],[:COMETSHARD,1],[:TUMBLEROCK,4]],
[:LUREBALLC,[:REDAPRICORN,2],[:BLUEAPRICORN,2],[:TUMBLEROCK,4]],
[:LEVELBALLC,[:BLACKAPRICORN,2],[:REDAPRICORN,2],[:TUMBLEROCK,4]],
[:HEAVYBALLC,[:BLUEAPRICORN,2],[:TUMBLEROCK,4]],
[:LOVEBALLC,[:WHITEAPRICORN,2],[:TUMBLEROCK,4]],
[:SPORTBALLC,[:REDAPRICORN,2],[:WHITEAPRICORN,1],[:TUMBLEROCK,4]],
[:SAFARIBALLC,[:GREENAPRICORN,2],[:YELLOWAPRICORN,1],[:TUMBLEROCK,4]],
[:FRIENDBALLC,[:GREENAPRICORN,2],[:WHITEAPRICORN,1],[:TUMBLEROCK,4]],
[:LUREBALLC,[:REDAPRICORN,2],[:BLUEAPRICORN,2],[:TUMBLEROCK,4]],
[:LEVELBALLC,[:BLACKAPRICORN,2],[:REDAPRICORN,2],[:TUMBLEROCK,4]],
[:HEAVYBALLC,[:BLUEAPRICORN,2],[:TUMBLEROCK,4]],
[:LOVEBALLC,[:WHITEAPRICORN,2],[:TUMBLEROCK,4]],
[:SPORTBALLC,[:REDAPRICORN,2],[:WHITEAPRICORN,1],[:TUMBLEROCK,4]],
[:SAFARIBALLC,[:GREENAPRICORN,2],[:YELLOWAPRICORN,1],[:TUMBLEROCK,4]],
[:FRIENDBALLC,[:GREENAPRICORN,2],[:WHITEAPRICORN,1],[:TUMBLEROCK,4]],
[:NESTBALLC,[:GREENAPRICORN,2],[:YELLOWAPRICORN,1],[:TANGABERRY,1],[:TUMBLEROCK,4]],
[:REPEATBALLC,[:REDAPRICORN,2],[:BLACKAPRICORN,2],[:JABOCABERRY,3],[:TUMBLEROCK,4]],
[:LUXURYBALLC,[:REDAPRICORN,2],[:WHITEAPRICORN,2],[:TUMBLEROCK,4]],
[:DIVEBALLC,[:PINKAPRICORN,1],[:BLUEAPRICORN,2],[:PASSHOBERRY,2],[:TUMBLEROCK,4]],
[:TIMERBALLC,[:WHITEAPRICORN,2],[:BLACKAPRICORN,1],[:BLUEAPRICORN,2],[:TUMBLEROCK,4]],
[:DUSKBALLC,[:BLACKAPRICORN,2],[:BLUEAPRICORN,1],[:YELLOWAPRICORN,2],[:TUMBLEROCK,4]],
[:HEALBALLC,[:PINKAPRICORN,1],[:WHITEAPRICORN,2],[:ORANBERRY,5],[:TUMBLEROCK,4]],
[:QUICKBALLC,[:YELLOWAPRICORN,1],[:BLUEAPRICORN,2],[:CUSTAPBERRY,2],[:TUMBLEROCK,4]],
[:CHERISHBALLC,[:REDAPRICORN,2],[:POKEBALLC,2],[:TUMBLEROCK,4]],
[:NETBALLC,[:BLACKAPRICORN,1],[:WHITEAPRICORN,2],[:TUMBLEROCK,4]],
[:SHOCKBALLC,[:YELLOWAPRICORN,3],[:WHITEAPRICORN,2],[:TUMBLEROCK,4]],
[:MOONBALLC,[:YELLOWAPRICORN,2],[:BLACKAPRICORN,1],[:TUMBLEROCK,4]],
[:STATUSBALLC,[:WHITEAPRICORN,2],[:REDAPRICORN,5],[:PECHABERRY,4],[:TUMBLEROCK,4]],
[:BURNBALLC,[:REDAPRICORN,3],[:GREENAPRICORN,1],[:RAWSTBERRY,4],[:TUMBLEROCK,4]],
[:DREAMBALLC,[:BLACKAPRICORN,1],[:PINKAPRICORN,3],[:CHESTOBERRY,4],[:TUMBLEROCK,4]],
[:FREEZEBALLC,[:BLUEAPRICORN,3],[:WHITEAPRICORN,3],[:ASPEARBERRY,4],[:TUMBLEROCK,4]],
[:STUNBALLC,[:YELLOWAPRICORN,2],[:PINKAPRICORN,3],[:CHERIBERRY,4],[:TUMBLEROCK,4]],
[:TOXICBALLC,[:BLACKAPRICORN,3],[:GREENAPRICORN,2],[:PECHABERRY,4],[:TUMBLEROCK,4]],
[:BARBEDBALLC,[:GREENAPRICORN,2],[:BLACKAPRICORN,2],[:IRON2,1],[:TUMBLEROCK,4]],
[:YOLOBALLC,[:REDAPRICORN,4],[:PINKAPRICORN,1],[:SHUCABERRY,1],[:TUMBLEROCK,4]],
[:HIDDENBALLC,[:PINKAPRICORN,8],[:GREENAPRICORN,8],[:CUSTAPBERRY,5],[:TUMBLEROCK,4]],
[:IMMUNEBALLC,[:BLACKAPRICORN,1],[:WHITEAPRICORN,3],[:CHILANBERRY,2],[:TUMBLEROCK,4]],
[:DEBUFFBALLC,[:REDAPRICORN,2],[:BLACKAPRICORN,3],[:YELLOWAPRICORN,3],[:TUMBLEROCK,4]],
[:DAWNBALLC,[:WHITEAPRICORN,1],[:YELLOWAPRICORN,1],[:TUMBLEROCK,4]] ]

   apricornmachine += newrecipes
	  return apricornmachine
	  

  end

  def self.furnace
      coal = GameData::Item.try_get($coal).id

 [
    [:NO,:NO,:NO,:NO], 
[:CHARCOAL,[:WOODENPLANKS,1],[coal,$value.to_i]],
[:IRON2,[:IRONORE,1],[coal,$value.to_i]],
[[:IRON2,2],[:IRONDUST,1],[coal,$value.to_i]],
[:GOLD2,[:GOLDORE,1],[coal,$value.to_i]],
[[:GOLD2,2],[:GOLDDUST,1],[coal,$value.to_i]],
[:COPPER2,[:COPPERORE,1],[coal,$value.to_i]],
[[:COPPER2,2],[:COPPERDUST,1],[coal,$value.to_i]],
[:SILVER2,[:SILVERORE,1],[coal,$value.to_i]],
[[:SILVER2,2],[:SILVERDUST,1],[coal,$value.to_i]],
[:CLAY2,[:LIGHTCLAY,1],[coal,$value.to_i]],
[[:CLAY2,2],[:CLAYDUST,1],[coal,$value.to_i]],
[:COOKEDORAN,[:ORANBERRY,1],[coal,$value.to_i]],
[:BAKEDPOTATO,[:POTATO,1],[coal,$value.to_i]],
[:CSLOWPOKETAIL,[:SLOWPOKETAIL,1],[coal,$value.to_i]],
[:COOKEDMEAT,[:MEAT,1],[coal,$value.to_i]],
[:MEAT,[:POISONOUSMEAT,1],[coal,$value.to_i]],
[:MEAT,[:FROZENMEAT,1],[coal,$value.to_i]],
[:COOKEDMEAT,[:MEAT,1],[coal,$value.to_i]],
[:COOKEDBIRDMEAT,[:BIRDMEAT,1],[coal,$value.to_i]],
[:COOKEDROCKYMEAT,[:ROCKYMEAT,1],[coal,$value.to_i]],
[:COOKEDBUGMEAT,[:BUGMEAT,1],[coal,$value.to_i]],
[:COOKEDSTEELYMEAT,[:STEELYMEAT,1],[coal,$value.to_i]],
[:COOKEDSUSHI,[:SUSHI,1],[coal,$value.to_i]],
[:COOKEDLEAFYMEAT,[:LEAFYMEAT,1],[coal,$value.to_i]],
[:COOKEDDRAGONMEAT,[:DRAGONMEAT,1],[coal,$value.to_i]],
[:COOKEDEDIABLESCRYSTAL,[:EDIABLESCRYSTAL,1],[coal,$value.to_i]],
[:FRESHWATER,[:WATER,1],[coal,(($value.to_i)/3).ceil]],
[:GLASS,[:SOFTSAND,4],[coal,(($value.to_i)/3).ceil]],
[:BLACKFLUTE,[:GLASS,4],[coal,$value.to_i]]
]
  end



  def self.grinder
  return [
    [:NO,:NO,:NO,:NO], 
[:IRONDUST,[:IRONORE,1]],
[:GOLDDUST,[:GOLDORE,1]],
[:COPPERDUST,[:COPPERORE,1]],
[:SILVERDUST,[:SILVERORE,1]],
[[:IRONDUST,2],[:IRONBALL,1]],
[[:IRONDUST,4],[:IRONPLATE,1]],
[:STARDUST,[:STARPIECE,1]],
[:STARDUST,[:STARPIECE,1]],
[[:GOLDDUST,2],[:NUGGET,1]],
[[:GOLDDUST,4],[:BIGNUGGET,1]],
[[:GOLDDUST,4],[:RELICGOLD,1]],
[:CLAYDUST,[:LIGHTCLAY,1]],
[:COPPERDUST,[:RELICCOPPER,1]],
[:SILVERDUST,[:RELICSILVER,1]]
]
  end




  def self.test
      return [ 
    [:ORANBERRY,[:ACORN,2],:ORANBERRY,:WOODENLOG,false]]
  end



end








































































































