class SimulatedBlock
  attr_reader :block

  attr_accessor :hp
  attr_reader :totalhp
  attr_reader :level
  attr_reader :stats
  attr_reader :moves
  attr_reader :status
  attr_reader :target
  attr_reader :defeated_pokemon

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
  def alive?
    @hp > 0
  end 

  def id
    return @id
  end
  def dead?
   !alive?
  end
  
  def choose_action
    return nil
  end 

  def target=(value)
    @target = nil
  end 
  
  def status=(value)
    @status = :NONE 
  end 
  
  def take_damage(amount)
    @hp = [@hp - amount, 0].max
  end
  
  def heal(amount)
    @hp = [@hp + amount, @totalhp].min
  end
  
  def apply
    @block.hp = @hp if @block.respond_to?(:hp=)
  end
  
end

class SimulatedPokemon
  attr_reader :pokemon

  attr_accessor :hp
  attr_reader :totalhp
  attr_reader :level
  attr_reader :stats
  attr_reader :moves
  attr_reader :status
  attr_accessor :target
  attr_reader :defeated_pokemon

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
  def alive?
    @hp > 0
  end 
  
  def id
    return @id
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
  
  def status=(value)
    @status = value 
  end 
  
  def choose_action
   moves = @moves.select { |move| move.pp > 0 && move.base_damage > 0 }
   move = moves.sample
   return nil unless move 
   SimulatedAction.new(move)
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

  def execute(user, target)
    @move.pp -= 1
    if @move.base_damage <= 0
      return SimulatedCombatResult.new(self, user, 0)
    end
    damage = calculate_damage(user, target)
    target.take_damage(damage)
    user.defeated_pokemon << target if target.dead?
    return SimulatedCombatResult.new(self, user, damage, nil, target.dead?)
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