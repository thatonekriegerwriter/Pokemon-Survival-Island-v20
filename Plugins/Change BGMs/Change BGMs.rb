#------------------------------------------------------------------------------
#Change BGMs script by aiyinsi
#Version: 1.0
#For Essentials V19
#------------------------------------------------------------------------------
#####################################SCRIPT####################################
#------------------------------------------------------------------------------
#
#This script allows you to change the bgm that is played naturaly on maps.
#
#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
#################DO NOT TOUCH IF YOU DON'T KNOW WHAT YOU'RE DOING##############
#------------------------------------------------------------------------------

#This method resets the special bgm that is bound to the given key to the normally playing one.
#If the player is on a map that is affected by this the bgm changes.
def deactivateSpecialBGM(identifier)
  #the save array doesn't exist and terefore all BGMs are normal
  if !$PokemonGlobal.bgm_state_array
    return
  end
  
  #turn of the given switch
  $PokemonGlobal.bgm_state_array[identifier] = false
  
  #update the maps on their bgms
  if $MapFactory
    $MapFactory.update_bgms
  end
  
  #if a new bgm is set for the current map, switch to that one
  $game_map.play_current_bgm
end


#This method activates the special bgm that is bound to the given key.
#If the player is on a map that is affected by this the bgm changes.
def playSpecialBGM(identifier)
  #if this is the first time a special bgm is used set up the hash
  if !$PokemonGlobal.bgm_state_array
    $PokemonGlobal.setup_bgm_state_array
  end
  
  #turn on the given switch
  $PokemonGlobal.bgm_state_array[identifier] = true
  #update the maps on their bgms
  if $MapFactory
    $MapFactory.update_bgms
  end
  
  #if a new bgm is set for the current map, switch to that one
  $game_map.play_current_bgm
end

class PokemonGlobalMetadata
  
  attr_accessor :bgm_state_array    #saves which special bgms are played
  
  #initializes all the keys with false
  def setup_bgm_state_array
    @bgm_state_array = {}
    REPLACE_BGMS.each{ |entry|
      @bgm_state_array.store(entry[0], false)
    }
  end
end

class Game_Map

  #update the bgm to what it should be rn (I tinkered with load_data)
  def update_bgm
    temp = load_data(sprintf("Data/Map%03d.rxdata",map_id))
    @map.bgm = temp.bgm
  end
  
  #if the bgm playing rn is different than the maps bgm, switch to the maps bgm
  def play_current_bgm
    bgm = $game_system.playing_bgm
    if (!bgm || bgm.name != @map.bgm.name || bgm.name != @map.bgm.volume || bgm.name != @map.bgm.pitch)
      pbCueBGM(@map.bgm.name,1.0,@map.bgm.volume,@map.bgm.pitch)
    end
  end
end

class PokemonMapFactory
  #calls update_bgm for each map that is loaded to make sure map transition bgms work
  def update_bgms
    @maps.each{ |map| map.update_bgm}
  end
end


#yeah sorry for changing the method here :D you're getting what I want, not 
#what your gamefiles say
alias load_data_old_aiyinsi load_data
def load_data(file)
  ret = load_data_old_aiyinsi(file)
  if file.start_with?("Data/Map") && $PokemonGlobal && $PokemonGlobal.bgm_state_array && ret.respond_to?('bgm')
    map_id = file[8..file.length-1].to_i
    #iterate through REPLACE_BGMS and see if a switch is set to "On"
    REPLACE_BGMS.each{ |entry|
      if $PokemonGlobal.bgm_state_array[entry[0]]
        change_bgm = false
        #no map filter was given: always change bgm
        if !entry[2]
          change_bgm = true
        #a list of map IDs was given: check whether it contains the 
        elsif entry[2].kind_of?(Array)
          if entry[2].include?(map_id)
            change_bgm = true
          end
        #play on outdoor maps
        elsif entry[2] == "outdoor"
          if GameData::MapMetadata.get($game_map.map_id).outdoor_map
            change_bgm = true
          end
        #play on indoor maps
        elsif entry[2] == "indoor"
          if !GameData::MapMetadata.get($game_map.map_id).outdoor_map
            change_bgm = true
          end
        end
        #if the bgm should be changed:
        if change_bgm
          #name
          ret.bgm.name = entry[1]
          #volume
          if entry[3]
            ret.bgm.volume = entry[3]
          end
          #pitch
          if entry[4]
            ret.bgm.pitch = entry[4]
          end
          break
          #break out of looping through REPLACE_BGMS loop
        end
      end
    } #end of each loop
  end
  return ret
end
