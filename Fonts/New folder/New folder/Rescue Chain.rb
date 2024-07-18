#===============================================================================
# Rescue Chain - By Vendily [v17]
# This script makes it so that if you chain pokemon of the same evolutionary
#  family together, an evolved form of the species will appear.
# I used no references and I completly misinterpreted a description of SOS
#  battles as this thing.
# * Minimum length of chain before evolved forms begin to appear. With every 
#    multiple, the chance for the evolved form or a second evolved form to appear
#    increases. (Default 10)
# * Chance that the evolved form will even show up, 1 out of this constant.
#    (Default 4, for 1/4 chance, it's probably too high)
# * Random number added to the minimum level this pokemon can evolve at or
#    the wild pokemon's current level if it evolves through item (Default 5)
# * Disable this modifier while the pokeradar is being used.
#    I recommend leaving it as is as the pokeradar may behave strangely and the
#    two scripts may reset each others' chain. (Default true)
# * The maps where this effect can only take place in.
# * The maps where this effect will never happen. Ever.
# * The switch to disable this effect. (Default -1)
#===============================================================================
EVOCHAINLENGTH      = 10
EVORANDCHANCE       = 4
EVOLEVELWOBBLE      = 5
EVOPKRADERDISABLE   = true
EVOMAPSWHITELIST    = []
EVOMAPSBLACKLIST    = []
EVODISABLESWITCH    = -1
class PokemonTemp
  attr_accessor :rescuechain # [chain length, evo family]
end

Events.onStartBattle+=proc {|sender,e|
   next if EVOMAPSBLACKLIST.include?($game_map.map_id)
   next if EVOMAPSWHITELIST.length>0 && !EVOMAPSWHITELIST.include?($game_map.map_id)
   next if EVODISABLESWITCH>0 && $game_switches[EVODISABLESWITCH]
   next if EVOPKRADERDISABLE && !$PokemonTemp.pokeradar.nil?
   next if !$PokemonGlobal.roamEncounter.nil?
   pokemon=e[0]
   next if pokemon.nil?
   if !$PokemonTemp.rescuechain
     $PokemonTemp.rescuechain=[0,nil]
   end
   family=pbGetBabySpecies(pokemon.fSpecies)
   if family != $PokemonTemp.rescuechain[1]
     $PokemonTemp.rescuechain=[0,family]
   end
   if $PokemonTemp.rescuechain[0]>=EVOCHAINLENGTH
     for i in 0..($PokemonTemp.rescuechain[0]/EVOCHAINLENGTH).floor()
       evodata=pbGetEvolvedFormData(pokemon.fSpecies)
       if evodata.length>0 && rand(EVORANDCHANCE)==0
         fspecies=evodata[rand(evodata.length)][2]
         newspecies,newform=pbGetSpeciesFromFSpecies(fspecies)
         level=pbGetMinimumLevel(fspecies)
         level=[level,pokemon.level].max
         level+=rand(EVOLEVELWOBBLE)
         pokemon.species=newspecies
         pokemon.form=newform
         pokemon.level=level
         pokemon.name=PBSpecies.getName(newspecies)
         pokemon.calcStats
         pokemon.resetMoves
       end
     end
   end
}

Events.onWildBattleEnd+=proc {|sender,e|
   next if EVOMAPSBLACKLIST.include?($game_map.map_id)
   next if EVOMAPSWHITELIST.length>0 && !EVOMAPSWHITELIST.include?($game_map.map_id)
   next if EVODISABLESWITCH>0 && $game_switches[EVODISABLESWITCH]
   next if EVOPKRADERDISABLE && !$PokemonTemp.pokeradar.nil?
   next if !$PokemonTemp.rescuechain
   species=e[0]
   result=e[2]
   family=pbGetBabySpecies(species)
   if (result==1 || result == 4) && family==$PokemonTemp.rescuechain[1]
     $PokemonTemp.rescuechain[0]+=1
   end
  
}