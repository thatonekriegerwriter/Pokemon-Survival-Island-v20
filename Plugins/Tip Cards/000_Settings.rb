
module Settings
    #====================================================================================
    #=============================== Tip Cards Settings =================================
    #====================================================================================
    
        #--------------------------------------------------------------------------------
        #  Set the default background for tip cards.
        #  The files are located in Graphics/Pictures/Tip Cards
        #--------------------------------------------------------------------------------	
        TIP_CARDS_DEFAULT_BG            = "help_bg"

        #--------------------------------------------------------------------------------
        #  If set to true, if only one group is shown when calling pbRevisitTipCardsGrouped,
        #  the group header will still appear. Otherwise, the header won't appear.
        #--------------------------------------------------------------------------------	
        TIP_CARDS_SINGLE_GROUP_SHOW_HEADER = true

        #--------------------------------------------------------------------------------
        #  If set to true, when the player uses the SPECIAL control, a list of all
        #  groups available to view will appear for the player to jump to one.
        #--------------------------------------------------------------------------------	
        TIP_CARDS_GROUP_LIST = true

        #--------------------------------------------------------------------------------
        #  Set the default text colors
        #--------------------------------------------------------------------------------	
        TIP_CARDS_TEXT_MAIN_COLOR       = Color.new(80, 80, 88)
        TIP_CARDS_TEXT_SHADOW_COLOR     = Color.new(160, 160, 168)

        #--------------------------------------------------------------------------------
        #  Set the sound effect to play when showing, dismissing, and switching tip cards.
        #  For TIP_CARDS_SWITCH_SE, set to nil to use the default cursor sound effect.
        #--------------------------------------------------------------------------------	
        TIP_CARDS_SHOW_SE               = "GUI menu open"
        TIP_CARDS_DISMISS_SE            = "GUI menu close"
        TIP_CARDS_SWITCH_SE             = nil

        #--------------------------------------------------------------------------------
        #  Define your tips in this hash. The :EXAMPLE describes what some of the 
        #  parameters do.
        #--------------------------------------------------------------------------------	
        TIP_CARDS_CONFIGURATION = {}

        TIP_CARDS_GROUPS = {
            :BEGINNER => {
                :Title => _INTL("Basic Controls"),
                :Tips => [:CONTROLS1, :CONTROLS2, :CONTROLS3]
            },
            :HUDSTUFF => {
                :Title => _INTL("Hud Tips"),
                :Tips => [:HUD, :HUD2, :CATCH]
            },
            :SURVIVAL => {
                :Title => _INTL("Survival Mode"),
                :Tips => [:SURVIVALMODE, :SURVIVALMODE2, :SURVIVALMODE3, :SURVIVALMODE4]
            },
            :BASICCOMBAT => {
                :Title => _INTL("Combat"),
                :Tips => [:CONTROLS3,:COMBAT1, :COMBAT2, :COMBAT3]
            },
            :BASICSCOMBAT => {
                :Title => _INTL("Combat"),
                :Tips => [:SCOMBAT0,:SCOMBAT1, :SCOMBAT2, :SCOMBAT3]
            }
        }

end





class PokemonGlobalMetadata
  # Movement
  attr_accessor :tipcards
  
  
  
  def tipcards
     return @tipcards = {
            :EXAMPLE => { # ID of the tip
                    # Required Settings
                    :Title => _INTL("Example Tip"),
                    :Text => _INTL("This is the text of the tip. You can include formatting."),
                    # Optional Settings
                    :Image => "example", # An image located in Graphics/Pictures/Tip Cards/Images
                    :ImagePosition => :Top, # Set to :Top, :Bottom, :Left, or :Right.
                        # If not defined, it will place wider images to :Top, and taller images to :Left.
                    :Background => "bg2", # A replacement background image located in Graphics/Pictures/Tip Cards
                    :YAdjustment => 0, # Adjust the vertical spacing of the tip's text (in pixels)
                    :HideRevisit => true # Set to true if you don't want the player to see the tip again when revisiting seen tips.
            },
            :CONTROLS1 => {
                :Title => _INTL("Basic Controls"),
                :Text => _INTL("#{get_keyname("Up")}#{get_keyname("Left")}#{get_keyname("Down")}#{get_keyname("Right")} to move. Use #{get_keyname("Running")} to run if you have Running Shoes.\nUse is the key to interact with people and things and use Overworld Items. Key:#{get_keyname("Action")}\nBack is the key to exit, cancel a choice, or cancel a mode. Key: #{get_keyname("Cancel")}\n Action is used to open the Pause Menu. Key: #{get_keyname("Menu")}"),
                :Image => "controlset1",
                :ImagePosition => :Top2,
                :ImageZoom => 0.75,
                :AdjustImageX => 38,
                :AdjustImageY => 17,
                :YAdjustment => -70,
                :Background => "help_bg"
            },
            :CONTROLS2 => {
                :Title => _INTL("Specialized Controls"),
                :Text => _INTL("These are more specialized controls.\nSpecial is used to quickly access items from the bag. Key: #{get_keyname("Special")}\nHud Keys are used to control the overworld HUD. To show the hud, use #{get_keyname("Show HUD")}. To toggle it's contents, use #{get_keyname("Toggle HUD Contents")}.\nThe two AUX keys have various functions, and are tied to #{get_keyname("Aux 1")} and #{get_keyname("Aux 2")}."),
                :Image => "controlset2",
                :ImagePosition => :Top2,
                :ImageZoom => 0.75,
                :AdjustImageX => 38,
                :AdjustImageY => 17,
                :YAdjustment => -70,
                :Background => "help_bg"
            },
            :CONTROLS3 => {
                :Title => _INTL("Combat Controls"),
                :Text => _INTL("These are Overworld Combat Controls.\nThe key #{get_keyname("Punch")} will let you punch.\nTo Control your Pokémon that are on the Overworld, you use the key #{get_keyname("Direct Pokemon")}.\nTo lock on to an enemy target, you use the key #{get_keyname("Lock On")}."),
                :Image => "controlset3",
                :ImagePosition => :Top2,
                :ImageZoom => 0.75,
                :AdjustImageX => 38,
                :AdjustImageY => 17,
                :YAdjustment => -70,
                :Background => "help_bg"
            },
            :HUD => {
                :Title => _INTL("The Overworld HUD"),
                :Text => _INTL("The Overworld HUD allows you to use various items, or place objects within your bases. (This can also be done from the bag.) Use Scroll Wheel or Up Arrow/Down Arrow to move through items, then use the Use Key (#{get_keyname("Action")}) to use it on the Overworld."),
                :Image => "hud1",
                :ImagePosition => :Top2,
                :AdjustImageY => 20,
                :YAdjustment => -43,
                :Background => "help_bg"
            },
            :HUD2 => {
                :Title => _INTL("The Overworld HUD"),
                :Text => _INTL("When you have Pokémon, you can use the #{get_keyname("Toggle HUD Contents")} to switch between Pokémon and Items. When having a Pokémon selected, you can use the Use Key (#{get_keyname("Action")}) to send it into the world."),
                :Image => "hud2",
                :ImagePosition => :Top2,
                :AdjustImageY => 20,
                :YAdjustment => -43,
                :Background => "help_bg"
            },
            :CATCH => {
                :Title => _INTL("The Overworld HUD"),
                :Text => _INTL("If you have a <c2=0999367C><b>Poké Ball</b></c2> selected, you can use the Use Key (#{get_keyname("Action")}) to catch any POKeMON you encounter."),
                :Image => "catch",
                :ImagePosition => :Top2,
                :AdjustImageY => 20,
                :YAdjustment => -43,
                :Background => "help_bg"
            },
            :SURVIVALMODE => {
                :Title => _INTL("Surviving"),
                :Text => _INTL("While traveling around, your Statuses can change. Your Health reflects your own condition, if it reaches zero, you will have to reload a save. \nYour Stamina controls what all you can do in the world, it decreases when using items, and when Running."),
                :Image => "survival mode",
                :ImagePosition => :Top2,
                :ImageZoom => 0.75,
                :AdjustImageX => 38,
                :AdjustImageY => 17,
                :YAdjustment => -70,
                :Background => "help_bg"
            },
            :SURVIVALMODE2 => {
                :Title => _INTL("Surviving"),
                :Text => _INTL("Your Food, Water, and Sleep can decrease, and if they are zero, you begin taking damage. If H2O or FOD are Blue, they will not decrease."),
                :Image => "survival mode",
                :ImagePosition => :Top2,
                :ImageZoom => 0.75,
                :AdjustImageX => 38,
                :AdjustImageY => 17,
                :YAdjustment => -70,
                :Background => "help_bg"
            },
            :SURVIVALMODE3 => {
                :Title => _INTL("Surviving"),
                :Text => _INTL("If a POKeMON dies, it may be able to be brought back with rare items down the line. If Hardcore Mode is on, upon your characters death, your save is deleted."),
                :Image => "survival mode",
                :ImagePosition => :Top2,
                :ImageZoom => 0.75,
                :AdjustImageX => 38,
                :AdjustImageY => 17,
                :YAdjustment => -70,
                :Background => "help_bg"
            },
            :SURVIVALMODE4 => {
                :Title => _INTL("Surviving"),
                :Text => _INTL("Every choice has a cost."),
                :Background => "help_bg"
            },
            :ADVENTURE => {
                :Title => _INTL("Adventures"),
                :Text => _INTL("You can send any Pokémon you have\nout on Adventures, while out, they\nwill encounter their own battles\nand will collect items."),
                :Image => "adventure",
                :ImagePosition => :Left,
                :YAdjustment => 20,
                :Background => "help_bg"
            },
            :ITEMS => {
                :Title => _INTL("Items"),
                :Text => _INTL("This is the text of the other tip. You may find items lying around."),
                :Image => "items",
                :YAdjustment => -70
            },
            :COMBAT1 => {
                :Title => _INTL("Combat Controls 1"),
                :Text => _INTL("You will be presented an input prompt, when offered, hit a direction. You will dodge at a cost of Stamina."),
                :Image => "Dodging",
                :ImagePosition => :Top2,
                :ImageZoom => 0.5,
                :AdjustImageX => 145,
                :AdjustImageY => 20,
                :YAdjustment => -180,
                :Background => "help_bg"
            },
            :COMBAT2 => {
                :Title => _INTL("Combat Controls 2"),
                :Text => _INTL("If you dodge towards the attacking POKeMON, you will dodge past them, it will cost more stamina. If you cannot dodge past them, or you dodge the direction it's moving, you will take damage."),
                :Image => "Dodging",
                :ImagePosition => :Top2,
                :ImageZoom => 0.5,
                :AdjustImageX => 145,
                :AdjustImageY => 20,
                :YAdjustment => -180,
                :Background => "help_bg"
            },
            :COMBAT3 => {
                :Title => _INTL("Combat Controls 3"),
                :Text => _INTL("If you are hit from the side or behind, you will take greater damage. If you do the same to the POKeMON, it will result in the same."),
                :Image => "Dodging",
                :ImagePosition => :Top2,
                :ImageZoom => 0.5,
                :AdjustImageX => 145,
                :AdjustImageY => 20,
                :YAdjustment => -180,
                :Background => "help_bg"
            },
            :SCOMBAT0 => {
                :Title => _INTL("Combat"),
                :Text => _INTL("When in combat, you and your POKeMON can be attacked by enemies. When health is lost, it can be restored by sleeping. If a POKeMON is knocked out, it will begin dying. You must sleep at least 8 hours to prevent its death."),
                :Background => "help_bg"
            },
            :SCOMBAT1 => {
                :Title => _INTL("Combat 1"),
                :Text => _INTL("When jumped by a POKeMON, you have multiple options:  CATCH, APPEAL, ATTACK, DEFEND.\nWhen using the Shift button while having one selected, you can perform a different action fo the type."),
                :Image => "safaricontrols",
                :ImagePosition => :Top2,
                :ImageZoom => 0.90,
                :AdjustImageX => 25,
                :AdjustImageY => 20,
                :YAdjustment => -50,
                :Background => "help_bg"
            },
            :SCOMBAT2 => {
                :Title => _INTL("Combat 2"),
                :Text => _INTL("When changing what you are doing will reflect on the UI. All action types take Stamina."),
                :Image => "safaricontrols2",
                :ImagePosition => :Top2,
                :ImageZoom => 0.90,
                :AdjustImageX => 25,
                :AdjustImageY => 20,
                :YAdjustment => -50,
                :Background => "help_bg"
            },
            :SCOMBAT3 => {
                :Title => _INTL("Combat 3"),
                :Text => _INTL("Under Defend, you can throw out a POKeMON if you have one, and it will transition to a normal battle."),
                :Image => "safaricontrols2",
                :ImagePosition => :Top2,
                :ImageZoom => 0.90,
                :AdjustImageX => 25,
                :AdjustImageY => 20,
                :YAdjustment => -50,
                :Background => "help_bg"
            },
            :SHOVEL => {
                :Title => _INTL("Digging"),
                :Text => _INTL("When using a Shovel, you can dig on sand, or dig on newly planted crops to dig them up. When digging on sand, you have a chance to dig up items."),
                :Image => "safaricontrols2",
                :ImagePosition => :Top2,
                :ImageZoom => 0.90,
                :AdjustImageX => 25,
                :AdjustImageY => 20,
                :YAdjustment => -50,
                :Background => "help_bg"
            },
            :POKEMONAGING => {
                :Title => _INTL("Lifespan"),
                :Text => _INTL("One of your POKeMON aged! Every time a POKeMON ages, their lifespan goes down, when their Lifespan reaches zero, they die."),
                :Image => "safaricontrols2",
                :ImagePosition => :Top2,
                :ImageZoom => 0.90,
                :AdjustImageX => 25,
                :AdjustImageY => 20,
                :YAdjustment => -50,
                :Background => "help_bg"
            },
            :OVERWORLDITEMS => {
                :Title => _INTL("Overworld Item"),
                :Text => _INTL("You are holding an Overworld Object. You can use the UP and DOWN Arrow Keys to set its direction, or the Scroll Wheel. You can also use the USE Key to place it once you have done so. Once it is placed, you can use its UI to pick it up and put it in your inventory, or use SHIFT while interacting with it to move it around."),
                :Image => "hud1",
                :ImagePosition => :Top2,
                :AdjustImageY => 20,
                :YAdjustment => -43,
                :Background => "help_bg"
            }
}

    

  
  end
  
  
  
end