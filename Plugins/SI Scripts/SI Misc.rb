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