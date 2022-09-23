def pbTrainerSteal(vari)
 vari = GameData::TrainerType.get(vari).name
 if vari == "Lass" || vari == "Youngster" || vari == "Twins"
  $player.rocketstealing = 1 
else 
  $player.rocketstealing = 0 
  end
  end

    
module PokeBattle_BattleCommon
 def pbThrowPokeBall(idxBattler,ball,catch_rate=nil,showPlayer=false)
    # Determine which Pokémon you're throwing the Poké Ball at
    battler = nil
    if opposes?(idxBattler)
      battler = @battlers[idxBattler]
    else
      battler = @battlers[idxBattler].pbDirectOpposing(true)
    end
    if battler.fainted?
      battler.eachAlly do |b|
        battler = b
        break
      end
    end
    # Messages
    itemName = GameData::Item.get(ball).name
    if battler.fainted?
      if itemName.starts_with_vowel?
        pbDisplay(_INTL("{1} threw an {2}!",pbPlayer.name,itemName))
      else
        pbDisplay(_INTL("{1} threw a {2}!",pbPlayer.name,itemName))
      end
      pbDisplay(_INTL("But there was no target..."))
      return
    end
    if itemName.starts_with_vowel?
      pbDisplayBrief(_INTL("{1} threw an {2}!",pbPlayer.name,itemName))
    else
      pbDisplayBrief(_INTL("{1} threw a {2}!",pbPlayer.name,itemName))
    end
	if $player.rocketbadges == 1 && $player.rocketstealing == 1 && $player.rocketstealcount == 0
         pbDisplay(_INTL("You are intimidating enough to Catch it!"))
		 $player.rocketstealcount = 1
	else
	if $player.rocketstealcount == 1
         pbDisplay(_INTL("You already caught a POKeMON this fight!"))
      return
	  end
    # Animation of opposing trainer blocking Poké Balls (unless it's a Snag Ball
    # at a Shadow Pokémon)
    if trainerBattle? && !(GameData::Item.get(ball).is_snag_ball? && battler.shadowPokemon?)
      @scene.pbThrowAndDeflect(ball,1)
      pbDisplay(_INTL("The Trainer blocked your Poké Ball! Don't be a thief!"))
      return
    end
    #EDIT
    if $game_switches[487] == true
     if trainerBattle? && (GameData::Item.get(ball).is_snag_ball? && battler.shadowPokemon?)
       @scene.pbThrowAndDeflect(ball,1)
       pbDisplay(_INTL("As if I would let you snag my Shadow Pokemon!"))
       return
     else
     @scene.pbThrowAndDeflect(ball,1)
      pbDisplay(_INTL("Your trainer isn't around to catch it!"))
      return
     end
    end
end
    #EDIT END 487
    #---------------------------------------------------------------------------
    # ZUD - Prevents capturing Raid Pokemon until defeated.
    #---------------------------------------------------------------------------
    return if defined?(Settings::ZUD_COMPAT) && _ZUD_RaidCaptureFail(battler,ball)
    #---------------------------------------------------------------------------
    # Calculate the number of shakes (4=capture)
    pkmn = battler.pokemon
    @criticalCapture = false
    numShakes = pbCaptureCalc(pkmn,battler,catch_rate,ball)
    PBDebug.log("[Threw Poké Ball] #{itemName}, #{numShakes} shakes (4=capture)")
    # Animation of Ball throw, absorb, shake and capture/burst out
    @scene.pbThrow(ball,numShakes,@criticalCapture,battler.index,showPlayer)
    # Ball Fetch
    if !pbInSafari?
    if numShakes != 4 && ![:SAFARIBALL,:MASTERBALL].include?(ball)
      eachBattler do |b|
        if b.hasActiveAbility?(:BALLFETCH) && !b.item
          b.effects[PBEffects::BallFetch] = ball
          break
        end
      end
    end
    end
    # Outcome message
    case numShakes
    when 0
      pbDisplay(_INTL("It's like the ball didn't even exist!"))
      BallHandlers.onFailCatch(ball,self,battler)
    when 1
      pbDisplay(_INTL("The Pokemon broke free easily!"))
      BallHandlers.onFailCatch(ball,self,battler)
    when 2
      pbDisplay(_INTL("Aargh! Almost had it!"))
      BallHandlers.onFailCatch(ball,self,battler)
    when 3
      pbDisplay(_INTL("Gah! It broke out, and it's not happy!"))
      BallHandlers.onFailCatch(ball,self,battler)
    when 4
      pbDisplayBrief(_INTL("Whew! {1} was caught!",pkmn.name))
      @scene.pbThrowSuccess   # Play capture success jingle
      pbRemoveFromParty(battler.index,battler.pokemonIndex)
      # Gain Exp
      if Settings::GAIN_EXP_FOR_CAPTURE
        battler.captured = true
        pbGainExp
        battler.captured = false
      end
      battler.pbReset
      if pbAllFainted?(battler.index)
        @decision = (trainerBattle?) ? 1 : 4   # Battle ended by win/capture
      end
      # Modify the Pokémon's properties because of the capture
      if GameData::Item.get(ball).is_snag_ball?
        pkmn.owner = Pokemon::Owner.new_from_trainer(pbPlayer)
      end
      BallHandlers.onCatch(ball,self,pkmn)
      pkmn.poke_ball = ball
      pkmn.makeUnmega if pkmn.mega?
      pkmn.makeUnprimal
      pkmn.update_shadow_moves if pkmn.shadowPokemon?
      pkmn.record_first_moves
      # Reset form
      pkmn.forced_form = nil if MultipleForms.hasFunction?(pkmn.species,"getForm")
      @peer.pbOnLeavingBattle(self,pkmn,true,true)
      # Make the Poké Ball and data box disappear
      @scene.pbHideCaptureBall(idxBattler)
      # Save the Pokémon for storage at the end of battle
      @caughtPokemon.push(pkmn)
    end
  end
end


def pbShadowMachine
  pbChooseNonEggPokemon(1,3)
 species = GameData::Species.get($game_variables[1]).id
  evos = GameData::Species.get(species).get_evolutions
  if evos.length > 0
     
  end
end
  
  