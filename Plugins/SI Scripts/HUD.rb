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

class HUD
  # If you wish to use a background picture, put the image path below, like
  # BG_PATH="Graphics/Pictures/battleMessage". I recommend a 512x64 picture.
  # If there is no image, a blue background will be draw.
  BG_PATH=""

  # Make as 'false' to don't show the blue bar
  USE_BAR=false

  # Make as 'true' to draw the HUD at bottom
  DRAW_AT_BOTTOM=true

  # Make as 'true' to only show HUD in the pause menu
  DRAW_ONLY_IN_MENU=false


  # When above 0, only displays HUD when this switch is on.
  SWITCH_NUMBER = -1

  # Lower this number = more lag.
  FRAMES_PER_UPDATE = 30

  # The size of drawable content.
  BAR_HEIGHT = 64
  

  HP_BAR_GREEN    = [Color.new(24,192,32),Color.new(0,144,0)]
  HP_BAR_YELLOW   = [Color.new(248,184,0),Color.new(184,112,0)]
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
    @viewport1 = viewport1
    @sprites = {}
    @yposition = DRAW_AT_BOTTOM ? Graphics.height-64 : 0
    @@instanceArray.compact! 
    @@instanceArray.push(self)
  end

  def showHUD?
    return (
      $player && !$game_temp.in_menu
    )
  end

  def create
    createSprites
    for sprite in @sprites.values
      sprite.z+=600
    end
    refresh
  end

  def createSprites
    createSTABar(1, 470, @yposition+45, 70, 11)
    createHPBar(2, 40, @yposition+45, 70, 11)
  end

  def createSTABar(i, x, y, width, height)
    fillWidth = width-4
    fillHeight = height-4
    @sprites["hpbarborder#{i}"] = BitmapSprite.new(width,height,@viewport1)
    @sprites["hpbarborder#{i}"].x = x-width/2
    @sprites["hpbarborder#{i}"].y = y-height/2
    @sprites["hpbarborder#{i}"].bitmap.fill_rect(
      Rect.new(0,0,width,height), Color.new(32,32,32)
    )
    @sprites["hpbarborder#{i}"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )
    @sprites["hpbarborder#{i}"].visible = false
    @sprites["hpbarfill#{i}"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @sprites["hpbarfill#{i}"].x = x-fillWidth/2
    @sprites["hpbarfill#{i}"].y = y-fillHeight/2
  end
  
  def createHPBar(i, x, y, width, height)
    fillWidth = width-4
    fillHeight = height-4
    @sprites["hpbarborder#{i}"] = BitmapSprite.new(width,height,@viewport1)
    @sprites["hpbarborder#{i}"].x = x-width/2
    @sprites["hpbarborder#{i}"].y = y-height/2
    @sprites["hpbarborder#{i}"].bitmap.fill_rect(
      Rect.new(0,0,width,height), Color.new(32,32,32)
    )
    @sprites["hpbarborder#{i}"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )
    @sprites["hpbarborder#{i}"].visible = false
    @sprites["hpbarfill#{i}"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @sprites["hpbarfill#{i}"].x = x-fillWidth/2
    @sprites["hpbarfill#{i}"].y = y-fillHeight/2
  end

  def createOverlay
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,BAR_HEIGHT,@viewport1)
    @sprites["overlay"].y = @yposition
    pbSetSystemFont(@sprites["overlay"].bitmap)
  end
  
  def refresh
    refreshSTABar(1, 470, @yposition+45, 70, 11)
    refreshHPBar(2, 30, @yposition+45, 70, 11)
  end


  def refreshSTABar(i, x, y, width, height)
    fillWidth = width-4
    fillHeight = height-4
    @sprites["hpbarborder#{i}"].visible = $player.playerstamina!=nil
    @sprites["hpbarfill#{i}"].visible = @sprites["hpbarborder#{i}"].visible
    @sprites["hpbarfill#{i}"].bitmap.clear
    fillAmount = ($player.playerstamina==0 || $player.playermaxstamina==0) ? 0 : (
      $player.playerstamina*@sprites["hpbarfill#{i}"].bitmap.width/$player.playermaxstamina
    )
    # Always show a bit of HP when alive
    return if fillAmount <= 0
    hpColors = Color.new(255,182,66)
    shadowHeight = 2
    @sprites["hpbarfill#{i}"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors
    )
    @sprites["hpbarfill#{i}"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["hpbarfill#{i}"].bitmap.height-shadowHeight
      ), hpColors
    )
  end


  def refreshHPBar(i, x, y, width, height)
    fillWidth = width-4
    fillHeight = height-4
    @sprites["hpbarborder#{i}"].visible = $player.playerhealth!=nil
    @sprites["hpbarfill#{i}"].visible = @sprites["hpbarborder#{i}"].visible
    @sprites["hpbarfill#{i}"].bitmap.clear
    fillAmount = ($player.playerhealth==0 || 100==0) ? 0 : (
      $player.playerhealth*@sprites["hpbarfill#{i}"].bitmap.width/100
    )
    # Always show a bit of HP when alive
    return if fillAmount <= 0
    hpColors = hpBarCurrentColors($player.playerhealth, 100)
    shadowHeight = 2
    @sprites["hpbarfill#{i}"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors[1]
    )
    @sprites["hpbarfill#{i}"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["hpbarfill#{i}"].bitmap.height-shadowHeight
      ), hpColors[0]
    )
  end


  def hpBarCurrentColors(hp, totalhp)
    if hp<=(totalhp/4.0)
      return HP_BAR_RED
    elsif hp<=(totalhp/2.0)
      return HP_BAR_YELLOW
    end
    return HP_BAR_GREEN
  end

  def refreshOverlay
    newText = textsDefined
    return if newText == @currentTextArray
    @currentTextArray = newText
    @sprites["overlay"].bitmap.clear
    x = Graphics.width-64
    textpos=[
      [@currentTextArray[0],x,6,2,TEXT_COLORS[0],TEXT_COLORS[1]],
      [@currentTextArray[1],x,38,2,TEXT_COLORS[0],TEXT_COLORS[1]]
    ]
    pbDrawTextPositions(@sprites["overlay"].bitmap,textpos)
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

class Spriteset_Map
  alias :initializeOldFL :initialize
  alias :disposeOldFL :dispose
  alias :updateOldFL :update

  def initialize(map=nil)
    $player = $Trainer if !$player # For compatibility with v20 and older
    initializeOldFL(map)
  end

  def dispose
    @hud.dispose if @hud
    disposeOldFL
  end

  def update
    updateOldFL
    @hud = HUD.new(@viewport1) if !@hud
    @hud.tryUpdate
  end
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