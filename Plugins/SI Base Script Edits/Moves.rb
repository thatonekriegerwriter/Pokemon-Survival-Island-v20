module GameData
  class Move
    attr_reader :overworld_state
    attr_reader :overworld_range
    attr_reader :num_hits
    attr_reader :attack_time
    GameData::Move::SCHEMA["ExecutionType"] = [:execution_type, "s"] if !GameData::Move::SCHEMA["ExecutionType"]
    GameData::Move::SCHEMA["OverworldState"] = [:overworld_state, "s"] if !GameData::Move::SCHEMA["OverworldState"]
    GameData::Move::SCHEMA["OverworldRange"] = [:overworld_range, "u"] if !GameData::Move::SCHEMA["OverworldRange"]
    GameData::Move::SCHEMA["NumHits"] = [:num_hits, "u"] if !GameData::Move::SCHEMA["NumHits"]
    GameData::Move::SCHEMA["AttackTime"] = [:attack_time, "u"] if !GameData::Move::SCHEMA["AttackTime"]
    
    alias original_move_init initialize
    def initialize(hash)
	  original_move_init(hash)
	  @execution_type = hash[:execution_type]
	  @overworld_state = hash[:overworld_state] || "None"
	  @overworld_range = hash[:overworld_range] || 3
	  @num_hits = hash[:num_hits] || 1
	  @attack_time = hash[:attack_time] || 60
	end 
	
	def beam_time
	  @attack_time
	end 
	
	def execution_type
	 return @execution_type if @execution_type
	 case @category
	 when 0
	   return "RushDownMove"
	 when 1
	   return "ProjectileMove"
	 when 2
	   return "DistanceIgnorantMove"
	 end
	end 
    
	
	def projectile?
	 ["ProjectileMove", "MultiHitProjectileMove", "PiercingProjectileMove", "MultiHitPiercingProjectileMove"].includes?(@execution_type)
	end
	
	def cardinal?
	 ["CardinalMove", "MultiHitCardinalMove"].includes?(@execution_type)
	end
	
	def rushdown?
	 ["RushDownMove", "MultiHitRushdownMove", "RushDownRecoilMove", "RushDownKnockbackMove", "RushDownDisplaceMove", "RushDownPushMove"].includes?(@execution_type)
    end
	
	def ranged_target?
	 ["RangedTargetMove", "DistanceIgnorantMove", "DelayedDistanceIgnorantMove", "InstantTransmissionMove", "InstantTransmissionRandomMove"].includes?(@execution_type)
	end 
	
	def surrounding_user?
	 ["AreaSurroundingUserAuraMove", "AreaSurroundingUserSightlineMove", "AreaSurroundingUserMove"].includes?(@execution_type)
	end
	
	def beam?
	 ["BeamMove"].includes?(@execution_type)
	end
	
	def cone?
	 ["ConeMove"].includes?(@execution_type)
	end
	
	def arc?
	 ["ArcMove", "ArcExplodeMove"].includes?(@execution_type)
	end
	
	def orbiting?
	 ["RandomOrbitingMove", "OrbitingMove"].includes?(@execution_type)
	end 
	
	def summoning?
	 ["TrappedMove", "SummonMove"].includes?(@execution_type)
	end
	
	def disappearance?
	 ["DisappearanceMove"].includes?(@execution_type)
	end

	def has_secondary_effect?
	  @effect_chance > 0 
	end
  end
end 

class Pokemon
  class Move
    def execution_type;  return GameData::Move.get(@id).execution_type;  end
    def overworld_state;  return GameData::Move.get(@id).overworld_state;  end
    def overworld_range;  return GameData::Move.get(@id).overworld_range;  end
    def num_hits;  return GameData::Move.get(@id).num_hits;  end
    def beam_time;  return GameData::Move.get(@id).attack_time;  end
    def attack_time;  return GameData::Move.get(@id).attack_time;  end
    def physical?;  return GameData::Move.get(@id).physical?;  end
    def special?;  return GameData::Move.get(@id).special?;  end
    def has_secondary_effect?;  return GameData::Move.get(@id).has_secondary_effect?;  end
	
	
    def projectile?;  return GameData::Move.get(@id).projectile?;  end
    def cardinal?;  return GameData::Move.get(@id).cardinal?;  end
    def rushdown?;  return GameData::Move.get(@id).rushdown?;  end
    def ranged_target?;  return GameData::Move.get(@id).ranged_target?;  end
    def surrounding_user?;  return GameData::Move.get(@id).surrounding_user?;  end
    def beam?;  return GameData::Move.get(@id).beam?;  end
    def cone?;  return GameData::Move.get(@id).cone?;  end
    def arc?;  return GameData::Move.get(@id).arc?;  end
    def orbiting?;  return GameData::Move.get(@id).orbiting?;  end
    def summoning?;  return GameData::Move.get(@id).summoning?;  end
    def disappearance?;  return GameData::Move.get(@id).disappearance?;  end
  end
end 