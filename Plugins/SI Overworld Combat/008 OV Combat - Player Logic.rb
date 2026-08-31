class OverworldCombat


  def player_action(event,item,dir)
    begin_action(event, item, dir)
  end
  
  
  def capturecalc(event, ball, dir)
    pkmn = event.pokemon
    catch_rate = pkmn.species_data.catch_rate
	puts catch_rate 
      if !pkmn.species_data.has_flag?("UltraBeast") || ball == :BEASTBALL
         catch_rate = ball.effects.trigger(:modifyCatchRate, catch_rate, nil, pkmn)
	puts catch_rate 
         #catch_rate = OverworldPBEffects.modifyCatchRate(ball, catch_rate, pkmn)
      else
         catch_rate /= 10
      end
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
    return 4 if x >= 255 || ball.effects.trigger(:isUnconditional, nil, pkmn)
    #return 99 if x >= 255 || OverworldPBEffects.isUnconditional?(ball, pkmn)
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

  
  def capture_calcs(event, ball, dir)
     catch_rate = capturecalc(event, ball, dir)
	 return catch_rate>=4
  end
  
  
  def no_moving(frames)
   $game_temp.no_moving=true
   loops=0
   loop do
    break if loops >= frames
	  
      OverworldCombat.update_package
	  
	  loops+=1
   end
	
   $game_temp.no_moving=false
  end
  

def is_assassin?
  return $player.is_it_this_class?(:ASSASSIN,false)
end
  
  def tool?(item)
	return true if item.id==:SNATCHER
	return false 
  end 
   
  def hitcalc(ball,pkmn)
    x = pkmn.speed
    x = x.floor
    x = 1 if x < 1
    return 99 if $player.pokedex.owned_count<2
    return 99 if pkmn.status == :SLEEP || pkmn.status == :FROZEN
	return 99 if $DEBUG && Input.press?(Input::CTRL)
    y = x-($player.shoespeed/2)
    numShakes = 0
    4.times do |i|
      numShakes += 1 if rand(75) > y
    end
    return numShakes
  end




 def hits?(event,item)
        return true if item.id == :BAIT || item.id == :STONE
		
        pkmn = event.pokemon
		
        hit_rate=hitcalc(item,pkmn)
		
        hit_rate+=4 if event.direction == $game_player.direction
        hit_rate+=2 if (event.direction == 4 || event.direction == 6) && ($game_player.direction == 8 || $game_player.direction == 2)
		randhit = rand(8)
        return randhit<=hit_rate

 end
 
 def begin_action(event, item, dir)
   unless $player.weapon_cooldown<=0
	sideDisplay("You are too winded from your last attack still!")
    return 
   end 
   $game_temp.weapon_selection_end=60 if $game_temp.weapon_selection_end!=-1
   $game_temp.lockontarget=event if $PokemonSystem.autotarget == 0
   play_attack_sound(item)
   unless hits?(event,item)
	 sideDisplay("#{$player.name} missed!")
     pbSEPlay("Miss")
	 $player.punch_cooldown+=40
	 $player.weapon_cooldown+=80
	 no_moving(15)
     return 
   end
   event.times_not_attacking += 1
   if item==:PUNCH
     handle_punch(event)
   else
     handle_itemdata(event, item)
   end 
   end_action(event)
 end 
 
 def end_action(event)
   event.remaining_steps+=10
  # @turn+=1
   $hud.createaChargeBar($game_player) if $player.attack_opportunity>=0
 end 
 
 def handle_punch(event)
  return if @battle_rules.include?("No Player Damage") || @battle_rules.include?("No Player Basics")
  pkmn = event.pokemon
  move = Pokemon::Move.new(:TACKLE)
  baseDmg = move.base_damage
  damage = calculate_weapon_damage(pkmn, :FIGHTING, baseDmg)
  deal_weapon_damage(event, damage)
  $player.punch_cooldown += 80
  no_moving(15)
 end 
 

 def handle_itemdata(event, item)
  if tool?(item)
    handle_tool(event, item)
  
  else 
    handle_attack(event, item)
  end 


 end  
 
 def handle_tool(event, item)
    case item.id
	  when :SNATCHER 
	   snatcher(event)
	end 
 
 
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
  
 def handle_attack(event, item)
  return if @battle_rules.include?("No Player Damage") 
  pkmn = event.pokemon
  
  item_meta = GameData::Item.get(item) 
  move_id = item_meta.move
  weapon_cooldown = item_meta.weapon_cooldown
  battle_timer = item_meta.battle_timer
  movement_lock = item_meta.movement_lock
  move = Pokemon::Move.new(move_id)
  moveType = move.type 
  baseDmg = move.base_damage
  
  damage = calculate_weapon_damage(pkmn, moveType, baseDmg)
  deal_weapon_damage(event, damage)
  if item_meta.is_dart?
       case item.id
           when :POISONDART
            	  inflictStatus(move,$player,pkmn,:POISON, rand(4)+1) if (!pkmn.pbHasType?(:STEEL) || !pkmn.hasAbility?(:CORROSION))
           when :SLEEPDART
            	inflictStatus(move,$player,pkmn,:SLEEP, rand(4)+1) if (!pkmn.hasAbility?(:INSOMNIA) || !pkmn.hasAbility?(:VITALSPIRIT))
           when :PARALYZDART
       	     inflictStatus(move,$player,pkmn,:PARALYSIS, rand(4)+1) if !pkmn.pbHasType?(:GROUND)
           when :ICEDART
       	     inflictStatus(move,$player,pkmn,:FROZEN, rand(4)+1) if !pkmn.pbHasType?(:ICE)
           when :FIREDART
       	     inflictStatus(move,$player,pkmn,:BURN, rand(4)+1) if !pkmn.pbHasType?(:FIRE)
        end
  
  end 
 end 
  
 def play_attack_sound(item)
   if item==:PUNCH
     pbSEPlay("smeck")
   
   elsif item.is_a?(ItemData)
     pbSEPlay("Sword") if item.id == :MACHETE
   else
     puts "item"
	 raise 
   end 
   


 end  
 
 def calculate_weapon_damage(pkmn, move_type, base_damage)
  damage = ((((2.0 * pkmn.level / 5) + 2).floor * base_damage).floor / 50).floor + 2

  pkmn.types.each do |type|
    value = Effectiveness.calculate(move_type, type)
    damage *= 2 if Effectiveness.super_effective?(value)
    damage /= 2 if Effectiveness.not_very_effective?(value)
    damage /= 2 if Effectiveness.resistant?(value)
    damage = 0 if Effectiveness.ineffective?(value)
  end

  damage += $player.equipmentatkbuff.to_i
  damage.floor
 end


 def deal_weapon_damage(event, damage)
  pkmn = event.pokemon

  if rand(100) < 20
    damage *= 2
    pbSEPlay("Battle damage super")
  else
    pbSEPlay("Battle damage normal")
  end
  puts "#{event.type.name}: #{event.type.hp}/#{event.type.totalhp}"


  event.remaining_steps += 1
  makeAggressive(event)
  pkmn.status = :NONE if pkmn.status == :SLEEP
  attacking_whatever_else(damage.floor, event, $game_player, nil)
 end


end 