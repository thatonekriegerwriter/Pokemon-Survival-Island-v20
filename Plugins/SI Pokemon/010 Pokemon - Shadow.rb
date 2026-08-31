def pbPurify(pkmn, scene)
  return if !pkmn.shadowPokemon? || pkmn.heart_gauge != 0
  $stats.shadow_pokemon_purified += 1
  pkmn.shadow = false
  pkmn.hyper_mode = false
  pkmn.giveRibbon(:NATIONAL)
  GameData::Stat.each_main do |s|
    pkmn.raw_shadow_bonus[s.id]       = 0
  end
  pkmn.update_level_cap_for_shadow
  scene.pbDisplay(_INTL("{1} opened the door to its heart!", pkmn.name))
  old_moves = []
  pkmn.moves.each { |m| old_moves.push(m.id) }
  pkmn.update_shadow_moves
  pkmn.moves.each_with_index do |m, i|
    next if m.id == old_moves[i]
    scene.pbDisplay(_INTL("{1} regained the move {2}!", pkmn.name, m.name))
  end
  pkmn.record_first_moves
  if pkmn.saved_ev
    pkmn.add_evs(pkmn.saved_ev)
    pkmn.saved_ev = nil
  end
  pbDoLevelUps(pkmn)
  
	 if nuzlocke_has?(:NICKNAMES)
      nickname = ""
	    loop do
      nickname = pbEnterPokemonName(_INTL("{1}'s nickname?", pkmn.speciesName),
                                    0, Pokemon::MAX_NAME_SIZE, "", pkmn.speciesName, true)
	    break if nickname.length>2
	    end
      pkmn.name = nickname
      @nicknamed = true
    elsif $PokemonSystem.givenicknames == 0 &&
     scene.pbConfirm(_INTL("Would you like to give a nickname to {1}?", pkmn.speciesName))
    newname = pbEnterPokemonName(_INTL("{1}'s nickname?", pkmn.speciesName),
                                 0, Pokemon::MAX_NAME_SIZE, "", pkmn)
    pkmn.name = newname
  end
end
