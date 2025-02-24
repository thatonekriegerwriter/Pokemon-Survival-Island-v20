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
    @window.x        = Graphics.width - @window.width - $PokemonSystem.screenposx
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
    Graphics.resize_screen(Settings::SCREEN_WIDTH + 288 + $PokemonSystem.offsetx, Settings::SCREEN_HEIGHT + 288 + $PokemonSystem.offsety)
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



class MapScreenScene
  def getMapSprite(id)
    if !@mapsprites[id]
      @mapsprites[id] = Sprite.new(@viewport)
      @mapsprites[id].z = 0
      @mapsprites[id].bitmap = nil
    end
    if !@mapsprites[id].bitmap || @mapsprites[id].bitmap.disposed?
      @mapsprites[id].bitmap = createMinimap(id)
    end
    return @mapsprites[id]
  end

  def close
    pbDisposeSpriteHash(@sprites)
    pbDisposeSpriteHash(@mapsprites)
    @viewport.dispose
  end

  def setMapSpritePos(id, x, y)
    sprite = getMapSprite(id)
    sprite.x = x
    sprite.y = y
    sprite.visible = true
  end

  def putNeighbors(id, sprites)
    conns = @mapconns
    mapsprite = getMapSprite(id)
    dispx = mapsprite.x
    dispy = mapsprite.y
    conns.each do |conn|
      if conn[0] == id
        b = sprites.any? { |i| i == conn[3] }
        if !b
          x = ((conn[1] - conn[4]) * 4) + dispx
          y = ((conn[2] - conn[5]) * 4) + dispy
          setMapSpritePos(conn[3], x, y)
          sprites.push(conn[3])
          putNeighbors(conn[3], sprites)
        end
      elsif conn[3] == id
        b = sprites.any? { |i| i == conn[0] }
        if !b
          x = ((conn[4] - conn[1]) * 4) + dispx
          y = ((conn[5] - conn[2]) * 4) + dispy
          setMapSpritePos(conn[0], x, y)
          sprites.push(conn[3])
          putNeighbors(conn[0], sprites)
        end
      end
    end
  end

  def hasConnections?(conns, id)
    conns.each do |conn|
      return true if conn[0] == id || conn[3] == id
    end
    return false
  end

  def connectionsSymmetric?(conn1, conn2)
    if conn1[0] == conn2[0]
      # Equality
      return false if conn1[1] != conn2[1]
      return false if conn1[2] != conn2[2]
      return false if conn1[3] != conn2[3]
      return false if conn1[4] != conn2[4]
      return false if conn1[5] != conn2[5]
      return true
    elsif conn1[0] == conn2[3]
      # Symmetry
      return false if conn1[1] != -conn2[1]
      return false if conn1[2] != -conn2[2]
      return false if conn1[3] != conn2[0]
      return false if conn1[4] != -conn2[4]
      return false if conn1[5] != -conn2[5]
      return true
    end
    return false
  end

  def removeOldConnections(ret, mapid)
    ret.delete_if { |conn| conn[0] == mapid || conn[3] == mapid }
  end

  # Returns the maps within _keys_ that are directly connected to this map, _map_.
  def getDirectConnections(keys, map)
    thissprite = getMapSprite(map)
    thisdims = MapFactoryHelper.getMapDims(map)
    ret = []
    keys.each do |i|
      next if i == map
      othersprite = getMapSprite(i)
      otherdims = MapFactoryHelper.getMapDims(i)
      x1 = (thissprite.x - othersprite.x) / 4
      y1 = (thissprite.y - othersprite.y) / 4
      if x1 == otherdims[0] || x1 == -thisdims[0] ||
         y1 == otherdims[1] || y1 == -thisdims[1]
        ret.push(i)
      end
    end
    # If no direct connections, add an indirect connection
    if ret.length == 0
      key = (map == keys[0]) ? keys[1] : keys[0]
      ret.push(key)
    end
    return ret
  end

  def generateConnectionData
    ret = []
    # Create a clone of current map connection
    @mapconns.each do |conn|
      ret.push(conn.clone)
    end
    keys = @mapsprites.keys
    return ret if keys.length < 2
    # Remove all connections containing any sprites on the canvas from the array
    keys.each do |i|
      removeOldConnections(ret, i)
    end
    # Rebuild connections
    keys.each do |i|
      refs = getDirectConnections(keys, i)
      refs.each do |refmap|
        othersprite = getMapSprite(i)
        refsprite = getMapSprite(refmap)
        c1 = (refsprite.x - othersprite.x) / 4
        c2 = (refsprite.y - othersprite.y) / 4
        conn = [refmap, 0, 0, i, c1, c2]
        j = 0
        while j < ret.length && !connectionsSymmetric?(ret[j], conn)
          j += 1
        end
        if j == ret.length
          ret.push(conn)
        end
      end
    end
    return ret
  end

  def serializeConnectionData
    conndata = generateConnectionData
    save_data(conndata, "Data/map_connections.dat")
    Compiler.write_connections
    @mapconns = conndata
  end

  def putSprite(id)
    addSprite(id)
    putNeighbors(id, [])
  end

  def addSprite(id)
    mapsprite = getMapSprite(id)
    x = (Graphics.width - mapsprite.bitmap.width) / 2
    y = (Graphics.height - mapsprite.bitmap.height) / 2
    mapsprite.x = x.to_i & ~3
    mapsprite.y = y.to_i & ~3
  end

  def saveMapSpritePos
    @mapspritepos.clear
    @mapsprites.each_key do |i|
      s = @mapsprites[i]
      @mapspritepos[i] = [s.x, s.y] if s && !s.disposed?
    end
  end

  def mapScreen
    @sprites = {}
    @mapsprites = {}
    @mapspritepos = {}
    @viewport = Viewport.new(0, 0, Graphics.width*2, Graphics.height*2)
    @viewport.z = 99999
    @lasthitmap = -1
    @lastclick = -1
    @oldmousex = nil
    @oldmousey = nil
    @dragging = false
    @dragmapid = -1
    @dragOffsetX = 0
    @dragOffsetY = 0
    @selmapid = -1
    @sprites["background"] = ColoredPlane.new(Color.new(160, 208, 240), @viewport)
    @sprites["selsprite"] = SelectionSprite.new(@viewport)
    @sprites["title"] = Window_UnformattedTextPokemon.newWithSize(
      _INTL("D: Help"), 0, Graphics.height*2 - 148, Graphics.width*2, 64, @viewport
    )
    @sprites["title"].z = 2
    @mapinfos = pbLoadMapInfos
    conns = MapFactoryHelper.getMapConnections
    @mapconns = []
    conns.each do |map_conns|
      next if !map_conns
      map_conns.each do |c|
        @mapconns.push(c.clone) if @mapconns.none? { |x| x[0] == c[0] && x[3] == c[3] }
      end
    end
    if $game_map
      @currentmap = $game_map.map_id
    else
      @currentmap = ($data_system) ? $data_system.edit_map_id : 1
    end
    putSprite(@currentmap)
  end

  def setTopSprite(id)
    @mapsprites.each_key do |i|
      @mapsprites[i].z = (i == id) ? 1 : 0
    end
  end

  def helpWindow
    helptext = _INTL("A: Add map to canvas\r\n")
    helptext += _INTL("DEL: Delete map from canvas\r\n")
    helptext += _INTL("S: Go to another map\r\n")
    helptext += _INTL("Click to select a map\r\n")
    helptext += _INTL("Double-click: Edit map's metadata\r\n")
    helptext += _INTL("Drag map to move it\r\n")
    helptext += _INTL("Arrow keys/drag canvas: Move around canvas")
    title = Window_UnformattedTextPokemon.newWithSize(
      helptext, 0, 0, Graphics.width * 8 / 10, Graphics.height, @viewport
    )
    title.z = 2
    loop do
      Graphics.update
      Input.update
      break if Input.trigger?(Input::BACK) || Input.trigger?(Input::USE)
    end
    Input.update
    title.dispose
  end

  def getMapRect(mapid)
    sprite = getMapSprite(mapid)
    return nil if !sprite
    return [sprite.x, sprite.y,
            sprite.x + sprite.bitmap.width, sprite.y + sprite.bitmap.height]
  end

  def onDoubleClick(map_id)
    pbEditMapMetadata(map_id) if map_id > 0
  end

  def onClick(mapid, x, y)
    if @lastclick > 0 && Graphics.frame_count - @lastclick < Graphics.frame_rate * 0.5
      onDoubleClick(mapid)
      @lastclick = -1
    else
      @lastclick = Graphics.frame_count
      if mapid >= 0
        @dragging = true
        @dragmapid = mapid
        sprite = getMapSprite(mapid)
        @sprites["selsprite"].othersprite = sprite
        @selmapid = mapid
        @dragOffsetX = sprite.x - x
        @dragOffsetY = sprite.y - y
        setTopSprite(mapid)
      else
        @sprites["selsprite"].othersprite = nil
        @dragging = true
        @dragmapid = mapid
        @selmapid = -1
        @dragOffsetX = x
        @dragOffsetY = y
        saveMapSpritePos
      end
    end
  end

  def onRightClick(mapid, x, y)
#   echoln "rightclick (#{mapid})"
  end

  def onMouseUp(mapid)
#   echoln "mouseup (#{mapid})"
    @dragging = false if @dragging
  end

  def onRightMouseUp(mapid)
#   echoln "rightmouseup (#{mapid})"
  end

  def onMouseOver(mapid, x, y)
#   echoln "mouseover (#{mapid},#{x},#{y})"
  end

  def onMouseMove(mapid, x, y)
#   echoln "mousemove (#{mapid},#{x},#{y})"
    if @dragging
      if @dragmapid >= 0
        sprite = getMapSprite(@dragmapid)
        x = x + @dragOffsetX
        y = y + @dragOffsetY
        sprite.x = x & ~3
        sprite.y = y & ~3
        @sprites["title"].text = _ISPRINTF("D: Help [{1:03d}: {2:s}]", mapid, @mapinfos[@dragmapid].name)
      else
        xpos = x - @dragOffsetX
        ypos = y - @dragOffsetY
        @mapspritepos.each_key do |i|
          sprite = getMapSprite(i)
          sprite.x = (@mapspritepos[i][0] + xpos) & ~3
          sprite.y = (@mapspritepos[i][1] + ypos) & ~3
        end
        @sprites["title"].text = _INTL("D: Help")
      end
    elsif mapid >= 0
      @sprites["title"].text = _ISPRINTF("D: Help [{1:03d}: {2:s}]", mapid, @mapinfos[mapid].name)
    else
      @sprites["title"].text = _INTL("D: Help")
    end
  end

  def hittest(x, y)
    @mapsprites.each_key do |i|
      sx = @mapsprites[i].x
      sy = @mapsprites[i].y
      sr = sx + @mapsprites[i].bitmap.width
      sb = sy + @mapsprites[i].bitmap.height
      return i if x >= sx && x < sr && y >= sy && y < sb
    end
    return -1
  end

  def chooseMapScreen(title, currentmap)
    return pbListScreen(title, MapLister.new(currentmap))
  end

  def update
    mousepos = Mouse.getMousePos
    if mousepos
      hitmap = hittest(mousepos[0], mousepos[1])
      if Input.trigger?(Input::MOUSELEFT)
        onClick(hitmap, mousepos[0], mousepos[1])
      elsif Input.trigger?(Input::MOUSERIGHT)
        onRightClick(hitmap, mousepos[0], mousepos[1])
      elsif Input.release?(Input::MOUSELEFT)
        onMouseUp(hitmap)
      elsif Input.release?(Input::MOUSERIGHT)
        onRightMouseUp(hitmap)
      else
        if @lasthitmap != hitmap
          onMouseOver(hitmap, mousepos[0], mousepos[1])
          @lasthitmap = hitmap
        end
        if @oldmousex != mousepos[0] || @oldmousey != mousepos[1]
          onMouseMove(hitmap, mousepos[0], mousepos[1])
          @oldmousex = mousepos[0]
          @oldmousey = mousepos[1]
        end
      end
    end
    if Input.pressex?(:UP)
      @mapsprites.each do |i|
        i[1].y += 4 if i
      end
    end
    if Input.pressex?(:DOWN)
      @mapsprites.each do |i|
        i[1].y -= 4 if i
      end
    end
    if Input.pressex?(:LEFT)
      @mapsprites.each do |i|
        i[1].x += 4 if i
      end
    end
    if Input.pressex?(:RIGHT)
      @mapsprites.each do |i|
        i[1].x -= 4 if i
      end
    end
    if Input.triggerex?(:A)
      id = chooseMapScreen(_INTL("Add Map"), @currentmap)
      if id > 0
        addSprite(id)
        setTopSprite(id)
        @mapconns = generateConnectionData
      end
    elsif Input.triggerex?(:S)
      id = chooseMapScreen(_INTL("Go to Map"), @currentmap)
      if id > 0
        @mapconns = generateConnectionData
        pbDisposeSpriteHash(@mapsprites)
        @mapsprites.clear
        @sprites["selsprite"].othersprite = nil
        @selmapid = -1
        putSprite(id)
        @currentmap = id
      end
    elsif Input.triggerex?(:DELETE)
      if @mapsprites.keys.length > 1 && @selmapid >= 0
        @mapsprites[@selmapid].bitmap.dispose
        @mapsprites[@selmapid].dispose
        @mapsprites.delete(@selmapid)
        @sprites["selsprite"].othersprite = nil
        @selmapid = -1
      end
    elsif Input.triggerex?(:D)
      helpWindow
    end
    pbUpdateSpriteHash(@sprites)
  end

  def pbMapScreenLoop
    loop do
      Graphics.update
      Input.update
      update
      if Input.trigger?(Input::BACK)
        if pbConfirmMessage(_INTL("Save changes?"))
          serializeConnectionData
          MapFactoryHelper.clear
        else
          GameData::Encounter.load
        end
        break if pbConfirmMessage(_INTL("Exit from the editor?"))
      end
    end
  end
end