def pbHouseUpgrades
amount = 0
command = 0
  loop do
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("You've written down a few upgrades for the house you have thought of."))
    command = pbShowCommands(msgwindow,
                    [_INTL("Breeding Area"),
                    _INTL("Upstairs"),
                    _INTL("Cave"),
                    _INTL("Well"),
                    _INTL("Statue"),
                    _INTL("Yard Farm"),
                    _INTL("Exit")],-1)
        pbDisposeMessageWindow(msgwindow)
    case command
    when 0   # Use Statue
	  if $bag.quantity(:WOODENPLANKS)>=200
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   $game_switches[496]=true
	   $bag.remove(:WOODENPLANKS,200)
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	  break
	  else
	   amount = 200 - $bag.quantity(:WOODENPLANKS)
	   pbMessage(_INTL("You need {1} more Wooden Planks to build this.",amount))
	  break
	  end
    when 1   # Use Statue
	  if $bag.quantity(:WOODENPLANKS)>=500
      if $bag.quantity(:STONE)>=50
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   $bag.remove(:WOODENPLANKS,500)
	   $bag.remove(:STONE,50)
	   $game_switches[495]=true
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	  break
	  else 
	   amount = 50 - $bag.quantity(:STONE)
	   pbMessage(_INTL("You need {1} more stone to build this.",amount))
	  break
	  end
	   else
	   amount = 500 - $bag.quantity(:WOODENPLANKS)
	   pbMessage(_INTL("You need {1} more stone to build this.",amount))
	  break
	  end
    when 2   # Use Statue
	  if $bag.quantity(:IRONPICKAXE)>=5
      if $bag.quantity(:WOODENPLANKS)>=50
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   $game_switches[498]=true
	    $bag.remove(:PICKAXE,5)
		$bag.remove(:WOODENPLANKS,50)
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	  break
	  else 
	   amount = 50 - $bag.quantity(:WOODENPLANKS)
	   pbMessage(_INTL("You need {1} more Wooden Planks to build this.",amount))
	  break
	  end
	   else
	   amount = 5 - $bag.quantity(:IRONPICKAXE)
	   pbMessage(_INTL("You need {1} more Pickaxe to build this.",amount))
	  break
	  end
    when 3   # Use Statue
	  if $bag.quantity(:STONE)>=50
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   $game_switches[494]=true
	   $bag.remove(:STONE,50)
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	  break
	  else
	   amount = 50 - $bag.quantity(:STONE)
	   pbMessage(_INTL("You need {1} more Stone to build this.",amount))
	  break
	  end
    when 4   # Use Statue
	 if $bag.quantity(:HARDSTONE)>=50
      if $bag.quantity(:MINDPLATE)>=5
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   $game_switches[479]=true
	   $bag.remove(:HARDSTONE,50)
	   $bag.remove(:MINDPLATE,5)
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	  break
	  else 
	   amount = 5 - $bag.quantity(:MINDPLATE)
	   pbMessage(_INTL("You need {1} more Mind Plate to build this.",amount))
	  break
	  end
	   else
	   amount = 50 - $bag.quantity(:HARDSTONE)
	   pbMessage(_INTL("You need {1} more Hard Stone to build this.",amount))
	  break
	  end
    when 5   # Use Statue
	  if $bag.quantity(:BONEDUST)>=50
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   $game_switches[478]=true
	   $bag.remove(:BONEDUST,50)
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	  break
	  else
	   amount = 50 - $bag.quantity(:BONEDUST)
	   pbMessage(_INTL("You need {1} more Bone Dust to build this.",amount))
	  break
	  end
    else
	  pbDisposeMessageWindow(msgwindow)
	  break
	end
	end

end


def pbBuildingHouses
	  if $bag.quantity(:WOODENPLANKS)>=300
      if $bag.quantity(:STONE)>=150
	   $bag.remove(:WOODENPLANKS,300)
	   $bag.remove(:STONE,150)
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   pbCaveEntrance
	   pbAchievementGet(4)
	   advanceQuestToStage(:PSIMQ1, 4)
	   $game_switches[132]=true
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	   return true
	  else 
	   amount = 150 - $bag.quantity(:STONE)
	   pbMessage(_INTL("You need {1} more stone to build this. You have {2}.",amount,$bag.quantity(:STONE)))
	   return false
	  end
	   else
	   amount = 300 - $bag.quantity(:WOODENPLANKS)
	   pbMessage(_INTL("You need {1} more wood to build this. You have {2}.",amount,$bag.quantity(:WOODENPLANKS)))
	   return false
	  end
end


def pbBuildingFarms
amount = 0
	  if $bag.quantity(:WOODENPLANKS)>=500 && $bag.remove(:WOODENPLANKS,500)
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   pbCaveEntrance
	   $game_switches[203]=true
	   $game_variables[4992]+=1
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	   return true
	  else
	   return false
	  end
end

#1 155
#2 147
#3 148
#4 149
#5 150
#6 151
#7 152
#8 153
#9 154