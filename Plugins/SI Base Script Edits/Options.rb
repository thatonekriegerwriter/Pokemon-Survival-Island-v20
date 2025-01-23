class PokemonSystem
  attr_accessor :textspeed
  attr_accessor :battlescene
  attr_accessor :battlestyle
  attr_accessor :sendtoboxes
  attr_accessor :givenicknames
  attr_accessor :frame
  attr_accessor :textskin
  attr_accessor :screensize
  attr_accessor :language
  attr_accessor :runstyle
  attr_accessor :difficulty
  attr_accessor :difficultymodifier
  attr_accessor :survivalmode
  attr_accessor :chapter
  attr_accessor :nuzlockemode
  attr_accessor :temperature
  attr_accessor :temperaturemeasurement
  attr_accessor :bgmvolume
  attr_accessor :sevolume
  attr_accessor :textinput
  attr_accessor :playermode
  attr_accessor :fastberries
  attr_accessor :potatocarrot
  attr_accessor :currentList
  attr_accessor :cheats
  attr_accessor :hardcore
  attr_accessor :hardcore2
  attr_accessor :hardcore3
  attr_accessor :hardcore4
  attr_accessor :hardcore5
  attr_accessor :hardcore6
  attr_accessor :hardcore7
  attr_accessor :hardcore8
  attr_accessor :hardcore9
  attr_accessor :hardcore10

  def initialize
    @textspeed     = 1     # Text speed (0=slow, 1=normal, 2=fast)
    @battlescene   = 0     # Battle effects (animations) (0=on, 1=off)
    @battlestyle   = 0     # Battle style (0=switch, 1=set)
    @sendtoboxes   = 0     # Send to Boxes (0=manual, 1=automatic)
    @givenicknames = 0     # Give nicknames (0=give, 1=don't give)
    @frame         = 0     # Default window frame (see also Settings::MENU_WINDOWSKINS)
    @textskin      = 0     # Speech frame
    @screensize    = (Settings::SCREEN_SCALE * 2).floor - 1   # 0=half size, 1=full size, 2=full-and-a-half size, 3=double size
    @language      = 0     # Language (see also Settings::LANGUAGES in script PokemonSystem)
    @survivalmode = 0     # Default Survival Mode (0=on, 1=off)
    @chapter = 1     # Default Survival Mode (0=on, 1=off)
    @nuzlockemode = 0     # Default Nuzlocke Mode (0=on, 1=off)
    @difficulty   = 1     # Default Nuzlocke Mode (0=on, 1=off)
    @difficultymodifier = 40     # Default Nuzlocke Mode (0=on, 1=off)
    @temperature = 0     # Default Temperature Mode (0=on, 1=off)	 
    @temperaturemeasurement = 0     # Default Temperature Mode (0=on, 1=off)
    @cheats = 1     # Default Temperature Mode (0=on, 1=off)
    @runstyle      = 0     # Default movement speed (0=walk, 1=run)
    @bgmvolume     = 100   # Volume of background music and ME
    @sevolume      = 100   # Volume of sound effects
    @textinput     = 1     # Text input mode (0=cursor, 1=keyboard)
    @playermode     = 1     # Text input mode (0=cursor, 1=keyboard)
    @hardcore     = 1     # Text input mode (0=cursor, 1=keyboard)
    @hardcore2     = 1     # Text input mode (0=cursor, 1=keyboard)
    @hardcore3     = 1     # Text input mode (0=cursor, 1=keyboard)
    @hardcore4     = 1     # Text input mode (0=cursor, 1=keyboard)
    @hardcore5     = 1     # Text input mode (0=cursor, 1=keyboard)
    @hardcore6     = 1     # Text input mode (0=cursor, 1=keyboard)
    @hardcore7     = 1     # Text input mode (0=cursor, 1=keyboard)
    @hardcore8     = 1     # Text input mode (0=cursor, 1=keyboard)
    @hardcore9     = 1     # Text input mode (0=cursor, 1=keyboard)
    @hardcore10     = 1     # Text input mode (0=cursor, 1=keyboard)
    @currentList = :main
  end
  
  def difficulty
    @difficulty   = 1 if @difficulty.nil?
	return @difficulty
  end
  def difficultymodifier
    @difficultymodifier = 40 if @difficultymodifier.nil?
	return @difficultymodifier
  end
end

#===============================================================================
#
#===============================================================================
module PropertyMixin
  attr_reader :name

  def get
    return @get_proc&.call
  end

  def set(*args)
    @set_proc&.call(*args)
  end
end

#===============================================================================
#
#===============================================================================
class EnumOption
  include PropertyMixin
  attr_accessor :values
  attr_reader :name

  def initialize(name, parent, values, get_proc, set_proc)
    @name     = name
    @values   = values.map { |val| _INTL(val) }
    @get_proc = get_proc
    @set_proc = set_proc
  end
  
  
  
  
  def next(current)
    index = current + 1
    index = @values.length - 1 if index > @values.length - 1
    return index
  end

  def prev(current)
    index = current - 1
    index = 0 if index < 0
    return index
  end
end

class AltOption
  include PropertyMixin
  attr_accessor :values
  attr_reader :name

  def initialize(name, parent, values, get_proc, set_proc)
    @name     = name
    @values   = values.map { |val| _INTL(val) }
    @get_proc = get_proc
    @set_proc = set_proc
  end

  def next(current)
    index = current + 1
    index = @values.length - 1 if index > @values.length - 1
    return index
  end

  def prev(current)
    index = current - 1
    index = 0 if index < 0
    return index
  end
end

class SelectOption
  include PropertyMixin
  attr_reader :name
  attr_accessor :values

  def initialize(name, parent, values, get_proc, set_proc)
    @name     = name
    @values     = values
  end
  
  def next(current)
  end

  def prev(current)
  end
  
  def act(current)
  end
end

#===============================================================================
#
#===============================================================================
class NumberOption
  include PropertyMixin
  attr_reader :lowest_value
  attr_reader :highest_value
  attr_reader :name
  attr_accessor :values

  def initialize(name, parent, range, get_proc, set_proc)
    @name = name
	@values = []
    case range
    when Range
      @lowest_value  = range.begin
      @highest_value = range.end
    when Array
      @lowest_value  = range[0]
      @highest_value = range[1]
    end
    @get_proc = get_proc
    @set_proc = set_proc
  end

  def next(current)
    index = current + @lowest_value
    index += 1
    index = @lowest_value if index > @highest_value
    return index - @lowest_value
  end

  def prev(current)
    index = current + @lowest_value
    index -= 1
    index = @highest_value if index < @lowest_value
    return index - @lowest_value
  end
  
  def act(current)
  end
end

#===============================================================================
#
#===============================================================================
class SliderOption
  include PropertyMixin
  attr_reader :lowest_value
  attr_reader :highest_value
  attr_reader :name
  attr_accessor :values

  def initialize(name, parent, range, get_proc, set_proc)
    @name          = name
	@values = []
    @lowest_value  = range[0]
    @highest_value = range[1]
    @interval      = range[2]
    @get_proc      = get_proc
    @set_proc      = set_proc
  end

  def next(current)
    index = current + @lowest_value
    index += @interval
    index = @highest_value if index > @highest_value
    return index - @lowest_value
  end

  def prev(current)
    index = current + @lowest_value
    index -= @interval
    index = @lowest_value if index < @lowest_value
    return index - @lowest_value
  end
  
  def act(current)
  end
end

#===============================================================================
# Main options list
#===============================================================================
class Window_PokemonOption < Window_DrawableCommand
  attr_reader :value_changed
  attr_accessor :options

  SEL_NAME_BASE_COLOR    = Color.new(192, 120, 0)
  SEL_NAME_SHADOW_COLOR  = Color.new(248, 176, 80)
  SEL_VALUE_BASE_COLOR   = Color.new(248, 48, 24)
  SEL_VALUE_SHADOW_COLOR = Color.new(248, 136, 128)

  def initialize(options, x, y, width, height)
    @options = options
    @values = []
    @options.length.times { |i| @values[i] = 0 }
    @value_changed = false
    super(x, y, width, height)
  end



  def set_options(options)
    @options = options
  end 
  
  def set_index(pos)
   self.index=pos
  end 


  def [](i)
    return @values[i]
  end




  def []=(i, value)
    @values[i] = value
    refresh
  end




  def setValueNoRefresh(i, value)
    @values[i] = value
  end




  def itemCount
    return @options.length + 1
  end




  def drawItem(index, _count, rect)
    rect = drawCursor(index, rect)
    sel_index = self.index
    # Draw option's name
    optionname = (index == @options.length) ? _INTL("Close") : @options[index].name
    optionwidth = rect.width * 9 / 20
    pbDrawShadowText(self.contents, rect.x, rect.y, optionwidth, rect.height, optionname,
                     (index == sel_index) ? SEL_NAME_BASE_COLOR : self.baseColor,
                     (index == sel_index) ? SEL_NAME_SHADOW_COLOR : self.shadowColor)
    return if index == @options.length
    # Draw option's values
    case @options[index]
    when EnumOption
      if @options[index].values.length > 1
        totalwidth = 0
        @options[index].values.each do |value|
          totalwidth += self.contents.text_size(value).width
        end
        spacing = (rect.width - rect.x - optionwidth  - totalwidth) / (@options[index].values.length - 1)
        spacing = 0 if spacing < 0
        xpos = optionwidth + rect.x
        ivalue = 0
        @options[index].values.each do |value|
          pbDrawShadowText(self.contents, xpos, rect.y, optionwidth, rect.height, value,
                           (ivalue == self[index]) ? SEL_VALUE_BASE_COLOR : self.baseColor,
                           (ivalue == self[index]) ? SEL_VALUE_SHADOW_COLOR : self.shadowColor)
          xpos += self.contents.text_size(value).width
          xpos += spacing
          ivalue += 1
        end
	   elsif @options[index].values.length == 0
      else
        totalwidth = 0
        @options[index].values.each do |value|
          totalwidth += self.contents.text_size(value).width
        end
        spacing = (rect.width - rect.x - optionwidth  - totalwidth) / (@options[index].values.length)
        spacing = 0 if spacing < 0
        xpos = optionwidth + rect.x
        ivalue = 0
        @options[index].values.each do |value|
          pbDrawShadowText(self.contents, xpos, rect.y, optionwidth, rect.height, value,
                           (ivalue == self[index]) ? SEL_VALUE_BASE_COLOR : self.baseColor,
                           (ivalue == self[index]) ? SEL_VALUE_SHADOW_COLOR : self.shadowColor)
          xpos += self.contents.text_size(value).width
          xpos += spacing
          ivalue += 1
        end

      end
    when AltOption
	
	
      if @options[index].values.length > 1
	  
	  
	  
        totalwidth = 0
		
		
        @options[index].values.each do |value|
          totalwidth += self.contents.text_size(value).width
        end
		
		
        spacing = (rect.width - rect.x - optionwidth  - totalwidth) / (@options[index].values.length - 1)
        spacing += 1.75
		 spacing += 20  if @options[index].values.length>3
        xpos = optionwidth + rect.x
        ivalue = 0
		amt = 0
		
		
		
		
        @options[index].values.each_with_index do |value, index2|
#		 if amt==0
          pbDrawShadowText(self.contents, xpos, rect.y, optionwidth, rect.height, value,
                           (ivalue == self[index]) ? SEL_VALUE_BASE_COLOR : self.baseColor,
                           (ivalue == self[index]) ? SEL_VALUE_SHADOW_COLOR : self.shadowColor)
          xpos += self.contents.text_size(value).width
          xpos += spacing
          ivalue += 1
		  amt+=1
		end
		
		
		
		
		
 #       end
 
 
 
 
 
      else
        pbDrawShadowText(self.contents, rect.x + optionwidth2, rect.y, optionwidth2, rect.height,
                         optionname, self.baseColor, self.shadowColor)
      end
	  
	  
	  
	  
	  
    when NumberOption
      value = _INTL("Type {1}/{2}", @options[index].lowest_value + self[index],
                    @options[index].highest_value - @options[index].lowest_value + 1)
      xpos = optionwidth + (rect.x * 2)
      pbDrawShadowText(self.contents, xpos, rect.y, optionwidth, rect.height, value,
                       SEL_VALUE_BASE_COLOR, SEL_VALUE_SHADOW_COLOR, 1)
    when SliderOption
      value = sprintf(" %d", @options[index].highest_value)
      sliderlength = rect.width - rect.x - optionwidth - self.contents.text_size(value).width
      xpos = optionwidth + rect.x
      self.contents.fill_rect(xpos, rect.y - 2 + (rect.height / 2), sliderlength, 4, self.baseColor)
      self.contents.fill_rect(
        xpos + ((sliderlength - 8) * (@options[index].lowest_value + self[index]) / @options[index].highest_value),
        rect.y - 8 + (rect.height / 2),
        8, 16, SEL_VALUE_BASE_COLOR
      )
      value = sprintf("%d", @options[index].lowest_value + self[index])
      xpos += (rect.width - rect.x - optionwidth) - self.contents.text_size(value).width
      pbDrawShadowText(self.contents, xpos, rect.y, optionwidth, rect.height, value,
                       SEL_VALUE_BASE_COLOR, SEL_VALUE_SHADOW_COLOR)
	when SelectOption
    else
      value = @options[index].values[self[index]]
      xpos = optionwidth + rect.x
      pbDrawShadowText(self.contents, xpos, rect.y, optionwidth, rect.height, value,
                       SEL_VALUE_BASE_COLOR, SEL_VALUE_SHADOW_COLOR)
    end
  end

  def update
    oldindex = self.index
    @value_changed = false
    super
    dorefresh = (self.index != oldindex)
    if self.active && self.index < @options.length
      if Input.repeat?(Input::LEFT)
	    oldself = self[self.index]
        self[self.index] = @options[self.index].prev(self[self.index])
        dorefresh = true
        @value_changed = true
      elsif Input.repeat?(Input::RIGHT)
	    oldself = self[self.index]
        self[self.index] = @options[self.index].next(self[self.index])
        dorefresh = true
        @value_changed = true
	  elsif Input.trigger?(Input::USE) && false
	    currentoption = @options[self.index]
		if currentoption.is_a? EnumOption
		  if currentoption.values.length == 1
		    currentoption.set(currentoption, self)
		    #pbHardcoreMode if currentoption.name == "Hardcore Mode"
		  end
		end
      end
    end
    refresh if dorefresh
  end
end

#===============================================================================
# Options main screen
#===============================================================================
class PokemonOption_Scene
  attr_reader :sprites
  attr_reader :in_load_screen
  attr_accessor :options
  attr_accessor :viewport
  attr_accessor :sprites
  def get_unique_parameters(hash,name)
     return hash["parameters"]	if $PokemonGlobal.nil?
  	 return [_INTL("Enabled")] if $PokemonGlobal.hardcore == true && name == "Hardcore Mode"
  	 return [_INTL("Enabled")] if nuzlocke_has?(:PERMADEATH) && name == "Nuzlocke Mode"
  	 return [_INTL("Enabled")] if nuzlocke_has?(:ONEROUTE) && name == "One Catch per Map"
  	 return [_INTL("Enabled")] if nuzlocke_has?(:NICKNAMES) && name == "Forced Nicknames"
  	 return [_INTL("Disabled")] if !nuzlocke_has?(:DUPSCLAUSE) && name == "Dups Clause"
  	 return [_INTL("Disabled")] if !nuzlocke_has?(:STATIC) && name == "Static Encounters"
  	 return [_INTL("Disabled")] if !nuzlocke_has?(:SHINY) && name == "Shiny Encounters"
  	 return [_INTL("Enabled")] if nuzlocke_has?(:AFULLEIGHTHOURS) && name == "A Full Eight Hours"
  	 return [_INTL("Enabled")] if nuzlocke_has?(:NOOVCATCHING) && name == "No Overworld Capture"
  	 return [_INTL("Enabled")] if nuzlocke_has?(:NOSTATUES) && name == "No Statues" 
  	 return [_INTL("Enabled")] if nuzlocke_has?(:SURVIVALMODE) && name == "Survival Mode (Pokemon)" 
	 
	 
    return hash["parameters"]	
  end
  def pbStartScene(in_load_screen = false)
    @in_load_screen = in_load_screen
	$PokemonSystem.currentList = :main
    # Get all options
    @options = []
    @hashes = []
    MenuHandlers.each_available(:options_menu) do |option, hash, name|
	  if hash["parent"].nil?
	    hash["parent"] = :main
	  end
	  if hash["parent"] == $PokemonSystem.currentList
      para = get_unique_parameters(hash,name)
      @options.push(hash["type"].new(name,hash["parent"], para, hash["get_proc"], hash["set_proc"]))
      @hashes.push(hash)
	  end
    end
    # Create sprites
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    addBackgroundOrColoredPlane(@sprites, "bg", "optionsbg", Color.new(192, 200, 208), @viewport)
    @sprites["title"] = Window_UnformattedTextPokemon.newWithSize(
      _INTL("Options"), 0, -16, Graphics.width, 64, @viewport
    )
    @sprites["title"].back_opacity = 0
    @sprites["textbox"] = pbCreateMessageWindow
    pbSetSystemFont(@sprites["textbox"].contents)
    @sprites["option"] = Window_PokemonOption.new(
      @options, 0, @sprites["title"].y + @sprites["title"].height - 16, Graphics.width,
      Graphics.height - (@sprites["title"].y + @sprites["title"].height - 16) - @sprites["textbox"].height
    )
	
	
    @sprites["option"].viewport = @viewport
    @sprites["option"].visible  = true
	
	
    # Get the values of each option
    @options.length.times { |i|  @sprites["option"].setValueNoRefresh(i, @options[i].get || 0) }
	
	
	
    @sprites["option"].refresh
	
	
    pbChangeSelection
	
	
    pbDeactivateWindows(@sprites)
	
	
    pbFadeInAndShow(@sprites) { pbUpdate }
	
	
	
	
  end

  def add(option, hash, name = nil, description = nil)
    @commands.push([option, hash["parent"], name || hash["name"], description || hash["description"]])
  end

  def list
    ret = []
    @commands.each { |cmd| ret.push(cmd[2]) if cmd[1] == @currentList }
    return ret
  end

  def getCommand(index)
    count = 0
    @commands.each do |cmd|
      next if cmd[1] != @currentList
      return cmd[0] if count == index
      count += 1
    end
    return nil
  end

  def getDesc(index)
    count = 0
    @commands.each do |cmd|
      next if cmd[1] != @currentList
      return cmd[3] if count == index && cmd[3]
      break if count == index
      count += 1
    end
    return "<No description available>"
  end

  def hasSubMenu?(check_cmd)
    @commands.each { |cmd| return true if cmd[1] == check_cmd }
    return false
  end

  def getParent
    ret = nil
    @commands.each do |cmd|
      next if cmd[0] != @currentList
      ret = cmd[1]
      break
    end
    return nil if !ret
    count = 0
    @commands.each do |cmd|
      next if cmd[1] != ret
      return [ret, count] if cmd[0] == @currentList
      count += 1
    end
    return [ret, 0]
  end


#===============================================================================
#
#===============================================================================

  def pbChangeSelection
    hash = @hashes[@sprites["option"].index]
    # Call selected option's "on_select" proc (if defined)
    @sprites["textbox"].letterbyletter = false
    hash["on_select"]&.call(self) if hash
    # Set descriptive text
    description = ""
    if hash
      if hash["description"].is_a?(Proc)
        description = hash["description"].call
      elsif !hash["description"].nil?
        description = _INTL(hash["description"])
      end
    else
      description = _INTL("Close the screen.")
    end
    @sprites["textbox"].text = description
  end

  def pbOptions
    pbActivateWindow(@sprites, "option") {
      index = -1
      loop do
        Graphics.update
        Input.update
        pbUpdate
        if @sprites["option"].index != index
          pbChangeSelection
          index = @sprites["option"].index
        end
        @options[index].set(@sprites["option"][index], self) if @sprites["option"].value_changed && !(@options[index].is_a?(EnumOption) &&  @options[index].values.length == 1)
        if Input.trigger?(Input::BACK)
	


		  if $game_temp.memorized_bgm && $game_system.is_a?(Game_System)
               $game_system.bgm_pause
               $game_system.bgm_position = $game_temp.memorized_bgm_position
               $game_system.bgm_resume($game_temp.memorized_bgm)
			    $game_temp.memorized_bgm = nil
			    $game_temp.memorized_bgm_position = nil
		  end


		 if $PokemonSystem.currentList == :main
          break
		 elsif $PokemonSystem.currentList != :main
		    $PokemonSystem.currentList = :main
			@sprites["option"].set_index(0)
			pbSceneControls
          @sprites["option"].refresh
		 end


       





	   elsif Input.trigger?(Input::USE)
		  if !defined?(@options[index].name)
		   if @sprites["option"].index == @options.length && $PokemonSystem.currentList == :main
		   break
		   elsif $PokemonSystem.currentList != :main
		    $PokemonSystem.currentList = :main
			@sprites["option"].set_index(0)
			pbSceneControls
          @sprites["option"].refresh
		   end
		  else
		  if @options[index].name == "Battle Gameplay Options..."
			$PokemonSystem.currentList = :gameplay_menu
			@sprites["option"].set_index(0)
			pbSceneControls
          @sprites["option"].refresh
		  elsif @options[index].name == "Overworld Gameplay Options..."
			$PokemonSystem.currentList = :gameplay_menu2
			@sprites["option"].set_index(0)
			pbSceneControls
          @sprites["option"].refresh
		  elsif @options[index].name == "User Interface Options..."
			$PokemonSystem.currentList = :ui_menu
			@sprites["option"].set_index(0)
			pbSceneControls
          @sprites["option"].refresh
		  elsif @options[index].name == "Music Options..."
			$PokemonSystem.currentList = :music_menu
			@sprites["option"].set_index(0)
			pbSceneControls
          @sprites["option"].refresh
		  elsif @options[index].name == "Challenge Options..."
			$PokemonSystem.currentList = :challenges_menu
			@sprites["option"].set_index(0)
			pbSceneControls
          @sprites["option"].refresh
		  elsif @options[index].name == "Controls Options..."
		    pbFadeOutIn(99999) {
	  	      open_set_controls_ui
	        }
		  elsif  @options[index].is_a?(EnumOption) &&  @options[index].values.length == 1
            @options[index].set(@sprites["option"][index], self)
		  elsif @sprites["option"].index == @options.length
		   break
		  end
        end
      end
	  end
    }
  end

  def pbEndScene
    pbPlayCloseMenuSE
    pbFadeOutAndHide(@sprites) { pbUpdate }
    # Set the values of each option, to make sure they're all set
    @options.length.times do |i|
      @options[i].set(@sprites["option"][i], self)
    end
    pbDisposeMessageWindow(@sprites["textbox"])
    pbDisposeSpriteHash(@sprites)
    pbUpdateSceneMap
    @viewport.dispose
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end
  
  def refresh_options
    @options = []
    @hashes = []
  
    MenuHandlers.each_available(:options_menu) do |option, hash, name|
	  if hash["parent"].nil?
	    hash["parent"] = :main
	  end
	  if hash["parent"] == $PokemonSystem.currentList
      para = get_unique_parameters(hash,name)
      @options.push(hash["type"].new(name,hash["parent"], para, hash["get_proc"], hash["set_proc"]))
      @hashes.push(hash)
	  end
    end
  
  
	@sprites["option"].set_options(@options)
	
	
    @options.length.times do |i|
	 @sprites["option"].setValueNoRefresh(i, @options[i].get || 0)
	end
	
    @sprites["option"].refresh
    pbChangeSelection
  end
  
  def pbSceneControls
    @options = []
    @hashes = []
    MenuHandlers.each_available(:options_menu) do |option, hash, name|
	  if hash["parent"].nil?
	    hash["parent"] = :main
	  end
	  if hash["parent"] == $PokemonSystem.currentList
      para = get_unique_parameters(hash,name)
      @options.push(hash["type"].new(name,hash["parent"], para, hash["get_proc"], hash["set_proc"]))
      @hashes.push(hash)
	  end
    end
	
	
	
	
	case $PokemonSystem.currentList 
    when :main
	  option = _INTL("Options")
    when :gameplay_menu
	  option = _INTL("Gameplay Options")
    when :gameplay_menu2
	  option = _INTL("Gameplay Options")
    when :ui_menu
	  option = _INTL("UI Options")
    when :music_menu
	  option = _INTL("Music Options")
    when :challenges_menu
	  option = _INTL("Challenges...")
	 else
	  option = _INTL("Options")
	end
    @sprites["title"].text = option
    pbSetSystemFont(@sprites["textbox"].contents)
	
	
	
    # Get the values of each option
	
	@sprites["option"].set_options(@options)
	
	
    @options.length.times do |i|
	 @sprites["option"].setValueNoRefresh(i, @options[i].get || 0)
	end
	
    @sprites["option"].refresh
    pbChangeSelection
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  def pbStartScene2(show_all = true, in_load_screen = false)
  # Get all commands
  commands = CommandMenuList.new
  MenuHandlers.each_available(:options_menu) do |option, hash, name|
    if hash["description"].is_a?(Proc)
      description = hash["description"].call
    elsif !hash["description"].nil?
      description = _INTL(hash["description"])
    end
 #     @options.push(
  #      hash["type"].new(name,hash["parent"], hash["parameters"], hash["get_proc"], hash["set_proc"])
   #   )
    #  @hashes.push(hash)
    commands.add(option, hash, name, description)
  end
  # Setup windows
  viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  viewport.z = 99999
  sprites = {}
  sprites["textbox"] = pbCreateMessageWindow
  sprites["textbox"].letterbyletter = false
  sprites["cmdwindow"] = Window_CommandPokemonEx.new(commands.list)
  cmdwindow = sprites["cmdwindow"]
  cmdwindow.x        = 0
  cmdwindow.y        = 0
  cmdwindow.width    = Graphics.width
  cmdwindow.height   = Graphics.height - sprites["textbox"].height
  cmdwindow.viewport = viewport
  cmdwindow.visible  = true
  sprites["textbox"].text = commands.getDesc(cmdwindow.index)
  pbFadeInAndShow(sprites)
  # Main loop
  ret = -1
  refresh = true
  loop do
    loop do
      oldindex = cmdwindow.index
      cmdwindow.update
      if refresh || cmdwindow.index != oldindex
        sprites["textbox"].text = commands.getDesc(cmdwindow.index)
        refresh = false
      end
      Graphics.update
      Input.update
      if Input.trigger?(Input::BACK)
        parent = commands.getParent
        if parent
          pbPlayCancelSE
          commands.currentList = parent[0]
          cmdwindow.commands = commands.list
          cmdwindow.index = parent[1]
          refresh = true
        else
          ret = -1
          break
        end
      elsif Input.trigger?(Input::USE)
        ret = cmdwindow.index
        break
      end
    end
    break if ret < 0
    cmd = commands.getCommand(ret)
    if commands.hasSubMenu?(cmd)
      pbPlayDecisionSE
      commands.currentList = cmd
      cmdwindow.commands = commands.list
      cmdwindow.index = 0
      refresh = true
    elsif cmd == :warp
      return if MenuHandlers.call(:debug_menu, cmd, "effect", sprites, viewport)
    else
      MenuHandlers.call(:debug_menu, cmd, "effect")
    end
  end
  pbPlayCloseMenuSE
  pbFadeOutAndHide(sprites)
  pbDisposeMessageWindow(sprites["textbox"])
  pbDisposeSpriteHash(sprites)
  viewport.dispose
end


end

#===============================================================================
#
#===============================================================================
class PokemonOptionScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen(in_load_screen = false)
    @scene.pbStartScene(in_load_screen)
    @scene.pbOptions
    @scene.pbEndScene
  end
end

#===============================================================================
# Options Menu commands
#===============================================================================


class PokemonGlobalMetadata
  attr_writer :hardcore #$PokemonGlobal.hardcore = true

  def hardcore
    @hardcore = false if !@hardcore
    return @hardcore
  end
end


MenuHandlers.add(:options_menu, :movement_style, {
  "name"        => _INTL("Double Tap to Run"),
  "parent"      => :main,
  "order"       => 28,
  "condition"   => proc { next $player },
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "description" => _INTL("Enables Double Tapping the Movement Controls to Run."),
  "get_proc"    => proc { next $PokemonSystem.runstyle },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.runstyle = value }
})



MenuHandlers.add(:options_menu, :screen_size, {
  "name"        => _INTL("Screen Size"),
  "parent"      => :main,
  "order"       => 28,
  "type"        => EnumOption,
  "parameters"  => [_INTL("S"), _INTL("M"), _INTL("L"), _INTL("XL") , _INTL("XXL"), _INTL("Full")],
  "description" => _INTL("Choose the size of the game window."),
  "get_proc"    => proc { next [$PokemonSystem.screensize, 5].min },
  "set_proc"    => proc { |value, _scene|
    next if $PokemonSystem.screensize == value
    $PokemonSystem.screensize = value
    pbSetResizeFactor($PokemonSystem.screensize)
  }
})



MenuHandlers.add(:options_menu, :controls_menu, {
  "name"        => _INTL("Controls Options..."),
  "parent"      => :main,
  "type"        => SelectOption,
  "order"       => 29,
  "description" => _INTL("View Options related to Controls..."),
})



MenuHandlers.add(:options_menu, :gameplay_menu, {
  "name"        => _INTL("Battle Gameplay Options..."),
  "parent"      => :main,
  "condition"   => proc { next $player },
  "type"        => SelectOption,
  "order"       => 31,
  "description" => _INTL("View Options Related to Gameplay in Battle..."),
})

MenuHandlers.add(:options_menu, :gameplay_menu2, {
  "name"        => _INTL("Overworld Gameplay Options..."),
  "parent"      => :main,
  "condition"   => proc { next $player },
  "type"        => SelectOption,
  "order"       => 31,
  "description" => _INTL("View Options Related to Gameplay in the Overworld..."),
})

MenuHandlers.add(:options_menu, :ui_menu, {
  "name"        => _INTL("User Interface Options..."),
  "parent"      => :main,
  "type"        => SelectOption,
  "order"       => 32,
  "description" => _INTL("View Options Related to the User Interface..."),
})

MenuHandlers.add(:options_menu, :music_menu, {
  "name"        => _INTL("Music Options..."),
  "parent"      => :main,
  "type"        => SelectOption,
  "order"       => 33,
  "description" => _INTL("View Options Related to the Music..."),
})
MenuHandlers.add(:options_menu, :challenges_menu, {
  "name"        => _INTL("Challenge Options..."),
  "parent"      => :main,
  "type"        => SelectOption,
  "condition"   => proc { 
  next $player
  next Nuzlocke.definedrules? == false
  next Nuzlocke.on? == false },
  "order"       => 37,
  "description" => _INTL("View Options that change the nature of the game..."),
  #"description" => _INTL("View Options that change the nature of the game...\nFor each enabled option, experience gain is increased."),
})

if false

MenuHandlers.add(:options_menu, :survivalmode, {
  "name"        => _INTL("Survival Mode"),
  "parent"      => :gameplay_menu2,
  "order"       => 37,
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "condition"   => proc { next $player },
  "description" => _INTL("Choose whether or not you play in Survival Mode."),
  "get_proc"    => proc { next $PokemonSystem.survivalmode },
  "set_proc"    => proc { |value, scene| $PokemonSystem.survivalmode = value }
})

MenuHandlers.add(:options_menu, :temperature, {
  "name"        => _INTL("Ambient Temperature"),
  "parent"      => :gameplay_menu2,
  "order"       => 39,
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "description" => _INTL("Choose whether or not Survival Mode has Temperature Mechanics."),
  "condition"   => proc { next $PokemonSystem.survivalmode == 0 && $player},
  "get_proc"    => proc { next $PokemonSystem.temperature },
  "set_proc"    => proc { |value, scene| $PokemonSystem.temperature = value }
})

MenuHandlers.add(:options_menu, :nuzlockemode, {
  "name"        => _INTL("Nuzlocke Mode"),
  "parent"      => :gameplay_menu2,
  "order"       => 40,
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "condition"   => proc { next $player },
  "description" => _INTL("Choose whether or not you play in Nuzlocke Mode."),
  "get_proc"    => proc { next $PokemonSystem.nuzlockemode },
  "set_proc"    => proc { |value, scene| $PokemonSystem.nuzlockemode = value 
  if $PokemonSystem.nuzlockemode == 0
    if Nuzlocke.definedrules? == true
      if Nuzlocke.on? == false
    scene.sprites["textbox"].text = ("Nuzlocke has been turned on.")
      Nuzlocke.toggle(true)
      end
    else 
    scene.sprites["textbox"].text = ("Nuzlocke has been started.")
      Nuzlocke.start
    end
  else
    if Nuzlocke.on? 
      Nuzlocke.toggle(false)
    scene.sprites["textbox"].text = ("Nuzlocke has been turned off.")
    end
  end}
})

end


#Main
MenuHandlers.add(:options_menu, :bgm_volume, {
  "name"        => _INTL("Music Volume"),
  "parent"      => :main,
  "order"       => 10,
  "type"        => SliderOption,
  "parameters"  => [0, 100, 5],   # [minimum_value, maximum_value, interval]
  "description" => _INTL("Adjust the volume of the background music."),
  "get_proc"    => proc { next $PokemonSystem.bgmvolume },
  "set_proc"    => proc { |value, scene|
    next if $PokemonSystem.bgmvolume == value
    $PokemonSystem.bgmvolume = value
    next if $game_system.playing_bgm.nil?
    playingBGM = $game_system.getPlayingBGM
    $game_system.bgm_pause
    $game_system.bgm_resume(playingBGM)
  }
})

MenuHandlers.add(:options_menu, :se_volume, {
  "name"        => _INTL("SE Volume"),
  "parent"      => :main,
  "order"       => 20,
  "type"        => SliderOption,
  "parameters"  => [0, 100, 5],   # [minimum_value, maximum_value, interval]
  "description" => _INTL("Adjust the volume of sound effects."),
  "get_proc"    => proc { next $PokemonSystem.sevolume },
  "set_proc"    => proc { |value, _scene|
    next if $PokemonSystem.sevolume == value
    $PokemonSystem.sevolume = value
    if $game_system.playing_bgs
      $game_system.playing_bgs.volume = value
      playingBGS = $game_system.getPlayingBGS
      $game_system.bgs_pause
      $game_system.bgs_resume(playingBGS)
    end
    pbPlayCursorSE
  }
})

MenuHandlers.add(:options_menu, :text_speed, {
  "name"        => _INTL("Text Speed"),
  "parent"      => :ui_menu,
  "order"       => 30,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Slow"), _INTL("Normal"), _INTL("Fast")],
  "description" => _INTL("Choose the speed at which text appears."),
  "on_select"   => proc { |scene| scene.sprites["textbox"].letterbyletter = true },
  "get_proc"    => proc { next $PokemonSystem.textspeed },
  "set_proc"    => proc { |value, scene|
    next if value == $PokemonSystem.textspeed
    $PokemonSystem.textspeed = value
    MessageConfig.pbSetTextSpeed(MessageConfig.pbSettingToTextSpeed(value))
    # Display the message with the selected text speed to gauge it better.
    scene.sprites["textbox"].textspeed      = MessageConfig.pbGetTextSpeed
    scene.sprites["textbox"].letterbyletter = true
    scene.sprites["textbox"].text           = scene.sprites["textbox"].text
  }
})


def pbHardcoreMode
     return false if $PokemonGlobal.hardcore == true
      if pbConfirmMessageSerious(_INTL("Are you sure you want to enable 'Hardcore Mode'? This can only be reversed by starting a new save."))
          $PokemonGlobal.hardcore = true
      end
end


MenuHandlers.add(:options_menu, :hardcore, {
  "name"        => _INTL("Hardcore Mode"),
  "parent"      => :challenges_menu,
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Enable")],
  "description" => _INTL("Enables 'Hardcore Mode'. You only have one life, and one save. Upon dying, your save is deleted."),
  "condition"   => proc { 
  next $player
  next $PokemonGlobal },
  "get_proc"    => proc { next $PokemonSystem.hardcore },
  "set_proc"    => proc { |value, scene|
     value = 0 if $PokemonGlobal.hardcore==false
     value = 1 if $PokemonGlobal.hardcore==true
    next if scene.in_load_screen 
	if value == 0
    pbHardcoreMode
	 if $PokemonGlobal.hardcore==true
	 options = scene.options
	 options.each do |option|
	   if option.name =="Hardcore Mode"
	     option.values=[_INTL("Enabled")]
	   end
	 
	 end
	scene.sprites["option"].set_options(options)
    scene.sprites["option"].refresh
	scene.refresh_options
	 else
	  value = 0
	 end
    else 
    scene.sprites["textbox"].text           = "'Hardcore Mode' is already enabled, and cannot be disabled."
	end
  }
})


def pbNuzlockeMode
     return false if nuzlocke_has?(:PERMADEATH)
      if pbConfirmMessageSerious(_INTL("Are you sure you want to enable 'Nuzlocke Mode'? This can only be reversed by starting a new save."))
         pbAddNuzlockeRule(:PERMADEATH)
         Nuzlocke.set_rules($PokemonGlobal.nuzlockeRules)
      end
end


MenuHandlers.add(:options_menu, :permadeath, {
  "name"        => _INTL("Nuzlocke Mode"),
  "parent"      => :challenges_menu,
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Enable")],
  "description" => _INTL("Enables 'Nuzlocke Mode'. When your Pokemon dies, it will be removed from your party with no recovery."),
  "condition"   => proc { 
  next $player
  next $PokemonGlobal},
  "get_proc"    => proc { next $PokemonSystem.hardcore2 },
  "set_proc"    => proc { |value, scene|
     value = 0 if !nuzlocke_has?(:PERMADEATH)
     value = 1 if nuzlocke_has?(:PERMADEATH)
    next if scene.in_load_screen 
	if value == 0
	 pbNuzlockeMode
	 if nuzlocke_has?(:PERMADEATH)
	 options = scene.options
	 options.each do |option|
	   if option.name =="Nuzlocke Mode"
	     option.values=[_INTL("Enabled")]
	   end
	 
	 end
	scene.sprites["option"].set_options(options)
    scene.sprites["option"].refresh
	scene.refresh_options
	 else
	  value = 0
	 end
    else 
    scene.sprites["textbox"].text           = "'Nuzlocke Mode' is already enabled, and cannot be disabled."
	end
  }
})



def pbOneRoute
     return false if nuzlocke_has?(:ONEROUTE)
      if pbConfirmMessageSerious(_INTL("Are you sure you want to enable 'One Catch per Map'? This can only be reversed by starting a new save."))
         pbAddNuzlockeRule(:ONEROUTE)
         pbAddNuzlockeRule(:DUPSCLAUSE)
         pbAddNuzlockeRule(:STATIC)
         pbAddNuzlockeRule(:SHINY)
         Nuzlocke.set_rules($PokemonGlobal.nuzlockeRules)
      end
end


MenuHandlers.add(:options_menu, :one_route, {
  "name"        => _INTL("One Catch per Map"),
  "parent"      => :challenges_menu,
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Enable")],
  "description" => _INTL("Enables 'One Catch per Map'. You can only capture one encounter per map. [NOT FINISHED]"),
  "condition"   => proc { 
  next $player && $PokemonGlobal},
  "get_proc"    => proc { next $PokemonSystem.hardcore3 },
  "set_proc"    => proc { |value, scene|
     value = 0 if !nuzlocke_has?(:ONEROUTE)
     value = 1 if nuzlocke_has?(:ONEROUTE)
    next if scene.in_load_screen 
	if value == 0
	 pbOneRoute
	 if nuzlocke_has?(:ONEROUTE)
	 options = scene.options
	 options.each do |option|
	   if option.name =="One Catch per Map"
	     option.values=[_INTL("Enabled")]
	   end
	 
	 end
	scene.sprites["option"].set_options(options)
    scene.sprites["option"].refresh
	scene.refresh_options
	 else
	  value = 0
	 end
    else 
	 puts $PokemonGlobal.nuzlockeRules.to_s
    scene.sprites["textbox"].text           = "'One Catch per Map' is already enabled, and cannot be disabled."
	end
  }
})

def pbDupsClause
     return false if !nuzlocke_has?(:DUPSCLAUSE)
      if pbConfirmMessageSerious(_INTL("Are you sure you want to disable 'Dups Clause'? This can only be reversed by starting a new save."))
         pbDeleteNuzlockeRule(:DUPSCLAUSE)
         Nuzlocke.set_rules($PokemonGlobal.nuzlockeRules)
      end
end


MenuHandlers.add(:options_menu, :dups_clause, {
  "name"        => _INTL("Dups Clause"),
  "parent"      => :challenges_menu,
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Disable")],
  "description" => _INTL("Disables 'Dups Clause'. 'Dups Clause' does not count duplicates of already caught species to the encounter limit."),
  "condition"   => proc { 
  next $player && $PokemonGlobal && nuzlocke_has?(:ONEROUTE)},
  "get_proc"    => proc { next $PokemonSystem.hardcore3 },
  "set_proc"    => proc { |value, scene|
     value = 0 if nuzlocke_has?(:DUPSCLAUSE)
     value = 1 if !nuzlocke_has?(:DUPSCLAUSE)
    next if scene.in_load_screen 
  next nuzlocke_has?(:ONEROUTE)
	if value == 0
	 pbDupsClause
	 if !nuzlocke_has?(:DUPSCLAUSE)
	 options = scene.options
	 options.each do |option|
	   if option.name =="Dups Clause"
	     option.values=[_INTL("Disabled")]
	   end
	 
	 end
	scene.sprites["option"].set_options(options)
    scene.sprites["option"].refresh
	scene.refresh_options
	 else
	  value = 0
	 end
    else 
    scene.sprites["textbox"].text           = "'Dups Clause' is already disabled, and cannot be enabled."
	end
  }
})




def pbStaticClause
     return false if !nuzlocke_has?(:STATIC)
      if pbConfirmMessageSerious(_INTL("Are you sure you want to disable 'Static Encounters'? This can only be reversed by starting a new save."))
         pbDeleteNuzlockeRule(:STATIC)
         Nuzlocke.set_rules($PokemonGlobal.nuzlockeRules)
      end
end


MenuHandlers.add(:options_menu, :static_clause, {
  "name"        => _INTL("Static Encounters"),
  "parent"      => :challenges_menu,
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Disable")],
  "description" => _INTL("Disables 'Static Encounters'. 'Static Encounters' are not currently counting to your encounter limit."),
  "condition"   => proc { 
  next $player && $PokemonGlobal && nuzlocke_has?(:ONEROUTE)},
  "get_proc"    => proc { next $PokemonSystem.hardcore4 },
  "set_proc"    => proc { |value, scene|
     value = 0 if nuzlocke_has?(:STATIC)
     value = 1 if !nuzlocke_has?(:STATIC)
    next if scene.in_load_screen 
  next nuzlocke_has?(:ONEROUTE)
	if value == 0
	 pbStaticClause
	 if !nuzlocke_has?(:STATIC)
	 options = scene.options
	 options.each do |option|
	   if option.name =="Static Encounters"
	     option.values=[_INTL("Disabled")]
	   end
	 
	 end
	scene.sprites["option"].set_options(options)
    scene.sprites["option"].refresh
	scene.refresh_options
	 else
	  value = 0
	 end
    else 
    scene.sprites["textbox"].text           = "'Static Encounters' is already disabled, and cannot be enabled."
	end
  }
})





def pbShinyClause
     return false if !nuzlocke_has?(:SHINY)
      if pbConfirmMessageSerious(_INTL("Are you sure you want to disable 'Shiny Encounters'? This can only be reversed by starting a new save."))
         pbDeleteNuzlockeRule(:SHINY)
         Nuzlocke.set_rules($PokemonGlobal.nuzlockeRules)
      end
end


MenuHandlers.add(:options_menu, :shiny_clause, {
  "name"        => _INTL("Shiny Encounters"),
  "parent"      => :challenges_menu,
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Disable")],
  "description" => _INTL("Disables 'Shiny Encounters'. 'Shiny Encounters' are not currently counting to your encounter limit."),
  "condition"   => proc { 
  next $player && $PokemonGlobal && nuzlocke_has?(:ONEROUTE)},
  "get_proc"    => proc { next $PokemonSystem.hardcore5 },
  "set_proc"    => proc { |value, scene|
     value = 0 if nuzlocke_has?(:SHINY)
     value = 1 if !nuzlocke_has?(:SHINY)
    next if scene.in_load_screen 
    next nuzlocke_has?(:ONEROUTE)
	if value == 0
	 pbShinyClause
	 if !nuzlocke_has?(:SHINY)
	 options = scene.options
	 options.each do |option|
	   if option.name =="Shiny Encounters"
	     option.values=[_INTL("Disabled")]
	   end
	 
	 end
	scene.sprites["option"].set_options(options)
    scene.sprites["option"].refresh
	scene.refresh_options
	 else
	  value = 0
	 end
    else 
    scene.sprites["textbox"].text           = "'Shiny Encounters' is already disabled, and cannot be enabled."
	end
  }
})





def pbNicknameClause
     return false if !nuzlocke_has?(:NICKNAMES)
      if pbConfirmMessageSerious(_INTL("Are you sure you want to enable 'Forced Nicknames'? This can only be reversed by starting a new save."))
         pbAddNuzlockeRule(:NICKNAMES)
         Nuzlocke.set_rules($PokemonGlobal.nuzlockeRules)
      end
end


MenuHandlers.add(:options_menu, :nicknameforcing, {
  "name"        => _INTL("Forced Nicknames"),
  "parent"      => :challenges_menu,
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Enable")],
  "description" => _INTL("Enables 'Forced Nicknames'. 'Forced Nicknames' forces you to give a Pokemon a name more than 2 characters."),
  "condition"   => proc { 
  next $player && $PokemonGlobal},
  "get_proc"    => proc { next $PokemonSystem.hardcore6 },
  "set_proc"    => proc { |value, scene|
     value = 0 if nuzlocke_has?(:NICKNAMES)
     value = 1 if !nuzlocke_has?(:NICKNAMES)
    next if scene.in_load_screen 
	if value == 0
	 pbShinyClause
	 if !nuzlocke_has?(:NICKNAMES)
	 options = scene.options
	 options.each do |option|
	   if option.name =="Forced Nicknames"
	     option.values=[_INTL("Enabled")]
	   end
	 
	 end
	scene.sprites["option"].set_options(options)
    scene.sprites["option"].refresh
	scene.refresh_options
	 else
	  value = 0
	 end
    else 
    scene.sprites["textbox"].text           = "'Forced Nicknames' is already enabled, and cannot be disabled."
	end
  }
})





def pbSleepClause
     return false if !nuzlocke_has?(:AFULLEIGHTHOURS)
      if pbConfirmMessageSerious(_INTL("Are you sure you want to enable 'A Full Eight Hours'? This can only be reversed by starting a new save."))
         pbAddNuzlockeRule(:AFULLEIGHTHOURS)
         Nuzlocke.set_rules($PokemonGlobal.nuzlockeRules)
      end
end


MenuHandlers.add(:options_menu, :sleepforcing, {
  "name"        => _INTL("A Full Eight Hours"),
  "parent"      => :challenges_menu,
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Enable")],
  "description" => _INTL("Enables 'A Full Eight Hours'. 'A Full Eight Hours' forces you to sleep 8 hours every time you go to bed."),
  "condition"   => proc { 
  next $player && $PokemonGlobal},
  "get_proc"    => proc { next $PokemonSystem.hardcore7 },
  "set_proc"    => proc { |value, scene|
     value = 0 if nuzlocke_has?(:AFULLEIGHTHOURS)
     value = 1 if !nuzlocke_has?(:AFULLEIGHTHOURS)
    next if scene.in_load_screen 
	if value == 0
	 pbSleepClause
	 if !nuzlocke_has?(:AFULLEIGHTHOURS)
	 options = scene.options
	 options.each do |option|
	   if option.name =="A Full Eight Hours"
	     option.values=[_INTL("Enabled")]
	   end
	 
	 end
	scene.sprites["option"].set_options(options)
    scene.sprites["option"].refresh
	scene.refresh_options
	 else
	  value = 0
	 end
    else 
    scene.sprites["textbox"].text           = "'A Full Eight Hours' is already enabled, and cannot be disabled."
	end
  }
})



def pbOverworldClause
     return false if !nuzlocke_has?(:NOOVCATCHING)
      if pbConfirmMessageSerious(_INTL("Are you sure you want to enable 'No Overworld Capture'? This can only be reversed by starting a new save."))
         pbAddNuzlockeRule(:NOOVCATCHING)
         Nuzlocke.set_rules($PokemonGlobal.nuzlockeRules)
      end
end


MenuHandlers.add(:options_menu, :nocatchforcing, {
  "name"        => _INTL("No Overworld Capture"),
  "parent"      => :challenges_menu,
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Enable")],
  "description" => _INTL("Enables 'No Overworld Capture'. 'No Overworld Capture' forces you to capture Pokemon in turn based combat."),
  "condition"   => proc { 
  next $player && $PokemonGlobal},
  "get_proc"    => proc { next $PokemonSystem.hardcore8 },
  "set_proc"    => proc { |value, scene|
     value = 0 if nuzlocke_has?(:NOOVCATCHING)
     value = 1 if !nuzlocke_has?(:NOOVCATCHING)
    next if scene.in_load_screen 
	if value == 0
	 pbOverworldClause
	 if !nuzlocke_has?(:NOOVCATCHING)
	 options = scene.options
	 options.each do |option|
	   if option.name =="No Overworld Capture"
	     option.values=[_INTL("Enabled")]
	   end
	 
	 end
	scene.sprites["option"].set_options(options)
    scene.sprites["option"].refresh
	scene.refresh_options
	 else
	  value = 0
	 end
    else 
    scene.sprites["textbox"].text           = "'No Overworld Capture' is already enabled, and cannot be disabled."
	end
  }
})



def pbStatuesClause
     return false if !nuzlocke_has?(:NOSTATUES)
      if pbConfirmMessageSerious(_INTL("Are you sure you want to enable 'No Statues'? This can only be reversed by starting a new save."))
         pbAddNuzlockeRule(:NOSTATUES)
         Nuzlocke.set_rules($PokemonGlobal.nuzlockeRules)
      end
end


MenuHandlers.add(:options_menu, :nostatueforcing, {
  "name"        => _INTL("No Statues"),
  "parent"      => :challenges_menu,
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Enable")],
  "description" => _INTL("Enables 'No Statues'. 'No Statues' removes all statues from being accessable."),
  "condition"   => proc { 
  next $player && $PokemonGlobal},
  "get_proc"    => proc { next $PokemonSystem.hardcore9 },
  "set_proc"    => proc { |value, scene|
     value = 0 if nuzlocke_has?(:NOSTATUES)
     value = 1 if !nuzlocke_has?(:NOSTATUES)
    next if scene.in_load_screen 
	if value == 0
	 pbStatuesClause
	 if !nuzlocke_has?(:NOSTATUES)
	 options = scene.options
	 options.each do |option|
	   if option.name =="No Statues"
	     option.values=[_INTL("Enabled")]
	   end
	 
	 end
	scene.sprites["option"].set_options(options)
    scene.sprites["option"].refresh
	scene.refresh_options
	 else
	  value = 0
	 end
    else 
    scene.sprites["textbox"].text           = "'No Statues' is already enabled, and cannot be disabled."
	end
  }
})



def pbSurvivalClause
     return false if !nuzlocke_has?(:SURVIVALMODE)
      if pbConfirmMessageSerious(_INTL("Are you sure you want to enable 'Survival Mode (Pokemon)'? This can only be reversed by starting a new save."))
         pbAddNuzlockeRule(:SURVIVALMODE)
         Nuzlocke.set_rules($PokemonGlobal.nuzlockeRules)
      end
end


MenuHandlers.add(:options_menu, :pkmnfoodandwater, {
  "name"        => _INTL("Survival Mode (Pokemon)"),
  "parent"      => :challenges_menu,
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Enable")],
  "description" => _INTL("[INCOMPLETE] Enables 'Survival Mode (Pokemon)'. 'Survival Mode (Pokemon)' causes Pokemon to have Food, Water, and Sleep stats like the player."),
  "condition"   => proc { 
  next $player && $PokemonGlobal},
  "get_proc"    => proc { next $PokemonSystem.hardcore10 },
  "set_proc"    => proc { |value, scene|
     value = 0 if nuzlocke_has?(:SURVIVALMODE)
     value = 1 if !nuzlocke_has?(:SURVIVALMODE)
    next if scene.in_load_screen 
	if value == 0
	 pbSurvivalClause
	 if !nuzlocke_has?(:SURVIVALMODE)
	 options = scene.options
	 options.each do |option|
	   if option.name =="Survival Mode (Pokemon)"
	     option.values=[_INTL("Enabled")]
	   end
	 
	 end
	scene.sprites["option"].set_options(options)
    scene.sprites["option"].refresh
	scene.refresh_options
	 else
	  value = 0
	 end
    else 
    scene.sprites["textbox"].text           = "'Survival Mode (Pokemon)' is already enabled, and cannot be disabled."
	end
  }
})

























MenuHandlers.add(:options_menu, :tension_screen, {
  "name"        => _INTL("Tension Screen"),
  "parent"      => :ui_menu,
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "description" => _INTL("Display the tension screen within you are within attack range."),
  "condition"   => proc { next $player },
  "get_proc"    => proc { next $PokemonSystem.tension_screen },
  "set_proc"    => proc { |value, scene|
    next if scene.in_load_screen 
      $PokemonSystem.tension_screen = value }
  }
)



MenuHandlers.add(:options_menu, :simple_title, {
  "name"        => _INTL("Simple Title Screen"),
  "parent"      => :ui_menu,
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Off"), _INTL("On")],
  "description" => _INTL("Shows a more Vanilla styled titled screen."),
  "get_proc"    => proc { next getSIDataStatus("classicTitleScreen") },
  "set_proc"    => proc { |value, scene|
      setSIDataStatus("classicTitleScreen",value) }
  }
)

  MenuHandlers.add(:options_menu, :disable_fogs, {
    "name"        => _INTL("Reduced Lighting Effects"),
    "parent"      => :ui_menu,
    "order"       => 80,
    "type"        => EnumOption,
    "parameters"  => [_INTL("Off"), _INTL("On")],
    "description" => _INTL("Reduces lighting effects in certain areas of the game in order to aid visibility."),
    "get_proc"    => proc { next $PokemonSystem.disable_fogs },
    "set_proc"    => proc { |value, _sceme| $PokemonSystem.disable_fogs = value }
  })





# Battle Stuff

MenuHandlers.add(:options_menu, :battle_animations, {
  "name"        => _INTL("Battle Effects"),
  "parent"      => :ui_menu,
  "order"       => 43,
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "description" => _INTL("Choose whether you wish to see move animations in battle."),
  "get_proc"    => proc { next $PokemonSystem.battlescene },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.battlescene = value }
})

MenuHandlers.add(:options_menu, :battle_style, {
  "name"        => _INTL("Battle Style"),
  "parent"      => :gameplay_menu,
  "order"       => 50,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Switch"), _INTL("Set")],
  "description" => _INTL("Choose whether you can switch Pokémon when an opponent's Pokémon faints."),
  "get_proc"    => proc { next $PokemonSystem.battlestyle },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.battlestyle = value }
})

MenuHandlers.add(:options_menu, :send_to_boxes, {
  "name"        => _INTL("Send to Boxes"),
  "parent"      => :gameplay_menu,
  "order"       => 70,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Manual"), _INTL("Automatic")],
  "description" => _INTL("Choose whether caught Pokémon are sent to your Boxes when your party is full."),
  "condition"   => proc { next Settings::NEW_CAPTURE_CAN_REPLACE_PARTY_MEMBER },
  "get_proc"    => proc { next $PokemonSystem.sendtoboxes },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.sendtoboxes = value }
})

MenuHandlers.add(:options_menu, :give_nicknames, {
  "name"        => _INTL("Give Nicknames"),
  "parent"      => :gameplay_menu,
  "order"       => 80,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Give"), _INTL("Don't give")],
  "description" => _INTL("Choose whether you can give a nickname to a Pokémon when you obtain it."),
  "get_proc"    => proc { next $PokemonSystem.givenicknames },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.givenicknames = value }
})

#Overworld Stuff


#UI Stuff




MenuHandlers.add(:options_menu, :speech_frame, {
  "name"        => _INTL("Speech Frame"),
  "parent"      => :ui_menu,
  "order"       => 90,
  "type"        => NumberOption,
  "parameters"  => 1..Settings::SPEECH_WINDOWSKINS.length,
  "description" => _INTL("Choose the appearance of dialogue boxes."),
  "get_proc"    => proc { next $PokemonSystem.textskin },
  "set_proc"    => proc { |value, scene|
    $PokemonSystem.textskin = value
    MessageConfig.pbSetSpeechFrame("Graphics/Windowskins/" + Settings::SPEECH_WINDOWSKINS[value])
    # Change the windowskin of the options text box to selected one
    scene.sprites["textbox"].setSkin(MessageConfig.pbGetSpeechFrame)
  }
})

MenuHandlers.add(:options_menu, :menu_frame, {
  "name"        => _INTL("Menu Frame"),
  "parent"      => :ui_menu,
  "order"       => 100,
  "type"        => NumberOption,
  "parameters"  => 1..Settings::MENU_WINDOWSKINS.length,
  "description" => _INTL("Choose the appearance of menu boxes."),
  "get_proc"    => proc { next $PokemonSystem.frame },
  "set_proc"    => proc { |value, scene|
    $PokemonSystem.frame = value
    MessageConfig.pbSetSystemFrame("Graphics/Windowskins/" + Settings::MENU_WINDOWSKINS[value])
    # Change the windowskin of the options text box to selected one
    scene.sprites["option"].setSkin(MessageConfig.pbGetSystemFrame)
  }
})


#[_INTL("Classic SI"), _INTL("Kanto"), _INTL("Johto"), _INTL("Hoenn"), _INTL("Sinnoh"), _INTL("Unova"), _INTL("Stadium"),_INTL("Colosseum")]
MenuHandlers.add(:options_menu, :wbattle_music, {
  "name"        => _INTL("Wild Battle Music"),
  "parent"      => :music_menu,
  "order"       => 1,
  "type"        => NumberOption,
  "parameters"  => 0..9,
  "description" => _INTL("Choose your Wild Battle Theme."),
  "get_proc"    => proc { next $PokemonSystem.wildbattleMusic },
  "set_proc"    => proc { |value, scene| 
  $PokemonSystem.wildbattleMusic = value

  if $game_system.is_a?(Game_System) && !$game_temp.memorized_bgm
    $game_system.bgm_pause
    $game_temp.memorized_bgm = $game_system.getPlayingBGM
    $game_temp.memorized_bgm_position = (Audio.bgm_pos rescue 0)
  end
   testbgm = pbGetWildBGM 
   scene.sprites["textbox"].text = (testbgm) if testbgm
   if testbgm == $game_temp.memorized_bgm && $game_system.is_a?(Game_System)
      $game_system.bgm_pause
      $game_system.bgm_position = $game_temp.memorized_bgm_position
      $game_system.bgm_resume($game_temp.memorized_bgm)
	  $game_temp.memorized_bgm = nil
		$game_temp.memorized_bgm_position = nil
		 
   else
   bgm = pbStringToAudioFile(testbgm) if testbgm
   pbBGMPlay(bgm) if testbgm
   end
  }
})
#[_INTL("Default"), _INTL("Map Theme"), _INTL("Wild Arms"), _INTL("Chrono Trigger"), _INTL("Stadium"),_INTL("Colosseum")]
MenuHandlers.add(:options_menu, :bossbattle_music, {
  "name"        => _INTL("Boss Battle Music"),
  "parent"      => :music_menu,
  "order"       => 4,
  "type"        => NumberOption,
  "parameters"  => 0..5,
  "description" => _INTL("Choose your Boss Battle Theme."),
  "get_proc"    => proc { next $PokemonSystem.bossbattleMusic },
  "set_proc"    => proc { |value, scene| $PokemonSystem.bossbattleMusic = value

  if $game_system.is_a?(Game_System) && !$game_temp.memorized_bgm
    $game_system.bgm_pause
    $game_temp.memorized_bgm = $game_system.getPlayingBGM
    $game_temp.memorized_bgm_position = (Audio.bgm_pos rescue 0)
  end
   testbgm = pbGetBossBattleBGM 
   scene.sprites["textbox"].text = (testbgm) if testbgm
   bgm = pbStringToAudioFile(testbgm) if testbgm
   pbBGMPlay(bgm) if testbgm }
})
#[_INTL("Default"),_INTL("Map Theme"),_INTL("Kanto"), _INTL("Johto"), _INTL("Hoenn"), _INTL("Sinnoh"), _INTL("Unova")]
MenuHandlers.add(:options_menu, :surf_music, {
  "name"        => _INTL("Surfing Music"),
  "parent"      => :music_menu,
  "order"       => 7,
  "type"        => NumberOption,
  "parameters"  => 0..6,
  "description" => _INTL("Choose your Surfing Theme."),
  "get_proc"    => proc { next $PokemonSystem.surfMusic },
  "set_proc"    => proc { |value, scene| $PokemonSystem.surfMusic = value

  if $game_system.is_a?(Game_System) && !$game_temp.memorized_bgm
    $game_system.bgm_pause
    $game_temp.memorized_bgm = $game_system.getPlayingBGM
    $game_temp.memorized_bgm_position = (Audio.bgm_pos rescue 0)
  end
   testbgm = pbGetSurfBGM 
   scene.sprites["textbox"].text = (testbgm) if testbgm
   if testbgm == $game_temp.memorized_bgm && $game_system.is_a?(Game_System)
      $game_system.bgm_pause
      $game_system.bgm_position = $game_temp.memorized_bgm_position
      $game_system.bgm_resume($game_temp.memorized_bgm)
	  $game_temp.memorized_bgm = nil
		$game_temp.memorized_bgm_position = nil
		 
   else
   bgm = pbStringToAudioFile(testbgm) if testbgm
   pbBGMPlay(bgm) if testbgm
   end
}})

MenuHandlers.add(:options_menu, :wvbattle_music, {
  "name"        => _INTL("Wild Victory Music"),
  "parent"      => :music_menu,
  "order"       => 8,
  "type"        => NumberOption,
  "condition"   => proc { next $DEBUG && 1==2},
  "parameters"  => [_INTL("Kanto"), _INTL("Johto"), _INTL("Hoenn"), _INTL("Sinnoh"), _INTL("Unova"), _INTL("Stadium"),_INTL("Colosseum")],
  "description" => _INTL("Choose your Wild Battle Theme."),
  "get_proc"    => proc { next $PokemonSystem.wildvictoryMusic },
  "set_proc"    => proc { |value, scene| $PokemonSystem.wildvictoryMusic = value }
})

MenuHandlers.add(:options_menu, :tvbattle_music, {
  "name"        => _INTL("Trainer Victory Music"),
  "parent"      => :music_menu,
  "order"       => 9,
  "type"        => AltOption,
  "condition"   => proc { next $DEBUG && 1==2},
  "parameters"  => [_INTL("Kanto"), _INTL("Johto"), _INTL("Hoenn"), _INTL("Sinnoh"), _INTL("Unova"), _INTL("Stadium"),_INTL("Colosseum")],
  "description" => _INTL("Choose your Wild Battle Theme."),
  "get_proc"    => proc { next $PokemonSystem.trainervictoryMusic },
  "set_proc"    => proc { |value, scene| $PokemonSystem.trainervictoryMusic = value }
})

MenuHandlers.add(:options_menu, :lowbattle_music, {
  "name"        => _INTL("Low HP SFX"),
  "parent"      => :music_menu,
  "order"       => 12,
  "type"        => AltOption,
  "parameters"  => [_INTL("Off"), _INTL("Ding"), _INTL("Music")],
  "description" => _INTL("Choose if you hear something for low health."),
  "get_proc"    => proc { next $PokemonSystem.lowHPMusic },
  "set_proc"    => proc { |value, scene| $PokemonSystem.lowHPMusic = value

  if $game_system.is_a?(Game_System) && !$game_temp.memorized_bgm
    $game_system.bgm_pause
    $game_temp.memorized_bgm = $game_system.getPlayingBGM
    $game_temp.memorized_bgm_position = (Audio.bgm_pos rescue 0)
  end
   testbgm = pbGetBeepGM 
   scene.sprites["textbox"].text = (testbgm) if testbgm
   if testbgm == $game_temp.memorized_bgm && $game_system.is_a?(Game_System)
      $game_system.bgm_pause
      $game_system.bgm_position = $game_temp.memorized_bgm_position
      $game_system.bgm_resume($game_temp.memorized_bgm)
	  $game_temp.memorized_bgm = nil
		$game_temp.memorized_bgm_position = nil
		 
   else
   bgm = pbStringToAudioFile(testbgm) if testbgm
   pbBGMPlay(bgm) if testbgm
   end
}})


module Settings
 BORDERS = [["Graphics/Pictures/Borders/empty",0,0, 0, 0, 2, 2, 0, 0],
 ["Graphics/Pictures/Borders/GBA",-28,-28, 100, 100, 2, 2, 0, 0],
 ["Graphics/Pictures/Borders/GBC",-28,-28, 100, 100, 2, 2, 0, 0],
 ["Graphics/Pictures/Borders/GB",-28,-28, 100, 100, 2, 2, 0, 0],
 ["Graphics/Pictures/Borders/Mini",-28,-28, 120, 120, 2, 2, 0, 0],
 ["Graphics/Pictures/Borders/Cube",-28,-28, 100, 100, 2, 2, 0, 0],
 ["Graphics/Pictures/Borders/GBA2",-50,0, 300, 100, 1, 4, 26, 4],
 ["Graphics/Pictures/Borders/TV",-50,0, 300, 100, 1, 4, 26, 4],
 ["Graphics/Pictures/Borders/custom",-50,0, 300, 100, 1, 4, 26, 4]]
end

MenuHandlers.add(:options_menu, :borders, {
  "name"        => _INTL("Borders"),
  "parent"      => :ui_menu,
  "order"       => 90,
  "type"        => NumberOption,
  "parameters"  => 1..Settings::BORDERS.length,
  "description" => _INTL("Choose a Border."),
  "get_proc"    => proc { next $PokemonSystem.cur_border },
  "set_proc"    => proc { |value, scene|
    $PokemonSystem.cur_border = value
	pbForceResizeFactor
	scene.viewport.rect.set(0+$PokemonSystem.screenposx,0+$PokemonSystem.screenposy,scene.viewport.rect.width,scene.viewport.rect.height)
	$scene.viewport.rect.set(0+$PokemonSystem.screenposx,0+$PokemonSystem.screenposy,scene.viewport.rect.width,scene.viewport.rect.height)
	 amtx = 0
	 amty = 0
	 amtx = $PokemonSystem.screenposx-$PokemonSystem.screenposx if $PokemonSystem.screenposx!=0
	 amty = $PokemonSystem.screenposy-$PokemonSystem.screenposy if $PokemonSystem.screenposy!=0
	scene.sprites["textbox"].x=0+amtx
	scene.sprites["textbox"].y=288+amty
	
  }
})

#For the Menu, an area to set Nuzlocke settings
#and maybe Survival Settings?
#adventure settings at least.
#Currently its calling pbControls to allow the controller on lower calls
#This is causing layering problems

