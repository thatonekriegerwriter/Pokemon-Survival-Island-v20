#-------------------------------------------------------------------------------
# Safari Hud component
#-------------------------------------------------------------------------------
class SafariHud < Component
  def startComponent(viewport)
    super(viewport)
    @sprites["overlay"] = BitmapSprite.new(Graphics.width/2,96,viewport)
    @sprites["overlay"].ox = @sprites["overlay"].bitmap.width
    @sprites["overlay"].x = Graphics.width
    @baseColor   = MENU_TEXTCOLOR[$PokemonSystem.current_menu_theme] || Color.new(248,248,248)
    @shadowColor = MENU_TEXTOUTLINE[$PokemonSystem.current_menu_theme] || Color.new(48,48,48)
  end

  def shouldDraw?; return false; end

  def refresh
    text = _INTL("Balls: {1}",pbSafariState.ballcount)
    text2 = (Settings::SAFARI_STEPS>0) ? _INTL("Steps: {1}/{2}", pbSafariState.steps,Settings::SAFARI_STEPS) : ""
    @sprites["overlay"].bitmap.clear
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbDrawTextPositions(@sprites["overlay"].bitmap,[[text,Graphics.width/2 - 8, 12,1,@baseColor,@shadowColor],[text2,Graphics.width/2 - 8,44,1,@baseColor,@shadowColor]])
  end
end

class DemoHud < Component
  def startComponent(viewport)
    super(viewport)
    @sprites["overlay"] = BitmapSprite.new(Graphics.width/2,96,viewport)
    @sprites["overlay"].ox = @sprites["overlay"].bitmap.width
    @sprites["overlay"].x = Graphics.width
    @baseColor   = MENU_TEXTCOLOR[$PokemonSystem.current_menu_theme] || Color.new(248,248,248)
    @shadowColor = MENU_TEXTOUTLINE[$PokemonSystem.current_menu_theme] || Color.new(48,48,48)
  end

  def shouldDraw?; return true if $PokemonSystem.playermode == 0; end

  def refresh
	if Input.triggerex?(:W)
    remainingtime = ($player.demotimer/60/60)
    text = _INTL("{1} IG Hours left",remainingtime)
	$type = "hours"
	elsif Input.triggerex?(:S)
    remainingtime = ($player.demotimer/60)
    text = _INTL("{1} IG Minutes left",remainingtime)
	$type = "minutes"
	elsif Input.triggerex?(:A)
    remainingtime = ($player.demotimer)
    text = _INTL("{1} IG Seconds left",remainingtime)
	$type = "seconds"
	elsif Input.triggerex?(:D)
    remainingtime = ($player.demotimer/60/60/24)
    text = _INTL("{1} IG Days left",remainingtime)
	$type = "days"
	else
	case $type
	when "seconds"
    remainingtime = ($player.demotimer)
    text = _INTL("{1} IG Seconds left",remainingtime)
	when "minutes"
    remainingtime = ($player.demotimer/60)
    text = _INTL("{1} IG Minutes left",remainingtime)
	when "hours"
    remainingtime = ($player.demotimer/60/60)
    text = _INTL("{1} IG Hours left",remainingtime)
	when "days"
    remainingtime = ($player.demotimer/60/60/24)
    text = _INTL("{1} IG Days left",remainingtime)
	else
    remainingtime = ($player.demotimer/60/60/24)
    text = _INTL("{1} IG Days left",remainingtime)
	end
	end
    @sprites["overlay"].bitmap.clear
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbDrawTextPositions(@sprites["overlay"].bitmap,[[text,Graphics.width/2 - 8, 12,1,@baseColor,@shadowColor]])
  end
end

#-------------------------------------------------------------------------------
# Survival Hud component
#-------------------------------------------------------------------------------
class SurvivalHud < Component
  def startComponent(viewport)
    super(viewport)
    @sprites["overlay"] = BitmapSprite.new(Graphics.width/2,192,viewport)
    @sprites["overlay"].ox = @sprites["overlay"].bitmap.width
    @sprites["overlay"].x = Graphics.width
    @sprites["overlay2"] = BitmapSprite.new(410,187,viewport)
    @sprites["overlay2"].ox = @sprites["overlay2"].bitmap.width
    @sprites["overlay2"].x = Graphics.width
    @sprites["overlay2"].z = -9
    @sprites["trainer"] = IconSprite.new(Graphics.width/2,96,viewport)
    @sprites["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($player.trainer_type))
    @sprites["trainer"].x = Graphics.width/2+120
    @sprites["trainer"].y = Graphics.height/2-85
    @sprites["trainer"].z = -9
    @sprites["nubg"] = IconSprite.new(Graphics.width/2,96,viewport)
    @sprites["nubg"].setBitmap(_INTL("Graphics/Pictures/loadslotsbg"))
    @sprites["nubg"].x = 0
    @sprites["nubg"].y = 0
    @sprites["nubg"].z = -10
	@regionname = ""
	createBars(viewport)
	createMap(viewport)
    @baseColor = Color.new(248,248,248)
    @shadowColor = Color.new(48,48,48)
  end


  def shouldDraw?; return true; end
  def createMap(viewport)
  
    map_data = pbLoadTownMapData
    map_metadata = $game_map.metadata
    playerpos = (map_metadata) ? map_metadata.town_map_position : nil
    mapindex = playerpos[0]
    map     = map_data[playerpos[0]]
	 @regionname = map[0]
    @sprites["map"] = IconSprite.new(0, 0, @viewport)
	if @regionname == "The Island"
	maptemp = map[1].gsub(".png", "")
    @sprites["map"].setBitmap("Graphics/Pictures/#{maptemp}#{getUncoveredMapAmt}.png")
	else
    @sprites["map"].setBitmap("Graphics/Pictures/#{map[1]}")
	end
    @sprites["map"].zoom_x=0.5
    @sprites["map"].zoom_y=0.5
    @sprites["map"].x = (Graphics.width - @sprites["map"].bitmap.width) / 2
    @sprites["map"].y = ((Graphics.height - @sprites["map"].bitmap.height) / 2)+30
    @sprites["map"].z = -10
    #[@regionname,((Graphics.width - @sprites["map"].bitmap.width) / 2)-60, 55,99,@baseColor,@shadowColor],
  end
 
  def createBars(viewport)
    x = 360
    width= 70
    height= 10
    fillWidth = width-4
    fillHeight = height-4
	if true
    @sprites["fodbarborder"] = BitmapSprite.new(width,height,viewport)
    @sprites["fodbarborder"].x = x-width/2
    @sprites["fodbarborder"].y = (@sprites["trainer"].y-height/2)+20
    @sprites["fodbarborder"].bitmap.fill_rect(  Rect.new(0,0,width,height), Color.new(32,32,32) )
    @sprites["fodbarborder"].bitmap.fill_rect(  (width-fillWidth)/2, (height-fillHeight)/2,fillWidth, fillHeight, Color.new(96,96,96)   )
    @sprites["fodbarfill"] = BitmapSprite.new(fillWidth,fillHeight,viewport)
    @sprites["fodbarfill"].x = x-fillWidth/2
    @sprites["fodbarfill"].y = (@sprites["trainer"].y-fillHeight/2)+20
	end
	
	if true
    @sprites["H2Obarborder"] = BitmapSprite.new(width,height,viewport)
    @sprites["H2Obarborder"].x = x-width/2
    @sprites["H2Obarborder"].y = (@sprites["trainer"].y-height/2)+50
    @sprites["H2Obarborder"].bitmap.fill_rect(  Rect.new(0,0,width,height), Color.new(32,32,32) )
    @sprites["H2Obarborder"].bitmap.fill_rect(  (width-fillWidth)/2, (height-fillHeight)/2,fillWidth, fillHeight, Color.new(96,96,96)   )
    @sprites["H2Obarfill"] = BitmapSprite.new(fillWidth,fillHeight,viewport)
    @sprites["H2Obarfill"].x = x-fillWidth/2
    @sprites["H2Obarfill"].y = (@sprites["trainer"].y-fillHeight/2)+50
	end
	
	
	if true
    @sprites["SLPbarborder"] = BitmapSprite.new(width,height,viewport)
    @sprites["SLPbarborder"].x = x-width/2
    @sprites["SLPbarborder"].y = (@sprites["trainer"].y-height/2)+80
    @sprites["SLPbarborder"].bitmap.fill_rect(  Rect.new(0,0,width,height), Color.new(32,32,32) )
    @sprites["SLPbarborder"].bitmap.fill_rect(  (width-fillWidth)/2, (height-fillHeight)/2,fillWidth, fillHeight, Color.new(96,96,96)   )
    @sprites["SLPbarfill"] = BitmapSprite.new(fillWidth,fillHeight,viewport)
    @sprites["SLPbarfill"].x = x-fillWidth/2
    @sprites["SLPbarfill"].y = (@sprites["trainer"].y-fillHeight/2)+80
	end
  end


  def refreshbars
    width= 70
    height= 10
    fillWidth = width-4
    fillHeight = height-4
	
	if true
	@sprites["fodbarfill"].bitmap.clear
    fillAmount = ($player.playerfood==0 || $player.playermaxfood==0) ? 0 : (
      $player.playerfood*@sprites["fodbarfill"].bitmap.width/$player.playermaxfood
    )
    if fillAmount > 0
	if $player.playersaturation > 0
    hpColors = CurrentColorsAlt($player.playerfood, $player.playermaxfood)
	else
    hpColors = CurrentColors($player.playerfood, $player.playermaxfood)
	end
    shadowHeight = 2
    @sprites["fodbarfill"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors
    )
    @sprites["fodbarfill"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["fodbarfill"].bitmap.height-shadowHeight
      ), hpColors
    )
    end
   end
	
	if true
	@sprites["H2Obarfill"].bitmap.clear
    fillAmount = ($player.playerwater==0 || $player.playermaxwater==0) ? 0 : (
      $player.playerwater*@sprites["H2Obarfill"].bitmap.width/$player.playermaxwater
    )
    if fillAmount > 0
	if $player.playersaturation > 0
    hpColors = CurrentColorsAlt($player.playerwater, $player.playermaxwater)
	else
    hpColors = CurrentColors($player.playerwater, $player.playermaxwater)
	end
    shadowHeight = 2
    @sprites["H2Obarfill"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors
    )
    @sprites["H2Obarfill"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["H2Obarfill"].bitmap.height-shadowHeight
      ), hpColors
    )
    end
   end
   
	if true
	@sprites["SLPbarfill"].bitmap.clear
    fillAmount = ($player.playersleep==0 || $player.playermaxsleep==0) ? 0 : (
      $player.playersleep*@sprites["SLPbarfill"].bitmap.width/$player.playermaxsleep
    )
    if fillAmount > 0
    hpColors = CurrentColors($player.playersleep, $player.playermaxsleep)
    shadowHeight = 2
    @sprites["SLPbarfill"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors
    )
    @sprites["SLPbarfill"].bitmap.fill_rect(
      Rect.new(
        0,shadowHeight,fillAmount,
        @sprites["SLPbarfill"].bitmap.height-shadowHeight
      ), hpColors
    )
    end
   end
   
   
   
   
   
   
   
  end

  def CurrentColors(hp, totalhp)
    if hp<(totalhp/4.0)
      return Color.new(255,55,55)
    elsif hp<=(totalhp/4.0)
      return Color.new(255,125,55)
    elsif hp<=(totalhp/2.0)
      return Color.new(255,255,55)
    end
    return Color.new(55,255,55)
  end
  def CurrentColorsAlt(hp, totalhp)
      return Color.new(152,208,248)
  end
  def refresh
   sta = $player.playerstamina
   maxsta = $player.playermaxstamina
    @healthColor=CurrentColors($player.playerhealth, $player.playermaxhealth)
	if $player.playersaturation > 0
    @hungerColor = CurrentColorsAlt($player.playerfood, $player.playermaxfood)
	else
    @hungerColor=CurrentColors($player.playerfood, $player.playermaxfood)
	end
	if $player.playersaturation > 0
    @thirstColor = CurrentColorsAlt($player.playerwater, $player.playermaxwater)
	else
    @thirstColor = CurrentColors($player.playerwater, $player.playermaxwater)
	end
    @sleepColor=CurrentColors($player.playersleep, $player.playermaxsleep)
    refreshbars
    x = Graphics.width/2 - 195
    text5 = "#{$player.playerclass} Lv#{$player.playerclasslevel.to_i}" 
    text4 = $player.name
    text = _INTL("FOD")
    text2 =_INTL("H20")
    text3 =_INTL("SLP")
    text4 = $player.name
    @sprites["overlay"].bitmap.clear
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbSetSystemFont(@sprites["overlay2"].bitmap)
    pbDrawTextPositions(@sprites["overlay2"].bitmap,[[@regionname,0, 45,99,@baseColor,@shadowColor]])
#	if $DEBUG
#    pbDrawTextPositions(@sprites["overlay"].bitmap,[[text,Graphics.width/2 - 8, 5,1,@hungerColor,@shadowColor],[text2,Graphics.width/2 - 8,27,1,@thirstColor,@shadowColor],[text3,Graphics.width/2 - 8,49,1,@sleepColor,@shadowColor],[text4,(Graphics.width/2)-70 - 8,49,1,@sleepColor,@shadowColor]])
#    else
    pbDrawTextPositions(@sprites["overlay"].bitmap,[[text5,Graphics.width/2 - 62, 65,1,@baseColor,@shadowColor],
	[text4,Graphics.width/2 - 77, 87,1,@baseColor,@shadowColor],[text,x, 110,1,@hungerColor,@shadowColor],[text2,x,140,1,@thirstColor,@shadowColor],[text3,x,170,1,@sleepColor,@shadowColor]])

#	end
  end
end

#-------------------------------------------------------------------------------
# Bug Contest Hud component
#-------------------------------------------------------------------------------
class BugContestHud < Component
  def startComponent(viewport)
    super(viewport)
    @sprites["overlay"] = BitmapSprite.new(Graphics.width/2,96,viewport)
    @sprites["overlay"].ox = @sprites["overlay"].bitmap.width
    @sprites["overlay"].x = Graphics.width
    @baseColor = MENU_TEXTCOLOR[$PokemonSystem.current_menu_theme] || Color.new(248,248,248)
    @shadowColor = MENU_TEXTOUTLINE[$PokemonSystem.current_menu_theme] || Color.new(48,48,48)
  end

  def shouldDraw?; return pbInBugContest?; end

  def refresh
    if pbBugContestState.lastPokemon
      text =  _INTL("Caught: {1}", pbBugContestState.lastPokemon.speciesName)
      text2 =  _INTL("Level: {1}", pbBugContestState.lastPokemon.level)
      text3 =  _INTL("Balls: {1}", pbBugContestState.ballcount)
    else
      text = _INTL("Caught: None")
      text2 = _INTL("Balls: {1}", pbBugContestState.ballcount)
      text3 = ""
    end
    @sprites["overlay"].bitmap.clear
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbDrawTextPositions(@sprites["overlay"].bitmap,[[text,Graphics.width/2 - 8, 12,1,
      @baseColor,@shadowColor],[text2,Graphics.width/2 - 8,44,1,@baseColor,@shadowColor],
      [text3,248,76,1,@baseColor,@shadowColor]])
  end
end

#-------------------------------------------------------------------------------
# Pokemon Party Hud component
#-------------------------------------------------------------------------------
class PokemonPartyHud < Component
  def startComponent(viewport)
    super(viewport)
    # Overlay stuff
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height/2,@viewport)
    @sprites["overlay"].y = (Graphics.height/2)
    @hpbar     = AnimatedBitmap.new(MENU_FILE_PATH + "overlayHp")
    @expbar    = AnimatedBitmap.new(MENU_FILE_PATH + "overlayExp")
    @status    = AnimatedBitmap.new(MENU_FILE_PATH + "overlayStatus")
    @infobmp   = Bitmap.new(MENU_FILE_PATH + "overlayInfo")
    @itembmp   = Bitmap.new(MENU_FILE_PATH + "overlayItem")
    @shinybmp  = Bitmap.new(MENU_FILE_PATH + "overlayShiny")
  end

  def shouldDraw?
   return false if pbInSafari?
   return true if $player.party_count > 0
  end

  def refresh
    # Iterate through all the player's Pokémon
    @sprites["overlay"].bitmap.clear
    for i in 0...6
      next if !@sprites["pokemon#{i}"]
      @sprites["pokemon#{i}"].dispose
      @sprites["pokemon#{i}"] = nil
      @sprites.delete("pokemon#{i}")
    end
    for i in 0...$player.party.length
      pokemon = $player.party[i]
      next if !pokemon
      spacing = (Graphics.width/8) * i
      # Pokémon Icon
      @sprites["pokemon#{i}"] = PokemonIconSprite.new(pokemon,@viewport) if !@sprites["pokemon#{i}"]
      @sprites["pokemon#{i}"].x = spacing + (Graphics.width/8)
      @sprites["pokemon#{i}"].y = Graphics.height - 164
      @sprites["pokemon#{i}"].z = -2
      next if pokemon.egg?
      # Information Overlay
      @sprites["overlay"].bitmap.blt(spacing + (Graphics.width/8) + 16, Graphics.height/2 - 102,
                          @infobmp, Rect.new(0, 0, @infobmp.width, @infobmp.height))
      # Shiny Icon
      if pokemon.shiny?
        @sprites["overlay"].bitmap.blt(spacing + (Graphics.width/8) + 52, Graphics.height/2 - 142,
                          @shinybmp,Rect.new(0, 0, @shinybmp.width, @shinybmp.height))
      end
      # Item Icon
      if pokemon.hasItem?
        @sprites["overlay"].bitmap.blt(spacing + (Graphics.width/8) + 52, Graphics.height/2 - 116,
                                       @itembmp,Rect.new(0, 0, @itembmp.width, @itembmp.height))
      end
      # Health
      if pokemon.hp>0
        w = (pokemon.hp * 32 * 1.0)/pokemon.totalhp
        w = 1 if w<1
        w = ((w/2).round) * 2
        hpzone = 0
        hpzone = 1 if pokemon.hp<=(pokemon.totalhp/2).floor
        hpzone = 2 if pokemon.hp<=(pokemon.totalhp/4).floor
        hprect = Rect.new(0, hpzone * 4, w, 4)
        @sprites["overlay"].bitmap.blt(spacing + (Graphics.width/8) + 18, Graphics.height/2 - 100, @hpbar.bitmap, hprect)
      end
      # EXP
      if pokemon.exp>0
        minexp = pokemon.growth_rate.minimum_exp_for_level(pokemon.level)
        currentexp = minexp-pokemon.exp
        maxexp = minexp-pokemon.growth_rate.minimum_exp_for_level(pokemon.level + 1)
        w = (currentexp * 24 * 1.0)/maxexp
        w = 1 if w < 1.0
        w = 0 if w.is_a?(Float) && w.nan?
        w = ((w/2).round) * 2 if w > 0 # I heard Pokémon Beekeeper was good
        exprect = Rect.new(0, 0, w, 2)
        @sprites["overlay"].bitmap.blt(spacing + (Graphics.width/8) + 22, Graphics.height/2 - 94, @expbar.bitmap, exprect)
      end
      # Status
      status = 0
      if pokemon.fainted?
        status = GameData::Status::DATA.keys.length / 2
#      elsif pokemon.status != :NONE
#        status = GameData::Status.get(pokemon.status).id
      elsif pokemon.pokerusStage == 1
        status = GameData::Status::DATA.keys.length / 2 + 1
      end
      status -= 1
      if status >= 0
        statusrect = Rect.new(0,8*status,8,8)
        @sprites["overlay"].bitmap.blt(spacing + (Graphics.width/8) + 48, Graphics.height/2 - 106, @status.bitmap, statusrect)
      end
    end
  end

  def dispose
    super
    @infobmp.dispose
    @hpbar.dispose
    @expbar.dispose
    @status.dispose
    @infobmp.dispose
    @itembmp .dispose
  end
end

#-------------------------------------------------------------------------------
# Date and Time Hud component
#-------------------------------------------------------------------------------
class DateAndTimeHud < Component
  def initialize
    @last_time = pbGetTimeNow.strftime("%I:%M %p")
  end

  def startComponent(viewport)
    super(viewport)
    @sprites["overlay"] = BitmapSprite.new(Graphics.width/2,96,viewport)
    @sprites["overlay"].ox = @sprites["overlay"].bitmap.width
    @sprites["overlay"].x = Graphics.width
    @baseColor = MENU_TEXTCOLOR[$PokemonSystem.current_menu_theme] || Color.new(248,248,248)
    @shadowColor = MENU_TEXTOUTLINE[$PokemonSystem.current_menu_theme] || Color.new(48,48,48)
  end

  def shouldDraw?; return (!$PokemonBag.pbHasItem?(:CLOCK) || !$PokemonBag.pbHasItem?(:CALENDAR)); end

  def update
    super
    refresh if @last_time != pbGetTimeNow.strftime("%I:%M %p")
  end

  def refresh
    text = _INTL("{1} {2} {3}",pbGetTimeNow.day.to_i,pbGetAbbrevMonthName(pbGetTimeNow.month.to_i),pbGetTimeNow.year.to_i) if $bag.has?(:CALENDAR)
    text = _INTL("",pbGetTimeNow.day.to_i,pbGetAbbrevMonthName(pbGetTimeNow.month.to_i),pbGetTimeNow.year.to_i) if !$bag.has?(:CALENDAR)
    text2 = _INTL("{1}",pbGetTimeNow.strftime("%I:%M %p")) if $bag.has?(:CLOCK)
    text2 = _INTL("",pbGetTimeNow.strftime("%I:%M %p")) if !$bag.has?(:CLOCK)
    @sprites["overlay"].bitmap.clear
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbDrawTextPositions(@sprites["overlay"].bitmap,[[text,Graphics.width/2 - 7,5,1,
      @baseColor,@shadowColor],[text2,Graphics.width/2 - 7,27,1,@baseColor,@shadowColor]])
    @last_time = pbGetTimeNow.strftime("%I:%M %p")
  end
end

#-------------------------------------------------------------------------------
# New Quesst Message Hud component
#-------------------------------------------------------------------------------
class NewQuestHud < Component
  def initialize
    @counter = 0
  end

  def startComponent(viewport)
    super(viewport)
    @sprites["overlay"] = BitmapSprite.new(Graphics.width/2,32,viewport)
    @sprites["overlay"].ox = @sprites["overlay"].bitmap.width
    @sprites["overlay"].x = Graphics.width
    @sprites["overlay"].y = 96
    @sprites["overlay"].oy = 32
    @baseColor = MENU_TEXTCOLOR[$PokemonSystem.current_menu_theme] || Color.new(248,248,248)
    @shadowColor = MENU_TEXTOUTLINE[$PokemonSystem.current_menu_theme] || Color.new(48,48,48)
  end

  def shouldDraw?
    return false if !defined?(hasAnyQuests?)
    return false if !$PokemonGlobal
    return false if !$PokemonGlobal.respond_to?(:quests)
    return $PokemonGlobal.quests.active_quests.any? { |quest| quest.respond_to?(:new) && quest.new }
  end

  def update
    super
    @counter += 1
    if @counter > Graphics.frame_rate/2
      @sprites["overlay"].y += 1 if @counter % (Graphics.frame_rate/8) == 0
    else
      @sprites["overlay"].y -= 1 if @counter % (Graphics.frame_rate/8) == 0
    end
    @counter = 0 if @counter >= Graphics.frame_rate
  end

  def refresh
    numQuests = $PokemonGlobal.quests.active_quests.count { |quest| quest.respond_to?(:new) && quest.new }
    @sprites["overlay"].bitmap.clear
    if numQuests > 0
      text = _INTL("You have {1} new quest{2}!",numQuests, numQuests == 1 ? "" : "s")
      pbSetSmallFont(@sprites["overlay"].bitmap)
      pbDrawTextPositions(@sprites["overlay"].bitmap,[[text,Graphics.width/2 - 8, 12,1,@baseColor,@shadowColor]])
    end
  end
end
