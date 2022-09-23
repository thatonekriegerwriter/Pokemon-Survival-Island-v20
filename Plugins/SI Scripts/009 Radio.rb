#===============================================================================
# ** Scene_iPod
# ** Created by xLeD and Harshboy (Scene_Jukebox)
# ** Modified by Mutant Yoshi
#-------------------------------------------------------------------------------
#  This class performs menu screen processing.
#===============================================================================
module Radio
 def self.RadioCall()
  pbToneChangeAll(Tone.new(-255,-255,-255),8)
  pbWait(16)
  itemscene=Scene_Radio.new
#  itemscene.pbStartScene($PokemonCharacterSelect)
  itemscene.pbEndScene
 end
end




class Scene_Radio
  #-----------------------------------------------------------------------------
  # * Object Initialization
  #     menu_index : command cursor's initial position
  #-----------------------------------------------------------------------------
  def initialize(menu_index = 0)
    @menu_index = menu_index
  end
  #-----------------------------------------------------------------------------
  # * Main Processing
  #-----------------------------------------------------------------------------
  def main
    # Make song command window
    fadein = true
    # Makes the text window
    @sprites={}
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites["background"] = IconSprite.new(0,0)
    @sprites["background"].setBitmap("Graphics/Pictures/radiobg")
    @sprites["background"].z=255
    #@cursorbitmap=AnimatedBitmap.new(_INTL("Graphics/Pictures/radioNeedle"))
    @choices=[
       _INTL("0"),
       _INTL("1"),
       _INTL("2"),
       _INTL("3"),
       _INTL("4"),
       _INTL("5"),
       _INTL("6"),
       _INTL("7"),
       _INTL("8"),
       _INTL("9"),
       _INTL("10")
    ]
    @sprites["header"]=Window_UnformattedTextPokemon.newWithSize(_INTL("Radio"),
       2,-18,128,64,@viewport)
    @sprites["header"].baseColor=Color.new(248,248,248)
    @sprites["header"].shadowColor=Color.new(0,0,0)
    @sprites["header"].windowskin=nil
    @sprites["command_window"] = Window_CommandPokemon.new(@choices,324)
    @sprites["command_window"].windowskin=nil
    @sprites["command_window"].index = @menu_index
    @sprites["command_window"].height = 64#224
    @sprites["command_window"].width = 324
    @sprites["command_window"].x = 110
    @sprites["command_window"].y = 92
    @sprites["command_window"].z = 256
    @custom=false
    # Execute transition
    Graphics.transition
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
    # Prepares for transition
    Graphics.freeze
    # Disposes the windows
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
  #-----------------------------------------------------------------------------
  # * Frame Update
  #-----------------------------------------------------------------------------
  def update
    # Update windows
    pbUpdateSpriteHash(@sprites)
    if @custom
      updateCustom
    else
      update_command
    end
    return
  end
  #-----------------------------------------------------------------------------
  # * Frame Update (when command window is active)
  #-----------------------------------------------------------------------------
  def updateCustom
    if Input.trigger?(Input::B)
      @sprites["command_window"].commands=@choices
      @sprites["command_window"].index=3
      @custom=false
      return
    end
    if Input.trigger?(Input::C)
      $PokemonMap.whiteFluteUsed=false if $PokemonMap
      $PokemonMap.blackFluteUsed=false if $PokemonMap
      if @sprites["command_window"].index==0
        $game_system.setDefaultBGM(nil)
    $game_map.autoplay
      else
        $game_system.setDefaultBGM(
           @sprites["command_window"].commands[@sprites["command_window"].index]
        )        
      end
    end
  end

  def update_command
    # If B button was pressed
    if Input.trigger?(Input::B)
      pbPlayCancelSE()
      # Switch to map screen
      $scene = Scene_Pokegear.new
      return
    end
    # If C button was pressed
    #if Input.trigger?(Input::C)
      # Branch by command window cursor position
      case @sprites["command_window"].index
        when 1
          pbBGMPlay("Radio - March", 100, 100)
          $PokemonMap.whiteFluteUsed=true if $PokemonMap
          $PokemonMap.blackFluteUsed=false if $PokemonMap
          @sprites["header"]=Window_UnformattedTextPokemon.newWithSize(_INTL("Pokémon March"),20,104,228,64,@viewport)
        when 2
          pbBGMPlay("Radio - Lullaby", 100, 100)
          $PokemonMap.blackFluteUsed=true if $PokemonMap
          $PokemonMap.whiteFluteUsed=false if $PokemonMap
          @sprites["header"]=Window_UnformattedTextPokemon.newWithSize(_INTL("Pokémon Lullaby"),20,104,228,64,@viewport)
        when 3
          pbBGMPlay("Radio - Oak", 100, 100)
          $PokemonMap.whiteFluteUsed=false if $PokemonMap
          $PokemonMap.blackFluteUsed=false if $PokemonMap
          @sprites["header"]=Window_UnformattedTextPokemon.newWithSize(_INTL("Oak's Talkshow"),20,104,228,64,@viewport)
        when 4
          pbBGMPlay("VForestBroken", 100, 100)
          $PokemonMap.whiteFluteUsed=false if $PokemonMap
          $PokemonMap.blackFluteUsed=false if $PokemonMap
          @sprites["header"]=Window_UnformattedTextPokemon.newWithSize(_INTL("Buena's Password"),20,104,228,64,@viewport)
        else
          $game_map.autoplay
          $PokemonMap.whiteFluteUsed=false if $PokemonMap
          $PokemonMap.blackFluteUsed=false if $PokemonMap
          @sprites["header"]=Window_UnformattedTextPokemon.newWithSize(_INTL(""),20,104,228,64,@viewport)
      end
      return
    end
  end