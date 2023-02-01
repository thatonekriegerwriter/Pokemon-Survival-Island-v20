EventHandlers.add(:on_wild_battle_end, :dungeonbattle,
  proc { |species, level, decision|
  if $game_switches[485]==true
    pkmn = species 
	joinrnd = rand(100)
	firstPkmn = $player.first_pokemon
    if decision == 1
	if level > firstPkmn.level+5
	  chances = 10
    elsif level > firstPkmn.level+10
	  chances = 5
    elsif level > firstPkmn.level+20
	  chances = 1
	else 
	  chances = 15
    end 	
  if firstPkmn
    case firstPkmn.ability_id
    when :COMPOUNDEYES
      chances = chances+10
    when :SUPERLUCK
      chances = chances+25
    end
	if firstPkmn.item == :WONDERORB
      chances = chances+15
	end
	if firstPkmn.hasMove?(:FALSESWIPE)
      chances = chances+15
	end
  end
	if joinrnd<chances 
	if pbConfirmMessage(_INTL("Oh! {1} want's to join your Party! Do you want {1} to join your Party?",pkmn))
	  pbMessage(_INTL("{1} is overjoyed!",pkmn))
	  pbAddPokemonSilent(species,level)
	else
	  pbMessage(_INTL("{1} leaves crying.",pkmn))
	end

	end
  	elsif decision == 2
	  case $player.pokemon_party.length
	  when 2
	     pkmn = $player.pokemon_party[2]
	     stored_box = pbStorePokemon(pbPlayer,pkmn)
         box_name = pbBoxName(stored_box)
         pbMessage(_INTL("{1} has been sent to Box \"{2}\"!", pkmn.name, box_name))
		 $game_switches[488]=true
	  when 3
	     pkmn1 = $player.pokemon_party[2]
	     stored_box = pbStorePokemon(pbPlayer,pkmn)
         box_name = pbBoxName(stored_box)
	     pkmn2 = $player.pokemon_party[3]
	     stored_box = pbStorePokemon(pbPlayer,pkmn)
         box_name = pbBoxName(stored_box)
         pbMessage(_INTL("{1} & {3} have been sent to Box \"{2}\"!", pkmn1.name, box_name,pkmn2.name))
		 $game_switches[488]=true
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
		 $game_switches[488]=true
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
      pbDetransform
	  PokemonSelection.restore
	  $game_switches[485]=false
	  if $scene.is_a?(Scene_Map) &&  $game_map.name == "Temperate Caves"
      pbFadeOutIn(99999){
        $game_temp.player_transferring   = true
        $game_temp.transition_processing = true
         $game_temp.player_new_map_id=204  
         $game_temp.player_new_x=28
         $game_temp.player_new_y=17
         $game_temp.player_new_direction=2
         $scene.transfer_player
         $game_map.refresh
      }
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
  
  def pbDungeonXatuMart
    return if $game_switches[1200]==true
    item1=0
	item2=0
	item3=0
    itemscommon=[:ORANMASH,:ARGOSTBERRY,:LEPPABERRY,"RANDOMGEM",:ORANBERRY]
    itemsuncommon=[:KINGSROCK,:RAZORFANG,:ROCKYHELMET,:LIFEORB,:FOCUSBAND]
    itemsrare=[:PURESEED,:METRONOME,:WONDERORB,:QUICKCLAW,:RAZORCLAW]
	itemsgem=[:FIREGEM,:WATERGEM,:ELECTRICGEM,:GRASSGEM,:ICEGEM,:FIGHTINGGEM,:POISONGEM,
	:GROUNDGEM,:FLYINGGEM,:PSYCHICGEM,:BUGGEM,:ROCKGEM,:GHOSTGEM,:DRAGONGEM,:DARKGEM,:STEELGEM,
	:FAIRYGEM,:NORMALGEM,:LIGHTBALL]
	rnditems=[itemscommon,itemsuncommon,itemsrare]
	itemchoice1 = rnditems[rand(3)]
	itemchoice2 = rnditems[rand(3)]
	itemchoice3 = rnditems[rand(3)]
	if itemchoice1 == itemscommon
	 $game_variables[4] = 1
	end
	if itemchoice2 == itemscommon
	 $game_variables[5] = 1
	end
	if itemchoice3 == itemscommon
	 $game_variables[7] = 1
	end
	if itemchoice1 == itemsuncommon
	 $game_variables[4] = 2
	end
	if itemchoice2 == itemsuncommon
	 $game_variables[5] = 2
	end
	if itemchoice3 == itemsuncommon
	 $game_variables[7] = 2
	end
	if itemchoice1 == itemsrare
	 $game_variables[4] = 3
	end
	if itemchoice2 == itemsrare
	 $game_variables[5] = 3
	end
	if itemchoice3 == itemsrare
	 $game_variables[7] = 3
	end
    item1 = itemchoice1[rand(5)]
    item2 = itemchoice2[rand(5)]
    item3 = itemchoice3[rand(5)]
	if item1 == "RANDOMGEM"
    item1 = itemsgem[rand(19)]
    elsif item2 == "RANDOMGEM"
    item2 = itemsgem[rand(19)]
    elsif item3 == "RANDOMGEM"
    item3 = itemsgem[rand(19)]
	end
	$game_variables[1] = item1
	$game_variables[2] = item2
	$game_variables[3] = item3
	$game_variables[393] = "\\v[4] Stardust"
	$game_variables[394] = "\\v[5] Stardust"
	$game_variables[395] = "\\v[4] Stardust"
	$game_variables[4901] = GameData::Item.get(item1).name
	$game_variables[4902] = GameData::Item.get(item2).name
	$game_variables[4903] = GameData::Item.get(item3).name
	$game_switches[1200]=true
  end
  
  
  EventHandlers.add(:on_player_step_taken_can_transfer, :patch1,
  proc {
  
  if $game_switches[485]==true
  setBattleRule("setStyle")
  setBattleRule("canLose")
end

})