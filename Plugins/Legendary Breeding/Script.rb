#===============================================================================
# Settings
#===============================================================================
module Settings
  EGG_SPECIES_ITEM = {
    #---------------------------------------------------------------------------
    # Template
    #---------------------------------------------------------------------------
    # :BABY_SPECIES refers to the species that would normally be hatched.
    # :NEW_SPECIES refers to the altered species that will be hatched instead.
    # :ITEM refers to the item that may be held by a parent to alter the baby species.
    #---------------------------------------------------------------------------
    # :BABY_SPECIES => {
    #   :NEW_SPECIES => :ITEM
    # },
    #---------------------------------------------------------------------------
    :MEW       => {
      :MEWTWO    => :BERSERKGENE
    },
    #---------------------------------------------------------------------------
    :PHIONE    => { 
      :MANAPHY   => :MYSTICWATER
    },
    #---------------------------------------------------------------------------
    :REGIGIGAS => { 
      :REGIROCK  => :HARDSTONE,
      :REGICE    => :NEVERMELTICE,
      :REGISTEEL => :IRONBALL,
      :REGIELEKI => :LIGHTBALL,
      :REGIDRAGO => :DRAGONFANG
    }
    #---------------------------------------------------------------------------
  }
end


#===============================================================================
# Legendary Egg Groups
#===============================================================================
GameData::EggGroup.register({
  :id   => :Skycrest,
  :name => _INTL("Skycrest")
})

GameData::EggGroup.register({
  :id   => :Bestial,
  :name => _INTL("Bestial")
})

GameData::EggGroup.register({
  :id   => :Titan,
  :name => _INTL("Titan")
})

GameData::EggGroup.register({
  :id   => :Overlord,
  :name => _INTL("Overlord")
})

GameData::EggGroup.register({
  :id   => :Nebulous,
  :name => _INTL("Nebulous")
})

GameData::EggGroup.register({
  :id   => :Enchanted,
  :name => _INTL("Enchanted")
})

GameData::EggGroup.register({
  :id   => :Ancestor,
  :name => _INTL("Ancestor")
})

GameData::EggGroup.register({
  :id   => :Ultra,
  :name => _INTL("Ultra")
})


#===============================================================================
# Breeding compatibility functions
#===============================================================================
class DayCare
  module EggGenerator
    module_function
    
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
  end
  
  def compatibility
    return 0 if self.count != 2
    pkmn1, pkmn2 = pokemon_pair
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
# Creating eggs with Arceus.
#===============================================================================
def pbArceusEggSpawn?(pkmn, item)
  return pkmn.isSpecies?(:ARCEUS) &&
         [:ADAMANTORB, :LUSTROUSORB, :GRISEOUSORB, :DIVINEPLATE, :FALSEPLATE].include?(item)
end

MenuHandlers.add(:party_menu, :egg_skill, {
  "name"      => _INTL("Form Egg"),
  "order"     => 22,
  "condition" => proc { |screen, party, party_idx| next pbArceusEggSpawn?(party[party_idx], party[party_idx].item_id) },
  "effect"    => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    if party.length >= Settings::MAX_PARTY_SIZE
      screen.pbDisplay(_INTL("There isn't enough space to carry an Egg."))
    elsif pbConfirmMessage(_INTL("Would you like {1} to form a new Egg out of its held item?", pkmn.name))
      case pkmn.item_id
      when :ADAMANTORB  then spawn = :DIALGA
      when :LUSTROUSORB then spawn = :PALKIA
      when :GRISEOUSORB then spawn = :GIRATINA
      when :DIVINEPLATE then spawn = :ARCEUS
      when :FALSEPLATE  then spawn = :TYPENULL
      end
      if GameData::Species.exists?(spawn)
        screen.pbDisplay(_INTL("{1} gathered immense energy!", pkmn.name))
        pbHiddenMoveAnimation(pkmn)
        origin = (spawn == :TYPENULL) ? _INTL("A Corrupted Force.") : _INTL("A Divine Force.")
        pbGenerateEgg(spawn, origin)
        egg = $player.last_party
        # Egg IV's are influenced by Arceus's IV's.
        stats = []
        GameData::Stat.each_main { |s| stats.push(s) }
        chosen_stats = stats.sample(5)
        chosen_stats.each { |stat| egg.iv[stat] = pkmn.iv[stat] }
        # Egg inherits Arceus's ball type.
        egg.poke_ball = pkmn.poke_ball if ![:MASTERBALL, :CHERISHBALL].include?(pkmn.poke_ball)
        pbMessage(_INTL("\\me[Egg get]You received an Egg from {1}!", pkmn.name))
        if [:ARCEUS, :TYPENULL].include?(spawn)
          screen.pbDisplay(_INTL("{1}'s <c2=65467b14>{2}</c2> shattered!", pkmn.name, pkmn.item.name))
          pkmn.item = nil
        else
          screen.pbDisplay(_INTL("{1}'s <c2=65467b14>{2}</c2> fused with the Egg!", pkmn.name, pkmn.item.name))
          egg.item = pkmn.item
          pkmn.item = nil
        end
        screen.pbHardRefresh
      else
        screen.pbDisplay(_INTL("{1} seems unable to to form an Egg with this item...", pkmn.name))
      end
    end
  }
})


#===============================================================================
# Compiler
#===============================================================================
module Compiler
  PLUGIN_FILES += ["Legendary Breeding"]
end