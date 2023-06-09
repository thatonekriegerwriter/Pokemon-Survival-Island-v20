class Adventure 
	attr_accessor :party
	attr_accessor :items
	
	def initialize
		@items		= []
		@party      = []
		@steps		= 0
	end
	def newStep
		if @steps.nil?
			@steps = 0
		end
		@steps = @steps+1
		for egg in @party
			next if egg.steps_to_hatch <= 0
			egg.steps_to_hatch -= 1
			for i in @party
				next if [:FLAMEBODY, :MAGMAARMOR, :STEAMENGINE].include?(i.ability_id)
				egg.steps_to_hatch -= 1
				break
			end
			if egg.steps_to_hatch <= 0
				egg.steps_to_hatch = 0
				speciesname = egg.speciesName
				egg.name           = nil
				egg.owner          = Pokemon::Owner.new_from_trainer($player)
				egg.happiness      = 20
				egg.loyalty        = 20
                egg.lifespan = 50
                egg.age = 1
				egg.timeEggHatched = pbGetTimeNow
				egg.obtain_method  = 1   # hatched from egg
				egg.hatched_map    = $game_map.map_id
				$player.pokedex.register(egg)
				$player.pokedex.set_owned(egg.species)
				egg.record_first_moves
			end
		end
		if @steps >= PokeventureConfig::Updatesteps
			if able_pokemon_count>0
				pbAdventuringEvent
			end
			@steps=0
		end
	end
	def pbAdventuringEvent
		index = rand(@party.length)
		pkmn = @party[index]
		  if $PokemonSystem.survivalmode==0
  @party.each do |pkmn|
  if $game_switches[167]==false && pbIsWeekday(6) 
    $game_switches[167] == true
    if pkmn.lifespan == 0 
      pkmn.permadeath=true
      pkmn.hp = 0
	  return
    end
	pkmn.changeAge
	pkmn.changeLifespan("age",pkmn)
  elsif !pbIsWeekday(6)
    $game_switches[167] = false
  end
  end
end

		chances = rand(500)
		chances2 = rand(500)
		chances3 = rand(500)
		if pkmn.egg?
		elsif chances >375 && PokeventureConfig::CollectRandomItem   #FIND ITEM
			@items.append(pbGetItem)
		elsif chances<=17 && PokeventureConfig::ChanceToFindEggs   #FIND EGG
			encounter = $PokemonEncounters.choose_wild_pokemon(:AdventureEggs)
			encounter = [nil, nil] if encounter.nil?
			pbGenerateAdEgg(encounter[0])
		elsif chances<=45 && chances2<=250 && PokeventureConfig::ChanceToFindEggs   #FIND EGG
		encounter = $PokemonEncounters.choose_wild_pokemon(:Adventure)
		encounter = [nil, nil] if encounter.nil?
		if !encounter.nil? && !encounter[0].nil?
		poke = Pokemon.new(encounter[0],encounter[1])
		if pkmn.male?
		poke.makeFemale
		mother = poke
		father = pkmn
		elsif pkmn.female?
		poke.makeMale
		father = poke
		mother = pkmn
		end
		egg = EggGenerator.generate(mother, father)
		party[party.length] = egg
		end
		elsif chances<=1 #TEAM ROCKET GRUNT
		elsif chances<=1 #TRADING
		elsif chances<=1 #GAINEV
		elsif chances<=1 #GAINIV
		elsif chances2<=25 #HEAL
			pkmn.heal	 
		elsif chances3<=25 #HARD FIGHT
			if pkmn.hp==0
			else
			battle(pkmn,index,true)
			end
		elsif chances2<=23 && GameData::MapMetadata.get($game_map.map_id).outdoor_map && pkmn.happiness>90 && pkmn.loyalty<20 && !$player.party_full?
			pbMessage(_INTL("{1} came back! They missed you. They were clearly too good at hide and seek.", pkmn.name))
             $player.party[$player.party.length] = pkmn
			 remove_pokemon_at_index(index)
		elsif chances2<=76 && GameData::MapMetadata.get($game_map.map_id).outdoor_map  #YOU ENCOUNTERED YOUR POKEMON
			pbMessage(_INTL("Oh! You encountered {1}! Hello {1}!", pkmn.name))
			pkmn.loyalty+=10
			pkmn.happiness+=45
		elsif chances2<=10  #UHH
		    if pokemon.hue==0
            pokemon.hue = rand(360)
            pokemon.memento = :LOSTMARK
			end
		elsif chances3>250  #FIND/DIE TO FRIEND
			if pkmn.hp==0
			else
			battle(pkmn,index)
			end
		end	
		
	end
	def battle(battler,index,hard=false)
	    pkmn = battler
		encounter = $PokemonEncounters.choose_wild_pokemon(:Adventure)
		encounter = [nil, nil] if encounter.nil?
		if !encounter.nil? && !encounter[0].nil?
			partylevel = pkmn.level
			win = false
			if hard==true
			level = encounter[1]+rand(10)+5
			else 
			level =  encounter[1]
			end
			chance = encounter[1] - partylevel
			if partylevel > level && rand(5)==4
				win = true
			elsif 1 == rand(chance)
				win = true 
			    if hard==true
				pkmn.hp -= rand(pkmn.totalhp/4)+1
				else
				pkmn.hp -= rand(pkmn.totalhp/6)+1
			   end
				if pkmn.hp==0
				 if pkmn.item==:REVIVALHERB || pkmn.item==:MAXHONEY
			       pkmn.hp=pkmn.totalhp
				   pkmn.item = nil
				 else
				  win = false
				 end
				end
			else

			end
			if win==true
			    pkmn.food+=rand(20)+10
				pkmn.water+=rand(20)+10
				poke = Pokemon.new(encounter[0],encounter[1])
				if PokeventureConfig::FindFriends && 0 == rand(PokeventureConfig::ChanceToFindFriend-1) && !party_full? 
					poke.generateBrilliant if (PokeventureConfig::AreFoundFriendsBrilliant && defined?(poke.generateBrilliant))
					poke.name= nil
					poke.owner= Pokemon::Owner.new_from_trainer($player)
					if poke.loyalty.nil?
					    poke.loyalty = 70
					end
					poke.age = (rand(50)+1)
					poke.water = (rand(100)+1)
					poke.food = (rand(100)+1)
					poke.lifespan = 50
					if poke.age <= 10
					    poke.ev[:DEFENSE] = rand(40)+10
					    poke.ev[:SPECIAL_DEFENSE] = rand(40)+10
 					   poke.ev[:ATTACK] = rand(40)+10
 					   poke.ev[:SPECIAL_ATTACK] = rand(40)+10
					    poke.ev[:SPEED] = rand(40)+10
					    poke.ev[:HP] = rand(40)+10
					elsif poke.age <= 20 && poke.age > 10
					    poke.ev[:DEFENSE] = rand(80)+10
					    poke.ev[:SPECIAL_DEFENSE] = rand(80)+10
					    poke.ev[:ATTACK] = rand(80)+10
					    poke.ev[:SPECIAL_ATTACK] = rand(80)+10
					    poke.ev[:SPEED] = rand(80)+10
					    poke.ev[:HP] = rand(80)+10
					elsif poke.age <= 30 && poke.age > 20
					    poke.ev[:DEFENSE] = rand(120)+10
					    poke.ev[:SPECIAL_DEFENSE] = rand(120)+10
					    poke.ev[:ATTACK] = rand(120)+10
 					   poke.ev[:SPECIAL_ATTACK] = rand(120)+10
 					   poke.ev[:SPEED] = rand(120)+10
					    poke.ev[:HP] = rand(120)+10
					elsif poke.age <= 40 && poke.age > 30
 					   poke.ev[:DEFENSE] = rand(150)+10
  					  poke.ev[:SPECIAL_DEFENSE] = rand(150)+10
  					  poke.ev[:ATTACK] = rand(150)+10
  					  poke.ev[:SPECIAL_ATTACK] = rand(150)+10
  					  poke.ev[:SPEED] = rand(150)+10
  					  poke.ev[:HP] = rand(150)+10
					elsif poke.age > 40
  					  poke.ev[:DEFENSE] = rand(200)+10
  					  poke.ev[:SPECIAL_DEFENSE] = rand(200)+10
  					  poke.ev[:ATTACK] = rand(200)+10
  					  poke.ev[:SPECIAL_ATTACK] = rand(200)+10
  					  poke.ev[:SPEED] = rand(200)+10
  					  poke.ev[:HP] = rand(200)+10
					end
					poke.obtain_method= 0  
					poke.obtain_text= "Encountered on an adventure!"
					poke.timeReceived= pbGetTimeNow
					$player.pokedex.register(poke)
					$player.pokedex.set_owned(poke.species)
					@party.append(poke)
				end
				if PokeventureConfig::CollectItemsFromBattles && 0 ==rand(PokeventureConfig::ChanceToGetEnemyItem)
					drops = poke.wildHoldItems
					if !drops.compact.empty?
						@items.append(drops.compact.sample)
					end
				end
                if pkmn.able? && PokeventureConfig::GainExp
				  if hard==true
					pbGainAventureExp(pkmn,poke,1,true)
				  else
					pbGainAventureExp(pkmn,poke,1)
				  end
				end
			else
			   pkmn.changeHappiness("faint",pkmn)
			   pkmn.changeLoyalty("faint",pkmn)
			   chances = rand(256)
			   if pkmn.happiness < 30 && pkmn.loyalty<75 && chances<=170
				 remove_pokemon_at_index(index)
			   end
			   if pkmn.loyalty < 10 && chances<=270
				 remove_pokemon_at_index(index)
			   end
			   if pkmn.hp==0 && defined?(Nuzlocke.definedrules?)
			     if chances<=170
				 pkmn.permaFaint = true
				 else
				 remove_pokemon_at_index(index)
				 end
			   end
			   if chances>=200
			   @items.delete_at(rand(@items.length))
			   end

			end
		end
		@party.each do |pkmn|
			PokeventureConfig::pbAdventureAbilities(pkmn)
		end
	end











	def remove_pokemon_at_index(index)
		return false if index < 0 || index >= @party.length
		@party.delete_at(index)
		return true
	end
	def all_fainted?
		return able_pokemon_count == 0
	end
	def party_full?
		return @party.length >= Settings::MAX_PARTY_SIZE
	end
	def able_pokemon_count
		ret = 0
		@party.each { |p| ret += 1 if p && !p.egg? && !p.fainted? }
		return ret
	end



	def add_pokemon(pkmn)
		@party.append(pkmn)
		itemcollect
	end
	def itemcollect
		@party.each do |pkmn|
			if pkmn.hasItem?
				item = GameData::Item.get(pkmn.item)
				@items.append(item)
				pkmn.item = nil
			end
		end
	end
	def harvestItems
		@items.each { |x| Kernel.pbReceiveItem(x) if !x.nil?}
		@items = []
	end
	def harvestItemsSilent
		giveAdventureItemList(@items)
		@items = []
	end
	def sendEveryoneToBox
		success = true
		while success && !(@party.empty?)
			success = pbMovetoPC(0)
		end
		if success
			pbMessage(_INTL("All adventurers were send to the PC!"))
		end
	end
	def pbMovetoPC(pos)
		if pbBoxesFull?
			pbMessage(_INTL("The Boxes on your PC are full!"))
			return false
		else
			$PokemonStorage.pbStoreCaught(@party[pos].dup)
			remove_pokemon_at_index(pos)
			return true
		end
	end
	def heal_party
		@party.each { |pkmn| pkmn.heal }
	end
	def pbPlayer
		return $player 
	end
	def pbGainAventureExp(pkmn,defeatedBattler,numPartic,double=false)
		growth_rate = pkmn.growth_rate
		if pkmn.exp>=growth_rate.maximum_exp
			pkmn.calc_stats   # To ensure new EVs still have an effect
			return
		end
		isPartic    = true
		level = defeatedBattler.level
    # Main Exp calculation
    exp = 0
    a = level*defeatedBattler.base_exp
    if isPartic   # Participated in battle, no Exp Shares held by anyone
      exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? numPartic : 1)
    end
    return if exp<=0
    # Scale the gained Exp based on the gainer's level (or not)
	if double == true
	 exp*=2
	end
    if Settings::SCALED_EXP_FORMULA
      exp /= 5
      levelAdjust = (2*level+10.0)/(pkmn.level+level+10.0)
      levelAdjust = levelAdjust**5
      levelAdjust = Math.sqrt(levelAdjust)
      exp *= levelAdjust
      exp = exp.floor
      exp += 1 if isPartic || hasExpShare
    else
      exp /= 7
    end
    # Foreign Pokémon gain more Exp
    isOutsider = (pkmn.owner.id != pbPlayer.id ||
                 (pkmn.owner.language != 0 && pkmn.owner.language != pbPlayer.language))
    if isOutsider
      if pkmn.owner.language != 0 && pkmn.owner.language != pbPlayer.language
        exp = (exp*1.7).floor
      else
        exp = (exp*1.5).floor
      end
    end
    # Modify Exp gain based on EXP Charm's Presence
    exp = (exp * 1.5).floor if GameData::Item.exists?(:EXPCHARM) && $bag.has?(:EXPCHARM)
    oldlevel = pkmn.level
    pkmn.exp += exp   # Gain Exp
    if !pkmn.level==oldlevel
	    pkmn.heal
		pkmn.calc_stats
		movelist = pkmn.getMoveList
		for i in movelist
			pkmn.learn_move(i[1]) if i[0]==pkmn.level   # Learned a new move
		end
    end
	end
	def pbGetItem
		items = PokeventureConfig::Items
		items.sort! { |a, b| b[1] <=> a[1] }
		chance_total = 0
		items.each { |a| chance_total += a[1] }
		rnd = rand(chance_total)
		item = nil
		items.each do |itm|
			rnd -= itm[1]
			next if rnd >= 0
			item = itm[0]
			break
		end
		return item
	end
	def pbGetPokemon3
		pkmn = PokeventureConfig::PkmnList
		pkmn.sort! { |a, b| b[1] <=> a[1] }
		chance_total = 0
		pkmn.each { |a| chance_total += a[1] }
		rnd = rand(chance_total)
		item = nil
		pkmn.each do |itm|
			rnd -= itm[1]
			next if rnd >= 0
			item = itm[0]
			break
		end
		return item
	end
	def pbGetEgg
		eggs = PokeventureConfig::EggList
		eggs.sort! { |a, b| b[1] <=> a[1] }
		chance_total = 0
		eggs.each { |a| chance_total += a[1] }
		rnd = rand(chance_total)
		item = nil
		eggs.each do |itm|
			rnd -= itm[1]
			next if rnd >= 0
			item = itm[0]
			break
		end
		return item
	end
	def pbGenerateAdEgg(pkmn)
		return false if !pkmn || party_full?
		pkmn = Pokemon.new(pkmn, Settings::EGG_LEVEL) if !pkmn.is_a?(Pokemon)
		# Set egg's details
		pkmn.name           = _INTL("Egg")
		pkmn.steps_to_hatch = pkmn.species_data.hatch_steps
		pkmn.obtain_text    = "Found on an adventure"
		
					if pkmn.loyalty.nil?
					    pkmn.loyalty = 70
					end
					pkmn.lifespan = 50
					pkmn.age = 1
					pkmn.water = (rand(100)+1)
					pkmn.food = (rand(100)+1)
		pkmn.calc_stats
		pkmn.generateBrilliant if (PokeventureConfig::AreFoundFriendsBrilliant && defined?(poke.generateBrilliant))
		# Add egg to party
		party[party.length] = pkmn
		return true
	end
end

def giveAdventureItemList(itemlist)
  list = itemlist.dup.compact()
  string = ""
  while list.length() > 0
    item = list.pop
    count = list.tally[item]
    if count
      count+=1
    else
      count=1
    end
	if item == [:GRIPCLAW] 
	item = :GRIPCLAW
	end
	if item == [:ABSORBBULB] 
	item = :ABSORBBULB
	end
	if item == :COCOABEANS 
	item = :COCOABEAN
	end
	if item == [] 
	item = :ORANBERRY
	end
#    pbMessage(_INTL("{1} ",item))
    if item.is_a?(Array)
	 item = item.sample
	end
    itemdata = GameData::Item.get(item)
    name = (count>1) ? itemdata.name_plural : itemdata.name
    string += count.to_s+" "+name+", "
    $PokemonBag.pbStoreItem(item,count)
    list.delete(item)
  end
end
