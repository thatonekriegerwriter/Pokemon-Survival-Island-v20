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
  p=Pokemon.new(NoteConfig::POKEMON,30,$player)
  title = pbFreeTextNoWindow("Title",false,256,Graphics.width,false)

  if title != "" && !title.nil?
      mailItem = :REPLYMAIL 
      msg = pbFreeTextNoWindow("Text",false,256,Graphics.width,false)
      if msg != "" && !msg.nil?
	     currMail = Mail.new(:REPLYMAIL, title, msg, "")
        p.mail = currMail
        p.item = :REPLYMAIL               #gives the mail defined before
        pbMoveToNotebook(p)              #sends the held item to the pc
        mailItem = nil                   #deletes the data to use again
      end

  end
end



def newCreatedNote(message=false,title,msg)
    pbMessage(_INTL("You pick up the Note: #{title}.")) if message = true
    p=Pokemon.new(NoteConfig::POKEMON,30,$player)
	currMail = Mail.new(:REPLYMAIL, title, msg, "")
    p.mail = currMail
    p.item = :REPLYMAIL                #gives the mail defined before
    pbMoveToNotebook(p)              #sends the held item to the pc
    pbFadeOutIn {
     pbDisplayMail(currMail)
    }
    mailItem = nil                   #deletes the data to use again
    pbMessage(_INTL("You stored Note: #{title} in your Notebook.")) if message = true
end

def pbDisplayMail(mail, _bearer = nil)
  sprites = {}
  viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  viewport.z = 99999
  addBackgroundPlane(sprites, "background", "mailbg", viewport)
  sprites["card"] = IconSprite.new(0, 0, viewport)
  sprites["card"].setBitmap(GameData::Item.mail_filename(mail.item))
  sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, viewport)
  overlay = sprites["overlay"].bitmap
  pbSetSystemFont(overlay)
  if GameData::Item.get(mail.item).is_icon_mail?
    if mail.poke1
      sprites["bearer"] = IconSprite.new(64, 288, viewport)
      bitmapFileName = GameData::Species.icon_filename(
        mail.poke1[0], mail.poke1[3], mail.poke1[1], mail.poke1[2], mail.poke1[4], mail.poke1[5]
      )
      sprites["bearer"].setBitmap(bitmapFileName)
      sprites["bearer"].src_rect.set(0, 0, 64, 64)
    end
    if mail.poke2
      sprites["bearer2"] = IconSprite.new(144, 288, viewport)
      bitmapFileName = GameData::Species.icon_filename(
        mail.poke2[0], mail.poke2[3], mail.poke2[1], mail.poke2[2], mail.poke2[4], mail.poke2[5]
      )
      sprites["bearer2"].setBitmap(bitmapFileName)
      sprites["bearer2"].src_rect.set(0, 0, 64, 64)
    end
    if mail.poke3
      sprites["bearer3"] = IconSprite.new(224, 288, viewport)
      bitmapFileName = GameData::Species.icon_filename(
        mail.poke3[0], mail.poke3[3], mail.poke3[1], mail.poke3[2], mail.poke3[4], mail.poke3[5]
      )
      sprites["bearer3"].setBitmap(bitmapFileName)
      sprites["bearer3"].src_rect.set(0, 0, 64, 64)
    end
  end
  baseForDarkBG    = Color.new(248, 248, 248)
  shadowForDarkBG  = Color.new(72, 80, 88)
  baseForLightBG   = Color.new(80, 80, 88)
  shadowForLightBG = Color.new(168, 168, 176)
  if mail.matter && mail.matter != ""
     if mail.date_created && mail.date_created != ""
    matter = "#{mail.matter} - #{mail.date_created}"
	  else
	   matter = mail.matter
	  end
    isDark = isDarkBackground(sprites["card"].bitmap, Rect.new(48, 48, Graphics.width - 96, 32 * 7))
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
  if mail.sender && mail.sender != ""
    isDark = isDarkBackground(sprites["card"].bitmap, Rect.new(336, 322, 144, 32 * 1))
    drawTextEx(overlay, 336, 328, 144, 1, mail.sender,
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