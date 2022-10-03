#===============================================================================
#
#===============================================================================
class BadgeCase_Scene
  
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end
  
  def pbStartScene
    @height = Graphics.height
    @screen = Graphics.snap_to_bitmap
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @badgeindex = 0
    @sprites = {}
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["background"] = ScrollingSprite.new(@viewport)
    @sprites["background"].speed = 1
    @sprites["badgeoverlay"] = IconSprite.new(0,0,@viewport)
    @sprites["leadersprite"] = IconSprite.new(350,38,@viewport)
    @sprites["pokemonoverlay"] = IconSprite.new(250,54,@viewport)
    @sprites["acepokemon"] = IconSprite.new(256,68,@viewport)
    @sprites["acepokemon"].zoom_x = 0.5
    @sprites["acepokemon"].zoom_y = @sprites["acepokemon"].zoom_x
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["badge"] = IconSprite.new(30,28,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/Badgecase/Backgrounds/base")
    @sprites["badgeoverlay"].setBitmap("Graphics/Pictures/Badgecase/badgeoverlay")
    @sprites["pokemonoverlay"].setBitmap("Graphics/Pictures/Badgecase/pokemonoverlay")
    drawPage
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbStartSceneOne(badgeindex)
    @height = Graphics.height
    @screen = Graphics.snap_to_bitmap
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @badgeindex = badgeindex
    @sprites = {}
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["background"] = ScrollingSprite.new(@viewport)
    @sprites["background"].speed = 1
    @sprites["badgeoverlay"] = IconSprite.new(0,0,@viewport)
    @sprites["leadersprite"] = IconSprite.new(350,38,@viewport)
    @sprites["pokemonoverlay"] = IconSprite.new(250,54,@viewport)
    @sprites["acepokemon"] = IconSprite.new(256,68,@viewport)
    @sprites["acepokemon"].zoom_x = 0.5
    @sprites["acepokemon"].zoom_y = @sprites["acepokemon"].zoom_x
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["badge"] = IconSprite.new(30,28,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/Badgecase/Backgrounds/base")
    @sprites["badgeoverlay"].setBitmap("Graphics/Pictures/Badgecase/badgeoverlay")
    @sprites["pokemonoverlay"].setBitmap("Graphics/Pictures/Badgecase/pokemonoverlay")
    drawPage
    pbFadeInAndShow(@sprites) { pbUpdate }
  end
  
  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
  
  def drawPage
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(239, 239, 239)
    shadow = Color.new(154, 154, 154)
    overlay.clear
    @sprites["background"].setBitmap("Graphics/Pictures/Badgecase/Backgrounds/base")
    @sprites["badge"].setBitmap("Graphics/Pictures/Badgecase/Badges/Badge#{@badgeindex}")
    @sprites["badge"].zoom_x = 160 / @sprites["badge"].src_rect.width.to_f
    @sprites["badge"].zoom_y = @sprites["badge"].zoom_x
    @sprites["badge"].visible = $player.badges[@badgeindex]
    @sprites["leadersprite"].setBitmap("Graphics/Trainers/#{Badgecase::BADGES[@badgeindex][5]}")
    @sprites["leadersprite"].visible = $player.badges[@badgeindex]
    @sprites["leadersprite"].zoom_x = 128 / @sprites["leadersprite"].src_rect.width.to_f
    @sprites["leadersprite"].zoom_y = @sprites["leadersprite"].zoom_x
    @sprites["acepokemon"].setBitmap("Graphics/Pokemon/Front/#{$player.badges[@badgeindex]? Badgecase::BADGES[@badgeindex][4].upcase : "000"}")
    textpos = [
      [_INTL("#{Badgecase::BADGES[@badgeindex][0]}"), 312, 214, 0, base, shadow],
      [_INTL("Leader: #{$player.badges[@badgeindex]? Badgecase::BADGES[@badgeindex][2] : "???"}"), 20, 254, 0, base, shadow]
    ]
    ypos = 284
    textpos.push([_INTL("Location: #{Badgecase::BADGES[@badgeindex][3]}"), 20, ypos, 0, base, shadow]) && ypos += 30 if BADGE_SHOW_LOCATION
    textpos.push([_INTL("Main Type: #{$player.badges[@badgeindex]? Badgecase::BADGES[@badgeindex][1] : "???"}"), 20, ypos, 0, base, shadow]) && ypos += 30 if BADGE_SHOW_TYPE
    textpos.push([_INTL("Ace Pokemon: #{$player.badges[@badgeindex]? Badgecase::BADGES[@badgeindex][4].capitalize : "???"}"), 20, ypos, 0, base, shadow]) && ypos += 30 if BADGE_SHOW_ACE_POKEMON
    pbDrawTextPositions(overlay,textpos)
    @sprites["pokemonoverlay"].visible = BADGE_SHOW_ACE_POKEMON
    @sprites["acepokemon"].visible = BADGE_SHOW_ACE_POKEMON
    @sprites["background"].setBitmap("Graphics/Pictures/Badgecase/Backgrounds/#{Badgecase::BADGES[@badgeindex][1].downcase}") if $player.badges[@badgeindex] && BADGE_SHOW_TYPE && BADGE_MATCH_BACKGROUND
  end
  
  def pbScene
    loop do
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      if Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      elsif Input.trigger?(Input::LEFT)
        @badgeindex -= 1
        @badgeindex = Badgecase::BADGES.length-1 if @badgeindex<0
        @badgeindex = 0 if @badgeindex > Badgecase::BADGES.length-1
        dorefresh = true
      elsif Input.trigger?(Input::RIGHT)
        @badgeindex += 1
        @badgeindex = Badgecase::BADGES.length-1 if @badgeindex<0
        @badgeindex = 0 if @badgeindex > Badgecase::BADGES.length-1
        dorefresh = true
      end
      if dorefresh
        drawPage
      end
    end
  end

  def pbSceneOne
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::BACK) || Input.trigger?(Input::USE)
        pbPlayCloseMenuSE
        break
      end
    end
  end
end

#===============================================================================
#
#===============================================================================
class BadgeCaseScreen
  
  def initialize(scene)
    @scene = scene
  end
  
  def pbStartScreen()
    @scene.pbStartScene
    ret = @scene.pbScene
    @scene.pbEndScene
    return ret
  end

  def pbStartScreenOne(badgeindex)
    @scene.pbStartSceneOne(badgeindex)
    ret = @scene.pbSceneOne
    @scene.pbEndScene
    return ret
  end
end

#===============================================================================
# pbGetBadge(badgeindex) is the method to get a badge
# badgeindex = The badge index (from the array above)
# It shows a one page UI for the new badge
#===============================================================================
def pbGetBadge(badgeindex)
  $player.badges[badgeindex] = true
  scene = BadgeCase_Scene.new
  screen = BadgeCaseScreen.new(scene)
  screen.pbStartScreenOne(badgeindex)
end