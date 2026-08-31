OUTBREAK_TIME    = 24                   #

def pbPetCheck
  if pbGetTimeNow.to_i-$PokemonGlobal.petTime>=24*60*60
   return true
  else 
   return false
  end
end

def pbGroomCheck
  if pbGetTimeNow.to_i-$PokemonGlobal.groomTime>=24*60*60
   return true
  else 
   return false
  end

end

