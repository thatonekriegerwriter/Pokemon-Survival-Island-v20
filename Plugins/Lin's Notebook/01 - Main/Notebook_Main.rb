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
  end
  
  def notebook
    @notebook=[] if @notebook.nil?
	return @notebook
  end
end

class Mail
  attr_accessor :item, :matter, :message, :sender, :poke1, :poke2, :poke3

  def initialize(item, matter, message, sender, poke1 = nil, poke2 = nil, poke3 = nil)
    @item    = GameData::Item.get(item).id   # Item represented by this mail
    @matter  = matter    # Matter of the letter
    @message = message   # Message text
    @sender  = sender    # Name of the message's sender
    @poke1   = poke1     # [species,gender,shininess,form,shadowness,is egg]
    @poke2   = poke2
    @poke3   = poke3
  end
end