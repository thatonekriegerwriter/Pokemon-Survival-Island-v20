#===============================================================================
# Stamina and Movement
#===============================================================================

class OverworldCombat 
  
def inputDetection(attacker,target)
    loops = 0
	dir = 0
	pbExclaim(target,46)
	sprite = nil
	amt = 5-@hard_hitting
	loop do
    dir = Input.dir4
	Input.update
    Graphics.update
	pbExclaim($game_player,47)
	dir_override = false
	dir_override = true if dir == @baddir && target.type.playerstamina>19 && target.type.stamina>19
	if sprite.nil? 
    spriteset = $scene.spriteset(target.map_id)
    sprite = spriteset&.addUserAnimation(47, target.x, target.y, false, 2)
	end
    case dir 
	 when 8
	  if (dir == @baddir && dir_override==false) || dir == attacker.direction
	pbExclaim(target,48)
	  else
	pbExclaim(target,42)
	  end
	
	
	 
	
	
	
	
	sprite.dispose
     break
	 
	 
	 
	 
	 when 2
	  if (dir == @baddir && dir_override==false) || dir == attacker.direction
	pbExclaim(target,48)
	  else
	pbExclaim(target,44)
	  end
	
	
	
	
	
	
	sprite.dispose
     break
	 
	 
	 
	 when 4 
	  if (dir == @baddir && dir_override==false) || dir == attacker.direction
	pbExclaim(target,48)
	  else
	pbExclaim(target,43)
	  end
	
	
	
	
	
	
	
	sprite.dispose
     break
	 
	 
	 
	 
	 
	 when 6
	 if (dir == @baddir && dir_override==false) || dir == attacker.direction
	pbExclaim(target,48)
	else
	pbExclaim(target,45)
	end
	sprite.dispose
     break
	 else
	loops += 1
	
	
	
	
	
	
	
	end
	
	
	
	
	
	sprite.dispose if loops >= amt
	break if loops >= amt
	if sprite.nil? 
    spriteset = $scene.spriteset(target.map_id)
    sprite = spriteset&.addUserAnimation(47, target.x, target.y, false, 2)
	end
	end

  return dir
end



def staminaManagement(attacker,target)
	  dir = 0
    if advanced_shoes(target)
	  the_effect_of_stamina(attacker,target)
	 elsif default_sta(target)
	  the_effect_of_stamina(attacker,target)
	 else
      dir = inputDetection(attacker,target)
	 end
  return dir
end

  def damageTarget(target,amt)
     if target==$game_player
       damagePlayer(amt)
	 else
      damagePokemon(target.pokemon, amt) if !target.is_a?(Pokemon)
      damagePokemon(target, amt) if target.is_a?(Pokemon)
	 end
  
  end


  def healTarget(target,amt)
     if target==$game_player
       increaseHealth(amt)
	 else
      increaseHealth(target.pokemon,amt) if !target.is_a?(Pokemon)
      increaseHealth(pokemon,amt) if target.is_a?(Pokemon)
	 end
  
  end
  def increaseHealth(pkmn,restoreHP)
    newHP = pkmn.hp + restoreHP
    newHP = pkmn.totalhp if newHP > pkmn.totalhp
    hpGain = newHP - pkmn.hp
    pkmn.hp = newHP
  end
  
 def damagePokemon(target,amt)
 
    defense, defStage = getDefenseStatsforplayer(target.pokemon)
	 decrease = (defense+defStage)/4
	 theamt = (amt-decrease)
	 theamt = 1 if theamt<1
    target.pokemon.hp -= theamt
	  if target.pokemon.status==:SLEEP
	    target.pokemon.status=:NONE
	  end
     if target.pokemon.hp<0
      target.pokemon.hp=0
     end
    if target.pokemon.owner == Pokemon::Owner.new_from_trainer($player)
	   target.pokemon.iframes=5
	end
	target.movement_type = :WANDER if target.is_a?(Game_PokeEventA) && target.can_be_knocked_out_of_state?
	puts "#{target.type.name} Lv#{target.type.level}: #{target.type.hp}/#{target.type.totalhp} - #{theamt}"
	OverworldCombat.fainted_check(target) 
 end


  def the_effect_of_stamina(attacker,target)
    return if $game_temp.bossfight==true
	 pbExclaim(target,21)
	  sideDisplay("#{target.type.name} doesn't have enough Stamina to avoid #{attacker.pokemon.name}!")
	 pbSEPlay("phenomenon_grass")
      damageTarget(target,target.type.totalhp/4)
	  if rand(100)+1 < 16 && $PokemonGlobal.in_dungeon==false && target == $game_player
	  sideDisplay("#{attacker.pokemon.name} knocked #{target.type.name} down!")
	  #pbMessage("\\ts[]" + (_INTL"#{attacker.pokemon.name} knocked #{target.type.name} down!\\wtnp[10]"))
	  if true
	  if pbOverworldCombat.battle_rules.include?("Catchless")
	   setBattleRule("disablepokeballs")
	  end
	  $game_temp.encounter_type = $game_temp.encounter_type
	  pbStoreTempForBattle()
	  $PokemonGlobal.battlingSpawnedPokemon = true
	  $game_temp.in_safari = true
	  pbSingleOrDoubleWildBattle($game_map.map_id, attacker.x, attacker.y, attacker.pokemon)
	  $game_temp.in_safari = false
	  $PokemonGlobal.battlingSpawnedPokemon = false
	  pbResetTempAfterBattle()
        attacker.removeThisEventfromMap
	  end
     end
	  return
  
  end
 
 
 def getdirissues(attacker_direction, target_direction)
  backattack = attacker_direction == target_direction

  sideattack = [4, 6].include?(target_direction) &&
               [2, 8].include?(attacker_direction)

  baddir = case attacker_direction
           when 8 then 2
           when 4 then 6
           when 2 then 8
           when 6 then 4
           else 0
           end

  [backattack, sideattack, baddir]

end

 



 
 
 
 def default_sta(target)
  return $player.playerstamina<10 || target!=$game_player
 end
 
 def default_sta2(target)
  return $player.playerstamina>9 || target!=$game_player
 end
 
  def advanced_shoes(target)
   return $player.playershoes.id == :DASHBOOTS && $player.playerstamina<20  || target!=$game_player
  end

  def advanced_shoes2(target)
   return $player.playershoes.id == :DASHBOOTS && $player.playerstamina>19  || target!=$game_player
  end

end