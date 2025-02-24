def pbCraftingBench(wari,data)
pbFadeOutIn {
  Crafts.craftWindow(:CRAFTINGBENCH ,3, data) if wari == :CRAFTINGBENCH 
  Crafts.craftWindow(:UPGRADEDCRAFTINGBENCH ,5, data) if wari == :UPGRADEDCRAFTINGBENCH 
  Crafts.craftWindow(:CAULDRON ,3, data) if wari == :CAULDRON 
  Crafts.craftWindow(:APRICORNCRAFTING ,4, data) if wari == :APRICORNCRAFTING || wari == :APRICORNMACHINE
  Crafts.craftWindow(:MEDICINEPOT ,5, data) if wari == :MEDICINEPOT
  Crafts.craftWindow(:POCKETCRAFTING ,2, data) if wari == :POCKETCRAFTING
  Crafts.craftWindow(:GRINDER ,1, data) if wari == :GRINDER || wari == :ELECTRICGRINDER
  Crafts.craftWindow(:FURNACE ,2, data) if wari == :FURNACE || wari == :ELECTRICFURNACE
  Crafts.craftWindow(:ELECTRICPRESS ,1, data) if wari == :ELECTRICPRESS
  Crafts.craftWindow(:SEWINGMACHINE ,3, data) if wari == :SEWINGMACHINE
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
    [:RARECANDY,[:SUGAR,6],[:FRESHWATER,1],[:ARGOSTBERRY,2]],
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
    [:MEATKABOB,:WOODENSTICKS,:COOKEDMEAT],
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
[:WEAKPOTION,[:ORANBERRY,1],[:GLASSBOTTLE,1]],
[:SQUIRTBOTTLE,[:IRON2,9]],
[:TORCH,[:WOODENPLANKS,2],[:CHARCOAL,2]],
[:TORCH,[:WOODENPLANKS,2],[:COAL,2]],
[:CHARREDGLASS,[:GLASS,1],[:COAL,1]],
[:CHARREDGLASS,[:GLASS,1],[:CHARCOAL,1]]
 ]
  end

  def self.medicine
      return [ 
    [:NO,:NO,:NO,:NO], 
[:POTION,[:ORANBERRY,2],[:WATERBOTTLE,1]],
[:POTION,[:WEAKPOTION,2],[:WATERBOTTLE,1]],
[:SUPERPOTION,[:POTION,1],[:SITRUSBERRY,2]],
[:HYPERPOTION,[:SUPERPOTION,1],[:SITRUSBERRY,3],[:ARGOSTBERRY,3]],
[:FULLRESTORE,[:HYPERPOTION,1],[:ENIGMABERRY,1]],
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
         [:GRINDER,[:STONE,2],[:COPPER2,3],[:GOLD2,2]],
         [:MEDICINEPOT,[:CLAY2,2],[:CLAY2,1],[:CLAY2,2]],
         [:BEDROLL,[:WOODENPLANKS,3],[:WOOL,3]],
         [:WOODENPAIL,[:WOODENLOG,1],[:WOODENPLANKS,1],[:WOODENPLANKS,1]],
         [:ITEMCRATE,[:WOODENLOG,1],[:WOODENPLANKS,5],[:WOODENLOG,1]],
         [:PKMNCRATE,[:WOODENPLANKS,5],[:IRON2,3],[:POKEBALLC,5]],
         [:PORTABLECAMP,[:WOOL,5],[:WOODENPLANKS,5],[:COPPER2,2]],
         [:UPGRADEDCRAFTINGBENCH,[:WOODENPLANKS,5],[:SILVER2,4]],
         [:OLDROD,[:WOODENSTICKS,1],[:WOODENSTICKS,1]],
         [:GOODROD,[:OLDROD,1],[:GOLD2,2]],
         [:BOWL,[:WOODENPLANKS,1],[:WOODENPLANKS,1],[:WOODENPLANKS,1]],
         [:WATERBOTTLE,[:IRON2,3],[:LEATHER,1]],
         [:MACHETE,[:IRON2,2],[:WOODENSTICKS,1]],
         [:SHOVEL,[:WOODENSTICKS,1],[:WOODENSTICKS,1],[:IRON2,1]],
         [:HOE,[:WOODENSTICKS,2],[:GOLD2,1],[:IRON2,1]],
         [:CALENDAR,[:LEATHER,4],[:WOODENPLANKS,1]],
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
        [:EXPSHARE,[:JACKETEDCABLE,4],[:GOLD2,10],[:IRON2,10]],
        [:EXPALL,[:EXPSHARE,5],[:SILVER2,10]],
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
        [:GROWTHMULCH2,[:GROWTHMULCH,1],[:FERTILIZERMIX,1]],
        [:DAMPMULCH2,[:DAMPMULCH,1],[:FERTILIZERMIX,1]],
        [:STABLEMULCH2,[:STABLEMULCH,1],[:FERTILIZERMIX,1]],
        [:GOOEYMULCH2,[:GOOEYMULCH,1],[:FERTILIZERMIX,1]],
        [:PRODUCEMULCH2,[:PRODUCEMULCH,1],[:FERTILIZERMIX,1]],
        [:POTENTIALMULCH2,[:POTENTIALMULCH,1],[:FERTILIZERMIX,1]],
        [:FERTILIZERMIX,[:BONEDUST,1],[:FRESHWATER,1]],
        [[:REPEL,2],[:WATERBOTTLE,2],[:LEAFSTONE,1]],
        [:SUPERREPEL,[:REPEL,1],[:MOONSTONE,1]],
        [:MAXREPEL,[:SUPERREPEL,1],[:THUNDERSTONE,1]],
        [:SNATCHER,[:IRON2,20],[:SILVER2,5],[:COPPER2,2]],
        [:MEGARING,[:MEGASTONE,1],[:SILVER2,3],false],
        [:JACKETEDCABLE,[:COPPER2,1],[:LEATHER,2]],
        [:MACHINEBOX,[:THUNDERSTONE,1],[:IRON2,5],[:JACKETEDCABLE,5]]
	  
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
[:MASTERBALLC,[:PURPLEAPRICORN,2],[:ENIGMABERRY,2],[:COMETSHARD,1],[:TUMBLEROCK,4]]]

   apricornmachine += newrecipes
	  return apricornmachine
	  

  end

  def self.furnace

 [
    [:NO,:NO,:NO,:NO], 
[:CHARCOAL,[:WOODENLOG,1]],
[:IRON2,[:IRONORE,1]],
[[:IRON2,2],[:IRONDUST,1]],
[:GOLD2,[:GOLDORE,1]],
[[:GOLD2,2],[:GOLDDUST,1]],
[:COPPER2,[:COPPERORE,1]],
[[:COPPER2,2],[:COPPERDUST,1]],
[:SILVER2,[:SILVERORE,1]],
[[:SILVER2,2],[:SILVERDUST,1]],
[:CLAY2,[:LIGHTCLAY,1]],
[[:CLAY2,2],[:CLAYDUST,1]],
[:COOKEDORAN,[:ORANBERRY,1]],
[:BAKEDPOTATO,[:POTATO,1]],
[:CSLOWPOKETAIL,[:SLOWPOKETAIL,1]],
[:COOKEDMEAT,[:MEAT,1]],
[:MEAT,[:POISONOUSMEAT,1]],
[:MEAT,[:FROZENMEAT,1]],
[:COOKEDMEAT,[:MEAT,1]],
[:COOKEDBIRDMEAT,[:BIRDMEAT,1]],
[:COOKEDROCKYMEAT,[:ROCKYMEAT,1]],
[:COOKEDBUGMEAT,[:BUGMEAT,1]],
[:COOKEDSTEELYMEAT,[:STEELYMEAT,1]],
[:COOKEDSUSHI,[:SUSHI,1]],
[:COOKEDLEAFYMEAT,[:LEAFYMEAT,1]],
[:COOKEDDRAGONMEAT,[:DRAGONMEAT,1]],
[:COOKEDEDIABLESCRYSTAL,[:EDIABLESCRYSTAL,1]],
[:FRESHWATER,[:WATER,1]],
[:GLASS,[:SOFTSAND,2]],
[:BLACKFLUTE,[:CHARREDGLASS,4]],
[:WHITEFLUTE,[:GLASS,4]]
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



class RecipeBook
  attr_accessor :recipes

def initialize
   @recipes = []
end

def add(recipe)
  if !has?(recipe)
    @recipes << recipe
  end
end

def has?(recipe)
 if @recipes.include?(recipe)
  return true
 else
  return false
 end
end

end

SaveData.register(:recipe_book) do
  ensure_class :RecipeBook 
  save_value { $recipe_book  }
  load_value { |value| $recipe_book = value }
  new_game_value {
    RecipeBook.new
  }
end


module GameData
  class Recipe
    attr_reader :id

    DATA = {}
    DATA_FILENAME = "recipes.dat"
    PBS_BASE_FILENAME = "recipes"

    SCHEMA = {
      "Name"          => [:name,        "s"],
      "Result"         => [:result, "*e", :Item],
      "Yield"          => [:yield, "v"],
      "Recipe"         => [:recipe, "*sv"],
      "Station"       => [:station, "*e", :Item],
      "CookingTime"    => [:cookingtime, "u"],
      "Locked"       => [:locked, "b"],
      "Flags"         => [:flags,       "*s"]
    }

    extend ClassMethodsSymbols
    include InstanceMethods
  

    def initialize(hash)
      @id                  = hash[:id]
      @name                = hash[:name]        || "Recipe"
      @result              = hash[:result] || :NO
      @yield              = hash[:yield] || 1
      @recipe              = hash[:recipe] || []
	  puts "#{@yield} - #{@recipe}"
      @station             = hash[:station] || :CRAFTINGBENCH
      @cookingtime          = hash[:cookingtime] || 0
      @locked             = hash[:locked] || false
      @flags               = hash[:flags]       || []
    end
	

    def yield
      return @yield
    end

    def name
      return @name
    end

    def result
      return @result
    end

    def recipe
      return @recipe
    end

    def cookingtime
      return @cookingtime
    end

    def station
      return @station
    end

    def locked
      return @locked
    end

    def has_flag?(flag)
      return @flags.any? { |f| f.downcase == flag.downcase }
    end
end
end

class Recipe
  attr_accessor :disease
  attr_accessor :length
  attr_accessor :severity


  def initialize(disease,length,severity)
   @disease = disease
   @length = length
   @severity = severity
  end

   def id
     return @disease.id
   end

   def name
     return @disease.name
   end

    def cause
      return @disease.cause
    end

    def symptoms
      return @disease.symptoms
    end

    def cure
      return @disease.cure
    end

    def item
      return @disease.cureitem.to_sym
    end

    def has_flag?(flag)
      return @disease.flags.any? { |f| f.downcase == flag.downcase }
    end

end





































































































