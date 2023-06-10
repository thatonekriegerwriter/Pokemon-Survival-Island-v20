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
		egg = generate(mother, father)
		if !party_full?
		party[party.length] = egg
		end
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
	
	
	
	
    def generate(mother, father)
      # Determine which Pokémon is the mother and which is the father
      # Ensure mother is female, if the pair contains a female
      # Ensure father is male, if the pair contains a male
      # Ensure father is genderless, if the pair is a genderless with Ditto
      if mother.male? || father.female? || mother.genderless?
        mother, father = father, mother
      end
      mother_data = [mother, mother.species_data.egg_groups.include?(:Ditto)]
      father_data = [father, father.species_data.egg_groups.include?(:Ditto)]
      # Determine which parent the egg's species is based from
      species_parent = (mother_data[1]) ? father : mother
      # Determine the egg's species
      baby_species = determine_egg_species(species_parent.species, mother, father)
      mother_data.push(mother.species_data.breeding_can_produce?(baby_species))
      father_data.push(father.species_data.breeding_can_produce?(baby_species))
      # Generate egg
      egg = generate_basic_egg(baby_species)
      # Inherit properties from parent(s)
      egg.family = PokemonFamily.new(egg, father, mother)
      inherit_form(egg, species_parent, mother_data, father_data)
      inherit_nature(egg, mother, father)
      inherit_ability(egg, mother_data, father_data)
      inherit_moves(egg, mother_data, father_data)
      inherit_IVs(egg, mother, father)
      inherit_poke_ball(egg, mother_data, father_data)
      egg.age = 1
      egg.lifespan = 50
      egg.water = 100
      egg.food = 100
      # Calculate other properties of the egg
      set_shininess(egg, mother, father)   # Masuda method and Shiny Charm
      set_pokerus(egg)
      # Recalculate egg's stats
      egg.calc_stats
      return egg
    end

    def determine_egg_species(parent_species, mother, father)
      ret = GameData::Species.get(parent_species).get_baby_species(true, mother.item_id, father.item_id)
      # Check for alternate offspring (i.e. Nidoran M/F, Volbeat/Illumise, Manaphy/Phione)
      offspring = GameData::Species.get(ret).offspring
      ret = offspring.sample if offspring.length > 0
      return ret
    end

    def generate_basic_egg(species)
      egg = Pokemon.new(species, Settings::EGG_LEVEL)
      egg.name           = _INTL("Egg")
      egg.steps_to_hatch = egg.species_data.hatch_steps
      egg.obtain_text    = _INTL("Day-Care Couple")
      egg.happiness      = 120
      egg.form           = 0 if species == :SINISTEA
      # Set regional form
      new_form = MultipleForms.call("getFormOnEggCreation", egg)
      egg.form = new_form if new_form
      return egg
    end

    def inherit_form(egg, species_parent, mother, father)
      # mother = [mother, mother_ditto, mother_in_family]
      # father = [father, father_ditto, father_in_family]
      # Inherit form from the parent that determined the egg's species
      if species_parent.species_data.has_flag?("InheritFormFromMother")
        egg.form = species_parent.form
      end
      # Inherit form from a parent holding an Ever Stone
      [mother, father].each do |parent|
        next if !parent[2]   # Parent isn't a related species to the egg
        next if !parent[0].species_data.has_flag?("InheritFormWithEverStone")
        next if !parent[0].hasItem?(:EVERSTONE)
        egg.form = parent[0].form
        break
      end
    end

    def get_moves_to_inherit(egg, mother, father)
      # mother = [mother, mother_ditto, mother_in_family]
      # father = [father, father_ditto, father_in_family]
      move_father = (father[1]) ? mother[0] : father[0]
      move_mother = (father[1]) ? father[0] : mother[0]
      moves = []
      # Get level-up moves known by both parents
      egg.getMoveList.each do |move|
        next if move[0] <= egg.level   # Could already know this move by default
        next if !mother[0].hasMove?(move[1]) || !father[0].hasMove?(move[1])
        moves.push(move[1])
      end
      # Inherit Machine moves from father (or non-Ditto genderless parent)
      if Settings::BREEDING_CAN_INHERIT_MACHINE_MOVES && !move_father.female?
        GameData::Item.each do |i|
          move = i.move
          next if !move
          next if !move_father.hasMove?(move) || !egg.compatible_with_move?(move)
          moves.push(move)
        end
      end
      # Inherit egg moves from each parent
      if !move_father.female?
        egg.species_data.egg_moves.each do |move|
          moves.push(move) if move_father.hasMove?(move)
        end
      end
      if Settings::BREEDING_CAN_INHERIT_EGG_MOVES_FROM_MOTHER && move_mother.female?
        egg.species_data.egg_moves.each do |move|
          moves.push(move) if move_mother.hasMove?(move)
        end
      end
      # Learn Volt Tackle if a parent has a Light Ball and is in the Pichu family
      if egg.species == :PICHU && GameData::Move.exists?(:VOLTTACKLE) &&
         ((father[2] && father[0].hasItem?(:LIGHTBALL)) ||
          (mother[2] && mother[0].hasItem?(:LIGHTBALL)))
        moves.push(:VOLTTACKLE)
      end
      return moves
    end

    def inherit_moves(egg, mother, father)
      moves = get_moves_to_inherit(egg, mother, father)
      # Remove duplicates (keeping the latest ones)
      moves = moves.reverse
      moves |= []   # remove duplicates
      moves = moves.reverse
      # Learn moves
      first_move_index = moves.length - Pokemon::MAX_MOVES
      first_move_index = 0 if first_move_index < 0
      (first_move_index...moves.length).each { |i| egg.learn_move(moves[i]) }
    end

    def inherit_nature(egg, mother, father)
      new_natures = []
      new_natures.push(mother.nature) if mother.hasItem?(:EVERSTONE)
      new_natures.push(father.nature) if father.hasItem?(:EVERSTONE)
      return if new_natures.empty?
      egg.nature = new_natures.sample
    end

    # If a Pokémon is bred with a Ditto, that Pokémon can pass down its Hidden
    # Ability (60% chance). If neither Pokémon are Ditto, then the mother can
    # pass down its ability (60% chance if Hidden, 80% chance if not).
    # NOTE: This is how ability inheritance works in Gen 6+. Gen 5 is more
    #       restrictive, and even works differently between BW and B2W2, and I
    #       don't think that is worth adding in. Gen 4 and lower don't have
    #       ability inheritance at all, and again, I'm not bothering to add that
    #       in.
    def inherit_ability(egg, mother, father)
      # mother = [mother, mother_ditto, mother_in_family]
      # father = [father, father_ditto, father_in_family]
      parent = (mother[1]) ? father[0] : mother[0]   # The female or non-Ditto parent
      if parent.hasHiddenAbility?
        egg.ability_index = parent.ability_index if rand(100) < 60
      elsif !mother[1] && !father[1]   # If neither parent is a Ditto
        if rand(100) < 80
          egg.ability_index = mother[0].ability_index
        else
          egg.ability_index = (mother[0].ability_index + 1) % 2
        end
      end
    end

    def inherit_IVs(egg, mother, father)
      # Get all stats
      stats = []
      GameData::Stat.each_main { |s| stats.push(s) }
      # Get the number of stats to inherit
      inherit_count = 3
      if Settings::MECHANICS_GENERATION >= 6
        inherit_count = 5 if mother.hasItem?(:DESTINYKNOT) || father.hasItem?(:DESTINYKNOT)
      end
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

    # Poké Balls can only be inherited from parents that are related to the
    # egg's species.
    # NOTE: This is how Poké Ball inheritance works in Gen 7+. Gens 5 and lower
    #       don't have Poké Ball inheritance at all. In Gen 6, only a female
    #       parent can pass down its Poké Ball. I don't think it's worth adding
    #       in these variations on the mechanic.
    # NOTE: The official games treat Nidoran M/F and Volbeat/Illumise as
    #       unrelated for the purpose of this mechanic. Essentials treats them
    #       as related and allows them to pass down their Poké Balls.
    def inherit_poke_ball(egg, mother, father)
      # mother = [mother, mother_ditto, mother_in_family]
      # father = [father, father_ditto, father_in_family]
      balls = []
      [mother, father].each do |parent|
        balls.push(parent[0].poke_ball) if parent[2]
      end
      balls.delete(:MASTERBALL)    # Can't inherit this Ball
      balls.delete(:CHERISHBALL)   # Can't inherit this Ball
      egg.poke_ball = balls.sample if !balls.empty?
    end

    # NOTE: There is a bug in Gen 8 that skips the original generation of an
    #       egg's personal ID if the Masuda Method/Shiny Charm can cause any
    #       rerolls. Essentials doesn't have this bug, meaning eggs are slightly
    #       more likely to be shiny (in Gen 8+ mechanics) than in Gen 8 itself.
    def set_shininess(egg, mother, father)
      shiny_retries = 0
      if father.owner.language != mother.owner.language
        shiny_retries += (Settings::MECHANICS_GENERATION >= 8) ? 6 : 5
      end
      shiny_retries += 2 if $bag.has?(:SHINYCHARM)
      return if shiny_retries == 0
      shiny_retries.times do
        break if egg.shiny?
        egg.shiny = nil   # Make it recalculate shininess
        egg.personalID = rand(2**16) | (rand(2**16) << 16)
      end
    end

    def set_pokerus(egg)
      egg.givePokerus if rand(65_536) < Settings::POKERUS_CHANCE
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

