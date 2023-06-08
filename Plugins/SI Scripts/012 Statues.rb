


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
                    _INTL("Seek Guidance"),
                    _INTL("Exit")],-1)
	pbDisposeMessageWindow(msgwindow)
    case command
    when 0   # Use Statue
    pbDisposeMessageWindow(msgwindow)
	interp = pbMapInterpreter
    this_event = interp.get_self
    statue = interp.getVariable
    if !statue
       statue = [00,0]
       interp.setVariable(statue)
    end
	if statue == 00
      statue = [00,0]
       interp.setVariable(statue)
	end
	if statue == 01
      statue = [01,0]
       interp.setVariable(statue)
	end
	if statue == 10
      statue = [10,0]
       interp.setVariable(statue)
	end
	if statue == 11
      statue = [11,2]
       interp.setVariable(statue)
	end
	if statue[0] == 11 || home == true
   	  pbShowFlyMap(-1, false) if $game_temp.fly_destination.nil?
	  if statue[1]==0
	  this_event.turn_down
      statue = [00,0]
	  else
	  statue[1]-=1
	  end
      interp.setVariable(statue)
      pbFlyToNewLocation
	elsif $bag.has?(:STARPIECE, 2) && (statue[0] != 01 || statue[0] != 10) 
     pbMessage(_INTL("It seems Star Pieces are what can fit into its eyes."))
	 if pbConfirmMessage(_INTL("Do you wish to place Star Pieces in it's eyes?"))
	    this_event.turn_left
        statue = [11,2]
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
			 if statue[0] == 01
             this_event.turn_down
             statue = [11,2]
             interp.setVariable(statue)
			 else
             this_event.turn_right
             statue = [10,0]
             interp.setVariable(statue)
			 end
          when 1
             pbMessage(_INTL("You place a Star Piece in it's right eye."))
			 if statue[0] == 10
             this_event.turn_down
             statue = [11,2]
             interp.setVariable(statue)
			 else
             this_event.turn_up
             statue = [01,0]
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
	when 2   # Help
    pbDisposeMessageWindow(msgwindow)
	story = $game_variables[237].to_i
	hints = $game_variables[238].to_i
	case story 
	when 0
	 if hints == 0
     pbMessage(_INTL("The Entirety of the Temperate Shores and Plains are open to you! The best thing to do right now is to just explore!"))
	 hints += 1
	 elsif hints == 1
     pbMessage(_INTL("The Temperate Plains seem a little more interesting than the Shore, maybe explore around there."))
	 hints += 1
	 elsif hints == 2
     pbMessage(_INTL("The Stone Ruins are the Remains of a Temple. A Pokemon of Immense Power Guards it's exit."))
	 hints += 1
	 elsif hints == 3
     pbMessage(_INTL("The Ancient One is a Ground/Dragon type Steelix, before fighting the Dungeon, prepare to fight it!"))
	 hints = 0
	 end
	when 1
	 if hints == 0
     pbMessage(_INTL("The Mountains have opened up to you! You could explore the peaks, or find a way to get Rock Smash to break into a Temple."))
	 hints += 1
	 elsif hints == 1
     pbMessage(_INTL("Remember that you can teach your POKeMON new moves using the Menu! You can use them to open up areas!"))
	 hints += 1
	 elsif hints == 2
     pbMessage(_INTL("The Peak has a lot of areas you can use for mining, maybe you can make something to break rocks!"))
	 hints += 1
	 elsif hints == 3
     pbMessage(_INTL("Most of your progress requires environmental altering, so maybe you should catch Pokemon or Craft Items to progress."))
	 hints = 0
	 end
	when 2
	 if $game_map.name == "Frigid Highlands"
     pbMessage(_INTL("The statue here doesn't seem to allow for teleportation. Maybe explore around?"))
	 else
	 if hints == 0
     pbMessage(_INTL("You've defeated the Magma Temple! Visit the Peaks if you haven't, but to find anything else, you are going to need to be able to cross water!"))
	 hints += 1
	 elsif hints == 1
     pbMessage(_INTL("There's a lot of places you can go to right now, you can visit areas across the Ocean, visit the Swamp, or cross the water in the Chilled Plains!"))
	 hints += 1
	 elsif hints == 2
     pbMessage(_INTL("Now that you have the ability to mine, and cross water, there is a cave out on the water that you can trade your mining gains at."))
	 hints += 1
	 elsif hints == 3
	 hints = 0
     pbMessage(_INTL("Now that you have reached this point, my advice is to work towards an Exp All before doing anything else."))
	 end
	 end
	when 3
	 if hints == 0
	 if $game_map.name == "Frigid Highlands"
     pbMessage(_INTL("Brr... The Cold isn't for me afterall. Let's leave."))
	 else
     pbMessage(_INTL("It's nice to be out of the cold. Maybe some things changed around here, let's take a look around."))
	 hints += 1
	 end
	 elsif hints == 1
     pbMessage(_INTL("Meeting Blue, huh? Who could you meet next?"))
	 hints += 1
	 elsif hints == 2
     pbMessage(_INTL("You've been everywhere by now, the only main area you haven't found a Temple in is the Swamp."))
	 hints += 1
	 elsif hints == 3
     pbMessage(_INTL("I say that, but that's actually a lie. There is another area that has been available since you gained the ability to move on Water, and the Ability to break rocks."))
	 hints = 0
	 end
	when 4
	 if hints == 0
     pbMessage(_INTL("Finally! A place that isn't cold or neutral! The area looks pretty flat, if there's something here, they would be on the edge of the water.."))
	 hints += 1
	 elsif hints == 1
     pbMessage(_INTL("If Blue was up north, I wonder who is here."))
	 hints += 1
	 elsif hints == 2
     pbMessage(_INTL("There's not actually a temple in this area."))
	 hints += 1
	 elsif hints == 3
     pbMessage(_INTL("While most of the people who came to the island found a comfortable place to stay, Red made a comfortable space."))
	 hints = 0
	 end
	when 20
	 if hints == 0
     pbMessage(_INTL("The Jungle is as far away from the rest of the island as Team Rocket could get, push through their Base!"))
	 hints += 1
	 elsif hints == 1
     pbMessage(_INTL("The Final Boss isn't a pushover."))
	 hints += 1
	 elsif hints == 2
     pbMessage(_INTL("The Final Boss isn't a pushover."))
	 hints += 1
	 elsif hints == 3
     pbMessage(_INTL("The Jungle is as far away from the rest of the island as Team Rocket could get, push through their Base!"))
	 hints = 0
	 end

	else
     pbMessage(_INTL("Oh. This message isn't supposed to show up."))
	end
    else
      break
      pbDisposeMessageWindow(msgwindow)
    end

end


end



def pbTeleportStatues3(home=false)
command = 0
  loop do
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?"))
    command = pbShowCommands(msgwindow,
                    [_INTL("Save Game"),
                    _INTL("Seek Guidance"),
                    _INTL("Exit")],-1)
	pbDisposeMessageWindow(msgwindow)
    case command
	when 0   # Save Game
    pbDisposeMessageWindow(msgwindow)
    scene = PokemonSave_Scene.new
    screen = PokemonSaveScreen.new(scene)
    screen.pbSaveScreen
	when 1   # Help
    pbDisposeMessageWindow(msgwindow)
	story = $game_variables[237].to_i
	hints = $game_variables[238].to_i
	case story 
	when 0
	 if hints == 0
     pbMessage(_INTL("The Entirety of the Temperate Shores and Plains are open to you! The best thing to do right now is to just explore!"))
	 hints += 1
	 elsif hints == 1
     pbMessage(_INTL("The Temperate Plains seem a little more interesting than the Shore, maybe explore around there."))
	 hints += 1
	 elsif hints == 2
     pbMessage(_INTL("The Stone Ruins are the Remains of a Temple. A Pokemon of Immense Power Guards it's exit."))
	 hints += 1
	 elsif hints == 3
     pbMessage(_INTL("The Ancient One is a Ground/Dragon type Steelix, before fighting the Dungeon, prepare to fight it!"))
	 hints = 0
	 end
	when 1
	 if hints == 0
     pbMessage(_INTL("The Mountains have opened up to you! You could explore the peaks, or find a way to get Rock Smash to break into a Temple."))
	 hints += 1
	 elsif hints == 1
     pbMessage(_INTL("Remember that you can teach your POKeMON new moves using the Menu! You can use them to open up areas!"))
	 hints += 1
	 elsif hints == 2
     pbMessage(_INTL("The Peak has a lot of areas you can use for mining, maybe you can make something to break rocks!"))
	 hints += 1
	 elsif hints == 3
     pbMessage(_INTL("Most of your progress requires environmental altering, so maybe you should catch Pokemon or Craft Items to progress."))
	 hints = 0
	 end
	when 2
	 if $game_map.name == "Frigid Highlands"
     pbMessage(_INTL("The statue here doesn't seem to allow for teleportation. Maybe explore around?"))
	 else
	 if hints == 0
     pbMessage(_INTL("You've defeated the Magma Temple! Visit the Peaks if you haven't, but to find anything else, you are going to need to be able to cross water!"))
	 hints += 1
	 elsif hints == 1
     pbMessage(_INTL("There's a lot of places you can go to right now, you can visit areas across the Ocean, visit the Swamp, or cross the water in the Chilled Plains!"))
	 hints += 1
	 elsif hints == 2
     pbMessage(_INTL("Now that you have the ability to mine, and cross water, there is a cave out on the water that you can trade your mining gains at."))
	 hints += 1
	 elsif hints == 3
	 hints = 0
     pbMessage(_INTL("Now that you have reached this point, my advice is to work towards an Exp All before doing anything else."))
	 end
	 end
	when 3
	 if hints == 0
	 if $game_map.name == "Frigid Highlands"
     pbMessage(_INTL("Brr... The Cold isn't for me afterall. Let's leave."))
	 else
     pbMessage(_INTL("It's nice to be out of the cold. Maybe some things changed around here, let's take a look around."))
	 hints += 1
	 end
	 elsif hints == 1
     pbMessage(_INTL("Meeting Blue, huh? Who could you meet next?"))
	 hints += 1
	 elsif hints == 2
     pbMessage(_INTL("You've been everywhere by now, the only main area you haven't found a Temple in is the Swamp."))
	 hints += 1
	 elsif hints == 3
     pbMessage(_INTL("I say that, but that's actually a lie. There is another area that has been available since you gained the ability to move on Water, and the Ability to break rocks."))
	 hints = 0
	 end
	when 4
	 if hints == 0
     pbMessage(_INTL("Finally! A place that isn't cold or neutral! The area looks pretty flat, if there's something here, they would be on the edge of the water.."))
	 hints += 1
	 elsif hints == 1
     pbMessage(_INTL("If Blue was up north, I wonder who is here."))
	 hints += 1
	 elsif hints == 2
     pbMessage(_INTL("There's not actually a temple in this area."))
	 hints += 1
	 elsif hints == 3
     pbMessage(_INTL("While most of the people who came to the island found a comfortable place to stay, Red made a comfortable space."))
	 hints = 0
	 end
	when 20
	 if hints == 0
     pbMessage(_INTL("The Jungle is as far away from the rest of the island as Team Rocket could get, push through their Base!"))
	 hints += 1
	 elsif hints == 1
     pbMessage(_INTL("The Final Boss isn't a pushover."))
	 hints += 1
	 elsif hints == 2
     pbMessage(_INTL("The Final Boss isn't a pushover."))
	 hints += 1
	 elsif hints == 3
     pbMessage(_INTL("The Jungle is as far away from the rest of the island as Team Rocket could get, push through their Base!"))
	 hints = 0
	 end

	else
     pbMessage(_INTL("Oh. This message isn't supposed to show up."))
	end
    else
      break
      pbDisposeMessageWindow(msgwindow)
    end

end


end
