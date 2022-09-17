
class AchievementUnlockWindow
  def initialize(number)
    @achName=AchievementsList.getAchievements[number][1]
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
  if $game_switches[(1201+number)]==true
  return 
  else
  $game_switches[(1201+number)]=true
  pbMEPlay("Bug catching 3rd")
  AchievementUnlockWindow.new(number)
  end
end
###---EDIT END---###