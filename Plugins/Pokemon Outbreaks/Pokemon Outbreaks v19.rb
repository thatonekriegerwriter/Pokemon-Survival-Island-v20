#===============================================================================
# Pokémon Outbreaks - By Vendily [v19] - v3
#===============================================================================
# This script adds in the Mass outbreak of pokemon that appear on a random map.
# It uses the Gen 4 version of the mechanics, so when the save is loaded, if
#  there is no active outbreak and the switch is active, will pick one outbreak
#  at random and spawn them at a 40% encounter rate. Feel free to change that of
#  course.
#===============================================================================
# This script includes some utility functions, such as the ability to 
#  randomly set a new outbreak at will with pbGenerateOutbreak, and get the
#  location and species of an outbreak, pbOutbreakInformation (which can save in 
#  two variables,  for species and map in that order). The variables contain
#  strings for names, or -1 if there is no outbreak. It will also return the map
#  id and species index for your scripting uses.
#===============================================================================
# * The length of time that an encounter will last in hours. (Default 24)
# * The percent chance an outbroken pokemon will spawn in place of
#    a regular one. (Default 40)
# * The switch used to enable outbreaks. (Default 100)
# * A set of arrays each containing details of a wild encounter that can only
#      occur via Pokemon Outbreaks. The information within is as follows:
#      - Map ID on which this encounter can occur.
#      - Species.
#      - Minimum possible level.
#      - Maximum possible level.
#      - Allowed encounter types.
#===============================================================================
PluginManager.register({
  :name    => "Pokémon Outbreaks",
  :version => "3.0",
  :link    => "https://reliccastle.com/resources/266/",
  :credits => "Vendily"
})
 
OUTBREAK_TIME    = 24
OUTBREAK_CHANCE  = 40
OUTBREAK_SWITCH  = 100
OUTBREAK_SPECIES = [
    [5,:DODUO,2,2,[:Land]],
    [5,:VOLTORB,28,29,[:Land,:LandNight]],
    [2,:MILOTIC,12,16,[:Water]]
    ]
class PokemonGlobalMetadata
  attr_accessor :currentOutbreak
end
 
EncounterModifier.register(proc {|encounter|
   next encounter if !encounter
   next encounter if !$game_switches[OUTBREAK_SWITCH]
   if !$PokemonGlobal.currentOutbreak ||
       $PokemonGlobal.currentOutbreak[0]<=-1 ||
       ((pbGetTimeNow-$PokemonGlobal.currentOutbreak[1])>OUTBREAK_TIME*60*60)
     $PokemonGlobal.currentOutbreak=[-1,nil]
   end
   if $PokemonGlobal.currentOutbreak[0]>-1
     newenc=OUTBREAK_SPECIES[$PokemonGlobal.currentOutbreak[0]]
     next encounter if $game_map && $game_map.map_id!=newenc[0]
     next encouter if !newenc[4].include?($PokemonEncounters.encounter_type)
     if rand(100)<OUTBREAK_CHANCE
       level=rand(newenc[3]-newenc[2])+newenc[2]
       next [newenc[1],level]
     end
   end
   next encounter
})
 
Events.onMapUpdate+=proc {|sender,e|
  next if !$game_switches[OUTBREAK_SWITCH]
  if !$PokemonGlobal.currentOutbreak ||
     $PokemonGlobal.currentOutbreak[0]<=-1 ||
     ((pbGetTimeNow-$PokemonGlobal.currentOutbreak[1])>OUTBREAK_TIME*60*60)
     pbGenerateOutbreak
  end
}
 
def pbGenerateOutbreak
  index=rand(OUTBREAK_SPECIES.length)
  $PokemonGlobal.currentOutbreak=[index,pbGetTimeNow]
end
 
def pbOutbreakInformation(speciesvar,mapvar)
  if !$PokemonGlobal.currentOutbreak ||
    $PokemonGlobal.currentOutbreak[0]<=-1 ||
    ((pbGetTimeNow-$PokemonGlobal.currentOutbreak[1])>OUTBREAK_TIME*60*60)
      $PokemonGlobal.currentOutbreak=[-1,nil]
      $game_variables[speciesvar]=-1 if speciesvar>0
      $game_variables[mapvar]=-1 if mapvar>0
      return [-1,-1]
  end
  newenc=OUTBREAK_SPECIES[$PokemonGlobal.currentOutbreak[0]]
  species=newenc[1]
  $game_variables[speciesvar]=GameData::Species.get(species).name if speciesvar>0
  $game_variables[mapvar]=pbGetMessage(MessageTypes::MapNames,newenc[0]) if mapvar>0
  return [newenc[0],species]
end