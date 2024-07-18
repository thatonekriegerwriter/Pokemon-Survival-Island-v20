#===============================================================================
# * Set the Controls Screen - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It creates a "Set the controls" screen
# on pause menu, allowing the player to map the actions to the keys in keyboard, 
# ignoring the values defined on F1. You can also define the default controls.
#
#== INSTALLATION ===============================================================
#
# To this script works, put it above main OR convert into a plugin.
#
#== NOTES ======================================================================
#
# '$PokemonSystem.game_controls = nil' resets the controls.
#
# This script, by default, doesn't allows the player to redefine some commands
# like F8 (screenshot key), but if the player assign an action to this key,
# like the "Cancel" action, this key will do this action AND take screenshots
# when pressed. Remember that F12 will reset the game.
#
#===============================================================================

if !PluginManager.installed?("Set the Controls Screen")
  PluginManager.register({                                                 
    :name    => "Set the Controls Screen",                                        
    :version => "1.1.1",                                                     
    :link    => "https://www.pokecommunity.com/showthread.php?t=309391",             
    :credits => "FL"
  })
end

# Open the controls UI.
# You can call this method directly from other places like an event.
def open_set_controls_ui(menu_to_refresh=nil)
  scene=PokemonControls_Scene.new
  screen=PokemonControlsScreen.new(scene)
  pbFadeOutIn {
    screen.start_screen
    menu_to_refresh.pbRefresh if menu_to_refresh
  }
end



module Input
	SEARCH = 40
	LOCKON = 41
	TOGGLETYPE = 42
	CYCLEFOLLOWER = 43
	TOGGLEHUD = 44
	RUNNING = 45
	DEBUGMENU = 46
	PKMNCONTROL = 47
	NOTESMENU = 48
	PUNCH = 49
  class << self
    if !method_defined?(:_old_fl_press?)
      alias :_old_fl_press? :press?
      def press?(button)
        key = buttonToKey(button)
        return key ? pressex_array?(key) : _old_fl_press?(button)
      end

      alias :_old_fl_trigger? :trigger?
      def trigger?(button)
        key = buttonToKey(button)
        return key ? triggerex_array?(key) : _old_fl_trigger?(button)
      end

      alias :_old_fl_repeat? :repeat?
      def repeat?(button)
        key = buttonToKey(button)
        return key ? repeatex_array?(key) : _old_fl_repeat?(button)
      end

      alias :_old_fl_release? :release?
      def release?(button)
        key = buttonToKey(button)
        return key ? releaseex_array?(key) : _old_fl_release?(button)
      end
    end

    def pressex_array?(array)
      for item in array
        return true if pressex?(item)
      end
      return false
    end

    def triggerex_array?(array)
      for item in array
        return true if triggerex?(item)
      end
      return false
    end

    def repeatex_array?(array)
      for item in array
        return true if repeatex?(item)
        return true if triggerex?(item) # Fix for MKXP-Z issue
      end
      return false
    end

    def releaseex_array?(array)
      for item in array
        return true if releaseex?(item)
      end
      return false
    end

    def dir4
      return 0 if press?(DOWN) && press?(UP)
      return 0 if press?(LEFT) && press?(RIGHT)
      for button in [DOWN,LEFT,RIGHT,UP]
        return button if press?(button)
      end
      return 0
    end

    def dir8
      buttons = []
      for b in [DOWN,LEFT,RIGHT,UP]
        buttons.push(b) if press?(b)
      end
      if buttons.length==0
        return 0
      elsif buttons.length==1
        return buttons[0]
      elsif buttons.length==2
        return 0 if (buttons[0]==DOWN && buttons[1]==UP)
        return 0 if (buttons[0]==LEFT && buttons[1]==RIGHT)
      end
      up_down    = 0
      left_right = 0
      for b in buttons
        up_down    = b if up_down==0 && (b==UP || b==DOWN)
        left_right = b if left_right==0 && (b==LEFT || b==RIGHT)
      end
      if up_down==DOWN
        return 1 if left_right==LEFT
        return 3 if left_right==RIGHT
        return 2
      elsif up_down==UP
        return 7 if left_right==LEFT
        return 9 if left_right==RIGHT
        return 8
      else
        return 4 if left_right==LEFT
        return 6 if left_right==RIGHT
        return 0
      end
    end
    

	
    def buttonToKey(button)
      $PokemonSystem = PokemonSystem.new if !$PokemonSystem
      case button
        when Input::DOWN
          return $PokemonSystem.game_control_code("Down")
        when Input::LEFT
          return $PokemonSystem.game_control_code("Left")
        when Input::RIGHT
          return $PokemonSystem.game_control_code("Right")
        when Input::UP
          return $PokemonSystem.game_control_code("Up")
        when Input::ACTION # Z, W, Y, Shift
          return $PokemonSystem.game_control_code("Menu")
        when Input::BACK # X, ESC
          return $PokemonSystem.game_control_code("Cancel")
        when Input::USE # C, ENTER, Space
          return $PokemonSystem.game_control_code("Action")
        when Input::AUX1 # A, Q, Page Up
          return $PokemonSystem.game_control_code("Aux 1")
        when Input::AUX2 # S, Page Down
          return $PokemonSystem.game_control_code("Aux 2")
        when Input::SPECIAL # F, F5, Tab
          return $PokemonSystem.game_control_code("Ready Menu")
          # AUX1 and AUX2 unused
        when Input::JUMPUP # A, Q, Page Up
          return $PokemonSystem.game_control_code("Scroll Up")
        when Input::JUMPDOWN # S, Page Down
          return $PokemonSystem.game_control_code("Scroll Down")
        when Input::SEARCH # F, F5, Tab
          return $PokemonSystem.game_control_code("Direct Pokemon")
        when Input::LOCKON # F, F5, Tab
          return $PokemonSystem.game_control_code("Lock On")
        when Input::TOGGLETYPE # F, F5, Tab
          return $PokemonSystem.game_control_code("Toggle HUD Contents")
        when Input::CYCLEFOLLOWER # F, F5, Tab
          return $PokemonSystem.game_control_code("Cycle Follower")
        when Input::TOGGLEHUD # F, F5, Tab
          return $PokemonSystem.game_control_code("Show HUD")
        when Input::RUNNING # F, F5, Tab
          return $PokemonSystem.game_control_code("Running")
        when Input::DEBUGMENU # F, F5, Tab
          return $PokemonSystem.game_control_code("Debug Menu")
        #when Input::PKMNCONTROL # F, F5, Tab
        #  return $PokemonSystem.game_control_code("Control Pokemon")
        when Input::NOTESMENU # F, F5, Tab
          return $PokemonSystem.game_control_code("Notes Menu")
        when Input::PUNCH # F, F5, Tab
          return $PokemonSystem.game_control_code("Punch")
        else
          return nil
      end
    end
  end
end


module Keys
  # Here you can change the number of keys for each action and the
  # default values
  def self.default_controls
    return [
      ControlConfig.new("Down", "S"),
      ControlConfig.new("Left", "A"),
      ControlConfig.new("Right", "D"),
      ControlConfig.new("Up", "W"),
      ControlConfig.new("Running", "Shift"),
      ControlConfig.new("Action", "Enter"),
      ControlConfig.new("Action", "Space"),
      ControlConfig.new("Action", "MouseLeft"),
      ControlConfig.new("Cancel",  "X"),
      ControlConfig.new("Cancel", "Esc"),
      ControlConfig.new("Cancel", "MouseRight"),
      ControlConfig.new("Menu", "E"),
      ControlConfig.new("Menu", "Z"),
      ControlConfig.new("Show HUD", "R"),
      ControlConfig.new("Scroll Up", "Up"),
      ControlConfig.new("Scroll Down", "Down"),
      ControlConfig.new("Toggle HUD Contents", "MouseMiddle"),
      ControlConfig.new("Ready Menu", "Tab"),
      ControlConfig.new("Aux 1", "J"),
      ControlConfig.new("Aux 2", "Y"),
      ControlConfig.new("Cycle Follower", "P"),
      ControlConfig.new("Lock On", "Q"),
      ControlConfig.new("Direct Pokemon", "F"),
      ControlConfig.new("Debug Menu", "/?"),
      #ControlConfig.new("Control Pokemon", "B"),
      ControlConfig.new("Notes Menu", "Alt"),
      ControlConfig.new("Punch", "C")
    ]
  end 

  # Available keys
  CONTROLS_LIST = {
    # Mouse buttons
    "MouseLeft"    => 0x01,
    "MouseRight"          => 0x02,
    "MouseMiddle"        => 0x04,
    "Mouse4"        => 0x05,
    "Mouse5"        => 0x06,
    "Mouse6"        => 0xA6,
    "Mouse7"        => 0xA7,
    "Backspace"    => 0x08,
    "Tab"          => 0x09,
    "Clear"        => 0x0C,
    "Enter"        => 0x0D,
    "Shift"        => 0x10,
    "Ctrl"         => 0x11,
    "Alt"          => 0x12,
    "Pause"        => 0x13,
    # IME keys
    "Caps Lock"    => 0x14,
    "Esc"          => 0x1B,
    "Space"        => 0x20,
    "Page Up"      => 0x21,
    "Page Down"    => 0x22,
    "End"          => 0x23,
    "Home"         => 0x24,
    "Left"         => 0x25,
    "Up"           => 0x26,
    "Right"        => 0x27,
    "Down"         => 0x28,
    "Select"       => 0x29,
    "Print"        => 0x2A,
    "Execute"      => 0x2B,
    "Print Screen" => 0x2C,
    "Insert"       => 0x2D,
    "Delete"       => 0x2E,
    "Help"         => 0x2F,
    "0"            => 0x30,
    "1"            => 0x31,
    "2"            => 0x32,
    "3"            => 0x33,
    "4"            => 0x34,
    "5"            => 0x35,
    "6"            => 0x36,
    "7"            => 0x37,
    "8"            => 0x38,
    "9"            => 0x39,
    "A"            => 0x41,
    "B"            => 0x42,
    "C"            => 0x43,
    "D"            => 0x44,
    "E"            => 0x45,
    "F"            => 0x46,
    "G"            => 0x47,
    "H"            => 0x48,
    "I"            => 0x49,
    "J"            => 0x4A,
    "K"            => 0x4B,
    "L"            => 0x4C,
    "M"            => 0x4D,
    "N"            => 0x4E,
    "O"            => 0x4F,
    "P"            => 0x50,
    "Q"            => 0x51,
    "R"            => 0x52,
    "S"            => 0x53,
    "T"            => 0x54,
    "U"            => 0x55,
    "V"            => 0x56,
    "W"            => 0x57,
    "X"            => 0x58,
    "Y"            => 0x59,
    "Z"            => 0x5A,
    # Windows keys
    "Numpad 0"     => 0x60,
    "Numpad 1"     => 0x61,
    "Numpad 2"     => 0x62,
    "Numpad 3"     => 0x63,
    "Numpad 4"     => 0x64,
    "Numpad 5"     => 0x65,
    "Numpad 6"     => 0x66,
    "Numpad 7"     => 0x67,
    "Numpad 8"     => 0x68,
    "Numpad 9"     => 0x69,
    "Multiply"     => 0x6A,
    "Add"          => 0x6B,
    "Separator"    => 0x6C,
    "Subtract"     => 0x6D,
    "Decimal"      => 0x6E,
    "Divide"       => 0x6F,
    "F1"           => 0x70,
    "F2"           => 0x71,
    "F3"           => 0x72,
    "F4"           => 0x73,
    "F5"           => 0x74,
    "F6"           => 0x75,
    "F7"           => 0x76,
    "F8"           => 0x77,
    "F9"           => 0x78,
    "F10"          => 0x79,
    "F11"          => 0x7A,
    "F12"          => 0x7B,
    "F13"          => 0x7C,
    "F14"          => 0x7D,
    "F15"          => 0x7E,
    "F16"          => 0x7F,
    "F17"          => 0x80,
    "F18"          => 0x81,
    "F19"          => 0x82,
    "F20"          => 0x83,
    "F21"          => 0x84,
    "F22"          => 0x85,
    "F23"          => 0x86,
    "F24"          => 0x87,
    "Num Lock"     => 0x90,
    "Scroll Lock"  => 0x91,
    # Multiple position Shift, Ctrl and Menu keys
    ";:"           => 0xBA,
    "+"            => 0xBB,
    ","            => 0xBC,
    "-"            => 0xBD,
    "."            => 0xBE,
    "/?"           => 0xBF,
    "`~"           => 0xC0,
    "{"            => 0xDB,
    "\|"           => 0xDC,
    "}"            => 0xDD,
    "'\""          => 0xDE,
    "AX"           => 0xE1 # Japan only,
  }

  def self.key_name(key_code)
    return CONTROLS_LIST.key(key_code) if CONTROLS_LIST.key(key_code)
    return key_code==0 ? "None" : "?"
  end 

  def self.key_code(key_name)
    ret  = CONTROLS_LIST[key_name]
    raise "The button #{key_name} no longer exists! " if !ret
    return ret
  end 

  def self.detect_key
    loop do
      Graphics.update
      Input.update
      for key_code in CONTROLS_LIST.values
        return key_code if Input.triggerex?(key_code)
      end
    end
  end
end 

def get_keyname(action)
  key = ""
 $PokemonSystem.game_controls.each do |control|
  if control.control_action==action
  key = control.key_name 
  end
 end
 
 return key
end

class ControlConfig
  attr_reader :control_action
  attr_accessor :key_code

  def initialize(control_action, default_key)
    @control_action = control_action
    @key_code = Keys.key_code(default_key)
  end

  def key_name
    return Keys.key_name(@key_code)
  end
end

class Window_PokemonControls < Window_DrawableCommand
  attr_reader :reading_input
  attr_reader :controls
  attr_reader :changed

  DEFAULT_EXTRA_INDEX = 0
  EXIT_EXTRA_INDEX = 1

  def initialize(controls,x,y,width,height)
    @controls = controls
    @name_base_color   = Color.new(88,88,80)
    @name_shadow_color = Color.new(168,184,184)
    @sel_base_color    = Color.new(24,112,216)
    @sel_shadow_color  = Color.new(136,168,208)
    @reading_input = false
    @changed = false
    super(x,y,width,height)
  end

  def itemCount
    return @controls.length+EXIT_EXTRA_INDEX+1
  end

  def set_new_input(new_input)
    @reading_input = false
    return if @controls[@index].key_code==new_input
    for control in @controls # Remove the same input for the same array
      control.key_code = 0 if control.key_code==new_input
    end
    @controls[@index].key_code=new_input
    @changed = true
    refresh
  end

  def on_exit_index?
    return @controls.length + EXIT_EXTRA_INDEX == @index
  end

  def on_default_index?
    return @controls.length + DEFAULT_EXTRA_INDEX == @index
  end
  
  def item_description
    ret=nil
    if on_exit_index?
      ret=_INTL("Exit. If you changed anything, asks if you want to keep changes.")
    elsif on_default_index?
      ret=_INTL("Restore the default controls.")
    else
      ret= control_description(@controls[@index].control_action)
    end
    return ret
  end 
  
  

  def control_description(control_action)
    hash = {}
    hash["Down"        ] = _INTL("Moves the character. Select entries and navigate menus.")
    hash["Left"        ] = hash["Down"]
    hash["Right"       ] = hash["Down"]
    hash["Up"          ] = hash["Down"]
    hash["Action"      ] = _INTL("Confirm a choice, check things, talk to people, and move through text.")
    hash["Cancel"      ] = _INTL("Exit, cancel a choice or mode, and move at field in a different speed.")
    hash["Menu"        ] = _INTL("Open the menu. Also has various functions depending on context.")
    hash["Show HUD"   ] = _INTL("Disables and Enables the Overworld HUD.")
    hash["Scroll Up"   ] = _INTL("Advance quickly in menus, and navigate Overworld HUD.")
    hash["Scroll Down" ] = hash[ "Scroll Up"]
    hash["Toggle Box"   ] = _INTL("Changes the Contents of the Overworld HUD to Items or Pokemon.")
    hash["Ready Menu"  ] = _INTL("Open Ready Menu, with registered items and available field moves.")
    hash["Trainer Card"  ] = _INTL("Open Trainer Card to see various stats about the Trainer.")
    hash["Following Pokemon"  ] = _INTL("Toggle your Following Pokemon.")
    hash["Lock On"  ] = _INTL("Lock on to an Overworld Pokemon.")
    hash["Search"  ] = _INTL("Direct your Overworld Pokemon to Search.")
    hash["Following Pokemon"  ] = _INTL("Toggle your Following Pokemon.")
    hash["Cycle Follower"  ] = _INTL("Cycles your Following Pokemon.")
    hash["Lock On"  ] = _INTL("Lock on to an Overworld Pokemon.")
    hash["Search"  ] = _INTL("Direct your Overworld Pokemon to Search.")
    return hash.fetch(control_action, _INTL("Set the controls."))
  end

  def drawItem(index,count,rect)
    rect=drawCursor(index,rect)
    name = case index-@controls.length
      when DEFAULT_EXTRA_INDEX   ; _INTL("Default")
      when EXIT_EXTRA_INDEX      ; _INTL("Exit")
      else                       ; @controls[index].control_action
    end
    width= rect.width*9/20
    pbDrawShadowText(
      self.contents,rect.x,rect.y,width,rect.height,
      name,@name_base_color,@name_shadow_color
    )
    self.contents.draw_text(rect.x,rect.y,width,rect.height,name)
    return if index>=@controls.length
    value = _INTL(@controls[index].key_name)
    xpos = width+rect.x
    pbDrawShadowText(
      self.contents,xpos,rect.y,width,rect.height,
      value,@sel_base_color,@sel_shadow_color
    )
    self.contents.draw_text(xpos,rect.y,width,rect.height,value)
  end

  def update
    oldindex=self.index
    super
    do_refresh=self.index!=oldindex
    if self.active && self.index<=@controls.length
      if Input.trigger?(Input::C)
        if on_default_index?
          if pbConfirmMessage(_INTL("Are you sure? Anyway, you can exit this screen without keeping the changes."))
            pbPlayDecisionSE()
            @controls = Keys.default_controls
            @changed = true
            do_refresh = true
          end
        elsif self.index<@controls.length
          @reading_input = true
        end
      end
    end
    refresh if do_refresh
  end
end

class PokemonControls_Scene
  def start_scene
    @sprites={}
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites["title"]=Window_UnformattedTextPokemon.newWithSize(
      _INTL("Controls"),0,0,Graphics.width,64,@viewport
    )
    @sprites["textbox"]=pbCreateMessageWindow
    @sprites["textbox"].letterbyletter=false
    game_controls = $PokemonSystem.game_controls.map{|c| c.clone}
    @sprites["controlwindow"]=Window_PokemonControls.new(
      game_controls,0,@sprites["title"].height,Graphics.width,
      Graphics.height-@sprites["title"].height-@sprites["textbox"].height
    )
    @sprites["controlwindow"].viewport=@viewport
    @sprites["controlwindow"].visible=true
    @changed = false
    pbDeactivateWindows(@sprites)
    pbFadeInAndShow(@sprites) { update }
  end

  def update
    pbUpdateSpriteHash(@sprites)
  end

  def main
    last_index=-1
    should_refresh_text = false
    pbActivateWindow(@sprites,"controlwindow"){
    loop do
      Graphics.update
      Input.update
      update
      should_refresh_text = @sprites["controlwindow"].index!=last_index
      if @sprites["controlwindow"].reading_input
        @sprites["textbox"].text=_INTL("Press a new key.")
        @sprites["controlwindow"].set_new_input(Keys.detect_key)
        should_refresh_text = true
        @changed = true
      else
        if Input.trigger?(Input::B) || (
          Input.trigger?(Input::C) && @sprites["controlwindow"].on_exit_index?
        )
          if(
            @sprites["controlwindow"].changed && 
            pbConfirmMessage(_INTL("Keep changes?"))
          )
            should_refresh_text = true # Visual effect
            if @sprites["controlwindow"].controls.find{|c| c.key_code == 0}
              @sprites["textbox"].text=_INTL("Fill all fields!")
              should_refresh_text = false
            else
              $PokemonSystem.game_controls = @sprites["controlwindow"].controls
              break
            end
          else
            break
          end
        end
      end
      if should_refresh_text
        if @sprites["textbox"].text!=@sprites["controlwindow"].item_description
          @sprites["textbox"].text = @sprites["controlwindow"].item_description
        end
        last_index = @sprites["controlwindow"].index
      end
    end
    }
  end

  def end_scene
    pbFadeOutAndHide(@sprites) { update }
    pbDisposeMessageWindow(@sprites["textbox"])
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class PokemonControlsScreen
  def initialize(scene)
    @scene=scene
  end

  def start_screen
    @scene.start_scene
    @scene.main
    @scene.end_scene
  end
end

class PokemonSystem
  attr_writer :game_controls
  def game_controls
    @game_controls = Keys.default_controls if !@game_controls
    return @game_controls
  end

  def game_control_code(control_action)
    ret = []
    for control in game_controls
      ret.push(control.key_code) if control.control_action == control_action
    end
    return ret
  end
end





#==============================================================================
# * Scene_Controls
#------------------------------------------------------------------------------
# Shows a help screen listing the keyboard controls.
# Display with:
#      pbEventScreen(ButtonEventScene)
#==============================================================================
class ButtonEventScene < EventScene
  def initialize(viewport = nil)
    super
    Graphics.freeze
    @current_screen = 1
    addImage(0, 0, "Graphics/Pictures/Controls help/help_bg")
    @labels = []
    @label_screens = []
    @keys = []
    @key_screens = []
     if $game_variables[4973]==0
    addImageForScreen(1, 44, 122, "Graphics/Pictures/Controls help/help_arrows")
    addImageForScreen(1, 44, 252, "Graphics/Pictures/Controls help/help_run")
    addLabelForScreen(1, 154, 84, 352, _INTL("Use these keys to move the main character.\r\n\r\nYou can also use the Arrow keys to select entries and navigate menus.(Defaults:  #{get_keyname("Up")},#{get_keyname("Down")},#{get_keyname("Left")},#{get_keyname("Right")}) "))
    addLabelForScreen(1, 154, 244, 352, _INTL("Use this key to Run. (Default: #{get_keyname("Running")})."))


    addImageForScreen(2, 16, 90, "Graphics/Pictures/Controls help/help_usekey")
    addImageForScreen(2, 16, 236, "Graphics/Pictures/Controls help/help_backkey")
    addLabelForScreen(2, 134, 68, 352, _INTL("Used to confirm a choice, interact with people and things, using Overworld Items, throwing out POKeMON in the Overworld, and moving through text. (Default: #{get_keyname("Action")})"))
    addLabelForScreen(2, 134, 236, 352, _INTL("Used to exit, cancel a choice, and cancel a mode. (Default: #{get_keyname("Cancel")})"))

    addImageForScreen(3, 16, 40, "Graphics/Pictures/Controls help/help_actionkey")
    addImageForScreen(3, 16, 186, "Graphics/Pictures/Controls help/help_specialkey")
    addImageForScreen(3, 16, 272, "Graphics/Pictures/Controls help/help_lock")
    addLabelForScreen(3, 134, 18, 352, _INTL("Used to open the Pause Menu. Also has various functions depending on context. (Default: #{get_keyname("Action")})"))
    addLabelForScreen(3, 134, 146, 352, _INTL("Press to open the Ready Menu, where registered items and available field moves can be used. (Default: #{get_keyname("Special")})"))
    addLabelForScreen(3, 134, 272, 352, _INTL("Used to lock on to an Overworld Pokemon, which allows you to place focus on them. (Default: #{get_keyname("Lock On")})"))
	
    addImageForScreen(4, 44, 122, "Graphics/Pictures/Controls help/help_hud")
    addLabelForScreen(4, 134, 84, 352, _INTL("There are two keys for controlling the Overworld Hud.\r\n\r\nOne key toggles it's presence. (Default: #{get_keyname("Show HUD")})\r\n\r\nThe other key toggles between what it can contain. (Default: #{get_keyname("Toggle HUD Contents")}"))
	
	
    addImageForScreen(5, 16, 90, "Graphics/Pictures/Controls help/help_control")
    addImageForScreen(5, 16, 236, "Graphics/Pictures/Controls help/help_search")
    addLabelForScreen(5, 134, 68, 352, _INTL("Used to directly take control of one of your POKeMON on the Overworld. (Default: #{get_keyname("Control Pokemon")})"))
    addLabelForScreen(5, 134, 196, 352, _INTL("Used to direct an Overworld POKeMON to search for items. (Default: #{get_keyname("Search")})"))
	
    addImageForScreen(6, 16, 90, "Graphics/Pictures/Controls help/help_hp")
    addImageForScreen(6, 16, 236, "Graphics/Pictures/Controls help/help_stamina")
    addLabelForScreen(6, 134, 68, 352, _INTL("This is your Health Bar. As you may guess, it displays your current Health. It changes different colors at different stages of damage."))
    addLabelForScreen(6, 134, 196, 352, _INTL("This is your Stamina Bar. It is used up by performing actions, knocking down a Tree, Running with Running Shoes, Dodging, and more."))

    addImageForScreen(7, 16, 40, "Graphics/Pictures/Controls help/help_fod")
    addImageForScreen(7, 16, 186, "Graphics/Pictures/Controls help/help_h2o")
    addImageForScreen(7, 16, 252, "Graphics/Pictures/Controls help/help_sleep")
    addLabelForScreen(7, 134, 18, 352, _INTL("These are your status bars.\r\n\r\nFOD means Food, H2O means Water, and SLP means Sleep. You restore them by performing the associated action."))
    addLabelForScreen(7, 134, 146, 352, _INTL("When FOD and H2O are blue, they will not go down, once they are no longer blue, they will go through the same color cycle as Health and Sleep."))
    addLabelForScreen(7, 134, 212, 352, _INTL("If any of these are zero, you will begin to die."))
	
	
	 elsif $game_variables[4973]==1
    addImageForScreen(1, 44, 122, "Graphics/Pictures/Controls help/help_arrows")
    addImageForScreen(1, 44, 252, "Graphics/Pictures/Controls help/help_run")
    addLabelForScreen(1, 134, 84, 352, _INTL("Use these keys to move the main character.\r\n\r\nYou can also use the Arrow keys to select entries and navigate menus.(Defaults:  #{get_keyname("Up")},#{get_keyname("Down")},#{get_keyname("Left")},#{get_keyname("Right")}) "))
    addLabelForScreen(1, 134, 244, 352, _INTL("Use this key to Run. (Default: #{get_keyname("Running")})."))
	 elsif $game_variables[4973]==2
    addImageForScreen(1, 16, 90, "Graphics/Pictures/Controls help/help_usekey")
    addImageForScreen(1, 16, 236, "Graphics/Pictures/Controls help/help_backkey")
    addLabelForScreen(1, 134, 68, 352, _INTL("Used to confirm a choice, interact with people and things, using Overworld Items, throwing out POKeMON in the Overworld, and moving through text. (Default: #{get_keyname("Action")})"))
    addLabelForScreen(1, 134, 196, 352, _INTL("Used to exit, cancel a choice, and cancel a mode. (Default: #{get_keyname("Cancel")})"))
	 elsif $game_variables[4973]==3
    addImageForScreen(1, 16, 40, "Graphics/Pictures/Controls help/help_actionkey")
    addImageForScreen(1, 16, 186, "Graphics/Pictures/Controls help/help_specialkey")
    addImageForScreen(1, 16, 252, "Graphics/Pictures/Controls help/help_lock")
    addLabelForScreen(1, 134, 18, 352, _INTL("Used to open the Pause Menu. Also has various functions depending on context. (Default: #{get_keyname("Action")})"))
    addLabelForScreen(1, 134, 146, 352, _INTL("Press to open the Ready Menu, where registered items and available field moves can be used. (Default: #{get_keyname("Special")})"))
    addLabelForScreen(1, 134, 212, 352, _INTL("Used to lock on to an Overworld Pokemon, which allows you to place focus on them. (Default: #{get_keyname("Lock On")})"))
	 elsif $game_variables[4973]==4
	     addImageForScreen(4, 44, 122, "Graphics/Pictures/Controls help/help_hud")
    addLabelForScreen(1, 134, 84, 352, _INTL("There are two keys for controlling the Overworld Hud.\r\n\r\nOne key toggles it's presence. (Default: #{get_keyname("Show HUD")})\r\n\r\nThe other key toggles between what it can contain. (Default: #{get_keyname("Toggle HUD Contents")}"))
	
	 elsif $game_variables[4973]==5
    addImageForScreen(1, 16, 90, "Graphics/Pictures/Controls help/help_control")
    addImageForScreen(1, 16, 236, "Graphics/Pictures/Controls help/help_search")
    addLabelForScreen(1, 134, 68, 352, _INTL("Used to directly take control of one of your POKeMON on the Overworld. (Default: #{get_keyname("Control Pokemon")})"))
    addLabelForScreen(1, 134, 196, 352, _INTL("Used to direct an Overworld POKeMON to search for items. (Default: #{get_keyname("Search")})"))
	 elsif $game_variables[4973]==6
    addImageForScreen(1, 44, 122, "Graphics/Pictures/Controls help/help_arrows")
    addImageForScreen(1, 44, 252, "Graphics/Pictures/Controls help/help_run")
    addLabelForScreen(1, 154, 84, 352, _INTL("Use these keys to move the main character.\r\n\r\nYou can also use the Arrow keys to select entries and navigate menus.(Defaults:  #{get_keyname("Up")},#{get_keyname("Down")},#{get_keyname("Left")},#{get_keyname("Right")}) "))
    addLabelForScreen(1, 154, 244, 352, _INTL("Use this key to Run. (Default: #{get_keyname("Running")})."))


    addImageForScreen(2, 16, 90, "Graphics/Pictures/Controls help/help_usekey")
    addImageForScreen(2, 16, 236, "Graphics/Pictures/Controls help/help_backkey")
    addLabelForScreen(2, 134, 68, 352, _INTL("Used to confirm a choice, interact with people and things, using Overworld Items, throwing out POKeMON in the Overworld, and moving through text. (Default: #{get_keyname("Action")})"))
    addLabelForScreen(2, 134, 236, 352, _INTL("Used to exit, cancel a choice, and cancel a mode. (Default: #{get_keyname("Cancel")})"))

    addImageForScreen(3, 16, 40, "Graphics/Pictures/Controls help/help_actionkey")
    addImageForScreen(3, 16, 186, "Graphics/Pictures/Controls help/help_specialkey")
    addImageForScreen(3, 16, 272, "Graphics/Pictures/Controls help/help_lock")
    addLabelForScreen(3, 134, 18, 352, _INTL("Used to open the Pause Menu. Also has various functions depending on context. (Default: #{get_keyname("Action")})"))
    addLabelForScreen(3, 134, 146, 352, _INTL("Press to open the Ready Menu, where registered items and available field moves can be used. (Default: #{get_keyname("Special")})"))
    addLabelForScreen(3, 134, 262, 352, _INTL("Used to lock on to an Overworld Pokemon, which allows you to place focus on them. (Default: #{get_keyname("Lock On")})"))
	
	elsif $game_variables[4973]==7
    addImageForScreen(1, 39, 136, "Graphics/Pictures/Controls help/help_hud")
    addLabelForScreen(1, 134, 84, 352, _INTL("There are two keys for controlling the Overworld Hud.\r\n\r\nOne key toggles it's presence. (Default: #{get_keyname("Show HUD")})\r\n\r\nThe other key toggles between what it can contain. (Default: #{get_keyname("Toggle HUD Contents")}"))
	
	
    addImageForScreen(2, 16, 90, "Graphics/Pictures/Controls help/help_control")
    addImageForScreen(2, 16, 236, "Graphics/Pictures/Controls help/help_search")
    addLabelForScreen(2, 134, 68, 352, _INTL("Used to directly take control of one of your POKeMON on the Overworld. (Default: #{get_keyname("Control Pokemon")})"))
    addLabelForScreen(2, 134, 196, 352, _INTL("Used to direct an Overworld POKeMON to search for items. (Default: #{get_keyname("Search")})"))
	elsif $game_variables[4973]==8
    addImageForScreen(2, 16, 90, "Graphics/Pictures/Controls help/help_hp")
    addImageForScreen(2, 16, 236, "Graphics/Pictures/Controls help/help_stamina")
    addLabelForScreen(2, 134, 68, 352, _INTL("This is your Health Bar. As you may guess, it displays your current Health. It changes different colors at different stages of damage."))
    addLabelForScreen(2, 134, 196, 352, _INTL("This is your Stamina Bar. It is used up by performing actions, knocking down a Tree, Running with Running Shoes, Dodging, and more."))

    addImageForScreen(3, 16, 40, "Graphics/Pictures/Controls help/help_fod")
    addImageForScreen(3, 16, 186, "Graphics/Pictures/Controls help/help_h2o")
    addImageForScreen(3, 16, 252, "Graphics/Pictures/Controls help/help_sleep")
    addLabelForScreen(3, 134, 18, 352, _INTL("These are your status bars.\r\n\r\nFOD means Food, H2O means Water, and SLP means Sleep. You restore them by performing the associated action."))
    addLabelForScreen(3, 134, 146, 352, _INTL("When FOD and H2O are blue, they will not go down, once they are no longer blue, they will go through the same color cycle as Health and Sleep."))
    addLabelForScreen(3, 134, 212, 352, _INTL("If any of these are zero, you will begin to die."))
	
        end
    set_up_screen(@current_screen)
    Graphics.transition
    # Go to next screen when user presses USE
    onCTrigger.set(method(:pbOnScreenEnd))
	$game_variables[4973]=0 if $game_variables[4973]!=0
  end

  def addLabelForScreen(number, x, y, width, text)
    @labels.push(addLabel(x, y, width, text))
    @label_screens.push(number)
    @picturesprites[@picturesprites.length - 1].opacity = 0
  end

  def addImageForScreen(number, x, y, filename)
    @keys.push(addImage(x, y, filename))
    @key_screens.push(number)
    @picturesprites[@picturesprites.length - 1].opacity = 0
  end

  def set_up_screen(number)
    @label_screens.each_with_index do |screen, i|
      @labels[i].moveOpacity((screen == number) ? 10 : 0, 10, (screen == number) ? 255 : 0)
    end
    @key_screens.each_with_index do |screen, i|
      @keys[i].moveOpacity((screen == number) ? 10 : 0, 10, (screen == number) ? 255 : 0)
    end
    pictureWait   # Update event scene with the changes
  end

  def pbOnScreenEnd(scene, *args)
    last_screen = [@label_screens.max, @key_screens.max].max
    if @current_screen >= last_screen
      # End scene
      $game_temp.background_bitmap = Graphics.snap_to_bitmap
      @viewport.color = Color.new(0, 0, 0, 255)   # Ensure screen is black
      $game_temp.background_bitmap.dispose
      scene.dispose
    else
      # Next screen
      @current_screen += 1
      onCTrigger.clear
      set_up_screen(@current_screen)
      onCTrigger.set(method(:pbOnScreenEnd))
    end
  end
end


 




MenuHandlers.add(:pause_menu, :controls, {
  "name"      => _INTL("Controls"),
  "order"     => 75,
  "effect"    => proc { |menu|
    pbPlayDecisionSE
    open_set_controls_ui(menu)
    next false
  }
})