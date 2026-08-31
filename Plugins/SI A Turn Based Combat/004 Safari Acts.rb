class SafariBattle::Acts
  attr_reader :id 
  attr_reader :name 
  attr_reader :description 
  attr_reader :stamina_cost
  attr_reader :consumable
  attr_reader :extra_data   
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @name = name
    @description = description
    @stamina_cost = stamina_cost
    @consumable = consumable
    @extra_data = extra_data
  
  end 
  def enough_stamina?
    $player.playerstamina >= @stamina_cost
  end  
  def can_add?
    enough_stamina?
  end
  def act(battle, target)
    raise NotImplementedError
  end

  protected
  
  def consume_item
    return unless @consumable
	item = @extra_data.nil? ? @id : @extra_data
    $bag.remove(item, 1)
  end

  def damage(battle, user, target, amount)
     target.damageState.hpLost       = amount
     target.damageState.totalHPLost += amount
	 battle.pbInflictHPDamage(target)
	 battle.pbAnimateHitAndHPLost(user, [target])
  end
  
  def calculate_damage(move_id) 
	 move = Pokemon::Move.new(move_id)
	 
	 move_damage = (move.base_damage/5).floor
	 player_damage = $player.base_damage + $player.equipmentatkbuff.to_i
	 low = [player_damage, move_damage].min
     high = move_damage
	 amount = rand(low..high)
	 return amount
  end 
  
  def calculate_damage_pokemon(pkmn) 
	 move = Pokemon::Move.new(:TACKLE)
	 move_damage = move.base_damage/4
	 pkmn_damage = pkmn.attack
	 low = [pkmn_damage, move_damage].min
     high = move_damage
	 amount = rand(low..high)
	 return amount
  end 
  
  def heal_stamina(amount)
    $player.increaseStamina(amount)
  end
  
  def spend_stamina
    return true if @stamina_cost == 0
    if @stamina_cost<0
	 return heal_stamina(@stamina_cost.abs)
	end 
    return $player.decreaseStamina(@stamina_cost)
  end


end 

class SafariBattle::Acts::Attack < SafariBattle::Acts

  protected
  #The enemy has become more angered, increasing it's willingness to attack, but also flee. This makes it harder to catch because it's more on guard.
  def make_angry(enemy, attack_delta, escape_delta, catch_delta)
    enemy.attackFactor += attack_delta
    enemy.escapeFactor += escape_delta
    enemy.catchFactor -= catch_delta
  end


end 


class SafariBattle::Acts::Defend < SafariBattle::Acts

  protected
  #The enemy has become more aggressive, increasing it's willingness to attack, decreasing it's willingness to flee. This makes it easier to catch because it's more inclined to be on the offensive.
  def make_aggressive(enemy, attack_delta, escape_delta, catch_delta)
    enemy.attackFactor += attack_delta
    enemy.escapeFactor -= escape_delta
    enemy.catchFactor += catch_delta
  end


end 


class SafariBattle::Acts::Appeal < SafariBattle::Acts

  protected
  #The enemy has become more passive, decreasing it's willingness to attack, decreasing it's willingness to flee. This makes it easier to catch because it's more inclined to be friendly.
  def make_passive(enemy, attack_delta, escape_delta, catch_delta)
    enemy.attackFactor -= attack_delta
    enemy.escapeFactor -= escape_delta
    enemy.catchFactor += catch_delta
  end


end 

class SafariBattle::Acts::Catch < SafariBattle::Acts


  protected
  #The enemy has become more scared, increasing it's willingness to attack, but also flee. This makes it harder to catch because it's more on guard.
  def make_scared(enemy, attack_delta, escape_delta, catch_delta)
    enemy.attackFactor += attack_delta
    enemy.escapeFactor += escape_delta
    enemy.catchFactor -= catch_delta
  end


end 



class SafariBattle::Acts::Attack::Punch < SafariBattle::Acts::Attack
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :PUNCH
    super(name, description, stamina_cost, consumable, extra_data)

  end 

  def can_add?
    ret = enough_stamina? && !$player.is_it_this_class?(:BLACKBELT, false)
	return ret 
    
  end
  
  def act(battle, target)
     return unless spend_stamina
     battle.pbDisplayPaused(_INTL("{1} punched the {2}!", $player.name, target.pokemon.name))
     pbSEPlay("smeck")
	 damage(battle, battle.battlers[0], target, calculate_damage(:TACKLE))
	 attack_delta = rand(7..10)
	 escape_delta = rand(2..8)
	 catch_delta = rand(7..10)
	 make_angry(target, attack_delta, escape_delta, catch_delta)
	 battle.runrate -= 1
  end 
end 

class SafariBattle::Acts::Attack::BlackBeltPunch < SafariBattle::Acts::Attack::Punch
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    super(name, description, stamina_cost, consumable, extra_data)
  end 
  def can_add?
    enough_stamina? && $player.is_it_this_class?(:BLACKBELT, false)
  end
  def act(battle, target)
     return unless spend_stamina
     battle.pbDisplayPaused(_INTL("{1} struck the {2}!", $player.name, target.pokemon.name))
     pbSEPlay("smeck")
	 damage(battle, battle.battlers[0], target, calculate_damage(:TACKLE))
	 attack_delta = rand(7..10)
	 escape_delta = rand(2..8)
	 catch_delta = rand(7..10)
	 make_angry(target, attack_delta, escape_delta, catch_delta)
	 battle.runrate -= 1
	 
  end 

end 

class SafariBattle::Acts::Attack::PreciseAttack < SafariBattle::Acts::Attack
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :PRECISEATTACK
    super(name, description, stamina_cost, consumable, extra_data)
  end 
  def can_add?
    enough_stamina? && $player.is_it_this_class?(:BLACKBELT, false)
  end
  
  def act(battle, target)
     return unless spend_stamina
     battle.pbDisplayPaused(_INTL("{1} took a moment, and then struck the {2} carefully!", $player.name, target.pokemon.name))
     pbSEPlay("smeck")
	 target.flinch = true if rand(100)<=20
	 damage(battle, target, calculate_damage(:ZENHEADBUTT))
	 attack_delta = rand(0..1)
	 escape_delta = rand(1..4)
	 catch_delta = rand(8..14)
	 make_angry(target, battle.battlers[0], attack_delta, escape_delta, catch_delta)
	 battle.runrate -= 1
	 
  end 
end 

class SafariBattle::Acts::Attack::FierceAttack < SafariBattle::Acts::Attack
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :FIERCEATTACK
    super(name, description, stamina_cost, consumable, extra_data)
  end 
  def can_add?
    enough_stamina? && $player.is_it_this_class?(:BLACKBELT, false)
  end
  
  def act(battle, target)
     return unless spend_stamina
     battle.pbDisplayPaused(_INTL("{1} lashed out, hitting {2} with all their force!", $player.name, target.pokemon.name))
     pbSEPlay("smeck")
	 move_damage = calculate_damage(:HEADLONGRUSH)
	 damage(battle, battle.battlers[0], target, move_damage)
	 damagePlayer((move_damage / 4).floor)
	 attack_delta = rand(8..14)
	 escape_delta = rand(2..7)
	 catch_delta = rand(8..14)
	 make_angry(target, attack_delta, escape_delta, catch_delta)
	 battle.runrate -= 1
  end 
end 

class SafariBattle::Acts::Attack::SpecialAttack < SafariBattle::Acts::Attack
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :SPECIALATTACK
    super(name, description, stamina_cost, consumable, extra_data)
  end 
  def can_add?
    enough_stamina? && $player.is_it_this_class?(:BLACKBELT, false)
  end
  
  def act(battle, target)
     return unless spend_stamina
     battle.pbDisplayPaused(_INTL("{1} hit a pose, before hitting {2} with their Special Attack!", $player.name, target.pokemon.name))
     pbSEPlay("smeck")
	 move_damage = calculate_damage(:HEADSMASH)
	 damage(battle, target, move_damage)
	 attack_delta = rand(8..14)
	 escape_delta = rand(8..14)
	 catch_delta = rand(0..2)
	 make_angry(target, battle.battlers[0], attack_delta, escape_delta, catch_delta)
	 battle.runrate -= 1
  end 
end 

class SafariBattle::Acts::Attack::Machete < SafariBattle::Acts::Attack
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :MACHETE
    super(name, description, stamina_cost, consumable, extra_data)
  end 

  def can_add?
    enough_stamina? && $bag.has?(@id)
  end
  
  def act(battle, target)
     return unless spend_stamina
     battle.pbDisplayPaused(_INTL("{1} slashes at {2} with their Machete!", $player.name, target.pokemon.name))
     pbSEPlay("sword")
	 move_damage = calculate_damage(:NIGHTSLASH)
	 damage(battle, target, move_damage)
	 attack_delta = rand(3..7)
	 escape_delta = rand(3..7)
	 catch_delta = rand(2..8)
	 make_angry(target, battle.battlers[0], attack_delta, escape_delta, catch_delta)
	 battle.runrate -= 1
  end 
end 

class SafariBattle::Acts::Attack::Stone < SafariBattle::Acts::Attack
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :STONE
    super(name, description, stamina_cost, consumable, extra_data)
  end 

  def can_add?
    enough_stamina? && $bag.quantity(@id) > 0
  end
  
  def act(battle, target)
     return unless spend_stamina
     battle.pbDisplayPaused(_INTL("{1} throws a Stone!", $player.name, target.pokemon.name))
     $bag.remove(:STONE,1)		
	 if battle.scene.pbThrowRock == true
	  move_damage = calculate_damage(:ROCKTHROW)
	  damage(battle, battle.battlers[0], target, move_damage)
	  attack_delta = -(rand(3..6))
	  escape_delta = rand(6..12)
	  catch_delta = -(rand(2..8))
	  make_angry(target, attack_delta, escape_delta, catch_delta)
	 battle.runrate -= 2
	 else
      battle.pbDisplayPaused(_INTL("The rock flew past {1}!", pkmn.name))
	 
	 end
  end 
end 

class SafariBattle::Acts::Defend::Rest < SafariBattle::Acts::Defend
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :REST
    super(name, description, stamina_cost, consumable, extra_data)

  end 

  def can_add?
    true
  end
  
  def act(battle, target)
  attack = target.attackFactor
  escape = target.escapeFactor
  calm   = target.catchFactor
     calm_higher = calm > attack + 30
	 if target.attackFactor > 10 && rand(255) < target.attackFactor && !calm_higher
      battle.pbDisplayPaused(_INTL("As {1} prepared to rest, {2} struck them!", $player.name, target.pokemon.name))
      pbSEPlay("normaldamage")
	  target.already_acted = true
	  move_damage = calculate_damage_pokemon(target.pokemon) 
	  damage(battle, target, battle.battlers[0], move_damage)
	  attack_delta = rand(12..20)
	  escape_delta = rand(10..18)
	  catch_delta = rand(8..12)
	   battle.runrate -= 5
	 
	 else
      battle.pbDisplayPaused(_INTL("{1} rested for a moment.", $player.name, target.pokemon.name))
      spend_stamina
	  if $player.playersaturation == 0.0
		 $player.playerfood -= (rand(5)+1).to_f
		 $player.playerwater -= (rand(5)+1).to_f
         $player.playerfood = 0.0 if $player.playerfood<0.0
		 $player.playerwater = 0.0 if $player.playerwater<0.0
	  else
		 $player.playersaturation -= (rand(5)+1).to_f
	  end
	  attack_delta = rand(5..8)
	  escape_delta = rand(5..8)
	  catch_delta = rand(5..8)
	  battle.runrate -= 1
	 end
	 make_aggressive(target, attack_delta, escape_delta, catch_delta)
  end 
end 

class SafariBattle::Acts::Defend::Block < SafariBattle::Acts::Defend
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :BLOCK
    super(name, description, stamina_cost, consumable, extra_data)

  end 

  def can_add?
    enough_stamina? && $player.is_it_this_class?(:BLACKBELT, false)
  end
  
  def act(battle, target)
     return unless spend_stamina
     battle.pbDisplayPaused(_INTL("{1} prepared to be hit!", $player.name, target.pokemon.name))
	 battle.battlers[0].endure = true 
	 attack_delta = rand(5..8)
	 escape_delta = rand(5..8)
	 catch_delta = rand(5..8)
	 make_aggressive(target, attack_delta, escape_delta, catch_delta)
  end 
end 

class SafariBattle::Acts::Defend::Counter < SafariBattle::Acts::Defend
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :COUNTER
    super(name, description, stamina_cost, consumable, extra_data)

  end 

  def can_add?
    enough_stamina? && $player.is_it_this_class?(:BLACKBELT, false)
  end
  
  def act(battle, target)
     return unless spend_stamina
     battle.pbDisplayPaused(_INTL("{1} prepared to attack back!", $player.name, target.pokemon.name))
	 battle.battlers[0].counter = true 
	 attack_delta = rand(7..20)
	 escape_delta = rand(1..4)
	 catch_delta = rand(1..8)
	 make_aggressive(target, attack_delta, escape_delta, catch_delta)
  end 
end 

class SafariBattle::Acts::Defend::Brace < SafariBattle::Acts::Defend
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :BRACE
    super(name, description, stamina_cost, consumable, extra_data)

  end 
  
  def act(battle, target)
     return unless spend_stamina
     battle.pbDisplayPaused(_INTL("{1} braced themselves!", $player.name, target.pokemon.name))
	 battle.battlers[0].braced = true 
	 attack_delta = rand(7..20)
	 escape_delta = rand(1..4)
	 catch_delta = rand(1..8)
	 make_aggressive(target, attack_delta, escape_delta, catch_delta)
  end 
end 

class SafariBattle::Acts::Defend::Run < SafariBattle::Acts::Defend
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :RUN
    super(name, description, stamina_cost, consumable, extra_data)

  end 
  
  def act(battle, target)
    if Input.press?(Input::CTRL) && $DEBUG
       pbSEPlay("Battle flee")
       battle.pbDisplayPaused(_INTL("You got away safely!"))
       battle.decision = 3
	   return
    end 
    return unless spend_stamina
  attack = target.attackFactor
  escape = target.escapeFactor
  calm   = target.catchFactor
     calm_higher = calm > attack + 30
	pkmn = target.pokemon
	should_attack = target.attackFactor > 10 && rand(255) < target.attackFactor && !calm_higher
	lets_go = target.escapeFactor > 90 && rand(255) < target.escapeFactor
	escapes = rand(100) <= battle.runrate
	escapes = true if calm >= 245
	escapes = true if attack < 10
	puts "Escapes: #{escapes} (#{battle.runrate})"
	injury = calculate_damage_pokemon(pkmn) 
	  target.already_acted = true
	if lets_go && escapes
       pbSEPlay("Battle flee")
       battle.pbDisplayPaused(_INTL("You got away safely!"))
       battle.decision = 3
	   return
	elsif escapes && should_attack
       pbSEPlay("Battle flee")
       battle.pbDisplayPaused(_INTL("While you were running away, {1} attacked!",pkmn.name)) 
       $player.damagePlayer(injury)
       pbSEPlay("normaldamage")
       battle.decision = 3
	   return
	elsif should_attack && !escapes 
       battle.pbDisplayPaused(_INTL("{1} leaps at you and bites you when you attempt to move!",pkmn.name)) 
       $player.damagePlayer(injury)
	  target.already_acted = true
	   attack_delta = rand(7..20)
	   escape_delta = rand(1..4)
	   catch_delta = rand(1..8)
	   battle.runrate -= 5
	elsif escapes && !should_attack
       pbSEPlay("Battle flee")
       battle.pbDisplayPaused(_INTL("You got away safely!"))
       battle.decision = 3
	   return
	elsif target.escapeFactor > 90
       battle.pbDisplayPaused(_INTL("{1} seems to want you to leave, but you can't see a way out!",pkmn.name)) 
	   attack_delta = -(rand(7..20))
	   escape_delta = rand(10..18)
	   catch_delta = rand(4..12)
	elsif target.attackFactor > 10 && !calm_higher
       battle.pbDisplayPaused(_INTL("Don't try it! {1} seems too jumpy, and is ready to lunge if you move!",pkmn.name)) 
	   attack_delta = rand(7..20)
	   escape_delta = rand(3..8)
	   catch_delta = rand(4..14)
	else
       battle.pbDisplayPaused(_INTL("You aren't sure if you can get out safely at the moment."))
	   attack_delta = rand(4..14)
	   escape_delta = rand(3..8)
	   catch_delta = rand(4..14)
	end 
	make_aggressive(target, attack_delta, escape_delta, catch_delta)
	battle.runrate += 4
  end 
end 

class SafariBattle::Acts::Defend::Pokemon < SafariBattle::Acts::Defend
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :POKEMON
    super(name, description, stamina_cost, consumable, extra_data)

  end 

  def can_add?
    enough_stamina? && $player.able_party.length>0
  end
  
  def act(battle, target)
   return unless spend_stamina
   value = battle.scene.pbShowCommands("Who do you want to send out?", $player.able_party.map { |pkmn| _INTL(pkmn.name) }, 0)
   if value < 0 
     battle.pbDisplayPaused(_INTL("{1} chose not to throw out a POKeMON.", $player.name, target.pokemon.name))
   else 
     battle.thrown_pokemon = value
     battle.decision = 5
   end 
  end 
end 



class SafariBattle::Acts::Appeal::Soothe < SafariBattle::Acts::Appeal
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :SOOTHE
    super(name, description, stamina_cost, consumable, extra_data)

  end 
  
  
  def act(battle, target)
     return unless spend_stamina
	 if target.approached==false
     battle.pbDisplayPaused(_INTL("{1} crouches down and calmly encourages {2} to approach.", $player.name, target.pokemon.name))
	 battle.battlers[0].approach_offer = true 
	 
	 attack_delta = rand(1..12)
	 escape_delta = rand(1..12)
	 catch_delta = rand(1..8)
	 make_passive(target, attack_delta, escape_delta, catch_delta)
	 else
     battle.pbDisplayPaused(_INTL("{1} pets {2} gently. After a moment, {1} backed away to give space.", $player.name, target.pokemon.name))
	 
	 attack_delta = rand(10..20)
	 escape_delta = rand(10..20)
	 catch_delta = rand(8..12)
	 make_passive(target, attack_delta, escape_delta, catch_delta)
	 target.approached=false
	 end 
	 battle.runrate += 1
  end 
end 

class SafariBattle::Acts::Appeal::Groom < SafariBattle::Acts::Appeal
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :GROOM
    super(name, description, stamina_cost, consumable, extra_data)

  end 

  def can_add?
    enough_stamina? && !$player.is_it_this_class?(:BREEDER, false) && $bag.has?(:POKEMONBRUSH)
  end
  
  def act(battle, target)
    if target.approached
     return unless spend_stamina
     battle.pbDisplayPaused(_INTL("{1} takes out a brush and begins to groom {2}.", $player.name, target.pokemon.name))
	 target.pokemon.changeLoyalty("groom")
	 attack_delta = rand(10..20)
	 escape_delta = rand(10..20)
	 catch_delta = rand(10..35)
	 make_passive(target, attack_delta, escape_delta, catch_delta)
	 battle.runrate += 5
	
	else
     battle.pbDisplayPaused(_INTL("{1} is too far away, and too nervous too allow you to do that.", target.pokemon.name))
	end
  end 
end 

class SafariBattle::Acts::Appeal::BreederGroom < SafariBattle::Acts::Appeal
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :GROOM
    super(name, description, stamina_cost, consumable, extra_data)

  end 

  def can_add?
    enough_stamina? && $player.is_it_this_class?(:BREEDER, false) && $bag.has?(:POKEMONBRUSH)
  end
  
  def act(battle, target)
    if target.approached
     return unless spend_stamina
     battle.pbDisplayPaused(_INTL("{1} takes out a brush and begins to groom {2}.", $player.name, target.pokemon.name))
	 target.pokemon.changeLoyalty("groom")
	 target.pokemon.changeLoyalty("groom") #Yes, this is intentional. It just takes a lot to write a new loyalty and happiness method.
	 attack_delta = rand(20..40)
	 escape_delta = rand(20..40)
	 catch_delta = rand(20..70)
	 make_passive(target, attack_delta, escape_delta, catch_delta)
	 battle.runrate += 10
	
	else
     battle.pbDisplayPaused(_INTL("{1} is too far away, and too nervous too allow you to do that.", target.pokemon.name))
	end
  end 
end 



class SafariBattle::Acts::Appeal::Bait < SafariBattle::Acts::Appeal
  def initialize(name, description, stamina_cost = 0, consumable = false, extra_data = nil)
    @id = :BAIT
    super(name, description, stamina_cost, consumable, extra_data)
  end 

  def can_add?
    enough_stamina? && $bag.quantity(@id) > 0
  end
  
  def act(battle, target)
     return unless spend_stamina
     battle.pbDisplayPaused(_INTL("{1} crouched down, and threw some bait at the {2}.", $player.name, target.pokemon.name))
     $bag.remove(:BAIT,1)		
	 if battle.scene.pbThrowBait == true
      battle.pbDisplayPaused(_INTL("{1} looks at the bait curiously, before...", pkmn.name))
	  if target.catchFactor > 10 && rand(2)==0
        battle.pbDisplayPaused(_INTL("{1} consumed the bait.", pkmn.name))
	    attack_delta = rand(1..12)
	    escape_delta = rand(1..8)
	    catch_delta = rand(10..20)
	    battle.runrate *= 2
	  
	  else
	   if target.attackFactor > 90
        battle.pbDisplayPaused(_INTL("{1} smushed the bait.", pkmn.name))
	    attack_delta = -(rand(4..12))
	    escape_delta = rand(1..8)
	    catch_delta = -(rand(5..15))
	  target.already_acted = true
	   elsif target.escapeFactor > 90
        battle.pbDisplayPaused(_INTL("{1} fled from the bait.", pkmn.name))
	    attack_delta = rand(1..12)
	    escape_delta = -(rand(6..12))
	    catch_delta = -(rand(5..15))
	  target.already_acted = true
	   else
        battle.pbDisplayPaused(_INTL("{1} ignored the bait.", pkmn.name))
	    attack_delta = -(rand(1..4))
	    escape_delta = -(rand(1..4))
	    catch_delta = -(rand(5..15))
	  target.already_acted = true
	   end 
	  end
      make_passive(target, attack_delta, escape_delta, catch_delta)
	 else
      battle.pbDisplayPaused(_INTL("The bait flew past {1}!", pkmn.name))
	 
	 end
  end 
end 

class SafariBattle::Acts::Catch::Ball < SafariBattle::Acts::Catch
  def initialize(name, description, stamina_cost, consumable, extra_data)
    @id = extra_data.id
    super(name, description, stamina_cost, consumable, extra_data)
  end 

  def can_add?
    enough_stamina? && $bag.quantity(@extra_data) > 0 && !pbBoxesFull?
  end
  
  def act(battle, target)
     return unless spend_stamina
     $bag.remove(@extra_data,1)
	 pkmn = target.pokemon
	 anger = target.attackFactor
	 anxiety = target.escapeFactor
	 affection = target.catchFactor 
	 pkmn.mood.set_values(anger, anxiety, affection)
     if battle.scene.pbThrowPokeBall(1, @extra_data, target.catchFactor, true)
	  if @caughtPokemon.length > 0
        battle.pbRecordAndStoreCaughtPokemon
        battle.decision = 4
	  end 
	 else
      battle.pbDisplayPaused(_INTL("{1} looks spooked!", pkmn.name))
	  attack_delta = rand(10..20)
	  escape_delta = rand(10..20)
	  catch_delta = rand(10..20)
	  make_scared(target, attack_delta, escape_delta, catch_delta)
	  battle.runrate -= 4
	  
	 end
  end 
end 