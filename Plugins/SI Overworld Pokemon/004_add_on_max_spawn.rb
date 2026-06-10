
          #########################################################
          #                                                       #
          #          ADD-ON:  MAX SPAWN by TrankerGolD            #
          #                                                       #
          #########################################################

# You can use this add-on to set a maximal number of wild Encounters Events
# that can be spawned on the map at the same time.
# Use the parameter MAX_SPAWN (see below) to set the limit of overworld pokeEvents at the same time.

# FEATURES:
# * Stop more PokeEvent from spawning with the MAX_SPAWN parameter



#===============================================================================
# new methods to count pkmn spawned 
#===============================================================================
#Count all spawned events
def pbCountPokeEvent
  currentCountPokeEvent = 0
  if $MapFactory
    for map in $MapFactory.maps
      for event in map.events.values
        if event.is_a?(Game_PokeEvent)
          currentCountPokeEvent = currentCountPokeEvent + 1
        end
      end
    end
  else
    for event in $game_map.events.values
      if event.is_a?(Game_PokeEvent)
        currentCountPokeEvent = currentCountPokeEvent + 1
      end
    end
  end
  return currentCountPokeEvent
end
  
#Count spawned events in current map
def pbCountPokeEventInMap
  currentCountPokeEvent = 0
  $game_map.events.values.each { |event|
    if event.is_a?(Game_PokeEvent)
      currentCountPokeEvent = currentCountPokeEvent + 1
    end
  }
  #puts "Pokemon amount in Map: #{currentCountPokeEvent}/#{(PBDayNight.isNight? ? VisibleEncounterSettings::MAX_SPAWN : VisibleEncounterSettings::MAX_SPAWN_DAY)}"
  return currentCountPokeEvent
end
  
