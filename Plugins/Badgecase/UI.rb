#===============================================================================
#
#===============================================================================
#  Calaculating best way to spread badges
#===============================================================================
def getBadgePositions(badgecount=8)
  width = Graphics.width
  height = Graphics.height - 50
  bestPositionsx=[]
  bestPositionsy=[]
  bestSize=0
  bestRows=0
  bestColumns=0
  for i in 1..10
    calculating = false
    rows = i
    columns = badgecount/i.to_f
    if columns == columns.to_int
      for j in 0...AGREED_SIZES.length
        if (width - columns*AGREED_SIZES[j] > 0) && (height - rows*AGREED_SIZES[j] > 0)
          ((bestSize = AGREED_SIZES[j]) && (calculating = true)) if bestSize<AGREED_SIZES[j]
          break
        end
      end
      if calculating
        bestRows=rows
        bestColumns=columns
        bestPositionsx=[]
        bestPositionsy=[]
        xstep = (width - columns*bestSize)/(columns+1.0)
        ystep = (height - rows*bestSize)/(rows+1.0)
        x = xstep
        y = ystep + 50
        for k in 0...rows
          for o in 0...columns
            bestPositionsx.push(x)
            bestPositionsy.push(y)
            x += bestSize + xstep
          end
          x = xstep
          y += bestSize + ystep
        end
      end
    end
  end
  bestPositions = [bestPositionsx,bestPositionsy,[bestSize,bestColumns,bestRows]]
  bestPositions = getBadgePositions(badgecount+1) if bestPositionsx.length == 0
  return bestPositions
end
#===============================================================================
#
#===============================================================================
class BadgeCase_Scene
  
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end
  
  def pbStartScene
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @badgeindex = 0
    @badgepage = false
    @sprites = {}
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["background"] = ScrollingSprite.new(@viewport)
    @sprites["background"].speed = 1
    @sprites["casebg"] = IconSprite.new(0,0,@viewport)
    @sprites["badgeoverlay"] = IconSprite.new(0,0,@viewport)
    @sprites["leadersprite"] = IconSprite.new(350,38,@viewport)
    @sprites["pokemonoverlay"] = IconSprite.new(250,54,@viewport)
    @sprites["acepokemon"] = IconSprite.new(256,68,@viewport)
    @sprites["acepokemon"].zoom_x = 0.5
    @sprites["acepokemon"].zoom_y = @sprites["acepokemon"].zoom_x
    @sprites["badge"] = IconSprite.new(30,28,@viewport)
    @badgePositions = getBadgePositions(Badgecase::BADGES.length)
    for i in 0...Badgecase::BADGES.length
      @sprites["badge#{i}"] = IconSprite.new(@badgePositions[0][i],@badgePositions[1][i],@viewport)
      @sprites["badge#{i}"].setBitmap("Graphics/Pictures/Badgecase/Badges/Badge#{i}")
      @sprites["badge#{i}"].zoom_x = @badgePositions[2][0] / @sprites["badge#{i}"].src_rect.width.to_f
      @sprites["badge#{i}"].zoom_y = @sprites["badge#{i}"].zoom_x
    end
    @sprites["badgecursor"] = IconSprite.new(0,0,@viewport)
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["casebg"].setBitmap("Graphics/Pictures/Badgecase/Backgrounds/badgebg")
    @sprites["background"].setBitmap("Graphics/Pictures/Badgecase/Backgrounds/base")
    @sprites["badgeoverlay"].setBitmap("Graphics/Pictures/Badgecase/badgeoverlay")
    @sprites["pokemonoverlay"].setBitmap("Graphics/Pictures/Badgecase/pokemonoverlay")
    @sprites["badgecursor"].setBitmap("Graphics/Pictures/Badgecase/badgeCursor")
    @sprites["badgecursor"].zoom_x = @badgePositions[2][0] / @sprites["badgecursor"].src_rect.width.to_f
    @sprites["badgecursor"].zoom_y = @sprites["badgecursor"].zoom_x
    drawPage
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbStartSceneOne(badgeindex)
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @badgeindex = badgeindex
    @badgepage = true
    @sprites = {}
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["background"] = ScrollingSprite.new(@viewport)
    @sprites["background"].speed = 1
    @sprites["badgeoverlay"] = IconSprite.new(0,0,@viewport)
    @sprites["leadersprite"] = IconSprite.new(350,38,@viewport)
    @sprites["acepokemon"] = IconSprite.new(256,68,@viewport)
    @sprites["acepokemon"].zoom_x = 0.5
    @sprites["acepokemon"].zoom_y = @sprites["acepokemon"].zoom_x
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["badge"] = IconSprite.new(30,28,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/Badgecase/Backgrounds/base")
    @sprites["badgeoverlay"].setBitmap("Graphics/Pictures/Badgecase/badgeoverlay")
    drawBadge
    pbFadeInAndShow(@sprites) { pbUpdate }
  end
  
  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def drawPage
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    @sprites["background"].visible = @badgepage
    @sprites["badgeoverlay"].visible = @badgepage
    @sprites["pokemonoverlay"].visible = @badgepage
    @sprites["leadersprite"].visible = false
    @sprites["acepokemon"].visible = false
    @sprites["badge"].visible = false
    @sprites["casebg"].visible = !@badgepage
    @sprites["badgecursor"].visible = !@badgepage
    for i in 0...Badgecase::BADGES.length
      @sprites["badge#{i}"].visible = false
    end
    if @badgepage
      drawBadgePage
    else
      drawCasePage
    end
  end

  def drawCasePage
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    base   = Color.new(156, 152, 149)
    shadow = Color.new(166, 162, 159)
    for i in 0...Badgecase::BADGES.length
      @sprites["badge#{i}"].visible = $player.badges[i]
    end
    textpos = [
      [_INTL("GYM BADGES"), 52, 12, 0, base, shadow]
    ]
    pbDrawTextPositions(overlay,textpos)
    updateCursor
  end
  
  def drawBadgePage
    oldX = @sprites["background"].src_rect.x
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    base   = Color.new(239, 239, 239)
    shadow = Color.new(154, 154, 154)
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
    @sprites["background"].src_rect.x = oldX
  end

  def updateCursor
    @sprites["badgecursor"].x = @badgePositions[0][@badgeindex]
    @sprites["badgecursor"].y = @badgePositions[1][@badgeindex]
  end
  
  def pbScene
    loop do
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      if Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        if @badgepage
          @badgepage = false
          dorefresh = true
        else
          break
        end
      elsif Input.trigger?(Input::USE)
        if !@badgepage
          @badgepage = true
          dorefresh = true
        end
      elsif Input.trigger?(Input::LEFT)
        if @badgepage
          @badgeindex -= 1
          @badgeindex = Badgecase::BADGES.length-1 if @badgeindex<0
          @badgeindex = 0 if @badgeindex > Badgecase::BADGES.length-1
          dorefresh = true
        else
          @badgeindex -= 1 if @badgeindex % @badgePositions[2][1] != 0
          @badgeindex = 0 if @badgeindex<0
          @badgeindex = Badgecase::BADGES.length-1 if @badgeindex > Badgecase::BADGES.length-1
          updateCursor
        end
      elsif Input.trigger?(Input::RIGHT)
        if @badgepage
          @badgeindex += 1
          @badgeindex = Badgecase::BADGES.length-1 if @badgeindex<0
          @badgeindex = 0 if @badgeindex > Badgecase::BADGES.length-1
          dorefresh = true
        else
          @badgeindex += 1 if (@badgeindex+1) % @badgePositions[2][1] != 0
          @badgeindex = 0 if @badgeindex<0
          @badgeindex = Badgecase::BADGES.length-1 if @badgeindex > Badgecase::BADGES.length-1
          updateCursor
        end
      elsif Input.trigger?(Input::DOWN)
        if !@badgepage
          @badgeindex += @badgePositions[2][1].to_int if (@badgeindex/@badgePositions[2][1]) < (@badgePositions[2][2]-1)
          @badgeindex = 0 if @badgeindex<0
          @badgeindex = Badgecase::BADGES.length-1 if @badgeindex > Badgecase::BADGES.length-1
          updateCursor
        end
      elsif Input.trigger?(Input::UP)
        if !@badgepage
          @badgeindex -= @badgePositions[2][1].to_int if @badgeindex>=@badgePositions[2][1]
          @badgeindex = 0 if @badgeindex<0
          @badgeindex = Badgecase::BADGES.length-1 if @badgeindex > Badgecase::BADGES.length-1
          updateCursor
        end
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
#
#===============================================================================
def pbGetBadge(badgeindex)
  $player.badges[badgeindex] = true
  scene = BadgeCase_Scene.new
  screen = BadgeCaseScreen.new(scene)
  screen.pbStartScreenOne(badgeindex)
end