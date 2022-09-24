#===============================================================================
# Core additions to PBEffects.
#===============================================================================
module PBEffects
  # Battler Effects
  FocusStyle    = 312
  FocusLock     = 313
  DampenFocus   = 314
  FullyFocused  = 315
  
  # Side Effects
  FocusedGuard  = 206
end

class Battle::ActiveSide
  alias focus_initialize initialize
  def initialize
    focus_initialize
    @effects[PBEffects::FocusedGuard] = 0
  end
end

#===============================================================================
# Core additions to Battle::Battler.
#===============================================================================
class Battle::Battler
  attr_accessor :focus_meter
  attr_accessor :focus_timer
  attr_accessor :focus_trigger
  
  #-----------------------------------------------------------------------------
  # Initializes a battler's focus properties.
  #-----------------------------------------------------------------------------
  alias focus_pbInitPokemon pbInitPokemon
  def pbInitPokemon(pkmn, idxParty)
    focus_pbInitPokemon(pkmn,idxParty)
    @focus_id = GameData::Focus.get(pkmn.focus_style).id
  end
  
  alias focus_pbInitEffects pbInitEffects  
  def pbInitEffects(batonPass)
    focus_pbInitEffects(batonPass)
    if batonPass
      @effects[PBEffects::FullyFocused] = (@effects[PBEffects::FullyFocused] > 0) ? 2 : 0
    else
      @focus_meter                      = 0
      @effects[PBEffects::FocusLock]    = 0
      @effects[PBEffects::DampenFocus]  = false
      @effects[PBEffects::FullyFocused] = 0
    end
    @focus_timer                        = Settings::FOCUS_METER_TIMER
    @focus_trigger                      = false
    @effects[PBEffects::FocusStyle]     = @focus_id || :None
  end
  
  #-----------------------------------------------------------------------------
  # Related to a battler's focus style.
  #-----------------------------------------------------------------------------
  # Checks user's current style.
  def inAccuracyStyle?;  return @effects[PBEffects::FocusStyle] == :Accuracy; end
  def inEvasionStyle?;   return @effects[PBEffects::FocusStyle] == :Evasion;  end
  def inCriticalStyle?;  return @effects[PBEffects::FocusStyle] == :Critical; end
  def inPotencyStyle?;   return @effects[PBEffects::FocusStyle] == :Potency;  end
  def inPassiveStyle?;   return @effects[PBEffects::FocusStyle] == :Passive;  end
  def inEnragedStyle?;   return @effects[PBEffects::FocusStyle] == :Enraged;  end
    
  # Checks if user has queued up a focus mechanic.
  def hasFocusedShot?
    return false if @effects[PBEffects::SkyDrop] >= 0
    return false if @effects[PBEffects::FocusLock] > 0
    return false if [:SLEEP, :FROZEN].include?(self.status)
    return true if hasFocusedRage? # Focused Rage gains all effects of Focused Shot.
    return @focus_trigger && inAccuracyStyle?
  end
  
  def hasFocusedDodge?
    return false if @effects[PBEffects::SkyDrop] >= 0
    return false if @effects[PBEffects::FocusLock] > 0
    return false if [:SLEEP, :FROZEN].include?(self.status)
    return true if hasFocusedRage? # Focused Rage gains all effects of Focused Dodge.
    return @focus_trigger && inEvasionStyle?
  end
  
  def hasFocusedStrike?
    return false if @effects[PBEffects::SkyDrop] >= 0
    return false if @effects[PBEffects::FocusLock] > 0
    return false if [:SLEEP, :FROZEN].include?(self.status)
    return true if hasFocusedRage? # Focused Rage gains all effects of Focused Strike.
    return @focus_trigger && inCriticalStyle?
  end
  
  def hasFocusedEffect?
    return false if @effects[PBEffects::SkyDrop] >= 0
    return false if @effects[PBEffects::FocusLock] > 0
    return false if [:SLEEP, :FROZEN].include?(self.status)
    return true if hasFocusedRage? # Focused Rage gains all effects of Focused Effect.
    return @focus_trigger && inPotencyStyle?
  end
  
  def hasFocusedGuard?
    return false if @effects[PBEffects::SkyDrop] >= 0
    return false if @effects[PBEffects::FocusLock] > 0
    return @focus_trigger && inPassiveStyle?
  end
  
  def hasFocusedRage?
    return false if @effects[PBEffects::SkyDrop] >= 0
    return false if @effects[PBEffects::FocusLock] > 0
    return @focus_trigger && inEnragedStyle?
  end
    
  # Changes the user's focus style mid-battle.
  def shift_focus(style, showFail = false)
    return if $game_switches[Settings::NO_FOCUS_MECHANIC]
    return if !GameData::Focus.exists?(style)
    # Boss styles cannot be changed.
    if GameData::Focus.get(@effects[PBEffects::FocusStyle]).users == :boss
      @battle.pbDisplay(_INTL("{1}'s focus cannot be shifted away from its current style!", pbThis)) if showFail
    else
      if @effects[PBEffects::FocusStyle] != style
        reset_focus_meter if @focus_meter > 0
        @effects[PBEffects::FocusStyle] = style
        style_name = GameData::Focus.get(style).name
        @battle.pbDisplay(_INTL("{1}'s focus was shifted to the {2} style!", pbThis, style_name))
      end
    end
  end
  
  #-----------------------------------------------------------------------------
  # Related to a battler's focus meter.
  #-----------------------------------------------------------------------------
  def focus_meter=(value)
    @focus_meter = value
  end
  
  def focus_timer=(value)
    @focus_timer = value
  end
  
  def focus_trigger=(value)
    @focus_trigger = value
  end
  
  def focus_meter_empty?
    return @focus_meter == 0
  end
  
  def focus_meter_full?
    max = (Settings::FOCUS_METER_SIZE > 10) ? Settings::FOCUS_METER_SIZE : 10
    return @focus_meter == max
  end
  
  def reset_focus_meter
    @battle.scene.pbFillFocusMeter(self, @focus_meter, 0, Settings::FOCUS_METER_SIZE)
    @focus_timer = Settings::FOCUS_METER_TIMER
    @focus_trigger = false
    @focus_meter = 0
  end
  
  def update_focus_meter(amount = 0)
    return if $game_switches[Settings::NO_FOCUS_MECHANIC]
    return if amount == 0 || focus_meter_full?
    startMeter = @focus_meter
    newMeter = (@focus_meter + amount).clamp(0, Settings::FOCUS_METER_SIZE)
    # Increases meter if amount is a positive number.
    if newMeter > startMeter
      self.focus_meter = newMeter
      if $DEBUG && Input.press?(Input::CTRL) && pbOwnedByPlayer?
        self.focus_meter = Settings::FOCUS_METER_SIZE 
      end
      endMeter = @focus_meter
      rangeMeter = endMeter - startMeter
      if rangeMeter > 0
        @battle.scene.pbFillFocusMeter(self, startMeter, endMeter, rangeMeter)
        if focus_meter_full? && pbOwnedByPlayer?
          pbSEPlay("GUI Focus Meter")
          @battle.pbDisplay(_INTL("{1} is ready to harness its built up focus!", pbThis))
          pbWait(32)
        end
      end
    # Decreases meter if amount is a negative number.
    elsif newMeter < startMeter
      @battle.scene.pbFillFocusMeter(self, startMeter, newMeter, Settings::FOCUS_METER_SIZE)
      self.focus_meter = newMeter
    end
  end
end