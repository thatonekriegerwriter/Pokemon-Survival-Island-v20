#============================================================================
#
#
#
#============================================================================

#		FIELD EFFECTS IN ORDER OF NUMBER
#
#	1|	Example Field

#=================================
# 			POWER BOOSTS
#=================================

class Battle::Move

alias fieldEffects_pbCalcDamageMultipliers pbCalcDamageMultipliers

  def pbCalcDamageMultipliers(user,target,numTargets,type,baseDmg,multipliers)
  
	# GENERAL BOOSTS
	if $game_temp.terrainEffectsBg == 2  # Misty Terrain
		if specialMove? && target.pbHasType?(:FAIRY)
			multipliers[:defense_multiplier] *= 1.3
		end
	end
	if $game_temp.terrainEffectsBg == 8  # Frosted Terrain
		if physicalMove? && target.pbHasType?(:ICE)
			multipliers[:defense_multiplier] *= 1.2
		end
	end
  
	case $game_temp.terrainEffectsBg
		when 1 # Grassy Terrain
		# BOOSTS
		if type == :GRASS && user.affectedByTerrain?
			multipliers[:base_damage_multiplier] *= 1.3
			@battle.pbDisplay(_INTL("The grass strengthened the attack!"))
		end
		when 2 # Misty Terrain
		# BOOSTS
		# DEBUFFS
		if type == :DRAGON && target.affectedByTerrain?
			multipliers[:base_damage_multiplier] *= 0.5
			@battle.pbDisplay(_INTL("The draconic power weakened...")) #if $game_temp.fieldMessage==0
		end
		when 3 # Electric Terrain
		# BOOSTS
		if type == :ELECTRIC && user.affectedByTerrain?
			multipliers[:base_damage_multiplier] *= 1.3
			@battle.pbDisplay(_INTL("The charged terrain powered up the attack!")) #if $game_temp.fieldMessage==0
		end
		when 4 # Psychic Terrain
		# BOOSTS
		if type == :PSYCHIC && user.affectedByTerrain?
			multipliers[:base_damage_multiplier] *= 1.3
			@battle.pbDisplay(_INTL("The weirdness boosted the attack!")) #if $game_temp.fieldMessage==0
		end
		# DEBUFFS
	end
    # TYPES
    case $game_temp.fieldEffectsBg
			# BOOSTS
		when 1 # Example Field
		   if type == :NORMAL
				  multipliers[:base_damage_multiplier] *= 1.5
				  @battle.pbDisplay(_INTL("The example field strengthened the attack!")) #if $game_temp.fieldMessage==0
				  #$game_temp.fieldMessage += 1
		   end
		   if type == :BUG && specialMove?
				  multipliers[:base_damage_multiplier] *= 1.5
				  @battle.pbDisplay(_INTL("The attack spreads through the exemplifying power of the field!")) #if $game_temp.fieldMessage==0
				  #$game_temp.fieldMessage += 1
		   end
		   if type == :PSYCHIC && physicalMove?
				  multipliers[:base_damage_multiplier] *= 1.5
				  @battle.pbDisplay(_INTL("The attack gets all beefed up!")) #if $game_temp.fieldMessage==0
				  #$game_temp.fieldMessage += 1
		   end
		   if contactMove?
				  multipliers[:base_damage_multiplier] *= 1.2
				  @battle.pbDisplay(_INTL("The contact move got powered up!")) #if $game_temp.fieldMessage==0
				  #$game_temp.fieldMessage += 1
		   end
		   if !contactMove?
				  multipliers[:base_damage_multiplier] *= 1.2
				  @battle.pbDisplay(_INTL("The non-contact move went super sayan!")) #if $game_temp.fieldMessage==0
				  #$game_temp.fieldMessage += 1
		   end
		   if soundMove?
		      multipliers[:base_damage_multiplier] *= 1.1
		      @battle.pbDisplay(_INTL("Echo...echo...echo..."))
		   end
		   if type == :GRASS && user.affectedByTerrain?
			  multipliers[:base_damage_multiplier] *= 0.5
			  @battle.pbDisplay(_INTL("The move got weaker cause the user is touching grass (literally)!")) #if $game_temp.fieldMessage==0
		   end
		   if type == :FIRE && target.affectedByTerrain?
			  multipliers[:base_damage_multiplier] *= 0.5
			  @battle.pbDisplay(_INTL("The enemy is touching grass, which makes the move weaker!")) 
		   end
    end
	
	# MOVES 
	case $game_temp.fieldEffectsBg
		when 1 # Example Field
		 # BOOSTS
		   if @id == :HURRICANE
              multipliers[:base_damage_multiplier] *= 2
			  @battle.pbDisplay(_INTL("Multiple trees fell on {1}!",target.pbThis(true)))
		   end
		   if @id == :ATTACKORDER
		      multipliers[:base_damage_multiplier] *= 1.5
			  @battle.pbDisplay(_INTL("The wild bugs joined the attack!"))
		   end
		   if @id == :GRAVAPPLE
		      multipliers[:base_damage_multiplier] *= 1.5
			  @battle.pbDisplay(_INTL("An apple fell from the tree!"))
		   end
		   if [:CUT, :PSYCHOCUT, :FURYCUTTER].include?(@id)
			 multipliers[:base_damage_multiplier] *= 1.5
		     @battle.pbDisplay(_INTL("A tree fell onto {1}!",target.pbThis(true)))
		   end 
		 # DEBUFFS
		   if [:SURF, :MUDDYWATER, :ROCKTHROW].include?(@id)
			 multipliers[:base_damage_multiplier] *= 0.5
		     @battle.pbDisplay(_INTL("The attack got weaker!"))
		   end 
    end
	
	case $game_temp.terrainEffectsBg
		when 1 # Grassy Terrain
		   if [:BULLDOZE, :EARTHQUAKE, :MAGNITUDE].include?(@id) && target.affectedByTerrain?
			 multipliers[:base_damage_multiplier] *= 0.5
		     @battle.pbDisplay(_INTL("The soil absorbed the attack!"))
		   end 
	end
	fieldEffects_pbCalcDamageMultipliers(user,target,numTargets,type,baseDmg,multipliers)
  end
end