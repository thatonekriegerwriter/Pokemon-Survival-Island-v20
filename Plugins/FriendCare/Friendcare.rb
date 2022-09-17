#===============================================================================
#  FriendCare System (MS) version 1.0.0
#    by realAfonso
# ----------------
#  This is a system developed by me, similar to DayCare but with 
#  some guidelines. The original DayCare of Pokémon Essentials 
#  is limited, meaning you can only have one DayCare in your 
#  game, and this DayCare can only receive two Pokémon. 
#  The FriendCare is designed to be an alternative to DayCare.
#-------------------------------------------------------------------------------
#  The main differences between DayCare and FriendCare:
#  - FriendCare can receive as many Pokémon as you want;
#  - FriendCare does not need payment to return the Pokémon;
#  - FriendCare does not generate eggs;
#  - You can have as many FriendCares as you want;
#===============================================================================

#-------------------------------------------------------------------------------
#  Important Gobal Variables
#-------------------------------------------------------------------------------
$FriendCare = [] if !$FriendCare
$FCPokemon = nil if !$FCPokemon
$SlotCount = 0 if !$SlotCount

#-------------------------------------------------------------------------------
#  Return the number of Slots in all FriendCares
#-------------------------------------------------------------------------------
def muFriendCareSlots()
  ret=0
  for slot in $FriendCare
    ret+=1
  end
  return ret
end

#-------------------------------------------------------------------------------
#  Return the number of Deposited Pokémons in a FriendCare
#-------------------------------------------------------------------------------
def muFriendCareDeposited(friend)
  ret=0
  for slot in $FriendCare
    ret+=1 if slot != nil && slot.friend == friend
  end
  return ret
end

#-------------------------------------------------------------------------------
#  Deposit a Pokémon in a slot of FriendCare Variable
#-------------------------------------------------------------------------------
def muFriendCareDeposit(index,friend)
  $FCPokemon = MultipleFriendCare.new
  $FCPokemon.pokemon=$Trainer.party[index]
  $FCPokemon.level=$Trainer.party[index].level
  $FCPokemon.friend=friend
  $FCPokemon.slot=$SlotCount
  $FCPokemon.pokemon.heal
  $Trainer.party[index]=nil
  $Trainer.party.compact!
  $FriendCare[$SlotCount] = $FCPokemon
  $SlotCount+=1
end

#-------------------------------------------------------------------------------
#  Withdraw a Pokémon from a slot of FriendCare Variable
#-------------------------------------------------------------------------------
def muFriendCareWithdraw(slot)
  if !$FriendCare[slot]
    raise _INTL("There's no Pokémon here...")
  elsif $Trainer.party.length>=6
    raise _INTL("Can't store the Pokémon...")
  else
    $Trainer.party[$Trainer.party.length]=$FriendCare[slot].pokemon
    $FriendCare.delete_at(slot)
  end  
end

#-------------------------------------------------------------------------------
#  Show chooses to the trainer
#-------------------------------------------------------------------------------
def muFriendCareChoose(text,friend)
  choices=[]
  results=[]
  count=0
  for slot in $FriendCare
    if(slot != nil && slot.friend == friend)
      pokemon=slot.pokemon
      if pokemon.isMale?
        choices.push(_ISPRINTF("{1:s} (♂, Lv{2:d})",pokemon.name,pokemon.level))
      elsif pokemon.isFemale?
        choices.push(_ISPRINTF("{1:s} (♀, Lv{2:d})",pokemon.name,pokemon.level))
      else
        choices.push(_ISPRINTF("{1:s} (Lv{2:d})",pokemon.name,pokemon.level))
      end
      results[count]=slot.slot
      count+=1
    end
  end
  choices.push(_INTL("CANCEL"))
  command=Kernel.pbMessage(text,choices,choices.length)
  muFriendCareWithdraw(results[command]) if command != count
  return true if command != count
  return false if command == count
end

#-------------------------------------------------------------------------------
#  Add EXP to the Pokémons in FriendCares
#-------------------------------------------------------------------------------
Events.onStepTaken+=proc {|sender,e|
   next if !$Trainer
   for slot in $FriendCare
     if(slot != nil)
       pkmn=slot.pokemon
       next if !pkmn
       maxexp=pkmn.growth_rate.maximum_exp
    next if pkmn.exp>=maxexp
    oldlevel = pkmn.level
    pkmn.exp += 1   # Gain Exp
    next if pkmn.level==oldlevel
    pkmn.calc_stats
    movelist = pkmn.getMoveList
    for i in movelist
      pkmn.learn_move(i[1]) if i[0]==pkmn.level   # Learned a new move
       end
       end
   end
}