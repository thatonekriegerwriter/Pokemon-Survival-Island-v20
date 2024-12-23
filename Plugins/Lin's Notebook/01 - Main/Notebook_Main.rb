#===============================================================================
# * Notebook - by LinKazamine (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It creates everything needed for the Notes.
#
#== INSTALLATION ===============================================================
#
# Drop the folder in your Plugin's folder.
#
#===============================================================================

class PokemonGlobalMetadata
  attr_accessor :notebook

  alias notebook_initialize initialize
  def initialize
    notebook_initialize
	
    @notebook              = []
	@notebook << generate_starter_notebook_mail if $DEBUG
  end
  
  
  def notebook
  if @notebook.nil?
    @notebook=[] 
	@notebook << generate_starter_notebook_mail if $DEBUG
	end
	return @notebook
  end
  def generate_starter_notebook_mail
  
  title = "First Entry"
  text = "I've awoken and it's been definitely been at least a day \nsince the crash.\n"
  text += "Looking back at sea, The ship is nowhere in sight.\n"
  text += "I don't know what happened, just that I'm the only one left.\n"
  text += "Now I just need to: \nSURVIVE."
	startermail = Mail.new(:REPLYMAIL, title, text, "")
	startermail.date_created = _INTL("{1} {2}, {3}",pbGetAbbrevMonthName(UnrealTime.initial_date.mon),UnrealTime.initial_date.day,UnrealTime.initial_date.year)
	return startermail
  end
end

class Mail
  attr_accessor :item, :matter, :message, :sender, :poke1, :poke2, :poke3, :date_created

  def initialize(item, matter, message, sender, poke1 = nil, poke2 = nil, poke3 = nil)
    @item    = GameData::Item.get(item).id   # Item represented by this mail
    @matter  = matter    # Matter of the letter
    @message = message   # Message text
    @sender  = sender    # Name of the message's sender
    @poke1   = poke1     # [species,gender,shininess,form,shadowness,is egg]
    @poke2   = poke2
    @poke3   = poke3
    @date_created   = _INTL("{1} {2}, {3}",pbGetAbbrevMonthName(pbGetTimeNow.mon),pbGetTimeNow.day,pbGetTimeNow.year)
  end
end