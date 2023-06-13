class Pokemon
  attr_accessor :onAdventure #Pokemons Current Map ID
  attr_accessor :location #Pokemons Current Map ID
  attr_accessor :collectedItems #The Items the Pokemon has picked up.
  attr_accessor :encounterLog #An array that logs what the POKeMON has done while adventuring.
  attr_accessor :adventuringTypes #A list of learned types and focuses for how a POKeMON adventures.
  attr_accessor :chosenAdvType #The chosen type in adventuringTypes
  attr_accessor :travelswithEgg #has an egg with it.
  attr_accessor :travelswithOther #has another with it.
  attr_accessor :inDungeon #has another with it.
  attr_accessor :advSteps #has another with it.

  alias :initold :initialize
  def initialize(*args)
    initold(*args)
    @onAdventure  = nil
    @location      = nil
    @collectedItems      = []
    @encounterLog      = []
    @adventuringTypes      = ["None"]
    @chosenAdvType      = nil
    @travelswithEgg      = nil
    @travelswithOther      = nil
    @inDungeon      = false
    @advSteps      = 0
  end
end
class Adventure 
	attr_accessor :party
	attr_accessor :adventurerTypes
	attr_accessor :items
	  
	def initialize
		@items		= []
		@party      = []
		@iq      = ["Dedicated Traveler","Collector","Acute Sniffer","Survivalist","Aggressor","Wary Fighter","House Avoider","Exp. Elite","Coin Watcher","Sleeper","Parental Instinct","Unfortunate","Shadow Striker"] 
		@steps		= 0
	end
	def newStep
	    return if @party.length == 0
		pkmn,index = choosePokemonforEvent
		if !pkmn.nil?
		if pkmn.collectedItems.nil?
		  pkmn.collectedItems = []
		end
		if pkmn.adventuringTypes.nil?
		 pkmn.adventuringTypes = ["None"]
		elsif pkmn.adventuringTypes.length==0
		 pkmn.adventuringTypes = ["None"]
		end
		if pkmn.advSteps.nil?
			pkmn.advSteps = 0
		end
		pkmn.advSteps += 1
		if pkmn.food<100
		 pkmn.food=100
		end
		if pkmn.water>100
		 pkmn.water=100
		end
		if pkmn.onAdventure.nil?
		pkmn.onAdventure=true
		end
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
		if $PokemonSystem.survivalmode==0
		@party.each do |pkmn|
		if $game_switches[167]==false && pbIsWeekday(6) 
		$game_switches[167] == true
		if pkmn.lifespan == 0 
		pkmn.permadeath=true
		pkmn.hp = 0
		end
		pkmn.changeAge
		pkmn.changeLifespan("age",pkmn)
		elsif !pbIsWeekday(6)
		$game_switches[167] = false
		end
		end
end
		if pkmn.advSteps >= PokeventureConfig::Updatesteps
			if pkmn && rand(2)==1
			if pkmn.location.nil?
			pbWalkingDowntheRoad(pkmn)
			else
			pbExplorersoftheI(pkmn,index)
			end
			else
			pbWalkingDowntheRoad(pkmn)
			end
		end
		if pkmn.location == $game_map.map_id
		  @items << pkmn.collectedItems
		  pkmn.collectedItems = []
		end
        end
	end

    def pbWalkingDowntheRoad(pkmn)
	 amt=0
	   loop do
	   id_map = rand(999)
	   puts id_map
	   id_map = id_map.to_i
	   if pbRgssExists?(sprintf("Data/Map%03d.rxdata", id_map))
	    if ApprovedAdvMaps(id_map,pkmn)
		  pkmn.location = id_map
	      pkmn.advSteps=0
		  break 
		end
	   else
		pkmn.advSteps=0
	   end
	 end
	 end

	def pbExplorersoftheI(pkmn,index)
	if IQEffects(pkmn,"exploring")
	  return false
	end
	   type = rand(5)
	   if type == 5 && GameData::MapMetadata.get($game_map.map_id).outdoor_map && pkmn.happiness>90 && pkmn.loyalty<20 && !$player.party_full? && pkmn.location == $game_map.map_id
			pbMessage(_INTL("{1} came back! They missed you. They were clearly too good at hide and seek.", pkmn.name))
             $player.party[$player.party.length] = pkmn
			 remove_pokemon_at_index(index)
			 return false
	  end
	   case type
		when 0
		collectionEncounters(pkmn)
		when 1
		randomEncounters(pkmn)
		when 2
		battleEncounters(pkmn,index) if pkmn.hp!=0
		when 3
		collectionEncounters(pkmn)
		when 4
		battleEncounters(pkmn,index) if pkmn.hp!=0
		when 5
		battleEncounters(pkmn,index) if pkmn.hp!=0
	  end 
	  pkmn.advSteps=0
end
end
def IQEffects(pkmn,curAction)
     return false if pkmn.chosenAdvType.nil?
      case pkmn.chosenAdvType
	    when "Dedicated Traveler"
		  if curAction == "exploring"
		    if rand(2)==1
			  pbWalkingDowntheRoad(pkmn)
			  return true
			end
		  end
		when "Collector"
		  if curAction != "collecting"
		    if rand(2)==1
		      collectionEncounters(pkmn)
			  return true
			end
		  end
		when "Acute Sniffer"
		  if curAction == "obtainingItems"
		    return true
		  end
		when "Survivalist"
		  if curAction != "resting"
		    if rand(2)==1
		      pkmn.food+=rand(20)+10
		      pkmn.water+=rand(20)+10
			end
		  end
		when "Aggressor"
		  if curAction == "battling"
		     pkmn.collectedItems.append(pbGetItem(pkmn))
		  end
		when "Wary Fighter"
		  if curAction == "startingBattle" && pkmn.hp<30
		    if rand(2)==1
			  pbExplorersoftheI(pkmn)
		      return true
			end
		  end
		when "House Avoider"
		  if curAction == "dungeon"
		    if rand(2)==1
			  pbExplorersoftheI(pkmn)
		      return true
			end
		  end
		when "Exp. Elite"
		  if curAction == "exp"
		      return true
		  end
		when "Coin Watcher"
		  if curAction == "obtainingItems"
		    return true
		  end
		when "Sleeper"
		  if curAction != "fucking" 
		    collectionEncounters(pkmn,likelihood=nil)
		    return true
		  end
		when "Parental Instinct"
		  if curAction != "wildEgg" 
		    collectionEncounters(pkmn,likelihood=nil)
		    return true
		  end
		when "Unfortunate"
		when "Shadow Striker"
		  if curAction = "Shadow Striker" 
		    return true
		  end
	  end
	  return false
end
	
	def choosePokemonforEvent
	    amt = 0
		pkmn = 0
		loop do
		return false if @party.length==0
		index = rand(@party.length)
		pkmn = @party[index]
		if !pkmn.able? || pkmn.egg?
		break
		end
		return pkmn,index
		end
	end

	  #Dedicated Traveler: The Pokémon will focus on traveling. It will do other things less often. 
	  #Collector: The Pokémon will focus on collecting more types of items. It will do other things less often. 
	  #Acute Sniffer: The Pokémon will focus on collecting rare items. It will do other things less often. 
	  #Survivalist: The Pokémon's food and water will be prioritized while traveling.
	  #Aggressor: The Pokémon will focus on combat. It will do other things less often, but it will bring back meat. 
	  #Wary Fighter: If the Pokémon's HP is low, it will not get into combat, but it will collect less items. 
	  #House Avoider: This Pokémon will not go to Monster Houses.
	  #Exp Elite: This Pokémon will gain more exp when it gets into combat.
	  #Coin Watcher: This Pokémon will focus on primarily collecting Star Pieces.
	  #Sleeper: This Pokémon will sleep more while collecting. It will do other things less often. 
	  #Parental Instinct: This Pokémon will focus on locating Eggs. It will do other things less often. 
	  #Unfortunate: This Pokémon gets lost often. 
	  #Shadow Striker: This Pokémon will strike subtly, often winning combat without the enemy noticing. 	
	
	def collectionEncounters(pkmn,likelihood=nil)
	  if IQEffects(pkmn,"collection")
	  end
	  if likelihood.nil?
	  likelihood = rand(21)
	  end
	  case likelihood
	   when 0
	    if IQEffects(pkmn,"collection")
	    end
	 if pkmn.chosenAdvType=="Collector"
	 item = pbGetItem(pkmn)
	 pkmn.collectedItems.append(item)
	 pkmn.collectedItems.append(item)
	 else
	 pkmn.collectedItems.append(pbGetItem(pkmn))
	 end  #chances >375 && PokeventureConfig::CollectRandomItem   #FIND ITEM
	   when 1
	    if IQEffects(pkmn,"wildEgg")
	    end
     	encounter = $PokemonEncounters.choose_wild_pokemon(:AdventureEggs)
		encounter = [nil, nil] if encounter.nil?
		pbGenerateAdEgg(encounter[0])
	   when 2
	    if IQEffects(pkmn,"fucking")
	    end
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
	   when 3
	 if pkmn.chosenAdvType=="Collector"
	 item = pbGetItem(pkmn)
	 pkmn.collectedItems.append(item)
	 pkmn.collectedItems.append(item)
	 else
	 pkmn.collectedItems.append(pbGetItem(pkmn))
	 end  #chances >375 && PokeventureConfig::CollectRandomItem   #FIND ITEM
	   when 4
	 if pkmn.chosenAdvType=="Collector"
	 item = pbGetItem(pkmn)
	 pkmn.collectedItems.append(item)
	 pkmn.collectedItems.append(item)
	 else
	 pkmn.collectedItems.append(pbGetItem(pkmn))
	 end  #chances >375 && PokeventureConfig::CollectRandomItem   #FIND ITEM
	   when 5
	 if pkmn.chosenAdvType=="Collector"
	 item = pbGetItem(pkmn)
	 pkmn.collectedItems.append(item)
	 pkmn.collectedItems.append(item)
	 else
	 pkmn.collectedItems.append(pbGetItem(pkmn))
	 end  #chances >375 && PokeventureConfig::CollectRandomItem   #FIND ITEM
	   else
	  end
	end
	
	def battleEncounters(pkmn,index)
	  if IQEffects(pkmn,"startingBattle")
	   return false
	  end
	  likelihood = rand(21)
	  case likelihood
	   when 0     #Normal Battle
	  if IQEffects(pkmn,"battling")
	  end
	    battle(pkmn,index,type="normal")
	   when 1     #Normal Battle
	  if IQEffects(pkmn,"battling")
	  end
	    battle(pkmn,index,type="normal")
	   when 2     #Normal Battle
	  if IQEffects(pkmn,"battling")
	  end
	    battle(pkmn,index,type="normal")
	   when 3     #Normal Battle
	  if IQEffects(pkmn,"battling")
	  end
	    battle(pkmn,index,type="normal")
	   when 4    #Harder Battle
	  if IQEffects(pkmn,"hardbattling")
	  end
	    battle(pkmn,index,type="hard")
	   when 5    #Harder Battle
	  if IQEffects(pkmn,"hardbattling")
	  end
	    battle(pkmn,index,type="hard")
	   when 6    #Raid Battle
	  if IQEffects(pkmn,"raidbattling")
	  end
	    battle(pkmn,index,type="raid")
	   when 7    #Team Battle!
	  if IQEffects(pkmn,"teambattling")
	  end
	    battle(pkmn,index,type="team")
	   when 8    #Dungeon
	  if IQEffects(pkmn,"dungeon")
	    return false
	  end
	    dungeon(pkmn,index)
	   when 9    #Heal
		  pkmn.heal	 
	   when 10    #freelevelup
        endexp = pkmn.growth_rate.minimum_exp_for_level(pkmn.level + 1)
        neededexp = endexp-pkmn.exp
		pkmn.exp += neededexp
	   else
	  end
	end
	
	def randomEncounters(pkmn)
	  if IQEffects(pkmn,"random")
	  end
	  rarer = rand(999)
	  likelihood = rand(21)
	   case likelihood
	   when 0
	   if GameData::MapMetadata.get(pkmn.location.to_i).outdoor_map && pkmn.location == $game_map.map_id
	        pbMessage(_INTL("Oh! You encountered {1}! Hello {1}.", pkmn.name))
			pkmn.loyalty+=10
			pkmn.happiness+=45
	   end
	   when 1 
	   if GameData::MapMetadata.get(pkmn.location.to_i).outdoor_map && rarer <= 10
		    if pkmn.hue==0
            pkmn.hue = rand(360)
            pkmn.memento = :LOSTMARK
			end
	   end
	   when 2 #ADD TRADING
	   when 3 #FOOD AND WATER
	  if IQEffects(pkmn,"resting")
	  end
		pkmn.food+=rand(20)+10
		pkmn.water+=rand(20)+10
	   when 4 #SHADOW POKEMON?!?!
	   if GameData::MapMetadata.get(pkmn.location.to_i).outdoor_map && rarer == 0
	    pkmn.makeShadow
	   end
	   when 5 
	    if rand(256)==1
	    iqs = ["Dedicated Traveler","Collector","Acute Sniffer","Survivalist","Aggressor","Wary Fighter","House Avoider","Exp. Elite","Coin Watcher","Sleeper","Parental Instinct"]
        choice = rand(iqs.length)
        pkmn.adventuringTypes.append(iqs[choice])
	    end
	     
	   else
	   end
	end
	
	
	def dungeon(pkmn,index)
	  if IQEffects(pkmn,"dungeon")
	  end
	 amt=0
	 loop do
	 battle(pkmn,index,type="normal")
	 if pkmn.chosenAdvType=="Collector"
	 item = pbGetItem(pkmn)
	 pkmn.collectedItems.append(item)
	 pkmn.collectedItems.append(item)
	 else
	 pkmn.collectedItems.append(pbGetItem(pkmn))
	 end
	 break if pkmn.hp==0
	 amt+1
	 break if amt==3
	 end
	 battle(pkmn,index,type="raid")
	 if pkmn.chosenAdvType=="Collector"
	 item = pbGetItem(pkmn)
	 pkmn.collectedItems.append(item)
	 pkmn.collectedItems.append(item)
	 else
	 pkmn.collectedItems.append(pbGetItem(pkmn))
	 end
	 if rand(2)==1
	 iqs = ["Dedicated Traveler","Collector","Acute Sniffer","Survivalist","Aggressor","Wary Fighter","House Avoider","Exp. Elite","Coin Watcher","Sleeper","Parental Instinct"]
     choice = rand(iqs.length)
     pkmn.adventuringTypes.append(iqs[choice])
	 end
	end
	def battle(battler,index,type="normal")
	    pkmn = battler
		amt = 0
		encounter = 0
		loop do
		enctype = rand(10)
		encounter = nil
		case enctype
		 when 0
		encounter = $PokemonEncounters.choose_wild_pokemon(:Adventure)
		 when 1
		encounter = $PokemonEncounters.choose_wild_pokemon(:Land)
		 when 2
		encounter = $PokemonEncounters.choose_wild_pokemon(:Cave)
		 when 3
		encounter = $PokemonEncounters.choose_wild_pokemon(:Water)
		 when 4
		encounter = $PokemonEncounters.choose_wild_pokemon(:LandMorning)
		 when 5
		encounter = $PokemonEncounters.choose_wild_pokemon(:LandDay)
		 when 6
		encounter = $PokemonEncounters.choose_wild_pokemon(:LandNight)
		 when 7
		encounter = $PokemonEncounters.choose_wild_pokemon(:CaveDeep)
		 when 8
		encounter = $PokemonEncounters.choose_wild_pokemon(:RockSmash)
		 when 9
		encounter = $PokemonEncounters.choose_wild_pokemon(:Bait)
		else
		encounter = $PokemonEncounters.choose_wild_pokemon(:Adventure)
		end
		amt+=1
		if amt == 3
		encounter = $PokemonEncounters.choose_wild_pokemon(:Adventure)
		end
		encounter = [nil, nil] if encounter.nil?
		break if !encounter.nil? && !encounter[0].nil?
		end
		if !encounter.nil? && !encounter[0].nil?
			partylevel = pkmn.level
			win = false
			if type=="normal"
			level =  encounter[1]
			elsif type=="hard"
			level =  encounter[1]+rand(5)+1
			elsif type=="raid"
			level =  encounter[1]+rand(10)+1
			elsif type=="team"
			level =  encounter[1]+rand(5)+1
		amt = 0
		encounter2 = 0
		loop do
		enctype = rand(10)
		case enctype
		 when 0
		encounter2 = $PokemonEncounters.choose_wild_pokemon(:Adventure)
		 when 1
		encounter2 = $PokemonEncounters.choose_wild_pokemon(:Land)
		 when 2
		encounter2 = $PokemonEncounters.choose_wild_pokemon(:Cave)
		 when 3
		encounter2 = $PokemonEncounters.choose_wild_pokemon(:Water)
		 when 4
		encounter2 = $PokemonEncounters.choose_wild_pokemon(:LandMorning)
		 when 5
		encounter2 = $PokemonEncounters.choose_wild_pokemon(:LandDay)
		 when 6
		encounter2 = $PokemonEncounters.choose_wild_pokemon(:LandNight)
		 when 7
		encounter2 = $PokemonEncounters.choose_wild_pokemon(:CaveDeep)
		 when 8
		encounter2 = $PokemonEncounters.choose_wild_pokemon(:RockSmash)
		 when 9
		encounter2 = $PokemonEncounters.choose_wild_pokemon(:Bait)
		else 
		encounter2 = $PokemonEncounters.choose_wild_pokemon(:Adventure)
		end
		amt+=1
		if amt == 3
		encounter2 = $PokemonEncounters.choose_wild_pokemon(:Adventure)
		end
		encounter2 = [nil, nil] if encounter2.nil?
		break if !encounter2.nil? && !encounter2[0].nil?
		end

			end
			if type=="team"
			    partylevel+=encounter2[1]
			end
			chance = encounter[1] - partylevel
			if partylevel > level && (rand(5)==4 || chance < 0) || IQEffects(pkmn,"Shadow Striker")
				win = true
				pkmn.hp -= rand(pkmn.totalhp/9)+1
				if pkmn.hp==0
				 if pkmn.item==:REVIVALHERB || pkmn.item==:MAXHONEY
			       pkmn.hp=pkmn.totalhp
				   pkmn.item = nil
				 else
				  win = false
				 end
				end
			elsif 1 == rand(chance)
				win = true 
				pkmn.hp -= rand(pkmn.totalhp/6)+1
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
				if !encounter2.nil? && type=="team"
				poke = Pokemon.new(encounter2[0],encounter2[1])
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
				end
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
						pkmn.collectedItems.append(drops.compact.sample)
					end
				end
                if pkmn.able? && PokeventureConfig::GainExp
			        if type=="normal"
			           pbGainAventureExp(pkmn,poke,1)
			        elsif type=="hard"
			           pbGainAventureExp(pkmn,poke,2)
			        elsif type=="raid"
			           pbGainAventureExp(pkmn,poke,3)
			        elsif type=="team"
			           pbGainAventureExp(pkmn,poke,0.5)
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
			   pkmn.collectedItems.delete_at(rand(pkmn.collectedItems.length))
			   end
			end
		end
		@party.each do |pkmn|
			PokeventureConfig::pbAdventureAbilities(pkmn)
		end
	end


	def ApprovedAdvMaps(map,pkmn)
#	   GameData::MapMetadata.try_get(map)
	   map = pbGetMapNameFromId(map)
	   case map.to_s
	    when "Temperate Shore"
		  return true
		when "Temperate Ocean"
		  return true
		when "Temperate Plains"
		  return true
		when "Temperate Highlands"
		  return true
		when "Mountain Interior"
		  return true
		when "Temperate Marsh"
		  return true
		when "Chilled Plains"
		  return true
		when "Frigid Highlands"
		  return true
		when "Deep Caves"
		  return true
		when "Tropical Coast"
		  return true
		when "Forest Zone"
		  return true
		when "Northern Area"
		  return true
		when "Jungle"
		  return true
		when "Southern Beach"
		  return true
		when "Southern Ocean"
		  return true
		when "West Shore"
		  return true
		when "Ravine"
		  return true
		when "Western Temperate"
		  return true
		when "Southern Ocean U"
		 if pkmn.types.include?(:WATER)
		  return true
		 end
		  return false
		when "S.S Glittering Wreck"
		 if pkmn.types.include?(:WATER)
		  return true
		 end
		  return false
		when "Red and Blue's Cabin"
		 if pkmn.types.include?(:WATER)
		  return true
		 end
		  return false
		when "Your Cabin"
		 if pkmn.types.include?(:WATER)
		  return true
		 end
		  return false
		when "William's Cabin"
		 if pkmn.types.include?(:WATER)
		  return true
		 end
		  return false
		when "Abandoned Cabin"
		 if pkmn.types.include?(:WATER)
		  return true
		 end
		  return false
		when "Kitchen"
		 if pkmn.types.include?(:WATER)
		  return true
		 end
		  return false
		when "Captain's Quarters"
		 if pkmn.types.include?(:WATER)
		  return true
		 end
		  return false
		when "S.S Glittering"
		 if pkmn.types.include?(:WATER)
		  return true
		 end
		  return false
		when "Temperate Skies"
		 if pkmn.types.include?(:FLYING)
		  return true
		 end
		  return false
		when "Shore Skies"
		 if pkmn.types.include?(:FLYING)
		  return true
		 end
		  return false
		when "Mountain Skies"
		 if pkmn.types.include?(:FLYING)
		  return true
		 end
		  return false
	   end
	   return false
	end
	def pbGainAventureExp(pkmn,defeatedBattler,multiplier)
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
      exp = a / 1
    end
    return if exp<=0
    # Scale the gained Exp based on the gainer's level (or not)
	exp*=multiplier
	if IQEffects(pkmn,"exp")
	 exp*=1.5
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
	def pbGetItem(pkmn)
		items = PokeventureConfig::Items
		if IQEffects(pkmn,"obtainingItems")
		 if pkmn.chosenAdvType=="Acute Sniffer"
		  items2 = [[:FIRESTONE,7], [:LEAFSTONE,7], [:MOOMOOMILK,5], [:EXPCANDYM,1], [:IRONORE,10], [:COPPERORE,10], [:GOLDORE,10], [:LEFTOVERS,20], [:SILVERORE,10], [:NUGGET,10], [:BIGNUGGET,1], [:IRONBALL,1], [:THUNDERSTONE,7]]
		  items2.each do |i|
		  items.append(i)
		  end
	   elsif pkmn.chosenAdvType=="Collector"
		  items2 = [[:ORANBERRY,15], [:SITRUSBERRY,10], [:POTATO,2], [:TEALEAF,3], [:WATER,5], [:MOOMOOMILK,1], [:LEMON,5], [:MEAT,1], [:MEAT,1]]
		  items2.each do |i|
		  items.append(i)
		  end
	   elsif pkmn.chosenAdvType=="Coin Watcher"
		  items2 = [[:STARPIECE,1], [:STARPIECE,1], [:STARPIECE,1], [:STARPIECE,1], [:STARPIECE,1]]
		  items2.each do |i|
		  items.append(i)
		  end
	   end
	    end
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
	end
	def harvestItems
	    @party.each do |pkmn|
		 @items.append(pkmn.collectedItems)
		end
		@items.each { |x| Kernel.pbReceiveItem(x) if !x.nil?}
		@items = []
	end
	def harvestItemsSilent
	    @party.each do |pkmn|
		 @items.append(pkmn.collectedItems)
		end
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
			@party[pos].location = nil
			@party[pos].inDungeon = false
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
      egg.obtain_text = "Adventuring Accident!"
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

