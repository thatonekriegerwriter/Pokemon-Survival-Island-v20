#===============================================================================
#                              *Item Crafter
# *Item Crafter scene created by TheKrazyGamer/kcgcrazy/TheKraazyGamer
# *Please Give Credit if used
#
# *to add an item of your own just add it to the RECIPEMART1 array.
#   Add The ITEMID,AMOUNT to be crafted,required MATERIALS and COSTS
#   and also BOOLEAN values for it being unlocked or not.
#   If a Second Material is not being used, enter nil.
#
#   Here is an example!
#
# RECIPEMART1=[
#  [:ITEMID,CRAFT_AMOUNT,[:MATERIAL1,COST],[:MATERIAL2,COST],IS_UNLOCKED?]
#  ]
############################################################
# RECIPEMART1=[
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

RECIPEMART1=[
[:POTION,1,[:STARPIECE,1],nil, true],
[:SUPERPOTION,1,[:STARPIECE,3],nil, true],
[:BLACKFLUTE,1,[:STARPIECE,2],nil, true],
[:EVIOLITE,1,[:STARPIECE,3],nil, true],
[:SACREDASH,1,[:STARPIECE,15],nil, true],
[:LEFTOVERS,1,[:STARPIECE,3],nil, true],
[:FULLINCENSE,1,[:STARPIECE,2],nil, true],
[:LAXINCENSE,1,[:STARPIECE,2],nil, true],
[:LUCKINCENSE,1,[:STARPIECE,2],nil, true],
[:PUREINCENSE,1,[:STARPIECE,2],nil, true],
[:SEAINCENSE,1,[:STARPIECE,2],nil, true],
[:WAVEINCENSE,1,[:STARPIECE,2],nil, true],
[:ROSEINCENSE,1,[:STARPIECE,2],nil, true],
[:ODDINCENSE,1,[:STARPIECE,2],nil, true],
[:ROCKINCENSE,1,[:STARPIECE,2],nil, true],
[:WATERBOTTLE,1,[:STARPIECE,1],nil, true],
[:POKEDOLL,1,[:STARPIECE,1],nil, true],
[:SNOWMAIL,1,[:STARPIECE,1],nil, true]
]

###############################################################################

# This goes through the RECIPEMART1 array and adds the true or false value from it
# to the $game_variables[CRAFTVAR] array
    for i in 0...RECIPEMART1.length
     $isUnlocked[i] = RECIPEMART1[i][4]
    end
   
  def setupCraftUnlocks
   $game_variables[CRAFTVAR] = $isUnlocked
  end

#From here onwards you DO NOT change anything.
class TradingMart1Scene

  def initialize
    @close = $exit
    @select=3
    @item=0
    @mat1=RECIPEMART1[@item][2]? RECIPEMART1[@item][2][0] : -1 # the amount for first item
    @mat2=RECIPEMART1[@item][3]? RECIPEMART1[@item][3][0] : -1 # the amount for first item
    @cost1=RECIPEMART1[@item][2]? RECIPEMART1[@item][2][1] : 0 # the amount for first item
    @cost2=RECIPEMART1[@item][3]? RECIPEMART1[@item][3][1] : 0 # the amount for first item
    @amount=RECIPEMART1[@item][1] # the amount for the first item made
                  
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
    @sprites["Item_icon"].setBitmap(GameData::Item.icon_filename(GameData::Item.try_get(RECIPEMART1[@item][0])))
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
    
    self.openTradingMart1Scene
  end
  
  def openTradingMart1Scene
    self.CheckAbleToCraft
    pbFadeInAndShow(@sprites) {self.text}
    self.input
    self.action
  end
  
  def closeTradingMart1Scene
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
        @sprites["Item_icon"].setBitmap(GameData::Item.icon_filename(GameData::Item.try_get(RECIPEMART1[@item][0])))
        if $game_variables[CRAFTVAR][@item]
            @sprites["unknown"].opacity=0
            @sprites["Item_icon"].opacity=255
            @sprites["Item_1_icon"].setBitmap(RECIPEMART1[@item][2]? GameData::Item.icon_filename(GameData::Item.try_get(RECIPEMART1[@item][2][0])) : "") # Vendily
            @sprites["Item_2_icon"].setBitmap(RECIPEMART1[@item][3]? GameData::Item.icon_filename(GameData::Item.try_get(RECIPEMART1[@item][3][0])) : "") # Vendily
            @sprites["Item_1_icon"].opacity= RECIPEMART1[@item][2] ? 255 : 0
            @sprites["Item_2_icon"].opacity=RECIPEMART1[@item][3] ? 255 : 0
            @mat1=RECIPEMART1[@item][2]? RECIPEMART1[@item][2][0] : -1
            @mat2=RECIPEMART1[@item][3]? RECIPEMART1[@item][3][0] : -1
            @cost1=RECIPEMART1[@item][2]? RECIPEMART1[@item][2][1] : 0
            @cost2=RECIPEMART1[@item][3]? RECIPEMART1[@item][3][1] : 0
            @amount=RECIPEMART1[@item][1]
          else
            @sprites["unknown"].opacity=255
            @sprites["Item_icon"].opacity=0
            @sprites["Item_1_icon"].opacity=0
            @sprites["Item_2_icon"].opacity=0
          end
          self.text
          
        # When pressing Right
        if Input.trigger?(Input::RIGHT)  && @item < RECIPEMART1.length-1
          @item+=1
        elsif Input.trigger?(Input::RIGHT)  && @item ==RECIPEMART1.length-1 # Make it run though the selection after last item.
          @item = 0
        end
        if Input.trigger?(Input::LEFT) && @item >0
          @item-=1
        elsif Input.trigger?(Input::LEFT) && @item ==0 # Make it run though the selection after first item.
          @item = RECIPEMART1.length-1
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
              $PokemonBag.pbStoreItem(RECIPEMART1[@item][0],@amount)
              $PokemonBag.pbDeleteItem(@mat1,@cost1)
              if @mat2!=-1
                $PokemonBag.pbDeleteItem(@mat2,@cost2)
              end
              self.text
              Kernel.pbMessage(_INTL("{1} and {2} were traded for each other.", GameData::Item.get(GameData::Item.try_get(@mat1)).name, GameData::Item.get(GameData::Item.try_get(RECIPEMART1[@item][0])).name))
            end
          else
            Kernel.pbMessage(_INTL("The Xatu doesn't feel like you should trade for that yet."))
          end
        when 1
          @close=@select
          self.closeTradingMart1Scene
        end       
      end
      
      if Input.trigger?(Input::B)
        @close=@select
        self.closeTradingMart1Scene  
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
    @text3=_INTL("{1} / {2}", @item + 1, RECIPEMART1.length)
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