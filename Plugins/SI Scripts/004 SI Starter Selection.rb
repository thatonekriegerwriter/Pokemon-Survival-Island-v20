###---NEW---###
def pbHasType?(type)
  for pokemon in $player.party
    next if pokemon.egg?
    return true if pokemon.type1==type || pokemon.type2==type
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


def pbSetGameVariables(variable,wariable)
  $game_variables[variable] = $game_variables[wariable]
end

###---END NEW---###
