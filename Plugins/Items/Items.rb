
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

ItemHandlers::UseInField.add(:FOODBAG,proc{|item|
  pbCommonEvent(27)
    next 1
})

ItemHandlers::UseInField.add(:MEDICINE,proc{|item|
  pbCommonEvent(28)
    next 1
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

																  
																										  

ItemHandlers::UseOnPokemon.add(:POTION,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,pkmn.totalhp/4,scene)
})

ItemHandlers::UseOnPokemon.add(:BERRYJUICE,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,20,scene)
})

ItemHandlers::UseOnPokemon.copy(:BERRYJUICE,:SWEETHEART)
ItemHandlers::UseOnPokemon.copy(:BERRYJUICE,:RAGECANDYBAR) if !Settings::RAGE_CANDY_BAR_CURES_STATUS_PROBLEMS

ItemHandlers::UseOnPokemon.add(:APPLE,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,10,scene)
})

ItemHandlers::UseOnPokemon.add(:SUPERPOTION,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,pkmn.totalhp/3,scene)
})

ItemHandlers::UseOnPokemon.add(:HYPERPOTION,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,pkmn.totalhp/2,scene)
})

ItemHandlers::UseOnPokemon.add(:MAXPOTION,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,pkmn.totalhp-pkmn.hp,scene)
})

ItemHandlers::UseOnPokemon.add(:FRESHWATER,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,50,scene)
})

ItemHandlers::UseOnPokemon.add(:SODAPOP,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,60,scene)
})

ItemHandlers::UseOnPokemon.add(:LEMONADE,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,80,scene)
})

ItemHandlers::UseOnPokemon.add(:MOOMOOMILK,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,100,scene)
})

ItemHandlers::UseOnPokemon.add(:ORANBERRY,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,10,scene)
})

ItemHandlers::UseOnPokemon.add(:SITRUSBERRY,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,pkmn.totalhp/4,scene)
})

ItemHandlers::UseOnPokemon.add(:AWAKENING,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status != :SLEEP
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} woke up.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:AWAKENING,:CHESTOBERRY,:BLUEFLUTE,:POKEFLUTE)

ItemHandlers::UseOnPokemon.add(:ANTIDOTE,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status != :POISON
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} was cured of its poisoning.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:ANTIDOTE,:PECHABERRY)

ItemHandlers::UseOnPokemon.add(:BURNHEAL,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status != :BURN
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s burn was healed.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:BURNHEAL,:RAWSTBERRY)

ItemHandlers::UseOnPokemon.add(:PARALYZEHEAL,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status != :PARALYSIS
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} was cured of paralysis.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:PARALYZEHEAL,:PARLYZHEAL,:CHERIBERRY)

ItemHandlers::UseOnPokemon.add(:ICEHEAL,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status != :FROZEN
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} was thawed out.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:ICEHEAL,:ASPEARBERRY)

ItemHandlers::UseOnPokemon.add(:FULLHEAL,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status == :NONE
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} became healthy.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:FULLHEAL,
   :LAVACOOKIE,:OLDGATEAU,:CASTELIACONE,:LUMIOSEGALETTE,:SHALOURSABLE,
   :BIGMALASADA,:LUMBERRY)
ItemHandlers::UseOnPokemon.copy(:FULLHEAL,:RAGECANDYBAR) if Settings::RAGE_CANDY_BAR_CURES_STATUS_PROBLEMS

ItemHandlers::UseOnPokemon.add(:FULLRESTORE,proc { |item,pkmn,scene|
  if pkmn.fainted? || (pkmn.hp==pkmn.totalhp && pkmn.status == :NONE)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  hpgain = pbItemRestoreHP(pkmn,pkmn.totalhp-pkmn.hp)
  pkmn.heal_status
  scene.pbRefresh
  if hpgain>0
    scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.",pkmn.name,hpgain))
  else
    scene.pbDisplay(_INTL("{1} became healthy.",pkmn.name))
  end
  next true
})

ItemHandlers::UseOnPokemon.add(:REVIVE,proc { |item,pkmn,scene|
  if !pkmn.fainted?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.hp = (pkmn.totalhp/2).floor
  pkmn.hp = 1 if pkmn.hp<=0
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:MAXREVIVE,proc { |item,pkmn,scene|
  if !pkmn.fainted?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_HP
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored.",pkmn.name))
  next true
})

													  

ItemHandlers::UseOnPokemon.add(:ENERGYPOWDER,proc { |item,pkmn,scene|
  if pbHPItem(pkmn,60,scene)
    pkmn.changeHappiness("powder",pkmn)
    pkmn.changeLoyalty("powder",pkmn)
    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:ENERGYROOT,proc { |item,pkmn,scene|
  if pbHPItem(pkmn,200,scene)
    pkmn.changeHappiness("energyroot",pkmn)
    pkmn.changeLoyalty("energyroot",pkmn)
    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:HEALPOWDER,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status == :NONE
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_status
  pkmn.changeHappiness("powder",pkmn)
  pkmn.changeLoyalty("powder",pkmn)
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} became healthy.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:REVIVALHERB,proc { |item,pkmn,scene|
  if !pkmn.fainted?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.heal_HP
  pkmn.heal_status
  pkmn.changeHappiness("revivalherb",pkmn)
  pkmn.changeLoyalty("revivalherb",pkmn)
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored.",pkmn.name))
  next true
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

ItemHandlers::BattleUseOnPokemon.add(:POTION,proc { |item,pokemon,battler,choices,scene|
  pbBattleHPItem(pokemon,battler,pokemon.totalhp/4,scene)
})

ItemHandlers::BattleUseOnPokemon.add(:ORANMASH,proc { |item,pokemon,battler,choices,scene|
  pbBattleHPItem(pokemon,battler,30,scene)
})

ItemHandlers::BattleUseOnPokemon.add(:BERRYJUICE,proc { |item,pokemon,battler,choices,scene|
  pbBattleHPItem(pokemon,battler,20,scene)
})
ItemHandlers::BattleUseOnPokemon.copy(:BERRYJUICE,:SWEETHEART)
ItemHandlers::BattleUseOnPokemon.copy(:BERRYJUICE,:RAGECANDYBAR) if !Settings::RAGE_CANDY_BAR_CURES_STATUS_PROBLEMS

ItemHandlers::BattleUseOnPokemon.add(:SUPERPOTION,proc { |item,pokemon,battler,choices,scene|
  pbBattleHPItem(pokemon,battler,pokemon.totalhp/3,scene)
})

ItemHandlers::BattleUseOnPokemon.add(:HYPERPOTION,proc { |item,pokemon,battler,choices,scene|
  pbBattleHPItem(pokemon,battler,pokemon.totalhp/2,scene)
})


ItemHandlers::BattleUseOnPokemon.add(:ARGOSTBERRY,proc { |item,pokemon,battler,choices,scene|
  pokemon.hp = 1
								   
  pokemon.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} recovered from fainting!",pokemon.name))
})



ItemHandlers::BattleUseOnBattler.add(:CRITCURRY,proc { |item,battler,scene|
  battler.effects[PBEffects::FocusEnergy] = 2
  scene.pbDisplay(_INTL("{1} is getting pumped!",battler.pbThis))
  battler.pokemon.changeHappiness("battleitem",battler)
  battler.pokemon.changeLoyalty("battleitem",battler)
})

ItemHandlers::CanUseInBattle.add(:XATTACK,proc { |item,pokemon,battler,move,firstAction,battle,scene,showMessages|
  next pbBattleItemCanRaiseStat?(:ATTACK,battler,scene,showMessages)
})

ItemHandlers::CanUseInBattle.copy(:XATTACK,:XATTACK2,:XATTACK3,:XATTACK6,:ATKCURRY)

ItemHandlers::CanUseInBattle.add(:XDEFENSE,proc { |item,pokemon,battler,move,firstAction,battle,scene,showMessages|
  next pbBattleItemCanRaiseStat?(:DEFENSE,battler,scene,showMessages)
})

ItemHandlers::CanUseInBattle.copy(:XDEFENSE,
   :XDEFENSE2,:XDEFENSE3,:XDEFENSE6,:XDEFEND,:XDEFEND2,:XDEFEND3,:XDEFEND6,:DEFCURRY)

ItemHandlers::CanUseInBattle.add(:XSPATK,proc { |item,pokemon,battler,move,firstAction,battle,scene,showMessages|
  next pbBattleItemCanRaiseStat?(:SPECIAL_ATTACK,battler,scene,showMessages)
})

ItemHandlers::CanUseInBattle.copy(:XSPATK,
   :XSPATK2,:XSPATK3,:XSPATK6,:XSPECIAL,:XSPECIAL2,:XSPECIAL3,:XSPECIAL6,:SATKCURRY)

ItemHandlers::CanUseInBattle.add(:XSPDEF,proc { |item,pokemon,battler,move,firstAction,battle,scene,showMessages|
  next pbBattleItemCanRaiseStat?(:SPECIAL_DEFENSE,battler,scene,showMessages)
})

ItemHandlers::CanUseInBattle.copy(:XSPDEF,:XSPDEF2,:XSPDEF3,:XSPDEF6,:SPDEFCURRY)

ItemHandlers::CanUseInBattle.add(:XSPEED,proc { |item,pokemon,battler,move,firstAction,battle,scene,showMessages|
  next pbBattleItemCanRaiseStat?(:SPEED,battler,scene,showMessages)
})

ItemHandlers::CanUseInBattle.copy(:XSPEED,:XSPEED2,:XSPEED3,:XSPEED6,:SPEEDCURRY)

ItemHandlers::CanUseInBattle.add(:XACCURACY,proc { |item,pokemon,battler,move,firstAction,battle,scene,showMessages|
  next pbBattleItemCanRaiseStat?(:ACCURACY,battler,scene,showMessages)
})

ItemHandlers::CanUseInBattle.copy(:XACCURACY,:XACCURACY2,:XACCURACY3,:XACCURACY6,:ACCCURRY)

ItemHandlers::CanUseInBattle.add(:DIREHIT,proc { |item,pokemon,battler,move,firstAction,battle,scene,showMessages|
  if !battler || battler.effects[PBEffects::FocusEnergy]>=1
																   
																		  
																		   
															  
    scene.pbDisplay(_INTL("It won't have any effect.")) if showMessages
    next false
  end
  next true
})

ItemHandlers::CanUseInBattle.add(:DIREHIT2,proc { |item,pokemon,battler,move,firstAction,battle,scene,showMessages|
  if !battler || battler.effects[PBEffects::FocusEnergy]>=2
    scene.pbDisplay(_INTL("It won't have any effect.")) if showMessages
    next false
  end
  next true
})

ItemHandlers::CanUseInBattle.add(:DIREHIT3,proc { |item,pokemon,battler,move,firstAction,battle,scene,showMessages|
  if !battler || battler.effects[PBEffects::FocusEnergy]>=3
    scene.pbDisplay(_INTL("It won't have any effect.")) if showMessages
    next false
  end
  next true
})

ItemHandlers::CanUseInBattle.add(:CRITCURRY,proc { |item,pokemon,battler,move,firstAction,battle,scene,showMessages|
  if !battler || battler.effects[PBEffects::FocusEnergy]>=2
    scene.pbDisplay(_INTL("It won't have any effect.")) if showMessages
    next false
  end
  next true
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


ItemHandlers::UseInBattle.add(:GSCURRY,proc { |item,battler,battle|
  battler.pbOwnSide.effects[PBEffects::Mist] = 5
  battle.pbDisplay(_INTL("{1} is immune to stat reduction!",battler.pbTeam))
  battler.pokemon.changeHappiness("battleitem",battler)
  battler.pokemon.changeLoyalty("battleitem",battler)
})