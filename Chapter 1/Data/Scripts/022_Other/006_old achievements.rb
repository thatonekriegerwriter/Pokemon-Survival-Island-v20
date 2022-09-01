###---ACHIEVEMENTS
class Achievements_Scene
#################################
## Configuration
  ACHIEVEMENTNAMEBASECOLOR=Color.new(88,88,80)
  ACHIEVEMENTNAMESHADOWCOLOR=Color.new(168,184,184)
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
    @sprites={}
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/achievementsPage")
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    coord=0
    @imagepos=[]
    @selectX=32
    @selectY=36
    @achList=AchievementsList.getAchievements
    for i in 0..@achList.length
      if $game_switches[(i+100)]==true
        @imagepos.push(["Graphics/Pictures/achievement#{i}",32+64*(coord%7),36+64*(coord/7).floor,
             0,0,48,48])
        coord+=1
      elsif $game_switches[(i+100)]==false
        @imagepos.push(["Graphics/Pictures/achievementEmpty",32+64*(coord%7),36+64*(coord/7).floor,
             0,0,48,48])
        coord+=1
      break if coord>=28
      end
    end
    @sprites["achievementName"]=Window_UnformattedTextPokemon.new("")
    @sprites["achievementText"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["achievementName"])
    @sprites["achievementName"].x=24
    @sprites["achievementName"].y=268
    @sprites["achievementName"].width=Graphics.width-48
    @sprites["achievementName"].height=Graphics.height
    @sprites["achievementName"].baseColor=Color.new(160,160,160)
    @sprites["achievementName"].shadowColor=Color.new(30,30,30)
    @sprites["achievementName"].visible=true
    @sprites["achievementName"].viewport=@viewport
    @sprites["achievementName"].windowskin=nil
    pbPrepareWindow(@sprites["achievementText"])
    @sprites["achievementText"].x=30
    @sprites["achievementText"].y=294
    @sprites["achievementText"].width=Graphics.width-48
    @sprites["achievementText"].height=Graphics.height
    @sprites["achievementText"].baseColor=Color.new(160,160,160)
    @sprites["achievementText"].shadowColor=Color.new(40,40,40)
    @sprites["achievementText"].visible=true
    @sprites["achievementText"].viewport=@viewport
    @sprites["achievementText"].windowskin=nil
    @sprites["selector"]=IconSprite.new(@selectX,@selectY,@viewport)
    @sprites["selector"].setBitmap("Graphics/Pictures/achievementSelect")
    pbDeactivateWindows(@sprites)
    pbRefresh
    pbFadeInAndShow(@sprites)
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def pbRefresh
    #@sprites["background"].setBitmap(sprintf("Graphics/Pictures/charselect#{playerCharacter}"))
  end
  
# Script that manages button inputs
  def pbSelectAchievement
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    pbSetSystemFont(overlay)
    pbDrawImagePositions(overlay,@imagepos)
    loop do
      Graphics.update
      Input.update
      self.update
      @sprites["selector"].x=@selectX
      @sprites["selector"].y=@selectY
      selectionNum=@selection
      @achievementName=AchievementsList.getAchievements[selectionNum][1]
      @achievementText=AchievementsList.getAchievements[selectionNum][2]
      @sprites["achievementName"].text=_INTL("{1}",@achievementName)
      @sprites["achievementText"].text=_INTL("{1}",@achievementText)
      if Input.trigger?(Input::LEFT)
        if @selection==0||@selection==7||@selection==14||@selection==21
          @selectX=416
          @selection+=6
        else
          @selectX-=64
          @selection-=1
        end
      elsif Input.trigger?(Input::RIGHT)
        if @selection==6||@selection==13||@selection==20||@selection==27
          @selectX=32
          @selection-=6
        else
          @selectX+=64
          @selection+=1
        end
      end
      
      if Input.trigger?(Input::UP)
        if @selection>6
          @selectY-=64
          @selection-=7
        else
          @selectY=228
          @selection+=21
        end
      elsif Input.trigger?(Input::DOWN)
      if @selection<21
          @selectY+=64
          @selection+=7
        else
          @selectY=36
          @selection-=21
        end
      end
      
       #Cancel
      if Input.trigger?(Input::B)
        return -1
      end     
    end
  end
end



class PokemonAchievementSelect
  attr_accessor :lastAchievement
  attr_reader :Achievements
  def numChars()
    return Achievements_Scene.achievementsList().length-1
  end
  def initialize
    @lastAchievement=1
    @achievements=[]
    @choices=[]
    # Initialize each playerCharacter of the array
    for i in 0..Achievements_Scene.achievementsList
      @achievements[i]=[]
      @choices[i]=0
    end
  end
  def achievements
    rearrange()
    return @achievements
  end

  def rearrange()
    if @achievements.length==6 && Achievements_Scene.achievementsList==28
      newAchievements=[]
      for i in 0..28
        newAchievements[i]=[]
        @choices[i]=0 if !@choices[i]
      end
      @achievements=newAchievements
    end
  end
end

module AchievementsList
  def self.getAchievements
    @achievementsList=[
      [0,"The Violence Begins","Win a battle against a wild Pokemon."],
      [1,"Fortress of Teamwork","Find and activate all Class statues."],
      [2,"The End","Complete the Survival Island story."],
      [3,"The Long Walk","Walk 10,000 steps."],
      [4,"Primary Colour Pokedex","Catch all 151 Kanto-region Pokemon."],
      [5,"Precious Metal Pokedex","Catch all 100 Johto-region Pokemon."],
      [6,"Gemstone Pokedex","Catch all 135 Hoenn-region Pokemon."],
      [7,"Legen...(wait for it)...DARY","Catch all Legendary Pokemon."],
      [8,"Gotta Catch 'em All","Catch all 386 Pokemon."],
      [9,"Futility's Triumph","Win a battle using 'struggle'."],
      [10,"Nuzlocke and Load","Start and finish the game in Nuzlocke Mode."],
      [11,"Impractical Romance","Breed a Skitty and Wailord."],
      [12,"Sweet Tooth","Craft 50 Rare Candies."],
      [13,"One-Hit Wonder","Land 15 One-Hit K-Os."],
      [14,"Pure Hatred","Bring a Pokemon's happiness down to 0."],
      [15,"Just Saiyan","Land a move that deals over 9000 base damage."],
      [16,"Disproportionate Retribution","Land a move that deals over 100,000 base damage."],
      [17,"Trippin' Balls","Craft 500 of any Pokeball."],
      [18,"Explorer","Walk off the beaten path."],
      [19,"N/A",""],
      [20,"N/A",""],
      [21,"N/A",""],
      [22,"N/A",""],
      [23,"N/A",""],
      [24,"N/A",""],
      [25,"N/A",""],
      [26,"N/A",""],
      [27,"N/A",""]
    ]
    return @achievementsList
  end
end

#Call Achievements.AchievementWindow
module Achievements  
  def self.AchievementWindow()
  achievementScene=Achievements_Scene.new
  achievementScene.pbStartScene($PokemonAchievementSelect)
  achievement=achievementScene.pbSelectAchievement
  achievementScene.pbEndScene
 end
end

