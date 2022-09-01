def pbIntroQuestionare
      pbDisplay(_INTL("Before we continue, I have several questions for you."))
      pbDisplay(_INTL("I want you to answer them however you feel strongest."))
      pbDisplay(_INTL("I'm going to say a word, I want you to tell me the first thing that comes to mind."))
      cmd = pbMessage(_INTL("Growlithe"),[
                            _INTL("Train"), #Warrior,Monk
                            _INTL("Catch"), #Catcher,Guardian
                            _INTL("Run"), #Runner,Alchemist,Mechanist
                            _INTL("Feed"),  #Breeder,Healer
                            _INTL("Dinner")]) #Hunter,Assassin
		  if cmd==0
	 $Trainer.playerphysical+=2 #Physical
	 $Trainer.playeremotional-=1 #Emotional
	 $Trainer.playerintelligence+=1 #Intelligence
		  elsif cmd==1
	 $Trainer.playerphysical+=1 #Physical
	 $Trainer.playeremotional+=2 #Emotional
	 $Trainer.playerintelligence-=2 #Intelligence
		  elsif cmd==2
	 $Trainer.playerphysical+=2 #Physical
	 $Trainer.playeremotional-=1 #Emotional
	 $Trainer.playerintelligence+=2 #Intelligence
		  elsif cmd==3
	 $Trainer.playerphysical-=2 #Physical
	 $Trainer.playeremotional+=2 #Emotional
	 $Trainer.playerintelligence+=2 #Intelligence
		  elsif cmd==4
	 $Trainer.playerphysical+=2 #Physical
	 $Trainer.playeremotional-=2 #Emotional
	 $Trainer.playerintelligence+=2 #Intelligence
	     end
      cmd = pbMessage(_INTL("Forest"),[
                            _INTL("Targets"), #Hunter,Assassin
                            _INTL("Friends"),  #Catcher,Healer
                            _INTL("Danger"), #Runner,Breeder,Monk
                            _INTL("Curiousity"),#Alchemist,Mechanist
                            _INTL("Campfire")]) #Guardian,Warrior
		  if cmd==0
	 $Trainer.playerphysical+=2 #Physical
	 $Trainer.playeremotional-=5 #Emotional
	 $Trainer.playerintelligence+=3 #Intelligence
		  elsif cmd==1
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=4 #Emotional
	 $Trainer.playerintelligence+=3 #Intelligence
		  elsif cmd==2
	 $Trainer.playerphysical+=1 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=3 #Intelligence
		  elsif cmd==3
	 $Trainer.playerphysical-=1 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=5 #Intelligence
		  elsif cmd==4
	 $Trainer.playerphysical+=3 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Night"),[
                            _INTL("Shelter"), #Guardian,Warrior
                            _INTL("Dream"),  #Alchemist,Mechanist
                            _INTL("Sleep"), #Runner,Monk
                            _INTL("Comfort"), #Catcher,Healer,Breeder
                            _INTL("Shroud")]) #Hunter,Assassin
		  if cmd==0
	 $Trainer.playerphysical+=2 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=2 #Intelligence
		  elsif cmd==1
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=2 #Emotional
	 $Trainer.playerintelligence+=4 #Intelligence
		  elsif cmd==2
	 $Trainer.playerphysical+=4 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=2 #Intelligence
		  elsif cmd==3
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=5 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
		  elsif cmd==4
	 $Trainer.playerphysical+=3 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=1 #Intelligence
	     end
      pbDisplay(_INTL("Very good, now I've got a few statements, I want you to admit if they are something you would say."))
      cmd = pbMessage(_INTL("I charge in to deal with my problems head on."),[
                            _INTL("Strongly Agree"), #Guardian,Warrior
                            _INTL("Agree"),  #Alchemist,Mechanist
                            _INTL("No Opinion"), #Runner,Monk
                            _INTL("Disagree"), #Catcher,Healer,Breeder
                            _INTL("Strongly Disagree")]) #Hunter,Assassin
		  if cmd==0
	 $Trainer.playerphysical+=4 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence-=1 #Intelligence
		  elsif cmd==1
	 $Trainer.playerphysical+=2 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=1 #Intelligence
		  elsif cmd==2
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
		  elsif cmd==3
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=2 #Emotional
	 $Trainer.playerintelligence+=2 #Intelligence
		  elsif cmd==4
	 $Trainer.playerphysical-=2 #Physical
	 $Trainer.playeremotional+=2 #Emotional
	 $Trainer.playerintelligence+=4 #Intelligence
	     end
      cmd = pbMessage(_INTL("I don't tend to rely on others for support."),[
                            _INTL("Strongly Agree"), #Guardian,Warrior
                            _INTL("Agree"),  #Alchemist,Mechanist
                            _INTL("No Opinion"), #Runner,Monk
                            _INTL("Disagree"), #Catcher,Healer,Breeder
                            _INTL("Strongly Disagree")]) #Hunter,Assassin
		  if cmd==0
	 $Trainer.playerphysical+=4 #Physical
	 $Trainer.playeremotional-=4 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
		  elsif cmd==1
	 $Trainer.playerphysical+=2 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
		  elsif cmd==2
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
		  elsif cmd==3
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=2 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
		  elsif cmd==4
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=5 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Conflict isn't in my nature."),[
                            _INTL("Strongly Agree"), #Guardian,Warrior
                            _INTL("Agree"),  #Alchemist,Mechanist
                            _INTL("No Opinion"), #Runner,Monk
                            _INTL("Disagree"), #Catcher,Healer,Breeder
                            _INTL("Strongly Disagree")]) #Hunter,Assassin
		  if cmd==0
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=4 #Emotional
	 $Trainer.playerintelligence+=2 #Intelligence
		  elsif cmd==1
	 $Trainer.playerphysical+=1 #Physical
	 $Trainer.playeremotional+=2 #Emotional
	 $Trainer.playerintelligence+=1 #Intelligence
		  elsif cmd==2
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
		  elsif cmd==3
	 $Trainer.playerphysical+=3 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
		  elsif cmd==4
	 $Trainer.playerphysical+=5 #Physical
	 $Trainer.playeremotional-=2 #Emotional
	 $Trainer.playerintelligence+=1 #Intelligence
	     end
      cmd = pbMessage(_INTL("I am slow to adapt."),[
                            _INTL("Strongly Agree"), #Guardian,Warrior
                            _INTL("Agree"),  #Alchemist,Mechanist
                            _INTL("No Opinion"), #Runner,Monk
                            _INTL("Disagree"), #Catcher,Healer,Breeder
                            _INTL("Strongly Disagree")]) #Hunter,Assassin
		  if cmd==0
	 $Trainer.playerphysical+=2 #Physical
	 $Trainer.playeremotional+=2 #Emotional
	 $Trainer.playerintelligence-=2 #Intelligence
		  elsif cmd==1
	 $Trainer.playerphysical+=1 #Physical
	 $Trainer.playeremotional+=1 #Emotional
	 $Trainer.playerintelligence-=1 #Intelligence
		  elsif cmd==2
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
		  elsif cmd==3
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=2 #Intelligence
		  elsif cmd==4
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=5 #Intelligence
	     end
      pbDisplay(_INTL("Alright, this'll be the last set, all 2 Answer."))
      cmd = pbMessage(_INTL("Do you think it's important to always aim to be the best?"),[
                            _INTL("Yes"), #Guardian,Warrior
                            _INTL("No")]) #Hunter,Assassin
		  if cmd==0
	 $Trainer.playerphysical+=2 #Physical
	 $Trainer.playeremotional+=2 #Emotional
	 $Trainer.playerintelligence+=2 #Intelligence
		  elsif cmd==1
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Good news and bad news... Which one do you want to hear first?"),[
                            _INTL("Good"), #Guardian,Warrior
                            _INTL("Bad")]) #Hunter,Assassin
		  if cmd==0
	 $Trainer.playerphysical+=2 #Physical
	 $Trainer.playeremotional+=3 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
		  elsif cmd==1
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=3 #Emotional
	 $Trainer.playerintelligence+=2 #Intelligence
	     end
      cmd = pbMessage(_INTL("Once you've decided something, do you see it through to the end?"),[
                            _INTL("Yes"), #Guardian,Warrior
                            _INTL("No")]) #Hunter,Assassin
		  if cmd==0
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=3 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
		  elsif cmd==1
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=2 #Intelligence
	     end
      cmd = pbMessage(_INTL("Have you had any hobbies for a long time?"),[
                            _INTL("Yes"), #Guardian,Warrior
                            _INTL("No")]) #Hunter,Assassin
		  if cmd==0
	 $Trainer.playerphysical+=4 #Physical
	 $Trainer.playeremotional+=3 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
		  elsif cmd==1
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("Can you strike up conversations with new people easily?"),[
                            _INTL("Yes"), #Guardian,Warrior
                            _INTL("No")]) #Hunter,Assassin
		  if cmd==0
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=4 #Emotional
	 $Trainer.playerintelligence+=2 #Intelligence
		  elsif cmd==1
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=0 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
	     end
      cmd = pbMessage(_INTL("When walking in a group, do you tend to be the one at the front?"),[
                            _INTL("Yes"), #Guardian,Warrior
                            _INTL("No")]) #Hunter,Assassin
		  if cmd==0
	 $Trainer.playerphysical+=3 #Physical
	 $Trainer.playeremotional+=4 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
		  elsif cmd==1
	 $Trainer.playerphysical+=0 #Physical
	 $Trainer.playeremotional+=6 #Emotional
	 $Trainer.playerintelligence+=0 #Intelligence
	     end
      pbDisplay(_INTL("Well, that's all."))
	  if $Trainer.playerphysical > (($Trainer.playeremotional || $Trainer.playerintelligence) +20)  #Warrior
	     $game_variables[50]=2
	  elsif $Trainer.playerphysical > $Trainer.playerintelligence && $Trainer.playeremotional < 10  #Assassin
	     $game_variables[50]=3
	  elsif $Trainer.playerphysical <= $Trainer.playerintelligence && $Trainer.playeremotional < 10 #Monk
	     $game_variables[50]=4
	  elsif $Trainer.playerintelligence > $Trainer.playeremotional &&  $Trainer.playerphysical < 10#Alchemist
	     $game_variables[50]=5
	  elsif $Trainer.playerintelligence && $Trainer.playeremotional &&  $Trainer.playerphysical > 10 && $Trainer.playerintelligence && $Trainer.playeremotional &&  $Trainer.playerphysical < 20 #Guardian
	     $game_variables[50]=6
	  elsif $Trainer.playerintelligence > 15 &&  $Trainer.playerphysical > 5#Hunter
	     $game_variables[50]=7
	  elsif $Trainer.playerintelligence > 15 &&  $Trainer.playerphysical < 10#Mechanist
	     $game_variables[50]=8
	  elsif $Trainer.playerintelligence > 5 &&  $Trainer.playerphysical < 5 && $Trainer.playeremotional > 10#Healer 
	     $game_variables[50]=9
	  elsif $Trainer.playerintelligence > 5 &&  $Trainer.playerphysical < 10 && $Trainer.playeremotional > 10#Breeder
	     $game_variables[50]=10
	  elsif $Trainer.playerintelligence > 15 &&  $Trainer.playerphysical > 10 && $Trainer.playeremotional > 5#Catcher 
	     $game_variables[50]=12
	  elsif $Trainer.playerphysical > $Trainer.playerintelligence > $Trainer.playeremotional
	     $game_variables[50]=2
	  elsif $Trainer.playerphysical < $Trainer.playerintelligence > $Trainer.playeremotional
	     $game_variables[50]=5
	  elsif $Trainer.playerphysical < $Trainer.playerintelligence < $Trainer.playeremotional
	     $game_variables[50]=10
	  else 
	     $game_variables[50]= rand(10)+1
		 if $game_variables[50]==11
	     $game_variables[50]= 12
		 end
     end
	 if $game_variables[50]==1
      pbDisplay(_INTL("You tend to be quick on the feet."))
      pbDisplay(_INTL("You get less overworld encounters, that's just how you are."))
	 elsif $game_variables[50]==2
      pbDisplay(_INTL("You are a fighter."))
      pbDisplay(_INTL("Your POKeMON will occasional not use PP."))
	 elsif $game_variables[50]==3
      pbDisplay(_INTL("You are a stealthy person."))
      pbDisplay(_INTL("All your POKeMON have increased evasion."))
	 elsif $game_variables[50]==4
      pbDisplay(_INTL("You are a stealthy person."))
      pbDisplay(_INTL("All your POKeMON have increased Loyalty."))
	 elsif $game_variables[50]==5
      pbDisplay(_INTL("You are a stealthy person."))
      pbDisplay(_INTL("Your moves that inflict status ailments will inflict them."))
	 elsif $game_variables[50]==6
      pbDisplay(_INTL("You are a protector."))
      pbDisplay(_INTL("All your POKeMONs multistrike moves hit the max amount."))
	 elsif $game_variables[50]==7
      pbDisplay(_INTL("You are a hunter."))
      pbDisplay(_INTL("All your POKeMON have increased chance of critical hits."))
	 elsif $game_variables[50]==8
      pbDisplay(_INTL("You are a whiz with machines."))
      pbDisplay(_INTL("You can craft machines without Machine Boxs, and can craft PCs."))
	 elsif $game_variables[50]==9
      pbDisplay(_INTL("You are a healer."))
      pbDisplay(_INTL("Health-recovering moves recover additional health."))
	 elsif $game_variables[50]==10
      pbDisplay(_INTL("You are a breeder."))
      pbDisplay(_INTL("You have a higher chance to have eggs spawn."))
	 elsif $game_variables[50]==12
      pbDisplay(_INTL("You are a catcher."))
      pbDisplay(_INTL("You have a chance to recover failed POKeBALL throws."))
	 end
end
