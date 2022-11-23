#==============================================================================#
#                                   Quicksave                                  #
#                         by Marin, updated by CrystalStar                     #
#==============================================================================#

class Scene_Map
	alias quicksave_update update
  def update
    quicksave_update
    scene = $scene if !scene
    if Input.triggerex?(:F9) #AUX2 refers to W key, can be changed by pressing F1
       maps=[54,56,351,352,41,148,149,155,150,151,152,147,153,154]
       if !pbInSafari? && !pbInBugContest? && !pbBattleChallenge.pbInChallenge? && $PokemonSystem.autosave!=0 && maps.include?($game_map.map_id)
         scene.spriteset.addUserSprite(Autosave.new)
	     Game.auto_save
		end
	end
end
end