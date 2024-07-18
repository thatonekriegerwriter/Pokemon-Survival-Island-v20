


# The Global Switch used to easily disable this system (i.e. like in Events).
#  *NOTE: Make sure this switch is not used by anything else!
SWITCH_DISABLE_BATTLEWORN = -1

#------#
# Whether an opponent's Pokemon has a chance to have missing HP.
ENABLE_OPPONENT_HPLOSS  =  true   #Default: true
# The chance for an opponent Pokemon to have missing HP.
CHANCE_OPPONENT_HPLOSS  =  5     #Default: 30
# Maximum percentage of HP that can be missing.
MAX_OPPONENT_HPLOSS     =  20     #Default: 25
# Minimum percentage of HP that can be missing.
MIN_OPPONENT_HPLOSS     =  10     #Default: 10

#------#
# Whether an opponent's Pokemon has a chance to have a Status Ailment.
ENABLE_OPPONENT_STATUS  =  true   #Default: true
# The chance for an opponent Pokemon to have a Status Ailment.
CHANCE_OPPONENT_STATUS  =  5     #Default: 15



#==============================================================================#
#//////////////////////////////////////////////////////////////////////////////#
#==============================================================================#


EventHandlers.add(:on_wild_pokemon_created, :make_worn,
  proc { |pkmn|
     pbBattlewornOpponents(pkmn)
  }
)



def pbBattlewornOpponents(opponent)
  #Run through each module, starting with fainting.
  pbOpponentsPriorHPLoss(opponent)
  pbOpponentsPriorStatus(opponent)
  opponent.calc_stats
end


def pbOpponentsPriorHPLoss(opponent)
  if ENABLE_OPPONENT_HPLOSS && opponent.hp>0 && !opponent.egg?
    case rand(100)
    when 0..CHANCE_OPPONENT_HPLOSS
      #Convert the percentage into a float that can be multiplied by the HP value.
      hpRandomPercent = rand(MAX_OPPONENT_HPLOSS.to_f - MIN_OPPONENT_HPLOSS.to_f)
      hpDamagePercent = MAX_OPPONENT_HPLOSS.to_f - hpRandomPercent.to_f
      #Decrease the opponent Pokemon's HP by a random amount.
      opponent.hp = opponent.totalhp - opponent.hp*(hpDamagePercent/100)
      opponent.hp = opponent.hp.ceil
    end
  end
end


def pbOpponentsPriorStatus(opponent)
  if ENABLE_OPPONENT_STATUS && !$game_switches[SWITCH_DISABLE_BATTLEWORN] && opponent.hp>0 && !opponent.egg?
	 loops = 0
    case rand(100)
    when 0..CHANCE_OPPONENT_STATUS
      loop do
	  
	    loops += 1
        case rand(5)
        when 1  #Sleeping
          if !opponent.hasAbility?(:VITALSPIRIT) &&
                     !opponent.hasAbility?(:INSOMNIA) &&
                     !opponent.hasAbility?(:SWEETVEIL) &&
                    (!opponent.hasAbility?(:FLOWERVEIL) && !opponent.hasType?(:GRASS)) &&
                    (!opponent.hasAbility?(:LEAFGUARD) && ($game_screen.weather_type!=:Sun)) &&
                    (!opponent.hasAbility?(:SHIELDSDOWN) && opponent.hp!=opponent.hp>(opponent.totalhp/2).floor)
            opponent.status=:SLEEP
            break
          end
        when 2  #Poisoned
          if !opponent.hasType?(:POISON) &&
                     !opponent.hasType?(:STEEL) &&
                     !opponent.hasAbility?(:IMMUNITY) &&
                    (!opponent.hasAbility?(:FLOWERVEIL) && !opponent.hasType?(:GRASS)) &&
                    (!opponent.hasAbility?(:LEAFGUARD) && ($game_screen.weather_type!=:Sun)) &&
                    (!opponent.hasAbility?(:SHIELDSDOWN) && opponent.hp!=opponent.hp>(opponent.totalhp/2).floor)
            opponent.status=:POISON
            break
          end
        when 3  #Burned
          if !opponent.hasType?(:FIRE) &&
                     !opponent.hasAbility?(:WATERVEIL) &&
                    (!opponent.hasAbility?(:FLOWERVEIL) && !opponent.hasType?(:GRASS)) &&
                    (!opponent.hasAbility?(:LEAFGUARD) && ($game_screen.weather_type!=:Sun)) &&
                    (!opponent.hasAbility?(:SHIELDSDOWN) && opponent.hp!=opponent.hp>(opponent.totalhp/2).floor)
            opponent.status=:BURN
            break
          end
        when 4  #Paralysed
            if !opponent.hasType?(:ELECTRIC) &&
                     !opponent.hasAbility?(:LIMBER) &&
                    (!opponent.hasAbility?(:FLOWERVEIL) && !opponent.hasType?(:GRASS)) &&
                    (!opponent.hasAbility?(:LEAFGUARD) && ($game_screen.weather_type!=:Sun)) &&
                    (!opponent.hasAbility?(:SHIELDSDOWN) && opponent.hp!=opponent.hp>(opponent.totalhp/2).floor)
              opponent.status=:PARALYSIS
              break
            end
        when 5  #Frozen
          if !opponent.hasType?(:ICE) &&
                    !opponent.hasAbility?(:MAGMAARMOR) &&
                    (!opponent.hasAbility?(:FLOWERVEIL) && !opponent.hasType?(:GRASS)) &&
                    (!opponent.hasAbility?(:LEAFGUARD) && ($game_screen.weather_type!=:Sun)) &&
                    (!opponent.hasAbility?(:SHIELDSDOWN) && opponent.hp!=opponent.hp>(opponent.totalhp/2).floor)
            opponent.status=:FROZEN
            break
          end
        end



     break if loops>5
      end
    end
  end
end




























