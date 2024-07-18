def pbStoryProgression


end




def pbActivatePlotlineQuest(quest,vari,queststage=nil)
if quest.is_a?(Symbol)
if $DEBUG && Input.press?(Input::CTRL)
resetQuest(quest)
puts "11"
end
if !isCompletedQuest?(quest) || !isFailedQuest?(quest)
activateQuest(quest, colorQuest("blue"), true)
end
if isFailedQuest?(quest)
return false 
end
end
name = vari+8
if $game_variables[name] == 000
$game_variables[name]="???"
end
if quest.is_a?(Symbol)
queststage = getCurrentStage(quest)
end
msgwindow = pbCreateMessageWindow(nil,nil)
case quest
when :PSISQ2
pbGetTextBasedOnVariable(msgwindow,vari,quest,queststage)
end
pbDisposeMessageWindow(msgwindow)
end

def pbGetTextBasedOnVariable(msgwindow,vari,quest,queststage)
   commands = []
   getvalue = pbGet(vari)
   case vari
   when 4926
   puts "Partner 1"
     case getvalue
	    when 1 #Brent
		 $game_variables[(wari+8)]="Brent"
	    when 2 #Donna
		 $game_variables[(wari+8)]="Donna"
	    when 3 #Jace
		 $game_variables[(wari+8)]="Jace"
	    when 4 #Sevii
		 $game_variables[(wari+8)]="Sevii"
	    when 5 #John
		$game_variables[(wari+8)]="John"
	    when 6 #Sam
		 $game_variables[(wari+8)]="Sam"
	    when 7 #David
		 $game_variables[(wari+8)]="David"
	    when 8 #Alice
		 $game_variables[(wari+8)]="Alice"
	 end
   when 4927
   puts "Partner 2"
     case getvalue
	    when 1 #Brent
		 $game_variables[(wari+8)]="Brent"
	    when 2 #Donna
		 $game_variables[(wari+8)]="Donna"
	    when 3 #Jace
		 $game_variables[(wari+8)]="Jace"
	    when 4 #Sevii
		 $game_variables[(wari+8)]="Sevii"
	    when 5 #John
		$game_variables[(wari+8)]="John"
	    when 6 #Sam
		 $game_variables[(wari+8)]="Sam"
	    when 7 #David
		 $game_variables[(wari+8)]="David"
	    when 8 #Alice
		 $game_variables[(wari+8)]="Alice"
	 end
   when 4928
   puts "Partner 3"
      case getvalue
	    when 1 #Brent
		 case quest
		 when :PSISQ2 #Retrieve My Pokemon!
		   case queststage
		      when 1
			        $player.partner3affinity = $player.partner3affinity.to_i
				    commands.push(_INTL("What's up?"))
				    commands.push(_INTL("Who are you?"))
				    commands.push(_INTL("What happened?"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Darn! Darn! Darn!"))
                    command = pbShowCommands(msgwindow, commands)
					case command
					when 0
					  $player.playerharmony+=2
					  $player.partner3affinity+=3
					  commands = []
				      commands.push(_INTL("Which way did they go?"))
				      commands.push(_INTL("Do you need help?"))
				      commands.push(_INTL("Are you injured?")) if ($player.playerclass == "Healer" || $player.playerharmony > 20)
					  case  command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was napping on this log,and a Rocket robbed me!"))
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] That doesn't matter right now, a Rocket stole my Pokemon!"))
					  when 2
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was traveling through the area and took a rest, and woke up to a Rocket running off with my POKeMON!"))
					  end
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
					  $player.playerwrath+=2
					  $player.partner3affinity+=1
					  commands = []
				      commands.push(_INTL("If you lead, I'll follow!")) if ($player.partner3affinity > 55 || $player.playermoral>55)
				      commands.push(_INTL("Don't worry about it, I'll get them back."))
				      commands.push(_INTL("Good luck!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] They went towards the Swamp!"))
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you would be willing to help, that'd be mighty great."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Just so you know, my name is..."))
					   $game_variables[(wari+8)]=pbEnterPlayerName("Their name?", 0, Settings::MAX_PLAYER_NAME_SIZE, "Brent")
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   when 1
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You'd do that? I guess I could trust you."))
					   $game_variables[(wari+8)]=pbEnterPlayerName("Their name?", 0, Settings::MAX_PLAYER_NAME_SIZE, "Brent")
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] my name is... \\v[4935], Thank's a bundle!"))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Thank's a bundle!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   when 2
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You... you aren't gonna help?"))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah well, screw you too buddy!"))
					   pbDisposeMessageWindow(msgwindow)
					   $player.partner3affinity-=20
					   pbCaveEntranceEx(true)
	                   pbSetSelfSwitch(15, "A", true, 28)
					   failQuest(:PSISQ2, colorQuest("red"), true)
					   end
					   when 1
					   $game_variables[(wari+8)]=pbEnterPlayerName("Their name?", 0, Settings::MAX_PLAYER_NAME_SIZE, "Brent")
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you don't mind helping me get them back, I would be eternally grateful. The name's \\v[4935], by the way."))
					  if $player.partner3affinity > 55
                      pbMessageDisplay(msgwindow,_INTL("He pauses, sighing."))
					  commands = []
				      commands.push(_INTL("You can come along."))
				      commands.push(_INTL("It's better for you to stay."))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Of course, I might be dead weight, so it's up to you to let me come along."))
                      command = pbShowCommands(msgwindow, commands)
					  case command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Thanks! I'll try not to be dead weight!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah, you're right, I'll be here until you get back."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					  end
					  else
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   
					   
					   
					   end
					   
					   
					   
					   
					   
					   
					   
					   
					   
					   when 2
					  commandsold = commands
					  commands = []
				      commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				      commands.push(_INTL("Whatever you say, just be careful."))
				      commands.push(_INTL("Okay, I'm gonna get going now!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]They didn't kneecap me or anything, just scared me, I feel fine, thanks for asking through."))
                      command = pbShowCommands(msgwindow, commands)
                      case command
					    when 0
						  if $PokemonSystem.survivalmode = 0 && $PokemonSystem.nuzlockemode = 0
						    $bag.remove(:POTION,1)
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks, that'll help no matter what."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Resources like Potions take a lot of work out here, so I at least want to give you something back."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I met a guy out east who let me know that if you boil freshwater, an Argost Berry, and an Enigma Berry in a Cauldron, you can get an item that allows you revive a POKeMON as an Egg."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  else
                            pbMessageDisplay(msgwindow,_INTL("He refuses it."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]You may need it more than me."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  end
					    when 1
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks for the concern."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thinking about it, I will rest here, thanks a bundle."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					    when 2
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I think I want to come with you, if you don't mind."))
							if $player.playerharmony>30
					             commands = []
				                 commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				                 commands.push(_INTL("Whatever you say, just be careful."))
                                 command = pbShowCommands(msgwindow, commands)
								 case command
								 when 0
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]On second thought, I will stay, I do lack POKeMON, and my leg does hurt a little bit."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
								 when 1
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Okay, let's go!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
								 end
							else 
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Let's get going!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
							end
					  end
					   end

					end
                    if $game_variables[(wari+8)]=="000"
					   $game_variables[(wari+8)]=pbEnterPlayerName("Their name?", 0, Settings::MAX_PLAYER_NAME_SIZE, "Brent")
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I almost forgot! My name is \\v[4935]! It's nice to meet you!"))
				       commands.push(_INTL("You as well."))
				       commands.push(_INTL("I feel the same."))
				       commands.push(_INTL("I'll be back in a bit."))
                       command = pbShowCommands(msgwindow, commands)
				       case command
				       when 0
			            $player.playerharmony+=3
				       when 1
			            $player.playermoral+=3
				       when 2
			            $player.playerwrath+=3
				       end
				    end
	                pbSetSelfSwitch(10, "A", true, 109)
                    pbSetSelfSwitch(9, "A", true, 109)
                    pbSetSelfSwitch(1, "D", true, 109) 
			  when 2 
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Please find my POKeMON!"))
				 
				 
				 
		      when 3
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] and you brought back my POKeMON! Thanks a lot!"))
			        $player.partner3affinity += $player.partner3affinity+10
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I'm gonna find a safer place to rest and make sure they are okay! Thank you so much!"))
					completeQuest(:PSISQ2, colorQuest("green"))
			  else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! Thanks for helping me out."))
		   end
		 when "red" #Retrieve this asshole and bring them to Red!
		    case queststage
			 when 0
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] What's up? Do you need something?"))
			 end
	     else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! You aren't meant to see this!"))
		 end
		   
		   
	    when 2 #Donna
		 $game_variables[(wari+8)]="Donna"
		 case quest
		 when :PSISQ2 #Retrieve My Pokemon!
		   case queststage
		      when 1
			        $player.partner3affinity = $player.partner3affinity.to_i
				    commands.push(_INTL("What's up?"))
				    commands.push(_INTL("Who are you?"))
				    commands.push(_INTL("What happened?"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Darn! Darn! Darn!"))
                    command = pbShowCommands(msgwindow, commands)
					case command
					when 0
					  $player.playerharmony+=2
					  $player.partner3affinity+=3
					  commands = []
				      commands.push(_INTL("Which way did they go?"))
				      commands.push(_INTL("Do you need help?"))
				      commands.push(_INTL("Are you injured?")) if ($player.playerclass == "Healer" || $player.playerharmony > 20)
					  case  command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was napping on this log,and a Rocket robbed me!"))
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] That doesn't matter right now, a Rocket stole my Pokemon!"))
					  when 2
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was traveling through the area and took a rest, and woke up to a Rocket running off with my POKeMON!"))
					  end
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
					  $player.playerwrath+=2
					  $player.partner3affinity+=1
					  commands = []
				      commands.push(_INTL("If you lead, I'll follow!")) if ($player.partner3affinity > 55 || $player.playermoral>55)
				      commands.push(_INTL("Don't worry about it, I'll get them back."))
				      commands.push(_INTL("Good luck!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] They went towards the Swamp!"))
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you would be willing to help, that'd be mighty great."))
					   $game_variables[(wari+8)]="Donna"
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Just so you know, my name is \\v[4935]."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   when 1
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You'd do that? I guess I could trust you."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] my name is \\v[4935], Thank's a bundle!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   when 2
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You... you aren't gonna help?"))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah well, screw you too buddy!"))
					   pbDisposeMessageWindow(msgwindow)
					   $player.partner3affinity-=20
					   pbCaveEntranceEx(true)
	                   pbSetSelfSwitch(15, "A", true, 28)
					   failQuest(:PSISQ2, colorQuest("red"), true)
					   end
					   when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you don't mind helping me get them back, I would be eternally grateful. The name's \\v[4935], by the way."))
					  if $player.partner3affinity > 55
                      pbMessageDisplay(msgwindow,_INTL("She pauses, sighing."))
					  commands = []
				      commands.push(_INTL("You can come along."))
				      commands.push(_INTL("It's better for you to stay."))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Of course, I might be dead weight, so it's up to you to let me come along."))
                      command = pbShowCommands(msgwindow, commands)
					  case command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Thanks! I'll try not to be dead weight!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah, you're right, I'll be here until you get back."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					  end
					  else
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   
					   
					   
					   end
					   
					   
					   
					   
					   
					   
					   
					   
					   
					   when 2
					  commandsold = commands
					  commands = []
				      commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				      commands.push(_INTL("Whatever you say, just be careful."))
				      commands.push(_INTL("Okay, I'm gonna get going now!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]They didn't kneecap me or anything, just scared me, I feel fine, thanks for asking through."))
                      command = pbShowCommands(msgwindow, commands)
                      case command
					    when 0
						  if $PokemonSystem.survivalmode = 0 && $PokemonSystem.nuzlockemode = 0
						    $bag.remove(:POTION,1)
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks, that'll help no matter what."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Resources like Potions take a lot of work out here, so I at least want to give you something back."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I met a guy out east who let me know that if you boil freshwater, an Argost Berry, and an Enigma Berry in a Cauldron, you can get an item that allows you revive a POKeMON as an Egg."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  else
                            pbMessageDisplay(msgwindow,_INTL("He refuses it."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]You may need it more than me."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  end
					    when 1
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks for the concern."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thinking about it, I will rest here, thanks a bundle."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					    when 2
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I think I want to come with you, if you don't mind."))
							if $player.playerharmony>30
					             commands = []
				                 commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				                 commands.push(_INTL("Whatever you say, just be careful."))
                                 command = pbShowCommands(msgwindow, commands)
								 case command
								 when 0
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]On second thought, I will stay, I do lack POKeMON, and my leg does hurt a little bit."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
								 when 1
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Okay, let's go!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
								 end
							else 
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Let's get going!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
							end
					  end
					   end

					end
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I almost forgot! My name is \\v[4935]! It's nice to meet you!"))
				       commands.push(_INTL("You as well."))
				       commands.push(_INTL("I feel the same."))
				       commands.push(_INTL("I'll be back in a bit."))
                       command = pbShowCommands(msgwindow, commands)
				       case command
				       when 0
			            $player.playerharmony+=3
				       when 1
			            $player.playermoral+=3
				       when 2
			            $player.playerwrath+=3
				       end
	                pbSetSelfSwitch(10, "A", true, 109)
                    pbSetSelfSwitch(9, "A", true, 109)
                    pbSetSelfSwitch(1, "D", true, 109) 
			  when 2 
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Please find my POKeMON!"))
				 
				 
				 
		      when 3
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] and you brought back my POKeMON! Thanks a lot!"))
			        $player.partner3affinity += $player.partner3affinity+10
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I'm gonna find a safer place to rest and make sure they are okay! Thank you so much!"))
					completeQuest(:PSISQ2, colorQuest("green"))
			  else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! Thanks for helping me out."))
		   end
		 when "red" #Retrieve this asshole and bring them to Red!
		    case queststage
			 when 0
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] What's up? Do you need something?"))
			 end
	     else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! You aren't meant to see this!"))
		 end
		   
		   
	    when 3 #Jace
		 $game_variables[(wari+8)]="Jace"
		 case quest
		 when :PSISQ2 #Retrieve My Pokemon!
		   case queststage
		      when 1
			        $player.partner3affinity = $player.partner3affinity.to_i
				    commands.push(_INTL("What's up?"))
				    commands.push(_INTL("Who are you?"))
				    commands.push(_INTL("What happened?"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Darn! Darn! Darn!"))
                    command = pbShowCommands(msgwindow, commands)
					case command
					when 0
					  $player.playerharmony+=2
					  $player.partner3affinity+=3
					  commands = []
				      commands.push(_INTL("Which way did they go?"))
				      commands.push(_INTL("Do you need help?"))
				      commands.push(_INTL("Are you injured?")) if ($player.playerclass == "Healer" || $player.playerharmony > 20)
					  case  command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was napping on this log,and a Rocket robbed me!"))
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] That doesn't matter right now, a Rocket stole my Pokemon!"))
					  when 2
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was traveling through the area and took a rest, and woke up to a Rocket running off with my POKeMON!"))
					  end
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
					  $player.playerwrath+=2
					  $player.partner3affinity+=1
					  commands = []
				      commands.push(_INTL("If you lead, I'll follow!")) if ($player.partner3affinity > 55 || $player.playermoral>55)
				      commands.push(_INTL("Don't worry about it, I'll get them back."))
				      commands.push(_INTL("Good luck!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] They went towards the Swamp!"))
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you would be willing to help, that'd be mighty great."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Just so you know, my name is \\v[4935]."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   when 1
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You'd do that? I guess I could trust you."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] my name is \\v[4935]], Thank's a bundle!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   when 2
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You... you aren't gonna help?"))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah well, screw you too buddy!"))
					   pbDisposeMessageWindow(msgwindow)
					   $player.partner3affinity-=20
					   pbCaveEntranceEx(true)
	                   pbSetSelfSwitch(15, "A", true, 28)
					   failQuest(:PSISQ2, colorQuest("red"), true)
					   end
					   when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you don't mind helping me get them back, I would be eternally grateful. The name's \\v[4935], by the way."))
					  if $player.partner3affinity > 55
                      pbMessageDisplay(msgwindow,_INTL("He pauses, sighing."))
					  commands = []
				      commands.push(_INTL("You can come along."))
				      commands.push(_INTL("It's better for you to stay."))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Of course, I might be dead weight, so it's up to you to let me come along."))
                      command = pbShowCommands(msgwindow, commands)
					  case command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Thanks! I'll try not to be dead weight!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah, you're right, I'll be here until you get back."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					  end
					  else
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   
					   
					   
					   end
					   
					   
					   
					   
					   
					   
					   
					   
					   
					   when 2
					  commandsold = commands
					  commands = []
				      commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				      commands.push(_INTL("Whatever you say, just be careful."))
				      commands.push(_INTL("Okay, I'm gonna get going now!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]They didn't kneecap me or anything, just scared me, I feel fine, thanks for asking through."))
                      command = pbShowCommands(msgwindow, commands)
                      case command
					    when 0
						  if $PokemonSystem.survivalmode = 0 && $PokemonSystem.nuzlockemode = 0
						    $bag.remove(:POTION,1)
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks, that'll help no matter what."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Resources like Potions take a lot of work out here, so I at least want to give you something back."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I met a guy out east who let me know that if you boil freshwater, an Argost Berry, and an Enigma Berry in a Cauldron, you can get an item that allows you revive a POKeMON as an Egg."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  else
                            pbMessageDisplay(msgwindow,_INTL("He refuses it."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]You may need it more than me."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  end
					    when 1
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks for the concern."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thinking about it, I will rest here, thanks a bundle."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					    when 2
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I think I want to come with you, if you don't mind."))
							if $player.playerharmony>30
					             commands = []
				                 commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				                 commands.push(_INTL("Whatever you say, just be careful."))
                                 command = pbShowCommands(msgwindow, commands)
								 case command
								 when 0
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]On second thought, I will stay, I do lack POKeMON, and my leg does hurt a little bit."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
								 when 1
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Okay, let's go!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
								 end
							else 
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Let's get going!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
							end
					  end
					   end

					end
                    if $game_variables[4935]=="000"
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I almost forgot! My name is \\v[4935]! It's nice to meet you!"))
				       commands.push(_INTL("You as well."))
				       commands.push(_INTL("I feel the same."))
				       commands.push(_INTL("I'll be back in a bit."))
                       command = pbShowCommands(msgwindow, commands)
				       case command
				       when 0
			            $player.playerharmony+=3
				       when 1
			            $player.playermoral+=3
				       when 2
			            $player.playerwrath+=3
				       end
				    end
	                pbSetSelfSwitch(10, "A", true, 109)
                    pbSetSelfSwitch(9, "A", true, 109)
                    pbSetSelfSwitch(1, "D", true, 109) 
			  when 2 
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Please find my POKeMON!"))
				 
				 
				 
		      when 3
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] and you brought back my POKeMON! Thanks a lot!"))
			        $player.partner3affinity += $player.partner3affinity+10
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I'm gonna find a safer place to rest and make sure they are okay! Thank you so much!"))
					completeQuest(:PSISQ2, colorQuest("green"))
			  else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! Thanks for helping me out."))
		   end
		 when "red" #Retrieve this asshole and bring them to Red!
		    case queststage
			 when 0
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] What's up? Do you need something?"))
			 end
	     else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! You aren't meant to see this!"))
		 end
		   
		   
	    when 4 #Sevii
		 $game_variables[(wari+8)]="Sevii"
		 case quest
		 when :PSISQ2 #Retrieve My Pokemon!
		   case queststage
		      when 1
			        $player.partner3affinity = $player.partner3affinity.to_i
				    commands.push(_INTL("What's up?"))
				    commands.push(_INTL("Who are you?"))
				    commands.push(_INTL("What happened?"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Darn! Darn! Darn!"))
                    command = pbShowCommands(msgwindow, commands)
					case command
					when 0
					  $player.playerharmony+=2
					  $player.partner3affinity+=3
					  commands = []
				      commands.push(_INTL("Which way did they go?"))
				      commands.push(_INTL("Do you need help?"))
				      commands.push(_INTL("Are you injured?")) if ($player.playerclass == "Healer" || $player.playerharmony > 20)
					  case  command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was napping on this log,and a Rocket robbed me!"))
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] That doesn't matter right now, a Rocket stole my Pokemon!"))
					  when 2
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was traveling through the area and took a rest, and woke up to a Rocket running off with my POKeMON!"))
					  end
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
					  $player.playerwrath+=2
					  $player.partner3affinity+=1
					  commands = []
				      commands.push(_INTL("If you lead, I'll follow!")) if ($player.partner3affinity > 55 || $player.playermoral>55)
				      commands.push(_INTL("Don't worry about it, I'll get them back."))
				      commands.push(_INTL("Good luck!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] They went towards the Swamp!"))
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you would be willing to help, that'd be mighty great."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Just so you know, my name is \\v[4935]."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   when 1
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You'd do that? I guess I could trust you."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] my name is \\v[4935], Thank's a bundle!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   when 2
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You... you aren't gonna help?"))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah well, screw you too buddy!"))
					   pbDisposeMessageWindow(msgwindow)
					   $player.partner3affinity-=20
					   pbCaveEntranceEx(true)
	                   pbSetSelfSwitch(15, "A", true, 28)
					   failQuest(:PSISQ2, colorQuest("red"), true)
					   end
					   when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you don't mind helping me get them back, I would be eternally grateful. The name's \\v[4935], by the way."))
					  if $player.partner3affinity > 55
                      pbMessageDisplay(msgwindow,_INTL("He pauses, sighing."))
					  commands = []
				      commands.push(_INTL("You can come along."))
				      commands.push(_INTL("It's better for you to stay."))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Of course, I might be dead weight, so it's up to you to let me come along."))
                      command = pbShowCommands(msgwindow, commands)
					  case command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Thanks! I'll try not to be dead weight!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah, you're right, I'll be here until you get back."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					  end
					  else
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   
					   
					   
					   end
					   
					   
					   
					   
					   
					   
					   
					   
					   
					   when 2
					  commandsold = commands
					  commands = []
				      commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				      commands.push(_INTL("Whatever you say, just be careful."))
				      commands.push(_INTL("Okay, I'm gonna get going now!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]They didn't kneecap me or anything, just scared me, I feel fine, thanks for asking through."))
                      command = pbShowCommands(msgwindow, commands)
                      case command
					    when 0
						  if $PokemonSystem.survivalmode = 0 && $PokemonSystem.nuzlockemode = 0
						    $bag.remove(:POTION,1)
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks, that'll help no matter what."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Resources like Potions take a lot of work out here, so I at least want to give you something back."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I met a guy out east who let me know that if you boil freshwater, an Argost Berry, and an Enigma Berry in a Cauldron, you can get an item that allows you revive a POKeMON as an Egg."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  else
                            pbMessageDisplay(msgwindow,_INTL("He refuses it."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]You may need it more than me."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  end
					    when 1
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks for the concern."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thinking about it, I will rest here, thanks a bundle."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					    when 2
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I think I want to come with you, if you don't mind."))
							if $player.playerharmony>30
					             commands = []
				                 commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				                 commands.push(_INTL("Whatever you say, just be careful."))
                                 command = pbShowCommands(msgwindow, commands)
								 case command
								 when 0
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]On second thought, I will stay, I do lack POKeMON, and my leg does hurt a little bit."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
								 when 1
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Okay, let's go!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
								 end
							else 
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Let's get going!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
							end
					  end
					   end

					end
                    if $game_variables[4935]=="000"
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I almost forgot! My name is \\v[4935]! It's nice to meet you!"))
				       commands.push(_INTL("You as well."))
				       commands.push(_INTL("I feel the same."))
				       commands.push(_INTL("I'll be back in a bit."))
                       command = pbShowCommands(msgwindow, commands)
				       case command
				       when 0
			            $player.playerharmony+=3
				       when 1
			            $player.playermoral+=3
				       when 2
			            $player.playerwrath+=3
				       end
				    end
	                pbSetSelfSwitch(10, "A", true, 109)
                    pbSetSelfSwitch(9, "A", true, 109)
                    pbSetSelfSwitch(1, "D", true, 109) 
			  when 2 
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Please find my POKeMON!"))
				 
				 
				 
		      when 3
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] and you brought back my POKeMON! Thanks a lot!"))
			        $player.partner3affinity += $player.partner3affinity+10
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I'm gonna find a safer place to rest and make sure they are okay! Thank you so much!"))
					completeQuest(:PSISQ2, colorQuest("green"))
			  else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! Thanks for helping me out."))
		   end
		 when "red" #Retrieve this asshole and bring them to Red!
		    case queststage
			 when 0
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] What's up? Do you need something?"))
			 end
	     else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! You aren't meant to see this!"))
		 end
		   
		   
	    when 5 #John
		$game_variables[(wari+8)]="John"
		 case quest
		 when :PSISQ2 #Retrieve My Pokemon!
		   case queststage
		      when 1
			        $player.partner3affinity = $player.partner3affinity.to_i
				    commands.push(_INTL("What's up?"))
				    commands.push(_INTL("Who are you?"))
				    commands.push(_INTL("What happened?"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Darn! Darn! Darn!"))
                    command = pbShowCommands(msgwindow, commands)
					case command
					when 0
					  $player.playerharmony+=2
					  $player.partner3affinity+=3
					  commands = []
				      commands.push(_INTL("Which way did they go?"))
				      commands.push(_INTL("Do you need help?"))
				      commands.push(_INTL("Are you injured?")) if ($player.playerclass == "Healer" || $player.playerharmony > 20)
					  case  command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was napping on this log,and a Rocket robbed me!"))
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] That doesn't matter right now, a Rocket stole my Pokemon!"))
					  when 2
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was traveling through the area and took a rest, and woke up to a Rocket running off with my POKeMON!"))
					  end
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
					  $player.playerwrath+=2
					  $player.partner3affinity+=1
					  commands = []
				      commands.push(_INTL("If you lead, I'll follow!")) if ($player.partner3affinity > 55 || $player.playermoral>55)
				      commands.push(_INTL("Don't worry about it, I'll get them back."))
				      commands.push(_INTL("Good luck!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] They went towards the Swamp!"))
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you would be willing to help, that'd be mighty great."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Just so you know, my name is \\v[4935]."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   when 1
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You'd do that? I guess I could trust you."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] my name is \\v[4935], Thank's a bundle!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   when 2
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You... you aren't gonna help?"))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah well, screw you too buddy!"))
					   pbDisposeMessageWindow(msgwindow)
					   $player.partner3affinity-=20
					   pbCaveEntranceEx(true)
	                   pbSetSelfSwitch(15, "A", true, 28)
					   failQuest(:PSISQ2, colorQuest("red"), true)
					   end
					   when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you don't mind helping me get them back, I would be eternally grateful. The name's \\v[4935], by the way."))
					  if $player.partner3affinity > 55
                      pbMessageDisplay(msgwindow,_INTL("He pauses, sighing."))
					  commands = []
				      commands.push(_INTL("You can come along."))
				      commands.push(_INTL("It's better for you to stay."))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Of course, I might be dead weight, so it's up to you to let me come along."))
                      command = pbShowCommands(msgwindow, commands)
					  case command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Thanks! I'll try not to be dead weight!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah, you're right, I'll be here until you get back."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					  end
					  else
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   
					   
					   
					   end
					   
					   
					   
					   
					   
					   
					   
					   
					   
					   when 2
					  commandsold = commands
					  commands = []
				      commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				      commands.push(_INTL("Whatever you say, just be careful."))
				      commands.push(_INTL("Okay, I'm gonna get going now!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]They didn't kneecap me or anything, just scared me, I feel fine, thanks for asking through."))
                      command = pbShowCommands(msgwindow, commands)
                      case command
					    when 0
						  if $PokemonSystem.survivalmode = 0 && $PokemonSystem.nuzlockemode = 0
						    $bag.remove(:POTION,1)
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks, that'll help no matter what."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Resources like Potions take a lot of work out here, so I at least want to give you something back."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I met a guy out east who let me know that if you boil freshwater, an Argost Berry, and an Enigma Berry in a Cauldron, you can get an item that allows you revive a POKeMON as an Egg."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  else
                            pbMessageDisplay(msgwindow,_INTL("He refuses it."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]You may need it more than me."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  end
					    when 1
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks for the concern."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thinking about it, I will rest here, thanks a bundle."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					    when 2
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I think I want to come with you, if you don't mind."))
							if $player.playerharmony>30
					             commands = []
				                 commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				                 commands.push(_INTL("Whatever you say, just be careful."))
                                 command = pbShowCommands(msgwindow, commands)
								 case command
								 when 0
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]On second thought, I will stay, I do lack POKeMON, and my leg does hurt a little bit."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
								 when 1
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Okay, let's go!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
								 end
							else 
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Let's get going!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
							end
					  end
					   end

					end
                    if $game_variables[4935]=="000"
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I almost forgot! My name is \\v[4935]! It's nice to meet you!"))
				       commands.push(_INTL("You as well."))
				       commands.push(_INTL("I feel the same."))
				       commands.push(_INTL("I'll be back in a bit."))
                       command = pbShowCommands(msgwindow, commands)
				       case command
				       when 0
			            $player.playerharmony+=3
				       when 1
			            $player.playermoral+=3
				       when 2
			            $player.playerwrath+=3
				       end
				    end
	                pbSetSelfSwitch(10, "A", true, 109)
                    pbSetSelfSwitch(9, "A", true, 109)
                    pbSetSelfSwitch(1, "D", true, 109) 
			  when 2 
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Please find my POKeMON!"))
				 
				 
				 
		      when 3
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] and you brought back my POKeMON! Thanks a lot!"))
			        $player.partner3affinity += $player.partner3affinity+10
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I'm gonna find a safer place to rest and make sure they are okay! Thank you so much!"))
					completeQuest(:PSISQ2, colorQuest("green"))
			  else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! Thanks for helping me out."))
		   end
		 when "red" #Retrieve this asshole and bring them to Red!
		    case queststage
			 when 0
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] What's up? Do you need something?"))
			 end
	     else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! You aren't meant to see this!"))
		 end
		   
		   
	    when 6 #Sam
		 $game_variables[(wari+8)]="Sam"
		 case quest
		 when :PSISQ2 #Retrieve My Pokemon!
		   case queststage
		      when 1
			        $player.partner3affinity = $player.partner3affinity.to_i
				    commands.push(_INTL("What's up?"))
				    commands.push(_INTL("Who are you?"))
				    commands.push(_INTL("What happened?"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Darn! Darn! Darn!"))
                    command = pbShowCommands(msgwindow, commands)
					case command
					when 0
					  $player.playerharmony+=2
					  $player.partner3affinity+=3
					  commands = []
				      commands.push(_INTL("Which way did they go?"))
				      commands.push(_INTL("Do you need help?"))
				      commands.push(_INTL("Are you injured?")) if ($player.playerclass == "Healer" || $player.playerharmony > 20)
					  case  command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was napping on this log,and a Rocket robbed me!"))
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] That doesn't matter right now, a Rocket stole my Pokemon!"))
					  when 2
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was traveling through the area and took a rest, and woke up to a Rocket running off with my POKeMON!"))
					  end
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
					  $player.playerwrath+=2
					  $player.partner3affinity+=1
					  commands = []
				      commands.push(_INTL("If you lead, I'll follow!")) if ($player.partner3affinity > 55 || $player.playermoral>55)
				      commands.push(_INTL("Don't worry about it, I'll get them back."))
				      commands.push(_INTL("Good luck!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] They went towards the Swamp!"))
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you would be willing to help, that'd be mighty great."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Just so you know, my name is \\v[4935]."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   when 1
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You'd do that? I guess I could trust you."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] my name is \\v[4935], Thank's a bundle!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   when 2
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You... you aren't gonna help?"))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah well, screw you too buddy!"))
					   pbDisposeMessageWindow(msgwindow)
					   $player.partner3affinity-=20
					   pbCaveEntranceEx(true)
	                   pbSetSelfSwitch(15, "A", true, 28)
					   failQuest(:PSISQ2, colorQuest("red"), true)
					   end
					   when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you don't mind helping me get them back, I would be eternally grateful. The name's \\v[4935], by the way."))
					  if $player.partner3affinity > 55
                      pbMessageDisplay(msgwindow,_INTL("He pauses, sighing."))
					  commands = []
				      commands.push(_INTL("You can come along."))
				      commands.push(_INTL("It's better for you to stay."))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Of course, I might be dead weight, so it's up to you to let me come along."))
                      command = pbShowCommands(msgwindow, commands)
					  case command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Thanks! I'll try not to be dead weight!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah, you're right, I'll be here until you get back."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					  end
					  else
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   
					   
					   
					   end
					   
					   
					   
					   
					   
					   
					   
					   
					   
					   when 2
					  commandsold = commands
					  commands = []
				      commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				      commands.push(_INTL("Whatever you say, just be careful."))
				      commands.push(_INTL("Okay, I'm gonna get going now!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]They didn't kneecap me or anything, just scared me, I feel fine, thanks for asking through."))
                      command = pbShowCommands(msgwindow, commands)
                      case command
					    when 0
						  if $PokemonSystem.survivalmode = 0 && $PokemonSystem.nuzlockemode = 0
						    $bag.remove(:POTION,1)
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks, that'll help no matter what."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Resources like Potions take a lot of work out here, so I at least want to give you something back."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I met a guy out east who let me know that if you boil freshwater, an Argost Berry, and an Enigma Berry in a Cauldron, you can get an item that allows you revive a POKeMON as an Egg."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  else
                            pbMessageDisplay(msgwindow,_INTL("He refuses it."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]You may need it more than me."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  end
					    when 1
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks for the concern."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thinking about it, I will rest here, thanks a bundle."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					    when 2
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I think I want to come with you, if you don't mind."))
							if $player.playerharmony>30
					             commands = []
				                 commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				                 commands.push(_INTL("Whatever you say, just be careful."))
                                 command = pbShowCommands(msgwindow, commands)
								 case command
								 when 0
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]On second thought, I will stay, I do lack POKeMON, and my leg does hurt a little bit."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
								 when 1
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Okay, let's go!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
								 end
							else 
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Let's get going!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
							end
					  end
					   end

					end
                    if $game_variables[4935]=="000"
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I almost forgot! My name is \\v[4935]! It's nice to meet you!"))
				       commands.push(_INTL("You as well."))
				       commands.push(_INTL("I feel the same."))
				       commands.push(_INTL("I'll be back in a bit."))
                       command = pbShowCommands(msgwindow, commands)
				       case command
				       when 0
			            $player.playerharmony+=3
				       when 1
			            $player.playermoral+=3
				       when 2
			            $player.playerwrath+=3
				       end
				    end
	                pbSetSelfSwitch(10, "A", true, 109)
                    pbSetSelfSwitch(9, "A", true, 109)
                    pbSetSelfSwitch(1, "D", true, 109) 
			  when 2 
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Please find my POKeMON!"))
				 
				 
				 
		      when 3
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] and you brought back my POKeMON! Thanks a lot!"))
			        $player.partner3affinity += $player.partner3affinity+10
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I'm gonna find a safer place to rest and make sure they are okay! Thank you so much!"))
					completeQuest(:PSISQ2, colorQuest("green"))
			  else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! Thanks for helping me out."))
		   end
		 when "red" #Retrieve this asshole and bring them to Red!
		    case queststage
			 when 0
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] What's up? Do you need something?"))
			 end
	     else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! You aren't meant to see this!"))
		 end
		   
		   
	    when 7 #David
		 $game_variables[(wari+8)]="David"
		 case quest
		 when :PSISQ2 #Retrieve My Pokemon!
		   case queststage
		      when 1
			        $player.partner3affinity = $player.partner3affinity.to_i
				    commands.push(_INTL("What's up?"))
				    commands.push(_INTL("Who are you?"))
				    commands.push(_INTL("What happened?"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Darn! Darn! Darn!"))
                    command = pbShowCommands(msgwindow, commands)
					case command
					when 0
					  $player.playerharmony+=2
					  $player.partner3affinity+=3
					  commands = []
				      commands.push(_INTL("Which way did they go?"))
				      commands.push(_INTL("Do you need help?"))
				      commands.push(_INTL("Are you injured?")) if ($player.playerclass == "Healer" || $player.playerharmony > 20)
					  case  command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was napping on this log,and a Rocket robbed me!"))
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] That doesn't matter right now, a Rocket stole my Pokemon!"))
					  when 2
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was traveling through the area and took a rest, and woke up to a Rocket running off with my POKeMON!"))
					  end
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
					  $player.playerwrath+=2
					  $player.partner3affinity+=1
					  commands = []
				      commands.push(_INTL("If you lead, I'll follow!")) if ($player.partner3affinity > 55 || $player.playermoral>55)
				      commands.push(_INTL("Don't worry about it, I'll get them back."))
				      commands.push(_INTL("Good luck!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] They went towards the Swamp!"))
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you would be willing to help, that'd be mighty great."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Just so you know, my name is \\v[4935]."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   when 1
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You'd do that? I guess I could trust you."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] my name is \\v[4935], Thank's a bundle!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   when 2
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You... you aren't gonna help?"))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah well, screw you too buddy!"))
					   pbDisposeMessageWindow(msgwindow)
					   $player.partner3affinity-=20
					   pbCaveEntranceEx(true)
	                   pbSetSelfSwitch(15, "A", true, 28)
					   failQuest(:PSISQ2, colorQuest("red"), true)
					   end
					   when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you don't mind helping me get them back, I would be eternally grateful. The name's \\v[4935], by the way."))
					  if $player.partner3affinity > 55
                      pbMessageDisplay(msgwindow,_INTL("He pauses, sighing."))
					  commands = []
				      commands.push(_INTL("You can come along."))
				      commands.push(_INTL("It's better for you to stay."))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Of course, I might be dead weight, so it's up to you to let me come along."))
                      command = pbShowCommands(msgwindow, commands)
					  case command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Thanks! I'll try not to be dead weight!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah, you're right, I'll be here until you get back."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					  end
					  else
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   
					   
					   
					   end
					   
					   
					   
					   
					   
					   
					   
					   
					   
					   when 2
					  commandsold = commands
					  commands = []
				      commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				      commands.push(_INTL("Whatever you say, just be careful."))
				      commands.push(_INTL("Okay, I'm gonna get going now!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]They didn't kneecap me or anything, just scared me, I feel fine, thanks for asking through."))
                      command = pbShowCommands(msgwindow, commands)
                      case command
					    when 0
						  if $PokemonSystem.survivalmode = 0 && $PokemonSystem.nuzlockemode = 0
						    $bag.remove(:POTION,1)
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks, that'll help no matter what."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Resources like Potions take a lot of work out here, so I at least want to give you something back."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I met a guy out east who let me know that if you boil freshwater, an Argost Berry, and an Enigma Berry in a Cauldron, you can get an item that allows you revive a POKeMON as an Egg."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  else
                            pbMessageDisplay(msgwindow,_INTL("He refuses it."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]You may need it more than me."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  end
					    when 1
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks for the concern."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thinking about it, I will rest here, thanks a bundle."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					    when 2
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I think I want to come with you, if you don't mind."))
							if $player.playerharmony>30
					             commands = []
				                 commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				                 commands.push(_INTL("Whatever you say, just be careful."))
                                 command = pbShowCommands(msgwindow, commands)
								 case command
								 when 0
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]On second thought, I will stay, I do lack POKeMON, and my leg does hurt a little bit."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
								 when 1
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Okay, let's go!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
								 end
							else 
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Let's get going!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
							end
					  end
					   end

					end
                    if $game_variables[4935]=="000"
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I almost forgot! My name is \\v[4935]! It's nice to meet you!"))
				       commands.push(_INTL("You as well."))
				       commands.push(_INTL("I feel the same."))
				       commands.push(_INTL("I'll be back in a bit."))
                       command = pbShowCommands(msgwindow, commands)
				       case command
				       when 0
			            $player.playerharmony+=3
				       when 1
			            $player.playermoral+=3
				       when 2
			            $player.playerwrath+=3
				       end
				    end
	                pbSetSelfSwitch(10, "A", true, 109)
                    pbSetSelfSwitch(9, "A", true, 109)
                    pbSetSelfSwitch(1, "D", true, 109) 
			  when 2 
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Please find my POKeMON!"))
				 
				 
				 
		      when 3
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] and you brought back my POKeMON! Thanks a lot!"))
			        $player.partner3affinity += $player.partner3affinity+10
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I'm gonna find a safer place to rest and make sure they are okay! Thank you so much!"))
					completeQuest(:PSISQ2, colorQuest("green"))
			  else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! Thanks for helping me out."))
		   end
		 when "red" #Retrieve this asshole and bring them to Red!
		    case queststage
			 when 0
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] What's up? Do you need something?"))
			 end
	     else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! You aren't meant to see this!"))
		 end
		   
		   
	    when 8 #Alice
		 $game_variables[(wari+8)]="Alice"
		 case quest
		 when :PSISQ2 #Retrieve My Pokemon!
		   case queststage
		      when 1
			        $player.partner3affinity = $player.partner3affinity.to_i
				    commands.push(_INTL("What's up?"))
				    commands.push(_INTL("Who are you?"))
				    commands.push(_INTL("What happened?"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Darn! Darn! Darn!"))
                    command = pbShowCommands(msgwindow, commands)
					case command
					when 0
					  $player.playerharmony+=2
					  $player.partner3affinity+=3
					  commands = []
				      commands.push(_INTL("Which way did they go?"))
				      commands.push(_INTL("Do you need help?"))
				      commands.push(_INTL("Are you injured?")) if ($player.playerclass == "Healer" || $player.playerharmony > 20)
					  case  command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was napping on this log,and a Rocket robbed me!"))
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] That doesn't matter right now, a Rocket stole my Pokemon!"))
					  when 2
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I was traveling through the area and took a rest, and woke up to a Rocket running off with my POKeMON!"))
					  end
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
					  $player.playerwrath+=2
					  $player.partner3affinity+=1
					  commands = []
				      commands.push(_INTL("If you lead, I'll follow!")) if ($player.partner3affinity > 55 || $player.playermoral>55)
				      commands.push(_INTL("Don't worry about it, I'll get them back."))
				      commands.push(_INTL("Good luck!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] They went towards the Swamp!"))
                      command = pbShowCommands(msgwindow, commands)
					   case command
					   when 0
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you would be willing to help, that'd be mighty great."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Just so you know, my name is \\v[4935]."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   when 1
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You'd do that? I guess I could trust you."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] my name is \\v[4935], Thank's a bundle!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   when 2
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You... you aren't gonna help?"))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah well, screw you too buddy!"))
					   pbDisposeMessageWindow(msgwindow)
					   $player.partner3affinity-=20
					   pbCaveEntranceEx(true)
	                   pbSetSelfSwitch(15, "A", true, 28)
					   failQuest(:PSISQ2, colorQuest("red"), true)
					   end
					   when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you don't mind helping me get them back, I would be eternally grateful. The name's \\v[4935], by the way."))
					  if $player.partner3affinity > 55
                      pbMessageDisplay(msgwindow,_INTL("He pauses, sighing."))
					  commands = []
				      commands.push(_INTL("You can come along."))
				      commands.push(_INTL("It's better for you to stay."))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Of course, I might be dead weight, so it's up to you to let me come along."))
                      command = pbShowCommands(msgwindow, commands)
					  case command
					  when 0
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Thanks! I'll try not to be dead weight!"))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					  when 1
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Yeah, you're right, I'll be here until you get back."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					  end
					  else
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   
					   
					   
					   end
					   
					   
					   
					   
					   
					   
					   
					   
					   
					   when 2
					  commandsold = commands
					  commands = []
				      commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				      commands.push(_INTL("Whatever you say, just be careful."))
				      commands.push(_INTL("Okay, I'm gonna get going now!"))
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]They didn't kneecap me or anything, just scared me, I feel fine, thanks for asking through."))
                      command = pbShowCommands(msgwindow, commands)
                      case command
					    when 0
						  if $PokemonSystem.survivalmode = 0 && $PokemonSystem.nuzlockemode = 0
						    $bag.remove(:POTION,1)
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks, that'll help no matter what."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Resources like Potions take a lot of work out here, so I at least want to give you something back."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I met a guy out east who let me know that if you boil freshwater, an Argost Berry, and an Enigma Berry in a Cauldron, you can get an item that allows you revive a POKeMON as an Egg."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  else
                            pbMessageDisplay(msgwindow,_INTL("He refuses it."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]You may need it more than me."))
					        advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
						  end
					    when 1
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thanks for the concern."))
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Thinking about it, I will rest here, thanks a bundle."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					    when 2
                            pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]I think I want to come with you, if you don't mind."))
							if $player.playerharmony>30
					             commands = []
				                 commands.push(_INTL("It's better to be safe. <Offer a Potion>")) if ($bag.has?(:POTION))
				                 commands.push(_INTL("Whatever you say, just be careful."))
                                 command = pbShowCommands(msgwindow, commands)
								 case command
								 when 0
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]On second thought, I will stay, I do lack POKeMON, and my leg does hurt a little bit."))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
								 when 1
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Okay, let's go!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
								 end
							else 
                                   pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]]Let's get going!"))
					               advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					               Followers.add(15, "Partner3", 93)
							end
					  end
					   end

					end
                    if $game_variables[4935]=="000"
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I almost forgot! My name is \\v[4935]! It's nice to meet you!"))
				       commands.push(_INTL("You as well."))
				       commands.push(_INTL("I feel the same."))
				       commands.push(_INTL("I'll be back in a bit."))
                       command = pbShowCommands(msgwindow, commands)
				       case command
				       when 0
			            $player.playerharmony+=3
				       when 1
			            $player.playermoral+=3
				       when 2
			            $player.playerwrath+=3
				       end
				    end
	                pbSetSelfSwitch(10, "A", true, 109)
                    pbSetSelfSwitch(9, "A", true, 109)
                    pbSetSelfSwitch(1, "D", true, 109) 
			  when 2 
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Please find my POKeMON!"))
				 
				 
				 
		      when 3
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] and you brought back my POKeMON! Thanks a lot!"))
			        $player.partner3affinity += $player.partner3affinity+10
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I'm gonna find a safer place to rest and make sure they are okay! Thank you so much!"))
					completeQuest(:PSISQ2, colorQuest("green"))
			  else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! Thanks for helping me out."))
		   end
		 when "red" #Retrieve this asshole and bring them to Red!
		    case queststage
			 when 0
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] What's up? Do you need something?"))
			 end
	     else
               pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Hey Pal! You aren't meant to see this!"))
		 end
		   
		   
	  end
	  
	  
	  
	  
	  
	  
	  
	  

   
   
   
   
   
   
   
   
   
   
   when 4929
   puts "Partner 4"
     case getvalue
	    when 1 #Brent
		 $game_variables[(wari+8)]="Brent"
	    when 2 #Donna
		 $game_variables[(wari+8)]="Donna"
	    when 3 #Jace
		 $game_variables[(wari+8)]="Jace"
	    when 4 #Sevii
		 $game_variables[(wari+8)]="Sevii"
	    when 5 #John
		$game_variables[(wari+8)]="John"
	    when 6 #Sam
		 $game_variables[(wari+8)]="Sam"
	    when 7 #David
		 $game_variables[(wari+8)]="David"
	    when 8 #Alice
		 $game_variables[(wari+8)]="Alice"
	 end
   when 4930
   puts "Partner 5"
     case getvalue
	    when 1 #Brent
		 $game_variables[(wari+8)]="Brent"
	    when 2 #Donna
		 $game_variables[(wari+8)]="Donna"
	    when 3 #Jace
		 $game_variables[(wari+8)]="Jace"
	    when 4 #Sevii
		 $game_variables[(wari+8)]="Sevii"
	    when 5 #John
		$game_variables[(wari+8)]="John"
	    when 6 #Sam
		 $game_variables[(wari+8)]="Sam"
	    when 7 #David
		 $game_variables[(wari+8)]="David"
	    when 8 #Alice
		 $game_variables[(wari+8)]="Alice"
	 end
   when 4931
   puts "Partner 6"
     case getvalue
	    when 1 #Brent
		 $game_variables[(wari+8)]="Brent"
	    when 2 #Donna
		 $game_variables[(wari+8)]="Donna"
	    when 3 #Jace
		 $game_variables[(wari+8)]="Jace"
	    when 4 #Sevii
		 $game_variables[(wari+8)]="Sevii"
	    when 5 #John
		$game_variables[(wari+8)]="John"
	    when 6 #Sam
		 $game_variables[(wari+8)]="Sam"
	    when 7 #David
		 $game_variables[(wari+8)]="David"
	    when 8 #Alice
		 $game_variables[(wari+8)]="Alice"
	 end
   when 4932
   puts "Partner 7"
     case getvalue
	    when 1 #Brent
		 $game_variables[(wari+8)]="Brent"
	    when 2 #Donna
		 $game_variables[(wari+8)]="Donna"
	    when 3 #Jace
		 $game_variables[(wari+8)]="Jace"
	    when 4 #Sevii
		 $game_variables[(wari+8)]="Sevii"
	    when 5 #John
		$game_variables[(wari+8)]="John"
	    when 6 #Sam
		 $game_variables[(wari+8)]="Sam"
	    when 7 #David
		 $game_variables[(wari+8)]="David"
	    when 8 #Alice
		 $game_variables[(wari+8)]="Alice"
	 end
   when "Red"
   puts "Red"
   when "Blue"
   puts "Blue"
   end
end