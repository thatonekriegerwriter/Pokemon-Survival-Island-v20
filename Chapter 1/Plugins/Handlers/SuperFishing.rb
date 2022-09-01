class SuperFishingScene
  # Size of the valid bar points between the left and the center
  BAR_LEFT_SIZE = 128 
  ARROW_SPEED = 16
  
  def pbStartScene
    @sprites={} 
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites["bar"]=IconSprite.new(0,0,@viewport)
    @sprites["bar"].setBitmap("Graphics/Pictures/superRodBar")
    @sprites["bar"].x=(Graphics.width-@sprites["bar"].bitmap.width)/2
    @sprites["bar"].y=Graphics.height-50
    arrow=AnimatedBitmap.new("Graphics/Pictures/Arrow")
    @sprites["arrow"]=BitmapSprite.new(arrow.bitmap.width/2,arrow.bitmap.height/2,@viewport)
    @sprites["arrow"].bitmap.blt(0,0,arrow.bitmap,Rect.new(
        0,@sprites["arrow"].bitmap.height,@sprites["arrow"].bitmap.width, @sprites["arrow"].bitmap.height
    ))
    @arrowXMiddle = @sprites["bar"].x-@sprites["arrow"].bitmap.width/2+4+BAR_LEFT_SIZE
    @sprites["arrow"].x = @arrowXMiddle-BAR_LEFT_SIZE
    @sprites["arrow"].y = @sprites["bar"].y-28
    @sprites["messagebox"]=Window_AdvancedTextPokemon.new("")
    @sprites["messagebox"].viewport=@viewport
    pbBottomLeftLines(@sprites["messagebox"],2)
    @sprites["messagebox"].z = @sprites["bar"].z-1
    @moving=true
    @right=false
    @result=nil
  end

  def pbMain
    @frameCount=-1
    loop do
      Graphics.update
      Input.update
      self.update
      pbUpdateSceneMap
      @frameCount+=1
      if @result!=nil
         break if @waitFrame<@frameCount
         next
      end
      onPress if Input.trigger?(Input::C) && @moving
      @moving = true if !@moving && @waitFrame<=@frameCount
      if @moving
        @right = !@right if  @sprites["arrow"].x==@arrowXMiddle-BAR_LEFT_SIZE ||  @sprites["arrow"].x==@arrowXMiddle+BAR_LEFT_SIZE
        @sprites["arrow"].x+= @right ? ARROW_SPEED : -ARROW_SPEED
      end
    end
    return @result
  end
  
  def onPress
    pbSEPlay($data_system.decision_se)
    arrowX = @sprites["arrow"].x
    @score= -(arrowX>@arrowXMiddle ? arrowX-@arrowXMiddle : @arrowXMiddle-arrowX)/ARROW_SPEED
    @moving = false
    @waitFrame=@frameCount+40
    case(@score)
    when 0
      @result = true
    when -1
      @result = true if rand(100) < 25
    else
      @result = false
    end
    pbPlayerExclaim if @result==nil
  end  

  def update
    pbUpdateSpriteHash(@sprites)
  end
  
  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class SuperFishingScreen
  def initialize(scene)
    @scene=scene
  end

  def pbStartScreen
    @scene.pbStartScene
    ret=@scene.pbMain
    @scene.pbEndScene
    return ret
  end
end

def pbSuperFishing
  scene=SuperFishingScene.new
  screen=SuperFishingScreen.new(scene)
  return screen.pbStartScreen
end






#===============================================================================
# * One screen Day-Care Checker item - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It makes a One screen Day-Care Checker
# (like in DPP) activated by item. This display the pokémon sprite, names,
# levels, genders and if them generate an egg.
#
#===============================================================================
#
#
#
#
#
#   pbFadeOutIn(99999){ 
#     scene=DayCareCheckerScene.new
#     screen=DayCareChecker.new(scene)
#     screen.startScreen
#   }
# To this script works, put it above main, put a 480x320 background in 
# DCCBACKPATH location and, like any item, you need to add in the "items.txt"
# and in the script. There an example below using the name DAYCARESIGHT, but
# you can use any other name changing the DDCITEM and the item that be added in
# txt. You can change the internal number too:
#
# 631,DAYCARESIGHT,DayCare Sight,8,0,"A visor that can be use for see certains Pokémon in Day-Care to monitor their growth.",2,0,6
# 
#===============================================================================

 # Change this and the item.txt if you wish another name
DCCBACKPATH= "Graphics/Pictures/dccbackground" # You can change if you wish 
# If you wish that the pokémon is positioned like in battle (have the distance
# defined in metadata, even the BattlerAltitude) change the below line to true
DDCBATTLEPOSITION = false

class DayCareCheckerScene  
  def startScene
    @sprites={}
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @pkmn1=$PokemonGlobal.daycare[0][0]
    @pkmn2=$PokemonGlobal.daycare[1][0]
    # If you wish that if there only one pokémon, it became right 
    # positioned, them uncomment the four below lines
    #if !@pkmn1 && @pkmn2
    #  @pkmn1=@pkmn2
    #  @pkmn2=nil
    #end  
    textPositions=[]
    baseColor=Color.new(12*8,12*8,12*8)
    shadowColor=Color.new(26*8,26*8,25*8)
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap(DCCBACKPATH)
    pokemony=128
    pokemonyadjust=pokemony-32
    if @pkmn1
      @sprites["pokemon1"]=PokemonSprite.new(@viewport)
      @sprites["pokemon1"].setPokemonBitmap(@pkmn1)
      @sprites["pokemon1"].mirror=true
      pbPositionPokemonSprite(@sprites["pokemon1"],32,pokemony)
      if DDCBATTLEPOSITION
        @sprites["pokemon1"].y=pokemonyadjust+adjustBattleSpriteY(@sprites["pokemon1"],@pkmn1.species,1)
      end
      textPositions.push([
        _INTL("{1} Lv{2}{3}",@pkmn1.name,@pkmn1.level.to_s,genderString(@pkmn1.gender)),32,46,false,baseColor,shadowColor
      ])
    end
    if @pkmn2
      @sprites["pokemon2"]=PokemonSprite.new(@viewport)
      @sprites["pokemon2"].setPokemonBitmap(@pkmn2)
      pbPositionPokemonSprite(@sprites["pokemon2"],312,pokemony)
      if DDCBATTLEPOSITION
        @sprites["pokemon2"].y==pokemonyadjust + adjustBattleSpriteY(@sprites["pokemon2"],@pkmn2.species,1)
      end
      textPositions.push([
        _INTL("{1} Lv{2}{3}",@pkmn2.name,@pkmn2.level.to_s,genderString(@pkmn2.gender)),464,46,true,baseColor,shadowColor
      ])
    end
    if $PokemonGlobal.daycareEgg==1
      fSpecies = pbDayCareGenerateEggFSpecies(@pkmn1,@pkmn2)
      speciesAndForm = pbGetSpeciesFromFSpecies(fSpecies)
      species = speciesAndForm[0]
      form = speciesAndForm[1]
      @sprites["egg"]=IconSprite.new(156,pokemony+16,@viewport)
      @sprites["egg"].setBitmap(EggType.eggPicture(species,form,false))
      # Uncomment the below line to only a egg shadow be show
      # @sprites["egg"].color=Color.new(0,0,0,255)    
    end
    @sprites["overlay"]=Sprite.new(@viewport)
    @sprites["overlay"].bitmap=BitmapWrapper.new(Graphics.width,Graphics.height)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbDrawTextPositions(@sprites["overlay"].bitmap,textPositions) if !textPositions.empty?
    pbFadeInAndShow(@sprites) { update }
  end

  def genderString(gender)
    ret="  "
    if gender==0
      ret=" ♂"
    elsif gender==1
      ret=" ♀"
    end  
    return ret
  end  

  def middleScene
    loop do
      Graphics.update
      Input.update
      self.update
      break if Input.trigger?(Input::B) || Input.trigger?(Input::C)
    end 
  end

  def update
    pbUpdateSpriteHash(@sprites)
  end

  def endScene
    pbFadeOutAndHide(@sprites) { update }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class DayCareChecker
  def initialize(scene)
    @scene=scene
  end

  def startScreen
    @scene.startScene
    @scene.middleScene
    @scene.endScene
  end
end

# Item handlers
