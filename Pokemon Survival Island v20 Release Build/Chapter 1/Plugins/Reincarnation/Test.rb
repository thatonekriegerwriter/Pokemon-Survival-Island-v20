
class Reincarnation
  module Reincarnator
    module_function

    def select_reincaration(pkmn)
      pkmn.happiness      = 120
      return pkmn
    end

    def inherit_IVs(pkmn, mother, father)
      # Get all stats
      stats = []
      GameData::Stat.each_main { |s| stats.push(s) }
      # Get the number of stats to inherit
      inherit_count = 3
 #     if Settings::MECHANICS_GENERATION >= 6
 #       inherit_count = 5 if mother.hasItem?(:DESTINYKNOT) || father.hasItem?(:DESTINYKNOT)
 #     end
      # Inherit IV because of Power items (if both parents have a Power item,
      # then only a random one of them is inherited)
      power_items = [
        [:POWERWEIGHT, :HP],
        [:POWERBRACER, :ATTACK],
        [:POWERBELT,   :DEFENSE],
        [:POWERLENS,   :SPECIAL_ATTACK],
        [:POWERBAND,   :SPECIAL_DEFENSE],
        [:POWERANKLET, :SPEED]
      ]
      power_stats = []
      [mother, father].each do |parent|
        power_items.each do |item|
          next if !parent.hasItem?(item[0])
          power_stats.push(item[1], parent.iv[item[1]])
          break
        end
      end
      if power_stats.length > 0
        power_stat = power_stats.sample
        egg.iv[power_stat[0]] = power_stat[1]
        stats.delete(power_stat[0])   # Don't try to inherit this stat's IV again
        inherit_count -= 1
      end
      # Inherit the rest of the IVs
      chosen_stats = stats.sample(inherit_count)
      chosen_stats.each { |stat| egg.iv[stat] = [mother, father].sample.iv[stat] }
    end


end
end