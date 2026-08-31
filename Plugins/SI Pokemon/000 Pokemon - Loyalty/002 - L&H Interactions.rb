    # Changing
class Pokemon
DATA_HASH = {
  :happiness => {
    :base => {
      :LOVING => 0,
      :HATEFUL => 0,
      :QUIRKY => 30,
      :CAREFUL => 0,
      :SASSY => -5,
      :GENTLE => 0,
      :CALM => 0,
      :RASH => 50,
      :BASHFUL => 0,
      :QUIET => 0,
      :MILD => 0,
      :MODEST => 0,
      :NAIVE => 0,
      :JOLLY => 0,
      :SERIOUS => -10,
      :HASTY => 75,
      :TIMID => 0,
      :LAX => 0,
      :IMPISH => 0,
      :RELAXED => 0,
      :DOCILE => 0,
      :BOLD => 75,
      :NAUGHTY => 5,
      :ADAMANT => 10,
      :BRAVE => 100,
      :LONELY => 0,
      :HARDY => 70
    },
    :gains => {
      :LOVING => {

      },
      :LONELY => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :BRAVE => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :ADAMANT => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :NAUGHTY => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :BOLD => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :DOCILE => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :RELAXED => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :IMPISH => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :LAX => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :TIMID => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :HASTY => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :SERIOUS => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :JOLLY => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :NAIVE => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :MODEST => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :MILD => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :QUIET => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :BASHFUL => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :RASH => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :CALM => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :GENTLE => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :SASSY => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :CAREFUL => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :QUIRKY => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [5, 3, 2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :HATEFUL => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :DEFAULT => {
  "walking"          => [2, 2, 1],
  "levelup"          => [5, 4, 3],
  "groom"            => [10, 10, 4],
  "evberry"          => [10, 5, 2],
  "vitamin"          => [5, 3, 2],
  "wing"             => [3, 2, 1],
  "machine"          => [1, 1, 0],
  "battleitem"       => [1, 1, 0],
  "faint"            => -1,
  "faintbad"         => [-5, -5, -10],
  "powder"           => [-5, -5, -10],
  "energyroot"       => [-10, -10, -15],
  "revivalherb"      => [-15, -15, -20],
  "damaged"          => [-1, -3, -2],
  "neglected"        => [-1, -1, -5],
  "hungry"           => [-1, -1, -5],
  "thirsty"          => [-1, -1, -1],
  "tired"            => [-1, -1, -5],
  "youareeatingme"   => [-255, -255, -255],
  "didDamage"        => [5, 3, 2],
  "TrainerPassedOut" => [5, 3, 2],
  "FollowerPkmn"     => [5, 3, 2]}
    
    }
  },
  :loyalty => {
    :base => {
      :LOVING => 0,
      :HATEFUL => 0,
      :QUIRKY => 30,
      :CAREFUL => 0,
      :SASSY => -5,
      :GENTLE => 0,
      :CALM => 0,
      :RASH => 50,
      :BASHFUL => 0,
      :QUIET => 0,
      :MILD => 0,
      :MODEST => 0,
      :NAIVE => 0,
      :JOLLY => 0,
      :SERIOUS => -10,
      :HASTY => 75,
      :TIMID => 0,
      :LAX => 0,
      :IMPISH => 0,
      :RELAXED => 0,
      :DOCILE => 0,
      :BOLD => 75,
      :NAUGHTY => 5,
      :ADAMANT => 10,
      :BRAVE => 100,
      :LONELY => 0,
      :HARDY => 70
    },
    :gains => {
      :LOVING => {

      },
      :LONELY => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :BRAVE => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :ADAMANT => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :NAUGHTY => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :BOLD => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :DOCILE => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :RELAXED => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :IMPISH => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :LAX => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :TIMID => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :HASTY => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :SERIOUS => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :JOLLY => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :NAIVE => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :MODEST => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :MILD => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :QUIET => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :BASHFUL => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :RASH => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :CALM => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :GENTLE => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :SASSY => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :CAREFUL => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :QUIRKY => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [5, 3, 2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :HATEFUL => {
        "walking" => [1, 1, 1],
        "levelup" => [5, 4, 3],
        "groom" => [10, 10, 4],
        "evberry" => [10, 5, 2],
        "vitamin" => [5, 3, 2],
        "wing" => [3, 2, 1],
        "machine" => [1, 1, 0],
        "battleitem" => [1, 1, 0],
        "faint" => [-20, -20, -30],
        "powder" => [-15, -15, -10],
        "energyroot" => [-1, -1, -1],
        "revivalherb" => [-15, -15, -20],
        "damaged" => [-5, -3, -2],
        "neglected" => [-1, -1, -1],
        "hungry" => [-1, -1, -1],
        "thirsty" => [-1, -1, -1],
        "tired" => [-1, -1, -1],
        "youareeatingme" => [-255, -255, -255],
        "didDamage" => [10, 10, 10],
        "TrainerPassedOut" => [10, 10, 10],
        "FollowerPkmn" => [10, 10, 10]
      },
      :DEFAULT => {
  "walking"          => [2, 2, 1],
  "levelup"          => [5, 4, 3],
  "groom"            => [10, 10, 4],
  "evberry"          => [10, 5, 2],
  "vitamin"          => [5, 3, 2],
  "wing"             => [3, 2, 1],
  "machine"          => [1, 1, 0],
  "battleitem"       => [1, 1, 0],
  "faint"            => -1,
  "faintbad"         => [-5, -5, -10],
  "powder"           => [-5, -5, -10],
  "energyroot"       => [-10, -10, -15],
  "revivalherb"      => [-15, -15, -20],
  "damaged"          => [-1, -3, -2],
  "neglected"        => [-1, -1, -5],
  "hungry"           => [-1, -1, -5],
  "thirsty"          => [-1, -1, -1],
  "tired"            => [-1, -1, -5],
  "youareeatingme"   => [-255, -255, -255],
  "didDamage"        => [5, 3, 2],
  "TrainerPassedOut" => [5, 3, 2],
  "FollowerPkmn"     => [5, 3, 2]}
    }
  }
}
  def get_happiness_gains(method, nature,happiness_range)
    puts self.nature.id
    gains = DATA_HASH[:happiness][:gains][self.nature.id][method][happiness_range] if DATA_HASH[:happiness][:gains][self.nature.id] && DATA_HASH[:happiness][:gains][self.nature.id][method]
    gains = DATA_HASH[:happiness][:gains][:DEFAULT][method][happiness_range] if gains.nil?
    return gains
  end 
  def get_happiness_base(method, nature,happiness_range)
    base = DATA_HASH[:happiness][:base][self.nature.id]
    base = 0 if base.nil?
  
    return base 
  end 
  def get_loyalty_gains(method, nature,loyalty_range)
    gains = DATA_HASH[:loyalty][:gains][self.nature.id][method][loyalty_range] if DATA_HASH[:loyalty][:gains][self.nature.id] && DATA_HASH[:loyalty][:gains][self.nature.id][method]
    gains = DATA_HASH[:loyalty][:gains][:DEFAULT][method][loyalty_range] if gains.nil?
    return gains
  end 
  def get_loyalty_base(method, nature,loyalty_range)
    base = DATA_HASH[:loyalty][:base][self.nature.id]
    base = 0 if base.nil?
  
    return base 
  end 
  def changeHappiness(method,pkmn=self)
    return if method == "damaged"
	pkmn.happiness = 70 if @happiness.nil? 
    happiness_range = @happiness / 100
	base = get_happiness_base(method, nature,happiness_range)
	gain = get_happiness_gains(method, nature,happiness_range)
    if gain > 0
      gain += 1 if @obtain_map == $game_map.map_id
      gain += 1 if @poke_ball == :LUXURYBALL
      gain = (gain * 1.5).floor if hasItem?(:SOOTHEBELL)
	  bonus += 1 if self.nature == :LOVING
    end
	gain = 0 if gain < 0 && $player.is_it_this_class?(:COORDINATOR, false)
    @happiness = (@happiness + gain + base).clamp(0, 255)
  end

  
  # Changes the happiness of this Pokémon depending on what happened to change it.
  # @param method [String] the happiness changing method (e.g. 'walking')
  def changeLoyalty(method,wari=self)
    return if method == "damaged"
    gain = 0
    bonus = 0
    pkmn = wari

	@loyalty = 100 if @loyalty.nil?
    loyalty_range = @loyalty / 100
	base = get_loyalty_base(method, nature,loyalty_range)
	gain = get_loyalty_gains(method, nature,loyalty_range)
    if gain > 0
      gain += 1 if @obtain_map == $game_map.map_id
	  gain += rand(5)+5 if $player.is_it_this_class?(:MONK, false)
	end
    @loyalty = (@loyalty + gain + base).clamp(0, 255)
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
  
  def loyalty_state
    case @loyalty
     when 0
      :NoTrust
     when 1..63
      :Distrusted
     when 64..127
      :Familiar
     when 128..191
      :Reliable
     when 192..254
      :Devoted
     when 255
      :Partner
     end
  
  end 
  def happiness_state
    case @happiness
     when 0
      :Hateful
     when 1..63
      :Unhappy
     when 64..127
      :Neutral
     when 128..191
      :Positive
     when 192..254
      :Happy
     when 255
      :Adoration
     end
  
  end 
  
end




EventHandlers.add(:on_step_taken, :angrysteps,
  proc {
  next 
  $PokemonGlobal.happinessSteps = 0 if !$PokemonGlobal.happinessSteps
  $PokemonGlobal.happinessSteps += 1
  if $PokemonGlobal.happinessSteps>=326
  $PokemonGlobal.pokemonStorageSystems.values.each do |storage|
   for i in 0...storage.maxBoxes
    for j in 0...storage.maxPokemon(i)
     pkmn = storage[i][j]
     next if !pkmn
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
  next 
  $PokemonGlobal.loyaltySteps = 0 if !$PokemonGlobal.loyaltySteps
  $PokemonGlobal.loyaltySteps += 1
  if $PokemonGlobal.loyaltySteps>=326
  $PokemonGlobal.pokemonStorageSystems.values.each do |storage|
   for i in 0...storage.maxBoxes
    for j in 0...storage.maxPokemon(i)
     pkmn = storage[i][j]
     next if !pkmn
     pkmn.changeLoyalty("powder",pkmn) if rand(2)==0
    end
   end
  end 
  $PokemonGlobal.happinessSteps = 0
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
	  damagePlayer(injury)
      return false 
    end
    if r <= 20 && r >= 10 && @status != :SLEEP && @pokemon.happiness >= 100
      @battle.pbDisplay(_INTL("{1} wants to play!",pbThis))
      return false 
    end
    if r <= 30 && r >= 20 && @status != :SLEEP && @pokemon.happiness <= 30
      injury = rand(10)+2
      @battle.pbDisplay(_INTL("{1} turned around rushed you down, hurting you for {2} damage!",pbThis, injury))
	  damagePlayer(injury)
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