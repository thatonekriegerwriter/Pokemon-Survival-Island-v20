class OverworldCombat


def doesithitfam(event,item)
         pkmn = event.pokemon
        hit_rate=hitcalc(item,pkmn)
        hit_rate+=2 if event.direction == $game_player.direction
        hit_rate+=1 if event.direction == 4 || 6 && $game_player.direction == 8 || 2
		randhit = rand(8)
        return randhit<=hit_rate

 end




def is_assassin?
  return $player.is_it_this_class?(:TRIATHLETE,false) if $player.playerclass.respond_to?("name")
  return $player.playerclass == "Assassin" if !$player.playerclass.respond_to?("name")
end
   
  def hitcalc(ball,pkmn)
    x = pkmn.speed
    pkmn.bait_eaten=0 if pkmn.bait_eaten.nil?
	x -= pkmn.bait_eaten
    x = x.floor
    x = 1 if x < 1
    return 99 if pkmn.status == :SLEEP || pkmn.status == :FROZEN
	return 99 if $DEBUG && Input.press?(Input::CTRL)
    y = x-($player.shoespeed/2)
    numShakes = 0
    4.times do |i|
      numShakes += 1 if rand(75) > y
    end
    return numShakes
  end
  

  def capturecalc(event,ball,dir)
    pkmn = event.pokemon
    catch_rate = pkmn.species_data.catch_rate if !catch_rate
      if !pkmn.species_data.has_flag?("UltraBeast") || ball == :BEASTBALL
      catch_rate = OverworldPBEffects.modifyCatchRate(ball, catch_rate, pkmn)
    else
      catch_rate /= 10
    end
	a = pkmn.totalhp
    b = pkmn.hp
    x = (((3 * pkmn.totalhp) - (2 * pkmn.hp)) * catch_rate.to_f) / (3 * pkmn.totalhp)
    # Calculation modifiers
    if pkmn.status == :SLEEP || pkmn.status == :FROZEN
      x *= 2.5
    elsif pkmn.status != :NONE
      x *= 1.5
    end
    if Input.repeat?(Input::ACTION)
      x *= 1.2
    end 
	   if pkmn.bait_eaten.nil?
	     pkmn.bait_eaten=0
	   end
	x += pkmn.bait_eaten
    x = x.floor
    x = 1 if x < 1
    return 99 if x >= 255 || OverworldPBEffects.isUnconditional?(ball, pkmn)
    y = (65_536 / ((255.0 / x)**0.1875)).floor
    if Settings::ENABLE_CRITICAL_CAPTURES
      dex_modifier = 0
      numOwned = $player.pokedex.owned_count
      if numOwned > 600
        dex_modifier = 5
      elsif numOwned > 450
        dex_modifier = 4
      elsif numOwned > 300
        dex_modifier = 3
      elsif numOwned > 150
        dex_modifier = 2
      elsif numOwned > 30
        dex_modifier = 1
      end
      dex_modifier *= 2 if $bag.has?(:CATCHINGCHARM)
      c = x * dex_modifier / 12
      # Calculate the number of shakes
      if c > 0 && pbRandom(256) < c
        criticalCapture = true
        return 4 if pbRandom(65_536) < y
        return 0
      end
    end
    numShakes = 0
    4.times do |i|
      break if numShakes < i
      numShakes += 1 if rand(65_536) < y
    end
	numShakes+=1 if event.direction == [2,4,6,8][dir]
	return 0 if @battle_rules.include?("Catchless")
    return numShakes
  end





  def player_action(event,item,dir)
   if $player.weapon_cooldown<=0
   pbSEPlay("smeck") if item=="Punch"
   if item.is_a?(Symbol) || item.is_a?(ItemData)
    pbSEPlay("Sword") if GameData::Item.get(item).id==:MACHETE
    item_data=GameData::Item.get(item)
   end
   
	hit = doesithitfam(event,item)
	event.times_not_attacking+=1 if hit
	punch(event) if item=="Punch" && hit && !@battle_rules.include?("No Player Damage")
	if !item_data.nil?
   stone_and_bait(event,item) if (item_data.id == :BAIT || item_data.id == :STONE)
    dartly_actions(event,item) if item_data.is_dart? && hit
    weaponly_actions(event,item) if item_data.is_weapon? && hit && item_data.id != :BAIT && item_data.id != :STONE
    snatcher(event) if item==:SNATCHER && hit
	end


    if !hit && !item_data.nil? && (item_data.id != :BAIT && item_data.id != :STONE)
	  
	  sideDisplay("#{$player.name} missed!")
	  #pbMessage("\\ts[]" + (_INTL"#{$player.name} missed!\\wtnp[10]"))
      pbSEPlay("Miss")
	   $player.punch_cooldown+=40
	   $player.weapon_cooldown+=80
	elsif item=="Punch" && !hit
	   
	  sideDisplay("#{$player.name} missed!")
	   $player.punch_cooldown+=80
	elsif item=="Punch" && hit
	  sideDisplay("#{$player.name} landed a punch on #{event.pokemon.name}!")
	   $player.punch_cooldown+=80
	end

    @turn+=1
    status_checks(event)
	return
  else
	sideDisplay("You are too winded from your last attack still!")
  end
  end
  
  
  
  def capture_calcs(target,ball,dir)
     pkmn = target.pokemon
     catch_rate=capturecalc(target,ball,dir)
	 randcatch = rand(9)+2
	  return randcatch<=catch_rate
  end
  
  
  def no_moving(amt)
   $game_temp.no_moving=true
     loops=0
    loop do
	   break if loops>=amt
      update_package
	  loops+=1
    end
   $game_temp.no_moving=false
  end
  
  
  
  def dartly_actions(event,item)
       pkmn = event.pokemon
       case GameData::Item.get(item).id
           when :POISONDART
            	  inflictStatus(move,user,target,:POISON, rand(4)+1) if (!target.pbHasType?(:STEEL) || !target.hasAbility?(:CORROSION))
           when :SLEEPDART
            	inflictStatus(move,user,target,:SLEEP, rand(4)+1) if (!target.hasAbility?(:INSOMNIA) || !target.hasAbility?(:VITALSPIRIT))
           when :PARALYZDART
       	     inflictStatus(move,user,target,:PARALYSIS, rand(4)+1) if !target.pbHasType?(:GROUND)
           when :ICEDART
       	     inflictStatus(move,user,target,:FROZEN, rand(4)+1) if !target.pbHasType?(:ICE)
           when :FIREDART
       	     inflictStatus(move,user,target,:BURN, rand(4)+1) if !target.pbHasType?(:FIRE)
        end
       event.angry_at << $game_player if !event.angry_at.include?($game_player)
  end





  def stone_and_bait(event,item)
     pkmn = event.pokemon
	 if !@battle_rules.include?("No Player Damage")
     case GameData::Item.get(item).id
     when :STONE
	   move = Pokemon::Move.new(:ROCKTHROW)
	   baseDmg = move.base_damage
       damage  = ((((2.0 * pkmn.level / 5) + 2).floor * baseDmg).floor / 50).floor + 2
	  pkmn.types.each do |type|
	   value = Effectiveness.calculate(move.type, type)
	   damage *= 2 if Effectiveness.super_effective?(value)
	   damage /= 2 if Effectiveness.not_very_effective?(value)
	   damage /= 2 if Effectiveness.resistant?(value)
	   damage *= 0 if Effectiveness.ineffective?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   end
	   damage += $player.equipmentatkbuff.to_i
	   damage = damage.floor
	 
	  start_attacked_glow(event,$game_player)
	  makeAggressive(event) 
	   puts "Stone Damage: #{damage}"
      damagePokemon(event,damage)
	  if pkmn.status==:SLEEP
	    pkmn.status=:NONE
	  end
      event.battle_timer = 6
	   $player.weapon_cooldown+=80
	  pbSEPlay("Battle damage normal")
	   no_moving(15)
	  
	  
	 when :BAIT
        event.remaining_steps -= 1
	    pkmn.bait_eaten=0 if pkmn.bait_eaten.nil?
	    pkmn.bait_eaten+=1
	    pkmn.bait_eaten=4 if pkmn.bait_eaten>4
	    pkmn.hp=pkmn.hp+(rand(20)+1)
		makeUnaggressive(event,$game_player)
       event.battle_timer = 15
	   $player.weapon_cooldown+=60
		pbSEPlay("eat")
	 
  
     end
	end
  end



  def weaponly_actions(event,item)
     pkmn = event.pokemon
	 if !@battle_rules.include?("No Player Damage")
     case GameData::Item.get(item).id
	 
	 when :MACHETE
	 
	   move = Pokemon::Move.new(:SLASH)
	   baseDmg = move.base_damage
       damage  = ((((2.0 * pkmn.level / 5) + 2).floor * baseDmg).floor / 50).floor + 2
	  pkmn.types.each do |type|
	   value = Effectiveness.calculate(:NORMAL, type)
	   damage *= 2 if Effectiveness.super_effective?(value)
	   damage /= 2 if Effectiveness.not_very_effective?(value)
	   damage /= 2 if Effectiveness.resistant?(value)
	   damage *= 0 if Effectiveness.ineffective?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   end
	   damage += $player.equipmentatkbuff.to_i
	   machete(event,damage) #SLASH - Power 70, Accuracy 100
      event.battle_timer = 6
	   $player.weapon_cooldown+=100
	   no_moving(30)
     when :STONEPICKAXE
	   move = Pokemon::Move.new(:ROCKSMASH)
	   baseDmg = move.base_damage
       damage  = ((((2.0 * pkmn.level / 5) + 2).floor * baseDmg).floor / 50).floor + 2
	  pkmn.types.each do |type|
	   value = Effectiveness.calculate(:NORMAL, type)
	   damage *= 2 if Effectiveness.super_effective?(value)
	   damage /= 2 if Effectiveness.not_very_effective?(value)
	   damage /= 2 if Effectiveness.resistant?(value)
	   damage *= 0 if Effectiveness.ineffective?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   end
	   damage += $player.equipmentatkbuff.to_i
	   machete(event,damage) #ROCKSMASH - Power 40, Accuracy 100
      event.battle_timer = 6
	   $player.weapon_cooldown+=80
	   no_moving(15)
     when :IRONPICKAXE
	   move = Pokemon::Move.new(:ROCKSMASH)
	   baseDmg = move.base_damage
       damage  = ((((2.0 * pkmn.level / 5) + 2).floor * baseDmg).floor / 50).floor + 2
	   value = Effectiveness.calculate(:NORMAL, pkmn.types)
	   damage *= 2 if Effectiveness.super_effective?(value)
	   damage /= 2 if Effectiveness.not_very_effective?(value)
	   damage /= 2 if Effectiveness.resistant?(value)
	   damage *= 0 if Effectiveness.ineffective?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   damage += $player.equipmentatkbuff.to_i
	   machete(event,damage) #ROCKSMASH - Power 40, Accuracy 100
      event.battle_timer = 6
	   $player.weapon_cooldown+=80
	   no_moving(15)
     when :STONEAXE
	   move = Pokemon::Move.new(:STONEAXE)
	   baseDmg = move.base_damage
       damage  = ((((2.0 * pkmn.level / 5) + 2).floor * baseDmg).floor / 50).floor + 2
	  pkmn.types.each do |type|
	   value = Effectiveness.calculate(:NORMAL, type)
	   damage *= 2 if Effectiveness.super_effective?(value)
	   damage /= 2 if Effectiveness.not_very_effective?(value)
	   damage /= 2 if Effectiveness.resistant?(value)
	   damage *= 0 if Effectiveness.ineffective?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   end
	   damage += $player.equipmentatkbuff.to_i
	   machete(event,damage) #STONEAXE - Power 80, Accuracy 100
      event.battle_timer = 6
	   $player.weapon_cooldown+=160
	   no_moving(15)
     when :IRONAXE
	   move = Pokemon::Move.new(:STONEAXE)
	   baseDmg = move.base_damage
       damage  = ((((2.0 * pkmn.level / 5) + 2).floor * baseDmg).floor / 50).floor + 2
	  pkmn.types.each do |type|
	   value = Effectiveness.calculate(:NORMAL, type)
	   damage *= 2 if Effectiveness.super_effective?(value)
	   damage /= 2 if Effectiveness.not_very_effective?(value)
	   damage /= 2 if Effectiveness.resistant?(value)
	   damage *= 0 if Effectiveness.ineffective?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   end
	   damage += $player.equipmentatkbuff.to_i
	   machete(event,damage) #STONEAXE - Power 80, Accuracy 100
      event.battle_timer = 6
	   $player.weapon_cooldown+=160
	   no_moving(15)
     when :STONEHAMMER
	   move = Pokemon::Move.new(:ROCKSMASH)
	   baseDmg = move.base_damage
       damage  = ((((2.0 * pkmn.level / 5) + 2).floor * baseDmg).floor / 50).floor + 2
	  pkmn.types.each do |type|
	   value = Effectiveness.calculate(:NORMAL, type)
	   damage *= 2 if Effectiveness.super_effective?(value)
	   damage /= 2 if Effectiveness.not_very_effective?(value)
	   damage /= 2 if Effectiveness.resistant?(value)
	   damage *= 0 if Effectiveness.ineffective?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   end
	   damage += $player.equipmentatkbuff.to_i
	   machete(event,damage) #ROCKSMASH - Power 40, Accuracy 100
      event.battle_timer = 6
	   $player.weapon_cooldown+=80
	   no_moving(15)
     when :IRONHAMMER
	   move = Pokemon::Move.new(:ROCKSMASH)
	   baseDmg = move.base_damage
       damage  = ((((2.0 * pkmn.level / 5) + 2).floor * baseDmg).floor / 50).floor + 2
	  pkmn.types.each do |type|
	   value = Effectiveness.calculate(:NORMAL, pkmn.types)
	   damage *= 2 if Effectiveness.super_effective?(value)
	   damage /= 2 if Effectiveness.not_very_effective?(value)
	   damage /= 2 if Effectiveness.resistant?(value)
	   damage *= 0 if Effectiveness.ineffective?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   end
	   damage += $player.equipmentatkbuff.to_i
	   machete(event,damage) #ROCKSMASH - Power 40, Accuracy 100
      event.battle_timer = 6
	   $player.weapon_cooldown+=80
	   no_moving(15)
     when :POLE
	   move = Pokemon::Move.new(:BONECLUB)
	   baseDmg = move.base_damage
       damage  = ((((2.0 * pkmn.level / 5) + 2).floor * baseDmg).floor / 50).floor + 2
	  pkmn.types.each do |type|
	   value = Effectiveness.calculate(:NORMAL, type)
	   damage *= 2 if Effectiveness.super_effective?(value)
	   damage /= 2 if Effectiveness.not_very_effective?(value)
	   damage /= 2 if Effectiveness.resistant?(value)
	   damage *= 0 if Effectiveness.ineffective?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   damage *= 1 if Effectiveness.normal?(value)
	   end
	   damage += $player.equipmentatkbuff.to_i
	   machete(event,damage) #BONECLUB - Power 65
      event.battle_timer = 3
	   $player.weapon_cooldown+=90
	   no_moving(15)
	 
	 
	 
	 end
     else
	  sideDisplay("#{$player.name}'s blows seem to be doing nothing!!")
	 
	 end
    
		event.angry_at << $game_player if !event.angry_at.include?($game_player)
  end



  def machete(event,injury)
   pkmn = event.pokemon
	  if rand(100)<20
	   injury*=2
		pbSEPlay("Battle damage super")
	  else
		pbSEPlay("Battle damage normal")
	  end
      
	   damage = damage.floor
	  start_attacked_glow(event,$game_player)
      damagePokemon(event,injury.to_i)
	  if pkmn.status==:SLEEP
	    pkmn.status=:NONE
	  end
      event.remaining_steps += 1
	  makeAggressive(event)
  
  
  end



  def snatcher(event)
	return false if @battle_rules.include?("Theftless")
   pkmn = event.pokemon
     decreaseStamina(4)
     if pbItemThieving(pkmn)
		pbSEPlay("Mining found all")
	     makeAggressive(event)
		event.angry_at << $game_player if !event.angry_at.include?($game_player)
	 end
  end



  def punch(event)
   pkmn = event.pokemon
    #RAPIDSPIN - Power 20
    #TACKLE - Power 40
    #STRENGTH - Power 80
	 move = Pokemon::Move.new(:TACKLE)
	 baseDmg = move.base_damage
     damage  = ((((2.0 * pkmn.level / 5) + 2).floor * baseDmg).floor / 50).floor + 2
	  pkmn.types.each do |type|
	 value = Effectiveness.calculate(:FIGHTING, type)
	 damage *= 2 if Effectiveness.super_effective?(value)
	 damage /= 2 if Effectiveness.not_very_effective?(value)
	 damage /= 2 if Effectiveness.resistant?(value)
	 damage *= 0 if Effectiveness.ineffective?(value)
	 damage *= 1 if Effectiveness.normal?(value)
	 damage *= 1 if Effectiveness.normal?(value)
	   end
	 damage += $player.equipmentatkbuff.to_i
	  if rand(100)<20
	   damage*=2
		pbSEPlay("Battle damage super")
	  else
		pbSEPlay("Battle damage normal")
	  end
	   
	  damage = damage.floor
	  start_attacked_glow(event,$game_player)
      damagePokemon(event,damage)
	    puts "#{event.type.name}: #{event.type.hp}/#{event.type.totalhp}"
	  
	    pkmn.status=:NONE if pkmn.status==:SLEEP
       event.remaining_steps += 1
	   
	  makeAggressive(event)
		event.angry_at << $game_player if !event.angry_at.include?($game_player)
  
  
  end




end