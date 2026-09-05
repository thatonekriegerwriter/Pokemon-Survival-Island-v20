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
 # pbFadeOutIn {
    screen.start_screen
    menu_to_refresh.pbRefresh if menu_to_refresh
#  }
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
	ALTMENU = 48
	PUNCH = 49
	CYCLEMOUSETYPE = 50
	NOTEBOOK = 51
	EXPAND = 52
	WHATISTHIS = 53
	ALTERNATEMOUSEMODE = 54
	INVENTORY = 55
	SHOWGRID = 56
	QUICKACCESSREGISTER = 57
	HISTORYSCREENSHOT = 58
	DESELECTALL = 59
	PONDERINVENTORY = 60
	FAVORITEINVENTORY = 61
	QUICKACCESSINVENTORY = 62
	INFOINVENTORY = 63
	SEARCHINVENTORY = 64
	INVENTORYTOGGLE = 65
	
	
	
	
	
  @key_last_pressed = {}
  @key_press_time = {}
  @key_last_pressed2 = {}
  @key_press_time2 = {}
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
    
	
  def held_for?(key)
      @hold_start ||= {}

      if Input.press?(key)
        @hold_start[key] ||= Graphics.frame_count
        return Graphics.frame_count - @hold_start[key]
      else
        @hold_start[key] = nil
        return 0
      end
  end
	
    def dir4
      return 0 if press?(DOWN) && press?(UP)
      return 0 if press?(LEFT) && press?(RIGHT)
      for button in [DOWN,LEFT,RIGHT,UP]
        return button if press?(button)
      end
      return 0
    end
    def dir4alt
      return 0 if trigger?(DOWN) && trigger?(UP)
      return 0 if trigger?(LEFT) && trigger?(RIGHT)
      for button in [DOWN,LEFT,RIGHT,UP]
        return button if trigger?(button)
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
    
  # Detect a double tap for a specific key
  def double_tap?(key)
    current_time = Graphics.frame_count
    duris = trigger?(key)
    if duris
      if @key_last_pressed[key] && (current_time - @key_last_pressed[key] <= 10)
        # Double tap detected
        @key_last_pressed[key] = nil
        return true
      else
        # Store the time of the first tap
        @key_last_pressed[key] = current_time
      end
    end

    return false
  end
    
  def jumping_up?
    return trigger?(Input::JUMPUP)  || scroll_v==1
  end
  def jumping_down?
    return trigger?(Input::JUMPDOWN)  || scroll_v==-1
  end
  # Detect a double tap for a specific key
  def single_tap?(key)
    current_time = Graphics.frame_count
    duris = trigger?(key)
    if duris
      if @key_last_pressed[key] && (current_time - @key_last_pressed[key] >= 20)
        # Double tap detected
        @key_last_pressed[key] = nil
	   elsif @key_last_pressed[key]
      else
        @key_last_pressed[key] = current_time
        return true
      end
    end

    return false
  end


  def double_tap_dir4?
    current_time = Graphics.frame_count
	  key = dir4alt
    if key!=0
      if @key_last_pressed[key] && (current_time - @key_last_pressed[key] <= 10)
        # Double tap detected
        @key_last_pressed[key] = nil
        return true
      else
        # Store the time of the first tap
        @key_last_pressed[key] = current_time
      end
    end

    return false
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
          return $PokemonSystem.game_control_code("Combat HUD")
          # AUX1 and AUX2 unused
        when Input::JUMPUP # A, Q, Page Up
          return $PokemonSystem.game_control_code("Scroll Up")
        when Input::JUMPDOWN # S, Page Down
          return $PokemonSystem.game_control_code("Scroll Down")
        when Input::LOCKON # F, F5, Tab
          return $PokemonSystem.game_control_code("Lock On")
        when Input::TOGGLETYPE # F, F5, Tab
          return $PokemonSystem.game_control_code("Direct Pokemon")
        when Input::TOGGLEHUD # F, F5, Tab
          return $PokemonSystem.game_control_code("Show HUD")
        when Input::RUNNING # F, F5, Tab
          return $PokemonSystem.game_control_code("Running")
        when Input::DEBUGMENU # F, F5, Tab
          return $PokemonSystem.game_control_code("Debug Menu")
        when Input::QUICKACCESSREGISTER # F, F5, Tab
          return $PokemonSystem.game_control_code("Quick Access")
      #  when Input::PKMNCONTROL # F, F5, Tab
      #    return $PokemonSystem.game_control_code("Direct Pokemon")
        when Input::ALTMENU # F, F5, Tab
#          return $PokemonSystem.game_control_code("Direct Group")
        when Input::PUNCH # F, F5, Tab
          return $PokemonSystem.game_control_code("Quick Use")
        #when Input::CYCLEMOUSETYPE # F, F5, Tab
        #  return $PokemonSystem.game_control_code("Cycle Mouse Mode")
        when Input::NOTEBOOK # F, F5, Tab
          return $PokemonSystem.game_control_code("Open Notebook")
        when Input::EXPAND # F, F5, Tab
          return $PokemonSystem.game_control_code("Expand HUD")
     #   when Input::ALTERNATEMOUSEMODE # F, F5, Tab
     #     return $PokemonSystem.game_control_code("Selection Mouse Mode")
        when Input::WHATISTHIS # F, F5, Tab
          return $PokemonSystem.game_control_code("Check")
        when Input::INVENTORY # F, F5, Tab
          return $PokemonSystem.game_control_code("Inventory")
        when Input::SHOWGRID
          return $PokemonSystem.game_control_code("Show Grid")
        when Input::HISTORYSCREENSHOT
          return $PokemonSystem.game_control_code("History")
        when Input::DESELECTALL
          return $PokemonSystem.game_control_code("Deselect")
        when Input::PONDERINVENTORY # X, ESC
          return $PokemonSystem.game_control_code("Ponder")
        when Input::FAVORITEINVENTORY # X, ESC
          return $PokemonSystem.game_control_code("Toggle Favorite")
        when Input::QUICKACCESSINVENTORY # X, ESC
          return $PokemonSystem.game_control_code("Toggle QA")
        when Input::INFOINVENTORY # X, ESC
          return $PokemonSystem.game_control_code("Show Info")
        when Input::SEARCHINVENTORY # X, ESC
          return $PokemonSystem.game_control_code("Search Inventory")
        when Input::INVENTORYTOGGLE # X, ESC
          return $PokemonSystem.game_control_code("Interact Inventory")
        else
          return nil
      end
    end
  
  alias original_update_input update
  def update
    original_update_input
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
      ControlConfig.new("Action", "Space"),
      ControlConfig.new("Action", "MouseLeft"),
      ControlConfig.new("Cancel",  "X"),
      ControlConfig.new("Cancel", "MouseRight"),
      ControlConfig.new("Inventory", "E"),
      ControlConfig.new("Menu", "Z"),
      ControlConfig.new("Menu", "Esc"),
      ControlConfig.new("Menu", "Enter"),
      ControlConfig.new("Running", "Shift"),
      ControlConfig.new("Quick Use", "F"),
    #  ControlConfig.new("Selection Mouse Mode", "Shift"),
      ControlConfig.new("Open Notebook", "V"),
      ControlConfig.new("Show HUD", "R"),
      ControlConfig.new("Expand HUD", "C"),
      ControlConfig.new("Combat HUD", "T"),
      ControlConfig.new("Show Grid", "G"),
      ControlConfig.new("Lock On", "Q"),
      ControlConfig.new("Scroll Up", "Up"),
      ControlConfig.new("Scroll Down", "Down"),
      ControlConfig.new("Quick Access", "+"),
      ControlConfig.new("Aux 1", "J"),
      ControlConfig.new("Aux 2", "Y"),
      ControlConfig.new("Direct Pokemon", "MouseMiddle"),
      ControlConfig.new("Check", "I"),
      ControlConfig.new("History", "Home"),
      ControlConfig.new("Deselect", "Tab"),
      ControlConfig.new("Ponder", "P"),
      ControlConfig.new("Toggle Favorite", "Tab"),
      ControlConfig.new("Toggle QA", "F"),
      ControlConfig.new("Show Info", "I"),
      ControlConfig.new("Search Inventory", "S"),
      ControlConfig.new("Interact Inventory", "MouseMiddle")
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
    "~"           => 0xC0,
    "{"            => 0xDB,
    "\|"           => 0xDC,
    "}"            => 0xDD,
    "'\""          => 0xDE,
    "AX"           => 0xE1, # Japan only,,
    "None"         => 0x00
  }

  def self.key_name(key_code)
    return CONTROLS_LIST.key(key_code) if CONTROLS_LIST.key(key_code)
    return "None"
  end 

  def self.key_code(key_name)
    ret  = CONTROLS_LIST[key_name]
    raise "The button #{key_name} no longer exists! " if !ret
    return ret
  end 

  # The default key code for the Nth binding of +action+ (0 = the first
  # ControlConfig for that action in default_controls, 1 = the second,
  # and so on). Falls back to the last matching default if +occurrence+
  # runs past the end, and to "None" if the action has no default at all.
  def self.default_key_code_for(action, occurrence = 0)
    matches = default_controls.select { |control| control.control_action == action }
    return key_code("None") if matches.empty?
    chosen = matches[occurrence] || matches.last
    return chosen.key_code
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

def get_keyname(action,version=0)
  key = nil
   keys = []
 $PokemonSystem.game_controls.each do |control|
  if control.control_action==action
    keys << control.key_name 
  end
 end
 if keys.length>0
  key = keys[version]
  key = keys[keys.length] if key.nil?
 end
 key = "None" if key.nil?
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



#===============================================================================
# Control Categories
#-------------------------------------------------------------------------------
# A small registry so the Set Controls screen can be split into tabs, and so
# new tabs/actions can be added from any other script without touching this
# one. Two calls are all that's needed:
#
#   ControlCategories.add(:combat, _INTL("Turn-Based Combat"), 30)
#   ControlCategories.assign("Switch Pokemon", :combat)
#
# "add" registers a tab (or updates the name/order of one that already
# exists). "order" controls left-to-right tab position; lower goes first.
# "assign" slots a control action into a tab. Calling assign with a category
# id that hasn't been added yet creates it automatically, so a plugin that
# only cares about its own action doesn't have to call "add" at all.
# Any action that's never assigned falls back to the :misc tab.
#===============================================================================
module ControlCategories
  CategoryDef = Struct.new(:id, :name, :order)

  @categories   = []
  @action_to_id = {}

  def self.add(id, name, order = 100)
    id = id.to_sym
    existing = @categories.find { |cat| cat.id == id }
    if existing
      existing.name  = name
      existing.order = order
    else
      @categories << CategoryDef.new(id, name, order)
    end
    return id
  end

  # All registered categories, sorted for display.
  def self.all
    return @categories.sort_by { |cat| [cat.order, cat.id.to_s] }
  end

  def self.exists?(id)
    return @categories.any? { |cat| cat.id == id.to_sym }
  end

  def self.name_for(id)
    cat = @categories.find { |c| c.id == id.to_sym }
    return cat ? cat.name : _INTL("Misc")
  end

  def self.assign(action, id)
    id = id.to_sym
    add(id, id.to_s.capitalize, 100) if !exists?(id)
    @action_to_id[action] = id
  end

  def self.for_action(action)
    return @action_to_id[action] || :misc
  end
end

# Built-in tabs. Add more from any script with ControlCategories.add.
ControlCategories.add(:overworld, _INTL("Overworld"), 10)
ControlCategories.add(:inventory, _INTL("Inventory"), 30)
ControlCategories.add(:combat,    _INTL("Combat"), 20)
ControlCategories.add(:misc,      _INTL("Other"), 999)

# Built-in action -> tab assignments. Every action currently defined in
# Keys.default_controls is Overworld, per how the game is set up today.
# Move an action to a different tab (or make a new tab for it) with a
# single line, e.g.:
#   ControlCategories.assign("Inventory", :inventory)
#   ControlCategories.assign("Debug Menu", :misc)
["Down", "Left", "Right", "Up", "Running", "Action", "Cancel", "Menu", "Inventory", "Open Notebook"].each { |action| ControlCategories.assign(action, :overworld) }
["Show HUD", "Expand HUD", "Combat HUD", "Show Grid", "Direct Pokemon", "Deselect", "Lock On", "Check", "Quick Access", "Quick Use"].each { |action| ControlCategories.assign(action, :combat) }
["Aux 1", "Aux 2", "Scroll Up", "Scroll Down", "Debug Menu"].each { |action| ControlCategories.assign(action, :misc) }
["Ponder", "Toggle Favorite", "Toggle QA", "Show Info", "Search Inventory", "Interact Inventory"].each { |action| ControlCategories.assign(action, :inventory) }


#===============================================================================
# The list of key bindings for a single tab.
#===============================================================================
class Window_PokemonControls < Window_DrawableCommand
  attr_reader :reading_input
  attr_reader :deleting_input
  attr_reader :default_input
  attr_reader :controls
  attr_reader :changed
  attr_accessor :refresh_controls

  DEFAULT_EXTRA_INDEX = 0
  EXIT_FULL_RESET_INDEX    = 1
  EXIT_EXTRA_INDEX    = 2

  # Same palette as Options' Window_PokemonOption, so the two screens read
  # as one continuous UI.
  SEL_NAME_BASE_COLOR    = Color.new(192, 120, 0)
  SEL_NAME_SHADOW_COLOR  = Color.new(248, 176, 80)
  SEL_VALUE_BASE_COLOR   = Color.new(248, 48, 24)
  SEL_VALUE_SHADOW_COLOR = Color.new(248, 136, 128)
  NAME_BASE_COLOR        = Color.new(88, 88, 80)
  NAME_SHADOW_COLOR      = Color.new(168, 184, 184)

  def initialize(controls, x, y, width, height)
    @controls       = controls
    @reading_input  = false
    @deleting_input = false
    @default_input  = false
    @changed        = false
    @refresh_controls        = false
    super(x, y, width, height)
  end
  def control_description(control_action)
    hash = {}
    hash["Down"] = _INTL("Moves the character. Select entries and navigate menus.")
    hash["Left"] = hash["Down"]
    hash["Right"] = hash["Down"]
    hash["Up"] = hash["Down"]
    hash["Running"] = _INTL("An optional key which can be assigned to run. The default behavior is double tap to run.")
    hash["Action"] = _INTL("Confirm a choice, interact with things, and move through text.")
    hash["Cancel"] = _INTL("Exit, cancel a choice or mode.")
    hash["Menu"] = _INTL("Open the pause menu. Also has various functions depending on context.")
    hash["Show HUD"] = _INTL("Toggles visibility of the Overworld HUD.")
    hash["Scroll Up"] = _INTL("Advance quickly in menus, and navigate Overworld HUD.")
    hash["Scroll Down"] = hash["Scroll Up"]
    hash["Toggle HUD Contents"] = _INTL("Changes the HUD between it's various content types.")
    hash["Expand HUD"] = _INTL("Toggles visibility of the other items in the Overworld HUD.")
    hash["Combat HUD"] = _INTL("A key dedicated to opening the Moves/Multiselect section of the Overworld HUD.")
    hash["Show Grid"] = _INTL("Shows a grid on the Overworld for use in directing and selecting events.")
    hash["Lock On"] = _INTL("Focuses the Camera on an Overworld Object.")
    hash["Quick Use"] = _INTL("Uses a binded item, if no item is bound, performs a punch.")
    hash["Quick Access"] = _INTL("Binds or Unbinds an item for Quick Use.")
    hash["Cycle Mouse Mode"] = _INTL("Cycle your mouse through it's different controls states.")
    hash["Open Notebook"] = _INTL("A dedicated key for opening your Notebook.")
    hash["Debug Menu"] = _INTL("Open the Debug Menu if accessible.")
    hash["Direct Group"] = _INTL("Direct a large group of Overworld Pokemon.")
    hash["Display Moves"] = _INTL("Display currently selected Overworld Pokemon's Moves.")
    hash["Selection Mouse Mode"] = _INTL("Immediately change to Selection Mouse Mode.")
    hash["Direct Pokemon"] = _INTL("Used to select/unselect an Overworld Pokemon, and direct them. Hold to select multiple Pokemon.")
    hash["Check"] = _INTL("Can be used when Locked On to get information about an object.")
    hash["Inventory"] = _INTL("Opens your Inventory Window.")
    hash["History"] = _INTL("Allows you to store this moment to be recounting to you on loading of a save.")
    hash["Deselect"] = _INTL("Unselect all currently selected Pokemon.")
    hash["Ponder"] = _INTL("Ponder hovered item.")
    hash["Toggle Favorite"] = _INTL("Toggle Favorite status for hovered object.")
    hash["Toggle QA"] = _INTL("Toggle Quick Access status for hovered object.")
    hash["Show Info"] = _INTL("Show more detail about the hovered object.")
    hash["Search Inventory"] = _INTL("Opens up prompt to allow you to search inventory for given name.")
    hash["Interact Inventory"] = _INTL("Allows you to use an item/open Pokemon inventory.")
    hash["Aux 1"] = _INTL("Anxillary Control: Currently unused.")
    hash["Aux 2"] = _INTL("Anxillary Control: Currently unused.")
    return hash.fetch(control_action, _INTL("Set the controls."))
  end

  # Swaps in a different tab's controls (the same underlying ControlConfig
  # objects as the master list, just filtered) without losing edits made on
  # other tabs.
  def set_controls(controls)
    @controls = controls
    @reading_input  = false
    @deleting_input = false
    @default_input  = false
    self.index = 0
    self.top_row = 0
    refresh
  end

  def itemCount
    return @controls.length + EXIT_EXTRA_INDEX + 1
  end

  def set_new_input(new_input)
    @reading_input = false
    return if @controls[@index].key_code == new_input
    @controls[@index].key_code = new_input
    @changed = true
    refresh
  end

  def remove_input
    @deleting_input = false
    @controls[@index].key_code = 0
    @changed = true
    refresh
  end

  # How many earlier rows in +list+ share the same action as the row at
  # +idx+. Used to line a binding up with the matching entry in
  # Keys.default_controls when an action has more than one binding (e.g.
  # "Action" is bound to both Space and the left mouse button by default).
  def occurrence_index(list, idx)
    action = list[idx].control_action
    count = 0
    list[0...idx].each { |control| count += 1 if control.control_action == action }
    return count
  end

  def default_the_input
    @default_input = false
    control = @controls[@index]
    control.key_code = Keys.default_key_code_for(
      control.control_action, occurrence_index(@controls, @index)
    )
    @changed = true
    refresh
  end

  # Resets every binding on this tab back to its default.
  def reset_tab_to_default
    @controls.each_with_index do |control, i|
      control.key_code = Keys.default_key_code_for(
        control.control_action, occurrence_index(@controls, i)
      )
    end
    @changed = true
    refresh
  end

  def on_exit_index?
    return @controls.length + EXIT_EXTRA_INDEX == @index
  end

  def on_default_index?
    return @controls.length + DEFAULT_EXTRA_INDEX == @index
  end
  def on_full_reset_index?
    return @controls.length + EXIT_FULL_RESET_INDEX == @index
  end

  def item_description
    return _INTL("Close. If you changed anything, asks if you want to keep changes.") if on_exit_index?
	if on_full_reset_index?
      return _INTL("Restore every control to its default.")
	end 
    if on_default_index?
      return _INTL("There are no controls on this tab to reset.") if @controls.empty?
      return _INTL("Restore every control on this tab to its default.")
    end
    return control_description(@controls[@index].control_action)
  end


  def drawItem(index, _count, rect)
    rect = drawCursor(index, rect)
    name = case index - @controls.length
           when DEFAULT_EXTRA_INDEX then _INTL("Reset Tab")
           when EXIT_FULL_RESET_INDEX then _INTL("Reset All")
           when EXIT_EXTRA_INDEX    then _INTL("Close")
           else @controls[index].control_action
           end

    width = rect.width * 9 / 20
    sel = (index == self.index)

    pbDrawShadowText(
      self.contents, rect.x, rect.y, width, rect.height,
      name,
      sel ? SEL_NAME_BASE_COLOR : NAME_BASE_COLOR,
      sel ? SEL_NAME_SHADOW_COLOR : NAME_SHADOW_COLOR
    )

    return if index >= @controls.length

    value = _INTL(@controls[index].key_name)
    xpos = width + rect.x
    pbDrawShadowText(
      self.contents, xpos, rect.y, width, rect.height,
      value, SEL_VALUE_BASE_COLOR, SEL_VALUE_SHADOW_COLOR
    )
  end

  def update
    oldindex = self.index
    super
    do_refresh = self.index != oldindex

    if self.active && self.index <= @controls.length + 1
      if Input.trigger?(Input::C)
        if on_default_index?
          if !@controls.empty? && pbConfirmMessage(_INTL("Reset every control on this tab to default? Anyway, you can exit this screen without keeping the changes."))
            pbPlayDecisionSE
            reset_tab_to_default
            do_refresh = true
          end
        elsif on_full_reset_index?
          if pbConfirmMessage(_INTL("Are you sure? Anyway, you can exit this screen without keeping the changes."))
            pbPlayDecisionSE
            @refresh_controls        = true 
			@changed = true
            do_refresh = true
          end
        elsif self.index < @controls.length
          commands   = []
          cmdChange  = commands.length; commands.push(_INTL("Change Key"))
          cmdDelete  = commands.length; commands.push(_INTL("Delete Key"))
          cmdDefault = commands.length; commands.push(_INTL("Default Key"))
          commands.push(_INTL("Cancel"))

          msgwindow = pbCreateMessageWindow(nil, nil)
          pbMessageDisplay(msgwindow, _INTL("What will you do?\\wtnp[1]"))
          command = pbShowCommands(msgwindow, commands)
          pbDisposeMessageWindow(msgwindow)

          if command == cmdChange
            @reading_input = true
          elsif command == cmdDelete
            @deleting_input = true
          elsif command == cmdDefault
            @default_input = true
          end
        end
      end
    end

    refresh if do_refresh
  end
end

class PokemonControls_Scene
  # Same palette as the tab text uses when selected/unselected, so the tab
  # bar and the list below it look like one piece.
  TAB_BASE_COLOR       = Color.new(88, 88, 80)
  TAB_SHADOW_COLOR     = Color.new(168, 184, 184)
  TAB_SEL_BASE_COLOR   = Color.new(192, 120, 0)
  TAB_SEL_SHADOW_COLOR = Color.new(248, 176, 80)
  TAB_HEIGHT           = 32


  def has_debug_menu?
    @all_controls.each do |control|
	  if control.control_action == "Debug Menu"
	    return false
	  end
	end
    return true
  end
  def start_scene
    @sprites  = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999

    # Same background as the main Options screen.
    addBackgroundOrColoredPlane(
      @sprites, "bg", "optionsbg", Color.new(192, 200, 208), @viewport
    )

    @sprites["title"] = Window_UnformattedTextPokemon.newWithSize(
      _INTL("Controls"), 0, -16, Graphics.width, 64, @viewport
    )
    @sprites["title"].back_opacity = 0

    tab_top = @sprites["title"].y + @sprites["title"].height - 16

    @categories = ControlCategories.all
    @tab_index  = 0

    @sprites["tabs"] = Sprite.new(@viewport)
    @sprites["tabs"].x = 0
    @sprites["tabs"].y = tab_top
    @sprites["tabs"].bitmap = Bitmap.new(Graphics.width, TAB_HEIGHT)

    @sprites["textbox"] = pbCreateMessageWindow
    @sprites["textbox"].letterbyletter = false
    pbSetSystemFont(@sprites["textbox"].contents)

    @all_controls = $PokemonSystem.game_controls.map { |c| c.clone }
    @all_controls << ControlConfig.new("Debug Menu", "/?") if $DEBUG && !has_debug_menu?
	
    list_y = tab_top + TAB_HEIGHT
    @sprites["controlwindow"] = Window_PokemonControls.new(
      controls_for_tab(@tab_index),
      0, list_y,
      Graphics.width,
      Graphics.height - list_y - @sprites["textbox"].height
    )
    @sprites["controlwindow"].viewport = @viewport
    @sprites["controlwindow"].visible  = true

    @tab_positions = {}
    @changed = false

    draw_tabs
    pbDeactivateWindows(@sprites)
    pbFadeInAndShow(@sprites) { update }
  end

  # Every control assigned to the category at +tab_index+, pulled from the
  # shared master list so edits persist when switching tabs.
  def controls_for_tab(tab_index)
    category = @categories[tab_index]
    return [] if category.nil?
    return @all_controls.select { |c| ControlCategories.for_action(c.control_action) == category.id }
  end

  def draw_tabs
    bitmap = @sprites["tabs"].bitmap
    bitmap.clear
    return if @categories.empty?
    pbSetSystemFont(bitmap)

    tab_width = bitmap.width / @categories.length
    @categories.each_with_index do |category, i|
      selected = (i == @tab_index)
      pbDrawShadowText(
        bitmap, i * tab_width, 0, tab_width, bitmap.height,
        category.name,
        selected ? TAB_SEL_BASE_COLOR : TAB_BASE_COLOR,
        selected ? TAB_SEL_SHADOW_COLOR : TAB_SHADOW_COLOR,
        1
      )
    end
  end

  def current_tab_empty?
    return controls_for_tab(@tab_index).empty?
  end

  def change_tab(tab_index)
    return if @categories.empty?

    # Remember where the cursor was on the tab we're leaving.
    @tab_positions[@tab_index] = @sprites["controlwindow"].index

    @tab_index = tab_index % @categories.length
    draw_tabs

    @sprites["controlwindow"].set_controls(controls_for_tab(@tab_index))
    saved = @tab_positions[@tab_index]
    @sprites["controlwindow"].index = saved if saved
  end

  def current_description
    return _INTL("No controls are assigned to this tab yet.") if current_tab_empty?
    return @sprites["controlwindow"].item_description
  end

  def update
    pbUpdateSpriteHash(@sprites)
  end

  def main
    last_index = -1
    should_refresh_text = false

    pbActivateWindow(@sprites, "controlwindow") {
      loop do
        Graphics.update
        Input.update
        update
        should_update_controls = @sprites["controlwindow"].refresh_controls
        should_refresh_text = @sprites["controlwindow"].index != last_index
        if should_update_controls
		 
         @all_controls = Keys.default_controls.map { |c| c.clone }
         @all_controls << ControlConfig.new("Debug Menu", "/?") if $DEBUG && !has_debug_menu?
         draw_tabs
         @sprites["controlwindow"].set_controls(controls_for_tab(@tab_index))
		 should_refresh_text = true 
		 @sprites["controlwindow"].refresh_controls = false 
		 @changed = true 
		end 
        if @sprites["controlwindow"].reading_input
          @sprites["textbox"].text = _INTL("Press a new key.")
          @sprites["controlwindow"].set_new_input(Keys.detect_key)
          should_refresh_text = true
          @changed = true
        elsif @sprites["controlwindow"].deleting_input
          @sprites["textbox"].text = _INTL("Unbinding Key.")
          @sprites["controlwindow"].remove_input
          should_refresh_text = true
          @changed = true
        elsif @sprites["controlwindow"].default_input
          @sprites["textbox"].text = _INTL("Setting key to default.")
          @sprites["controlwindow"].default_the_input
          should_refresh_text = true
          @changed = true
        else
          if Input.trigger?(Input::LEFT) && @categories.length > 1
            pbPlayCursorSE
            change_tab(@tab_index - 1)
            should_refresh_text = true
          elsif Input.trigger?(Input::RIGHT) && @categories.length > 1
            pbPlayCursorSE
            change_tab(@tab_index + 1)
            should_refresh_text = true
          elsif Input.trigger?(Input::B) || (
            Input.trigger?(Input::C) && @sprites["controlwindow"].on_exit_index?
          )
            if @sprites["controlwindow"].changed &&
               pbConfirmMessage(_INTL("Keep changes?"))
              should_refresh_text = true # Visual effect
              controls = @all_controls.reject { |control| control.control_action == "Debug Menu" }
              siSaveControls(controls)
              $PokemonSystem.game_controls = @all_controls
              break
            else
              break
            end
          end
        end

        if should_refresh_text
          new_text = current_description
          @sprites["textbox"].text = new_text if @sprites["textbox"].text != new_text
          last_index = @sprites["controlwindow"].index
        end
      end
    }
  end

  def end_scene
    pbFadeOutAndHide(@sprites) { update }
    pbDisposeMessageWindow(@sprites["textbox"])
    if @sprites["tabs"] && @sprites["tabs"].bitmap && !@sprites["tabs"].bitmap.disposed?
      @sprites["tabs"].bitmap.dispose
    end
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class PokemonControlsScreen
  def initialize(scene)
    @scene = scene
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
    @game_controls = merge_controls(siLoadControls)
	@game_controls << ControlConfig.new("Debug Menu", "/?") if $DEBUG && !has_debug_menu?
    return @game_controls
  end
  def merge_controls(saved_controls)
  used = Array.new(saved_controls.length, false)

  Keys.default_controls.map do |default_control|
    index = saved_controls.each_index.find do |i|
      !used[i] &&
        saved_controls[i].control_action == default_control.control_action
    end

    if index
      used[index] = true
      saved_controls[index]
    else
      default_control
    end
  end
end
  
  def has_debug_menu?
    @game_controls.each do |control|
	  if control.control_action == "Debug Menu"
	    return false
	  end
	end
    return true
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