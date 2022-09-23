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