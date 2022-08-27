#===============================================================================
# Trainer class for the player
#===============================================================================

PLAYERSTARTHEALTH = 100
PLAYERSTARTFOOD = 100
PLAYERSTARTWATER = 100
PLAYERSTARTSATURATION = 200
PLAYERSTARTINGSTAMINA = 50
PLAYERSTARTSLEEP = 100
PLAYERMAXHEALTH = 100
PLAYERMAXFOOD = 100
PLAYERMAXWATER = 100
PLAYERMAXSATURATION = 200
PLAYERMAXSTAMINA = 50
PLAYERMAXSLEEP = 100


class Player < Trainer
  # @return [Integer] the character ID of the player
  attr_accessor :character_ID
  # @return [Integer] the player's outfit
  attr_accessor :outfit
  # @return [Array<Boolean>] the player's Gym Badges (true if owned)
  attr_accessor :badges
  # @return [Integer] the player's money
  attr_reader   :money
  # @return [Integer] the player's Game Corner coins
  attr_reader   :coins
  # @return [Integer] the player's battle points
  attr_reader   :battle_points
  # @return [Integer] the player's soot
  attr_reader   :soot
  # @return [Pokedex] the player's Pokédex
  attr_reader   :pokedex
  # @return [Boolean] whether the Pokédex has been obtained
  attr_accessor :has_pokedex
  # @return [Boolean] whether the Pokégear has been obtained
  attr_accessor :has_pokegear
  # @return [Boolean] whether the player has running shoes (i.e. can run)
  attr_accessor :has_running_shoes
  # @return [Boolean] whether the creator of the Pokémon Storage System has been seen
  attr_accessor :seen_storage_creator
  # @return [Boolean] whether Mystery Gift can be used from the load screen
  attr_accessor :mystery_gift_unlocked
  # @return [Array<Array>] downloaded Mystery Gift data
  attr_accessor :mystery_gifts
  attr_reader :playerwater  #206
  attr_reader :playerfood   #205
  attr_reader :playersleep   #208
  attr_reader :playersaturation #207
  attr_reader :playerhealth #225
  attr_reader :playerstamina
  attr_reader :playermaxstamina
  attr_reader :playerstaminamod
  attr_reader :rocketplaythrough
  attr_reader :rocketbadges
  attr_reader :rocketstealing
  attr_reader :rocketstealcount
  attr_reader :playerphysical
  attr_reader :playeremotional
  attr_reader :playerintelligence

  # Sets the player's money. It can not exceed {Settings::MAX_MONEY}.
  # @param value [Integer] new money value
  def money=(value)
    validate value => Integer
    @money = value.clamp(0, Settings::MAX_MONEY)
  end

  # Sets the player's coins amount. It can not exceed {Settings::MAX_COINS}.
  # @param value [Integer] new coins value
  def coins=(value)
    validate value => Integer
    @coins = value.clamp(0, Settings::MAX_COINS)
  end

  # Sets the player's Battle Points amount. It can not exceed
  # {Settings::MAX_BATTLE_POINTS}.
  # @param value [Integer] new Battle Points value
  def battle_points=(value)
    validate value => Integer
    @battle_points = value.clamp(0, Settings::MAX_BATTLE_POINTS)
  end

  # Sets the player's soot amount. It can not exceed {Settings::MAX_SOOT}.
  # @param value [Integer] new soot value
  def soot=(value)
    validate value => Integer
    @soot = value.clamp(0, Settings::MAX_SOOT)
  end

  # @return [Integer] the number of Gym Badges owned by the player
  def badge_count
    return @badges.count { |badge| badge == true }
  end

    def playerwater=(value)
    validate value => Integer
    @playerwater = value.clamp(0, 9999)
  end
  def playerfood=(value)
    validate value => Integer
    @playerfood = value.clamp(0, 9999)
  end
  def playersaturation=(value)
    validate value => Integer
    @playersaturation = value.clamp(0, 9999)
  end
  def playersleep=(value)
    validate value => Integer
    @playersleep = value.clamp(0, 9999)
  end
  def playerhealth=(value)
    validate value => Integer
    @playerhealth = value.clamp(0, 9999)
  end
  def playerstamina=(value)
    validate value => Integer
    @playerstamina = value.clamp(0, 9999)
  end
  def playerintelligence=(value)
    validate value => Integer
    @playerintelligence = value.clamp(0, 9999)
  end
  def playeremotional=(value)
    validate value => Integer
    @playeremotional = value.clamp(0, 9999)
  end
  def playerphysical=(value)
    validate value => Integer
    @playerphysical = value.clamp(0, 9999)
  end
  
  def playermaxstamina=(value)
    validate value => Integer
    @playermaxstamina = value.clamp(0, 9999)
  end
  def playerstaminamod=(value)
    validate value => Integer
    @playerstaminamod = value.clamp(0, 9999)
  end
  def rocketplaythrough=(value)
    validate value => Integer
    @rocketplaythrough = value.clamp(0, 1)
  end
  def rocketbadges=(value)
    validate value => Integer
    @rocketbadges = value.clamp(0, 1)
  end
  def rocketstealing=(value)
    validate value => Integer
    @rocketstealing = value.clamp(0, 1)
  end
  def rocketstealcount=(value)
    validate value => Integer
    @rocketstealcount = value.clamp(0, 9999)
  end
  #=============================================================================

  # (see Pokedex#seen?)
  # Shorthand for +self.pokedex.seen?+.
  def seen?(species)
    return @pokedex.seen?(species)
  end

  # (see Pokedex#owned?)
  # Shorthand for +self.pokedex.owned?+.
  def owned?(species)
    return @pokedex.owned?(species)
  end

  #=============================================================================

  def initialize(name, trainer_type)
    super
    @character_ID          = -1
    @outfit                = 0
    @badges                = [false] * 8
    @money                 = Settings::INITIAL_MONEY
    @coins                 = 0
    @battle_points         = 0
    @soot                  = 0
    @pokedex               = Pokedex.new
    @has_pokedex           = false
    @has_pokegear          = false
    @has_running_shoes     = false
    @seen_storage_creator  = false
    @mystery_gift_unlocked = false
    @mystery_gifts         = []
    @playerwater   = PLAYERSTARTWATER     # Text speed (0=slow, 1=normal, 2=fast)
    @playerfood = PLAYERSTARTFOOD     # Battle effects (animations) (0=on, 1=off)
    @playersaturation = PLAYERSTARTSATURATION     # Battle style (0=switch, 1=set)
    @playersleep = PLAYERSTARTSLEEP     # Battle style (0=switch, 1=set)
    @playerhealth  = PLAYERSTARTHEALTH     # Default window frame (see also Settings::MENU_WINDOWSKINS)
    @playerstamina  = PLAYERSTARTINGSTAMINA     # Speech frame
    @rocketplaythrough                  = 0
    @rocketbadges                  = 0
    @rocketstealing                 = 0
    @rocketstealcount                 = 0
    @playerphysical                 = 0
    @playeremotional                 = 0
    @playerintelligence                 = 0
  end
end
