#-------------------------------------------------------------------------------------------------------------------------------
#													EDIT IN THE SCRIPTS
#-------------------------------------------------------------------------------------------------------------------------------
# In Overworld_BattleStarting
#	Search for '# Terrain'
#		as seen in this image https://i.imgur.com/F97nEHV.png
#		
#		Replace - 
#			case $game_screen.weather_type
#			when :Storm
#				battle.defaultTerrain = :Electric
#			when :Fog
#				battle.defaultTerrain = :Misty
#			end
#			
#		With - 
#			case $game_screen.weather_type
#			when :Storm
#				$game_temp.terrainEffectsBg = 3 # Electric Terrain
#			when :Fog
#				$game_temp.terrainEffectsBg = 2 # Misty Terrain
#			end
#-------------------------------------------------------------------------------------------------------------------------------
			