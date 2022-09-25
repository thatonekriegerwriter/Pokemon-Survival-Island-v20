module FameChecker

  # please make sure that when you call this function, you use the name of the person you
    # previously used when first inputting the character.
  # famousPersonName = string, is used to look up a specific person, example "BROCK"
    # note that "BROCK" would be the original name given, "Brock", or "brock" wouldn't work
  # hasMet = boolean, not required, defaults to true, assuming you mainly want to set that the
    # player has encountered a specific person, is often times called when first meeting them in person
    # however isn't limited to those uses.
  # this function is usually to be called during a scripting event with that person, 
	# but isn't supposed to be displayed    FameChecker.hasEncountered(famousPersonName, hasMet = true)
  def self.hasEncountered(famousPersonName, hasMet = true)
    FameChecker.checkSetup
    FameChecker.runSetup

    if !$PokemonGlobal.FameTargets[famousPersonName]
      return
    end
    $PokemonGlobal.FameTargets[famousPersonName]["seen"] = hasMet
  end

  # please make sure that when you call this function, you use the name of the person you
    # previously used when first inputting the character.
  # famousPersonName = string, is used to look up a specific person, example "BROCK"
    # note that "BROCK" would be the original name given, "Brock", or "brock" wouldn't work
  # InfoNum = integer, can be any number, however doesn't do anything if it cannot find
    # the info target you want to set as found. 
    # note, the starting number is 0 not 1.
  # hasFound = boolean, not required, defaults to true, assuming you mainly want to set that the
    # player has encountered an NPC that has given them some info about the specific character.
  # this is usually called during the text boxes that relay that info, and is usually not to be displayed.
  def self.hasFoundInfo(famousPersonName, infoNum, hasFound = true)
    FameChecker.checkSetup
    FameChecker.runSetup

    if !$PokemonGlobal.FameTargets[famousPersonName]
      return
    end

    if !$PokemonGlobal.FameInfo[famousPersonName][infoNum]
      print("the number you input for the info of #{famousPersonName} doesn't exist.")
    end
    $PokemonGlobal.FameInfo[famousPersonName][infoNum]["seen"] = hasFound
  end

  # for debugging purposes, usually you want to call it, store the value in the npc script
    # and then print it within that script. You can probably use it for a fame checker NPC if you want one.
  def self.printFoundStatus(famousPersonName)
    FameChecker.checkSetup
    FameChecker.runSetup

    if !$PokemonGlobal.FameTargets[famousPersonName]
      return
    end
    return $PokemonGlobal.FameTargets[famousPersonName]["seen"]
  end

  # note, this is ONLY to be called upon the initialization of a new save file, or when you want to introduce
    # a new character that was not previously within the game, such as in the case of an update from a previous version
  # personName = string, represents the name of a specific person, all names must be different, example "BROCK"
  # fileName = string, represents the image that will be displayed on screen for a specific person,
    # example "BROCK.png", note that you should have the file within the big_sprites folder
  # hasMet = boolean, not required, can be true or false, defaults to false when not given
    # decides if the player has met the person in question, normally the player wouldn't have at the beginning
    # of the game, so false is the default statement.
  # If you want to use this function within the game's interface, it must be called using FameChecker.createFamousPerson
  def self.createFamousPerson(personName, fileName, hasMet = false)
    FameChecker.checkSetup
    newHash = {}
    newHash["fileName"] = fileName.upcase
    newHash["seen"] = hasMet
    $PokemonGlobal.FameTargets[personName] = newHash
  end

  # personName = string, represents the name of a specific person, all names must be different, example "BROCK"
  # fileName = string, represents the image that will be displayed on screen for a specific person,
    # example "old_lady.png", note that you should have the file within the Small_sprites folder
  # textBoxText = array of strings, must be of size 2, represents the value that appears within the blue frame, example ["VERIDIAN CITY", "GYM SIGN"]
  # selectText = array of strings, represents the text that is displayed when you select that specific info person, 
    # example ["Oak is an interesting man, he apparently created MISSINGNO!","I get it, you're skeptical, but it's true, he really did!"]
    # note, this can be any size, just make sure to seperate sentances in this way.
  # hoverText = string, represents the text that is supposed to display when the player is hovering over that specific info person,
    # example, "Did you hear about his secret experiment..."
  # hasMet = boolean, not required, can be true or false, defaults to false when not given
    # decides if the player has seen the info in question, normally the player wouldn't have at the beginning
    # of the game, so false is the default statement.
  # If you want to use this function within the game's interface, it must be called using FameChecker.createFameInfo
  def self.createFameInfo(personName, fileName, textBoxText, selectText, hoverText, hasMet = false)
    FameChecker.checkSetup
    if !$PokemonGlobal.FameTargets[personName]
      return
    end
    if !$PokemonGlobal.FameInfo[personName]
      $PokemonGlobal.FameInfo[personName] = {}
    end
    temp = $PokemonGlobal.FameInfo[personName]
    newHash = {}
    newHash["fileName"] = fileName
    newHash["infoText"] = textBoxText
    newHash["selectText"] = selectText
    newHash["hoverText"] = hoverText
    newHash["seen"] = hasMet
    temp[temp.size] = newHash
  end

  # this function is where you place every call of createFamousPerson
  # within the function is a template for you to copy to your hearts content
  # please ensure that the files are within Graphics/Pictures/FameChecker/Big_Sprites else it will throw an error
  def self.setupFamousPeople()
    # template
    self.createFamousPerson("Brent", "BRENT.png", false)
    self.createFamousPerson("Donna", "DONNA.png", false)
    self.createFamousPerson("Alice", "ALICE.png", false)
    self.createFamousPerson("Jace", "JACE.png", false)
    self.createFamousPerson("David", "DAVID.png", false)
    self.createFamousPerson("John", "JOHN.png", false)
    self.createFamousPerson("Samantha", "SAMANTHA.png", false)
    self.createFamousPerson("Sevii", "SEVII.png", false)
    self.createFamousPerson("Blue", "BLUE.png", false)
    self.createFamousPerson("Red", "RED.png", false)
    self.createFamousPerson("Boss", "BOSS.png", true)
    self.createFamousPerson("???", "000.png", false)
  end

  # this function is where you place every call of createFameInfo
  # within the function is a template for you to copy to your hearts content
  # please ensure that the files are within Graphics/Pictures/FameChecker/small_sprites and that the name you use is correct for each
  def self.setupFameInfo()
    # template
	if $game_variables[4926]==1
       self.createFameInfo("Brent", "base.png", ["Affinity", " "], ["\\pa1"], "Check Affinity.",true)
	elsif $game_variables[4926]==2
       self.createFameInfo("Donna", "base.png", ["Affinity", " "], ["\\pa1"], "Check Affinity.",true)
	elsif $game_variables[4926]==3
       self.createFameInfo("Jace", "base.png", ["Affinity", " "], ["\\pa1"], "Check Affinity.",true)
	elsif $game_variables[4926]==4
       self.createFameInfo("Sevii", "base.png", ["Affinity", " "], ["\\pa1"], "Check Affinity.",true)
	elsif $game_variables[4926]==5
       self.createFameInfo("John", "base.png", ["Affinity", " "], ["\\pa1"], "Check Affinity.",true)
	elsif $game_variables[4926]==6
       self.createFameInfo("Samantha", "base.png", ["Affinity", " "], ["\\pa1"], "Check Affinity.",true)
	elsif $game_variables[4926]==7
       self.createFameInfo("David", "base.png", ["Affinity", " "], ["\\pa1"], "Check Affinity.",true)
	elsif $game_variables[4926]==8
       self.createFameInfo("Alice", "base.png", ["Affinity", " "], ["\\pa1"], "Check Affinity.",true)
	else 
       self.createFameInfo("???", "unknown.png", ["Affinity", " "], ["\\pa1"], "Check Affinity.",true)
    end
	if $game_variables[4927]==1
       self.createFameInfo("Brent", "base.png", ["Affinity", " "], ["\\pa2"], "Check Affinity.",true)
	elsif $game_variables[4927]==2
       self.createFameInfo("Donna", "base.png", ["Affinity", " "], ["\\pa2"], "Check Affinity.",true)
	elsif $game_variables[4927]==3
       self.createFameInfo("Jace", "base.png", ["Affinity", " "], ["\\pa2"], "Check Affinity.",true)
	elsif $game_variables[4927]==4
       self.createFameInfo("Sevii", "base.png", ["Affinity", " "], ["\\pa2"], "Check Affinity.",true)
	elsif $game_variables[4927]==5
       self.createFameInfo("John", "base.png", ["Affinity", " "], ["\\pa2"], "Check Affinity.",true)
	elsif $game_variables[4927]==6
       self.createFameInfo("Samantha", "base.png", ["Affinity", " "], ["\\pa2"], "Check Affinity.",true)
	elsif $game_variables[4927]==7
       self.createFameInfo("David", "base.png", ["Affinity", " "], ["\\pa2"], "Check Affinity.",true)
	elsif $game_variables[4927]==8
       self.createFameInfo("Alice", "base.png", ["Affinity", " "], ["\\pa2"], "Check Affinity.",true)
	else 
       self.createFameInfo("???", "unknown.png", ["Affinity", " "], ["\\pa2"], "Check Affinity.",true)
    end
	if $game_variables[4928]==1
       self.createFameInfo("Brent", "base.png", ["Affinity", " "], ["\\pa3"], "Check Affinity.",true)
	elsif $game_variables[4928]==2
       self.createFameInfo("Donna", "base.png", ["Affinity", " "], ["\\pa3"], "Check Affinity.",true)
	elsif $game_variables[4928]==3
       self.createFameInfo("Jace", "base.png", ["Affinity", " "], ["\\pa3"], "Check Affinity.",true)
	elsif $game_variables[4928]==4
       self.createFameInfo("Sevii", "base.png", ["Affinity", " "], ["\\pa3"], "Check Affinity.",true)
	elsif $game_variables[4928]==5
       self.createFameInfo("John", "base.png", ["Affinity", " "], ["\\pa3"], "Check Affinity.",true)
	elsif $game_variables[4928]==6
       self.createFameInfo("Samantha", "base.png", ["Affinity", " "], ["\\pa3"], "Check Affinity.",true)
	elsif $game_variables[4928]==7
       self.createFameInfo("David", "base.png", ["Affinity", " "], ["\\pa3"], "Check Affinity.",true)
	elsif $game_variables[4928]==8
       self.createFameInfo("Alice", "base.png", ["Affinity", " "], ["\\pa3"], "Check Affinity.",true)
	else 
       self.createFameInfo("???", "unknown.png", ["Affinity", " "], ["\\pa3"], "Check Affinity.",true)
    end
	if $game_variables[4929]==1
       self.createFameInfo("Brent", "base.png", ["Affinity", " "], ["\\pa4"], "Check Affinity.",true)
	elsif $game_variables[4929]==2
       self.createFameInfo("Donna", "base.png", ["Affinity", " "], ["\\pa4"], "Check Affinity.",true)
	elsif $game_variables[4929]==3
       self.createFameInfo("Jace", "base.png", ["Affinity", " "], ["\\pa4"], "Check Affinity.",true)
	elsif $game_variables[4929]==4
       self.createFameInfo("Sevii", "base.png", ["Affinity", " "], ["\\pa4"], "Check Affinity.",true)
	elsif $game_variables[4929]==5
       self.createFameInfo("John", "base.png", ["Affinity", " "], ["\\pa4"], "Check Affinity.",true)
	elsif $game_variables[4929]==6
       self.createFameInfo("Samantha", "base.png", ["Affinity", " "], ["\\pa4"], "Check Affinity.",true)
	elsif $game_variables[4929]==7
       self.createFameInfo("David", "base.png", ["Affinity", " "], ["\\pa4"], "Check Affinity.",true)
	elsif $game_variables[4929]==8
       self.createFameInfo("Alice", "base.png", ["Affinity", " "], ["\\pa4"], "Check Affinity.",true)
	else 
       self.createFameInfo("???", "unknown.png", ["Affinity", " "], ["\\pa4"], "Check Affinity.",true)
    end
	if $game_variables[4930]==1
       self.createFameInfo("Brent", "base.png", ["Affinity", " "], ["\\pa5"], "Check Affinity.",true)
	elsif $game_variables[4930]==2
       self.createFameInfo("Donna", "base.png", ["Affinity", " "], ["\\pa5"], "Check Affinity.",true)
	elsif $game_variables[4930]==3
       self.createFameInfo("Jace", "base.png", ["Affinity", " "], ["\\pa5"], "Check Affinity.",true)
	elsif $game_variables[4930]==4
       self.createFameInfo("Sevii", "base.png", ["Affinity", " "], ["\\pa5"], "Check Affinity.",true)
	elsif $game_variables[4930]==5
       self.createFameInfo("John", "base.png", ["Affinity", " "], ["\\pa5"], "Check Affinity.",true)
	elsif $game_variables[4930]==6
       self.createFameInfo("Samantha", "base.png", ["Affinity", " "], ["\\pa5"], "Check Affinity.",true)
	elsif $game_variables[4930]==7
       self.createFameInfo("David", "base.png", ["Affinity", " "], ["\\pa5"], "Check Affinity.",true)
	elsif $game_variables[4930]==8
       self.createFameInfo("Alice", "base.png", ["Affinity", " "], ["\\pa5"], "Check Affinity.",true)
	else 
       self.createFameInfo("???", "unknown.png", ["Affinity", " "], ["\\pa5"], "Check Affinity.",true)
    end
	if $game_variables[4931]==1
       self.createFameInfo("Brent", "base.png", ["Affinity", " "], ["\\pa6"], "Check Affinity.",true)
	elsif $game_variables[4931]==2
       self.createFameInfo("Donna", "base.png", ["Affinity", " "], ["\\pa6"], "Check Affinity.",true)
	elsif $game_variables[4931]==3
       self.createFameInfo("Jace", "base.png", ["Affinity", " "], ["\\pa6"], "Check Affinity.",true)
	elsif $game_variables[4931]==4
       self.createFameInfo("Sevii", "base.png", ["Affinity", " "], ["\\pa6"], "Check Affinity.",true)
	elsif $game_variables[4931]==5
       self.createFameInfo("John", "base.png", ["Affinity", " "], ["\\pa6"], "Check Affinity.",true)
	elsif $game_variables[4931]==6
       self.createFameInfo("Samantha", "base.png", ["Affinity", " "], ["\\pa6"], "Check Affinity.",true)
	elsif $game_variables[4931]==7
       self.createFameInfo("David", "base.png", ["Affinity", " "], ["\\pa6"], "Check Affinity.",true)
	elsif $game_variables[4931]==8
       self.createFameInfo("Alice", "base.png", ["Affinity", " "], ["\\pa6"], "Check Affinity.",true)
	else 
       self.createFameInfo("???", "unknown.png", ["Affinity", " "], ["\\pa6"], "Check Affinity.",true)
    end
	if $game_variables[4932]==1
       self.createFameInfo("Brent", "base.png", ["Affinity", " "], ["\\pa7"], "Check Affinity.",true)
	elsif $game_variables[4932]==2
       self.createFameInfo("Donna", "base.png", ["Affinity", " "], ["\\pa7"], "Check Affinity.",true)
	elsif $game_variables[4932]==3
       self.createFameInfo("Jace", "base.png", ["Affinity", " "], ["\\pa7"], "Check Affinity.",true)
	elsif $game_variables[4932]==4
       self.createFameInfo("Sevii", "base.png", ["Affinity", " "], ["\\pa7"], "Check Affinity.",true)
	elsif $game_variables[4932]==5
       self.createFameInfo("John", "base.png", ["Affinity", " "], ["\\pa7"], "Check Affinity.",true)
	elsif $game_variables[4932]==6
       self.createFameInfo("Samantha", "base.png", ["Affinity", " "], ["\\pa7"], "Check Affinity.",true)
	elsif $game_variables[4932]==7
       self.createFameInfo("David", "base.png", ["Affinity", " "], ["\\pa7"], "Check Affinity.",true)
	elsif $game_variables[4932]==8
       self.createFameInfo("Alice", "base.png", ["Affinity", " "], ["\\pa7"], "Check Affinity.",true)
	else 
       self.createFameInfo("???", "unknown.png", ["Affinity", " "], ["\\pa7"], "Check Affinity.",true)
    end
    self.createFameInfo("Blue", "base.png", ["Affinity", " "], ["\\pab"], "Check Affinity.",true)
    self.createFameInfo("Red", "base.png", ["Affinity", " "], ["\\par"], "Check Affinity.",true)
    self.createFameInfo("Boss", "pkb.png", ["Boss", "  "], ["Your boss was nice enough to take you on a trip!","The Plan was to start a POKeMON journey, but it didn't go to plan."], "The Pokemon World.",true)
end
end