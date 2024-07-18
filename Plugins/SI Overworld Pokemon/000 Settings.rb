module VisibleEncounterSettings
  #------------- SPAWN RATE AND SPAWN PROPABILITY ------------ 
  INSTANT_WILD_BATTLE_PROPABILITY = 50 # default 0.
  # This parameter holds the default propability of normal to overworld encountering.
  # The propability is stored in percentage with possible values 0,1,2,...,100.
  # <= 0           - means only overworld encounters, no instant battles
  # > 0 and < 100  - means overworld encounters and normal encounters at the same time.
  # >= 100         - means only normal encounters and instant battles as usual, no overworld spawning
  
  #--------------- SPAWN POSITION ------------------
  SPAWN_RANGE = 10 # default 4
  # This parameter needs to be a positive integer. It is the maximum range from the player a PokeEvent will be able to spawn 

  RESTRICT_ENCOUNTERS_TO_PLAYER_MOVEMENT = false # default false
  # true - means that water encounters are popping up
  #       if and only if player is surfing
  #       (perhaps decreases encounter rate)
  # false - means that all encounter types can pop up
  #        close to the player (as long as there is a suitable tile)
  
  NO_SPAWN_ON_BORDER = false # default false
  # true  - means that pokemon on water won't spawn in the border
  # false - means that pokemon will also spawn on the border of water   

  #---------------- GRAPHICS OF SPAWNED POKEMON -------------------
  SPRITES = [true, true, true] # default [true, true, true]
  # This parameter must be an array [alt_form, female, shiny] of three bools.
  # alt_form/ female/ shiny = false means: you don't use alternative/ female/ shiny sprites for your overworld encounter.
  #                         = true  means: alternative forms/ female forms/ shiny pokemon have there own special overworld sprite.
  # If true, make sure that you have the overworld sprites with the right name in your "\Graphics\Characters\Follower" folder
  # and that you have the shiny overworld sprites with the same name in your "\Graphics\Characters\Follower shiny" folder.
  # The right name of sprites:
  #  usual form     - SPECIES.png   where SPECIES is the species name in capslock (e.g. PIDGEY.png)
  #  alternate form - SPECIES_n.png where n is the number of the form (e.g. PIKACHU_3.png)
  #  female form    - SPECIES_female.png or SPECIES_n_female (e.g. PIDGEY_female.png or PIKACHU_3_female.png)
  
  USE_STEP_ANIMATION = true # default true
  #false - means that overworld encounters don't have a stop-animation
  #true - means that overworld encounters have a stop-animation similar as  
  #       following pokemon
  
  #------------------- MOVEMENT OF SPAWNED POKEMON -----------------------
  DEFAULT_MOVEMENT = [3, 3, 1] # default [3, 3, 1]
  # This parameter stores an array [move_speed, move_frequency, move_type] of three integers where
  # move_speed/ move_frequency/ move_type is the default movement speed/ frequency/ type of spawned PokeEvents.
  # See RPGMakerXP for more details (compare to autonomous movement of events).
  # speed/ frequency = 1   - means lowest movement speed/ frequency
  # speed/ frequency = 6   - means highest movement speed/ frequency
  # type = 0/ 1/ 3         - means no movement/ random movement/ run to player
  # ...

  Enc_Movements = [                  # default
    [:shiny?, true, 6, 6, nil],    # [:shiny?, true, 3, 4, 3] means that shiny encounters will be faster
    [:species, :SLOWPOKE, 1, 1, nil], # [:species, :SLOWPOKE, 1, 1, nil] means that slowpoke is very slow. It might still want to run random or to the player.
    [:nature, :NAUGHTY, nil, 4, 3] # [:nature, :NAUGHTY, nil, 4, 3] means pokemon with a naughty nature will run to the player and be faster
  ]
  # This parameter is used to change movement of spawned PokeEvents depending on the spawned pokemon.
  # The data is stored as an array of arrays. You can add your own arrays.s
  # The data is stored as an array of entries [variable, value, move_speed, move_frequency, move_type], where variable
  # is a variable or method which does not require parameters of the class Pokemon,
  # value is a possible outcome value of variable and move_speed, move_frequency and move_type are the movement speed,
  # frequency and type all PokeEvents should get if value == pokemon.variable.
  # nil  - means that the movement-parameter will not be changed.

  #--------------- BATTLING SPAWNED POKEMON ------------------
  BATTLE_WATER_FROM_SHORE = true #default true
  # this is used if you want to battle water pokemon without surfing
  # (default is true but I think is better in false)
  #false - means the battle wont start if not surfing 
  #true - means you can battle from the ground a pokemon from the water

  #--------------- VANISHING OF SPAWNED POKEMON AFTER STEPS -------------------
  DEFAULT_STEPS_BEFORE_VANISH = 90 # default 10
  # This is the number of steps a wild encounter goes by default before vanishing on the map.

  Add_Steps_Before_Vanish = [ # default
    [:shiny?, true, 10],       # [:shiny, true, 8]       - means that spawned shiny pokemon will more 8 steps longer on the map than default.
    [:species, :PIDGEY, -2]   # [:species, :PIDGEY, -2] - means that pidgeys will be gone faster (2 steps earlier).
  ]
  # This is an array of arrays. You can add your own conditions as an additional array. It must be of the form [variable, value, number] where
  # variable is a variable or an method that does not need any parameters of the class Pokemon,
  # value is a possible value of variable and number is the number of steps an pokemon goes more (or less) than default before vanishing on the map 
  # if it satisfies pokemon.variable == value
  
end


module VisibleEncounterSettings
  #------------- ADDITIONAL ANIMATIONS DURING SPAWNING ETC ------------
  # Create your own animations in database, then and edit the number ids 
  DEFAULT_RUSTLE_ANIMATION_ID = Settings::RUSTLE_NORMAL_ANIMATION_ID # default Settings::RUSTLE_NORMAL_ANIMATION_ID
  # This parameter stores the id of the default animation that triggers when a new pokemon spawns on the overworld.
  # Usually it is the normal grass rustle animation. But you can create your own animation in database and place in its id here.
  
  ENV_SPAWN_ANIMATIONS = [                          # default
    [:dust, Settings::DUST_ANIMATION_ID],           # [:dust, Settings::DUST_ANIMATION_ID],  -  means if pokemon spawns on dust then use default dust animation
    [:land, Settings::RUSTLE_NORMAL_ANIMATION_ID],  # [:land, Settings::RUSTLE_NORMAL_ANIMATION_ID],  -  means if pokemon spawns on land then use default grass rustle animation
    [:water, 27]                                    # [:water, 10],  -  means if pokemon spawns on water then use user animation with id 10
  ]
  # This parameter is used to add a grass rustle/ water splash/ etc. animation depending on the ground where the pokemon spawns.
  # The data is stored as an array of entries [encounter_type, animation_id], where encounter_type is a GameData::EncounterType 
  # and animation_id is the id of the user animation.
  
  Enc_Spawn_Animations = [     # default
    [:shiny?, true, 25],        # [:shiny?, true, 8],     -  means if pokemon is shiny then use animation with id 8
    [:pokerusStage, 1, 26]      # [:pokerusStage, 1, 11]  -  means if pokemon is infected then use animation with id 11
  ]
  # This parameter is used to add an animation to the PokeEvent depending on the spawning pokemon.
  # The data is stored as an array of entries [method, value, animation_id], where method is a variable or method which does not require parameters of the class Pokemon,
  # value is a possible outcome value of the method method and animation_id is the id of the user animation that should 
  # trigger if value == pokemon.method for the spawning pokemon pokemon.
  
  Perma_Enc_Animations = [  # default
    [:shiny?, true, 26],     # [:shiny?, true, 7],  -  means if pokemon is shiny then permanently play animation with id 7 from database
  ]
  # This parameter is used to add an permanent animation to the PokeEvent depending on the spawning pokemon.
  # The data is stored as an array of entries [variable, value, animation_id], where variable is a variable or a method (that does not need a ) of the class Pokemon,
  # value is a possible outcome value of that variable and animation_id is the id of the existing user animation in database
  # that will play constantly over the overworld PokeEvent if it is in the screen and the value value equals the actual value
  # of the variable of that Game_PokeEvent.
end


module VisibleEncounterSettings

  LET_NORMAL_ENCOUNTERS_SPAWN = true # default false
  # This parameter must be true or false. This parameter comes in play when
  # there is no specific overworld encounter type defined in the PBS "encounters.txt"
  # false - means: if there is no specific overworld ecounter type in the PBS 
  #         for the current map then there will be no spawning pokemon on that map
  # true  - means: if there is no specific overworld ecounter type in the PBS 
  #         for the current map but a usual encounter type then a pokemon from
  #         that usual encounter type list will spawn
  
end
