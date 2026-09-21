#===============================================================================
# Berry Plant Genetics
#
# Replaces the flat pair-lookup mutation in checkNearbyPlantsForMutation
# (Settings::BERRY_MUTATION_POSSIBILITIES[[id1,id2]].sample) with real
# per-chromosome inheritance. Different chromosomes use different rules,
# by design, not by accident:
#
#   SPECIES  - Forestry-style: primary/secondary allele pair, each allele
#              tagged dominant or recessive on its own, active allele
#              resolved by the standard rule (dominant beats recessive;
#              two-of-a-kind is a coin flip). Mutation is checked once per
#              parent, each direction independently: that parent's own
#              primary species against the OTHER parent's secondary
#              species - not a single shared "these two together" lookup.
#
#   SEASON   - Same Forestry-style allele-pair treatment as Species, just
#              without a mutation step of its own (no "new season" concept
#              analogous to a new hybrid species) - it only goes through
#              Step 2 (inherit one allele from each parent).
#
#   GROWTH / RESISTANCE / GAIN - AgriCraft-style: a single number, no
#              allele pair, no dominance. Each has an independent chance to
#              tick up by 1 (capped) whenever breeding happens near enough
#              fully-grown neighbors. There's nothing to "resolve" because
#              there's only ever one value.
#
#   FLAVOR   - Only changes when a Species mutation actually succeeds (not
#              on every ordinary breeding tick, unlike Growth/Resistance/
#              Gain, and not every generation regardless of mutation,
#              unlike Season). Blends the two contributing parents' flavor
#              arrays: whatever both agree on gets reinforced ABOVE either
#              parent's own value; whatever differs bleeds through at a
#              fraction of its strength. A Dry parent bred with a
#              Dry-Sweet parent becomes MORE dry, and slightly sweet.
#
# Every constant marked PLACEHOLDER below is structurally correct but
# numerically invented - none of these are balance calls I can make.
#===============================================================================

module BerryGenetics
  # ---- dominance tables -----------------------------------------------------
  # PLACEHOLDER CONTENT. Dominance is a property of the specific value, not
  # derived from anything ("better = dominant" was explicitly rejected)-
  # every real species id and season value needs its own entry here.
  # Anything NOT listed defaults to recessive.

  SPECIES_DOMINANT = [
    # :EXAMPLESPECIES,   <- replace with real species ids
  ].freeze

  SEASON_DOMINANT = [
    # 0, 2,   <- replace with real season values (0-3)
  ].freeze

  CLIMATE_DOMINANT      = [].freeze  # PLACEHOLDER
  WEATHER_DOMINANT      = [].freeze  # PLACEHOLDER
  INHOSPITABLE_DOMINANT = [].freeze  # PLACEHOLDER

  # ---- flavor blend constants -----------------------------------------------
  # PLACEHOLDER. Tune so "slightly sweet" actually reads as slight, and so
  # repeated reinforcement doesn't rocket toward the cap in a couple of
  # generations.

  FLAVOR_SCALE     = 100
  FLAVOR_REINFORCE = 1.1
  FLAVOR_BLEED     = 0.3

  # ---- growth/resistance/gain increment constants ---------------------------
  # PLACEHOLDER. Base chance per breeding event; scaled up by nearby
  # fully-grown neighbors the same way AgriCraft's odds improve with more
  # parent plants present. STAT_CAP mirrors AgriCraft's 1-10 scale - change
  # if these traits are meant to live on a different range.
  
  SEASON_REROLL_CHANCE       = 0.10 
  CLIMATE_REROLL_CHANCE      = 0.10 
  WEATHER_REROLL_CHANCE      = 0.10
  INHOSPITABLE_REROLL_CHANCE = 0.10 
  GROWTH_INCREMENT_CHANCE     = 0.01
  RESISTANCE_INCREMENT_CHANCE = 0.10
  GAIN_INCREMENT_CHANCE       = 0.10
  QUALITY_INCREMENT_CHANCE    = 0.10
  NEIGHBOR_CHANCE_SCALE       = 0.5   # each extra grown neighbor adds this much of the base chance
  STAT_CAP                    = 10

  # Reused directly rather than reinvented - this is the same table the old
  # placeholder mutation system already used to know which species pairs
  # can mutate into what. Here it's the candidate list Step 1 checks
  # against, not the final sampled answer.
  MUTATION_TABLE = Settings::BERRY_MUTATION_POSSIBILITIES

  module_function

  # ---- allele resolution (Species, Season) -----------------------------------

  def dominant?(chromosome, value)
    case chromosome
    when :species then SPECIES_DOMINANT.include?(value)
    when :season   then SEASON_DOMINANT.include?(value)
    when :climate       then CLIMATE_DOMINANT.include?(value)
    when :weather       then WEATHER_DOMINANT.include?(value)
    when :inhospitable  then INHOSPITABLE_DOMINANT.include?(value)
    else false
    end
  end

  # The expressed (active) value for one chromosome, given its own
  # primary/secondary pair.
  def resolve_active(chromosome, primary, secondary)
    primary_dominant   = dominant?(chromosome, primary)
    secondary_dominant = dominant?(chromosome, secondary)
    return primary   if primary_dominant && !secondary_dominant
    return secondary if secondary_dominant && !primary_dominant
    return [primary, secondary].sample   # both dominant, or both recessive
  end

  # One random allele - primary or secondary - drawn from a single pair.
  # Used once per parent per chromosome during inheritance.
  def draw_allele(pair)
    pair.sample
  end

  def maybe_reroll_allele(own_primary, own_secondary, neighbor_primary, neighbor_secondary, base_chance, grown_neighbor_count)
   chance = base_chance * (1 + grown_neighbor_count * NEIGHBOR_CHANCE_SCALE)
    return [own_primary, own_secondary] if rand >= chance
   [draw_allele([own_primary, own_secondary]), draw_allele([neighbor_primary, neighbor_secondary])]
  end
  # ---- species mutation (Step 1) --------------------------------------------
  # Checks ONE direction: this parent's own primary species against the
  # OTHER parent's secondary species. Call this twice per breeding event -
  # once per parent, each in its own direction - since Forestry runs these
  # as two independent attempts, not one shared check.
  def check_species_mutation(own_primary_species, other_secondary_species)
    candidates = MUTATION_TABLE[[own_primary_species, other_secondary_species]] ||
                 MUTATION_TABLE[[other_secondary_species, own_primary_species]]
    return nil if !candidates || candidates.empty?

    # PLACEHOLDER: reuses the existing flat BERRY_BASE_MUTATION_CHANCE.
    # Real Forestry rolls a separate adjusted probability per candidate
    # mutation rather than one flat chance for the whole pool - worth
    # revisiting if some mutations should be rarer than others.
    return nil if rand(100) >= Settings::BERRY_BASE_MUTATION_CHANCE

    candidates.sample
  end

  # ---- flavor blend ---

  def blend_flavor(parent_a_flavor, parent_b_flavor)
    parent_a_flavor.each_index.map do |axis|
      shared = [parent_a_flavor[axis], parent_b_flavor[axis]].min
      unique = (parent_a_flavor[axis] - parent_b_flavor[axis]).abs
      value  = (shared * FLAVOR_REINFORCE) + (unique * FLAVOR_BLEED)
      value.clamp(0, FLAVOR_SCALE)
    end
  end

  # ---- growth/resistance/gain (no alleles, just a number with a chance to tick up) ---

  def maybe_increment(current_value, base_chance, grown_neighbor_count)
    chance = base_chance * (1 + grown_neighbor_count * NEIGHBOR_CHANCE_SCALE)
    return current_value if rand >= chance
    [current_value + 1, STAT_CAP].min
  end
  
  def maybe_decrement(current_value, base_chance, grown_neighbor_count)
    chance = base_chance * (1 + grown_neighbor_count * NEIGHBOR_CHANCE_SCALE)
    return current_value if rand >= chance
    [current_value - 1, 1].max
  end
  
  def maybe_increment_quality(cur_quality, base_chance, grown_neighbor_count, watered_count, moist)
   chance = base_chance * (1 + grown_neighbor_count * NEIGHBOR_CHANCE_SCALE)
   return cur_quality if rand >= chance
   max_value =  moist.max
   max_index = moist.index(max_value)
   quality_array = [1,0,-1,-2]
   quality = [[cur_quality + quality_array[max_index] + (watered_count / 2).to_i, 1].max,4].min
   return quality 
  end 
  
  
end


#===============================================================================
# BerryPlantData extensions
#
# Adds the actual genome fields (Species/Season allele pairs, flat Growth/
# Resistance/Gain values, Flavor array) and the breeding method that ties
# BerryGenetics together. Everything else on BerryPlantData - growth
# ticking, watering, pests, the existing checkNearbyPlantsForMutation
# gating (cropsticks, mulch, nearby_apiaries?) - is untouched; only the
# BODY of checkNearbyPlantsForMutation changes, replacing the old flat
# table sample with a real breeding call.
#===============================================================================

class BerryPlantData
  attr_accessor :species_primary, :species_secondary
  attr_accessor :season_primary, :season_secondary
  
  attr_accessor :inhospitable_primary, :inhospitable_secondary
  attr_accessor :weather_primary, :weather_secondary
  attr_accessor :climate_primary, :climate_secondary
  
  attr_accessor :growth_value, :resistance_value, :gain_value
  attr_accessor :flavor

  def active_species(new_primary, new_secondary)
    BerryGenetics.resolve_active(:species, new_primary, new_secondary)
  end

  def active_season(new_primary, new_secondary)
    BerryGenetics.resolve_active(:season, new_primary, new_secondary)
  end

  def active_climate(new_primary, new_secondary)
    BerryGenetics.resolve_active(:climate, new_primary, new_secondary)
  end

  def active_weather(new_primary, new_secondary)
    BerryGenetics.resolve_active(:weather, new_primary, new_secondary)
  end

  def active_inhospitable(new_primary, new_secondary)
    BerryGenetics.resolve_active(:inhospitable, new_primary, new_secondary)
  end
	

  # Seeds a fresh genome from the species template - a Pure Tree, matching
  # "all trees from the wild are purebred": both alleles identical, single
  # starting value on every flat stat. Call this from plant() alongside the
  # existing @preferred_weather/@preferred_season assignment.
  def seed_genome
    @species_primary   = @berry.stats.species[0]
    @species_secondary = @berry.stats.species[1]
    @season_primary    = @berry.stats.seasons[0]
    @season_secondary  = @berry.stats.seasons[1]
    @climate_primary   = @berry.stats.climates[0]
    @climate_secondary = @berry.stats.climates[1]
    @weather_primary    = @berry.stats.weathers[0]
    @weather_secondary  = @berry.stats.weathers[1]
    @inhospitable_primary    = @berry.stats.inhospitables[0]
    @inhospitable_secondary  = @berry.stats.inhospitables[1]
	
	
    @growth_value      = @berry.stats.growth
    @resistance_value  = @berry.stats.resistance
    @gain_value         = @berry.stats.gain
    @flavor             = @berry.stats.flavor.dup
    @quality         = @berry.stats.quality
  end

  def grown_neighbor_count
    pbGetNeighbors.count { |data| data.is_a?(BerryPlantData) && data.planted? && data.grown? }
  end
  

  
  # The actual breeding event: resolves Species (with its own mutation
  # check), Season, Growth/Resistance/Gain, and - only if a Species
  # mutation actually succeeded - Flavor. Returns true if a species
  # mutation occurred, so the caller can decide whether to surface
  # mutated_berry_info.
  def breed_genome_with(neighbor)
    mutated_self     = BerryGenetics.check_species_mutation(@species_primary, neighbor.species_secondary)
    mutated_neighbor = BerryGenetics.check_species_mutation(neighbor.species_primary, @species_secondary)
    species_mutated  = !mutated_self.nil? || !mutated_neighbor.nil?
    return nil unless species_mutated
	
    self_species_pair     = mutated_self     ? [mutated_self, mutated_self]     : [@species_primary, @species_secondary]
    neighbor_species_pair = mutated_neighbor ? [mutated_neighbor, mutated_neighbor] : [neighbor.species_primary, neighbor.species_secondary]

    new_species_primary   = BerryGenetics.draw_allele(self_species_pair)
    new_species_secondary = BerryGenetics.draw_allele(neighbor_species_pair)

    new_season_primary   = BerryGenetics.draw_allele([@season_primary, @season_secondary])
    new_season_secondary = BerryGenetics.draw_allele([neighbor.season_primary, neighbor.season_secondary])

    new_climate_primary   = BerryGenetics.draw_allele([@climate_primary, @climate_secondary])
    new_climate_secondary = BerryGenetics.draw_allele([neighbor.climate_primary, neighbor.climate_secondary])

    new_weather_primary   = BerryGenetics.draw_allele([@weather_primary, @weather_secondary])
    new_weather_secondary = BerryGenetics.draw_allele([neighbor.weather_primary, neighbor.weather_secondary])

    new_inhospitable_primary   = BerryGenetics.draw_allele([@inhospitable_primary, @inhospitable_secondary])
    new_inhospitable_secondary = BerryGenetics.draw_allele([neighbor.inhospitable_primary, neighbor.inhospitable_secondary])
	

	
    new_species = active_species(new_species_primary, new_species_secondary)
    new_season = active_season(new_season_primary, new_season_secondary)
    new_climate = active_climate(new_climate_primary, new_climate_secondary)
    new_weather = active_weather(new_weather_primary, new_weather_secondary)
    new_inhospitable = active_inhospitable(new_inhospitable_primary, new_inhospitable_secondary)
	
    mutated_berry = grow_berry(ItemData.new(new_species), neighbor)
    @mutated_berry_info = mutated_berry
    return mutated_berry
  end
  
  def grow_berry(growing_berry, neighbor)
    neighbors_grown = grown_neighbor_count
    growing_berry.stats.growth = BerryGenetics.maybe_decrement(@growth_value,     BerryGenetics::GROWTH_INCREMENT_CHANCE,     neighbors_grown)
    growing_berry.stats.resistance = BerryGenetics.maybe_increment(@resistance_value, BerryGenetics::RESISTANCE_INCREMENT_CHANCE, neighbors_grown)
    growing_berry.stats.gain = BerryGenetics.maybe_increment(@gain_value,       BerryGenetics::GAIN_INCREMENT_CHANCE,       neighbors_grown)
    growing_berry.stats.quality = BerryGenetics.maybe_increment_quality(@quality, BerryGenetics::QUALITY_INCREMENT_CHANCE, neighbors_grown, @watering_count, @times_in_each_moist)
    growing_berry.stats.flavor = BerryGenetics.blend_flavor(@flavor, neighbor.flavor)
	

    season_pair       = BerryGenetics.maybe_reroll_allele(@season_primary,       @season_secondary,       neighbor.season_primary,       neighbor.season_secondary,       BerryGenetics::SEASON_REROLL_CHANCE,       neighbors_grown)
    climate_pair      = BerryGenetics.maybe_reroll_allele(@climate_primary,      @climate_secondary,      neighbor.climate_primary,      neighbor.climate_secondary,      BerryGenetics::CLIMATE_REROLL_CHANCE,      neighbors_grown)
    weather_pair      = BerryGenetics.maybe_reroll_allele(@weather_primary,      @weather_secondary,      neighbor.weather_primary,      neighbor.weather_secondary,      BerryGenetics::WEATHER_REROLL_CHANCE,      neighbors_grown)
    inhospitable_pair = BerryGenetics.maybe_reroll_allele(@inhospitable_primary, @inhospitable_secondary, neighbor.inhospitable_primary, neighbor.inhospitable_secondary, BerryGenetics::INHOSPITABLE_REROLL_CHANCE, neighbors_grown)

    growing_berry.stats.seasons[0], growing_berry.stats.seasons[1]           = season_pair
    growing_berry.stats.climates[0], growing_berry.stats.climates[1]         = climate_pair
    growing_berry.stats.weathers[0], growing_berry.stats.weathers[1]         = weather_pair
    growing_berry.stats.inhospitables[0], growing_berry.stats.inhospitables[1] = inhospitable_pair

    growing_berry.stats.season       = BerryGenetics.resolve_active(:season, *season_pair)
    growing_berry.stats.climate      = BerryGenetics.resolve_active(:climate, *climate_pair)
    growing_berry.stats.weather      = BerryGenetics.resolve_active(:weather, *weather_pair)
    growing_berry.stats.inhospitable = BerryGenetics.resolve_active(:inhospitable, *inhospitable_pair)


	return growing_berry
  end 
  
  def resolve_berry
    if cropsticks==false
	   new_berry = @berry.dup 
	   new_berry.durability = new_berry.max_durability 
	   return new_berry
	end 
    neighbor = get_valid_neighbor
    if neighbor.nil?
	   new_berry = @berry.dup 
	   new_berry.durability = new_berry.max_durability 
	   return new_berry
	end 
	return unless cropsticks && neighbor
	new_berry = @berry.dup 
	new_berry.durability = new_berry.max_durability 
	return grow_berry(new_berry, neighbor)
  end 
  
  def get_valid_neighbor
    neighbors = pbGetNeighbors
    valid_neighbors = neighbors.select { |data| data.is_a?(BerryPlantData) && data.planted? }
    return nil if valid_neighbors.empty?
    return valid_neighbors.sample
  end 
  
end


#===============================================================================
# checkNearbyPlantsForMutation - replaced
#
# Everything above the neighbor search is untouched from the original:
# same cropsticks gate, same mulch/nearby_apiaries?-modified chance
# envelope, same overall "should a breeding attempt happen at all this
# tick" gate. Only what happens once a valid neighbor is found changes -
# it now calls into real genome inheritance instead of sampling a flat
# table.
#===============================================================================

class BerryPlantData
  def checkNearbyPlantsForMutation
    $PokemonGlobal.compilePlantMutationParents if !$PokemonGlobal.berry_plant_mutation_parents
    @mutated_berry_tried = true
    return if cropsticks==false
    return if !self.event || !$PokemonGlobal.berry_plant_mutation_parents.include?(@berry_id)
    mutation_chance = Settings::BERRY_MULCHES_IMPACTING_MUTATIONS[@mulch,id] || Settings::BERRY_BASE_MUTATION_CHANCE
    mutation_chance *= (1.0 + (nearby_apiaries? * 0.5))
    return if mutation_chance <= 0 || rand(100) >= mutation_chance

    neighbors = pbGetNeighbors
    valid_neighbors = neighbors.select { |data| data.is_a?(BerryPlantData) && data.planted? }
    return if valid_neighbors.empty?

    neighbor = valid_neighbors.sample
    breed_genome_with(neighbor)

  end
end
