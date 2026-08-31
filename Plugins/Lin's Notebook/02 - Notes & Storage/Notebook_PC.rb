#===============================================================================
# * Notebook PC - by LinKazamine (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It creates a storage for the notes.
#
#== INSTALLATION ===============================================================
#
# Drop the folder in your Plugin's folder.
#
#===============================================================================

#===============================================================================
# Move mail to Notebook PC
#===============================================================================
def pbMoveToNotebook(mail)
  $PokemonGlobal.notebook = [] if !$PokemonGlobal.notebook
  return false if !mail
  $PokemonGlobal.notebook.push(mail)
  return true
end
def pbMoveToNoteStorage(mail)
  $PokemonGlobal.notestorage = [] if !$PokemonGlobal.notestorage
  return false if !mail
  $PokemonGlobal.notestorage.push(mail)
  return true
end

#===============================================================================
# * Notebook PC
#===============================================================================
def pbPCNotebook
  if !$PokemonGlobal.notebook || $PokemonGlobal.notebook.length == 0
    pbMessage(_INTL("There's no notes here."))
  else
    loop do
      command = 0
      commands = []
      $PokemonGlobal.notebook.each do |mail|
        commands.push(mail.matter)
      end
      commands.push(_INTL("Cancel"))
      command = pbShowCommands(nil, commands, -1, command)
      if command >= 0 && command < $PokemonGlobal.notebook.length
        mailIndex = command
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
end