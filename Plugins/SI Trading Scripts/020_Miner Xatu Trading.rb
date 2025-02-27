#===============================================================================
#                              *Item Crafter
# *Item Crafter scene created by TheKrazyGamer/kcgcrazy/TheKraazyGamer
# *Please Give Credit if used
#
# *to add an item of your own just add it to the type array.
#   Add The ITEMID,AMOUNT to be crafted,required MATERIALS and COSTS
#   and also BOOLEAN values for it being unlocked or not.
#   If a Second Material is not being used, enter nil.
#
#   Here is an example!
#
# type=[
#  [:ITEMID,CRAFT_AMOUNT,[:MATERIAL1,COST],[:MATERIAL2,COST],IS_UNLOCKED?]
#  ]
############################################################
# type=[
# [:POKEBALL,1,[:WHTAPRICORN,5],nil,false],
# [:GREATBALL,1,[:WHTAPRICORN,15],[:BLKAPRICORN,5],false],
# [:ULTRABALL,1,[:WHTAPRICORN,15],[:GRNAPRICORN,15],false],
# [:DIVEBALL,1,[:WHTAPRICORN,3],[:PNKAPRICORN,3],false]
# ]
#
############################################################
#
#  *To call put ItemCrafterScene.new in an event 
#   or create an item like this
#
# #Item Crafter
# ItemHandlers::UseFromBag.add(:ITEMCRAFTER,proc{|item|
#     Kernel.pbMessage(_INTL("{1} used the {2}.",$Trainer.name,PBItems.getName(item)))
#       ItemCrafterScene.new
#     next 1
#  })
#
# and add this to the Items.txt
# XXX,ITEMCRAFTER,Item Crafter,8,0,"Lets you craft items.",2,0,6,
# XXX - This is the number you can use in items.txt
# Create an item in icons folder with that number.
#
# To unlock an item that was set as false, just add the following after an event:
# $game_variables[CRAFTVAR][x]=true # x being the item index (count from 0 for the first etc)
#
# And Finally...
#
# Add setupCraftUnlocks to an event in the Intro Event to initialize
# The $game_variables.
#
#
#===============================================================================

CRAFTVAR = 100 # number used for available $game_variable.
CRAFTVAR2 = 99 # number used for available $game_variable.

$exit = 0
$isUnlocked = []
###############################################################################
# This is your Items, Material etc.
###############################################################################

RECIPE1=[
[:YELLOWAPRICORN,1,[:STARPIECE,1],nil, true],
[:LEPPABERRY,1,[:RAREBONE,1],nil, true],
[:STARFBERRY,1,[:HEARTSCALE,1],nil, true],
[:OCCABERRY,1,[:HEATROCK,1],nil, true],
[:PASSHOBERRY,1,[:DAMPROCK,1],nil, true],
[:SHUCABERRY,1,[:SMOOTHROCK,1],nil, true],
[:YACHEBERRY,1,[:ICYROCK,1],nil, true],
[:JOYSCENT,1,[:REDSHARD,1],nil, true],
[:EXCITESCENT,1,[:GREENSHARD,1],nil, true],
[:VIVIDSCENT,1,[:YELLOWSHARD,1],nil, true],
[:BLUEFLUTE,1,[:BLUESHARD,1],nil, true],
[:WHITEAPRICORN,1,[:LIGHTCLAY,1],nil, true],
[:CHARCOAL,1,[:FIRESTONE,1],nil, true],
[:MYSTICWATER,1,[:WATERSTONE,1],nil, true],
[:BRIGHTPOWDER,1,[:THUNDERSTONE,1],nil, true],
[:MIRACLESEED,1,[:LEAFSTONE,1],nil, true],
[:ROSELIBERRY,1,[:MOONSTONE,1],nil, true],
[:SILKSCARF,1,[:SUNSTONE,1],nil, true],
[:LUCKYEGG,1,[:OVALSTONE,1],nil, true],
[:ABILITYCAPSULE,1,[:EVERSTONE,1],nil, true],
[:EXPSHARE,1,[:SILVERORE,1],nil, true],
[:ABILITYPATCH,1,[:EVIOLITE,1],nil, true],
[:IRON2,2,[:IRONBALL,1],nil, true],
[:STONE,2,[:HARDSTONE,1],nil, true],
[:SPELLTAG,1,[:ODDKEYSTONE,1],nil, true],
[:SWIFTWING,1,[:INSECTPLATE,1],nil, true],
[:COLBURBERRY,1,[:DREADPLATE,1],nil, true],
[:DRAGONFANG,1,[:DRACOPLATE,1],nil, true],
[:ELECTRICGEM,1,[:ZAPPLATE,1],nil, true],
[:BLACKBELT,1,[:FISTPLATE,1],nil, true],
[:ELECTRICGEM,1,[:FLAMEPLATE,1],nil, true],
[:ROSEINCENSE,1,[:MEADOWPLATE,1],nil, true],
[:SOFTSAND,1,[:EARTHPLATE,1],nil, true],
[:WEAKNESSPOLICY,1,[:ICICLEPLATE,1],nil, true],
[:BLACKSLUDGE,1,[:TOXICPLATE,1],nil, true],
[:MAGOSTBERRY,1,[:MINDPLATE,1],nil, true],
[:CORNNBERRY,1,[:STONEPLATE,1],nil, true],
[:FLYINGGEM,1,[:SKYPLATE,1],nil, true],
[:WIDELENS,1,[:SPOOKYPLATE,1],nil, true],
[:STEELGEM,1,[:IRONPLATE,1],nil, true],
[:SAFETYGOGGLES,1,[:SPLASHPLATE,1],nil, true],
[:FLYINGGEM,1,[:NOMELBERRY,1],nil, true],
[:ASSAULTVEST,1,[:SMOKEBALL,1],nil, true]
]
RECIPE2=[
[:FULLINCENSE,1,[:STARPIECE,2],nil, true],
[:LAXINCENSE,1,[:STARPIECE,2],nil, true],
[:LUCKINCENSE,1,[:STARPIECE,2],nil, true],
[:PUREINCENSE,1,[:STARPIECE,2],nil, true],
[:SEAINCENSE,1,[:STARPIECE,2],nil, true],
[:WAVEINCENSE,1,[:STARPIECE,2],nil, true],
[:ROSEINCENSE,1,[:STARPIECE,2],nil, true],
[:ODDINCENSE,1,[:STARPIECE,2],nil, true],
[:ROCKINCENSE,1,[:STARPIECE,2],nil, true],
[:EVERSTONE,1,[:STARPIECE,2],nil, true],
[:DESTINYKNOT,1,[:STARPIECE,20],nil, true],
[:ABILITYCAPSULE,1,[:STARPIECE,4],nil, true]
]
RECIPE3=[
[:TM93,1,[:STARPIECE,2],nil, true],
[:TM86,1,[:STARPIECE,2],nil, true],
[:TM87,1,[:STARPIECE,2],nil, true],
[:TM35,1,[:STARPIECE,2],nil, true],
[:TM30,1,[:STARPIECE,2],nil, true],
[:TM22,1,[:STARPIECE,2],nil, true],
[:TM24,1,[:STARPIECE,2],nil, true],
[:TM02,1,[:STARPIECE,2],nil, true],
[:TM10,1,[:STARPIECE,2],nil, true],
[:TM64,1,[:STARPIECE,2],nil, true],
[:TM62,1,[:STARPIECE,2],nil, true],
[:TM81,1,[:STARPIECE,2],nil, true],
[:TM92,1,[:STARPIECE,2],nil, true],
[:TM38,1,[:STARPIECE,2],nil, true],
[:TM29,1,[:STARPIECE,2],nil, true],
[:TM23,1,[:STARPIECE,2],nil, true],
[:TM46,1,[:STARPIECE,2],nil, true],
[:TM48,1,[:STARPIECE,2],nil, true],
[:TM18,1,[:STARPIECE,2],nil, true],
[:TM17,1,[:STARPIECE,2],nil, true],
[:TM27,1,[:STARPIECE,2],nil, true],
[:TM04,1,[:STARPIECE,2],nil, true],
[:TM43,1,[:STARPIECE,2],nil, true],
[:TM36,1,[:STARPIECE,2],nil, true],
[:TM37,1,[:STARPIECE,2],nil, true],
[:TM15,1,[:STARPIECE,2],nil, true],
[:TM37,1,[:STARPIECE,2],nil, true],
[:TM48,1,[:STARPIECE,2],nil, true],
[:TM59,1,[:STARPIECE,2],nil, true],
[:TM71,1,[:STARPIECE,2],nil, true],
[:TM75,1,[:STARPIECE,2],nil, true],
[:TM08,1,[:STARPIECE,2],nil, true],
[:TM76,1,[:STARPIECE,2],nil, true],
[:TM70,1,[:STARPIECE,2],nil, true],
[:TM87,1,[:STARPIECE,2],nil, true],
[:TM78,1,[:STARPIECE,2],nil, true],
[:TM28,1,[:STARPIECE,2],nil, true],
[:TM01,1,[:STARPIECE,2],nil, true],
[:TM96,1,[:STARPIECE,2],nil, true],
[:TM98,1,[:STARPIECE,2],nil, true],
[:TM94,1,[:STARPIECE,2],nil, true],
[:TM12,1,[:STARPIECE,2],nil, true],
[:TM99,1,[:STARPIECE,2],nil, true]
]


RECIPE4=[
[:POTION,1,[:STARPIECE,1],nil, true],
[:SUPERPOTION,1,[:STARPIECE,5],nil, true],
[:BLACKFLUTE,1,[:STARPIECE,2],nil, true],
[:EVIOLITE,1,[:STARPIECE,3],nil, true],
[:SACREDASH,1,[:STARPIECE,15],nil, true],
[:LEFTOVERS,1,[:STARPIECE,6],nil, true],
[:FRESHWATER,1,[:STARPIECE,2],nil, true],
[:POKEDOLL,1,[:STARPIECE,1],nil, true],
[:SNOWMAIL,1,[:STARPIECE,1],nil, true]
]

RECIPE5=[
[:YELLOWAPRICORN,1,[:STARPIECE,1],nil, true],
[:LEPPABERRY,1,[:RAREBONE,1],nil, true],
[:STARFBERRY,1,[:HEARTSCALE,1],nil, true],
[:OCCABERRY,1,[:HEATROCK,1],nil, true],
[:PASSHOBERRY,1,[:DAMPROCK,1],nil, true],
[:SHUCABERRY,1,[:SMOOTHROCK,1],nil, true],
[:YACHEBERRY,1,[:ICYROCK,1],nil, true],
[:JOYSCENT,1,[:REDSHARD,1],nil, true],
[:EXCITESCENT,1,[:GREENSHARD,1],nil, true],
[:VIVIDSCENT,1,[:YELLOWSHARD,1],nil, true],
[:BLUEFLUTE,1,[:BLUESHARD,1],nil, true],
[:WHITEAPRICORN,1,[:LIGHTCLAY,1],nil, true],
[:CHARCOAL,1,[:FIRESTONE,1],nil, true],
[:MYSTICWATER,1,[:WATERSTONE,1],nil, true],
[:BRIGHTPOWDER,1,[:THUNDERSTONE,1],nil, true],
[:MIRACLESEED,1,[:LEAFSTONE,1],nil, true],
[:ROSELIBERRY,1,[:MOONSTONE,1],nil, true],
[:SILKSCARF,1,[:SUNSTONE,1],nil, true],
[:LUCKYEGG,1,[:OVALSTONE,1],nil, true],
[:ABILITYCAPSULE,1,[:EVERSTONE,1],nil, true],
[:EXPSHARE,1,[:SILVERORE,1],nil, true],
[:ABILITYPATCH,1,[:EVIOLITE,1],nil, true],
[:IRON2,2,[:IRONBALL,1],nil, true],
[:STONE,2,[:HARDSTONE,1],nil, true],
[:SPELLTAG,1,[:ODDKEYSTONE,1],nil, true],
[:SWIFTWING,1,[:INSECTPLATE,1],nil, true],
[:COLBURBERRY,1,[:DREADPLATE,1],nil, true],
[:DRAGONFANG,1,[:DRACOPLATE,1],nil, true],
[:TM15,1,[:ZAPPLATE,1],nil, true],
[:BLACKBELT,1,[:FISTPLATE,1],nil, true],
[:TM11,1,[:FLAMEPLATE,1],nil, true],
[:ROSEINCENSE,1,[:MEADOWPLATE,1],nil, true],
[:SOFTSAND,1,[:EARTHPLATE,1],nil, true],
[:WEAKNESSPOLICY,1,[:ICICLEPLATE,1],nil, true],
[:BLACKSLUDGE,1,[:TOXICPLATE,1],nil, true],
[:MAGOSTBERRY,1,[:MINDPLATE,1],nil, true],
[:CORNNBERRY,1,[:STONEPLATE,1],nil, true],
[:FLYINGGEM,1,[:SKYPLATE,1],nil, true],
[:WIDELENS,1,[:SPOOKYPLATE,1],nil, true],
[:TM37,1,[:IRONPLATE,1],nil, true],
[:SAFETYGOGGLES,1,[:SPLASHPLATE,1],nil, true],
[:FLYINGGEM,1,[:NOMELBERRY,1],nil, true],
[:ASSAULTVEST,1,[:SMOKEBALL,1],nil, true]
]


###############################################################################

# This goes through the type array and adds the true or false value from it
# to the $game_variables[CRAFTVAR] array

   
  def setupCraftUnlocks
   $game_variables[CRAFTVAR] = $isUnlocked
  end
  
  
  def pbTradingScene(type)
	 for i in 0...type.length
     $isUnlocked[i] = type[i][4]
    end
     setupCraftUnlocks
	 TradingScene.new(type)
  end
#From here onwards you DO NOT change anything.
class TradingScene

  def initialize(type)
    @close = $exit
	@type = type
    @select=3
    @item=0
    @mat1=@type[@item][2]? @type[@item][2][0] : -1 # the amount for first item
    @mat2=@type[@item][3]? @type[@item][3][0] : -1 # the amount for first item
    @cost1=@type[@item][2]? @type[@item][2][1] : 0 # the amount for first item
    @cost2=@type[@item][3]? @type[@item][3][1] : 0 # the amount for first item
    @amount=@type[@item][1] # the amount for the first item made
                  
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites={}

    @sprites["bg"]=IconSprite.new(0,0,@viewport)    
    @sprites["bg"].setBitmap("Graphics/Pictures/ItemCrafter/BG")
    
    @sprites["Item"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item"].setBitmap("Graphics/Pictures/ItemCrafter/Item_BG")
    @sprites["Item"].x=210+10
    @sprites["Item"].y=30
     
    @sprites["Item_Hov"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item_Hov"].setBitmap("Graphics/Pictures/ItemCrafter/ItemHov_BG")
    @sprites["Item_Hov"].x=210+10
    @sprites["Item_Hov"].y=30
    @sprites["Item_Hov"].opacity=0
    
    @sprites["Item_icon"]=IconSprite.new(0,0,@viewport)   
    @sprites["Item_icon"].setBitmap(GameData::Item.icon_filename(GameData::Item.try_get(@type[@item][0])))
    @sprites["Item_icon"].x=220+10
    @sprites["Item_icon"].y=40
    @sprites["Item_icon"].opacity=0
    
    @sprites["unknown"]=IconSprite.new(0,0,@viewport)    
    @sprites["unknown"].setBitmap("Graphics/Pictures/ItemCrafter/unknown")
    @sprites["unknown"].x=220
    @sprites["unknown"].y=30
    
    @sprites["Item_1"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item_1"].setBitmap("Graphics/Pictures/ItemCrafter/ItemR_BG")
    @sprites["Item_1"].x=65
    @sprites["Item_1"].y=100
    
    @sprites["Item_1_icon"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item_1_icon"].setBitmap((@mat1!=-1) ? GameData::Item.icon_filename(GameData::Item.try_get(@mat1)) : "")
    @sprites["Item_1_icon"].x=65+10
    @sprites["Item_1_icon"].y=100+10
    @sprites["Item_1_icon"].opacity=0
    
    @sprites["Item_1_name"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item_1_name"].setBitmap("Graphics/Pictures/ItemCrafter/Item_Name")
    @sprites["Item_1_name"].x=140
    @sprites["Item_1_name"].y=110
    
    @sprites["Item_2"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item_2"].setBitmap("Graphics/Pictures/ItemCrafter/ItemR_BG")
    @sprites["Item_2"].x=65
    @sprites["Item_2"].y=185
    
    @sprites["Item_2_icon"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item_2_icon"].setBitmap((@mat2!=-1) ? GameData::Item.icon_filename(GameData::Item.try_get(@mat2)) : "")
    @sprites["Item_2_icon"].x=65+10
    @sprites["Item_2_icon"].y=185+10
    @sprites["Item_2_icon"].opacity=0
    
    @sprites["Item_2_name"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item_2_name"].setBitmap("Graphics/Pictures/ItemCrafter/Item_Name")
    @sprites["Item_2_name"].x=140
    @sprites["Item_2_name"].y=198
    
    @sprites["Confirm"]=IconSprite.new(0,0,@viewport)    
    @sprites["Confirm"].setBitmap("Graphics/Pictures/ItemCrafter/Selection")
    @sprites["Confirm"].x=115
    @sprites["Confirm"].y=280
    
    @sprites["Confirm_Hov"]=IconSprite.new(0,0,@viewport)    
    @sprites["Confirm_Hov"].setBitmap("Graphics/Pictures/ItemCrafter/Selection_1")
    @sprites["Confirm_Hov"].x=115
    @sprites["Confirm_Hov"].y=280
    @sprites["Confirm_Hov"].opacity=0
    
    @sprites["Cancel"]=IconSprite.new(0,0,@viewport)    
    @sprites["Cancel"].setBitmap("Graphics/Pictures/ItemCrafter/Selection")
    @sprites["Cancel"].x=115
    @sprites["Cancel"].y=330
    
    @sprites["Cancel_Hov"]=IconSprite.new(0,0,@viewport)    
    @sprites["Cancel_Hov"].setBitmap("Graphics/Pictures/ItemCrafter/Selection_1")
    @sprites["Cancel_Hov"].x=115
    @sprites["Cancel_Hov"].y=330

    @sprites["overlay"]=BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    
    self.openTradingscene
  end
  
  def openTradingscene
    self.CheckAbleToCraft
    pbFadeInAndShow(@sprites) {self.text}
    self.input
    self.action
  end
  
  def closeTradingscene
    pbFadeOutAndHide(@sprites)  
  end
    
    def input
      case @select
      when 1
        @sprites["Confirm"].opacity=255
        @sprites["Confirm_Hov"].opacity=0
        @sprites["Cancel"].opacity=0
        @sprites["Cancel_Hov"].opacity=255
        @sprites["Item"].opacity=255
        @sprites["Item_Hov"].opacity=0
      when 2
        @sprites["Confirm"].opacity=0
        @sprites["Confirm_Hov"].opacity=255
        @sprites["Cancel"].opacity=255
        @sprites["Cancel_Hov"].opacity=0
        @sprites["Item"].opacity=255
        @sprites["Item_Hov"].opacity=0
      when 3
        @sprites["Confirm"].opacity=255
        @sprites["Confirm_Hov"].opacity=0
        @sprites["Cancel"].opacity=255
        @sprites["Cancel_Hov"].opacity=0
        @sprites["Item"].opacity=0
        @sprites["Item_Hov"].opacity=255
        @sprites["Item_icon"].setBitmap(GameData::Item.icon_filename(GameData::Item.try_get(@type[@item][0])))
        if $game_variables[CRAFTVAR][@item]
            @sprites["unknown"].opacity=0
            @sprites["Item_icon"].opacity=255
            @sprites["Item_1_icon"].setBitmap(@type[@item][2]? GameData::Item.icon_filename(GameData::Item.try_get(@type[@item][2][0])) : "") # Vendily
            @sprites["Item_2_icon"].setBitmap(@type[@item][3]? GameData::Item.icon_filename(GameData::Item.try_get(@type[@item][3][0])) : "") # Vendily
            @sprites["Item_1_icon"].opacity= @type[@item][2] ? 255 : 0
            @sprites["Item_2_icon"].opacity=@type[@item][3] ? 255 : 0
            @mat1=@type[@item][2]? @type[@item][2][0] : -1
            @mat2=@type[@item][3]? @type[@item][3][0] : -1
            @cost1=@type[@item][2]? @type[@item][2][1] : 0
            @cost2=@type[@item][3]? @type[@item][3][1] : 0
            @amount=@type[@item][1]
          else
            @sprites["unknown"].opacity=255
            @sprites["Item_icon"].opacity=0
            @sprites["Item_1_icon"].opacity=0
            @sprites["Item_2_icon"].opacity=0
          end
          self.text
          
        # When pressing Right
        if Input.trigger?(Input::RIGHT)  && @item < @type.length-1
          @item+=1
        elsif Input.trigger?(Input::RIGHT)  && @item ==@type.length-1 # Make it run though the selection after last item.
          @item = 0
        end
        if Input.trigger?(Input::LEFT) && @item >0
          @item-=1
        elsif Input.trigger?(Input::LEFT) && @item ==0 # Make it run though the selection after first item.
          @item = @type.length-1
        end
      end    
      # When pressing Left.
      if Input.trigger?(Input::UP)  && @select <3
        @select+=1
      end
      if Input.trigger?(Input::DOWN) && @select >1
        @select-=1
      end
      
      if Input.trigger?(Input::C) 
        case @select
        when 2 
          if $game_variables[CRAFTVAR][@item]
            if $PokemonBag.pbQuantity(@mat1)<@cost1 || (@mat2!=-1 && $PokemonBag.pbQuantity(@mat2) <@cost2) #Seth Edited 
              Kernel.pbMessage(_INTL("The Xatu can see you do not have enough items for that."))
            else
              $PokemonBag.pbStoreItem(@type[@item][0],@amount)
              $PokemonBag.pbDeleteItem(@mat1,@cost1)
              if @mat2!=-1
                $PokemonBag.pbDeleteItem(@mat2,@cost2)
              end
              self.text
              Kernel.pbMessage(_INTL("{1} and {2} were traded for each other.", GameData::Item.get(GameData::Item.try_get(@mat1)).name, GameData::Item.get(GameData::Item.try_get(@type[@item][0])).name))
            end
          else
            Kernel.pbMessage(_INTL("The Xatu doesn't feel like you should trade for that yet."))
          end
        when 1
          @close=@select
          self.closeTradingscene
        end       
      end
      
      if Input.trigger?(Input::B)
        @close=@select
        self.closeTradingscene  
      end
      
    end
    
  def action
    while @close==0
      Graphics.update
      Input.update
      self.input
    end
  end
  
  def text
    overlay= @sprites["overlay"].bitmap
    overlay.clear
    baseColor=Color.new(255, 255, 255)
    shadowColor=Color.new(0,0,0)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    textos=[]
    if $game_variables[CRAFTVAR][@item]
      @text1=_INTL("{1}/{2} - {3}", $PokemonBag.pbQuantity(@mat1),@cost1, GameData::Item.get(GameData::Item.try_get(@mat1)).name)
      if @mat2==-1
        @text2=_INTL("")
      else
        @text2=_INTL("{1}/{2} - {3}", $PokemonBag.pbQuantity(@mat2),@cost2 , GameData::Item.get(GameData::Item.try_get(@mat2)).name)
      end
    else
      @text1=_INTL("UNKNOWN")
      @text2=_INTL("UNKNOWN")
    end
    @text3=_INTL("{1} / {2}", @item + 1, @type.length)
    textos.push([@text1,175,115,false,baseColor,shadowColor])
    textos.push([@text2,175,198+5,false,baseColor,shadowColor])
    textos.push([@text3,75,30,false,baseColor,shadowColor])
    textos.push(["Trade",230,280+5,false,baseColor,shadowColor])
    textos.push(["Cancel",230,330+5,false,baseColor,shadowColor])
    pbDrawTextPositions(overlay,textos)
  end
  
  def CheckAbleToCraft
    if $game_variables[CRAFTVAR][0]
      @sprites["Item_icon"].opacity=255
      @sprites["Item_1_icon"].opacity=255
      @sprites["unknown"].opacity=0
    else
      @sprites["Item_icon"].opacity=0
      @sprites["Item_1_icon"].opacity=0
      @sprites["unknown"].opacity=255
    end
  end
  
    
end