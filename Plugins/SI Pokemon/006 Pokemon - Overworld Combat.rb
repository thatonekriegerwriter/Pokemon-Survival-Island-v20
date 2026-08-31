class Pokemon
  attr_accessor :attacking
  attr_accessor :random_attacking
  attr_accessor :attack_mode
  attr_accessor :autobattle
  attr_accessor :overworld_targets
  attr_accessor :hits
  attr_accessor :iframes
  attr_accessor :moves2
  attr_accessor :stages
  attr_accessor :effects
  attr_accessor :status_turns

  alias _SI_Pokemon_OV_init initialize
  def initialize(*args)
    _SI_Pokemon_OV_init(*args)
    @status_turns            = 0 
    @attacking     = false     # Text input mode (0=PSID, 1=PSIA)
    @moves2     = []     # Text input mode (0=PSID, 1=PSIA)(*args)
    @random_attacking = nil
    @attack_mode = nil
    @autobattle = nil
    @hits = 0
    @stages      = getStages
    @iframes     = 0
    @overworld_targets = {}
	@active_state = OverworldCombat::PokemonActiveState.new
  end

   def active_state
    @active_state = OverworldCombat::PokemonActiveState.new if @active_state.nil?
	@active_state 
   end 
   def effects
   if @effects.nil?
   @effects = [] 
   $PokemonGlobal.ov_combat.pbInitEffects(self)
   end
   return @effects
   end


   def iframes
    @iframes = 0 if !@iframes
    return @iframes
   end

   
   def stages
   @stages = getStages if @stages.nil?
   return @stages
   end  

     def getStages
    return {
	  :ATTACK => 0,
	  :DEFENSE => 0,
	  :SPECIAL_ATTACK => 0,
	  :SPECIAL_DEFENSE => 0,
	  :SPEED => 0,
	  :ACCURACY => 0,
	  :CRIT => 0
			}
   
   end
   def statusCount
	return @status_turns
   end
   def status_turns
    @status_turns = 0 if @status_turns.nil?
	return @status_turns
   end   
   def hits
    @hits = 0 if @hits.nil?
	return @hits
   end

   def damage(amount)
    pbOverworldCombat.damageTarget(self, amount)
   end 
end 