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
	puts string
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

def pbPlayVideo(movie,volume,cancelable)
    pbPauseBGM
	$mouse.hide
	if $game_system.getPlayingBGM
	 pbBGMStop
	end
	if $game_system.getPlayingBGM
	 pbBGMStop
	end
	if !$game_system.getPlayingBGM
    Graphics.play_movie(movie, volume, cancelable)
	end
	$mouse.show
	pbResumeBGM
end

class Scene_Intro
  #-----------------------------------------------------------------------------
  # load the title screen
  #-----------------------------------------------------------------------------
  def main
	Graphics.show_cursor=false
    Graphics.transition(0)
    # refresh input
    Input.update
    # Loads up a species cry for the title screen
    species = ModularTitle::SPECIES
    species = species.upcase.to_sym if species.is_a?(String)
    species = GameData::Species.get(species).id
    @selected_file = SaveData.get_newest_save_slot
	@newest_file = SaveData.get_newest_save_slot
	@newest_data = {}
    @newest_data = load_save_file(SaveData.get_full_path(@newest_file)) if @selected_file
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
    # Plays defined title screen BGM
    # Plays the title screen intro (is skippable)
    @screen.intro
    # Creates/updates the main title screen loop
	loop do 
    result = self.update
	puts result
	break if result == true
	end
    Graphics.freeze if @main_loop==false
  end
  #-----------------------------------------------------------------------------
  # main update loop
  #-----------------------------------------------------------------------------


  def update
    return if @main_loop==false
    ret = 0
    handle_saves
    pbValidateGameVersionAndUpdate() if (GameVersion::POKE_UPDATER_CONFIG['FORCE_UPDATE']==true || forcetheupdate) && getUpdate && GameVersion::ENABLED
    first_time = true
	createSIDataValues
    loop do
      @screen.update
      Graphics.update
      Input.update
      @demo_timer += 1
      if Input.trigger?(Input::USE)
        ret = 2
        break
      end
	  if @demo_timer>45*Graphics.frame_rate
	    @demo_timer=0
        ret = 1
        break
	  end
    end
   
    case ret
    when 1
	pbFadeOutIn { @screen.hide }
	   pbPlayIntroVideo
	pbFadeOutIn { @screen.show}
	   return false
    when 2
      closeTitle
	   return true if @main_loop==false
	   return false if @main_loop==true
    end

  end
  #-----------------------------------------------------------------------------
  # close title screen and dispose of elements
  #-----------------------------------------------------------------------------
  def closeTitle
    save_file_list = SaveData.getSlots
	real_save_file_list = SaveData.get_all_saves
    # Play Pokemon cry
	
    pbSEPlay("XATU", 100, 100)
	if getSIDataStatus("classicTitleScreen")==1
	 originalBehavior
	else
	@screen.depth(1)
	   if @selected_file
        @save_data = load_save_file(SaveData.get_full_path(@selected_file))
      else
        @save_data = {}
      end
      commands = []
      cmd_continue     = -1
      cmd_load_game     = -1
      cmd_new_game     = -1
      cmd_update       = -1
      cmd_language     = -1
      cmd_mystery_gift = -1
      cmd_options = -1
      cmd_debug        = -1
      cmd_quit         = -1
      cmd_left = -3
      cmd_right = -2
      cmd_delete = -9
      show_continue = !@save_data.empty?
      
      commands[cmd_continue = commands.length] = _INTL('Continue Game') if show_continue
      commands[cmd_load_game = commands.length]  = _INTL('Load Game') if show_continue && real_save_file_list.length > 1 && @save_data[:global_metadata].hardcore == false
      commands[cmd_new_game = commands.length]  = _INTL('New Game')
      commands[cmd_update = commands.length]    = _INTL('Check for Updates') if getUpdate && GameVersion::ENABLED
      commands[cmd_quit = commands.length]      = _INTL('Quit Game')
      commands[cmd_language = commands.length]  = _INTL('Language') if Settings::LANGUAGES.length >= 2
      commands[cmd_debug = commands.length]     = _INTL('Debug') if $DEBUG
      commands[cmd_options = commands.length]   = _INTL('Options')
	   @screen.set_text("craftResult",commands[@index])
    loop do
      @screen.update
      Graphics.update
      Input.update
	  if @demo_timer>45*Graphics.frame_rate
	  @demo_timer=0
	pbFadeOutIn { @screen.hide }
	   pbPlayIntroVideo
	pbFadeOutIn { @screen.show}
	  end
     show_continue = !@save_data.empty?
	 
	 if @save_data.empty? && SaveData.get_all_saves.length < 2 && commands.include?(_INTL('Load Game'))
	 commands.delete(_INTL('Load Game'))
	@screen.generic_update("craftResult",commands[@index])
	cmd_load_game = -1
	cmd_new_game -= 1 if cmd_new_game > -1
	cmd_update -= 1 if cmd_update > -1
	cmd_options -= 1 if cmd_options > -1
	cmd_language -= 1 if cmd_language > -1
	cmd_mystery_gift -= 1 if cmd_mystery_gift > -1
	cmd_debug -= 1 if cmd_debug > -1
	cmd_quit -= 1 if cmd_quit > -1
	  end
     if @save_data.empty? && commands.include?(_INTL('Continue Game'))
	 commands.delete(_INTL('Continue Game'))
	@screen.generic_update("craftResult",commands[@index])
	cmd_continue = -1
	cmd_new_game -= 1 if cmd_new_game > -1
	cmd_update -= 1 if cmd_update > -1
	cmd_options -= 1 if cmd_options > -1
	cmd_language -= 1 if cmd_language > -1
	cmd_mystery_gift -= 1 if cmd_mystery_gift > -1
	cmd_debug -= 1 if cmd_debug > -1
	cmd_quit -= 1 if cmd_quit > -1
	 end

     @demo_timer+=1	  
	   main_selection_loop(save_file_list,real_save_file_list,commands,cmd_continue,show_continue,cmd_load_game,cmd_new_game,cmd_update,cmd_options,cmd_language,cmd_mystery_gift,cmd_debug,cmd_quit)

         break if @main_loop==false
		 if @main_loop=="goback!"
	     @screen.depth(0)
	     @index = 0
		 
		 @main_loop=true
		 break
        end
	end
    end
  end

  def load_save_file(file_path)
    puts file_path
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
	   if Input.trigger?(Input::UP) || Input.repeat?(Input::UP) || Input.scroll_v==1
	    if curselection-1<0
		curselection = thecommands.length-1
		else
	    curselection-=1
		end
		  pbPlayDecisionSE
		@screen.move_selector_arrow(curselection)
	   elsif Input.trigger?(Input::DOWN)  || Input.repeat?(Input::UP) || Input.scroll_v==-1
	    if curselection+1>=thecommands.length
	    curselection=0
		else
	    curselection+=1
		end
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
      thecommands = [_INTL("Play"),_INTL("Mystery Gift")]
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
	  pbBGMFade(0.8)
	  
    pbSEPlay("GUI trainer card open", 100, 100)
        pbFadeOutIn do
		
	  disposeTitle
	  @main_loop = false
	  file[:player].autosave_steps=0
      Game.load(file)
	  return
	  end
	 end
#          commands[cmd_mystery_gift = commands.length] = _INTL('Mystery Gift') # Honestly I have no idea how to make Mystery Gift work well with this.
#        end
   
	  return
  end



  def select_difficulty
    command3 = 0
      thecommands = [_INTL("Very Easy"),_INTL("Easy"),_INTL("Normal"),_INTL("Hard"),_INTL("Very Hard"),_INTL("Cancel")]
      @screen.pbChoiceBox(thecommands)
	  command3 = selection_box_stuff(thecommands)
	   case command3
      when 0
		  $PokemonSystem.difficulty = 1
		  $PokemonSystem.nuzlockemode = 1
		  $PokemonSystem.survivalmode = 1
      when 1
		  $PokemonSystem.difficulty = 2
		  $PokemonSystem.nuzlockemode = 0
		  $PokemonSystem.survivalmode = 0
      when 2
		  $PokemonSystem.difficulty = 3
		  $PokemonSystem.nuzlockemode = 0
		  $PokemonSystem.survivalmode = 0
      when 3
		  $PokemonSystem.difficulty = 4
		  $PokemonSystem.nuzlockemode = 0
		  $PokemonSystem.survivalmode = 0
	  when 4
		  $PokemonSystem.difficulty = 5
		  $PokemonSystem.nuzlockemode = 0
		  $PokemonSystem.survivalmode = 0
	  else
	     return false
      end
	  return true
  end





  def main_selection_loop(save_file_list,real_save_file_list,commands,cmd_continue,show_continue,cmd_load_game,cmd_new_game,cmd_update,cmd_options,cmd_language,cmd_mystery_gift,cmd_debug,cmd_quit)

   if Input.trigger?(Input::LEFT) || Input.repeat?(Input::LEFT) || Input.triggerex?(0x25) || Input.repeatex?(0x25)

    if @index - 1 < 0
	 @index = commands.length-1
	else
    @index -= 1
	end
	pbPlayDecisionSE
	@screen.move_arrowl("craftResult",commands[@index])
	@screen.displayboxdisplaymeasavefile
	     @demo_timer=0

	
	
   elsif Input.trigger?(Input::RIGHT) || Input.repeat?(Input::RIGHT) || Input.triggerex?(0x27) || Input.repeatex?(0x27)
    if @index+1 == commands.length
    @index = 0
	
	else
    @index += 1
	end
	pbPlayDecisionSE
	@screen.move_arrowr("craftResult",commands[@index])
	 @screen.displayboxdisplaymeasavefile
	     @demo_timer=0


	elsif Input.trigger?(Input::USE) && (Input.mouse_x.between?(@screen.sprites2["arrowr"].x-10,@screen.sprites2["arrowr"].x+@screen.sprites2["arrowr"].width+10) && Input.mouse_y.between?(@screen.sprites2["arrowr"].y-10,@screen.sprites2["arrowr"].y+@screen.sprites2["arrowl"].height+10))
	
    if @index+1 == commands.length
    @index = 0
	
	else
    @index += 1
	end
	pbPlayDecisionSE
	@screen.move_arrowr("craftResult",commands[@index])
	 @screen.displayboxdisplaymeasavefile
	     @demo_timer=0

	elsif Input.trigger?(Input::USE) && (Input.mouse_x.between?(@screen.sprites2["arrowl"].x-10,@screen.sprites2["arrowl"].x+@screen.sprites2["arrowl"].width+10) && Input.mouse_y.between?(@screen.sprites2["arrowl"].y-10,@screen.sprites2["arrowl"].y+@screen.sprites2["arrowl"].height+10))
	
    if @index - 1 < 0
	 @index = commands.length-1
	else
    @index -= 1
	end
	pbPlayDecisionSE
	@screen.move_arrowl("craftResult",commands[@index])
	@screen.displayboxdisplaymeasavefile
	     @demo_timer=0

	
	
   elsif Input.trigger?(Input::USE)
        
	     @demo_timer=0
        case @index
        when cmd_continue
		 puts "A"
		 if !@save_data.empty?
		 pbPlayDecisionSE
	     @screen.displayboxdisplaymeasavefile(@newest_data,commands[cmd_continue],@newest_file)
		 loop do
      @screen.update
      Graphics.update
      Input.update
		  if Input.trigger?(Input::USE) 
		   puts @save_data
		  pbPlayDecisionSE
		  select_this_file(@save_data)
		   break
		  elsif Input.triggerex?(:DELETE)
		  file_path = SaveData.get_full_path(@selected_file)
		  prompt_save_deletion_manual(file_path,@selected_file)
		  
		  file = SaveData.get_newest_save_slot
		   if !file.nil?
		  @newest_file = file
		  @selected_file = file
		  @newest_data = load_save_file(SaveData.get_full_path(@newest_file))
         @save_data = load_save_file(SaveData.get_full_path(@selected_file))
	     @screen.displayboxdisplaymeasavefile(@newest_data,commands[cmd_continue],@newest_file)
		   else
		  @newest_file = nil
		  @selected_file = nil
		  @newest_data = {}
         @save_data = {}
		  puts @save_data
	       @screen.displayboxdisplaymeasavefile
		  puts @save_data
		   break
		  end
		  elsif Input.trigger?(Input::BACK)
	       @screen.displayboxdisplaymeasavefile
		   break
		  end
		 end
        end

        when cmd_load_game
		 puts "B"
		 if !@save_data.empty?
	      @screen.displayboxdisplaymeasavefile(@save_data,commands[cmd_load_game],@selected_file)
		 loop do
      @screen.update
      Graphics.update
      Input.update
		  if Input.trigger?(Input::USE)
		  disposeTitle
		  select_this_file(@save_data)
		   break
		  
		  elsif Input.triggerex?(:DELETE)
	       @screen.displayboxdisplaymeasavefile
		  file_path = SaveData.get_full_path(@selected_file)
		  prompt_save_deletion_manual(file_path,@selected_file)
		  @newest_file = SaveData.get_newest_save_slot
           @newest_data = load_save_file(SaveData.get_full_path(@newest_file))
		  @selected_file = SaveData.get_newest_save_slot
           @save_data = load_save_file(SaveData.get_full_path(@selected_file))
	      @screen.displayboxdisplaymeasavefile(@save_data,commands[cmd_load_game],@selected_file)
		  elsif Input.trigger?(Input::LEFT)
           @selected_file = SaveData.get_prev_slot(save_file_list, @selected_file)
           @save_data = load_save_file(SaveData.get_full_path(@selected_file))
	       @screen.displayboxdisplaymeasavefile(1)
		  pbPlayDecisionSE
		   @screen.move_arrowl2(@save_data,commands[cmd_load_game],@selected_file)
		  elsif Input.trigger?(Input::RIGHT)
           @selected_file = SaveData.get_next_slot(save_file_list, @selected_file)
           @save_data = load_save_file(SaveData.get_full_path(@selected_file))
	       @screen.displayboxdisplaymeasavefile(1)
		  pbPlayDecisionSE
		   @screen.move_arrowr2(@save_data,commands[cmd_load_game],@selected_file)
		  elsif Input.trigger?(Input::BACK)
	       @screen.displayboxdisplaymeasavefile
		   break
		  end
		 end
        end
        when cmd_new_game
		 puts "C"
		result = false
		  pbPlayDecisionSE
		  result=select_difficulty
		if result==true
	     $mouse.hide
		  $PokemonSystem.playermode = 1
          Level_Cap.initialize
			if Settings::LANGUAGES.length >= 2 && show_continue
			  $PokemonSystem.language = pbChooseLanguage
			  pbLoadMessages('Data/' + Settings::LANGUAGES[$PokemonSystem.language][1])
			end
    pbSEPlay("GUI trainer card open", 100, 100)
	    
        $mouse.hide
        pbFadeOutIn do
        $mouse.hide
		  disposeTitle
        $mouse.hide
	     @main_loop = false
        $mouse.hide
         Game.start_new
        $mouse.hide
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
          pbFadeOutIn { pbDownloadMysteryGift(@save_data[:player]) }
        when cmd_update
		   pbValidateGameVersionAndUpdate(true)
        when cmd_language
		   disposeTitle
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
        pbFadeOutIn do
		   disposeTitle
		   @main_loop=false
          $scene = nil
          return
		  end
        #when cmd_delete
		 # save_data = SaveData.get_full_path(@selected_file)
		#  prompt_save_deletion_manual(save_data,@selected_file)
		#  @selected_file = SaveData.get_newest_save_slot
        else
          pbPlayBuzzerSE
        end

   elsif Input.trigger?(Input::BACK)
      @main_loop="goback!"
	  return
   else
   
   end
  
   return if @main_loop==false




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
  
   def prompt_save_deletion_manual(file_path,save)
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
