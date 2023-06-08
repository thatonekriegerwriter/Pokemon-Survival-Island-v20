#===============================================================================
# Core additions to Pokemon class.
#===============================================================================
class Pokemon
  def focus_style
    if !@focus_style
      case self.species
      # These species default to Passive style due to not 
      # learning any offensive moves naturally.
      when :METAPOD, :KAKUNA, :WOBBUFFET, :SILCOON, 
           :CASCOON, :WYNAUT, :SPEWPA,  :PYUKUMUKU
        return :Passive
      end
      styles = []
      GameData::Focus.each_usable { |focus| styles.push(focus.id) }
      idx = @personalID % styles.length
      @focus_style = styles[idx]
    end
    return GameData::Focus.try_get(@focus_style)
  end

  def focus_id
    return @focus_style
  end

  def focus_style=(value)
    return if value && !GameData::Focus.exists?(value)
    @focus_style = (value) ? GameData::Focus.get(value).id : value
  end
  
  alias focus_initialize initialize
  def initialize(*args)
    focus_initialize(*args)
    @focus_style = Settings::FOCUS_STYLE_DEFAULT
  end
end

#===============================================================================
# Adds focus style display to the Summary.
#===============================================================================
class PokemonSummary_Scene
  alias focus_drawPageThree drawPageThree
  def drawPageThree
    focus_drawPageThree
    return if !@pokemon.focus_style || $game_switches[Settings::NO_FOCUS_MECHANIC]
    overlay = @sprites["overlay"].bitmap
    focusbitmap = AnimatedBitmap.new(_INTL("Graphics/Plugins/Focus Meter/styles"))
    focus_number = GameData::Focus.get(@pokemon.focus_style).icon_position
    focus_rect = Rect.new(0, focus_number * 14, 174, 14)
    coords = (PluginManager.installed?("BW Summary Screen")) ? [Graphics.width - focusbitmap.bitmap.width, 286] : [238, 60]
    overlay.blt(coords[0], coords[1], focusbitmap.bitmap, focus_rect)
  end
end

#===============================================================================
# Simple "Focus Tutor" NPC Event to change focus styles of party Pokemon.
#===============================================================================
def pbFocusTrainer(gender = -1)
  g = (gender == 0) ? "\\b" : (gender == 1) ? "\\r" : ""
  if pbMapInterpreter.tsOff?("A")
    pbMessage(_INTL("#{g}...\\wt[16] ...\\wt[16] ...\\wt[16] Oh!"))
    pbMessage(_INTL("#{g}My apologies, I didn't see you there!\nI was too focused!"))
    pbMessage(_INTL("#{g}What was I focused on, you ask?\nWell, I was focused on...\\wt[8]my focus!"))
    pbMessage(_INTL("#{g}The ability to harness your focus is itself a powerful tool!\nPokémon are no different, in that regard."))
    pbMessage(_INTL("#{g}Perhaps I can teach one of your Pokémon a new way to harness its focus!"))
    pbMapInterpreter.setTempSwitchOn("A")
  else
    pbMessage(_INTL("#{g}...\\wt[16] Oh!\\wt[8]\nI didn't see you there!"))
  end
  if pbConfirmMessage(_INTL("#{g}Would you like me to retrain the focus styles of your Pokémon?"))
    pbMessage(_INTL("#{g}Very well.\nWhich Pokémon requires a change of focus?"))
    pbChooseNonEggPokemon(1, 2)
    if pbGet(1) < 0
      pbMessage(_INTL("#{g}Hmm? Changed your mind, eh?"))
      pbMessage(_INTL("#{g}Perhaps you are the one who requires focus training!"))
    else
      poke = $player.party[pbGet(1)]
      focus = GameData::Focus.try_get(poke.focus_style)
      focus = GameData::Focus.get(:None) if !focus
      pbMessage(_INTL("#{g}{1}'s focus is currently in the {2} style.", poke.name, focus.name))
      pbMessage(_INTL("#{g}Which style of focus would you prefer {1} to use?", poke.name))
      cmd    = 0
      ids    = []
      styles = []
      GameData::Focus.each_usable do |focus|
        next if focus.id == poke.focus_id
        ids[focus.icon_position]    = focus.id
        styles[focus.icon_position] = _INTL("{1}", focus.name)
      end
      ids.compact!
      styles.compact!
      styles.push(_INTL("Cancel"))
      loop do
        cmd = pbShowCommands(nil, styles, cmd)
        if cmd == styles.length - 1 || cmd < 0
          pbMessage(_INTL("#{g}Hmm? Changed your mind, eh?"))
          pbMessage(_INTL("#{g}Perhaps you are the one who requires focus training!"))
          break
        else
          $stats.total_focus_styles_changed += 1
          poke.focus_style = ids[cmd]
          pbMessage(_INTL("#{g}...\\wt[16] ...\\wt[16] ...\\wt[16] Done!"))
          pbMessage(_INTL("\\se[Pkmn move learnt]#{g}{1} shifted its focus to the {2} style!", poke.name, styles[cmd]))
          break
        end
      end
    end
  else
    pbMessage(_INTL("#{g}Ah, I see that you and your Pokemon are already focused on your goals."))
  end
  pbMessage(_INTL("#{g}Come back again if you require a change of focus!"))
end