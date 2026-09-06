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
  
  # @defenders' exact meaning (reinforcement Pokemon? player-brought
  # allies?) isn't pinned down here - leaving as-is since it's already
  # consumed elsewhere.
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
    return unless active?
    @simulation&.update(delta)
  end

  # Called when the player walks onto this raid's map while it's ongoing.
  # `resume_manual` (below) already flips state to :manual, which makes
  # `update` above stop advancing the abstract sim - good, since once the
  # player is standing here we don't want the "offscreen" simulation and
  # the real on-map fight disagreeing about who's still alive.
  #
  # What's still missing is turning the *current* simulation state into
  # actual map events, so I've left it as a stub rather than guess at the
  # event/map API. Roughly, this needs to:
  #   1. simulation.simulated_enemies.select(&:alive?) - these are the
  #      attackers that need an on-map presence.
  #   2. For each, its `.target` (set during the background sim) is the
  #      SimulatedPokemon/SimulatedBlock it's currently fighting.
  #      `.target.object` gets back to the real Pokemon/block, and from
  #      there to whatever event represents it on the map, so the
  #      attacker can be spawned near it.
  #   3. Decide a fallback spawn spot for attackers whose `.target` is
  #      nil (nothing left alive to fight, or no turn has run yet).
  #   4. Keep a reverse lookup (attacker id -> map event) somewhere so
  #      the on-map battle system can find "which SimulatedPokemon is
  #      this event" and so results get written back to the right
  #      sprite when the raid finishes.
  def spawn_events_for_map
    raise NotImplementedError, "hook up map event spawning here"
  end
end