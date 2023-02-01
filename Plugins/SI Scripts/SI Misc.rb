def pbSizeCheck
pkmn = pbChoosePokemon
pbSet(1,pkmn.species)
height =  GameData::Species.get_species_form(pkmn.species, pkmn.form).height
if height > 0.2
return false
else
return true
end
end

def pbShadowPokemonCheck
return true if $stats.shadow_pokemon_purified > 4
end

###---NEW---###
def pbHasType?(type)
  for pokemon in $player.party
    next if pokemon.egg?
    return true if pokemon.type1==type || pokemon.type2==type
  end
  return false
end

def pbHasMove?(move)
  for pokemon in $player.party
    next if pokemon.egg?
    return true if pokemon.hasMove?(move)
  end
  return false
end

def pbCheckMoveType(type,va,wa)
  $player.pokemon_party.each do |pkmn|
    pkmn.moves.each do |m|
      if m.type == type
        $game_variables[va] = pkmn.name
        $game_variables[wa] = m.name
        return true
      end
    end
  end
  return false
end