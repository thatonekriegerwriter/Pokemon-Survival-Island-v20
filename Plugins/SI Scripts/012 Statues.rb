


def pbTeleportStatues1
     pbMessage(_INTL("This is a spirit statue. Once activated, the spirit inside will aid you with some of its power."))
	 if pbConfirmMessage(_INTL("Activate Statue?"))
	   pbMessage(_INTL("It seems to need something to be placed in its eyes to be activated."))
	   pbMEPlay("Pokemon Healing")
       $player.heal_party
      this_event = pbMapInterpreter.get_self
      pbSetSelfSwitch(this_event.id, "A", true)  
	 end

end


def pbTeleportStatues2(home=false)
command = 0
  loop do
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?"))
    command = pbShowCommands(msgwindow,
                    [_INTL("Use Statue"),
                    _INTL("Save Game"),
                    _INTL("Exit")],2)
    case command
    when 0   # Use Statue
    pbDisposeMessageWindow(msgwindow)
	interp = pbMapInterpreter
    this_event = interp.get_self
    statue = interp.getVariable
    if !statue
       statue = 00
       interp.setVariable(statue)
    end
	if statue == 11 || home == true
   	  pbShowFlyMap(-1, false) if $game_temp.fly_destination.nil?
	  this_event.turn_down
      statue = 00
      interp.setVariable(statue)
      pbFlyToNewLocation
	elsif $bag.has?(:STARPIECE, 2) && (statue != 01 || statue != 10) 
     pbMessage(_INTL("It seems Star Pieces are what can fit into its eyes."))
	 if pbConfirmMessage(_INTL("Do you wish to place Star Pieces in it's eyes?"))
	    this_event.turn_left
        statue = 11
        interp.setVariable(statue)
	    $bag.remove(:STARPIECE,2)
	 end
	elsif $bag.has?(:STARPIECE, 1)
     pbMessage(_INTL("It seems Star Pieces are what can fit into its eyes."))
	 if pbConfirmMessage(_INTL("Do you wish to place Star Pieces in it's eyes?"))
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("Which eye do you wish to place your Star Piece in?"))
    command = pbShowCommands(msgwindow,
                                   [_INTL("Left"),
                                    _INTL("Right"),
                                    _INTL("Cancel")])
	     
          case command
          when 0
             pbMessage(_INTL("You place a Star Piece in it's left eye."))
			 if statue == 01
             this_event.turn_down
             statue = 11
             interp.setVariable(statue)
			 else
             this_event.turn_right
             statue = 10
             interp.setVariable(statue)
			 end
          when 1
             pbMessage(_INTL("You place a Star Piece in it's right eye."))
			 if statue == 10
             this_event.turn_down
             statue = 11
             interp.setVariable(statue)
			 else
             this_event.turn_up
             statue = 01
             interp.setVariable(statue)
			 end
          end
	 end
	else 
     pbMessage(_INTL("The Statue doesn't seem to react to anything you have."))
	end
    
	when 1   # Save Game
    pbDisposeMessageWindow(msgwindow)
    scene = PokemonSave_Scene.new
    screen = PokemonSaveScreen.new(scene)
    screen.pbSaveScreen
    else
      break
      pbDisposeMessageWindow(msgwindow)
    end

end


end