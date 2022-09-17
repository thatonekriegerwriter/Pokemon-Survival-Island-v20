module GameData
  class Item
  
    def is_rein_stone?; return has_flag?("ReincarnationStone"); end
    def is_reinboon?;            return has_flag?("ReincarnationBoon"); end
    def is_reinbane?;            return has_flag?("ReincarnationBane"); end
  
  
end
end

class Reincarnation


	def self.reincarnation_nature(pkmn, boon, bane)
	  chance2 = 0
	  reincarnatornature = 0
	  chance2 = rand(5)
	  if boon ==  ReincarnationConfig::BOON_NEUTRAL || bane == ReincarnationConfig::BOON_NEUTRAL || (boon == bane)
	    if chance2 == 0
	      reincarnatornature = :HARDY
	    elsif chance2 == 1
	      reincarnatornature = :DOCILE
	    elsif chance2 == 2
	      reincarnatornature = :SERIOUS
	    elsif chance2 == 3
	      reincarnatornature = :BASHFUL
	    elsif chance2 == 4
	      reincarnatornature = :QUIRKY
	    end
	  elsif boon == ReincarnationConfig::BOON_ATK 
	    if bane == ReincarnationConfig::BANE_DEF
	      reincarnatornature = :LONELY
		elsif bane == ReincarnationConfig::BANE_SPEED
	      reincarnatornature = :BRAVE
		elsif bane == ReincarnationConfig::BANE_SATK
	      reincarnatornature = :ADAMANT
		elsif bane == ReincarnationConfig::BANE_SDEF
	      reincarnatornature = :NAUGHTY
		end
	  elsif boon == ReincarnationConfig::BOON_DEF 
	    if bane == ReincarnationConfig::BANE_ATK
	      reincarnatornature = :BOLD
		elsif bane == ReincarnationConfig::BANE_SPEED
	      reincarnatornature = :RELAXED
		elsif bane == ReincarnationConfig::BANE_SATK
	      reincarnatornature = :IMPISH
		elsif bane == ReincarnationConfig::BANE_SDEF
	      reincarnatornature = :LAX
		end
	  elsif boon == ReincarnationConfig::BOON_SPEED
	    if bane == ReincarnationConfig::BANE_ATK
	      reincarnatornature = :TIMID
		elsif bane == ReincarnationConfig::BANE_DEF
	      reincarnatornature = :HASTY
		elsif bane == ReincarnationConfig::BANE_SATK
	      reincarnatornature = :JOLLY
		elsif bane == ReincarnationConfig::BANE_SDEF
	      reincarnatornature = :NAIVE
		end
	  elsif boon == ReincarnationConfig::BOON_SATK
	    if bane == ReincarnationConfig::BANE_ATK
	      reincarnatornature = :MODEST
		elsif bane == ReincarnationConfig::BANE_SPEED
	      reincarnatornature = :QUIET
		elsif bane == ReincarnationConfig::BANE_DEF
	      reincarnatornature = :MILD
		elsif bane == ReincarnationConfig::BANE_SDEF
	      reincarnatornature = :RASH
		end
	  elsif boon == ReincarnationConfig::BOON_SDEF
	    if bane == ReincarnationConfig::BANE_ATK
	      reincarnatornature = :CALM
		elsif bane == ReincarnationConfig::BANE_SPEED
	      reincarnatornature = :SASSY
		elsif bane == ReincarnationConfig::BANE_SATK
	      reincarnatornature = :CAREFUL
		elsif bane == ReincarnationConfig::BANE_DEF
	      reincarnatornature = :GENTLE
		end
	  end
      pkmn.nature = reincarnatornature
    end

    def self.begin_reincarnation(pkmn, donator1, donator2, ivitem, boon, bane)
	   if ReincarnationConfig::NUZLOCKE_REINCARNATION == true && defined?(Nuzlocke.definedrules?)
       pbMessage(_INTL("{1} is not dead, reincarnation cannot occur.", pkmn)) 
	   return false
	   end
	   if ReincarnationConfig::REINCARNATION_HAS_COST == true && $bag.quantity(ReincarnationConfig::COST_ITEM) < ReincarnationConfig::COST_AMOUNT
       pbMessage(_INTL("You do not have enough {1}, you need at least {2}.", ReincarnationConfig::COST_ITEM,ReincarnationConfig::COST_AMOUNT)) 
	   return false
	   end
	   
  ivs = {}
  GameData::Stat.each_main { |s| ivs[s.id] = rand(32) }
  ivinherit = []
	  magstoninher = 0
	  chance = rand(6)
	  if chance = 0
	     magstoninher = :HP
	  elsif chance = 1
	     magstoninher = :ATTACK
	  elsif chance = 2
	     magstoninher = :DEFENSE
	  elsif chance = 3
	     magstoninher = :SPECIAL_ATTACK
	  elsif chance = 4
	     magstoninher = :SPECIAL_DEFENSE
	  elsif chance = 5
	     magstoninher = :SPEED
	  end
  for i in 0...2
    parent = [donator1,donator2][i]
    ivinherit[i] = :HP if ivitem == (ReincarnationConfig::MAGIC_STONE_HP)
    ivinherit[i] = :ATTACK if ivitem == (ReincarnationConfig::MAGIC_STONE_ATK)
    ivinherit[i] = :DEFENSE if ivitem == (ReincarnationConfig::MAGIC_STONE_DEF)
    ivinherit[i] = :SPECIAL_ATTACK if ivitem == (ReincarnationConfig::MAGIC_STONE_SATK)
    ivinherit[i] = :SPECIAL_DEFENSE if ivitem == (ReincarnationConfig::MAGIC_STONE_SDEF)
    ivinherit[i] = :SPEED if ivitem == (ReincarnationConfig::MAGIC_STONE_INHERIT)
    ivinherit[i] = magstoninher if ivitem == (ReincarnationConfig::MAGIC_STONE_INHERIT)
  end
  num = 0
  r = rand(2)
  2.times do
    if ivinherit[r]!=nil
      ivs[ivinherit[r]] = pkmn.iv[ivinherit[r]]
      num += 1
      break
    end
    r = (r+1)%2
  end
  limit = ivitem == (ReincarnationConfig::MAGIC_STONE_INHERIT) ? 5 : 3
  loop do
    freestats = []
    GameData::Stat.each_main { |s| freestats.push(s.id) if !ivinherit.include?(s.id) }
    break if freestats.length==0
    r = freestats[rand(freestats.length)]
    parent = [donator1,donator2][rand(2)]
    ivs[r] = parent.iv[r]
    ivinherit.push(r)
    num += 1
    break if num>=limit
  end
	   reincarnation_nature(pkmn, boon, bane)
	   if ReincarnationConfig::NUZLOCKE_REINCARNATION == true && defined?(Nuzlocke.definedrules?) && pkmn.permaFaint == true
	   pkmn.permaFaint = false
	   end
	   if ReincarnationConfig::TAKE_FROM_BAG == "STONES"
	     $bag.remove(ivitem)
	   elsif ReincarnationConfig::TAKE_FROM_BAG == "BOON/BANE"
	     $bag.remove(boon)
	     $bag.remove(bane)
	   elsif ReincarnationConfig::TAKE_FROM_BAG == "BOTH"
	     $bag.remove(boon)
	     $bag.remove(bane)
	     $bag.remove(ivitem)
	   end
	   if ReincarnationConfig::REINCARNATION_HAS_COST == true
	     $bag.remove(ReincarnationConfig::COST_ITEM,ReincarnationConfig::COST_AMOUNT)
	   end
       if ReincarnationConfig::SET_TO_LEVEL !=nil
	   pkmn.level = ReincarnationConfig::SET_TO_LEVEL
	   pkmn.iv = ivs
	   end
	   pkmn.calc_stats
	   return pkmn
	end
end