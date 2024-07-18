ItemHandlers::UseFromBag.add(:BAIT, proc { |item|
  next 2
})
ItemHandlers::UseInField.add(:BAIT,proc { |item|
  pbBait
  next true
})



ItemHandlers::UseFromBag.add(:WATERBOTTLE,proc { |item|
  next 2
})

ItemHandlers::UseFromBag.add(:GLASSBOTTLE,proc { |item|
  next 2
})

ItemHandlers::UseFromBag.add(:IRONAXE,proc { |item|
  next 2
})

ItemHandlers::UseInField.add(:WATERBOTTLE,proc { |item|
if $game_player.pbFacingTerrainTag.can_surf
     message=(_INTL("Want to pick up water?"))
    if pbConfirmMessage(message)
      message=(_INTL("Do you want to use all your bottles?"))
    if pbConfirmMessage(message)
       $bag.add(:WATER,$bag.quantity(:WATERBOTTLE))
	else
       $bag.add(:WATER,1)
	end
	end
	next true
   else
    pbMessage(_INTL("That is not water."))
	next false
end
})
ItemHandlers::UseInField.add(:GLASSBOTTLE,proc { |item|
if $game_player.pbFacingTerrainTag.can_surf
     message=(_INTL("Want to pick up water?"))
    if pbConfirmMessage(message)
      message=(_INTL("Do you want to use all your bottles?"))
    if pbConfirmMessage(message)
       $bag.add(:WATER,$bag.quantity(:GLASSBOTTLE))
	else
       $PokemonBag.add(:WATER,1)
	end

	end
	next true
   else
    pbMessage(_INTL("That is not water."))
	next false
end
})
ItemHandlers::UseInField.add(:IRONAXE,proc { |item|
if $game_player.pbFacingTerrainTag.can_knockdown
     message=(_INTL("Want to knock down some branches?"))
    if pbConfirmMessage(message)
       $bag.add(:ACORN,(rand(6)))
	end
	next true
   else
    pbMessage(_INTL("That is not a tree."))
	next false
end
})



def pbBait
  viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  viewport.z = 99999
  count = 0
  viewport.color.red   = 255
  viewport.color.green = 0
  viewport.color.blue  = 0
  viewport.color.alpha -= 10
  alphaDiff = 12 * 20 / Graphics.frame_rate
  loop do
    if count == 0 && viewport.color.alpha < 128
      viewport.color.alpha += alphaDiff
    elsif count > Graphics.frame_rate / 4
      viewport.color.alpha -= alphaDiff
    else
      count += 1
    end
    Graphics.update
    Input.update
    pbUpdateSceneMap
    break if viewport.color.alpha <= 0
  end
  viewport.dispose
  enctype = $PokemonEncounters.encounter_type
  if !enctype || !$PokemonEncounters.encounter_possible_here?
    pbMessage(_INTL("There appears to be nothing here..."))
  else
   pbMessage(_INTL("You throw the bait on the ground, and a POKeMON appeared!"))
	$game_temp.in_safari=true
   if pbEncounter(enctype)
   end
	$game_temp.in_safari=false
  end
end




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

ItemHandlers::UseOnPokemon.add(:GRITGRAVEL,proc { |item,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_ATTACK)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Attack increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})
ItemHandlers::UseOnPokemon.add(:GRITPEBBLE,proc { |item,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_ATTACK)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Attack increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})

ItemHandlers::UseOnPokemon.add(:GRITROCK,proc { |item,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_ATTACK)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Attack increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})



ItemHandlers::UseOnPokemon.add(:SPEEDCOMET,proc { |item,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:SPEED,40)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Speed increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})

ItemHandlers::UseOnPokemon.add(:DEFENDCOMET,proc { |item,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_DEFENSE,20)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pbJustRaiseEffortValues(pkmn,:DEFENSE,20)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Defenses increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})

ItemHandlers::UseOnPokemon.add(:BALANCEDCOMET,proc { |item,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:ATTACK,10)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_ATTACK,10)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_DEFENSE,10)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pbJustRaiseEffortValues(pkmn,:DEFENSE,10)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pbJustRaiseEffortValues(pkmn,:SPEED,10)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pbJustRaiseEffortValues(pkmn,:HP,10)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Attack increased.",pkmn.name))
  pkmn.changeHappiness("vitamin",pkmn)
  pkmn.changeLoyalty("vitamin",pkmn)
  next true
})

ItemHandlers::UseOnPokemon.add(:ATKCOMET,proc { |item,pkmn,scene|
  if pbJustRaiseEffortValues(pkmn,:ATTACK,20)
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pbJustRaiseEffortValues(pkmn,:SPECIAL_ATTACK,20)
  else
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
  if battler.hp==1
       battle.pbReduceHP(1)
	   scene.pbDisplay(_INTL("You slashed at Enemy {1} with the {2}!",battler.name,itemname))
	   pbCookMeat(false,battler)
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






