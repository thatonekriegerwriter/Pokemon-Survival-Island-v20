def pbHasCrate?
 return true if $bag.has?(:PORTABLEPC)
 return true if $bag.has?(:ITEMCRATE)
end

def pbHasGrinder?
 return true if $bag.has?(:GRINDER)
 return true if $bag.has?(:ELECTRICGRINDER)
end

def pbHasApricorn?
 return true if $bag.has?(:APRICORNCRAFTING)
 return true if $bag.has?(:APRICORNMACHINE)
end

def pbHasFurnace?
 return true if $bag.has?(:FURNACE)
 return true if $bag.has?(:ELECTRICFURNACE)
end

def pbHasCrafting?
 return true if $bag.has?(:CRAFTINGBENCH)
 return true if $bag.has?(:UPGRADEDCRAFTINGBENCH)
end

ItemHandlers::UseOnPokemon.add(:GRITDUST,proc { |item,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_ATTACK)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Attack increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})



ItemHandlers::UseInField.add(:LCLOAK,proc{|item|
  if !$game_variables[256]==(:LCLOAK)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:LCLOAK)
  else
  $game_variables[256]=(:LCLOAK) 
  end
    next 2
})

ItemHandlers::UseInField.add(:PROTECTIVEVEST,proc{|item|
  if !$game_variables[256]==(:PROTECTIVEVEST)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:PROTECTIVEVEST)
  else
  $game_variables[256]=(:PROTECTIVEVEST) 
  end
    next 2
})

ItemHandlers::UseInField.add(:SEASHOES,proc{|item|
  if !$game_variables[256]==(:SEASHOES)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:SEASHOES)
  else
  $game_variables[256]=(:SEASHOES) 
  end
    next 2
})

ItemHandlers::UseInField.add(:LJACKET,proc{|item|
  if !$game_variables[256]==(:LJACKET)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:LJACKET)
  else
  $game_variables[256]=(:LJACKET) 
  end
    next 2
})

ItemHandlers::UseInField.add(:SSHIRT,proc{|item|
  if !$game_variables[256]==(:SSHIRT)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:SSHIRT)
  else
  $game_variables[256]=(:SSHIRT) 
  end
    next 2
})

ItemHandlers::UseInField.add(:GHOSTMAIL,proc{|item|
  if !$game_variables[256]==(:GHOSTMAIL)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:GHOSTMAIL)
  else
  $game_variables[256]=(:GHOSTMAIL) 
  end
    next 2
})

ItemHandlers::UseInField.add(:IRONARMOR,proc{|item|
  if !$game_variables[256]==(:IRONARMOR)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:IRONARMOR)
  else
  $game_variables[256]=(:IRONARMOR) 
  end
    next 2
})



ItemHandlers::UseInField.add(:PORTABLECAMP,proc{|item|
   if pbConfirmMessage(_INTL("Are you sure you want to use the Camp?"))
  pbFadeOutIn {  
    next 2
     pbMessage(_INTL("You laid down in the Portable Camp, heading to sleep."))
     $game_variables[29] += 67200
     pbSleepRestore(10)}
				if $player.playersleep >= 100
			        pbMessage(_INTL("You feel well rested!"))
				elsif $player.playersleep >= 75
			        pbMessage(_INTL("You feel a little groggy, but are raring to go!"))
				elsif $player.playersleep >= 50
			        pbMessage(_INTL("Your brain feels fuzzy."))
				elsif $player.playersleep >= 25
			        pbMessage(_INTL("You want to go back to bed."))
				else
			        pbMessage(_INTL("You really need to sleep."))
				end 
   next true
   else
     pbMessage(_INTL("You decide against sleeping."))
	 next false
   end
     next false
})

ItemHandlers::UseInField.add(:BERRYBLENDER,proc{|item|
  pbCommonEvent(29)
    next 1
})

ItemHandlers::UseFromBag.add(:LVLDETECTOR,proc{|item|
        if $game_switches[240]==false
         $game_switches[240]=true
        elsif $game_switches[240]==true
         $game_switches[240]=false
        end
    next 1
})


ItemHandlers::UseOnPokemon.add(:APPLE,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,10,scene)
})

ItemHandlers::UseInBattle.add(:POISONDART,proc { |item,battler,battle|
   if battler && battler.status == :NONE || !battler.pbHasType?(:STEEL)
     battle.pbDisplay(_INTL("You shoot a dart at the Pokemon, poisoning it."))
     battler.pbPoison(user) if target.pbCanPoison?(user,false,self)
     next true
   else
    battle.pbDisplay(_INTL("It won't have any effect."))
     next false
   end
   next true
})

ItemHandlers::UseInBattle.add(:SLEEPDART,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 ability1=GameData::Ability.try_get(:INSOMNIA)
 ability2=GameData::Ability.try_get(:VITALSPIRIT)
  if battler.status != :NONE || battler.ability==ability1 || battler.ability==ability2
     next false
  else
     battle.pbDisplay(_INTL("Enemy {1} was put to sleep by the {2}!",battler.name,itemname))
     battler.pbSleep
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:PARALYZDART,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:GROUND
  if battler.status != :NONE || battler.pbHasType?(:GROUND)
     battle.pbDisplay(_INTL("It won't have any effect."))
     next false
  else
     battle.pbDisplay(_INTL("Enemy {1} was paralyzed by the {2}!",battler.name,itemname))
     battler.pbParalyze(battler)
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:ICEDART,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:ICE
  if battler.status != :NONE  || battler.pbHasType?(:ICE)
     battle.pbDisplay(_INTL("It won't have any effect."))
     next false
  else
     battle.pbDisplay(_INTL("Enemy {1} was frozen solid by the {2}!",battler.name,itemname))
     battler.pbFreeze(battler)
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:FIREDART,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:FIRE
  if battler.status != :NONE || battler.pbHasType?(:FIRE)
     battle.pbDisplay(_INTL("It won't have any effect."))
     next false
  else
     scene.pbDisplay(_INTL("Enemy {1} was burned by the {2}!",battler.name,itemname))
     battler.pbBurn(battler)
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:MACHETE,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
  if battler
       battle.pbReduceHP($player.playerstamina)
	   scene.pbDisplay(_INTL("You slashed at Enemy {1} with the {2}!",battler.name,itemname))
	   next false
  else
     battle.pbDisplay(_INTL("It won't have any effect."))
     next false
  end
})

ItemHandlers::UseInBattle.add(:RUSTEDPICKAXE,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:GROUND
 typeb=PBTypes::ROCK
  if battler.type1==type || battler.type2==typeb 
     battler.pbReduceHP(battler.totalhp/3)
	   battle.pbDisplay(_INTL("You axed at Enemy {1} with the {2}!",battler.name,itemname))
     next false
  else
     battle.pbDisplay(_INTL("It won't have any effect."))
     next true
  end
})

ItemHandlers::UseInBattle.add(:PICKAXE,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:GROUND
 typeb=PBTypes::ROCK
  if battler.type1==type || battler.type2==typeb 
     battler.pbReduceHP(battler.totalhp/5)
	   battle.pbDisplay(_INTL("You axed at Enemy {1} with the {2}!",battler.name,itemname))
     next false
  else
     battle.pbDisplay(_INTL("It won't have any effect."))
     next true
  end
})



ItemHandlers::UseInField.add(:PORTABLEPC,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if $game_switches[414] == true
    Kernel.pbMessage(_INTL("You already have an Item Crate placed, these take the same spot.",item))
    next 0
  else
   if maps.include?($game_map.map_id)
    Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
    $game_switches[406] = true
     next 3
  else
    Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
  end
})

ItemHandlers::UseInField.add(:BEDROLL,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[407] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:GRINDER,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[404] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:UPGRADEDCRAFTINGBENCH,proc { |item|
  maps = [10,20,40,97,41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[402] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})
ItemHandlers::UseInField.add(:MEDICINEPOT,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[405] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:FURNACE,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[403] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:CAULDRON,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[147] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:CRAFTINGBENCH,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[150] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:APRICORNCRAFTING,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[144] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})
ItemHandlers::UseInField.add(:CUTTER,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_variables[290] += 1
  $game_switches[411] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:ITEMCRATE,proc { |item|
  maps = [10,20,40,97]   # Map IDs for Origin Forme
  if $game_switches[406] == true
    Kernel.pbMessage(_INTL("You already have an Pokemon Crate placed, these take the same spot.",item))
    next 0
  else
   if maps.include?($game_map.map_id)
    Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
    $game_switches[414] = true
     next 3
  else
    Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
  end
})

ItemHandlers::UseInField.add(:SEWINGMACHINE,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_variables[290] += 1
  $game_switches[411] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:ELECTRICPRESS,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_variables[290] += 1
  $game_switches[412] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})
ItemHandlers::UseInField.add(:APRICORNMACHINE,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_variables[290] += 1
  $game_switches[415] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:ELECTRICFURNACE,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_variables[290] += 1
  $game_switches[416] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:ELECTRICGRINDER,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_variables[290] += 1
  $game_switches[417] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:COALGENERATOR,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[409] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:SOLARGENERATOR,proc { |item|
  maps = [54]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[418] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:HYDROGENERATOR,proc { |item|
  maps = [54]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[419] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:WINDGENERATOR,proc { |item|
  maps = [54]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[420] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})

ItemHandlers::UseInField.add(:POKEGENERATOR,proc { |item|
  maps = [41]   # Map IDs for Origin Forme
  if maps.include?($game_map.map_id)
  Kernel.pbMessage(_INTL("Do you want to place your {1}?",item))
  $game_switches[421] = true
  next 3
  else
  Kernel.pbMessage(_INTL("This cannot be placed here."))
  next 0
  end
})






ItemHandlers::UseFromBag.add(:WATERBOTTLE,proc { |item|
if $game_player.pbFacingTerrainTag.can_surf
     message=(_INTL("Want to pick up water?"))
    if pbConfirmMessage(message)
       $PokemonBag.pbStoreItem(:WATER,1)
	end
	$bag.remove(:WATERBOTTLE,1)
	next 4
   else
    Kernel.pbMessage(_INTL("That is not water."))
	next 0
end
})

ItemHandlers::UseFromBag.add(:GLASSBOTTLE,proc { |item|
if $game_player.pbFacingTerrainTag.can_surf
     message=(_INTL("Want to pick up water?"))
    if pbConfirmMessage(message)
       $PokemonBag.pbStoreItem(:WATER,1)
	end
	$bag.remove(:GLASSBOTTLE,1)
	next 4
   else
    Kernel.pbMessage(_INTL("That is not water."))
	next 0
end
})

ItemHandlers::UseFromBag.add(:IRONAXE,proc { |item|
if $game_player.pbFacingTerrainTag.can_knockdown
     message=(_INTL("Want to knock down some branches?"))
    if pbConfirmMessage(message)
       $PokemonBag.pbStoreItem(:ACORN,(rand(6)))
	end
	next 2
   else
    Kernel.pbMessage(_INTL("That is not a tree."))
	next 0
end
})