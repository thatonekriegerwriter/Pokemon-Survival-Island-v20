
class PokemonGlobalMetadata
  attr_accessor :foreignEncounter
  attr_accessor :foreignPokemon
  attr_writer   :foreignPokemonCaught

  def foreignPokemonCaught
    return @foreignPokemonCaught || []
  end
end

#===============================================================================
# Encountering a foreign Pokémon in a wild battle.
#===============================================================================
class Game_Temp
  attr_accessor :foreign_index_for_encounter   # Index of foreign Pokémon to encounter next
end

EventHandlers.add(:on_wild_species_chosen, :foreign_pokemon,
  proc { |encounter|
    $game_temp.foreign_index_for_encounter = nil
    $PokemonGlobal.foreignPokemon = [] if !$PokemonGlobal.foreignPokemon
    next if !encounter
    # Give the regular encounter if encountering a foreign Pokémon isn't possible
    next if $PokemonGlobal.partner
    next if $game_temp.poke_radar_data
    # Look at each foreign Pokémon in turn and decide whether it's possible to encounter it
    currentRegion = pbGetCurrentRegion
    currentMapName = $game_map.name
    possible_foreign = []
    Settings::FOREIGN_SPECIES.each_with_index do |data, i|
      # data = [module, Game Switch, maps, encounter method, battle BGM, encounter chance]
      pokedata = ForeignPokemon.const_get(data[0])
      next if !GameData::Species.exists?(pokedata[:species])
      next if data[1] > 0 && !$game_switches[data[1]]   # Isn't active
      next if $PokemonGlobal.foreignPokemon[i] == true   # Foreign Pokémon has been caught
      # Get possible maps
      foreignMaps = data[2]
      if foreignMaps.include?($game_map.map_id)
        match = true
      else
      # If foreign mon isn't on the current map, check if it's on a map with the same
      # name and in the same region
          for i in 0...foreignMaps.length
          testMap = foreignMaps[i]
          map_metadata = GameData::MapMetadata.try_get(testMap)
            if map_metadata && map_metadata.town_map_position &&
                map_metadata.town_map_position[0] == currentRegion &&
                pbGetMapNameFromId(testMap) == currentMapName
                  match = true
            end
          end
      end
      next if !match
      # Check whether the encounter method is currently possible
      next if !pbRoamingMethodAllowed(data[3])
      next if !(rand(100) < data[5])
      # Add this foreign Pokémon to the list of possible foreign Pokémon to encounter
      possible_foreign.push([i, data[4]])   # [i, BGM]
    end
    # No encounterable foreign Pokémon were found, just have the regular encounter
    next if possible_foreign.length == 0
    # Pick a foreign Pokémon to encounter out of those available
    foreign = possible_foreign.sample
    $PokemonGlobal.foreignEncounter = foreign
    $game_temp.foreign_index_for_encounter = foreign[0]
    $PokemonGlobal.nextBattleBGM = foreign[1] if foreign[1] && !foreign[1].empty?
    $game_temp.force_single_battle = true
  }
)

EventHandlers.add(:on_calling_wild_battle, :foreign_pokemon,
  proc { |species, level, handled|
    # handled is an array: [nil]. If [true] or [false], the battle has already
    # been overridden (the boolean is its outcome), so don't do anything that
    # would override it again
    next if !handled[0].nil?
    next if !$PokemonGlobal.foreignEncounter || $game_temp.foreign_index_for_encounter.nil?
    handled[0] = pbForeignPokemonBattle
  }
)

def pbForeignPokemonBattle
  # Get the foreign Pokémon to encounter; generate it based on the species and
  # level if it doesn't already exist
  idxForeign = $game_temp.foreign_index_for_encounter
  if !$PokemonGlobal.foreignPokemon[idxForeign] ||
     !$PokemonGlobal.foreignPokemon[idxForeign].is_a?(Pokemon)
      pokedata = Settings::FOREIGN_SPECIES[idxForeign][0]
      pokedata = ForeignPokemon.const_get(pokedata)
      newpoke = pbGenerateWildPokemon(pokedata[:species],pokedata[:level])
      newpoke.shiny = pokedata[:shiny] if pokedata[:shiny]
      newpoke.name = pokedata[:name] if pokedata[:name]
      newpoke.gender = pokedata[:gender] if pokedata[:gender]
      newpoke.item = pokedata[:item] if pokedata[:item]
      newpoke.nature = pokedata[:nature] if pokedata[:nature]
      newpoke.form = pokedata[:form] if pokedata[:form]
      newpoke.happiness = pokedata[:happiness] if pokedata[:happiness]
      newpoke.sheen = pokedata[:sheen] if pokedata[:sheen]
      newpoke.cool = pokedata[:cool] if pokedata[:cool]
      newpoke.beauty = pokedata[:beauty] if pokedata[:beauty]
      newpoke.cute = pokedata[:cute] if pokedata[:cute]
      newpoke.smart = pokedata[:smart] if pokedata[:smart]
      newpoke.tough = pokedata[:tough] if pokedata[:tough]
      if pokedata[:ribbons]
        for i in 0...pokedata[:ribbons].length
          newpoke.giveRibbon(pokedata[:ribbons][i])
        end
      end
      if pokedata[:pokerus]
        if pokedata[:pokerus].is_a?(Integer)
          newpoke.givePokerus(pokedata[:pokerus])
        else
          newpoke.givePokerus
        end
      end
      newpoke.ability = pokedata[:ability] if pokedata[:ability]
      newpoke.ability_index = pokedata[:ability_index] if pokedata[:ability_index]
      if pokedata[:moves]
        moves = []
        for i in 0...pokedata[:moves].length
            moves.push(Pokemon::Move.new(pokedata[:moves][i]))
        end
        newpoke.moves = moves
      end
      if pokedata[:newmoves]
        for i in 0...pokedata[:newmoves].length
            newpoke.learn_move(pokedata[:newmoves][i])
        end
      end
      newpoke.ev = pokedata[:ev] if pokedata[:ev]
      newpoke.iv = pokedata[:iv] if pokedata[:iv]
      if pokedata[:perf_ivs]
        stats = []
        GameData::Stat.each_main { |s| stats.push(s.id)}
        stats = stats.sample(pokedata[:perf_ivs])
        stats.each do |s|
          newpoke.iv[s] = Pokemon::IV_STAT_LIMIT
        end
      end
      newpoke.memory = pokedata[:memory] if pokedata[:memory]
      if pokedata[:ot]
        trainerdata = ForeignOTs.const_get(pokedata[:ot])
        newpoke.owner.name = trainerdata[:name] if trainerdata[:name]
        newpoke.owner.gender = trainerdata[:gender] if trainerdata[:gender]
        if trainerdata[:id_number]
          id = trainerdata[:id_number]
          newpoke.owner.id = id | (id << 16) 
        else
          newpoke.owner.id = $player.make_foreign_ID
        end
        newpoke.owner.language = trainerdata[:language] if trainerdata[:language]
      end
      $PokemonGlobal.foreignPokemon[idxForeign] = newpoke
  end
  if $PokemonGlobal.foreignPokemon[idxForeign].is_a?(Pokemon)
    $PokemonGlobal.foreignPokemon[idxForeign].heal if $PokemonGlobal.foreignPokemon[idxForeign].fainted?
  end
  # Set some battle rules
  setBattleRule("single")
  # Perform the battle
  decision = WildBattle.start_core($PokemonGlobal.foreignPokemon[idxForeign])
  species = $PokemonGlobal.foreignPokemon[idxForeign].species
  level = $PokemonGlobal.foreignPokemon[idxForeign].level
  # Update Foreign Pokémon data based on result of battle
  if decision == 4   # Caught
    $PokemonGlobal.foreignPokemon[idxForeign]       = true
    $PokemonGlobal.foreignPokemonCaught[idxForeign] = (decision == 4)
  end
  $PokemonGlobal.foreignEncounter = nil
  $game_temp.foreign_index_for_encounter = nil
  # Used by the Poké Radar to update/break the chain
  EventHandlers.trigger(:on_wild_battle_end, species, level, decision)
  # Return false if the player lost or drew the battle, and true if any other result
  return (decision != 2 && decision != 5)
end