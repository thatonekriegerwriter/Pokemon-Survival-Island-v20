#============================================================================
#
#	Field Transformations are all done here.
#	While you don't have to, I decided to seperate damage dealing moves from 
#	status moves, mostly for organisations sake.
#
#	The code is the same all the time
#	case $game_temp.fieldEffectsBg
#		when x
#			if [:MOVEHERE].include?(move.id)
#				$game_temp.fieldEffectsBg = xyz  
#				@battle.scene.pbChangeBGSprite
#				@battle.pbDisplay(_INTL("blahblah!"))
#			end
#		when y
#		
#		when z
#		
#	end
#============================================================================

#		FIELD EFFECTS IN ORDER OF NUMBER
#
#	1|	Example Field

#=================================
# Field Transformations
#=================================

class Battle::Battler
  def pbEffectsAfterMove(user, targets, move, numHits)
	# STATUS MOVES
	case $game_temp.fieldEffectsBg
		when 1 # Example Field
				
	end
	# DAMAGE DEALING MOVES
	case $game_temp.fieldEffectsBg
		when 1 # Example Field
			if ![:Rain, :HeavyRain].include?(@battle.pbWeather)
				 if [:FIREPLEDGE, :FIREBLAST, :FLAMEBURST].include?(move.id)
						$game_temp.fieldEffectsBg = 0 # No Field 
						@battle.scene.pbChangeBGSprite
						@battle.pbDisplay(_INTL("The example field is gone!"))
				 end
			end	 
	end
  end
end