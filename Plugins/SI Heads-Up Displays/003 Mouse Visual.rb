class MouseVisual
  
  def initialize
    puts $PokemonSystem.nil?
    @viewport = Viewport.new(0-$PokemonSystem.screenposx, 0-$PokemonSystem.screenposy, Settings::SCREEN_WIDTH*4, Settings::SCREEN_HEIGHT*4)
	@viewport.z = 999999999
	@mouse = nil
    @disposed = false
    @disabled = false
    @mode = :DEFAULT
  end
  
  def getMousePos(catch_anywhere = false)
    return nil unless Input.mouse_in_window || catch_anywhere
    return @mouse.x - (@mouse.width/2), @mouse.y - (@mouse.height/2)
  end
  
  def x
   return @mouse.x
  end
  def y
   return @mouse.y
  end
  def width 
    @mouse.width
  end
  def height 
    @mouse.height
  end
  def current_mode
   return @mode
  
  end
  
  def dispose
	@mouse.dispose
	@disposed=true
  end
  def hide
	@mouse.visible=false
  end
  def show
	@mouse.visible=true
  end
  def disable
   @disabled=true
	@mouse.visible=false
  end
  def disabled?
   return @disabled
  end
  def enable
   @disabled=false
	@mouse.visible=true
  end
  def set_mode(mode)
    @mode = mode
	image_per_mode
  end
  def change_mode
    return if $player.able_party.length < 1
    if @mode == :DEFAULT
	    @mode = :SQUARE
	    image_per_mode
	    sideDisplay("Mouse Mode: Selection")
	    $selection_displayer.prior_mode(:SQUARE)
    elsif @mode == :SQUARE
	  @mode = :DEFAULT
	  image_per_mode
	  sideDisplay("Mouse Mode: Default")
	  $selection_displayer.prior_mode(:DEFAULT)
	end
  end
  def image_per_mode
  
    if @mode == :DEFAULT
	  @mouse.setBitmap("Graphics/UI/Cursor/cursor1.png")
    elsif @mode == :SELECTION
	  @mouse.setBitmap("Graphics/UI/Cursor/cursor4.png")
    elsif @mode == :SQUARE
	  @mouse.setBitmap("Graphics/UI/Cursor/cursor2.png")
	else
	 if !($PokemonGlobal.selected_pokemon_cleaned.length<1 && @mode == :FOLLOW)
	  @mouse.setBitmap("Graphics/UI/Cursor/cursor3.png")
	 end
	end
  
  end
  def hidden?
	return @mouse.visible==false
  end
  
  def disposed?
   return @mouse && @mouse.disposed?
  end
  def update
    return if @mouse && @mouse.disposed?
    return if @disabled
	if @mouse.nil?
   @mouse = IconSprite.new(@viewport)
   image_per_mode
   @mouse.ox = @mouse.bitmap.width/2
   @mouse.oy = @mouse.bitmap.height/2
   @mouse.z = 99999
   end
   @mouse.x = Input.mouse_x + 9
   @mouse.y = Input.mouse_y + 9
    if !$PokemonGlobal.nil?
	filtered_pokemon = $PokemonGlobal.selected_pokemon_cleaned
	if filtered_pokemon.length<1 && @mode == :FOLLOW
   set_mode(:DEFAULT) 
    end
    end
  
  end


end
