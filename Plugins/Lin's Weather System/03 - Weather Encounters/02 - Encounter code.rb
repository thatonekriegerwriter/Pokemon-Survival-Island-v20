#===============================================================================
# * Weather System - Water, Land and Cave encounters code
#===============================================================================

class PokemonEncounters
  # Checks the defined encounters for the current map and returns the encounter
  # type that the given weather should produce. Only returns an encounter type if
  # it has been defined for the current map.
  def find_valid_encounter_type_for_weather(base_type, new_type)
    ret = nil
    try_type = nil
    weather = $game_screen.weather_type if $game_screen.weather_type != :None
    try_type = (new_type.to_s + weather.to_s).to_sym
    if try_type && !has_encounter_type?(try_type)
      try_type = (base_type.to_s + weather.to_s).to_sym
    end
    ret = try_type if try_type && has_encounter_type?(try_type)
    return ret if ret
    return (has_encounter_type?(base_type)) ? base_type : nil
  end

  # Checks the defined encounters for the current map and returns the encounter
  # type that the given time should produce. Only returns an encounter type if
  # it has been defined for the current map.
end

#===============================================================================

def pbRockSmashRandomEncounter
  enctype = $PokemonEncounters.find_valid_encounter_type_for_weather(:RockSmash, :RockSmash)
  if $PokemonEncounters.encounter_triggered?(enctype, false, false)
    $stats.rock_smash_battles += 1
    pbEncounter(enctype)
  end
end
