#===============================================================================
#  Utilities for Manolo's Scripts (MS) version 1.1.0
#    by realAfonso
# ----------------
#  Various utilities used within my plugins. 
#===============================================================================

#-------------------------------------------------------------------------------
#  Multiple FriendCare Class
#-------------------------------------------------------------------------------
class MultipleFriendCare
  attr_accessor :pokemon
  attr_accessor :level
  attr_accessor :friend
  attr_accessor :slot

  def initialize
    @pokemon      = nil
    @level        = 0
    @friend       = nil
    @unity        = nil
  end
  
  def pokemon=(pokemon)
    @pokemon = pokemon
  end
  
  def level=(level)
    @level = level
  end
  
  def friend=(friend)
    @friend = friend
  end
  
  def slot=(slot)
    @slot = slot
  end
end

#-------------------------------------------------------------------------------
#  Print a message on screen
#-------------------------------------------------------------------------------
def muEcho(text="")
  Kernel.pbMessage(_INTL("{1}",text))
end

#-------------------------------------------------------------------------------
#  Print a variable on screen
#-------------------------------------------------------------------------------

def muEchoVar(variable,text="")
  Kernel.pbMessage(_INTL("{1}{2}",text,variable))
end

#-------------------------------------------------------------------------------
#  pbChooseNonEggPokemon variation 
#  that filters the result by type
#-------------------------------------------------------------------------------
def muChoosePokemonType(variableNumber,nameVarNumber,type,name_var=0,specie_var=0,type_var=0)
  muChoosePokemon(variableNumber,nameVarNumber,proc {|poke|
     !poke.egg? && poke.hasType?(type)
  },false,name_var,specie_var,type_var)
end

#-------------------------------------------------------------------------------
#  pbChoosePokemon variation 
#  save type and specie in a variable 
#-------------------------------------------------------------------------------
def muChoosePokemon(variableNumber,nameVarNumber,ableProc=nil,allowIneligible=false,name_var=0,specie_var=0,type_var=0)
  chosen = 0
  pbFadeOutIn(99999){
    scene = PokemonParty_Scene.new
    screen = PokemonPartyScreen.new(scene,$Trainer.party)
    if ableProc
      chosen=screen.pbChooseAblePokemon(ableProc,allowIneligible)      
    else
      screen.pbStartScene(_INTL("Choose a Pokémon."),false)
      chosen = screen.pbChoosePokemon
      screen.pbEndScene
    end
  }
  pbSet(variableNumber,chosen)
  if chosen>=0
    pbSet(nameVarNumber,$Trainer.party[chosen].name)
    pbSet(name_var,$Trainer.party[chosen].name) if name_var > 0
    pbSet(specie_var,$Trainer.party[chosen].speciesName) if specie_var > 0
    pbSet(type_var,$Trainer.party[chosen].type1) if type_var > 0
  else
    pbSet(nameVarNumber,"")
  end
end

#-------------------------------------------------------------------------------
#  Return true if specie in a variable is same of the text 
#-------------------------------------------------------------------------------
def muSelectedSpecies(variable,specie)
  if $game_variables[variable] == specie
    return true
  else
    return false
  end
end