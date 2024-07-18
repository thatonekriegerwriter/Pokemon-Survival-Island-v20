    # Changing
class Pokemon

  def changeHappiness(method,wari=self)
    pkmn = wari
	if pkmn.starter.nil?
	 pkmn.starter = false
	end
    return if pkmn.starter == true
    gain = 0
	 base = 0
     base = 100 if pkmn.nature ==   :LOVING
     base = -100 if pkmn.nature ==   :HATEFUL
     base = -2 if pkmn.nature ==   :QUIRKY
     base = 0 if pkmn.nature ==   :CAREFUL
     base = 5 if pkmn.nature ==   :SASSY
     base = 15 if pkmn.nature ==   :GENTLE
     base = 10 if pkmn.nature ==   :CALM
     base = 5 if pkmn.nature ==   :RASH
     base = 5 if pkmn.nature ==   :BASHFUL
     base = 5 if pkmn.nature ==   :QUIET
     base = 10 if pkmn.nature ==   :MILD
     base = 10 if pkmn.nature ==   :MODEST
     base = 10 if pkmn.nature ==   :NAIVE
     base = 15 if pkmn.nature ==   :JOLLY
     base = -2 if pkmn.nature ==   :SERIOUS
     base = 15 if pkmn.nature ==   :HASTY
     base = -1 if pkmn.nature ==   :TIMID
     base = 25 if pkmn.nature ==   :LAX
     base = 9 if pkmn.nature ==   :IMPISH
     base = 30 if pkmn.nature ==   :RELAXED
     base = 20 if pkmn.nature ==   :DOCILE
     base = 5 if pkmn.nature ==   :BOLD
     base = -1 if pkmn.nature ==   :NAUGHTY
     base = -2 if pkmn.nature ==   :ADAMANT
     base = 5 if pkmn.nature ==   :BRAVE
     base = 5 if pkmn.nature ==   :LONELY
     base = 6 if pkmn.nature ==   :HARDY
    happiness_range = @happiness / 100
if pkmn.nature ==   :HARDY
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [10, 10, 5][happiness_range]
      when "groom"
        gain = [3, 3, 4][happiness_range]
      when "evberry"
        gain = [10, 15, 15][happiness_range]
      when "vitamin"
        gain = [6, 6, 7][happiness_range]
      when "wing"
        gain = [9, 9, 7][happiness_range]
      when "machine", "battleitem"
        gain = [3, 1, 3][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-5, -10, -7][happiness_range]
      when "energyroot"
        gain = [-2, -6, -8][happiness_range]
      when "revivalherb"
        gain = [-5, -5, -7][happiness_range]
      when "damaged"
        gain = [-2, -3, -2][happiness_range]
      when "neglected"
        gain = [-1, -1, -1][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [15, 25, 25][happiness_range]
      when "TrainerPassedOut"
        gain = [15, 25, 25][happiness_range]
      when "FollowerPkmn"
        gain = [2, 1, 2][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :LONELY
      case method
      when "walking"
        gain = [2, 2, 2][happiness_range]
      when "levelup"
        gain = [2, 2, 3][happiness_range]
      when "groom"
        gain = [20, 20, 4][happiness_range]
      when "evberry"
        gain = [7, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [1, 1, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-10, -5, -10][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-10, -10, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-10, -10, -15][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-50, -50, -50][happiness_range]
      when "hungry"
        gain = [-20, -20, -25][happiness_range]
      when "thirsty"
        gain = [-20, -20, -25][happiness_range]
      when "tired"
        gain = [-1, -1, -5][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [1, 1, 5][happiness_range]
      when "TrainerPassedOut"
        gain = [-1, 1, 0][happiness_range]
      when "FollowerPkmn"
        gain = [20, 15, 5][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :BRAVE
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 5][happiness_range]
      when "vitamin"
        gain = [5, 3, 5][happiness_range]
      when "wing"
        gain = [3, 2, 3][happiness_range]
      when "machine", "battleitem"
        gain = [7, 5, 5][happiness_range]
      when "faint"
        gain = [0, 1, -5][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-20, -40, -60][happiness_range]
      when "powder"
        gain = [-10, -10, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -10][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -10][happiness_range]
      when "damaged"
        gain = [-1, -1, -2][happiness_range]
      when "neglected"
        gain = [-20, -20, -25][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [25, 25, 30][happiness_range]
      when "TrainerPassedOut"
        gain = [10, 10, 20][happiness_range]
      when "FollowerPkmn"
        gain = [20, 10, 20][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :ADAMANT
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :NAUGHTY
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :BOLD
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :DOCILE
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :RELAXED
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :IMPISH
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :LAX
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :TIMID
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :HASTY
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :SERIOUS
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :JOLLY
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :NAIVE
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :MODEST
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :MILD
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :QUIET
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :BASHFUL
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :RASH
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :CALM
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :GENTLE
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :SASSY
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :CAREFUL
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :QUIRKY
      case method
      when "walking"
        gain = [1, 1, 1][happiness_range]
      when "levelup"
        gain = [5, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-20, -20, -30][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [1, 3, 3][happiness_range]
      when "FollowerPkmn"
        gain = [1, 4, 3][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :HATEFUL
      case method
      when "walking"
        gain = [0, 0, 0][happiness_range]
      when "levelup"
        gain = [0, 0, 0][happiness_range]
      when "groom"
        gain = [1, 1, 0][happiness_range]
      when "evberry"
        gain = [0, 0, 0][happiness_range]
      when "vitamin"
        gain = [0, 0, 0][happiness_range]
      when "wing"
        gain = [0, 0, 0][happiness_range]
      when "machine", "battleitem"
        gain = [0, 0, 0][happiness_range]
      when "faint"
        gain = [-50, -50, -50][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][happiness_range]
      when "powder"
        gain = [-15, -15, -10][happiness_range]
      when "energyroot"
        gain = [-10, -10, -15][happiness_range]
      when "revivalherb"
        gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-5, -3, -2][happiness_range]
      when "neglected"
        gain = [-10, -10, -15][happiness_range]
      when "hungry"
        gain = [-10, -10, -15][happiness_range]
      when "thirsty"
        gain = [-10, -10, -15][happiness_range]
      when "tired"
        gain = [-10, -10, -15][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [0, 0, 0][happiness_range]
      when "TrainerPassedOut"
        gain = [-10, -10, -15][happiness_range]
      when "FollowerPkmn"
        gain = [-10, -10, -15][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :LOVING
      case method
      when "walking"
        gain = [3, 3, 3][happiness_range]
      when "levelup"
        gain = [7, 4, 3][happiness_range]
      when "groom"
        gain = [10, 10, 4][happiness_range]
      when "evberry"
        gain = [10, 5, 2][happiness_range]
      when "vitamin"
        gain = [5, 3, 2][happiness_range]
      when "wing"
        gain = [3, 2, 1][happiness_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][happiness_range]
      when "faint"
        gain = [-5, -5, -7][happiness_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-5, -10, -20][happiness_range]
      when "powder"
        gain = [-5, -5, -1][happiness_range]
      when "energyroot"
        gain = [-1, -1, -5][happiness_range]
      when "revivalherb"
        gain = [-5, -5, -2][happiness_range]
      when "damaged"
        gain = [-1, -3, -2][happiness_range]
      when "neglected"
        gain = [-1, -1, -5][happiness_range]
      when "hungry"
        gain = [-1, -1, -5][happiness_range]
      when "thirsty"
        gain = [-1, -1, -1][happiness_range]
      when "tired"
        gain = [-1, -1, -5][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [5, 3, 2][happiness_range]
      when "FollowerPkmn"
        gain = [5, 3, 2][happiness_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
else
    case method
    when "walking"
      gain = [2, 2, 1][happiness_range]
    when "levelup"
      gain = [5, 4, 3][happiness_range]
    when "groom"
      gain = [10, 10, 4][happiness_range]
    when "evberry"
      gain = [10, 5, 2][happiness_range]
    when "vitamin"
      gain = [5, 3, 2][happiness_range]
    when "wing"
      gain = [3, 2, 1][happiness_range]
    when "machine", "battleitem"
      gain = [1, 1, 0][happiness_range]
    when "faint"
      gain = -1
    when "faintbad"   # Fainted against an opponent that is 30+ levels higher
      gain = [-5, -5, -10][happiness_range]
    when "powder"
      gain = [-5, -5, -10][happiness_range]
    when "energyroot"
      gain = [-10, -10, -15][happiness_range]
    when "revivalherb"
      gain = [-15, -15, -20][happiness_range]
      when "damaged"
        gain = [-1, -3, -2][happiness_range]
      when "neglected"
        gain = [-1, -1, -5][happiness_range]
      when "hungry"
        gain = [-1, -1, -5][happiness_range]
      when "thirsty"
        gain = [-1, -1, -1][happiness_range]
      when "tired"
        gain = [-1, -1, -5][happiness_range]
      when "youareeatingme"
        gain = [-255, -255, -255][happiness_range]
      when "didDamage"
        gain = [5, 3, 2][happiness_range]
      when "TrainerPassedOut"
        gain = [5, 3, 2][happiness_range]
      when "FollowerPkmn"
        gain = [5, 3, 2][happiness_range]
    else
      raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
	end
	if gain.nil?
    gain=0
	end
    if gain > 0
      gain += 1 if @obtain_map == $game_map.map_id
      gain += 1 if @poke_ball == :LUXURYBALL
      gain = (gain * 1.5).floor if hasItem?(:SOOTHEBELL)
    end
	if @happiness.nil?
	pkmn.happiness = 70
	end
    @happiness = (@happiness + gain + base).clamp(0, 255)
  end

  
  # Changes the happiness of this Pokémon depending on what happened to change it.
  # @param method [String] the happiness changing method (e.g. 'walking')
  def changeLoyalty(method,wari=self)
    gain = 0
    bonus = 0
    pkmn = wari
	if pkmn.starter.nil?
	 pkmn.starter = false
	end
    return if pkmn.starter == true
	if @loyalty.nil?
	@loyalty = 0
	end
	base = 0
     base = 0 if pkmn.nature ==   :LOVING
     base = 0 if pkmn.nature ==   :HATEFUL
     base = 30 if pkmn.nature ==   :QUIRKY
     base = 0 if pkmn.nature ==   :CAREFUL
     base = -5 if pkmn.nature ==   :SASSY
     base = 0 if pkmn.nature ==   :GENTLE
     base = 0 if pkmn.nature ==   :CALM
     base = 50 if pkmn.nature ==   :RASH
     base = 0 if pkmn.nature ==   :BASHFUL
     base = 0 if pkmn.nature ==   :QUIET
     base = 0 if pkmn.nature ==   :MILD
     base = 0 if pkmn.nature ==   :MODEST
     base = 0 if pkmn.nature ==   :NAIVE
     base = 0 if pkmn.nature ==   :JOLLY
     base = -10 if pkmn.nature ==   :SERIOUS
     base = 75 if pkmn.nature ==   :HASTY
     base = 0 if pkmn.nature ==   :TIMID
     base = 0 if pkmn.nature ==   :LAX
     base = 0 if pkmn.nature ==   :IMPISH
     base = 0 if pkmn.nature ==   :RELAXED
     base = 0 if pkmn.nature ==   :DOCILE
     base = 75 if pkmn.nature ==   :BOLD
     base = 5 if pkmn.nature ==   :NAUGHTY
     base = 10 if pkmn.nature ==   :ADAMANT
     base = 100 if pkmn.nature ==   :BRAVE
     base = 0 if pkmn.nature ==   :LONELY
     base = 70 if pkmn.nature ==   :HARDY
    loyalty_range = @loyalty / 100
if pkmn.nature ==   :HARDY
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :LONELY
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :BRAVE
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :ADAMANT
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :NAUGHTY
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :BOLD
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :DOCILE
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :RELAXED
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :IMPISH
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :LAX
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :TIMID
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :HASTY
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :SERIOUS
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :JOLLY
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :NAIVE
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :MODEST
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :MILD
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :QUIET
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :BASHFUL
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :RASH
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :CALM
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :GENTLE
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :SASSY
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :CAREFUL
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :QUIRKY
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [5, 3, 2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :HATEFUL
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
elsif pkmn.nature ==   :LOVING
      case method
      when "walking"
        gain = [1, 1, 1][loyalty_range]
      when "levelup"
        gain = [5, 4, 3][loyalty_range]
      when "groom"
        gain = [10, 10, 4][loyalty_range]
      when "evberry"
        gain = [10, 5, 2][loyalty_range]
      when "vitamin"
        gain = [5, 3, 2][loyalty_range]
      when "wing"
        gain = [3, 2, 1][loyalty_range]
      when "machine", "battleitem"
        gain = [1, 1, 0][loyalty_range]
      when "faint"
        gain = [-20, -20, -30][loyalty_range]
      when "faintbad"   # Fainted against an opponent that is 30+ levels higher
        gain = [-30, -40, -60][loyalty_range]
      when "powder"
        gain = [-15, -15, -10][loyalty_range]
      when "energyroot"
        gain = [-1, -1, -1][loyalty_range]
      when "revivalherb"
        gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
else
        raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
else
    case method
    when "walking"
      gain = [2, 2, 1][loyalty_range]
    when "levelup"
      gain = [5, 4, 3][loyalty_range]
    when "groom"
      gain = [10, 10, 4][loyalty_range]
    when "evberry"
      gain = [10, 5, 2][loyalty_range]
    when "vitamin"
      gain = [5, 3, 2][loyalty_range]
    when "wing"
      gain = [3, 2, 1][loyalty_range]
    when "machine", "battleitem"
      gain = [1, 1, 0][loyalty_range]
    when "faint"
      gain = -1
    when "faintbad"   # Fainted against an opponent that is 30+ levels higher
      gain = [-5, -5, -10][loyalty_range]
    when "powder"
      gain = [-5, -5, -10][loyalty_range]
    when "energyroot"
      gain = [-10, -10, -15][loyalty_range]
    when "revivalherb"
      gain = [-15, -15, -20][loyalty_range]
      when "damaged"
        gain = [-5, -3, -2][loyalty_range]
      when "neglected"
        gain = [-1, -1, -1][loyalty_range]
      when "hungry"
        gain = [-1, -1, -1][loyalty_range]
      when "thirsty"
        gain = [-1, -1, -1][loyalty_range]
      when "tired"
        gain = [-1, -1, -1][loyalty_range]
      when "youareeatingme"
        gain = [-255, -255, -255][loyalty_range]
      when "didDamage"
        gain = [10, 10, 10][loyalty_range]
      when "TrainerPassedOut"
        gain = [10, 10, 10][loyalty_range]
      when "FollowerPkmn"
        gain = [10, 10, 10][loyalty_range]
    else
      raise _INTL("Unknown happiness-changing method: {1}", method.to_s)
    end
end
	
    gain=0 if gain.nil?
	pkmn.loyalty = 100 if @loyalty.nil?
    bonus=0 if bonus.nil?
	bonus=10 if pkmn.nature == :LOVING
	bonus = bonus+rand(5)+5 if $player.playerclass == "Monk"
    @loyalty = (@loyalty + gain + base + bonus).clamp(0, 255)
  end
  

  def adjustHeart(value)
    return if !shadowPokemon?
    @heart_gauge = (self.heart_gauge + value).clamp(0, max_gauge_size)
  end

  def change_heart_gauge(method, multiplier = 1)
    return if !shadowPokemon?
    heart_amounts = {
      # [sending into battle, call to, walking 256 steps, using scent]
      :HARDY   => [0, 300, 0,  90],
      :LONELY  => [ 0, 330, 0, 130],
      :BRAVE   => [0, 270,  0,  80],
      :ADAMANT => [0, 270, 0,  80],
      :NAUGHTY => [0, 270, 0,  70],
      :BOLD    => [0, 270,  0, 100],
      :DOCILE  => [0, 360, 0, 120],
      :RELAXED => [0, 270, 0, 100],
      :IMPISH  => [0, 300, 0,  80],
      :LAX     => [0, 270,  0, 110],
      :TIMID   => [0, 330, 0, 120],
      :HASTY   => [0, 300,  0, 100],
      :SERIOUS => [0, 330, 0,  90],
      :JOLLY   => [0, 300,  0,  90],
      :NAIVE   => [0, 300, 0,  80],
      :MODEST  => [0, 300, 0, 110],
      :MILD    => [0, 270, 0, 120],
      :QUIET   => [0, 300, 0, 100],
      :BASHFUL => [0, 300,  0, 130],
      :RASH    => [0, 300,  0, 120],
      :CALM    => [0, 300, 0, 110],
      :GENTLE  => [0, 300, 0, 100],
      :SASSY   => [0, 240, 0,  70],
      :CAREFUL => [0, 300, 0, 110],
      :QUIRKY  => [0, 270, 0,  90]
    }
    amt = 100
    case method
    when "battle"
      amt = (heart_amounts[@nature]) ? heart_amounts[@nature][0] : 0
    when "call"
      amt = (heart_amounts[@nature]) ? heart_amounts[@nature][1] : 300
    when "walking"
      amt = (heart_amounts[@nature]) ? heart_amounts[@nature][2] : 0
    when "scent"
      amt = (heart_amounts[@nature]) ? heart_amounts[@nature][3] : 100
      amt *= multiplier
    when "koedsomeone"
      amt = -200
      amt *= multiplier
    else
      raise _INTL("Unknown heart gauge-changing method: {1}", method.to_s)
    end
    adjustHeart(-amt)
  end

end




EventHandlers.add(:on_step_taken, :angrysteps,
  proc {
  $PokemonGlobal.happinessSteps = 0 if !$PokemonGlobal.happinessSteps
  $PokemonGlobal.happinessSteps += 1
  if $PokemonGlobal.happinessSteps>=326
for i in 0...$PokemonStorage.maxBoxes
 for j in 0...$PokemonStorage.maxPokemon(i)
  pkmn = $PokemonStorage[i][j]
  if pkmn!=nil
   pkmn.changeHappiness("powder",pkmn) if rand(2)==0
  end 
 end
end
    $PokemonGlobal.happinessSteps = 0
  end
  }
)

EventHandlers.add(:on_step_taken, :angrystepsl,
  proc {
  $PokemonGlobal.loyaltySteps = 0 if !$PokemonGlobal.loyaltySteps
  $PokemonGlobal.loyaltySteps += 1
  if $PokemonGlobal.loyaltySteps>=326
for i in 0...$PokemonStorage.maxBoxes
 for j in 0...$PokemonStorage.maxPokemon(i)
  pkmn = $PokemonStorage[i][j]
  if pkmn!=nil
   pkmn.changeLoyalty("powder",pkmn) if rand(2)==0
  end 
 end
end
    $PokemonGlobal.loyaltySteps = 0
  end
  }
)

class Battle::Battler


 def pbObedienceCheck?(choice)
    return true if usingMultiTurnAttack?
    return true if choice[0]!=:UseMove
    return true if !@battle.internalBattle
    return true if !@battle.pbOwnedByPlayer?(@index)
    disobedient = false
    # Pokémon may be disobedient; calculate if it is
    badgeLevel = 10 * (@battle.pbPlayer.badge_count + 1)
    r = @battle.pbRandom(256)
    badgeLevel = GameData::GrowthRate.max_level if @battle.pbPlayer.badge_count >= 8
    if @pokemon.foreign?(@battle.pbPlayer) && @level>badgeLevel
      a = ((@level+badgeLevel)*@battle.pbRandom(256)/256).floor
      disobedient |= (a>=badgeLevel)
    end
#EDIT
    return pbDisobey(choice, badgeLevel) if @pokemon.loyalty == 0 && rand(255)<= 75
    return pbDisobey(choice, badgeLevel) if @pokemon.loyalty <= 49 && rand(255)<= 50
    return pbDisobey(choice, badgeLevel) if @pokemon.loyalty <= 74 && rand(255)<= 25
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 149 && @pokemon.loyalty == 0 && r <= 50
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 149 && @pokemon.loyalty == 49 && r <= 25
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 149 && @pokemon.loyalty == 74 && r <= 20
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 199 && @pokemon.loyalty == 0 && r <= 45
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 199 && @pokemon.loyalty == 49 && r <= 25
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 199 && @pokemon.loyalty == 74 && r <= 15
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 249 && @pokemon.loyalty == 0 && r <= 40
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 249 && @pokemon.loyalty == 49 && r <= 25
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 249 && @pokemon.loyalty == 74 && r <= 10
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness == 250 && @pokemon.loyalty == 0 && r <= 35
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness == 250 && @pokemon.loyalty == 49 && r <= 25
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness == 250 && @pokemon.loyalty == 74 && r <= 5
#END EDIT
    disobedient |= !pbHyperModeObedience(choice[2])
    return true if !disobedient
    # Pokémon is disobedient; make it do something else
#    return pbDisobey(choice,badgeLevel)
  end


  def pbDisobey(choice,badgeLevel)
    move = choice[2]
    PBDebug.log("[Disobedience] #{pbThis} disobeyed")
    @effects[PBEffects::Rage] = false
    # Do nothing if using Snore/Sleep Talk
    if @status == :SLEEP && move.usableWhenAsleep?
      @battle.pbDisplay(_INTL("{1} ignored orders and kept sleeping!",pbThis))
      return false
    end
    c = @level-badgeLevel
    r = @battle.pbRandom(90)
    # Fall asleep
    if r <= 10  && pbCanSleep?(self,false)
      pbSleepSelf(_INTL("{1} began to nap!",pbThis))
      return false
    end
    # Hurt self in confusion
    if r <= 10 && @status != :SLEEP
      pbConfusionDamage(_INTL("{1} won't obey! It hurt itself in its confusion!",pbThis))
      return false
    end
    #EDIT
    if r <= 20 && r >= 10 && @status != :SLEEP && @pokemon.happiness <= 60
      injury = rand(10)+2
      @battle.pbDisplay(_INTL("{1} turned around and attacked you for {2} damage!",pbThis, injury))
      $player.playerhealth -= injury
      return false 
    end
    if r <= 20 && r >= 10 && @status != :SLEEP && @pokemon.happiness >= 100
      @battle.pbDisplay(_INTL("{1} wants to play!",pbThis))
      return false 
    end
    if r <= 30 && r >= 20 && @status != :SLEEP && @pokemon.happiness <= 30
      injury = rand(10)+2
      @battle.pbDisplay(_INTL("{1} turned around rushed you down, hurting you for {2} damage!",pbThis, injury))
      $player.playerhealth -= injury
      return false 
    end
    if r <= 30 && r >= 20 && @status != :SLEEP && @pokemon.happiness >= 200
      @battle.pbDisplay(_INTL("{1} wants you to praise it before it does anything!",pbThis))
      return false 
    end
    # Use another move
    if (r <= 40 && r >= 30 && @status != :SLEEP) || (r <= 40 && r >= 30 && @status != :SLEEP  && @pokemon.happiness >= 199)
      @battle.pbDisplay(_INTL("{1} ignored orders!",pbThis))
      return false if !@battle.pbCanShowFightMenu?(@index)
      otherMoves = []
      eachMoveWithIndex do |_m,i|
        next if i==choice[1]
        otherMoves.push(i) if @battle.pbCanChooseMove?(@index,i,false)
      end
      return false if otherMoves.length==0   # No other move to use; do nothing
      newChoice = otherMoves[@battle.pbRandom(otherMoves.length)]
      choice[1] = newChoice
      choice[2] = @moves[newChoice]
      choice[3] = -1
      return true
    end
    # Show refusal message and do nothing
    case @battle.pbRandom(4)
    when 0 then @battle.pbDisplay(_INTL("{1} won't obey!",pbThis))
    when 1 then @battle.pbDisplay(_INTL("{1} turned away!",pbThis))
    when 2 then @battle.pbDisplay(_INTL("{1} is loafing around!",pbThis))
    when 3 then @battle.pbDisplay(_INTL("{1} pretended not to notice!",pbThis))
    end
    return false
  end




end