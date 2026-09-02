class CraftingStationData
    attr_accessor :event_id
    attr_accessor :time_last_updated
    attr_accessor :time_active
    attr_accessor :fuel
	
	
    attr_accessor :reset
    attr_accessor :active
	
	
    attr_accessor :power
    attr_accessor :connected_to
    attr_accessor :time_running
    attr_accessor :network
    attr_reader :internal_storage


	
  def initialize(event_id)
    @event_id = event_id 
    @time_last_updated = pbGetTimeNow.to_i
    @time_active         = 0
	
    @reset = false
    @fuel = 0.0
    @active = false
	
    @power = 0
    @connected_to = nil
    @time_running       = 0
    @network = {}
    @internal_storage = [nil]
	@work_time = 0
	@work_done = 0.0
	@passed_time = 0
    @internal_storage = [nil] if spinner?
  end
  def internal_storage
   @internal_storage = [] if @internal_storage.nil?
   @internal_storage = [nil] if spinner?
   return @internal_storage
  end
  def work_time
   @work_time = 0 if @work_time.nil?
   return @work_time
  end
  def work_done
   @work_done = 0.0 if @work_done.nil?
   return @work_done
  end
  def passed_time
   @passed_time = 0 if @passed_time.nil?
   return @passed_time
  end
  def active
   @active = false if @active.nil?
   return @active
  end
  def crafting_data
    GameData::Recipe::DATA.values.select do |recipe|
       recipe.station.include?(item.id) && (!recipe.locked || $recipe_book.unlocked?(recipe.id))
    end
  end
  
  def decreaseStamina(worker_id, amt)
    worker = $game_map.events[worker_id]
	return unless worker
	pkmn = worker.pokemon
	return unless pkmn && pkmn.is_a?(Pokemon)
	pkmn.stamina = [pkmn.stamina - amt, 0].max
  end 
  
  def decrease_workers_stamina(amt = 1)
    return if amt == 0
    workers.each do |worker_id|
	  decreaseStamina(worker_id, amt)
	end 
  end 
  
  def still_me?
  end
  
  def event 
    $game_map.events[@event_id]
  end 
  
  def item
    event&.type
  end 
  
  def furnace?
    item&.id == :FURNACE
  end 
  def grinder?
    item&.id == :GRINDER
  end 
  def garbage_bin?
    item&.id == :GARBAGEBIN
  end 
  def warding_totem?
    item&.id == :WARDINGTOTEM
  end 
  def butchering_table?
    item&.id == :BUTCHERTABLE
  end 
  def composter?
    item&.id == :COMPOSTER
  end 

  def spinner?
    item&.id == :SILKSPINNER
  end  
  def electric?
    return false unless item 
    GameData::Placeable.get(item.id).needs_power
  end 
  
  def generator?
    return false unless item 
    GameData::Placeable.get(item.id).produces_power
  end 
  
  def fueled?
    @fuel > 0.0
  end 


  def update_grinder(time_delta)
    return if workers.empty?
    @current_recipe ||= get_recipe(recipe_slots)
    return unless @current_recipe
    return unless can_afford?(@current_recipe.recipe, recipe_slots)
	time = @current_recipe.time.to_f
	time = 2000.0 if time <= 0.0
	progress = workers.sum do |worker_id|
      event = $game_map.events[worker_id]
      next 0.0 unless event 
	  pokemon = event.pokemon
	  next 0.0 unless pokemon
      if pokemon.hasType?(:GROUND) || pokemon.hasType?(:ROCK)
        1.50
      else
        1.0
      end
    end
    @work_done += progress * time_delta * (100.0 / time)
	 event.grant_worker_exp(2)
	crafted = 0 
    while @work_done >= 100.0
     break unless can_afford?(@current_recipe.recipe, recipe_slots)
     remove_amounts(@current_recipe.recipe)
     craft(@current_recipe)
	 event.grant_worker_exp(100)
     @work_done -= 100.0
     @current_recipe = get_recipe(recipe_slots)
	 crafted += 1 
     break unless @current_recipe
    end
	decrease_workers_stamina(crafted) if crafted > 0
  end 
  
  def update_crafting(time_delta)
    return if workers.empty?
    @current_recipe ||= get_recipe(recipe_slots)
    return unless @current_recipe
    return unless can_afford?(@current_recipe.recipe, recipe_slots)
	time = @current_recipe.time.to_f
	time = 2000.0 if time <= 0.0
    @work_done += workers.length * time_delta * (100.0 / time)
	event.grant_worker_exp(2)
	puts "@work_done: #{@work_done}"
	crafted = 0 
    while @work_done >= 100.0
     break unless can_afford?(@current_recipe.recipe, recipe_slots)
     remove_amounts(@current_recipe.recipe)
     craft(@current_recipe)
     @work_done -= 100.0
	 event.grant_worker_exp(100)
     @current_recipe = get_recipe(recipe_slots)
	 crafted += 1 
     break unless @current_recipe
    end
	decrease_workers_stamina(crafted) if crafted > 0
  end 

  def update_furnace(time_delta)
    return if @fuel == 0.0
	@passed_time += time_delta
	amt = get_fuel_consumption
	event.grant_worker_exp(2)
	@work_done += amt * time_delta / 1800.0
	decrease = @work_done.round(10)
    @fuel = [@fuel - decrease, 0.0].max
    @work_done = 0.0
	@work_time = 0
    @passed_time %= 1800
  end  
  
  def update_spinner(time_delta)
    return if workers.empty?
    @work_done += workers.length * time_delta * (100.0 / 4000.0)
	event.grant_worker_exp(2)
	crafted = 0 
#	puts "@work_done: #{@work_done}"
    while @work_done >= 100.0
     @work_done -= 100.0
	 event.grant_worker_exp(100)
     itemdata = ItemData.new(:SILK)
     amt = 1
	 if result_slot && result_slot.is_a?(Array) && result_slot[0] && result_slot[0].identical(itemdata)
       result_slot[1] += amt
     else
      self.result_slot = [itemdata, amt]
     end
     crafted += 1
    end 
#	puts "crafted: #{crafted}"
#	puts "result_slot: #{result_slot.inspect}"
	decrease_workers_stamina(crafted) if crafted > 0
  end 
  def update_composter(time_delta)
    slot = recipe_slots[0]
	return unless slot && slot.is_a?(Array)
	placed_item = slot[0]
	return unless placed_item.data.is_berry?
	#puts placed_item
    if @internal_storage[0] && @internal_storage[0][1] > 0
     @internal_storage[0][1]-=1
	 @internal_storage[0] = nil if @internal_storage[0][1] <= 0
	#puts @work_done
	 @work_done += 1
	 return unless @work_done >= 10
     itemdata = ItemData.new(:FERTILIZERMIX)
     amt = 1
	 if result_slot && result_slot.is_a?(Array) && result_slot[0] && result_slot[0].identical(itemdata)
       result_slot[1] += amt
     else
      self.result_slot = [itemdata, amt]
     end
	 @work_done -= 10
    end 

  end  



  def update_warding_totem(time_delta)
    @passed_time += time_delta
	#puts @fuel
    while @passed_time >= 1800
     @passed_time -= 1800
     @fuel -= 1.0 if @fuel > 0.0
    end
    slot = recipe_slots[0]
	return unless slot && slot.is_a?(Array)
	if [:REPEL, :SUPERREPEL, :MAXREPEL].include?(slot[0].id)
	 amt = 2.0 if slot[0].id == :REPEL
	 amt = 8.0 if slot[0].id == :SUPERREPEL
	 amt = 16.0 if slot[0].id == :MAXREPEL
    if @internal_storage[0] && @internal_storage[0][1] > 0
     @internal_storage[0][1]-=1
	 @internal_storage[0] = nil if @internal_storage[0][1] <= 0
	 @fuel += amt
    end 
	end 
  end 

  def update_garbage_bin(time_delta)
    slot = recipe_slots[0]
	return unless slot && slot.is_a?(Array)
	placed_item = slot[0]
	#puts placed_item
    if @internal_storage[0] && @internal_storage[0][1] > 0
     @internal_storage[0][1]-=1
	 @internal_storage[0] = nil if @internal_storage[0][1] <= 0
	#puts @work_done
	 return if placed_item.id == :BLACKSLUDGE
	 @work_done += 1
	 return unless @work_done >= 10
     itemdata = ItemData.new(:BLACKSLUDGE)
     amt = 1
	 if result_slot && result_slot.is_a?(Array) && result_slot[0] && result_slot[0].identical(itemdata)
       result_slot[1] += amt
     else
      self.result_slot = [itemdata, amt]
     end
	 @work_done -= 10
    end 

  end 
  def update_butcher_table(time_delta)
    if result_slot && result_slot.is_a?(Pokemon)
	  pkmn = result_slot.dup
	  @internal_storage[-1] = nil
      food_item, amt = pbPrepareMeat(pkmn)
	  items = []
	  if food_item && amt && amt > 0
	    items << [food_item, amt]
	  end
      if pkmn.species == :SLOWPOKE
	    item = ItemData.new(:SLOWPOKETAIL)
		amt = 1
	    items << [item, amt]
	  #if $bag.add(:SLOWPOKETAIL,1)
		#itemAnim(:SLOWPOKETAIL,1) if !$game_temp.in_battle
	  #end
	  end 
	  if rand(12)==0
	    amt = rand(2)+1
        item = ItemData.new(:RAREBONE)
	    items << [item, amt]
		#if $bag.add(bone,geoiag)
		#  itemAnim(bone,geoiag) if !$game_temp.in_battle
		#end
	  end
	  if pkmn.types.include?(:ROCK)
	    amt = rand(2)+1
        item = ItemData.new(:STONE)
	    items << [item, amt]
	  
	  end 
	  if pkmn.types.include?(:STEEL)
	    amt = rand(2)+1
        item = ItemData.new(:IRON2)
	    items << [item, amt]
	  
	  end   
	  if pkmn.types.include?(:FLYING)
        feathers = [:PRETTYFEATHER, :PRETTYFEATHER, :PRETTYFEATHER, :HEALTHFEATHER, :HEALTHFEATHER, :HEALTHFEATHER, :HEALTHFEATHER, :MUSCLEFEATHER, :RESISTFEATHER, :GENIUSFEATHER, :CLEVERFEATHER, :SWIFTFEATHER] 
	    amt = rand(2)+1
	    item = ItemData.new(feathers.sample)
	    items << [item, amt]
	    
	  end 
	  if pkmn.wildHoldItems
       wildDrop = pkmn.wildHoldItems
       firstqty = rand(6)+1
       secondqty = rand(4)+1
       thirdqty = rand(2)+1
       droprnd = rand(100)

    chances = [ItemDropsConfig::Common_Item_Chance,ItemDropsConfig::Uncommon_Item_Chance,ItemDropsConfig::Rare_Item_Chance]
	bonus = 0
	if wildDrop[0] == wildDrop[1] && wildDrop[1] == wildDrop[2]
  	  item = wildDrop[0].sample
	  unless item.nil?
        item = GameData::Item.get(item)
		item = ItemData.new(item.id)
	    items << [item, firstqty]
	  end
	else
	  if droprnd < chances[0] + bonus
        item = wildDrop[0].sample
        unless item.nil?
         item = GameData::Item.get(item)
		 item = ItemData.new(item.id)
	     items << [item, firstqty]
        end
	  end

	  if droprnd < chances[1] + bonus
        item = wildDrop[1].sample
        unless item.nil?
         item = GameData::Item.get(item)
		 item = ItemData.new(item.id)
	     items << [item, secondqty]
        end
	  end

	  if droprnd < chances[2] + bonus
        item = wildDrop[2].sample
        unless item.nil?
         item = GameData::Item.get(item)
		 item = ItemData.new(item.id)
	     items << [item, thirdqty]
        end
	  end
	end

	  end 
	  if pkmn.poke_ball
	    item = pkmn.poke_ball.is_a?(Symbol) ? ItemData.new(pkmn.poke_ball) : pkmn.poke_ball
		amt = 1
	    items << [item, amt]
	  end 
	  raise if items.length > 8
      @internal_storage[0, items.length] = items
	  pkmn = nil
	end 
  end 
  def update
    @internal_storage = [] if @internal_storage.nil?
    time_now = pbGetTimeNow.to_i
    time_delta = time_now - @time_last_updated
    return if time_delta <= 0
	@work_time ||= 0
    @work_done ||= 0.0 
	@passed_time ||= 0
	@work_time += time_delta if workers.length > 0
	update_furnace(time_delta) if furnace?
	update_grinder(time_delta) if grinder?
	update_spinner(time_delta) if spinner?
	update_garbage_bin(time_delta) if garbage_bin?
	update_composter(time_delta) if composter?
	update_warding_totem(time_delta) if warding_totem?
	update_butcher_table(time_delta) if butchering_table?
    @time_last_updated = time_now
  end
  
  def refresh
    @time_last_updated = pbGetTimeNow.to_i
    @time_active         = 0
    @reset = false
    @fuel = 0.0
    @electronic = false
    @on = 0
    @power = 0
    @connected_to = nil
    @time_running       = 0
    @network = {}
  end 

  def collect_silk
    unless result_slot && result_slot.is_a?(Array) && result_slot[0].id == :SILK && result_slot[1] > 0
	  sideDisplay(_INTL("There is nothing to collect!"))
	  return
	end 
	item, quantity = result_slot
	if $bag.can_add?(item, quantity)
	 $bag.add(item, quantity)
	 itemAnim(item, quantity)
     itemname = (quantity > 1) ? item.name_plural : item.name
	 sideDisplay(_INTL("You collected {1} {2} from the Spinner.", quantity, itemname))
     self.result_slot = nil
	end 
  end 
 
  
    def craft(recipe)
     itemdata = ItemData.new(recipe.result[0])
	 set_max_durability(itemdata)
     apply_bottle_contents(itemdata)
     amt = recipe.yield
	 if result_slot && result_slot.is_a?(Array) && result_slot[0] && result_slot[0].identical(itemdata)
       result_slot[1] += amt
     else
      self.result_slot = [itemdata, amt]
     end
	end 
	
      def apply_bottle_contents(itemdata)
        bottle_entry = recipe_slots.each_with_index.find { |(item, _qty), _i| item && InventoryScene::Concerns::Craftable::BOTTLE_ITEMS.include?(item.id) }
        return unless bottle_entry

        bottle_item, = bottle_entry[0]
        bottle = InventoryScene::Concerns::Craftable::CONTAINER_ITEMS.include?(bottle_item.id) ? bottle_item : bottle_item.bottle
        itemdata.set_bottle(bottle) if bottle
      end

      def set_max_durability(item)
        item.max_durability = 10 if %i[WHITEFLUTE BLACKFLUTE].include?(item.id)
        item.max_durability = 25 if InventoryScene::Concerns::Craftable::CONTAINER_ITEMS.include?(item.id)
        item.durability = item.max_durability
      end
  
  
    
      def remove_amounts(recipe)
        return if recipe.empty?



        recipe.each do |item, qty_needed|
          remaining = qty_needed
          next if remaining <= 0

          while remaining > 0
          taken_any = false
		  
          recipe_slots.each_with_index do |inv_item, index|
            next unless inv_item && inv_item[0].id == item && inv_item[1] > 0

            inv_item[1] -= 1
            remaining -= 1
            taken_any = true
            break if remaining <= 0
          end
          break unless taken_any
		  end
        end




        recipe_slots.each_with_index { |inv_item, index| @internal_storage[index] = nil if inv_item && inv_item[1] <= 0 }
      end

      def normalize_ingredients(list)
        return [] if list.nil?

        list.filter_map do |entry|
          next if entry.nil?

          item, qty = entry.is_a?(Array) ? entry : [entry, 1]
          item = item.id if item.is_a?(ItemData)
          [item, qty || 1]
        end.sort_by { |item, qty| [item.to_s, qty] }
      end

      def get_recipe(ingredients)
        inventory = normalize_ingredients(ingredients)

        matches = crafting_data.select do |recipe|
          required = normalize_ingredients(recipe.recipe)
          required = required.reject { |item, _| item == :MACHINEBOX } if $player.is_it_this_class?(:ENGINEER, false)

          next false unless inventory.map(&:first).sort == required.map(&:first).sort
          next false unless inventory.size == required.size

          remaining = inventory.map(&:dup)
          required.all? do |req_item, req_qty|
            idx = remaining.index { |inv_item, inv_qty| inv_item == req_item && inv_qty >= req_qty }
            next false unless idx

            remaining.delete_at(idx)
            true
          end
        end
        return nil if matches.empty?
        return matches[0]
      end

      def can_afford?(recipe, ingredients)

        normalized_recipe = normalize_ingredients(recipe)
        normalized_inventory = normalize_ingredients(ingredients)

        normalized_recipe.all? do |item, qty|
          have = normalized_inventory.select { |inv_item, _| inv_item == item }.sum { |_, q| q }
          have >= qty
        end
      end

  
  def workers
    event.workers.current_workers 
  end 
  
  def heaters
    work_spots = [
    [event.x + 1, event.y],
    [event.x - 1, event.y],
    [event.x, event.y + 1],
    [event.x, event.y - 1]
     ]
  work_spots.filter_map do |x, y|
    event_id = $game_map.check_event(x, y)
    event = $game_map.events[event_id]

    next unless event.is_a?(Game_OVEvent)
    next unless [:FURNACE, :ELECTRICFURNACE, :COALGENERATOR].include?(event.type)

    event
  end
   
  end 
  

  
  def get_fuel_consumption
    amt = 1.0
    amt -= 0.20 * workers.length
    amt += 0.10 * heaters.length
    amt = [amt, 0.0].max
	return amt 
  end 
  
  def result_slot
    @internal_storage[-1]
  end 
  
  def result_slot=(value)
    @internal_storage[-1]=value
  end 
  
  def recipe_slots
    @internal_storage[0...-1]
  end 
  
end


class PetBedData
  attr_accessor :event_id
  attr_accessor :assigned_job   
  attr_accessor :resting_since  # for the breeding/hatch-speed system 
  attr_accessor :breeding 
  attr_accessor :reserved_for_egg 
  attr_accessor :egg 
  attr_accessor :started_working_at  
  FEATHERS = [:HEALTHFEATHER,:MUSCLEFEATHER,:RESISTFEATHER,:GENIUSFEATHER,:SWIFTFEATHER,:PRETTYFEATHER,:PRETTYFEATHER,:PRETTYFEATHER,:PRETTYFEATHER,:PRETTYFEATHER,:PRETTYFEATHER,:PRETTYFEATHER,:PRETTYFEATHER,:PRETTYFEATHER,:PRETTYFEATHER]
  HATCH_STEPS_PER_HOUR = 80.0
  MIN_BREEDING_DELAY = 3600
  MAX_BREEDING_DELAY = 28800
  def initialize(event_id)
    @event_id = event_id
    @pokemon_slot = [nil]
    @assigned_job = nil
    @resting_since = nil
    @try_breeding = nil
    @breeding_at = nil
	@partner_bed = nil 
	@baby_bed = nil
	@reserved_for_egg = false 
	@pokemon_is_egg = false 
	@bedtime = nil 
	@work_check = nil 
	@started_working_at = nil 
	@last_got_feather = pbGetTimeNow.to_i - 3600
  end
 
  def last_got_feather
	@last_got_feather = pbGetTimeNow.to_i - 3600 if @last_got_feather.nil?
	return @last_got_feather
  end  
  
  def workers
    event.workers.current_workers 
  end  
  
  def can_find_feather?
   return false unless pokemon
   return pokemon.species_data.egg_groups.include?(:Flying) && pbGetTimeNow.to_i - last_got_feather >= 3600 + rand(1600)
  end 
  
  def should_find_feather?
    can_find_feather? && rand(100) < 26
  end 
  
  def pick_feather
    item = ItemData.new(FEATHERS.sample)
    amt = rand(4)+1
    [item, amt]
  end 
  
  def give_feather
    return unless should_find_feather?
	item, quantity = pick_feather
	if $bag.can_add?(item, quantity)
	 $bag.add(item, quantity)
	 itemAnim(item, quantity)
     itemname = (quantity > 1) ? item.name_plural : item.name
	 sideDisplay(_INTL("{1} seems to have left {2} {3} in their bed.", pokemon.name, quantity, itemname))
	 @last_got_feather = pbGetTimeNow.to_i
	end 
  end 
  
  def remove_worker
    return if @assigned_job.nil?
    return if pokemon.nil?
	work_event.workers.remove(pokemon.associatedevent)
  end 
  
  def work_event
    $game_map.events[@assigned_job]
  end 
  
  def work_x
    return nil if work_event.nil?
    work_event.x
  end
  
  def work_y
    return nil if work_event.nil?
    work_event.y
  end 
  
  def work_name
    return "" if work_event.nil?
    work_event.station_name
  end 
  
  def breeding
    return !@partner_bed.nil? && !@baby_bed.nil?
  end 
  alias breeding? breeding 
  
  
  def reserved_for_egg
	@reserved_for_egg = false if @reserved_for_egg.nil?
    return @reserved_for_egg
  end 
  
  def set_baby_and_partner(baby, partner)
	@partner_bed = partner 
	@baby_bed = baby
  end 
  
  def event = $game_map.events[@event_id]
  def x = event.x 
  def y = event.y 
  def pokemon = @pokemon_slot[0]
  def pokemon_slot = @pokemon_slot
  
  
  def replace_pokemon(new_pokemon)
    spawned_event&.removeThisEventfromMap
    @pokemon_slot[0] = nil
    place_pokemon(new_pokemon)
  end 

  def place_pokemon(new_pokemon)
    return false unless new_pokemon
    return true if new_pokemon.equal?(pokemon) # already resting here

    if pbPlacePokemon(x, y, new_pokemon)
      @pokemon_slot[0] = new_pokemon
	  if new_pokemon.egg? 
      self.movement_type = :EGG 
	  @pokemon_is_egg = true 
	  else
      self.movement_type = :INBED 
	  end 
	  spawned_event.pet_bed = @event_id
	  @resting_since = pbGetTimeNow.to_i 
      return true
    else
      return false
    end
  end
  
  def egg?
    return false unless pokemon
	return pokemon.egg?
  end 
  
  def working?
    @assigned_job && spawned_event && !pokemon_in_bed? && spawned_event.movement_type == :WORKING
  end 
  
  def remove_pokemon
    remove_worker
    spawned_event&.removeThisEventfromMap
    @pokemon_slot[0] = nil
	cancel_assignment
  end

  def spawned_event
    return nil unless pokemon&.event
    pokemon.event 
  end
  
  def assigned_event
    $game_map.events[@assigned_job]
  end 
  
  def current_job
    assigned_event.type
  end 
  
  def job_data
    assigned_event.truetype.is_a?(ItemData) ? current_job.internal_data : assigned_event.type
  end 
  
  def pokemon_in_bed?
    return false unless spawned_event
    return spawned_event.x == x && spawned_event.y == y 
  end 
  
  def movement_type
    return nil unless pokemon
    return nil unless spawned_event
	return spawned_event.movement_type
  end 
  def movement_type=(value)
    return nil unless pokemon
    return nil unless spawned_event
	spawned_event.movement_type = value
  end 
  
  def can_heal?
    return pokemon_in_bed? && movement_type == :INBED && !breeding && spawned_event.sleeping?
  end 
  
  def researching?
    return false if current_job.id != :RESEARCHTABLE
	return job_data.researching?
  end 
  def fueled?
    return false if current_job.id != :FURNACE && current_job.id != :COALGENERATOR 
	return job_data.fueled?
  end 
  def planted?
    return false if current_job.id != :BERRYPOT && current_job.id != :BERRYPLANT 
	return job_data.planted?
  
  end 
  def workable?
	return !job_data.recipe_slots[0].nil? if current_job.id == :GRINDER
    return false 
  
  end 
  
  def should_go_to_work?
    return researching? if current_job.id == :RESEARCHTABLE
    return fueled? if current_job.id == :FURNACE || current_job.id == :COALGENERATOR 
	return planted? if current_job.id == :BERRYPOT || current_job.id == :BERRYPLANT 
	return workable? if current_job.id == :GRINDER
	return true 
  end 
  
  def nothing_to_nurture?
    return true if current_job.id != :PETBED && current_job.id != :PETBEDOUTDOOR
	return !job_data.worker_needed?
  end 
  
  def worker_needed?
    return true if self.pokemon && self.pokemon.egg?
	return false
  end 
   
  def cancel_assignment?
   return true if (current_job.id == :PETBED || current_job.id == :PETBEDOUTDOOR) && nothing_to_nurture?
   return false 
  end 
  
  def cancel_assignment
	self.assigned_job = nil
	@work_check = nil 
	@started_working_at = nil 
  end 
  
  def should_breed?
    return rand(100) < 69
  end 
  
  def breeding_opportunity
    time_now = pbGetTimeNow.to_i
    if @try_breeding.nil?
      @try_breeding = time_now + rand(MIN_BREEDING_DELAY..MAX_BREEDING_DELAY)
      return
    end

    return if time_now < @try_breeding
	@try_breeding = time_now + rand(MIN_BREEDING_DELAY..MAX_BREEDING_DELAY)
	
	return unless should_breed?
	$scene.spriteset.addUserAnimation(34,spawned_event.x,spawned_event.y,true,1)
    day_care = $PokemonGlobal.day_care
    pet_beds = $DynamicEvents.available_pet_beds(@event_id)
    return unless pet_beds.length>0
	empty_beds = $DynamicEvents.available_empty_pet_beds
    return unless empty_beds.length>0
	bed_for_egg = empty_beds.sample 
	
    possible_pairs = pet_beds.filter_map do |bed|
      bed_data = bed.type.internal_data
      other_pokemon = bed_data.pokemon

      compatibility = day_care.get_compatibility_between(pokemon, other_pokemon)
      next if compatibility == 0

      [bed, compatibility]
    end
	
    return if possible_pairs.empty?
	
	
	
    highest_compatibility = possible_pairs.map { |pair| pair[1] }.max
    possible_pairs.select! { |pair| pair[1] == highest_compatibility }
    bed = possible_pairs.min_by do |pair|
      bed_data = pair[0].type.internal_data
      (bed_data.x - x).abs + (bed_data.y - y).abs
    end 
	return unless bed 
	bed = bed[0]
    partner = bed.type.internal_data
    baby = bed_for_egg.type.internal_data
    baby.reserved_for_egg = true 
    partner.set_baby_and_partner(baby.event_id , @event_id)
    self.set_baby_and_partner(baby.event_id , partner.event_id )
	breeding_length = (rand(8)+1) * 3600
	@breeding_at = time_now + breeding_length
	$scene.spriteset.addUserAnimation(30,spawned_event.x,spawned_event.y,true,1)
	$scene.spriteset.addUserAnimation(30,partner.spawned_event.x,partner.spawned_event.y,true,1)
  end 
  
  def perform_breeding
    return if @breeding_at.nil?
    time_now = pbGetTimeNow.to_i
    return if time_now < @breeding_at
	
    partner_bed = $game_map.events[@partner_bed]
    baby_bed    = $game_map.events[@baby_bed]
  
    return unless partner_bed && baby_bed
	
	partner = partner_bed.type.internal_data
    baby    = baby_bed.type.internal_data
	egg = DayCare::EggGenerator.generate(self.pokemon, partner.pokemon)
	
	@try_breeding = time_now + rand(MIN_BREEDING_DELAY..MAX_BREEDING_DELAY)
	
	baby.place_pokemon(egg)
	$scene.spriteset.addUserAnimation(7,baby.spawned_event.x,baby.spawned_event.y,true,1)
	baby.end_breeding
	partner.end_breeding
	self.end_breeding
  end 
  
  def end_breeding
    @partner_bed = nil
    @baby_bed = nil
    @breeding_at = nil
    @reserved_for_egg = false 
  end

  def update_egg
     time_now = pbGetTimeNow.to_i 
     time_delta = time_now - @resting_since
     return if time_delta <= 0
	 
     hatch_multiplier = 1.0
	 
     workers.each do |worker_id|
       worker = $game_map.events[worker_id]
       next unless worker
       pokemon = worker.pokemon
       next unless pokemon

       hatch_multiplier += 0.10

       hatch_multiplier += 0.10 if pokemon.types.include?(:FIRE)

       if [:FLAMEBODY, :MAGMAARMOR, :STEAMENGINE].include?(pokemon.ability_id)
         hatch_multiplier += 0.20
       end
     end
     steps_increment = (time_delta * HATCH_STEPS_PER_HOUR / 3600.0).floor
     steps = (time_delta * HATCH_STEPS_PER_HOUR * hatch_multiplier / 3600.0).floor
	 
	 return if steps <= 0
	 
	 
	 event.grant_worker_exp(10)
     pokemon.steps_to_hatch -= steps
     pokemon.steps_to_hatch = 0 if pokemon.steps_to_hatch < 0
	 event.grant_worker_exp(1190) if pokemon.steps_to_hatch <= 0
     @resting_since += (steps_increment * 3600.0 / HATCH_STEPS_PER_HOUR).to_i
  end 
  
  def update_breeding
    return unless pokemon.female?
	unless breeding 
	 breeding_opportunity
	else 
	 perform_breeding
    end 
  end 
  
  def update_bedtime
    @bedtime = pbGetTimeNow.to_i if @bedtime.nil?
    time_now = pbGetTimeNow.to_i
    time_delta = time_now - @bedtime
    return if time_delta < 3600
	amt = (time_delta/3600).floor
	heal_BED(amt, pokemon)
	@bedtime += amt * 3600
  end 
  
  def update_job
    @work_check = pbGetTimeNow.to_i - 300 if @work_check.nil?
    time_now = pbGetTimeNow.to_i
    time_delta = time_now - @work_check
    return if time_delta < 300
	if spawned_event.started_working_at
	time_working = time_now - spawned_event.started_working_at
	if time_working >= 3600
      hours = (time_working / 3600).floor
	  pokemon.stamina = [pokemon.stamina - hours, 0].max
	  spawned_event.started_working_at = time_now
	end 
	end 
    self.movement_type==:INBED ? update_in_bed : update_working
	@work_check = time_now
  end 

  def update_in_bed
    stamina = pokemon.stamina
    
    return if stamina <= 0
	return if !should_go_to_work?
	
    chance = stamina * 100 / 7
    if PBDayNight.isDay? && stamina > 3
      chance *= 1.5
    elsif PBDayNight.isNight?
      chance *= 0.5
    end
    chance = [chance, 100].min
    self.movement_type = :MOVING_TO_WORK if rand(100) < chance

  end 
  
  def update_working
    return unless self.movement_type==:WORKING
    stamina = pokemon.stamina

    if stamina <= 0 || !should_go_to_work?
      self.movement_type = :MOVING_TO_BED
      return
    end


    chance = (7 - stamina) * 100 / 7
    if PBDayNight.isNight?
      chance *= 1.5
    elsif PBDayNight.isDay? && stamina > 3
      chance *= 0.5
    end

  chance = [chance, 100].min

    self.movement_type = :MOVING_TO_BED if rand(100) < chance
  end 
  
  
  def update
    return unless pokemon
	return if pokemon.fainted?
	if @pokemon_is_egg && !egg?
	 @pokemon_is_egg = false 
	 pokemon.play_cry
	 pokemon.name = nil
	 sideDisplay(_INTL("{1} hatched from the Egg!", pokemon.name))
     was_owned = $player.owned?(pokemon.species)
     $player.pokedex.register(pokemon)
     $player.pokedex.set_owned(pokemon.species)
     $player.pokedex.set_seen_egg(pokemon.species)
	 spawned_event&.update_pokemon_sprite
	end 
    if egg?
	 update_egg
	 return
	end 
	return if spawned_event.in_battle
	if can_heal?
	 update_bedtime
	 return
	else 
     @bedtime = nil 
	end 
	if @assigned_job && !spawned_event.sleeping? && !breeding#&& @assigned_job!=@event_id  This was intended to be 'assigned job is caring for egg' but that doesnt work.
	 if cancel_assignment?
	  cancel_assignment
	  return 
	 end 
	 update_job
	 return 
	end 
	#You cannot breed if you have a job assigned currently. Maybe I exclude this for Breeders.
	
	update_breeding
  end 
end

class BerryPotData
  attr_accessor :event_id 
  attr_accessor :berry
  attr_accessor :time_active
  attr_accessor :time_last_updated
  attr_accessor :growth_stage
  attr_accessor :moisture_level
  attr_accessor :yield_penalty
  def initialize(event_id)
    @event_id = event_id 
    reset
  end
  

  def reset(planting = false)
    @berry           = nil
    @time_alive         = 0
    @time_last_updated  = 0
    @growth_stage       = 0
    @moisture_level     = 100
    @yield_penalty      = 0
  end

  def plant(berry)
    reset(true)
    @berry          = berry
    @growth_stage      = 1
    @time_last_updated = pbGetTimeNow.to_i
  end
  def event = $game_map.events[@event_id]


  
  def moisture_stage
    return 2 if @moisture_level > 50
    return 1 if @moisture_level > 0
    return 0
  end

  def planted?
    return @growth_stage > 0
  end

  def growing?
    return @growth_stage > 0 && @growth_stage < 5
  end

  def grown?
    return @growth_stage >= 5
  end
  
  def water(amt = 100)
    @moisture_level = [@moisture_level+ amt, 100].min
  end
  
  def mulch_id
    nil
  end 
  

  def dead?
    false
  end 
  
  def berry_yield
    data = GameData::BerryPlant.get(@berry.id)
    ret = [data.maximum_yield * (5 - @yield_penalty) / 5, data.minimum_yield].max
	ret = [ret / 2, 1].max 
    return ret
  end 
  
  def workers
    event.workers.current_workers 
  end 
  def tending_multiplier
    1.0 + (workers.length * 0.25)
  end
  def update
   # puts "Berry Pot (#{event.id}) updating..."
    return if !planted?
	
	reset if @berry.id == :SPOILEDFOOD
	
    time_now = pbGetTimeNow
    time_delta = time_now.to_i - @time_last_updated
    return if time_delta <= 0
	
    plant_data = GameData::BerryPlant.get(@berry.id)
	
    new_time_alive = @time_alive + time_delta
	
    max_yield = plant_data.maximum_yield
    min_yield = plant_data.minimum_yield
    time_per_stage = ((plant_data.hours_per_stage * 3600) * 1.5).floor
	time_per_stage = (time_per_stage / tending_multiplier).floor
	
	
	event.grant_worker_exp(2)
	
    drying_per_hour = plant_data.drying_per_hour
    stages_growing = GameData::BerryPlant::NUMBER_OF_GROWTH_STAGES
    stages_fully_grown = GameData::BerryPlant::NUMBER_OF_FULLY_GROWN_STAGES
	
    old_growth_stage = @growth_stage
    @time_alive = new_time_alive
    @growth_stage = 1 + (@time_alive / time_per_stage)
    @time_last_updated = time_now.to_i
	
	
	
    old_growth_hour = (@time_alive - time_delta) / 3600
    new_growth_hour = @time_alive / 3600
    if new_growth_hour > old_growth_hour
        (new_growth_hour - old_growth_hour).times do
          if @moisture_level > 0
            @moisture_level -= drying_per_hour
          else
            @yield_penalty += 1
          end
        end
    end
	
	update_watering
    update_harvesting
  end
def update_watering
  return if @moisture_level >= 100
  time_now = pbGetTimeNow.to_i
  return if @watered_at && time_now - @watered_at < 3600
  workers.each do |worker_id|
    next if @moisture_level >= 100
    worker = $game_map.events[worker_id]
    next unless worker
    pokemon = worker&.pokemon
    next unless pokemon

    move = pokemon.moves.find do |move|
      move && move.type == :WATER && move.pp > 0
    end

    next unless move

    water(move.base_damage)
    move.pp -= 1
    pokemon.gain_exp_single(500)
    @watered_at = time_now
  end
end

def update_harvesting
  return unless grown?

  workers.each do |worker_id|
    worker = $game_map.events[worker_id]
    next unless worker
    pokemon = worker&.pokemon
    next unless @berry
    next unless pokemon
    next unless pokemon.types.include?(:GRASS)
	cur_yield = self.berry_yield
    next unless pokemon.inventory.can_add?(@berry, cur_yield)
   
    pokemon.inventory.add(@berry, cur_yield)
    pokemon.gain_exp_single(250)
    reset
	sideDisplay(_INTL("#{pokemon.name} has collected the harvest!"))
  end
end

end 


class BeehiveData
  attr_accessor :event_id 
  attr_reader :apiary
  attr_accessor :time_last_updated
  attr_accessor :queen
  attr_accessor :breeder
  attr_reader :comb
  attr_reader :frames
  attr_reader :internal_storage
  def initialize(event_id, apiary = false)
    @event_id = event_id
    @apiary = apiary
	@time_last_updated = pbGetTimeNow.to_i
	@queen = nil
	@breeder = nil
	@comb = Array.new(7)
	@frames = Array.new(3)
	@internal_storage = []
	@work_time = 0
	@work_done = 0.0
	@breeding_done = 0.0
  end 
  def event 
    $game_map.events[@event_id]
  end 
  def inspect_storage(storage)
  storage.map do |slot|
    next nil if slot.nil?

    if slot.is_a?(Array)
      item = slot[0]
      amount = slot[1]
      [item.name, amount]
    else
      slot
    end
  end
end
  def workers
    event.workers.current_workers 
  end 
  def update
   @breeding_done ||= 0.0
   @comb.map! { |slot| slot.is_a?(Array) && slot[1] == 0 ? nil : slot }
   @internal_storage.delete_if { |slot| slot.is_a?(Array) && slot[1] == 0 }
   @internal_storage.compact!
    time_now = pbGetTimeNow.to_i
    time_delta = time_now - @time_last_updated
    return if time_delta <= 0
	if Input.pressex?(:TAB)
     puts "@queen: #{@queen.inspect}"
     puts "@breeder: #{@breeder.inspect}"
	 puts "@comb: #{inspect_storage(@comb).inspect}"
     puts "@frames: #{inspect_storage(@frames).inspect}"
     puts "@internal_storage: #{inspect_storage(@internal_storage).inspect}"
	end 
   @apiary ? update_apiary(time_delta) : update_beehive(time_delta)
   update_breeding(time_delta)
   move_storage_to_comb
    @time_last_updated = time_now
   
   
  end 
  

  def breeding?
  @queen && @breeder
  end

  def kill(pkmn)
      food_item, amt = pbPrepareMeat(pkmn)
	  if food_item && amt && amt > 0
	    store_comb_result([food_item, amt]) if amt > 0 
	  end

	  if rand(12)==0
	    amt = rand(2)+1
        item = ItemData.new(:RAREBONE)
	    store_comb_result([item, amt]) if amt > 0 
		#if $bag.add(bone,geoiag)
		#  itemAnim(bone,geoiag) if !$game_temp.in_battle
		#end
	  end
	  if pkmn.types.include?(:ROCK)
	    amt = rand(2)+1
        item = ItemData.new(:STONE)
	    store_comb_result([item, amt]) if amt > 0 
	  
	  end 
	  if pkmn.types.include?(:STEEL)
	    amt = rand(2)+1
        item = ItemData.new(:IRON2)
	    @internal_storage << [item, amt] if amt > 0 
	  
	  end   
	  if pkmn.types.include?(:FLYING)
        feathers = [:PRETTYFEATHER, :PRETTYFEATHER, :PRETTYFEATHER, :HEALTHFEATHER, :HEALTHFEATHER, :HEALTHFEATHER, :HEALTHFEATHER, :MUSCLEFEATHER, :RESISTFEATHER, :GENIUSFEATHER, :CLEVERFEATHER, :SWIFTFEATHER] 
	    amt = rand(2)+1
	    item = ItemData.new(feathers.sample)
	    store_comb_result([item, amt]) if amt > 0 
	    
	  end 
	  if pkmn.wildHoldItems
       wildDrop = pkmn.wildHoldItems
       firstqty = rand(6)+1
       secondqty = rand(4)+1
       thirdqty = rand(2)+1
       droprnd = rand(100)

    chances = [ItemDropsConfig::Common_Item_Chance,ItemDropsConfig::Uncommon_Item_Chance,ItemDropsConfig::Rare_Item_Chance]
	bonus = 0
	if wildDrop[0] == wildDrop[1] && wildDrop[1] == wildDrop[2]
  	  item = wildDrop[0].sample
	  unless item.nil? || item == :HONEY
        item = GameData::Item.get(item)
		item = ItemData.new(item.id)
	    store_comb_result([item, firstqty]) if firstqty > 0 
	  end
	else
	  if droprnd < chances[0] + bonus
        item = wildDrop[0].sample
        unless item.nil? || item == :HONEY
         item = GameData::Item.get(item)
		 item = ItemData.new(item.id)
	     store_comb_result([item, firstqty]) if firstqty > 0 
        end
	  end

	  if droprnd < chances[1] + bonus
        item = wildDrop[1].sample
        unless item.nil? || item == :HONEY
         item = GameData::Item.get(item)
		 item = ItemData.new(item.id)
	     store_comb_result([item, secondqty]) if secondqty > 0 
        end 
	  end

	  if droprnd < chances[2] + bonus
        item = wildDrop[2].sample
        unless item.nil? || item == :HONEY
         item = GameData::Item.get(item)
		 item = ItemData.new(item.id)
	     store_comb_result([item, thirdqty]) if thirdqty > 0 
        end
	  end
	end

	  end 
	  if pkmn.poke_ball
	    item = pkmn.poke_ball.is_a?(Symbol) ? ItemData.new(pkmn.poke_ball) : pkmn.poke_ball
		amt = 1
	     store_comb_result([item, amt]) if amt > 0 
	  end 
  
  end 
  
  def kill_queen
    pkmn = @queen.dup
	@queen = nil
    kill(pkmn)
	pkmn = nil
  end 
  
  def kill_breeder
    pkmn = @breeder.dup
	@breeder = nil
    kill(pkmn)
	pkmn = nil
  
  end 
  

  def update_breeding(time_delta)
  unless breeding?
    @breeding_done = 0.0
    return
  end

  @breeding_done += time_delta * (100.0 / 6000.0)
  
  puts "@breeding_done: #{@breeding_done.inspect}"
  return unless @breeding_done >= 100

  @breeding_done = 0.0
  produce_offspring
  produce_product
  kill_queen
  kill_breeder
  
  end
  
  
  def produce_offspring
	mother = @queen
	father = @breeder
	princess = DayCare::EggGenerator.generate(mother, father, true, true)
	princess.makeFemale 
    store_comb_result(princess)
    rand(1..3).times do
	  pkmn = DayCare::EggGenerator.generate(mother, father, true)
	  pkmn.makeMale
      store_comb_result(pkmn)
    end
  end 
 

  def produce_product
    amt = rand(3)+1
	honeycomb = ItemData.new(:HONEYCOMB)
	amt.times do 
	 hc_amt = rand(8)+1
     store_comb_result([honeycomb, hc_amt])
    end 
  end  
  def store_comb_result(item)
  index = @comb.index(&:nil?)

  if index
    @comb[index] = item
  else
    @internal_storage << item
  end
  end  
  
 def move_storage_to_comb
  @comb.each_with_index do |slot, index|
    next unless slot.nil?
    break if @internal_storage.empty?

    @comb[index] = @internal_storage.shift
  end
end 


  def update_apiary(time_delta)
   return if @frames.all? { |frame| frame.nil? || frame.water >= 100 }
   return unless can_forage?

   @work_done += workers.length * time_delta * (100.0 / 3000.0)
   puts "@work_done: #{@work_done.inspect}"
   event.grant_worker_exp(2)
   if @work_done >= 100
     event.grant_worker_exp(100)
     fill_frames
     @work_done -= 100
   end
  end 
  def fill_frames
  amount = berry_plants.length

  @frames.each do |frame|
    next if frame.nil?
    next if frame.water >= 100

    amount_to_add = [amount, 100 - frame.water].min
    frame.water += amount_to_add
    amount -= amount_to_add

    break if amount <= 0
  end
  end




  def update_beehive(time_delta)
  end 
  
def can_forage?
  workers.any? && berry_plants.any?
end

def berry_plants
  $DynamicEvents.get_berry_plants(event.map_id).select do |plant|
    next false unless plant.planted?
    next false if plant.dead?
	
    dx = plant.x - event.x
    dy = plant.y - event.y
    dx * dx + dy * dy <= 25
  end
end

end 

def pbBerryPot(berryPot)
  item = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
 unless berryPot.planted?
  if item.is_a?(ItemData) && item.data.is_berry?
   if item.id != :ACORN
    $bag.remove(item, 1)
    berryPot.plant(item)
    sideDisplay(_INTL("#{item.name} has been planted here."))
    sideDisplay(_INTL("There is not enough room in the Pot for")) if item.id == :APPLE
    sideDisplay(_INTL("#{item.name} to produce usable wood.")) if item.id == :APPLE
	return 
   else 
    sideDisplay(_INTL("There is no enough room in the Pot for #{item.name}."))
   end 
  else
    sideDisplay(_INTL("The Pot is empty."))
	return 
  end
 end 
 berry = berryPot.berry
 if berryPot.grown?
  berryPot.reset if pbPickBerryPot(berry, berryPot.berry_yield)
  return 
 end 
 if berryPot.growing? 
   if item.is_a?(ItemData) && item.id == :SHOVEL
    sideDisplay(_INTL("You retrieve the Berry from the pot."))
    current_selection.decrease_durability(1)
    $bag.add(berryPot.berry, 1)
    reset
   else
    case berryPot.growth_stage
     when 1 
      sideDisplay(_INTL("#{berry.name} has been planted here."))
     when 2 
      sideDisplay(_INTL("#{berry.name} has sprouted."))
     when 3 
      sideDisplay(_INTL("#{berry.name} is growing bigger."))
     when 4 
      sideDisplay(_INTL("#{berry.name} is in bloom."))
    end 
   
   end 

 end 
end 

def pbPickBerryPot(berry, qty = 1)
  berry = GameData::Item.get(berry)
  berry_name = (qty > 1) ? berry.name_plural : berry.name
  if !$bag.can_add?(berry, qty)
    sideDisplay(_INTL("The Bag is full..."))
    return false
  end 
  $stats.berry_plants_picked += 1
  if qty >= GameData::BerryPlant.get(berry.id).maximum_yield
    $stats.max_yield_berry_plants += 1
  end
  $bag.add(berry, qty)
  if shouldAutoselectCrop?
	$PokemonGlobal.set_ball_hud_type(:ITEM,true)
	$PokemonGlobal.set_item_hud(:CROPS,true)
    new_index = $PokemonGlobal.ball_order.index do |item|
     item_id = item.is_a?(Symbol) || item.is_a?(String) ? item : item.id
     item_id == berry.id
    end
	unless new_index.nil?
     $PokemonGlobal.ball_hud_index = new_index  
     $PokemonGlobal.ball_hud_enabled = true
	end
  end 
  return true 
end 