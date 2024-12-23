class OverworldCombat
  def is_the_styler_near_me(opponent)
    mouse_loc = get_tile_mouse_on
    distance = (opponent.x - mouse_loc[0]).abs + (opponent.y - mouse_loc[1]).abs
    return distance <= 3
  end
  def get_styler_distance(opponent)
    mouse_loc = get_tile_mouse_on
    distance = (opponent.x - mouse_loc[0]).abs + (opponent.y - mouse_loc[1]).abs
    return distance
  end

def capture_styler_touching(opponent)
	 start_glow(opponent)
	if !is_the_styler_near_me(opponent)
	sideDisplay("#{opponent.pokemon.name} tried to hit your Styler, but you moved it!")
	
	return 
	end
    move = chooseMove(opponent,$game_player,get_styler_distance(opponent))
	amt = getDamager(opponent,$game_player,move,0)
	$styler.styler_health-=amt
	$styler.styler_health=0 if $styler.styler_health<0
    damagePlayer((amt/2))
	pbSEPlay("Battle damage normal")
	sideDisplay("#{opponent.pokemon.name} strikes your Styler!")
	sideDisplay("You take #{(amt/2)} damage as backlash!")
end
end