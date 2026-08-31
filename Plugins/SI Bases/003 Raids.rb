class Raid
  attr_reader :base_id
  attr_accessor :attackers
  attr_accessor :defenders

  attr_reader :state
  attr_reader :started_at
  attr_reader :simulation

  def initialize(base_id)
    @base_id        = base_id
    @attackers   = []
    @defenders   = []
    @simulation  = nil

    @state       = :preparing #active, interrupted, manual, cleanup, finished
    @started_at  = nil
	@last_updated = nil
  end
  def active?
    @state == :active
  end
  def activate
    return if active?
    @state = :active
    @started_at  = pbGetTimeNow.to_i
	new_simulation
  end

  def interrupt
    @state = :interrupted
  end

  def resume_manual
    @state = :manual
  end

  def finish
    @state = :finished
	@simulation&.apply_simulation
  end
  
  def base
    $bases[base_id]
  end
  def pokemon
    base.pokemon
  end
  
  def full_defenders 
    blockdata + pokemon + @defenders
  end 
  
  def blockdata
    base.blockdata
  end
  
  def finished?
   !!@simulation&.finished?
  end
  
  def cleanup
   finish
   @simulation = nil
  end 
  
  def new_simulation
    @simulation = CombatSimulation.new(pokemon + @defenders, @attackers, blockdata)
  end 
  
  def update(delta)
    @simulation&.update(delta)
  end
end