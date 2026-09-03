class CombatSimulation
  TURN_TIME = 30
  
  attr_reader :simulated_allies
  attr_reader :simulated_enemies
  attr_reader :simulated_other
  attr_reader :turn_timer
  attr_reader :turn_side
  attr_reader :elapsed_time
  attr_reader :results
  attr_reader :last_turn_results

  def initialize(allies, enemies, other = nil)
    @allies  = allies
    @enemies = enemies
	@other = other || []
	@next_id = 0
	@simulated_allies = convert_to_simpoke(@allies)
	@simulated_enemies = convert_to_simpoke(@enemies)
	@simulated_other = convert_to_simother(@other)

    @turn_timer = 0
    @turn_side = :allies
	@elapsed_time = 0
	@results = []
	@last_turn_results = []
  end
  def combatants
   [
    *@simulated_allies,
    *@simulated_enemies,
    *@simulated_other
   ]
  end

  def allies_alive?
    defender_side.any?(&:alive?)
  end

  def enemies_alive?
    @simulated_enemies.any?(&:alive?)
  end
  
  def finished?
    !allies_alive? || !enemies_alive?
  end

  def convert_to_simpoke(array)
   return [] if array.nil?
   array.map { |pkmn| SimulatedPokemon.new(pkmn, next_id) }
  end 
  
  def convert_to_simother(array)
   return [] if array.nil?
   array.map { |block| SimulatedBlock.new(block, next_id) }
  end 

  def next_id
   id = @next_id
   @next_id += 1
   id
  end
  
  def update(delta)
    @elapsed_time += delta
    @turn_timer += delta
    return if @turn_timer < TURN_TIME
    while @turn_timer >= TURN_TIME
     @turn_timer -= TURN_TIME
     process_turn
    end
  end
  
  def defender_side
    [*@simulated_allies,*@simulated_other]
  end 
  
  def process_turn
    
	@last_turn_results = []
    if @turn_side == :allies
      simulate_team_turn(@simulated_allies, @simulated_enemies)
      @turn_side = :enemies
    else
      simulate_team_turn(@simulated_enemies, defender_side)
      @turn_side = :allies
    end
  end

def simulate_team_turn(team, targets)
  team.each do |attacker|
    next unless attacker.alive?

    target = choose_target(attacker, targets)
    next unless target
    action = attacker.choose_action(target)
    next unless action
    result = action.execute(attacker, target)
    @results << result
	@last_turn_results << result 
  end
end


def choose_target(attacker, targets)
  return attacker.target if attacker.target&.alive?
  
  valid_targets = targets.select(&:alive?)
  attacker.target = valid_targets.sample
end


  
  def apply_simulation
   combatants.each(&:apply)
  end 
end


