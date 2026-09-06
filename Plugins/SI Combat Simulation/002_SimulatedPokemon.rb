# Shared interface for anything CombatSimulation can treat as a
# combatant (see CombatSimulation#combatants). Both SimulatedBlock and
# SimulatedPokemon relied on identical copies of all of this; pulled out
# to one place so the expected interface is explicit and doesn't drift
# between the two.
module SimulatedCombatant
  attr_reader :id
  attr_reader :totalhp
  attr_reader :level
  attr_reader :stats
  attr_reader :moves
  attr_reader :status
  attr_reader :defeated_pokemon

  def alive?
    @hp > 0
  end

  def dead?
    !alive?
  end

  def take_damage(amount)
    @hp = [@hp - amount, 0].max
  end

  def heal(amount)
    @hp = [@hp + amount, @totalhp].min
  end
end

class SimulatedBlock
  include SimulatedCombatant

  attr_reader :block
  attr_accessor :hp
  attr_reader :target

  def initialize(block, id)
    @block = block
	@id      = id
    @hp      = 100
	@totalhp = @hp
    @status  = :NONE
    @level  = 0
    @stats  = [0, 0, 0, 0, 0]
    @moves  = []
	@target = nil
	@defeated_pokemon = []
  end

  def object
    @block
  end
  def hasType?(type)
    false
  end 
  def types
    []
  end 
  
  def choose_action(target)
    return nil
  end 

  # Blocks (turrets/walls) can't be targeted for follow-up or given a
  # status - these are forced no-ops rather than real writers on purpose,
  # since nothing about a block is meant to change here.
  def target=(value)
    @target = nil
  end 
  
  def status=(value)
    @status = :NONE 
  end 
  
  def apply
    @block.hp = @hp if @block.respond_to?(:hp=)
  end
  
end

class SimulatedPokemon
  include SimulatedCombatant

  attr_reader :pokemon
  attr_accessor :hp
  attr_accessor :target

  def initialize(pokemon, id)
    @pokemon = pokemon
	@id      = id
    @hp      = pokemon.hp
	@totalhp = pokemon.totalhp
    @status  = pokemon.status
    @level  = pokemon.level
    @stats  = {
  attack: pokemon.attack,
  defense: pokemon.defense,
  spatk: pokemon.spatk,
  spdef: pokemon.spdef,
  speed: pokemon.speed
}
    @moves  = pokemon.totalMoves.map(&:clone)
	@target = nil
	@defeated_pokemon = []
  end
  
  def object
    @pokemon
  end
  def types
    @pokemon.types
  end 
  def hasType?(type)
    @pokemon.hasType?(type)
  end 
  
  def status=(value)
    @status = value 
  end 
  
  def choose_action(target)
    AdventureBattleAI.choose_action(self, target)
  end
  
  def apply
    @pokemon.totalMoves.each_with_index do |move, index|
      next unless @moves[index]
	  move.pp = @moves[index].pp
	end 
    @pokemon.hp = @hp if @pokemon.respond_to?(:hp=)
    @pokemon.status = @status if @pokemon.respond_to?(:status=)
  end
  
end

class SimulatedAction
  attr_reader :move

  def initialize(move)
    @move = move
  end

  STATUS_FUNCTION_CODES = {
    "SleepTarget"    => :SLEEP,
    "ParalyzeTarget" => :PARALYSIS,
    "PoisonTarget"   => :POISON,
    "BurnTarget"     => :BURN,
    "FreezeTarget"   => :FROZEN
  }.freeze

  # move.base_damage is used directly as the flat amount here rather than
  # run through calculate_damage - these move powers aren't a normal
  # power stat, so running them through the level/attack/defense formula
  # would give a meaningless result.
  FIXED_DAMAGE_FUNCTION_CODES = {
    "FixedDamage20" => ->(_user, _target) { 20 },
    "FixedDamage40" => ->(_user, _target) { 40 },
    "FixedDamageHalfTargetHP" => ->(_user, target) { (target.hp / 2.0).round },
    "FixedDamageUserLevel"    => ->(user, _target) { user.level }
  }.freeze

  def execute(user, target)
    @move.pp -= 1

    case @move.function_code
    when "GiveUserStatusToTarget"
      return give_user_status_to_target(user, target)
    when *STATUS_FUNCTION_CODES.keys
      return inflict_status(user, target, STATUS_FUNCTION_CODES[@move.function_code])
    when "RemoveTargetItem"
      return remove_target_item(user, target)
    when "DestroyTargetBerryOrGem"
      return remove_target_item(user, target) # TODO: restrict this to berries/gems specifically once we settle on the Item API check for that
    when "HealUserHalfOfTotalHP"
      user.heal((user.totalhp / 2.0).round)
      return SimulatedCombatResult.new(self, user, 0)
    when *FIXED_DAMAGE_FUNCTION_CODES.keys
      amount = FIXED_DAMAGE_FUNCTION_CODES[@move.function_code].call(user, target)
      return apply_damage(user, target, amount)
    end

    if @move.base_damage <= 0
      return SimulatedCombatResult.new(self, user, 0)
    end
    damage = calculate_damage(user, target)
    return apply_damage(user, target, damage)
  end

  def apply_damage(user, target, damage)
    damage = [damage, target.hp].min
    target.take_damage(damage)
    user.defeated_pokemon << target if target.dead?
    SimulatedCombatResult.new(self, user, damage, nil, target.dead?)
  end

  def inflict_status(user, target, status)
    return SimulatedCombatResult.new(self, user, 0) if target.status != :NONE
    target.status = status
    SimulatedCombatResult.new(self, user, 0, target.status)
  end

  # Psycho Shift-style: passes the USER's current status onto the target,
  # rather than a fixed status of its own.
  def give_user_status_to_target(user, target)
    return SimulatedCombatResult.new(self, user, 0) if user.status == :NONE || target.status != :NONE
    target.status = user.status
    SimulatedCombatResult.new(self, user, 0, target.status)
  end

  def remove_target_item(user, target)
    if target.object.respond_to?(:item) && target.object.respond_to?(:item=) && target.object.item
      target.object.item = nil
    end
    SimulatedCombatResult.new(self, user, 0)
  end
  def type_multiplier(target)
  value = Effectiveness.calculate(
    @move.type,
    *target.types
  )

  return 0.0 if Effectiveness.ineffective?(value)

  value.to_f / Effectiveness::NORMAL_EFFECTIVE
  end
  def calculate_damage(user, target)
   power = @move.base_damage
   type = @move.type
   level = user.level
   offensive_stat = @move.category == :physical ? :attack : :spatk
   defensive_stat = @move.category == :physical ? :defense : :spdef

   attack = [user.stats[offensive_stat], 1].max
   defense = [target.stats[defensive_stat], 1].max
       multipliers = {
      # base_damage_multiplier/attack_multiplier/defense_multiplier are
      # placeholders for a later hook (abilities/items/etc.) - only
      # final_damage_multiplier is actually applied below right now.
      :base_damage_multiplier  => 1.0,
      :attack_multiplier       => 1.0,
      :defense_multiplier      => 1.0,
      :final_damage_multiplier => 1.0
    }
   damage = ((((2 * level / 5 + 2) * power * attack / defense) / 50) + 2)
   if type && user.hasType?(type)
        multipliers[:final_damage_multiplier] *= 1.5
   end 
    
    multipliers[:final_damage_multiplier] *= type_multiplier(target)
	result = (damage * multipliers[:final_damage_multiplier]).floor
   return result 
  end
end


class SimulatedCombatResult
  attr_reader :user
  attr_reader :action
  attr_reader :damage
  attr_reader :status
  attr_reader :fainted

  def initialize(action, user, damage, status = nil, fainted = false)
    @action = action
	@user   = user
    @damage = damage
    @status = status
    @fainted = fainted
  end
end