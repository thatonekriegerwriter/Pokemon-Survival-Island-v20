def pbIntroQuestionare
      if $DEBUG && Input.press?(Input::CTRL)
	  else
      pbMessage(_INTL("Answer the following questions however you feel strongest."))
      pbMessage(_INTL("There will be a word, Choose the first thing that comes to mind."))
      cmd = pbMessage(_INTL("Arcanine"),[
                            _INTL("Train"), #Warrior,Monk
                            _INTL("Catch"), #Catcher,Guardian
                            _INTL("Run"), #Runner,Alchemist,Mechanist
                            _INTL("Feed"),  #Breeder,Healer
                            _INTL("Dinner")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony-=1 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony-=1 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==3
	 $player.playerwrath-=2 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony-=2 #Emotional
	 $player.playermoral+=2 #Intelligence
	     end
      cmd = pbMessage(_INTL("Forest"),[
                            _INTL("Targets"), #Hunter,Assassin
                            _INTL("Friends"),  #Catcher,Healer
                            _INTL("Danger"), #Runner,Breeder,Monk
                            _INTL("Curiousity"),#Alchemist,Mechanist
                            _INTL("Campfire")]) #Guardian,Warrior
		  if cmd==0
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony-=5 #Emotional
	 $player.playermoral+=3 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=4 #Emotional
	 $player.playermoral+=3 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=3 #Intelligence
		  elsif cmd==3
	 $player.playerwrath-=1 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=5 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=3 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Night"),[
                            _INTL("Shelter"), #Guardian,Warrior
                            _INTL("Dream"),  #Alchemist,Mechanist
                            _INTL("Sleep"), #Runner,Monk
                            _INTL("Comfort"), #Catcher,Healer,Breeder
                            _INTL("Shroud")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=4 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=5 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=4 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=3 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=5 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=3 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=1 #Intelligence
	     end
      cmd = pbMessage(_INTL("Pokemon Center"),[
                            _INTL("Safety"), #Guardian,Warrior
                            _INTL("Healing"),  #Alchemist,Mechanist
                            _INTL("Rest"), #Runner,Monk
                            _INTL("Burglarize"), #Catcher,Healer,Breeder
                            _INTL("Renovate")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=4 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=1 #Emotional
	 $player.playermoral+=2 #Intelligence
	     end
      cmd = pbMessage(_INTL("Grunt"),[
                            _INTL("Bribe"), #Guardian,Warrior
                            _INTL("Fight"),  #Alchemist,Mechanist
                            _INTL("Fear"), #Runner,Monk
                            _INTL("Police"), #Catcher,Healer,Breeder
                            _INTL("Reasonable")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=4 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=5 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=4 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=4 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Light"),[
                            _INTL("Dark"), #Guardian,Warrior
                            _INTL("Heavy"),  #Alchemist,Mechanist
                            _INTL("Flash"), #Runner,Monk
                            _INTL("Torch"), #Catcher,Healer,Breeder
                            _INTL("Sun")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=1 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=1 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=4 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=3 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      pbMessage(_INTL("Here are a few statements, choose if you agree with them or not."))
      cmd = pbMessage(_INTL("I charge in to deal with my problems head on."),[
                            _INTL("Strongly Agree"), #Guardian,Warrior
                            _INTL("Agree"),  #Alchemist,Mechanist
                            _INTL("No Opinion"), #Runner,Monk
                            _INTL("Disagree"), #Catcher,Healer,Breeder
                            _INTL("Strongly Disagree")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=4 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==4
	 $player.playerwrath-=2 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=4 #Intelligence
	     end
      cmd = pbMessage(_INTL("I don't tend to rely on others for support."),[
                            _INTL("Strongly Agree"), #Guardian,Warrior
                            _INTL("Agree"),  #Alchemist,Mechanist
                            _INTL("No Opinion"), #Runner,Monk
                            _INTL("Disagree"), #Catcher,Healer,Breeder
                            _INTL("Strongly Disagree")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=4 #Physical
	 $player.playerharmony-=4 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony-=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==4
	 $player.playerwrath-=4 #Physical
	 $player.playerharmony+=4 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Conflict isn't in my nature."),[
                            _INTL("Strongly Agree"), #Guardian,Warrior
                            _INTL("Agree"),  #Alchemist,Mechanist
                            _INTL("No Opinion"), #Runner,Monk
                            _INTL("Disagree"), #Catcher,Healer,Breeder
                            _INTL("Strongly Disagree")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=4 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=3 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=5 #Physical
	 $player.playerharmony-=2 #Emotional
	 $player.playermoral+=1 #Intelligence
	     end
      cmd = pbMessage(_INTL("I am slow to adapt."),[
                            _INTL("Strongly Agree"), #Guardian,Warrior
                            _INTL("Agree"),  #Alchemist,Mechanist
                            _INTL("No Opinion"), #Runner,Monk
                            _INTL("Disagree"), #Catcher,Healer,Breeder
                            _INTL("Strongly Disagree")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=1 #Emotional
	 $player.playermoral-=1 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=3 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=5 #Intelligence
	     end
      cmd = pbMessage(_INTL("I want to be the center of attention."),[
                            _INTL("Strongly Agree"), #Guardian,Warrior
                            _INTL("Agree"),  #Alchemist,Mechanist
                            _INTL("No Opinion"), #Runner,Monk
                            _INTL("Disagree"), #Catcher,Healer,Breeder
                            _INTL("Strongly Disagree")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=4 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral-=0 #Intelligence
		  elsif cmd==2
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==3
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=1 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==4
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=4 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      pbMessage(_INTL("The following are 'Yes' 'No' type questions."))
      cmd = pbMessage(_INTL("Do you think it's important to always aim to be the best?"),[
                            _INTL("Yes"), #Guardian,Warrior
                            _INTL("No")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=2 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Do you have a cheerful personality?"),[
                            _INTL("Yes"), #Guardian,Warrior
                            _INTL("No")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=1 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=1 #Intelligence
	     end
      cmd = pbMessage(_INTL("Can you focus on something you like?"),[
                            _INTL("Yes"), #Guardian,Warrior
                            _INTL("No")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=1 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=1 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Good news and bad news... Which one do you want to hear first?"),[
                            _INTL("Good"), #Guardian,Warrior
                            _INTL("Bad")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=2 #Physical
	 $player.playerharmony+=3 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=3 #Emotional
	 $player.playermoral+=2 #Intelligence
	     end
      cmd = pbMessage(_INTL("Once you've decided something, do you see it through to the end?"),[
                            _INTL("Yes"), #Guardian,Warrior
                            _INTL("No")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=3 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=0 #Emotional
	 $player.playermoral+=2 #Intelligence
	     end
      cmd = pbMessage(_INTL("Do you like to noisily enjoy yourself with others?"),[
                            _INTL("Yes"), #Guardian,Warrior
                            _INTL("No")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=1 #Physical
	 $player.playerharmony+=2 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath-=0 #Physical
	 $player.playerharmony-=4 #Emotional
	 $player.playermoral-=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Can you strike up conversations with new people easily?"),[
                            _INTL("Yes"), #Guardian,Warrior
                            _INTL("No")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=4 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony-=4 #Emotional
	 $player.playermoral+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Do you sometimes run out of things to do all of a sudden?"),[
                            _INTL("Yes"), #Guardian,Warrior
                            _INTL("No")]) #Hunter,Assassin
		  if cmd==0
	 $player.playerwrath+=3 #Physical
	 $player.playerharmony+=4 #Emotional
	 $player.playermoral+=0 #Intelligence
		  elsif cmd==1
	 $player.playerwrath+=0 #Physical
	 $player.playerharmony+=6 #Emotional
	 $player.playermoral+=3 #Intelligence
	     end
      pbMessage(_INTL("That's all the questions!"))
      pbMessage(_INTL("Here's your results."))
      pbMessage(_INTL("\\l[5]Interpersonal Intelligence: {1}\\nLogical Intelligence: {2}\\nKinesthetic Intelligence: {3}",$player.playerharmony,$player.playermoral,$player.playerwrath))

    # Emotional   (-13) to 45
    # Intelligence   (-1) to 31
    # Physical   (-5) to 36
	 $player.playerclass = "Catcher"
	 if $player.playerwrath >= 15 && $player.playerharmony >= 15
	 $player.playerclass = "Runner"
	 end
	 if $player.playerwrath >= 20 && $player.playerharmony >= 20
	 $player.playerclass = "Guardian"
	 end
	 if $player.playerwrath >= 20 && $player.playermoral >= 10
	 $player.playerclass = "Hunter"
	 end
	 if $player.playerwrath >= 20 && $player.playermoral >= 20
	 $player.playerclass = "Assassin"
	 end
	 if $player.playerwrath >= 15 && $player.playerharmony >= 15  && $player.playerharmony >= 10
	 $player.playerclass = "Monk"
	 end
	 if $player.playermoral >= 15 && $player.playerharmony >= 15
	 $player.playerclass = "Breeder"
	 end
	 if $player.playerwrath >= 20 && $player.playerharmony >= 20
	 $player.playerclass = "Runner"
	 end
	 if $player.playerwrath >= 25 && $player.playerharmony >= 25
	 $player.playerclass = "Guardian"
	 end
	 if $player.playerwrath >= 25 && $player.playermoral >= 15
	 $player.playerclass = "Hunter"
	 end
	 if $player.playerwrath >= 25 && $player.playermoral >= 25
	 $player.playerclass = "Assassin"
	 end
	 if $player.playerwrath >= 20 && $player.playerharmony >= 20  && $player.playerharmony >= 15
	 $player.playerclass = "Monk"
	 end
	 if $player.playermoral >= 20 && $player.playerharmony >= 20
	 $player.playerclass = "Breeder"
	 end
	 if $player.playermoral >= 25 && $player.playerharmony >= 25
	 $player.playerclass = "Alchemist"
	 end
	 if $player.playerwrath >= 30
	 $player.playerclass = "Warrior"
	 end
	 if $player.playerharmony >= 30
	 $player.playerclass = "Healer" 
	 end
	 if $player.playermoral >= 30
	 $player.playerclass = "Mechanist"
     end


	 if $player.playerclass == "Runner" #$game_variables[50]==1 Runner
      pbMessage(_INTL("You are a Runner."))
      pbMessage(_INTL("You get less overworld encounters, that's just how you are."))
	 elsif $player.playerclass == "Warrior"#$game_variables[50]==2 
      pbMessage(_INTL("You are a Warrior."))
      pbMessage(_INTL("Your POKeMON will occasionally not use PP."))
	 elsif $player.playerclass == "Assassin"#$game_variables[50]==3
      pbMessage(_INTL("You are a Assassin."))
      pbMessage(_INTL("All your POKeMON have increased evasion."))
	 elsif $player.playerclass == "Monk"#$game_variables[50]==4
      pbMessage(_INTL("You are a Monk."))
      pbMessage(_INTL("All your POKeMON have increased Loyalty."))
	 elsif $player.playerclass == "Alchemist"#$game_variables[50]==5
      pbMessage(_INTL("You are an Alchemist."))
      pbMessage(_INTL("Your moves that inflict status ailments will inflict them."))
	 elsif $player.playerclass == "Guardian"#$game_variables[50]==6
      pbMessage(_INTL("You are a Guardian."))
      pbMessage(_INTL("All your POKeMONs multistrike moves hit the max amount."))
	 elsif $player.playerclass == "Hunter"#$game_variables[50]==7
      pbMessage(_INTL("You are a Hunter."))
      pbMessage(_INTL("All your POKeMON have increased chance of critical hits."))
	 elsif $player.playerclass == "Mechanist"#$game_variables[50]==8
      pbMessage(_INTL("You are a Mechanist."))
      pbMessage(_INTL("You can craft machines without Machine Boxs, and can craft PCs."))
	 elsif $player.playerclass == "Healer"#$game_variables[50]==9
      pbMessage(_INTL("You are a Healer."))
      pbMessage(_INTL("Health-recovering moves recover additional health."))
      pbMessage(_INTL("It is said you can heal with a touch."))
	 elsif $player.playerclass == "Breeder"#$game_variables[50]==10
      pbMessage(_INTL("You are a Breeder."))
      pbMessage(_INTL("You have a higher chance to have eggs spawn."))
	 elsif $player.playerclass == "Catcher"#$game_variables[50]==12
      pbMessage(_INTL("You are a catcher."))
      pbMessage(_INTL("You have a chance to recover failed POKeBALL throws."))
	 end
	 end
      pbMessage(_INTL("Of course, you don't have to be what your answers give, you can choose what you want to be!"))
  command = 0
    command = pbShowCommands(nil,
       [_INTL("I want what I got."),
       _INTL("Catcher!"),
       _INTL("Runner!"),
       _INTL("Guardian!"),
       _INTL("Hunter!"),
       _INTL("Assassin!"),
       _INTL("Monk!"),
       _INTL("Alchemist!"),
       _INTL("Breeder!"),
       _INTL("Warrior!"),
       _INTL("Healer!"),
       _INTL("Mechanist!")],-1,command)
    case command
    when 0   # Withdraw Item
    when 1   # Deposit Item
	$player.playerclass = "Catcher"
	 if $player.playerclass == "Runner" #$game_variables[50]==1 Runner
      pbMessage(_INTL("You are a Runner."))
      pbMessage(_INTL("You get less overworld encounters, that's just how you are."))
	 elsif $player.playerclass == "Warrior"#$game_variables[50]==2 
      pbMessage(_INTL("You are a Warrior."))
      pbMessage(_INTL("Your POKeMON will occasionally not use PP."))
	 elsif $player.playerclass == "Assassin"#$game_variables[50]==3
      pbMessage(_INTL("You are a Assassin."))
      pbMessage(_INTL("All your POKeMON have increased evasion."))
	 elsif $player.playerclass == "Monk"#$game_variables[50]==4
      pbMessage(_INTL("You are a Monk."))
      pbMessage(_INTL("All your POKeMON have increased Loyalty."))
	 elsif $player.playerclass == "Alchemist"#$game_variables[50]==5
      pbMessage(_INTL("You are an Alchemist."))
      pbMessage(_INTL("Your moves that inflict status ailments will inflict them."))
	 elsif $player.playerclass == "Guardian"#$game_variables[50]==6
      pbMessage(_INTL("You are a Guardian."))
      pbMessage(_INTL("All your POKeMONs multistrike moves hit the max amount."))
	 elsif $player.playerclass == "Hunter"#$game_variables[50]==7
      pbMessage(_INTL("You are a Hunter."))
      pbMessage(_INTL("All your POKeMON have increased chance of critical hits."))
	 elsif $player.playerclass == "Mechanist"#$game_variables[50]==8
      pbMessage(_INTL("You are a Mechanist."))
      pbMessage(_INTL("You can craft machines without Machine Boxs, and can craft PCs."))
	 elsif $player.playerclass == "Healer"#$game_variables[50]==9
      pbMessage(_INTL("You are a Healer."))
      pbMessage(_INTL("Health-recovering moves recover additional health."))
	 elsif $player.playerclass == "Breeder"#$game_variables[50]==10
      pbMessage(_INTL("You are a Breeder."))
      pbMessage(_INTL("You have a higher chance to have eggs spawn."))
	 elsif $player.playerclass == "Catcher"#$game_variables[50]==12
      pbMessage(_INTL("You are a catcher."))
      pbMessage(_INTL("You have a chance to recover failed POKeBALL throws."))
	 end
    when 2   # Toss Item
	$player.playerclass = "Runner"
	 if $player.playerclass == "Runner" #$game_variables[50]==1 Runner
      pbMessage(_INTL("You are a Runner."))
      pbMessage(_INTL("You get less overworld encounters, that's just how you are."))
	 elsif $player.playerclass == "Warrior"#$game_variables[50]==2 
      pbMessage(_INTL("You are a Warrior."))
      pbMessage(_INTL("Your POKeMON will occasionally not use PP."))
	 elsif $player.playerclass == "Assassin"#$game_variables[50]==3
      pbMessage(_INTL("You are a Assassin."))
      pbMessage(_INTL("All your POKeMON have increased evasion."))
	 elsif $player.playerclass == "Monk"#$game_variables[50]==4
      pbMessage(_INTL("You are a Monk."))
      pbMessage(_INTL("All your POKeMON have increased Loyalty."))
	 elsif $player.playerclass == "Alchemist"#$game_variables[50]==5
      pbMessage(_INTL("You are an Alchemist."))
      pbMessage(_INTL("Your moves that inflict status ailments will inflict them."))
	 elsif $player.playerclass == "Guardian"#$game_variables[50]==6
      pbMessage(_INTL("You are a Guardian."))
      pbMessage(_INTL("All your POKeMONs multistrike moves hit the max amount."))
	 elsif $player.playerclass == "Hunter"#$game_variables[50]==7
      pbMessage(_INTL("You are a Hunter."))
      pbMessage(_INTL("All your POKeMON have increased chance of critical hits."))
	 elsif $player.playerclass == "Mechanist"#$game_variables[50]==8
      pbMessage(_INTL("You are a Mechanist."))
      pbMessage(_INTL("You can craft machines without Machine Boxs, and can craft PCs."))
	 elsif $player.playerclass == "Healer"#$game_variables[50]==9
      pbMessage(_INTL("You are a Healer."))
      pbMessage(_INTL("Health-recovering moves recover additional health."))
	 elsif $player.playerclass == "Breeder"#$game_variables[50]==10
      pbMessage(_INTL("You are a Breeder."))
      pbMessage(_INTL("You have a higher chance to have eggs spawn."))
	 elsif $player.playerclass == "Catcher"#$game_variables[50]==12
      pbMessage(_INTL("You are a catcher."))
      pbMessage(_INTL("You have a chance to recover failed POKeBALL throws."))
	 end
    when 3   # Toss Item
	$player.playerclass = "Guardian"
	 if $player.playerclass == "Runner" #$game_variables[50]==1 Runner
      pbMessage(_INTL("You are a Runner."))
      pbMessage(_INTL("You get less overworld encounters, that's just how you are."))
	 elsif $player.playerclass == "Warrior"#$game_variables[50]==2 
      pbMessage(_INTL("You are a Warrior."))
      pbMessage(_INTL("Your POKeMON will occasionally not use PP."))
	 elsif $player.playerclass == "Assassin"#$game_variables[50]==3
      pbMessage(_INTL("You are a Assassin."))
      pbMessage(_INTL("All your POKeMON have increased evasion."))
	 elsif $player.playerclass == "Monk"#$game_variables[50]==4
      pbMessage(_INTL("You are a Monk."))
      pbMessage(_INTL("All your POKeMON have increased Loyalty."))
	 elsif $player.playerclass == "Alchemist"#$game_variables[50]==5
      pbMessage(_INTL("You are an Alchemist."))
      pbMessage(_INTL("Your moves that inflict status ailments will inflict them."))
	 elsif $player.playerclass == "Guardian"#$game_variables[50]==6
      pbMessage(_INTL("You are a Guardian."))
      pbMessage(_INTL("All your POKeMONs multistrike moves hit the max amount."))
	 elsif $player.playerclass == "Hunter"#$game_variables[50]==7
      pbMessage(_INTL("You are a Hunter."))
      pbMessage(_INTL("All your POKeMON have increased chance of critical hits."))
	 elsif $player.playerclass == "Mechanist"#$game_variables[50]==8
      pbMessage(_INTL("You are a Mechanist."))
      pbMessage(_INTL("You can craft machines without Machine Boxs, and can craft PCs."))
	 elsif $player.playerclass == "Healer"#$game_variables[50]==9
      pbMessage(_INTL("You are a Healer."))
      pbMessage(_INTL("Health-recovering moves recover additional health."))
	 elsif $player.playerclass == "Breeder"#$game_variables[50]==10
      pbMessage(_INTL("You are a Breeder."))
      pbMessage(_INTL("You have a higher chance to have eggs spawn."))
	 elsif $player.playerclass == "Catcher"#$game_variables[50]==12
      pbMessage(_INTL("You are a catcher."))
      pbMessage(_INTL("You have a chance to recover failed POKeBALL throws."))
	 end
    when 4   # Toss Item
	$player.playerclass = "Hunter"
	 if $player.playerclass == "Runner" #$game_variables[50]==1 Runner
      pbMessage(_INTL("You are a Runner."))
      pbMessage(_INTL("You get less overworld encounters, that's just how you are."))
	 elsif $player.playerclass == "Warrior"#$game_variables[50]==2 
      pbMessage(_INTL("You are a Warrior."))
      pbMessage(_INTL("Your POKeMON will occasionally not use PP."))
	 elsif $player.playerclass == "Assassin"#$game_variables[50]==3
      pbMessage(_INTL("You are a Assassin."))
      pbMessage(_INTL("All your POKeMON have increased evasion."))
	 elsif $player.playerclass == "Monk"#$game_variables[50]==4
      pbMessage(_INTL("You are a Monk."))
      pbMessage(_INTL("All your POKeMON have increased Loyalty."))
	 elsif $player.playerclass == "Alchemist"#$game_variables[50]==5
      pbMessage(_INTL("You are an Alchemist."))
      pbMessage(_INTL("Your moves that inflict status ailments will inflict them."))
	 elsif $player.playerclass == "Guardian"#$game_variables[50]==6
      pbMessage(_INTL("You are a Guardian."))
      pbMessage(_INTL("All your POKeMONs multistrike moves hit the max amount."))
	 elsif $player.playerclass == "Hunter"#$game_variables[50]==7
      pbMessage(_INTL("You are a Hunter."))
      pbMessage(_INTL("All your POKeMON have increased chance of critical hits."))
	 elsif $player.playerclass == "Mechanist"#$game_variables[50]==8
      pbMessage(_INTL("You are a Mechanist."))
      pbMessage(_INTL("You can craft machines without Machine Boxs, and can craft PCs."))
	 elsif $player.playerclass == "Healer"#$game_variables[50]==9
      pbMessage(_INTL("You are a Healer."))
      pbMessage(_INTL("Health-recovering moves recover additional health."))
	 elsif $player.playerclass == "Breeder"#$game_variables[50]==10
      pbMessage(_INTL("You are a Breeder."))
      pbMessage(_INTL("You have a higher chance to have eggs spawn."))
	 elsif $player.playerclass == "Catcher"#$game_variables[50]==12
      pbMessage(_INTL("You are a catcher."))
      pbMessage(_INTL("You have a chance to recover failed POKeBALL throws."))
	 end
    when 5   # Toss Item
	$player.playerclass = "Assassin"
	 if $player.playerclass == "Runner" #$game_variables[50]==1 Runner
      pbMessage(_INTL("You are a Runner."))
      pbMessage(_INTL("You get less overworld encounters, that's just how you are."))
	 elsif $player.playerclass == "Warrior"#$game_variables[50]==2 
      pbMessage(_INTL("You are a Warrior."))
      pbMessage(_INTL("Your POKeMON will occasionally not use PP."))
	 elsif $player.playerclass == "Assassin"#$game_variables[50]==3
      pbMessage(_INTL("You are a Assassin."))
      pbMessage(_INTL("All your POKeMON have increased evasion."))
	 elsif $player.playerclass == "Monk"#$game_variables[50]==4
      pbMessage(_INTL("You are a Monk."))
      pbMessage(_INTL("All your POKeMON have increased Loyalty."))
	 elsif $player.playerclass == "Alchemist"#$game_variables[50]==5
      pbMessage(_INTL("You are an Alchemist."))
      pbMessage(_INTL("Your moves that inflict status ailments will inflict them."))
	 elsif $player.playerclass == "Guardian"#$game_variables[50]==6
      pbMessage(_INTL("You are a Guardian."))
      pbMessage(_INTL("All your POKeMONs multistrike moves hit the max amount."))
	 elsif $player.playerclass == "Hunter"#$game_variables[50]==7
      pbMessage(_INTL("You are a Hunter."))
      pbMessage(_INTL("All your POKeMON have increased chance of critical hits."))
	 elsif $player.playerclass == "Mechanist"#$game_variables[50]==8
      pbMessage(_INTL("You are a Mechanist."))
      pbMessage(_INTL("You can craft machines without Machine Boxs, and can craft PCs."))
	 elsif $player.playerclass == "Healer"#$game_variables[50]==9
      pbMessage(_INTL("You are a Healer."))
      pbMessage(_INTL("Health-recovering moves recover additional health."))
	 elsif $player.playerclass == "Breeder"#$game_variables[50]==10
      pbMessage(_INTL("You are a Breeder."))
      pbMessage(_INTL("You have a higher chance to have eggs spawn."))
	 elsif $player.playerclass == "Catcher"#$game_variables[50]==12
      pbMessage(_INTL("You are a catcher."))
      pbMessage(_INTL("You have a chance to recover failed POKeBALL throws."))
	 end
    when 6   # Toss Item
	$player.playerclass = "Monk"
	 if $player.playerclass == "Runner" #$game_variables[50]==1 Runner
      pbMessage(_INTL("You are a Runner."))
      pbMessage(_INTL("You get less overworld encounters, that's just how you are."))
	 elsif $player.playerclass == "Warrior"#$game_variables[50]==2 
      pbMessage(_INTL("You are a Warrior."))
      pbMessage(_INTL("Your POKeMON will occasionally not use PP."))
	 elsif $player.playerclass == "Assassin"#$game_variables[50]==3
      pbMessage(_INTL("You are a Assassin."))
      pbMessage(_INTL("All your POKeMON have increased evasion."))
	 elsif $player.playerclass == "Monk"#$game_variables[50]==4
      pbMessage(_INTL("You are a Monk."))
      pbMessage(_INTL("All your POKeMON have increased Loyalty."))
	 elsif $player.playerclass == "Alchemist"#$game_variables[50]==5
      pbMessage(_INTL("You are an Alchemist."))
      pbMessage(_INTL("Your moves that inflict status ailments will inflict them."))
	 elsif $player.playerclass == "Guardian"#$game_variables[50]==6
      pbMessage(_INTL("You are a Guardian."))
      pbMessage(_INTL("All your POKeMONs multistrike moves hit the max amount."))
	 elsif $player.playerclass == "Hunter"#$game_variables[50]==7
      pbMessage(_INTL("You are a Hunter."))
      pbMessage(_INTL("All your POKeMON have increased chance of critical hits."))
	 elsif $player.playerclass == "Mechanist"#$game_variables[50]==8
      pbMessage(_INTL("You are a Mechanist."))
      pbMessage(_INTL("You can craft machines without Machine Boxs, and can craft PCs."))
	 elsif $player.playerclass == "Healer"#$game_variables[50]==9
      pbMessage(_INTL("You are a Healer."))
      pbMessage(_INTL("Health-recovering moves recover additional health."))
	 elsif $player.playerclass == "Breeder"#$game_variables[50]==10
      pbMessage(_INTL("You are a Breeder."))
      pbMessage(_INTL("You have a higher chance to have eggs spawn."))
	 elsif $player.playerclass == "Catcher"#$game_variables[50]==12
      pbMessage(_INTL("You are a catcher."))
      pbMessage(_INTL("You have a chance to recover failed POKeBALL throws."))
	 end
    when 7   # Toss Item
	$player.playerclass = "Alchemist"
	 if $player.playerclass == "Runner" #$game_variables[50]==1 Runner
      pbMessage(_INTL("You are a Runner."))
      pbMessage(_INTL("You get less overworld encounters, that's just how you are."))
	 elsif $player.playerclass == "Warrior"#$game_variables[50]==2 
      pbMessage(_INTL("You are a Warrior."))
      pbMessage(_INTL("Your POKeMON will occasionally not use PP."))
	 elsif $player.playerclass == "Assassin"#$game_variables[50]==3
      pbMessage(_INTL("You are a Assassin."))
      pbMessage(_INTL("All your POKeMON have increased evasion."))
	 elsif $player.playerclass == "Monk"#$game_variables[50]==4
      pbMessage(_INTL("You are a Monk."))
      pbMessage(_INTL("All your POKeMON have increased Loyalty."))
	 elsif $player.playerclass == "Alchemist"#$game_variables[50]==5
      pbMessage(_INTL("You are an Alchemist."))
      pbMessage(_INTL("Your moves that inflict status ailments will inflict them."))
	 elsif $player.playerclass == "Guardian"#$game_variables[50]==6
      pbMessage(_INTL("You are a Guardian."))
      pbMessage(_INTL("All your POKeMONs multistrike moves hit the max amount."))
	 elsif $player.playerclass == "Hunter"#$game_variables[50]==7
      pbMessage(_INTL("You are a Hunter."))
      pbMessage(_INTL("All your POKeMON have increased chance of critical hits."))
	 elsif $player.playerclass == "Mechanist"#$game_variables[50]==8
      pbMessage(_INTL("You are a Mechanist."))
      pbMessage(_INTL("You can craft machines without Machine Boxs, and can craft PCs."))
	 elsif $player.playerclass == "Healer"#$game_variables[50]==9
      pbMessage(_INTL("You are a Healer."))
      pbMessage(_INTL("Health-recovering moves recover additional health."))
	 elsif $player.playerclass == "Breeder"#$game_variables[50]==10
      pbMessage(_INTL("You are a Breeder."))
      pbMessage(_INTL("You have a higher chance to have eggs spawn."))
	 elsif $player.playerclass == "Catcher"#$game_variables[50]==12
      pbMessage(_INTL("You are a catcher."))
      pbMessage(_INTL("You have a chance to recover failed POKeBALL throws."))
	 end
    when 8   # Toss Item
	$player.playerclass = "Breeder"
	 if $player.playerclass == "Runner" #$game_variables[50]==1 Runner
      pbMessage(_INTL("You are a Runner."))
      pbMessage(_INTL("You get less overworld encounters, that's just how you are."))
	 elsif $player.playerclass == "Warrior"#$game_variables[50]==2 
      pbMessage(_INTL("You are a Warrior."))
      pbMessage(_INTL("Your POKeMON will occasionally not use PP."))
	 elsif $player.playerclass == "Assassin"#$game_variables[50]==3
      pbMessage(_INTL("You are a Assassin."))
      pbMessage(_INTL("All your POKeMON have increased evasion."))
	 elsif $player.playerclass == "Monk"#$game_variables[50]==4
      pbMessage(_INTL("You are a Monk."))
      pbMessage(_INTL("All your POKeMON have increased Loyalty."))
	 elsif $player.playerclass == "Alchemist"#$game_variables[50]==5
      pbMessage(_INTL("You are an Alchemist."))
      pbMessage(_INTL("Your moves that inflict status ailments will inflict them."))
	 elsif $player.playerclass == "Guardian"#$game_variables[50]==6
      pbMessage(_INTL("You are a Guardian."))
      pbMessage(_INTL("All your POKeMONs multistrike moves hit the max amount."))
	 elsif $player.playerclass == "Hunter"#$game_variables[50]==7
      pbMessage(_INTL("You are a Hunter."))
      pbMessage(_INTL("All your POKeMON have increased chance of critical hits."))
	 elsif $player.playerclass == "Mechanist"#$game_variables[50]==8
      pbMessage(_INTL("You are a Mechanist."))
      pbMessage(_INTL("You can craft machines without Machine Boxs, and can craft PCs."))
	 elsif $player.playerclass == "Healer"#$game_variables[50]==9
      pbMessage(_INTL("You are a Healer."))
      pbMessage(_INTL("Health-recovering moves recover additional health."))
	 elsif $player.playerclass == "Breeder"#$game_variables[50]==10
      pbMessage(_INTL("You are a Breeder."))
      pbMessage(_INTL("You have a higher chance to have eggs spawn."))
	 elsif $player.playerclass == "Catcher"#$game_variables[50]==12
      pbMessage(_INTL("You are a catcher."))
      pbMessage(_INTL("You have a chance to recover failed POKeBALL throws."))
	 end
    when 9   # Toss Item
	$player.playerclass = "Warrior"
	 if $player.playerclass == "Runner" #$game_variables[50]==1 Runner
      pbMessage(_INTL("You are a Runner."))
      pbMessage(_INTL("You get less overworld encounters, that's just how you are."))
	 elsif $player.playerclass == "Warrior"#$game_variables[50]==2 
      pbMessage(_INTL("You are a Warrior."))
      pbMessage(_INTL("Your POKeMON will occasionally not use PP."))
	 elsif $player.playerclass == "Assassin"#$game_variables[50]==3
      pbMessage(_INTL("You are a Assassin."))
      pbMessage(_INTL("All your POKeMON have increased evasion."))
	 elsif $player.playerclass == "Monk"#$game_variables[50]==4
      pbMessage(_INTL("You are a Monk."))
      pbMessage(_INTL("All your POKeMON have increased Loyalty."))
	 elsif $player.playerclass == "Alchemist"#$game_variables[50]==5
      pbMessage(_INTL("You are an Alchemist."))
      pbMessage(_INTL("Your moves that inflict status ailments will inflict them."))
	 elsif $player.playerclass == "Guardian"#$game_variables[50]==6
      pbMessage(_INTL("You are a Guardian."))
      pbMessage(_INTL("All your POKeMONs multistrike moves hit the max amount."))
	 elsif $player.playerclass == "Hunter"#$game_variables[50]==7
      pbMessage(_INTL("You are a Hunter."))
      pbMessage(_INTL("All your POKeMON have increased chance of critical hits."))
	 elsif $player.playerclass == "Mechanist"#$game_variables[50]==8
      pbMessage(_INTL("You are a Mechanist."))
      pbMessage(_INTL("You can craft machines without Machine Boxs, and can craft PCs."))
	 elsif $player.playerclass == "Healer"#$game_variables[50]==9
      pbMessage(_INTL("You are a Healer."))
      pbMessage(_INTL("Health-recovering moves recover additional health."))
	 elsif $player.playerclass == "Breeder"#$game_variables[50]==10
      pbMessage(_INTL("You are a Breeder."))
      pbMessage(_INTL("You have a higher chance to have eggs spawn."))
	 elsif $player.playerclass == "Catcher"#$game_variables[50]==12
      pbMessage(_INTL("You are a catcher."))
      pbMessage(_INTL("You have a chance to recover failed POKeBALL throws."))
	 end
    when 10   # Toss Item
	$player.playerclass = "Healer"
	 if $player.playerclass == "Runner" #$game_variables[50]==1 Runner
      pbMessage(_INTL("You are a Runner."))
      pbMessage(_INTL("You get less overworld encounters, that's just how you are."))
	 elsif $player.playerclass == "Warrior"#$game_variables[50]==2 
      pbMessage(_INTL("You are a Warrior."))
      pbMessage(_INTL("Your POKeMON will occasionally not use PP."))
	 elsif $player.playerclass == "Assassin"#$game_variables[50]==3
      pbMessage(_INTL("You are a Assassin."))
      pbMessage(_INTL("All your POKeMON have increased evasion."))
	 elsif $player.playerclass == "Monk"#$game_variables[50]==4
      pbMessage(_INTL("You are a Monk."))
      pbMessage(_INTL("All your POKeMON have increased Loyalty."))
	 elsif $player.playerclass == "Alchemist"#$game_variables[50]==5
      pbMessage(_INTL("You are an Alchemist."))
      pbMessage(_INTL("Your moves that inflict status ailments will inflict them."))
	 elsif $player.playerclass == "Guardian"#$game_variables[50]==6
      pbMessage(_INTL("You are a Guardian."))
      pbMessage(_INTL("All your POKeMONs multistrike moves hit the max amount."))
	 elsif $player.playerclass == "Hunter"#$game_variables[50]==7
      pbMessage(_INTL("You are a Hunter."))
      pbMessage(_INTL("All your POKeMON have increased chance of critical hits."))
	 elsif $player.playerclass == "Mechanist"#$game_variables[50]==8
      pbMessage(_INTL("You are a Mechanist."))
      pbMessage(_INTL("You can craft machines without Machine Boxs, and can craft PCs."))
	 elsif $player.playerclass == "Healer"#$game_variables[50]==9
      pbMessage(_INTL("You are a Healer."))
      pbMessage(_INTL("Health-recovering moves recover additional health."))
	 elsif $player.playerclass == "Breeder"#$game_variables[50]==10
      pbMessage(_INTL("You are a Breeder."))
      pbMessage(_INTL("You have a higher chance to have eggs spawn."))
	 elsif $player.playerclass == "Catcher"#$game_variables[50]==12
      pbMessage(_INTL("You are a catcher."))
      pbMessage(_INTL("You have a chance to recover failed POKeBALL throws."))
	 end
    when 11   # Toss Item
	$player.playerclass = "Mechanist"
	 if $player.playerclass == "Runner" #$game_variables[50]==1 Runner
      pbMessage(_INTL("You are a Runner."))
      pbMessage(_INTL("You get less overworld encounters, that's just how you are."))
	 elsif $player.playerclass == "Warrior"#$game_variables[50]==2 
      pbMessage(_INTL("You are a Warrior."))
      pbMessage(_INTL("Your POKeMON will occasionally not use PP."))
	 elsif $player.playerclass == "Assassin"#$game_variables[50]==3
      pbMessage(_INTL("You are a Assassin."))
      pbMessage(_INTL("All your POKeMON have increased evasion."))
	 elsif $player.playerclass == "Monk"#$game_variables[50]==4
      pbMessage(_INTL("You are a Monk."))
      pbMessage(_INTL("All your POKeMON have increased Loyalty."))
	 elsif $player.playerclass == "Alchemist"#$game_variables[50]==5
      pbMessage(_INTL("You are an Alchemist."))
      pbMessage(_INTL("Your moves that inflict status ailments will inflict them."))
	 elsif $player.playerclass == "Guardian"#$game_variables[50]==6
      pbMessage(_INTL("You are a Guardian."))
      pbMessage(_INTL("All your POKeMONs multistrike moves hit the max amount."))
	 elsif $player.playerclass == "Hunter"#$game_variables[50]==7
      pbMessage(_INTL("You are a Hunter."))
      pbMessage(_INTL("All your POKeMON have increased chance of critical hits."))
	 elsif $player.playerclass == "Mechanist"#$game_variables[50]==8
      pbMessage(_INTL("You are a Mechanist."))
      pbMessage(_INTL("You can craft machines without Machine Boxs, and can craft PCs."))
	 elsif $player.playerclass == "Healer"#$game_variables[50]==9
      pbMessage(_INTL("You are a Healer."))
      pbMessage(_INTL("Health-recovering moves recover additional health."))
	 elsif $player.playerclass == "Breeder"#$game_variables[50]==10
      pbMessage(_INTL("You are a Breeder."))
      pbMessage(_INTL("You have a higher chance to have eggs spawn."))
	 elsif $player.playerclass == "Catcher"#$game_variables[50]==12
      pbMessage(_INTL("You are a catcher."))
      pbMessage(_INTL("You have a chance to recover failed POKeBALL throws."))
	 end
    end
  end

