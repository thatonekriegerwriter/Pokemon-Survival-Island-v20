###---craftS
class Crafts_Scene
#################################
## Configuration
  craftNAMEBASECOLOR=Color.new(88,88,80)
  craftNAMESHADOWCOLOR=Color.new(168,184,184)
#################################
  
  def update
    pbUpdateSpriteHash(@sprites)
  end

  def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
  end
  
  def pbStartScene(selection)
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @selection=0
    @quant=1
    @currentArray=0
    @returnItem=:NO
    @itemA=:NO
    @itemB=:NO
    @itemC=:NO
    @sprites={}
    @icons={}
    @recipe=[:NO,:NO,:NO,:NO]
    @required=[]
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/craftingMenu/craftingPage")
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    coord=0
    @imagepos=[]
    @selectX=100
    @selectY=168
    @sprites["quant"]=Window_UnformattedTextPokemon.new("")
    @sprites["quantA"]=Window_UnformattedTextPokemon.new("")
    @sprites["quantB"]=Window_UnformattedTextPokemon.new("")
    @sprites["quantC"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftA"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftB"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftC"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftResult"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["quant"])
    @sprites["quant"].x=356
    @sprites["quant"].y=224
    @sprites["quant"].width=Graphics.width-48
    @sprites["quant"].height=Graphics.height
    @sprites["quant"].baseColor=Color.new(240,240,240)
    @sprites["quant"].shadowColor=Color.new(40,40,40)
    @sprites["quant"].visible=true
    @sprites["quant"].viewport=@viewport
    @sprites["quant"].windowskin=nil
    pbPrepareWindow(@sprites["quantA"])
    @sprites["quantA"].x=112
    @sprites["quantA"].y=224
    @sprites["quantA"].width=Graphics.width-48
    @sprites["quantA"].height=Graphics.height
    @sprites["quantA"].baseColor=Color.new(160,160,160)
    @sprites["quantA"].shadowColor=Color.new(40,40,40)
    @sprites["quantA"].visible=true
    @sprites["quantA"].viewport=@viewport
    @sprites["quantA"].windowskin=nil
    pbPrepareWindow(@sprites["quantB"])
    @sprites["quantB"].x=172
    @sprites["quantB"].y=224
    @sprites["quantB"].width=Graphics.width-48
    @sprites["quantB"].height=Graphics.height
    @sprites["quantB"].baseColor=Color.new(160,160,160)
    @sprites["quantB"].shadowColor=Color.new(40,40,40)
    @sprites["quantB"].visible=true
    @sprites["quantB"].viewport=@viewport
    @sprites["quantB"].windowskin=nil
    pbPrepareWindow(@sprites["quantC"])
    @sprites["quantC"].x=236
    @sprites["quantC"].y=224
    @sprites["quantC"].width=Graphics.width-48
    @sprites["quantC"].height=Graphics.height
    @sprites["quantC"].baseColor=Color.new(160,160,160)
    @sprites["quantC"].shadowColor=Color.new(40,40,40)
    @sprites["quantC"].visible=true
    @sprites["quantC"].viewport=@viewport
    @sprites["quantC"].windowskin=nil
    pbPrepareWindow(@sprites["craftResult"])
    @sprites["craftResult"].x=30
    @sprites["craftResult"].y=294
    @sprites["craftResult"].width=Graphics.width-48
    @sprites["craftResult"].height=Graphics.height
    @sprites["craftResult"].baseColor=Color.new(0,0,0)
    @sprites["craftResult"].shadowColor=Color.new(160,160,160)
    @sprites["craftResult"].visible=true
    @sprites["craftResult"].viewport=@viewport
    @sprites["craftResult"].windowskin=nil
    @sprites["selector"]=IconSprite.new(@selectX,@selectY,@viewport)
    @sprites["selector"].setBitmap("Graphics/Pictures/craftingMenu/craftSelect")
    
    filenamA=GameData::Item.icon_filename(@itemA)
    @icons["itemA"]=IconSprite.new(100,168,@viewport)
    @icons["itemA"].setBitmap(filenamA)
    
    filenamB=GameData::Item.icon_filename(@itemB)
    @icons["itemB"]=IconSprite.new(164,168,@viewport)
    @icons["itemB"].setBitmap(filenamB)
    
    filenamC=GameData::Item.icon_filename(@itemC)
    @icons["itemC"]=IconSprite.new(228,168,@viewport)
    @icons["itemC"].setBitmap(filenamC)
    
    filenamD=GameData::Item.icon_filename(@returnItem)
    @icons["itemResult"]=IconSprite.new(356,168,@viewport)
    @icons["itemResult"].setBitmap(filenamD)
    
    pbDeactivateWindows(@sprites)
    pbRefresh
    pbFadeInAndShow(@sprites)
  end

  def pbEndScene
    pbFadeOutAndHide(@icons)
    pbDisposeSpriteHash(@icons)

    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end


  def pbRefresh
    #@sprites["background"].setBitmap(sprintf("Graphics/Pictures/charselect#{playerCharacter}"))
  end

















# Script that manages button inputs  
  def pbSelectcraft
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    pbSetSystemFont(overlay)
    pbDrawImagePositions(overlay,@imagepos)
    @returnItem=:NO
    @itemA=:NO
    @itemB=:NO
    @itemC=:NO
    @quantA=0
    @quantB=0
    @quantC=0
    while true
    Graphics.update
      Input.update
      self.update
      @sprites["selector"].x=@selectX
      @sprites["selector"].y=@selectY
      
      filenamA = GameData::Item.icon_filename(@itemA)
      @icons["itemA"].setBitmap(filenamA)
      
      filenamB = GameData::Item.icon_filename(@itemB)
      @icons["itemB"].setBitmap(filenamB)
      
      filenamC = GameData::Item.icon_filename(@itemC)
      @icons["itemC"].setBitmap(filenamC)
      
      filenamD = GameData::Item.icon_filename(@returnItem)
      @icons["itemResult"].setBitmap(filenamD)
      
      selectionNum=@selection
	  
	  
      if @currentArray==0
        @craftA=:NO
        @craftB=:NO
        @craftC=:NO
        @craftResult=:NO
      else
        @craftA=GameData::Item.get(@itemA).name
        @craftB=GameData::Item.get(@itemB).name
        @craftC=GameData::Item.get(@itemC).name
        @craftResult=GameData::Item.get(@returnItem).name
      end

      @sprites["quant"].text=_INTL("{1}",@quant)
      @sprites["quantA"].text=_INTL("{1}",@quantA)
      @sprites["quantB"].text=_INTL("{1}",@quantB)
      @sprites["quantC"].text=_INTL("{1}",@quantC)


      if @craftA==:NO
        @sprites["craftResult"].text=_INTL("No items selected.")
      elsif @craftA!=:NO && @craftResult==:NO
        @sprites["craftResult"].text=_INTL("Incorrect crafting recipe.")
      elsif @itemB==:NO && @itemC==:NO
        @sprites["craftResult"].text=_INTL("{1} = {2}",@craftA,@craftResult)
      elsif @itemB!=:NO && @itemC!=:NO && @itemA==:NO
        @sprites["craftResult"].text=_INTL("{1} + {2} = {3}",@craftC,@craftB,@craftResult)
      elsif @itemA!=:NO && @itemC!=:NO && @itemB==:NO
        @sprites["craftResult"].text=_INTL("{1} + {2} = {3}",@craftA,@craftC,@craftResult)
      elsif @itemA!=:NO && @itemB!=:NO && @itemC==:NO
        @sprites["craftResult"].text=_INTL("{1} + {2} = {3}",@craftA,@craftB,@craftResult)
      else
        @sprites["craftResult"].text=_INTL("{1} + {2} + {3} = {4}",@craftA,@craftB,@craftC,@craftResult)
      end
	  
	  
	  
      if Input.trigger?(Input::LEFT) #SELECTING POSITION
        if @selection==0
          @selectX=356
          @selection+=3
        elsif @selection==3
          @selectX=228
          @selection=2
        else
          @selectX-=64
          @selection-=1
        end
      elsif Input.trigger?(Input::RIGHT)
        if @selection==3
          @selectX=100
          @selection-=3
        elsif @selection==2
          @selectX=356
          @selection=3
        else
          @selectX+=64
          @selection+=1
        end
      end
	  
	  
      if Input.trigger?(Input::UP)  #INCREASING QUANTITY
        if @quant>99
          @quant=1
        else
          @quant+=1
        end
      end
      if Input.trigger?(Input::DOWN) #DECREASING QUANTITY
        if @quant==1
          @quant=100
        else
          @quant-=1
        end
      end





      if Input.trigger?(Input::C)
	  
	  
	  
	  
        if @selection==3 && @returnItem!=:NO #If Result is valid then craft
             if pbCheckRecipe([@itemA,@itemB,@itemC])
			 if pbCheckPrices
              Kernel.pbReceiveItem(@returnItem,@quant)
			  if @itemA != :NO
              $PokemonBag.pbDeleteItem(@itemA,@quant)
			  end
			  if @itemB != :NO
              $PokemonBag.pbDeleteItem(@itemB,@quant)
			  end
			  if @itemC != :NO
              $PokemonBag.pbDeleteItem(@itemC,@quant)
			  end
              @itemA=:NO
              @itemB=:NO
              @itemC=:NO
			  @craftA=:NO
			  @craftB=:NO
			  @craftC=:NO
			  @craftResult=:NO
              @returnItem=:NO
              @sprites["craftResult"].text=_INTL("No items selected.")
              @quant=1
              @quantA=0
              @quantB=0
              @quantC=0
			 end
			 end
            





        elsif @selection==0
          @returnItem=:NO
          @itemA=Kernel.pbChooseItem
		  if @itemA.nil?
		   @itemA = :NO 
		  end
	      @recipe[1] = @itemA
		  crafts = CraftsList.getcrafts	 
        if !@itemA.empty?		  
            if pbCheckRecipe([@itemA,@itemB,@itemC])
              @returnItem=crafts[@currentArray][0]
              @required[1]=crafts[@currentArray][1]
			  
			  puts @currentArray
            end
		else
		@itemA=:NO
        end



        elsif @selection==1
          @returnItem=:NO
          @itemB=Kernel.pbChooseItem
		  if @itemB.nil?
		   @itemB = :NO 
		  end
	      @recipe[2] = @itemB
		  crafts = CraftsList.getcrafts
		  if !@itemB.empty?
            if pbCheckRecipe([@itemA,@itemB,@itemC])
              @returnItem=crafts[@currentArray]&.[](0)
              @required[2]=crafts[@currentArray]&.[](2)
			  puts @currentArray
            end
		  else
		  @itemB=:NO
		  end



        elsif @selection==2
          @returnItem=:NO
          @itemC=Kernel.pbChooseItem
		  if @itemC.nil?
		   @itemC = :NO 
		  end
	      @recipe[3] = @itemC
		  crafts = CraftsList.getcrafts
		  if !@itemC.empty?
            if pbCheckRecipe([@itemA,@itemB,@itemC])
              @returnItem=crafts[@currentArray]&.[](0)
              @required[3]=crafts[@currentArray]&.[](3)
			  puts @currentArray
            end
		  else
		  @itemC=:NO
		  end
        else
          Kernel.pbMessage(_INTL("You must first select an item!"))
        end


        if !@itemA.empty? && !@itemB.empty? && !@itemC.empty?
         @quantA=$PokemonBag.pbQuantity(@itemA)
         @quantB=$PokemonBag.pbQuantity(@itemB)
         @quantC=$PokemonBag.pbQuantity(@itemC)
        end
      end









       #Cancel
      if Input.trigger?(Input::BACK)
        return -1
      end     




    end
  end











  def pbCheckRecipe(recipe)
    if recipe.is_a? Array
    sorted_recipe = recipe.sort
	else
	end
    for i in 0..CraftsList.getcrafts.length-1
	  sorted_craft = CraftsList.getcrafts[i][1..-1].sort
      if sorted_recipe == sorted_craft
	   @currentArray=i
       return true
      end
    end
   return false
  end
  
  
  def pbCheckPrices
		  crafts = CraftsList.getcrafts	 
		  craftedA = crafts[@currentArray][1]
		  craftedB = crafts[@currentArray][2]
		  craftedC = crafts[@currentArray][2]
		 if craftedA==:NO && craftedB==:NO && craftedC==:NO
		 return false
         elsif ($PokemonBag.pbQuantity(craftedA)>=@quant || craftedA==:NO) && ($PokemonBag.pbQuantity(craftedB)>=@quant || craftedB==:NO) && ($PokemonBag.pbQuantity(craftedC)>=@quant || craftedC==:NO)
		 return true
		 else
		 return false
		 end
  end
end



class PokemoncraftSelect
  attr_accessor :lastcraft
  attr_reader :crafts
  def numChars()
    return CraftsList.getcrafts.length-1
  end
  def initialize
    @lastcraft=1
    @crafts=[]
    @choices=[]
    # Initialize each playerCharacter of the array
    for i in 0..CraftsList.getcrafts.length
      @crafts[i]=[]
      @choices[i]=0
    end
  end
  def crafts
    rearrange()
    return @crafts
  end

  def rearrange()
    if @crafts.length==6
      newcrafts=[]
      for i in 0..CraftsList.getcrafts.length
        newcrafts[i]=[]
        @choices[i]=0 if !@choices[i]
      end
      @crafts=newcrafts
    end
  end
end

module CraftsList
  def self.getcrafts
    @CraftsList = [
    [:NO,:NO,:NO,:NO], 
    [:TEA,:NO,:FRESHWATER,:TEALEAF], 
    #RECIPE 2: 
    [:SWEETHEART,:NO,:SUGAR,:CHOCOLATE], 
    #RECIPE 3: 
    [:CARROTCAKE,:WHEAT,:SUGAR,:CARROT],
    #RECIPE 4:  
    [:LEMONADE,:LEMON,:SUGAR,:FRESHWATER], 
    #RECIPE 5:  
    [:BREAD,:WHEAT,:WHEAT,:WHEAT],
    #RECIPE 6: 
    [:CHOCOLATE,:NO,:SUGAR,:COCOABEANS],
    #RECIPE 7: 
    [:GSCURRY,:MEAT,:STARFBERRY,:BOWL],
    #RECIPE 8: 
    [:CRITCURRY,:MEAT,:LANSATBERRY,:BOWL],
    #RECIPE 9: 
    [:DEFCURRY,:MEAT,:BELUEBERRY,:BOWL],
    #RECIPE 10: 
    [:ACCCURRY,:MEAT,:MICLEBERRY,:BOWL],
    #RECIPE 11: 
    [:SPDEFCURRY,:MEAT,:DURINBERRY,:BOWL],
    #RECIPE 12: 
    [:SPEEDCURRY,:MEAT,:WATMELBERRY,:BOWL],
    #RECIPE 13: 
    [:SATKCURRY,:MEAT,:KELPSYBERRY,:BOWL],
    #RECIPE 14: 
    [:ATKCURRY,:MEAT,:SPELONBERRY,:BOWL],
    #RECIPE 15: 
    [:LONELYMINT,:SUGAR,:PAMTREBERRY,:NO],
    #RECIPE 16: 
    [:ADAMANTMINT,:SUGAR,:YACHEBERRY,:NO],
    #RECIPE 17: 
    [:NAUGHTYMINT,:SUGAR,:TANGABERRY,:NO],
    #RECIPE 18: 
    [:BRAVEMINT,:SUGAR,:KASIBBERRY,:NO],
    #RECIPE 19: 
    [:BOLDMINT,:SUGAR,:GANLONBERRY,:NO],
    #RECIPE 20: 
    [:IMPISHMINT,:SUGAR,:COBABERRY,:NO],
    #RECIPE 21: 
    [:LAXMINT,:SUGAR,:WHEAT,:NO],
    #RECIPE 22: 
    [:RELAXEDMINT,:SUGAR,:CORNNBERRY,:NO],
    #RECIPE 23: 
    [:MODESTMINT,:SUGAR,:FIGYBERRY,:NO],
    #RECIPE 24: 
    [:MILDMINT,:SUGAR,:WEPEARBERRY,:NO],
    #RECIPE 25: 
    [:RASHMINT,:SUGAR,:GREPABERRY,:NO],
    #RECIPE 26: 
    [:QUIETMINT,:SUGAR,:APPLE,:NO],
    #RECIPE 27: 
    [:CALMMINT,:SUGAR,:BLUKBERRY,:NO],
    #RECIPE 28: 
    [:GENTLEMINT,:SUGAR,:SPELONBERRY,:NO],
    #RECIPE 29: 
    [:CAREFULMINT,:SUGAR,:TAMATOBERRY,:NO],
    #RECIPE 30: 
    [:SASSYMINT,:SUGAR,:PINAPBERRY,:NO],
    #RECIPE 31: 
    [:TIMIDMINT,:SUGAR,:POMEGBERRY,:NO],
    #RECIPE 32: 
    [:HASTYMINT,:SUGAR,:WIKIBERRY,:NO],
    #RECIPE 33: 
    [:JOLLYMINT,:SUGAR,:CHERIBERRY,:NO],
    #RECIPE 34: 
    [:NAIVEMINT,:SUGAR,:STARFBERRY,:NO],
    #RECIPE 35: 
    [:SERIOUSMINT,:SUGAR,:JABOCABERRY,:NO],
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
    [:MEATSANDWICHBIRD,:BREAD,:COOKEDBIRDMEAT,:NO],
    [:MEATSANDWICHROCKY,:BREAD,:COOKEDROCKYMEAT,:NO],
    [:MEATSANDWICHBUG,:BREAD,:COOKEDBUGMEAT,:NO],
    [:MEATSANDWICHSTEELY,:BREAD,:COOKEDSTEELYMEAT,:NO],
    [:MEATSANDWICHSUS,:BREAD,:COOKEDSUSHI,:NO],
    [:MEATSANDWICHLEAFY,:BREAD,:COOKEDLEAFYMEAT,:NO],
    [:MEATSANDWICHMJ,:BREAD,:COOKEDDRAGONMEAT,:NO],
    [:MEATSANDWICHCRYSTAL,:BREAD,:COOKEDEDIABLESCRYSTAL,:NO],
    [:MEATSANDWICH,:BREAD,:COOKEDMEAT,:NO],
    [:POTATOSTEW,:POTATO,:ONION,:CARROT],
    [:MEATKABOB,:POTATO,:ONION,:COOKEDMEAT],
    [:SOUPBROTH,:FRESHWATER,:RAREBONE,:BALMMUSHROOM],
    [:FISHSOUP,:SUSHI,:POTATO,:SOUPBROTH]
    ]
    return @CraftsList
  end
end

#Call Crafts.craftWindow
module Crafts  
  def self.craftWindow()
#  $DiscordRPC.details = "Cooking a Tasty Meal!"
#  $DiscordRPC.update
  craftScene=Crafts_Scene.new
  craftScene.pbStartScene($PokemoncraftSelect)
  craft=craftScene.pbSelectcraft
  craftScene.pbEndScene
 end
end