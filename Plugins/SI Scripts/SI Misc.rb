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

def pbHasMoveType(type)
  $player.pokemon_party.each do |pkmn|
    pkmn.moves.each do |m|
      if m.type == type && m.pp > 0
        return true
      end
    end
  end
  return false
end

def pbCheckMoveType(type)
  $player.pokemon_party.each do |pkmn|
    pkmn.moves.each do |m|
      if m.type == type && m.pp > 0
        return m,pkmn
      end
    end
  end
  return nil
end

def pbCheckMoveTypeforWatering(type)
  $player.pokemon_party.each do |pkmn|
    pkmn.moves.each do |m|
      if m.type == type && m.pp > 1
        return m,pkmn
      end
    end
  end
  return nil
end

def pbThisHasType?(pokemon,type)
  return false if pokemon.egg?
  return true if pokemon.type1==type || pokemon.type2==type
  return false
end

def waterPlantWithMove
move,pkmn = pbCheckMoveType(:WATER)
if !move.nil?
wateramt = move.base_damage
pbMessage(_INTL("#{pkmn.name} watered the plant for you with #{move.name}!"))
move.pp = move.pp-2
return wateramt
else
return nil
end
end