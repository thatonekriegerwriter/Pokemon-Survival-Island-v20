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

  def shouldDraw?; return pbInSafari?; end

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

  def shouldDraw?; return true if $player.playermode == 0; end

  def refresh
    text = _INTL("Time: {1}",$player.demotimer)
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
    @sprites["overlay"] = BitmapSprite.new(Graphics.width/2,96,viewport)
    @sprites["overlay"].ox = @sprites["overlay"].bitmap.width
    @sprites["overlay"].x = Graphics.width
	if $player.playerhealth >= 80
         trainerhealth = _INTL("Healthy")
         @healthColor=Color.new(55,255,55)
     else
       if $player.playerhealth >= 50
         trainerhealth = _INTL("Injured")
         @healthColor=Color.new(255,255,55)
     else
        if $player.playerhealth >= 25
         trainerhealth = _INTL("Wounded")
         @healthColor=Color.new(255,125,55)
     else
        if $player.playerhealth <= 24
         trainerhealth = _INTL("Critical")
         @healthColor=Color.new(255,55,55)
        end
        end
     end
    end

    if $player.playerfood >= 80
         trainerhunger = _INTL("Full")
         @hungerColor=Color.new(55,255,55)
       else
         if $player.playerfood >= 75
           trainerhunger = _INTL("Well Off")
           @hungerColor=Color.new(255,255,55)
         else
           if $player.playerfood >= 50
             trainerhunger = _INTL("Hungry")
             @hungerColor=Color.new(255,125,55)
           else
               if $player.playerfood >= 25
                trainerhunger = _INTL("Starving")
                @hungerColor=Color.new(255,125,55)
                else
                 if $player.playerfood <= 24
                   trainerhunger= _INTL("Dying")
                   @hungerColor=Color.new(255,55,55)
			    end
			   end
           end
         end
       end   


    if $player.playerwater >= 80
         trainerthirst = _INTL("Quenched")
         @thirstColor=Color.new(55,255,55)
       else
         if $player.playerwater >= 75
           trainerthirst = _INTL("Well Off")
           @thirstColor=Color.new(255,255,55)
         else
           if $player.playerwater >= 50
             trainerthirst = _INTL("Thirsty")
             @thirstColor=Color.new(255,125,55)
           else
               if $player.playerwater >= 25
                trainerthirst = _INTL("Dehydrated")
                @thirstColor=Color.new(255,125,55)
                else
                 if $player.playerwater <= 24
                   trainerthirst= _INTL("Dying")
                   @thirstColor=Color.new(255,55,55)
			    end
			   end
           end
         end
       end   

    if $player.playersleep >= 80
          trainersleep = _INTL("Rested")
          @sleepColor=Color.new(55,255,55)
       else
         if $player.playersleep >= 75
            trainersleep = _INTL("Well Off")
            @sleepColor=Color.new(255,255,55)
         else
           if $player.playersleep >= 50
              trainersleep = _INTL("Tired")
              @sleepColor=Color.new(255,125,55)
           else
               if $player.playersleep >= 25
                 trainersleep = _INTL("Deprived")
                 @sleepColor=Color.new(255,125,55)
                else
                 if $player.playersleep <= 24
                   trainersleep= _INTL("Dying")
                   @sleepColor=Color.new(255,55,55)
			    end
			   end
           end
         end
       end 
  end
    @shadowColor = Color.new(48,48,48)


  def shouldDraw?; return true if $PokemonSystem.survivalmode == 0; end

  def refresh
    text = _INTL("FOD")
    text2 =_INTL("H20")
    text3 =_INTL("SLP")
    text4 =_INTL("HP")
    @sprites["overlay"].bitmap.clear
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbDrawTextPositions(@sprites["overlay"].bitmap,[[text,Graphics.width/2 - 8, 34,1,@hungerColor,@shadowColor],[text2,Graphics.width/2 - 8,56,1,@thirstColor,@shadowColor],[text3,Graphics.width/2 - 8,78,1,@sleepColor,@shadowColor],[text4,Graphics.width/2 - 8,12,1,@healthColor,@shadowColor]])
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

  def shouldDraw?; return $player.party_count > 0; end

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

  def shouldDraw?; return ($PokemonBag.pbHasItem?(:CLOCK) || $PokemonBag.pbHasItem?(:CALENDAR)); end

  def update
    super
    refresh if @last_time != pbGetTimeNow.strftime("%I:%M %p")
  end

  def refresh
    text = _INTL("{1} {2} {3}",Time.now.day.to_i,pbGetAbbrevMonthName(Time.now.month.to_i),Time.now.year.to_i) if $PokemonBag.pbHasItem?(:CALENDAR)
    text = _INTL("",Time.now.day.to_i,pbGetAbbrevMonthName(Time.now.month.to_i),Time.now.year.to_i) if !$PokemonBag.pbHasItem?(:CALENDAR)
    text2 = _INTL("{1}",pbGetTimeNow.strftime("%I:%M %p")) if $PokemonBag.pbHasItem?(:CLOCK)
    text2 = _INTL("",pbGetTimeNow.strftime("%I:%M %p")) if !$PokemonBag.pbHasItem?(:CLOCK)
    @sprites["overlay"].bitmap.clear
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbDrawTextPositions(@sprites["overlay"].bitmap,[[text,Graphics.width/2 - 8, 12,1,
      @baseColor,@shadowColor],[text2,Graphics.width/2 - 8,44,1,@baseColor,@shadowColor]])
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
