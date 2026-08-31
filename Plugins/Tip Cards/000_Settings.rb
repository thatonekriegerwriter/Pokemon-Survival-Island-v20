
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
        TIP_CARDS_SINGLE_GROUP_SHOW_HEADER = false

        #--------------------------------------------------------------------------------
        #  If set to true, when the player uses the SPECIAL control, a list of all
        #  groups available to view will appear for the player to jump to one.
        #--------------------------------------------------------------------------------	
        TIP_CARDS_GROUP_LIST = true

        #--------------------------------------------------------------------------------
        #  Set the default text colors
        #--------------------------------------------------------------------------------	
        TIP_CARDS_TEXT_MAIN_COLOR       = Color.new(248, 248, 248)
        TIP_CARDS_TEXT_SHADOW_COLOR     = Color.new(72, 80, 88)
        TIP_CARDS_BODY_SIZE             = 20
        TIP_CARDS_TITLE_SIZE             = 27
        TIP_CARDS_TITLE_Y_OFFSET             = -10

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
            :SPECIALIZEDCONTROLS => {
                :Title => _INTL("Specialized Controls"),
                :Tips => [:SPECIALIZEDCONTROLS1]
            },
            :HUDSTUFF => {
                :Title => _INTL("HUD Tips"),
                :Tips => [:HUD, :HUD2, :CATCH, :HUD3]
            },
            :SURVIVAL => {
                :Title => _INTL("Survival Mode"),
                :Tips => [:SURVIVALMODE, :SURVIVALMODE2, :SURVIVALMODE3, :SURVIVALMODE4]
            },
            :DEATH => {
                :Title => _INTL("Death"),
                :Tips => [:DOWNED, :LIFESPAN]
            },
            :BASICCOMBAT => {
                :Title => _INTL("Overworld Combat"),
                :Tips => [:COMBAT1, :COMBAT2, :COMBAT3]
            },
            :BASICSCOMBAT => {
                :Title => _INTL("Turn Based Combat (Player)"),
                :Tips => [:SCOMBAT1, :SCOMBAT2]
            },
            :BEDTIMETIPS => {
                :Title => _INTL("Bedtime"),
                :Tips => [:SLEEPING1,:SLEEPING2, :SLEEPING3, :SLEEPING4]
            },
            :OVERWORLD_PKMN => {
                :Title => _INTL("Overworld Pokemon"),
                :Tips => [:OVERWORLDPOKEMON,:OVERWORLDPOKEMON2]
            },
            :FARMING => {
                :Title => _INTL("Farming"),
                :Tips => [:BERRYPLANTS1,:BERRYPLANTS2]
            },
			:ALL =>{
                :Title => _INTL("All Tips"),
                :Tips => [:ALL]
            }
        }

end





class PokemonGlobalMetadata
  
  
  def get_tipcards
     return {
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
                :Text => 
				_INTL("Use #{get_keyname("Up")}#{get_keyname("Left")}#{get_keyname("Down")}#{get_keyname("Right")} to move the main character." +
				"\nIn the options menu, these keys can also be toggled to run upon double tapping, otherwise, running can be performed with #{get_keyname("Running")}." +
				"\n\nThese keys can also be used to navigate menus."),
                :Image => "wasd",
                :ImagePosition => :Top2,
                :ImageZoom => 1,
                :AdjustImageX => 0,
                :AdjustImageY => -16,
                :YAdjustment => -70,
                :Background => "help_bg"
            },
            :CONTROLS2 => {
                :Title => _INTL("Basic Controls"),
                :Text => 
				_INTL("Use (Main Key: #{get_keyname("Action")}) has many uses ranging from interacting with objects, entities, and using items." +
				"\nThis is also bound to LMB." + 
				
                "\n\nBack/Cancel (Main Key: #{get_keyname("Action")}) is used to cancel a decision, leave a menu, or back out of your current action." +  
				"\nThis is also bound to RMB."
				
				
				),
                :Image => "use",
                :ImagePosition => :Top2,
                :ImageZoom => 1,
                :AdjustImageX => 0,
                :AdjustImageY => -10,
                :Image2 => "back",
                :Image2Position => :Top2,
                :Image2Zoom => 1,
                :AdjustImage2X => 0,
                :AdjustImage2Y => 128,
                :YAdjustment => -120,
                :Background => "help_bg"
            },
            :CONTROLS3 => {
                :Title => _INTL("Basic Controls"),
                :Text => 
				_INTL("Controls can be viewed or modified in the Options Menu.\n\nTip Cards like these can be viewed in the Notebook."),
                :YAdjustment => 10,
                :Background => "help_bg"
            },
            :SPECIALIZEDCONTROLS1 => {
                :Title => _INTL("Specialized Controls"),
                :Text => 
				_INTL("Use #{get_keyname("Menu")} to open the Menu, which can be used to access various menus." +
				"\n\nUse #{get_keyname("Inventory")} to open the Inventory, which can be used to access Items, POKeMON, and craft Items.." +
				"\n\nUse #{get_keyname("Open Notebook")} to open the Notebook, which can be used to view Tip Cards, Crafting Recipes, Discovered Pokemon, and take notes."),
            },

            :HUD => {
                :Title => _INTL("The Overworld HUD"),
                :Text => _INTL("The Overworld HUD allows you to use various items, send out POKeMON, or place objects within your bases."),
                :Image => "hud1",
                :ImagePosition => :Top2,
                :AdjustImageY => -16,
                :YAdjustment => -33,
                :Background => "help_bg"
            },
            :HUD2 => {
                :Title => _INTL("The Overworld HUD"),
                :Text => _INTL("Use Show HUD (#{get_keyname("Show HUD")}) to show the HUD, navigation of the HUD can be done using Scroll Wheel, or #{get_keyname("Scroll Up")} and #{get_keyname("Scroll Down")}." +
				"\nYou can use the Use key (#{get_keyname("Action")}/RMB) to select an option." + 
				"\nKeys 1-9 can also be used to quickly shift between available menus."
				),
                :Image => "hud1",
                :ImagePosition => :Top2,
                :AdjustImageX => 0,
                :AdjustImageY => -16,
                :YAdjustment => -70,
                :Background => "help_bg"
            },
            :CATCH => {
                :Title => _INTL("The Overworld HUD"),
                :Text => _INTL("If you have a <c2=0999367C><b>Poké Ball</b></c2> selected, you can use the Use Key (#{get_keyname("Action")}) to catch any POKeMON you encounter."),
                :Image => "catch",
                :ImagePosition => :Top2,
                :AdjustImageY => -16,
                :YAdjustment => -43,
                :Background => "help_bg"
            },
            :HUD3 => {
                :Title => _INTL("The Overworld HUD"),
                :Text => _INTL("When scrolled over an POKeMON, you can use the Use Key (#{get_keyname("Action")}) to send the POKeMON out into the World." +
				"\nIn this state, you can once again use the Use key to enter it's Direction Menu, double tapping the Back key will recall it." +
				"\nA POKeMONs direction menu can be used to give the POKeMON orders to move or attack."
				
				
				),
                :Image => "hud2",
                :ImagePosition => :Top2,
                :AdjustImageY => -20,
                :YAdjustment => -86,
                :Background => "help_bg"
            },
            :OVERWORLDPOKEMON => {
                :Title => _INTL("Overworld POKeMON"),
                :Text => _INTL("When a POKeMON has been sent into the Overworld, it can be directed multiple ways." +
				"\n• Using the Overworld HUD to give orders, the Special key (#{get_keyname("Combat HUD")}) can be used to immediately open the Orders Menu."+
				"\n• Double tapping the Direct Key (#{get_keyname("Direct Pokemon")}) to direct it to an object or position."
				
				
				),
                :Image => "hud2",
                :ImagePosition => :Top2,
                :AdjustImageY => -20,
                :YAdjustment => -86,
                :Background => "help_bg"
            },
            :OVERWORLDPOKEMON2 => {
                :Title => _INTL("Overworld POKeMON"),
                :Text => _INTL("When multiple POKeMON are out in the world, double tapping the Direct Key (#{get_keyname("Direct Pokemon")}) can select and unselect POKeMON." +
				"\n\nHolding the Direct Key will create a Selection Box, allowing you to select a large amount of POKeMON at once." +
				"\n\nThe Show Grid Key (#{get_keyname("Show Grid")}) can be used to show a Grid on the Overworld for use when throwing or directing POKeMON."
				),
                :Image => "hud2",
                :ImagePosition => :Top2,
                :AdjustImageY => -20,
                :YAdjustment => -86,
                :Background => "help_bg"
            },
            :COMBAT1 => {
                :Title => _INTL("Overworld Combat"),
                :Text => _INTL("When travelling, you may encounter a POKeMON whom is hostile to you, they might run at you or fire projectiles," +
				"\nWhen this occurs, you will have to avoid the incoming attacks, or you will get hit." +
				"\nIf you are hit from the side or behind, you will take greater damage. This applies to anything being attacked in the Overworld."),
                :Image => "Dodging",
                :ImagePosition => :Top2,
                :ImageZoom => 1,
                :AdjustImageX => 00,
                :AdjustImageY => -18,
                :YAdjustment => -76,
                :Background => "help_bg"
            },
            :COMBAT2 => {
                :Title => _INTL("Overworld Combat"),
                :Text => _INTL("If you have a POKeMON, or a weapon, they can be used to engage with an enemy more safely. "+
				"Recieving especially powerful attacks from a POKeMON may lead you to being knocked over. "+
				"In these situations, you will either have to fend for yourself, or, if you have a POKeMON, release them to battle."),
                :Image => "hud2",
                :ImagePosition => :Top2,
                :AdjustImageY => -20,
                :YAdjustment => -86,
                :Background => "help_bg"
            },
            :COMBAT3 => {
                :Title => _INTL("Overworld Combat"),
                :Text => _INTL("While moving around, you do have some ways of fighting back, even if without POKeMON and unequipped." +
				"\nThe Punch key (#{get_keyname("Punch")}) will let you punch.\nThe Lock On key (#{get_keyname("Lock On")}), will allow you to focus on an enemy." + 
				"\nWhen locked on, the Check key (#{get_keyname("Check")}) will allow you to get details about whatever you may be locked onto."),
                :Image => "controlset3",
                :ImagePosition => :Top2,
                :AdjustImageX => 0,
                :AdjustImageY => -20,
                :YAdjustment => -96,
                :Background => "help_bg"
            },
            :SURVIVALMODE => {
                :Title => _INTL("Surviving"),
                :Text => _INTL("While traveling around, your Statuses can change. Your Health reflects your own condition, if it reaches zero, you will have to reload a save. \nYour Stamina controls what all you can do in the world, it decreases when using items, and when Running."),
                :Image => "survival mode",
                :ImagePosition => :Top2,
                :AdjustImageX => 0,
                :AdjustImageY => -10,
                :YAdjustment => -50,
                :Background => "help_bg"
            },
            :SURVIVALMODE2 => {
                :Title => _INTL("Surviving"),
                :Text => _INTL("Your Food, Water, and Sleep can decrease, and if they are zero, you begin taking damage. If H2O or FOD are blue, they will not decrease."),
                :Image => "survival mode",
                :ImagePosition => :Top2,
                :AdjustImageX => 0,
                :AdjustImageY => -10,
                :YAdjustment => -50,
                :Background => "help_bg"
            },
            :SURVIVALMODE3 => {
                :Title => _INTL("Surviving"),
                :Text => _INTL("If Hardcore Mode is on, upon your characters death, your save is deleted."),
                :Image => "survival mode",
                :ImagePosition => :Top2,
                :AdjustImageX => 0,
                :AdjustImageY => 30,
                :YAdjustment => -30,
                :Background => "help_bg"
            },
            :SURVIVALMODE4 => {
                :Title => _INTL("Surviving"),
                :Text => _INTL("Every choice has a cost."),
                :YAdjustment => 70,
                :Background => "help_bg"
            },
            :SLEEPING1 => {
                :Title => _INTL("Sleeping"),
                :Text => _INTL("You can sleep up to 24 hours, during this time, while you are sleeping, your SLP stat will increase, and your other Survival Stats will go down."),
                :YAdjustment => 40,
                :Background => "help_bg"
            },
            :SLEEPING2 => {
                :Title => _INTL("Sleeping"),
                :Text => _INTL("Your Pokemon and yourself will be healed some based on amount of time slept. \nAt least a full 8 hours is optimal, and has a chance for extra effects like PP restoration, recovery from a downed state, and a full heal."),
                :YAdjustment => 30,
                :Background => "help_bg"
            },
            :SLEEPING3 => {
                :Title => _INTL("Sleeping"),
                :Text => _INTL("While you are sleeping, there is a random chance for events to occur on the overworld while you sleep. You might wake up to things different from how you left them."),
                :YAdjustment => 40,
                :Background => "help_bg"
            },
            :SLEEPING4 => {
                :Title => _INTL("Sleeping"),
                :Text => _INTL("When you sleep in a bed, your spawnpoint is set there. If you pick back up your bed to move it, make sure to sleep in it before risking anything. If you do not rest in a bed, you will not respawn there."),
                :YAdjustment => 34,
                :Background => "help_bg"
            },
            :CRITICALCONDITION => {
                :Title => _INTL("Critical Condition"),
                :Text => _INTL("One of your Pokemon is in Critical Condition, during this time, it's Lifespan will slowly drain from it's body until it passes away. It can still fight, and have it's HP restored, but it's Lifespan will decrease. When it's Lifespan reaches zero, it will pass away. This can be staved off by items like Revival Herbs, or completely fixed by sleeping a full 8 hours."),
                :YAdjustment => -10,
                :Background => "help_bg"
            },

#pbShowTipCard(:CRITICALCONDITION)
#pbShowTipCardsGrouped(:BEDTIMETIPS)
            :SCOMBAT0 => {
                :Title => _INTL("Combat"),
                :Text => _INTL("."),
                :Background => "help_bg",
                :YAdjustment => 20,
            },
            :SCOMBAT1 => {
                :Title => _INTL("Combat"),
                :Text => _INTL("When jumped by a POKeMON, you have multiple options:\nCATCH, APPEAL, ATTACK, DEFEND.\nWhen using the Shift button while having an option selected, you may perform a different action for the type."),
                :Image => "safaricontrols",
                :ImagePosition => :Top2,
                :ImageZoom => 0.90,
                :Background => "help_bg"
            },
            :SCOMBAT2 => {
                :Title => _INTL("Combat"),
                :Text => _INTL("Changing what you are doing will reflect on the UI. All action types take Stamina." + 
				"\nUnder Defend, you can throw out a POKeMON if you have one, and it will transition to a normal battle."),
                :Image => "safaricontrols2",
                :ImagePosition => :Top2,
                :ImageZoom => 0.90,
                :AdjustImageX => 25,
                :AdjustImageY => 20,
                :YAdjustment => 4,
                :Background => "help_bg"
            },
			
			
			
            :ADVENTURE => {
                :Title => _INTL("Adventures"),
                :Text => _INTL("You can send any Pokémon you have\nout on Adventures, while out, they\nwill encounter their own battles\nand will collect items."),
                :Image => "adventure",
                :ImagePosition => :Left,
                :AdjustImageY => -30,
                :YAdjustment => 20,
                :Background => "help_bg"
            },
            :SHOVEL => {
                :Title => _INTL("Digging"),
                :Text => _INTL("When using a Shovel, you can dig on sand, or dig on newly planted crops to dig them up. When digging on sand, you have a chance to dig up items."),
                :Image => "safaricontrols2",
                :YAdjustment => 30,
                :Background => "help_bg"
            },
            :HOE => {
                :Title => _INTL("Tilling"),
                :Text => _INTL("When using a Hoe, you can till the ground to create tilled ground to farm crops on. Unlike naturally occuring planting spots, these need to be placed in optimal positions for crops to actually grow." +
				"These conditions are nearby water, and good quality soil, which is tied to the presence of water, and not overfarming the same type of crop in that spot.."),
                :YAdjustment => 20,
                :Background => "help_bg"
            },
            :OVERWORLDITEMS => {
                :Title => _INTL("Overworld Item"),
                :Text => _INTL("You are holding an Overworld Object. You can use the Scroll Wheel, or #{get_keyname("Scroll Up")} and #{get_keyname("Scroll Down")}. You can also use the Use Key (#{get_keyname("Action")}) to place it once you have done so. Once it is placed, you can use its UI to pick it up and put it in your inventory, or use the Run Key (#{get_keyname("Running")}) while interacting with it to move it around."),
                :Image => "hud1",
                :ImagePosition => :Top2,
                :AdjustImageY => -20,
                :YAdjustment => -60,
                :Background => "help_bg"
            },
            :DOWNED => {
                :Title => _INTL("Downed"),
                :Text => _INTL("One of your POKeMON has entered a Downed state.\nA Downed POKeMON must rest for at least 8 hours, or placed in a Crate to slow the rate of Lifespan loss.\nWhile downed, a POKeMON will lose Lifespan every few steps."),
                :YAdjustment => 10,
                :Background => "help_bg"
            },
            :LIFESPAN => {
                :Title => _INTL("Lifespan"),
                :Text => _INTL("Pokemon have a finite lifespan which may decrease from injuries, or old age.\nLifespan can be restored with items such as Revival Herbs.\nIf a POKeMON's Lifespan reaches zero, it will Perish."),
                :YAdjustment => 10,
                :Background => "help_bg"
            },
            :PERISHING => {
                :Title => _INTL("Perishing"),
                :Text => _INTL("A POKeMON perishes when it's Lifespan reaches zero.\nIts body may be stored in a Box for safekeeping, buried, or used as a source of food."),
                :YAdjustment => 20,
                :Background => "help_bg"
            },
            :BERRYPLANTS1 => {
                :Title => _INTL("Farming"),
                :Text => _INTL("In order to begin farming, you need to hold a crop in the Item Box, and interact with the soil. It will plant the crop, and you can do the same with Mulch, or Cropsticks." +
				"Plants need to be watered and checked on periodically, but do not need to be watered if it's raining." +
				"Plants will grow as time passes, and will grow faster if you sleep, however, if you sleep too long, the plants may die from lack of care."
				),
                :YAdjustment => -10,
                :Background => "help_bg"
            },
            :BERRYPLANTS2 => {
                :Title => _INTL("Farming (Advanced)"),
                :Text => _INTL("You can also use Cropsticks on soil, which will allow the crops to have a higher yield, and even cross breed with adjacent plants." +
				"However, POKeMON may be attracted to these higher quality plants, and there is an increased risk of weeds."),
                :YAdjustment => 10,
                :Background => "help_bg"
            }







}.freeze

    

  
  end
  
  def tipcards
    @tipcards = get_tipcards #if @tipcards.nil?
	#@tipcards
  end 
  
end