#===============================================================================
# Settings.
#===============================================================================
module Settings
  ##############################################################################
  # Switch settings
  ##############################################################################
  # The switch number for disabling the entire focus mechanic. When this switch
  # is enabled, focus meters will be hidden and disabled, focus may no longer be
  # triggered in battle, Pokemon's Focus Style displays in the Summary will be 
  # hidden, and Pokemon will no longer be able to have their Focus Styles 
  # altered both in and out of battle. Also disables the Focus Panel.
  #-----------------------------------------------------------------------------
  NO_FOCUS_MECHANIC = 39
  

  ##############################################################################
  # Focus Meter visual settings
  ##############################################################################
  # Sets the visual style in which the focus meter is displayed in battle.
  # 0 = No meters      - No visible meter on any Pokemon.
  # 1 = Simple style   - A standard meter displays above databoxes.
  # 2 = Thin style     - A thin meter overlays the upper edge of databoxes.
  # 3 = Vertical style - A vertical meter displays at the inner edge of databoxes.
  # 4 = Advanced style - The entire databox itself becomes the meter.
  #-----------------------------------------------------------------------------
  FOCUS_METER_STYLE = 1
  
  #-----------------------------------------------------------------------------
  # Shows opponent's focus meter when "true", hides them when "false".
  # Note that opponent meters may be automatically hidden regardless of this
  # setting when using certain meter styles in certain battle sizes.
  #-----------------------------------------------------------------------------
  SHOW_FOE_FOCUS_METER = true
  
  #-----------------------------------------------------------------------------
  # The maximum number of points needed before the focus meter is full.
  # All effects that fill a Pokemon's meter are scaled based on this number.
  #-----------------------------------------------------------------------------
  FOCUS_METER_SIZE = 100
  
  #-----------------------------------------------------------------------------
  # Adjusts the X and Y positioning of the focus meter on a Pokemon's databox. 
  # This is only used for the Simple or Thin meter styles. (Default : 4, -8)
  #-----------------------------------------------------------------------------
  FOCUS_METER_XY = 4, -8
  
  #-----------------------------------------------------------------------------
  # Adjusts the speed that the focus meter bar fills up. A lower number will 
  # speed up the animation, and vice versa. (Default : 0.4)
  #-----------------------------------------------------------------------------
  FOCUS_FILL_TIME = 0.4
  
  
  
  ##############################################################################
  # Focus Panel settings
  ##############################################################################
  # Sets how the Focus Panel displays the current focus of battlers.
  # Always shows "????" on opponents when SHOW_FOE_FOCUS_METER is false.
  # 0 = Disables the use of the focus panel.
  # 1 = Displays a mini focus meter.
  # 2 = Displays the current percentage of meter filled (ex. 25%)
  # 3 = Displays the actual meter value out of the max value (ex. 25/100)
  #-----------------------------------------------------------------------------
  FOCUS_PANEL_DISPLAY = 1
  
  #-----------------------------------------------------------------------------
  # Sets the keyboard key used to toggle the focus panel in battle.
  #-----------------------------------------------------------------------------
  FOCUS_PANEL_KEY = :P
  
  
  
  ##############################################################################
  # Gameplay settings
  ##############################################################################
  # The number of turns a full focus meter is held until it manually resets.
  # Set this to -1 to hold a full meter indefinitely.
  #-----------------------------------------------------------------------------
  FOCUS_METER_TIMER = 3
  
  #-----------------------------------------------------------------------------
  # Scales how much overall meter is gained by Pokemon. The number set here will
  # multiply the amount of total focus gained by that number. This means that a
  # higher number will speed up the rate which focus is gained, while a lower
  # number will slow it down. Set this to 1.0 for the default amount of focus.
  #-----------------------------------------------------------------------------
  FOCUS_GAIN_SCALE = 1.0
  
  #-----------------------------------------------------------------------------
  # The default Focus Style each newly generated Pokemon will start with. 
  # Set this to a Focus Style ID (ex. :Accuracy, :Evasion, :Critical, etc.).
  # Setting this to "nil" will randomize each Pokemon's default Focus Style
  # based on their personal ID.
  #-----------------------------------------------------------------------------
  FOCUS_STYLE_DEFAULT = nil
  
  #-----------------------------------------------------------------------------
  # Sets the keyboard key used to trigger a full focus meter in battle.
  #-----------------------------------------------------------------------------
  FOCUS_TRIGGER_KEY = :TAB
end