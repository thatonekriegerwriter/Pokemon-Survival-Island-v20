
ItemHandlers::UseInField.add(:LCLOAK,proc{|item|
  if !$game_variables[256]==(:LCLOAK)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:LCLOAK)
  else
  $game_variables[256]=(:LCLOAK) 
  end
    next 3
})

ItemHandlers::UseInField.add(:PROTECTIVEVEST,proc{|item|
  if !$game_variables[256]==(:PROTECTIVEVEST)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:PROTECTIVEVEST)
  else
  $game_variables[256]=(:PROTECTIVEVEST) 
  end
    next 3
})

ItemHandlers::UseInField.add(:SEASHOES,proc{|item|
  if !$game_variables[256]==(:SEASHOES)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:SEASHOES)
  else
  $game_variables[256]=(:SEASHOES) 
  end
    next 3
})

ItemHandlers::UseInField.add(:LJACKET,proc{|item|
  if !$game_variables[256]==(:LJACKET)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:LJACKET)
  else
  $game_variables[256]=(:LJACKET) 
  end
    next 3
})

ItemHandlers::UseInField.add(:SSHIRT,proc{|item|
  if !$game_variables[256]==(:SSHIRT)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:SSHIRT)
  else
  $game_variables[256]=(:SSHIRT) 
  end
    next 3
})

ItemHandlers::UseInField.add(:GHOSTMAIL,proc{|item|
  if !$game_variables[256]==(:GHOSTMAIL)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:GHOSTMAIL)
  else
  $game_variables[256]=(:GHOSTMAIL) 
  end
    next 3
})

ItemHandlers::UseInField.add(:IRONARMOR,proc{|item|
  if !$game_variables[256]==(:IRONARMOR)
    item = $game_variables[256]
	$PokemonBag.pbStoreItem(item,1)
	$game_variables[256]=(:IRONARMOR)
  else
  $game_variables[256]=(:IRONARMOR) 
  end
    next 3
})



ItemHandlers::UseInField.add(:PORTABLECAMP,proc{|item|
   if pbConfirmMessage(_INTL("Are you sure you want to use the Camp?"))
     pbFadeOutAndHide(@sprites)
     pbMessage(_INTL("You laid down in the portable camp, heading to sleep."))
     $Trainer.heal_party
     $game_variables[29] += 67200
     scene = PokemonSave_Scene.new
     screen = PokemonSaveScreen.new(scene)
     screen.pbSaveScreen
     $game_variables[247] = 2
     pbSleepRestore
   else
     $PokemonBag.pbStoreItem(PORTABLECAMP,1)
     pbMessage(_INTL("You decide against sleeping."))
   end
     next 3
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

ItemHandlers::UseInField.add(:MAP,proc { |item|
  pbShowMap(-1,false)
  next 1
})

ItemHandlers::UseInField.add(:PHONE,proc{|item|  
    pbFadeOutIn {
     PokemonPhoneScene.new.start
												
																			
    }
    next 1
})
 

ItemHandlers::UseInField.add(:PLAYER,proc{|item|  
      pbFadeOutIn {
        scene = PokemonJukebox_Scene.new
        screen = PokemonJukeboxScreen.new(scene)
        screen.pbStartScreen
      }
    next 1
})


ItemHandlers::UseOnPokemon.add(:SUSPO,proc { |item,pkmn,scene|
       if pkmn.permaFaint==true
         if pkmn.happiness <= 100
          pkmn.species = pkmn.species_data.get_baby_species
          pkmn.level          = Settings::EGG_LEVEL
          pkmn.calc_stats
          pkmn.name           = _INTL("Egg")
          pkmn.steps_to_hatch = pkmn.species_data.hatch_steps
          pkmn.hatched_map    = 0
          pkmn.obtain_method  = 1
          pkmn.food  = 100
          pkmn.water  = 100
          pkmn.sleep  = 1
		      pkmn.permaFaint = false
          next true
         else
         scene.pbDisplay(_INTL("It doesn't like you enough to reincarnate."))
         end
       else
         scene.pbDisplay(_INTL("It won't have any effect."))
         next false
         end
})

																  
																										  


ItemHandlers::UseOnPokemon.add(:APPLE,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,10,scene)
})


ItemHandlers::UseInBattle.add(:POISONDART,proc { |item,battler,battle|
   if battler && battler.status == :NONE || battler.type1 != STEEL || battler.type2 != STEEL
     battler.pbPoison(user) if target.pbCanPoison?(user,false,self)
     battle.pbDisplay(_INTL("You shoot a dart at the Pokemon, poisoning it."))
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
     battler.pbSleep
     battle.pbDisplay(_INTL("Enemy {1} was put to sleep by the {2}!",battler.name,itemname))
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:PARALYZDART,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:GROUND
  if battler.status != :NONE || battler.type1==type || battler.type2==type
     battle.pbDisplay(_INTL("It won't have any effect."))
     next false
  else
     battler.pbParalyze(battler)
     battle.pbDisplay(_INTL("Enemy {1} was paralyzed by the {2}!",battler.name,itemname))
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:ICEDART,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:ICE
  if battler.status != :NONE || battler.type1==type
     battle.pbDisplay(_INTL("It won't have any effect."))
     next false
  else
     battler.pbFreeze(battler)
     battle.pbDisplay(_INTL("Enemy {1} was frozen solid by the {2}!",battler.name,itemname))
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:FIREDART,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:FIRE
  if battler.status != :NONE || battler.type1==type
     battle.pbDisplay(_INTL("It won't have any effect."))
     next false
  else
     battler.pbBurn(battler)
     scene.pbDisplay(_INTL("Enemy {1} was burned by the {2}!",battler.name,itemname))
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:MACHETE,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:FIRE
  if battler
     battle.pbReduceHP(battler.totalhp/7)
	   scene.pbDisplay(_INTL("You slashed at Enemy {1} with the {2}!",battler.name,itemname))
     next false
  else
     battle.pbDisplay(_INTL("It won't have any effect."))
     next true
  end
  next true
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
  next true
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
  next true
})
#=begin
ItemHandlers::UseInBattle.add(:SNATCHER,proc { |item,battler,battle|
    return if battler.damageState.unaffected || battler.damageState.substitute
    return if battler.item==0
    return if battler.unlosableItem?(battler.item)
    return if battler.hasActiveAbility?(:STICKYHOLD) && !@battle.moldBreaker
    itemName = battler.itemName
    # Permanently steal the item from wild Pokémon
    if @battle.wildBattle? && battler.opposes?
      battler.initialItem==battler.item
      battler.pbRemoveItem
    else
      battler.pbRemoveItem(false)
    end
    battle.pbDisplay(_INTL("You stole {1}'s {2}!",battler.pbThis(true),itemName))
    $PokemonBag.pbStoreItem(:itemname,1)
})
ItemHandlers::BattleUseOnPokemon.add(:ARGOSTBERRY,proc { |item,pokemon,battler,choices,scene|
  pokemon.hp = 1
								   
  pokemon.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} recovered from fainting!",pokemon.name))
})




ItemHandlers::UseInBattle.add(:POISONDART,proc { |item,battler,battle|
   if battler && battler.status == :NONE || battler.type1 != STEEL || battler.type2 != STEEL
     battler.pbPoison(user) if target.pbCanPoison?(user,false,self)
     battle.pbDisplay(_INTL("You shoot a dart at the Pokemon, poisoning it."))
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
     battler.pbSleep
     battle.pbDisplay(_INTL("Enemy {1} was put to sleep by the {2}!",battler.name,itemname))
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:PARALYZDART,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:GROUND
  if battler.status != :NONE || battler.type1==type || battler.type2==type
     battle.pbDisplay(_INTL("It won't have any effect."))
     next false
  else
     battler.pbParalyze(battler)
     battle.pbDisplay(_INTL("Enemy {1} was paralyzed by the {2}!",battler.name,itemname))
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:ICEDART,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:ICE
  if battler.status != :NONE || battler.type1==type
     battle.pbDisplay(_INTL("It won't have any effect."))
     next false
  else
     battler.pbFreeze(battler)
     battle.pbDisplay(_INTL("Enemy {1} was frozen solid by the {2}!",battler.name,itemname))
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:FIREDART,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:FIRE
  if battler.status != :NONE || battler.type1==type
     battle.pbDisplay(_INTL("It won't have any effect."))
     next false
  else
     battler.pbBurn(battler)
     scene.pbDisplay(_INTL("Enemy {1} was burned by the {2}!",battler.name,itemname))
     next true
  end
  next true
})

ItemHandlers::UseInBattle.add(:MACHETE,proc { |item,battler,battle|
 itemname = GameData::Item.get(item).name
 type=:FIRE
  if battler
     battle.pbReduceHP(battler.totalhp/7)
	   scene.pbDisplay(_INTL("You slashed at Enemy {1} with the {2}!",battler.name,itemname))
     next false
  else
     battle.pbDisplay(_INTL("It won't have any effect."))
     next true
  end
  next true
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
  next true
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
  next true
})
#=begin
ItemHandlers::UseInBattle.add(:SNATCHER,proc { |item,battler,battle|
    return if battler.damageState.unaffected || battler.damageState.substitute
    return if battler.item==0
    return if battler.unlosableItem?(battler.item)
    return if battler.hasActiveAbility?(:STICKYHOLD) && !@battle.moldBreaker
    itemName = battler.itemName
    # Permanently steal the item from wild Pokémon
    if @battle.wildBattle? && battler.opposes?
      battler.initialItem==battler.item
      battler.pbRemoveItem
    else
      battler.pbRemoveItem(false)
    end
    battle.pbDisplay(_INTL("You stole {1}'s {2}!",battler.pbThis(true),itemName))
    $PokemonBag.pbStoreItem(:itemname,1)
})
