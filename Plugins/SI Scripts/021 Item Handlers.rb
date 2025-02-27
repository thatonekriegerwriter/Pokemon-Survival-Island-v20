
def pbHPItem(pkmn, restoreHP, scene)
  if !pkmn.able? || pkmn.hp == pkmn.totalhp
    scene.pbDisplay(_INTL("It won't have any effect."))
    return false
  end
  hpGain = pbItemRestoreHP(pkmn, restoreHP)
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.", pkmn.name, hpGain))
  return true
end
def pbItemRestoreHP(pkmn, restoreHP)
  newHP = pkmn.hp + restoreHP
  newHP = pkmn.totalhp if newHP > pkmn.totalhp
  hpGain = newHP - pkmn.hp
  pkmn.hp = newHP
  return hpGain
end

ItemHandlers::UseOnPokemon.add(:POTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 20, scene)
})

ItemHandlers::UseOnPokemon.copy(:POTION, :BERRYJUICE, :SWEETHEART)
ItemHandlers::UseOnPokemon.copy(:POTION, :RAGECANDYBAR) if !Settings::RAGE_CANDY_BAR_CURES_STATUS_PROBLEMS

ItemHandlers::UseOnPokemon.add(:SUPERPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 60, scene)
})

ItemHandlers::UseOnPokemon.add(:HYPERPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 120, scene)
})

ItemHandlers::UseOnPokemon.add(:MAXPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, pkmn.totalhp - pkmn.hp, scene)
})

ItemHandlers::UseOnPokemon.add(:FRESHWATER, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 30, scene)
})

ItemHandlers::UseOnPokemon.add(:SODAPOP, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 60, scene)
})

ItemHandlers::UseOnPokemon.add(:LEMONADE, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 80, scene)
})

ItemHandlers::UseOnPokemon.add(:WEAKPOTION, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 10, scene)
})

ItemHandlers::UseOnPokemon.add(:MOOMOOMILK, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 50, scene)
})

ItemHandlers::UseOnPokemon.add(:ORANBERRY, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, 10, scene)
})

ItemHandlers::UseOnPokemon.add(:SITRUSBERRY, proc { |item, qty, pkmn, scene|
  next pbHPItem(pkmn, pkmn.totalhp / 4, scene)
})



ItemHandlers::UseOnPokemon.add(:SUSPO,proc { |item,pkmn,scene|
       chance = rand(4)
        if pkmn.happiness >= 75
		 if 0 == chance
          pkmn.species = pkmn.species_data.get_baby_species
          pkmn.exp           = 0
          pkmn.calc_stats
          pkmn.name           = _INTL("Egg")
          pkmn.steps_to_hatch = pkmn.species_data.hatch_steps
          pkmn.food  = 100
          pkmn.water  = 100
          pkmn.age  = 1
          pkmn.lifespan  = 100
		  pkmn.permaFaint = false if pkmn.permaFaint==true 
          next true
		 else
         scene.pbDisplay(_INTL("It was indigested, but had no effect."))
          next true
		 end
        else
         scene.pbDisplay(_INTL("It doesn't like you enough to reincarnate."))
         next false
        end
})



ItemHandlers::UseInField.add(:CALENDAR,proc { |item|
  openCalendar
  next 2
})


Battle::ItemEffects::HPHeal.add(:ARGOSTBERRY,
  proc { |item, battler, battle, forced|
    next false if battler.able
    battle.pbCommonAnimation("EatBerry", battler) if !forced
    battler.hp = 1
    itemName = GameData::Item.get(item).name
    if forced
      PBDebug.log("[Item triggered] Forced consuming of #{itemName}")
      battle.pbDisplay(_INTL("{1}'s was revived.", battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1} was revived!", battler.pbThis, itemName))
    end
    next true
  }
)


ItemHandlers::UseOnPokemon.add(:ARGOSTBERRY, proc { |item, qty, pkmn, scene|
    next false if !pkmn.fainted?
    next false if pkmn.permaFaint
    pkmn.hp = 1
    pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s was revived.", pkmn.name))
  next true
})


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

ItemHandlers::UseInField.add(:WATERBOTTLE,proc { |item2|
if $game_player.pbFacingTerrainTag.can_surf
     message=(_INTL("Store water in your Canteen?"))
    if pbConfirmMessage(message)
	
	    item = ItemData.new(:WATER)
        item2.decrease_durability(1)
		 item.set_bottle(item2)
       $bag.add(item,1)
       $bag.remove(item2,1)

	end
	next false
   else
end
	next false
})

ItemHandlers::UseInField.add(:GLASSBOTTLE,proc { |item2|
  puts $game_player.pbFacingTerrainTag.can_surf
if $game_player.pbFacingTerrainTag.can_surf
     message=(_INTL("Store water in your Bottle?"))
    if pbConfirmMessage(message)
	    item = ItemData.new(:WATER)
        item2.decrease_durability(1)
		 item.set_bottle(item2)
       $bag.add(item,1)
       $bag.remove(item2,1)
	next false
	end

	next false
end
	next false
})


ItemHandlers::UseInField.add(:BOWL,proc { |item2|
if $game_player.pbFacingTerrainTag.can_surf
     message=(_INTL("Drink some unpurified water?"))
    if pbConfirmMessage(message)
        item2.decrease_durability(1)
        increaseWater(10)
        damagePlayer(10.0)
	next true
	end
	next false
end
	next false
})

ItemHandlers::UseInField.add(:IRONAXE,proc { |item|
if $game_player.pbFacingTerrainTag.can_knockdown
     message=(_INTL("Want to knock down some branches?"))
    if pbConfirmMessage(message)
       item.decrease_durability(1)
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
	   pbCookMeat(battler)
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






