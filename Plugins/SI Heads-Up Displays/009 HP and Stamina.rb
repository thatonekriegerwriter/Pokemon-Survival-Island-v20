class PlayerStatusHUD
  BG_PATH="Graphics/Pictures/Hud/Bolt"
  BG_PATH2="Graphics/Pictures/Hud/Heart"
  DIRECTION = { 2 => "Down", 4 => "Left", 6 => "Right", 8 => "Up" }
  def initialize(viewport)
    @viewport = viewport 
    @y_position = Graphics.height-64 + $PokemonSystem.screenposy + 30
    @x_position = 55 + $PokemonSystem.screenposx
	@sprites = {}
	$PlayerStatusHUD = self 
  end 
  def create
    createSprites
    for sprite in @sprites.values
      sprite.z+=600
    end
    refresh
  end 
  def createSprites
    
    createHPBar(@x_position , @y_position, 90, 8)
    createSTABar(@x_position + 10 , @y_position + 20, 90, 8)
	create_location_display
  end 
  def create_location_display
    create_text_backdrop("location_backdrop", 4, 4, 9, 260, 160)
    backdrop_sprite = @sprites["location_backdrop"]
    @sprites["location_text"] = Window_UnformattedTextPokemon.new("")
    text_sprite = @sprites["location_text"]
    text_sprite.contents.font.size = 14
    text_sprite.refresh
    pbPrepareWindow(text_sprite)
    text_sprite.resizeToFit("")
    text_sprite.x = -2
    text_sprite.y = -2
    text_sprite.windowskin = nil
    text_sprite.baseColor = Color.new(255, 255, 255)
    text_sprite.shadowColor = nil
    text_sprite.viewport = @viewport
    text_sprite.z = 10
	backdrop_sprite.visible = false
    text_sprite.visible = false
  end
  def revealMainHUD
  @sprites.each_key do |key|
    next if key == "location_backdrop"
    next if key == "location_text"
    @sprites[key].visible=true
  end
  end
  def hideMainHUD
  @sprites.each_key do |key|
    next if key == "location_backdrop"
    next if key == "location_text"
    @sprites[key].visible=false
  end
  end
  
  def should_display?
    return false unless $hud
    return  $PokemonGlobal.bars_visible &&
    !$game_temp.in_menu &&
    !$game_temp.message_window_showing &&
    $hud.show && !$game_temp.signposting
  end 
  
  def refresh
    return unless hasSprites?
    return unless should_display?
    refreshSTABar
    refreshHPBar
    refresh_location_display
  end
  def refresh_location_display
  text_sprite = @sprites["location_text"]
   return unless text_sprite.visible
    pbFillUpdaterConfig if (GameVersion::POKE_UPDATER_CONFIG).empty?
  version = GameVersion::POKE_UPDATER_CONFIG['CURRENT_GAME_VERSION']
  version = "DEVELOPMENT" if version == "999999999.9999.9999.9999.999.9999.999" && version
  version = Settings::GAME_VERSION if version.nil?
  height = $game_player.height_level || 0
  map_metadata = GameData::MapMetadata.try_get($game_map.map_id)
  tiles = *get_tile_with_direction
  zone = pbCurrentZone
  zone = "Base" if map_metadata.associated_base && !zone
  zone = "Dungeon" if map_metadata.random_dungeon && !zone
  zone = "Interior" if !map_metadata.outdoor_map && !zone
  zone = "Unknown" if !zone
  direction = DIRECTION[$game_player.direction] || "N/A"
  text = ""
  text << "Version: SI-#{version}\n"
  text << "#{Graphics.fps.round(1)} fps\n"
  text << "Map (Zone): #{$game_map.map_id} - #{$game_map.name} (#{zone})\n"
  text << "XYZ: #{$game_player.x.to_f} / #{$game_player.y.to_f} / #{height.to_f}\n"
  text << "Facing: #{direction}\n"
  text << "Difficulty: #{$PokemonSystem.difficulty+1}\n"
  text << "Hovering: Map #{tiles[3].map_id} - #{tiles[0].to_f} / #{tiles[1].to_f} / 0.0\n"
  event_id = tiles[3].check_event(tiles[0], tiles[1])
  ename = "None"
  if event_id 
   event = tiles[3].events[event_id]
   ename = event.name if event 
   ename = event.pokemon.name if event && event.is_a?(Game_PokeEvent) || event.is_a?(Game_PokeEventA)
   ename = event.station_name if event && event.is_a?(Game_OVEvent)
   ename = event.type.berry.name if event && event.is_a?(Game_OVEvent) && event.type && event.type.is_a?(BerryPlantData) && event.type.berry
   ename = event.data.name if event && event.is_a?(Game_TempEvent) && event.data && event.data.is_a?(Pokemon::Move)
  end 
  text << "Hover Event: #{ename}"

  text_sprite.text = text
  text_sprite.resizeToFit(text)
  end
  def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
  end
  
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
	["FOD","H20","SLP"].each_with_index do |text, index|
	   new_x = (x-width/2) + 24*index
	   new_y = y - 8 
	   
	   
	   
	   create_text2(text,1,new_x+1,new_y+1)
	   create_text(text,new_x,new_y)
	   create_text_backdrop("#{text}_backdrop",0,y - 24, 0, width+28, 80) if index==0
	end 
  end


  def create_text_backdrop(key, x, y, z, width, height,color = Color.new(0, 0, 0, 160))
  sprite = BitmapSprite.new(width, height, @viewport)
  sprite.x = x
  sprite.y = y
  sprite.z = z
  sprite.bitmap.fill_rect(0, 0, width, height, color)

  @sprites[key] = sprite
end

  def create_text(text,x,y)
    @sprites["#{text}_text"]=Window_UnformattedTextPokemon.new(text)
    text_sprite = @sprites["#{text}_text"]
	text_sprite.contents.font.size = 14 
	text_sprite.refresh
    pbPrepareWindow(text_sprite)
    text_sprite.resizeToFit(text)
	text_sprite.x = x
	text_sprite.y= y - 16 - text_sprite.contents.font.size
    text_sprite.windowskin=nil
    text_sprite.baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    text_sprite.shadowColor=nil
    text_sprite.text=text
    text_sprite.viewport=@viewport
    text_sprite.z = 10
    text_sprite.visible=true
  end

  def create_text2(text,index,x,y)
    @sprites["#{text}_#{index}_text"]=Window_UnformattedTextPokemon.new(text)
    text_sprite = @sprites["#{text}_#{index}_text"]
	text_sprite.contents.font.size = 14 
	text_sprite.refresh
    pbPrepareWindow(text_sprite)
    text_sprite.resizeToFit(text)
	text_sprite.x = x
	text_sprite.y= y - 16 - text_sprite.contents.font.size
    text_sprite.windowskin=nil
    text_sprite.baseColor=MessageConfig::DARK_TEXT_MAIN_COLOR
    text_sprite.shadowColor=nil
    text_sprite.text=text
    text_sprite.viewport=@viewport
    text_sprite.z = 10
    text_sprite.visible=true
  end


  def refreshSTABar
    #return if @sprites["starbarborder"].nil?
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
    #createSprites if @sprites["hpbarborder"].nil?
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

	[["H20",$player.playerwater,$player.playermaxwater],["FOD",$player.playerfood,$player.playermaxfood],["SLP",$player.playersleep,$player.playermaxsleep]].each_with_index do |stat, index|
	  text = stat[0]
	  cur = stat[1]
	  max = stat[2]
	  if ["H20","FOD"].include?(text)
	   color = $player.playersaturation>0 ? CurrentColorsAlt(cur, max) : CurrentColors(cur, max)
	  else
	   color = CurrentColors(cur, max)
	  end 
	   @sprites["#{text}_text"].baseColor = color
	end 
  end


  def hpBarCurrentColors(hp, totalhp)
    if hp<=(totalhp/4.0)
      return HUD::HP_BAR_RED
    elsif hp<=(totalhp/2.0)
      return HUD::HP_BAR_YELLOW
    end
    return HUD::HP_BAR_GREEN
  end
  def CurrentColors(value, maxvalue)
    quarter = maxvalue / 4.0
    half = maxvalue / 2.0
    if value < 1
      return Color.new(139,0,0)
    elsif value < quarter
      return Color.new(255,55,55)
    elsif value < half
      return Color.new(255,125,55)
    elsif value < half + quarter
      return Color.new(255,255,55)
    end
    return Color.new(55,255,55)
  end
  def CurrentColorsAlt(hp, totalhp)
      return Color.new(152,208,248)
  end


  def update
  if $DEBUG && Input.triggerex?(:F3)
    visible = !@sprites["location_text"].visible
    @sprites["location_text"].visible = visible
    @sprites["location_backdrop"].visible = visible
  end
    pbUpdateSpriteHash(@sprites)
  end 
  
  def dispose
    pbDisposeSpriteHash(@sprites)
  end
  
  def hasSprites?
    return !@sprites.empty?
  end

end 