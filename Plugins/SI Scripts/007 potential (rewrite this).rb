def pbPotentialBook

        if pbConfirmMessage(_INTL("You can awaken moves within your POKeMON that can be taught at a Move Relearner."))
               pbMessage(_INTL("Which POKeMON?"))
			   pbChoosePokemon(1,3)
     if pbGetPokemon(1).isSpecies?(:MAGIKARP)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Dragon Rage"),
                            _INTL("Bubble"),
                            _INTL("Reversal"),
                            _INTL("Hydro Pump")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:DRAGONRAGE)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:BUBBLE)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REVERSAL)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:HYDROPUMP)
		  end
     elsif pbGetPokemon(1).isSpecies?(:PIKACHU)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Fly"),
                            _INTL("Sing"),
                            _INTL("Refresh"),
                            _INTL("Surf"),
                            _INTL("Teeter Dance")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FLY)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SING)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:TEETERDANCE)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  elsif cmd==4
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SURF)
		  end
	 elsif pbGetPokemon(1).isSpecies?(:PICHU)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Fly"),
                            _INTL("Sing"),
                            _INTL("Refresh"),
                            _INTL("Surf"),
                            _INTL("Teeter Dance")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FLY)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SING)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:TEETERDANCE)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  elsif cmd==4
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SURF)
		  end
     elsif pbGetPokemon(1).isSpecies?(:FEAROW)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Payday")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PAYDAY)
		  end
     elsif pbGetPokemon(1).isSpecies?(:PHANPY)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Absorb"),
                            _INTL("Encore")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:ABSORB)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:ENCORE)
		  end
	 elsif pbGetPokemon(1).isSpecies?(:DONPHAN)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Absorb"),
                            _INTL("Encore"),
                            _INTL("Barrage"),
                            _INTL("Magnitude"),
                            _INTL("Reversal")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:ABSORB)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:ENCORE)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:BARRAGE)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:MAGNITUDE)
		  elsif cmd==4
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REVERSAL)
		  end
     elsif pbGetPokemon(1).isSpecies?(:MAGNEMITE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Agility")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:AGILITY)
		  end
     elsif pbGetPokemon(1).isSpecies?(:VOLTORB)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Agility"),
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:AGILITY)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:HOPPIP)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Agility")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:AGILITY)
		  end
     elsif pbGetPokemon(1).isSpecies?(:DROWZEE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Amnesia"),
                            _INTL("Belly Drum")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:AMNESIA)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:BELLYDRUM)
		  end
     elsif pbGetPokemon(1).isSpecies?(:REMORAID)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Amnesia"),
                            _INTL("Mist")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:AMNESIA)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:MIST)
		  end
     elsif pbGetPokemon(1).isSpecies?(:CHARMANDER)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Howl"),
                            _INTL("Quick Attack"),
                            _INTL("Block"),
                            _INTL("Acrobatics"),
                            _INTL("False Swipe")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:HOWL)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:QUICKATTACK)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:BLOCK)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:ACROBATICS)
		  elsif cmd==4
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FALSESWIPE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:BULBASAUR)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Ancientpower"),
                            _INTL("Block"),
                            _INTL("False Swipe"),
                            _INTL("Weatherball")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:ANCIENTPOWER)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:BLOCK)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FALSESWIPE)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:WEATHERBALL)
		  end
     elsif pbGetPokemon(1).isSpecies?(:TANGROWTH)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Morningsun")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:MORNINGSUN)
		  end
     elsif pbGetPokemon(1).isSpecies?(:LEDYBA)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Barrier")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:BARRIER)
		  end
     elsif pbGetPokemon(1).isSpecies?(:WOOPER)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Belly Drum")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:BELLYDRUM)
		  end
     elsif pbGetPokemon(1).isSpecies?(:LAPRAS)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Bite")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:BITE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:LICKITUNG)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Doubleslap")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:DOUBLESLAP)
		  end
     elsif pbGetPokemon(1).isSpecies?(:MACHOP)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("False Swipe")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FALSESWIPE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:ZUBAT)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Flail")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FLAIL)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SEEL)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Flail")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FLAIL)
		  end
     elsif pbGetPokemon(1).isSpecies?(:CUBONE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Fury Attack")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FURYATTACK)
		  end
     elsif pbGetPokemon(1).isSpecies?(:DUNSPARCE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Fury Attack"),
                            _INTL("Horn Drill")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FURYATTACK)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:HORNDRILL)
		  end
     elsif pbGetPokemon(1).isSpecies?(:POLIWAG)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Growth"),
                            _INTL("Lovely Kiss"),
                            _INTL("Sweet Kiss")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:GROWTH)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:LOVELYKISS)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SWEETKISS)
		  end
     elsif pbGetPokemon(1).isSpecies?(:POLITOED)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Growth"),
                            _INTL("Lovely Kiss"),
                            _INTL("Sweet Kiss"),
                            _INTL("Cross Chop"),
                            _INTL("Fissure"),
                            _INTL("Hi Jump Kick"),
                            _INTL("Psybeam")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:GROWTH)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:LOVELYKISS)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SWEETKISS)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:CROSSCHOP)
		  elsif cmd==4
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FISSURE)
		  elsif cmd==5
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:HIJUMPKICK)
		  elsif cmd==6
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PSYBEAM)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SPINARAK)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Growth"),
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:GROWTH)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:EEVEE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Growth"),
                            _INTL("Sing"),
                            _INTL("False Swipe"),
                            _INTL("Thief"),
                            _INTL("Triattack")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:GROWTH)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SING)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FALSESWIPE)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:THIEF)
		  elsif cmd==4
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:TRIATTACK)
		  end
     elsif pbGetPokemon(1).isSpecies?(:MANTINE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Gust")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:GUST)
		  end
     elsif pbGetPokemon(1).isSpecies?(:HORSEA)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Haze")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:HAZE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:MISDREAVUS)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Hypnosis")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:HYPNOSIS)
		  end
     elsif pbGetPokemon(1).isSpecies?(:CHINCHOU)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Lightscreen")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:LIGHTSCREEN)
		  end
     elsif pbGetPokemon(1).isSpecies?(:DODUO)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Lowkick")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:LOWKICK)
		  end
     elsif pbGetPokemon(1).isSpecies?(:NIDORANmA)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Lovelykiss"),
                            _INTL("Morningsun"),
                            _INTL("Sweet Kiss")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:LOVELYKISS)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:MORNINGSUN)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SWEETKISS)
		  end
     elsif pbGetPokemon(1).isSpecies?(:NIDORANfE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Lovelykiss"),
                            _INTL("Morningsun"),
                            _INTL("Sweet Kiss")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:LOVELYKISS)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:MORNINGSUN)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SWEETKISS)
		  end
     elsif pbGetPokemon(1).isSpecies?(:BELLSPROUT)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Lovelykiss"),
                            _INTL("Teeter Dance"),
                            _INTL("Sweet Kiss")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:LOVELYKISS)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:TEETERDANCE)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SWEETKISS)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SNORLAX)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Lovelykiss"),
                            _INTL("Splash"),
                            _INTL("Refresh"),
                            _INTL("Sweet Kiss")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:LOVELYKISS)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SPLASH)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SWEETKISS)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SNUBBULL)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Lovelykiss")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:LOVELYKISS)
		  end
     elsif pbGetPokemon(1).isSpecies?(:WOBBUFFET)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Mimic")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:MIMIC)
		  end
     elsif pbGetPokemon(1).isSpecies?(:DELIBIRD)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Payday")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PAYDAY)
		  end
     elsif pbGetPokemon(1).isSpecies?(:PSYDUCK)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Petaldance"),
                            _INTL("Triattack")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PETALDANCE)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:TRIATTACK)
		  end
     elsif pbGetPokemon(1).isSpecies?(:CHIKORITA)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Petal Dance"),
                            _INTL("Ancient Power"),
                            _INTL("Grass Knot"),
                            _INTL("Grassy Terrain")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PETALDANCE)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:ANCIENTPOWER)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:GRASSKNOT)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:GRASSYTERRAIN)
		  end
     elsif pbGetPokemon(1).isSpecies?(:CLEFFA)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Petal Dance"),
                            _INTL("Swift")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PETALDANCE)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SWIFT)
		  end
     elsif pbGetPokemon(1).isSpecies?(:IGGLYBUFF)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Petal Dance")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PETALDANCE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SMOOCHUM)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Petal Dance")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PETALDANCE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:TAUROS)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Quick Attack"),
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:QUICKATTACK)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:TYROGUE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Rage")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:RAGE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:LARVITAR)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Rage")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:RAGE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:ONIX)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sharpen")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SHARPEN)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SPEAROW)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sonic Boom")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SONICBOOM)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SCYTHER)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sonic Boom"),
                            _INTL("Morningsun"),
                            _INTL("Fly")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SONICBOOM)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:MORNINGSUN)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FLY)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SCIZOR)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sonic Boom"),
                            _INTL("Morningsun"),
                            _INTL("Fly")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SONICBOOM)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:MORNINGSUN)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FLY)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SUNKERN)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Splash")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SPLASH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:TOTODILE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Submission")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SUBMISSION)
		  end
     elsif pbGetPokemon(1).isSpecies?(:YANMA)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sweet Kiss")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SWEETKISS)
		  end
     elsif pbGetPokemon(1).isSpecies?(:EXEGGCUTE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sweet Scent")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SWEETSCENT)
		  end
	 elsif pbGetPokemon(1).isSpecies?(:EXEGGUTOR)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:CHANSEY)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sweet Scent")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SWEETSCENT)
		  end
     elsif pbGetPokemon(1).isSpecies?(:MACHOP)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Thrash")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:THRASH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SWINUB)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Whirlwind")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:WHIRLWIND)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SQUIRTLE) || pbGetPokemon(1).isSpecies?(:WARTORTLE) || pbGetPokemon(1).isSpecies?(:BLASTOISE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Zap Cannon"),
                            _INTL("Block"),
                            _INTL("Follow Me"),
                            _INTL("False Swipe"),
                            _INTL("Bubblebeam")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:ZAPCANNON)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:BLOCK)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FOLLOWME)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FALSESWIPE)
		  elsif cmd==4
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:BUBBLEBEAM)
		  end
     elsif pbGetPokemon(1).isSpecies?(:MAGNETON)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Double Edge"),
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:DOUBLEEDGE)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:CACNEA)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Morning Sun")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:MORNINGSUN)
		  end
     elsif pbGetPokemon(1).isSpecies?(:BUTTERFREE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Morning Sun")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:MORNINGSUN)
		  end
     elsif pbGetPokemon(1).isSpecies?(:WEEPINBELL)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Morning Sun")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:MORNINGSUN)
		  end
     elsif pbGetPokemon(1).isSpecies?(:TANGELA)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Morning Sun"),
                            _INTL("Sunny Day")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:MORNINGSUN)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SUNNYDAY)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SKITTY)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Payday")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PAYDAY)
		  end
     elsif pbGetPokemon(1).isSpecies?(:MEOWTH)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Petal Dance"),
                            _INTL("Sing")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PETALDANCE)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SING)
		  end
     elsif pbGetPokemon(1).isSpecies?(:PIDGEY)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:RATICATE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:ARBOK)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:PARAS)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:VENOMOTH)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SHELLDER)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:HITMONLEE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  endd_first_move(:BUBBLE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:STARMIE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:LEDYBA)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:PINECO)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:TEDDIURSA)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:MAGCARGO)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SEEDOT)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SHROOMISH)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:MAKUHITA)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:MANECTRIC)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh"),
                            _INTL("Electric Terrain")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:ELECTRICTERRAIN)
		  end
     elsif pbGetPokemon(1).isSpecies?(:CARVANHA)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:ZANGOOSE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:BALTOY)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SALAMANCE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:METANG)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Refresh")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:REFRESH)
		  end
     elsif pbGetPokemon(1).isSpecies?(:MAROWAK)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sing"),
                            _INTL("Sandstorm")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SING)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SANDSTORM)
		  end
     elsif pbGetPokemon(1).isSpecies?(:KANGASKHAN)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sing")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SING)
		  end
     elsif pbGetPokemon(1).isSpecies?(:RALTS)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sing"),
                            _INTL("Psychic Terrain")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SING)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PSYCHICTERRAIN)
		  end
     elsif pbGetPokemon(1).isSpecies?(:MAWILE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sing"),
                            _INTL("Sandstorm")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SING)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SANDSTORM)
		  end
     elsif pbGetPokemon(1).isSpecies?(:GULPIN)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sing")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SING)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SPINDA)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sing")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SING)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SNORUNT)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sing"),
                            _INTL("Hail")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SING)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:HAIL)
		  end
     elsif pbGetPokemon(1).isSpecies?(:WHISMUR)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Teeter Dance")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:TEETERDANCE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:RHYHORN)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Double Edge"),
                            _INTL("Sandstorm")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:DOUBLEEDGE)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SANDSTORM)
		  end
     elsif pbGetPokemon(1).isSpecies?(:METAGROSS)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Double Edge")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:DOUBLEEDGE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:JUMPLUFF)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("False Swipe")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FALSESWIPE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:LUNATONE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Moonlight")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:MOONLIGHT)
		  end
     elsif pbGetPokemon(1).isSpecies?(:SOLROCK)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Morning Sun")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:MORNINGSUN)
		  end
     elsif pbGetPokemon(1).isSpecies?(:PIPLUP)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sing")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SING)
		  end
     elsif pbGetPokemon(1).isSpecies?(:ESPEON)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("False Swipe"),
                            _INTL("Thief")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FALSESWIPE)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:THIEF)
		  end
     elsif pbGetPokemon(1).isSpecies?(:CROBAT)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("False Swipe"),
                            _INTL("Shadow Ball"),
                            _INTL("Sky Attack"),
                            _INTL("Sludge Bomb")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FALSESWIPE)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SHADOWBALL)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SKYATTACK)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SLUDGEBOMB)
		  end
     elsif pbGetPokemon(1).isSpecies?(:DRAGONITE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Extreme Speed"),
                            _INTL("Hydro Pump"),
                            _INTL("Earthquake"),
                            _INTL("Barrier")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:EXTREMESPEED)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:HYDROPUMP)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:EARTHQUAKE)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:BARRIER)
		  end
     elsif pbGetPokemon(1).isSpecies?(:AROMATISSE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Disable")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:DISABLE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:PORYGON)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Barrier")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:BARRIER)
		  end
     elsif pbGetPokemon(1).isSpecies?(:MACHAMP)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Double Edge")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:DOUBLEEDGE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:DRATINI)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Extreme Speed"),
                            _INTL("Hydro Pump"),
                            _INTL("Rain Dance")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:EXTREMESPEED)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:HYDROPUMP)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:RAINDANCE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:DRAGONAIR)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Leech Seed")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:LEECHSEED)
		  end
     elsif pbGetPokemon(1).isSpecies?(:ODDISH)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Leech Seed")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:LEECHSEED)
		  end
     elsif pbGetPokemon(1).isSpecies?(:RAPIDASH)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Pay Day")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PAYDAY)
		  end
     elsif pbGetPokemon(1).isSpecies?(:OMANYTE)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Rock Throw")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:ROCKTHROW)
		  end
     elsif pbGetPokemon(1).isSpecies?(:KABUTO)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Rock Throw")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:ROCKTHROW)
		  end
     elsif pbGetPokemon(1).isSpecies?(:VULPIX)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Headbutt"),
                            _INTL("Flame Wheel"),
                            _INTL("Psybeam"),
                            _INTL("Sunny Day"),
                            _INTL("Fire Pledge"),
                            _INTL("Fire Fang"),
                            _INTL("Power Trick"),
                            _INTL("Psychic Fangs")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:HEADBUTT)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FLAMEWHEEL)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PSYBEAM)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SUNNYDAY)
		  elsif cmd==4
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FIREPLEDGE)
		  elsif cmd==5
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FIREFANG)
		  elsif cmd==6
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:POWERTRICK)
		  elsif cmd==7
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PSYCHICFANGS)
		  end
     elsif pbGetPokemon(1).isSpecies?(:NINETALES)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Headbutt"),
                            _INTL("Flame Wheel"),
                            _INTL("Psybeam"),
                            _INTL("Sunny Day"),
                            _INTL("Fire Pledge"),
                            _INTL("Fire Fang"),
                            _INTL("Power Trick"),
                            _INTL("Psychic Fangs")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:HEADBUTT)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FLAMEWHEEL)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PSYBEAM)
		  elsif cmd==3
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SUNNYDAY)
		  elsif cmd==4
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FIREPLEDGE)
		  elsif cmd==5
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:FIREFANG)
		  elsif cmd==6
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:POWERTRICK)
		  elsif cmd==7
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PSYCHICFANGS)
		  end
     elsif pbGetPokemon(1).isSpecies?(:AERODACTYL)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Rock Throw")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:ROCKTHROW)
		  end
     elsif pbGetPokemon(1).isSpecies?(:ZOROARK)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Sludge Bomb")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SLUDGEBOMB)
		  end
     elsif pbGetPokemon(1).isSpecies?(:GOLDEEN)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Swords Dance"),
                            _INTL("Rain Dance")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SWORDSDANCE)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:RAINDANCE)
		  end
     elsif pbGetPokemon(1).isSpecies?(:TURTWIG)
	      cmd = pbMessage(_INTL("Which move do you want to add to {1}?",$game_variables[3]),[
                            _INTL("Petal Dance"),
                            _INTL("Ancient Power"),
                            _INTL("Grass Knot"),
                            _INTL("Swagger")])
		  if cmd==0
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:PETALDANCE)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:ANCIENTPOWER)
		  elsif cmd==1
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:GRASSKNOT)
		  elsif cmd==2
		    pkmn=pbGetPokemon(1)
			pkmn.add_first_move(:SWAGGER)
		  end
	 else
    Kernel.pbMessage(_INTL("That Pokemon does not yet have potential defined."))
end
end
end
