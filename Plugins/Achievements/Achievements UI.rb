###---ACHIEVEMENTS
class AchievementUnlockWindow
  def initialize(number)
    @achName=AchievementsList.getAchievements[number][0]
    #@achievementID=$game_map.map_id
    @window=Window_AdvancedTextPokemon.new("")
    Kernel.pbMessage(_INTL("\\ts[]\\w[textbox9]\\wu\\wtnp[15]\\op<icon=bagPocket3>Achievement Unlocked: {1}\\cl",@achName))
    @window.width=256
    @window.height=96
    @window.x=@window.width-256
    @window.y=-@window.height
    @window.z=99999
    @frames=0
  end

  def disposed?
    @window.disposed?
  end

  def dispose
    @window.dispose
  end

  def update
    return if @window.disposed?
    @window.update
    if $game_temp.message_window_showing
      @window.dispose
      return
    end
    if @frames>80
      @window.y-=4
      @window.dispose if @window.y+@window.height<0
    else
      @window.y+=4 if @window.y<0
      @frames+=1
    end
  end
end


def pbAchievementGet(number)
  if $PokemonGlobal.achievements[number][0]==true
  $PokemonGlobal.achievements[number][1] = 0 if $PokemonGlobal.achievements[number][1]==false
  $PokemonGlobal.achievements[number][1]+=1
  return 
  else
  $PokemonGlobal.achievements[number][0]=true
  $PokemonGlobal.achievements[number][1] = 0 if $PokemonGlobal.achievements[number][1]==false
  $PokemonGlobal.achievements[number][1]+=1
  pbMEPlay("Bug catching 3rd")
  AchievementUnlockWindow.new(number)
  end
  
end







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
    @sprites["background"].setBitmap("Graphics/Pictures/AchievementsC/achievementsPage")
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    coord=0
    @imagepos=[]
    @selectX=32
    @selectY=36
    @achList=AchievementsList.getAchievements
    for i in 0..@achList.length
      if $PokemonGlobal.achievements[i][0]==true
        @imagepos.push(["Graphics/Pictures/AchievementsC/achievement#{i}",32+64*(coord%7),36+64*(coord/7).floor,
             0,0,48,48])
        coord+=1
      elsif $PokemonGlobal.achievements[i][0]==false
        @imagepos.push(["Graphics/Pictures/AchievementsC/achievementEmpty",32+64*(coord%7),36+64*(coord/7).floor,
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
    @sprites["selector"].setBitmap("Graphics/Pictures//AchievementsC/achievementSelect")
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
      @achievementName=AchievementsList.getAchievements[selectionNum][0]
      @achievementText=AchievementsList.getAchievements[selectionNum][1]
      @sprites["achievementText"].text=_INTL("???")
      @sprites["achievementName"].text=_INTL("{1}",@achievementName)
      @sprites["achievementText"].text=_INTL("{1}",@achievementText) if $PokemonGlobal.achievements[selectionNum][0]==true
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

class PokemonGlobalMetadata
  attr_accessor :achievements
  
  
  def achievements
    @achievements = get_achievements if !@achievements
	 if @achievements.length < AchievementsList.getAchievements.length
	   amt = AchievementsList.getAchievements.length-@achievements.length
	   amt.times do |i|
	    @achievements << [false,0]
	   end
	 end
    return @achievements
  end
  
  def get_achievements
     achievements=[]
    AchievementsList.getAchievements.length.times do |i|
	    achievements << [false,0]
	end
    return achievements
  end
end

class PokemonAchievementSelect
  attr_accessor :lastAchievement
  attr_reader :Achievements
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
    #rearrange()
    return @achievements
  end
  
  
  def numChars()
    return Achievements_Scene.achievementsList().length-1
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
      ["Survive","Begin your stay on the Island."], #0
      ["Explorer","Head off the beaten path."], #1
      ["Thrive","Place an Item."], #2
	  
	  
	  
	  
      ["The Violence Begins","Win a Command Battle against a wild POKéMON."], #3
      ["Futility's Triumph","Win a Command Battle using 'Struggle'."], #4
      ["One-Hit Wonder","Land 15 One-Hit K-Os in either a Command or Field Battle."], #5
      ["I'll Handle This.","Win a Field Battle personally."], #6
      ["Riskier Plays.","Win a Field Battle using a POKéMON."], #7
      ["Took the Bullet","Die in Field Battle with all your POKéMON healthy."], #8
	  
	  
	  
	  
	  
      ["Filled with Malice","Catch a POKéMON with a Hateful Nature."], #9
      ["Pure Hatred","Bring a POKéMON's happiness down to 0."], #10
      ["Ain't Loyal","Bring a POKéMON's loyalty down to 0."], #11
      ["Fallen Comrade","Have a POKéMON die."], #12
      ["Bad Romance","Breed a Skitty and Wailord."], #13
	  
      ["Watermelon Festival","Grow a Plant of Superb Quality."], #14
      ["5-Star Chef","Cook a Meal of Superb Quality."], #15
      ["Gonna Catch Them All","Make more lifetime POKéBALLs than there are POKéMON types."], #16
      ["Fished a Big One","Fish up a Magikarp of Extreme Size."], #17
      ["On the Rocks","Have your Pickaxe or Hammer break while Mining."], #18
	  
	  
	  
      ["Abandoned by a Comrade","Have a POKéMON you sent on an Adventure ditch you."],#19
      ["Full House","Have a Full Party both with you and on an Adventure."],#20
      ["Dungeon Dove","Have a POKéMON complete a Dungeon."],#21
	  
	  
      ["???",""],#22
      ["???",""],#23
      ["???",""],#24
      ["???",""],#25
	  
	  
      ["Nuzlocke and Load","Start the game in Nuzlocke Mode."], #26
      ["Dead on Survival","Start the game in Survival Mode."], #27
      ["True Story","Complete the game with both Nuzlocke and Survival Mode on the entire time."] #28
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


EventHandlers.add(:on_end_battle, :check_achievements,
  proc { |decision, canLose|
  if decision ==1
      pbAchievementGet(3)
  end
  }
)