#============================================================================
#
#
#
#============================================================================

#		TERRAINS IN ORDER OF NUMBER
#
#	1|	Grassy Terrain
#	2|	Electric Terrain
#	3|	Misty Terrain
#	4|	Psychic Terrain



class Battle
	def EoRTerrainEffects
	# Count down terrain duration
    $game_temp.terrainDuration -= 1 if $game_temp.terrainDuration > 0
	# Terrain wears off
		if $game_temp.terrainEffectsBg != 0 && $game_temp.terrainDuration == 0
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
		  $game_temp.terrainEffectsBg = 0 # No Terrain
		  # Start up the default terrain
		  return if $game_temp.terrainEffectsBg == 0 # No Terrain
		end
	end
end

#===============================================================================
# GRASSY TERRAIN
#===============================================================================
class Battle::Move::StartGrassyTerrain < Battle::Move
  def pbMoveFailed?(user, targets)
    if $game_temp.terrainEffectsBg == 1 # Grassy Terrain
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
	# Set Variables to Off
	heldItem = false
	
	# Verify Terrain Extender presence
	heldItem = true if user.hasActiveItem?(:TERRAINEXTENDER)
	
	$game_temp.terrainEffectsBg = 1 # Grassy Terrain
	$game_temp.terrainDuration = 5
	$game_temp.terrainDuration += 3 if heldItem 
	@battle.pbDisplay(_INTL("The terrain bloomed!"))
  end
end

# GRASSY SURGE
Battle::AbilityEffects::OnSwitchIn.add(:GRASSYSURGE,
  proc { |ability, battler, battle, switch_in|
    next if $game_temp.terrainEffectsBg == 1 # Grassy Terrain
    battle.pbShowAbilitySplash(battler)
    # Set Variables to Off
	heldItem = false
	
	# Verify Terrain Extender presence
	heldItem = true if battler.hasActiveItem?(:TERRAINEXTENDER)
		
	$game_temp.terrainEffectsBg = 1 # Grassy Terrain
	$game_temp.terrainDuration = 5
	$game_temp.terrainDuration += 3 if heldItem 
	battle.pbDisplay(_INTL("The terrain bloomed!"))
	battle.pbHideAbilitySplash(battler)
  }
)


#===============================================================================
# MISTY TERRAIN
#===============================================================================
class Battle::Move::StartMistyTerrain < Battle::Move
  def pbMoveFailed?(user, targets)
    if $game_temp.terrainEffectsBg == 2 # Misty Terrain
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
	# Set Variables to Off
	heldItem = false
	
	# Verify Terrain Extender presence
	heldItem = true if user.hasActiveItem?(:TERRAINEXTENDER)
		
	$game_temp.terrainEffectsBg = 2 # Misty Terrain
	$game_temp.terrainDuration = 5
	$game_temp.terrainDuration += 3 if heldItem 
	@battle.pbDisplay(_INTL("The terrain became misty!"))
  end
end

# MISTY SURGE
Battle::AbilityEffects::OnSwitchIn.add(:MISTYSURGE,
  proc { |ability, battler, battle, switch_in|
    next if $game_temp.terrainEffectsBg == 2 # Misty Terrain
    battle.pbShowAbilitySplash(battler)
    # Set Variables to Off
	heldItem = false
	
	# Verify Terrain Extender presence
	heldItem = true if battler.hasActiveItem?(:TERRAINEXTENDER)
		
	$game_temp.terrainEffectsBg = 2 # Misty Terrain
	$game_temp.terrainDuration = 5
	$game_temp.terrainDuration += 3 if heldItem 
	battle.pbDisplay(_INTL("The terrain became misty!"))
	battle.pbHideAbilitySplash(battler)
  }
)


#===============================================================================
# ELECTRIC TERRAIN
#===============================================================================
class Battle::Move::StartElectricTerrain < Battle::Move
  def pbMoveFailed?(user, targets)
    if $game_temp.terrainEffectsBg == 3 # Electric Terrain
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
	# Set Variables to Off
	heldItem = false
	
	# Verify Terrain Extender presence
	heldItem = true if user.hasActiveItem?(:TERRAINEXTENDER)
		
	$game_temp.terrainEffectsBg = 3 # Electric Terrain
	$game_temp.terrainDuration = 5
	$game_temp.terrainDuration += 3 if heldItem 
	@battle.pbDisplay(_INTL("The terrain became electrified!"))
  end
end

# ELECTRIC SURGE
Battle::AbilityEffects::OnSwitchIn.add(:ELECTRICSURGE,
  proc { |ability, battler, battle, switch_in|
    next if $game_temp.terrainEffectsBg == 3 # Electric Terrain
    battle.pbShowAbilitySplash(battler)
    # Set Variables to Off
	heldItem = false
	
	# Verify Terrain Extender presence
	heldItem = true if battler.hasActiveItem?(:TERRAINEXTENDER)
		
	$game_temp.terrainEffectsBg = 3 # Electric Terrain
	$game_temp.terrainDuration = 5
	$game_temp.terrainDuration += 3 if heldItem 
	battle.pbDisplay(_INTL("The terrain became electrified!"))
	battle.pbHideAbilitySplash(battler)
  }
)

#===============================================================================
# PSYCHIC TERRAIN
#===============================================================================
class Battle::Move::StartPsychicTerrain < Battle::Move
  def pbMoveFailed?(user, targets)
    if $game_temp.terrainEffectsBg == 4 # Psychic Terrain
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
	# Set Variables to Off
	heldItem = false
	
	# Verify Terrain Extender presence
	heldItem = true if user.hasActiveItem?(:TERRAINEXTENDER)
		
	$game_temp.terrainEffectsBg = 4 # Psychic Terrain
	$game_temp.terrainDuration = 5
	$game_temp.terrainDuration += 3 if heldItem 
	@battle.pbDisplay(_INTL("The terrain got weird!"))
  end
end

# PSYCHIC SURGE
Battle::AbilityEffects::OnSwitchIn.add(:PSYCHICSURGE,
  proc { |ability, battler, battle, switch_in|
    next if $game_temp.terrainEffectsBg == 4 # Psychic Terrain
    battle.pbShowAbilitySplash(battler)
    # Set Variables to Off
	heldItem = false
	
	# Verify Terrain Extender presence
	heldItem = true if battler.hasActiveItem?(:TERRAINEXTENDER)
		
	$game_temp.terrainEffectsBg = 4 # Psychic Terrain
	$game_temp.terrainDuration = 5
	$game_temp.terrainDuration += 3 if heldItem 
	battle.pbDisplay(_INTL("The terrain got weird!"))
	battle.pbHideAbilitySplash(battler)
  }
)