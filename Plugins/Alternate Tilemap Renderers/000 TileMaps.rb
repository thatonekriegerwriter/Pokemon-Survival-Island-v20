class CustomTilemaps
  RENDERTYPE = 0


end 
class Scene_Map
  
  def createSpritesets
    if !@map_renderer || @map_renderer.disposed?
	  if CustomTilemaps::RENDERTYPE == 1
        @map_renderer = PerspectiveTilemapRenderer.new(Spriteset_Map.viewport)
	  
	  
	  else
        @map_renderer = TilemapRenderer.new(Spriteset_Map.viewport)
	  
	  
	  end 
	
	
	
	end 
    @spritesetGlobal = Spriteset_Global.new if !@spritesetGlobal
    @spritesets = {}
    $map_factory.maps.each do |map|
      @spritesets[map.map_id] = Spriteset_Map.new(map)
    end
    $map_factory.setSceneStarted(self)
    updateSpritesets(true)
  end



end 

module ScreenPosHelper
  def self.pbScreenZoomX(ch)
    zoom=1.0
	zoom = ((ch.screen_y - 16) - (Graphics.height / 2)) * (PerspectiveTilemapRenderer::PITCH*1.0 / (Graphics.height * 25)) + 1 if CustomTilemaps::RENDERTYPE == 1
    return zoom * Game_Map::TILE_WIDTH / 32.0
  end

  def self.pbScreenZoomY(ch)
    zoom=1.0
	zoom = ((ch.screen_y - 16) - (Graphics.height / 2)) * (PerspectiveTilemapRenderer::PITCH*1.0 / (Graphics.height * 25)) + 1 if CustomTilemaps::RENDERTYPE == 1
    return zoom * Game_Map::TILE_HEIGHT / 32.0
  end

  def self.pbScreenX(ch)
    ret = ch.screen_x
    if CustomTilemaps::RENDERTYPE == 1
      widthdiv2=(Graphics.width / 2)
      ret=widthdiv2+(ret-widthdiv2)*pbScreenZoomX(ch)
    end
    return ret
  end

  def self.pbScreenY(ch)
    ret=ch.screen_y
    if CustomTilemaps::RENDERTYPE == 1 && PerspectiveTilemapRenderer::CURVE && PerspectiveTilemapRenderer::PITCH != 0
      zoomy=pbScreenZoomY(ch)
      oneMinusZoomY=1-zoomy
      ret += (8 * oneMinusZoomY * (oneMinusZoomY /
         (2 * ((PerspectiveTilemapRenderer::PITCH*1.0 / 100) / (Graphics.height*1.0 / 16.0))) + 0.5))
    end
    return ret
  end

  @heightcache = {}

  def self.bmHeight(bm)
    h = @heightcache[bm]
    if !h
      bmap = AnimatedBitmap.new("Graphics/Characters/" + bm, 0)
      h = bmap.height
      @heightcache[bm] = h
      bmap.dispose
    end
    return h
  end

  def self.pbScreenZ(ch, height = nil)
    if height.nil?
      height = 0
      if ch.tile_id > 0
        height = 32
      elsif ch.character_name != ""
        height = bmHeight(ch.character_name) / 4
      end
    end
    ret = ch.screen_z(height)
    if CustomTilemaps::RENDERTYPE == 1
      ret-=(pbScreenZoomY(ch) < 0.5 ? 1000 : 0)
    end
    return ret
  end
end


class Sprite_Character
  alias perspectivetilemap_initialize initialize
  attr_accessor :character

  def initialize(viewport, character = nil)
    @character = character
    perspectivetilemap_initialize(viewport,character)
  end

  alias update_or update

  def update
    update_or
    if CustomTilemaps::RENDERTYPE == 1
      self.zoom_y=ScreenPosHelper.pbScreenZoomY(@character)
      self.zoom_x=ScreenPosHelper.pbScreenZoomX(@character)
      self.x=ScreenPosHelper.pbScreenX(@character)
      self.y=ScreenPosHelper.pbScreenY(@character)
      self.z=ScreenPosHelper.pbScreenZ(@character,@ch)
    end
  end
end