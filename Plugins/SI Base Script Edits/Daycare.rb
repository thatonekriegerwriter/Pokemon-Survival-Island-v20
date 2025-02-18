class DayCare
  #=============================================================================
  # Code that generates an egg based on two given Pokémon.
  #=============================================================================
  module EggGenerator
    module_function

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

    
    def egg_species_from_item(babyspecies, mother_item, father_item)
      egg_species = Settings::EGG_SPECIES_ITEM[babyspecies]
      return babyspecies if !egg_species
      egg_species.keys.each do |key|
        if [mother_item, father_item].include?(egg_species[key]) 
          babyspecies = key if GameData::Species.exists?(key)
        end
      end
      return babyspecies
    end
    


    def determine_egg_species(parent_species, mother, father)
      ret = GameData::Species.get(parent_species).get_baby_species(true, mother.item_id, father.item_id)
      offspring = GameData::Species.get(ret).offspring
      ret = offspring.sample if offspring.length > 0
      ret = egg_species_from_item(ret, mother.item_id, father.item_id)
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
      if species_parent.species_data.has_flag?("InheritFormFromMother")
        egg.form = species_parent.form
      end
      species_parent.species_data.flags.each do |flag|
        egg.form = $~[1].to_i if flag[/^InheritForm_(\d+)$/i]
      end
      [mother, father].each do |parent|
        next if !parent[2]
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

  #=============================================================================
  # A slot in the Day Care, which can contain a Pokémon.
  #=============================================================================
  class DayCareSlot
    attr_reader :pokemon

    def initialize
      reset
    end

    def reset
      @pokemon = nil
      @initial_level = 0
    end

    def deposit(pkmn)
      @pokemon = pkmn
      @pokemon.heal
      @pokemon.form = 0 if @pokemon.isSpecies?(:SHAYMIN)
      @initial_level = pkmn.level
    end

    def filled?
      return !@pokemon.nil?
    end

    def pokemon_name
      return (filled?) ? @pokemon.name : ""
    end

    def level_gain
      return (filled?) ? @pokemon.level - @initial_level : 0
    end

    def cost
      return (level_gain + 1) * 100
    end

    def choice_text
      return nil if !filled?
      if @pokemon.male?
        return _INTL("{1} (♂, Lv.{2})", @pokemon.name, @pokemon.level)
      elsif @pokemon.female?
        return _INTL("{1} (♀, Lv.{2})", @pokemon.name, @pokemon.level)
      end
      return _INTL("{1} (Lv.{2})", @pokemon.name, @pokemon.level)
    end

    def add_exp(amount = 1)
      return if !filled?
      max_exp = @pokemon.growth_rate.maximum_exp
      return if @pokemon.exp >= max_exp
      old_level = @pokemon.level
      @pokemon.exp += amount
      return if @pokemon.level == old_level
      @pokemon.calc_stats
      move_list = @pokemon.getMoveList
      move_list.each { |move| @pokemon.learn_move(move[1]) if move[0] == @pokemon.level }
    end
  end

  #=============================================================================

  attr_reader   :slots
  attr_accessor :egg_generated
  attr_accessor :step_counter
  attr_accessor :gain_exp
  attr_accessor :share_egg_moves   # For deposited Pokémon of the same species

  MAX_SLOTS = 2

  def initialize
    @slots = []
    MAX_SLOTS.times { @slots.push(DayCareSlot.new) }
    reset_egg_counters
    @gain_exp = Settings::DAY_CARE_POKEMON_GAIN_EXP_FROM_WALKING
    @share_egg_moves = Settings::DAY_CARE_POKEMON_CAN_SHARE_EGG_MOVES
  end

  def [](index)
    return @slots[index]
  end

  def reset_egg_counters
    @egg_generated = false
    @step_counter = 0
  end

  def count
    return @slots.select { |slot| slot.filled? }.length
  end

  def get_compatibility
    return compatibility
  end
  def get_compatibility2(pkmn1,pkmn2)
    return compatibility([pkmn1,pkmn2])
  end
  def generate_egg
    return nil if self.count != 2
    pkmn1, pkmn2 = pokemon_pair
    return EggGenerator.generate(pkmn1, pkmn2)
  end

  def share_egg_move
    return if count != 2
    pkmn1, pkmn2 = pokemon_pair
    return if pkmn1.species != pkmn2.species
    egg_moves1 = pkmn1.species_data.get_egg_moves
    egg_moves2 = pkmn2.species_data.get_egg_moves
    known_moves1 = []
    known_moves2 = []
    if pkmn2.numMoves < Pokemon::MAX_MOVES
      pkmn1.moves.each { |m| known_moves1.push(m.id) if egg_moves2.include?(m.id) && !pkmn2.hasMove?(m.id) }
    end
    if pkmn1.numMoves < Pokemon::MAX_MOVES
      pkmn2.moves.each { |m| known_moves2.push(m.id) if egg_moves1.include?(m.id) && !pkmn1.hasMove?(m.id) }
    end
    if !known_moves1.empty?
      if known_moves2.empty?
        pkmn2.learn_move(known_moves1[0])
      else
        learner = [[pkmn1, known_moves2[0]], [pkmn2, known_moves1[0]]].sample
        learner[0].learn_move(learner[1])
      end
    elsif !known_moves2.empty?
      pkmn1.learn_move(known_moves2[0])
    end
  end

  def update_on_step_taken
    @step_counter += 1
    if @step_counter >= 256
      @step_counter = 0
      # Make an egg available at the Day Care
      if !@egg_generated && count == 2
        compat = compatibility
        egg_chance = [0, 20, 50, 70][compat]
   egg_chance += 10 if $bag.has?(:OVALCHARM) && compat>0
   egg_chance += 10 if $player.is_it_this_class?(:BREEDER) && compat>0
   egg_chance += 10 if $player.is_it_this_class?(:BREEDER) && $bag.has?(:OVALCHARM) && compat>0
   egg_chance += 1 if $player.is_it_this_class?(:BREEDER) && $bag.has?(:OVALCHARM) && compat==0
		 
        @egg_generated = true if rand(100) < egg_chance
      end
      if @egg_generated == true
        egg = day_care.generate_egg
        raise _INTL("Couldn't generate the egg.") if egg.nil?
      end 
      # Have one deposited Pokémon learn an egg move from the other
      # NOTE: I don't know what the chance of this happening is.
      share_egg_move if @share_egg_moves && rand(100) < 50
    end
    # Day Care Pokémon gain Exp/moves
    if @gain_exp
      @slots.each { |slot| slot.add_exp }
    end
  end

  #=============================================================================

  def self.count
    return $PokemonGlobal.day_care.count
  end

  def self.egg_generated?
    return $PokemonGlobal.day_care.egg_generated
  end

  def self.reset_egg_counters
    $PokemonGlobal.day_care.reset_egg_counters
  end

  def self.get_details(index, name_var, cost_var)
    day_care = $PokemonGlobal.day_care
    $game_variables[name_var] = day_care[index].pokemon_name if name_var > 0
    $game_variables[cost_var] = day_care[index].cost if cost_var > 0
  end

  def self.get_level_gain(index, name_var, level_var)
    day_care = $PokemonGlobal.day_care
    $game_variables[name_var] = day_care[index].pokemon_name if name_var > 0
    $game_variables[level_var] = day_care[index].level_gain if level_var > 0
  end

  def self.get_compatibility(compat_var)
    $game_variables[compat_var] = $PokemonGlobal.day_care.get_compatibility if compat_var > 0
  end

  def self.deposit(party_index)
    $stats.day_care_deposits += 1
    day_care = $PokemonGlobal.day_care
    pkmn = $player.party[party_index]
    raise _INTL("No Pokémon at index {1} in party.", party_index) if pkmn.nil?
    day_care.slots.each do |slot|
      next if slot.filled?
      slot.deposit(pkmn)
      $player.party.delete_at(party_index)
      day_care.reset_egg_counters
      return
    end
    raise _INTL("No room to deposit a Pokémon.")
  end

  def self.withdraw(index)
    day_care = $PokemonGlobal.day_care
    slot = day_care[index]
    if !slot.filled?
      raise _INTL("No Pokémon found in slot {1}.", index)
    elsif $player.party_full?
      raise _INTL("No room in party for Pokémon.")
    end
    $stats.day_care_levels_gained += slot.level_gain
    $player.party.push(slot.pokemon)
    slot.reset
    day_care.reset_egg_counters
  end

  def self.choose(message, choice_var)
    day_care = $PokemonGlobal.day_care
    case day_care.count
    when 0
      raise _INTL("No Pokémon found in Day Care to choose from.")
    when 1
      day_care.slots.each_with_index { |slot, i| $game_variables[choice_var] = i if slot.filled? }
    else
      commands = []
      indices = []
      day_care.slots.each_with_index do |slot, i|
        choice_text = slot.choice_text
        next if !choice_text
        commands.push(choice_text)
        indices.push(i)
      end
      commands.push(_INTL("CANCEL"))
      command = pbMessage(message, commands, commands.length)
      $game_variables[choice_var] = (command == commands.length - 1) ? -1 : indices[command]
    end
  end

  def self.collect_egg
    day_care = $PokemonGlobal.day_care
    egg = day_care.generate_egg
    raise _INTL("Couldn't generate the egg.") if egg.nil?
    raise _INTL("No room in party for egg.") if $player.party_full?
    $player.party.push(egg)
    day_care.reset_egg_counters
  end

  #=============================================================================

  private

  def pokemon_pair
    pkmn1 = nil
    pkmn2 = nil
    @slots.each do |slot|
      next if !slot.filled?
      if pkmn1.nil?
        pkmn1 = slot.pokemon
      else
        pkmn2 = slot.pokemon
      end
    end
    raise _INTL("Couldn't find 2 deposited Pokémon.") if pkmn2.nil?
    return pkmn1, pkmn2
  end

  def pokemon_in_ditto_egg_group?(pkmn)
    return pkmn.species_data.egg_groups.include?(:Ditto)
  end

  def compatible_gender?(pkmn1, pkmn2)
    return true if pkmn1.female? && pkmn2.male?
    return true if pkmn1.male? && pkmn2.female?
    ditto1 = pokemon_in_ditto_egg_group?(pkmn1)
    ditto2 = pokemon_in_ditto_egg_group?(pkmn2)
    return true if ditto1 && !ditto2
    return true if ditto2 && !ditto1
    return false
  end

  def compatibility(pkmn = [])
    if pkmn.length == 2
      pkmn1, pkmn2 = pkmn[0], pkmn[1]
    else
      return 0 if self.count != 2
      pkmn1, pkmn2 = pokemon_pair
    end
    return 0 if pkmn1.shadowPokemon? || pkmn2.shadowPokemon?
    return 0 if pkmn1.celestial? || pkmn2.celestial?
    egg_groups1 = pkmn1.species_data.egg_groups
    egg_groups2 = pkmn2.species_data.egg_groups
    return 0 if egg_groups1.include?(:Undiscovered) || egg_groups2.include?(:Undiscovered)
    return 0 if egg_groups1.include?(:Ditto) && legendary_egg_group?(egg_groups2)
    return 0 if egg_groups2.include?(:Ditto) && legendary_egg_group?(egg_groups1)
    return 0 if egg_groups1.include?(:Ancestor) && egg_groups2.include?(:Ultra)
    return 0 if egg_groups1.include?(:Ultra)    && egg_groups2.include?(:Ancestor)
    return 0 if !fluid_egg_group?(egg_groups1 + egg_groups2) && (egg_groups1 & egg_groups2).length == 0
    return 0 if !compatible_gender?(pkmn1, pkmn2)
    ret = 1
    ret += 1 if pkmn1.species == pkmn2.species
    ret += 1 if pkmn1.owner.id != pkmn2.owner.id
    return ret
  end



end

#===============================================================================
# With each step taken, add Exp to Pokémon in the Day Care and try to generate
# an egg.
#===============================================================================
EventHandlers.add(:on_player_step_taken, :update_day_care,
  proc {
    $PokemonGlobal.day_care.update_on_step_taken
  }
)


#===============================================================================
# * Egg Hatch Animation - by FL (Credits will be apreciated)
#                         Tweaked by Maruno
#===============================================================================
# This script is for Pokémon Essentials. It's an egg hatch animation that
# works even with special eggs like Manaphy egg.
#===============================================================================
# To this script works, put it above Main and put a picture (a 5 frames
# sprite sheet) with egg sprite height and 5 times the egg sprite width at
# Graphics/Battlers/eggCracks.
#===============================================================================
class PokemonEggHatch_Scene
  def pbStartScene(pokemon)
    @sprites = {}
    @pokemon = pokemon
    @nicknamed = false
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    # Create background image
    addBackgroundOrColoredPlane(@sprites, "background", "hatchbg",
                                Color.new(248, 248, 248), @viewport)
    # Create egg sprite/Pokémon sprite
    @sprites["pokemon"] = PokemonSprite.new(@viewport)
    @sprites["pokemon"].setOffset(PictureOrigin::BOTTOM)
    @sprites["pokemon"].x = Graphics.width / 2
    @sprites["pokemon"].y = 264 + 56   # 56 to offset the egg sprite
    @sprites["pokemon"].setSpeciesBitmap(@pokemon.species, @pokemon.gender,
                                         @pokemon.form, @pokemon.shiny?,
                                         false, false, true)   # Egg sprite
    # Load egg cracks bitmap
    crackfilename = sprintf("Graphics/Pokemon/Eggs/%s_cracks", @pokemon.species)
    crackfilename = sprintf("Graphics/Pokemon/Eggs/000_cracks") if !pbResolveBitmap(crackfilename)
    crackfilename = pbResolveBitmap(crackfilename)
    @hatchSheet = AnimatedBitmap.new(crackfilename)
    # Create egg cracks sprite
    @sprites["hatch"] = Sprite.new(@viewport)
    @sprites["hatch"].x = @sprites["pokemon"].x
    @sprites["hatch"].y = @sprites["pokemon"].y
    @sprites["hatch"].ox = @sprites["pokemon"].ox
    @sprites["hatch"].oy = @sprites["pokemon"].oy
    @sprites["hatch"].bitmap = @hatchSheet.bitmap
    @sprites["hatch"].src_rect = Rect.new(0, 0, @hatchSheet.width / 5, @hatchSheet.height)
    @sprites["hatch"].visible = false
    # Create flash overlay
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["overlay"].z = 200
    @sprites["overlay"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["overlay"].bitmap.fill_rect(0, 0, Graphics.width, Graphics.height,
                                         Color.new(255, 255, 255))
    @sprites["overlay"].opacity = 0
    # Start up scene
    pbFadeInAndShow(@sprites)
  end

  def pbMain
    pbBGMPlay("Evolution")
    # Egg animation
    updateScene(Graphics.frame_rate * 15 / 10)
    pbPositionHatchMask(0)
    pbSEPlay("Battle ball shake")
    swingEgg(4)
    updateScene(Graphics.frame_rate * 2 / 10)
    pbPositionHatchMask(1)
    pbSEPlay("Battle ball shake")
    swingEgg(4)
    updateScene(Graphics.frame_rate * 4 / 10)
    pbPositionHatchMask(2)
    pbSEPlay("Battle ball shake")
    swingEgg(8, 2)
    updateScene(Graphics.frame_rate * 4 / 10)
    pbPositionHatchMask(3)
    pbSEPlay("Battle ball shake")
    swingEgg(16, 4)
    updateScene(Graphics.frame_rate * 2 / 10)
    pbPositionHatchMask(4)
    pbSEPlay("Battle recall")
    # Fade and change the sprite
    fadeTime = Graphics.frame_rate * 4 / 10
    toneDiff = (255.0 / fadeTime).ceil
    (1..fadeTime).each do |i|
      @sprites["pokemon"].tone = Tone.new(i * toneDiff, i * toneDiff, i * toneDiff)
      @sprites["overlay"].opacity = i * toneDiff
      updateScene
    end
    updateScene(Graphics.frame_rate * 3 / 4)
    @sprites["pokemon"].setPokemonBitmap(@pokemon) # Pokémon sprite
    @sprites["pokemon"].x = Graphics.width / 2
    @sprites["pokemon"].y = 264
    @pokemon.species_data.apply_metrics_to_sprite(@sprites["pokemon"], 1)
    @sprites["hatch"].visible = false
    (1..fadeTime).each do |i|
      @sprites["pokemon"].tone = Tone.new(255 - (i * toneDiff), 255 - (i * toneDiff), 255 - (i * toneDiff))
      @sprites["overlay"].opacity = 255 - (i * toneDiff)
      updateScene
    end
    @sprites["pokemon"].tone = Tone.new(0, 0, 0)
    @sprites["overlay"].opacity = 0
    # Finish scene
    frames = (GameData::Species.cry_length(@pokemon) * Graphics.frame_rate).ceil
    @pokemon.play_cry
    updateScene(frames + 4)
    pbBGMStop
    pbMEPlay("Evolution success")
    @pokemon.name = nil
    pbMessage(_INTL("\\se[]{1} hatched from the Egg!\\wt[80]", @pokemon.name)) { update }
    # Record the Pokémon's species as owned in the Pokédex
    was_owned = $player.owned?(@pokemon.species)
    $player.pokedex.register(@pokemon)
    $player.pokedex.set_owned(@pokemon.species)
    $player.pokedex.set_seen_egg(@pokemon.species)
    # Show Pokédex entry for new species if it hasn't been owned before
    if Settings::SHOW_NEW_SPECIES_POKEDEX_ENTRY_MORE_OFTEN && !was_owned && $player.has_pokedex
      pbMessage(_INTL("{1}'s data was added to the Pokédex.", @pokemon.name)) { update }
      $player.pokedex.register_last_seen(@pokemon)
      pbFadeOutIn {
        scene = PokemonPokedexInfo_Scene.new
        screen = PokemonPokedexInfoScreen.new(scene)
        screen.pbDexEntry(@pokemon.species)
      }
    end
    # Nickname the Pokémon
	 if nuzlocke_has?(:NICKNAMES)
      nickname = ""
	    loop do
      nickname = pbEnterPokemonName(_INTL("{1}'s nickname?", @pokemon.name),
                                    0, Pokemon::MAX_NAME_SIZE, "", @pokemon, true)
	    break if nickname.length>2
      pbMessage(_INTL("The name needs to be longer than one character!", @pokemon.name)) { update }
	    end
      @pokemon.name = nickname
      @nicknamed = true
    elsif ($PokemonSystem.givenicknames == 0 &&
       pbConfirmMessage(
         _INTL("Would you like to nickname the newly hatched {1}?", @pokemon.name)
       ) { update })
      nickname = pbEnterPokemonName(_INTL("{1}'s nickname?", @pokemon.name),
                                    0, Pokemon::MAX_NAME_SIZE, "", @pokemon, true)
      @pokemon.name = nickname
      @nicknamed = true
    end
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { update } if !@nicknamed
    pbDisposeSpriteHash(@sprites)
    @hatchSheet.dispose
    @viewport.dispose
  end

  def pbPositionHatchMask(index)
    @sprites["hatch"].src_rect.x = index * @sprites["hatch"].src_rect.width
  end

  def swingEgg(speed, swingTimes = 1)
    @sprites["hatch"].visible = true
    speed = speed.to_f * 20 / Graphics.frame_rate
    amplitude = 8
    targets = []
    swingTimes.times do
      targets.push(@sprites["pokemon"].x + amplitude)
      targets.push(@sprites["pokemon"].x - amplitude)
    end
    targets.push(@sprites["pokemon"].x)
    targets.each_with_index do |target, i|
      loop do
        break if i.even? && @sprites["pokemon"].x >= target
        break if i.odd? && @sprites["pokemon"].x <= target
        @sprites["pokemon"].x += speed
        @sprites["hatch"].x    = @sprites["pokemon"].x
        updateScene
      end
      speed *= -1
    end
    @sprites["pokemon"].x = targets[targets.length - 1]
    @sprites["hatch"].x   = @sprites["pokemon"].x
  end

  def updateScene(frames = 1)   # Can be used for "wait" effect
    frames.times do
      Graphics.update
      Input.update
      self.update
    end
  end

  def update
    pbUpdateSpriteHash(@sprites)
  end
end

#===============================================================================
#
#===============================================================================
class PokemonEggHatchScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen(pokemon)
    @scene.pbStartScene(pokemon)
    @scene.pbMain
    @scene.pbEndScene
  end
end

#===============================================================================
#
#===============================================================================
def pbHatchAnimation(pokemon)
  pbMessage(_INTL("Huh?\1"))
  pbFadeOutInWithMusic {
    scene = PokemonEggHatch_Scene.new
    screen = PokemonEggHatchScreen.new(scene)
    screen.pbStartScreen(pokemon)
  }
  return true
end

def pbHatch(pokemon)
  $stats.eggs_hatched += 1
  speciesname = pokemon.speciesName
  pokemon.name           = nil
  pokemon.owner          = Pokemon::Owner.new_from_trainer($player)
  pokemon.happiness      = 120
  pokemon.timeEggHatched = pbGetTimeNow
  pokemon.obtain_method  = 1   # hatched from egg
  pokemon.hatched_map    = $game_map.map_id
  pokemon.record_first_moves
  if !pbHatchAnimation(pokemon)
    pbMessage(_INTL("Huh?\1"))
    pbMessage(_INTL("...\1"))
    pbMessage(_INTL("... .... .....\1"))
    pbMessage(_INTL("{1} hatched from the Egg!", speciesname))
    was_owned = $player.owned?(pokemon.species)
    $player.pokedex.register(pokemon)
    $player.pokedex.set_owned(pokemon.species)
    $player.pokedex.set_seen_egg(pokemon.species)
    # Show Pokédex entry for new species if it hasn't been owned before
    if Settings::SHOW_NEW_SPECIES_POKEDEX_ENTRY_MORE_OFTEN && !was_owned && $player.has_pokedex
      pbMessage(_INTL("{1}'s data was added to the Pokédex.", speciesname))
      $player.pokedex.register_last_seen(pokemon)
      pbFadeOutIn {
        scene = PokemonPokedexInfo_Scene.new
        screen = PokemonPokedexInfoScreen.new(scene)
        screen.pbDexEntry(pokemon.species)
      }
    end
    # Nickname the Pokémon
    
	 if nuzlocke_has?(:PERMADEATH)
      nickname = ""
	    loop do
      nickname = pbEnterPokemonName(_INTL("{1}'s nickname?", speciesname),
                                    0, Pokemon::MAX_NAME_SIZE, "", speciesname, true)
	    break if nickname.length>2
      pbMessage(_INTL("The name needs to be longer than one character!", speciesname))
	    end
      pokemon.name = nickname
    elsif $PokemonSystem.givenicknames == 0 &&
       pbConfirmMessage(_INTL("Would you like to nickname the newly hatched {1}?", speciesname))
      nickname = pbEnterPokemonName(_INTL("{1}'s nickname?", speciesname),
                                    0, Pokemon::MAX_NAME_SIZE, "", pokemon)
      pokemon.name = nickname
    end
  end
end

EventHandlers.add(:on_player_step_taken, :hatch_eggs,
  proc {
    $player.party.each do |egg|
      next if egg.steps_to_hatch <= 0
      egg.steps_to_hatch -= 1
      $player.pokemon_party.each do |pkmn|
        next if !pkmn.ability&.has_flag?("FasterEggHatching")
        egg.steps_to_hatch -= 1
        break
      end
      if egg.steps_to_hatch <= 0
        egg.steps_to_hatch = 0
        pbHatch(egg)
      end
    end
  }
)
