#New Level Cap System

LEVEL_CAP_IN_OPTIONS = false #This Switch will determine whether the Level Caps Option will appear in the Options Menu


#This adds compatablilty with the Voltseon Pause Menu Plugin
#Set to true if using the Voltseon Pause Menu
VOLTSEON_PAUSE_MENU_USED = true

class PokemonSystem
  attr_accessor :level_caps
  alias initialize_caps initialize
  def initialize
    initialize_caps
    @level_caps = 0 #Level caps set to on by default
  end
  
  def level_caps
    @level_caps = 0 if @level_caps.nil?
    return @level_caps
  end
end

class Game_System
  attr_accessor :level_cap

  def level_cap
    @level_cap          = 0  if @level_cap.nil?
    return @level_cap
  end
end

#Define all your levels caps in this array. Every time you run Level_Cap.update, it will move to the next level cap in the array.

#LEVEL_CAP = [Temperate,Mountain,Ice,Water]


module Level_Cap
  LEVEL_CAP = [13,24,35,46,57,68]
  def self.update
    $game_system.level_cap += 1
    $game_system.level_cap = LEVEL_CAP.size-1 if $game_system.level_cap >= LEVEL_CAP.size
  end
end

module NavNums
  Dispose = 900 #Edit this to whatever switch you would like, it's not needed unless you're using the DexNav plugin
end

class PokemonPauseMenu_Scene
  alias pbStartSceneCap pbStartScene
  def pbStartScene
    if !VOLTSEON_PAUSE_MENU_USED
      if $game_switches[NavNums::Dispose] == false
        cap = get_level_cap(pkmn)
        @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
        @viewport.z = 99999
        @sprites = {}
        @sprites["cmdwindow"] = Window_CommandPokemon.new([])
        @sprites["cmdwindow"].visible = false
        @sprites["cmdwindow"].viewport = @viewport
        @sprites["infowindow"] = Window_UnformattedTextPokemon.newWithSize("", 0, 0, 32, 32, @viewport)
        @sprites["infowindow"].visible = false
        @sprites["helpwindow"] = Window_UnformattedTextPokemon.newWithSize("", 0, 0, 32, 32, @viewport)
        @sprites["helpwindow"].visible = false
        @sprites["levelcapwindow"] = Window_UnformattedTextPokemon.newWithSize("Level Cap: #{cap}",0,64,208,64,@viewport)
        @sprites["levelcapwindow"].visible = false
        @infostate = false
        @helpstate = false
        $close_dexnav = 0
        $sprites = @sprites
        pbSEPlay("GUI menu open")
      else
        $viewport1.dispose
        $currentDexSearch = nil
        $close_dexnav = 1
        $game_switches[NavNums::Dispose] = false
        pbSEPlay("GUI menu close")
        return
      end
    else
      pbStartSceneCap
    end
  end
  alias pbShowCommandsCap pbShowCommands
  def pbShowCommands(commands)
    if !VOLTSEON_PAUSE_MENU_USED
      if $game_switches[NavNums::Dispose] == false && $close_dexnav < 1
        ret = -1
        cmdwindow = @sprites["cmdwindow"]
        cmdwindow.commands = commands
        cmdwindow.index    = $game_temp.menu_last_choice
        cmdwindow.resizeToFit(commands)
        cmdwindow.x        = Graphics.width - cmdwindow.width
        cmdwindow.y        = 0
        cmdwindow.visible  = true
        loop do
          cmdwindow.update
          Graphics.update
          Input.update
          pbUpdateSceneMap
          if Input.trigger?(Input::BACK) || Input.trigger?(Input::ACTION)
            ret = -1
            break
          elsif Input.trigger?(Input::USE)
            ret = cmdwindow.index
            $game_temp.menu_last_choice = ret
            break
          end
        end
      else
        ret = -1
      end
      $close_dexnav -= 1
      return ret
    else
      pbShowCommandsCap(commands)
    end
  end
  def pbShowLevelCap
    if $PokemonSystem.level_caps == 0 && !$currentDexSearch
      @sprites["levelcapwindow"].visible = true if !VOLTSEON_PAUSE_MENU_USED
    end
  end
  def pbHideLevelCap
    @sprites["levelcapwindow"].visible = false if !VOLTSEON_PAUSE_MENU_USED
  end
end

class PokemonPauseMenu
  def pbShowLevelCap
    @scene.pbShowLevelCap if !VOLTSEON_PAUSE_MENU_USED
  end

  def pbHideLevelCap
    @scene.pbHideLevelCap if !VOLTSEON_PAUSE_MENU_USED
  end
  alias pbStartPokemonMenuCap pbStartPokemonMenu
  def pbStartPokemonMenu
    if !VOLTSEON_PAUSE_MENU_USED
      if !$player
        if $DEBUG
          pbMessage(_INTL("The player trainer was not defined, so the pause menu can't be displayed."))
          pbMessage(_INTL("Please see the documentation to learn how to set up the trainer player."))
        end
        return
      end
      @scene.pbStartScene
      # Show extra info window if relevant
      pbShowInfo
      if $close_dexnav != 1 && !VOLTSEON_PAUSE_MENU_USED
        $PokemonSystem.level_caps == 0 ? pbShowLevelCap : pbHideLevelCap
      end
      # Get all commands
      command_list = []
      commands = []
      MenuHandlers.each_available(:pause_menu) do |option, hash, name|
        command_list.push(name)
        commands.push(hash)
      end
      # Main loop
      end_scene = false
      loop do
        if !$currentDexSearch
          choice = @scene.pbShowCommands(command_list)
        else
          choice = -1
        end
        if choice < 0
          pbPlayCloseMenuSE if !$currentDexSearch
          end_scene = true
          break
        end
        break if commands[choice]["effect"].call(@scene)
      end
      if $close_dexnav != 0
        @scene.pbEndScene if end_scene
      end
    else
      pbStartPokemonMenuCap
    end
  end
end

def get_level_cap(pkmn)
  return pkmn.level_cap if pkmn.level_cap>0
  return Level_Cap::LEVEL_CAP[$game_system.level_cap]

end

ItemHandlers::UseOnPokemonMaximum.add(:RARECANDY, proc { |item, pkmn|
  if $PokemonSystem.level_caps == 1
    next GameData::GrowthRate.max_level - pkmn.level
  else
    next get_level_cap(pkmn) - pkmn.level
  end
})

ItemHandlers::UseOnPokemon.add(:RARECANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if $PokemonSystem.level_caps == 1
    if pkmn.level >= GameData::GrowthRate.max_level
      new_species = pkmn.check_evolution_on_level_up
      if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
        scene.pbDisplay(_INTL("It won't have any effect."))
        next false
      end
      # Check for evolution
      pbFadeOutInWithMusic {
        evo = PokemonEvolutionScene.new
        evo.pbStartScreen(pkmn, new_species)
        evo.pbEvolution
        evo.pbEndScreen
        scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
      }
      next true
    end
  else
    if pkmn.level >= get_level_cap(pkmn)
      new_species = pkmn.check_evolution_on_level_up
      if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
        scene.pbDisplay(_INTL("It won't have any effect."))
        next false
      end
      # Check for evolution
      pbFadeOutInWithMusic {
        evo = PokemonEvolutionScene.new
        evo.pbStartScreen(pkmn, new_species)
        evo.pbEvolution
        evo.pbEndScreen
        scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
      }
      next true
    end
  end
  # Level up
  pbChangeLevel(pkmn, pkmn.level + qty, scene)
  scene.pbHardRefresh
  next true
})

