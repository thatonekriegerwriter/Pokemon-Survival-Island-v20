#===============================================================================
# * Notebook Notes - by LinKazamine (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. The code for creating and storing notes.
#
#== INSTALLATION ===============================================================
#
# Drop the folder in your Plugin's folder.
#
#===============================================================================

#===============================================================================
# Create a Note
#===============================================================================
def writeNote
  title = pbFreeTextNoWindow("Title",false,256,Graphics.width,64, false)

  if title != "" && !title.nil?
      mailItem = :REPLYMAIL 
      msg = pbFreeTextNoWindow("Text",false,256,Graphics.width,64, false)
      if msg != "" && !msg.nil?
	    currMail = Mail.new(:REPLYMAIL, title, msg, "")
        pbMoveToNotebook(currMail)              #sends the held item to the pc
      end

  end
end



def newCreatedNote(message=false,title,msg)
    pbMessage(_INTL("You pick up the Note: #{title}.")) if message = true
	currMail = Mail.new(:REPLYMAIL, title, msg, "")
    pbMoveToNoteStorage(currMail)              #sends the held item to the pc
    pbFadeOutIn {
     pbDisplayNote(currMail)
    }
    pbMessage(_INTL("You stored Note: #{title} in your Notebook.")) if message = true
end

def pbDisplayNote(mail, _bearer = nil)
  sprites = {}
  viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  viewport.z = 99999
  addBackgroundPlane(sprites, "background", "mailbg", viewport)
  sprites["card"] = IconSprite.new(0, 0, viewport)
  sprites["card"].setBitmap(GameData::Item.mail_filename(mail.item))
  sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, viewport)
  overlay = sprites["overlay"].bitmap
  pbSetSystemFont(overlay)
  baseForDarkBG    = Color.new(248, 248, 248)
  shadowForDarkBG  = Color.new(72, 80, 88)
  baseForLightBG   = Color.new(80, 80, 88)
  shadowForLightBG = Color.new(168, 168, 176)
  if mail.matter && mail.matter != ""
	   matter = mail.matter
    isDark = isDarkBackground(sprites["card"].bitmap, Rect.new(48, 48, Graphics.width - 96, 32 * 7))
	puts matter 
    drawTextEx(overlay, 48, 5, Graphics.width - 94, 7, matter,
               (isDark) ? baseForDarkBG : baseForLightBG,
               (isDark) ? shadowForDarkBG : shadowForLightBG)
  
  
  
  end
  if mail.message && mail.message != ""
    isDark = isDarkBackground(sprites["card"].bitmap, Rect.new(48, 48, Graphics.width - 96, 32 * 7))
    drawTextEx(overlay, 48, 52, Graphics.width - 94, 7, mail.message,
               (isDark) ? baseForDarkBG : baseForLightBG,
               (isDark) ? shadowForDarkBG : shadowForLightBG)
  end
  pbFadeInAndShow(sprites)
  loop do
    Graphics.update
    Input.update
    pbUpdateSpriteHash(sprites)
    if Input.trigger?(Input::BACK) || Input.trigger?(Input::USE)
      break
    end
  end
  pbFadeOutAndHide(sprites)
  pbDisposeSpriteHash(sprites)
  viewport.dispose
end