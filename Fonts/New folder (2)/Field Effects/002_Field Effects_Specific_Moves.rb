#============================================================================
#
#
#
#============================================================================

#		FIELD EFFECTS IN ORDER OF NUMBER
#
#	1|	Example Field

#==============================================================
# 				    MOVE - SPECIFIC CHANGES
#==============================================================

#============================
# DEFEND ORDER [ EXAMPLE FIELD]
#============================
class Battle::Move::RaiseUserDefSpDef1 < Battle::Move::MultiStatUpMove
  def initialize(battle, move)
    super
	if @id == :DEFENDORDER 
	  if $game_temp.fieldEffectsBg == 1 # Example Field
       @statUp = [:DEFENSE,2,:SPECIAL_DEFENSE,2] 
	  end
	else
	   @statUp = [:DEFENSE,1,:SPECIAL_DEFENSE,1]
	end
  end
end

#============================
# HEAL ORDER [ EXAMPLE FIELD]
#============================
class Battle::Move::HealUserHalfOfTotalHP < Battle::Move::HealingMove
  def pbHealAmount(user)
	if @id == :HEALORDER 
		if $game_temp.fieldEffectsBg == 1 # Example Field
			return (user.totalhp*0.66).round
		end
	else
		return (user.totalhp/2.0).round
	end
  end
end

#============================
# WOOD HAMMER [ EXAMPLE FIELD]
#============================
class Battle::Move::RecoilThirdOfDamageDealt < Battle::Move::RecoilMove
  def pbRecoilDamage(user, target)
	return if @id == :WOODHAMMER && ($game_temp.fieldEffectsBg == 2 && $game_temp.terrainEffectsBg == 1) # Forest + Grassy Overlay
    return (target.damageState.totalHPLost / 3.0).round 
  end
  
  def pbAdditionalEffect(user, target)
    if @id == :WOODHAMMER
		if $game_temp.fieldEffectsBg == 1 # Example Field
		   user.pbBurn(user) if user.pbCanBurn?(user, false, self)
		end
	end
  end
end

#============================
# FOREST'S CURSE [ EXAMPLE FIELD ]
#============================
class Battle::Move::AddGrassTypeToTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    if !GameData::Type.exists?(:GRASS) || target.pbHasType?(:GRASS) || !target.canChangeType?
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    target.effects[PBEffects::Type3] = :GRASS
    typeName = GameData::Type.get(:GRASS).name
    @battle.pbDisplay(_INTL("{1} transformed into the {2} type!", target.pbThis, typeName))
	case $game_temp.fieldEffectsBg
		when 1 # Example Field
		  target.effects[PBEffects::LeechSeed] = user.index
          @battle.pbDisplay(_INTL("{1} was seeded!",target.pbThis))
	end
  end
end

#===============================================================================
# GRASSY GLIDE [GRASSY TERRAIN]
#===============================================================================
class Battle::Move::HigherPriorityInGrassyTerrain < Battle::Move
  def pbPriority(user)
    ret = super					# Grassy Terrain
    ret += 1 if $game_temp.terrainEffectsBg == 1 && user.affectedByTerrain?
    return ret
  end
end

#===============================================================================
# MISTY EXPLOSION [MISTY TERRAIN]
#===============================================================================
class Battle::Move::UserFaintsPowersUpInMistyTerrainExplosive < Battle::Move::UserFaintsExplosive
  def pbBaseDamage(baseDmg, user, target)
    baseDmg = baseDmg * 3 / 2 if $game_temp.terrainEffectsBg == 2 # Misty Terrain
    return baseDmg
  end
end

#===============================================================================
# RISING VOLTAGE [ELECTRIC TERRAIN]
#===============================================================================
class Battle::Move::DoublePowerInElectricTerrain < Battle::Move
  def pbBaseDamage(baseDmg, user, target)
    baseDmg *= 2 if $game_temp.terrainEffectsBg == 3 && target.affectedByTerrain?
    return baseDmg
  end
end

#===============================================================================
# EXPANDING FORCE [PSYCHIC TERRAIN]
#===============================================================================
class Battle::Move::HitsAllFoesAndPowersUpInPsychicTerrain < Battle::Move
  def pbTarget(user)
    if $game_temp.terrainEffectsBg == 4 && user.affectedByTerrain? # Psychic Terrain
      return GameData::Target.get(:AllNearFoes)
    end
    return super
  end

  def pbBaseDamage(baseDmg, user, target)
    if $game_temp.terrainEffectsBg == 4 && user.affectedByTerrain? # Psychic Terrain
      baseDmg = baseDmg * 3 / 2
    end
    return baseDmg
  end
end

#===============================================================================
# TERRAIN PULSE [ALL TERRAINS]
#===============================================================================
class Battle::Move::TypeAndPowerDependOnTerrain < Battle::Move
  def pbBaseDamage(baseDmg, user, target)
    baseDmg *= 2 if $game_temp.terrainEffectsBg != 0 && user.affectedByTerrain?
    return baseDmg
  end

  def pbBaseType(user)
    ret = :NORMAL
    case $game_temp.terrainEffectsBg
    when 1 # Grassy Terrain
      ret = :GRASS if GameData::Type.exists?(:GRASS)
	when 2 # Misty Terrain
      ret = :FAIRY if GameData::Type.exists?(:FAIRY)
	when 3 # Electric Terrain
      ret = :ELECTRIC if GameData::Type.exists?(:ELECTRIC)
	when 4 # Psychic Terrain
      ret = :PSYCHIC if GameData::Type.exists?(:PSYCHIC)
	end
    return ret
  end

  def pbShowAnimation(id, user, targets, hitNum = 0, showAnimation = true)
    t = pbBaseType(user)
    hitNum = 1 if t == :ELECTRIC   # Type-specific anims
    hitNum = 2 if t == :GRASS
    hitNum = 3 if t == :FAIRY
    hitNum = 4 if t == :PSYCHIC
    super
  end
end

#============================
# NATURE POWER [ ALL FIELDS]
#============================
class Battle::Move::UseMoveDependingOnEnvironment < Battle::Move
  def callsAnotherMove?; return true; end

  def pbOnStartUse(user, targets)
    # NOTE: It's possible in theory to not have the move Nature Power wants to
    #       turn into, but what self-respecting game wouldn't at least have Tri
    #       Attack in it?
    @npMove = :TRIATTACK
	case $game_temp.fieldEffectsBg
       when 1 # Example Field
           @npMove = :WOODHAMMER if GameData::Move.exists?(:WOODHAMMER)
	else
		case $game_temp.terrainEffectsBg
		when 1 # Grassy Terrain
		  @npMove = :ENERGYBALL if GameData::Move.exists?(:ENERGYBALL)
		when 2 # Misty Terrain 
		  @npMove = :MISTBALL if GameData::Move.exists?(:MISTBALL)
		when 3 # Electric Terrain
		  @npMove = :THUNDERBOLT if GameData::Move.exists?(:THUNDERBOLT)
		when 4 # Psychic Terrain
		  @npMove = :PSYCHIC if GameData::Move.exists?(:PSYCHIC)
		end
    end
  end

  def pbEffectAgainstTarget(user, target)
    @battle.pbDisplay(_INTL("{1} turned into {2}!", @name, GameData::Move.get(@npMove).name))
    user.pbUseMoveSimple(@npMove, target.index)
  end
end

#============================
# CAMOUFLAGE [ ALL FIELDS]
#============================
class Battle::Move::SetUserTypesBasedOnEnvironment < Battle::Move
  def canSnatch?; return true; end

  def pbMoveFailed?(user, targets)
    if !user.canChangeType?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    @newType = :NORMAL
    checkedTerrain = false
    case $game_temp.terrainEffectsBg
		when 1 # Grassy Terrain
		  if GameData::Type.exists?(:GRASS)
			@newType = :GRASS
			checkedTerrain = true
		  end
		when 2 # Misty Terrain
		  if GameData::Type.exists?(:FAIRY)
			@newType = :FAIRY
			checkedTerrain = true
		  end
		when 3 # Electric Terrain
		  if GameData::Type.exists?(:ELECTRIC)
			@newType = :ELECTRIC
			checkedTerrain = true
		  end
		when 4 # Psychic Terrain
		  if GameData::Type.exists?(:PSYCHIC)
			@newType = :PSYCHIC
			checkedTerrain = true
		  end
    end
	if !checkedTerrain
      case $game_temp.fieldEffectsBg
        when 1 # Example Field
          @newType = :BUG
      end
    end
    @newType = :NORMAL if !GameData::Type.exists?(@newType)
    if !GameData::Type.exists?(@newType) || !user.pbHasOtherType?(@newType)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbChangeTypes(@newType)
    typeName = GameData::Type.get(@newType).name
    @battle.pbDisplay(_INTL("{1}'s type changed to {2}!", user.pbThis, typeName))
  end
end

#============================
# SECRET POWER [ ALL FIELDS & ALL TERRAINS]
#============================

class Battle::Move::EffectDependsOnEnvironment < Battle::Move
  def flinchingMove?; return [6, 10, 12].include?(@secretPower); end
  

  def pbOnStartUse(user, targets)
    # NOTE: This is Gen 7's list plus some of Gen 6 plus a bit of my own.
    @secretPower = 0   # Body Slam, paralysis
    case $game_temp.fieldEffectsBg
		when 1 # Example Field
		   @secretPower = 2    # Vine Whip, Sleep
	else 
		case $game_temp.terrainEffectsBg
			when 1 # Grassy Terrain
			   @secretPower = 2    # Vine Whip, Sleep
			when 2 # Misty Terrain
			   @secretPower = 2    # Fairy Wind, Lower Special Attack
			when 3 # Electric Terrain
				@secretPower = 1   # Thundershock, Paralysis
			when 4 # Psychic Terrain
				@secretPower = 4   # Confusion, Lower Speed
		end
    end
  end

  # NOTE: This intentionally doesn't use def pbAdditionalEffect, because that
  #       method is called per hit and this move's additional effect only occurs
  #       once per use, after all the hits have happened (two hits are possible
  #       via Parental Bond).
  def pbEffectAfterAllHits(user, target)
    return if target.fainted?
    return if target.damageState.unaffected || target.damageState.substitute
    chance = pbAdditionalEffectChance(user, target)
    return if @battle.pbRandom(100) >= chance
    case @secretPower
    when 2
      target.pbSleep if target.pbCanSleep?(user, false, self)
    when 10
      target.pbBurn(user) if target.pbCanBurn?(user, false, self)
    when 0, 1
      target.pbParalyze(user) if target.pbCanParalyze?(user, false, self)
    when 9
      target.pbFreeze if target.pbCanFreeze?(user, false, self)
    when 5
      if target.pbCanLowerStatStage?(:ATTACK, user, self)
        target.pbLowerStatStage(:ATTACK, 1, user)
      end
    when 14
      if target.pbCanLowerStatStage?(:DEFENSE, user, self)
        target.pbLowerStatStage(:DEFENSE, 1, user)
      end
    when 3
      if target.pbCanLowerStatStage?(:SPECIAL_ATTACK, user, self)
        target.pbLowerStatStage(:SPECIAL_ATTACK, 1, user)
      end
    when 4, 6, 12, 15
      if target.pbCanLowerStatStage?(:SPEED, user, self)
        target.pbLowerStatStage(:SPEED, 1, user)
      end
    when 8
      if target.pbCanLowerStatStage?(:ACCURACY, user, self)
        target.pbLowerStatStage(:ACCURACY, 1, user)
      end
    when 7, 11, 13
      target.pbFlinch(user)
	when 16
	  if target.effects[PBEffects::ThroatChop] == 0
		  @battle.pbDisplay(_INTL("The effects of {1} prevent {2} from using certain moves!",
								@name, target.pbThis(true)))
	  end
	  target.effects[PBEffects::ThroatChop] = 5
    end
  end

  def pbShowAnimation(id, user, targets, hitNum = 0, showAnimation = true)
    id = :BODYSLAM   # Environment-specific anim
    case @secretPower
    when 1  then id = :THUNDERSHOCK if GameData::Move.exists?(:THUNDERSHOCK)
    when 2  then id = :VINEWHIP if GameData::Move.exists?(:VINEWHIP)
    when 3  then id = :FAIRYWIND if GameData::Move.exists?(:FAIRYWIND)
    when 4  then id = :CONFUSION if GameData::Move.exists?(:CONFUSION)
    when 5  then id = :WATERPULSE if GameData::Move.exists?(:WATERPULSE)
    when 6  then id = :MUDSHOT if GameData::Move.exists?(:MUDSHOT)
    when 7  then id = :ROCKTHROW if GameData::Move.exists?(:ROCKTHROW)
    when 8  then id = :MUDSLAP if GameData::Move.exists?(:MUDSLAP)
    when 9  then id = :ICESHARD if GameData::Move.exists?(:ICESHARD)
    when 10 then id = :INCINERATE if GameData::Move.exists?(:INCINERATE)
    when 11 then id = :SHADOWSNEAK if GameData::Move.exists?(:SHADOWSNEAK)
    when 12 then id = :GUST if GameData::Move.exists?(:GUST)
    when 13 then id = :SWIFT if GameData::Move.exists?(:SWIFT)
    when 14 then id = :PSYWAVE if GameData::Move.exists?(:PSYWAVE)
	when 15 then id = :BUBBLEBEAM if GameData::Move.exists?(:BUBBLEBEAM)
	when 16 then id = :THROATCHOP if GameData::Move.exists?(:THROATCHOP)
    end
    super
  end
end


#===============================================================================
# DEFOG [ALL TERRAINS]
#===============================================================================
class Battle::Move::LowerTargetEvasion1RemoveSideEffects < Battle::Move::TargetStatDownMove
  def ignoresSubstitute?(user); return true; end

  def initialize(battle, move)
    super
    @statDown = [:EVASION, 1]
  end

  def pbFailsAgainstTarget?(user, target, show_message)
    targetSide = target.pbOwnSide
    targetOpposingSide = target.pbOpposingSide
    return false if targetSide.effects[PBEffects::AuroraVeil] > 0 ||
                    targetSide.effects[PBEffects::LightScreen] > 0 ||
                    targetSide.effects[PBEffects::Reflect] > 0 ||
                    targetSide.effects[PBEffects::Mist] > 0 ||
                    targetSide.effects[PBEffects::Safeguard] > 0
    return false if targetSide.effects[PBEffects::StealthRock] ||
                    targetSide.effects[PBEffects::Spikes] > 0 ||
                    targetSide.effects[PBEffects::ToxicSpikes] > 0 ||
                    targetSide.effects[PBEffects::StickyWeb]
    return false if Settings::MECHANICS_GENERATION >= 6 &&
                    (targetOpposingSide.effects[PBEffects::StealthRock] ||
                    targetOpposingSide.effects[PBEffects::Spikes] > 0 ||
                    targetOpposingSide.effects[PBEffects::ToxicSpikes] > 0 ||
                    targetOpposingSide.effects[PBEffects::StickyWeb])
    return false if Settings::MECHANICS_GENERATION >= 8 && @battle.field.terrain != :None
    return super
  end

  def pbEffectAgainstTarget(user, target)
    if target.pbCanLowerStatStage?(@statDown[0], user, self)
      target.pbLowerStatStage(@statDown[0], @statDown[1], user)
    end
    if target.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
      target.pbOwnSide.effects[PBEffects::AuroraVeil] = 0
      @battle.pbDisplay(_INTL("{1}'s Aurora Veil wore off!", target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::LightScreen] > 0
      target.pbOwnSide.effects[PBEffects::LightScreen] = 0
      @battle.pbDisplay(_INTL("{1}'s Light Screen wore off!", target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::Reflect] > 0
      target.pbOwnSide.effects[PBEffects::Reflect] = 0
      @battle.pbDisplay(_INTL("{1}'s Reflect wore off!", target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::Mist] > 0
      target.pbOwnSide.effects[PBEffects::Mist] = 0
      @battle.pbDisplay(_INTL("{1}'s Mist faded!", target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::Safeguard] > 0
      target.pbOwnSide.effects[PBEffects::Safeguard] = 0
      @battle.pbDisplay(_INTL("{1} is no longer protected by Safeguard!!", target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::StealthRock] ||
       (Settings::MECHANICS_GENERATION >= 6 &&
       target.pbOpposingSide.effects[PBEffects::StealthRock])
      target.pbOwnSide.effects[PBEffects::StealthRock]      = false
      target.pbOpposingSide.effects[PBEffects::StealthRock] = false if Settings::MECHANICS_GENERATION >= 6
      @battle.pbDisplay(_INTL("{1} blew away stealth rocks!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::Spikes] > 0 ||
       (Settings::MECHANICS_GENERATION >= 6 &&
       target.pbOpposingSide.effects[PBEffects::Spikes] > 0)
      target.pbOwnSide.effects[PBEffects::Spikes]      = 0
      target.pbOpposingSide.effects[PBEffects::Spikes] = 0 if Settings::MECHANICS_GENERATION >= 6
      @battle.pbDisplay(_INTL("{1} blew away spikes!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::ToxicSpikes] > 0 ||
       (Settings::MECHANICS_GENERATION >= 6 &&
       target.pbOpposingSide.effects[PBEffects::ToxicSpikes] > 0)
      target.pbOwnSide.effects[PBEffects::ToxicSpikes]      = 0
      target.pbOpposingSide.effects[PBEffects::ToxicSpikes] = 0 if Settings::MECHANICS_GENERATION >= 6
      @battle.pbDisplay(_INTL("{1} blew away poison spikes!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::StickyWeb] ||
       (Settings::MECHANICS_GENERATION >= 6 &&
       target.pbOpposingSide.effects[PBEffects::StickyWeb])
      target.pbOwnSide.effects[PBEffects::StickyWeb]      = false
      target.pbOpposingSide.effects[PBEffects::StickyWeb] = false if Settings::MECHANICS_GENERATION >= 6
      @battle.pbDisplay(_INTL("{1} blew away sticky webs!", user.pbThis))
    end
    if $game_temp.terrainEffectsBg != 0 # Isn't None
      case $game_temp.terrainEffectsBg
		when 1 # Grassy Terrain
			pbDisplay(_INTL("The grass disappeared from the battlefield!"))
		when 2 # Electric Terrain
			pbDisplay(_INTL("The electric current disappeared from the battlefield!"))
		when 3 # Misty Terrain
			pbDisplay(_INTL("The mist disappeared from the battlefield!"))
		when 4 # Psychic Terrain
			pbDisplay(_INTL("The weirdness disappeared from the battlefield!"))
		end
		  $game_temp.terrainDuration = 0 # Terrain Duration becomes 0, I don't know if this line is needed, but it's here just in case
		  $game_temp.terrainEffectsBg = 0 # No Terrain
    end
  end
end