

EventHandlers.add(:on_player_step_taken_can_transfer, :loyalty,
  proc {
  $PokemonGlobal.loyaltySteps = 0 if !$PokemonGlobal.loyaltySteps
  $PokemonGlobal.loyaltySteps += 1
  if $PokemonGlobal.loyaltySteps>=128
    for pkmn in $Trainer.able_party
      pkmn.changeLoyalty("walking",pkmn) if rand(2)==0
    end
    $PokemonGlobal.loyaltySteps = 0
  end
}
)

class HappinessHandlerHash < HandlerHash2
end

module BattleHandlers
  PriorityBracketHappy           = HappinessHandlerHash.new   # None!
  
  def self.triggerPriorityBracketHappy(battler,battle)
    PriorityBracketHappy.trigger(battler,battle)
  end
end  

  # Quick Claw, Custap Berry's "X let it move first!" message.
  def pbAttackPhasePriorityChangeMessages
    pbPriority.each do |b|
      if b.effects[PBEffects::PriorityAbility] && b.abilityActive?
        BattleHandlers.triggerPriorityBracketUseAbility(b.ability,b,self)
      elsif b.effects[PBEffects::PriorityItem] && b.itemActive?
        BattleHandlers.triggerPriorityBracketUseItem(b.item,b,self)
      elsif battler.happiness >=200
        BattleHandlers.triggerPriorityBracketHappy(b,self)
      end
    end
  end
  
  
class HappinessHandlerHash < HandlerHash2
end

module BattleHandlers
  PriorityBracketHappy           = HappinessHandlerHash.new   # None!
  
  def self.triggerPriorityBracketHappy(battler,battle)
    PriorityBracketHappy.trigger(battler,battle)
  end
end  

  # Quick Claw, Custap Berry's "X let it move first!" message.
  def pbAttackPhasePriorityChangeMessages
    pbPriority.each do |b|
      if b.effects[PBEffects::PriorityAbility] && b.abilityActive?
        BattleHandlers.triggerPriorityBracketUseAbility(b.ability,b,self)
      elsif b.effects[PBEffects::PriorityItem] && b.itemActive?
        BattleHandlers.triggerPriorityBracketUseItem(b.item,b,self)
      elsif battler.happiness >=200
        BattleHandlers.triggerPriorityBracketHappy(b,self)
      end
    end
  end

  class PokeBattle_Move
    def pbEndureKOMessage(target)
    if target.damageState.disguise
      @battle.pbShowAbilitySplash(target)
      if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("Its disguise served it as a decoy!"))
      else
        @battle.pbDisplay(_INTL("{1}'s disguise served it as a decoy!",target.pbThis))
      end
      @battle.pbHideAbilitySplash(target)
      target.pbChangeForm(1,_INTL("{1}'s disguise was busted!",target.pbThis))
      target.pbReduceHP(target.totalhp/8)
    elsif target.damageState.iceface
      @battle.pbShowAbilitySplash(target)
      target.pbChangeForm(1,_INTL("{1} transformed!",target.pbThis))
      @battle.pbHideAbilitySplash(target)
    elsif target.damageState.endured
      @battle.pbDisplay(_INTL("{1} endured the hit!",target.pbThis))
    elsif target.damageState.sturdy
      @battle.pbShowAbilitySplash(target)
      if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1} endured the hit!",target.pbThis))
      else
        @battle.pbDisplay(_INTL("{1} hung on with Sturdy!",target.pbThis))
      end
      @battle.pbHideAbilitySplash(target)
    elsif target.damageState.focusSash
      @battle.pbCommonAnimation("UseItem",target)
      @battle.pbDisplay(_INTL("{1} hung on using its Focus Sash!",target.pbThis))
      target.pbConsumeItem
    elsif target.damageState.focusBand
      @battle.pbCommonAnimation("UseItem",target)
      @battle.pbDisplay(_INTL("{1} hung on using its Focus Band!",target.pbThis))
    end
  end
  end
  
  class PokeBattle_Battler
  attr_accessor :loyalty
  attr_accessor :happiness
  
    def pbEndOfBattle
    oldDecision = @decision
    @decision = 4 if @decision==1 && wildBattle? && @caughtPokemon.length>0
    case oldDecision
    ##### WIN #####
    when 1
      PBDebug.log("")
      PBDebug.log("***Player won***")
      if trainerBattle?
        @scene.pbTrainerBattleSuccess
        case @opponent.length
        when 1
          pbDisplayPaused(_INTL("You defeated {1}!",@opponent[0].full_name))
        when 2
          pbDisplayPaused(_INTL("You defeated {1} and {2}!",@opponent[0].full_name,
             @opponent[1].full_name))
        when 3
          pbDisplayPaused(_INTL("You defeated {1}, {2} and {3}!",@opponent[0].full_name,
             @opponent[1].full_name,@opponent[2].full_name))
        end
        @opponent.each_with_index do |_t,i|
          @scene.pbShowOpponent(i)
          msg = (@endSpeeches[i] && @endSpeeches[i]!="") ? @endSpeeches[i] : "..."
          pbDisplayPaused(msg.gsub(/\\[Pp][Nn]/,pbPlayer.name))
        end
      end
      # Gain money from winning a trainer battle, and from Pay Day
      pbGainMoney if @decision!=4
      # Hide remaining trainer
      @scene.pbShowOpponent(@opponent.length) if trainerBattle? && @caughtPokemon.length>0
    ##### LOSE, DRAW #####
    when 2, 5
      PBDebug.log("")
      PBDebug.log("***Player lost***") if @decision==2
      PBDebug.log("***Player drew with opponent***") if @decision==5
      if @internalBattle
        pbDisplayPaused(_INTL("You have no more Pokémon that can fight!"))
        if trainerBattle?
          case @opponent.length
          when 1
            pbDisplayPaused(_INTL("You lost against {1}!",@opponent[0].full_name))
          when 2
            pbDisplayPaused(_INTL("You lost against {1} and {2}!",
               @opponent[0].full_name,@opponent[1].full_name))
          when 3
            pbDisplayPaused(_INTL("You lost against {1}, {2} and {3}!",
               @opponent[0].full_name,@opponent[1].full_name,@opponent[2].full_name))
             end
        end
        if wildBattle?
          foeParty = pbParty(1)
          case foeParty.length
            when 1
            pbDisplayPaused(_INTL("The Wild {1} started charging at you!",foeParty[0].name))
          when 2
            pbDisplayPaused(_INTL("Oh! A wild {1} and {2} started charging at you!",foeParty[0].name,
               foeParty[1].name))
          when 3
            pbDisplayPaused(_INTL("The Wild {1}, {2} and {3} all started charging at once!",foeParty[0].name,
               foeParty[1].name,foeParty[2].name))
          end
      end
        # Lose money from losing a battle
        #EDIT
        $Trainer.playerhealth += rand(30)
        pbLoseMoney
        pbDisplayPaused(_INTL("You blacked out!")) if !@canLose
      elsif @decision==2
        if @opponent
          @opponent.each_with_index do |_t,i|
            @scene.pbShowOpponent(i)
            msg = (@endSpeechesWin[i] && @endSpeechesWin[i]!="") ? @endSpeechesWin[i] : "..."
            pbDisplayPaused(msg.gsub(/\\[Pp][Nn]/,pbPlayer.name))
          end
        end
      end
    ##### CAUGHT WILD POKÉMON #####
    when 4
      @scene.pbWildBattleSuccess if !Settings::GAIN_EXP_FOR_CAPTURE
    end
    # Register captured Pokémon in the Pokédex, and store them
    pbRecordAndStoreCaughtPokemon
    # Collect Pay Day money in a wild battle that ended in a capture
    pbGainMoney if @decision==4
    # Pass on Pokérus within the party
    if @internalBattle
      infected = []
      $Trainer.party.each_with_index do |pkmn,i|
        infected.push(i) if pkmn.pokerusStage==1
      end
      infected.each do |idxParty|
        strain = $Trainer.party[idxParty].pokerusStrain
        if idxParty>0 && $Trainer.party[idxParty-1].pokerusStage==0
          $Trainer.party[idxParty-1].givePokerus(strain) if rand(3)==0   # 33%
        end
        if idxParty<$Trainer.party.length-1 && $Trainer.party[idxParty+1].pokerusStage==0
          $Trainer.party[idxParty+1].givePokerus(strain) if rand(3)==0   # 33%
        end
      end
    end
    # Clean up battle stuff
    @scene.pbEndBattle(@decision)
    @battlers.each do |b|
      next if !b
      pbCancelChoice(b.index)   # Restore unused items to Bag
      BattleHandlers.triggerAbilityOnSwitchOut(b.ability,b,true) if b.abilityActive?
    end
    pbParty(0).each_with_index do |pkmn,i|
      next if !pkmn
      @peer.pbOnLeavingBattle(self,pkmn,@usedInBattle[0][i],true)   # Reset form
      pkmn.item = @initialItems[0][i]
    end
    return @decision
  end

  #=================
  
  end
  