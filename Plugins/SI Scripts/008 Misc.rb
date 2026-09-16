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



class FixedSizeArray

  def initialize(size)
    @array = []
	@array_size = size || 5
  end

  def add(element)
    @array.push(element)
    @array.shift if @array.size > @array_size
  end
  def remove(element)
    @array.delete(element)
  end
  def clear
    @array = []
  end
  def to_a
    @array
  end
  def empty?
    return @array.empty?
  end
  def length
    return @array.length
  end
  
  
  
  def how_many?(object,length)
    last_part = @array.last(length)
    count = last_part.count(object)
	return count
  end

  def next_position
    return @array.size
  end
end


class ElectricityPower
end 


SaveData.register(:electricity) do
  ensure_class :ElectricityPower 
  save_value { $ElectricityPower  }
  load_value { |value| $ElectricityPower = value }
  new_game_value {
    ElectricityPower.new
  }
end
