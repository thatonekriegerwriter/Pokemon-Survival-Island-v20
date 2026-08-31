class Game_Temp
  attr_accessor :signposting

  def signposting
    @signposting = false if @signposting.nil?
    return @signposting
  end
end

if defined?(PluginManager) && !PluginManager.installed?("Simple HUD")
  PluginManager.register({                                                 
    :name    => "Simple HUD",                                        
    :version => "3.0",                                                     
    :link    => "https://www.pokecommunity.com/showthread.php?t=390640",             
    :credits => "FL"
  })
end


class HUD
  attr_accessor :visible
  attr_reader :show
  if true
  # Lower this number = more lag.
  FRAMES_PER_UPDATE = 1
  HP_BAR_GREEN    = [Color.new(24,192,32),Color.new(0,144,0)]
  HP_BAR_YELLOW   = [Color.new(250,250,51),Color.new(184,112,0)]
  HP_BAR_RED      = [Color.new(240,80,32),Color.new(168,48,56)]
  
  @@lastGlobalRefreshFrame = -1
  @@instanceArray = []
  @@tonePerStatus = nil

  attr_reader :lastRefreshFrame
  def initialize(viewport1)
    @visible = false
    @viewport1 = viewport1
    @sprites = {}
	@pokemon_charge_bars={}
    @show = true if @show.nil?
	@subhuds = {
	:status => PlayerStatusHUD.new(@viewport1),
	:menu => OverworldMenu.new(@viewport1),
	:lock_on => LockOnScreen.new(@viewport1),
	:controlling => ControllingPokemonScreen.new(@viewport1),
	#:minimap => MinimapHUD.new(@viewport1)
	}
	#@bar_image = RPG::Cache.picture("Hud/overlay_hp")
	#@bar_image2 = RPG::Cache.picture("Hud/overlay_hp2")
    @@instanceArray.compact! 
    @@instanceArray.push(self)
  end

  def create
    createSprites
    for sprite in @sprites.values
      sprite.z+=600
    end
	@subhuds.values.each(&:create)
    refresh
  end

  def createSprites
   # createHPBar(55+$PokemonSystem.screenposx , @yposition+30, 90, 8)
   # createSTABar(65+$PokemonSystem.screenposx , @yposition+50, 90, 8)
    #createSTABar(120+$PokemonSystem.screenposx , @yposition+45, 70, 11)
    #createHPBar(40+$PokemonSystem.screenposx , @yposition+45, 70, 11)
   # createBox(440+$PokemonSystem.screenposx , @yposition+45, 70, 11)
	#createSelection(440+$PokemonSystem.screenposx , @yposition+45, 70, 11)
	#createHPLevel(80, 10)
  end

  def refresh
  #  refreshSTABar if $PokemonGlobal.bars_visible==true
  #  refreshHPBar if $PokemonGlobal.bars_visible==true
  # refreshHPLevel(80+$PokemonSystem.screenposx , 10)
	# refreshSelection
	#refreshBox(440+$PokemonSystem.screenposx , @yposition+45) if $PokemonGlobal.ball_hud_enabled==true
	#refreshChargeBars
	@subhuds.values.each(&:refresh)
  end


  def hideSelectionHUD
    @subhuds[:controlling].hideSelectionHUD
  end
  def revealSelectionHUD
    @subhuds[:controlling].revealSelectionHUD
  end
   
  def hideHPHUD
    @subhuds[:lock_on].hideHPHUD
  end
  def revealHPHUD
    @subhuds[:lock_on].revealHPHUD
  end
  
  def revealBallHUD
    @subhuds[:menu].revealBallHUD
  end
  def hideBallHUD
    @subhuds[:menu].hideBallHUD
  end

  def revealMainHUD
    @subhuds[:status].revealMainHUD
  end
  def hideMainHUD
    @subhuds[:status].hideMainHUD
  end

  def revealMinimap
    #@subhuds[:minimap].revealMinimap
  end
  def hideMinimap
    #@subhuds[:minimap].hideMinimap
  end


  def showHUD?
   @show = true if @show.nil?
    ret = (
      $player && !$game_temp.in_menu && @show == true &&($game_map.map_id != 1 && $game_map.map_id != 25)
    )
	 return ret
  end
  
  def hideHUD
  @show = false
  end
  
  def showHUD
    @show = true
  end

  def tryUpdate(force=false)
    if showHUD?
      update(force) if @lastRefreshFrame != Graphics.frame_count
    else
      dispose if hasSprites?
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
    if $PokemonGlobal.ball_hud_enabled && !$game_temp.in_menu && !$game_temp.message_window_showing && $hud.show && !$game_temp.signposting
        revealBallHUD
        getCurrentItemOrder
    else
        hideBallHUD
        getCurrentItemOrder
    end
    if $PokemonGlobal.bars_visible && !$game_temp.in_menu && !$game_temp.message_window_showing==true && @show && !$game_temp.signposting 
	  if $game_temp.in_inventory==false 
        revealMainHUD
	  else
        hideMainHUD
	  end 
    else
        hideMainHUD
    end
    if $game_map && $game_map.metadata && $game_map.metadata&.outdoor_map && !$game_temp.in_menu && !$game_temp.message_window_showing==true && @show && !$game_temp.signposting
        revealMinimap
    else
        hideMinimap
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
    
	@subhuds.values.each(&:update)
    pbUpdateSpriteHash(@sprites)
    pbUpdateSpriteHash(@pokemon_charge_bars)
    @lastRefreshFrame = Graphics.frame_count
    self.class.tryUpdateAll if self.class.shouldUpdateAll?
  else 
   @visible = false
	end
  end

  def dispose
	@subhuds.values.each(&:dispose)
    pbDisposeSpriteHash(@sprites)
    pbUpdateSpriteHash(@pokemon_charge_bars)
  end

  def hasSprites?
    return !@sprites.empty? || @subhuds.values.any?(&:hasSprites?)
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


end
class MinimapHUD
  MINIMAP_WIDTH  = 160
  MINIMAP_HEIGHT = 107

  def initialize(viewport)
    @viewport = viewport
    @sprites = {}
  end

  def create
    createSprites
    refresh
  end

  def createSprites
    @sprites["map"] = BitmapSprite.new(
      MINIMAP_WIDTH,
      MINIMAP_HEIGHT,
      @viewport
    )

    @sprites["discovery"] = BitmapSprite.new(
      MINIMAP_WIDTH,
      MINIMAP_HEIGHT,
      @viewport
    )
    @sprites["center"] = BitmapSprite.new(
      MINIMAP_WIDTH,
      MINIMAP_HEIGHT,
      @viewport
    )
    @sprites["map"].x = 10
    @sprites["map"].y = 10
    @sprites["discovery"].x = @sprites["map"].x
    @sprites["discovery"].y = @sprites["map"].y

    @sprites["map"].z = 600
    @sprites["discovery"].z = 601

    @sprites["map"].bitmap.stretch_blt(
      Rect.new(0, 0, MINIMAP_WIDTH, MINIMAP_HEIGHT),
      Bitmap.new("Graphics/Pictures/Maps/mapRegion3.png"),
      Rect.new(0, 0, 480, 320)
    )
	@sprites["center"].x = @sprites["map"].x
@sprites["center"].y = @sprites["map"].y
@sprites["center"].z = 602

@sprites["center"].bitmap.fill_rect(
  MINIMAP_WIDTH / 2,
  0,
  1,
  MINIMAP_HEIGHT,
  Color.new(255, 0, 0, 150)
)

@sprites["center"].bitmap.fill_rect(
  0,
  MINIMAP_HEIGHT / 2,
  MINIMAP_WIDTH,
  1,
  Color.new(255, 0, 0, 150)
)
  end

  def refresh
    return if !$game_map
    return if !$game_map.metadata

    refresh_map
    refresh_discovery
  end

  def refresh_map
    position = WorldMapDiscovery.player_world_position
    return if !position

    world_x, world_y = position

    source_x = world_x - (MINIMAP_WIDTH / 2)
    source_y = world_y - (MINIMAP_HEIGHT / 2)

    source_x = 0 if source_x < 0
    source_y = 0 if source_y < 0

    source_x = 480 - MINIMAP_WIDTH if source_x + MINIMAP_WIDTH > 480
    source_y = 320 - MINIMAP_HEIGHT if source_y + MINIMAP_HEIGHT > 320

    bitmap = Bitmap.new("Graphics/Pictures/Maps/mapRegion3.png")

    @sprites["map"].bitmap.clear

    @sprites["map"].bitmap.blt(
      0,
      0,
      bitmap,
      Rect.new(
        source_x,
        source_y,
        MINIMAP_WIDTH,
        MINIMAP_HEIGHT
      )
    )

    bitmap.dispose
  end

  def refresh_discovery
    position = WorldMapDiscovery.player_world_position
    return if !position

    world_x, world_y = position

    source_x = world_x - (MINIMAP_WIDTH / 2)
    source_y = world_y - (MINIMAP_HEIGHT / 2)

    source_x = 0 if source_x < 0
    source_y = 0 if source_y < 0

    source_x = 480 - MINIMAP_WIDTH if source_x + MINIMAP_WIDTH > 480
    source_y = 320 - MINIMAP_HEIGHT if source_y + MINIMAP_HEIGHT > 320

    full_mask = Bitmap.new(480, 320)
    WorldMapDiscovery.create_mask(full_mask)

    @sprites["discovery"].bitmap.clear

    @sprites["discovery"].bitmap.blt(
      0,
      0,
      full_mask,
      Rect.new(
        source_x,
        source_y,
        MINIMAP_WIDTH,
        MINIMAP_HEIGHT
      )
    )

    full_mask.dispose
  end

  def refresh_player
    return
  end
  
  def revealMinimap
  @sprites.each_key do |key|
	 sprite = @sprites[key]
     next if sprite.visible
    sprite.visible=true
  
  end 
  end
  
  def hideMinimap
  @sprites.each_key do |key|
    @sprites[key].visible=false
  end
  end
  
  def update
    return if !$game_map

    refresh
  end

  def dispose
    pbDisposeSpriteHash(@sprites)
  end

  def hasSprites?
    return !@sprites.empty?
  end
end