#===============================================================================
# Pokémon Outbreaks - By Vendily [v20] - v4
#===============================================================================
# This script adds in the Mass Outbreak of Pokémon that appear on a random map.
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
# * The percent chance an outbroken Pokémon will spawn in place of
#    a regular one. (Default 40)
# * The switch used to enable outbreaks, -1 to not use a switch. (Default 100)
# * A set of arrays each containing details of a wild encounter that can only
#      occur via Pokémon Outbreaks. The information within is as follows:
#      - Map ID on which this encounter can occur.
#      - Species.
#      - Minimum possible level.
#      - Maximum possible level.
#      - Allowed encounter types (GameData::EncounterType#type).
#===============================================================================
PluginManager.register({
  :name    => "Pokémon Outbreaks",
  :version => "4.0",
  :link    => "https://reliccastle.com/resources/266/",
  :credits => "Vendily"
})
module Settings
  OUTBREAK_TIME    = 24
  OUTBREAK_CHANCE  = 40
end
class PokemonGlobalMetadata
  attr_accessor :currentOutbreak
  attr_accessor :outbreakflag
  attr_accessor :outbreakSteps
end
 
EventHandlers.add(:on_wild_species_chosen,:outbreak_change_mon,
  proc {|encounter|
    next if !encounter
    next if $game_temp.poke_radar_data &&
             encounter[0] == $game_temp.poke_radar_data[0] &&
             encounter[1] == $game_temp.poke_radar_data[1]
			 
			 
			 
			 
			 
     $PokemonGlobal.outbreakflag=false if $PokemonGlobal.outbreakflag.nil?
			 
    if !$PokemonGlobal.currentOutbreak || ((pbGetTimeNow-$PokemonGlobal.currentOutbreak[1]).to_i>Settings::OUTBREAK_TIME*60*60)
      $PokemonGlobal.currentOutbreak=[[0,-1],-1,nil]
    end
	
	   mapid = $game_map&.map_id   
      next if $game_map&.map_id != $PokemonGlobal.currentOutbreak[2]
	  

      if rand(100)<Settings::OUTBREAK_CHANCE
        encounter[0] = $PokemonGlobal.currentOutbreak[0][0]
        encounter[1] = $PokemonGlobal.currentOutbreak[0][1]
      end
	  
	  
	  
  }
)
 
EventHandlers.add(:on_step_taken,:outbreak_update,
  proc {
  $PokemonGlobal.outbreakSteps=0 if !$PokemonGlobal.outbreakSteps
  if $PokemonGlobal.outbreakSteps==4056+rand(200)


    if !$PokemonGlobal.currentOutbreak || $PokemonGlobal.currentOutbreak[0][1].to_i<=-1 ||((pbGetTimeNow-$PokemonGlobal.currentOutbreak[1]).to_i>Settings::OUTBREAK_TIME*60*60)
	  if ((pbGetTimeNow-$PokemonGlobal.currentOutbreak[1]).to_i>((Settings::OUTBREAK_TIME*60*60)*1.25).to_i)
      $PokemonGlobal.currentOutbreak=[[0,-1],-1,nil]
       $PokemonGlobal.outbreakSteps=0
	  else
       pbGenerateOutbreak
       $PokemonGlobal.outbreakSteps=0
	   end
    end
  end
  }
)
EventHandlers.add(:on_step_taken,:outbreak_steps,
  proc {
  $PokemonGlobal.outbreakSteps=0 if !$PokemonGlobal.outbreakSteps
  $PokemonGlobal.outbreakSteps+=1

  }
)
 
def pbGenerateOutbreak
$PokemonGlobal.outbreakflag=false if $PokemonGlobal.outbreakflag.nil?
  
	 mapid = $game_map&.map_id 
	 outdoor = $game_map.metadata&.outdoor_map
	 if mapid && outdoor
	 encounter_type = $PokemonEncounters.encounter_type_on_outbreak(mapid)
	 if !encounter_type.nil?
    encounter = $PokemonEncounters.choose_wild_pokemon(encounter_type)
 

  $PokemonGlobal.currentOutbreak=[encounter,pbGetTimeNow,mapid]
  $PokemonGlobal.outbreakflag=true
   end
  end
end
 
def pbOutbreakInformation(speciesvar=-1,mapvar=-1)
  if !$PokemonGlobal.currentOutbreak ||$PokemonGlobal.currentOutbreak[0][1].to_i<=-1 ||((pbGetTimeNow-$PokemonGlobal.currentOutbreak[2])>Settings::OUTBREAK_TIME*60*60)
      $PokemonGlobal.currentOutbreak=[[0,-1],0,nil]
      return [-1,-1]
  end
  newenc=$PokemonGlobal.currentOutbreak[0]
  species=newenc[0]
  return [species,newenc[2]]
end

def get_outbreak
$PokemonGlobal.outbreakflag=false if $PokemonGlobal.outbreakflag.nil?
return $PokemonGlobal.outbreakflag==true

end


def announce_outbreak



pbMessage("\\ts[]" + (_INTL"An outbreak has broken out in #{$map_factory.getMap($PokemonGlobal.currentOutbreak[2])}!\\wtnp[15]"))




$PokemonGlobal.outbreakflag=false
end