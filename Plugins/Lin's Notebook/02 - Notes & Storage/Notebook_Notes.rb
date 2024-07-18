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