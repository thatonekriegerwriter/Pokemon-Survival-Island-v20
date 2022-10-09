EventHandlers.add(:on_wild_battle_end, :dungeonbattle,
  proc { |species, level, decision|
  if $game_switches[485]==true
    pkmn = species 
	joinrnd = rand(100)
	firstPkmn = $player.first_pokemon
    if decision == 1
	if level > firstPkmn.level+5
	  chances = 25
    elsif level > firstPkmn.level+10
	  chances = 10
    elsif level > firstPkmn.level+20
	  chances = 1
	else 
	  chances = 50
    end 	
  if firstPkmn
    case firstPkmn.ability_id
    when :COMPOUNDEYES
      chances = chances+10
    when :SUPERLUCK
      chances = chances+25
    end
  end
	if joinrnd<chances 
	if pbConfirmMessage(_INTL("Oh! {1} want's to join your Party! Do you want {1} to join your Party?",pkmn))
	  pbMessage(_INTL("{1} is overjoyed!",pkmn))
	  pbAddPokemonSilent(species,level)
	else
	  pbMessage(_INTL("{1} leaves crying.",pkmn))
	end
	elsif decision == 2
	  case $player.pokemon_party.length
	  when 2
	     pkmn = $player.pokemon_party[2]
	     stored_box = pbStorePokemon(pbPlayer,pkmn)
         box_name = pbBoxName(stored_box)
         pbMessage(_INTL("{1} has been sent to Box \"{2}\"!", pkmn.name, box_name))
	  when 3
	     pkmn1 = $player.pokemon_party[2]
	     stored_box = pbStorePokemon(pbPlayer,pkmn)
         box_name = pbBoxName(stored_box)
	     pkmn2 = $player.pokemon_party[3]
	     stored_box = pbStorePokemon(pbPlayer,pkmn)
         box_name = pbBoxName(stored_box)
         pbMessage(_INTL("{1} & {3} have been sent to Box \"{2}\"!", pkmn1.name, box_name,pkmn2.name))
	  when 4
	     pkmn1 = $player.pokemon_party[2]
	     stored_box = pbStorePokemon(pbPlayer,pkmn)
         box_name = pbBoxName(stored_box)
	     pkmn2 = $player.pokemon_party[3]
	     stored_box = pbStorePokemon(pbPlayer,pkmn)
         box_name = pbBoxName(stored_box)
	     pkmn3 = $player.pokemon_party[4]
	     stored_box = pbStorePokemon(pbPlayer,pkmn)
         box_name = pbBoxName(stored_box)
         pbMessage(_INTL("{1},{3} & {4} have been sent to Box \"{2}\"!", pkmn1.name, box_name,pkmn2.name,pkmn3.name))
	  when 5
	     pkmn1 = $player.pokemon_party[2]
	     stored_box = pbStorePokemon(pbPlayer,pkmn)
         box_name = pbBoxName(stored_box)
	     pkmn2 = $player.pokemon_party[3]
	     stored_box = pbStorePokemon(pbPlayer,pkmn)
         box_name = pbBoxName(stored_box)
	     pkmn3 = $player.pokemon_party[4]
	     stored_box = pbStorePokemon(pbPlayer,pkmn)
         box_name = pbBoxName(stored_box)
	     pkmn4 = $player.pokemon_party[5]
	     stored_box = pbStorePokemon(pbPlayer,pkmn)
         box_name = pbBoxName(stored_box)
         pbMessage(_INTL("{1},{3}, (4) & {5} have been sent to Box \"{2}\"!", pkmn1.name, box_name,pkmn2.name,pkmn3.name,pkmn4.name))
		 $game_switches[488]=true
	  end
	end
  end
  end
  }
)


  def pbStorePokemonPC(player, pkmn)
    oldCurBox = pbCurrentBox
    storedBox = $PokemonStorage.pbStoreCaught(pkmn)
    if storedBox < 0
      # NOTE: Poké Balls can't be used if storage is full, so you shouldn't ever
      #       see this message.
      pbDisplayPaused(_INTL("Can't catch any more..."))
      return oldCurBox
    end
    return storedBox
  end
  
  
  EventHandlers.add(:on_player_step_taken_can_transfer, :patch1,
  proc {
  
  if $game_switches[485]==true
  setBattleRule("setStyle")
  setBattleRule("canLose")
end

})