#===============================================================================
# * Notebook Settings
#===============================================================================

module NoteConfig
  # The base number of notes that can be stored.
  NUM_NOTE_STORAGE = 999
  # The switch ID for extra storage. Set to 0 or keep the variable at 0 if you don't want to use this function.
  NOTE_STORAGE_VARIABLE = 0

  # The species of the pokemon used to create the note. It'll be erased after the note is created.
  POKEMON = :BULBASAUR

  # The message displayed when trying to create a note with the storage full.
  FULL_MESSAGE = _INTL("There's no space for the note. Please, increase the notebook capacity.")

  # A list of the id of the mails to be used for the notes
  NOTES_BACKGROUND = [
    :BRIDGETMAIL, :BRIDGEDMAIL, :BRIDGESMAIL, :BRIDGEVMAIL, :BRIDGEMMAIL, :FAVOREDMAIL, :THANKSMAIL,
    :INQUIRYMAIL, :GREETMAIL, :RSVPMAIL, :LIKEMAIL, :REPLYMAIL
  ]

  # Set to true if you want to use the new notebook scene. Set to false to use the default mail scene.
  NEW_SCENE = true

  # The path for the background to use for the notebook scene.
  # Note: If you use this with my pokegear theme's plugin, keep the path up to the pokegear folder.
  BACKGROUND = "notebookbg4"
  BACKGROUND_PATH = _INTL("Graphics/Pictures/")

  # The path for the background to use for the pokegear scene.
  # Note: If you are using my pokegear theme's plugin, keep the path up to the pokegear folder.
  POKEGEAR_BACKGROUND = "bg"
  POKEGEAR_BACKGROUND_PATH = _INTL("Graphics/Pictures/Pokegear/")

  # Set to true if you want the background to change with the pokegear themes
  THEME_CHANGE = false
end