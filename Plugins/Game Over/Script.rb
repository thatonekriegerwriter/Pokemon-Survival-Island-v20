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
    pbLoadRpgxpScene(Scene_Gameover.new)
    return
  _old_FL_pbStartOver(gameover)
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
    @sprite = Sprite.new
	chance = rand(1000)
	if chance!=0
	@box2 = Window_AdvancedTextPokemon.new("<ac>You have perished.")
	@box = Window_AdvancedTextPokemon.new("<ac>The darkness of the afterlife is all that awaits you now. May you find more peace in that world than you found in this one.")
    @box.x = (Graphics.width/2)-255
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
	 slot = SaveData::MANUAL_SLOTS[0]
	 save_data = SaveData.get_full_path(slot)
     SaveData.delete_this_save(save_data)
	end
	if chance==0
     @sprite.bitmap = RPG::Cache.gameover($data_system.gameover_name)
     $game_system.me_play($data_system.gameover_me)
	 else 
	  potato = true
     @sprite.bitmap = RPG::Cache.gameover("GameOver.png")
	 if rand(100)==0
     pbMEPlay("Game Over Meme")
	 else
     pbMEPlay("Game Over")
	 end
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
    if Input.trigger?(Input::C)
 # commented line
      $scene = nil; # added line
    end
  end
end