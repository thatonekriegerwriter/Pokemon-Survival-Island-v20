#===============================================================================
# * Family Tree - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It displays a sixth page at pokémon
# summary showing a little info about the pokémon mother, father, grandmothers
# and grandfathers if the pokémon has any.
#
#== INSTALLATION ===============================================================
#
# To this script works, put it above PSystem_System. 
#
# Put a 512x384 background for this screen in "Graphics/Pictures/Summary/" as 
# "bg_6" and as "bg_6_egg". This last one is only necessary if SHOW_FAMILY_EGG
# is true. You also need to update the below pictures on same folder in order
# to reflect the summary icon change:
# - bg_1
# - bg_2
# - bg_3
# - bg_4
# - bg_movedetail
# - bg_5
#
# - At PScreen_Summary, change both lines '@page = 5 if @page>5'
# to '@page=6 if @page>6'
#
# - Change line '_INTL("RIBBONS")][page-1]' into:
#
# _INTL("RIBBONS"),
# _INTL("FAMILY TREE")][page-1]
#
#== NOTES ======================================================================
#
# This won't work on eggs generated before this script was installed.
#
#===============================================================================

if !PluginManager.installed?("Family Tree")
  PluginManager.register({                                                 
    :name    => "Family Tree",                                        
    :version => "1.3",                                                     
    :link    => "https://www.pokecommunity.com/showthread.php?t=339384",             
    :credits => "FL"
  })
end


class PokemonFamily
  MAX_GENERATIONS = 3 # Tree stored generation limit

  attr_reader :mother # PokemonFamily object
  attr_reader :father # PokemonFamily object

  attr_reader :species
  attr_reader :form
  attr_reader :gender
  attr_reader :shiny
  attr_reader :name # nickname
  # You can add more data here and on initialize class. Just
  # don't store the entire pokémon object.

  def initialize(pokemon, father=nil,mother=nil)
    @father = format_parent(pokemon, father, 0)
    @mother = format_parent(pokemon, mother, 1)
    initialize_cub_data(pokemon) if !father || !mother
    apply_generation_limit(MAX_GENERATIONS)
  end

  # [0] = father, [1] = mother
  def [](value)
    return case value
      when 0; @father
      when 1; @mother
      else; nil
    end
  end

  def format_parent(pokemon, parent, index)
    return pokemon.family[index] if pokemon.family && pokemon.family[index]
    return PokemonFamily.new(parent) if parent
    return nil
  end

  def initialize_cub_data(pokemon)
    @species=pokemon.species
    @form=pokemon.form
    @gender=pokemon.gender
    @shiny=pokemon.shiny?
    @name=pokemon.name
  end

  def apply_generation_limit(generation)
    if generation>1
      @father.apply_generation_limit(generation-1) if @father
      @mother.apply_generation_limit(generation-1) if @mother
    else
      @father=nil
      @mother=nil
    end
  end

  def icon_filename
    return GameData::Species.icon_filename(@species, @form, @gender, @shiny)
  end
end 

class Pokemon
  attr_accessor :family
end

alias :_pbDayCareGenerateEgg_FL_fam :pbDayCareGenerateEgg
def pbDayCareGenerateEgg
  _pbDayCareGenerateEgg_FL_fam
  pkmn0 = $PokemonGlobal.daycare[0][0]
  pkmn1 = $PokemonGlobal.daycare[1][0]
  mother = nil
  father = nil
  if pkmn0.female? || pbIsDitto?(pkmn0)
    mother = pkmn0
    father = pkmn1
  else
    mother = pkmn1
    father = pkmn0
  end
  $player.party[-1].family = PokemonFamily.new(
    $player.party[-1], father, mother
  )
end