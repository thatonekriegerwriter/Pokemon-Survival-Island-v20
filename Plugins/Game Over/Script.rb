#===============================================================================
# * Game Over - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. When a switch is on, its activates a
# game over when the player lose a battle instead of going to last healing spot.
# Also, the Game Over event command back to work.
#
#===============================================================================
  
# The switch number that need to be ON in order to allows a game over
GAMEOVERSWITCH = 80

alias :_old_FL_pbStartOver :pbStartOver
def pbStartOver(gameover=false)
    $game_temp.in_menu = false if $game_temp.in_menu==true
    $game_temp.dead = true
    pbLoadRpgxpScene(Scene_Gameover.new) if $player.playermaxhealth2<=0 && $game_temp.in_temple==false
    
    pbFadeOutIn { pbRespawnItself } if $player.playerhealth<=0 && $game_temp.in_temple==false
    pbLoadRpgxpScene(Scene_Gameover.new) if $game_temp.in_temple==true && $player.playerhealth<=0
    return
  _old_FL_pbStartOver(gameover)
end

def pbRespawnAtBed 
 
    pbFadeOutIn { pbRespawnItself }
    $game_temp.lockontarget=false
end

 def pbRespawnItself
    pbBGMFade(1.0)
    pbBGSFade(1.0)
  if pbInBugContest?
    pbBugContestStartOver
    return
  end
  $stats.blacked_out_count += 1
  $player.decrease_current_total_hp
  $player.playerhealth = $player.playermaxhealth2
  if $PokemonGlobal.pokecenterMapId && $PokemonGlobal.pokecenterMapId >= 0 && $player.is_dead==false
    mapname = GameData::MapMetadata&.try_get($PokemonGlobal.pokecenterMapId).name
	if mapname.include?("(Folder)")
    mapname = "The Dreamyard"
	end
    pbMessage(_INTL("\\w[]\\wm\\c[8]\\l[3]You started blacking out, you manage to collapse back in #{mapname}."))
    pbCancelVehicles
    $game_temp.player_new_map_id    = $PokemonGlobal.pokecenterMapId
    $game_temp.player_new_x         = $PokemonGlobal.pokecenterX
    $game_temp.player_new_y         = $PokemonGlobal.pokecenterY
    $game_temp.player_new_direction = $PokemonGlobal.pokecenterDirection
    pbDismountBike
    $scene.transfer_player if $scene.is_a?(Scene_Map)
    $game_map.refresh
    $game_temp.dead = false
  $player.playerfood = $player.playermaxfood
  $player.playerwater = $player.playermaxwater
  $player.playersleep = $player.playermaxsleep
	 pbBedMessageLoss
 else
    pbLoadRpgxpScene(Scene_Gameover.new)
 end
 
 
 
 
 end


def pbCheckAllFainted
  if $player.able_pokemon_count == 0
    pbMessage(_INTL("You have no more Pokémon that can fight!\1"))
    pbMessage(_INTL("You blacked out!"))
  end
end





class Game_Temp
  if !respond_to?(:to_title)
    def to_title
      return @title_screen_calling
    end

    def to_title=(value)
      @title_screen_calling=value
    end
  end
end


# Method created to Interpreter.command_end work in branch
class Interpreter
  def force_end
    command_end
    @list = [RPG::EventCommand.new, RPG::EventCommand.new]
    @index = 0
    @branch = [false]
  end
end

def go_to_title
  $need_save_reload = true
 pbMapInterpreter.force_end if pbMapInterpreter
  $game_screen.start_tone_change(Tone.new(-255, -255, -255), 0)
  $game_temp.to_title = true
        # Switch to title screen
$scene = pbCallTitle(false)

  $game_screen.start_tone_change(Tone.new(0, 0, 0), 0)
end
$need_save_reload = false


# Small adjust to fix an Essentials V19 reload issue
module SaveData
  class << self
    alias :_old_FL_load_all_values :load_all_values
    def load_all_values(save_data)
      if !$need_save_reload
        _old_FL_load_all_values(save_data)
        return
      end
      $game_temp.to_title = false
      $need_save_reload = false
      validate save_data => Hash
      load_values(save_data)
    end
  end
end
# Below is the RPG Maker XP Scene_Gameover with a line commented, three lines
# added and one changed.
#==============================================================================
# ** Scene_Gameover
#------------------------------------------------------------------------------
#  This class performs game over screen processing.
#==============================================================================

class Scene_Gameover
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # Make game over graphic
    $game_temp.lockontarget=false
    pbBGMFade(1.0)
    pbBGSFade(1.0)
    $game_temp.dead = false
    @sprite = Sprite.new
	chance = rand(1000)
	if chance!=0
	if $PokemonGlobal.hardcore == true
	@box2 = Window_AdvancedTextPokemon.new("<ac>You have perished.")
	@box = Window_AdvancedTextPokemon.new("<ac>The darkness of the afterlife is all that awaits you now. May you find more peace in that world than you found in this one.")
   else
	@box2 = Window_AdvancedTextPokemon.new("<ac>Rest in peace, #{$player.name}.")
	@box = Window_AdvancedTextPokemon.new("<ac>Reload your save and try again.")
   end
    @box.x = (Graphics.width/2)-125
	@box.y = Graphics.height/2-50
	@box.z = 999
	@box.windowskin = nil
	@box2.x = (Graphics.width/2)-95
	@box2.y = Graphics.height/2-75
	@box2.z = 999
	@box2.windowskin = nil
	end
	@sprite.z = 950
    # Stop BGM and BGS
    $game_system.bgm_stop
    $game_system.bgs_stop
	potato = false
    # Play game over ME
	if $PokemonGlobal.hardcore == true
	 slot = SaveData::HARDCORE_SLOTS
	 save_data = SaveData.get_full_path(slot)
     SaveData.delete_this_save(save_data)
	end
	if chance!=0
     @sprite.bitmap = RPG::Cache.gameover($data_system.gameover_name)
     $game_system.me_play($data_system.gameover_me)
	 else 
	  potato = true
     @sprite.bitmap = RPG::Cache.gameover("GameOver.png")
     pbMEPlay("Game Over Meme")
	end
    # Execute transition
    Graphics.transition(120)
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
     Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      if $scene != self
        break
      end
    end
    Audio.me_fade(800) # added line
    # Prepare for transition
    Graphics.freeze
    # Dispose of game over graphic
    @sprite.bitmap.dispose
    @sprite.dispose
	if chance!=0
    @box.dispose
    @box2.dispose
	end
    # Execute transition
    Graphics.transition(20) # changed line (from 40 to 1)
    # Prepare for transition
    Graphics.freeze
    go_to_title # added line
    # If battle test
    if $BTEST
      $scene = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # If C button was pressed
    if Input.trigger?(Input::USE)
 # commented line
      $scene = nil # added line
    end
  end
end



#===============================================================================
#
#===============================================================================
class PokemonClose_Scene
  def pbStartScreen
    
    $mouse.show if $mouse && !$mouse.disposed? 
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    totalsec = $stats.play_time.to_i
    hour = totalsec / 60 / 60
    min = totalsec / 60 % 60
    mapname = "Exiting..."
    textColor = ["0070F8,78B8E8", "E82010,F8A8B8", "0070F8,78B8E8"][$player.gender]
    locationColor = "209808,90F090"   # green
    loctext = _INTL("<ac><c3={1}>{2}</c3></ac>", locationColor, mapname)
    loctext += _INTL("Player<r><c3={1}>{2}</c3><br>", textColor, $player.name)
	classy = $player.playerclass.name if $player.playerclass.respond_to?("name")
	classy = $player.playerclass if !$player.playerclass.respond_to?("name")
    loctext += _INTL("Class<r><c3={1}>{2} Lv{3}</c3><br>", textColor, classy, $player.playerclasslevel.to_i)
    @sprites["nubg"] = IconSprite.new(0,0,@viewport)
    @sprites["nubg"].setBitmap(_INTL("Graphics/Pictures/loadslotsbg"))
    @sprites["locwindow"] = Window_AdvancedTextPokemon.new(loctext)
    @sprites["locwindow"].viewport = @viewport
    @sprites["locwindow"].x = 0-BorderSettings::SCREENPOSX
    @sprites["locwindow"].y = 0-BorderSettings::SCREENPOSY
    @sprites["locwindow"].width = 228 if @sprites["locwindow"].width < 228
    @sprites["locwindow"].visible = true
  end
  


  def pbEndScreen
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

#===============================================================================
#
#===============================================================================
class PokemonCloseScreen
  def initialize(scene)
    @scene = scene
  end

  def pbDisplay(text, brief = false)
    @scene.pbDisplay(text, brief)
  end

  def pbDisplayPaused(text)
    @scene.pbDisplayPaused(text)
  end

  def pbConfirm(text)
    return @scene.pbConfirm(text)
  end

  def pbCloseScreen(menu=nil)
    ret = false
    @scene.pbStartScreen
    if pbConfirmMessage(_INTL("Are you sure you want to quit the game?"))
        pbFadeOutIn {
      pbSEPlay("GUI save choice")
	  pbWait(1)
      menu.pbEndScene if !menu.nil?
     @scene.pbEndScreen
	  pbWait(1)
	  $scene.dispose
        }
	$scene = pbCallTitle(false)
    while $scene != nil
      $scene.main
    end
    Graphics.transition(20)
	else
    @scene.pbEndScreen
    end
  end


end
