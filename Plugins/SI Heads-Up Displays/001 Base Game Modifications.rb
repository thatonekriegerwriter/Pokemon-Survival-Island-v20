

#===============================================================================
# Pokémon sprite (used out of battle)
#===============================================================================

class PokemonSprite < Sprite
  attr_reader   :pokemon
  def initialize(viewport = nil)
    super(viewport)
    @_iconbitmap = nil
    @pokemon = nil
  end

  def dispose
    @_iconbitmap&.dispose
    @_iconbitmap = nil
    self.bitmap = nil if !self.disposed?
    super
  end

  def clearBitmap
    @_iconbitmap&.dispose
    @_iconbitmap = nil
    self.bitmap = nil
  end

  def setOffset(offset = PictureOrigin::CENTER)
    @offset = offset
    changeOrigin
  end

  def changeOrigin
    return if !self.bitmap
    @offset = PictureOrigin::CENTER if !@offset
    case @offset
    when PictureOrigin::TOP_LEFT, PictureOrigin::LEFT, PictureOrigin::BOTTOM_LEFT
      self.ox = 0
    when PictureOrigin::TOP, PictureOrigin::CENTER, PictureOrigin::BOTTOM
      self.ox = self.bitmap.width / 2
    when PictureOrigin::TOP_RIGHT, PictureOrigin::RIGHT, PictureOrigin::BOTTOM_RIGHT
      self.ox = self.bitmap.width
    end
    case @offset
    when PictureOrigin::TOP_LEFT, PictureOrigin::TOP, PictureOrigin::TOP_RIGHT
      self.oy = 0
    when PictureOrigin::LEFT, PictureOrigin::CENTER, PictureOrigin::RIGHT
      self.oy = self.bitmap.height / 2
    when PictureOrigin::BOTTOM_LEFT, PictureOrigin::BOTTOM, PictureOrigin::BOTTOM_RIGHT
      self.oy = self.bitmap.height
    end
  end

  def setPokemonBitmap(pokemon, back = false)
    @pokemon = pokemon
    @_iconbitmap&.dispose
    @_iconbitmap = (pokemon) ? GameData::Species.sprite_bitmap_from_pokemon(pokemon, back) : nil
    self.bitmap = (@_iconbitmap) ? @_iconbitmap.bitmap : nil
    self.color = Color.new(0, 0, 0, 0)
    changeOrigin
  end

  def setPokemonBitmapSpecies(pokemon, species, back = false)
    @pokemon = pokemon
    @_iconbitmap&.dispose
    @_iconbitmap = (pokemon) ? GameData::Species.sprite_bitmap_from_pokemon(pokemon, back, species) : nil
    self.bitmap = (@_iconbitmap) ? @_iconbitmap.bitmap : nil
    changeOrigin
  end

  def setSpeciesBitmap(species, gender = 0, form = 0, shiny = false, shadow = false, back = false, egg = false)
    @_iconbitmap&.dispose
    @_iconbitmap = GameData::Species.sprite_bitmap(species, form, gender, shiny, shadow, back, egg)
    self.bitmap = (@_iconbitmap) ? @_iconbitmap.bitmap : nil
    changeOrigin
  end

  def update
    super
    if @_iconbitmap
      @_iconbitmap.update
      self.bitmap = @_iconbitmap.bitmap
	   if !@pokemon.nil?
      self.tone = Tone.new(0,0,0,255) if @pokemon.dead?
	   end
    end
  end
end


#===============================================================================
# Pokémon icon (for defined Pokémon)
#===============================================================================
class PokemonIconSprite < Sprite
  attr_accessor :selected
  attr_accessor :active
  attr_reader   :pokemon

  def initialize(pokemon, viewport = nil)
    super(viewport)
    @selected     = false
    @active       = false
    @numFrames    = 0
    @currentFrame = 0
    @counter      = 0
    self.pokemon  = pokemon
    @logical_x    = 0   # Actual x coordinate
    @logical_y    = 0   # Actual y coordinate
    @adjusted_x   = 0   # Offset due to "jumping" animation in party screen
    @adjusted_y   = 0   # Offset due to "jumping" animation in party screen
  end

  def dispose
    @animBitmap&.dispose
    super
  end

  def x; return @logical_x; end
  def y; return @logical_y; end

  def x=(value)
    @logical_x = value
    super(@logical_x + @adjusted_x)
  end

  def y=(value)
    @logical_y = value
    super(@logical_y + @adjusted_y)
  end

  def pokemon=(value)
    @pokemon = value
    @animBitmap&.dispose
    @animBitmap = nil
    if !@pokemon
      self.bitmap = nil
      @currentFrame = 0
      @counter = 0
      return
    end
    @animBitmap = AnimatedBitmap.new(GameData::Species.icon_filename_from_pokemon(value))
    self.bitmap = @animBitmap.bitmap
    self.src_rect.width  = @animBitmap.height
    self.src_rect.height = @animBitmap.height
    @numFrames    = @animBitmap.width / @animBitmap.height
    @currentFrame = 0 if @currentFrame >= @numFrames
    changeOrigin
  end

  def setOffset(offset = PictureOrigin::CENTER)
    @offset = offset
    changeOrigin
  end

  def changeOrigin
    return if !self.bitmap
    @offset = PictureOrigin::TOP_LEFT if !@offset
    case @offset
    when PictureOrigin::TOP_LEFT, PictureOrigin::LEFT, PictureOrigin::BOTTOM_LEFT
      self.ox = 0
    when PictureOrigin::TOP, PictureOrigin::CENTER, PictureOrigin::BOTTOM
      self.ox = self.src_rect.width / 2
    when PictureOrigin::TOP_RIGHT, PictureOrigin::RIGHT, PictureOrigin::BOTTOM_RIGHT
      self.ox = self.src_rect.width
    end
    case @offset
    when PictureOrigin::TOP_LEFT, PictureOrigin::TOP, PictureOrigin::TOP_RIGHT
      self.oy = 0
    when PictureOrigin::LEFT, PictureOrigin::CENTER, PictureOrigin::RIGHT
      # NOTE: This assumes the top quarter of the icon is blank, so oy is placed
      #       in the middle of the lower three quarters of the image.
      self.oy = self.src_rect.height * 5 / 8
    when PictureOrigin::BOTTOM_LEFT, PictureOrigin::BOTTOM, PictureOrigin::BOTTOM_RIGHT
      self.oy = self.src_rect.height
    end
  end

  # How long to show each frame of the icon for
  def counterLimit
    return 0 if @pokemon.dead?    # Fainted - no animation
    return 0 if @pokemon.fainted?    # Fainted - no animation
	
	
    # ret is initially the time a whole animation cycle lasts. It is divided by
    # the number of frames in that cycle at the end.
    ret = Graphics.frame_rate / 4               # Green HP - 0.25 seconds
    if @pokemon.hp <= @pokemon.totalhp / 4      # Red HP - 1 second
      ret *= 4
    elsif @pokemon.hp <= @pokemon.totalhp / 2   # Yellow HP - 0.5 seconds
      ret *= 2
    end
    ret /= @numFrames
    ret = 1 if ret < 1
    return ret
  end

  def update
    return if !@animBitmap
    super
    @animBitmap.update
    self.bitmap = @animBitmap.bitmap
    # Update animation
    cl = self.counterLimit
    if cl == 0
      @currentFrame = 0
    else
      @counter += 1
      if @counter >= cl
        @currentFrame = (@currentFrame + 1) % @numFrames
        @counter = 0
      end
    end
    self.src_rect.x = self.src_rect.width * @currentFrame
    # Update "jumping" animation (used in party screen)
    if @selected
      @adjusted_x = 4
      @adjusted_y = (@currentFrame >= @numFrames / 2) ? -2 : 6
    else
      @adjusted_x = 0
      @adjusted_y = 0
    end

    self.tone = Tone.new(0,0,0,255) if @pokemon.dead?
    self.x = self.x
    self.y = self.y
  end
end

module Graphics
  unless defined?(fake_mouse_graphical_update)
    class << Graphics
      alias fake_mouse_graphical_update update
    end
    class << Graphics
      alias fake_mouse_graphical_freeze freeze
    end
  end

  def self.update
    fake_mouse_graphical_update
	$mouse = MouseVisual.new if $mouse.nil?
    $mouse.update if $mouse && !$mouse.disposed?
    $mouse = nil if $mouse&.disposed?
	
    $border = Border.new if !$border
    $border.tryUpdate
  end


  def self.freeze
    $mouse.hide if $mouse && !$mouse.disposed? && !$mouse.disabled?
    fake_mouse_graphical_freeze
    $mouse.show if $mouse && !$mouse.disposed? && !$mouse.disabled?
  end


end



class Spriteset_Map
  attr_accessor :usersprites
  
  
  alias :initializeOldFL :initialize
  alias :disposeOldFL :dispose
  alias :updateOldFL :update

  
  def initialize(map=nil)
    $player = $Trainer if !$player # For compatibility with v20 and older
    initializeOldFL(map)
  end
  def dispose
    disposeOldFL
  end
  def update
	$ov_grid = OverworldGrid.new(@@viewport1) if !$ov_grid
	$ov_grid.update
    updateOldFL
	#pbCreateParticleEngine(@viewport1, @map)
    #$particle_engine.tryUpdate if $particle_engine
	#$particle_engine.update if $particle_engine
  end
end


class Spriteset_Global
  alias :updateOldFL :update
  alias :disposeOldFL :dispose
  def dispose
	$styler.dispose if $styler
    $hud.dispose if $hud
    disposeOldFL
  end
  def update
    updateOldFL
	$tensionbars = TensionBars.new(@viewport1) if !$tensionbars
	$selection_arrows = SelectionBaseDisplay.new(Spriteset_Map.viewport) if !$selection_arrows
	$selection_displayer = SelectionDisplay.new(@viewport1) if !$selection_displayer
    $hud = HUD.new(@viewport1) if !$hud
    $tensionbars.update
	$styler = MouseTrail.new(@viewport1) if !$styler
	$sidedisplay = SideDisplayUI.new(@viewport1) if !$sidedisplay
    $styler.update
    $sidedisplay.update
    $selection_displayer.update
    $selection_arrows.update
    $hud.tryUpdate
  end 

end 


class IconSprite < Sprite
  attr_accessor :call_id
    def call_id
      @call_id = 0 if @call_id.nil?
      return @call_id
	end
end 

#===============================================================================
# Item icon
#===============================================================================
class ItemIconSprite < Sprite
  attr_reader :item

  ANIM_ICON_SIZE   = 48
  FRAMES_PER_CYCLE = Graphics.frame_rate

  def initialize(x, y, item, viewport = nil)
    super(viewport)
    @animbitmap = nil
    @animframe = 0
    @numframes = 1
    @frame = 0
    self.x = x
    self.y = y
    @blankzero = false
    @forceitemchange = true
    self.item = item
    @forceitemchange = false
  end

  def dispose
    @animbitmap&.dispose
    super
  end

  def width
    return 0 if !self.bitmap || self.bitmap.disposed?
    return (@numframes == 1) ? self.bitmap.width : ANIM_ICON_SIZE
  end

  def height
    return (self.bitmap && !self.bitmap.disposed?) ? self.bitmap.height : 0
  end

  def blankzero=(val)
    @blankzero = val
    @forceitemchange = true
    self.item = @item
    @forceitemchange = false
  end

  def setOffset(offset = PictureOrigin::CENTER)
    @offset = offset
    changeOrigin
  end

  def changeOrigin
    @offset = PictureOrigin::CENTER if !@offset
    case @offset
    when PictureOrigin::TOP_LEFT, PictureOrigin::TOP, PictureOrigin::TOP_RIGHT
      self.oy = 0
    when PictureOrigin::LEFT, PictureOrigin::CENTER, PictureOrigin::RIGHT
      self.oy = self.height / 2
    when PictureOrigin::BOTTOM_LEFT, PictureOrigin::BOTTOM, PictureOrigin::BOTTOM_RIGHT
      self.oy = self.height
    end
    case @offset
    when PictureOrigin::TOP_LEFT, PictureOrigin::LEFT, PictureOrigin::BOTTOM_LEFT
      self.ox = 0
    when PictureOrigin::TOP, PictureOrigin::CENTER, PictureOrigin::BOTTOM
      self.ox = self.width / 2
    when PictureOrigin::TOP_RIGHT, PictureOrigin::RIGHT, PictureOrigin::BOTTOM_RIGHT
      self.ox = self.width
    end
  end

  def item=(value)
    return if @item == value && !@forceitemchange
    @item = value
    @animbitmap&.dispose
    @animbitmap = nil
    if @item || !@blankzero
      @animbitmap = AnimatedBitmap.new(GameData::Item.icon_filename(@item))
      self.bitmap = @animbitmap.bitmap
      if self.bitmap.height == ANIM_ICON_SIZE
        @numframes = [(self.bitmap.width / ANIM_ICON_SIZE).floor, 1].max
        self.src_rect = Rect.new(0, 0, ANIM_ICON_SIZE, ANIM_ICON_SIZE)
      else
        @numframes = 1
        self.src_rect = Rect.new(0, 0, self.bitmap.width, self.bitmap.height)
      end
      @animframe = 0
      @frame = 0
    else
      self.bitmap = nil
    end
    changeOrigin
  end

  def update
    @updating = true
    super
    if @animbitmap
      @animbitmap.update
      self.bitmap = @animbitmap.bitmap
      if @numframes > 1
	   if (self.item.is_a?(ItemData) && self.item.id == :CLOCK) || self.item == :CLOCK
         time = pbCurrentTime
         minutes = (time.hour % 12) * 60 + time.min
         @animframe = (minutes * @numframes / 720).floor
         self.src_rect.x = @animframe * ANIM_ICON_SIZE
	   else 
        frameskip = (FRAMES_PER_CYCLE / @numframes).floor
        @frame = (@frame + 1) % FRAMES_PER_CYCLE
        if @frame >= frameskip
          @animframe = (@animframe + 1) % @numframes
          self.src_rect.x = @animframe * ANIM_ICON_SIZE
          @frame = 0
        end 
       end 
     end
    end
    @updating = false
  end


end
