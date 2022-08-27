###---craftS
class Crafts_Scene2
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
    @itemD=:NO
    @itemE=:NO
    @itemF=:NO
    @itemG=:NO
    @itemH=:NO
    @itemI=:NO
    @sprites={}
    @icons={}
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
    @sprites["quantD"]=Window_UnformattedTextPokemon.new("")
    @sprites["quantE"]=Window_UnformattedTextPokemon.new("")
    @sprites["quantF"]=Window_UnformattedTextPokemon.new("")
    @sprites["quantG"]=Window_UnformattedTextPokemon.new("")
    @sprites["quantH"]=Window_UnformattedTextPokemon.new("")
    @sprites["quantI"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftA"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftB"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftC"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftD"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftE"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftF"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftG"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftH"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftI"]=Window_UnformattedTextPokemon.new("")
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
    pbPrepareWindow(@sprites["quantD"])
    @sprites["quantD"].x=236
    @sprites["quantD"].y=224
    @sprites["quantD"].width=Graphics.width-48
    @sprites["quantD"].height=Graphics.height
    @sprites["quantD"].baseColor=Color.new(160,160,160)
    @sprites["quantD"].shadowColor=Color.new(40,40,40)
    @sprites["quantD"].visible=true
    @sprites["quantD"].viewport=@viewport
    @sprites["quantD"].windowskin=nil
    pbPrepareWindow(@sprites["quantE"])
    @sprites["quantE"].x=236
    @sprites["quantE"].y=224
    @sprites["quantE"].width=Graphics.width-48
    @sprites["quantE"].height=Graphics.height
    @sprites["quantE"].baseColor=Color.new(160,160,160)
    @sprites["quantE"].shadowColor=Color.new(40,40,40)
    @sprites["quantE"].visible=true
    @sprites["quantE"].viewport=@viewport
    @sprites["quantE"].windowskin=nil
    pbPrepareWindow(@sprites["quantF"])
    @sprites["quantF"].x=236
    @sprites["quantF"].y=224
    @sprites["quantF"].width=Graphics.width-48
    @sprites["quantF"].height=Graphics.height
    @sprites["quantF"].baseColor=Color.new(160,160,160)
    @sprites["quantF"].shadowColor=Color.new(40,40,40)
    @sprites["quantF"].visible=true
    @sprites["quantF"].viewport=@viewport
    @sprites["quantF"].windowskin=nil
    pbPrepareWindow(@sprites["quantG"])
    @sprites["quantG"].x=236
    @sprites["quantG"].y=224
    @sprites["quantG"].width=Graphics.width-48
    @sprites["quantG"].height=Graphics.height
    @sprites["quantG"].baseColor=Color.new(160,160,160)
    @sprites["quantG"].shadowColor=Color.new(40,40,40)
    @sprites["quantG"].visible=true
    @sprites["quantG"].viewport=@viewport
    @sprites["quantG"].windowskin=nil
    pbPrepareWindow(@sprites["quantH"])
    @sprites["quantH"].x=236
    @sprites["quantH"].y=224
    @sprites["quantH"].width=Graphics.width-48
    @sprites["quantH"].height=Graphics.height
    @sprites["quantH"].baseColor=Color.new(160,160,160)
    @sprites["quantH"].shadowColor=Color.new(40,40,40)
    @sprites["quantH"].visible=true
    @sprites["quantH"].viewport=@viewport
    @sprites["quantH"].windowskin=nil
    pbPrepareWindow(@sprites["quantI"])
    @sprites["quantI"].x=236
    @sprites["quantI"].y=224
    @sprites["quantI"].width=Graphics.width-48
    @sprites["quantI"].height=Graphics.height
    @sprites["quantI"].baseColor=Color.new(160,160,160)
    @sprites["quantI"].shadowColor=Color.new(40,40,40)
    @sprites["quantI"].visible=true
    @sprites["quantI"].viewport=@viewport
    @sprites["quantI"].windowskin=nil
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
    
    filenamD=GameData::Item.icon_filename(@itemD)
    @icons["itemD"]=IconSprite.new(228,168,@viewport)
    @icons["itemD"].setBitmap(filenamD)
    
    filenamE=GameData::Item.icon_filename(@itemE)
    @icons["itemE"]=IconSprite.new(228,168,@viewport)
    @icons["itemE"].setBitmap(filenamE)
    
    filenamF=GameData::Item.icon_filename(@itemF)
    @icons["itemF"]=IconSprite.new(228,168,@viewport)
    @icons["itemF"].setBitmap(filenamF)
    
    filenamG=GameData::Item.icon_filename(@itemG)
    @icons["itemG"]=IconSprite.new(228,168,@viewport)
    @icons["itemG"].setBitmap(filenamG)
    
    filenamH=GameData::Item.icon_filename(@itemH)
    @icons["itemH"]=IconSprite.new(228,168,@viewport)
    @icons["itemH"].setBitmap(filenamH)
    
    filenamI=GameData::Item.icon_filename(@itemI)
    @icons["itemI"]=IconSprite.new(228,168,@viewport)
    @icons["itemI"].setBitmap(filenamI)
    
    filenamResult=GameData::Item.icon_filename(@returnItem)
    @icons["itemResult"]=IconSprite.new(356,168,@viewport)
    @icons["itemResult"].setBitmap(filenamResult)
    
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
  def pbSelectcraft2
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    pbSetSystemFont(overlay)
    pbDrawImagePositions(overlay,@imagepos)
    @returnItem=:NO
    @itemA=:NO
    @itemB=:NO
    @itemC=:NO
    @itemD=:NO
    @itemE=:NO
    @itemF=:NO
    @itemG=:NO
    @itemH=:NO
    @itemI=:NO
    @quantA=0
    @quantB=0
    @quantC=0
    @quantD=0
    @quantE=0
    @quantF=0
    @quantG=0
    @quantH=0
    @quantI=0
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
      
      filenamD = GameData::Item.icon_filename(@itemD)
      @icons["itemD"].setBitmap(filenamD)
      
      filenamE = GameData::Item.icon_filename(@itemE)
      @icons["itemE"].setBitmap(filenamE)
      
      filenamF = GameData::Item.icon_filename(@itemF)
      @icons["itemF"].setBitmap(filenamF)
      
      filenamG = GameData::Item.icon_filename(@itemG)
      @icons["itemG"].setBitmap(filenamG)
      
      filenamH = GameData::Item.icon_filename(@itemH)
      @icons["itemH"].setBitmap(filenamH)
      
      filenamI = GameData::Item.icon_filename(@itemI)
      @icons["itemI"].setBitmap(filenamI)
      
      filenamResult = GameData::Item.icon_filename(@returnItem)
      @icons["itemResult"].setBitmap(filenamResult)
      
      selectionNum=@selection
      if @currentArray==0
        @craftA=:NO
        @craftB=:NO
        @craftC=:NO
        @craftD=:NO
        @craftE=:NO
        @craftF=:NO
        @craftG=:NO
        @craftH=:NO
        @craftI=:NO
        @craftResult=:NO
      else
        @craftA=GameData::Item.get(CraftsList2.getcrafts2[@currentArray][1]).name
        @craftB=GameData::Item.get(CraftsList2.getcrafts2[@currentArray][2]).name
        @craftC=GameData::Item.get(CraftsList2.getcrafts2[@currentArray][3]).name
        @craftD=GameData::Item.get(CraftsList2.getcrafts2[@currentArray][4]).name
        @craftE=GameData::Item.get(CraftsList2.getcrafts2[@currentArray][5]).name
        @craftF=GameData::Item.get(CraftsList2.getcrafts2[@currentArray][6]).name
        @craftG=GameData::Item.get(CraftsList2.getcrafts2[@currentArray][7]).name
        @craftH=GameData::Item.get(CraftsList2.getcrafts2[@currentArray][8]).name
        @craftI=GameData::Item.get(CraftsList2.getcrafts2[@currentArray][9]).name
        @craftResult=GameData::Item.get(CraftsList2.getcrafts2[@currentArray][0]).name
      end
      @sprites["quant"].text=_INTL("{1}",@quant)
      @sprites["quantA"].text=_INTL("{1}",@quantA)
      @sprites["quantB"].text=_INTL("{1}",@quantB)
      @sprites["quantC"].text=_INTL("{1}",@quantC)
      @sprites["quantD"].text=_INTL("{1}",@quantD)
      @sprites["quantE"].text=_INTL("{1}",@quantE)
      @sprites["quantF"].text=_INTL("{1}",@quantF)
      @sprites["quantG"].text=_INTL("{1}",@quantG)
      @sprites["quantH"].text=_INTL("{1}",@quantH)
      @sprites["quantI"].text=_INTL("{1}",@quantI)
      if @craftResult!=:NO
        @sprites["craftResult"].text=_INTL("{1}",@craftResult)
      else
        @sprites["craftResult"].text=_INTL("No Result.")
      end
      if Input.trigger?(Input::LEFT)
        if @selection==0
          @selectX=356
          @selection+=9
        elsif @selection==1
          @selectX-=64
          @selection-=1
        elsif @selection==2
          @selectX=228
          @selection-=1
        elsif @selection==3
          @selectX=356
          @selection-=1
        elsif @selection==4
          @selectX=228
          @selection-=1
        elsif @selection==5
          @selectX-=64
          @selection-=1
        elsif @selection==6
          @selectX=356
          @selection-=1
        elsif @selection==7
          @selectX=228
          @selection-=1
        elsif @selection==8
          @selectX-=64
          @selection-=1
        elsif @selection==9
          @selectX-=64
          @selection-=1
        end
      elsif Input.trigger?(Input::RIGHT)
        if @selection==0
          @selectX+=64
          @selection+=1
        elsif @selection==1
          @selectX=356
          @selection+=1
        elsif @selection==2
          @selectX=100
          @selection+=1
        elsif @selection==3
          @selectX+=64
          @selection+=1
        elsif @selection==4
          @selectX=356
          @selection+=1
        elsif @selection==5
          @selectX=100
          @selection+=1
        elsif @selection==6
          @selectX+=64
          @selection+=1
        elsif @selection==7
          @selectX=356
          @selection+=1
        elsif @selection==8
          @selectX=100
          @selection-=1
        elsif @selection==9
          @selectX=100
          @selection-=9
        end
      end
      if Input.trigger?(Input::UP)
        if @quant>99
          @quant=1
        else
          @quant+=1
        end
      end
      if Input.trigger?(Input::DOWN)
        if @quant==1
          @quant=100
        else
          @quant-=1
        end
      end
      if Input.trigger?(Input::C)   
        if @selection==9 && @returnItem!=:NO   #Crafting an item with 1 item
          if CraftsList2.getcrafts2[@currentArray][2]==:NO #If slot 2 is empty, don't read it
            if $PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][1])>=@quant
              #if CraftsList2.getcrafts2[@currentArray][1]==@itemA 
                @recipe=[@returnItem,@itemA,:NO,:NO]
                if pbCheckRecipe2(@recipe)
                  Kernel.pbReceiveItem(@returnItem,@quant)
                  $PokemonBag.pbDeleteItem(@itemA,@quant)
                  @itemA=:NO
                  @returnItem=:NO
                  @quant=1
                  @quantA=0
                  @quantB=0
                  @quantC=0
                  @quantD=0
                  @quantE=0
                  @quantF=0
                  @quantG=0
                  @quantH=0
                  @quantI=0
                end
              #end
            else
              Kernel.pbMessage(_INTL("You don't have the ingredients to craft this many items! 1"))
            end
          elsif CraftsList2.getcrafts2[@currentArray][3]==:NO&&CraftsList2.getcrafts2[@currentArray][2]!=:NO
            if $PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][1])>=@quant &&
              $PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][2])>=@quant #Crafting an item with 2 items
                Kernel.pbReceiveItem(@returnItem,@quant)
                $PokemonBag.pbDeleteItem(@itemA,@quant)
                $PokemonBag.pbDeleteItem(@itemB,@quant)
                @itemA=:NO
                @itemB=:NO
                @returnItem=:NO
                @quant=1
                @quantA=0
                @quantB=0
                @quantC=0
                @quantD=0
                @quantE=0
                @quantF=0
                @quantG=0
                @quantH=0
                @quantI=0
            else
              Kernel.pbMessage(_INTL("You don't have the ingredients to craft this many items! 2"))
            end   #Crafting with 3 items
          elsif ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][1])>=@quant  || CraftsList2.getcrafts2[@currentArray][1]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][2])>=@quant ||  || CraftsList2.getcrafts2[@currentArray][2]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][3])>=@quant || CraftsList2.getcrafts2[@currentArray][3]==:NO)
              Kernel.pbReceiveItem(@returnItem,@quant)
              $PokemonBag.pbDeleteItem(@itemA,@quant) if @itemA != :NO
              $PokemonBag.pbDeleteItem(@itemB,@quant) if @itemB != :NO
              $PokemonBag.pbDeleteItem(@itemC,@quant) if @itemC != :NO
		      crafts = CraftsList2.getcrafts2
              @itemA=:NO
              @itemB=:NO
              @returnItem=:NO
              @quant=1
              @quantA=0
              @quantB=0
              @quantC=0
              @quantD=0
              @quantE=0
              @quantF=0
              @quantG=0
              @quantH=0
              @quantI=0
          elsif ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][1])>=@quant  || CraftsList2.getcrafts2[@currentArray][1]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][2])>=@quant ||  || CraftsList2.getcrafts2[@currentArray][2]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][3])>=@quant || CraftsList2.getcrafts2[@currentArray][3]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][4])>=@quant || CraftsList2.getcrafts2[@currentArray][4]==:NO)
                  $PokemonBag.pbDeleteItem(@itemA,@quant) if @itemA != :NO
                  $PokemonBag.pbDeleteItem(@itemB,@quant) if @itemB != :NO
                  $PokemonBag.pbDeleteItem(@itemC,@quant) if @itemC != :NO
                  $PokemonBag.pbDeleteItem(@itemD,@quant) if @itemD != :NO
		          crafts = CraftsList2.getcrafts2
                  @itemA=:NO
                  @itemB=:NO
                  @itemC=:NO
                  @returnItem=:NO
                  @quant=1
                  @quantA=0
                  @quantB=0
                  @quantC=0
                  @quantD=0
                  @quantE=0
                  @quantF=0
                  @quantG=0
                  @quantH=0
                  @quantI=0
              #end
          elsif ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][1])>=@quant  || CraftsList2.getcrafts2[@currentArray][1]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][2])>=@quant ||  || CraftsList2.getcrafts2[@currentArray][2]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][3])>=@quant || CraftsList2.getcrafts2[@currentArray][3]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][4])>=@quant || CraftsList2.getcrafts2[@currentArray][4]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][5])>=@quant || CraftsList2.getcrafts2[@currentArray][5]==:NO)
                  $PokemonBag.pbDeleteItem(@itemA,@quant) if @itemA != :NO
                  $PokemonBag.pbDeleteItem(@itemB,@quant) if @itemB != :NO
                  $PokemonBag.pbDeleteItem(@itemC,@quant) if @itemC != :NO
                  $PokemonBag.pbDeleteItem(@itemD,@quant) if @itemD != :NO
                  $PokemonBag.pbDeleteItem(@itemE,@quant) if @itemE != :NO
		          crafts = CraftsList2.getcrafts2
                  @itemA=:NO
                  @itemB=:NO
                  @itemC=:NO
                  @itemD=:NO
                  @returnItem=:NO
                  @quant=1
                  @quantA=0
                  @quantB=0
                  @quantC=0
                  @quantD=0
                  @quantE=0
                  @quantF=0
                  @quantG=0
                  @quantH=0
                  @quantI=0
              #end
          elsif ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][1])>=@quant  || CraftsList2.getcrafts2[@currentArray][1]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][2])>=@quant ||  || CraftsList2.getcrafts2[@currentArray][2]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][3])>=@quant || CraftsList2.getcrafts2[@currentArray][3]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][4])>=@quant || CraftsList2.getcrafts2[@currentArray][4]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][5])>=@quant || CraftsList2.getcrafts2[@currentArray][5]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][6])>=@quant || CraftsList2.getcrafts2[@currentArray][6]==:NO)
                  $PokemonBag.pbDeleteItem(@itemA,@quant) if @itemA != :NO
                  $PokemonBag.pbDeleteItem(@itemB,@quant) if @itemB != :NO
                  $PokemonBag.pbDeleteItem(@itemC,@quant) if @itemC != :NO
                  $PokemonBag.pbDeleteItem(@itemD,@quant) if @itemD != :NO
                  $PokemonBag.pbDeleteItem(@itemE,@quant) if @itemE != :NO
                  $PokemonBag.pbDeleteItem(@itemF,@quant) if @itemF != :NO
		          crafts = CraftsList2.getcrafts2
                  @itemA=:NO
                  @itemB=:NO
                  @itemC=:NO
                  @itemD=:NO
                  @itemE=:NO
                  @returnItem=:NO
                  @quant=1
                  @quantA=0
                  @quantB=0
                  @quantC=0
                  @quantD=0
                  @quantE=0
                  @quantF=0
                  @quantG=0
                  @quantH=0
                  @quantI=0
              #end
          elsif ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][1])>=@quant  || CraftsList2.getcrafts2[@currentArray][1]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][2])>=@quant ||  || CraftsList2.getcrafts2[@currentArray][2]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][3])>=@quant || CraftsList2.getcrafts2[@currentArray][3]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][4])>=@quant || CraftsList2.getcrafts2[@currentArray][4]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][5])>=@quant || CraftsList2.getcrafts2[@currentArray][5]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][6])>=@quant || CraftsList2.getcrafts2[@currentArray][6]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][7])>=@quant || CraftsList2.getcrafts2[@currentArray][7]==:NO)
                  $PokemonBag.pbDeleteItem(@itemA,@quant) if @itemA != :NO
                  $PokemonBag.pbDeleteItem(@itemB,@quant) if @itemB != :NO
                  $PokemonBag.pbDeleteItem(@itemC,@quant) if @itemC != :NO
                  $PokemonBag.pbDeleteItem(@itemD,@quant) if @itemD != :NO
                  $PokemonBag.pbDeleteItem(@itemE,@quant) if @itemE != :NO
                  $PokemonBag.pbDeleteItem(@itemF,@quant) if @itemF != :NO
                  $PokemonBag.pbDeleteItem(@itemG,@quant) if @itemG != :NO
		          crafts = CraftsList2.getcrafts2
                  @itemA=:NO
                  @itemB=:NO
                  @itemC=:NO
                  @itemD=:NO
                  @itemE=:NO
                  @itemF=:NO
                  @returnItem=:NO
                  @quant=1
                  @quantA=0
                  @quantB=0
                  @quantC=0
                  @quantD=0
                  @quantE=0
                  @quantF=0
                  @quantG=0
                  @quantH=0
                  @quantI=0
              #end
          elsif ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][1])>=@quant  || CraftsList2.getcrafts2[@currentArray][1]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][2])>=@quant ||  || CraftsList2.getcrafts2[@currentArray][2]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][3])>=@quant || CraftsList2.getcrafts2[@currentArray][3]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][4])>=@quant || CraftsList2.getcrafts2[@currentArray][4]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][5])>=@quant || CraftsList2.getcrafts2[@currentArray][5]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][6])>=@quant || CraftsList2.getcrafts2[@currentArray][6]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][7])>=@quant || CraftsList2.getcrafts2[@currentArray][7]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][8])>=@quant || CraftsList2.getcrafts2[@currentArray][8]==:NO)
                  $PokemonBag.pbDeleteItem(@itemA,@quant) if @itemA != :NO
                  $PokemonBag.pbDeleteItem(@itemB,@quant) if @itemB != :NO
                  $PokemonBag.pbDeleteItem(@itemC,@quant) if @itemC != :NO
                  $PokemonBag.pbDeleteItem(@itemD,@quant) if @itemD != :NO
                  $PokemonBag.pbDeleteItem(@itemE,@quant) if @itemE != :NO
                  $PokemonBag.pbDeleteItem(@itemF,@quant) if @itemF != :NO
                  $PokemonBag.pbDeleteItem(@itemG,@quant) if @itemG != :NO
                  $PokemonBag.pbDeleteItem(@itemH,@quant) if @itemH != :NO
		          crafts = CraftsList2.getcrafts2
                  @itemA=:NO
                  @itemB=:NO
                  @itemC=:NO
                  @itemD=:NO
                  @itemE=:NO
                  @itemF=:NO
                  @itemG=:NO
                  @returnItem=:NO
                  @quant=1
                  @quantA=0
                  @quantB=0
                  @quantC=0
                  @quantD=0
                  @quantE=0
                  @quantF=0
                  @quantG=0
                  @quantH=0
                  @quantI=0
              #end
          elsif ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][1])>=@quant  || CraftsList2.getcrafts2[@currentArray][1]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][2])>=@quant ||  || CraftsList2.getcrafts2[@currentArray][2]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][3])>=@quant || CraftsList2.getcrafts2[@currentArray][3]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][4])>=@quant || CraftsList2.getcrafts2[@currentArray][4]==:NO) &&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][5])>=@quant || CraftsList2.getcrafts2[@currentArray][5]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][6])>=@quant || CraftsList2.getcrafts2[@currentArray][6]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][7])>=@quant || CraftsList2.getcrafts2[@currentArray][7]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][8])>=@quant || CraftsList2.getcrafts2[@currentArray][8]==:NO)&&
            ($PokemonBag.pbQuantity(CraftsList2.getcrafts2[@currentArray][9])>=@quant || CraftsList2.getcrafts2[@currentArray][9]==:NO)
                  $PokemonBag.pbDeleteItem(@itemA,@quant) if @itemA != :NO #1
                  $PokemonBag.pbDeleteItem(@itemB,@quant) if @itemB != :NO #2
                  $PokemonBag.pbDeleteItem(@itemC,@quant) if @itemC != :NO #3
                  $PokemonBag.pbDeleteItem(@itemD,@quant) if @itemD != :NO #4
                  $PokemonBag.pbDeleteItem(@itemE,@quant) if @itemE != :NO #5
                  $PokemonBag.pbDeleteItem(@itemF,@quant) if @itemF != :NO #6
                  $PokemonBag.pbDeleteItem(@itemG,@quant) if @itemG != :NO #7
                  $PokemonBag.pbDeleteItem(@itemH,@quant) if @itemH != :NO #8
                  $PokemonBag.pbDeleteItem(@itemI,@quant) if @itemI != :NO #9
		          crafts = CraftsList2.getcrafts2
                  @itemA=:NO
                  @itemB=:NO
                  @itemC=:NO
                  @itemD=:NO
                  @itemE=:NO
                  @itemF=:NO
                  @itemG=:NO
                  @itemH=:NO
                  @itemI=:NO
                  @returnItem=:NO
                  @quant=1
                  @quantA=0
                  @quantB=0
                  @quantC=0
                  @quantD=0
                  @quantE=0
                  @quantF=0
                  @quantG=0
                  @quantH=0
                  @quantI=0
              #end
            else
              Kernel.pbMessage(_INTL("You don't have the ingredients to craft this many items! 1"))
        elsif @selection==0
          @returnItem=:NO
          @itemA=Kernel.pbChooseItem
		  crafts = CraftsList2.getcrafts2	 
        if !@itemA.empty?		  
          for i in 0..274
            if crafts[i][2]!=@itemB && @itemB==:NO
              @itemB=:NO
              @quantB=0
            end
            if crafts[i][3]!=@itemC && @itemC==:NO
              @itemC=:NO
              @quantC=0
            end
            if crafts[i][1]==@itemA&&crafts[i][2]==@itemB&&crafts[i][3]==@itemC
              @currentArray=i
              @returnItem=crafts[i][0]
              @required[1]=crafts[i][1]
            end
          end
		else
		@itemA=:NO
        end
        elsif @selection==1
          @returnItem=:NO
          @itemB=Kernel.pbChooseItem
		  crafts = CraftsList2.getcrafts2
		  if !@itemB.empty?
          for i in 0..274
            if crafts[i][1]==@itemA&&crafts[i][2]==@itemB&&crafts[i][3]==@itemC
              @currentArray=i
              @returnItem=crafts[i][0]
              @required[2]=crafts[i][2]
            end
            if crafts[i][2]!=@itemA && @itemA==:NO
              @itemA=:NO
              @quantA=0
            end
            if crafts[i][2]!=@itemC && @itemC==:NO
              @itemC=:NO
              @quantC=0
            end
          end 
		  else
		  @itemB=:NO
		  end
        elsif @selection==2
          @returnItem=:NO
          @itemC=Kernel.pbChooseItem
		  crafts = CraftsList2.getcrafts2
		  if !@itemC.empty?
          for i in 0..274
            if crafts[i][1]==@itemA&&crafts[i][2]==@itemB&&crafts[i][3]==@itemC
              @currentArray=i
              @returnItem=crafts[i][0]
              @required[3]=crafts[i][3]
            end
            if crafts[i][2]!=@itemA && @itemA==:NO
              @itemA=:NO
              @quantA=0
            end
            if crafts[i][2]!=@itemB && @itemB==:NO
              @itemB=:NO
              @quantB=0
            end
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
	  if Input.trigger?(Input::SPECIAL)
 		     pbMessage(_INTL("Crafts 0:{1}, Item D: {2}",crafts[i][0],@returnItem))
 		     pbMessage(_INTL("Crafts 1:{1}, Item A: {2}",crafts[i][1],@itemA))
 		     pbMessage(_INTL("Crafts 2:{1}, Item B: {2}",crafts[i][2],@itemB))
 		     pbMessage(_INTL("Crafts 3:{1}, Item C: {2}",crafts[i][3],@itemC))
	  end
    end
  end
  
  def pbCheckRecipe2(recipe)
    for i in 0..274
      if recipe[1]==CraftsList2.getcrafts2[i][1] &&
         recipe[2]==CraftsList2.getcrafts2[i][2] &&
         recipe[3]==CraftsList2.getcrafts2[i][3]
       return true
      end
    end
   return false
   Kernel.pbMessage(_INTL("Nope! {1}",recipe[0]))
  end
  
end



class PokemoncraftSelect2
  attr_accessor :lastcraft
  attr_reader :crafts
  def numChars()
    return Crafts_Scene2.CraftsList2().length-1
  end
  def initialize
    @lastcraft=1
    @crafts=[]
    @choices=[]
    # Initialize each playerCharacter of the array
    for i in 0..Crafts_Scene2.CraftsList2
      @crafts[i]=[]
      @choices[i]=0
    end
  end
  def crafts
    rearrange()
    return @crafts
  end

  def rearrange()
    if @crafts.length==6 && Crafts_Scene2.CraftsList2==28
      newcrafts=[]
      for i in 0..28
        newcrafts[i]=[]
        @choices[i]=0 if !@choices[i]
      end
      @crafts=newcrafts
    end
  end
end

module CraftsList2
  def self.getcrafts2
    @CraftsList2 = [
	#[RESULT = Item 1 + Item 2 + Item 3]
    [:NO,:NO,:NO,:NO], #Empty
    #RECIPE 1: ,
    [:POKEBALL,:NO,:REDAPRICORN,:NO],  
    [:POKEBALL,:NO,:NO,:REDAPRICORN],  
    [:POKEBALL,:NO,:NO,:REDAPRICORN],  
    [:POKEBALL,:NO,:REDAPRICORN,:NO], 
    [:POKEBALL,:REDAPRICORN,:NO,:NO],  
    [:POKEBALL,:REDAPRICORN,:NO,:NO],  
    #RECIPE 2: 
    [:GREATBALL,:NO,:POKEBALL,:BLUEAPRICORN],  
    [:GREATBALL,:NO,:BLUEAPRICORN,:POKEBALL],  
    [:GREATBALL,:BLUEAPRICORN,:NO,:POKEBALL],  
    [:GREATBALL,:BLUEAPRICORN,:POKEBALL,:NO],  
    [:GREATBALL,:POKEBALL,:NO,:BLUEAPRICORN],  
    [:GREATBALL,:POKEBALL,:BLUEAPRICORN,:NO],  
    #RECIPE 3: 
    [:ULTRABALL,:POKEBALL,:YELLOWAPRICORN,:IRON2],  
    [:ULTRABALL,:POKEBALL,:IRON2,:YELLOWAPRICORN],  
    [:ULTRABALL,:YELLOWAPRICORN,:IRON2,:POKEBALL],  
    [:ULTRABALL,:YELLOWAPRICORN,:POKEBALL,:IRON2],  
    [:ULTRABALL,:IRON2,:YELLOWAPRICORN,:POKEBALL],  
    [:ULTRABALL,:IRON2,:POKEBALL,:YELLOWAPRICORN], 
    #RECIPE 4:  
    [:SUPERBALL,:BLACKAPRICORN,:POKEBALL,:SILVER2],  
    [:SUPERBALL,:BLACKAPRICORN,:POKEBALL,:SILVER2],  
    [:SUPERBALL,:SILVER2,:POKEBALL,:BLACKAPRICORN],  
    [:SUPERBALL,:SILVER2,:BLACKAPRICORN,:POKEBALL],  
    [:SUPERBALL,:POKEBALL,:BLACKAPRICORN,:SILVER2],  
    [:SUPERBALL,:POKEBALL,:SILVER2,:BLACKAPRICORN], 
    #RECIPE 5:  
    [:PREMIERBALL,:POKEBALL,:NO,:WHITEAPRICORN],  
    [:PREMIERBALL,:POKEBALL,:NO,:WHITEAPRICORN],  
    [:PREMIERBALL,:WHITEAPRICORN,:NO,:POKEBALL],  
    [:PREMIERBALL,:WHITEAPRICORN,:POKEBALL,:NO],  
    [:PREMIERBALL,:NO,:POKEBALL,:WHITEAPRICORN],  
    [:PREMIERBALL,:NO,:WHITEAPRICORN,:POKEBALL], 
    #RECIPE 6: 
    [:MASTERBALL,:NO,:PURPLEAPRICORN,:COCOABEANS],
    [:MASTERBALL,:NO,:COCOABEANS,:PURPLEAPRICORN],
    [:MASTERBALL,:PURPLEAPRICORN,:NO,:COCOABEANS],
    [:MASTERBALL,:PURPLEAPRICORN,:COCOABEANS,:NO],
    [:MASTERBALL,:COCOABEANS,:NO,:PURPLEAPRICORN],
    [:MASTERBALL,:COCOABEANS,:PURPLEAPRICORN,:NO],
    #RECIPE 7: 
    [:GSCURRY,:MEAT,:STARFBERRY,:WATERBOTTLE],
    [:GSCURRY,:MEAT,:WATERBOTTLE,:STARFBERRY],
    [:GSCURRY,:WATERBOTTLE,:STARFBERRY,:MEAT],
    [:GSCURRY,:WATERBOTTLE,:MEAT,:STARFBERRY],
    [:GSCURRY,:STARFBERRY,:WATERBOTTLE,:MEAT],
    [:GSCURRY,:STARFBERRY,:MEAT,:WATERBOTTLE],
    #RECIPE 8: 
    [:CRITCURRY,:MEAT,:LANSATBERRY,:WATERBOTTLE],
    [:CRITCURRY,:MEAT,:WATERBOTTLE,:LANSATBERRY],
    [:CRITCURRY,:WATERBOTTLE,:LANSATBERRY,:MEAT],
    [:CRITCURRY,:WATERBOTTLE,:MEAT,:LANSATBERRY],
    [:CRITCURRY,:LANSATBERRY,:WATERBOTTLE,:MEAT],
    [:CRITCURRY,:LANSATBERRY,:MEAT,:WATERBOTTLE],
    #RECIPE 9: 
    [:DEFCURRY,:MEAT,:BELUEBERRY,:WATERBOTTLE],
    [:DEFCURRY,:MEAT,:WATERBOTTLE,:BELUEBERRY],
    [:DEFCURRY,:WATERBOTTLE,:BELUEBERRY,:MEAT],
    [:DEFCURRY,:WATERBOTTLE,:MEAT,:BELUEBERRY],
    [:DEFCURRY,:BELUEBERRY,:WATERBOTTLE,:MEAT],
    [:DEFCURRY,:BELUEBERRY,:MEAT,:WATERBOTTLE],
    #RECIPE 10: 
    [:ACCCURRY,:MEAT,:MICLEBERRY,:WATERBOTTLE],
    [:ACCCURRY,:MEAT,:WATERBOTTLE,:MICLEBERRY],
    [:ACCCURRY,:WATERBOTTLE,:MICLEBERRY,:MEAT],
    [:ACCCURRY,:WATERBOTTLE,:MEAT,:MICLEBERRY],
    [:ACCCURRY,:MICLEBERRY,:WATERBOTTLE,:MEAT],
    [:ACCCURRY,:MICLEBERRY,:MEAT,:WATERBOTTLE],
    #RECIPE 11: 
    [:SPDEFCURRY,:MEAT,:DURINBERRY,:WATERBOTTLE],
    [:SPDEFCURRY,:MEAT,:WATERBOTTLE,:DURINBERRY],
    [:SPDEFCURRY,:WATERBOTTLE,:DURINBERRY,:MEAT],
    [:SPDEFCURRY,:WATERBOTTLE,:MEAT,:DURINBERRY],
    [:SPDEFCURRY,:DURINBERRY,:WATERBOTTLE,:MEAT],
    [:SPDEFCURRY,:DURINBERRY,:MEAT,:WATERBOTTLE],
    #RECIPE 12: 
    [:SPEEDCURRY,:MEAT,:WATMELBERRY,:WATERBOTTLE],
    [:SPEEDCURRY,:MEAT,:WATERBOTTLE,:WATMELBERRY],
    [:SPEEDCURRY,:WATERBOTTLE,:WATMELBERRY,:MEAT],
    [:SPEEDCURRY,:WATERBOTTLE,:MEAT,:WATMELBERRY],
    [:SPEEDCURRY,:WATMELBERRY,:WATERBOTTLE,:MEAT],
    [:SPEEDCURRY,:WATMELBERRY,:MEAT,:WATERBOTTLE],
    #RECIPE 13: 
    [:SATKCURRY,:MEAT,:KELPSYBERRY,:WATERBOTTLE],
    [:SATKCURRY,:MEAT,:WATERBOTTLE,:KELPSYBERRY],
    [:SATKCURRY,:WATERBOTTLE,:KELPSYBERRY,:MEAT],
    [:SATKCURRY,:WATERBOTTLE,:MEAT,:KELPSYBERRY],
    [:SATKCURRY,:KELPSYBERRY,:WATERBOTTLE,:MEAT],
    [:SATKCURRY,:KELPSYBERRY,:MEAT,:WATERBOTTLE],
    #RECIPE 14: 
    [:ATKCURRY,:MEAT,:SPELONBERRY,:WATERBOTTLE],
    [:ATKCURRY,:MEAT,:WATERBOTTLE,:SPELONBERRY],
    [:ATKCURRY,:WATERBOTTLE,:SPELONBERRY,:MEAT],
    [:ATKCURRY,:WATERBOTTLE,:MEAT,:SPELONBERRY],
    [:ATKCURRY,:SPELONBERRY,:WATERBOTTLE,:MEAT],
    [:ATKCURRY,:SPELONBERRY,:MEAT,:WATERBOTTLE],
    #RECIPE 15: 
    [:LONELYMINT,:SUGAR,:PAMTREBERRY,:NO],
    [:LONELYMINT,:SUGAR,:NO,:PAMTREBERRY],
    [:LONELYMINT,:NO,:PAMTREBERRY,:SUGAR],
    [:LONELYMINT,:NO,:SUGAR,:PAMTREBERRY],
    [:LONELYMINT,:PAMTREBERRY,:NO,:SUGAR],
    [:LONELYMINT,:PAMTREBERRY,:SUGAR,:NO],
    #RECIPE 16: 
    [:ADAMANTMINT,:SUGAR,:YACHEBERRY,:NO],
    [:ADAMANTMINT,:SUGAR,:NO,:YACHEBERRY],
    [:ADAMANTMINT,:NO,:YACHEBERRY,:SUGAR],
    [:ADAMANTMINT,:NO,:SUGAR,:YACHEBERRY],
    [:ADAMANTMINT,:YACHEBERRY,:NO,:SUGAR],
    [:ADAMANTMINT,:YACHEBERRY,:SUGAR,:NO],
    #RECIPE 17: 
    [:NAUGHTYMINT,:SUGAR,:TANGABERRY,:NO],
    [:NAUGHTYMINT,:SUGAR,:NO,:TANGABERRY],
    [:NAUGHTYMINT,:NO,:TANGABERRY,:SUGAR],
    [:NAUGHTYMINT,:NO,:SUGAR,:TANGABERRY],
    [:NAUGHTYMINT,:TANGABERRY,:NO,:SUGAR],
    [:NAUGHTYMINT,:TANGABERRY,:SUGAR,:NO],
    #RECIPE 18: 
    [:BRAVEMINT,:SUGAR,:KASIBBERRY,:NO],
    [:BRAVEMINT,:SUGAR,:NO,:KASIBBERRY],
    [:BRAVEMINT,:NO,:KASIBBERRY,:SUGAR],
    [:BRAVEMINT,:NO,:SUGAR,:KASIBBERRY],
    [:BRAVEMINT,:KASIBBERRY,:NO,:SUGAR],
    [:BRAVEMINT,:KASIBBERRY,:SUGAR,:NO],
    #RECIPE 19: 
    [:BOLDMINT,:SUGAR,:GANLONBERRY,:NO],
    [:BOLDMINT,:SUGAR,:NO,:GANLONBERRY],
    [:BOLDMINT,:NO,:GANLONBERRY,:SUGAR],
    [:BOLDMINT,:NO,:SUGAR,:GANLONBERRY],
    [:BOLDMINT,:GANLONBERRY,:NO,:SUGAR],
    [:BOLDMINT,:GANLONBERRY,:SUGAR,:NO],
    #RECIPE 20: 
    [:IMPISHMINT,:SUGAR,:COBABERRY,:NO],
    [:IMPISHMINT,:SUGAR,:NO,:COBABERRY],
    [:IMPISHMINT,:NO,:COBABERRY,:SUGAR],
    [:IMPISHMINT,:NO,:SUGAR,:COBABERRY],
    [:IMPISHMINT,:COBABERRY,:NO,:SUGAR],
    [:IMPISHMINT,:COBABERRY,:SUGAR,:NO],
    #RECIPE 21: 
    [:LAXMINT,:SUGAR,:WHEAT,:NO],
    [:LAXMINT,:SUGAR,:NO,:WHEAT],
    [:LAXMINT,:NO,:WHEAT,:SUGAR],
    [:LAXMINT,:NO,:SUGAR,:WHEAT],
    [:LAXMINT,:WHEAT,:NO,:SUGAR],
    [:LAXMINT,:WHEAT,:SUGAR,:NO],
    #RECIPE 22: 
    [:RELAXEDMINT,:SUGAR,:CORNNBERRY,:NO],
    [:RELAXEDMINT,:SUGAR,:NO,:CORNNBERRY],
    [:RELAXEDMINT,:NO,:CORNNBERRY,:SUGAR],
    [:RELAXEDMINT,:NO,:SUGAR,:CORNNBERRY],
    [:RELAXEDMINT,:CORNNBERRY,:NO,:SUGAR],
    [:RELAXEDMINT,:CORNNBERRY,:SUGAR,:NO],
    #RECIPE 23: 
    [:MODESTMINT,:SUGAR,:FIGYBERRY,:NO],
    [:MODESTMINT,:SUGAR,:NO,:FIGYBERRY],
    [:MODESTMINT,:NO,:FIGYBERRY,:SUGAR],
    [:MODESTMINT,:NO,:SUGAR,:FIGYBERRY],
    [:MODESTMINT,:FIGYBERRY,:NO,:SUGAR],
    [:MODESTMINT,:FIGYBERRY,:SUGAR,:NO],
    #RECIPE 24: 
    [:MILDMINT,:SUGAR,:WEPEARBERRY,:NO],
    [:MILDMINT,:SUGAR,:NO,:WEPEARBERRY],
    [:MILDMINT,:NO,:WEPEARBERRY,:SUGAR],
    [:MILDMINT,:NO,:SUGAR,:WEPEARBERRY],
    [:MILDMINT,:WEPEARBERRY,:NO,:SUGAR],
    [:MILDMINT,:WEPEARBERRY,:SUGAR,:NO],
    #RECIPE 25: 
    [:RASHMINT,:SUGAR,:GREPABERRY,:NO],
    [:RASHMINT,:SUGAR,:NO,:GREPABERRY],
    [:RASHMINT,:NO,:GREPABERRY,:SUGAR],
    [:RASHMINT,:NO,:SUGAR,:GREPABERRY],
    [:RASHMINT,:GREPABERRY,:NO,:SUGAR],
    [:RASHMINT,:GREPABERRY,:SUGAR,:NO],
    #RECIPE 26: 
    [:QUIETMINT,:SUGAR,:APPLE,:NO],
    [:QUIETMINT,:SUGAR,:NO,:APPLE],
    [:QUIETMINT,:NO,:APPLE,:SUGAR],
    [:QUIETMINT,:NO,:SUGAR,:APPLE],
    [:QUIETMINT,:APPLE,:NO,:SUGAR],
    [:QUIETMINT,:APPLE,:SUGAR,:NO],
    #RECIPE 27: 
    [:CALMMINT,:SUGAR,:BLUKBERRY,:NO],
    [:CALMMINT,:SUGAR,:NO,:BLUKBERRY],
    [:CALMMINT,:NO,:BLUKBERRY,:SUGAR],
    [:CALMMINT,:NO,:SUGAR,:BLUKBERRY],
    [:CALMMINT,:BLUKBERRY,:NO,:SUGAR],
    [:CALMMINT,:BLUKBERRY,:SUGAR,:NO],
    #RECIPE 28: 
    [:GENTLEMINT,:SUGAR,:SPELONBERRY,:NO],
    [:GENTLEMINT,:SUGAR,:NO,:SPELONBERRY],
    [:GENTLEMINT,:NO,:SPELONBERRY,:SUGAR],
    [:GENTLEMINT,:NO,:SUGAR,:SPELONBERRY],
    [:GENTLEMINT,:SPELONBERRY,:NO,:SUGAR],
    [:GENTLEMINT,:SPELONBERRY,:SUGAR,:NO],
    #RECIPE 29: 
    [:CAREFULMINT,:SUGAR,:TAMATOBERRY,:NO],
    [:CAREFULMINT,:SUGAR,:NO,:TAMATOBERRY],
    [:CAREFULMINT,:NO,:TAMATOBERRY,:SUGAR],
    [:CAREFULMINT,:NO,:SUGAR,:TAMATOBERRY],
    [:CAREFULMINT,:TAMATOBERRY,:NO,:SUGAR],
    [:CAREFULMINT,:TAMATOBERRY,:SUGAR,:NO],
    #RECIPE 30: 
    [:SASSYMINT,:SUGAR,:PINAPBERRY,:NO],
    [:SASSYMINT,:SUGAR,:NO,:PINAPBERRY],
    [:SASSYMINT,:NO,:PINAPBERRY,:SUGAR],
    [:SASSYMINT,:NO,:SUGAR,:PINAPBERRY],
    [:SASSYMINT,:PINAPBERRY,:NO,:SUGAR],
    [:SASSYMINT,:PINAPBERRY,:SUGAR,:NO],
    #RECIPE 31: 
    [:TIMIDMINT,:SUGAR,:POMEGBERRY,:NO],
    [:TIMIDMINT,:SUGAR,:NO,:POMEGBERRY],
    [:TIMIDMINT,:NO,:POMEGBERRY,:SUGAR],
    [:TIMIDMINT,:NO,:SUGAR,:POMEGBERRY],
    [:TIMIDMINT,:POMEGBERRY,:NO,:SUGAR],
    [:TIMIDMINT,:POMEGBERRY,:SUGAR,:NO],
    #RECIPE 32: 
    [:HASTYMINT,:SUGAR,:WIKIBERRY,:NO],
    [:HASTYMINT,:SUGAR,:NO,:WIKIBERRY],
    [:HASTYMINT,:NO,:WIKIBERRY,:SUGAR],
    [:HASTYMINT,:NO,:SUGAR,:WIKIBERRY],
    [:HASTYMINT,:WIKIBERRY,:NO,:SUGAR],
    [:HASTYMINT,:WIKIBERRY,:SUGAR,:NO],
    #RECIPE 33: 
    [:JOLLYMINT,:SUGAR,:CHERIBERRY,:NO],
    [:JOLLYMINT,:SUGAR,:NO,:CHERIBERRY],
    [:JOLLYMINT,:NO,:CHERIBERRY,:SUGAR],
    [:JOLLYMINT,:NO,:SUGAR,:CHERIBERRY],
    [:JOLLYMINT,:CHERIBERRY,:NO,:SUGAR],
    [:JOLLYMINT,:CHERIBERRY,:SUGAR,:NO],
    #RECIPE 34: 
    [:NAIVEMINT,:SUGAR,:STARFBERRY,:NO],
    [:NAIVEMINT,:SUGAR,:NO,:STARFBERRY],
    [:NAIVEMINT,:NO,:STARFBERRY,:SUGAR],
    [:NAIVEMINT,:NO,:SUGAR,:STARFBERRY],
    [:NAIVEMINT,:STARFBERRY,:NO,:SUGAR],
    [:NAIVEMINT,:STARFBERRY,:SUGAR,:NO],
    #RECIPE 35: 
    [:SERIOUSMINT,:SUGAR,:JABOCABERRY,:NO],
    [:SERIOUSMINT,:SUGAR,:NO,:JABOCABERRY],
    [:SERIOUSMINT,:NO,:JABOCABERRY,:SUGAR],
    [:SERIOUSMINT,:NO,:SUGAR,:JABOCABERRY],
    [:SERIOUSMINT,:JABOCABERRY,:NO,:SUGAR],
    [:SERIOUSMINT,:JABOCABERRY,:SUGAR,:NO],
	#RECIPE 36:
    [:BERRYMASH,:ORANBERRY,:SITRUSBERRY,:SITRUSBERRY],
    [:BERRYMASH,:SITRUSBERRY,:ORANBERRY,:SITRUSBERRY],
    [:BERRYMASH,:SITRUSBERRY,:SITRUSBERRY,:ORANBERRY],
    [:BERRYMASH,:SITRUSBERRY,:ORANBERRY,:SITRUSBERRY],
    [:BERRYMASH,:ORANBERRY,:SITRUSBERRY,:SITRUSBERRY],
	#RECIPE 36:
    [:SITRUSJUICE,:SUGAR,:BERRYMASH,:WATERBOTTLE],
    [:SITRUSJUICE,:SUGAR,:WATERBOTTLE,:BERRYMASH],
    [:SITRUSJUICE,:WATERBOTTLE,:BERRYMASH,:SUGAR],
    [:SITRUSJUICE,:WATERBOTTLE,:SUGAR,:BERRYMASH],
    [:SITRUSJUICE,:BERRYMASH,:WATERBOTTLE,:SUGAR],
    [:SITRUSJUICE,:BERRYMASH,:SUGAR,:WATERBOTTLE],
	#RECIPE 37:
    [:FRESHWATER,:WATER,:CHARCOAL,:NO],
    [:FRESHWATER,:WATER,:NO,:CHARCOAL],
    [:FRESHWATER,:NO,:WATER,:CHARCOAL],
    [:FRESHWATER,:WATER,:NO,:CHARCOAL],
    [:FRESHWATER,:CHARCOAL,:WATER,:NO],
    [:FRESHWATER,:CHARCOAL,:NO,:WATER,],
	#RECIPE 37:
    [:SUSPO,:ARGOSTBERRY,:WATERBOTTLE,:ENIGMABERRY],
    [:SUSPO,:ARGOSTBERRY,:ENIGMABERRY,:WATERBOTTLE],
    [:SUSPO,:ENIGMABERRY,:ARGOSTBERRY,:WATERBOTTLE],
    [:SUSPO,:ARGOSTBERRY,:ENIGMABERRY,:WATERBOTTLE],
    [:SUSPO,:WATERBOTTLE,:ARGOSTBERRY,:ENIGMABERRY],
    [:SUSPO,:WATERBOTTLE,:ENIGMABERRY,:ARGOSTBERRY,],
	#RECIPE 37:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:ATKCURRY],
    [:LARGEMEAL,:BAKEDPOTATO,:ATKCURRY,:TEA],
    [:LARGEMEAL,:ATKCURRY,:BAKEDPOTATO,:TEA],
    [:LARGEMEAL,:BAKEDPOTATO,:ATKCURRY,:TEA],
    [:LARGEMEAL,:TEA,:BAKEDPOTATO,:ATKCURRY],
    [:LARGEMEAL,:TEA,:ATKCURRY,:BAKEDPOTATO,],
	#RECIPE 37:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:SATKCURRY],
    [:LARGEMEAL,:BAKEDPOTATO,:SATKCURRY,:TEA],
    [:LARGEMEAL,:SATKCURRY,:BAKEDPOTATO,:TEA],
    [:LARGEMEAL,:BAKEDPOTATO,:SATKCURRY,:TEA],
    [:LARGEMEAL,:TEA,:BAKEDPOTATO,:SATKCURRY],
    [:LARGEMEAL,:TEA,:SATKCURRY,:BAKEDPOTATO,],
	#RECIPE 37:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:SPEEDCURRY],
    [:LARGEMEAL,:BAKEDPOTATO,:SPEEDCURRY,:TEA],
    [:LARGEMEAL,:SPEEDCURRY,:BAKEDPOTATO,:TEA],
    [:LARGEMEAL,:BAKEDPOTATO,:SPEEDCURRY,:TEA],
    [:LARGEMEAL,:TEA,:BAKEDPOTATO,:SPEEDCURRY],
    [:LARGEMEAL,:TEA,:SPEEDCURRY,:BAKEDPOTATO,],
	#RECIPE 37:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:SPDEFCURRY],
    [:LARGEMEAL,:BAKEDPOTATO,:SPDEFCURRY,:TEA],
    [:LARGEMEAL,:SPDEFCURRY,:BAKEDPOTATO,:TEA],
    [:LARGEMEAL,:BAKEDPOTATO,:SPDEFCURRY,:TEA],
    [:LARGEMEAL,:TEA,:BAKEDPOTATO,:SPDEFCURRY],
    [:LARGEMEAL,:TEA,:SPDEFCURRY,:BAKEDPOTATO,],
	#RECIPE 37:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:ACCCURRY],
    [:LARGEMEAL,:BAKEDPOTATO,:ACCCURRY,:TEA],
    [:LARGEMEAL,:ACCCURRY,:BAKEDPOTATO,:TEA],
    [:LARGEMEAL,:BAKEDPOTATO,:ACCCURRY,:TEA],
    [:LARGEMEAL,:TEA,:BAKEDPOTATO,:ACCCURRY],
    [:LARGEMEAL,:TEA,:ACCCURRY,:BAKEDPOTATO,],
	#RECIPE 37:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:DEFCURRY],
    [:LARGEMEAL,:BAKEDPOTATO,:DEFCURRY,:TEA],
    [:LARGEMEAL,:DEFCURRY,:BAKEDPOTATO,:TEA],
    [:LARGEMEAL,:BAKEDPOTATO,:DEFCURRY,:TEA],
    [:LARGEMEAL,:TEA,:BAKEDPOTATO,:DEFCURRY],
    [:LARGEMEAL,:TEA,:DEFCURRY,:BAKEDPOTATO,],
	#RECIPE 37:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:CRITCURRY],
    [:LARGEMEAL,:BAKEDPOTATO,:CRITCURRY,:TEA],
    [:LARGEMEAL,:CRITCURRY,:BAKEDPOTATO,:TEA],
    [:LARGEMEAL,:BAKEDPOTATO,:CRITCURRY,:TEA],
    [:LARGEMEAL,:TEA,:BAKEDPOTATO,:CRITCURRY],
    [:LARGEMEAL,:TEA,:CRITCURRY,:BAKEDPOTATO,],
	#RECIPE 37:
    [:LARGEMEAL,:BAKEDPOTATO,:TEA,:GSCURRY],
    [:LARGEMEAL,:BAKEDPOTATO,:GSCURRY,:TEA],
    [:LARGEMEAL,:GSCURRY,:BAKEDPOTATO,:TEA],
    [:LARGEMEAL,:BAKEDPOTATO,:GSCURRY,:TEA],
    [:LARGEMEAL,:TEA,:BAKEDPOTATO,:GSCURRY],
    [:LARGEMEAL,:TEA,:GSCURRY,:BAKEDPOTATO,]
    ]
    return @CraftsList2
  end
end

#Call Crafts.craftWindow
module Crafts  
  def self.craftWindow2()
  craftScene=Crafts_Scene2.new
  craftScene.pbStartScene($PokemoncraftSelect2)
  craft=craftScene.pbSelectcraft2
  craftScene.pbEndScene
 end
end