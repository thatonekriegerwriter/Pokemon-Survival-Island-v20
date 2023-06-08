#==================================
# Registering Unnatural/Rare Natures (Code by wrigty12!!!)
#==================================

class Game_System
    attr_reader :only_common_natures
    attr_reader :only_rare_natures
   
    alias unnatural_system_init initialize
    def initialize
        unnatural_system_init
        @only_common_natures = nil
        @only_rare_natures = nil
    end
   
    def only_common_natures= (value)
        @only_common_natures = value
    end
   
    def only_rare_natures= (value)
        @only_rare_natures = value
    end
   
end

module GameData
    class Nature
        attr_reader :unnatural
        attr_reader :rare
       
        alias unnatural_initialize initialize
        def initialize(hash)
            unnatural_initialize(hash)
            @unnatural = hash[:unnatural] || false
            @rare = hash[:rare] || false
        end
   
        def self.count
            if !$game_system.only_common_natures
                #Reorganize hashes so the order is regular natures > rare natures > unnatural natures
                origHash = self::DATA.clone
                rareHash = {}
                unnaturalHash = {}
                self::DATA.each { |n|
                    if GameData::Nature.get(n[0]).unnatural
                        id = GameData::Nature.get(n[0]).id
                        unnaturalHash[id] = origHash.delete(id)
                    elsif GameData::Nature.get(n[0]).rare
                        id = GameData::Nature.get(n[0]).id
                        rareHash[id] = origHash.delete(id)
                    end
                }
                newHash = origHash.merge(rareHash)
                newHash = newHash.merge(unnaturalHash)
                self::DATA.replace newHash
               
                common = []
                rares = []
                natures = self::DATA.keys
                natures.each { |n|
                    common.push n if !GameData::Nature.get(n).unnatural && !GameData::Nature.get(n).rare
                    rares.push n if !GameData::Nature.get(n).unnatural && GameData::Nature.get(n).rare
                }
                $game_system.only_common_natures = common
                $game_system.only_rare_natures = rares
            end
           
            amt = $game_system.only_common_natures.length
            amt += $game_system.only_rare_natures.length if rand(10) < NatureSettings::RARE_NATURE_CHANCE
            return amt
        end
       
    end
end	

#============================================
# New Natures
#============================================

#====================
# Normal Natures
#====================

GameData::Nature.register({
  :id           => :DULL,
  :name         => _INTL("Dull"),
})

#====================
# Simple Natures
#====================

GameData::Nature.register({
  :id           => :POISED,
  :name         => _INTL("Poised"),
  :stat_changes => [[:ATTACK, 5]]
})

GameData::Nature.register({
  :id           => :TENSE,
  :name         => _INTL("Tense"),
  :stat_changes => [[:DEFENSE, 5]]
})

GameData::Nature.register({
  :id           => :ALERT,
  :name         => _INTL("Alert"),
  :stat_changes => [[:SPEED, 5]]
})

GameData::Nature.register({
  :id           => :NUTTY,
  :name         => _INTL("Nutty"),
  :stat_changes => [[:SPECIAL_ATTACK, 5]]
})

GameData::Nature.register({
  :id           => :WEARY,
  :name         => _INTL("Weary"),
  :stat_changes => [[:SPECIAL_DEFENSE, 5]]
})

#====================
# Dual Natures
#====================

GameData::Nature.register({
  :id           => :BLUNT,
  :name         => _INTL("Blunt"),
  :stat_changes => [[:ATTACK, 5], [:DEFENSE, -5], [:SPECIAL_ATTACK, 5], [:SPECIAL_DEFENSE, -5]]
})

GameData::Nature.register({
  :id           => :CAUTIOUS,
  :name         => _INTL("Cautious"),
  :stat_changes => [[:ATTACK, -5], [:DEFENSE, 5], [:SPECIAL_ATTACK, -5], [:SPECIAL_DEFENSE, 5]]
})

GameData::Nature.register({
  :id           => :WISE,
  :name         => _INTL("Wise"),
  :stat_changes => [[:ATTACK, -5], [:DEFENSE, -5], [:SPECIAL_ATTACK, 5], [:SPECIAL_DEFENSE, 5]]
})

GameData::Nature.register({
  :id           => :DETERMINED,
  :name         => _INTL("Determined"),
  :stat_changes => [[:ATTACK, 5], [:DEFENSE, 5], [:SPECIAL_ATTACK, -5], [:SPECIAL_DEFENSE, -5]]
})

#====================
# Pure Natures
#====================

GameData::Nature.register({
  :id           => :HOTHEADED,
  :name         => _INTL("Hotheaded"),
  :rare         => true,
  :stat_changes => [[:ATTACK, 20], [:DEFENSE, -20]]
})

GameData::Nature.register({
  :id           => :SHELTERED,
  :name         => _INTL("Sheltered"),
  :rare         => true,
  :stat_changes => [[:DEFENSE, 20], [:SPEED, -20]]
})

GameData::Nature.register({
  :id           => :TURBULENT,
  :name         => _INTL("Turbulent"),
  :rare         => true,
  :stat_changes => [[:SPEED, 20], [:SPECIAL_DEFENSE, -20]]
})

GameData::Nature.register({
  :id           => :WHIMSICAL,
  :name         => _INTL("Whimsical"),
  :rare         => true,
  :stat_changes => [[:SPECIAL_ATTACK, 20], [:DEFENSE, -20]]
})

GameData::Nature.register({
  :id           => :DAUNTLESS,
  :name         => _INTL("Dauntless"),
  :rare         => true,
  :stat_changes => [[:SPECIAL_DEFENSE, 20], [:SPECIAL_ATTACK, -20]]
})

#====================
# Unnatural Natures
#====================

GameData::Nature.register({
  :id           => :GOLDEN,
  :name         => _INTL("Golden"),
  :unnatural    => true,
  :stat_changes => [[:ATTACK, 5], [:DEFENSE, 5], [:SPEED, 5], [:SPECIAL_ATTACK, 5], [:SPECIAL_DEFENSE, 5]]
})

GameData::Nature.register({
  :id           => :RADIANT,
  :name         => _INTL("Radiant"),
  :unnatural    => true,
  :stat_changes => [[:ATTACK, 10], [:DEFENSE, 10], [:SPEED, 10], [:SPECIAL_ATTACK, 10], [:SPECIAL_DEFENSE, 10]]
})

GameData::Nature.register({
  :id           => :WIMPY,
  :name         => _INTL("Wimpy"),
  :unnatural    => true,
  :stat_changes => [[:ATTACK, -5], [:DEFENSE, -5], [:SPEED, -5], [:SPECIAL_ATTACK, -5], [:SPECIAL_DEFENSE, -5]]
})

GameData::Nature.register({
  :id           => :PATHETIC,
  :name         => _INTL("Pathetic"),
  :unnatural    => true,
  :stat_changes => [[:ATTACK, -10], [:DEFENSE, -10], [:SPEED, -10], [:SPECIAL_ATTACK, -10], [:SPECIAL_DEFENSE, -10]]
})

#===========================================================================
# New Mints
#===========================================================================

ItemHandlers::UseOnPokemon.add(:HARDYMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:HARDY, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:DOCILEMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:DOCILE, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:BASHFULMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:BASHFUL, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:QUIRKYMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:QUIRKY, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:DULLMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:DULL, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:POISEDMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:POISED, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:TENSEMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:TENSE, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:ALERTMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:ALERT, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:NUTTYMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:NUTTY, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:WEARYMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:WEARY, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:BLUNTMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:BLUNT, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:CAUTIOUSMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:CAUTIOUS, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:WISEMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:WISE, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:DETERMINEDMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:DETERMINED, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:GOLDENMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:GOLDEN, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:RADIANTMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:RADIANT, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:WIMPYMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:WIMPY, item, pkmn, scene)
})

ItemHandlers::UseOnPokemon.add(:PATHETICMINT, proc { |item, qty, pkmn, scene|
  pbNatureChangingMint(:PATHETIC, item, pkmn, scene)
})

#-------------------------------------------------------------------------------
# Compiler.
#-------------------------------------------------------------------------------
module Compiler
  PLUGIN_FILES += ["Orange's Natures Expansion"]
end