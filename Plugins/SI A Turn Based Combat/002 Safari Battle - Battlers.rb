
#===============================================================================
# Simple battler class for the wild Pokémon in a Safari Zone battle
#===============================================================================
class Battle::FakeBattler
  attr_reader :battle
  attr_reader :index
  attr_reader :pokemon
  attr_reader :owned
  attr_accessor :tookDamageThisRound
  attr_accessor :droppedBelowHalfHP
  attr_reader :damageState
  attr_accessor :statusCount
  attr_accessor :status
  attr_accessor :item_id
  attr_accessor :ability_id
  attr_accessor :attackFactor
  attr_accessor :catchFactor
  attr_accessor :escapeFactor
  attr_accessor :flinch
  attr_accessor :already_acted
  attr_accessor :endure
  attr_accessor :counter
  attr_accessor :braced
  attr_accessor :approach_offer
  attr_accessor :approached
  attr_accessor :offered_approach_last_turn

  def initialize(battle, index)
    @battle  = battle
	@pokemon = nil
    @pokemon = battle.party2[0] if index>0
    @index   = index
    @status         = :NONE
    @statusCount    = 0
    @ability_id     = nil
    @item_id        = nil
	@hp = self.hp
	@totalhp = self.totalhp
    @droppedBelowHalfHP = false
      @tookDamageThisRound = false
    @damageState = Battle::DamageState.new
    @attackFactor   = 0
    @catchFactor   = 0
    @escapeFactor   = 0
	@already_acted = false 
	@flinch = false 
	@endure = false 
	@counter = false 
	@braced = false 
	@approach_offer = false
	@approached = false
	@offered_approach_last_turn = false 
  end
  
  def hp=(value)
    @hp = value
	@pokemon.hp = value if @index>0
	$player.playerhealth = value if @index==0
  end 
  
  def pokemonIndex;   return 0;                     end
  def species;        return @pokemon&.species;      end
  def gender;         return @pokemon&.gender;       end
  def status;         return @pokemon.status;       end
  def hp;             
   return @pokemon.hp if @index>0
   return $player.playerhealth if @index==0
  end
  def level;          return @pokemon&.level;        end
  def name;           return @pokemon&.name;         end
  def totalhp;        
   return @pokemon.totalhp if @index>0
   return $player.total_health if @index==0
  end
  def displayGender;  return @pokemon&.gender;       end
  def shiny?;         return @pokemon&.shiny?;       end
  def super_shiny?;   return @pokemon&.super_shiny?; end

  def isSpecies?(check_species)
    return @pokemon&.isSpecies?(check_species)
  end

  def fainted?;       return false; end
  def shadowPokemon?; return false; end
  def hasMega?;       return false; end
  def mega?;          return false; end
  def hasPrimal?;     return false; end
  def primal?;        return false; end
  def captured;       return false; end
  def captured=(value); end

  def owned?
    return true if @index==0
    return $player.owned?(pokemon.species)
  end

  def pbThis(lowerCase = false)
    return (lowerCase) ? _INTL("the wild {1}", name) : _INTL("The wild {1}", name) if @index>0
	return $player.name if @index==0
  end

  def opposes?(i)
    i = i.index if i.is_a?(Battle::FakeBattler)
    return (@index & 1) != (i & 1)
  end

  def pbReset; end

  def canRecover?
    return true if @pokemon.inventory.has?(:SITRUSBERRY) || @pokemon.inventory.has?(:ORANBERRY) || @pokemon.inventory.has?(:ORANMASH)
    return true if @pokemon.totalMoves.any? { |move| move.function_code.include?("HealUser") }
	return false 
  end 
  #=============================================================================
  # Change HP
  #=============================================================================
  def pbReduceHP(amt, anim = true, registerDamage = true, anyAnim = true)
    amt = amt.round
    amt = @hp if amt > @hp
    amt = 1 if amt < 1 && !fainted?
    oldHP = @hp
    self.hp -= amt
    PBDebug.log("[HP change] #{pbThis} lost #{amt} HP (#{oldHP}=>#{@hp})") if amt > 0
    raise _INTL("HP less than 0") if @hp < 0
    raise _INTL("HP greater than total HP") if @hp > @totalhp
    @battle.scene.pbHPChanged(self, oldHP, anim) if anyAnim && amt > 0    # Lose happiness
    if @pokemon
      @pokemon.changeHappiness("damaged",@pokemon)
      @pokemon.changeLoyalty("damaged",@pokemon)
    end
    if amt > 0 && registerDamage
      @droppedBelowHalfHP = true if @hp < @totalhp / 2 && @hp + amt >= @totalhp / 2
      @tookDamageThisRound = true
    end
    return amt
  end

  def pbRecoverHP(amt, anim = true, anyAnim = true)
    amt = amt.round
    amt = @totalhp - @hp if amt > @totalhp - @hp
    amt = 1 if amt < 1 && @hp < @totalhp
    oldHP = @hp
    self.hp += amt
    raise _INTL("HP less than 0") if @hp < 0
    raise _INTL("HP greater than total HP") if @hp > @totalhp
    @battle.scene.pbHPChanged(self, oldHP, anim) if anyAnim && amt > 0
    if @pokemon
     @pokemon.changeHappiness("vitamin",@pokemon)
     @pokemon.changeLoyalty("vitamin",@pokemon)
    end
    @droppedBelowHalfHP = false if @hp >= @totalhp / 2
    return amt
  end
end


