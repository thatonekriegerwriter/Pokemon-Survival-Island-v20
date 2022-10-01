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
                    _INTL("Exit")],2)
    case command
    when 0   # Use Statue
	  if $bag.quantity(:WOODENPLANKS)>=200 && $bag.remove(:WOODENPLANKS,200) || $DEBUG && Input.press?(Input::CTRL)
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   $game_switches[496]=true
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	  break
	  else
	   amount = 200 - $bag.quantity(:WOODENPLANKS)
	   pbMessage(_INTL("You need {1} more Wooden Planks to build this.",amount))
	  break
	  end
    when 1   # Use Statue
	  if $bag.quantity(:WOODENPLANKS)>=500 && $bag.remove(:WOODENPLANKS,500)  || $DEBUG && Input.press?(Input::CTRL)
      if $bag.quantity(:STONE)>=50 && $bag.remove(:STONE,50) || $DEBUG && Input.press?(Input::CTRL)
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
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
	  if $bag.quantity(:PICKAXE)>=5 && $bag.remove(:PICKAXE,5)  || $DEBUG && Input.press?(Input::CTRL)
      if $bag.quantity(:WOODENPLANKS)>=50 && $bag.remove(:WOODENPLANKS,50) || $DEBUG && Input.press?(Input::CTRL)
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   $game_switches[498]=true
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	  break
	  else 
	   amount = 50 - $bag.quantity(:WOODENPLANKS)
	   pbMessage(_INTL("You need {1} more Wooden Planks to build this.",amount))
	  break
	  end
	   else
	   amount = 500 - $bag.quantity(:PICKAXE)
	   pbMessage(_INTL("You need {1} more Pickaxe to build this.",amount))
	  break
	  end
    when 3   # Use Statue
	  if $bag.quantity(:STONE)>=50 && $bag.remove(:STONE,50) || $DEBUG && Input.press?(Input::CTRL)
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   $game_switches[494]=true
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	  break
	  else
	   amount = 200 - $bag.quantity(:WOODENPLANKS)
	   pbMessage(_INTL("You need {1} more Wooden Planks to build this.",amount))
	  break
	  end
    when 4   # Use Statue
	 if $bag.quantity(:HARDSTONE)>=50 && $bag.remove(:HARDSTONE,50)  || $DEBUG && Input.press?(Input::CTRL)
      if $bag.quantity(:MINDPLATE)>=5 && $bag.remove(:MINDPLATE,5) || $DEBUG && Input.press?(Input::CTRL)
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   $game_switches[479]=true
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	  break
	  else 
	   amount = 50 - $bag.quantity(:MINDPLATE)
	   pbMessage(_INTL("You need {1} more Mind Plate to build this.",amount))
	  break
	  end
	   else
	   amount = 500 - $bag.quantity(:HARDSTONE)
	   pbMessage(_INTL("You need {1} more Hard Plate to build this.",amount))
	  break
	  end
    when 5   # Use Statue
	  if $bag.quantity(:BONEDUST)>=50 && $bag.remove(:BONEDUST,50) || $DEBUG && Input.press?(Input::CTRL)
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   $game_switches[478]=true
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	  break
	  else
	   amount = 200 - $bag.quantity(:WOODENPLANKS)
	   pbMessage(_INTL("You need {1} more Wooden Planks to build this.",amount))
	  break
	  end
    else
	  break
	end
	end

end


def pbBuildingHouses
	  if $bag.quantity(:WOODENPLANKS)>=300 && $bag.remove(:WOODENPLANKS,300)  || $DEBUG && Input.press?(Input::CTRL)
      if $bag.quantity(:STONE)>=150 && $bag.remove(:STONE,150) || $DEBUG && Input.press?(Input::CTRL)
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   pbAchievementGet(4)
	   advanceQuestToStage(:PSIMQ1, 4)
	   $game_switches[132]=true
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	   return true
	  else 
	   amount = 50 - $bag.quantity(:STONE)
	   pbMessage(_INTL("You need {1} more stone to build this.",amount))
	   return false
	  end
	   else
	   amount = 500 - $bag.quantity(:WOODENPLANKS)
	   pbMessage(_INTL("You need {1} more stone to build this.",amount))
	   return false
	  end
end


def pbBuildingFarms
amount = 0
	  if $bag.quantity(:WOODENPLANKS)>=500 && $bag.remove(:WOODENPLANKS,500) || $DEBUG && Input.press?(Input::CTRL)
	   pbToneChangeAll(Tone.new(-255,-255,-255,0),20)
	   $game_switches[203]=true
	   pbToneChangeAll(Tone.new(0,0,0,0),20)
	   return true
	  else
	   amount = 500 - $bag.quantity(:WOODENPLANKS)
	   pbMessage(_INTL("You need {1} more Wooden Planks to build this.",amount))
	   return false
	  end
end