def heal_BED(wari,pkmn)
  case $PokemonSystem.difficulty
    when 0
	 chance = rand(5)
    when 1
	 chance = rand(7)
    when 2
	 chance = rand(9)
    when 3
	 chance = rand(11)
  end
  return if pkmn.egg?
  if wari >= 8
    pkmn.heal_HP
    pkmn.heal_status if chance <= 1
    pkmn.heal_PP if chance <= 1
  else 
    newHP = pkmn.hp + ((pkmn.totalhp * wari)/8) 
    newHP = pkmn.totalhp if newHP > pkmn.totalhp
    pkmn.hp = newHP
  end
  @ready_to_evolve = false
end


def pbBedCore(temperate=false)
command = 0
pbSetPokemonCenter
  loop do
      cmdSleep  = -1
      cmdNap   = -1
      cmdSave   = -1
      cmdDreamConnect = -1
      cmdPickUp = -1
      commands = []
      commands[cmdSleep  = commands.length] = _INTL("Sleep")
      commands[cmdNap  = commands.length] = _INTL("Nap")
      commands[cmdSave   = commands.length] = _INTL("Save")
      commands[cmdDreamConnect = commands.length] = _INTL("Dream Connect")
      commands[cmdPickUp  = commands.length] = _INTL("Pick Up") if temperate==false
      commands[commands.length]              = _INTL("Cancel")
      command = pbShowCommands(nil, commands)
      if cmdSleep >= 0 && command == cmdSleep      # Send to Boxes
          if pbConfirmMessage(_INTL("Do you want to head to bed?"))
             params = ChooseNumberParams.new
             params.setMaxDigits(1)
             params.setRange(0,9)
             msgwindow = pbCreateMessageWindow(nil,nil)
             pbMessageDisplay(msgwindow,_INTL("How many hours do you want to sleep?"))
		     hours = pbChooseNumber(msgwindow,params)
             pbDisposeMessageWindow(msgwindow)
			  if hours == 1
			    pbMessage(_INTL("You lay down to rest with your Pokemon for an hour."))
			  elsif hours == 0
			    pbMessage(_INTL("You decide not to sleep.",hours))
				 break
			  else
			    pbMessage(_INTL("You lay down to rest with your Pokemon for {1} hours.",hours))
			  end
				pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	            pbMEPlay("Pokemon Healing")
				party = $player.party
                 for i in 0...party.length
                 pkmn = party[i]
				 heal_BED(hours,pkmn)
				 end
				pbWait(80)
				pbRandomEvent
				if $game_switches[157]==true && $game_variables[423] >= 1
				$player.money +=(500*pbGet(350))
			    pbMessage(_INTL("You got paid for a days worth of battling."))
				$game_variables[423] = 0
				end
				if pbPokerus?
			    pbMessage(_INTL("Your Pokemon seems a little off tonight."))
				end 
				$game_variables[29] += (3600*hours)
				pbSleepRestore(hours)
				pbToneChangeAll(Tone.new(0,0,0,0),20)
				if $player.playersleep >= 100
			        pbMessage(_INTL("You feel well rested!"))
				elsif $player.playersleep >= 75
			        pbMessage(_INTL("You feel a little groggy, but are raring to go!"))
				elsif $player.playersleep >= 50
			        pbMessage(_INTL("Your brain feels fuzzy."))
				elsif $player.playersleep >= 25
			        pbMessage(_INTL("You want to go back to bed."))
				else
			        pbMessage(_INTL("You really need to sleep."))
				end  
        	    break
		  end
      elsif cmdNap >= 0 && command == cmdNap   # Summary
          if pbConfirmMessage(_INTL("Do you want to take a nap?"))
			    pbMessage(_INTL("You lay down to take a nap."))
				pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
			    hours = 1
				$game_variables[29] += ((3600*hours)/2).round
	            pbMEPlay("Pokemon Healing")
				pbWait(40)
				pbRandomEvent
				chance = rand(3)
				if chance == 0
				$player.pokemon_party.each do |pkmn|
                 pkmn.heal_HP
                 pkmn.heal_status
                 pkmn.heal_PP
				 end
				 pbSleepRestore(hours)
			 	pbToneChangeAll(Tone.new(0,0,0,0),20)
			     pbMessage(_INTL("You wake up feeling great!"))
				 elsif chance == 1
			 	pbToneChangeAll(Tone.new(0,0,0,0),20)
			     pbMessage(_INTL("You wake up not feeling any different."))
				 else
			     $player.pokemon_party.each do |pkmn|
			        pkmn.changeSleep
			        pkmn.changeSleep
			        pkmn.changeSleep
			     end
				   $player.playersleep -= 24
				 pbToneChangeAll(Tone.new(0,0,0,0),20)
			     pbMessage(_INTL("You wake up feeling worse than before."))
				 end
        	    break
				end
      elsif cmdSave >= 0 && command == cmdSave   # Summary
       scene = PokemonSave_Scene.new
       screen = PokemonSaveScreen.new(scene)
       screen.pbSaveScreen
	   break
      elsif cmdDreamConnect >= 0 && command == cmdDreamConnect   # Summary
	    pbCableClub
		break
      elsif cmdPickUp >= 0 && command == cmdPickUp   # Summary
          if pbConfirmMessage(_INTL("Do you want to pick up the Bed?"))
		    pbReceiveItem(:BEDROLL)
		    this_event = pbMapInterpreter.get_self
		    pbSetSelfSwitch(this_event.id, "A", false)  
		  end
		  break
	  elsif Input.trigger?(Input::BACK)
	    break
	  else
	    break
      end
end
end




def pbBedMessageLoss
if $player.playerhealth >=75
    pbMessage(_INTL("{1} woke up feeling well-rested."),$player.name)
elsif $player.playerhealth >=50
    pbMessage(_INTL("{1} woke up feeling rested, if a little achey.."),$player.name)
elsif $player.playerhealth >=25
    pbMessage(_INTL("{1} woke up feeling tired, but determined."),$player.name)
elsif $player.playerhealth >=10
    pbMessage(_INTL("{1} woke up in pain, but shrugged it off. It can't be *that* bad..."),$player.name)
elsif $player.playerhealth <=9
    pbMessage(_INTL("{1} really doesn't want to get out of bed."),$player.name)
end
end


module MessageConfig

def pbPositionNearMsgWindow(cmdwindow, msgwindow, side)
  return if !cmdwindow
  if msgwindow
    height = [cmdwindow.height, Graphics.height - msgwindow.height].min
    if cmdwindow.height != height
      cmdwindow.height = height
    end
    cmdwindow.y = msgwindow.y - cmdwindow.height
    if cmdwindow.y < 0
      cmdwindow.y = msgwindow.y + msgwindow.height
      if cmdwindow.y + cmdwindow.height > Graphics.height
        cmdwindow.y = msgwindow.y - cmdwindow.height
      end
    end
    case side
    when :left
      cmdwindow.x = msgwindow.x
    when :right
      cmdwindow.x = msgwindow.x + msgwindow.width - cmdwindow.width
    else
      cmdwindow.x = msgwindow.x + msgwindow.width - cmdwindow.width
    end
  else
    cmdwindow.height = Graphics.height if cmdwindow.height > Graphics.height
    cmdwindow.x = 0
    cmdwindow.y = 0
  end
end
end