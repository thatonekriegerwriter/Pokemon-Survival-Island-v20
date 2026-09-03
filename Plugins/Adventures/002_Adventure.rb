EventHandlers.add(:on_frame_update, :increase_adventuring_stage,
  proc {
    # Runs every frame now, unconditionally - battle simulation needs
    # fine-grained real-time deltas (CombatSimulation#update expects to
    # be called often), completely decoupled from the coarse ~30-minute
    # exploration tick below.
    $Adventure.update_active_battles

    next if pbGetTimeNow.to_i < $Adventure.last_check + $Adventure.timer
    $Adventure.party.each { |pkmn| pkmn.update if pkmn }
    $Adventure.adventuring
  }
)

class Adventure # Setup - unchanged
  attr_accessor :party
  attr_accessor :items
  attr_accessor :last_check
  attr_accessor :timer

  def initialize
    @items = []
    @party = []
    @timer = 1800
    @last_check = pbGetTimeNow.to_i
  end

  def last_check
    @last_check = pbGetTimeNow.to_i if @last_check.nil?
    @last_check
  end

  def timer
    @timer = 1800 if @timer.nil? || @timer.zero?
    @timer
  end
  
  def adventuring
    @last_check = pbGetTimeNow.to_i
    return if @party.compact.empty?

    birth_actions
    death_actions

    @party.each_with_index do |pkmn, index|
      next unless pkmn

      pkmn.steps_taken ||= 0
      next if !pkmn.able? || pkmn.permadeath || pkmn.egg? || pkmn.offscreen_fight

      pkmn.steps_taken += 1

      if pkmn.called_back
        advance_toward_home(pkmn)
      elsif pkmn.current_map != $game_map.map_id && pkmn.steps_taken >= PokeventureConfig::Updatesteps
        life_actions(pkmn, index)
      end
    end
  end

  # NOTE: dropped the original's auto-triggered `obtain_items` call here
  # (it fired on `location == current map && fighting`, which reads
  # backwards - obtaining items while AT HOME and mid-battle doesn't
  # match how collectionEncounters already adds directly to
  # pkmn.inventory while OUT exploring). Left the obtain_items/@items/
  # harvestItems machinery itself untouched since that's the player-
  # triggered manual harvest path, a separate system I wasn't asked to
  # touch - just removed what looked like a stray/incorrect auto-call.
  def life_actions(pkmn, index)
    pkmn.just_arrived = false if pkmn.wait_time.to_i.positive? && pkmn.just_arrived
    pkmn.wait_time -= 1 if pkmn.wait_time.to_i.positive?
    pbWalkingDowntheRoad(pkmn) if pkmn.wait_time.to_i.zero?
    pkmn.wait_time = rand(1000) + 1 if pkmn.just_arrived
    pbExplorersoftheIsland(pkmn, index) if !pkmn.just_arrived && pkmn.wait_time.to_i.positive?
    pkmn.steps_taken = 0
  end

  def pbWalkingDowntheRoad(pkmn)
    map_id = ApprovedAdvMaps(pkmn)
    pkmn.current_map = map_id if map_id
    pkmn.just_arrived = true
  end

  # Same as the original except the redundant unreachable tail
  # (`elsif !outdoor_map ... return 4 else return 4`, both branches
  # already covered earlier in the same if/elsif chain) is gone.
  def ApprovedAdvMaps(pkmn)
    map_id = pkmn.current_map
    pkmn.current_map = $game_map.map_id if pkmn.current_map.nil?
    options = []

    if !GameData::MapMetadata&.get(pkmn.current_map).outdoor_map
      options << decide_new_location(map_id)
    elsif pkmn.types.include?(:FLYING)
      $map_factory.maps.each do |map|
        next unless GameData::MapMetadata&.get(map).outdoor_map
        next unless GameData::MapMetadata&.get(map).random_dungeon
        next if %w[INTRO Prologue TransitionRoom TestMap].include?(map.name.gsub(" ", ""))
        next if map.name.include?("(Folder)")

        options << map
      end
    elsif MapFactoryHelper.hasConnections?(map_id)
      MapFactoryHelper.eachConnectionForMap(map_id) do |conn|
        next unless conn[0] == map_id
        next if pbLoadMapInfos[conn[3]].name.include?("Ocean") && !pkmn.types.include?(:WATER)
        next if pbLoadMapInfos[conn[3]].name.include?("Skies") && !pkmn.types.include?(:FLYING)

        options << conn[3]
      end
    else
      return 4
    end

    options[rand(options.length)]
  end

  def decide_new_location(map_id)
    case map_id
    when 10 then 4
    when 12 then 9
    when 63 then 58
    when 14, 20, 32 then 16
    when 31 then [29, 17, 24].sample
    when 40 then 26
    when 37 then 36
    when 139 then 110
    when 76 then 44
    when 71 then [68, 72].sample
    when 87, 88, 89, 90, 91, 92, 93, 94, 95, 96 then 80
    when 97 then 85
    when 100, 99, 98 then 82
    when 143, 141 then 137
    when 214 then 238
    else 4
    end
  end

  # NEW - the return trip. Travels the SAME connection graph as outbound
  # wandering (they're intrinsically the same roads), one hop per tick to
  # match the original's per-tick movement pacing, rather than the old
  # code's instant teleport home. Flying Pokemon skip the road entirely,
  # matching their outbound mobility (ApprovedAdvMaps already lets them
  # jump to any outdoor dungeon map directly).
  def advance_toward_home(pkmn)
    if pkmn.current_map == pkmn.called_back_map
      pkmn.called_back = nil
      pkmn.called_back_map = nil
      pkmn.just_arrived = true
      pkmn.wait_time = 0
      return
    end

    next_map = step_toward_map(pkmn, pkmn.called_back_map)
    pkmn.current_map = next_map if next_map
    pkmn.just_arrived = true
  end

  def step_toward_map(pkmn, target_map)
    if pkmn.types.include?(:FLYING) && GameData::MapMetadata&.get(target_map)&.outdoor_map
      return target_map
    end

    path = shortest_map_path(pkmn.current_map, target_map)
    return path.first unless path.empty?

    # No route found via the connection graph (e.g. current map has no
    # connection data at all) - fall back to the same hardcoded "toward
    # the outdoor world" table ApprovedAdvMaps already uses for the
    # outbound trip, then let pathfinding pick it up again next tick.
    fallback = decide_new_location(pkmn.current_map)
    return fallback if fallback && fallback != pkmn.current_map

    # Nothing worked - snap home rather than strand the Pokemon forever.
    # This is a safety valve, not confidently "correct" - if it's ever
    # actually hit, that means the graph has no path at all between
    # these two maps, which is worth knowing about on its own.
    target_map
  end

  def shortest_map_path(from_map, to_map)
    return [] if from_map == to_map

    visited = { from_map => true }
    queue = [[from_map, []]]
    until queue.empty?
      current, path = queue.shift
      connected_maps(current).each do |nxt|
        next if visited[nxt]

        new_path = path + [nxt]
        return new_path if nxt == to_map

        visited[nxt] = true
        queue << [nxt, new_path]
      end
    end
    []
  end

  def connected_maps(map_id)
    results = []
    return results unless MapFactoryHelper.hasConnections?(map_id)

    MapFactoryHelper.eachConnectionForMap(map_id) { |conn| results << conn[3] if conn[0] == map_id }
    results
  end

  def birth_actions
    @party.each do |egg|
      next unless egg
      next if egg.steps_to_hatch <= 0

      egg.steps_to_hatch -= 1
      @party.each do |p|
        next unless %i[FLAMEBODY MAGMAARMOR STEAMENGINE].include?(p.ability_id)

        egg.steps_to_hatch -= 1
        break
      end
      next if egg.steps_to_hatch.positive?

      egg.steps_to_hatch = 0
      egg.name = nil
      egg.owner = Pokemon::Owner.new_from_trainer($player)
      egg.age = 1
      egg.timeEggHatched = pbGetTimeNow
      egg.obtain_method = 1
      egg.hatched_map = egg.current_map
      $player.pokedex.register(egg)
      $player.pokedex.set_owned(egg.species)
      egg.record_first_moves
    end
  end

  def death_actions
    return unless $PokemonSystem.survivalmode == 0 && Nuzlocke.on? && pbIsWeekday(0)

    @party.each do |pkmn|
      next if pkmn.offscreen_fight
      next unless pkmn.hp == 0

      pkmn.hp = 0
      pkmn.permadeath = true
    end
  end
end

class Adventure # Battles - rewritten around CombatSimulation
  BATTLE_TICK_INTERVAL = 1 # seconds between simulation ticks - tune freely

  def update_active_battles
    now = pbGetTimeNow.to_i
    @last_battle_tick ||= now
    delta = now - @last_battle_tick
    return if delta < BATTLE_TICK_INTERVAL

    @last_battle_tick = now
    @party.each do |pkmn|
      sim = pkmn&.offscreen_fight
      next unless sim

      sim.update(delta)
      apply_battle_items(sim)
      resolve_battle(pkmn, sim) if sim.finished?
    end
  end

  def start_battle(pkmn, index, type = "normal")
    return if pkmn.offscreen_fight

    enctype = $PokemonEncounters.encounter_type_for_adventure(pkmn.current_map)
    return unless enctype

    encounter = $PokemonEncounters.choose_wild_pokemon_for_map(pkmn.current_map, enctype)
    return unless encounter

    allies = [pkmn]
    if type == "team"
      ally = pkmn.traveling_partners.reject(&:egg?).first
      return unless ally

      allies << ally
    end

    enemies = Array.new(type == "raid" ? 2 : 1) { Pokemon.new(encounter[0], encounter[1]) }

    pkmn.offscreen_fight = CombatSimulation.new(allies, enemies)
    pkmn.battle_type = type
    pkmn.battle_index = index
  end

  # Held-berry auto-heal/auto-revive, adapted to run BETWEEN simulation
  # ticks rather than per-hit (CombatSimulation doesn't expose a per-hit
  # callback, only batches of results per processed turn via
  # last_turn_results). Reads/writes the real Pokemon's inventory but
  # mutates the SIMULATED hp (ally.hp), not the real Pokemon's - the real
  # one only gets updated when the battle ends and apply_simulation runs.
  # This is a genuine adaptation, not a straight port - worth checking it
  # actually matches what you want (threshold points especially).
  def apply_battle_items(sim)
    sim.simulated_allies.each do |ally|
      pkmn = ally.object
      next unless pkmn.respond_to?(:inventory)

      if ally.hp <= 0
        use_auto_revive_item(pkmn, ally)
      elsif ally.hp <= ally.totalhp / 2
        use_auto_item(pkmn, ally)
      end
    end
  end

  def use_auto_revive_item(pkmn, ally)
    if pkmn.inventory.has?(:REVIVALHERB)
      pkmn.inventory.remove(:REVIVALHERB)
      ally.hp = ally.totalhp
    elsif pkmn.inventory.has?(:MAXHONEY)
      pkmn.inventory.remove(:MAXHONEY)
      ally.hp = ally.totalhp
    elsif pkmn.inventory.has?(:ARGOSTBERRY)
      pkmn.inventory.remove(:ARGOSTBERRY)
      ally.hp = 1
    end
  end

  def use_auto_item(pkmn, ally)
    if pkmn.inventory.has?(:ORANBERRY) && ally.hp <= ally.totalhp / 4
      pkmn.inventory.remove(:ORANBERRY)
      ally.heal(20)
    elsif pkmn.inventory.has?(:SITRUSBERRY) && ally.hp <= ally.totalhp / 2
      pkmn.inventory.remove(:SITRUSBERRY)
      ally.heal(ally.totalhp / 4)
    end
  end

  def resolve_battle(pkmn, sim)
    sim.apply_simulation
    won = !sim.enemies_alive?

    won ? handle_battle_win(pkmn, sim) : handle_battle_loss(pkmn, sim)

    # Dungeon runs are a short chain of battles - continue it on a win
    # instead of ending here, matching the original's loop-of-3.
    if won && pkmn.dungeon_battles_left.to_i > 1 && pkmn.hp.positive?
      pkmn.dungeon_battles_left -= 1
      pkmn.offscreen_fight = nil
      start_battle(pkmn, pkmn.battle_index, "normal")
      return
    end

    pkmn.dungeon_battles_left = nil
    pkmn.offscreen_fight = nil
  end

  def handle_battle_win(pkmn, sim)
    enemy = sim.simulated_enemies.first&.object
    return unless enemy

    collectItem(pkmn) if pkmn.dungeon_battles_left

    if PokeventureConfig::FindFriends && rand(PokeventureConfig::ChanceToFindFriend).zero? && pkmn.traveling_partners.length < 2
      enemy.hp = enemy.totalhp
      addAlly(pkmn, enemy)
    end

    if PokeventureConfig::CollectItemsFromBattles && rand(PokeventureConfig::ChanceToGetEnemyItem).zero?
      drops = enemy.wildHoldItems.compact
      addItem(pkmn, drops.sample) unless drops.empty?
    end

    gain = { "normal" => 1, "hard" => 2, "raid" => 3, "team" => 0.5 }[pkmn.battle_type] || 1
    [pkmn, *pkmn.traveling_partners.first(pkmn.battle_type == "team" ? 1 : 0)].each do |pk|
     pk.gain_exp_adventure(enemy, multiplier) if pk.able?
    end
  end

  def handle_battle_loss(pkmn, sim)
    pkmn.changeHappiness("faint", pkmn)
    pkmn.changeLoyalty("faint", pkmn)
    pkmn.permaFaint = true if pkmn.hp == 0 && defined?(Nuzlocke.definedrules?) && Nuzlocke.on?
    return if pkmn.species == :SHAYMIN

    chances = rand(256)
    remove_pokemon_at_index(pkmn.battle_index) if pkmn.happiness < 30 && pkmn.loyalty < 75 && chances <= 170
    remove_pokemon_at_index(pkmn.battle_index) if pkmn.loyalty < 10 && chances <= 270
  end
end

class Adventure # Encounters - IQ/chosenAdvType checks removed throughout, current_map rename
  def pbExplorersoftheIsland(pkmn, index)
    case rand(5)
    when 0 then collectionEncounters(pkmn, 12)
    when 1 then randomEncounters(pkmn)
    when 2 then battleEncounters(pkmn, index) if pkmn.hp != 0
    when 3 then collectionEncounters(pkmn, 6)
    when 4, 5 then battleEncounters(pkmn, index) if pkmn.hp != 0
    end
  end

  def collectionEncounters(pkmn, likelihood = nil)
    likelihood = rand(32) if likelihood.nil?
    case likelihood
    when 0, 3, 4, 5, 7, 8
      collectItem(pkmn)
    when 1
      enctype = $PokemonEncounters.encounter_type_for_adventure_eggs(pkmn.current_map)
      encounter = $PokemonEncounters.choose_wild_pokemon_for_map(pkmn.current_map, enctype)
      encounter = PokeventureConfig::EggList.sample if (enctype != :AdventureEggs && rand(2).zero?) || encounter.nil?
      pbGenerateWildEgg(encounter[0]) unless encounter.nil?
    when 2
      enctype = $PokemonEncounters.encounter_type_for_adventure(pkmn.current_map)
      encounter = $PokemonEncounters.choose_wild_pokemon_for_map(pkmn.current_map, enctype)
      generate_egg(pkmn, encounter)
    when 6
      next_encounter_for_ally(pkmn) if pkmn.traveling_partners.length < 2 && PokeventureConfig::FindFriends && rand(49).zero?
    end
  end



  def generate_egg(pkmn, encounter)
    return if encounter.nil? || encounter[0].nil?

    poke = Pokemon.new(encounter[0], encounter[1])
    if pkmn.male?
      poke.makeFemale
      mother, father = poke, pkmn
    elsif pkmn.female?
      poke.makeMale
      father, mother = poke, pkmn
    else
      return
    end
	egg = DayCare::EggGenerator.generate(mother, father)
    party[party.length] = egg unless party_full?
  end





  def next_encounter_for_ally(pkmn)
    enctype = $PokemonEncounters.encounter_type_for_adventure(pkmn.current_map)
    return unless enctype

    encounter = $PokemonEncounters.choose_wild_pokemon_for_map(pkmn.current_map, enctype)
    generateAlly(pkmn, encounter)
  end

  def battleEncounters(pkmn, index)
    return if pkmn.offscreen_fight

    case rand(23)
    when 0, 1, 2, 3, 11, 12, 13, 16 then start_battle(pkmn, index, "normal")
    when 4, 5, 14, 15 then start_battle(pkmn, index, "hard")
    when 6 then start_battle(pkmn, index, "raid")
    when 7, 17 then start_battle(pkmn, index, "team")
    when 8 then dungeon(pkmn, index)
    when 9 then pkmn.heal
    when 10
      endexp = pkmn.growth_rate.minimum_exp_for_level(pkmn.level + 1)
      pkmn.exp += endexp - pkmn.exp
    end
  end

  def dungeon(pkmn, index)
    return if pkmn.offscreen_fight

    pkmn.dungeon_battles_left = 3
    start_battle(pkmn, index, "normal")
  end

  def randomEncounters(pkmn)
    rarer = rand(999)
    case rand(21)
    when 1
      next if !GameData::MapMetadata.get(pkmn.current_map.to_i).outdoor_map || rarer > 10

      [pkmn, *pkmn.traveling_partners].each do |p|
        next unless p.hue.zero?

        p.hue = rand(360)
        p.memento = :LOSTMARK
      end
    when 3
      [pkmn, *pkmn.traveling_partners].each do |p|
        p.hp += p.totalhp / 4
        p.hp = p.totalhp if p.hp > p.totalhp
      end
    when 4
      pkmn.makeShadow if GameData::MapMetadata.get(pkmn.current_map.to_i).outdoor_map && rarer.zero?
    end
  end

  def collectItem(pkmn)
    item = pbGetItem(pkmn)
    pkmn.inventory.add(item, 1) if pkmn.inventory.can_add?(item, 1)
  end

  def addItem(pkmn, item)
    pkmn.inventory.add(item, 1) if pkmn.inventory.can_add?(item, 1)
  end
end





	def pbGetItem(pkmn)
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
	def pbGenerateWildEgg(pkmn)
		return false if !pkmn || party_full?
		pkmn = Pokemon.new(pkmn, Settings::EGG_LEVEL) if !pkmn.is_a?(Pokemon)
		# Set egg's details
		pkmn.name           = _INTL("Egg")
		pkmn.steps_to_hatch = pkmn.species_data.hatch_steps
		pkmn.obtain_text    = "Found on an adventure"
		pkmn.age = 1
		pkmn.calc_stats
		pkmn.generateBrilliant if (PokeventureConfig::AreFoundFriendsBrilliant && defined?(poke.generateBrilliant))
		# Add egg to party
		party[party.length] = pkmn
		return true
	end

	








class Adventure

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
  def pokemon_party
    return @party.find_all { |p| p && !p.egg? }
  end

  def able_party
    return @party.find_all { |p| p && !p.egg? && !p.fainted? }
  end

  def party_count
    return @party.length
  end
	def able_pokemon_count
		ret = 0
		@party.each { |p| ret += 1 if p && !p.egg? && !p.fainted? }
		return ret
	end
	def add_pokemon(pkmn)
		@party.append(pkmn)
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
			@party[pos].on_adventure = false
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
			pkmn.on_adventure = false
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