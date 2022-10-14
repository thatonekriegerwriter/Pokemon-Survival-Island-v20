module GameData
  class Item
	def is_rein_stone?
	  return has_flag?("ReincarnationStone")
	end
    def is_reinboon?
	  return has_flag?("ReincarnationBoon")
	end
    def is_reinbane?
	  return has_flag?("ReincarnationBane")
	end
  end
end

class Reincarnation
    def self.begin_reincarnation(pkmn, donator1 = nil, donator2 = nil, ivitem, boon, bane,oldhpiv,oldatkiv,olddefiv,oldsatkiv,oldsdefiv,oldspdiv)
	   if ReincarnationConfig::NUZLOCKE_REINCARNATION == true && defined?(Nuzlocke.definedrules?)
       pbMessage(_INTL("{1} is not dead, reincarnation cannot occur.", pkmn.name)) 
	   return false
	   end
	   if ReincarnationConfig::REINCARNATION_HAS_COST == true && $bag.quantity(ReincarnationConfig::COST_ITEM) < ReincarnationConfig::COST_AMOUNT
       pbMessage(_INTL("You do not have enough {1}, you need at least {2}.", ReincarnationConfig::COST_ITEM,ReincarnationConfig::COST_AMOUNT)) 
	   return false
	   end
	#Randomize Stats
  ivs = {}
  GameData::Stat.each_main { |s| ivs[s.id] = rand(Pokemon::IV_STAT_LIMIT + 1) }
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
	  #Parents
	  
   if donator1==0
  for i in 0...1
    parent = [donator2][i]
    ivinherit[i] = magstoninher if ivitem == (ReincarnationConfig::MAGIC_STONE_INHERIT)
  end
   
   elsif donator2==0
  for i in 0...1
    parent = [donator1][i]
    ivinherit[i] = magstoninher if ivitem == (ReincarnationConfig::MAGIC_STONE_INHERIT)
  end
   elsif donator2.nil? && donator1.nil?
   
   else
  for i in 0...2
    parent = [donator1,donator2][i]
    ivinherit[i] = magstoninher if ivitem == (ReincarnationConfig::MAGIC_STONE_INHERIT)
  end
  end
     #
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
  if donator2==0 || donator1==0
  if limit == 3
   limit = 2
  elsif limit == 5
   limit = 4
  end
  end
  loop do
    freestats = []
    GameData::Stat.each_main { |s| freestats.push(s.id) if !ivinherit.include?(s.id) }
          pbMessage(_INTL("{1}",freestats.length))
    break if freestats.length==0
    r = freestats[rand(freestats.length)]
	if donator1==0
    parent = [donator2][rand(1)]
    ivs[r] = parent.iv[r]
          pbMessage(_INTL("{1}",ivs[r]))
    ivinherit.push(r)
	elsif donator2==0
    parent = [donator1][rand(1)]
    ivs[r] = parent.iv[r]
          pbMessage(_INTL("{1}",ivs[r]))
    ivinherit.push(r)
	elsif donator1==0 && donator2==0
	else
    parent = [donator1,donator2][rand(2)]
    ivs[r] = parent.iv[r]
    ivinherit.push(r)
	end
    num += 1
    break if num>=limit
	end

		  chance2 = 0
	  pkmn = pkmn
	  reincarnatornature = 0
	  chance2 = rand(5)
	  chance3 = rand(4)
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
		else 
	    if chance3 == 0
	      reincarnatornature = :LONELY
	    elsif chance3 == 1
	      reincarnatornature = :BRAVE
	    elsif chance3 == 2
	      reincarnatornature = :ADAMANT
	    elsif chance3 == 3
	      reincarnatornature = :NAUGHTY
		end
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
		else 
	    if chance3 == 0
	      reincarnatornature = :BOLD
	    elsif chance3 == 1
	      reincarnatornature = :RELAXED
	    elsif chance3 == 2
	      reincarnatornature = :IMPISH
	    elsif chance3 == 3
	      reincarnatornature = :LAX
		end
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
		else 
	    if chance3 == 0
	      reincarnatornature = :TIMID
	    elsif chance3 == 1
	      reincarnatornature = :HASTY
	    elsif chance3 == 2
	      reincarnatornature = :JOLLY
	    elsif chance3 == 3
	      reincarnatornature = :NAIVE
		end
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
		else 
	    if chance3 == 0
	      reincarnatornature = :RASH
	    elsif chance3 == 1
	      reincarnatornature = :MILD
	    elsif chance3 == 2
	      reincarnatornature = :QUIET
	    elsif chance3 == 3
	      reincarnatornature = :MODEST
		end
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
		else 
	    if chance3 == 0
	      reincarnatornature = :CALM
	    elsif chance3 == 1
	      reincarnatornature = :SASSY
	    elsif chance3 == 2
	      reincarnatornature = :CAREFUL
	    elsif chance3 == 3
	      reincarnatornature = :GENTLE
		end
		end
	  
	  elsif bane == ReincarnationConfig::BANE_ATK
	     if boon == ReincarnationConfig::BOON_DEF 
	      reincarnatornature = :BOLD
	     elsif boon == ReincarnationConfig::BOON_SATK
	      reincarnatornature = :MODEST
	     elsif boon == ReincarnationConfig::BOON_SDEF
	      reincarnatornature = :CALM
	     elsif boon == ReincarnationConfig::BOON_SPEED
	      reincarnatornature = :TIMID
		else 
	    if chance3 == 0
	      reincarnatornature = :BOLD
	    elsif chance3 == 1
	      reincarnatornature = :MODEST
	    elsif chance3 == 2
	      reincarnatornature = :CALM
	    elsif chance3 == 3
	      reincarnatornature = :TIMID
		end
		 end
	  elsif bane == ReincarnationConfig::BANE_DEF
	     if boon == ReincarnationConfig::BOON_ATK 
	      reincarnatornature = :LONELY
	     elsif boon == ReincarnationConfig::BOON_SATK
	      reincarnatornature = :MILD
	     elsif boon == ReincarnationConfig::BOON_SDEF
	      reincarnatornature = :GENTLE
	     elsif boon == ReincarnationConfig::BOON_SPEED
	      reincarnatornature = :HASTY
		 else
	    if chance3 == 0
	      reincarnatornature = :LONELY
	    elsif chance3 == 1
	      reincarnatornature = :MILD
	    elsif chance3 == 2
	      reincarnatornature = :GENTLE
	    elsif chance3 == 3
	      reincarnatornature = :HASTY
		end
		 end
	  elsif bane == ReincarnationConfig::BANE_SATK
	     if boon == ReincarnationConfig::BOON_ATK 
	      reincarnatornature = :ADAMANT
	     elsif boon == ReincarnationConfig::BOON_DEF 
	      reincarnatornature = :IMPISH
	     elsif boon == ReincarnationConfig::BOON_SDEF
	      reincarnatornature = :CALM
	     elsif boon == ReincarnationConfig::BOON_SPEED
	      reincarnatornature = :JOLLY
		 else
	    if chance3 == 0
	      reincarnatornature = :ADAMANT
	    elsif chance3 == 1
	      reincarnatornature = :IMPISH
	    elsif chance3 == 2
	      reincarnatornature = :CALM
	    elsif chance3 == 3
	      reincarnatornature = :JOLLY
		end
		 end
	  elsif bane == ReincarnationConfig::BANE_SDEF
	     if boon == ReincarnationConfig::BOON_ATK 
	      reincarnatornature = :NAUGHTY
	     elsif boon == ReincarnationConfig::BOON_DEF 
	      reincarnatornature = :LAX
	     elsif boon == ReincarnationConfig::BOON_SATK
	      reincarnatornature = :RASH
	     elsif boon == ReincarnationConfig::BOON_SPEED
	      reincarnatornature = :NAIVE
		 else
	    if chance3 == 0
	      reincarnatornature = :NAUGHTY
	    elsif chance3 == 1
	      reincarnatornature = :LAX
	    elsif chance3 == 2
	      reincarnatornature = :RASH
	    elsif chance3 == 3
	      reincarnatornature = :NAIVE
		end
		 end
	  elsif bane == ReincarnationConfig::BANE_SPEED
	     if boon == ReincarnationConfig::BOON_ATK 
	      reincarnatornature = :BRAVE
	     elsif boon == ReincarnationConfig::BOON_DEF 
	      reincarnatornature = :RELAXED
	     elsif boon == ReincarnationConfig::BOON_SATK
	      reincarnatornature = :QUIET
	     elsif boon == ReincarnationConfig::BOON_SDEF
	      reincarnatornature = :SASSY
		 else
	    if chance3 == 0
	      reincarnatornature = :BRAVE
	    elsif chance3 == 1
	      reincarnatornature = :RELAXED
	    elsif chance3 == 2
	      reincarnatornature = :QUIET
	    elsif chance3 == 3
	      reincarnatornature = :SASSY
		end
		 end
	  end
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
	   end
       if ReincarnationConfig::REVERT_EVOLUTION ==true
	   pkmn.species = pkmn.species_data.get_baby_species
	   end
       if ReincarnationConfig::REVERT_MOVES ==true
	   pkmn.reset_moves
	   end
       pkmn.iv = ivs
	   pkmn.nature = reincarnatornature
	   if ivitem == (ReincarnationConfig::MAGIC_STONE_HP)
	   pkmn.iv[:HP] = oldhpiv
	   elsif ivitem == (ReincarnationConfig::MAGIC_STONE_ATK)
         pkmn.iv[:ATTACK] = oldatkiv
	   elsif ivitem == (ReincarnationConfig::MAGIC_STONE_DEF)
          pkmn.iv[:DEFENSE] = olddefiv
	   elsif ivitem == (ReincarnationConfig::MAGIC_STONE_SATK)
         pkmn.iv[:SPECIAL_ATTACK] = oldsatkiv
	   elsif ivitem == (ReincarnationConfig::MAGIC_STONE_SDEF)
         pkmn.iv[:SPECIAL_DEFENSE] = oldsdefiv
	   elsif ivitem == (ReincarnationConfig::MAGIC_STONE_SPEED)
         pkmn.iv[:SPEED] = oldspdiv
	   end
	   pkmn.calc_stats
	   $game_variables[1] = 0
	   return pkmn
	end
end