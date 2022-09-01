#===============================================================================
# Revamps base Essentials code related to the Fight Menu to allow for 
# plugin compatibility.
#===============================================================================


#-------------------------------------------------------------------------------
# Revamped Fight Menu class.
#-------------------------------------------------------------------------------
class Battle::Scene::FightMenu < Battle::Scene::MenuBase
  NoButton         =-1 
  MegaButton       = 0
  UltraBurstButton = 1
  ZMoveButton      = 2
  DynamaxButton    = 3
  StylesButton     = 4
  ZodiacButton     = 5

  def initialize(viewport, z)
    super(viewport)
    self.x = 0
    self.y = Graphics.height - 96
    @battler   = nil
    @shiftMode = 0
    @focusMode = 0
    if USE_GRAPHICS
      @buttonBitmap  = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/cursor_fight"))
      @typeBitmap    = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
      @shiftBitmap   = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/cursor_shift"))
      @battleButtonBitmap = {}
      @battleButtonBitmap[MegaButton] = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/cursor_mega"))
      if PluginManager.installed?("ZUD Mechanics")
        path = "Graphics/Plugins/ZUD/Battle/"
        @battleButtonBitmap[UltraBurstButton] = AnimatedBitmap.new(path + "cursor_ultra")
        @battleButtonBitmap[ZMoveButton]      = AnimatedBitmap.new(path + "cursor_zmove")
        @battleButtonBitmap[DynamaxButton]    = AnimatedBitmap.new(path + "cursor_dynamax")
      end
      if PluginManager.installed?("PLA Battle Styles")
        path = "Graphics/Plugins/PLA Battle Styles/"
        @battleButtonBitmap[StylesButton]     = AnimatedBitmap.new(path + "cursor_styles")
      end
      if PluginManager.installed?("Pokémon Birthsigns")
        path = "Graphics/Plugins/Birthsigns/"
        @battleButtonBitmap[ZodiacButton]     = AnimatedBitmap.new(path + "cursor_zodiac")
      end
      @chosen_button = NoButton
      background = IconSprite.new(0, Graphics.height - 96, viewport)
      background.setBitmap("Graphics/Pictures/Battle/overlay_fight")
      addSprite("background", background)
      @buttons = Array.new(Pokemon::MAX_MOVES) do |i|
        button = SpriteWrapper.new(viewport)
        button.bitmap = @buttonBitmap.bitmap
        button.x = self.x + 4
        button.x += (i.even? ? 0 : (@buttonBitmap.width / 2) - 4)
        button.y = self.y + 6
        button.y += (((i / 2) == 0) ? 0 : BUTTON_HEIGHT - 4)
        button.src_rect.width  = @buttonBitmap.width / 2
        button.src_rect.height = BUTTON_HEIGHT
        addSprite("button_#{i}", button)
        next button
      end
      @overlay = BitmapSprite.new(Graphics.width, Graphics.height - self.y, viewport)
      @overlay.x = self.x
      @overlay.y = self.y
      pbSetNarrowFont(@overlay.bitmap)
      addSprite("overlay", @overlay)
      @infoOverlay = BitmapSprite.new(Graphics.width, Graphics.height - self.y, viewport)
      @infoOverlay.x = self.x
      @infoOverlay.y = self.y
      pbSetNarrowFont(@infoOverlay.bitmap)
      addSprite("infoOverlay", @infoOverlay)
      @typeIcon = SpriteWrapper.new(viewport)
      @typeIcon.bitmap = @typeBitmap.bitmap
      @typeIcon.x      = self.x + 416
      @typeIcon.y      = self.y + 20
      @typeIcon.src_rect.height = TYPE_ICON_HEIGHT
      addSprite("typeIcon", @typeIcon)
      @battleButton = SpriteWrapper.new(viewport) # For button graphic
      addSprite("battleButton", @battleButton)
      @shiftButton = SpriteWrapper.new(viewport)
      @shiftButton.bitmap = @shiftBitmap.bitmap
      @shiftButton.x      = self.x + 4
      @shiftButton.y      = self.y - @shiftBitmap.height
      addSprite("shiftButton", @shiftButton)
      if PluginManager.installed?("Focus Meter System")
        path = "Graphics/Plugins/Focus Meter/"
        @focusBitmap = AnimatedBitmap.new(path + "cursor_focus")
        @focusButton = SpriteWrapper.new(viewport)
        @focusButton.bitmap = @focusBitmap.bitmap
        @focusButton.x      = self.x + 4
        @focusButton.y      = self.y - @focusBitmap.height / 2
        @focusButton.src_rect.height = @focusBitmap.height / 2
        addSprite("focusButton", @focusButton)
      end
    else
      @msgBox = Window_AdvancedTextPokemon.newWithSize(
        "", self.x + 320, self.y, Graphics.width - 320, Graphics.height - self.y, viewport
      )
      @msgBox.baseColor   = TEXT_BASE_COLOR
      @msgBox.shadowColor = TEXT_SHADOW_COLOR
      pbSetNarrowFont(@msgBox.contents)
      addSprite("msgBox", @msgBox)
      @cmdWindow = Window_CommandPokemon.newWithSize(
        [], self.x, self.y, 320, Graphics.height - self.y, viewport
      )
      @cmdWindow.columns       = 2
      @cmdWindow.columnSpacing = 4
      @cmdWindow.ignore_input  = true
      pbSetNarrowFont(@cmdWindow.contents)
      addSprite("cmdWindow", @cmdWindow)
    end
    self.z = z
  end
  
  def dispose
    super
    @buttonBitmap&.dispose
    @typeBitmap&.dispose
    @battleButtonBitmap.each { |k, bmp| bmp&.dispose}
    @shiftBitmap&.dispose
    @focusBitmap&.dispose if PluginManager.installed?("Focus Meter System")
  end
  
  def chosen_button=(value)
    oldValue = @chosen_button
    @chosen_button = value
    refresh if @chosen_button != oldValue
  end
  
  def refreshBattleButton
    return if !USE_GRAPHICS
    if @chosen_button == NoButton
      @visibility["battleButton"] = false
      return
    end
    @battleButton.bitmap = @battleButtonBitmap[@chosen_button].bitmap
    @battleButton.x = self.x + 120
    @battleButton.y = self.y - @battleButtonBitmap[@chosen_button].height / 2
    @battleButton.src_rect.height = @battleButtonBitmap[@chosen_button].height / 2
    @battleButton.src_rect.y = (@mode - 1) * @battleButtonBitmap[@chosen_button].height / 2
    mode = @shiftMode + @focusMode
    @battleButton.x = self.x + ((mode > 0) ? 204 : 120)
    @battleButton.z = self.z - 1
    @visibility["battleButton"] = (@mode > 0)
  end
  
  def refreshButtonNames
    moves = (@battler) ? @battler.moves : []
    if !USE_GRAPHICS
      commands = []
      [4, moves.length].max.times do |i|
        commands.push((moves[i]) ? moves[i].short_name : "-")
      end
      @cmdWindow.commands = commands
      return
    end
    @overlay.bitmap.clear
    textPos = []
    @buttons.each_with_index do |button, i|
      next if !@visibility["button_#{i}"]
      x = button.x - self.x + (button.src_rect.width / 2)
      y = button.y - self.y + 14
      moveNameBase = TEXT_BASE_COLOR
      if GET_MOVE_TEXT_COLOR_FROM_MOVE_BUTTON && moves[i].display_type(@battler)
        moveNameBase = button.bitmap.get_pixel(10, button.src_rect.y + 34)
      end
      textPos.push([moves[i].short_name, x, y, 2, moveNameBase, TEXT_SHADOW_COLOR])
    end
    pbDrawTextPositions(@overlay.bitmap, textPos)
  end

  def refresh
    return if !@battler
    refreshSelection
    refreshBattleButton
    refreshShiftButton
    refreshFocusButton if PluginManager.installed?("Focus Meter System")
    refreshButtonNames
  end
end

def pbPlayBattleButton
  if FileTest.audio_exist?("Audio/SE/GUI ZUD Button")
    pbSEPlay("GUI ZUD Button", 80)
  else
    pbPlayDecisionSE
  end
end


#-------------------------------------------------------------------------------
# Toggles battle mechanics in the fight menu.
#-------------------------------------------------------------------------------
class Battle
  def pbFightMenu(idxBattler)
    return pbAutoChooseMove(idxBattler) if !pbCanShowFightMenu?(idxBattler)
    return true if pbAutoFightMenu(idxBattler)
    ret = false
    p1 = pbCanMegaEvolve?(idxBattler)
    p2 = (PluginManager.installed?("ZUD Mechanics"))      ? pbCanUltraBurst?(idxBattler)  : false
    p3 = (PluginManager.installed?("ZUD Mechanics"))      ? pbCanZMove?(idxBattler)       : false
    p4 = (PluginManager.installed?("ZUD Mechanics"))      ? pbCanDynamax?(idxBattler)     : false
    p5 = (PluginManager.installed?("PLA Battle Styles"))  ? pbCanStrongStyle?(idxBattler) : false
    p6 = (PluginManager.installed?("PLA Battle Styles"))  ? pbCanAgileStyle?(idxBattler)  : false
    p7 = (PluginManager.installed?("Pokémon Birthsigns")) ? pbCanZodiacPower?(idxBattler) : false
    @scene.pbFightMenu(idxBattler, p1, p2, p3, p4, p5, p6, p7) { |cmd|
      case cmd
      when -1   # Cancel
      when -2   # Mega Evolution
        pbToggleRegisteredMegaEvolution(idxBattler)
        next false
      when -3   # Ultra Burst
        pbToggleRegisteredUltraBurst(idxBattler)  if PluginManager.installed?("ZUD Mechanics")
        next false
      when -4   # Z-Moves
        pbToggleRegisteredZMove(idxBattler)       if PluginManager.installed?("ZUD Mechanics")
        next false
      when -5   # Dynamax
        pbToggleRegisteredDynamax(idxBattler)     if PluginManager.installed?("ZUD Mechanics")
        next false
      when -6   # Strong Style
        pbToggleRegisteredStrongStyle(idxBattler) if PluginManager.installed?("PLA Battle Styles")
        next false
      when -7   # Agile Style
        pbToggleRegisteredAgileStyle(idxBattler)  if PluginManager.installed?("PLA Battle Styles")
        next false
      when -8   # Zodiac Powers
        pbToggleRegisteredZodiacPower(idxBattler) if PluginManager.installed?("Pokémon Birthsigns")
        next false
      when -9   # Focus
        pbToggleRegisteredFocus(idxBattler)       if PluginManager.installed?("Focus Meter System")
        next false
      when -10  # Shift
        pbUnregisterMegaEvolution(idxBattler)
        if PluginManager.installed?("ZUD Mechanics")
          pbUnregisterUltraBurst(idxBattler)
          pbUnregisterZMove(idxBattler)
          pbUnregisterDynamax(idxBattler)
          @battlers[idxBattler].power_trigger = false
          @battlers[idxBattler].display_base_moves
        end
        pbUnregisterStyle(idxBattler)       if PluginManager.installed?("PLA Battle Styles")
        pbUnregisterZodiacPower(idxBattler) if PluginManager.installed?("Pokémon Birthsigns")
        pbUnregisterFocus(idxBattler)       if PluginManager.installed?("Focus Meter System")
        pbRegisterShift(idxBattler)
        ret = true
      else
        next false if cmd < 0 || !@battlers[idxBattler].moves[cmd] ||
                      !@battlers[idxBattler].moves[cmd].id
        next false if !pbRegisterMove(idxBattler, cmd)
        next false if !singleBattle? &&
                      !pbChooseTarget(@battlers[idxBattler], @battlers[idxBattler].moves[cmd])
        ret = true
      end
      next true
    }
    return ret
  end
end


#-------------------------------------------------------------------------------
# Revamped Fight Menu scene.
#-------------------------------------------------------------------------------
class Battle::Scene
  def mechanic_params(*params)
    data = {
      :mega     => params[0] || false,
      :ultra    => params[1] || false,
      :zmove    => params[2] || false,
      :dynamax  => params[3] || false,
      :style    => (params[4] || params[5]) || false,
      :zodiac   => params[6] || false
    }
    return data
  end
  
  def pbFightMenu(idxBattler, *params)
    data = mechanic_params(*params)
    battler = @battle.battlers[idxBattler]
    cw = @sprites["fightWindow"]
    cw.battler = battler
    moveIndex  = 0
    if battler.moves[@lastMove[idxBattler]]&.id
      moveIndex = @lastMove[idxBattler]
    end
    cw.shiftMode = (@battle.pbCanShift?(idxBattler)) ? 1 : 0
    if PluginManager.installed?("Focus Meter System")
      cw.focusMode = (@battle.pbCanUseFocus?(idxBattler)) ? 1 : 0
    end
    mechanicPossible = false
    cw.chosen_button = Battle::Scene::FightMenu::NoButton
    cw.chosen_button = Battle::Scene::FightMenu::MegaButton       if data[:mega]
    cw.chosen_button = Battle::Scene::FightMenu::UltraBurstButton if data[:ultra]
    cw.chosen_button = Battle::Scene::FightMenu::ZMoveButton      if data[:zmove]
    cw.chosen_button = Battle::Scene::FightMenu::DynamaxButton    if data[:dynamax]
    cw.chosen_button = Battle::Scene::FightMenu::StyleButton      if data[:style]
    cw.chosen_button = Battle::Scene::FightMenu::ZodiacButton     if data[:zodiac]
    mechanicPossible = (data[:mega] || data[:ultra] || data[:zmove] || data[:dynamax] || data[:style] || data[:zodiac])
    cw.setIndexAndMode(moveIndex, (mechanicPossible) ? 1 : 0)
    needFullRefresh = true
    needRefresh = false
    loop do
      if needFullRefresh
        pbShowWindow(FIGHT_BOX)
        pbSelectBattler(idxBattler)
        needFullRefresh = false
      end
      if needRefresh
        if data[:mega]
          newMode = (@battle.pbRegisteredMegaEvolution?(idxBattler)) ? 2 : 1
          cw.mode = newMode if newMode != cw.mode
        end
        if data[:ultra]
          newMode = (@battle.pbRegisteredUltraBurst?(idxBattler)) ? 2 : 1
          cw.mode = newMode if newMode != cw.mode
        end
        if data[:zmove]
          newMode = (@battle.pbRegisteredZMove?(idxBattler)) ? 2 : 1
          cw.mode = newMode if newMode != cw.mode
        end
        if data[:dynamax]
          newMode = (@battle.pbRegisteredDynamax?(idxBattler)) ? 2 : 1
          cw.mode = newMode if newMode != cw.mode
        end
        if data[:style]
          newMode = (@battle.pbRegisteredStyle?(idxBattler)) ? 2 : 1
          cw.mode = newMode if newMode != cw.mode
        end
        if data[:zodiac]
          newMode = (@battle.pbRegisteredZodiacPower?(idxBattler)) ? 2 : 1
          cw.mode = newMode if newMode != cw.mode
        end
        needRefresh = false
      end
      oldIndex = cw.index
      pbUpdate(cw)
      if Input.trigger?(Input::LEFT)
        cw.index -= 1 if (cw.index & 1) == 1
      elsif Input.trigger?(Input::RIGHT)
        if battler.moves[cw.index + 1]&.id && (cw.index & 1) == 0
          cw.index += 1
        end
      elsif Input.trigger?(Input::UP)
        cw.index -= 2 if (cw.index & 2) == 2
      elsif Input.trigger?(Input::DOWN)
        if battler.moves[cw.index + 2]&.id && (cw.index & 2) == 0
          cw.index += 2
        end
      end
      if cw.index != oldIndex
        pbPlayCursorSE
      end
      #=========================================================================
      # Confirm Selection
      #=========================================================================
      if Input.trigger?(Input::USE)
        # Z-Move fails if held crystal and selected move are incompatible.
        if data[:zmove]
          if cw.mode == 2
            itemname = battler.item.name
            movename = battler.moves[cw.index].name
            if !battler.hasCompatibleZMove?(battler.moves[cw.index])
              @battle.pbDisplay(_INTL("{1} is not compatible with {2}!", movename, itemname))
              if battler.power_trigger
                battler.power_trigger = false
                battler.display_base_moves
              end
              break if yield -1
            end
          end
        # Style fails if selected move has not yet been mastered.
        elsif data[:style]
          if cw.mode == 2
            movename = battler.moves[cw.index].name
            if !battler.moves[cw.index].mastered?
              @battle.pbDisplay(_INTL("{1} needs to be mastered first before it may be used in that style!", movename))
              if battler.power_trigger
                battler.power_trigger = false
                battler.display_base_moves
              end
              break if yield -1
            end
          end
        elsif data[:ultra]
          battler.power_trigger = false
        end
        pbPlayDecisionSE
        break if yield cw.index
        needFullRefresh = true
        needRefresh = true
      #=========================================================================
      # Cancel Selection
      #=========================================================================
      elsif Input.trigger?(Input::BACK)
        if data[:zmove] || data[:style]
          battler.display_base_moves if battler.power_trigger
          battler.power_trigger = false
        elsif data[:dynamax]
          if battler.power_trigger && !battler.dynamax?
            battler.display_base_moves
            battler.power_trigger = false
          end
        elsif data[:ultra]
          battler.power_trigger = false
        end
        pbPlayCancelSE
        break if yield -1
        needRefresh = true
      #=========================================================================
      # Toggle Battle Mechanic
      #=========================================================================
      elsif Input.trigger?(Input::ACTION)
        #-----------------------------------------------------------------------
        # Mega Evolution
        #-----------------------------------------------------------------------
        if data[:mega]
          pbPlayBattleButton
          break if yield -2
          needRefresh = true
        end
        #-----------------------------------------------------------------------
        # Ultra Burst
        #-----------------------------------------------------------------------
        if data[:ultra]
          battler.power_trigger = !battler.power_trigger
          if battler.power_trigger
            pbPlayBattleButton
          else
            pbPlayCancelSE
          end
          break if yield -3
          needRefresh = true
        end
        #-----------------------------------------------------------------------
        # Z-Moves
        #-----------------------------------------------------------------------
        if data[:zmove]
          battler.power_trigger = !battler.power_trigger
          if battler.power_trigger
            battler.display_power_moves("Z-Move")
            pbPlayBattleButton
          else
            battler.display_base_moves
            pbPlayCancelSE
          end
          needFullRefresh = true
          break if yield -4
          needRefresh = true
        end
        #-----------------------------------------------------------------------
        # Dynamax
        #-----------------------------------------------------------------------
        if data[:dynamax]
          battler.power_trigger = !battler.power_trigger
          if battler.power_trigger
            battler.display_power_moves("Max Move")
            pbPlayBattleButton
          else
            battler.display_base_moves
            pbPlayCancelSE
          end
          needFullRefresh = true
          break if yield -5
          needRefresh = true
        end
        #-----------------------------------------------------------------------
        # Battle Styles
        #-----------------------------------------------------------------------
        if data[:style]
          battler.power_trigger = !battler.power_trigger
          style = battler.battle_style
          if battler.power_trigger
            battler.display_style_moves(style)
            pbPlayBattleButton
          else
            battler.display_base_moves
            pbPlayCancelSE
          end
          needFullRefresh = true
          case style
          when 1 then break if yield -6
          when 2 then break if yield -7
          end
          needRefresh = true
        end
        #-----------------------------------------------------------------------
        # Zodiac Power
        #-----------------------------------------------------------------------
        if data[:zodiac]
          pbPlayBattleButton
          break if yield -8
          needRefresh = true
        end
      #=========================================================================
      # Shift
      #=========================================================================
      elsif Input.trigger?(Input::SPECIAL)
        if cw.shiftMode > 0
          pbPlayDecisionSE
          break if yield -10
          needRefresh = true
        end
      end
      #=========================================================================
      # Other Commands
      #=========================================================================
      if PluginManager.installed?("Focus Meter System")
        if Input.triggerex?(Settings::FOCUS_TRIGGER_KEY)
          case cw.focusMode
          when 1
            cw.focusMode = 2
            pbPlayDecisionSE
          when 2
            cw.focusMode = 1
            pbPlayCancelSE
          end
          break if yield -9
          needRefresh = true
        elsif Input.triggerex?(Settings::FOCUS_PANEL_KEY)
          pbToggleFocusPanel
        end
      end
    end
    pbToggleFocusPanel(false) if PluginManager.installed?("Focus Meter System")
    @lastMove[idxBattler] = cw.index
  end
end