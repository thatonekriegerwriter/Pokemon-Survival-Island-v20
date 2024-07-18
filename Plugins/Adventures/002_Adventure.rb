EventHandlers.add(:on_frame_update, :increase_adventuring_stage,
  proc {
    next if pbGetTimeNow.to_i<$Adventure.last_check+$Adventure.timer
    #$Adventure.adventuring if pbGetTimeNow.to_i>=$Adventure.last_check+$Adventure.timer
  }
)


class PokemonEncounters  
  def encounter_type_for_adventure_eggs(map_id)
    time = pbGetTimeNow
    ret = nil
    if map_has_encounter_type?(map_id,:AdventureEggs)
      ret = find_valid_encounter_type_for_map_and_time(:AdventureEggs, time, map_id)
    end
    if map_has_encounter_type?(map_id,:Adventure) && !ret
      ret = find_valid_encounter_type_for_map_and_time(:Adventure, time, map_id)
    end

    if !ret && pbLoadMapInfos[map_id].name.include?("Ocean") && map_has_encounter_type?(map_id,:Water)
      ret = find_valid_encounter_type_for_map_and_time(:Water, time, map_id)
    end
	
    if !ret && has_cave_encounters? && map_has_encounter_type?(map_id,:Cave)
        ret = find_valid_encounter_type_for_map_and_time(:Cave, time, map_id)
    end
	
	
    if !ret && map_has_encounter_type?(map_id,:Land)
        ret = find_valid_encounter_type_for_map_and_time(:Land, time, map_id) if !ret
    end
	
	
	
    return ret
  end
  def encounter_type_for_adventure(map_id)
    time = pbGetTimeNow
    ret = nil
    if map_has_encounter_type?(map_id,:Adventure)
      ret = find_valid_encounter_type_for_map_and_time(:Adventure, time, map_id)
    end

    if !ret && pbLoadMapInfos[map_id].name.include?("Ocean") && map_has_encounter_type?(map_id,:Water)
      ret = find_valid_encounter_type_for_map_and_time(:Water, time, map_id)
    end
	
    if !ret && has_cave_encounters? && map_has_encounter_type?(map_id,:Cave)
        ret = find_valid_encounter_type_for_map_and_time(:Cave, time, map_id)
    end
	
	
    if !ret && map_has_encounter_type?(map_id,:Land)
        ret = find_valid_encounter_type_for_map_and_time(:Land, time, map_id) if !ret
    end
	
	
	
    return ret
  end
  

    def find_valid_encounter_type_for_map_and_time(base_type, time, map_id)
    ret = nil
    if PBDayNight.isDay?(time)
      try_type = nil
      if PBDayNight.isMorning?(time)
        try_type = (base_type.to_s + "Morning").to_sym
      elsif PBDayNight.isAfternoon?(time)
        try_type = (base_type.to_s + "Afternoon").to_sym
      elsif PBDayNight.isEvening?(time)
        try_type = (base_type.to_s + "Evening").to_sym
      end
      ret = try_type if try_type && map_has_encounter_type?(map_id,try_type)
      if !ret
        try_type = (base_type.to_s + "Day").to_sym
        ret = try_type if map_has_encounter_type?(map_id,try_type)
      end
    else
      try_type = (base_type.to_s + "Night").to_sym
      ret = try_type if map_has_encounter_type?(map_id,try_type)
    end
    return ret if ret
    return (map_has_encounter_type?(map_id,base_type)) ? base_type : nil
  end
  
  
  
  
end


class Pokemon
  attr_accessor :onAdventure #Pokemons Current Map ID
  attr_accessor :location #Pokemons Current Map ID
  attr_accessor :collectedItems #The Items the Pokemon has picked up.
  attr_accessor :encounterLog #An array that logs what the POKeMON has done while adventuring.
  attr_accessor :adventuringTypes #A list of learned types and focuses for how a POKeMON adventures.
  attr_accessor :chosenAdvType #The chosen type in adventuringTypes
  attr_accessor :travelswithEgg #has an egg with it.
  attr_accessor :travelingpartners #has another with it.
  attr_accessor :inDungeon #has another with it.
  attr_accessor :advSteps #has another with it.
  attr_accessor :who_fighting #has another with it.
  attr_accessor :wait_time #has another with it.
  attr_accessor :just_arrived #has another with it.
  attr_accessor :called_back #has another with it.

  alias :initold :initialize
  def initialize(*args)
    initold(*args)
    @onAdventure  = false
    @location      = nil
    @collectedItems      = []
    @encounterLog      = []
    @adventuringTypes      = ["None"]
    @chosenAdvType      = nil
    @travelswithEgg      = nil
    @travelingpartners      = nil
    @inDungeon      = false
    @advSteps      = 0
    @who_fighting      = nil
    @wait_time      = 0
    @just_arrived      = false
    @called_back      = false
    @called_back_map      = nil
  end
  
  def travelingpartners
   @travelingpartners = [] if @travelingpartners.nil?
   return @travelingpartners
  end
  def who_fighting
   return @who_fighting
  end
  def wait_time
   @wait_time = 0 if @wait_time.nil?
   return @wait_time
  end
  def just_arrived
   @just_arrived = false if @just_arrived.nil?
   return @just_arrived
  end
  def called_back
   @called_back = false if @called_back.nil?
   return @called_back
  end
  def called_back_map
   @called_back_map = nil if @called_back_map.nil?
   return @called_back_map
  end


end
class Adventure #Set up
	attr_accessor :party
	attr_accessor :adventurerTypes
	attr_accessor :iq
	attr_accessor :items
	attr_accessor :last_check
	attr_accessor :timer
	  
	def initialize
		@items		= []
		@party      = []
		@iq      = ["Dedicated Traveler","Collector","Acute Sniffer","Survivalist","Aggressor","Wary Fighter","House Avoider","Exp. Elite","Coin Watcher","Sleeper","Parental Instinct","Unfortunate","Shadow Striker"] 
		@steps		= 0
		@timer		= 1800
		@last_check	= pbGetTimeNow.to_i
	end
	def last_check
		@last_check	= pbGetTimeNow.to_i if @last_check.nil?
	   return @last_check
	end
	def timer
		@timer	= 1800 if @timer.nil?
		@timer = 1800 if @timer==0
	   return @timer
	end
	def iq
	 @iq = ["Dedicated Traveler","Collector","Acute Sniffer","Survivalist","Aggressor","Wary Fighter","House Avoider","Exp. Elite","Coin Watcher","Sleeper","Parental Instinct","Unfortunate","Shadow Striker"] if @iq.nil?
	 return @iq
	end
end

class Adventure #Actions
	def adventuring
	  $Adventure.last_check = pbGetTimeNow.to_i
	  return if @party.length == 0
      birth_actions
      death_actions
	  @party.each_with_index do |pkmn,index|
		pkmn.advSteps = 0 if pkmn.advSteps.nil?
		pkmn.adventuringTypes = ["None"] if pkmn.adventuringTypes.nil? || pkmn.adventuringTypes.length==0
		  next if !pkmn.able?
		  next if pkmn.permadeath
		  next if pkmn.egg?
		  next if !pkmn.who_fighting.nil?
		pkmn.advSteps += 1
		if pkmn.called_back==false
		obtain_items if pkmn.location == $game_map.map_id && pkmn.who_fighting
       life_actions(pkmn,index) if pkmn.location != $game_map.map_id && pkmn.advSteps >= PokeventureConfig::Updatesteps 
	   else
	    pkmn.wait_time=0
		 pkmn.location = pkmn.called_back_map if !pkmn.called_back_map.nil?
		 pkmn.location = $game_map.map_id if pkmn.called_back_map.nil?
	   end
	  end
	   
	   
	end
	
   
   def birth_actions
   
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
				egg.hatched_map    = egg.location
				$player.pokedex.register(egg)
				$player.pokedex.set_owned(egg.species)
				egg.record_first_moves
			end
		end


   
   
   end
   def death_actions
  if $PokemonSystem.survivalmode==0 && Nuzlocke.on? && pbIsWeekday(0)
  @party.each do |pkmn|
	 next if !pkmn.who_fighting.nil?
    if pkmn.hp == 0 
      pkmn.permadeath=true
    end
	pkmn.changeAge
	pkmn.changeLifespan("age",pkmn)
    if pkmn.lifespan == 0 
      pkmn.permadeath=true
      pkmn.hp = 0
	  next
    end
  end
  end
   end
   def life_actions(pkmn,index)
		pkmn.just_arrived=false if pkmn.wait_time>0 && pkmn.just_arrived==true
		pkmn.wait_time-=1 if pkmn.wait_time>0
		pbWalkingDowntheRoad(pkmn) if pkmn.wait_time==0
		pkmn.wait_time = rand(3)+1 if pkmn.just_arrived==true
		pbExplorersoftheIsland(pkmn,index) if pkmn.just_arrived==false && pkmn.wait_time>0
	    pkmn.advSteps=0
   end
   def obtain_items
     pkmn.inventory.each_with_index do |item,index|
       next if index==0
	    item[1].times do i
         @items << item[0]
		end
     end
   end
   
   
	
	

    def pbWalkingDowntheRoad(pkmn)
	   map_id = ApprovedAdvMaps(pkmn) 
	   pkmn.location = map_id if map_id
	   pkmn.just_arrived=true
	end



	def pbExplorersoftheIsland(pkmn,index)
	if IQEffects(pkmn,"exploring")
	  return if pkmn.chosenAdvType == "Dedicated Traveler"
	end
	   type = rand(5)
	   case type
		when 0
		collectionEncounters(pkmn,12)
		when 1
		randomEncounters(pkmn)
		when 2
		battleEncounters(pkmn,index) if pkmn.hp!=0
		when 3
		collectionEncounters(pkmn,6)
		when 4
		battleEncounters(pkmn,index) if pkmn.hp!=0
		when 5
		battleEncounters(pkmn,index) if pkmn.hp!=0
	  end 
end

	

	def collectionEncounters(pkmn,likelihood=nil)
	  likelihood = rand(32) if likelihood.nil?
	  case likelihood
	   when 0,3,4,5,7,8
	    if IQEffects(pkmn,"collection")
	    end
	    collectItem(pkmn)
	   when 1
	    if IQEffects(pkmn,"wildEgg")
	    end
		
		enctype = $PokemonEncounters.encounter_type_for_adventure_eggs(pkmn.location)
		encounter = $PokemonEncounters.choose_wild_pokemon_for_map(pkmn.location,enctype)
		if enctype!=:AdventureEggs && rand(2)==0 || encounter.nil?
		 encounter == PokeventureConfig::EggList[rand(PokeventureConfig::EggList)]
		end
		pbGenerateAdEgg(encounter[0]) if !encounter.nil?
	   when 2
	    if IQEffects(pkmn,"fucking")
	    end
		enctype = $PokemonEncounters.encounter_type_for_adventure(pkmn.location)
		encounter = $PokemonEncounters.choose_wild_pokemon_for_map(pkmn.location,enctype)
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
		egg.name           = _INTL("Egg")
		egg.steps_to_hatch = egg.species_data.hatch_steps
		egg.obtain_text    = "Bred while on an Adventure"
		
					if egg.loyalty.nil?
					    egg.loyalty = 70
					end
					egg.lifespan = 50
					egg.age = 1
					egg.water = (rand(100)+1)
					egg.food = (rand(100)+1)
		egg.calc_stats
		egg.generateBrilliant if (PokeventureConfig::AreFoundFriendsBrilliant && defined?(poke.generateBrilliant))
		if !party_full?
		party[party.length] = egg
		end
		end
       when 6
	    if pkmn.travelingpartners.length<2 && PokeventureConfig::FindFriends && 0 == rand(49)
		  enctype = $PokemonEncounters.encounter_type_for_adventure(pkmn.location)
		  if !enctype.nil?
		  encounter = $PokemonEncounters.choose_wild_pokemon_for_map(pkmn.location,enctype)
	      generateAlly(pkmn,encounter)
		  end
		
		end
	   else
	   
	   
	   end
	  
	  
	end
	
	
	def battleEncounters(pkmn,index)
	  if IQEffects(pkmn,"startingBattle")
	   return false if pkmn.chosenAdvType=="Wary Fighter"
	  end


	  likelihood = rand(23)
	  
	  
	  case likelihood
	   when 0,1,2,3,11,12,13,16
	  if IQEffects(pkmn,"battling")
	  end
	    battle(pkmn,index,type="normal")
	   when 4,5,14,15    #Harder Battle
	  if IQEffects(pkmn,"hardbattling")
	  end
	    battle(pkmn,index,type="hard")
	   when 6    #Raid Battle
	  if IQEffects(pkmn,"raidbattling")
	  end
	    battle(pkmn,index,type="raid")
	   when 7,17    #Team Battle!
	    options = []
	    pkmn.travelingpartners.each do |poke|
	     next if poke.egg?
		 options << poke
	   end
	    if options.length>0
	  if IQEffects(pkmn,"teambattling")
	  end
	    battle([pkmn,options[0]],index,type="team")
	   end
	   when 8    #Dungeon
	   if IQEffects(pkmn,"dungeon")
	      return false if pkmn.chosenAdvType=="House Avoider"
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
	   when 1 
	   if GameData::MapMetadata.get(pkmn.location.to_i).outdoor_map && rarer <= 10
		    if pkmn.hue==0
            pkmn.hue = rand(360)
            pkmn.memento = :LOSTMARK
			end
		pkmn.travelingpartners.each do |p|
		    if p.hue==0
            p.hue = rand(360)
            p.memento = :LOSTMARK
			end
		end
	   end
	   when 2 #ADD TRADING
	   when 3 #FOOD AND WATER
	  if IQEffects(pkmn,"resting")
	  end
		pkmn.hp+=pkmn.totalhp/4
		pkmn.hp=pkmn.totalhp if pkmn.hp>pkmn.totalhp
		pkmn.travelingpartners.each do |p|
		  p.hp+=p.totalhp/4
		  p.hp=p.totalhp if p.hp>p.totalhp
		end
	   when 4 #SHADOW POKEMON?!?!
	   if GameData::MapMetadata.get(pkmn.location.to_i).outdoor_map && rarer == 0
	    pkmn.makeShadow
	   end
	   when 5 
	    if rand(256)==1
	    iqs = ["Dedicated Traveler","Collector","Acute Sniffer","Survivalist","Aggressor","Wary Fighter","House Avoider",
		"Exp. Elite","Coin Watcher","Sleeper","Parental Instinct"]
        choice = rand(iqs.length)
        pkmn.adventuringTypes.append(iqs[choice])
	    end
	   else
	   end
	end
		
	

	def collectItem(pkmn)
	    item = pbGetItem(pkmn)
	    amt = 1
	    amt += 1 if pkmn.chosenAdvType=="Collector"
		 puts "amt: #{amt}"
	    pkmn.inv_add(item,amt)
	end

    def addItem(pkmn,item)
	    amt = 1
	    pkmn.inv_add(item,amt)
	end
end

class Adventure #Remember to mark that a pokemon is battling. Remember to make the Log.
  def calcDamageAdventure(user,target,move,multiplier=1)
  #pbCalcDamage
	  baseDmg = move.base_damage
     atk, atkStage = getAttackStats(user, target, move)
    defense, defStage = getDefenseStats(user, target, move)
    multipliers = {
      :base_damage_multiplier  => 1.0,
      :attack_multiplier       => 1.0,
      :defense_multiplier      => 1.0,
      :final_damage_multiplier => 1.0
    }
	multipliers = get_the_multipliers(multipliers,user,move)
    # pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
    # Main damage calculation
    baseDmg = [(baseDmg * multipliers[:base_damage_multiplier]).round, 1].max
    atk     = [(atk     * multipliers[:attack_multiplier]).round, 1].max
    defense = [(defense * multipliers[:defense_multiplier]).round, 1].max
    damage  = ((((user.level / 5) + 1).floor * baseDmg * atk / defense).floor / 50).floor + 2
    damage  = [(damage * multipliers[:final_damage_multiplier]).round, 1].max
	divideby = 2
     return (damage.ceil/divideby).floor
  end
	
	def dungeon(pkmn,index)
	  if IQEffects(pkmn,"dungeon")
	  end
	 amt=0
	 loop do
	 battle(pkmn,index,type="normal")
	 collectItem(pkmn)
	 break if pkmn.hp==0
	 amt+1
	 break if amt==3
	 end
	 if rand(2)==1
	 iqs = ["Dedicated Traveler","Collector","Acute Sniffer","Survivalist","Aggressor","Wary Fighter","House Avoider","Exp. Elite","Coin Watcher","Sleeper","Parental Instinct"]
     choice = rand(iqs.length)
     pkmn.adventuringTypes.append(iqs[choice])
	 end
	end


	def battle(battler,index2,type="normal")
	    battlers = []
	    if battler.is_a? Array
	    pkmn = battler[0]
		ally = battler[1]
		battlers << battler
		elsif battler.is_a?(Pokemon) && type=="team"
		 type="normal"
		 pkmn = battler
		else
		 pkmn = battler
		end
		amt = 0
		win = false
		enctype = $PokemonEncounters.encounter_type_for_adventure(pkmn.location)
		puts enctype
		encounter = $PokemonEncounters.choose_wild_pokemon_for_map(pkmn.location,enctype) if !enctype.nil?
       #EventHandlers.trigger(:on_wild_species_chosen, encounter) if encounter
	   
	   
		if !encounter.nil?
		    enemy = Pokemon.new(encounter[0], encounter[1])
		    pkmn.who_fighting = enemy
		    battlers << enemy
			partylevel = pkmn.level
			partylevel = (pkmn.level + ally.level/2) if !ally.nil?
			chance = encounter[1] - partylevel
			decision = 0
			 loop do
			  battlers.each_with_index do |ibattler,index|
			   otherindex = 0 if index==1
			   otherindex = 1 if index==0
			   if ibattler.is_a? Array
			     ibattler.each do |b|
				   if battlers[otherindex].is_a? Array
				   
				    target = battlers[otherindex][rand(battlers[otherindex].length)]
				   else
				   
				    target = battlers[otherindex]
				   end 
			       take_turn(b,target)
				   take_turn(b,target) if IQEffects(b,"Shadow Striker")
				 end
			   end
			  
			  end
           decision = 1 if partyfainted?(battler) #Loss
           decision = 2 if partyfainted?(enemy) #Win
		    decision = 3 if false #Fled
		    decision = 4 if false #Befriended

           break if decision!=0
           end




      end






			if decision==2
				allied = false
				if PokeventureConfig::FindFriends && 0 == rand(PokeventureConfig::ChanceToFindFriend-1) && pkmn.travelingpartners.length<2
				enemy = enemy[rand(enemy.length)] if enemy.is_a? Array
				enemy.hp = enemy.totalhp
				addAlly(enemy)
				end
				if PokeventureConfig::CollectItemsFromBattles && 0 ==rand(PokeventureConfig::ChanceToGetEnemyItem)
					drops = enemy.wildHoldItems
					if !drops.compact.empty?
					    addItem(pkmn,drops.compact.sample)
					end
				end
              if !battler.is_a?(Array)
			     battler = [battler]
              end
				battler.each do |pk|
				if pk.able? && PokeventureConfig::GainExp
			      if type=="normal"
			           pbGainAventureExp(pk,enemy,1)
			      elsif type=="hard"
			           pbGainAventureExp(pk,enemy,2)
			      elsif type=="raid"
			           pbGainAventureExp(pk,enemy,3)
			      elsif type=="team"
			           pbGainAventureExp(pk,enemy,0.5)
			      end
					
				end
             end

			elsif decision==1
			   if !battler.is_a?(Array)
			     battler = [battler]
              end
			
			   battler.each do |pk|
			   pk.changeHappiness("faint",pk)
			   pk.changeLoyalty("faint",pk)
			   if pk.hp==0 && defined?(Nuzlocke.definedrules?) && Nuzlocke.on?
				 pk.permaFaint = true
			   end
			   end



			   chances = rand(256)
			   if pkmn.species != :SHAYMIN
			   if pkmn.happiness < 30 && pkmn.loyalty<75 && chances<=170
				 remove_pokemon_at_index(index2)
			   end
			   if pkmn.loyalty < 10 && chances<=270
				 remove_pokemon_at_index(index2)
			   end
			   end
              
           else

			end


 if !encounter.nil?
		@party.each do |pkmn|
			PokeventureConfig::pbAdventureAbilities(pkmn)
		end
		pkmn.who_fighting = nil
end
		
	end

def generateAlly(pkmn,encounter)
  return false if pkmn.travelingpartners.length>1
poke = Pokemon.new(encounter[0],encounter[1])
					poke.generateBrilliant if (PokeventureConfig::AreFoundFriendsBrilliant && defined?(poke.generateBrilliant))
					poke.name= nil
					poke.owner= Pokemon::Owner.new_from_trainer($player)
					if poke.loyalty.nil?
					    poke.loyalty = 70
					end
					poke.age = (rand(50)+1)
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
					pkmn.travelingpartners.append(poke)


  return true
end
def addAlly(pkmn,poke)
  return false if pkmn.travelingpartners.length>1
	poke.name= nil
	poke.owner= Pokemon::Owner.new_from_trainer($player)
	if poke.loyalty.nil?
		poke.loyalty = 70
	end
	poke.age = (rand(50)+1)
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
	pkmn.travelingpartners.append(poke)
  return true
end


def partyfainted?(battler)
 if battler.is_a? Array
   return battler[0].hp>0 && battler[1].hp>0
 else
   return battler.hp>0
 end

end


def can_choose_move?(pkmn,move)
  if move.pp == 0 && move.total_pp > 0
    return false
  end
  if pkmn.status == :FROZEN
    return false
  end
  if pkmn.status == :PARALYSIS
    return false
  end
  if pkmn.status == :SLEEP
    return false
  end
  return true
end




def chooseMove(attacker,target)
   $PokemonSystem.difficulty =  4 if $PokemonSystem.difficulty.nil?
   $PokemonSystem.difficultymodifier =  80 if $PokemonSystem.difficultymodifier.nil?
   skill=(($PokemonSystem.difficulty+1)*$PokemonSystem.difficultymodifier)+(rand(80)+1)	
   potato = []
   potato2 = []
   attacker.moves.each do |m|
      duris = get_ov_move_score(m,attacker,target,skill)
      if can_choose_move?(attacker,m)
      potato << duris
	  else
      potato << 0
	  end
   end

   attacker.moves2.each do |m|
      duris = get_ov_move_score(m,attacker.pokemon,target,skill)
      if can_choose_move?(attacker.pokemon,m)
      potato2 << duris
	  else
      potato2 << 0
	  end
   end
   if potato.empty?
      potato << 0
   end
   if potato2.empty?
      potato2 << 0
   end
   largest = potato.max
   largest2 = potato2.max
   largeroftwo = [largest,largest2].max
   if largeroftwo==0
    return false
   else
   max_index1 = [largest,largest2].index(largeroftwo)
    if max_index1==0
   max_index = potato.index(largest)
   return attacker.moves[max_index]
    else
   max_index = potato2.index(largest2)
   return attacker.moves2[max_index]
    end
   end

end




def get_ov_move_score(move,user,target,skill)
   # 1*40 = 40
   # 2*40 = 80
   # 3*40 = 120
   # 4*40 = 160
    score = 100
     if skill > 120
      # If user is asleep, prefer moves that are usable while asleep
      if user.status == :SLEEP && (move!=:SNORE||move!=:SLEEPTALK)
        user.moves.each do |m|
          next unless (m==:SNORE||m==:SLEEPTALK)
          score -= 60
          break
        end
      end
      # If user is frozen, prefer a move that can thaw the user
      if user.status == :FROZEN
        if move.flags.any? { |f| f[/^ThawsUser$/i] }
          score += 40
        else
          user.moves.each do |m|
            next unless m.flags.any? { |f| f[/^ThawsUser$/i] }
            score -= 60
            break
          end
        end
      end
      # If target is frozen, don't prefer moves that could thaw them
      if target.status == :FROZEN
        user.moves.each do |m|
          next if m.flags.any? { |f| f[/^ThawsUser$/i] }
          score -= 60
          break
        end
      end
	  
	   
	   if move.function_code.include?("SleepTarget")
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end

	   if move.function_code.include?("ParalyzeTarget" )
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end
	   
	   
	   if move.function_code.include?("PoisonTarget")
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end


	   
	   if move.function_code.include?("BurnTarget")
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end


	   
	   if move.function_code.include?("FreezeTarget")
	    if target.is_a?(Pokemon)
		  
		else
	      score += 40
		end
	   end


	   if move.function_code == "GiveUserStatusToTarget"
      if user.status == :NONE
        score -= 90
      else
        score += 40
	   end
	   end
	  end
     if skill > 160
	   	if move.function_code.include?("SwitchOut") 
	   score -= 100
	   end

	   if move.function_code == "TrapTargetInBattle"
	   score += 30
	   end
	   
	   if move.function_code == "PursueSwitchingFoe"
	   score += 80
	   end
	   

	  end
     if skill > 200
	 	if move.function_code == "RemoveTargetItem"
        score += 20 if target.item
	   end
	   if move.function_code == "DestroyTargetBerryOrGem"
	   score += 30
	   end
	   if move.function_code == "HealUserHalfOfTotalHP"
	    score+30
	   end

	   if move.function_code == "FixedDamage20"
	   score += 80 if !target.is_a?(Pokemon)
	   end
	   if move.function_code == "FixedDamage40"
	   score += 80 if !target.is_a?(Pokemon)
	   end
	   if move.function_code == "FixedDamageHalfTargetHP"
	   score += 80 if !target.is_a?(Pokemon)
	   end
	   if move.function_code == "FixedDamageUserLevel"
	   score += 80 if !target.is_a?(Pokemon)
	   end
	   


	  end

	   if move.function_code == "UserFaintsExplosive"
	    score -= user.hp * 100 / user.totalhp
	   end



        score -= 40 if move.category == 2
        score += 80 if move.category == 1
        score += 80 if move.category == 0
		get_ov_damage_score(score,move,user,target,skill)
		   value = Effectiveness.calculate(move.type, *target.types)
          score+=60 if Effectiveness.super_effective?(value)
          score=0 if Effectiveness.ineffective?(value)
          score-=60 if Effectiveness.not_very_effective?(value)
          score-=60 if Effectiveness.resistant?(value)

	   if move.function_code == "FleeFromBattle" 
	   score = 10
	   end

    score = score.to_i
	 if rand(2)==0
	score+= rand(30)
	 else
	score-= rand(30)
	 end
    score = 0 if score < 0
    return score

end

def get_ov_damage_score(score,move,user,target,skill)
	 atk = pbGetAttackStat2(user,move)
    dmg = ((move.base_damage+atk)/2).floor
    if move.function_code == "AttackAndSkipNextTurn"
	  dmg *= 2 / 3
	end
    damagePercentage = dmg * 100.0 / target.hp if target.is_a?(Pokemon)
    damagePercentage = dmg * 100.0 / $player.playerhealth if !target.is_a?(Pokemon)
	if target.is_a?(Pokemon)
    damagePercentage *= 1.2 if user.level - 10 > target.level
	else
    damagePercentage *= 1.2 if dmg - 10 > $player.equipmentdefbuff
	end
	if skill > 160
    damagePercentage = 120 if damagePercentage > 120   # Treat all lethal moves the same
    damagePercentage += 40 if damagePercentage > 100   # Prefer moves likely to be lethal
   end
    score += damagePercentage.to_i
    return score
end

def doesStatus?(move)
   return true if move.function_code.include?("SleepTarget") || move.function_code.include?("ParalyzeTarget") || move.function_code.include?("PoisonTarget") ||
   move.function_code.include?("BurnTarget") || move.function_code.include?("FreezeTarget") || move.function_code == "GiveUserStatusToTarget" || 
   move.function_code == "BindTarget"
   return false
end



def take_turn(attacker,target)
   move = chooseMove(attacker,target)
   accuracy   = move.accuracy
   accbonus = 0
   will_hit = rand(100) < (accuracy+accbonus)
   is_hitting(attacker,target,move) if will_hit

end

def is_hitting(attacker,target,move)
   thedamage = calcDamageAdventure(attacker,target,move,multiplier)
   applyStatus(move,attacker,target)
   target.hp-=thedamage
   target.hp = 0 if target.hp < 0
   useAutoReviveItem(target) if target.hp < 0
   useAutoItem(pkmn) if rand(2)==0
end

 def useAutoReviveItem(pkmn)
   if pkmn.inv_has?(:REVIVALHERB) && pkmn.hp<=0
        pkmn.inv_remove(:REVIVALHERB)
		 pkmn.hp=pkmn.totalhp
		 return
   end
   if pkmn.inv_has?(:MAXHONEY) && pkmn.hp<=0
        pkmn.inv_remove(:MAXHONEY)
		 pkmn.hp=pkmn.totalhp
		 return
   end
   if pkmn.inv_has?(:ARGOSTBERRY) && pkmn.hp<=0
        pkmn.inv_remove(:ARGOSTBERRY)
		 pkmn.hp=1
		 return
   end
   if pkmn.inv_has?(:ORANBERRY) && pkmn.hp<=pkmn.totalhp/4
        pkmn.inv_remove(:ORANBERRY)
		 pkmn.hp+=20
		 return
   end
   if pkmn.inv_has?(:SITRUSBERRY) && pkmn.hp<=pkmn.totalhp/2
        pkmn.inv_remove(:SITRUSBERRY)
		 pkmn.hp+=pkmn.totalhp/4
		 return
   end
 end

 def useAutoItem(pkmn)
   if pkmn.inv_has?(:ORANBERRY) && pkmn.hp<=pkmn.totalhp/4
        pkmn.inv_remove(:ORANBERRY)
		 pkmn.hp+=20
		 return
   end
   if pkmn.inv_has?(:SITRUSBERRY) && pkmn.hp<=pkmn.totalhp/2
        pkmn.inv_remove(:SITRUSBERRY)
		 pkmn.hp+=pkmn.totalhp/4
		 return
   end
 end

end





class Adventure  
    def choosePokemonforEvent	
		return nil,nil if @party.length==0
		pkmn = nil
		index = nil
		loop do
		  index = rand(@party.length)
		  pkmn = @party[index]
		  next if !pkmn.able?
		  next if pkmn.permadeath
		  next if pkmn.egg?
		  break
		end
		return pkmn,index
	end



	def ApprovedAdvMaps(pkmn)
	 puts pkmn.name
	 map_id = pkmn.location
	 pkmn.location = $game_map.map_id if pkmn.location.nil?
	 options = []
	 if !GameData::MapMetadata&.get(pkmn.location).outdoor_map
	   options << decide_new_location(map_id)

	 else
	 if pkmn.types.include?(:FLYING)
	   $map_factory.maps.each do |map|
	     next if !GameData::MapMetadata&.get(map).outdoor_map
	     next if !GameData::MapMetadata&.get(map).random_dungeon
	     next if map.name == "INTRO"
	     next if map.name == "Prologue"
	     next if map.name == "Transition Room"
	     next if map.name == "Test Map"
		 next if map.name.include?("(Folder)")
	     options << map
		  
	   end
	 elsif MapFactoryHelper.hasConnections?(map_id)
      MapFactoryHelper.eachConnectionForMap(map_id) { |conn|
	    if conn[0]==map_id
		 if pbLoadMapInfos[conn[3]].name.include?("Ocean") && !pkmn.types.include?(:WATER)
		 
		 elsif pbLoadMapInfos[conn[3]].name.include?("Skies") && !pkmn.types.include?(:FLYING)
		 
		 else
	     options << conn[3]
		 end
		end
      }
	 elsif !GameData::MapMetadata&.get(pkmn.location).outdoor_map
	    return 4
	 else
	    return 4
	 end
     end 
     nu_map = options[rand(options.length)]
     return nu_map
	end

   def decide_new_location(map_id)
     case map_id
	   when 10
	     return 4
	   when 12
	     return 9
	   when 63
	     return 58
	   when 14,20,32
	     return 16
	   when 31
	     potato64 = [29,17,24]
		 return potato64[rand(potato64.length)]
	   when 40
	     return 26
	   when 37
	     return 36
	   when 139
	     return 110
	   when 76
	     return 44
	   when 71
	     potato64 = [68,72]
		 return potato64[rand(potato64.length)]
	   when 87,88,89,90,91,92,93,94,95,96
	     return 80
	   when 97
	     return 85
	   when 100,99,98
	     return 82
	   when 143,141
	     return 137
	   when 214
	     return 238
	   else 
	     return 4
	 end
   
   
   
   
   end



   def IQEffects(pkmn,curAction) #IQ EFFECTS NEED AN OVERHAUL
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
    if pkmn.level!=oldlevel
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
			@party[pos].onAdventure = false
			$PokemonStorage.pbStoreCaught(@party[pos].dup)
			remove_pokemon_at_index(pos)
			return true
		end
	end
	def pbAddtoPCAlly(pkmn)
		if pbBoxesFull?
			pbMessage(_INTL("The Boxes on your PC are full!"))
			return false
		else
			pkmn.location = nil
			pkmn.onAdventure = false
			$PokemonStorage.pbStoreCaught(pkmn)
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

