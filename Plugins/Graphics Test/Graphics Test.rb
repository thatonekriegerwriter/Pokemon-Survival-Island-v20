module BorderSettings
 #OFFSETX = 100
 #OFFSETY = 100
 #SCREENPOSX = OFFSETX/2
 #SCREENPOSY = OFFSETY/2
 
 BORDERSENABLED = true
 SELECTEDBORDER = 0 
 
 BORDERS = [["Graphics/Pictures/Borders/empty",0,0, 0, 0],
 ["Graphics/Pictures/Borders/GBA",-28,-28, 100, 100],
 ["Graphics/Pictures/Borders/GBC",-28,-28, 100, 100],
 ["Graphics/Pictures/Borders/GB",-28,-28, 100, 100],
 ["Graphics/Pictures/Borders/Mini",-28,-28, 100, 100],
 ["Graphics/Pictures/Borders/custom",-28,-28, 100, 100]]

end
class PokemonSystem
  attr_accessor :cur_border
  attr_accessor :borders
  attr_accessor :offsetx
  attr_accessor :offsety
   
  def cur_border
   @cur_border = 0 if @cur_border.nil?
   return @cur_border
  end
  def borders
   @borders = Settings::BORDERS 
   return @borders
  end
   
   def offsetx
    return $PokemonSystem.borders[$PokemonSystem.cur_border][3]
   end
   def offsety
    return $PokemonSystem.borders[$PokemonSystem.cur_border][4]
   end
   def screenposx
    offset = (offsety/$PokemonSystem.borders[$PokemonSystem.cur_border][5])+$PokemonSystem.borders[$PokemonSystem.cur_border][7]
	 #puts "screenposx: #{offset}"
    return offset
   end
   def screenposy
    offset = (offsety/$PokemonSystem.borders[$PokemonSystem.cur_border][6])+$PokemonSystem.borders[$PokemonSystem.cur_border][8]
	 #puts "screenposy: #{offset}"
    return offset
   end
end


#module Graphics
#  if !self.respond_to?("width")
#    def self.width; return 640; end
#  end
#  if !self.respond_to?("height")
#    def self.height; return 480; end
#  end
#end

#module Graphics
#    def self.width
#  	  return 640
#    end
#    def self.height
#	  return 480
#    end
#end

# I'm sorry.
module Graphics
  # I'm sorry, again.
  def self.width
    width = 640
    #return Settings::SCREEN_WIDTH if BorderSettings::OFFSETX!=0
    width = Settings::SCREEN_WIDTH 
	return width
  end
  # I'm really sorry.
  def self.height
    height = 480
   
    #return Settings::SCREEN_HEIGHT if BorderSettings::OFFSETY!=0
    height = Settings::SCREEN_HEIGHT 
	return height
  end
end

class Viewport
  attr_accessor :x 
  attr_accessor :y
 alias :viewportinitold :initialize
  def initialize(x, y, width, height)
   x+=$PokemonSystem.screenposx
   y+=$PokemonSystem.screenposy
   viewportinitold(x, y, width, height)
  end
end
class LocationWindow
 alias :locationinitold :initialize
  def initialize(name)
    @window = Window_AdvancedTextPokemon.new(name)
    @window.resizeToFit(name, Graphics.width)
    @window.x        = 0-$PokemonSystem.screenposx
    @window.y        = 0-$PokemonSystem.screenposy
    @window.viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @window.viewport.z = 99999
    @currentmap = $game_map.map_id
    @frames = 0
  end

  def update
    return if @window.disposed?
    @window.update
    if $game_temp.message_window_showing || @currentmap != $game_map.map_id
      @window.dispose
      return
    end
    if @frames > Graphics.frame_rate * 2
      @window.y -= 4+$PokemonSystem.screenposy
      @window.dispose if @window.y + @window.height < 0
    else
      @window.y += 4 if @window.y < 0
      @frames += 1
    end
  end
end
class Window_AdvancedTextPokemon < SpriteWindow_Base
  def x=(value)
    super(value + $PokemonSystem.screenposx)
  end

  def y=(value)
    super(value + $PokemonSystem.screenposy)
  end


end

def pbSetResizeFactor(factor)
  if !$ResizeInitialized
    Graphics.resize_screen(Settings::SCREEN_WIDTH + $PokemonSystem.offsetx, Settings::SCREEN_HEIGHT + $PokemonSystem.offsety)
    $ResizeInitialized = true
  end
  if factor < 0 || factor == 5
    Graphics.fullscreen = true if !Graphics.fullscreen
  else
    Graphics.fullscreen = false if Graphics.fullscreen
    Graphics.scale = (factor + 1) * 0.5
    Graphics.center
  end
end

def pbForceResizeFactor
    Graphics.resize_screen(Settings::SCREEN_WIDTH + $PokemonSystem.offsetx, Settings::SCREEN_HEIGHT + $PokemonSystem.offsety)
  if $PokemonSystem.screensize < 0 || $PokemonSystem.screensize == 5
    Graphics.fullscreen = true if !Graphics.fullscreen
  else
    Graphics.fullscreen = false if Graphics.fullscreen
    Graphics.scale = ($PokemonSystem.screensize + 1) * 0.5
    Graphics.center
  end
end


def pbConnectionsEditor
  pbCriticalCode {
    Graphics.resize_screen(Settings::SCREEN_WIDTH + 288, Settings::SCREEN_HEIGHT + 288)
    pbSetResizeFactor(1)
    mapscreen = MapScreenScene.new
    mapscreen.mapScreen
    mapscreen.pbMapScreenLoop
    mapscreen.close
    $ResizeInitialized = false
    pbSetResizeFactor($PokemonSystem.screensize)
  }
end

def pbTilesetScreen
  pbFadeOutIn {
    Graphics.resize_screen(Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT * 2)
    pbSetResizeFactor(1)
    scene = PokemonTilesetScene.new
    scene.pbStartScene
    $ResizeInitialized = false
    pbSetResizeFactor($PokemonSystem.screensize)
  }
end

def pbAnimationEditor
  pbBGMStop
  animation = pbLoadBattleAnimations
  if !animation || !animation[0]
    animation = PBAnimations.new
    animation[0].graphic = ""
  end
  Graphics.resize_screen(Settings::SCREEN_WIDTH + 288, Settings::SCREEN_HEIGHT + 288)
  pbSetResizeFactor(1)
  animationEditorMain(animation)
  $ResizeInitialized = false
  pbSetResizeFactor($PokemonSystem.screensize)
  $game_map&.autoplay
end

class Border
  @@lastGlobalRefreshFrame = -1
  FRAMES_PER_UPDATE = 1
  @@instanceArray = []
  @@tonePerStatus = nil
  attr_reader :lastRefreshFrame
  def initialize
    @viewport = Viewport.new(0-$PokemonSystem.screenposx, 0-$PokemonSystem.screenposy, Settings::SCREEN_WIDTH*4, Settings::SCREEN_HEIGHT*4)
	 @viewport.z = 900000
	@sprites = {}
    @@instanceArray.compact! 
    @@instanceArray.push(self)
  end

  def showHUD?
    return false if $PokemonSystem.borders[$PokemonSystem.cur_border].nil?
    return false if $PokemonSystem.borders[$PokemonSystem.cur_border].empty?
    return true
  end 
  def hasSprites?
    return !@sprites.empty?
  end 


  def create
    createSprites
    for sprite in @sprites.values
      sprite.z=999999999
    end
    refresh
  end

  def createSprites
    createBorder
  end

  def refresh
    refreshBorder
  end
  
  
  def createBorder
    @sprites["border"]=IconSprite.new(0,0,@viewport)
    @sprites["border"].setBitmap($PokemonSystem.borders[$PokemonSystem.cur_border][0])
    @sprites["border"].x=$PokemonSystem.borders[$PokemonSystem.cur_border][1]
    @sprites["border"].y=$PokemonSystem.borders[$PokemonSystem.cur_border][2]
    @sprites["border"].visible = true
  end
  def refreshBorder
  
  def refreshBorder
    if @currentbitmap!=$PokemonSystem.borders[$PokemonSystem.cur_border][0]
      @sprites["border"].setBitmap($PokemonSystem.borders[$PokemonSystem.cur_border][0])
	   @currentbitmap = $PokemonSystem.borders[$PokemonSystem.cur_border][0]
      @sprites["border"].x=$PokemonSystem.borders[$PokemonSystem.cur_border][1]
      @sprites["border"].y=$PokemonSystem.borders[$PokemonSystem.cur_border][2]
	
	end
  end
  end
 

 def tryUpdate(force=false)
    if showHUD?
      update(force) if @lastRefreshFrame != Graphics.frame_count
    else
      dispose if hasSprites?
    end
  end

  def update(force)
    if hasSprites?
      if (
        force || FRAMES_PER_UPDATE<=1 || 
        Graphics.frame_count%FRAMES_PER_UPDATE==0
      )
        refresh
      end
    else
      create
    end
    pbUpdateSpriteHash(@sprites)
    @lastRefreshFrame = Graphics.frame_count
    self.class.tryUpdateAll if self.class.shouldUpdateAll?
  end

  def dispose
    pbDisposeSpriteHash(@sprites)
    pbDisposeSpriteHash(@sprites2)
    pbDisposeSpriteHash(@sprites3)
  end
  
  def recreate
    dispose
    create
  end
  
  class << self
    def shouldUpdateAll?
      return @@lastGlobalRefreshFrame != Graphics.frame_count
    end

    def tryUpdateAll
      @@lastGlobalRefreshFrame = Graphics.frame_count
      for hud in @@instanceArray
        if (
          hud && hud.hasSprites? && 
          hud.lastRefreshFrame < @@lastGlobalRefreshFrame
        )
          hud.tryUpdate 
        end
      end
    end

    def recreateAll
      for hud in @@instanceArray
        hud.recreate if hud && hud.hasSprites?
      end
    end
  end
 
end

class Spriteset_Map

  alias :updateOldOmen :update
  def update
    updateOldOmen
    @@viewport1.rect.set($PokemonSystem.screenposx, $PokemonSystem.screenposy, Graphics.width, Graphics.height)
    @@viewport1.update
	
	end





end


def pbCaveEntranceEx(exiting)
  # Create bitmap
  sprite = BitmapSprite.new(Graphics.width, Graphics.height)
  sprite.x +=$PokemonSystem.screenposx
  sprite.y +=$PokemonSystem.screenposy
  sprite.z = 100000
  # Define values used for the animation
  totalFrames = (Graphics.frame_rate * 0.4).floor
  increment = (255.0 / totalFrames).ceil
  totalBands = 15
  bandheight = ((Graphics.height / 2.0) - 10) / totalBands
  bandwidth  = ((Graphics.width / 2.0) - 12) / totalBands
  # Create initial array of band colors (black if exiting, white if entering)
  grays = Array.new(totalBands) { |i| (exiting) ? 0 : 255 }
  # Animate bands changing color
  totalFrames.times do |j|
    x = 0
    y = 0
    # Calculate color of each band
    totalBands.times do |k|
      next if k >= totalBands * j / totalFrames
      inc = increment
      inc *= -1 if exiting
      grays[k] -= inc
      grays[k] = 0 if grays[k] < 0
    end
    # Draw gray rectangles
    rectwidth  = Graphics.width
    rectheight = Graphics.height
    totalBands.times do |i|
      currentGray = grays[i]
      sprite.bitmap.fill_rect(Rect.new(x, y, rectwidth, rectheight),
                              Color.new(currentGray, currentGray, currentGray))
      x += bandwidth
      y += bandheight
      rectwidth  -= bandwidth * 2
      rectheight -= bandheight * 2
    end
    Graphics.update
    Input.update
  end
  # Set the tone at end of band animation
  if exiting
    pbToneChangeAll(Tone.new(255, 255, 255), 0)
  else
    pbToneChangeAll(Tone.new(-255, -255, -255), 0)
  end
  # Animate fade to white (if exiting) or black (if entering)
  totalFrames.times do |j|
    if exiting
      sprite.color = Color.new(255, 255, 255, j * increment)
    else
      sprite.color = Color.new(0, 0, 0, j * increment)
    end
    Graphics.update
    Input.update
  end
  # Set the tone at end of fading animation
  pbToneChangeAll(Tone.new(0, 0, 0), 8)
  # Pause briefly
  (Graphics.frame_rate / 10).times do
    Graphics.update
    Input.update
  end
  sprite.dispose
end