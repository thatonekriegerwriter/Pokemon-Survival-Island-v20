#===============================================================================
# * Notebook Screen - by LinKazamine (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It creates an notebook scene for the notes.
#
#== INSTALLATION ===============================================================
#
# Drop the folder in your Plugin's folder.
#
#===============================================================================

class NotebookShowScene
  def pbStartScene
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites["background"] = IconSprite.new(0, 0, @viewport)
    image_path = NoteConfig::BACKGROUND_PATH + NoteConfig::BACKGROUND
    @sprites["background"].setBitmap(image_path)
    @sprites["background"].x = (Graphics.width - @sprites["background"].bitmap.width)/2
    @sprites["background"].y = (Graphics.height - @sprites["background"].bitmap.height)/2
    @sprites["title"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["title"].bitmap)
    title = @sprites["title"].bitmap
    title.clear
    base_color   = Color.new(248, 248, 248)
    shadow_color = Color.new(0, 0, 0)
    pbDrawTextPositions(title,
      [[_INTL("Index"), 170, 10, 0, base_color, shadow_color, true]])
    @sprites["cancelwindow"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["cancelwindow"].bitmap)
    cancelWindow = @sprites["cancelwindow"].bitmap
    cancelWindow.clear
    cancelText = _INTL("Cancel: close")
    pbDrawTextPositions(title,
      [[cancelText, 350, 10, 0, base_color, shadow_color, true]])
    commands = []
    @sprites["cmdwindow"] = Window_CommandPokemon.new([])
    @sprites["cmdwindow"].visible = false
    @sprites["cmdwindow"].viewport = @viewport
    pbFadeInAndShow(@sprites) { update }
  end

  def pbMain
    ret = -1
    commands = []
    $PokemonGlobal.notebook.each do |mail|
      commands.push(mail.matter)
    end
    cmdwindow = @sprites["cmdwindow"]
    cmdwindow.commands = commands
    cmdwindow.index    = $game_temp.menu_last_choice
    cmdwindow.width    = 320
    cmdwindow.height   = 254
    cmdwindow.x        = 162
    cmdwindow.y        = 30
    cmdwindow.visible  = true
    cmdwindow.back_opacity  = 0
    loop do
      Graphics.update
      Input.update
      self.update
      if Input.trigger?(Input::BACK) || Input.trigger?(Input::ACTION)
        ret = -1
        break     
      elsif Input.trigger?(Input::USE)
        ret = cmdwindow.index
        $game_temp.menu_last_choice = ret
        break
      end
    end
    return ret
  end

  def update
    pbUpdateSpriteHash(@sprites)
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { update }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class NotebookShowScreen
  def initialize(scene)
    @scene=scene
  end

  def pbStartScreen
    @scene.pbStartScene
    loop do
      if !$PokemonGlobal.notebook || $PokemonGlobal.notebook.length == 0
        pbMessage(_INTL("There's no notes here."))
        break
      else
        choice = @scene.pbMain
        if choice >= 0 && choice < $PokemonGlobal.notebook.length
          mailIndex = choice
          commandMail = pbMessage(
            _INTL("What do you want to do with note {1}?", $PokemonGlobal.notebook[mailIndex].matter),
            [_INTL("Read"),
             _INTL("Delete"),
             _INTL("Cancel")], -1
          )
          case commandMail
          when 0   # Read
            pbFadeOutIn {
              pbDisplayMail($PokemonGlobal.notebook[mailIndex])
            }
          when 1   # Delete
            if pbConfirmMessage(_INTL("The note will be lost. Is that OK?"))
              pbMessage(_INTL("The note was deleted."))
              $PokemonGlobal.notebook.delete_at(mailIndex)
            end
          end
        else
          break
        end
      end
    end
    @scene.pbEndScene
  end
end

def pbNewNotebookScreen
  pbFadeOutIn(99999) {
    scene = NotebookShowScene.new
    screen = NotebookShowScreen.new(scene)
    screen.pbStartScreen
  }
end