EventHandlers.add(:on_player_step_taken_can_transfer, :effefefefefehhttrfeeffeeffefej,
  proc {
  #Demo Mode moving over to main.
  if $PokemonSystem.playermode == 0 
     if $player.demotimer <= 0 && $game_temp.in_menu == false
	     pbMessage(_INTL("Beep! Beep! Beep! Beep! Beep!"))
	     pbMessage(_INTL("It sounds like an alarm."))
    $game_temp.player_new_map_id    = 1
    $game_temp.player_new_x         = 22
    $game_temp.player_new_y         = 3
    $game_temp.player_new_direction = 1
    $scene.transfer_player(false)
    $game_map.autoplay
    $game_map.refresh
	Game.save
	$PokemonSystem.playermode = 1 
	$scene = pbCallTitle
    while $scene != nil
      $scene.main
    end
    Graphics.transition(20)
	 else
     $player.demotimer = $player.demotimer.to_i-1
	 end
end


})



EventHandlers.add(:on_player_step_taken_can_transfer, :effefefefefehhttj,
  proc {


  #This is the PokeGenerator settings.
if $game_switches[421]==true
  if $game_switches[943]==true
     $game_variables[291]+=1
  end
  if $game_switches[944]==true
     $game_variables[291]+=1
  end
  if $game_switches[945]==true
     $game_variables[291]+=1
  end
  if $game_switches[946]==true
     $game_variables[291]+=1
  end
  if $game_switches[947]==true
     $game_variables[291]+=1
  end
  if $game_switches[948]==true
     $game_variables[291]+=1
  end
  if $game_switches[949]==true
     $game_variables[291]+=1
  end
  if $game_switches[950]==true
     $game_variables[291]+=1
  end
end

})


