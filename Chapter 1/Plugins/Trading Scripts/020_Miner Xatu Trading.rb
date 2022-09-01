#===============================================================================
#                              *Item Crafter
# *Item Crafter scene created by TheKrazyGamer/kcgcrazy/TheKraazyGamer
# *Please Give Credit if used
#
# *to add an item of your own just add it to the RECIPEXS array.
#   Add The ITEMID,AMOUNT to be crafted,required MATERIALS and COSTS
#   and also BOOLEAN values for it being unlocked or not.
#   If a Second Material is not being used, enter nil.
#
#   Here is an example!
#
# RECIPEXS=[
#  [:ITEMID,CRAFT_AMOUNT,[:MATERIAL1,COST],[:MATERIAL2,COST],IS_UNLOCKED?]
#  ]
############################################################
# RECIPEXS=[
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

$exit = 0
$isUnlocked = []
###############################################################################
# This is your Items, Material etc.
###############################################################################

RECIPEXS=[
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
[:EXPSHARE,1,[:LINKSTONE,1],nil, true],
[:ASSAULTVEST,1,[:EVIOLITE,1],nil, true],
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

# This goes through the RECIPEXS array and adds the true or false value from it
# to the $game_variables[CRAFTVAR] array
    for i in 0...RECIPEXS.length
     $isUnlocked[i] = RECIPEXS[i][4]
    end
   
  def setupCraftUnlocks
   $game_variables[CRAFTVAR] = $isUnlocked
  end

#From here onwards you DO NOT change anything.
class TradingScene

  def initialize
    @close = $exit
    @select=3
    @item=0
    @mat1=RECIPEXS[@item][2]? RECIPEXS[@item][2][0] : -1 # the amount for first item
    @mat2=RECIPEXS[@item][3]? RECIPEXS[@item][3][0] : -1 # the amount for first item
    @cost1=RECIPEXS[@item][2]? RECIPEXS[@item][2][1] : 0 # the amount for first item
    @cost2=RECIPEXS[@item][3]? RECIPEXS[@item][3][1] : 0 # the amount for first item
    @amount=RECIPEXS[@item][1] # the amount for the first item made
                  
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
    @sprites["Item_icon"].setBitmap(pbItemIconFile(GameData::Item.try_get(RECIPEXS[@item][0])))
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
    @sprites["Item_1_icon"].setBitmap((@mat1!=-1) ? pbItemIconFile(GameData::Item.try_get(@mat1)) : "")
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
    @sprites["Item_2_icon"].setBitmap((@mat2!=-1) ? pbItemIconFile(GameData::Item.try_get(@mat2)) : "")
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
        @sprites["Item_icon"].setBitmap(pbItemIconFile(GameData::Item.try_get(RECIPEXS[@item][0])))
        if $game_variables[CRAFTVAR][@item]
            @sprites["unknown"].opacity=0
            @sprites["Item_icon"].opacity=255
            @sprites["Item_1_icon"].setBitmap(RECIPEXS[@item][2]? pbItemIconFile(GameData::Item.try_get(RECIPEXS[@item][2][0])) : "") # Vendily
            @sprites["Item_2_icon"].setBitmap(RECIPEXS[@item][3]? pbItemIconFile(GameData::Item.try_get(RECIPEXS[@item][3][0])) : "") # Vendily
            @sprites["Item_1_icon"].opacity= RECIPEXS[@item][2] ? 255 : 0
            @sprites["Item_2_icon"].opacity=RECIPEXS[@item][3] ? 255 : 0
            @mat1=RECIPEXS[@item][2]? RECIPEXS[@item][2][0] : -1
            @mat2=RECIPEXS[@item][3]? RECIPEXS[@item][3][0] : -1
            @cost1=RECIPEXS[@item][2]? RECIPEXS[@item][2][1] : 0
            @cost2=RECIPEXS[@item][3]? RECIPEXS[@item][3][1] : 0
            @amount=RECIPEXS[@item][1]
          else
            @sprites["unknown"].opacity=255
            @sprites["Item_icon"].opacity=0
            @sprites["Item_1_icon"].opacity=0
            @sprites["Item_2_icon"].opacity=0
          end
          self.text
          
        # When pressing Right
        if Input.trigger?(Input::RIGHT)  && @item < RECIPEXS.length-1
          @item+=1
        elsif Input.trigger?(Input::RIGHT)  && @item ==RECIPEXS.length-1 # Make it run though the selection after last item.
          @item = 0
        end
        if Input.trigger?(Input::LEFT) && @item >0
          @item-=1
        elsif Input.trigger?(Input::LEFT) && @item ==0 # Make it run though the selection after first item.
          @item = RECIPEXS.length-1
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
              $PokemonBag.pbStoreItem(RECIPEXS[@item][0],@amount)
              $PokemonBag.pbDeleteItem(@mat1,@cost1)
              if @mat2!=-1
                $PokemonBag.pbDeleteItem(@mat2,@cost2)
              end
              self.text
              Kernel.pbMessage(_INTL("{1} {2}'s were traded for each other.", @amount, GameData::Item.get(GameData::Item.try_get(RECIPEXS[@item][0])).name))
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
    @text3=_INTL("{1} / {2}", @item + 1, RECIPEXS.length)
    textos.push([@text1,175,115,false,baseColor,shadowColor])
    textos.push([@text2,175,198+5,false,baseColor,shadowColor])
    textos.push([@text3,75,30,false,baseColor,shadowColor])
    textos.push(["Craft",230,280+5,false,baseColor,shadowColor])
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