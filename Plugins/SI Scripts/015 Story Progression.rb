def pbStoryProgression


end




def pbActivatePlotlineQuest(quest,vari)
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
name = vari+8
if $game_variables[name] == 000
$game_variables[name]="???"
end
queststage = getCurrentStage(quest)
msgwindow = pbCreateMessageWindow(nil,nil)
case quest
when :PSISQ2
pbGetTextBasedOnVariable(msgwindow,vari,queststage)
end
pbDisposeMessageWindow(msgwindow)
end

def pbGetTextBasedOnVariable(msgwindow,vari,queststage)
   commands = []
   getvalue = pbGet(vari)
   case vari
   when 4928
      case getvalue
	    when 1
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
					   $game_variables[(wari+8)]="Brent"
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Just so you know, my name is Brent."))
					   advanceQuestToStage(:PSISQ2,3, colorQuest("blue"), true)
					   Followers.add(15, "Partner3", 93)
					   when 1
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] You'd do that? I guess I could trust you."))
					   $game_variables[(wari+8)]="Brent"
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] My name is Brent, Thank's a bundle!"))
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
					  $game_variables[4935]="Brent"
                      pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] If you don't mind helping me get them back, I would be eternally grateful. The name's Brent, by the way."))
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
				       $game_variables[4935]="Brent"
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I almost forgot! My name is Brent! It's nice to meet you!"))
				       commands.push(_INTL("You as well."))
				       commands.push(_INTL("I feel the same."))
				       commands.push(_INTL("I'll be back in a bit."))
                       pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Darn! Darn! Darn!"))
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

			  when 2 
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Please find my POKeMON!"))
				 
				 
				 
		      when 3
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] Oh! You're back!"))
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] and you brought back my POKeMON! Thanks a lot!"))
			        $player.partner3affinity += $player.partner3affinity+10
                    pbMessageDisplay(msgwindow,_INTL("\\xn[\\v[4935]] I'm gonna find a safer place to rest and make sure they are okay! Thank you so much!"))
					completeQuest(:PSISQ2, colorQuest("green"))
	                pbSetSelfSwitch(15, "A", true, 28)
		   end
		   
		   
		   
		   
		   
		   
		   
		   
		   
		   
	    when 2
	    when 3
	    when 4
	    when 5
	    when 6
	    when 7
	    when 8
	  end
	  
	  
	  
	  
	  
	  
	  
	  
	if queststage==1
	pbSetSelfSwitch(10, "A", true, 109)
    pbSetSelfSwitch(9, "A", true, 109)
    pbSetSelfSwitch(1, "D", true, 109) 
	end
   when 4929
   end
end