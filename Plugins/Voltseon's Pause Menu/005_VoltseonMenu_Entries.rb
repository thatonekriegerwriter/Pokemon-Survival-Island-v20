#-------------------------------------------------------------------------------
# Entry for Pokemon Party Screen
#-------------------------------------------------------------------------------
class MenuEntryPokemon < MenuEntry
  def initialize
    @icon = "menuPokemon"
    @name = "Pokemon"
    @text = "P"
  end

  def selected(menu)
    hiddenmove = nil
    pbFadeOutIn(99999) {
      sscene = PokemonParty_Scene.new
      sscreen = PokemonPartyScreen.new(sscene,$player.party)
      hiddenmove = sscreen.pbPokemonScreen
    }
    if hiddenmove
      menu.pbHideMenu
      $game_temp.in_menu = false
      pbUseHiddenMove(hiddenmove[0],hiddenmove[1])
      return true
    end
  end

  def selectable?; return ($player.party_count > 0); end
end
#-------------------------------------------------------------------------------
# Entry for Pokedex Screen
#-------------------------------------------------------------------------------
class MenuEntryPokedex < MenuEntry
  def initialize
    @icon = "menuPokedex"
    @name = "Pokédex"
    @text = "-"
  end

  def selected(menu)
    if $player.pokedex.accessible_dexes.length == 1
      $PokemonGlobal.pokedexDex = $player.pokedex.accessible_dexes[0]
      pbFadeOutIn(99999) {
        scene = PokemonPokedex_Scene.new
        screen = PokemonPokedexScreen.new(scene)
        screen.pbStartScreen
      }
    else
      pbFadeOutIn(99999) {
        scene = PokemonPokedexMenu_Scene.new
        screen = PokemonPokedexMenuScreen.new(scene)
        screen.pbStartScreen
      }
    end
  end

  def selectable?
    return false if pbGetCurrentRegion() == 0
    return ($player.has_pokedex && $player.pokedex.accessible_dexes.length > 0)
  end
end
#-------------------------------------------------------------------------------
# Entry for Bag Screen
#-------------------------------------------------------------------------------
class MenuEntryBag < MenuEntry
  def initialize
    @icon = "menuBag"
    @name = "Bag"
    @text = "B"
  end

  def selected(menu)
    item = nil
    pbFadeOutIn(99999) {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene,$bag)
      item = screen.pbStartScreen
    }
    if item
      menu.pbHideMenu
      $game_temp.in_menu = false
      pbUseKeyItemInField(item)
      return true
    end
  end

  def selectable?; return !pbInBugContest?; end
end
#-------------------------------------------------------------------------------
# Entry for Craft Screen
#-------------------------------------------------------------------------------
class MenuEntryCraft < MenuEntry
	def initialize
		@icon = "menuCrafting"
		@name = "Crafting"
       @text = "C"
	end

	def selected(menu)
	  item = nil
	  pbFadeOutIn(99999) {
    pbCraftingBench(:POCKETCRAFTING)
	  }
	end

	def selectable? 
	return false if $PokemonSystem.playermode == 0
	return true if $game_switches[485]==false
	end
end
#-------------------------------------------------------------------------------
# Entry for Mystery Gift Screen
#-------------------------------------------------------------------------------
class MenuEntryMystery < MenuEntry
	def initialize
		@icon = "menuDebug"
		@name = "Mystery Gift"
       @text = "-"
	end

	def selected(menu)
	  item = nil
      Kernel.pbMessage(_INTL("Oh! What's this?!?!"))
	  id = pbNextMysteryGiftID
      pbReceiveMysteryGift(id)
	end

	def selectable?; return true if pbNextMysteryGiftID>0; end
end
#-------------------------------------------------------------------------------
# Entry for Craft Screen
#-------------------------------------------------------------------------------
class MenuEntryVentures < MenuEntry
	def initialize
		@icon = "menuAdventures"
		@name = "Adventures"
       @text = "V"
	end

	def selected(menu)
	    if !pbSeenTipCard?(:ADVENTURE)
		 pbShowTipCard(:ADVENTURE)
		end
	  item = nil
	  pbFadeOutIn(99999) {
    pbStartAdventureMenu
	  }
	end
def selectable?
	return true
	end
end
#-------------------------------------------------------------------------------
# Entry for Craft Screen
#-------------------------------------------------------------------------------
class MenuEntryTips < MenuEntry
	def initialize
		@icon = "menuQuest"
		@name = "Tips"
       @text = "-"
	end

	def selected(menu)
	  pbFadeOutIn(99999) {
      pbRevisitTipCards
	  }
	end
def selectable?
	return true
	end
end
#-------------------------------------------------------------------------------
# Entry for CAchievements Screen
#-------------------------------------------------------------------------------
class MenuEntryAchievements < MenuEntry
	def initialize
		@icon = "menuAchievements"
		@name = "Achievements"
       @text = "T"
	end

	def selected(menu)
	  item = nil
	  pbFadeOutIn(99999) {
	  	Achievements.AchievementWindow
	  }
	end

	def selectable?; return true; end
end
#-------------------------------------------------------------------------------
# Entry for Control Screen
#-------------------------------------------------------------------------------
class MenuEntryControls < MenuEntry
	def initialize
		@icon = "menuControls"
		@name = "Controls"
       @text = "-"
	end

	def selected(menu)
	  item = nil
	  pbFadeOutIn(99999) {
	  	open_set_controls_ui
	  }
	end

	def selectable?; return true; end
end
# Entry for Pokegear Screen
#-------------------------------------------------------------------------------
class MenuEntryPokegear < MenuEntry
  def initialize
    @icon = "menuPokegear"
    @name = "PokéGear"
    @text = "-"
  end

  def selected(menu)
    pbFadeOutIn(99999) {
      scene = PokemonPokegear_Scene.new
      screen = PokemonPokegearScreen.new(scene)
      screen.pbStartScreen
    }
  end

  def selectable?; return false; end#$player.has_pokegear; end
end
#-------------------------------------------------------------------------------
# Entry for Trainer Card Screen
#-------------------------------------------------------------------------------
class MenuEntryTrainer < MenuEntry
  def initialize
    @icon = "menuTrainer"
    @name = $player.name
       @text = "-"
  end

  def selected(menu)
    pbFadeOutIn(99999) {
      scene = PokemonTrainerCard_Scene.new
      screen = PokemonTrainerCardScreen.new(scene)
      screen.pbStartScreen(false)
    }
  end

  def selectable?; return false; end
end
#-------------------------------------------------------------------------------
# Entry for Badge Case
#-------------------------------------------------------------------------------
class MenuEntryBadge < MenuEntry
  def initialize
    @icon = "menuBadge"
    @name = "Badge Case"
       @text = "-"
  end

  def selected(menu)
    pbFadeOutIn {
      scene = BadgeCase_Scene.new
      screen = BadgeCaseScreen.new(scene)
      screen.pbStartScreen
    }
  end

  def selectable?; return $bag.has?(:BADGECASE); end
end
#-------------------------------------------------------------------------------
# Entry for Save Screen
#-------------------------------------------------------------------------------
class MenuEntrySave < MenuEntry
  def initialize
    @icon = "menuSave"
    @name = "Save"
    @text = "S"
  end

  def selected(menu)
    menu.pbHideMenu
    scene = PokemonSave_Scene.new
    screen = PokemonSaveScreen.new(scene)
    screen.pbSaveScreen
    menu.pbShowMenu
  end

  def selectable?
     maps=[10,54,56,351,352,41,148,149,155,150,151,152,147,153,154,162]
    return (!pbInBugContest? && $game_system && !$game_system.save_disabled && (maps.include?($game_map.map_id) || $PokemonSystem.playermode == 0)) 
  end
end
#-------------------------------------------------------------------------------
# Entry for Town Map Screen
#-------------------------------------------------------------------------------
class MenuEntryMap < MenuEntry # Play Pokémon Splice
  def initialize
    @icon = "menuMap"
    @name = "Map"
       @text = "-"
  end

  def selected(menu)
    pbShowMap(-1,false)
  end

  def selectable?; return $bag.has?(:TOWNMAP); end
end
#-------------------------------------------------------------------------------
# Entry for Options Screen
#-------------------------------------------------------------------------------
class MenuEntryOptions < MenuEntry
  def initialize
    @icon = "menuOptions"
    @name = "Options"
       @text = "-"
  end

  def selected(menu)
    pbFadeOutIn(99999) {
      scene = PokemonOption_Scene.new
      screen = PokemonOptionScreen.new(scene)
      screen.pbStartScreen
      pbUpdateSceneMap
    }
    return $game_temp.menu_theme_changed
  end

  def selectable?; return true; end
end
#-------------------------------------------------------------------------------
# Entry for Debug Menu Screen
#-------------------------------------------------------------------------------
class MenuEntryDebug < MenuEntry
  def initialize
    @icon = "menuDebug"
    @name = "Debug"
       @text = "-"
  end

  def selected(menu)
    pbFadeOutIn(99999) { pbDebugMenu }
    return $game_temp.menu_theme_changed
  end

  def selectable?; return $DEBUG; end
end
#-------------------------------------------------------------------------------
# Entry for quitting Safari Zone
#-------------------------------------------------------------------------------
class MenuEntryExitSafari < MenuEntry
  def initialize
    @icon = "menuBack"
    @name = "Quit Safari"
       @text = "-"
  end

  def selected(menu)
    menu.pbHideMenu
    if pbConfirmMessage(_INTL("Would you like to leave the Safari Game right now?"))
      $game_temp.in_menu = false
      pbSafariState.decision = 1
      pbSafariState.pbGoToStart
      return true
    end
    menu.pbShowMenu
  end

  def selectable?; return false; end
end
#-------------------------------------------------------------------------------
# Entry for quitting Bug Contest
#-------------------------------------------------------------------------------
class MenuEntryExitBugContest < MenuEntry
  def initialize
    @icon = "menuBack"
    @name = "Quit Contest"
       @text = "-"
  end

  def selected(menu)
    menu.pbHideMenu
    if pbConfirmMessage(_INTL("Would you like to end the Contest now?"))
      $game_temp.in_menu = false
      pbBugContestState.pbStartJudging
      return true
    end
    menu.pbShowMenu
  end

  def selectable?; return pbInBugContest?; end
end


class MenuEntryExitDemo < MenuEntry
  def initialize
    @icon = "menuBack"
    @name = "Quit Demo"
       @text = "-"
  end

  def selected(menu)
    menu.pbHideMenu
	pbDemoExit
  end

  def selectable?; return true if $PokemonSystem.playermode == 0; end
end
#-------------------------------------------------------------------------------
# Entry for quitting the game
#-------------------------------------------------------------------------------
class MenuEntryQuit < MenuEntry
  def initialize
    @icon = "menuQuit"
    @name = "Quit"
       @text = "Q"
  end

  def selected(menu)
    menu.pbHideMenu
    if pbConfirmMessage(_INTL("Are you sure you want to quit the game?"))
      menu.pbEndScene
	$scene = pbCallTitle(false)
    while $scene != nil
      $scene.main
    end
    Graphics.transition(20)
    end
  end

  def selectable?; return !pbInBugContest?; end
end
#-------------------------------------------------------------------------------
# Entry for Encounter List screen by ThatWelshOne
#-------------------------------------------------------------------------------
class MenuEntryEncounterList < MenuEntry
  def initialize
    @icon = "menuDebug"
    @name = "Encounters"
       @text = "-"
  end

  def selected(menu)
    pbFadeOutIn(99999) {
      scene = EncounterList_Scene.new
      screen = EncounterList_Screen.new(scene)
      screen.pbStartScreen
    }
  end

  def selectable?; return false; end
end

#-------------------------------------------------------------------------------
# Entry for Modern Quest System by ThatWelshOne
#-------------------------------------------------------------------------------
class MenuEntryQuests < MenuEntry
  def initialize
    @icon = "menuQuest"
    @name = "Quests"
    @text = "G"
  end

  def selected(menu); pbFadeOutIn(99999) { pbViewQuests }; end

  def selectable?; return defined?(hasAnyQuests?) && hasAnyQuests?; end
end
