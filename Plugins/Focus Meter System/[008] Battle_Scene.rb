#===============================================================================
# Additions to Battle::Scene.
#===============================================================================
class Battle::Scene
  alias focus_pbInitSprites pbInitSprites
  def pbInitSprites
    focus_pbInitSprites
    #---------------------------------------------------------------------------
    # Initializes the Focus panel.
    #---------------------------------------------------------------------------
    total  = 0
    @focusToggle = false
    @sprites["panel"] = IconSprite.new(0, 0, @viewport)
    @sprites["panel"].setBitmap("Graphics/Plugins/Focus Meter/focus_panel")
    @sprites["panel"].visible = @focusToggle
    panel_width = @sprites["panel"].bitmap.width
    @sprites["panel"].z = 200
    @sprites["panel"].x = Graphics.width - panel_width
    @sprites["focus"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["focus"].z = 201
    @sprites["focus"].visible = @focusToggle
    pbSetSmallFont(@sprites["focus"].bitmap)
    @focusOverlay = @sprites["focus"].bitmap
    @meterbitmap = AnimatedBitmap.new(_INTL("Graphics/Plugins/Focus Meter/panel_meter"))
    @focusbitmap = AnimatedBitmap.new(_INTL("Graphics/Plugins/Focus Meter/panel_bar"))
    @battle.battlers.each_with_index do |b, i|
      total += 1
      next if !b
      @sprites["pokeicon#{i}"] = PokemonIconSprite.new(b.pokemon, @viewport)
      @sprites["pokeicon#{i}"].visible = @focusToggle
      @sprites["pokeicon#{i}"].setOffset(PictureOrigin::CENTER)
      @sprites["pokeicon#{i}"].x = Graphics.width - 100
      @sprites["pokeicon#{i}"].y = 34 + (i * 32)
      @sprites["pokeicon#{i}"].z = 202
      @sprites["pokeicon#{i}"].zoom_x = 0.5
      @sprites["pokeicon#{i}"].zoom_y = 0.5
    end
    @sprites["panel"].src_rect.set(0, 0, panel_width, 19 + (total * 32))
  end
  
  def pbUpdateFocusPanel
    textPos = []
    xpos    = Graphics.width - 10
    ypos    = 58
    @focusOverlay.clear
    @battle.battlers.each_with_index do |b, i|
      next if !b
      base   = (b.opposes?) ? Color.new(232, 232, 232) : Color.new(72, 72, 72)
      shadow = (b.opposes?) ? Color.new(72, 72, 72)    : Color.new(184, 184, 184)
      # Removes fainted Pokemon from the panel.
      @sprites["pokeicon#{i}"].visible = false if b.fainted?
      next if b.fainted?
      if !Settings::SHOW_FOE_FOCUS_METER && b.opposes?
        # Displays focus as "????" on foes if setting is off.
        textPos.push([_INTL("????"), xpos - 32, (ypos / 2) + (i * 32), 2, base, shadow])
      else
        case Settings::FOCUS_PANEL_DISPLAY
        when 1 # Displays focus as a mini meter.
          w = @focusbitmap.width.to_f * b.focus_meter / Settings::FOCUS_METER_SIZE
          w = 1 if w < 1
          w = ((w / 2.0).round) * 2
          @focusOverlay.blt(xpos - 73, 32 + (i * 32), @meterbitmap.bitmap, Rect.new(0, 0, 78, 9))
          @focusOverlay.blt(xpos - 73, 32 + (i * 32), @focusbitmap.bitmap, Rect.new(0, 0, w, 9))
        when 2 # Displays focus as a percentage.
          percent = ((b.focus_meter.to_f / Settings::FOCUS_METER_SIZE.to_f) * 100.0).round
          textPos.push([_INTL("#{percent}%"), xpos - 30, (ypos / 2) + (i * 32), 2, base, shadow])
        when 3 # Displays current focus out of total focus.
          meter = sprintf("%d/%d", b.focus_meter, Settings::FOCUS_METER_SIZE)
          textPos.push([meter, xpos, (ypos / 2) + (i * 32), 1, base, shadow])
        end
      end
      @sprites["pokeicon#{i}"].pokemon = b.pokemon
    end
    pbDrawTextPositions(@focusOverlay, textPos)
  end
  
  def pbToggleFocusPanel(set = nil)
    return if Settings::FOCUS_PANEL_DISPLAY == 0
    return if $game_switches[Settings::NO_FOCUS_MECHANIC]
    @focusToggle = (set.nil?) ? !@focusToggle : set
    pbSEPlay("GUI party switch") if @focusToggle
    pbPlayCloseMenuSE if !@focusToggle && set.nil?
    @sprites["panel"].visible = @focusToggle
    @sprites["focus"].visible = @focusToggle
    @battle.battlers.each_with_index do |b, i|
      next if !b
      sprites["pokeicon#{i}"].visible = false if b.fainted?
      next if b.fainted?
      sprites["pokeicon#{i}"].visible = @focusToggle
    end
    pbUpdateFocusPanel if set.nil?
  end

  def pbFillFocusMeter(battler, startMeter, endMeter, rangeMeter)
    return if !battler || endMeter == startMeter
    dataBox = @sprites["dataBox_#{battler.index}"]
    dataBox.animateMeter(startMeter, endMeter, rangeMeter)
    while dataBox.animatingMeter
      pbUpdate
    end
  end
  
  def pbHideFocusMeter(battler)
    return if !battler
    dataBox = @sprites["dataBox_#{battler.index}"]
    dataBox.showMeter = false
    pbUpdate
  end
end

class Battle::DebugSceneNoLogging
  def pbFillFocusMeter(battler, startMeter, endMeter, rangeMeter); end
  def pbHideFocusMeter(battler); end
end

#===============================================================================
# Additions to Fight Menu.
#===============================================================================
class Battle::Scene::FightMenu < Battle::Scene::MenuBase
  attr_reader :focusMode
  
  def focusMode=(value)
    oldValue = @focusMode
    @focusMode = value
    refreshFocusButton if @focusMode != oldValue
  end
  
  def refreshFocusButton
    return if !USE_GRAPHICS
    @focusButton.src_rect.y    = (@focusMode - 1) * @focusBitmap.height / 2
    @focusButton.y             = self.y - ((@shiftMode > 0) ? @focusBitmap.height : @focusBitmap.height / 2)
    @focusButton.z             = self.z - 1
    @visibility["focusButton"] = (@focusMode > 0)
  end
end

#===============================================================================
# Additions to Databoxes.
#===============================================================================
class Battle::Scene::PokemonDataBox < SpriteWrapper
  attr_accessor :showMeter
  attr_reader   :animatingMeter
  
  alias focus_initialize initialize
  def initialize(*args)
    @showMeter      = false
    @animatingMeter = false
    @sideSize       = args[1]
    @focus_x, @focus_y = Settings::FOCUS_METER_XY
    focus_initialize(*args)
  end
  
  def focus_InitializeDatabox(bgFilename, onPlayerSide)
    path = "Graphics/Plugins/Focus Meter/Databoxes/Focus Styles/"
    # Initializes the focus bar and meter bitmaps.
    bar   = "focus"
    meter = "meter"
    if @raid_boss
      bar += "_raid"
    else
      case Settings::FOCUS_METER_STYLE
      when 2 # Thin style
        path += "Style_2/"
      when 3 # Vertical style
        path += "Style_3/"
        boxtype  = (@sideSize == 1) ? "_normal" : "_thin"
        boxtype += "_foe" if !onPlayerSide
        bar     += boxtype
        meter   += boxtype
      when 4 # Advanced style
        boxtype  = (@sideSize == 1) ? "_normal" : "_thin"
        boxtype += "_foe" if !onPlayerSide
        bar = "Style_4/" + bar + boxtype
      end
    end
    @bg_path = bgFilename + "_bg"
    @focus_meter_path = path + meter
    @focus_bar_path = path + bar
  end
  
  alias focus_initializeOtherGraphics initializeOtherGraphics
  def initializeOtherGraphics(viewport)
    if !@raid_boss
      @databoxBgBitmap = AnimatedBitmap.new(@bg_path)
      @databoxBg = Sprite.new(viewport)
      @databoxBg.bitmap = @databoxBgBitmap.bitmap
      @sprites["databoxBg"] = @databoxBg
    end
    @focusMeterBitmap = AnimatedBitmap.new(@focus_meter_path)
    @focusMeter = Sprite.new(viewport)
    @focusMeter.bitmap = @focusMeterBitmap.bitmap
    @sprites["focusMeter"] = @focusMeter
    @focusBarBitmap = AnimatedBitmap.new(@focus_bar_path)
    @focusBar = Sprite.new(viewport)
    @focusBar.bitmap = @focusBarBitmap.bitmap
    @sprites["focusBar"] = @focusBar
    focus_initializeOtherGraphics(viewport)
  end
  
  def focus_MeterSetup(onPlayerSide)
    if $game_switches[Settings::NO_FOCUS_MECHANIC]
      @showMeter = false
      return
    end
    if onPlayerSide
      case Settings::FOCUS_METER_STYLE
      when 0 then @showMeter = false
      when 1 then @showMeter = @sideSize < 3
      else        @showMeter = true
      end
    else
      if Settings::SHOW_FOE_FOCUS_METER
        case Settings::FOCUS_METER_STYLE
        when 0 then @showMeter = false
        when 1 then @showMeter = @sideSize == 1
        else        @showMeter = true
        end
        @showMeter = true if @raid_boss
      else
        @showMeter = false
      end
    end
  end
  
  def pbSetFocusBarX(value)
    @databoxBg.x = value if !@raid_boss
    if @raid_boss
      @focusMeter.x = value + 16
      @focusBar.x   = value + 16
    else
      case Settings::FOCUS_METER_STYLE
      when 1 # Simple style
        @focusMeter.x = value + @spriteBaseX + @focus_x
        @focusBar.x   = value + @spriteBaseX + (@focus_x + 6)
      when 2 # Thin style
        @focusMeter.x = value + @spriteBaseX + (@focus_x - 6)
        @focusBar.x   = value + @spriteBaseX + (@focus_x + 23)
      when 3 # Vertical style 
        if @battler.opposes?
          @focusMeter.x = value + @spriteBaseX + 216
          @focusBar.x   = value + @spriteBaseX + 222
        else
          offset = (@sideSize > 1) ? -4 : 0
          @focusMeter.x = value + @spriteBaseX - (34 + offset)
          @focusBar.x   = value + @spriteBaseX - (28 + offset)
        end
      when 4 # Advanced style
        @focusMeter.x = value
        @focusBar.x   = value
      end
    end
  end

  def pbSetFocusBarY(value)
    @databoxBg.y = value if !@raid_boss
    if @raid_boss
      @focusMeter.y = value + 30
      @focusBar.y   = value + 30
    else
      case Settings::FOCUS_METER_STYLE
      when 1 # Simple style
        @focusMeter.y = value + @focus_y
        @focusBar.y   = value + (@focus_y + 6)
      when 2 # Thin style
        @focusMeter.y = value + (@focus_y + 10)
        @focusBar.y   = value + (@focus_y + + 12)
      when 3 # Vertical style
        @focusMeter.y = value
        @focusBar.y   = value + 8
      when 4 # Advanced styles
        @focusMeter.y = value
        @focusBar.y   = value
      end
    end
  end
  
  alias focus_dispose dispose
  def dispose
    @databoxBgBitmap.dispose if !@raid_boss
    @focusBarBitmap.dispose
    @focusMeterBitmap.dispose
    focus_dispose
  end

  def z=(value)
    super
    @databoxBg.z  = value - 1 if !@raid_boss
    @hpBar.z      = value + 1
    @expBar.z     = value + 1
    @hpNumbers.z  = value + 2
    @focusMeter.z = value + 1
    @focusBar.z   = value - 1
    case Settings::FOCUS_METER_STYLE
    when 4 then @focusBar.z = value - 1
    else @focusBar.z = value + 1
    end
    @focusBar.z = value + 1 if @raid_boss
  end
  
  def visible=(value)
    super
    @sprites.each do |i|
      i[1].visible = value if !i[1].disposed?
    end
    @expBar.visible = (value && @showExp)
    @focusMeter.visible = (value && @showMeter && !@raid_boss && Settings::FOCUS_METER_STYLE < 4)
    @focusBar.visible = (value && @showMeter)
  end
  
  def showMeter=(value)
    @focusMeter.visible = value
    @focusBar.visible = value
  end
  
  def meter
    return (@animatingMeter) ? @currentMeter : @battler.focus_meter
  end
  
  def refreshMeter
    return if !@showMeter || !@battler
    rect = 0
    if self.meter > 0
      bar  = (Settings::FOCUS_METER_STYLE == 3) ? @focusBarBitmap.height.to_f : @focusBarBitmap.width.to_f
      rect = bar * self.meter / Settings::FOCUS_METER_SIZE
      rect = 1 if rect < 1
      rect = ((rect / 2.0).round) * 2
    end
    if Settings::FOCUS_METER_STYLE == 3
      @focusBar.src_rect.height = rect
    else
      @focusBar.src_rect.width = rect
    end
  end

  def animateMeter(oldMeter, newMeter, rangeMeter)
    @currentMeter     = oldMeter
    @endMeter         = newMeter
    @rangeMeter       = rangeMeter
    @meterIncPerFrame = (newMeter - oldMeter).abs / (Settings::FOCUS_FILL_TIME * Graphics.frame_rate)
    minInc = (rangeMeter * 4) / (@focusBarBitmap.width * Settings::FOCUS_FILL_TIME * Graphics.frame_rate)
    @meterIncPerFrame = minInc if @meterIncPerFrame < minInc
    @animatingMeter   = true
  end
  
  def updateMeterAnimation
    return if !@animatingMeter
    if @endMeter > Settings::FOCUS_METER_SIZE
      @endMeter = Settings::FOCUS_METER_SIZE
    end
    if !@showMeter
      @currentMeter = @endMeter
      @animatingMeter = false
      return
    end
    if @currentMeter < @endMeter
      @currentMeter += @meterIncPerFrame
      @currentMeter = @endMeter if @currentMeter >= @endMeter
    elsif @currentMeter > @endMeter
      @currentMeter -= @meterIncPerFrame
      @currentMeter = @endMeter if @currentMeter <= @endMeter
    end
    refreshMeter
    @animatingMeter = false if @currentMeter == @endMeter
  end
  
  alias focus_update update
  def update(frameCounter = 0)
    updateMeterAnimation
    focus_update(frameCounter)
  end
end