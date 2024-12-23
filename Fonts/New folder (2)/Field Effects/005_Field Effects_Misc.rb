#============================================================================
#
#
#
#============================================================================

#		FIELD EFFECTS IN ORDER OF NUMBER
#
#	1|	Example Field


# BUG TYPE SPEED BOOST ON [ EXAMPLE FIELD ]
# NON-WATER TYPE SPEED IS HALVED [ EXAMPLE FIELD ]
class Battle::Battler
	alias fieldEffectsSpeed_pbSpeed pbSpeed
	
	def pbSpeed
		ret = fieldEffectsSpeed_pbSpeed
			speedMult *= 1.2 if pbHasType?(:BUG) && $game_temp.fieldEffectsBg == 1 # Example Field
			speedMult /= 2 if (!pbHasType?(:WATER) || 
								!hasActiveAbility?(:SWIFTSWIM) || 
								!hasActiveAbility?(:SURGESURFER) || 
								!hasActiveAbility?(:STEELWORKER)) && $game_temp.fieldEffectsBg == 1 # Example Field				
			# Calculation
			return ret
	end
end

# DUAL-TYPE MOVES
class Battle::Move
	alias fieldEffects_pbCalcTypeModSingle pbCalcTypeModSingle
 
	def fieldEffects_pbCalcTypeModSingle(moveType, defType, user, target)
		case $game_temp.fieldEffectsBg
			when 1 # Example Field
				if GameData::Type.exists?(:WATER) && moveType == :ROCK
					waterEff = Effectiveness.calculate_one(:WATER, defType)
					ret *= waterEff.to_f / Effectiveness::NORMAL_EFFECTIVE_ONE
				end
		end
	pbCalcTypeModSingle
	end  
end

# STATUS IMMUNITY - GENERAL
class Battle::Battler
	alias terrainEffects_pbCanInflictStatus? pbCanInflictStatus?

	def pbCanInflictStatus?(newStatus, user, showMessages, move = nil, ignoreStatus = false)
		ret = terrainEffects_pbCanInflictStatus?(newStatus, user, showMessages, move, ignoreStatus)
		if ret 
				# Terrains immunity
				if affectedByTerrain?
				  case $game_temp.terrainEffectsBg 
					  when 2 # Misty Terrain
						@battle.pbDisplay(_INTL("{1} surrounds itself with misty terrain!", pbThis(true))) if showMessages
						return false
					  when 3 # Electric Terrain
						if newStatus == :SLEEP
						   @battle.pbDisplay(_INTL("{1} surrounds itself with electrified terrain!", pbThis(true))) if showMessages
						   return false
						end
				  end
				end
				# Field Immunity
				case $game_temp.fieldEffectsBg
				when 1 # Example Field
					if newStatus == :FROZEN
					  if showMessages
						@battle.pbDisplay(_INTL("The example field protected {1} from being frozen!", pbThis(true))) if showMessages
						return false
					  end
					end
				end
		else
			return false
		end
	end
end

# YAWN SLEEP IMMUNITY
class Battle::Battler
	alias terrainEffects_pbCanSleepYawn? pbCanSleepYawn?
	
	def pbCanSleepYawn?
		ret = terrainEffects_pbCanSleepYawn?
		if ret
			if affectedByterrain?
				case $game_temp.terrainEffectsBg 
					when 2 # Misty Terrains
						return false
					when 3 # Electric Terrain
						return false
				end
			end
		else
			return true
		end
	end
end

# CONFUSION IMMUNITY
class Battle::Battler
	alias terrainEffects_pbCanConfuse? pbCanConfuse?
	
	def pbCanConfuse?(user = nil, showMessages = true, move = nil, selfInflicted = false)
		ret = terrainEffects_pbCanConfuse?(user, showMessages, move, selfInflicted)
		if ret
			# Terrains immunity
			if affectedByTerrain?
			  case $game_temp.terrainEffectsBg 
				  when 2 # Misty Terrain
					@battle.pbDisplay(_INTL("{1} surrounds itself with misty terrain!", pbThis(true))) if showMessages
					return false
			  end
			end
		else
			return false
		end
	end
end

# PRIORITY MOVES DON'T WORK
class Battle::Battler
	alias terrainEffects_pbSuccessCheckAgainstTarget	pbSuccessCheckAgainstTarget
	
	def pbSuccessCheckAgainstTarget(move, user, target, targets)
		ret = terrainEffects_pbSuccessCheckAgainstTarget(move, user, target, targets)
		if ret
			return true
		else
			# Immunity to priority moves because of Psychic Terrain
				if $game_temp.terrainEffectsBg == 4 && target.affectedByTerrain? && target.opposes?(user) &&
				   @battle.choices[user.index][4] > 0   # Move priority saved from pbCalculatePriority
				   @battle.pbDisplay(_INTL("{1} surrounds itself with psychic terrain!", target.pbThis)) if show_message
				  return false
			end
		end
	end
end

# NEGATE WEATHER
class Battle
  def pbWeather
    return :None if allBattlers.any? { |b| b.hasActiveAbility?([:CLOUDNINE, :AIRLOCK]) }
	return :None if $game_temp.fieldEffectsBg == 1 # Example Field
    return @field.weather
  end
end

#
class Battle
  #=============================================================================
  # End Of Round deal damage to trapped battlers
  #=============================================================================
  TRAPPING_MOVE_COMMON_ANIMATIONS = {
    :BIND        => "Bind",
    :CLAMP       => "Clamp",
    :FIRESPIN    => "FireSpin",
    :MAGMASTORM  => "MagmaStorm",
    :SANDTOMB    => "SandTomb",
    :WRAP        => "Wrap",
    :INFESTATION => "Infestation"
  }

  def pbEORTrappingDamage(battler)
    return if battler.fainted? || battler.effects[PBEffects::Trapping] == 0
    battler.effects[PBEffects::Trapping] -= 1
    move_name = GameData::Move.get(battler.effects[PBEffects::TrappingMove]).name
    if battler.effects[PBEffects::Trapping] == 0
      pbDisplay(_INTL("{1} was freed from {2}!", battler.pbThis, move_name))
      return
    end
    anim = TRAPPING_MOVE_COMMON_ANIMATIONS[battler.effects[PBEffects::TrappingMove]] || "Wrap"
    pbCommonAnimation(anim, battler)
    return if !battler.takesIndirectDamage?
    hpLoss = (Settings::MECHANICS_GENERATION >= 6) ? battler.totalhp / 8 : battler.totalhp / 16
    if @battlers[battler.effects[PBEffects::TrappingUser]].hasActiveItem?(:BINDINGBAND)
      hpLoss = (Settings::MECHANICS_GENERATION >= 6) ? battler.totalhp / 6 : battler.totalhp / 8
    end
	# NOTE: Follow the example under this if you desire to make Trapping moves deal more damage
	# 		There are ways to make Binding Band + Field Damage Boost work together. But I think thats overkill.
	if $game_temp.fieldEffectsBg == 1 && # Example Field
	   @battlers[battler.effects[PBEffects::TrappingMove]]==:INFESTATION
      hpLoss = battler.totalhp / 6
    end
    @scene.pbDamageAnimation(battler)
    battler.pbTakeEffectDamage(hpLoss, false) { |hp_lost|
      pbDisplay(_INTL("{1} is hurt by {2}!", battler.pbThis, move_name))
    }
  end
  
end


# NOTE: Here you can make Entry Hazards deal more damage, or make more things happen.
#		I know how to make Entry Hazard damage be dual-typed for example. I didn't put it in here
#		but if you want I can show how to do it.
class Battle
	def pbEntryHazards(battler)
		battler_side = battler.pbOwnSide
		# Stealth Rock
		if battler_side.effects[PBEffects::StealthRock] && battler.takesIndirectDamage? &&
		   GameData::Type.exists?(:ROCK) && !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
		  bTypes = battler.pbTypes(true)
		  eff = Effectiveness.calculate(:ROCK, bTypes[0], bTypes[1], bTypes[2])		  
		  if !Effectiveness.ineffective?(eff)
			eff = eff.to_f / Effectiveness::NORMAL_EFFECTIVE
			if $game_temp.fieldEffectsBg == 1 # Example Field
				battler.pbReduceHP(battler.totalhp * eff / 4, false)
			else	
				battler.pbReduceHP(battler.totalhp * eff / 8, false)
			end
			pbDisplay(_INTL("Pointed stones dug into {1}!", battler.pbThis))
			battler.pbItemHPHealCheck
		  end
		end
		# Spikes
		if battler_side.effects[PBEffects::Spikes] > 0 && battler.takesIndirectDamage? &&
		   !battler.airborne? && !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
		  spikesDiv = [8, 6, 4][battler_side.effects[PBEffects::Spikes] - 1]
		  battler.pbReduceHP(battler.totalhp / spikesDiv, false)
		  pbDisplay(_INTL("{1} is hurt by the spikes!", battler.pbThis))
		  battler.pbItemHPHealCheck
		end
		# Toxic Spikes
		if battler_side.effects[PBEffects::ToxicSpikes] > 0 && !battler.fainted? && !battler.airborne?
		  if battler.pbHasType?(:POISON)
			battler_side.effects[PBEffects::ToxicSpikes] = 0
			pbDisplay(_INTL("{1} absorbed the poison spikes!", battler.pbThis))
		  elsif battler.pbCanPoison?(nil, false) && !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
			if battler_side.effects[PBEffects::ToxicSpikes] == 2
			  battler.pbPoison(nil, _INTL("{1} was badly poisoned by the poison spikes!", battler.pbThis), true)
			else
			  battler.pbPoison(nil, _INTL("{1} was poisoned by the poison spikes!", battler.pbThis))
			end
		  end
		end
		# Sticky Web
		if battler_side.effects[PBEffects::StickyWeb] && !battler.fainted? && !battler.airborne? &&
		   !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
		  pbDisplay(_INTL("{1} was caught in a sticky web!", battler.pbThis))
		  if battler.pbCanLowerStatStage?(:SPEED)
			battler.pbLowerStatStage(:SPEED, 1, nil)
			battler.pbItemStatRestoreCheck
      end
    end
  end
end

#=============================================================================
# End Of Round healing from Terrains or Fields
#=============================================================================
  def pbEORTerrainHealing(battler)
    return if battler.fainted?
    # Grassy Terrain (healing)
    if $game_temp.terrainEffectsBg == 1 && battler.affectedByTerrain? && battler.canHeal?
      PBDebug.log("[Lingering effect] Grassy Terrain heals #{battler.pbThis(true)}")
      battler.pbRecoverHP(battler.totalhp / 16)
      pbDisplay(_INTL("{1}'s HP was restored.", battler.pbThis))
    end
  end

