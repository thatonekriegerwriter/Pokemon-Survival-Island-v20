#===============================================================================
#  New animated and modular Title Screen for Pokemon Essentials
#    by Luka S.J.
#
#  ONLY FOR Essentials v19.x
# ----------------
#  Adds new visual styles to the Pokemon Essentials title screen, and animates
#  depending on the styles selected.
#
#  A lot of time and effort went into making this an extensive and comprehensive
#  resource. So please be kind enough to give credit when using it.
#===============================================================================



class MainMenuSounds
 attr_accessor :memorized_bgm
 attr_accessor :memorized_bgm_position

end
def isthereagift
  if !nil_or_empty?(MysteryGift::URL)
    string = pbDownloadToString(MysteryGift::URL)
    return !nil_or_empty?(string)
  else
    return false
  end
end

def pbPauseBGM
  if $game_system.is_a?(Game_System)
    if !$game_temp.memorized_bgm
      $game_temp.memorized_bgm = $game_system.getPlayingBGM
      pbBGMStop
    end
  end
end

def pbResumeBGM
  if $game_system.is_a?(Game_System)
    if $game_temp.memorized_bgm
      playingBGM = $game_temp.memorized_bgm
      pbBGMPlay(playingBGM)
    end
  end
end

def pbPlayIntroVideo
  pbPlayVideo("Movies/#{IntroConfig::VIDEO_NAME}.ogv",IntroConfig::VIDEO_VOLUME,IntroConfig::VIDEO_CANCELABLE)
end

def pbPlayVideo(movie, volume, cancelable)
  pbPauseBGM
  $mouse.hide
  pbBGMStop if $game_system.getPlayingBGM
  # only play the movie once we've confirmed the BGM has actually stopped
  Graphics.play_movie(movie, volume, cancelable) unless $game_system.getPlayingBGM
  $mouse.show
  pbResumeBGM
end

class Scene_Intro
    attr_accessor :viewport
  #-----------------------------------------------------------------------------
  # load the title screen
  #-----------------------------------------------------------------------------
  def main
    Graphics.show_cursor = false
    Graphics.transition(0)
    siGetMetaData if $meta.nil?
    # refresh input
    Input.update
    # Loads up a species cry for the title screen
    species = ModularTitle::SPECIES
    species = species.upcase.to_sym if species.is_a?(String)
    species = GameData::Species.get(species).id
    @selected_file = SaveData.get_newest_save_slot
    @newest_file = SaveData.get_newest_save_slot
    @newest_data = {}
    @newest_data = SaveData.read_summary(@newest_file) || {} if @selected_file
    @index = 0
    @main_loop = true
    @demo_timer = 0
    @save_data = {}
    @cry = species.nil? ? nil : GameData::Species.cry_filename(species, ModularTitle::SPECIES_FORM)
    # Cycles through the intro pictures
    @skip = false
    self.cyclePics
    # loads the modular title screen
    @screen = ModularTitleScreen.new
    @viewport = @screen.viewport
    # Plays defined title screen BGM
    # Plays the title screen intro (is skippable)
    @screen.intro
    # Creates/updates the main title screen loop
    loop do
      result = self.update
      break if result == true
    end
    Graphics.freeze if @main_loop == false
  end

  #-----------------------------------------------------------------------------
  # main update loop
  #-----------------------------------------------------------------------------
  def update
    return if @main_loop == false
    ret = 0
    handle_saves
    pbValidateGameVersionAndUpdate() if (GameVersion::POKE_UPDATER_CONFIG['FORCE_UPDATE'] == true || forcetheupdate) && getUpdate && GameVersion::ENABLED
    loop do
      @screen.update
      Graphics.update
      Input.update
      @demo_timer += 1
      if Input.trigger?(Input::USE)
        ret = 2
        break
      end
      if @demo_timer > 270 * Graphics.frame_rate
        @demo_timer = 0
        ret = 1
        break
      end
    end

    case ret
    when 1
    #  pbFadeOutIn { @screen.hide }
    #  pbPlayIntroVideo
    #  pbFadeOutIn { @screen.show }
      return false
    when 2
      closeTitle
      return true if @main_loop == false
      return false if @main_loop == true
    end
  end
  #-----------------------------------------------------------------------------
  # close title screen and dispose of elements
  #-----------------------------------------------------------------------------
  # The main menu's command list depends on save-game state (Continue/Load Game only
  # show up if a save exists), so its entries and their indices can change while the
  # menu is open. Building it as (key, label, enabled) tuples lets indices always be
  # looked up fresh via commands.index(label) instead of being tracked by hand — see
  # cmd_indices_for below. (The old version kept ~9 separate cmd_* index variables in
  # sync manually, decrementing each one whenever an earlier entry was removed; easy
  # to get out of sync if a new command was ever added and someone missed a spot.)
  def command_definitions(show_continue, real_save_file_list)
    [
      [:continue, _INTL('Continue Game'), show_continue],
      [:load_game, _INTL('Load Game'), show_continue && real_save_file_list.length > 1 && @save_data[:hardcore] == false],
      [:new_game, _INTL('New Game'), true],
      [:update, _INTL('Check for Updates'), getUpdate && GameVersion::ENABLED],
      [:quit, _INTL('Quit Game'), true],
      [:language, _INTL('Language'), Settings::LANGUAGES.length >= 2],
      [:debug, _INTL('Debug'), $DEBUG],
      [:options, _INTL('Options'), true],
    ]
  end

  # builds the initial commands array from the enabled definitions
  def build_commands(defs)
    commands = []
    defs.each { |_key, label, enabled| commands << label if enabled }
    commands
  end

  # looks up each definition's current position in commands (nil if no longer present)
  def cmd_indices_for(commands, defs)
    indices = {}
    defs.each { |key, label, _enabled| indices[key] = commands.index(label) }
    indices
  end

  def closeTitle
    save_file_list = SaveData.getSlots
    real_save_file_list = SaveData.get_all_saves
    pbSEPlay("XATU", 100, 100)
    if getSIDataStatus("classicTitleScreen") == 1
      originalBehavior
    else
      @screen.depth(1)
      @save_data = @selected_file ? (SaveData.read_summary(@selected_file) || {}) : {}
      show_continue = !@save_data.empty?

      defs = command_definitions(show_continue, real_save_file_list)
      commands = build_commands(defs)
      cmd = cmd_indices_for(commands, defs)
      @screen.set_text("currentSelection", commands[@index])

      loop do
        @screen.update
        Graphics.update
        Input.update

        show_continue = !@save_data.empty?

        if @save_data.empty? && SaveData.get_all_saves.length < 2 && commands.include?(_INTL('Load Game'))
          commands.delete(_INTL('Load Game'))
          @screen.generic_update("currentSelection", commands[@index])
          cmd = cmd_indices_for(commands, defs)
        end
        if @save_data.empty? && commands.include?(_INTL('Continue Game'))
          commands.delete(_INTL('Continue Game'))
          @screen.generic_update("currentSelection", commands[@index])
          cmd = cmd_indices_for(commands, defs)
        end

        @demo_timer += 1
        main_selection_loop(save_file_list, real_save_file_list, commands, cmd[:continue], show_continue,
                             cmd[:load_game], cmd[:new_game], cmd[:update], cmd[:options], cmd[:language],
                             cmd[:mystery_gift], cmd[:debug], cmd[:quit])

        break if @main_loop == false
        if @main_loop == "goback!"
          @screen.depth(0)
          @index = 0
          @main_loop = true
          break
        end
      end
    end
  end

  def load_save_file(file_path)
    return {} if file_path=="Saves/.rxdata"
    save_data = SaveData.read_from_file(file_path)
    unless SaveData.valid?(save_data)
      if File.file?(file_path + ".bak")
        pbMessage(_INTL("The save file is corrupt. A backup will be loaded."))
        save_data = load_save_file(file_path + ".bak")
      else
        prompt_save_deletion(file_path)
        return {}
      end
    end
	
    return save_data
  end
  def selection_box_stuff(thecommands)
    curselection = 0
    loop do
      @screen.update
      Graphics.update
      Input.update
      if Input.trigger?(Input::UP) || Input.repeat?(Input::UP) || Input.scroll_v == 1
        curselection = (curselection - 1 < 0) ? thecommands.length - 1 : curselection - 1
        pbPlayDecisionSE
        @screen.move_selector_arrow(curselection)
      elsif Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN) || Input.scroll_v == -1
        curselection = (curselection + 1 >= thecommands.length) ? 0 : curselection + 1
        pbPlayDecisionSE
        @screen.move_selector_arrow(curselection)
      elsif Input.trigger?(Input::USE)
        @screen.pbChoiceBox()
        return curselection
      elsif Input.trigger?(Input::BACK)
        @screen.pbChoiceBox()
        return nil
      end
    end
  end

  def select_this_file(file)
    command3 = 0
    if file[:player].mystery_gift_unlocked && isthereagift
      thecommands = [_INTL("Play"), _INTL("Mystery Gift")]
      @screen.pbChoiceBox(thecommands)
      command3 = selection_box_stuff(thecommands)
      if command3 == 1
        pbFadeOutIn { pbDownloadMysteryGift(file[:player]) }
        return
      end
    end
    if command3 == 0
      @screen.update
      Graphics.update
      Input.update
      pbSEPlay("GUI trainer card open", 100, 100)
      pbFadeOutIn do
        disposeTitle
        @main_loop = false
        file[:player].autosave_steps = 0
        Game.load(file)
        return
      end
    end
    return
  end

  def select_difficulty
    thecommands = [_INTL("Very Easy"), _INTL("Easy"), _INTL("Normal"), _INTL("Hard"), _INTL("Very Hard"), _INTL("Cancel")]
    @screen.pbChoiceBox(thecommands)
    command3 = selection_box_stuff(thecommands)
    # [difficulty, nuzlockemode, survivalmode] per selection; Very Easy also turns on
    # nuzlocke/survival modes, the rest only change the difficulty number.
    settings = {0 => [1, 1, 1], 1 => [2, 0, 0], 2 => [3, 0, 0], 3 => [4, 0, 0], 4 => [5, 0, 0]}[command3]
    return false if settings.nil?
    $PokemonSystem.difficulty, $PokemonSystem.nuzlockemode, $PokemonSystem.survivalmode = settings
    true
  end





  # true if the mouse is within a small margin of the given sprite's bounding box
  def mouse_over?(sprite)
    Input.mouse_x.between?(sprite.x - 10, sprite.x + sprite.width + 10) &&
      Input.mouse_y.between?(sprite.y - 10, sprite.y + sprite.height + 10)
  end

  # Moves the selection index one step left/right (wrapping around), plays the SE,
  # animates the matching arrow, and refreshes the save-file display. This replaces
  # four blocks in main_selection_loop that duplicated this logic for keyboard-left,
  # keyboard-right, mouse-click-on-arrowr, and mouse-click-on-arrowl.
  def move_selection(direction, commands)
    if direction == :left
      @index = (@index - 1 < 0) ? commands.length - 1 : @index - 1
      pbPlayDecisionSE
      @screen.move_arrowl("currentSelection", commands[@index])
    else
      @index = (@index + 1 == commands.length) ? 0 : @index + 1
      pbPlayDecisionSE
      @screen.move_arrowr("currentSelection", commands[@index])
    end
    @screen.displayboxdisplaymeasavefile
    @demo_timer = 0
  end

  # The save-file browsing sub-loop opened after pressing USE on Continue or Load Game.
  # allow_cycle: Load Game lets you page between save slots with Left/Right; Continue
  #   only ever shows the newest file, so it has no cycling and no LEFT/RIGHT branch.
  # dispose_before_select: Load Game disposes the title screen before opening the
  #   chosen file; Continue instead plays the decision SE and disposes later (inside
  #   select_this_file's own flow). This mirrors each branch's original behavior.
  def run_file_selection_loop(cmd, save_file_list, allow_cycle:, dispose_before_select:)
    loop do
      @screen.update
      Graphics.update
      Input.update
      if Input.trigger?(Input::USE)
        if dispose_before_select
          disposeTitle
        else
          pbPlayDecisionSE
        end
        # @save_data is only the lightweight preview summary while browsing — actually
        # loading the game needs the real, full save data, so that's fetched fresh here,
        # exactly once, right before handing off.
        select_this_file(load_save_file(SaveData.get_full_path(@selected_file)))
        break
      elsif Input.triggerex?(:DELETE)
        # Load Game blanks the display before the confirmation prompt; Continue doesn't
        # (kept from the original — Continue's box is already showing the single newest
        # file, Load Game's box can be showing any slot in the list).
        @screen.displayboxdisplaymeasavefile if allow_cycle
        file_path = SaveData.get_full_path(@selected_file)
        prompt_save_deletion_manual(file_path, @selected_file)
        file = SaveData.get_newest_save_slot
        if !file.nil?
          @newest_file = file
          @selected_file = file
          @newest_data = SaveData.read_summary(@newest_file) || {}
          @save_data = SaveData.read_summary(@selected_file) || {}
          @screen.displayboxdisplaymeasavefile(@save_data, cmd, @selected_file)
        else
          # no saves left at all — clear the box and drop back out to the main menu
          @newest_file = nil
          @selected_file = nil
          @newest_data = {}
          @save_data = {}
          @screen.displayboxdisplaymeasavefile
          break
        end
      elsif allow_cycle && Input.trigger?(Input::LEFT)
        @selected_file = SaveData.get_prev_slot(save_file_list, @selected_file)
        @save_data = SaveData.read_summary(@selected_file) || {}
        @screen.displayboxdisplaymeasavefile(1)
        pbPlayDecisionSE
        @screen.move_arrowl2(@save_data, cmd, @selected_file)
      elsif allow_cycle && Input.trigger?(Input::RIGHT)
        @selected_file = SaveData.get_next_slot(save_file_list, @selected_file)
        @save_data = SaveData.read_summary(@selected_file) || {}
        @screen.displayboxdisplaymeasavefile(1)
        pbPlayDecisionSE
        @screen.move_arrowr2(@save_data, cmd, @selected_file)
      elsif Input.trigger?(Input::BACK)
        @screen.displayboxdisplaymeasavefile
        break
      end
    end
  end

  def main_selection_loop(save_file_list,real_save_file_list,commands,cmd_continue,show_continue,cmd_load_game,cmd_new_game,cmd_update,cmd_options,cmd_language,cmd_mystery_gift,cmd_debug,cmd_quit)
    if Input.trigger?(Input::LEFT) || Input.repeat?(Input::LEFT) || Input.triggerex?(0x25) || Input.repeatex?(0x25)
      move_selection(:left, commands)
    elsif Input.trigger?(Input::RIGHT) || Input.repeat?(Input::RIGHT) || Input.triggerex?(0x27) || Input.repeatex?(0x27)
      move_selection(:right, commands)
    elsif Input.trigger?(Input::USE) && mouse_over?(@screen.sprites2["arrowr"])
      move_selection(:right, commands)
    elsif Input.trigger?(Input::USE) && mouse_over?(@screen.sprites2["arrowl"])
      move_selection(:left, commands)
   elsif Input.trigger?(Input::USE)
      @demo_timer = 0
      case @index
      when cmd_continue
        if !@save_data.empty?
          pbPlayDecisionSE
          @screen.displayboxdisplaymeasavefile(@newest_data, commands[cmd_continue], @newest_file)
          run_file_selection_loop(commands[cmd_continue], save_file_list, allow_cycle: false, dispose_before_select: false)
        end
      when cmd_load_game
        if !@save_data.empty?
          @screen.displayboxdisplaymeasavefile(@save_data, commands[cmd_load_game], @selected_file)
          run_file_selection_loop(commands[cmd_load_game], save_file_list, allow_cycle: true, dispose_before_select: true)
        end
      when cmd_new_game
        pbPlayDecisionSE
        result = select_difficulty
        if result == true
          $mouse.disable
          $PokemonSystem.playermode = 1
          Level_Cap.initialize
          if Settings::LANGUAGES.length >= 2 && show_continue
            $PokemonSystem.language = pbChooseLanguage
            pbLoadMessages('Data/' + Settings::LANGUAGES[$PokemonSystem.language][1])
          end
          pbSEPlay("GUI trainer card open", 100, 100)
          pbFadeOutIn do
            disposeTitle
            @main_loop = false
            Game.start_new
          end
          return
        end
      when cmd_options
        pbFadeOutIn do
          scene = PokemonOption_Scene.new
          screen = PokemonOptionScreen.new(scene)
          screen.pbStartScreen(true)
        end
      when cmd_mystery_gift
        full_save_data = load_save_file(SaveData.get_full_path(@selected_file))
        pbFadeOutIn { pbDownloadMysteryGift(full_save_data[:player]) }
      when cmd_update
        pbValidateGameVersionAndUpdate(true)
      when cmd_language
        disposeTitle
        $PokemonSystem.language = pbChooseLanguage
        pbLoadMessages('Data/' + Settings::LANGUAGES[$PokemonSystem.language][1])
        if show_continue
          # @save_data here is only the lightweight preview summary, not the real save —
          # writing that to disk would destroy the actual save file, so this needs a
          # genuine full load to patch and write back.
          full_save_data = load_save_file(SaveData.get_full_path(@selected_file))
          full_save_data[:pokemon_system] = $PokemonSystem
          File.open(SaveData.get_full_path(@selected_file), 'wb') { |file| Marshal.dump(full_save_data, file) }
        end
        $scene = pbCallTitle
        return
      when cmd_debug
        pbFadeOutIn { pbDebugMenu(false) }
      when cmd_quit
        pbPlayCloseMenuSE
        pbFadeOutIn do
          disposeTitle
          @main_loop = false
          $scene = nil
          exit
        end
      else
        pbPlayBuzzerSE
      end
    elsif Input.trigger?(Input::BACK)
      @main_loop = "goback!"
      return
    end
    return if @main_loop == false
  end

  def originalBehavior
    # Fade out
    # disposes current title screen
    disposeTitle
    # initializes load screen
    sscene = PokemonLoad_Scene.new
    sscreen = PokemonLoadScreen.new(sscene)
    sscreen.pbStartLoadScreen
  end

  def prompt_save_deletion(file_path)
    pbMessage(_INTL("A save file is corrupt, or is incompatible with this game."))
    delete_save_data(file_path) if pbConfirmMessageSerious(
      _INTL("Do you want to delete that save file? The game will exit afterwards either way.")
    )
    exit
  end

  def prompt_save_deletion_manual(file_path, save)
    delete_save_data(file_path) if pbConfirmMessageSerious(
      _INTL("Do you want to delete #{save}?")
    )
  end

  # nil deletes all, otherwise just the given file
  def delete_save_data(file_path=nil)
    begin
      SaveData.delete_this_save(file_path)
      pbMessage(_INTL("The save data was deleted."))
    rescue SystemCallError
      pbMessage(_INTL("The save data could not be deleted."))
    end
  end
  #-----------------------------------------------------------------------------
  # close title screen when save delete
  #-----------------------------------------------------------------------------
  def closeTitleDelete
    pbBGMStop(1.0)
    # disposes current title screen
    disposeTitle
    # initializes delete screen
    sscene = PokemonLoad_Scene.new
    sscreen = PokemonLoadScreen.new(sscene)
    sscreen.pbStartLoadScreen
  end
  #-----------------------------------------------------------------------------
  # cycle splash images
  #-----------------------------------------------------------------------------
  def cyclePics
    pics = IntroEventScene::SPLASH_IMAGES
    frames = (Graphics.frame_rate * (IntroEventScene::FADE_TICKS/20.0)).ceil
    sprite = Sprite.new
    sprite.opacity = 0
    for i in 0...pics.length
      bitmap = pbBitmap("Graphics/Titles/#{pics[i]}")
      sprite.bitmap = bitmap
      frames.times do
        sprite.opacity += 255.0/frames
        pbWait(1)
      end
      pbWait((IntroEventScene::SECONDS_PER_SPLASH * Graphics.frame_rate).ceil)
      frames.times do
        sprite.opacity -= 255.0/frames
        pbWait(1)
      end
    end
    sprite.dispose
  end
  #-----------------------------------------------------------------------------
  # dispose of title screen
  #-----------------------------------------------------------------------------
  def disposeTitle
    @screen.dispose
  end
  #-----------------------------------------------------------------------------
  # wait command (skippable)
  #-----------------------------------------------------------------------------
  def wait(frames = 1, advance = true)
    return false if @skip
    frames.times do
      Graphics.update
      Input.update
      @skip = true if Input.trigger?(Input::C)
    end
    return true
  end
  #-----------------------------------------------------------------------------
end
#===============================================================================
#  sprite compatibility
#===============================================================================
class Sprite
  attr_accessor :id
end
#===============================================================================
#  title call override
#===============================================================================
