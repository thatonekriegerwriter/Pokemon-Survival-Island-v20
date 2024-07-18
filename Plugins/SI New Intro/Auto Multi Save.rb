# Auto Multi Save by http404error
# For Pokemon Essentials v19.1

# Description:
#   Adds multiple save slots and the abliity to auto-save.
#   Included is code to autosave every 30 overworld steps. Feel free to edit or delete it (it's right at the top).
#   On the Load screen you can use the left and right buttons while "Continue" is selected to cycle through files.
#   When saving, you can quickly save to the same slot you loaded from, or pick another slot.
#   Battle Challenges are NOT supported.

# Customization:
#   I recommend altering your pause menu to quit to the title screen or load screen instead of exiting entirely.
#     -> For instance, just change the menu text to "Quit to Title" and change `$scene = nil` to `$scene = pbCallTitle`.
#   Call Game.auto_save whenever you want.
#     -> Autosaving during an event script will actually resume event execution when you load the game; however it will also do so if you start a New Game... it's a bug right now.
#     -> I haven't investigated if it might be possible to autosave on closing the window with the X or Alt-F4 yet.
#   You can rename the slots to your liking, or change how many there are.
#   In some cases, you might want to remove the option to save to a different slot than the one you loaded from.

# Notes:
#   On the first Load, the old Game.rxdata will be copied to the first slot in MANUAL_SLOTS. It won't have a known save time though.
#   The interface to `Game.save` has been changed.
#   Due to the slots, alters the save backup system in the case of save corruption/crashes - backups will be named Backup000.rxdata and so on.
#   Heavily modifies the SaveData module and Save and Load screens. This may cause incompatibility with some other plugins or custom game code.
#   Not everything here has been tested extensively, only what applies to normal usage of my game. Please let me know if you run into any problems.

# Future development ideas:
#   There isn't currently support for unlimited slots but it wouldn't be too hard.
#   Letting the user name their slots seems cool.
#   It would be nice if there was a sliding animation for switching files on that load screen. :)
#   It would be nice if the file select arrows used nicer animated graphics, kind of like the Bag.
#   Maybe auto-save slots should act like a queue instead of cycling around.

# Autosave every 30 steps
module UILoad
	# If true, player name will be blue if male, red if female
	SHOW_GENDER_COLOR = true
	# If true, it'll use a custom font from Fonts folder
	USE_CUSTOM_FONT = false
	# Define a custom font name here (it must exist in Fonts folder)
	CUSTOM_FONT_NAME = "FOT-Rodin Pro" 
	# Define a custom font size here
	CUSTOM_FONT_SIZE = 24
end

EventHandlers.add(:on_player_step_taken, :auto_save, proc {
  $player.autosave_steps = 0 if !$player.autosave_steps
  next if $PokemonGlobal.sliding
  next if !pbCanAutosave?
  next if $game_map.map_id==3
  $player.autosave_steps += 1
  if $player.autosave_steps >= 200
    pbAutosave
    $player.autosave_steps = 0
  end
})
#===============================================================================
#
#===============================================================================


			 
module SaveData
  # You can rename these slots or change the amount of them
  # They change the actual save file names though, so it would take some extra work to use the translation system on them.
  AUTO_SLOTS = [
    'Auto 1',
    'Auto 2',
    'Auto 3',
    'Auto 4'
  ]
  MANUAL_SLOTS = [
    'File A',
    'File B',
    'File C',
    'File D',
    'File E',
    'File F',
    'File G',
    'File H'
  ]

  # For compatibility with games saved without this plugin
  OLD_SAVE_SLOT = 'Game'

  SAVE_DIR = "Saves"#if File.directory?(System.data_directory)
              # System.data_directory + "Saves"
            # else
            #  '.'
            # end #

  def self.getSlots
   if File.file?(self.get_full_path(MANUAL_SLOTS[0]))
   save_data = self.read_from_file(self.get_full_path(MANUAL_SLOTS[0]))
   else
   save_data = nil
   end
   if !save_data.nil?
   return [MANUAL_SLOTS[0]] if save_data[:global_metadata].hardcore == true
   end
   return (AUTO_SLOTS + MANUAL_SLOTS)
  end
  def self.each_slot
    self.getSlots.each { |f| yield f }
  end

  def self.get_full_path(file)
    return "#{SAVE_DIR}/#{file}.rxdata"
  end

  def self.get_backup_file_path
    backup_file = "Backup000"
    while File.file?(self.get_full_path(backup_file))
      backup_file.next!
    end
    return self.get_full_path(backup_file)
  end

  # Given a list of save file names and a file name in it, return the next file after it which exists
  # If no other file exists, will just return the same file again
  def self.get_next_slot(file_list, file)
    old_index = file_list.find_index(file)
    ordered_list = file_list.rotate(old_index + 1)
    ordered_list.each do |f|
      return f if File.file?(self.get_full_path(f))
    end
    # should never reach here since the original file should always exist
    return file
  end
  # See self.get_next_slot
  def self.get_prev_slot(file_list, file)
    return self.get_next_slot(file_list.reverse, file)
  end

  # Returns nil if there are no saves
  # Returns the first save if there's a tie for newest
  # Old saves from previous version don't store their saved time, so are treated as very old
  def self.get_newest_save_slot
    newest_time = Time.at(0) # the Epoch
    newest_slot = nil
    self.each_slot do |file_slot|
      full_path = self.get_full_path(file_slot)
      next if !File.file?(full_path)
      temp_save_data = self.read_from_file(full_path)
      save_time = temp_save_data[:player].last_time_saved || Time.at(1)
      if save_time > newest_time
        newest_time = save_time
        newest_slot = file_slot
      end
    end
    # Port old save
    if newest_slot.nil? && File.file?(self.get_full_path(OLD_SAVE_SLOT))
      file_copy(self.get_full_path(OLD_SAVE_SLOT), self.get_full_path(MANUAL_SLOTS[0]))
      return MANUAL_SLOTS[0]
    end
    return newest_slot
  end

  # @return [Boolean] whether any save file exists
  def self.exists?
    self.each_slot do |slot|
      full_path = SaveData.get_full_path(slot)
      return true if File.file?(full_path)
    end
    return false
  end

  def self.exists2(slot)
    full_path = SaveData.get_full_path(slot)
    return true if File.file?(full_path)
    return false
  end


  # This seems to be only used in a hidden function (ctrl+down+cancel on title screen)
  # Deletes ALL the save files (and possible .bak backup files if they exist)
  # @raise [Error::ENOENT]
  def self.delete_file
	  pbSIDataStorage(:DELETE)
  end
  
  def self.delete_this_save(file_path=nil)
    if file_path
      File.delete(file_path) if File.file?(file_path)
    else
      self.each_slot do |slot|
        full_path = self.get_full_path(slot)
        File.delete(full_path) if File.file?(full_path)
      end
    end
  end

  # Moves a save file from the old Saved Games folder to the new
  # location specified by {MANUAL_SLOTS[0]}. Does nothing if a save file
  # already exists in {MANUAL_SLOTS[0]}.
  def self.move_old_windows_save
    return if self.exists?
    game_title = System.game_title.gsub(/[^\w ]/, '_')
    home = ENV['HOME'] || ENV['HOMEPATH']
    return if home.nil?
    old_location = File.join(home, 'Saved Games', game_title)
    return unless File.directory?(old_location)
    old_file = File.join(old_location, 'Game.rxdata')
    return unless File.file?(old_file)
    File.move(old_file, MANUAL_SLOTS[0])
  end

  # Runs all possible conversions on the given save data.
  # Saves a backup before running conversions.
  # @param save_data [Hash] save data to run conversions on
  # @return [Boolean] whether conversions were run
  def self.run_conversions(save_data)
    validate save_data => Hash
    conversions_to_run = self.get_conversions(save_data)
    return false if conversions_to_run.none?
    File.open(SaveData.get_backup_file_path, 'wb') { |f| Marshal.dump(save_data, f) }
    Console.echo_h1 "Backed up save to #{SaveData.get_backup_file_path}"
    Console.echo_h1 "Running #{conversions_to_run.length} conversions..."
    conversions_to_run.each do |conversion|
      Console.echo_li "#{conversion.title}..."
      conversion.run(save_data)
      Console.echo_done ' done.'
    end
    echoln '' if conversions_to_run.length > 0
    Console.echo_h2("All save file conversions applied successfully", text: :green)
    save_data[:essentials_version] = Essentials::VERSION
    save_data[:game_version] = Settings::GAME_VERSION
    return true
  end
end

#===============================================================================
#
#===============================================================================
class PokemonLoadPanel < Sprite
  attr_reader :selected

  TEXTCOLOR             = Color.new(232, 232, 232)
  TEXTSHADOWCOLOR       = Color.new(136, 136, 136)
  MALETEXTCOLOR         = Color.new(56, 160, 248)
  MALETEXTSHADOWCOLOR   = Color.new(56, 104, 168)
  FEMALETEXTCOLOR       = Color.new(240, 72, 88)
  FEMALETEXTSHADOWCOLOR = Color.new(160, 64, 64)

  def initialize(index, title, isContinue, savefile, trainer, framecount, stats, mapid, viewport = nil)
    super(viewport)
    @index = index
    @title = title
    @isContinue = isContinue
    @savefile = savefile
    @trainer = trainer
    @totalsec = (stats) ? stats.play_time.to_i : ((framecount || 0) / Graphics.frame_rate)
    @mapid = mapid
    @selected = (index == 0)
    @bgbitmap = AnimatedBitmap.new("Graphics/UI/Load/loadPanels")
    @refreshBitmap = true
    @refreshing = false
    refresh
  end

  def dispose
    @bgbitmap.dispose
    self.bitmap.dispose
    super
  end

  def selected=(value)
    return if @selected == value
    @selected = value
    @refreshBitmap = true
    refresh
  end

  def pbRefresh
    @refreshBitmap = true
    refresh
  end

  def refresh
    return if @refreshing
    return if disposed?
    @refreshing = true
    if !self.bitmap || self.bitmap.disposed?
      self.bitmap = BitmapWrapper.new(@bgbitmap.width, 222)
      pbSetSystemFont(self.bitmap)
    end
    if @refreshBitmap
      @refreshBitmap = false
      self.bitmap&.clear
      if @isContinue
        self.bitmap.blt(0, 0, @bgbitmap.bitmap, Rect.new(0, (@selected) ? 222 : 0, @bgbitmap.width, 222))
      else
        self.bitmap.blt(0, 0, @bgbitmap.bitmap, Rect.new(0, 444 + ((@selected) ? 46 : 0), @bgbitmap.width, 46))
      end
      textpos = []
      if @isContinue
        textpos.push([@title, 32, 16, 0, TEXTCOLOR, TEXTSHADOWCOLOR])
        textpos.push([_INTL("Class:"), 32, 118, 0, TEXTCOLOR, TEXTSHADOWCOLOR])
        textpos.push([@trainer.playerclass.to_s, 206, 118, 1, TEXTCOLOR, TEXTSHADOWCOLOR])
        textpos.push([_INTL("Health:"), 32, 150, 0, TEXTCOLOR, TEXTSHADOWCOLOR])
        textpos.push([_INTL("{1}/{2}", @trainer.playerhealth.to_s,@trainer.playermaxhealth), 206, 150, 1, TEXTCOLOR, TEXTSHADOWCOLOR])
        #textpos.push([_INTL("Time:"), 32, 182, 0, TEXTCOLOR, TEXTSHADOWCOLOR])
       # hour = @totalsec / 60 / 60
        #min  = @totalsec / 60 % 60
        #if hour > 0
       #   textpos.push([_INTL("{1}h {2}m", hour, min), 206, 182, 1, TEXTCOLOR, TEXTSHADOWCOLOR])
       # else
       #   textpos.push([_INTL("{1}m", min), 206, 182, 1, TEXTCOLOR, TEXTSHADOWCOLOR])
       # end
        if @trainer.male?
          textpos.push([@trainer.name, 112, 70, 0, MALETEXTCOLOR, MALETEXTSHADOWCOLOR])
        elsif @trainer.female?
          textpos.push([@trainer.name, 112, 70, 0, FEMALETEXTCOLOR, FEMALETEXTSHADOWCOLOR])
        else
          textpos.push([@trainer.name, 112, 70, 0, TEXTCOLOR, TEXTSHADOWCOLOR])
        end
		
        save_data = SaveData.read_from_file((SaveData.get_full_path(@savefile)))
		if save_data[:global_metadata].hardcore == true && save_data[:pokemon_system].playermode == 0
        textpos.push([_INTL("{1} (DH)", @savefile.to_s), 229, 16, 1, TEXTCOLOR, TEXTSHADOWCOLOR])
		elsif save_data[:pokemon_system].playermode == 0
        textpos.push([_INTL("{1} (D)", @savefile.to_s), 229, 16, 1, TEXTCOLOR, TEXTSHADOWCOLOR])
		elsif save_data[:global_metadata].hardcore == true
        textpos.push([_INTL("{1} (H)", @savefile.to_s), 229, 16, 1, TEXTCOLOR, TEXTSHADOWCOLOR])
		else
        textpos.push([@savefile, 216, 16, 1, TEXTCOLOR, TEXTSHADOWCOLOR])
		end
        mapname = pbGetMapNameFromId(@mapid)
        mapname.gsub!(/\\PN/, @trainer.name)
		text = "#{mapname} ->"
		
		if !save_data.nil?
         if save_data[:global_metadata].hardcore == true
		   text = "#{mapname}"
		 end
		end
        textpos.push([text, 386, 16, 1, TEXTCOLOR, TEXTSHADOWCOLOR])
      else
        textpos.push([@title, 32, 14, 0, TEXTCOLOR, TEXTSHADOWCOLOR])
      end
	  self.bitmap.font.name = UILoad::CUSTOM_FONT_NAME if UILoad::USE_CUSTOM_FONT
	  self.bitmap.font.size = UILoad::CUSTOM_FONT_SIZE if UILoad::USE_CUSTOM_FONT
      pbDrawTextPositions(self.bitmap, textpos)
    end
    @refreshing = false
  end
end



class PokemonLoad_Scene
  def pbStartScene(commands, show_continue, savefile, trainer, frame_count, stats, map_id)
    @commands = commands
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99998
    addBackgroundOrColoredPlaneNew(@sprites, "background", "Load/loadslotsbg", Color.new(248, 248, 248), @viewport)
    y = 32
    commands.length.times do |i|
      @sprites["panel#{i}"] = PokemonLoadPanel.new(
        i, commands[i], (show_continue) ? (i == 0) : false, savefile, trainer,
        frame_count, stats, map_id, @viewport
      )
      @sprites["panel#{i}"].x = 48
      @sprites["panel#{i}"].y = y
      @sprites["panel#{i}"].pbRefresh
      y += (show_continue && i == 0) ? 224 : 48
    end
    @sprites["cmdwindow"] = Window_CommandPokemon.new([])
    @sprites["cmdwindow"].viewport = @viewport
    @sprites["cmdwindow"].visible  = false
	@star1 = IconSprite.new(5, 35, @viewport)
	@star2 = IconSprite.new(5, 47, @viewport)
	@star3 = IconSprite.new(5, 59, @viewport)
	@star4 = IconSprite.new(5, 71, @viewport)
	@star5 = IconSprite.new(5, 83, @viewport)
	@star1.visible = false
	@star2.visible = false
	@star3.visible = false
	@star4.visible = false
	@star5.visible = false
#	@star1.z = 20
#	@star2.z = 20
#	@star3.z = 20
#	@star4.z = 20
#	@star5.z = 20
	@star1.setBitmap("Graphics/Pictures/stars1.png")
	@star2.setBitmap("Graphics/Pictures/stars1.png")
	@star3.setBitmap("Graphics/Pictures/stars1.png")
	@star4.setBitmap("Graphics/Pictures/stars1.png")
	@star5.setBitmap("Graphics/Pictures/stars1.png")
    @sprites["craftResult"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["craftResult"])
    @sprites["craftResult"].x=30
    @sprites["craftResult"].y=294
    @sprites["craftResult"].width=Graphics.width-48
    @sprites["craftResult"].height=Graphics.height
    @sprites["craftResult"].baseColor=Color.new(232, 232, 232)
    @sprites["craftResult"].shadowColor=Color.new(136, 136, 136)
    @sprites["craftResult"].viewport=@viewport
    @sprites["craftResult"].visible=false
  end

  def pbStartScene2
    pbFadeInAndShow(@sprites) { pbUpdate }
  end
  def pbPrepareWindow(window)
    window.letterbyletter=false
  end
  def pbStartDeleteScene
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99998
    addBackgroundOrColoredPlaneNew(@sprites, "background", "Load/loadslotsbg", Color.new(248, 248, 248), @viewport)
  end

  def pbUpdate
    oldi = @sprites["cmdwindow"].index rescue 0
    pbUpdateSpriteHash(@sprites)
    newi = @sprites["cmdwindow"].index rescue 0
    if oldi != newi
      @sprites["panel#{oldi}"].selected = false
      @sprites["panel#{oldi}"].pbRefresh
      @sprites["panel#{newi}"].selected = true
      @sprites["panel#{newi}"].pbRefresh
      while @sprites["panel#{newi}"].y > Graphics.height - 80
        @commands.length.times do |i|
          @sprites["panel#{i}"].y -= 48
        end
        6.times do |i|
          break if !@sprites["party#{i}"]
          @sprites["party#{i}"].y -= 48
        end
        @sprites["player"].y -= 48 if @sprites["player"]
      end
      while @sprites["panel#{newi}"].y < 32
        @commands.length.times do |i|
          @sprites["panel#{i}"].y += 48
        end
        6.times do |i|
          break if !@sprites["party#{i}"]
          @sprites["party#{i}"].y += 48
        end
        @sprites["player"].y += 48 if @sprites["player"]
      end
    end
  end

  def pbSetParty(trainer)
    return if !trainer || !trainer.party
    meta = GameData::PlayerMetadata.get(trainer.character_ID)
    if meta
      filename = pbGetPlayerCharset(meta.walk_charset, trainer, true)
      @sprites["player"] = TrainerWalkingCharSprite.new(filename, @viewport)
      charwidth  = @sprites["player"].bitmap.width
      charheight = @sprites["player"].bitmap.height
      @sprites["player"].x        = 112 - (charwidth / 8)
      @sprites["player"].y        = 112 - (charheight / 8)
      @sprites["player"].src_rect = Rect.new(0, 0, charwidth / 4, charheight / 4)
    end
    trainer.party.each_with_index do |pkmn, i|
      @sprites["party#{i}"] = PokemonIconSprite.new(pkmn, @viewport)
      @sprites["party#{i}"].setOffset(PictureOrigin::CENTER)
      @sprites["party#{i}"].x = 334 + (66 * (i % 2))
      @sprites["party#{i}"].y = 112 + (50 * (i / 2))
      @sprites["party#{i}"].z = 99999
    end
  end

  def close_title_screen_delete
    sscene = PokemonLoad_Scene.new
    sscreen = PokemonLoadScreen.new(sscene)
    sscreen.pbStartDeleteScreen
  end

  def pbChoose(commands, continue_idx)
    @sprites["cmdwindow"].commands = commands
    loop do
      Graphics.update
      Input.update
      pbUpdate
	  if Input.press?(Input::DOWN) &&
       Input.press?(Input::BACK) &&
       Input.press?(Input::CTRL)
      close_title_screen_delete
      end
      if Input.trigger?(Input::USE) || Input.trigger?(Input::MOUSELEFT)
		@star1.visible = false
	    @star2.visible = false
	    @star3.visible = false
    	@star4.visible = false
    	@star5.visible = false
        return @sprites["cmdwindow"].index
		
		        

	  elsif @sprites["cmdwindow"].index == continue_idx
        if Input.trigger?(Input::LEFT) && SaveData.read_from_file((SaveData.get_full_path(SaveData::MANUAL_SLOTS[0])))[:global_metadata].hardcore == false
          return -3
        elsif Input.trigger?(Input::RIGHT) && SaveData.read_from_file((SaveData.get_full_path(SaveData::MANUAL_SLOTS[0])))[:global_metadata].hardcore == false
          return -2
		elsif Input.triggerex?(:DELETE)
          return -9

        end
      end
    end
  end
  def pbChoose3(commands,adventure_idx,classic_idx,back_idx,tr_idx,speed_idx,weedidx)
    @sprites["cmdwindow"].commands = commands
    loop do
      Graphics.update
      Input.update
      pbUpdate
      @sprites["craftResult"].text=_INTL("Very Easy is an extremely relaxed version of the game, perfect if you dislike Survival Elements.") if @sprites["cmdwindow"].index == adventure_idx
      @sprites["craftResult"].text=_INTL("Easy is for people who aren't the best at battling, but still want some challenge.") if @sprites["cmdwindow"].index == classic_idx
      @sprites["craftResult"].text=_INTL("Normal is a option for those starting for Pokemon Survival Island.") if @sprites["cmdwindow"].index == tr_idx
      @sprites["craftResult"].text=_INTL("Hard is great for those who like a little challenge!") if @sprites["cmdwindow"].index == speed_idx
      @sprites["craftResult"].text=_INTL("Very Hard is the default difficulty.") if @sprites["cmdwindow"].index == weedidx
      @sprites["craftResult"].text=_INTL("Return to Main Menu.") if @sprites["cmdwindow"].index == back_idx
      @sprites["craftResult"].visible=true
      if Input.trigger?(Input::USE) || Input.trigger?(Input::MOUSELEFT)
		@star1.visible = false
	    @star2.visible = false
	    @star3.visible = false
    	@star4.visible = false
    	@star5.visible = false
        return @sprites["cmdwindow"].index
	  end
      if Input.trigger?(Input::BACK)
		@star1.visible = false
	    @star2.visible = false
	    @star3.visible = false
    	@star4.visible = false
    	@star5.visible = false
        return -10
	  end
  end
  end


  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def pbCloseScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end
#===============================================================================
#
#===============================================================================
class PokemonLoadScreen
  def initialize(scene)
    @scene = scene
    @selected_file = SaveData.get_newest_save_slot
  end
  def pbStartDeleteScreen
    @scene.pbStartDeleteScene
    @scene.pbStartScene2
      if pbConfirmMessageSerious(_INTL("Delete Cross-save Data?"))
        pbMessage(_INTL("Once data has been deleted, there is no way to recover it.\1"))
        if pbConfirmMessageSerious(_INTL("Delete the data anyway?"))
          pbMessage(_INTL("Deleting all data. Don't turn off the power.\\wtnp[0]"))
          SaveData.delete_file
          pbMessage(_INTL("The save data was deleted."))
        end
      end
    @scene.pbEndScene
    $scene = pbCallTitle
  end
  # @param file_path [String] file to load save data from
  # @return [Hash] save data
  def load_save_file(file_path)
    save_data = SaveData.read_from_file(file_path)
    unless SaveData.valid?(save_data)
      if File.file?(file_path + ".bak")
        pbMessage(_INTL("The save file is corrupt. A backup will be loaded."))
        save_data = load_save_file(file_path + ".bak")
      else
        self.prompt_save_deletion(file_path)
        return {}
      end
    end
	
    return save_data
  end

  # Called if save file is invalid.
  # Prompts the player to delete the save files.
  def prompt_save_deletion(file_path)
    pbMessage(_INTL("A save file is corrupt, or is incompatible with this game."))
    self.delete_save_data(file_path) if pbConfirmMessageSerious(
      _INTL("Do you want to delete that save file? The game will exit afterwards either way.")
    )
    exit
  end
  
   def prompt_save_deletion_manual(file_path,save)
    self.delete_save_data(file_path) if pbConfirmMessageSerious(
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

  def pbStartLoadScreen
    save_file_list = SaveData.getSlots
    first_time = true
	pbSIDataStorage()
    loop do # Outer loop is used for switching save files
      if @selected_file
        @save_data = load_save_file(SaveData.get_full_path(@selected_file))
      else
        @save_data = {}
      end
      commands = []
      cmd_continue     = -1
      cmd_new_game     = -1
      cmd_language     = -1
      cmd_mystery_gift = -1
      cmd_debug        = -1
      cmd_quit         = -1
      show_continue = !@save_data.empty?
      if show_continue
	     item = _INTL('<- Continue Game')
	     item = _INTL('Continue Game') if @save_data[:global_metadata].hardcore == true
        commands[cmd_continue = commands.length] = item
#        if @save_data[:player].mystery_gift_unlocked
#          commands[cmd_mystery_gift = commands.length] = _INTL('Mystery Gift') # Honestly I have no idea how to make Mystery Gift work well with this.
#        end
      end
      commands[cmd_new_game = commands.length]  = _INTL('New Game')
      commands[cmd_language = commands.length]  = _INTL('Language') if Settings::LANGUAGES.length >= 2
      commands[cmd_debug = commands.length]     = _INTL('Debug') if $DEBUG
      commands[cmd_quit = commands.length]      = _INTL('Quit Game')
      cmd_left = -3
      cmd_right = -2
      cmd_delete = -9
      map_id = show_continue ? @save_data[:map_factory].map.map_id : 0
    @scene.pbStartScene(commands, show_continue, @selected_file, @save_data[:player],
                        @save_data[:frame_count] || 0, @save_data[:stats], map_id)
    @scene.pbSetParty(@save_data[:player]) if show_continue
      if first_time
        @scene.pbStartScene2
        first_time = false
      else
        @scene.pbUpdate
      end

      loop do # Inner loop is used for going to other menus and back and stuff (vanilla)
        command = @scene.pbChoose(commands, cmd_continue)
        pbPlayDecisionSE if command != cmd_quit

        case command
        when cmd_continue
          @scene.pbEndScene
		  pbBGMFade(0.8)
          Game.load(@save_data)
		   @save_data[:player].autosave_steps=0
          return
        when cmd_new_game
		          @scene.pbEndScene
	commands = []
    cmd_cmd_psiave     = -1
    cmd_psia     = -1
    cmd_demo     = -1
    cmd_rocket     = -1
    cmd_speed     = -1
    cmd_return2 = -1
    cmd_return = -10
    commands[cmd_psiave = commands.length] = _INTL('Play Pokemon SI: Very Easy')
    commands[cmd_psiae = commands.length] = _INTL('Play Pokemon SI: Easy')
    commands[cmd_psian = commands.length]  = _INTL('Play Pokemon SI: Normal')
    commands[cmd_psiah = commands.length]  = _INTL('Play Pokemon SI: Hard')
    commands[cmd_psiavh = commands.length]  = _INTL('Play Pokemon SI: Very Hard')



    commands[cmd_return2 = commands.length]  = _INTL('Back')
		@scene.pbStartScene(commands, false, false, nil, 0, nil, 0)
    loop do
      command = @scene.pbChoose3(commands,cmd_psiave,cmd_psiae,cmd_return2,cmd_psian,cmd_psiah,cmd_psiavh)
      pbPlayDecisionSE if command != cmd_quit
      case command
      when cmd_return
		 @scene.pbEndScene
		 pbStartLoadScreen
      when cmd_return2
		 @scene.pbEndScene
		 pbStartLoadScreen
	  else
      case command
      when cmd_psiave
		  $PokemonSystem.difficulty = 0
		  $PokemonSystem.nuzlockemode = 1
		  $PokemonSystem.survivalmode = 1
      when cmd_psiae
		  $PokemonSystem.difficulty = 0
		  $PokemonSystem.nuzlockemode = 0
		  $PokemonSystem.survivalmode = 0
      when cmd_psian
		  $PokemonSystem.difficulty = 1
		  $PokemonSystem.nuzlockemode = 0
		  $PokemonSystem.survivalmode = 0
      when cmd_psiah
		  $PokemonSystem.difficulty = 2
		  $PokemonSystem.nuzlockemode = 0
		  $PokemonSystem.survivalmode = 0
	  when cmd_psiavh
		  $PokemonSystem.difficulty = 3
		  $PokemonSystem.nuzlockemode = 0
		  $PokemonSystem.survivalmode = 0
      end

		  $PokemonSystem.playermode = 1
          Level_Cap.initialize
		  @scene.pbEndScene
				if Settings::LANGUAGES.length >= 2 && show_continue
					$PokemonSystem.language = pbChooseLanguage
					pbLoadMessages('Data/' + Settings::LANGUAGES[$PokemonSystem.language][1])
				end
        Game.start_new
        return





	  end
    end
	
	
	
	
	
	
        when cmd_mystery_gift
          pbFadeOutIn { pbDownloadMysteryGift(@save_data[:player]) }
        when cmd_language
          @scene.pbEndScene
          $PokemonSystem.language = pbChooseLanguage
          pbLoadMessages('Data/' + Settings::LANGUAGES[$PokemonSystem.language][1])
          if show_continue
            @save_data[:pokemon_system] = $PokemonSystem
            File.open(SaveData.get_full_path(@selected_file), 'wb') { |file| Marshal.dump(@save_data, file) }
          end
          $scene = pbCallTitle
          return
        when cmd_debug
          pbFadeOutIn { pbDebugMenu(false) }
        when cmd_quit
          pbPlayCloseMenuSE
          @scene.pbEndScene
          $scene = nil
          return
        when cmd_left
          @scene.pbCloseScene
          @selected_file = SaveData.get_prev_slot(save_file_list, @selected_file)
          break # to outer loop
        when cmd_right
          @scene.pbCloseScene
          @selected_file = SaveData.get_next_slot(save_file_list, @selected_file)
          break # to outer loop
        when cmd_delete
		  save_data = SaveData.get_full_path(@selected_file)
		  self.prompt_save_deletion_manual(save_data,@selected_file)
          @scene.pbCloseScene
		  @selected_file = SaveData.get_newest_save_slot
          break # to outer loop
        else
          pbPlayBuzzerSE
        end
      end
    end
  end
end

#===============================================================================
#
#===============================================================================
class PokemonSave_Scene
  def pbStartScreen
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    totalsec = $stats.play_time.to_i
    hour = totalsec / 60 / 60
    min = totalsec / 60 % 60
    mapname = $game_map.name
    textColor = ["0070F8,78B8E8", "E82010,F8A8B8", "0070F8,78B8E8"][$player.gender]
    locationColor = "209808,90F090"   # green
    loctext = _INTL("<ac><c3={1}>{2}</c3></ac>", locationColor, mapname)
    loctext += _INTL("Player<r><c3={1}>{2}</c3><br>", textColor, $player.name)
    loctext += _INTL("Class<r><c3={1}>{2} Lv{3}</c3><br>", textColor, $player.playerclass, $player.playerclasslevel.to_i)
    @sprites["nubg"] = IconSprite.new(0,0,@viewport)
    @sprites["nubg"].setBitmap(_INTL("Graphics/Pictures/loadslotsbg"))
    @sprites["locwindow"] = Window_AdvancedTextPokemon.new(loctext)
    @sprites["locwindow"].viewport = @viewport
    @sprites["locwindow"].x = 0
    @sprites["locwindow"].y = 0
    @sprites["locwindow"].width = 228 if @sprites["locwindow"].width < 228
    @sprites["locwindow"].visible = true
  end





  def pbUpdateSlotInfo(slottext)
    pbDisposeSprite(@sprites, "slotinfo")
    @sprites["slotinfo"]=Window_AdvancedTextPokemon.new(slottext)
    @sprites["slotinfo"].viewport=@viewport
    @sprites["slotinfo"].x=0
    @sprites["slotinfo"].y=160
    @sprites["slotinfo"].width=228 if @sprites["slotinfo"].width<228
    @sprites["slotinfo"].visible=true
  end
end

#===============================================================================
#
#===============================================================================
class PokemonSaveScreen
  def doSave(slot)
    if Game.save(slot)
      pbMessage(_INTL("\\se[]{1} saved the game.\\me[GUI save game]\\wtnp[30]", $player.name))
      return true
    else
      pbMessage(_INTL("\\se[]Save failed.\\wtnp[30]"))
      return false
    end
  end

  # Return true if pause menu should close after this is done (if the game was saved successfully)
  def pbSaveScreen(exiting=false)
    ret = false
    @scene.pbStartScreen
    if !$player.save_slot
      # New Game - must select slot
      ret = slotSelect(exiting)
	 elsif $PokemonGlobal.hardcore == true
        pbSEPlay('GUI save choice')
        slot = SaveData::MANUAL_SLOTS[0]
        if !File.file?(SaveData.get_full_path(slot)) ||
            pbConfirmMessageSerious(_INTL("Are you sure you want to save?")) # If the slot names were changed this grammar might need adjustment.
          pbSEPlay('GUI save choice')
          ret = doSave(slot)
        end
    else
      choices = [
        _INTL("Save to #{$player.save_slot}"),
        _INTL("Save to another file"),
        exiting ? _INTL("Quit without saving") : _INTL("Cancel")
      ]
      opt = pbMessage(_INTL('Would you like to save the game?'),choices,3)
      if opt == 0
        pbSEPlay('GUI save choice')
        ret = doSave($player.save_slot)
      elsif opt == 1
        pbPlayDecisionSE
        ret = slotSelect(exiting)
      else
        pbPlayCancelSE
      end
    end
    @scene.pbEndScreen
    return ret
  end

  # Call this to open the slot select screen
  # Returns true if the game was saved, otherwise false
  def slotSelect(exiting=false)
    ret = false
    choices = SaveData::MANUAL_SLOTS
    choice_info = SaveData::MANUAL_SLOTS.map { |s| getSaveInfoBoxContents(s) }
    loop do
      index = slotSelectCommands(choices, choice_info)
      if index >= 0
        slot = SaveData::MANUAL_SLOTS[index]
        # Confirm if slot not empty
        if !File.file?(SaveData.get_full_path(slot)) ||
            pbConfirmMessageSerious(_INTL("Are you sure you want to overwrite the save in #{slot}?")) # If the slot names were changed this grammar might need adjustment.
          pbSEPlay('GUI save choice')
          ret = doSave(slot)
        end

      elsif exiting # Pressed cancel
        next unless pbConfirmMessageSerious(_INTL("Are you sure you want to quit without saving?"))
      end
      break
    end
    pbPlayCloseMenuSE if !ret
    return ret
  end

  # Handles the UI for the save slot select screen. Returns the index of the chosen slot, or -1.
  # Based on pbShowCommands
  def slotSelectCommands(choices, choice_info, defaultCmd=0)
    msgwindow = Window_AdvancedTextPokemon.new(_INTL("Which slot to save in?"))
    msgwindow.z = 99999
    msgwindow.visible = true
    msgwindow.letterbyletter = true
    msgwindow.back_opacity = MessageConfig::WINDOW_OPACITY
    pbBottomLeftLines(msgwindow, 2)
    $game_temp.message_window_showing = true if $game_temp
    msgwindow.setSkin(MessageConfig.pbGetSpeechFrame)

    cmdwindow = Window_CommandPokemonEx.new(choices)
    cmdwindow.z = 99999
    cmdwindow.visible = true
    cmdwindow.resizeToFit(cmdwindow.commands)
    pbPositionNearMsgWindow(cmdwindow,msgwindow,:right)
    cmdwindow.index=defaultCmd
    command=0
    loop do
      @scene.pbUpdateSlotInfo(choice_info[cmdwindow.index])
      Graphics.update
      Input.update
      cmdwindow.update
      msgwindow.update if msgwindow
      if Input.trigger?(Input::BACK)
        command = -1
        break
      end
      if Input.trigger?(Input::USE) || Input.trigger?(Input::MOUSELEFT)
        command = cmdwindow.index
        break
      end
      pbUpdateSceneMap
    end
    ret = command
    cmdwindow.dispose
    msgwindow.dispose
    $game_temp.message_window_showing = false if $game_temp
    Input.update
    return ret
  end

  # Show the player some data about their currently selected save slot for quick identification
  # This doesn't use player gender for coloring, unlike the default save window
  def getSaveInfoBoxContents(slot)
    full_path = SaveData.get_full_path(slot)
    if !File.file?(full_path)
      return _INTL("<ac><c3=3050C8,D0D0C8>(empty)</c3></ac>")
    end
    temp_save_data = SaveData.read_from_file(full_path)

    # Last save time
    time = temp_save_data[:player].last_time_saved
    if time
      date_str = time.strftime("%x")
      time_str = time.strftime(_INTL("%I:%M%p"))
      datetime_str = "#{date_str}<r>#{time_str}<br>"
    else
      datetime_str = _INTL("<ac>(old save)</ac>")
    end

    # Map name
    map_str = pbGetMapNameFromId(temp_save_data[:map_factory].map.map_id)

    # Elapsed time
    totalsec = (temp_save_data[:frame_count] || 0) / Graphics.frame_rate
    hour = totalsec / 60 / 60
    min = totalsec / 60 % 60
    if hour > 0
      elapsed_str = _INTL("Time<r>{1}h {2}m<br>", hour, min)
    else
      elapsed_str = _INTL("Time<r>{1}m<br>", min)
    end

    return "<c3=3050C8,D0D0C8>#{datetime_str}</c3>"+ # blue
           "<ac><c3=209808,90F090>#{map_str}</c3></ac>"+ # green
           "#{elapsed_str}"
  end
end

#===============================================================================
#
#===============================================================================
module Game
  # Loads bootup data from save file (if it exists) or creates bootup data (if
  # it doesn't).
  def self.set_up_system
    SaveData.move_old_windows_save if System.platform[/Windows/]
    save_slot = SaveData.get_newest_save_slot
    if save_slot
      save_data = SaveData.read_from_file(SaveData.get_full_path(save_slot))
    else
      save_data = {}
    end
    if save_data.empty?
      SaveData.initialize_bootup_values
    else
      SaveData.load_bootup_values(save_data)
    end
    # Set resize factor
    pbSetResizeFactor([$PokemonSystem.screensize, 4].min)
    # Set language (and choose language if there is no save file)
    if Settings::LANGUAGES.length >= 2
      $PokemonSystem.language = pbChooseLanguage if save_data.empty?
      pbLoadMessages('Data/' + Settings::LANGUAGES[$PokemonSystem.language][1])
    end
  end

  # Saves the game. Returns whether the operation was successful.
  # @param save_file [String] the save file path
  # @param safe [Boolean] whether $PokemonGlobal.safesave should be set to true
  # @return [Boolean] whether the operation was successful
  # @raise [SaveData::InvalidValueError] if an invalid value is being saved
  def self.save(slot=nil, auto=false, safe: false)
  
    slot = $player.save_slot if slot.nil?
    return false if slot.nil?
	if $PokemonGlobal.hardcore == true
	slot = SaveData::MANUAL_SLOTS[0]
	end
    
    file_path = SaveData.get_full_path(slot)
    $PokemonGlobal.safesave = safe
    $game_system.save_count += 1
    $game_system.magic_number = $data_system.magic_number
    $player.save_slot = slot unless auto
    $player.last_time_saved = Time.now
    begin
      SaveData.save_to_file(file_path)
      Graphics.frame_reset
    rescue IOError, SystemCallError
      $game_system.save_count -= 1
      return false
    end
    return true
  end

  # Overwrites the first empty autosave slot, or the oldest existing autosave
  def self.auto_save
    oldest_time = nil
    oldest_slot = nil
	if $PokemonGlobal.hardcore == true
	  slot = SaveData::MANUAL_SLOTS[0]
	  full_path = SaveData.get_full_path(slot)
      temp_save_data = SaveData.read_from_file(full_path)
      save_time = temp_save_data[:player].last_time_saved || Time.at(1)
      if oldest_time.nil? || save_time < oldest_time
        oldest_time = save_time
        oldest_slot = slot
      end
      self.save(oldest_slot, true)
	else
    SaveData::AUTO_SLOTS.each do |slot|
      full_path = SaveData.get_full_path(slot)
      if !File.file?(full_path)
        oldest_slot = slot
        break
      end
      temp_save_data = SaveData.read_from_file(full_path)
      save_time = temp_save_data[:player].last_time_saved || Time.at(1)
      if oldest_time.nil? || save_time < oldest_time
        oldest_time = save_time
        oldest_slot = slot
      end
    end
    self.save(oldest_slot, true)
	end
  end



end

#===============================================================================
#
#===============================================================================

# Lol who needs the FileUtils gem?
# This is the implementation from the original pbEmergencySave.
def file_copy(src, dst)
  File.open(src, 'rb') do |r|
    File.open(dst, 'wb') do |w|
      while s = r.read(4096)
        w.write s
      end
    end
  end
end

# When I needed extra data fields in the save file I put them in Player because it seemed easier than figuring out
# how to make a save file conversion, and I prefer to maintain backwards compatibility.
class Player
  attr_accessor :last_time_saved
  attr_accessor :save_slot
  attr_accessor :autosave_steps
end

def pbEmergencySave
  oldscene = $scene
  $scene = nil
  pbMessage(_INTL("The script is taking too long. The game will restart."))
  return if !$player
  return if !$player.save_slot
  current_file = SaveData.get_full_path($player.save_slot)
  backup_file = SaveData.get_backup_file_path
  file_copy(current_file, backup_file)
  if Game.save
    pbMessage(_INTL("\\se[]The game was saved.\\me[GUI save game] The previous save file has been backed up.\\wtnp[30]"))
  else
    pbMessage(_INTL("\\se[]Save failed.\\wtnp[30]"))
  end
  $scene = oldscene
end


def pbStorePokemonPC2(pkmn)
  if pbBoxesFull?
    pbMessage(_INTL("There's no more room for Pokémon!\1"))
    pbMessage(_INTL("The Pokémon Boxes are full and can't accept any more!"))
    return
  end
  pkmn.record_first_moves
    stored_box = $PokemonStorage.pbStoreCaught(pkmn)
    box_name   = $PokemonStorage[stored_box].name
end


def pbCallTitle(bgmchange=nil)
  if bgmchange == false
    pbBGMPlay("anthemmix")
  else
	pbBGMPlay("Title")
  end
  return Scene_Intro.new
end



def pbSIDataStorage(option=nil,object=nil,goal=nil)
  save_dir2 = if File.directory?(System.data_directory)
               System.data_directory
             else
              '.'
             end
 loaded_data = nil
 file_name = "#{save_dir2}/SI_FUN.rxdata"
  if !File.exist?(file_name)
     default_values = {"demo_mode" => true,"adventure_mode" => true,"rocket_mode" => false,"speedrun_mode" => false,"kanto_unlocked" => false,
	 "johto_unlocked" => false,"completed_demo" => false,"completed_rocket" => false,"completed_speedrun" => false,"demo_team" => nil,"stars" => 0,
	 "played_before" => false,"original_player_name" => nil}
	 File.open(file_name, "wb") do |file|
      file.write(Marshal.dump(default_values))
     end
  else
  File.open(file_name, "rb") do |file|
    loaded_data = Marshal.load(file.read)
  end
  if loaded_data
  if $DEBUG
  end
else
end
  if loaded_data && loaded_data[object] && option == :SAVE
  if object == "original_player_name" && option == :SAVE
  loaded_data[object] = $player.name 
  elsif object == "demo_team" && option == :SAVE
  loaded_data[object] = $player.party 
  else
  loaded_data[object] = goal  
  end
  	 if File.exist?(file_name)
	 File.open(file_name, "wb") do |file|
      file.write(Marshal.dump(loaded_data))
     end
	 end
  return loaded_data[object]
  elsif loaded_data && loaded_data[object] && option == :LOAD
  return loaded_data[object]
  elsif loaded_data && option == :UPDATE
  loaded_data[object] = goal
  	 if File.exist?(file_name)
	 File.open(file_name, "wb") do |file|
      file.write(Marshal.dump(loaded_data))
     end
	 end
  return loaded_data[object]
  elsif loaded_data && option == :DELETE 
   File.delete(file_name)
  return true
  end
  end
end


def pbDemoExit
    if pbConfirmMessage(_INTL("Would you like to end the Demo now?"))
	  pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
      $game_temp.in_menu = false
	  pbSIDataStorage(:SAVE,"completed_demo",true)
	  pbSIDataStorage(:SAVE,"demo_team")
	  stars = pbSIDataStorage(:LOAD,"stars")
	  pbSIDataStorage(:SAVE,"stars",stars+1)
	  pbMessage(_INTL("Beep! Beep! Beep! Beep! Beep!"))
	  pbMessage(_INTL("It sounds like an alarm."))
    $game_temp.player_new_map_id    = 1
    $game_temp.player_new_x         = 22
    $game_temp.player_new_y         = 3
    $game_temp.player_new_direction = 1
    $scene.transfer_player(false)
    $game_map.autoplay
    $game_map.refresh
	Game.save
#	$player.playermode = 1 
	$scene = pbCallTitle
    while $scene != nil
      $scene.main
    end
    Graphics.transition(20)
    end
end

