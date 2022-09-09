###---craftS
class Reincarnation
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
  
  def pbStartScene
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @selection=0
    @reincarnpkmn=0
    @donApkmn=0
    @donBpkmn=0
    @reincarnpkmnsp=0
    @donApkmnsp=0
    @donBpkmnsp=0
    @pkmnnat1=0
    @pkmnnat2=0
    @pkmniv=0
    @sprites={}
    @icons={}
    @required=[]
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/Reincarnation/Reincarnation")
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    coord=0
    @imagepos=[]
    @selectX=100
    @selectY=168
    @sprites["selector"]=IconSprite.new(@selectX,@selectY,@viewport)
    @sprites["selector"].setBitmap("Graphics/Pictures/craftingMenu/craftSelect")
    @sprites["selector"].visible=false
    pbDeactivateWindows(@sprites)
    pbRefresh
    pbFadeInAndShow(@sprites)
    filenamA="Graphics/Pictures/Reincarnation/begin"
    @sprites["begin"]=IconSprite.new(356,340,@viewport)
    @sprites["begin"].setBitmap(filenamA)
    @sprites["begin"].visible = false
    
    filenamB="Graphics/Pictures/Reincarnation/ivs"
    @sprites["ivs"]=IconSprite.new(366,285,@viewport)
    @sprites["ivs"].setBitmap(filenamB)
    @sprites["ivs"].visible = true
    
    filenamC="Graphics/Pictures/Reincarnation/nature"
    @sprites["nature1"]=IconSprite.new(366,185,@viewport)
    @sprites["nature1"].setBitmap(filenamC)
    @sprites["nature1"].visible = true
    @sprites["nature2"]=IconSprite.new(366,235,@viewport)
    @sprites["nature2"].setBitmap(filenamC)
    @sprites["nature2"].visible = true
    
    filenamD="Graphics/Pictures/Reincarnation/reincarnator"
    @sprites["reincarnator"]=IconSprite.new(366,35,@viewport)
    @sprites["reincarnator"].setBitmap(filenamD)
    @sprites["reincarnator"].visible = true
    
    filenamE="Graphics/Pictures/Reincarnation/donator"
    @sprites["donatorA"]=IconSprite.new(366,85,@viewport)
    @sprites["donatorA"].setBitmap(filenamE)
    @sprites["donatorA"].visible = true
    @sprites["donatorB"]=IconSprite.new(366,135,@viewport)
    @sprites["donatorB"].setBitmap(filenamE)
    @sprites["donatorB"].visible = true
	

    filenamB="Graphics/Pictures/Reincarnation/ivsexpand"
    @sprites["ivse"]=IconSprite.new(366,235,@viewport)
    @sprites["ivse"].setBitmap(filenamB)
    @sprites["ivse"].visible = false
    
    filenamC="Graphics/Pictures/Reincarnation/natureexpand"
    @sprites["nature1e"]=IconSprite.new(366,185,@viewport)
    @sprites["nature1e"].setBitmap(filenamC)
    @sprites["nature1e"].visible = false
    @sprites["nature2e"]=IconSprite.new(366,235,@viewport)
    @sprites["nature2e"].setBitmap(filenamC)
    @sprites["nature2e"].visible = false
    
    filenamD="Graphics/Pictures/Reincarnation/reincarnatorexpand"
    @sprites["reincarnatore"]=IconSprite.new(366,35,@viewport)
    @sprites["reincarnatore"].setBitmap(filenamD)
    @sprites["reincarnatore"].visible = true
    
    filenamE="Graphics/Pictures/Reincarnation/donatorexpand"
    @sprites["donatorAe"]=IconSprite.new(366,85,@viewport)
    @sprites["donatorAe"].setBitmap(filenamE)
    @sprites["donatorAe"].visible = false
    @sprites["donatorBe"]=IconSprite.new(366,135,@viewport)
    @sprites["donatorBe"].setBitmap(filenamE)
    @sprites["donatorBe"].visible = false
	
    @sprites["A"]=Window_UnformattedTextPokemon.new("")
    @sprites["B"]=Window_UnformattedTextPokemon.new("")
    @sprites["C"]=Window_UnformattedTextPokemon.new("")
    @sprites["D"]=Window_UnformattedTextPokemon.new("")
    @sprites["E"]=Window_UnformattedTextPokemon.new("")
    @sprites["F"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["A"])
    @sprites["A"].x=422
    @sprites["A"].y=35
    @sprites["A"].width=Graphics.width-48
    @sprites["A"].height=Graphics.height
    @sprites["A"].baseColor=Color.new(240,240,240)
    @sprites["A"].shadowColor=Color.new(40,40,40)
    @sprites["A"].visible=true
    @sprites["A"].viewport=@viewport
    @sprites["A"].windowskin=nil
    pbPrepareWindow(@sprites["B"])
    @sprites["B"].x=422
    @sprites["B"].y=85
    @sprites["B"].width=Graphics.width-48
    @sprites["B"].height=Graphics.height
    @sprites["B"].baseColor=Color.new(240,240,240)
    @sprites["B"].shadowColor=Color.new(40,40,40)
    @sprites["B"].visible=false
    @sprites["B"].viewport=@viewport
    @sprites["B"].windowskin=nil
    pbPrepareWindow(@sprites["C"])
    @sprites["C"].x=422
    @sprites["C"].y=135
    @sprites["C"].width=Graphics.width-48
    @sprites["C"].height=Graphics.height
    @sprites["C"].baseColor=Color.new(240,240,240)
    @sprites["C"].shadowColor=Color.new(40,40,40)
    @sprites["C"].visible=false
    @sprites["C"].viewport=@viewport
    @sprites["C"].windowskin=nil
    pbPrepareWindow(@sprites["D"])
    @sprites["D"].x=422
    @sprites["D"].y=185
    @sprites["D"].width=Graphics.width-48
    @sprites["D"].height=Graphics.height
    @sprites["D"].baseColor=Color.new(240,240,240)
    @sprites["D"].shadowColor=Color.new(40,40,40)
    @sprites["D"].visible=true
    @sprites["D"].viewport=@viewport
    @sprites["D"].windowskin=nil
    pbPrepareWindow(@sprites["E"])
    @sprites["E"].x=422
    @sprites["E"].y=235
    @sprites["E"].width=Graphics.width-48
    @sprites["E"].height=Graphics.height
    @sprites["E"].baseColor=Color.new(240,240,240)
    @sprites["E"].shadowColor=Color.new(40,40,40)
    @sprites["E"].visible=true
    @sprites["E"].viewport=@viewport
    @sprites["E"].windowskin=nil
    pbPrepareWindow(@sprites["F"])
    @sprites["F"].x=422
    @sprites["F"].y=285
    @sprites["F"].width=Graphics.width-48
    @sprites["F"].height=Graphics.height
    @sprites["F"].baseColor=Color.new(240,240,240)
    @sprites["F"].shadowColor=Color.new(40,40,40)
    @sprites["F"].visible=true
    @sprites["F"].viewport=@viewport
    @sprites["F"].windowskin=nil
  end

  def pbEndScene
    pbFadeOutAndHide(@icons)
    pbDisposeSpriteHash(@icons)

    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end


# Script that manages button inputs  
  def pbSelectreincarnation
    delay = 0
	i = 0
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    pbSetSystemFont(overlay)
    pbDrawImagePositions(overlay,@imagepos)
    while true
    Graphics.update
      Input.update
      self.update
    @sprites["selector"].x=@selectX
    @sprites["selector"].y=@selectY
    @sprites["A"].text=_INTL("{1}",@reincarnpkmn)
    @sprites["B"].text=_INTL("{1}",@donApkmn)
    @sprites["C"].text=_INTL("{1}",@donBpkmn)
    @sprites["D"].text=_INTL("{1}", @pkmnnat1)
    @sprites["E"].text=_INTL("{1}",@pkmnnat2)
    @sprites["F"].text=_INTL("{1}",@pkmniv)
	@sprites["A"].text=_INTL("Set",@reincarnpkmn) if @reincarnpkmn==0 ||  @reincarnpkmn==-1  ||  @reincarnpkmn==""  ||  @reincarnpkmn==nil
    @sprites["B"].text=_INTL("Set",@donApkmn) if @donApkmn==0 ||  @donApkmn==-1
    @sprites["C"].text=_INTL("Set",@donBpkmn) if @donBpkmn==0 ||  @donBpkmn==-1
    @sprites["D"].text=_INTL("Set", @pkmnnat1) if @pkmnnat1==0 ||  @pkmnnat1==-1
    @sprites["E"].text=_INTL("Set",@pkmnnat2) if @pkmnnat2==0 ||  @pkmnnat2==-1
    @sprites["F"].text=_INTL("Set",@pkmniv) if @pkmniv==0 ||  @pkmniv==-1
	  
      
      selectionNum=@selection
      if Input.trigger?(Input::UP)
	    if @selection==0 && @reincarnpkmn!=0 && @donApkmn!=0 && @donBpkmn!=0  && @pkmnnat1!=0 && @pkmnnat2!=0 && @pkmniv!=0
		  pbSEPlay("GUI party switch")
          @sprites["reincarnatore"].visible = false
          @selection=6
	    elsif @selection==0
		  pbSEPlay("GUI party switch")
          @selection=5
		  @sprites["ivse"].visible = true
          @sprites["reincarnatore"].visible = false
          @sprites["A"].visible=true
          @sprites["F"].visible=false
          @sprites["D"].visible=true
          @sprites["B"].visible=true
          @sprites["C"].visible=true
        elsif @selection==1
		  pbSEPlay("GUI party switch")
          @selection-=1
          @sprites["reincarnatore"].visible = true
          @sprites["donatorAe"].visible = false
          @sprites["A"].visible=true
          @sprites["B"].visible=false
          @sprites["C"].visible=false
          @sprites["E"].visible=true
        elsif @selection==2
		  pbSEPlay("GUI party switch")
          @sprites["donatorAe"].visible = true
          @sprites["donatorBe"].visible = false
          @sprites["B"].visible=true
          @sprites["C"].visible=false
          @sprites["D"].visible=false
          @sprites["F"].visible=true
          @selection-=1
        elsif @selection==3
		  pbSEPlay("GUI party switch")
          @sprites["donatorBe"].visible = true
          @sprites["nature1e"].visible = false
          @sprites["C"].visible=true
          @sprites["D"].visible=false
          @sprites["E"].visible=false
          @selection-=1
        elsif @selection==4
		  pbSEPlay("GUI party switch")
          @sprites["nature1e"].visible = true
          @sprites["nature2e"].visible = false
          @sprites["E"].visible=false
          @sprites["F"].visible=false
          @selection-=1
		elsif @selection==6
		  pbSEPlay("GUI party switch")
          @selection-=1
        else
		  pbSEPlay("GUI party switch")
          @sprites["nature2e"].visible = true
		  @sprites["ivse"].visible = false
          @sprites["D"].visible=true
          @selection-=1
        end
      end
      if Input.trigger?(Input::DOWN)
        if @selection==0
		  pbSEPlay("GUI party switch")
		  @sprites["reincarnatore"].visible = false
          @sprites["donatorAe"].visible = true
          @sprites["B"].visible=true
          @sprites["D"].visible=false
          @sprites["F"].visible=true
          @selection+=1
        elsif @selection==1
		  pbSEPlay("GUI party switch")
          @sprites["donatorAe"].visible = false
          @sprites["donatorBe"].visible = true
          @sprites["C"].visible=true
          @sprites["D"].visible=false
          @sprites["E"].visible=false
          @selection+=1
        elsif @selection==2
		  pbSEPlay("GUI party switch")
          @sprites["donatorBe"].visible = false
          @sprites["nature1e"].visible = true
          @sprites["D"].visible=true
          @sprites["F"].visible=false
          @selection+=1
        elsif @selection==3
		  pbSEPlay("GUI party switch")
          @sprites["nature1e"].visible = false
          @sprites["nature2e"].visible = true
          @sprites["E"].visible=true
          @selection+=1
        elsif @selection==4
		  pbSEPlay("GUI party switch")
          @sprites["nature2e"].visible = false
		  @sprites["ivse"].visible = true
          @sprites["F"].visible=false
          @selection+=1
		elsif @selection==5 && @reincarnpkmn!=0 && @donApkmn!=0 && @donBpkmn!=0  && @pkmnnat1!=0 && @pkmnnat2!=0 && @pkmniv!=0
		  @sprites["ivse"].visible = false
		  pbSEPlay("GUI party switch")
          @selection+=1
          @sprites["F"].visible=true
		elsif @selection==6
		  pbSEPlay("GUI party switch")
		  @sprites["reincarnatore"].visible = true
          @sprites["A"].visible=true
          @sprites["B"].visible=false
          @sprites["C"].visible=false
          @selection=0
        else
		  pbSEPlay("GUI party switch")
		  @sprites["ivse"].visible = false
		  @sprites["reincarnatore"].visible = true
          @sprites["A"].visible=true
          @sprites["B"].visible=false
          @sprites["C"].visible=false
          @sprites["F"].visible=true
          @selection=0
        end
      end
      if Input.trigger?(Input::ACTION)
        if @selection==0
		  pbChoosePokemon(1,3)
		  if @reincarnpkmnsp!= 0
          @sprites["icon_#{0}"].visible = false
		  @reincarnpkmnsp = 0
		  end
		  @reincarnpkmn = $game_variables[3]
		  if $game_variables[1] != -1
		  @reincarnpkmnsp = ($player.party[pbGet(1)].species_data).id
		  @sprites["icon_#{0}"] = PokemonSpeciesIconSprite.new(@reincarnpkmnsp,@viewport)
		  @sprites["icon_#{0}"].x = 116
		  @sprites["icon_#{0}"].y = 76
          @sprites["icon_#{0}"].visible = true
		  end
		  $game_variables[3] = 0
		  $game_variables[1] = 0
        elsif @selection==1
		  pbChoosePokemon(1,3)
		  if @donApkmnsp!= 0
          @sprites["icon_#{1}"].visible = false
		  @donApkmnsp = 0
		  end
		  @donApkmn = $game_variables[3]
		  if $game_variables[1] != -1
		  @donApkmnsp = ($player.party[pbGet(1)].species_data).id
		  @sprites["icon_#{1}"] = PokemonSpeciesIconSprite.new(@donApkmnsp,@viewport)
		  @sprites["icon_#{1}"].x = 50
		  @sprites["icon_#{1}"].y = 210
          @sprites["icon_#{1}"].visible = true
		  end
		  $game_variables[3] = 0
		  $game_variables[1] = 0
        elsif @selection==2
		  pbChoosePokemon(1,3)
		  if @donBpkmnsp != 0
          @sprites["icon_#{2}"].visible = false
		  @donBpkmnsp = 0
		  end
		  @donBpkmn = $game_variables[3]
		  if $game_variables[1] != -1
		  @donBpkmnsp = ($player.party[pbGet(1)].species_data).id
		  @sprites["icon_#{2}"] = PokemonSpeciesIconSprite.new(@donBpkmnsp,@viewport)
		  @sprites["icon_#{2}"].x = 177
		  @sprites["icon_#{2}"].y = 210
          @sprites["icon_#{2}"].visible = true
		  end
		  $game_variables[3] = 0
		  $game_variables[1] = 0
        elsif @selection==3
          pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
@pkmnnat1 = screen.pbChooseItemScreen
}
if @pkmnnat1 != nil
item = @pkmnnat1
@pkmnnat1 = GameData::Item.get(item).name
end
        elsif @selection==4
           pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
@pkmnnat2 = screen.pbChooseItemScreen
}
if @pkmnnat2 != nil
item = @pkmnnat2
@pkmnnat2 = GameData::Item.get(item).name
end
		elsif @selection==6
        else
          pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
@pkmniv = screen.pbChooseItemScreen
}
if @pkmniv != nil
item = @pkmniv
@pkmniv = GameData::Item.get(item).name
end
        end
      end
       #Cancel
      if Input.trigger?(Input::BACK)
        return -1
      end     
	  if Input.trigger?(Input::SPECIAL)
	  end
    end
  end
  
def pbRefresh
end



end

#Call Crafts.craftWindow
module Reincarnations  
  def self.reincarnationWindow
  reScene=Reincarnation.new
  reScene.pbStartScene
  recar=reScene.pbSelectreincarnation
  reScene.pbEndScene
 end
end