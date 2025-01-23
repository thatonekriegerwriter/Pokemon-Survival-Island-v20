#===============================================================================
# * Simple HUD - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It displays a HUD with the party icons,
# HP bars, tone (for status) and some small text.
#
#== INSTALLATION ===============================================================
#
# To this script works, put it above main.
#
#===============================================================================



if defined?(PluginManager) && !PluginManager.installed?("Simple HUD")
  PluginManager.register({                                                 
    :name    => "Simple HUD",                                        
    :version => "3.0",                                                     
    :link    => "https://www.pokecommunity.com/showthread.php?t=390640",             
    :credits => "FL"
  })
end

class PokemonGlobalMetadata
  attr_accessor :hud_selector
  attr_accessor :ball_order
  attr_accessor :bars_visible
  attr_accessor :hud_control
  attr_accessor :styler_control
  attr_accessor :positioning_controls_window

  def hud_selector
    @hud_selector = 0 if !@hud_selector
    return @hud_selector
  end
  def positioning_controls_window
    setup_positioning_controls_window if !@positioning_controls_window
    return @positioning_controls_window
  end
  
  def set_positioning_controls_window_text(text=nil)
    return if @positioning_controls_window.text==text
    if !text.nil? && !text.empty?
    @positioning_controls_window.text=text
    @positioning_controls_window.resizeToFit(text,@positioning_controls_window.width)
    @positioning_controls_window.visible = true
	else
    @positioning_controls_window.visible = false
    @positioning_controls_window.text=""
    @positioning_controls_window.resizeToFit("",@positioning_controls_window.width)
	end
  end
  
  def get_positioning_controls_window_text
    setup_positioning_controls_window if !@positioning_controls_window
    return if @positioning_controls_window.text
  end
  def setup_positioning_controls_window
  
	    @positioning_controls_window = Window_UnformattedTextPokemon.newWithSize("", 0, 0, 240, 64)
        @positioning_controls_window.resizeToFit("",@positioning_controls_window.width)
        @positioning_controls_window.x = Graphics.width-@positioning_controls_window.width
        @positioning_controls_window.z = 99999
        @positioning_controls_window.visible = false
  
  
  end

  def hud_control
    return @hud_control
  end

  def styler_control
    return @styler_control
  end

  def bars_visible
    @bars_visible = true if !@bars_visible
    return @bars_visible
  end


  def ball_order
   @ball_order = [] if @ball_order.nil?
   return @ball_order
  end
end



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



class HUD
  attr_accessor :visible
  if true
  # If you wish to use a background picture, put the image path below, like
  # BG_PATH="Graphics/Pictures/battleMessage". I recommend a 512x64 picture.
  # If there is no image, a blue background will be draw.
  BG_PATH="Graphics/Pictures/Hud/Bolt"
  BG_PATH2="Graphics/Pictures/Hud/Heart"

  # Make as 'false' to don't show the blue bar
  USE_BAR=false

  # Make as 'true' to draw the HUD at bottom
  DRAW_AT_BOTTOM=true

  # Make as 'true' to only show HUD in the pause menu
  DRAW_ONLY_IN_MENU=false


  # When above 0, only displays HUD when this switch is on.
  SWITCH_NUMBER = -1

  # Lower this number = more lag.
  FRAMES_PER_UPDATE = 1

  # The size of drawable content.
  BAR_HEIGHT = 64
  
  $old_qty=nil
  $old_ball=nil
  $originalx = nil
	$originaly = nil
  HP_BAR_GREEN    = [Color.new(24,192,32),Color.new(0,144,0)]
  HP_BAR_YELLOW   = [Color.new(250,250,51),Color.new(184,112,0)]
  HP_BAR_RED      = [Color.new(240,80,32),Color.new(168,48,56)]
  STA_BAR_GREEN    = [Color.new(255,182,66),Color.new(0,144,0)]
  STA_BAR_YELLOW   = [Color.new(248,184,0),Color.new(184,112,0)]
  STA_BAR_RED      = [Color.new(240,80,32),Color.new(168,48,56)]
  TEXT_COLORS = [Color.new(72,72,72), Color.new(160,160,160)]
  BACKGROUND_COLOR = Color.new(128,128,192)
  
  @@lastGlobalRefreshFrame = -1
  @@instanceArray = []
  @@tonePerStatus = nil

  attr_reader :lastRefreshFrame

  # Note that this method is called on each refresh, but the texts
  # only will be redrawed if any character change.
  def textsDefined
    ret=[]
    ret[0] = _INTL(" ")
    ret[1] = _INTL(" ")
    return ret
  end

  class RunningData
    attr_reader :hp, :totalhp, :sta, :totalsta

    def initialize
      @hp = $player.playerhealth
      @totalhp = 100
      @sta = $player.playerstamina
      @totalsta = $player.playermaxstamina
    end

  end

  def initialize(viewport1)
    @visible = false
    @viewport1 = viewport1
    @sprites = {}
    @sprites2={}
    @sprites3={}
	@sprites4={}
	@sprites5={}
	@bar_image = RPG::Cache.picture("Hud/overlay_hp")
	@bar_image2 = RPG::Cache.picture("Hud/overlay_hp2")
    @yposition = DRAW_AT_BOTTOM ? Graphics.height-64 : 0
	@yposition += $PokemonSystem.screenposy
    @old_index=nil
    @old_map=nil
    @@instanceArray.compact! 
    @@instanceArray.push(self)
  end

  def showHUD?
    return (
      $player && !$game_temp.in_menu && ($game_map.map_id != 1 && $game_map.map_id != 25)
    )
  end
  end


  def create
    createSprites
    for sprite in @sprites.values
      sprite.z+=600
    end
    refresh
  end

  def createSprites
    createHPBar(55+$PokemonSystem.screenposx , @yposition+30, 90, 8)
    createSTABar(65+$PokemonSystem.screenposx , @yposition+50, 90, 8)
    #createSTABar(120+$PokemonSystem.screenposx , @yposition+45, 70, 11)
    #createHPBar(40+$PokemonSystem.screenposx , @yposition+45, 70, 11)
    createBox(440+$PokemonSystem.screenposx , @yposition+45, 70, 11)
	createSelection(440+$PokemonSystem.screenposx , @yposition+45, 70, 11)
	createHPLevel(80+$PokemonSystem.screenposx , 10)
  end
  

  def createSelection(x, y, width, height)
      5.times do |i| 
        @sprites4["selection#{i}"]=IconSprite.new(x-30,100+(i*32),@viewport)
        @sprites4["selection#{i}"].setBitmap("Graphics/Pictures/ov_selection_box")
        @sprites4["selection#{i}"].z=9
        @sprites4["selection#{i}"].visible=false
		 if i==4
	       @sprites4["item_sel#{i}"] = Window_UnformattedTextPokemon.newWithSize("5. Interact", x-46,86+(i*32), 270, 64)
		 else
	       @sprites4["item_sel#{i}"] = Window_UnformattedTextPokemon.newWithSize("", x-46,86+(i*32), 270, 64)
		 end
        @sprites4["item_sel#{i}"].visible = false
        @sprites4["item_sel#{i}"].z=10
        @sprites4["item_sel#{i}"].windowskin  = nil
      end
      @sprites4["pause"] = Window_UnformattedTextPokemon.newWithSize("PAUSE", Graphics.width/2-40,Graphics.height/2-70, 270, 64)
      @sprites4["pause"].visible = false
      @sprites4["pause"].windowskin  = nil
      @sprites4["pause"].z=99
      @sprites4["bar"]=IconSprite.new(0,0,@viewport1)
      @sprites4["bar"].setBitmap("Graphics/Pictures/loadslotsbg")
      @sprites4["bar"].visible = false
      @sprites4["bar"].z=98
  end


  def createHPLevel(width, height)
    fillWidth = width-4
    fillHeight = height-4
    @sprites3["hpbarborderevent"] = BitmapSprite.new(width,height,@viewport1)
    @sprites3["hpbarborderevent"].x = 25
    @sprites3["hpbarborderevent"].y = 40
	x=25
	y=40
   # @sprites3["bar"]=IconSprite.new((@sprites3["hpbarborder#{event.id}"].x-1),(@sprites3["hpbarborder#{event.id}"].y-8),@viewport1)
   # @sprites3["bar"].setBitmap(BG_PATH)
   # @sprites3["bar"].visible = false
   # @sprites3["bar"].z = 9
    @sprites3["hpbarborderevent"].bitmap.fill_rect(
      Rect.new(0,0,width,height), Color.new(32,32,32)
    )
    @sprites3["hpbarborderevent"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )
    @sprites3["hpbarborderevent"].visible = false
    @sprites3["hpbarborderevent"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @sprites3["hpbarborderevent"].x = x+2
    @sprites3["hpbarborderevent"].y = y+2
    text = ""
	@sprites3["namewindowevent"] = Window_UnformattedTextPokemon.newWithSize(text, 10, 1, 270, 64)
    @sprites3["namewindowevent"].visible = false
	@sprites3["namewindowevent"].windowskin  = nil
end

        #@sprites5["ball_icon2"]=IconSprite.new(49,-25,nil,@viewport)
       # @sprites5["ball_icon2"].setBitmap("Graphics/Pictures/dropdownstuff")
       # @sprites5["ball_icon2"].z=9
       # @sprites5["ball_icon2"].visible=false
		#keyname = get_keyname("Control Pokemon")
	   # @sprites5["ball_icon2window"] = Window_UnformattedTextPokemon.newWithSize("#{keyname}", 46, 25, 270, 64)
        #@sprites5["ball_icon2window"].visible = false
	   # @sprites5["ball_icon2window"].windowskin  = nil
       # @sprites5["ball_icon2window"].z=9

  def createBox(x, y, width, height)
     return if !@sprites2["hud_bg"].nil?
     getCurrentItemOrder
     current_selection=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
     @sprites2["hud_bg"]=IconSprite.new(x-22,280,@viewport)
     @sprites2["hud_bg"].setBitmap("Graphics/Pictures/OW_Catch_UI")
     @sprites2["hud_bg"].z=9
     @sprites2["ball_icon"]=ItemIconSprite.new(x+24,288+34,nil,@viewport)
     @sprites2["ball_icon"].blankzero = true
     @sprites2["ball_icon"].z=9
	 @sprites2["pkmn_icon"]=PokemonIconSprite.new(nil, @viewport)
     @sprites2["pkmn_icon"].x=x-7
     @sprites2["pkmn_icon"].y=288-4
     @sprites2["pkmn_icon"].z=9
     @sprites2["overlay"]=BitmapSprite.new(48,48,@viewport)
     @sprites2["overlay"].x=x
     @sprites2["overlay"].y=288
     @sprites2["overlay"].z=9
     pbSetSystemFont(@sprites2["overlay"].bitmap)
	 
     if current_selection.is_a?(Pokemon)
       @sprites2["pkmn_icon"].pokemon=current_selection
     elsif current_selection.is_a?(ItemData)
       @sprites2["ball_icon"].item=current_selection
     elsif current_selection == :MULTISELECT
       @sprites2["ball_icon"].item=:NO
     end

     @sprites2["namewindow"] = Window_UnformattedTextPokemon.newWithSize("", x-24, 250, 270, 64)
     @sprites2["namewindow"].visible = true
     @sprites2["namewindow"].windowskin  = nil
     @sprites2["amt"] = Window_UnformattedTextPokemon.newWithSize("", x-24+46, 256+56, 270+1, 200)
     @sprites2["amt"].visible = true
     @sprites2["amt"].windowskin  = nil
     @sprites2["durawindow"] = Window_UnformattedTextPokemon.new("")
     @sprites2["durawindow"].visible = true
     @sprites2["durawindow"].windowskin  = nil
     @sprites2["durawindow"].zoom_x  = 0.75
     @sprites2["durawindow"].zoom_y  = 0.75
     @sprites2["durawindow"].x  = x-24+144
     @sprites2["durawindow"].y  = 240+190
     @sprites2["durawindow"].baseColor  = Color.new(255,192,66)
     @sprites2["durawindow"].shadowColor=get_shadow_color(:FIRE)
     @sprites2["waterwindow"] = Window_UnformattedTextPokemon.new("")
     @sprites2["waterwindow"].visible = true
     @sprites2["waterwindow"].windowskin  = nil
     @sprites2["waterwindow"].zoom_x  = 0.75
     @sprites2["waterwindow"].zoom_y  = 0.75
     @sprites2["waterwindow"].x  = x-24+209
     @sprites2["waterwindow"].y  = 240+190
     @sprites2["waterwindow"].baseColor  = Color.new(0, 84, 119)
     @sprites2["durawindow"].shadowColor=get_shadow_color(:FIRE)
     @sprites2["status_effect"]=IconSprite.new(x+1,289,@viewport)
     @sprites2["status_effect"].setBitmap("Graphics/Pictures/Hud/empty")
     @sprites2["status_effect"].z=10
	  
	    6.times do |i|
     @sprites2["secondary_boxes#{i}"]=IconSprite.new(0,0,@viewport)
     @sprites2["secondary_boxes#{i}"].visible=false
     @sprites2["secondary_boxes#{i}"].setBitmap("Graphics/Pictures/Hud/catchuiblank")
     @sprites2["secondary_boxes#{i}"].zoom_x=0.65
     @sprites2["secondary_boxes#{i}"].zoom_y=0.65
     @sprites2["secondary_boxes#{i}"].x=x-56- (46*i)
     @sprites2["secondary_boxes#{i}"].y=Graphics.height-78
     @sprites2["secondary_boxes#{i}"].z=8
     #@sprites2["secondary_boxes#{i}"].opacity = (300/(i+1)).to_i
        case i
		 when 6
		  bonus = -4
		
		 when 5
		  bonus = -4
		 
		 when 4
		  bonus = -4
		 when 3
		  bonus = -3
		 when 2
		  bonus = -2
		 when 1
		  bonus = -1
		 else
		  bonus = 0
        end
     @sprites2["durawindow_small#{i}"] = Window_UnformattedTextPokemon.new("")
     @sprites2["durawindow_small#{i}"].visible = false
     @sprites2["durawindow_small#{i}"].windowskin  = nil
     @sprites2["durawindow_small#{i}"].zoom_x  = 0.65
     @sprites2["durawindow_small#{i}"].zoom_y  = 0.65
     @sprites2["durawindow_small#{i}"].x  = x + bonus + 142 - (70*i)
     @sprites2["durawindow_small#{i}"].y  = Graphics.height + 120
     #@sprites2["durawindow_small#{i}"].opacity = (300/(i+1)).to_i

     @sprites2["namewindow_small#{i}"] = Window_UnformattedTextPokemon.newWithSize("", x-24, 250, 270, 64)
     @sprites2["namewindow_small#{i}"].visible = false
     @sprites2["namewindow_small#{i}"].windowskin  = nil
     @sprites2["namewindow_small#{i}"].zoom_x  = 0.65
     @sprites2["namewindow_small#{i}"].zoom_y  = 0.65
     @sprites2["namewindow_small#{i}"].x  = x + bonus + 146 - (70*i)
     @sprites2["namewindow_small#{i}"].y  = Graphics.height + 55
     #@sprites2["namewindow_small#{i}"].opacity = (300/(i+1)).to_i

	 @sprites2["pkmn_icon_small#{i}"]=PokemonIconSprite.new(nil, @viewport)
     @sprites2["pkmn_icon_small#{i}"].zoom_x  = 0.65
     @sprites2["pkmn_icon_small#{i}"].zoom_y  = 0.65
     @sprites2["pkmn_icon_small#{i}"].x=x-56- (46*i)
     @sprites2["pkmn_icon_small#{i}"].y=Graphics.height-78
     @sprites2["pkmn_icon_small#{i}"].z=9
     #@sprites2["pkmn_icon_small#{i}"].opacity = (300/(i+1)).to_i
     @sprites2["pkmn_icon_small#{i}"].visible = false
	    end
	 
     overlay=@sprites2["overlay"].bitmap
     overlay.clear
		 
     hideBallHUD if $PokemonGlobal.ball_hud_enabled==false
  end


end


class HUD

  def hideSelectionHUD
  @sprites4.each_key do |key|
    @sprites4[key].visible=false
  end
   
  end
  def revealSelectionHUD
  @sprites4.each_key do |key|
    @sprites4[key].visible=true
  end
   
  end
   
  def hideHPHUD
  @sprites3.each_key do |key|
    @sprites3[key].visible=false
  end
   
  end
  def revealHPHUD
  @sprites3.each_key do |key|
    @sprites3[key].visible=true
  end
   
  end
  
  def revealBallHUD
  @sprites2.each_key do |key|
     next if key.include?("secondary_boxes")
     next if key.include?("pkmn_icon_small")
     next if key.include?("namewindow_small")
     next if key.include?("durawindow_small")
    @sprites2[key].visible=true
  end
  end
  def hideBallHUD
  @sprites2.each_key do |key|
    @sprites2[key].visible=false
  end
  end

  def revealMainHUD
  @sprites.each_key do |key|
    @sprites[key].visible=true
  end
  end
  def hideMainHUD
  @sprites.each_key do |key|
    @sprites[key].visible=false
  end
  end



end


class HUD
  
  def refresh
    refreshSTABar if $PokemonGlobal.bars_visible==true
    refreshHPBar if $PokemonGlobal.bars_visible==true
	refreshHPLevel(80+$PokemonSystem.screenposx , 10) if $game_temp.lockontarget!=false
	refreshSelection
	refreshBox(440+$PokemonSystem.screenposx , @yposition+45) if $PokemonGlobal.ball_hud_enabled==true
  end


  def get_type_color(type)
       case type
         when :NORMAL
           return Color.new(168, 167, 122)
         when :FIRE
           return Color.new(238, 129, 48)
         when :WATER
           return Color.new(99, 144, 240)
         when :ELECTRIC
           return Color.new(247, 208, 44)
         when :GRASS
           return Color.new(122, 199, 76)
         when :ICE
           return Color.new(150, 217, 214)
         when :FIGHTING
           return Color.new(194, 46, 40)
         when :POISON
           return Color.new(163, 62, 161)
         when :GROUND
           return Color.new(226, 191, 101)
         when :FLYING
           return Color.new(169, 143, 243)
         when :PSYCHIC
           return Color.new(249, 85, 135)
         when :BUG
           return Color.new(166, 185, 26)
         when :ROCK
           return Color.new(182, 161, 54)
         when :GHOST
           return Color.new(115, 87, 151)
         when :DRAGON
           return Color.new(111, 53, 252)
         when :DARK
           return Color.new(112, 87, 70)
         when :STEEL
           return Color.new(183, 183, 206)
         when :FAIRY
           return Color.new(214, 133, 173)
         else
           return Color.new(80, 80, 88)
       end
  end
 
  def get_shadow_color(type)
       case type
         when :NORMAL
           return Color.new(80, 80, 88)
         when :FIRE
           return Color.new(80, 80, 88)
         when :WATER
           return Color.new(80, 80, 88)
         when :ELECTRIC
           return Color.new(80, 80, 88)
         when :GRASS
           return Color.new(80, 80, 88)
         when :ICE
           return Color.new(80, 80, 88)
         when :FIGHTING
           return Color.new(80, 80, 88)
         when :POISON
           return Color.new(80, 80, 88)
         when :GROUND
           return Color.new(80, 80, 88)
         when :FLYING
           return Color.new(80, 80, 88)
         when :PSYCHIC
           return Color.new(80, 80, 88)
         when :BUG
           return Color.new(80, 80, 88)
         when :ROCK
           return Color.new(80, 80, 88)
         when :GHOST
           return Color.new(80, 80, 88)
         when :DRAGON
           return Color.new(80, 80, 88)
         when :DARK
           return Color.new(80, 80, 88)
         when :STEEL
           return Color.new(80, 80, 88)
         when :FAIRY
           return Color.new(80, 80, 88)
         else
           return Color.new(160, 160, 168)
       end
  end 
  
  def refreshBox(x,y)
    cur_qty = 0
    getCurrentItemOrder
	  $PokemonGlobal.selected_pokemon[0] = 0 if $PokemonGlobal.selected_pokemon[0].nil?
	 
	#  @sprites2["pkmn_icon"].pokemon=nil
	#  @sprites2["ball_icon"].item=:NO
	# name = "Multi Sel"
    current_selection=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
	if current_selection.is_a?(Pokemon)
	  object = nil
	  @sprites2["pkmn_icon"].pokemon=nil if @sprites2["pkmn_icon"].pokemon!=current_selection
	  name = GameData::Species.try_get(current_selection.species).real_name
	  name = name.slice(0, 10) if name.length > 10
	  formname = current_selection.species_data.form_name
	  name = "#{name} (#{formname.slice(0, 1)})" if !formname.nil? 
	  @sprites2["pkmn_icon"].pokemon=current_selection
	  @sprites2["ball_icon"].item=nil
	   text = ""
	   if current_selection.egg?
	   text34 = ""
     @sprites2["durawindow"].baseColor  = Color.new(255,182,66)

	   else
	   text34 = "#{current_selection.hp}/#{current_selection.totalhp}"
    @sprites2["durawindow"].baseColor = Color.new(24,198,33)  # Default (green)
    @sprites2["durawindow"].baseColor = Color.new(239,173,0) if current_selection.hp <= (current_selection.totalhp / 2).floor  # Yellow at 50% HP
    @sprites2["durawindow"].baseColor = Color.new(255,74,57) if current_selection.hp <= (current_selection.totalhp / 4).floor  # Red at 25% HP
    @sprites2["durawindow"].shadowColor=get_shadow_color(:FIRE)
	   end
	  @sprites2["durawindow"].text = text34
      @sprites2["durawindow"].resizeToFit(text34)
	  @sprites2["waterwindow"].text = ""
      @sprites2["waterwindow"].shadowColor=get_shadow_color(:FIRE)
	  name = "???" if current_selection.egg?
      case current_selection.status
        when :SLEEP
         @sprites2["status_effect"].setBitmap("Graphics/Pictures/Hud/sleep")
        when :POISON
         @sprites2["status_effect"].setBitmap("Graphics/Pictures/Hud/Poison")
        when :BURN
         @sprites2["status_effect"].setBitmap("Graphics/Pictures/Hud/Flame")
        when :PARALYSIS
         @sprites2["status_effect"].setBitmap("Graphics/Pictures/Hud/Paralyzed")
        when :FROZEN
         @sprites2["status_effect"].setBitmap("Graphics/Pictures/Hud/Frozen")
		 else
         @sprites2["status_effect"].setBitmap("Graphics/Pictures/Hud/empty")
      end
	  if !current_selection.egg? && $PokemonGlobal.selected_pokemon[0]!=current_selection
	  $selection_arrows.remove_sprite("Arrow#{$PokemonGlobal.selected_pokemon[0]&.associatedevent}") if $PokemonGlobal.selected_pokemon[0] != 0
	  $PokemonGlobal.selected_pokemon[0] = current_selection  if !current_selection&.associatedevent.nil?
	  elsif $PokemonGlobal.selected_pokemon[0] != 0
	  $selection_arrows.remove_sprite("Arrow#{$PokemonGlobal.selected_pokemon[0]&.associatedevent}")if $PokemonGlobal.selected_pokemon[0]!=0
	  $PokemonGlobal.selected_pokemon[0] = 0 if current_selection.egg?
	  end

	elsif current_selection.is_a?(String)
	  object = nil
	
	  if $PokemonGlobal.selected_pokemon[0] != 0
	  $PokemonGlobal.selected_pokemon[0] = 0 
	  $selection_arrows.remove_sprite("Arrow#{$PokemonGlobal.selected_pokemon[0]&.associatedevent}")if $PokemonGlobal.selected_pokemon[0]!=0
	  end
	  
     @sprites2["status_effect"].setBitmap("Graphics/Pictures/Hud/empty")
	  name = current_selection
	  name = name.slice(0, 10) if name.length > 10
	  @sprites2["ball_icon"].item=:NO
	  @sprites2["pkmn_icon"].pokemon=nil
     @sprites2["durawindow"].baseColor  = Color.new(255,182,66)
	  text4 = ""    
	  @sprites2["durawindow"].text = text4
      @sprites2["durawindow"].resizeToFit(text4)

	  text5 = ""   
	  @sprites2["waterwindow"].text = text5
      @sprites2["waterwindow"].resizeToFit(text5)
	
	
	elsif current_selection == :MULTISELECT
	  object = nil
	
	  if $PokemonGlobal.selected_pokemon[0] != 0
	  $PokemonGlobal.selected_pokemon[0] = 0 
	  $selection_arrows.remove_sprite("Arrow#{$PokemonGlobal.selected_pokemon[0]&.associatedevent}")if $PokemonGlobal.selected_pokemon[0]!=0
	  end
	  
     @sprites2["status_effect"].setBitmap("Graphics/Pictures/Hud/empty")
	  name = "Multi Sel"
	  name = name.slice(0, 10) if name.length > 10
	  @sprites2["ball_icon"].item=:NO
	  @sprites2["pkmn_icon"].pokemon=nil
     @sprites2["durawindow"].baseColor  = Color.new(255,182,66)
	  text4 = ""    
	  @sprites2["durawindow"].text = text4
      @sprites2["durawindow"].resizeToFit(text4)

	  text5 = ""   
	  @sprites2["waterwindow"].text = text5
      @sprites2["waterwindow"].resizeToFit(text5)




	elsif current_selection.is_a?(ItemData)
	
	
	  if $PokemonGlobal.selected_pokemon[0] != 0
	  $PokemonGlobal.selected_pokemon[0] = 0 
	  $selection_arrows.remove_sprite("Arrow#{$PokemonGlobal.selected_pokemon[0]&.associatedevent}")if $PokemonGlobal.selected_pokemon[0]!=0
	  end
	  
     @sprites2["status_effect"].setBitmap("Graphics/Pictures/Hud/empty")
	  object = GameData::Item.try_get(current_selection) 
	  @sprites2["ball_icon"].item=nil if @sprites2["ball_icon"].item!=current_selection
	  name = object.name
	  name = name.slice(0, 10) if name.length > 10
	  @sprites2["ball_icon"].item=current_selection
	  @sprites2["pkmn_icon"].pokemon=nil
     @sprites2["durawindow"].baseColor  = Color.new(255,182,66)
	  text4 = ""    
	  text4 = "#{current_selection.durability}/100" if current_selection.is_a?(ItemData) && current_selection.durability!=false && !GameData::Item.get(current_selection).is_foodwater? && !GameData::Item.get(current_selection).is_berry? && !GameData::Item&.try_get(current_selection).is_poke_ball? && current_selection.id!=:STONE
	  @sprites2["durawindow"].text = text4
      @sprites2["durawindow"].resizeToFit(text4)

	  text5 = ""   
     text5 = "#{current_selection.water}" if current_selection.is_a?(ItemData) && GameData::BerryPlant::WATERING_CANS.include?(current_selection.id)
	  @sprites2["waterwindow"].text = text5
      @sprites2["waterwindow"].resizeToFit(text5)
	  
	  
	  
	else
	 if $PokemonGlobal.selected_pokemon[0] != 0
	  $PokemonGlobal.selected_pokemon[0] = 0 
	  $selection_arrows.remove_sprite("Arrow#{$PokemonGlobal.selected_pokemon[0]&.associatedevent}") if $PokemonGlobal.selected_pokemon[0]!=0
	 end
    	return
	end
   
	cur_qty=$bag.quantity(current_selection) if current_selection.is_a?(ItemData) || (current_selection.is_a?(Symbol) && current_selection!=:MULTISELECT)
	if cur_qty > 0
		case cur_qty.to_s.length
		  when 1
		  @sprites2["amt"].x = x-24+46
		  when 2
		  @sprites2["amt"].x = x-24+40
		  when 3
		  @sprites2["amt"].x = x-24+36
		end

	end
	@sprites2["namewindow"].text=name if @sprites2["namewindow"].text!=name
	if !cur_qty.nil?
	@sprites2["amt"].text = "x#{cur_qty}" if cur_qty>0 && @sprites2["namewindow"].text!="x#{cur_qty}"
	@sprites2["amt"].text = "" if cur_qty==0 && @sprites2["namewindow"].text!=""
	end






	    6.times do |i|
   if $PokemonGlobal.set_extended_hud==true
      target = (i + 1 + $PokemonGlobal.ball_hud_index) % $PokemonGlobal.ball_order.length 
	  target -= $PokemonGlobal.ball_hud_index if target>$PokemonGlobal.ball_order.length
      altselect = $PokemonGlobal.ball_order[target]
	  next if altselect.nil?
	  
     next if i==5 && $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==altselect
      #next if @sprites2["pkmn_icon_small#{i}"].visible == false && @sprites2["secondary_boxes#{i}"].visible == false && @sprites2["durawindow_small#{i}"].visible == false && @sprites2["namewindow_small#{i}"].visible == false
          text1 = ""
		   text2 = ""
		   
	  if altselect.is_a?(Pokemon)
       @sprites2["pkmn_icon_small#{i}"].pokemon=altselect
	     name = GameData::Species.try_get(altselect.species).real_name
	     name = name.slice(0, 10) if name.length > 10
	     formname = altselect.species_data.form_name
	     text1 = "#{name}" if formname.nil? 
	     text1 = "#{name} (#{formname.slice(0, 1)})" if !formname.nil? 
	     text1 = altselect.name if altselect.egg?
	     text1 = "???" if altselect.egg?
		 text2 = "#{altselect.hp}/#{altselect.totalhp}" if !altselect.egg?
	  elsif altselect == :MULTISELECT
       @sprites2["pkmn_icon_small#{i}"].pokemon=nil
	     text1 = "Multi Sel" if formname.nil? 
	  end
	  
       @sprites2["durawindow_small#{i}"].text = text2
       @sprites2["namewindow_small#{i}"].text = text1
      @sprites2["durawindow_small#{i}"].resizeToFit(text2)
      @sprites2["namewindow_small#{i}"].resizeToFit(text1)
     @sprites2["pkmn_icon_small#{i}"].visible = true
     @sprites2["secondary_boxes#{i}"].visible = true
     @sprites2["durawindow_small#{i}"].visible = true
     @sprites2["namewindow_small#{i}"].visible = true
     if altselect.is_a?(Pokemon)
    @sprites2["durawindow_small#{i}"].baseColor = Color.new(24,198,33)  
    @sprites2["durawindow_small#{i}"].baseColor = Color.new(239,173,0) if altselect.hp <= (altselect.totalhp / 2).floor 
    @sprites2["durawindow_small#{i}"].baseColor = Color.new(255,74,57) if altselect.hp <= (altselect.totalhp / 4).floor
     end
   else
    
      #next if @sprites2["pkmn_icon_small#{i}"].visible == true && @sprites2["secondary_boxes#{i}"].visible == true && @sprites2["durawindow_small#{i}"].visible == true && @sprites2["namewindow_small#{i}"].visible == true

     @sprites2["pkmn_icon_small#{i}"].visible = false
     @sprites2["secondary_boxes#{i}"].visible = false
     @sprites2["durawindow_small#{i}"].visible = false
     @sprites2["namewindow_small#{i}"].visible = false

       @sprites2["durawindow_small#{i}"].baseColor = Color.new(255,182,66)  # Default (green)
       @sprites2["pkmn_icon_small#{i}"].item=nil if defined?(@sprites2["pkmn_icon_small#{i}"].item)
       @sprites2["pkmn_icon_small#{i}"].pokemon=nil if defined?(@sprites2["pkmn_icon_small#{i}"].pokemon)
       @sprites2["durawindow_small#{i}"].text = ""
       @sprites2["namewindow_small#{i}"].text = ""
      @sprites2["durawindow_small#{i}"].resizeToFit("")
      @sprites2["namewindow_small#{i}"].resizeToFit("")
   
   end
       end




	return if $old_ball==name && $old_qty==cur_qty
	

	$old_ball = name
	$old_qty = cur_qty
	
	
	overlay=@sprites2["overlay"].bitmap
	overlay.clear
	
   end

  def is_broseph?
    broseph = nil
   return false if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(String)
      if $game_temp.current_pkmn_controlled!=false
        broseph = $game_temp.current_pkmn_controlled
	  
	  else
	      if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]!=:MULTISELECT
            id = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]&.associatedevent
		   end
		 id = $PokemonGlobal.stored_ball_order&.associatedevent if $PokemonGlobal.stored_ball_order && id.nil?
        broseph = $game_map.events[id] if !id.nil?
	   end
    return !broseph.nil?
  end

  def refreshSelection
   return if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(String)
   return if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(ItemData)
    if $PokemonGlobal.display_moves==false
      if $game_temp.current_pkmn_controlled!=false
        broseph = $game_temp.current_pkmn_controlled
	  
	  else
	      if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]!=:MULTISELECT
        id = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]&.associatedevent
		   end
		 id = $PokemonGlobal.stored_ball_order&.associatedevent if $PokemonGlobal.stored_ball_order && id.nil?
        broseph = $game_map.events[id] if !id.nil?
	   end
		if !broseph.nil?
		if $PokemonGlobal.ball_hud_enabled==true
       broseph.type.moves.each_with_index do |move,index|
        @sprites4["selection#{index}"].visible = true
        @sprites4["item_sel#{index}"].text=""
		  movename = move.name
		  if movename.length>7
		   movename = movename.slice(0, 7)
		   movename = "#{movename...}"
		  end
        @sprites4["item_sel#{index}"].text="#{index+1}. #{movename} (#{move.pp}/#{move.total_pp})"
        @sprites4["item_sel#{index}"].baseColor=get_type_color(move.type)
        @sprites4["item_sel#{index}"].shadowColor=get_shadow_color(move.type)
        @sprites4["item_sel#{index}"].visible = true
        if index == $PokemonGlobal.hud_selector && $game_temp.current_pkmn_controlled!=false
          @sprites4["item_sel#{index}"].x = 420-30
          @sprites4["selection#{index}"].x = 420-30
          @sprites4["selection#{index}"].setBitmap("Graphics/Pictures/ov_selection_box2")
        else
          @sprites4["item_sel#{index}"].x = 415-60
          @sprites4["selection#{index}"].x = 415-60
          @sprites4["selection#{index}"].setBitmap("Graphics/Pictures/ov_selection_box")
        end
       end
       @sprites4["selection4"].visible = true 
       @sprites4["item_sel4"].visible = true 
		if 4 == $PokemonGlobal.hud_selector && $game_temp.current_pkmn_controlled!=false
          @sprites4["selection4"].setBitmap("Graphics/Pictures/ov_selection_box2")
 
          @sprites4["item_sel4"].x = 420-30
          @sprites4["selection4"].x = 420-30
		else
          @sprites4["selection4"].setBitmap("Graphics/Pictures/ov_selection_box")
          @sprites4["item_sel4"].x = 415-60
          @sprites4["selection4"].x = 415-60
 
		end
       else 
     5.times do |index| 
	     next if @sprites4["selection#{index}"].visible == false && @sprites4["item_sel#{index}"].visible == false
        @sprites4["selection#{index}"].visible = false
        @sprites4["item_sel#{index}"].visible = false
        @sprites4["item_sel#{index}"].baseColor=get_type_color(:DURIS)
        @sprites4["item_sel#{index}"].shadowColor=get_shadow_color(:DURIS)
        @sprites4["item_sel#{index}"].text="" if index!=4
      
	  end
     end
       else

      5.times do |index| 
	     next if @sprites4["selection#{index}"].visible == false && @sprites4["item_sel#{index}"].visible == false
        @sprites4["selection#{index}"].visible = false
        @sprites4["item_sel#{index}"].visible = false
        @sprites4["item_sel#{index}"].baseColor=get_type_color(:DURIS)
        @sprites4["item_sel#{index}"].shadowColor=get_shadow_color(:DURIS)
        @sprites4["item_sel#{index}"].text="" if index!=4
      
	  end
       end	   
    else
	
     5.times do |index| 
	     next if @sprites4["selection#{index}"].visible == false && @sprites4["item_sel#{index}"].visible == false
        @sprites4["selection#{index}"].visible = false
        @sprites4["item_sel#{index}"].visible = false
        @sprites4["item_sel#{index}"].baseColor=get_type_color(:DURIS)
        @sprites4["item_sel#{index}"].shadowColor=get_shadow_color(:DURIS)
        @sprites4["item_sel#{index}"].text="" if index!=4
      
	  end
	end
 end


  def refreshHPLevel(width, height)
   event = $game_temp.lockontarget
   
   if $bag.has?(:HPDETECTOR)
    
    text = "#{event.pokemon.name}"
	@sprites3["namewindowevent"].text  = text
    fillWidth = width-4
    fillHeight = height-4
    totalhp = event.pokemon.totalhp
    hp = event.pokemon.hp
    @sprites3["hpbarborderevent"].visible = hp!=nil
    #@sprites3["bar"].visible = @sprites3["hpbarborderevent"].visible
	
	
	
    @sprites3["hpbarfillevent"].visible = @sprites3["hpbarborderevent"].visible
    @sprites3["hpbarfillevent"].bitmap.clear
	
	
    fillAmount = (hp==0 || totalhp==0) ? 0 : (event.pokemon.hp*@sprites3["hpbarfillevent"].bitmap.width/totalhp)
    # Always show a bit of HP when alive
    return if fillAmount <= 0
	
    hpColors = hpBarCurrentColors(hp, totalhp)
    shadowHeight = 2
    @sprites3["hpbarfillevent"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors[1]
    )
    @sprites3["hpbarfillevent"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites3["hpbarfillevent"].bitmap.height-shadowHeight
      ), hpColors[0]
    )
   end
   if $bag.has?(:LVLDETECTOR)
    text = "#{event.pokemon.name} Lv #{event.pokemon.level}"
   end
   @sprites3["namewindowevent"].visible = true if $bag.has?(:HPDETECTOR) || $bag.has?(:LVLDETECTOR)
   



  end




end


class HUD #Player Bars


   #   if @pokemon.hp > 0
   #   w = @pokemon.hp * 96 / @pokemon.totalhp.to_f
    #  w = 1 if w < 1
    #  w = ((w / 2).round) * 2
    #  hpzone = 0
    #  hpzone = 1 if @pokemon.hp <= (@pokemon.totalhp / 2).floor
    #  hpzone = 2 if @pokemon.hp <= (@pokemon.totalhp / 4).floor
    #  imagepos = [
    #    ["Graphics/Pictures/Summary/overlay_hp", 360, 110, 0, hpzone * 6, w, 6]
    #  ]
    #  pbDrawImagePositions(overlay, imagepos)
    #end



  def createSTABar(x, y, width, height)
    fillWidth = width-4
    fillHeight = height-4
    @sprites["starbarborder"] = BitmapSprite.new(width,height,@viewport1)
    @sprites["starbarborder"].x = x-width/2
    @sprites["starbarborder"].y = y-height/2
    @sprites["starbarborder"].z=9
    @sprites["bar"]=IconSprite.new((@sprites["starbarborder"].x-5),(@sprites["starbarborder"].y-8),@viewport1)
    @sprites["bar"].setBitmap(BG_PATH)
    @sprites["bar"].visible = false
    @sprites["bar"].z = 9
    @sprites["starbarborder"].bitmap.fill_rect(Rect.new(0,0,width,height), Color.new(32,32,32))
    @sprites["starbarborder"].bitmap.fill_rect((width-fillWidth)/2, (height-fillHeight)/2,fillWidth, fillHeight, Color.new(96,96,96))
    @sprites["starbarborder"].visible = false
    @sprites["starbarfill"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @sprites["starbarfill"].x = x-fillWidth/2
    @sprites["starbarfill"].y = y-fillHeight/2
    @sprites["starbarfill"].z=9
	
  end

  def createHPBar(x, y, width, height)
  
    fillWidth = width-4
    fillHeight = height-4
    @sprites["hpbarborder"] = BitmapSprite.new(width,height,@viewport1)
    @sprites["hpbarborder"].x = x-width/2
    @sprites["hpbarborder"].y = y-height/2
        @sprites["hpbarborder"].z=9
    @sprites["bar2"]=IconSprite.new((@sprites["hpbarborder"].x-5),(@sprites["hpbarborder"].y-7),@viewport1)
    @sprites["bar2"].setBitmap(BG_PATH2)
    @sprites["bar2"].visible = false
    @sprites["bar2"].z = 9
    @sprites["hpbarborder"].bitmap.fill_rect(
      Rect.new(0,0,width,height), Color.new(32,32,32)
    )
    @sprites["hpbarborder"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )
    @sprites["hpbarborder"].visible = false
    @sprites["hpbarfill"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @sprites["hpbarfill"].x = x-fillWidth/2
    @sprites["hpbarfill"].y = y-fillHeight/2
    @sprites["hpbarfill"].z=9
	
  end


  def refreshSTABar
    @sprites["starbarborder"].visible = $player.playerstamina!=nil
    @sprites["bar"].visible = @sprites["starbarborder"].visible
    @sprites["starbarfill"].visible = @sprites["starbarborder"].visible
    @sprites["starbarfill"].bitmap.clear
    fillAmount = ($player.playerstamina==0 || $player.playermaxstamina==0) ? 0 : (
      $player.playerstamina*@sprites["starbarfill"].bitmap.width/$player.playermaxstamina
    )
    # Always show a bit of HP when alive
    return if fillAmount <= 0
    hpColors = Color.new(255,182,66)
    shadowHeight = 2
    @sprites["starbarfill"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors
    )
    @sprites["starbarfill"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["starbarfill"].bitmap.height-shadowHeight
      ), hpColors
    )

  end


  def refreshHPBar
    @sprites["hpbarborder"].visible = $player.playerhealth!=nil
    @sprites["bar2"].visible = @sprites["hpbarborder"].visible
    @sprites["hpbarfill"].visible = @sprites["hpbarborder"].visible
    @sprites["hpbarfill"].bitmap.clear
    fillAmount = ($player.playerhealth==0 || $player.playermaxhealth2==0) ? 0 : (
      $player.playerhealth*@sprites["hpbarfill"].bitmap.width/$player.playermaxhealth2
    )
    # Always show a bit of HP when alive
    return if fillAmount <= 0
    hpColors = hpBarCurrentColors($player.playerhealth, $player.playermaxhealth2)
    shadowHeight = 2
    @sprites["hpbarfill"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors[1]
    )
    @sprites["hpbarfill"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["hpbarfill"].bitmap.height-shadowHeight
      ), hpColors[0]
    )

  end



end




class HUD

  def hpBarCurrentColors(hp, totalhp)
    if hp<=(totalhp/4.0)
      return HP_BAR_RED
    elsif hp<=(totalhp/2.0)
      return HP_BAR_YELLOW
    end
    return HP_BAR_GREEN
  end

  def tryUpdate(force=false)
    if showHUD?
      update(force) if @lastRefreshFrame != Graphics.frame_count
    else
      #dispose if hasSprites?
    end
  end

  def update(force=false)
   if showHUD?
    @visible = true
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
    if $PokemonGlobal.ball_hud_enabled==false || $game_temp.current_pkmn_controlled!=false
        hideBallHUD
        getCurrentItemOrder
    else
        revealBallHUD
        getCurrentItemOrder
    end
    if $PokemonGlobal.bars_visible==false || $game_temp.in_menu
        hideMainHUD
    else
        revealMainHUD
    end
   # if $game_temp.current_pkmn_controlled==false || $game_temp.menu_calling
	#  hideSelectionHUD
	#else
	#  revealSelectionHUD
	#end
    if $game_temp.lockontarget==false
	  hideHPHUD
	else
	  revealHPHUD
	end
    
    pbUpdateSpriteHash(@sprites)
    pbUpdateSpriteHash(@sprites2)
    pbUpdateSpriteHash(@sprites3)
    pbUpdateSpriteHash(@sprites4)
    pbUpdateSpriteHash(@sprites5)
    @lastRefreshFrame = Graphics.frame_count
    self.class.tryUpdateAll if self.class.shouldUpdateAll?
  else 
   @visible = false
	end
  end

  def dispose
    pbDisposeSpriteHash(@sprites)
    pbDisposeSpriteHash(@sprites2)
    pbDisposeSpriteHash(@sprites3)
  end

  def hasSprites?
    return !@sprites.empty?
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

class MouseVisual
  
  def initialize
    @viewport = Viewport.new(0-$PokemonSystem.screenposx, 0-$PokemonSystem.screenposy, Settings::SCREEN_WIDTH*4, Settings::SCREEN_HEIGHT*4)
	@viewport.z = 999999999
	@mouse = nil
    @disposed = false
    @disabled = false
    @mode = :DEFAULT
  end
  
  def x
   return @mouse.x
  end
  def y
   return @mouse.y
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
	  @mode = :FOLLOW
	  image_per_mode
	  sideDisplay("Mouse Mode: Pointer")
	  $selection_displayer.prior_mode(:FOLLOW)
    elsif @mode == :FOLLOW
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
    elsif @mode == :SQUARE
	  @mouse.setBitmap("Graphics/UI/Cursor/cursor2.png")
	else
	 if !($PokemonGlobal.selected_pokemon.length<2 && $PokemonGlobal.selected_pokemon[0]==0 && @mode == :FOLLOW)
	  @mouse.setBitmap("Graphics/UI/Cursor/cursor3.png")
	 end
	end
  
  end
  def hidden?
	return @mouse.visible==false
  end
  
  def disposed?
   return @disposed
  end
  def update
    return if @disposed
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
	if $PokemonGlobal.selected_pokemon.length<2 && $PokemonGlobal.selected_pokemon[0]==0 && @mode == :FOLLOW
   set_mode(:DEFAULT) 
    end
    end
  
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
    $hud.dispose if $hud
	 $styler.dispose if $styler
    disposeOldFL
  end
  def update
    updateOldFL
	pbCreateParticleEngine(@viewport1, @map)
	$selection_arrows = SelectionBaseDisplay.new(@viewport1) if !$selection_arrows
	$styler = MouseTrail.new(@viewport1) if !$styler
	$selection_displayer = SelectionDisplay.new(@viewport1) if !$selection_displayer
	$tensionbars = TensionBars.new(@viewport1) if !$tensionbars
    $hud = HUD.new(@viewport1) if !$hud
	$sidedisplay = SideDisplayUI.new(@viewport1) if !$sidedisplay
    $styler.update
    $selection_displayer.update
    $selection_arrows.update
    $tensionbars.update
    $hud.update
    $sidedisplay.update
    $particle_engine.update if $particle_engine
  end
end
class IconSprite < Sprite
  attr_accessor :call_id
    def call_id
      @call_id = 0 if @call_id.nil?
      return @call_id
	end
end 


class SelectionBaseDisplay
  
  def initialize(viewport)
    @viewport = viewport
	@sprites = {}
    @disposed = false
  end
 
  def dispose
	pbDisposeSpriteHash(@sprites)
	@disposed=true
  end
  
  def hide
   @sprites.each_key do |i|
	@sprites.visible=false
   end
  end
  
  def show
   @sprites.each_key do |i|
	@sprites.visible=true
   end
  end
  
  def disposed?
   return @disposed
  end
  
  def remove_sprite(sprite)
	   if !@sprites[sprite].nil?
	   if !@sprites[sprite].disposed?
	    @sprites[sprite].visible=false
	    @sprites[sprite].dispose
		@sprites.delete(sprite)
		end
     end
  end

  def update
    return if @disposed
	 $PokemonGlobal.selected_pokemon.each do |pkmn|
	   next if pkmn==0
	   event_id = pkmn.associatedevent
	   if event_id.nil? && pkmn.in_world==true
	    event_id = getOverworldPokemonfromPokemon(pkmn)
		 pkmn.associatedevent=event_id
	   end
	   next if event_id.nil?
	   event = $game_map.events[event_id]
	   if !event.nil?
	   if @sprites["Arrow#{event_id}"].nil?
	    @sprites["Arrow#{event_id}"] = IconSprite.new(@viewport)
		@sprites["Arrow#{event_id}"].setBitmap("Graphics/UI/Cursor/selected2.png")
	   end
         if !@sprites["Arrow#{event_id}"].disposed?
       @sprites["Arrow#{event_id}"].x = ScreenPosHelper.pbScreenX(event) - 17
       @sprites["Arrow#{event_id}"].y = ScreenPosHelper.pbScreenY(event) - 60
       @sprites["Arrow#{event_id}"].z = ScreenPosHelper.pbScreenZ(event) + 1
	     end
	   else
	   
	   if !@sprites["Arrow#{event_id}"].nil? && !@sprites["Arrow#{event_id}"].disposed?
	    @sprites["Arrow#{event_id}"].visible=false
	    @sprites["Arrow#{event_id}"].dispose
		@sprites.delete("Arrow#{event_id}")
	   end

	   end
	   
	   
	 end
   if $PokemonGlobal.selected_pokemon.length < @sprites.length
     $player.party.each do |pkmn|
	    next if pkmn.in_world==false
	   event_id = pkmn.associatedevent
	   if event_id.nil?
	    event_id = getOverworldPokemonfromPokemon(pkmn)
	   end
	   next if event_id.nil?
	 	if !@sprites["Arrow#{event_id}"].nil? && !@sprites["Arrow#{event_id}"].disposed?
	    @sprites["Arrow#{event_id}"].visible=false
	    @sprites["Arrow#{event_id}"].dispose
		@sprites.delete("Arrow#{event_id}")
	   end
	 
	 
	 end
   
   
   end
	    
   if Input.time?(Input::MOUSELEFT) >= 0.65 && Input.mouse_in_window? 
	  event_id2=$game_map.check_event(*get_tile_mouse_on)
      if event_id2.is_a?(Integer)
	     if $game_map.events[event_id2].is_a?(Game_PokeEventA)
	    if $game_map.events[event_id2].name=="PlayerPkmn" && $PokemonGlobal.selected_pokemon.include?($game_map.events[event_id2].pokemon) && $game_map.events[event_id2].pokemon.deselecttimer == 0
		  $PokemonGlobal.selected_pokemon.delete($game_map.events[event_id2].pokemon)
		  
	   if !@sprites["Arrow#{event_id2}"].nil? && !@sprites["Arrow#{event_id2}"].disposed?
	    @sprites["Arrow#{event_id2}"].visible=false
	    @sprites["Arrow#{event_id2}"].dispose
		@sprites.delete("Arrow#{event_id2}")
	   end
       else
	    $game_map.events[event_id2].pokemon.deselecttimer -= 1 if $game_map.events[event_id2].pokemon.deselecttimer>0
		end

        end
	  end
		  end
  end



end


#===============================================================================
#
#  Trainer Sensor Script
#  Author     : Drimer
#
#===============================================================================

#===============================================================================
#                             **  Settings here! **
#
# RANGE sets the... range of detection! If it is set to 0 it will take the
# value x from 'Trainer(x)' (Event's name!)
#
# BAR_OPACITY is used to set the transparency to the focus bars.
#
# SELF_SWITCH is used to identify those trainers you already fought against of.
#
# BAR_HEIGHT sets the the focus bars' height value.
#
# BAR_GRAPHIC allows you to load your own graphic from 'Graphics/Pictures/'
# if it is set to "" or nil, the system will create them for you. If not, then
# the BAR_HEIGHT will be ignored as well as the BAR_OPACITY constant.
#===============================================================================
module TrainerSensor
  RANGE       = 3
  BAR_OPACITY = 255/2
  SELF_SWITCH = "A"
  BAR_HEIGHT  = Graphics.height/6
  BAR_GRAPHIC = ""
  # If you use EBS, a good option is set this value to "EBS/newBattleMessageBox"
end
  

#===============================================================================
# **  
#===============================================================================
class TensionBars
  attr_accessor :triggered
  attr_accessor :top
  
  def initialize(viewport)
    @top = Sprite.new(viewport)
     @top.z = 0
     @bottom = Sprite.new(viewport)
     @bottom.z = @top.z
     @triggered = false
     @custom_graphic = false
     @created = false
    if ["", nil].include?(TrainerSensor::BAR_GRAPHIC)
      @top.bitmap = Bitmap.new(Graphics.width, TrainerSensor::BAR_HEIGHT)
      @top.bitmap.fill_rect(0,0,@top.bitmap.width,@top.bitmap.height,
        Color.new(-255,-255,-255, TrainerSensor::BAR_OPACITY))
    else
      @top.bitmap = BitmapCache.load_bitmap("Graphics/Pictures/#{TrainerSensor::BAR_GRAPHIC}")
      @top.ox = @top.bitmap.width/2
      @top.x = Graphics.width/2
      @top.y = -@top.bitmap.height
      @top.mirror = true
      @top.angle = 180
      @custom_graphic = true
    end
    @top.oy = @top.bitmap.height
    @bottom.bitmap = @top.bitmap.clone
    if @custom_graphic
      @bottom.ox = @bottom.bitmap.width/2
      @bottom.x = Graphics.width/2
    end
    @bottom.y = Graphics.height
    @created = true
  end
  
  def triggered?
    @triggered
  end
  def disposed?
    @top.disposed? && @bottom.disposed?
  end  
  def show
    @triggered = true
  end
  
  def hide
    @triggered = false
  end
  
  def update
    return if !@created
    if @triggered
      if @top.y < (@custom_graphic ? 0 : (TrainerSensor::BAR_HEIGHT - 6) )
        @top.y += 6
        @bottom.y -= 6
      end
    else
      if @top.y > (@custom_graphic ? -@top.bitmap.height : 0 )
        @top.y -= 6
        @bottom.y += 6
      end    
    end
  end
  
  # Function to check if the player is in an event's range
  def inRange?(event, event2, distance)
    distance = TrainerSensor::RANGE if distance.nil?
    return false if distance<=0
    rad = (Math.hypot((event.x - $game_player.x),(event.y - $game_player.y))).abs
    return true if (rad <= distance)
    return false
  end
end

# Change it to Events.StepTaken if you want this to scan the events on each step
# the player gives.
EventHandlers.add(:on_step_taken, :tension_screen,
  proc { |mevent|
    next if !$scene.is_a?(Scene_Map)
	 next if $PokemonSystem.tension_screen==1
    #next if mevent != $game_player && $game_temp.current_pkmn_controlled==false && !TrainerSensor.triggered?
    #next if $game_temp.current_pkmn_controlled!=false && mevent != $game_temp.current_pkmn_controlled && !TrainerSensor.triggered?
	event2 = $game_player if $game_temp.current_pkmn_controlled==false
	event2 = $game_temp.current_pkmn_controlled if $game_temp.current_pkmn_controlled!=false
	
  for event in $game_map.events.values
    if (event.name[/^Trainer\((\d+)\)$/] && event.isOff?(TrainerSensor::SELF_SWITCH)) || event.is_a?(Game_PokeEvent)
      distance=$~[1].to_i if !event.is_a?(Game_PokeEvent)
      distance=event.counter.to_i if event.is_a?(Game_PokeEvent)
      if $tensionbars.inRange?(event, event2, distance)
        $tensionbars.show()
        break
      else
        $tensionbars.hide() if $tensionbars.triggered?
      end
    else
      $tensionbars.hide() if $tensionbars.triggered?
    end

  end
}

)


class PokemonSystem
  attr_accessor :tension_screen
  
  def tension_screen
   @tension_screen = 1 if @tension_screen.nil?
    return @tension_screen
  end
end


class MouseTrail
  attr_accessor :styler_on
  attr_accessor :user_styler
  attr_accessor :styler_dead
  attr_accessor :max_trail_length
  attr_accessor :trail_fade_speed
  attr_accessor :trigger_cooldown
  attr_accessor :target_hits_f
  attr_accessor :styler_health
  
  
  
  def initialize(viewport = nil)
    @viewport = viewport || Viewport.new(0, 0, Graphics.width, Graphics.height)
	 placeholder_styler = ItemData.new(:CAPTURESTYLUS)
     placeholder_styler.capture_styler_stats["Health"]=100
     placeholder_styler.capture_styler_stats["Power"]=0
     placeholder_styler.capture_styler_stats["Line"]=0 #10 #35
     placeholder_styler.capture_styler_stats["Recovery"]=0
     placeholder_styler.capture_styler_stats["LP"]=0
     placeholder_styler.capture_styler_stats["Fading"]=0
	 set_styler(placeholder_styler)
    @trail_sprites = []
    @trail_locations = {}
    @most_recent_trail = nil
    @styler_on = false
    @styler = create_styler
    @min_x = 999
    @max_x = 0
    @min_y = 999
    @max_y = 0
    @trigger_cooldown = 0
    @stamina_cooldown = 0
    @target_hits_f = 0
    @disposed = false
    @styler_dead = false
	 @stamina_cooldown_target = 40
	 @lastsound = 0
	
	
	
  end
 
  def set_styler(styler)
      @user_styler = styler
      @styler_health = @user_styler.capture_styler_stats["Health"]
      power = @user_styler.capture_styler_stats["Power"]
      line = @user_styler.capture_styler_stats["Line"]
      recovery = @user_styler.capture_styler_stats["Recovery"]
      latentpower = @user_styler.capture_styler_stats["LP"]
      fading = @user_styler.capture_styler_stats["Fading"]
	  
	  
      @max_trail_length = 40 + line # Maximum number of trail segments, 25 too low
      @trail_fade_speed = 1.5 + fading  # Speed of fading, lower is slower
	   @trigger_target = 60 - latentpower
       @power = power+1
	   @recovery = recovery+1
      @assists = @user_styler.capture_styler_stats["Assists"]
  end
  
  
  def are_two_trails_touching(given_key)
     
     given_value = @trail_locations[given_key]
	 return if given_value.nil?  
     @trail_locations.each do |key, coords|
	   #puts "Coords: #{[coords[0],coords[1]].to_s}"
       @min_x = [@min_x, coords[0]].min
       @max_x = [@max_x, coords[0]].max

       @min_y = [@min_y, coords[1]].min
       @max_y = [@max_y, coords[1]].max
	  # puts "Mins: #{[@min_x,@min_y].to_s} Maxs: #{[@max_x,@max_y].to_s}"
	    next if key == given_key  # Skip the given key itself
       coord_pair = coords # Combine x and y into an array for easy comparison
       if coord_pair == given_value
	    if [@min_x, @min_y] == [@max_x, @max_y]
         return false
	    end
	     	spriteindex = @trail_sprites.index(key)
	     	if !spriteindex.nil?
			 if !@trail_sprites[spriteindex].disposed?
	     	 if spriteindex >= (@trail_sprites.length/1.85)
		        return false
		     end
            end
	       end
		  return true
       end
	   
	   
     end
    return false
  end
  
  def dispose
    @trail_sprites.each do |sprite|
       sprite.dispose
    end
	@styler.dispose
	@disposed=true
  end
  
  def view_styler
  
  
  end

  def get_tile_line_on(x1,y1)
     x = (((x1 * Game_Map::X_SUBPIXELS) + $game_map.display_x)/Game_Map::REAL_RES_X).round
     y = (((y1 * Game_Map::Y_SUBPIXELS) + $game_map.display_y)/Game_Map::REAL_RES_Y).round
     return x,y
  end


  def update
    return if $game_temp.in_menu
    return if @disposed
    @styler = create_styler if !@styler
    if $PokemonGlobal.ball_hud_enabled==true && $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]!=:CAPTURESTYLER
	 @styler.visible = false if @styler.visible==true
    @trail_sprites.each_with_index do |sprite, index|
      sprite.opacity -= @trail_fade_speed
      if sprite.opacity <= 0
	    @trail_locations.delete(sprite)
        sprite.dispose
        @trail_sprites.delete_at(index)
      end
    end
	 return 
	end
    if @styler_on==false
	 @styler.visible = false if @styler.visible==true
    @trail_sprites.each_with_index do |sprite, index|
      sprite.opacity -= @trail_fade_speed
      if sprite.opacity <= 0
	    @trail_locations.delete(sprite)
        sprite.dispose
        @trail_sprites.delete_at(index)
      end
    end
	 return 
	 else 
	 @styler.visible = true if @styler.visible==false
	end
    
	 update_styler
	 triggered=false

    @trail_sprites.each_with_index do |sprite, index|
    sprite.setBitmap("Graphics/Plugins/Capture Styler/styler_light.png") if index <= (@trail_sprites.length/1.85)
	sprite.setBitmap("Graphics/Plugins/Capture Styler/styler_light_unsafe.png") if index >= (@trail_sprites.length/1.85)
	  sprite.visible =true
      sprite.opacity -= @trail_fade_speed
	  
      if sprite.opacity <= 0
	    @trail_locations.delete(sprite)
        sprite.dispose
        @trail_sprites.delete_at(index)
      end
    end
	 if Input.press?(Input::MOUSELEFT) && Input.mouse_in_window? 
	 if Input.mouse_in_window? && @styler_dead==false 
	
	 pbBGSPlay("charge_loop",75) 
	 if @stamina_cooldown==0 && !($DEBUG && Input.press?(Input::CTRL))
	   decreaseStamina(1.8) 
	   @stamina_cooldown=@stamina_cooldown_target
	 else
	   @stamina_cooldown-=1 if @stamina_cooldown>0
	 end

	 else
	   pbBGSFade(1.0)
	 end
    # Create a new trail segment at the current mouse position
	 most_recent_trail = nil
    most_recent_trail = create_trail_segment if Input.mouse_in_window? && @styler_dead==false
    @most_recent_trail = most_recent_trail if !most_recent_trail.nil?
    # Update and fade existing trail segments
	if @trigger_cooldown==0 && @styler_dead==false
    if are_two_trails_touching(@most_recent_trail)
	   
	  if @min_x!=@max_x && @min_y!=@max_y
      (@min_x..@max_x).each do |x|
		     next if triggered==true
         (@min_y..@max_y).each do |y|
		     next if triggered==true
	        #puts "Coordinates: #{[x,y].to_s}}"
			$game_temp.preventspawns=true
            event_id = $game_map.check_event(x,y)
			$game_temp.preventspawns=false
	           if event_id.is_a?(Integer)
	            #puts "event_id: #{[event_id].to_s}}"
                 if event_id > 0
				   if !$game_map.events[event_id].nil?
  				    if $game_map.events[event_id].name[/vanishingEncounter/]
				      triggered=true
				      event = $game_map.events[event_id]
	                 event.remaining_steps+=10
				      pkmn = event.pokemon
				      pkmn.hits+=@power
					  makeAggressive(event) if !pkmn.is_aggressive?
					   target_hits = get_target_hits(pkmn)
					   #puts "Target Hits: #{target_hits}"
					   #puts "Hits: #{pkmn.hits}"
					   extra = ""
					   extra = " Only halfway to go!" if pkmn.hits==(target_hits/2).to_i
					   extra = " Almost There!" if pkmn.hits+10>=target_hits
	                 sideDisplay("#{pkmn.hits} hits on #{pkmn.name}!#{extra}") if pkmn.hits<target_hits
					    #puts "sound_index_calc: #{(pkmn.hits / (target_hits / 8.0)).floor.round}"
					    sound_index = [(pkmn.hits / (target_hits / 8.0)).floor, 7].min
						if @lastsound == sound_index && sound_index!=7
						  sound_index += rand(2)==0 ? 1 : -1
						  sound_index = 0 if sound_index<0 && @lastsound != 0
						  sound_index = 1 if sound_index<0 && @lastsound != 1
						  @lastsound = sound_index
						else
						 @lastsound = sound_index
						end
					    #puts "sound_index: #{sound_index}"
					    #puts sound_index
                     sound_filename = "Stylus#{sound_index + 1}"
					   pbSEPlay(sound_filename)
					   @styler_health+=@recovery
					  if pkmn.hits>=target_hits
                     pbPlayerEXP(pkmn,pbOverworldCombat.get_allied_pokemon)
		              pkmn.poke_ball = :POKEBALLC
		              pkmn.calc_stats
					   if $game_map.map_id!=11
					    if true
	                 sideDisplay("#{pkmn.name} has been caught!")
                     $scene.spriteset.addUserAnimation(7, event.x, event.y, true, 1)
					   pbHeldItemDropOW(pkmn)
					   pkmnAnim(pkmn)
                     pbAddPokemonSilent(pkmn)
                     event.removeThisEventfromMap
					     end
					   elsif $game_map.map_id == 11 && (pokemon = get_form_for_species(pkmn))
					    $game_temp.preventspawns=false
						$PokemonGlobal.cur_challenge.beaten += 1 if $PokemonGlobal.cur_challenge!=false
	                 sideDisplay("#{pkmn.name} has been defeated!")
					    x=event.x
						y=event.y
                     event.removeThisEventfromMap
					    pbPlaceEncounter(x,y,pokemon,2)
					   else
						$PokemonGlobal.cur_challenge.beaten += 1 if $PokemonGlobal.cur_challenge!=false
	                 sideDisplay("#{pkmn.name} has been defeated!")
					   pbHeldItemDropOW(pkmn,true)
					    event.removeThisEventfromMap
					   end
					  end

					   @trigger_cooldown=@trigger_target
				   end
                 end
               end
			   end
         end
      end
   	  end

   end
   else
    @trigger_cooldown-=1
   end
    @min_x = 999
    @max_x = 0
    @min_y = 999
    @max_y = 0
	end
     if Input.release?(Input::USE)
	   pbBGSFade(1.0)
	 end
  end
   def screen_x
    ret = ((@real_x.to_f - self.map.display_x) / Game_Map::X_SUBPIXELS).round
    ret += @width * Game_Map::TILE_WIDTH / 2
    ret += self.x_offset
    return ret
   end
   
   def screen_y
    ret = ((@real_y.to_f - self.map.display_y) / Game_Map::Y_SUBPIXELS).round
    ret += Game_Map::TILE_HEIGHT
    return ret
   end
   def get_form_for_species(pkmn)
     if pkmn.species == :GIRATINA && pkmn.form == 0
			pokemon = Pokemon.new(:GIRATINA, pkmn.level)
			pokemon.item = :GRISEOUSORB
			pokemon.form = 1
			pokemon.shiny = true
        
		
		
     elsif pkmn.species == :MEWTWO && pkmn.form == 0
			pokemon = Pokemon.new(:MEWTWO, pkmn.level)
			pokemon.form = 1
			pokemon.shiny = true
     elsif pkmn.species == :MEWTWO && pkmn.form == 1
			pokemon = Pokemon.new(:MEWTWO, pkmn.level)
			pokemon.form = 2
			pokemon.shiny = true
	 
	 
	 else
	    return false
	 end
	   return pokemon
   end
  
  def get_target_hits(pkmn)
	target_hits = pkmn.hp/4
	target_hits = 50 if target_hits > 50 
	target_hits = 10 if target_hits < 10
    target_hits = @target_hits_f if @target_hits_f!=0
    return target_hits
  end



  def remove_oldest_trail
    sprite = @trail_sprites[0]
	@trail_locations.delete(sprite)
    @trail_sprites.shift.dispose
  end


  def update_styler
   return if @styler_dead==true
   if @user_styler
    if @styler_health<=0
	   @styler_dead=true
      @styler.setBitmap("Graphics/Plugins/Capture Styler/loss.gif")
	  @styler.bitmap.looping=false
	end
   end
   return if @styler_dead==true
   @styler.x = Input.mouse_x
   @styler.y = Input.mouse_y + 5
  end
  
  def create_styler
   styler = IconSprite.new(@viewport)
   
   styler.setBitmap("Graphics/Plugins/Capture Styler/capture styler.gif")
   styler.ox = styler.bitmap.width/2
   styler.oy = styler.bitmap.height/2
   styler.x = Input.mouse_x
   styler.y = Input.mouse_y + 5
   styler.z = 99999
  
   return styler
  end
  
  private
  

  def create_trail_segment
    amt = 8
    sprite = IconSprite.new(@viewport)
    sprite.setBitmap("Graphics/Plugins/Capture Styler/styler_light.png") if @trail_sprites.length <= (@trail_sprites.length/1.85)
	sprite.setBitmap("Graphics/Plugins/Capture Styler/styler_light_unsafe.png") if @trail_sprites.length >= (@trail_sprites.length/1.85)
    sprite.ox = sprite.bitmap.width/2
    sprite.oy = sprite.bitmap.height/2
    sprite.x = @styler.x
    sprite.y = @styler.y+amt
    sprite.z = 99998  # Ensure it's on top
	 sprite.visible = false
	sprite.call_id = @trail_sprites.length
    @trail_sprites.push(sprite)
    @trail_locations[sprite]=get_tile_line_on(sprite.x,sprite.y-amt-5)
    # Limit the number of trail segments
    if @trail_sprites.size > @max_trail_length
	  remove_oldest_trail
    end
	 return sprite
  end





end
class SelectionDisplay
  
  def initialize(viewport)
    @viewport = viewport
	@sprites = {}
   @sprites["square"] = IconSprite.new(@viewport)
    @sprites["square"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
   @sprites["square"].z = 99999
    @mouse_start_x = nil  # X position where the left-click started
    @mouse_start_y = nil  # Y position where the left-click started
    @mouse_end_x = nil  # X position where the left-click is
    @mouse_end_y = nil  # Y position where the left-click is
    @drawing = false  # To track whether we are currently drawing
    @line_width = 1  # Width of the outline
    @color = Color.new(255, 0, 0)  # Color of the square outline (red)
    @disposed = false
    @prior_mode = nil
  end
 
  def dispose
	pbDisposeSpriteHash(@sprites)
	@disposed=true
  end
  
  def hide
   @sprites.each_key do |i|
	@sprites.visible=false
   end
  end
  
  def show
   @sprites.each_key do |i|
	@sprites.visible=true
   end
  end
  
  def disposed?
   return @disposed
  end
  
  def draw_square(x1, y1, x2, y2)
    @sprites["square"].bitmap.clear  # Clear previous drawings
    # Calculate square's dimensions
    width = (x2 - x1).abs
    height = (y2 - y1).abs
    x = [x1, x2].min  # Get the top-left corner
    y = [y1, y2].min  # Get the top-left corner

    # Draw the hollow square (four sides)
    @sprites["square"].bitmap.fill_rect(x, y, width, @line_width, @color)  # Top side
    @sprites["square"].bitmap.fill_rect(x, y, @line_width, height, @color)  # Left side
    @sprites["square"].bitmap.fill_rect(x + width - @line_width, y, @line_width, height, @color)  # Right side
    @sprites["square"].bitmap.fill_rect(x, y + height - @line_width, width, @line_width, @color)  # Bottom side
  end

  def prior_mode(mode)
    @prior_mode = mode
  end
  def check_events_in_square
    x1,y1 = get_tile_from_screen_pos(@mouse_start_x, @mouse_start_y)
    x2,y2 = get_tile_from_screen_pos(@mouse_end_x, @mouse_end_y)
  
    start_x = [x1, x2].min
    start_y = [y1, y2].min
    end_x = [x1, x2].max
    end_y = [y1, y2].max


    followers = pokemon_in_world
    return if followers.length == 0
    followers.each do |pkmn|
	   if $PokemonGlobal.selected_pokemon.include?(pkmn) && pkmn.in_world==false
	     $PokemonGlobal.selected_pokemon.delete(pkmn)
	   end
	   event = $game_map.events[getOverworldPokemonfromPokemon(pkmn)]
	   next if event.nil?
      if event.x.between?(start_x, end_x) && event.y.between?(start_y, end_y)
        puts "#{event.pokemon.name} (#{event.id}) is inside the square!"
        pbSelectThisPokemon(pkmn)
	  else 
	    pbDeselectThisPokemon(pkmn)
      end
	  
	  
    end
  end

  
  def update
    return if @disposed
     bonus = 2 
	 if Input.press?(Input::ALTERNATEMOUSEMODE) && $mouse.current_mode!=:SQUARE
	  @prior_mode = $mouse.current_mode if $mouse.current_mode!=:SQUARE
	 
	  $mouse.set_mode(:SQUARE)
	 elsif Input.release?(Input::ALTERNATEMOUSEMODE) && @drawing==false && @prior_mode!=:SQUARE
	  $mouse.set_mode(@prior_mode)
	 end
    if ((Input.time?(Input::MOUSELEFT) >= 1 && $mouse.current_mode!=:FOLLOW) || Input.trigger?(Input::MOUSELEFT) && $mouse.current_mode==:SQUARE  ) && @drawing==false && !($game_map.check_event(*get_tile_mouse_on)).is_a?(Integer)
   @mouse_start_x = Input.mouse_x + bonus
   @mouse_start_y = Input.mouse_y + bonus
      @drawing = true
	  @prior_mode = $mouse.current_mode if $mouse.current_mode!=:SQUARE
	  $mouse.set_mode(:SQUARE)
   end
     if ((Input.time?(Input::MOUSELEFT) >= 1 && $mouse.current_mode!=:FOLLOW) || Input.press?(Input::MOUSELEFT) && $mouse.current_mode==:SQUARE )  && @drawing==true
      @mouse_end_x = Input.mouse_x + bonus
      @mouse_end_y = Input.mouse_y + bonus
      draw_square(@mouse_start_x, @mouse_start_y, @mouse_end_x, @mouse_end_y)  # Draw the square based on mouse positions
	  check_events_in_square
    end 
     if Input.release?(Input::MOUSELEFT) && @drawing==true
      reset_square
    end 
	 
  end

  def reset_square
    @sprites["square"].bitmap.clear 
    @mouse_start_x = nil
    @mouse_start_y = nil
    @mouse_end_x = nil
    @mouse_end_y = nil
	$mouse.set_mode(@prior_mode)
    @drawing = false
  end

end

def pbTogglePokemonSelection(pkmn)
  if $PokemonGlobal.selected_pokemon.include?(pkmn)
    pbDeselectThisPokemon(pkmn)
  else
    pbSelectThisPokemon(pkmn)
  end
end
def pbSelectThisPokemon(pkmn, forced=false)
  return false if $PokemonGlobal.selected_pokemon.include?(pkmn) && $PokemonGlobal.selected_pokemon.index(pkmn)!=0 && forced==false
  return false if $PokemonGlobal.selected_pokemon.count(pkmn) > 1 && forced==false
  $PokemonGlobal.selected_pokemon << pkmn
  return true
end

def pbDeselectThisPokemon(pkmn)
  return false if !$PokemonGlobal.selected_pokemon.include?(pkmn)
  if $PokemonGlobal.selected_pokemon.index(pkmn)==0
    $PokemonGlobal.selected_pokemon[0]=0
  end
  $PokemonGlobal.selected_pokemon.delete(pkmn) if $PokemonGlobal.selected_pokemon.include?(pkmn)
  $selection_arrows.remove_sprite("Arrow#{pkmn.associatedevent}")
  return true
end
# For compatibility with older versions
module GameData
  class Species
    class << self
      if !method_defined?(:icon_filename_from_pokemon)
        def icon_filename_from_pokemon(pkmn)
          pbPokemonIconFile(pkmn)
        end
      end
    end
  end
end

EventHandlers.add(:on_enter_map, :selection_set, 
proc{

  }
)

EventHandlers.add(:on_leave_map, :selection_save,
  proc {
  
  }
)




def getCurrentItemOrder(update_index=false)
	 
	
	if $PokemonGlobal.alt_control_move==true
	 $PokemonGlobal.stored_ball_order = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index] if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon) || $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index] == :MULTISELECT
      itms = ["Follow","Search (E)","Search (I)","Recall","Wander","Wait"]
	   
	  $PokemonGlobal.ball_order = itms.reverse
	  if update_index==true
	   $PokemonGlobal.ball_hud_index=0
     end
	 return 
	end
	if $PokemonGlobal.ball_hud_type==:PKMN
	 $PokemonGlobal.stored_ball_order = nil
	 if $player.party.length < 1
	  $PokemonGlobal.ball_hud_type=:ITEM 
	 else
      potentional=$player.party.find_all { |p| p && !p.dead? && !p.fainted? }
	  if potentional.length==0
	  $PokemonGlobal.ball_hud_type=:ITEM 
	  elsif $PokemonGlobal.selected_pokemon.length>1
	   potentional << :MULTISELECT
	  $PokemonGlobal.ball_order = potentional
	  else
	  $PokemonGlobal.ball_order = potentional
	  end
	  if update_index==true
	   $PokemonGlobal.ball_hud_pkmn_index=0 if $player.party.length < $PokemonGlobal.ball_hud_pkmn_index
	   $PokemonGlobal.ball_hud_index=$PokemonGlobal.ball_hud_pkmn_index
     end
	 end
	end
	
	
	
	
	
   if $PokemonGlobal.ball_hud_type==:ITEM 
	 $PokemonGlobal.stored_ball_order = nil
	if $game_map.metadata&.base_map
     basicitems=$bag.isPlacableinInventory
	 $PokemonGlobal.ball_hud_item_type=:PLACE
	 $PokemonGlobal.ball_hud_item_type_old=$PokemonGlobal.ball_hud_item_type if $PokemonGlobal.ball_hud_place_index!=$PokemonGlobal.ball_hud_item_type
	 if update_index==true
	 $PokemonGlobal.ball_hud_place_index=0 if basicitems.length < $PokemonGlobal.ball_hud_place_index
	 $PokemonGlobal.ball_hud_index=$PokemonGlobal.ball_hud_place_index
	 end
	else
     basicitems=$bag.isToolinInventory
	 $PokemonGlobal.ball_hud_item_type=:TOOL
	 $PokemonGlobal.ball_hud_item_type_old=$PokemonGlobal.ball_hud_item_type if $PokemonGlobal.ball_hud_item_type_old!=$PokemonGlobal.ball_hud_item_type
	 if update_index==true
	 $PokemonGlobal.ball_hud_item_index=0 if basicitems.length < $PokemonGlobal.ball_hud_item_index
	 $PokemonGlobal.ball_hud_index=$PokemonGlobal.ball_hud_item_index
	 end
	end
    if basicitems.length < 1
	 $PokemonGlobal.ball_hud_type=:PKMN
	 return 
	end 
     item = ItemData.new(:NOTEBOOK)
	  basicitems.unshift(item)
    $PokemonGlobal.ball_order=basicitems
	 return
   end



end



class PokemonGlobalMetadata
  attr_writer :ball_hud_enabled #$PokemonGlobal.ball_hud_enabled = true
  attr_writer :ball_hud_index
  attr_writer :stored_ball_order
  attr_writer :ball_hud_type
  attr_writer :ball_hud_item_type
  attr_writer :ball_hud_item_type_old
  attr_writer :ball_hud_pkmn_index
  attr_writer :ball_hud_item_index
  attr_writer :ball_hud_place_index
  attr_writer :ball_hud_pkmn_index_old
  attr_writer :ball_hud_item_index_old
  attr_writer :selected_pokemon
  attr_writer :set_extended_hud
  attr_writer :alt_control_move
  attr_writer :hud_storage_for_alt
  attr_writer :junk_ass_multiselect_counter
  attr_writer :display_moves

  def ball_hud_enabled
    @ball_hud_enabled = false if !@ball_hud_enabled
    return @ball_hud_enabled
  end
  def stored_ball_order
    @stored_ball_order = nil if !@stored_ball_order
    return @stored_ball_order
  end

  def junk_ass_multiselect_counter
    @junk_ass_multiselect_counter = 0 if @junk_ass_multiselect_counter.nil?
    return @junk_ass_multiselect_counter
  end
  def alt_control_move
    @alt_control_move = false if !@alt_control_move
    return @alt_control_move
  end
  def display_moves
    @display_moves = false if !@display_moves
    return @display_moves
  end


  def hud_storage_for_alt
    @hud_storage_for_alt = :PKMN if !@hud_storage_for_alt
    return @hud_storage_for_alt
  end

  def set_extended_hud
    @set_extended_hud = false if @set_extended_hud.nil?
    return @set_extended_hud
  end

  def ball_hud_index
    @ball_hud_index = 0 if @ball_hud_index.nil?
    return @ball_hud_index
  end


  def selected_pokemon
    @selected_pokemon = [0] if @selected_pokemon.nil?
    return @selected_pokemon
  end

def get_selected_pokemon_length
  length = @selected_pokemon.length
  length -= 1 if @selected_pokemon[0]==0
  return length
end
def get_single_selected_pokemon
  postarity = @selected_pokemon.dup
  postarity.delete(0) if postarity[0]==0
  return nil if postarity.length>1
  return postarity[0]
end

  def ball_hud_type
    return @ball_hud_type || :PKMN
  end




  def ball_hud_item_type
    return @ball_hud_item_type || :PKMN
  end
  def ball_hud_item_type_old
    return @ball_hud_item_type_old || :PKMN
  end
  
  def ball_hud_item_type_toggle
    if @ball_hud_item_type==:PLACE
	  @ball_hud_item_type=:TOOL
	 else
	  @ball_hud_item_type=:PLACE
	 end
  end
  
  def ball_hud_type_toggle
    if @ball_hud_type==:PKMN
	  @ball_hud_type=:ITEM
	 else
	  @ball_hud_type=:PKMN
	 end
  end

  def ball_hud_pkmn_index
    return @ball_hud_pkmn_index || 0
  end

  def ball_hud_item_index
    return @ball_hud_item_index || 0
  end
  def ball_hud_place_index
    return @ball_hud_place_index || 0
  end

  def ball_hud_pkmn_index_old
    return @ball_hud_pkmn_index_old || 0
  end

  def ball_hud_item_index_old
    return @ball_hud_item_index_old || 0
  end
end


