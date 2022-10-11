###---craftS
class Reincarnation_UI
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
	playingBGM = $game_system.playing_bgm
	if playingBGM != ReincarnationConfig::CUSTOM_MUSIC
    pbBGMPlay(ReincarnationConfig::CUSTOM_MUSIC)
	end
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @selection=0
    @reincarnpkmn=0
    @donApkmn=0
    @donBpkmn=0
    @pkmnnat1=0
    @pkmnnat2=0
    @pkmniv=0
    @reincarnpkmnsp=0
    @donApkmnsp=0
    @donBpkmnsp=0
    @pkmnnat1sp=0
    @pkmnnat2sp=0
    @pkmnivsp=0
    @pkmn1=false
    @pkmn2=false
    @pkmn3=false
    @sprites={}
    @icons={}
    @required=[]
	@inui = false
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap(ReincarnationConfig::CUSTOM_BG)
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    coord=0
    @imagepos=[]
    @selectX=100
    @selectY=168
    pbDeactivateWindows(@sprites)
    pbRefresh
	if ReincarnationConfig::CUSTOM_BG == "Graphics/Pictures/Reincarnation/ReincarnationBG"
    filenamSigil="Graphics/Pictures/Reincarnation/ReincarnationSigil"
    @sprites["sigil"]=IconSprite.new(-30,25,@viewport)
    @sprites["sigil"].setBitmap(filenamSigil)
    @sprites["sigil"].visible = true
    filenamReOrb="Graphics/Pictures/Reincarnation/ReincarnatorOrb"
    @sprites["ReOrb"]=IconSprite.new(122,91,@viewport)
    @sprites["ReOrb"].setBitmap(filenamReOrb)
    @sprites["ReOrb"].visible = true
    filenamDon1Orb="Graphics/Pictures/Reincarnation/Donator1Orb"
    @sprites["Don1Orb"]=IconSprite.new(65,210,@viewport)
    @sprites["Don1Orb"].setBitmap(filenamDon1Orb)
    @sprites["Don1Orb"].visible = true
    filenamDon2Orb="Graphics/Pictures/Reincarnation/Donator2Orb"
    @sprites["Don2Orb"]=IconSprite.new(178,210,@viewport)
    @sprites["Don2Orb"].setBitmap(filenamDon2Orb)
    @sprites["Don2Orb"].visible = true
    filenamItem1Orb="Graphics/Pictures/Reincarnation/item1orb"
    @sprites["Item1Orb"]=IconSprite.new(128,185,@viewport)
    @sprites["Item1Orb"].setBitmap(filenamItem1Orb)
    @sprites["Item1Orb"].visible = true
    filenamItem2Orb="Graphics/Pictures/Reincarnation/item2orb"
    @sprites["Item2Orb"]=IconSprite.new(91,87,@viewport)
    @sprites["Item2Orb"].setBitmap(filenamItem2Orb)
    @sprites["Item2Orb"].visible = true
    filenamItem3Orb="Graphics/Pictures/Reincarnation/item3orb"
    @sprites["Item3Orb"]=IconSprite.new(166,87,@viewport)
    @sprites["Item3Orb"].setBitmap(filenamItem3Orb)
    @sprites["Item3Orb"].visible = true
	end
	
    filenamBack="Graphics/Pictures/Reincarnation/ReincarnationBack"
    @sprites["back"]=IconSprite.new(0,0,@viewport)
    @sprites["back"].setBitmap(filenamBack)
    @sprites["back"].visible = true

	
    filenamA="Graphics/Pictures/Reincarnation/begin"
    #@sprites["begin"]=IconSprite.new(356,340,@viewport)
    @sprites["begin"]=IconSprite.new(356,338,@viewport)
    @sprites["begin"].setBitmap(filenamA)
    @sprites["begin"].visible = true
    
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
    @sprites["ivse"]=IconSprite.new(266,285,@viewport)
    @sprites["ivse"].setBitmap(filenamB)
    @sprites["ivse"].visible = false
    
    filenamC="Graphics/Pictures/Reincarnation/natureexpand"
    @sprites["nature1e"]=IconSprite.new(266,185,@viewport)
    @sprites["nature1e"].setBitmap(filenamC)
    @sprites["nature1e"].visible = false
    @sprites["nature2e"]=IconSprite.new(266,235,@viewport)
    @sprites["nature2e"].setBitmap(filenamC)
    @sprites["nature2e"].visible = false
    
    filenamD="Graphics/Pictures/Reincarnation/reincarnatorexpand"
    @sprites["reincarnatore"]=IconSprite.new(266,35,@viewport)
    @sprites["reincarnatore"].setBitmap(filenamD)
    @sprites["reincarnatore"].visible = true
    
    filenamE="Graphics/Pictures/Reincarnation/donatorexpand"
    @sprites["donatorAe"]=IconSprite.new(266,85,@viewport)
    @sprites["donatorAe"].setBitmap(filenamE)
    @sprites["donatorAe"].visible = false
    @sprites["donatorBe"]=IconSprite.new(266,135,@viewport)
    @sprites["donatorBe"].setBitmap(filenamE)
    @sprites["donatorBe"].visible = false
	
	if @pkmnnat1!=0
	filenamF =GameData::Item.icon_filename(@pkmnnat1) 
	else
	filenamF ="Graphics/Items/000"
	end
    @icons["itemResult1"]=IconSprite.new(275,185,@viewport)
    @icons["itemResult1"].setBitmap(filenamF)
    @icons["itemResult1"].visible=false
    @icons["itemResult4"]=IconSprite.new(114,87,@viewport)
    @icons["itemResult4"].setBitmap(filenamF)
    @icons["itemResult4"].visible=false
      
	if @pkmnnat2!=0
	filenamG =GameData::Item.icon_filename(@pkmnnat2) 
	else
	filenamG ="Graphics/Items/000"
	end
    @icons["itemResult2"]=IconSprite.new(275,235,@viewport)
    @icons["itemResult2"].setBitmap(filenamG)
    @icons["itemResult2"].visible=false
    @icons["itemResult5"]=IconSprite.new(114,87,@viewport)
    @icons["itemResult5"].setBitmap(filenamG)
    @icons["itemResult5"].visible=false
	
    if @pkmniv!=0
    filenamH =GameData::Item.icon_filename(@pkmniv)
	else
	filenamH ="Graphics/Items/000"
	end
    @icons["itemResult3"]=IconSprite.new(275,285,@viewport)
    @icons["itemResult3"].setBitmap(filenamH)
    @icons["itemResult3"].visible=false
    @icons["itemResult6"]=IconSprite.new(275,285,@viewport)
    @icons["itemResult6"].setBitmap(filenamH)
    @icons["itemResult6"].visible=false
      

	
    @sprites["A"]=Window_UnformattedTextPokemon.new("")
    @sprites["B"]=Window_UnformattedTextPokemon.new("")
    @sprites["C"]=Window_UnformattedTextPokemon.new("")
    @sprites["D"]=Window_UnformattedTextPokemon.new("")
    @sprites["E"]=Window_UnformattedTextPokemon.new("")
    @sprites["F"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["A"])
    @sprites["A"].x=315
    #@sprites["A"].y=35
    @sprites["A"].y=25
    @sprites["A"].width=Graphics.width-48
    @sprites["A"].height=Graphics.height
    @sprites["A"].baseColor=Color.new(240,240,240)
    @sprites["A"].shadowColor=Color.new(40,40,40)
    @sprites["A"].visible=true
    @sprites["A"].viewport=@viewport
    @sprites["A"].windowskin=nil
    pbPrepareWindow(@sprites["B"])
    #@sprites["B"].x=422
    @sprites["B"].x=366
    #@sprites["B"].y=85
    @sprites["B"].y=75
    @sprites["B"].width=Graphics.width-48    ## no effect when modified
    @sprites["B"].height=Graphics.height
    @sprites["B"].baseColor=Color.new(240,240,240)
    @sprites["B"].shadowColor=Color.new(40,40,40)
    @sprites["B"].visible=true
    @sprites["B"].viewport=@viewport
    @sprites["B"].windowskin=nil
    pbPrepareWindow(@sprites["C"])
    #@sprites["C"].x=422
    @sprites["C"].x=366
    #@sprites["C"].y=135
    @sprites["C"].y=125
    @sprites["C"].width=Graphics.width-48
    @sprites["C"].height=Graphics.height
    @sprites["C"].baseColor=Color.new(240,240,240)
    @sprites["C"].shadowColor=Color.new(40,40,40)
    @sprites["C"].visible=true
    @sprites["C"].viewport=@viewport
    @sprites["C"].windowskin=nil
    pbPrepareWindow(@sprites["D"])
    #@sprites["D"].x=422
    @sprites["D"].x=366
    #@sprites["D"].y=185
    @sprites["D"].y=175
    @sprites["D"].width=Graphics.width-48
    @sprites["D"].height=Graphics.height
    @sprites["D"].baseColor=Color.new(240,240,240)
    @sprites["D"].shadowColor=Color.new(40,40,40)
    @sprites["D"].visible=true
    @sprites["D"].viewport=@viewport
    @sprites["D"].windowskin=nil
    pbPrepareWindow(@sprites["E"])
    #@sprites["E"].x=422
    @sprites["E"].x=366
    #@sprites["E"].y=235
    @sprites["E"].y=225
    @sprites["E"].width=Graphics.width-48
    @sprites["E"].height=Graphics.height
    @sprites["E"].baseColor=Color.new(240,240,240)
    @sprites["E"].shadowColor=Color.new(40,40,40)
    @sprites["E"].visible=true
    @sprites["E"].viewport=@viewport
    @sprites["E"].windowskin=nil
    pbPrepareWindow(@sprites["F"])
    #@sprites["F"].x=422
    @sprites["F"].x=366
    #@sprites["F"].y=285
    @sprites["F"].y=275
    @sprites["F"].width=Graphics.width-48
    @sprites["F"].height=Graphics.height
    @sprites["F"].baseColor=Color.new(240,240,240)
    @sprites["F"].shadowColor=Color.new(40,40,40)
    @sprites["F"].visible=true
    @sprites["F"].viewport=@viewport
    @sprites["F"].windowskin=nil
	
#Viewport Stuff
	
	
	filenamPokeStat="Graphics/Pictures/Reincarnation/pokeview"
    @sprites["pokeview"]=IconSprite.new(0,120,@viewport)
    @sprites["pokeview"].setBitmap(filenamPokeStat)
    @sprites["pokeview"].visible = false
    @sprites["F"].visible=true
    @sprites["E"].visible=true
    @sprites["D"].visible=true
    @sprites["C"].visible=true
    @sprites["B"].visible=true
    @sprites["A"].visible=true
	@sprites["A"].text=_INTL("Recipient",@reincarnpkmn) if @reincarnpkmn==0 ||  @reincarnpkmn==-1  ||  @reincarnpkmn==""  ||  @reincarnpkmn==nil
    @sprites["B"].text=_INTL("Donor 1",@donApkmn) if @donApkmn==0 ||  @donApkmn==-1  ||  @donApkmn==""  ||  @donApkmn==nil
    @sprites["C"].text=_INTL("Donor 2",@donBpkmn) if @donBpkmn==0 ||  @donBpkmn==-1  ||  @donBpkmn==""  ||  @donBpkmn==nil
    @sprites["D"].text=_INTL("Stat Boon", @pkmnnat1) if @pkmnnat1==0 ||  @pkmnnat1==-1  ||  @pkmnnat1==""  ||  @pkmnnat1==nil
    @sprites["E"].text=_INTL("Stat Bane",@pkmnnat2) if @pkmnnat2==0 ||  @pkmnnat2==-1  ||  @pkmnnat2==""  ||  @pkmnnat2==nil
    @sprites["F"].text=_INTL("Stat Modifier",@pkmniv) if @pkmniv==0 ||  @pkmniv==-1  ||  @pkmniv==""  ||  @pkmniv==nil
	
	
	
#finishing
    pbFadeInAndShow(@sprites)
	end
  end

  def pbEndScene
    pbFadeOutAndHide(@icons)
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@icons)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
		map_id = $game_map.map_id
		map = load_data(sprintf("Data/Map%03d.rxdata",map_id))
		pbBGMPlay(map.bgm)
  end


# Script that manages button inputs  
  def pbSelectreincarnation
    delay = 0
	i = 0
		  donator2pokemonicon1 = 0
		  donator2pokemonicon2 = 0
		  donatorpokemonicon2 = 0
		  donatorpokemonicon1 = 0
		  reincarnpokemonicon = 0
		  reincarnpokemonicon1 = 0
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    pbSetSystemFont(overlay)
    pbDrawImagePositions(overlay,@imagepos)
    while true
    Graphics.update
      Input.update
      self.update
    @sprites["A"].text=_INTL("{1}",@reincarnpkmn) 
    @sprites["B"].text=_INTL("{1}",@donApkmn)
    @sprites["C"].text=_INTL("{1}",@donBpkmn)
	if @reincarnpkmnsp!=0
    @sprites["A"].text=_INTL("{1} ♂",@reincarnpkmn) if @reincarnpkmnsp.male?
    @sprites["A"].text=_INTL("{1} ♀",@reincarnpkmn) if @reincarnpkmnsp.female?
    @sprites["A"].text=_INTL("{1}",@reincarnpkmn) if @reincarnpkmnsp.genderless?
	end
	if @donApkmnsp!=0
    @sprites["B"].text=_INTL("{1} ♂",@donApkmn) if @donApkmnsp.male?
    @sprites["B"].text=_INTL("{1} ♀",@donApkmn) if @donApkmnsp.female?
    @sprites["B"].text=_INTL("{1} ",@donApkmn) if @donApkmnsp.genderless?
	end
	if @donBpkmnsp!=0
    @sprites["C"].text=_INTL("{1} ♂",@donBpkmn) if @donBpkmnsp.male?
    @sprites["C"].text=_INTL("{1} ♀",@donBpkmn) if @donBpkmnsp.female?
    @sprites["C"].text=_INTL("{1} ",@donBpkmn) if @donBpkmnsp.genderless?
	end
    @sprites["D"].text=_INTL("{1}", @pkmnnat1) if @pkmnnat1!=0 ||  @pkmnnat1!=-1
    @sprites["E"].text=_INTL("{1}",@pkmnnat2) if @pkmnnat2!=0 ||  @pkmnnat2!=-1
    @sprites["F"].text=_INTL("{1}",@pkmniv) if @pkmniv!=0 ||  @pkmniv!=-1
	@sprites["A"].text=_INTL("Recipient",@reincarnpkmn) if @reincarnpkmn==0 ||  @reincarnpkmn==-1  ||  @reincarnpkmn==""  ||  @reincarnpkmn==nil
    @sprites["B"].text=_INTL("Donor 1",@donApkmn) if @donApkmn==0 ||  @donApkmn==-1  ||  @donApkmn==""  ||  @donApkmn==nil
    @sprites["C"].text=_INTL("Donor 2",@donBpkmn) if @donBpkmn==0 ||  @donBpkmn==-1  ||  @donBpkmn==""  ||  @donBpkmn==nil
    @sprites["D"].text=_INTL("Stat Boon", @pkmnnat1) if @pkmnnat1==0 ||  @pkmnnat1==-1  ||  @pkmnnat1==""  ||  @pkmnnat1==nil
    @sprites["E"].text=_INTL("Stat Bane",@pkmnnat2) if @pkmnnat2==0 ||  @pkmnnat2==-1  ||  @pkmnnat2==""  ||  @pkmnnat2==nil
    @sprites["F"].text=_INTL("Stat Modifier",@pkmniv) if @pkmniv==0 ||  @pkmniv==-1  ||  @pkmniv==""  ||  @pkmniv==nil
	  
      selectionNum=@selection
      if Input.trigger?(Input::UP) && @inui == false
	    if @selection==0 && @reincarnpkmn!=0
		  pbSEPlay("GUI party switch")
          @sprites["reincarnatore"].visible = false
          @sprites["icon_#{4}"].visible = false
          @sprites["begin"].y=340
          #@sprites["A"].x=422
          @sprites["A"].x=366
          #@sprites["A"].y=35
          @sprites["A"].y=25
          @selection=6
	    elsif @selection==0
		  pbSEPlay("GUI party switch")
          @selection=5
		  @sprites["ivse"].visible = true
          @icons["itemResult3"].visible=true
		  if @sprites["icon_#{4}"]!=nil
          @sprites["icon_#{4}"].visible = false
		  end
          @sprites["reincarnatore"].visible = false
          @sprites["F"].x=315
          #@sprites["F"].y=285
          @sprites["F"].y=275
          #@sprites["A"].x=422
          @sprites["A"].x=366
          #@sprites["A"].y=35
          @sprites["A"].y=25
        elsif @selection==1
		  pbSEPlay("GUI party switch")
          @selection-=1
          @sprites["reincarnatore"].visible = true
          @sprites["donatorAe"].visible = false
		  if @sprites["icon_#{4}"]!=nil
          @sprites["icon_#{4}"].visible = true
		  end
		  if @sprites["icon_#{5}"]!=nil
          @sprites["icon_#{5}"].visible = false
		  end
          @sprites["A"].x=315 ## Don't Remove
          #@sprites["A"].y=35
          @sprites["A"].y=25
          #@sprites["B"].x=422
          @sprites["B"].x=366
          #@sprites["B"].y=85
          @sprites["B"].y=75
        elsif @selection==2
		  pbSEPlay("GUI party switch")
          @sprites["donatorAe"].visible = true
          @sprites["donatorBe"].visible = false
		  if @sprites["icon_#{5}"]!=nil
          @sprites["icon_#{5}"].visible = true
		  end
		  if @sprites["icon_#{6}"]!=nil
          @sprites["icon_#{6}"].visible = false
		  end
          @sprites["B"].x=315          
          #@sprites["B"].y=85
          @sprites["B"].y=75
          #@sprites["C"].x=422
          @sprites["C"].x=366
          #@sprites["C"].y=135
          @sprites["C"].y=125
          @selection-=1
        elsif @selection==3
		  pbSEPlay("GUI party switch")
          @sprites["donatorBe"].visible = true
          @sprites["nature1e"].visible = false
          @icons["itemResult1"].visible=false
		  if @sprites["icon_#{6}"]!=nil
          @sprites["icon_#{6}"].visible = true
		  end
          @sprites["C"].x=315
          #@sprites["C"].y=135
          @sprites["C"].y=125
          #@sprites["D"].x=422
          @sprites["D"].x=366
          #@sprites["D"].y=185
          @sprites["D"].y=175
          @selection-=1
        elsif @selection==4
		  pbSEPlay("GUI party switch")
          @sprites["nature1e"].visible = true
          @sprites["nature2e"].visible = false
          @icons["itemResult1"].visible=true
          @icons["itemResult2"].visible=false
          @sprites["D"].x=315
          #@sprites["D"].y=185
          @sprites["D"].y=175
          #@sprites["E"].x=422
          @sprites["E"].x=366
          #@sprites["E"].y=235
          @sprites["E"].y=225
          @selection-=1
		elsif @selection==6
		  pbSEPlay("GUI party switch")
          @sprites["begin"].y=350
          @sprites["F"].x=315
          #@sprites["F"].y=285
          @sprites["F"].y=275
		  @sprites["ivse"].visible = true
          @selection-=1
        else
		  pbSEPlay("GUI party switch")
          @sprites["nature2e"].visible = true
		  @sprites["ivse"].visible = false
          @icons["itemResult2"].visible=true
          @icons["itemResult3"].visible=false
		  if @sprites["icon_#{4}"]!=nil
          @sprites["icon_#{4}"].visible = false
		  end
          #@sprites["F"].x=422
          @sprites["F"].x=366
          #@sprites["F"].y=285
          @sprites["F"].y=275
          @sprites["E"].x=315
          #@sprites["E"].y=235
          @sprites["E"].y=225
          @selection-=1
        end
      end
      if Input.trigger?(Input::DOWN) && @inui == false
        if @selection==0
		  pbSEPlay("GUI party switch")
		  @sprites["reincarnatore"].visible = false
          @sprites["donatorAe"].visible = true
          #@sprites["A"].x=422
          @sprites["A"].x=366
          #@sprites["A"].y=35
          @sprites["A"].y=25
          @sprites["B"].x=315
          #@sprites["B"].y=85
          @sprites["B"].y=75
		  if @sprites["icon_#{4}"]!=nil
          @sprites["icon_#{4}"].visible = false
		  end
		  if @sprites["icon_#{5}"]!=nil
          @sprites["icon_#{5}"].visible = true
		  end
          @selection+=1
        elsif @selection==1
		  pbSEPlay("GUI party switch")
          @sprites["donatorAe"].visible = false
          @sprites["donatorBe"].visible = true
          #@sprites["B"].x=422
          @sprites["B"].x=366
          #@sprites["B"].y=85
          @sprites["B"].y=75
          @sprites["C"].x=315
          #@sprites["C"].y=135
          @sprites["C"].y=125
		  if @sprites["icon_#{5}"]!=nil
          @sprites["icon_#{5}"].visible = false
		  end
		  if @sprites["icon_#{6}"]!=nil
          @sprites["icon_#{6}"].visible = true
		  end
          @selection+=1
        elsif @selection==2
		  pbSEPlay("GUI party switch")
          @sprites["donatorBe"].visible = false
          @sprites["nature1e"].visible = true
          @icons["itemResult1"].visible=true
          @selection+=1
          #@sprites["C"].x=422
          @sprites["C"].x=366
          #@sprites["C"].y=135
          @sprites["C"].y=125
          @sprites["D"].x=315
          #@sprites["D"].y=185
          @sprites["D"].y=175
		  if @sprites["icon_#{6}"]!=nil
          @sprites["icon_#{6}"].visible = false
		  end
        elsif @selection==3
		  pbSEPlay("GUI party switch")
          @sprites["nature1e"].visible = false
          @sprites["nature2e"].visible = true
          @icons["itemResult2"].visible=true
          @icons["itemResult1"].visible=false
          #@sprites["D"].x=422
          @sprites["D"].x=366
          #@sprites["D"].y=185
          @sprites["D"].y=175
          @sprites["E"].x=315
          #@sprites["E"].y=235
          @sprites["E"].y=225
          @selection+=1
        elsif @selection==4
		  pbSEPlay("GUI party switch")
          @sprites["nature2e"].visible = false
          @icons["itemResult2"].visible=false
          @icons["itemResult3"].visible=true
          #@sprites["E"].x=422
          @sprites["E"].x=366
          #@sprites["E"].y=235
          @sprites["E"].y=225
          @sprites["F"].x=315
          #@sprites["F"].y=285
          @sprites["F"].y=275
		  @sprites["ivse"].visible = true
          @selection+=1
		elsif @selection==5 && @reincarnpkmn!=0 
		  @sprites["ivse"].visible = false
		  pbSEPlay("GUI party switch")
          @icons["itemResult3"].visible=false
          #@sprites["F"].x=422
          @sprites["F"].x=366
          #@sprites["F"].y=285
          @sprites["F"].y=275
          @sprites["begin"].y=340
          @selection+=1
		elsif @selection==6
		  pbSEPlay("GUI party switch")
		  @sprites["reincarnatore"].visible = true
          @sprites["A"].x=315
          #@sprites["A"].y=35
          @sprites["A"].y=25
          @sprites["icon_#{4}"].visible = true
          @sprites["begin"].y=350
          @selection=0
        else
		  pbSEPlay("GUI party switch")
		  @sprites["ivse"].visible = false
		  @sprites["reincarnatore"].visible = true
          @icons["itemResult3"].visible=false
          #@sprites["F"].x=422
          @sprites["F"].x=366
          #@sprites["F"].y=285
          @sprites["F"].y=275
          @sprites["A"].x=315
          #@sprites["A"].y=35
          @sprites["A"].y=25
		  if @sprites["icon_#{4}"]!=nil
          @sprites["icon_#{4}"].visible = true
		  end
          @selection=0
        end
      end

      if Input.trigger?(Input::USE)
        if @selection==0
		loop do
		  pbChoosePokemon(1,3)
		  if @reincarnpkmnsp!= 0
          reincarnpokemonicon.visible = false
          reincarnpokemonicon1.visible = false
		  @reincarnpkmnsp = 0
		  end
		  @reincarnpkmn = $game_variables[3]
		  if $game_variables[1] != -1
		  @reincarnpkmnsp = ($player.party[pbGet(1)])
		  if @reincarnpkmnsp == @donApkmnsp || @reincarnpkmnsp == @donBpkmnsp
              pbMessage(_INTL("{1} has already been chosen! Choose Another!", @reincarnpkmn))
			  @reincarnpkmnsp = 0
			  break
		  else
		  i = @reincarnpkmnsp.species_data 
		  @sprites["icon_#{0}"] = PokemonSpeciesIconSprite.new(i.id,@viewport)
		  @sprites["icon_#{0}"].x = 114
		  @sprites["icon_#{0}"].y = 77
          @sprites["icon_#{0}"].visible = true
		  reincarnpokemonicon1 = @sprites["icon_#{0}"] 
		  @sprites["icon_#{4}"] = PokemonSpeciesIconSprite.new(i.id,@viewport)
		  @sprites["icon_#{4}"].x = 270
		  @sprites["icon_#{4}"].y = 15
          @sprites["icon_#{4}"].visible = true
		  reincarnpokemonicon = @sprites["icon_#{4}"]
		  $game_variables[3] = nil
		  $game_variables[1] = nil
			  break
		  end
		end
		  end
        elsif @selection==1
		loop do
		  pbChoosePokemon(1,3)
		  if @donApkmnsp!= 0
          donatorpokemonicon1.visible = false
          donatorpokemonicon2.visible = false
		  @donApkmnsp = 0
		  end
		  @donApkmn = $game_variables[3]
		  if $game_variables[1] != -1
		  @donApkmnsp = ($player.party[pbGet(1)])
		  if @donApkmnsp == @reincarnpkmnsp || @donApkmnsp == @donBpkmnsp
              pbMessage(_INTL("{1} has already been chosen! Choose Another!", @donApkmn))
			  @donApkmnsp = 0
			  break
		  else
		  i = @donApkmnsp.species_data
		  @sprites["icon_#{1}"] = PokemonSpeciesIconSprite.new(i.id,@viewport)
		  @sprites["icon_#{1}"].x = 54
		  @sprites["icon_#{1}"].y = 190
          @sprites["icon_#{1}"].visible = true
		  donatorpokemonicon1 = @sprites["icon_#{1}"]
		  @sprites["icon_#{5}"] = PokemonSpeciesIconSprite.new(i.id,@viewport)
		  @sprites["icon_#{5}"].x = 270
		  @sprites["icon_#{5}"].y = 65
          @sprites["icon_#{5}"].visible = true
		  donatorpokemonicon2 = @sprites["icon_#{5}"]
		  $game_variables[3] = nil
		  $game_variables[1] = nil
			  break
		  end
		 end
		  end
        elsif @selection==2
		 loop do
		  pbChoosePokemon(1,3)
		  if @donBpkmnsp != 0
          donator2pokemonicon1.visible = false
          donator2pokemonicon2.visible = false
		  @donBpkmnsp = 0
		  end
		  @donBpkmn = $game_variables[3]
		  if $game_variables[1] != -1
		  @donBpkmnsp = ($player.party[pbGet(1)])
		  if @donBpkmnsp == @donApkmnsp || @donBpkmnsp == @reincarnpkmnsp
              pbMessage(_INTL("{1} has already been chosen! Choose Another!", @donBpkmn))
			  @donBpkmnsp = 0
			  break
		  else
		  i = @donBpkmnsp.species_data
		  @sprites["icon_#{2}"] = PokemonSpeciesIconSprite.new(i.id,@viewport)
		  @sprites["icon_#{2}"].x = 174
		  @sprites["icon_#{2}"].y = 195
          @sprites["icon_#{2}"].visible = true
		  donator2pokemonicon1 = @sprites["icon_#{2}"]
		  @sprites["icon_#{6}"] = PokemonSpeciesIconSprite.new(i.id,@viewport)
		  @sprites["icon_#{6}"].x = 270
		  @sprites["icon_#{6}"].y = 115
          @sprites["icon_#{6}"].visible = true
		  donator2pokemonicon2 = @sprites["icon_#{6}"]
		  $game_variables[3] = nil
		  $game_variables[1] = nil
			  break
		  end
		  end
		  end
        elsif @selection==3
          pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
@pkmnnat1 = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_reinboon? })
}
if @pkmnnat1 != nil
item = @pkmnnat1
filenamF =GameData::Item.icon_filename(@pkmnnat1) 
    @icons["itemResult4"]=IconSprite.new(84,77,@viewport)
    @icons["itemResult4"].setBitmap(filenamF)
    @icons["itemResult4"].visible=true
@icons["itemResult1"].setBitmap(filenamF)
@pkmnnat1sp = @pkmnnat1
@pkmnnat1 = GameData::Item.get(item).name
end
        elsif @selection==4
           pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
@pkmnnat2 = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_reinbane? })
}
if @pkmnnat2 != nil
item = @pkmnnat2
filenamG =GameData::Item.icon_filename(@pkmnnat2) 
@pkmnnat2sp = @pkmnnat2
@pkmnnat2 = GameData::Item.get(item).name
@icons["itemResult2"].setBitmap(filenamG)
    @icons["itemResult5"]=IconSprite.new(155,77,@viewport)
    @icons["itemResult5"].setBitmap(filenamG)
    @icons["itemResult5"].visible=true
end
		elsif @selection==6
		if pbConfirmMessage(_INTL("{1} will become Level 1! Are you sure?",@reincarnpkmnsp.name))
        @inui = true
		@selection = 7
		pbSEPlay("GUI naming confirm")
		@sprites["D"].visible = false
        @sprites["E"].visible = false
        @sprites["F"].visible = false
     	@sprites["A"].visible = false
        @sprites["B"].visible = false
        @sprites["C"].visible = false
        @sprites["D"].visible = false
        @sprites["E"].visible = false
        @sprites["F"].visible = false
        @icons["itemResult2"].visible=false
        @icons["itemResult3"].visible=false
        @icons["itemResult1"].visible=false
        @sprites["donatorBe"].visible = false
        @sprites["reincarnatore"].visible = false
        @sprites["nature2e"].visible = false
        @sprites["ivse"].visible = false
        @sprites["donatorA"].visible = false
        @sprites["donatorB"].visible = false
        @sprites["reincarnator"].visible = false
        @sprites["nature1"].visible = false
        @sprites["nature2"].visible = false
        @sprites["ivs"].visible = false
        @sprites["begin"].visible = false
        @icons["itemResult4"].visible=false
        @icons["itemResult5"].visible=false
        @icons["itemResult6"].visible=false
		  donator2pokemonicon1.visible = false if donator2pokemonicon1 != 0
		  donator2pokemonicon2.visible = false if donator2pokemonicon2 != 0
		  donatorpokemonicon2.visible = false if donatorpokemonicon2 != 0
		  donatorpokemonicon1.visible = false if donatorpokemonicon1 != 0
		  reincarnpokemonicon.visible = false if reincarnpokemonicon != 0
		  reincarnpokemonicon1.visible = false if reincarnpokemonicon1 != 0
	if ReincarnationConfig::CUSTOM_BG == "Graphics/Pictures/Reincarnation/ReincarnationBG"
		pbWait(5)
		21.times { 
		@sprites["sigil"].x = @sprites["sigil"].x + 5
		@sprites["Item3Orb"].x = @sprites["Item3Orb"].x + 5
		@sprites["Item2Orb"].x = @sprites["Item2Orb"].x + 5
		@sprites["Item1Orb"].x = @sprites["Item1Orb"].x + 5
		@sprites["Don2Orb"].x = @sprites["Don2Orb"].x + 5
		@sprites["Don1Orb"].x = @sprites["Don1Orb"].x + 5
		@sprites["ReOrb"].x = @sprites["ReOrb"].x + 5
		pbWait(1)
    }
    fadeTime = Graphics.frame_rate * 4 / 10
    toneDiff = (255.0 / fadeTime).ceil
    pbSEPlay(ReincarnationConfig::CUSTOM_REINCARNME)
    (1..fadeTime).each do |i|
		@sprites["Item3Orb"].tone = Tone.new(0 + (i * toneDiff), 0 + (i * toneDiff), 0 + (i * toneDiff))
		@sprites["Item2Orb"].tone = Tone.new(0 + (i * toneDiff), 0 + (i * toneDiff), 0 + (i * toneDiff))
		@sprites["Item1Orb"].tone = Tone.new(0 + (i * toneDiff), 0 + (i * toneDiff), 0 + (i * toneDiff))
		@sprites["Don2Orb"].tone = Tone.new(0 + (i * toneDiff), 0 + (i * toneDiff), 0 + (i * toneDiff))
		@sprites["Don1Orb"].tone = Tone.new(0 + (i * toneDiff), 0 + (i * toneDiff), 0 + (i * toneDiff))
		@sprites["ReOrb"].tone = Tone.new(0 + (i * toneDiff), 0 + (i * toneDiff), 0 + (i * toneDiff))
        if i > 12
           @sprites["background"].tone = Tone.new(0 + (i * toneDiff), 0 + (i * toneDiff), 0 + (i * toneDiff))
	       @sprites["sigil"].tone = Tone.new(0 + (i * toneDiff), 0 + (i * toneDiff), 0 + (i * toneDiff))
		   @sprites["back"].tone = Tone.new(0 + (i * toneDiff), 0 + (i * toneDiff), 0 + (i * toneDiff))
		end 
		pbWait(3)
    end
    (1..fadeTime).each do |i|
		@sprites["Item3Orb"].tone = Tone.new(255 - (i * toneDiff), 255 - (i * toneDiff), 255 - (i * toneDiff))
		@sprites["Item2Orb"].tone = Tone.new(255 - (i * toneDiff), 255 - (i * toneDiff), 255 - (i * toneDiff))
		@sprites["Item1Orb"].tone = Tone.new(255 - (i * toneDiff), 255 - (i * toneDiff), 255 - (i * toneDiff))
		@sprites["Don2Orb"].tone = Tone.new(255 - (i * toneDiff), 255 - (i * toneDiff), 255 - (i * toneDiff))
		@sprites["Don1Orb"].tone = Tone.new(255 - (i * toneDiff), 255 - (i * toneDiff), 255 - (i * toneDiff))
		@sprites["ReOrb"].tone = Tone.new(255 - (i * toneDiff), 255 - (i * toneDiff), 255 - (i * toneDiff))
        if i > 7
           @sprites["background"].tone = Tone.new(255 - (i * toneDiff), 255 - (i * toneDiff), 255 - (i * toneDiff))
	       @sprites["sigil"].tone = Tone.new(255 - (i * toneDiff), 255 - (i * toneDiff), 255 - (i * toneDiff))
		   @sprites["back"].tone = Tone.new(255 - (i * toneDiff), 255 - (i * toneDiff), 255 - (i * toneDiff))
		end 
		pbWait(3)
    end
	end
	pbWait(20)
		pkmn = @reincarnpkmnsp
       if ReincarnationConfig::SET_TO_LEVEL !=nil
	   pkmn.level = ReincarnationConfig::SET_TO_LEVEL
	   pkmn.calc_stats
	   end
		@oldhp = pkmn.totalhp
		@oldatk = pkmn.attack
		@olddef = pkmn.defense
		@oldsatk = pkmn.spatk
		@oldsdef = pkmn.spdef
		@oldspd = pkmn.speed
		@oldhpiv = pkmn.iv[:HP]
		@oldatkiv = pkmn.iv[:ATTACK]
		@olddefiv = pkmn.iv[:DEFENSE]
		@oldsatkiv = pkmn.iv[:SPECIAL_ATTACK]
		@oldsdefiv = pkmn.iv[:SPECIAL_DEFENSE]
		@oldspdiv = pkmn.iv[:SPEED]
		pkmn = Reincarnation.begin_reincarnation(pkmn, @donApkmnsp, @donBpkmnsp, @pkmnivsp, @pkmnnat1sp, @pkmnnat2sp)
		@newhp = pkmn.totalhp
		@newatk = pkmn.attack
		@newdef = pkmn.defense
		@newsatk = pkmn.spatk
		@newsdef = pkmn.spdef
		@newspd = pkmn.speed
		@newhpiv = pkmn.iv[:HP]
		@newatkiv = pkmn.iv[:ATTACK]
		@newdefiv = pkmn.iv[:DEFENSE]
		@newsatkiv = pkmn.iv[:SPECIAL_ATTACK]
		@newsdefiv = pkmn.iv[:SPECIAL_DEFENSE]
		@newspdiv = pkmn.iv[:SPEED]
		pbWait(20)
        @sprites["pokeview"].visible = true
        @sprites["pokemon"] = PokemonSprite.new(@viewport)
        @sprites["pokemon"].setOffset(PictureOrigin:: CENTER)
        @sprites["pokemon"].x = 255
        @sprites["pokemon"].y = 255
        @sprites["pokemon"].setPokemonBitmap(@reincarnpkmnsp)
        @sprites["pokemon"].visible = true
		
		filenamRatingF="Graphics/Pictures/Reincarnation/RatingF"
	    filenamRatingD="Graphics/Pictures/Reincarnation/RatingD"
	    filenamRatingC="Graphics/Pictures/Reincarnation/RatingC"
	    filenamRatingB="Graphics/Pictures/Reincarnation/RatingB"
	    filenamRatingA="Graphics/Pictures/Reincarnation/RatingA"
	    filenamRatingS="Graphics/Pictures/Reincarnation/RatingS"
    @sprites["HPOld"]=Window_UnformattedTextPokemon.new("")
    @sprites["ATKOld"]=Window_UnformattedTextPokemon.new("")
    @sprites["DEFOld"]=Window_UnformattedTextPokemon.new("")
    @sprites["SATKOld"]=Window_UnformattedTextPokemon.new("")
    @sprites["SDEFOld"]=Window_UnformattedTextPokemon.new("")
    @sprites["SPDOld"]=Window_UnformattedTextPokemon.new("")
    @sprites["HPNew"]=Window_UnformattedTextPokemon.new("")
    @sprites["ATKNew"]=Window_UnformattedTextPokemon.new("")
    @sprites["DEFNew"]=Window_UnformattedTextPokemon.new("")
    @sprites["SATKNew"]=Window_UnformattedTextPokemon.new("")
    @sprites["SDEFNew"]=Window_UnformattedTextPokemon.new("")
    @sprites["SPDNew"]=Window_UnformattedTextPokemon.new("")
    @sprites["PkmnName"]=Window_UnformattedTextPokemon.new("")
    @sprites["PkmnLevel"]=Window_UnformattedTextPokemon.new("")
    @sprites["PkmnLevel50"]=Window_UnformattedTextPokemon.new("")
    @sprites["PkmnAbility"]=Window_UnformattedTextPokemon.new("")
    @sprites["PkmnAbilityDesc"]=Window_UnformattedTextPokemon.new("")
    @sprites["HPOldN"]=Window_UnformattedTextPokemon.new("")
    @sprites["ATKOldN"]=Window_UnformattedTextPokemon.new("")
    @sprites["DEFOldN"]=Window_UnformattedTextPokemon.new("")
    @sprites["SATKOldN"]=Window_UnformattedTextPokemon.new("")
    @sprites["SDEFOldN"]=Window_UnformattedTextPokemon.new("")
    @sprites["SPDOldN"]=Window_UnformattedTextPokemon.new("")
    @sprites["HPNewN"]=Window_UnformattedTextPokemon.new("")
    @sprites["ATKNewN"]=Window_UnformattedTextPokemon.new("")
    @sprites["DEFNewN"]=Window_UnformattedTextPokemon.new("")
    @sprites["SATKNewN"]=Window_UnformattedTextPokemon.new("")
    @sprites["SDEFNewN"]=Window_UnformattedTextPokemon.new("")
    @sprites["SPDNewN"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["HPOld"])
    @sprites["HPOld"].x=14
    @sprites["HPOld"].y=160
    @sprites["HPOld"].width=Graphics.width-48
    @sprites["HPOld"].height=Graphics.height
    @sprites["HPOld"].baseColor=Color.new(240,240,240)
    @sprites["HPOld"].shadowColor=Color.new(40,40,40)
    @sprites["HPOld"].text=_INTL("HP") 
    @sprites["HPOld"].viewport=@viewport
    @sprites["HPOld"].windowskin=nil
    @sprites["HPOld"].visible=false
    pbPrepareWindow(@sprites["ATKOld"])
    @sprites["ATKOld"].x=14
    @sprites["ATKOld"].y=192
    @sprites["ATKOld"].width=Graphics.width-48
    @sprites["ATKOld"].height=Graphics.height
    @sprites["ATKOld"].baseColor=Color.new(240,240,240)
    @sprites["ATKOld"].shadowColor=Color.new(40,40,40)
    @sprites["ATKOld"].text=_INTL("ATK") 
    @sprites["ATKOld"].viewport=@viewport
    @sprites["ATKOld"].windowskin=nil
    @sprites["ATKOld"].visible=false
    pbPrepareWindow(@sprites["DEFOld"])
    @sprites["DEFOld"].x=14
    @sprites["DEFOld"].y=224
    @sprites["DEFOld"].width=Graphics.width-48
    @sprites["DEFOld"].height=Graphics.height
    @sprites["DEFOld"].baseColor=Color.new(240,240,240)
    @sprites["DEFOld"].shadowColor=Color.new(40,40,40)
    @sprites["DEFOld"].text=_INTL("DEF") 
    @sprites["DEFOld"].viewport=@viewport
    @sprites["DEFOld"].windowskin=nil
    @sprites["DEFOld"].visible=false
    pbPrepareWindow(@sprites["SATKOld"])
    @sprites["SATKOld"].x=14
    @sprites["SATKOld"].y=256
    @sprites["SATKOld"].width=Graphics.width-48
    @sprites["SATKOld"].height=Graphics.height
    @sprites["SATKOld"].baseColor=Color.new(240,240,240)
    @sprites["SATKOld"].shadowColor=Color.new(40,40,40)
    @sprites["SATKOld"].text=_INTL("S. ATK") 
    @sprites["SATKOld"].viewport=@viewport
    @sprites["SATKOld"].windowskin=nil
    @sprites["SATKOld"].visible=false
    pbPrepareWindow(@sprites["SDEFOld"])
    @sprites["SDEFOld"].x=14
    @sprites["SDEFOld"].y=288
    @sprites["SDEFOld"].width=Graphics.width-48
    @sprites["SDEFOld"].height=Graphics.height
    @sprites["SDEFOld"].baseColor=Color.new(240,240,240)
    @sprites["SDEFOld"].shadowColor=Color.new(40,40,40)
    @sprites["SDEFOld"].text=_INTL("S. DEF") 
    @sprites["SDEFOld"].viewport=@viewport
    @sprites["SDEFOld"].windowskin=nil
    @sprites["SDEFOld"].visible=false
    pbPrepareWindow(@sprites["SPDOld"])
    @sprites["SPDOld"].x=14
    @sprites["SPDOld"].y=320
    @sprites["SPDOld"].width=Graphics.width-48
    @sprites["SPDOld"].height=Graphics.height
    @sprites["SPDOld"].baseColor=Color.new(240,240,240)
    @sprites["SPDOld"].shadowColor=Color.new(40,40,40)
    @sprites["SPDOld"].text=_INTL("SPD") 
    @sprites["SPDOld"].viewport=@viewport
    @sprites["SPDOld"].windowskin=nil
    @sprites["SPDOld"].visible=false
    pbPrepareWindow(@sprites["HPNew"])
    @sprites["HPNew"].x=350
    @sprites["HPNew"].y=160
    @sprites["HPNew"].width=Graphics.width-48
    @sprites["HPNew"].height=Graphics.height
    @sprites["HPNew"].baseColor=Color.new(240,240,240)
    @sprites["HPNew"].shadowColor=Color.new(40,40,40)
    @sprites["HPNew"].text=_INTL("HP") 
    @sprites["HPNew"].viewport=@viewport
    @sprites["HPNew"].windowskin=nil
    @sprites["HPNew"].visible=false
    pbPrepareWindow(@sprites["ATKNew"])
    @sprites["ATKNew"].x=350
    @sprites["ATKNew"].y=192
    @sprites["ATKNew"].width=Graphics.width-48
    @sprites["ATKNew"].height=Graphics.height
    @sprites["ATKNew"].baseColor=Color.new(240,240,240)
    @sprites["ATKNew"].shadowColor=Color.new(40,40,40)
    @sprites["ATKNew"].text=_INTL("ATK") 
    @sprites["ATKNew"].viewport=@viewport
    @sprites["ATKNew"].windowskin=nil
    @sprites["ATKNew"].visible=false
    pbPrepareWindow(@sprites["DEFNew"])
    @sprites["DEFNew"].x=350
    @sprites["DEFNew"].y=224
    @sprites["DEFNew"].width=Graphics.width-48
    @sprites["DEFNew"].height=Graphics.height
    @sprites["DEFNew"].baseColor=Color.new(240,240,240)
    @sprites["DEFNew"].shadowColor=Color.new(40,40,40)
    @sprites["DEFNew"].text=_INTL("DEF") 
    @sprites["DEFNew"].viewport=@viewport
    @sprites["DEFNew"].windowskin=nil
    @sprites["DEFNew"].visible=false
    pbPrepareWindow(@sprites["SATKNew"])
    @sprites["SATKNew"].x=350
    @sprites["SATKNew"].y=255
    @sprites["SATKNew"].width=Graphics.width-48
    @sprites["SATKNew"].height=Graphics.height
    @sprites["SATKNew"].baseColor=Color.new(240,240,240)
    @sprites["SATKNew"].shadowColor=Color.new(40,40,40)
    @sprites["SATKNew"].text=_INTL("S. ATK") 
    @sprites["SATKNew"].viewport=@viewport
    @sprites["SATKNew"].windowskin=nil
    @sprites["SATKNew"].visible=false
    pbPrepareWindow(@sprites["SDEFNew"])
    @sprites["SDEFNew"].x=350
    @sprites["SDEFNew"].y=288
    @sprites["SDEFNew"].width=Graphics.width-48
    @sprites["SDEFNew"].height=Graphics.height
    @sprites["SDEFNew"].baseColor=Color.new(240,240,240)
    @sprites["SDEFNew"].shadowColor=Color.new(40,40,40)
    @sprites["SDEFNew"].text=_INTL("S. DEF") 
    @sprites["SDEFNew"].viewport=@viewport
    @sprites["SDEFNew"].windowskin=nil
    @sprites["SDEFNew"].visible=false
    pbPrepareWindow(@sprites["SPDNew"])
    @sprites["SPDNew"].x=350
    @sprites["SPDNew"].y=320
    @sprites["SPDNew"].width=Graphics.width-48
    @sprites["SPDNew"].height=Graphics.height
    @sprites["SPDNew"].baseColor=Color.new(240,240,240)
    @sprites["SPDNew"].shadowColor=Color.new(40,40,40)
    @sprites["SPDNew"].text=_INTL("SPD") 
    @sprites["SPDNew"].viewport=@viewport
    @sprites["SPDNew"].windowskin=nil
    @sprites["SPDNew"].visible=false
    pbPrepareWindow(@sprites["PkmnName"])
    @sprites["PkmnName"].x=175
    @sprites["PkmnName"].y=110
    @sprites["PkmnName"].width=Graphics.width-48
    @sprites["PkmnName"].height=Graphics.height
    @sprites["PkmnName"].baseColor=Color.new(240,240,240)
    @sprites["PkmnName"].shadowColor=Color.new(40,40,40)
    @sprites["PkmnName"].text=_INTL("{1}",@reincarnpkmnsp.name) 
    @sprites["PkmnName"].viewport=@viewport
    @sprites["PkmnName"].windowskin=nil
    @sprites["PkmnName"].visible=false
    pbPrepareWindow(@sprites["PkmnLevel"])
    @sprites["PkmnLevel"].x=380
    @sprites["PkmnLevel"].y=135
    @sprites["PkmnLevel"].width=Graphics.width-48
    @sprites["PkmnLevel"].height=Graphics.height
    @sprites["PkmnLevel"].baseColor=Color.new(240,240,240)
    @sprites["PkmnLevel"].shadowColor=Color.new(40,40,40)
    @sprites["PkmnLevel"].text=_INTL("1") 
    @sprites["PkmnLevel"].viewport=@viewport
    @sprites["PkmnLevel"].windowskin=nil
    @sprites["PkmnLevel"].visible=false
    pbPrepareWindow(@sprites["PkmnLevel50"])
    @sprites["PkmnLevel50"].x=192
    @sprites["PkmnLevel50"].y=140
    @sprites["PkmnLevel50"].width=Graphics.width-48
    @sprites["PkmnLevel50"].height=Graphics.height
    @sprites["PkmnLevel50"].text=_INTL("1") 
    @sprites["PkmnLevel50"].baseColor=Color.new(240,240,240)
    @sprites["PkmnLevel50"].shadowColor=Color.new(40,40,40)
    @sprites["PkmnLevel50"].viewport=@viewport
    @sprites["PkmnLevel50"].windowskin=nil
    @sprites["PkmnLevel50"].visible=false
    pbPrepareWindow(@sprites["PkmnAbility"])
    @sprites["PkmnAbility"].x=170
    @sprites["PkmnAbility"].y=327
    @sprites["PkmnAbility"].width=Graphics.width-48
    @sprites["PkmnAbility"].height=Graphics.height
    @sprites["PkmnAbility"].text=_INTL("{1}",@reincarnpkmnsp.nature.name) 
    @sprites["PkmnAbility"].baseColor=Color.new(240,240,240)
    @sprites["PkmnAbility"].shadowColor=Color.new(40,40,40)
    @sprites["PkmnAbility"].viewport=@viewport
    @sprites["PkmnAbility"].windowskin=nil
    @sprites["PkmnAbility"].visible=false
    pbPrepareWindow(@sprites["HPOldN"])
    @sprites["HPOldN"].x=86
    @sprites["HPOldN"].y=160
    @sprites["HPOldN"].width=Graphics.width-48
    @sprites["HPOldN"].height=Graphics.height
    @sprites["HPOldN"].baseColor=Color.new(240,240,240)
    @sprites["HPOldN"].shadowColor=Color.new(40,40,40)
    @sprites["HPOldN"].text=_INTL("{1}",@oldhp,@oldhpiv)
    @sprites["HPOldN"].viewport=@viewport
    @sprites["HPOldN"].windowskin=nil
    @sprites["HPOldN"].visible=false
    @sprites["HPStar"]=IconSprite.new(132,182,@viewport)
      if @oldhpiv > 30
        @sprites["HPStar"].setBitmap(filenamRatingS)
      elsif @oldhpiv && @oldhpiv < 31
        @sprites["HPStar"].setBitmap(filenamRatingA)
      elsif @oldhpiv > 15 && @oldhpiv < 23
        @sprites["HPStar"].setBitmap(filenamRatingB)
      elsif @oldhpiv > 7 && @oldhpiv < 16
        @sprites["HPStar"].setBitmap(filenamRatingC)
      elsif @oldhpiv > 0 && @oldhpiv < 8
        @sprites["HPStar"].setBitmap(filenamRatingD)
      else
        @sprites["HPStar"].setBitmap(filenamRatingF)
      end
    @sprites["HPStar"].visible = false
    pbPrepareWindow(@sprites["ATKOldN"])
    @sprites["ATKOldN"].x=86
    @sprites["ATKOldN"].y=192
    @sprites["ATKOldN"].width=Graphics.width-48
    @sprites["ATKOldN"].height=Graphics.height
    @sprites["ATKOldN"].baseColor=Color.new(240,240,240)
    @sprites["ATKOldN"].shadowColor=Color.new(40,40,40)
    @sprites["ATKOldN"].text=_INTL("{1}",@oldatk,@oldatkiv)
    @sprites["ATKOldN"].viewport=@viewport
    @sprites["ATKOldN"].windowskin=nil
    @sprites["ATKOldN"].visible=false
    @sprites["ATKStar"]=IconSprite.new(132,214,@viewport)
      if @oldatkiv > 30
        @sprites["ATKStar"].setBitmap(filenamRatingS)
      elsif @oldatkiv > 22 && @oldatkiv < 31
        @sprites["ATKStar"].setBitmap(filenamRatingA)
      elsif @oldatkiv > 15 && @oldatkiv < 23
        @sprites["ATKStar"].setBitmap(filenamRatingB)
      elsif @oldatkiv > 7 && @oldatkiv < 16
        @sprites["ATKStar"].setBitmap(filenamRatingC)
      elsif @oldatkiv > 0 && @oldatkiv < 8
        @sprites["ATKStar"].setBitmap(filenamRatingD)
      else
        @sprites["ATKStar"].setBitmap(filenamRatingF)
      end
    @sprites["ATKStar"].visible = false
    pbPrepareWindow(@sprites["DEFOldN"])
    @sprites["DEFOldN"].x=86
    @sprites["DEFOldN"].y=224
    @sprites["DEFOldN"].width=Graphics.width-48
    @sprites["DEFOldN"].height=Graphics.height
    @sprites["DEFOldN"].baseColor=Color.new(240,240,240)
    @sprites["DEFOldN"].shadowColor=Color.new(40,40,40)
    @sprites["DEFOldN"].text=_INTL("{1}",@olddef,@olddefiv)
    @sprites["DEFOldN"].viewport=@viewport
    @sprites["DEFOldN"].windowskin=nil
    @sprites["DEFOldN"].visible=false
    @sprites["DEFStar"]=IconSprite.new(132,246,@viewport)
      if @olddefiv > 30
        @sprites["DEFStar"].setBitmap(filenamRatingS)
      elsif @olddefiv > 22 && @olddefiv < 31
        @sprites["DEFStar"].setBitmap(filenamRatingA)
      elsif @olddefiv > 15 && @olddefiv < 23
        @sprites["DEFStar"].setBitmap(filenamRatingB)
      elsif @olddefiv > 7 && @olddefiv < 16
        @sprites["DEFStar"].setBitmap(filenamRatingC)
      elsif @olddefiv > 0 && @olddefiv < 8
        @sprites["DEFStar"].setBitmap(filenamRatingD)
      else
        @sprites["DEFStar"].setBitmap(filenamRatingF)
      end
    @sprites["DEFStar"].visible = false
    pbPrepareWindow(@sprites["SATKOldN"])
    @sprites["SATKOldN"].x=86
    @sprites["SATKOldN"].y=255
    @sprites["SATKOldN"].width=Graphics.width-48
    @sprites["SATKOldN"].height=Graphics.height
    @sprites["SATKOldN"].baseColor=Color.new(240,240,240)
    @sprites["SATKOldN"].shadowColor=Color.new(40,40,40)
    @sprites["SATKOldN"].text=_INTL("{1}",@oldsatk,@oldsatkiv)
    @sprites["SATKOldN"].viewport=@viewport
    @sprites["SATKOldN"].windowskin=nil
    @sprites["SATKOldN"].visible=false
    @sprites["SATKStar"]=IconSprite.new(132,277,@viewport)
      if @oldsatkiv > 30
        @sprites["SATKStar"].setBitmap(filenamRatingS)
      elsif @oldsatkiv > 22 && @oldsatkiv < 31
        @sprites["SATKStar"].setBitmap(filenamRatingA)
      elsif @oldsatkiv > 15 && @oldsatkiv < 23
        @sprites["SATKStar"].setBitmap(filenamRatingB)
      elsif @oldsatkiv > 7 && @oldsatkiv < 16
        @sprites["SATKStar"].setBitmap(filenamRatingC)
      elsif @oldsatkiv > 0 && @oldsatkiv < 8
        @sprites["SATKStar"].setBitmap(filenamRatingD)
      else
        @sprites["SATKStar"].setBitmap(filenamRatingF)
      end
    @sprites["SATKStar"].visible = false
    pbPrepareWindow(@sprites["SDEFOldN"])
    @sprites["SDEFOldN"].x=86
    @sprites["SDEFOldN"].y=288
    @sprites["SDEFOldN"].width=Graphics.width-48
    @sprites["SDEFOldN"].height=Graphics.height
    @sprites["SDEFOldN"].baseColor=Color.new(240,240,240)
    @sprites["SDEFOldN"].shadowColor=Color.new(40,40,40)
    @sprites["SDEFOldN"].text=_INTL("{1}",@oldsdef,@oldsdefiv)
    @sprites["SDEFOldN"].viewport=@viewport
    @sprites["SDEFOldN"].windowskin=nil
    @sprites["SDEFOldN"].visible=false
    @sprites["SDEFStar"]=IconSprite.new(132,310,@viewport)
      if @oldsdefiv > 30
        @sprites["SDEFStar"].setBitmap(filenamRatingS)
      elsif @oldsdefiv > 22 && @oldsdefiv < 31
        @sprites["SDEFStar"].setBitmap(filenamRatingA)
      elsif @oldsdefiv > 15 && @oldsdefiv < 23
        @sprites["SDEFStar"].setBitmap(filenamRatingB)
      elsif @oldsdefiv > 7 && @oldsdefiv < 16
        @sprites["SDEFStar"].setBitmap(filenamRatingC)
      elsif @oldsdefiv > 0 && @oldsdefiv < 8
        @sprites["SDEFStar"].setBitmap(filenamRatingD)
      else
        @sprites["SDEFStar"].setBitmap(filenamRatingF)
      end
    @sprites["SDEFStar"].visible = false
    pbPrepareWindow(@sprites["SPDOldN"])
    @sprites["SPDOldN"].x=86
    @sprites["SPDOldN"].y=320
    @sprites["SPDOldN"].width=Graphics.width-48
    @sprites["SPDOldN"].height=Graphics.height
    @sprites["SPDOldN"].baseColor=Color.new(240,240,240)
    @sprites["SPDOldN"].shadowColor=Color.new(40,40,40)
    @sprites["SPDOldN"].text=_INTL("{1}",@oldspd,@oldspdiv)
    @sprites["SPDOldN"].viewport=@viewport
    @sprites["SPDOldN"].windowskin=nil
    @sprites["SPDOldN"].visible=false
    @sprites["SPDStar"]=IconSprite.new(132,342,@viewport)
      if @oldspdiv > 30
        @sprites["SPDStar"].setBitmap(filenamRatingS)
      elsif @oldspdiv > 22 && @oldspdiv < 31
        @sprites["SPDStar"].setBitmap(filenamRatingA)
      elsif @oldspdiv > 15 && @oldspdiv < 23
        @sprites["SPDStar"].setBitmap(filenamRatingB)
      elsif @oldspdiv > 7 && @oldspdiv < 16
        @sprites["SPDStar"].setBitmap(filenamRatingC)
      elsif @oldspdiv > 0 && @oldspdiv < 8
        @sprites["SPDStar"].setBitmap(filenamRatingD)
      else
        @sprites["SPDStar"].setBitmap(filenamRatingF)
      end
    @sprites["SPDStar"].visible = false
    pbPrepareWindow(@sprites["HPNewN"])
    @sprites["HPNewN"].x=422
    @sprites["HPNewN"].y=160
    @sprites["HPNewN"].width=Graphics.width-48
    @sprites["HPNewN"].height=Graphics.height
    @sprites["HPNewN"].baseColor=Color.new(240,240,240)
    @sprites["HPNewN"].shadowColor=Color.new(40,40,40)
    @sprites["HPNewN"].text=_INTL("{1}",@newhp,@newhpiv)
    @sprites["HPNewN"].viewport=@viewport
    @sprites["HPNewN"].windowskin=nil
    @sprites["HPNewN"].visible=false
    @sprites["HPStarNew"]=IconSprite.new(467,182,@viewport)
      if @newhpiv > 30
        @sprites["HPStarNew"].setBitmap(filenamRatingS)
      elsif @newhpiv > 22 && @newhpiv < 31
        @sprites["HPStarNew"].setBitmap(filenamRatingA)
      elsif @newhpiv > 15 && @newhpiv < 23
        @sprites["HPStarNew"].setBitmap(filenamRatingB)
      elsif @newhpiv > 7 && @newhpiv < 16
        @sprites["HPStarNew"].setBitmap(filenamRatingC)
      elsif @newhpiv > 0 && @newhpiv < 8
        @sprites["HPStarNew"].setBitmap(filenamRatingD)
      else
        @sprites["HPStarNew"].setBitmap(filenamRatingF)
      end
    @sprites["HPStarNew"].visible = false
    pbPrepareWindow(@sprites["ATKNewN"])
    @sprites["ATKNewN"].x=424
    @sprites["ATKNewN"].y=192
    @sprites["ATKNewN"].width=Graphics.width-48
    @sprites["ATKNewN"].width=Graphics.width-48
    @sprites["ATKNewN"].height=Graphics.height
    @sprites["ATKNewN"].baseColor=Color.new(240,240,240)
    @sprites["ATKNewN"].shadowColor=Color.new(40,40,40)
    @sprites["ATKNewN"].viewport=@viewport
    @sprites["ATKNewN"].text=_INTL("{1}",@newatk,@newatkiv)
    @sprites["ATKNewN"].windowskin=nil
    @sprites["ATKNewN"].visible=false
    @sprites["ATKStarNew"]=IconSprite.new(467,214,@viewport)
      if @newatkiv > 30
        @sprites["ATKStarNew"].setBitmap(filenamRatingS)
      elsif @newatkiv > 22 && @newatkiv < 31
        @sprites["ATKStarNew"].setBitmap(filenamRatingA)
      elsif @newatkiv > 15 && @newatkiv < 23
        @sprites["ATKStarNew"].setBitmap(filenamRatingB)
      elsif @newatkiv > 7 && @newatkiv < 16
        @sprites["ATKStarNew"].setBitmap(filenamRatingC)
      elsif @newatkiv > 0 && @newatkiv < 8
        @sprites["ATKStarNew"].setBitmap(filenamRatingD)
      else
        @sprites["ATKStarNew"].setBitmap(filenamRatingF)
      end
    @sprites["ATKStarNew"].visible = false
    pbPrepareWindow(@sprites["DEFNewN"])
    @sprites["DEFNewN"].x=424
    @sprites["DEFNewN"].y=224
    @sprites["DEFNewN"].width=Graphics.width-48
    @sprites["DEFNewN"].height=Graphics.height
    @sprites["DEFNewN"].baseColor=Color.new(240,240,240)
    @sprites["DEFNewN"].shadowColor=Color.new(40,40,40)
    @sprites["DEFNewN"].text=_INTL("{1}",@newdef,@newdefiv)
    @sprites["DEFNewN"].viewport=@viewport
    @sprites["DEFNewN"].windowskin=nil
    @sprites["DEFNewN"].visible=false
    @sprites["DEFStarNew"]=IconSprite.new(467,246,@viewport)
      if @newdefiv > 30
        @sprites["DEFStarNew"].setBitmap(filenamRatingS)
      elsif @newdefiv > 22 && @newdefiv < 31
        @sprites["DEFStarNew"].setBitmap(filenamRatingA)
      elsif @newdefiv > 15 && @newdefiv < 23
        @sprites["DEFStarNew"].setBitmap(filenamRatingB)
      elsif @newdefiv > 7 && @newdefiv < 16
        @sprites["DEFStarNew"].setBitmap(filenamRatingC)
      elsif @newdefiv > 0 && @newdefiv < 8
        @sprites["DEFStarNew"].setBitmap(filenamRatingD)
      else
        @sprites["DEFStarNew"].setBitmap(filenamRatingF)
      end
    @sprites["DEFStarNew"].visible = false
    pbPrepareWindow(@sprites["SATKNewN"])
    @sprites["SATKNewN"].x=424
    @sprites["SATKNewN"].y=255
    @sprites["SATKNewN"].width=Graphics.width-48
    @sprites["SATKNewN"].height=Graphics.height
    @sprites["SATKNewN"].baseColor=Color.new(240,240,240)
    @sprites["SATKNewN"].shadowColor=Color.new(40,40,40)
    @sprites["SATKNewN"].text=_INTL("{1}",@newsatk,@newsatkiv)
    @sprites["SATKNewN"].viewport=@viewport
    @sprites["SATKNewN"].windowskin=nil
    @sprites["SATKNewN"].visible=false
    @sprites["SATKStarNew"]=IconSprite.new(467,277,@viewport)
      if @newsatkiv > 30
        @sprites["SATKStarNew"].setBitmap(filenamRatingS)
      elsif @newsatkiv > 22 && @newsatkiv < 31
        @sprites["SATKStarNew"].setBitmap(filenamRatingA)
      elsif @newsatkiv > 15 && @newsatkiv < 23
        @sprites["SATKStarNew"].setBitmap(filenamRatingB)
      elsif @newsatkiv> 7 && @newsatkiv < 16
        @sprites["SATKStarNew"].setBitmap(filenamRatingC)
      elsif @newsatkiv > 0 && @newsatkiv < 8
        @sprites["SATKStarNew"].setBitmap(filenamRatingD)
      else
        @sprites["SATKStarNew"].setBitmap(filenamRatingF)
      end
    @sprites["SATKStarNew"].visible = false
    pbPrepareWindow(@sprites["SDEFNewN"])
    @sprites["SDEFNewN"].x=424
    @sprites["SDEFNewN"].y=288
    @sprites["SDEFNewN"].width=Graphics.width-48
    @sprites["SDEFNewN"].height=Graphics.height
    @sprites["SDEFNewN"].baseColor=Color.new(240,240,240)
    @sprites["SDEFNewN"].shadowColor=Color.new(40,40,40)
    @sprites["SDEFNewN"].text=_INTL("{1}",@newsdef,@newsdefiv)
    @sprites["SDEFNewN"].viewport=@viewport
    @sprites["SDEFNewN"].windowskin=nil
    @sprites["SDEFNewN"].visible=false
    @sprites["SDEFStarNew"]=IconSprite.new(467,310,@viewport)
      if @newsdefiv > 30
        @sprites["SDEFStarNew"].setBitmap(filenamRatingS)
      elsif @newsdefiv > 22 && @newsdefiv < 31
        @sprites["SDEFStarNew"].setBitmap(filenamRatingA)
      elsif @newsdefiv > 15 && @newsdefiv < 23
        @sprites["SDEFStarNew"].setBitmap(filenamRatingB)
      elsif @newsdefiv > 7 && @newsdefiv < 16
        @sprites["SDEFStarNew"].setBitmap(filenamRatingC)
      elsif @newsdefiv > 0 && @newsdefiv < 8
        @sprites["SDEFStarNew"].setBitmap(filenamRatingD)
      else
        @sprites["SDEFStarNew"].setBitmap(filenamRatingF)
      end
    @sprites["SDEFStarNew"].visible = false
    pbPrepareWindow(@sprites["SPDNewN"])
    @sprites["SPDNewN"].x=424
    @sprites["SPDNewN"].y=320
    @sprites["SPDNewN"].width=Graphics.width-48
    @sprites["SPDNewN"].height=Graphics.height
    @sprites["SPDNewN"].baseColor=Color.new(240,240,240)
    @sprites["SPDNewN"].shadowColor=Color.new(40,40,40)
    @sprites["SPDNewN"].text=_INTL("{1}",@newspd,@newspdiv)
    @sprites["SPDNewN"].viewport=@viewport
    @sprites["SPDNewN"].windowskin=nil
    @sprites["SPDNewN"].visible=false
    @sprites["SPDStarNew"]=IconSprite.new(467,342,@viewport)
      if @newspdiv > 30
        @sprites["SPDStarNew"].setBitmap(filenamRatingS)
      elsif @newspdiv > 22 && @newspdiv < 31
        @sprites["SPDStarNew"].setBitmap(filenamRatingA)
      elsif @newspdiv > 15 && @newspdiv < 23
        @sprites["SPDStarNew"].setBitmap(filenamRatingB)
      elsif @newspdiv > 7 && @newspdiv < 16
        @sprites["SPDStarNew"].setBitmap(filenamRatingC)
      elsif @newspdiv > 0 && @newspdiv < 8
        @sprites["SPDStarNew"].setBitmap(filenamRatingD)
      else
        @sprites["SPDStarNew"].setBitmap(filenamRatingF)
      end
    @sprites["SPDStarNew"].visible = false
        @sprites["HPOld"].visible=true
        @sprites["ATKOld"].visible=true
        @sprites["DEFOld"].visible=true
        @sprites["SATKOld"].visible=true
        @sprites["SDEFOld"].visible=true
        @sprites["SPDOld"].visible=true
        @sprites["HPNew"].visible=true
        @sprites["ATKNew"].visible=true
        @sprites["DEFNew"].visible=true
        @sprites["SATKNew"].visible=true
        @sprites["SDEFNew"].visible=true
        @sprites["SPDNew"].visible=true
        @sprites["PkmnName"].visible=true
        @sprites["PkmnLevel50"].visible=true
        @sprites["PkmnAbility"].visible=true
        @sprites["HPOldN"].visible=true
        @sprites["ATKOldN"].visible=true
        @sprites["DEFOldN"].visible=true
        @sprites["SATKOldN"].visible=true
        @sprites["SDEFOldN"].visible=true
        @sprites["SPDOldN"].visible=true
        @sprites["HPNewN"].visible=true
        @sprites["ATKNewN"].visible=true
        @sprites["DEFNewN"].visible=true
        @sprites["SATKNewN"].visible=true
        @sprites["SDEFNewN"].visible=true
        @sprites["SPDNewN"].visible=true
    @sprites["SPDStarNew"].visible = true
    @sprites["SDEFStarNew"].visible = true
    @sprites["SATKStarNew"].visible = true
    @sprites["DEFStarNew"].visible = true
    @sprites["ATKStarNew"].visible = true
    @sprites["HPStarNew"].visible = true
    @sprites["SPDStar"].visible = true
    @sprites["SDEFStar"].visible = true
    @sprites["SATKStar"].visible = true
    @sprites["DEFStar"].visible = true
    @sprites["ATKStar"].visible = true
    @sprites["HPStar"].visible = true
		end
        elsif @selection==5
          pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
@pkmniv = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_rein_stone? })
}
if @pkmniv != nil
item = @pkmniv
filenamH =GameData::Item.icon_filename(@pkmniv) 
@pkmnivsp = @pkmniv
@pkmniv = GameData::Item.get(item).name
@icons["itemResult3"].setBitmap(filenamH)
    @icons["itemResult6"]=IconSprite.new(120,170,@viewport)
    @icons["itemResult6"].setBitmap(filenamH)
    @icons["itemResult6"].visible=true
end
       elsif @selection==7 && @inui == true
		  @sprites["HPOld"].visible=false
        @sprites["ATKOld"].visible=false
        @sprites["DEFOld"].visible=false
        @sprites["SATKOld"].visible=false
        @sprites["SDEFOld"].visible=false
        @sprites["SPDOld"].visible=false
        @sprites["HPNew"].visible=false
        @sprites["ATKNew"].visible=false
        @sprites["DEFNew"].visible=false
        @sprites["SATKNew"].visible=false
        @sprites["SDEFNew"].visible=false
        @sprites["SPDNew"].visible=false
        @sprites["PkmnName"].visible=false
        @sprites["PkmnLevel50"].visible=false
        @sprites["PkmnAbility"].visible=false
        @sprites["HPOldN"].visible=false
        @sprites["ATKOldN"].visible=false
        @sprites["DEFOldN"].visible=false
        @sprites["SATKOldN"].visible=false
        @sprites["SDEFOldN"].visible=false
        @sprites["SPDOldN"].visible=false
        @sprites["HPNewN"].visible=false
        @sprites["ATKNewN"].visible=false
        @sprites["DEFNewN"].visible=false
        @sprites["SATKNewN"].visible=false
        @sprites["SDEFNewN"].visible=false
        @sprites["SPDNewN"].visible=false
    @sprites["SPDStarNew"].visible = false
    @sprites["SDEFStarNew"].visible = false
    @sprites["SATKStarNew"].visible = false
    @sprites["DEFStarNew"].visible = false
    @sprites["ATKStarNew"].visible = false
    @sprites["HPStarNew"].visible = false
    @sprites["SPDStar"].visible = false
    @sprites["SDEFStar"].visible = false
    @sprites["SATKStar"].visible = false
    @sprites["DEFStar"].visible = false
    @sprites["ATKStar"].visible = false
    @sprites["HPStar"].visible = false
    @sprites["pokeview"].visible = false
		if pbConfirmMessage(_INTL("Do you wish to quit?",@reincarnpkmnsp.name))
		   break
		else
          pbFadeOutIn(99999){
    @sprites["F"].visible=true
    @sprites["E"].visible=true
    @sprites["D"].visible=true
    @sprites["C"].visible=true
    @sprites["B"].visible=true
    @sprites["A"].visible=true
	if donator2pokemonicon1 !=0
    donator2pokemonicon1.visible=false
	end
	if donator2pokemonicon2 !=0
    donator2pokemonicon2.visible=false
	end
	if donatorpokemonicon2 !=0
    donatorpokemonicon2.visible=false
	end
	if donatorpokemonicon1 !=0
    donatorpokemonicon1.visible=false
	end
	if reincarnpokemonicon !=0
    reincarnpokemonicon.visible=false
	end
	if reincarnpokemonicon1 !=0
    reincarnpokemonicon1.visible=false
	end
	@reincarnpkmn=0
	@donApkmn=0
	@donBpkmn=0
	@pkmnnat1=0
	@pkmnnat2=0
	@pkmniv=0
    @icons["itemResult6"].visible=false
    @icons["itemResult2"].visible=false
    @icons["itemResult4"].visible=false
    @icons["itemResult1"].visible=false
    @sprites["donatorAe"].visible = false
    @sprites["donatorBe"].visible = false
    @sprites["donatorAe"].visible = false
    @sprites["nature2e"].visible = false
    @sprites["ivse"].visible = false
    @sprites["donatorB"].visible = true
    @sprites["reincarnator"].visible = true
    @sprites["nature2"].visible = true
    @sprites["ivs"].visible = true
    @sprites["begin"].visible = true
    @sprites["nature2e"].visible = false
    @sprites["nature1e"].visible = false
    @sprites["ivse"].visible = false
    @sprites["donatorB"].visible = true
    @sprites["donatorA"].visible = true
    @sprites["reincarnatore"].visible = true
    @sprites["nature2"].visible = true
    @sprites["pokemon"].visible = false
    @sprites["nature1"].visible = true
    @sprites["ivs"].visible = true
    @sprites["begin"].visible = true
    @sprites["Item3Orb"].x=166
    @sprites["Item3Orb"].y=87
    @sprites["Item2Orb"].x=91
    @sprites["Item2Orb"].y=87
    @sprites["Item1Orb"].x=128
    @sprites["Item1Orb"].y=185
    @sprites["Don2Orb"].x=178
    @sprites["Don2Orb"].y=210
    @sprites["Don1Orb"].x=65
    @sprites["Don1Orb"].y=210
    @sprites["ReOrb"].x=122
    @sprites["ReOrb"].y=91
    @sprites["sigil"].x=-30
    @sprites["sigil"].y=25
    @sprites["begin"].y=350
		  if @sprites["icon_#{6}"]!=nil
          @sprites["icon_#{6}"] = nil
		  end
		  if @sprites["icon_#{5}"]!=nil
          @sprites["icon_#{5}"] = nil
		  end
		  if @sprites["icon_#{6}"]!=nil
          @sprites["icon_#{6}"] = nil
		  end
		  if @sprites["icon_#{4}"]!=nil
          @sprites["icon_#{4}"] = nil
		  end
		  if @sprites["icon_#{5}"]!=nil
          @sprites["icon_#{5}"] = nil
		  end
	@reincarnpkmn=nil
	@donApkmn=nil
	@donBpkmn=nil
	@pkmnnat1=nil
	@pkmnnat2=nil
	@pkmniv=nil
	@sprites["A"].text=_INTL("Recipient",@reincarnpkmn)
    @sprites["B"].text=_INTL("Donor 1",@donApkmn)
    @sprites["C"].text=_INTL("Donor 2",@donBpkmn)
    @sprites["D"].text=_INTL("Stat Boon", @pkmnnat1)
    @sprites["E"].text=_INTL("Stat Bane",@pkmnnat2)
    @sprites["F"].text=_INTL("Stat Modifier",@pkmniv)
	      @selection = 0
			  @donBpkmnsp = 0
			  @donApkmnsp = 0
			  @reincarnpkmnsp = 0
	
		  $game_variables[3] = nil
		  $game_variables[1] = nil
	      @inui = false
		}  
		end
       end
      end
       #Cancel
      if Input.trigger?(Input::BACK)
		if pbConfirmMessage(_INTL("Do you wish to quit?"))
        break
		end
      end     
	  if Input.trigger?(Input::SPECIAL)
	  end
    end
  
end
def pbRefresh
end




#Call Reincarnate.reincarnationWindow
module Reincarnate
  def self.reincarnationWindow
	pbBGMFade(1.0)
          pbFadeOutIn {
  reScene=Reincarnation_UI.new
  reScene.pbStartScene
  recar=reScene.pbSelectreincarnation
  reScene.pbEndScene}
 end
end