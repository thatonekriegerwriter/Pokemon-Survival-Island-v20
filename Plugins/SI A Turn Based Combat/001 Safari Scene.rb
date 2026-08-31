#===============================================================================
# Safari Zone battle scene (the visuals of the battle)
#===============================================================================
class Battle::Scene
  attr_accessor :subMenuOpen
  attr_accessor :selectedSubmenu
  attr_accessor :sprites
  def pbSafariStart
    @briefMessage = false
    @sprites["dataBox_0"] = SafariDataBox.new(@battle, @viewport)
   # dataBoxAnim = Animation::DataBoxAppear.new(@sprites, @viewport, 0)
  #  loop do
  #    dataBoxAnim.update
    #  pbUpdate
   #   break if dataBoxAnim.animDone?
   # end
   # dataBoxAnim.dispose
	#shift1 = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/cursor_shift"))
   # shift = Sprite.new(@viewport)
   # shift.bitmap = shift1.bitmap
   # shift.x      = x = 4
   # shift.y      = y = shift1.height+200
   # shift.z      = 99
   # @sprites["shiftButton"] = shift
	@subMenuOpen = false 
	@selectedSubmenu = -1
	@stored_cw_index = 0
	@stored_safari_indexes = {}
    pbRefresh
  end
  
  def pbResetSafariCommand
	@subMenuOpen = false 
	@selectedSubmenu = -1
	@stored_cw_index = 0
    cw = @sprites["commandWindow"]
    cw.safari_index = 0
	cw.index = 0
  end 
  def pbShowSafariWindow
    @sprites["commandWindow"].visible = true
    @sprites["messageBox"].visible    = true
  end
  
  def getCommands
	return [_INTL("What will {1} do?", $player.name)] +  getSelectionCommands
  end
  
  def getSelectionCommands 
   commands = []
   commands << _INTL("ATTACK")
   commands << _INTL("CATCH")
   commands << _INTL("APPEAL") 
   commands << _INTL("DEFEND") 
   return commands 
  end 
  
  def pbSafariSetSubcommands(command, cw)
    options = @battle.suboptions[command]
    current_option = options[cw.safari_index]
	
	name = current_option.name
	description = current_option.description
	stamina_change = current_option.stamina_cost
	is_consumed = current_option.consumable
	extra_data = current_option.extra_data
    texts = []
	texts << description
	name_text = ""
	name_text += "◀" if options.length>1
	name_text += name
	name_text += "▶" if options.length>1
	texts << name_text
	amt_text = ""
	amt_text += _INTL("x{1}", $bag.quantity(id)) if is_consumed && command!=_INTL("CATCH")
	amt_text += _INTL("x{1}", $bag.quantity(extra_data)) if is_consumed && command==_INTL("CATCH")
	texts << amt_text 
	sta_text = ""
	sta_text2 = ""
	if stamina_change && !stamina_change.zero?
	sta_text2 += _INTL("+") if stamina_change<0
	sta_text2 += _INTL("-") if stamina_change>0
	sta_text2 += _INTL("{1} STA", stamina_change.abs.to_i)
	sta_text += _INTL("{1}/{2} STA", $player.playerstamina.to_i, $player.playermaxstamina.to_i) 
	end
	texts << sta_text 
	texts << sta_text2 
    cw.setTexts(texts)
  end 
  
  def pbSafariMainCommands(oldIndex, cw)
      if Input.trigger?(Input::LEFT)
        cw.index -= 1 if (cw.index & 1) == 1
      elsif Input.trigger?(Input::RIGHT)
        cw.index += 1 if (cw.index & 1) == 0
      elsif Input.trigger?(Input::UP)
        cw.index -= 2 if (cw.index & 2) == 2
      elsif Input.trigger?(Input::DOWN)
        cw.index += 2 if (cw.index & 2) == 0
      end
      @battle.index = cw.index
      pbPlayCursorSE if cw.index != oldIndex      # Actions
      if Input.trigger?(Input::USE)
	    command = getSelectionCommands[cw.index]
	    if @battle.suboptions[command].length==0 || (command==_INTL("CATCH")) && $player.is_it_this_class?(:RANGER, false)
		 pbPlayBuzzerSE
		 oldText = cw.getText(cw.index)
		 cw.setMsgBoxText(_INTL("{1} can't do anything with that!", $player.name))
		else
         pbPlayDecisionSE
		 @selectedSubmenu = cw.index
		 cw.safari_index = @stored_safari_indexes[getSelectionCommands[@selectedSubmenu]] || 0
         options = @battle.suboptions[command]
		 cw.safari_index = options.length-1 if cw.safari_index > options.length-1
		 
		 pbSafariSetSubcommands(command, cw)
		 @stored_cw_index = cw.index
		 cw.index = -1 
		 @subMenuOpen = true 
		end 
      end
  end
  
  def pbSafariSubmenuCommands(oldIndex, cw)
      pbSafariSetSubcommands(getSelectionCommands[@selectedSubmenu], cw)
	  options = @battle.suboptions[getSelectionCommands[@selectedSubmenu]]
      if Input.trigger?(Input::LEFT)
         cw.safari_index -= 1
         cw.safari_index = options.length - 1 if cw.safari_index < 0
      elsif Input.trigger?(Input::RIGHT)
         cw.safari_index += 1
         cw.safari_index = 0 if cw.safari_index >= options.length
      end
      #@battle.index = cw.index
      pbPlayCursorSE if cw.safari_index != oldIndex      # Actions
      if Input.trigger?(Input::USE)
	    ret = cw.safari_index
	    return ret
	  elsif Input.trigger?(Input::BACK)
		 @stored_safari_indexes[getSelectionCommands[@selectedSubmenu]] = cw.safari_index
		 @selectedSubmenu = -1
		 cw.safari_index = 0
         pbPlayCancelSE
		 cw.index = @stored_cw_index
		 @stored_cw_index = 0 
         cw.setTexts(getCommands)
		 @subMenuOpen = false  
		 return nil
      end
      return nil
  end 
  
  def pbSafariCommandMenuEx(idxBattler, mode = 3)
    pbResetSafariCommand
    texts = getCommands
    pbShowSafariWindow
    cw = @sprites["commandWindow"]
    cw.setTexts(texts)
    cw.setIndexAndMode(@lastCmd[idxBattler], mode)
    pbSelectBattler(idxBattler)
	@sprites["dataBox_0"].refresh
    ret = -1
    loop do
	  Input.update
      oldIndex = cw.index
      oldSafariIndex = cw.safari_index
      pbUpdate(cw)
      # Update selected command
	  
      @sprites["dataBox_0"].visible = ($player && $player.playerhealth > 0)
	  @sprites["dataBox_0"].refresh
	  if @subMenuOpen == false  
      pbSafariMainCommands(oldIndex, cw) 
	  else
      ret = pbSafariSubmenuCommands(oldSafariIndex, cw)
	  end
	  break if ret && ret >= 0
   end
    @battle.selected_menu = @selectedSubmenu
	@battle.index = ret
	selection = getSelectionCommands[@selectedSubmenu]
	options = @battle.suboptions[selection]
    return options[ret]
  end
  
  def pbSafariCommandMenu(index)
        pbSafariCommandMenuEx(index, 3)
					
  end

  def pbThrowBait
    @briefMessage = false
    baitAnim = Animation::ThrowBait.new(@sprites, @viewport, @battle.battlers[1])
    loop do
      baitAnim.update
      pbUpdate
      break if baitAnim.animDone?
    end
	increasedlikeness=50
	likelihood = rand(100)
	if $player.playerstamina > 90
	increasedlikeness+=30
	elsif $player.playerstamina > 75
	increasedlikeness+=10
	elsif $player.playerstamina > 50
	increasedlikeness+=10
	elsif $player.playerstamina < 25
	increasedlikeness-=10
	elsif $player.playerstamina < 10
	increasedlikeness-=20
	elsif $player.playerstamina <= 5
	increasedlikeness-=30
	end
    baitAnim.dispose
	if likelihood < increasedlikeness
       return true
	else 
	   return false
	end
  end

  def pbThrowRock
    @briefMessage = false
    rockAnim = Animation::ThrowRock.new(@sprites, @viewport, @battle.battlers[1])
    loop do
      rockAnim.update
      pbUpdate
      break if rockAnim.animDone?
    end
	increasedlikeness=30
	likelihood = rand(100)
	if $player.playerstamina > 90
	increasedlikeness+=30
	elsif $player.playerstamina > 75
	increasedlikeness+=10
	elsif $player.playerstamina > 50
	increasedlikeness+=10
	elsif $player.playerstamina < 25
	increasedlikeness-=10
	elsif $player.playerstamina < 10
	increasedlikeness-=20
	elsif $player.playerstamina <= 5
	increasedlikeness-=30
	end
    rockAnim.dispose
	if likelihood < increasedlikeness
       return true
	else 
	   return false
	end
  end

  alias __safari__pbThrowSuccess pbThrowSuccess unless method_defined?(:__safari__pbThrowSuccess)

  def pbThrowSuccess
    __safari__pbThrowSuccess
    pbWildBattleSuccess if @battle.is_a?(SafariBattle)
  end
  def pbEndCombat
  pbWildBattleSuccess
  end
def pbSafariBalls
    # Fade out and hide all sprites
    visibleSprites = pbFadeOutAndHide(@sprites)
    # Set Bag starting positions
    oldLastPocket = $bag.last_viewed_pocket
    oldChoices    = $bag.last_pocket_selections.clone
    if @bagLastPocket
      $bag.last_viewed_pocket     = @bagLastPocket
      $bag.last_pocket_selections = @bagChoices
    else
      $bag.reset_last_selections
    end
    # Start Bag screen
    itemScene = PokemonBag_Scene.new
    itemScene.pbStartScene($bag, true,
                           proc { |item| useType = GameData::Item.get(item).is_pokeball?}, false)
    # Loop while in Bag screen
    wasTargeting = false
	item = nil
    loop do
      # Select an item
      item = itemScene.pbChooseItem
      break if !item
      # Choose a command for the selected item
      item = GameData::Item.get(item)
      itemName = item.name
      useType = item.is_pokeball?
      cmdUse = -1
      commands = []
      commands[cmdUse = commands.length] = _INTL("Select") if useType && useType != 0
      commands[commands.length]          = _INTL("Cancel")
      command = itemScene.pbShowCommands(_INTL("{1} is selected.", itemName), commands)
      break if cmdUse >= 0 && command == cmdUse   # Use
    end
    @bagLastPocket = $bag.last_viewed_pocket
    @bagChoices    = $bag.last_pocket_selections.clone
    $bag.last_viewed_pocket     = oldLastPocket
    $bag.last_pocket_selections = oldChoices
    # Close Bag screen
    itemScene.pbEndScene
    # Fade back into battle screen (if not already showing it)
    pbFadeInAndShow(@sprites, visibleSprites) if !wasTargeting
	return item
  end


  def pbCanSafariRun?(battler)
    pkmn = battler.pokemon
   return false if $player.playerstamina < 15
   return true if pkmn.types.include?(:GHOST)
   return true
  end

  def closeBriefMessage
    @briefMessage = false 
    @sprites["messageWindow"].visible = false 
    @sprites["messageWindow"].text = ""
  end 


end


class Battle::Scene::CommandMenu < Battle::Scene::MenuBase
  attr_accessor :safari_index
  def initialize(viewport, z)
    super(viewport)
    self.x = 0
    self.y = Graphics.height - 96
	@safari_index = 0
    # Create message box (shows "What will X do?")
    @msgBox = Window_UnformattedTextPokemon.newWithSize(
      "", self.x + 16, self.y + 2, 220, Graphics.height - self.y, viewport
    )
    @msgBox.baseColor   = TEXT_BASE_COLOR
    @msgBox.shadowColor = TEXT_SHADOW_COLOR
    @msgBox.windowskin  = nil
    addSprite("msgBox", @msgBox)
	 if $game_temp.in_safari.nil?
	   $game_temp.in_safari=false
	 end
    if USE_GRAPHICS && $game_temp.in_safari==false
      # Create background graphic
      background = IconSprite.new(self.x, self.y, viewport)
      background.setBitmap("Graphics/Pictures/Battle/overlay_command")
      addSprite("background", background)
      # Create bitmaps
      @buttonBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/cursor_command"))
      # Create action buttons
      @buttons = Array.new(4) do |i|   # 4 command options, therefore 4 buttons
        button = Sprite.new(viewport)
        button.bitmap = @buttonBitmap.bitmap
        button.x = self.x + Graphics.width - 260
        button.x += (i.even? ? 0 : (@buttonBitmap.width / 2) - 4)
        button.y = self.y + 6
        button.y += (((i / 2) == 0) ? 0 : BUTTON_HEIGHT - 4)
        button.y -= 10 if i > 1
        button.src_rect.width  = @buttonBitmap.width / 2
        button.src_rect.height = BUTTON_HEIGHT
        addSprite("button_#{i}", button)
        next button
      end
    else
      # Create command window (shows Fight/Bag/Pokémon/Run)
      @cmdWindow = Window_CommandPokemon.newWithSize(
        [], self.x + Graphics.width - 240, self.y, 240, Graphics.height - self.y, viewport
      )
      @cmdWindow.columns       = 2
      @cmdWindow.columnSpacing = 4
      @cmdWindow.ignore_input  = true
      addSprite("cmdWindow", @cmdWindow)
    end
    self.z = z
    refresh
  end
  def setTexts(value)
    @msgBox.text = value[0]
    return if USE_GRAPHICS && $game_temp.in_safari==false
    commands = []
    (1..4).each do |i|
	commands.push(value[i]) if value[i] 
	end
    @cmdWindow.commands = commands
  end
  def refreshButtons
	 if $game_temp.in_safari.nil?
	   $game_temp.in_safari=false
	 end
    return if !USE_GRAPHICS
    return if $game_temp.in_safari==true
    @buttons.each_with_index do |button, i|
      button.src_rect.x = (i == @index) ? @buttonBitmap.width / 2 : 0
      button.src_rect.y = MODES[@mode][i] * BUTTON_HEIGHT
      button.z          = self.z + ((i == @index) ? 3 : 2)
    end
  end
  def setMsgBoxText(text)
    @msgBox.text = text
  end 
  def setCommandText(text, index)
    @cmdWindow.commands[index] =  text 
  end 
  def getText(index)
    return @msgBox.text if index==0
	return @cmdWindow.commands[index]
  end 
end

#===============================================================================
# Data box for safari battles
#===============================================================================
class Battle::Scene::SafariDataBox < Sprite
  attr_accessor :selected
  attr_reader   :animatingHP

  HP_BAR_CHANGE_TIME = 1.0
  STATUS_ICON_HEIGHT = 16
  NAME_BASE_COLOR         = Color.new(255,255,255)
  NAME_SHADOW_COLOR       = Color.new(0, 0, 0)
  MALE_BASE_COLOR         = Color.new(66, 206, 255)
  MALE_SHADOW_COLOR       = NAME_SHADOW_COLOR
  FEMALE_BASE_COLOR       = Color.new(255, 156, 148)
  FEMALE_SHADOW_COLOR     = NAME_SHADOW_COLOR
  def initialize(battle, viewport = nil)
    super(viewport)
    @battler     = $player
	@sprites = {}
    @spriteX      = Graphics.width - 232
    @spriteY      = Graphics.height - 184
    @spriteBaseX  = 24
    @selected    = 0
    @battle      = battle
    @frame        = 0
	@showHP = true 
    @animatingHP  = false
    @databox&.dispose
    @databox     = AnimatedBitmap.new("Graphics/Pictures/Battle/databox_safari")
    @spriteX      = Graphics.width - 232
    @spriteY      = Graphics.height - 184
    @spriteBaseX  = 24
	initializeOtherGraphics(viewport)
    refresh
  end
  
  def initializeOtherGraphics(viewport)
    # Create other bitmaps
    @numbersBitmap = AnimatedBitmap.new("Graphics/Pictures/Battle/icon_numbers")
    @hpBarBitmap   = AnimatedBitmap.new("Graphics/Pictures/Battle/overlay_hp")
    # Create sprite to draw HP numbers on
    @hpNumbers = BitmapSprite.new(124, 16, viewport)
#    pbSetSmallFont(@hpNumbers.bitmap)
    @sprites["hpNumbers"] = @hpNumbers
    # Create sprite wrapper that displays HP bar
    @hpBar = Sprite.new(viewport)
    @hpBar.bitmap = @hpBarBitmap.bitmap
    @hpBar.src_rect.height = @hpBarBitmap.height / 3
    @sprites["hpBar"] = @hpBar
    @contents    = BitmapWrapper.new(@databox.width, @databox.height)
    self.bitmap  = @contents
    self.visible = false
    self.z       = 50
    pbSetSystemFont(self.bitmap)
  end
  def x=(value)
    super
    @hpBar.x     = value + @spriteBaseX + 84
    @hpNumbers.x = value + @spriteBaseX + 66
  end

  def y=(value)
    super
    @hpBar.y     = value + 56
    @hpNumbers.y = value + 62
  end

  def z=(value)
    super
    @hpBar.z     = value + 1
    @hpNumbers.z = value + 2
  end
  def opacity=(value)
    super
    @sprites.each do |i|
      i[1].opacity = value if !i[1].disposed?
    end
  end
  def visible=(value)
    super
    @sprites.each do |i|
      i[1].visible = value if !i[1].disposed?
    end
  end

  QUARTER_ANIM_PERIOD = Graphics.frame_rate * 3 / 20
  
  def updatePositions(frameCounter)
    self.x = @spriteX
    self.y = @spriteY
    # Data box bobbing while Pokémon is selected
    if @selected == 1 || @selected == 2   # Choosing commands/targeted or damaged
      case (frameCounter / QUARTER_ANIM_PERIOD).floor
      when 1 then self.y = @spriteY - 2
      when 3 then self.y = @spriteY + 2
      end
    end
  end


  def color=(value)
    super
    @sprites.each do |i|
      i[1].color = value if !i[1].disposed?
    end
  end

  def hp
    return (@animatingHP) ? @currentHP : @battler.playerhealth
  end


  def dispose
    pbDisposeSpriteHash(@sprites)
    @databox.dispose
    @numbersBitmap.dispose
    @hpBarBitmap.dispose
    @contents.dispose
    super
  end

  def pbDrawNumber(number, btmp, startX, startY, align = 0)
    # -1 means draw the / character
    n = (number == -1) ? [10] : number.to_i.digits.reverse
    charWidth  = @numbersBitmap.width / 11
    charHeight = @numbersBitmap.height
    startX -= charWidth * n.length if align == 1
    n.each do |i|
      btmp.blt(startX, startY, @numbersBitmap.bitmap, Rect.new(i * charWidth, 0, charWidth, charHeight))
      startX += charWidth
    end
  end
  
  def animateHP(oldHP, newHP, rangeHP)
    @currentHP   = oldHP
    @endHP       = newHP
    @rangeHP     = rangeHP
    # NOTE: A change in HP takes the same amount of time to animate, no matter
    #       how big a change it is.
    @hpIncPerFrame = (newHP - oldHP).abs / (HP_BAR_CHANGE_TIME * Graphics.frame_rate)
    # minInc is the smallest amount that HP is allowed to change per frame.
    # This avoids a tiny change in HP still taking HP_BAR_CHANGE_TIME seconds.
    minInc = (rangeHP * 4) / (@hpBarBitmap.width * HP_BAR_CHANGE_TIME * Graphics.frame_rate)
    @hpIncPerFrame = minInc if @hpIncPerFrame < minInc
    @animatingHP   = true
  end

  def draw_status
    return if @battler.status.nil?
    return if @battler.status == :NONE
    if @battler.status == :POISON && @battler.statusCount > 0   # Badly poisoned
      s = GameData::Status.count - 1
    else
      s = GameData::Status.get(@battler.status).icon_position
    end
    return if s < 0
    pbDrawImagePositions(self.bitmap, [["Graphics/Pictures/Battle/icon_statuses", @spriteBaseX + 24, 36,
                                        0, s * STATUS_ICON_HEIGHT, -1, STATUS_ICON_HEIGHT]])
  end
  def draw_name
    base   = Color.new(255, 255, 255)
    shadow = Color.new(0, 0, 0)
    textpos = []
    textpos.push([_INTL("{1}", @battler.name), 20, 28, false, base, shadow])
    pbDrawTextPositions(self.bitmap, textpos)
  
  end 

  def refreshHP
    @hpNumbers.bitmap.clear
    # Show HP numbers
    if @showHP
      pbDrawNumber(self.hp, @hpNumbers.bitmap, 54, 2, 1)
      pbDrawNumber(-1, @hpNumbers.bitmap, 54, 2)   # / char
      pbDrawNumber(@battler.playermaxhealth, @hpNumbers.bitmap, 70, 2)
    end
    # Resize HP bar
    w = 0
    if self.hp > 0
      w = @hpBarBitmap.width.to_f * self.hp / @battler.playermaxhealth
      w = 1 if w < 1
      # NOTE: The line below snaps the bar's width to the nearest 2 pixels, to
      #       fit in with the rest of the graphics which are doubled in size.
      w = ((w / 2.0).round) * 2
    end
    @hpBar.src_rect.width = w
    hpColor = 0                                  # Green bar
    hpColor = 1 if self.hp <= @battler.playermaxhealth / 2   # Yellow bar
    hpColor = 2 if self.hp <= @battler.playermaxhealth / 4   # Red bar
    @hpBar.src_rect.y = hpColor * @hpBarBitmap.height / 3
  end
  def refresh
    self.bitmap.clear
    self.bitmap.blt(0, 0, @databox.bitmap, Rect.new(0, 0, @databox.width, @databox.height))
	draw_name
	draw_status
	refreshHP
	
  end

  def updateHPAnimation
    return if !@animatingHP
    if @currentHP < @endHP      # Gaining HP
      @currentHP += @hpIncPerFrame
      @currentHP = @endHP if @currentHP >= @endHP
    elsif @currentHP > @endHP   # Losing HP
      @currentHP -= @hpIncPerFrame
      @currentHP = @endHP if @currentHP <= @endHP
    end
    # Refresh the HP bar/numbers
    refreshHP
    @animatingHP = false if @currentHP == @endHP
  end

  def update(frameCounter = 0)
    super()
	updateHPAnimation
	updatePositions(frameCounter)
    pbUpdateSpriteHash(@sprites)
  end
end

