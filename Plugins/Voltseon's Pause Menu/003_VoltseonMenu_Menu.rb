#-------------------------------------------------------------------------------
# Main Pause Menu component
#-------------------------------------------------------------------------------
class VoltseonsPauseMenu < Component
  def startComponent(viewport, spritehash, menu)
    super(viewport)
    @sprites = spritehash
    @menu = menu
    @entries = []
    @currentSelection = $game_temp.last_menu_selection
    @shouldRefresh = true
    # Background image
    @sprites["menuback"] = Sprite.new(@viewport)
    if pbResolveBitmap(MENU_FILE_PATH + "Backgrounds/bg_#{$PokemonSystem.current_menu_theme}")
      @sprites["menuback"].bitmap = Bitmap.new(MENU_FILE_PATH + "Backgrounds/bg_#{$PokemonSystem.current_menu_theme}")
    else
      @sprites["menuback"].bitmap = Bitmap.new(MENU_FILE_PATH + "Backgrounds/bg_#{DEFAULT_MENU_THEME}")
    end
    @sprites["menuback"].z        = -5
    @sprites["menuback"].oy       = @sprites["menuback"].bitmap.height
    @sprites["menuback"].y        = @sprites["menuback"].bitmap.height
    # Did you know that the first pokémon you see in Red and Blue, Nidorino plays a Nidorina cry?
    # This could have been prevented if they just used vCry("Nidorino") ;)
    # Voltseon's Handy Tools is available at https://reliccastle.com/resources/400/4
    calculateMenuEntries
    calculateDisplayIndex
    redrawMenuIcons
    @sprites["dummyiconL"] = IconSprite.new(0,0,@viewport)
    @sprites["dummyiconL"].y = Graphics.height - 42
    @sprites["dummyiconL"].ox = $game_temp.menu_icon_width/2
    @sprites["dummyiconL"].oy = $game_temp.menu_icon_width/2
    @sprites["dummyiconR"] = IconSprite.new(0,0,@viewport)
    @sprites["dummyiconR"].y = Graphics.height - 42
    @sprites["dummyiconR"].ox = $game_temp.menu_icon_width/2
    @sprites["dummyiconR"].oy = $game_temp.menu_icon_width/2
    calculateXPositions(true)
    @sprites["entrytext"] = BitmapSprite.new(Graphics.width,@sprites["menuback"].height,@viewport)
    @sprites["entrytext"].y = Graphics.height - 188
    #@sprites["entrytext"].ox = 128
    @sprites["entrytext"].x = 0
    @sprites["leftarrow"].visible = !(@displayIndexes.length == 1)
    @sprites["rightarrow"].visible = @displayIndexes.length > 1
	7.times do |i|
    @sprites["boxi#{i}"] = IconSprite.new(0,0,@viewport)
    @sprites["boxi#{i}"].visible = true
	x=0
    case i
	 when 0
	   x=-5
	 when 1
	   x=64
	 when 2
	   x=133
	 when 3
	   x=226
	 when 4
	   x=319
	 when 5
	   x=388
	 when 6
	   x=457
	end 
	 @sprites["boxi#{i}"].x = x+12
    @sprites["boxi#{i}"].y = Graphics.height - 10
    @sprites["boxi#{i}"].z = @sprites["entrytext"].z-1
    @sprites["boxi#{i}"].ox = $game_temp.menu_icon_width/2
    @sprites["boxi#{i}"].oy = $game_temp.menu_icon_width/2
    @sprites["boxi#{i}"].setBitmap("Graphics/Pictures/tinyuiboxgrey.png")
	end
    @doingStartup = true
  end

  def update
    exit = false # should the menu-loop continue
    if Input.trigger?(Input::BACK) || Input.trigger?(Input::ACTION)
      @menu.shouldExit = true
      $game_temp.last_menu_selection = @currentSelection
      return
    elsif Input.press?(Input::LEFT) || Input.scroll_v==-1
      shiftCursor(-1)
    elsif (Input.press?(Input::RIGHT)  || Input.scroll_v==1  )&& @displayIndexes.length > 1
      shiftCursor(1)
    elsif Input.trigger?(Input::USE)
      pbPlayDecisionSE
      exit = @entries[@currentSelection].selected(@menu) # trigger selected entry.
	  if @entries[@currentSelection].name == "Quit" && exit == false
	  else
      calculateMenuEntries
      calculateDisplayIndex
      redrawMenuIcons
      calculateXPositions(true)
      @shouldRefresh = true
      $game_temp.last_menu_selection = @currentSelection
	  end
    elsif Input.triggerex?(:P) #Pokemon
	   @entries.each do |i|
	    if i.name == "Pokemon"
	   i.selected(@menu)
	   end
	   end
      calculateMenuEntries
      calculateDisplayIndex
      redrawMenuIcons
      calculateXPositions(true)
      @shouldRefresh = true
    elsif Input.triggerex?(:B) #Bag
	   @entries.each do |i|
	    if i.name == "Bag"
	   i.selected(@menu)
	   end
	   end
      calculateMenuEntries
      calculateDisplayIndex
      redrawMenuIcons
      calculateXPositions(true)
      @shouldRefresh = true
    elsif Input.triggerex?(:C) #Craft
	   @entries.each do |i|
	    if i.name == "Crafting"
	   i.selected(@menu)
	   end
	   end
      calculateMenuEntries
      calculateDisplayIndex
      redrawMenuIcons
      calculateXPositions(true)
      @shouldRefresh = true
    elsif Input.triggerex?(:V) #Adventure
	   @entries.each do |i|
	    if i.name == "Adventures"
	   i.selected(@menu)
	   end
	   end
      calculateMenuEntries
      calculateDisplayIndex
      redrawMenuIcons
      calculateXPositions(true)
      @shouldRefresh = true
    elsif Input.triggerex?(:S) #Save
	   @entries.each do |i|
	    if i.name == "Save"
	   i.selected(@menu)
	   end
	   end
      calculateMenuEntries
      calculateDisplayIndex
      redrawMenuIcons
      calculateXPositions(true)
      @shouldRefresh = true
    elsif Input.triggerex?(:W) #Disable Menu?
	   
    elsif Input.triggerex?(:G) #Quest
	   @entries.each do |i|
	    if i.name == "Quests"
	   i.selected(@menu)
	   end
	   end
      calculateMenuEntries
      calculateDisplayIndex
      redrawMenuIcons
      calculateXPositions(true)
      @shouldRefresh = true
    elsif Input.triggerex?(:T) #Advancement
	   @entries.each do |i|
	    if i.name == "Achievements"
	   i.selected(@menu)
	   end
	   end
      calculateMenuEntries
      calculateDisplayIndex
      redrawMenuIcons
      calculateXPositions(true)
      @shouldRefresh = true
    elsif Input.triggerex?(:Q) #Quit
	   @entries.each do |i|
	    if i.name == "Quit"
	   i.selected(@menu)
	   end
	   end
    end
    if @shouldRefresh && !@menu.shouldExit
      refreshMenu
      @menu.shouldRefresh = true
      @shouldRefresh = false
      @sprites["leftarrow"].visible = !(@entries.length == 1)
      @sprites["rightarrow"].visible = @displayIndexes.length > 1
    end
    @menu.shouldExit = exit
  end

  # direction is either 1 (right) or -1 (left)
  def shiftCursor(direction)
    return false if @entries.length < 2
    @currentSelection += direction
    # keep selection within array bounds
    @currentSelection = @entries.length-1 if @currentSelection < 0
    @currentSelection = 0 if @currentSelection >= @entries.length
    # Shift array elements
    if direction < 0
      el = @entries.length - 1
      temp = @entryIndexes[el].clone
      @entryIndexes[el] = nil
      e_temp = @entryIndexes.clone
      for i in 0...(el + 1)
        @entryIndexes[i + 1] = e_temp[i]
      end
      @entryIndexes[0] = temp
      @entryIndexes.compact!
    else
      ret = @entryIndexes.shift
      @entryIndexes.push(ret)
    end
    @shouldRefresh = true
    pbSEPlay(MENU_CURSOR_SOUND)
    # Animation stuff
    duration = (Graphics.frame_rate/8)
    middle = @displayIndexes.length/2
    if @displayIndexes.length < 3
      calculateXPositions
      duration.times do
        Graphics.update
        pbUpdateSpriteHash(@sprites)
      end
      return
    end
    duration.times do
      for key in @sprites.keys
        next if !key[/icon/]
        total = (direction > 0)? @iconsDeviationL[key] : @iconsDeviationR[key]
        amt2 = (total/(duration * 1.0))
        amt = ((direction > 0) ? amt2.floor : amt2.ceil).to_i
        amt -= (direction * 1) if @displayIndexes.length < 5
        @sprites[key].x += amt
        finalpos = (@iconsBaseX[key] + total)
        baseX = direction > 0 ? (@sprites[key].x <= finalpos) : (@sprites[key].x >= finalpos)
        @sprites[key].x = (@iconsBaseX[key] + total) if baseX
      end
      @sprites["icon#{middle}"].zoom_x -= (ACTIVE_SCALE - 1.0)/(duration)
      @sprites["icon#{middle}"].zoom_y -= (ACTIVE_SCALE - 1.0)/(duration)
      @sprites["icon#{middle}"].z = -1
      mdr = middle + direction
      mdr = mdr.clamp(0,6)
      @sprites["icon#{mdr}"].zoom_x += (ACTIVE_SCALE - 1.0)/(duration)
      @sprites["icon#{mdr}"].zoom_y += (ACTIVE_SCALE - 1.0)/(duration)
      @sprites["icon#{mdr}"].z = -1
      pbUpdateSpriteHash(@sprites)
      Graphics.update
    end
    calculateXPositions
  end

  # Calculate indexes of sprites to be displayed
  def calculateDisplayIndex
    @displayIndexes = @entryIndexes.clone
    if @entryIndexes.length%2 == 0
      @displayIndexes[0] = nil
      @displayIndexes.compact!
    end
    if @displayIndexes.length > 7
      offset = (@entryIndexes.length - 7)/2
      endVal = 7 + offset
      @displayIndexes = @displayIndexes[offset...endVal]
    end
  end

  # Get all the entries to be displayed
  def calculateMenuEntries
    oldentries = @entries.length
    @entries = []
    MENU_ENTRIES.each do |entry|
      menuEntry = Object.const_get(entry).new
      @entries.push(menuEntry) if menuEntry.selectable?
    end
    if @entries.length != oldentries && oldentries != 0
      @currentSelection += (@entries.length - oldentries)
      @currentSelection = @currentSelection.clamp(0,@entries.length - 1)
    end
    @entryIndexes = []
    middle = @entries.length/2
    @entryIndexes[middle] = @currentSelection
    current = @currentSelection + 1
    # Calculating an array in the fashion [...,5,6,0,1,2....]
    for i in (middle + 1)...@entries.length
      current = 0 if current >= @entries.length
      @entryIndexes[i] = current
      current += 1
    end
    for i in 0...middle
      current = 0 if current >= @entries.length
      @entryIndexes[i] = current
      current += 1
    end
  end

  def redrawMenuIcons
    for key in @sprites.keys
      next if !key[/icon/] || key[/dummy/]
      @sprites[key].dispose
      @sprites[key] = nil
      @sprites.delete(key)
    end
    middle = @displayIndexes.length/2
    for i in 0...@displayIndexes.length
      @sprites["icon#{i}"] = IconSprite.new(0,0,@viewport)
      @sprites["icon#{i}"].visible = true
      @sprites["icon#{i}"].y = Graphics.height - 42
      @sprites["icon#{i}"].ox = $game_temp.menu_icon_width/2
      @sprites["icon#{i}"].oy = $game_temp.menu_icon_width/2
      @sprites["icon#{i}"].z = -1
    end
    if @displayIndexes.length == 2
      @sprites["icon1"] = IconSprite.new(0,0,@viewport)
      @sprites["icon1"].visible = true
      @sprites["icon1"].y = Graphics.height - 20
      @sprites["icon1"].ox = $game_temp.menu_icon_width/2
      @sprites["icon1"].oy = $game_temp.menu_icon_width/2
      @sprites["icon1"].z = -1
    end
  end

  # Calculate x positions of icons after animation is complete
  def calculateXPositions(recalc = false)
    middle = @displayIndexes.length/2
    @sprites["icon#{middle}"].x = Graphics.width/2
    maxdist = Graphics.width/8
    offset = middle == 0 ? maxdist : maxdist/(@displayIndexes.length/2)
    offset = offset.clamp(maxdist/3,maxdist)
    lastx = 0
    addl_space = 48 - $game_temp.menu_icon_width
    for i in 0...middle
      finalx = Graphics.width/2 - ($game_temp.menu_icon_width/2) - ((offset - 21) * @displayIndexes.length/2)
      finalx -= ($game_temp.menu_icon_width + offset + addl_space) * (middle - i)
      @sprites["icon#{i}"].x = finalx
      lastx = finalx if i == 0
    end
    @sprites["dummyiconL"].x = lastx - ($game_temp.menu_icon_width + offset + addl_space)
    lastx = 0
    for i in (middle + 1)...@displayIndexes.length
      finalx = Graphics.width/2 + ($game_temp.menu_icon_width/2) + (@displayIndexes.length < 5 ?  offset/2 : ((offset - 21) * @displayIndexes.length/2))
      finalx += ($game_temp.menu_icon_width + offset + addl_space) * (i - middle)
      @sprites["icon#{i}"].x = finalx
      lastx = finalx
    end
    @sprites["dummyiconR"].x = lastx + ($game_temp.menu_icon_width + offset + addl_space)
    return if !recalc
    @iconsBaseX = {}
    @iconsDeviationL = {}
    @iconsDeviationR = {}
    for key in @sprites.keys
      next if !key[/icon/]
      @iconsBaseX[key] = @sprites[key].x
    end
    for key in @sprites.keys
      next if !key[/icon/]
      if key[/dummy/]
        if key[/L/]
          max_dev = @sprites["icon0"].x - @sprites[key].x
        elsif key[/R/]
          max_dev = @sprites[key].x - @sprites["icon#{@displayIndexes.length - 1}"].x
        end
        @iconsDeviationL[key] = - max_dev
        @iconsDeviationR[key] = max_dev
        next
      end
      index = key.gsub("icon","").to_i
      newkeyL = (index == 0)? "dummyiconL" : "icon#{index - 1}"
      newkeyR = (index == @displayIndexes.length - 1)? "dummyiconR" : "icon#{index + 1}"
      @iconsDeviationL[key] = @sprites[newkeyL].x - @sprites[key].x
      @iconsDeviationR[key] = @sprites[newkeyR].x - @sprites[key].x
    end
  end

  def refreshMenu
    calculateDisplayIndex
    baseColor = MENU_TEXTCOLOR[$PokemonSystem.current_menu_theme].is_a?(Color) ? MENU_TEXTCOLOR[$PokemonSystem.current_menu_theme] : Color.new(248,248,248)
    shadowColor = MENU_TEXTOUTLINE[$PokemonSystem.current_menu_theme].is_a?(Color) ? MENU_TEXTOUTLINE[$PokemonSystem.current_menu_theme] : Color.new(48,48,48)
    middle = @displayIndexes.length/2
	textpos = []
	textpos << [@entries[@currentSelection].name,Graphics.width/2,20,2,baseColor,shadowColor]
    for i in 0...@displayIndexes.length
      @sprites["icon#{i}"].setBitmap(@entries[@displayIndexes[i]].icon)
      @sprites["icon#{i}"].zoom_x = 1
      @sprites["icon#{i}"].zoom_y = 1
	  textpos << [@entries[@displayIndexes[i]].text,(@sprites["icon#{i}"].x-30),155,99,baseColor,shadowColor] 
    end
    @sprites["icon#{middle}"].zoom_x = ACTIVE_SCALE
    @sprites["icon#{middle}"].zoom_y = ACTIVE_SCALE
    if @entries.length <= 8
      b2 = @entries[@entryIndexes[0]].icon
      b1 = ((@entries.length%2==0)? @entries[@entryIndexes[0]] : @entries[@entryIndexes[@displayIndexes.length - 1]]).icon
    else
      offset = (@entryIndexes.length - 7)/2
      of2 = (@entryIndexes.length%2 - 1).abs
      b1 = @entries[@entryIndexes[offset - 1 + of2]].icon
      b2 = @entries[@entryIndexes[@entryIndexes.length - offset]].icon
    end
    @sprites["dummyiconL"].setBitmap(b1)
    @sprites["dummyiconR"].setBitmap(b2)
    @sprites["entrytext"].bitmap.clear
    pbSetSystemFont(@sprites["entrytext"].bitmap)
    pbDrawTextPositions(@sprites["entrytext"].bitmap,textpos)
  end
end
