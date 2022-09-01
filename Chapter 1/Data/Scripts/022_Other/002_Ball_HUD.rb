#===============================================================================
# OW Ball HUD by Vendily
#   (only for v19.1)
#===============================================================================
class PokemonGlobalMetadata
  attr_writer :ball_hud_enabled
  attr_writer :ball_hud_index

  def ball_hud_enabled
    @ball_hud_enabled = false if !@ball_hud_enabled
    return @ball_hud_enabled
  end

  def ball_hud_index
    return @ball_hud_index || 0
  end
end

class Sprite_BallHUD
  BALL_ORDER=[:POKEBALL,:GREATBALL,:ULTRABALL,:PREMIERBALL,:HEAVYBALL,:HEALBALL,:QUICKBALL,:STONE,:BAIT]
  def initialize(viewport=nil)
    @viewport=viewport
    @sprites={}
    @setup=false
    @old_ball=-1
    @old_qty=-1
    @disposed=false
  end

  def dispose
    pbDisposeSpriteHash(@sprites)
    @disposed=true
  end

  def disposed?
    @disposed
  end

  def update
    return if disposed? || !$PokemonGlobal || !$PokemonBag
    if $PokemonGlobal.ball_hud_enabled
      if !@setup
        @sprites["hud_bg"]=IconSprite.new(44,270,@viewport)
        @sprites["hud_bg"].setBitmap("Graphics/Pictures/OW_Catch_UI")
        @sprites["hud_bg"].z=99998
        @sprites["ball_icon"]=ItemIconSprite.new(66+24,288+24,nil,@viewport)
        @sprites["ball_icon"].blankzero = true
        @sprites["ball_icon"].z=99998
        @sprites["overlay"]=BitmapSprite.new(68,48,@viewport)
        @sprites["overlay"].x=36
        @sprites["overlay"].y=288
        @sprites["overlay"].z=99998
        pbSetSystemFont(@sprites["overlay"].bitmap)
        @setup=true
      end
      cur_ball=$PokemonGlobal.ball_hud_index
      cur_qty=$PokemonBag.pbQuantity(BALL_ORDER[cur_ball])
      if cur_ball != @old_ball || cur_qty != @old_qty
        @old_ball = cur_ball
        @old_qty = cur_qty
        @sprites["ball_icon"].item=BALL_ORDER[@old_ball]
        overlay=@sprites["overlay"].bitmap
        overlay.clear
        baseColor   = Color.new(72,72,72)
        shadowColor = Color.new(160,160,160)
        pbDrawTextPositions(overlay,[[sprintf("x%d",@old_qty),46,14,1,baseColor,shadowColor]])
      end
      pbUpdateSpriteHash(@sprites)
    else
      pbDisposeSpriteHash(@sprites)
      @setup=false
    end
  end
end

class Spriteset_Global
  
  alias ball_hud_initialize initialize
  def initialize
    ball_hud_initialize
    @ball_hud_sprite = Sprite_BallHUD.new
  end
  
  alias ball_hud_dispose dispose
  def dispose
    ball_hud_dispose
    @ball_hud_sprite.dispose
    @ball_hud_sprite = nil
  end
  
  alias ball_hud_update update
  def update
    ball_hud_update
    @ball_hud_sprite.update if @ball_hud_sprite
  end
end