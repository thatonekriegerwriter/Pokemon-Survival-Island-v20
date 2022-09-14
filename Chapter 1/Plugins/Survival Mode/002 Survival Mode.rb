#==============================================================================#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
#==============================================================================#
#                                                                              #
#                             Survival Mode                                    #
#                          By thatonekriegerwriter                             #
#                 Original Hunger Script by Maurili and Vendily                #
#                                                                              #
#                                                                              #
#                                                                              #
#==============================================================================#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
#==============================================================================#
#Thanks Maurili and Vendily for the Original Hunger Script                     #
class PokemonGlobalMetadata

  attr_accessor :pkmnfoodSteps
  attr_accessor :pkmnthirstSteps
  attr_accessor :playerfoodSteps
  attr_accessor :playerwaterSteps
  attr_accessor :playersleepSteps
  attr_accessor :playersaturationSteps
  
  
  def initialize
    @pkmnfoodSteps       = 0
    @pkmnthirstSteps       = 0
    @playerfoodSteps       = 0
    @playerwaterSteps       = 0
    @playersleepSteps       = 0
    @playersaturationSteps       = 0
  end
end

module GameData
  class Species
    attr_reader :id
    attr_reader :species
    attr_reader :form
    attr_reader :real_name
    attr_reader :real_form_name
    attr_reader :real_category
    attr_reader :real_pokedex_entry
    attr_reader :pokedex_form
    attr_reader :types
    attr_reader :base_stats
    attr_reader :evs
    attr_reader :base_exp
    attr_reader :growth_rate
    attr_reader :gender_ratio
    attr_reader :catch_rate
    attr_reader :happiness
    attr_reader :moves
    attr_reader :tutor_moves
    attr_reader :egg_moves
    attr_reader :abilities
    attr_reader :hidden_abilities
    attr_reader :wild_item_common
    attr_reader :wild_item_uncommon
    attr_reader :wild_item_rare
    attr_reader :egg_groups
    attr_reader :hatch_steps
    attr_reader :incense
    attr_reader :offspring
    attr_reader :evolutions
    attr_reader :height
    attr_reader :weight
    attr_reader :color
    attr_reader :shape
    attr_reader :habitat
    attr_reader :generation
    attr_reader :flags
    attr_reader :mega_stone
    attr_reader :mega_move
    attr_reader :unmega_form
    attr_reader :mega_message
    attr_reader :loyalty
    attr_reader :maxage
    attr_reader :lifespan
    attr_reader :food
    attr_reader :water
    attr_reader :sleep
    attr_reader :age
  
  
    def self.schema(compiling_forms = false)
      ret = {
        "FormName"          => [0, "q"],
        "Category"          => [0, "s"],
        "Pokedex"           => [0, "q"],
        "Types"             => [0, "eE", :Type, :Type],
        "BaseStats"         => [0, "vvvvvv"],
        "EVs"               => [0, "*ev", :Stat],
        "BaseExp"           => [0, "v"],
        "CatchRate"         => [0, "u"],
        "Happiness"         => [0, "u"],
        "Moves"             => [0, "*ue", nil, :Move],
        "TutorMoves"        => [0, "*e", :Move],
        "EggMoves"          => [0, "*e", :Move],
        "Abilities"         => [0, "*e", :Ability],
        "HiddenAbilities"   => [0, "*e", :Ability],
        "WildItemCommon"    => [0, "*e", :Item],
        "WildItemUncommon"  => [0, "*e", :Item],
        "WildItemRare"      => [0, "*e", :Item],
        "EggGroups"         => [0, "*e", :EggGroup],
        "HatchSteps"        => [0, "v"],
        "Height"            => [0, "f"],
        "Weight"            => [0, "f"],
        "Color"             => [0, "e", :BodyColor],
        "Shape"             => [0, "e", :BodyShape],
        "Habitat"           => [0, "e", :Habitat],
        "Generation"        => [0, "i"],
        "Flags"             => [0, "*s"],
        "BattlerPlayerX"    => [0, "i"],
        "BattlerPlayerY"    => [0, "i"],
        "BattlerEnemyX"     => [0, "i"],
        "BattlerEnemyY"     => [0, "i"],
        "BattlerAltitude"   => [0, "i"],
        "BattlerShadowX"    => [0, "i"],
        "BattlerShadowSize" => [0, "u"],
        # All properties below here are old names for some properties above.
        # They will be removed in v21.
        "Type1"             => [0, "e", :Type],
        "Type2"             => [0, "e", :Type],
        "Rareness"          => [0, "u"],
        "Compatibility"     => [0, "*e", :EggGroup],
        "Kind"              => [0, "s"],
        "BaseEXP"           => [0, "v"],
        "EffortPoints"      => [0, "*ev", :Stat],
        "HiddenAbility"     => [0, "*e", :Ability],
        "StepsToHatch"      => [0, "v"],
	    	"Loyalty"           => [0, "u"],
	    	"MaxAge"           => [0, "u"],
	    	"Lifespan"         => [0, "u"],
	    	"Food"             => [0, "u"],
	    	"Water"            => [0, "u"],
	    	"Sleep"            => [0, "u"],
	    	"Age"              => [0, "u"],
      }
      if compiling_forms
        ret["PokedexForm"]  = [0, "u"]
        ret["Offspring"]    = [0, "*e", :Species]
        ret["Evolutions"]   = [0, "*ees", :Species, :Evolution, nil]
        ret["MegaStone"]    = [0, "e", :Item]
        ret["MegaMove"]     = [0, "e", :Move]
        ret["UnmegaForm"]   = [0, "u"]
        ret["MegaMessage"]  = [0, "u"]
      else
        ret["InternalName"] = [0, "n"]
        ret["Name"]         = [0, "s"]
        ret["GrowthRate"]   = [0, "e", :GrowthRate]
        ret["GenderRatio"]  = [0, "e", :GenderRatio]
        ret["Incense"]      = [0, "e", :Item]
        ret["Offspring"]    = [0, "*s"]
        ret["Evolutions"]   = [0, "*ses", nil, :Evolution, nil]
        # All properties below here are old names for some properties above.
        # They will be removed in v21.
        ret["GenderRate"]   = [0, "e", :GenderRatio]
      end
      return ret
    end

	
	
    def initialize(hash)
      @id                 = hash[:id]
      @species            = hash[:species]            || @id
      @form               = hash[:form]               || 0
      @real_name          = hash[:name]               || "Unnamed"
      @real_form_name     = hash[:form_name]
      @real_category      = hash[:category]           || "???"
      @real_pokedex_entry = hash[:pokedex_entry]      || "???"
      @pokedex_form       = hash[:pokedex_form]       || @form
      @types              = hash[:types]              || [:NORMAL]
      @base_stats         = hash[:base_stats]         || {}
      @evs                = hash[:evs]                || {}
      GameData::Stat.each_main do |s|
        @base_stats[s.id] = 1 if !@base_stats[s.id] || @base_stats[s.id] <= 0
        @evs[s.id]        = 0 if !@evs[s.id] || @evs[s.id] < 0
      end
      @base_exp           = hash[:base_exp]           || 100
      @growth_rate        = hash[:growth_rate]        || :Medium
      @gender_ratio       = hash[:gender_ratio]       || :Female50Percent
      @catch_rate         = hash[:catch_rate]         || 255
      @happiness          = hash[:happiness]          || 70
      @moves              = hash[:moves]              || []
      @tutor_moves        = hash[:tutor_moves]        || []
      @egg_moves          = hash[:egg_moves]          || []
      @abilities          = hash[:abilities]          || []
      @hidden_abilities   = hash[:hidden_abilities]   || []
      @wild_item_common   = hash[:wild_item_common]   || []
      @wild_item_uncommon = hash[:wild_item_uncommon] || []
      @wild_item_rare     = hash[:wild_item_rare]     || []
      @egg_groups         = hash[:egg_groups]         || [:Undiscovered]
      @hatch_steps        = hash[:hatch_steps]        || 1
      @incense            = hash[:incense]
      @offspring          = hash[:offspring]          || []
      @evolutions         = hash[:evolutions]         || []
      @height             = hash[:height]             || 1
      @weight             = hash[:weight]             || 1
      @color              = hash[:color]              || :Red
      @shape              = hash[:shape]              || :Head
      @habitat            = hash[:habitat]            || :None
      @generation         = hash[:generation]         || 0
      @flags              = hash[:flags]              || []
      @mega_stone         = hash[:mega_stone]
      @mega_move          = hash[:mega_move]
      @unmega_form        = hash[:unmega_form]        || 0
      @mega_message       = hash[:mega_message]       || 0
	  @loyalty               = hash[:loyalty]         || 50  
      @maxage                 = hash[:maxage]           || 100   
      @lifespan               = hash[:lifespan]         || 50    
      @food                   = hash[:food]             || 100   
      @water                  = hash[:water]            || 100   
      @sleep                  = hash[:sleep]            || 100  
      @age                    = hash[:age]              || 1  
	end
end
end
class Pokemon
    attr_accessor :food
    attr_accessor :water
    attr_accessor :sleep
    attr_accessor :age
    attr_accessor :maxage
    attr_accessor :lifespan
	
	  def initialize(species, level, owner = $player, withMoves = true, recheck_form = true)
    species_data = GameData::Species.get(species)
    @species          = species_data.species
    @form             = species_data.base_form
    @forced_form      = nil
    @time_form_set    = nil
    self.level        = level
    @steps_to_hatch   = 0
    heal_status
    @gender           = nil
    @shiny            = nil
    @ability_index    = nil
    @ability          = nil
    @nature           = nil
    @nature_for_stats = nil
    @item             = nil
    @mail             = nil
    @moves            = []
    reset_moves if withMoves
    @first_moves      = []
    @ribbons          = []
    @cool             = 0
    @beauty           = 0
    @cute             = 0
    @smart            = 0
    @tough            = 0
    @sheen            = 0
    @pokerus          = 0
    @name             = nil
    @happiness        = species_data.happiness
    @loyalty          = species_data.loyalty
    @food             = species_data.food
    @water            = species_data.water
    @sleep            = species_data.sleep
    @poke_ball        = :POKEBALL
    @markings         = []
    @iv               = {}
    @ivMaxed          = {}
    @ev               = {}
    GameData::Stat.each_main do |s|
      @iv[s.id]       = rand(IV_STAT_LIMIT + 1)
      @ev[s.id]       = 0
    end
    case owner
    when Owner
      @owner = owner
    when Player, NPCTrainer
      @owner = Owner.new_from_trainer(owner)
    else
      @owner = Owner.new(0, "", 2, 2)
    end
    @obtain_method    = 0   # Met
    @obtain_method    = 4 if $game_switches && $game_switches[Settings::FATEFUL_ENCOUNTER_SWITCH]
    @obtain_map       = ($game_map) ? $game_map.map_id : 0
    @obtain_text      = nil
    @obtain_level     = level
    @hatched_map      = 0
    @timeReceived     = pbGetTimeNow.to_i
    @timeEggHatched   = nil
    @fused            = nil
    @personalID       = rand(2**16) | (rand(2**16) << 16)
    @hp               = 1
    @totalhp          = 1
    calc_stats
    if @form == 0 && recheck_form
      f = MultipleForms.call("getFormOnCreation", self)
      if f
        self.form = f
        reset_moves if withMoves
      end
    end
  end


  def changeFood
    gain = 0
    food_range = @food / 100
    gain = [-1, -2, -2][food_range]
    @food = (@food + gain).clamp(0, 255)
  end
  
  def changeWater
    gain = 0
    water_range = @water / 100
    gain = [-1, -2, -2][water_range]
    @water = (@water + gain).clamp(0, 255)
  end
  
  def changeLifespan(method,pkmn)
    if @lifespan.nil?
	 @lifespan = 50
	end
    gain = 0
    lifespan_range = @lifespan / 100
      case method
      when "age"
        gain = [-1, -1, -1][lifespan_range]
	  end
    @lifespan = (@lifespan + gain).clamp(0, 255)
  end
  
  def changeAge
    if @age.nil?
	 @age = 1
	end
    gain = 0
    age_range = @age / 100
    gain = [1, 1, 1][age_range]
    @age = (@age + gain).clamp(0, 255)
  end
  
  
  
end

class Player < Trainer
  attr_reader :playerwater  #206
  attr_reader :playerfood   #205
  attr_reader :playersleep   #208
  attr_reader :playersaturation #207
  attr_reader :playerhealth #225
  attr_reader :playerstamina
  attr_reader :playermaxstamina
  attr_reader :playerstaminamod
  
  def initialize(name, trainer_type)
    @playerwater   = 100   # Text speed (0=slow, 1=normal, 2=fast)
    @playerfood = 100     # Battle effects (animations) (0=on, 1=off)
    @playersaturation = 100     # Battle style (0=switch, 1=set)
    @playersleep = 100     # Battle style (0=switch, 1=set)
    @playerhealth  = 100     # Default window frame (see also Settings::MENU_WINDOWSKINS)
    @playerstamina  = 50     # Speech frame
    @playermaxstamina  = 50     # Speech frame
    @playerstaminamod  = 0     # Speech frame
  end
  
  def playerwater=(value)
    validate value => Integer
    @playerwater = value.clamp(0, 100)
  end
  def playerfood=(value)
    validate value => Integer
    @playerfood = value.clamp(0, 100)
  end
  def playersaturation=(value)
    validate value => Integer
    @playersaturation = value.clamp(0, 100)
  end
  def playersleep=(value)
    validate value => Integer
    @playersleep = value.clamp(0, 200)
  end
  def playerhealth=(value)
    validate value => Integer
    @playerhealth = value.clamp(0, 100)
  end
  def playerstamina=(value)
    validate value => Integer
    @playerstamina = value.clamp(0, 1000)
  end
  def playermaxstamina=(value)
    validate value => Integer
    @playermaxstamina = value.clamp(0, 9999)
  end
  def playerstaminamod=(value)
    validate value => Integer
    @playerstaminamod = value.clamp(0, 50)
  end
end


module Compiler
  module_function
  def compile_pokemon(path = "PBS/pokemon.txt")
    compile_pbs_file_message_start(path)
    GameData::Species::DATA.clear
    species_names           = []
    species_form_names      = []
    species_categories      = []
    species_pokedex_entries = []
    # Read from PBS file
    File.open(path, "rb") { |f|
      FileLineData.file = path   # For error reporting
      # Read a whole section's lines at once, then run through this code.
      # contents is a hash containing all the XXX=YYY lines in that section, where
      # the keys are the XXX and the values are the YYY (as unprocessed strings).
      schema = GameData::Species.schema
      idx = 0
      pbEachFileSection(f) { |contents, species_id|
        echo "." if idx % 50 == 0
        idx += 1
        Graphics.update if idx % 250 == 0
        FileLineData.setSection(species_id, "header", nil)   # For error reporting
        contents["InternalName"] = species_id if !species_id[/^\d+/]
        # Ensure all required properties have been defined, and raise an error
        # if not
        schema.each_key do |key|
          next if !nil_or_empty?(contents[key])
          if ["Name", "InternalName"].include?(key)
            raise _INTL("The entry {1} is required in {2} section {3}.", key, path, species_id)
          end
          contents[key] = nil
        end
        # Raise an error if a species ID is used twice
        if GameData::Species::DATA[contents["InternalName"].to_sym]
          raise _INTL("Species ID '{1}' is used twice.\r\n{2}", contents["InternalName"], FileLineData.linereport)
        end
        # Go through schema hash of compilable data and compile this section
        schema.each_key do |key|
          next if nil_or_empty?(contents[key])
          FileLineData.setSection(species_id, key, contents[key])   # For error reporting
          # Compile value for key
          if ["EVs", "EffortPoints"].include?(key) && contents[key].split(",")[0].numeric?
            value = pbGetCsvRecord(contents[key], key, [0, "uuuuuu"])   # Old format
          else
            value = pbGetCsvRecord(contents[key], key, schema[key])
          end
          value = nil if value.is_a?(Array) && value.empty?
          contents[key] = value
          # Sanitise data
          case key
          when "BaseStats"
            value_hash = {}
            GameData::Stat.each_main do |s|
              value_hash[s.id] = value[s.pbs_order] if s.pbs_order >= 0
            end
            contents[key] = value_hash
          when "EVs", "EffortPoints"
            if value[0].is_a?(Array)   # New format
              value_hash = {}
              value.each { |val| value_hash[val[0]] = val[1] }
              GameData::Stat.each_main { |s| value_hash[s.id] ||= 0 }
              contents[key] = value_hash
            else   # Old format
              value_hash = {}
              GameData::Stat.each_main do |s|
                value_hash[s.id] = value[s.pbs_order] if s.pbs_order >= 0
              end
              contents[key] = value_hash
            end
          when "Height", "Weight"
            # Convert height/weight to 1 decimal place and multiply by 10
            value = (value * 10).round
            if value <= 0
              raise _INTL("Value for '{1}' can't be less than or close to 0 (section {2}, {3})", key, species_id, path)
            end
            contents[key] = value
          when "Evolutions"
            contents[key].each { |evo| evo[3] = false }
          end
        end
        # Construct species hash
        types = contents["Types"] || [contents["Type1"], contents["Type2"]]
        types = [types] if !types.is_a?(Array)
        types = types.uniq.compact
        species_hash = {
          :id                 => contents["InternalName"].to_sym,
          :name               => contents["Name"],
          :form_name          => contents["FormName"],
          :category           => contents["Category"] || contents["Kind"],
          :pokedex_entry      => contents["Pokedex"],
          :types              => types,
          :base_stats         => contents["BaseStats"],
          :evs                => contents["EVs"] || contents["EffortPoints"],
          :base_exp           => contents["BaseExp"] || contents["BaseEXP"],
          :growth_rate        => contents["GrowthRate"],
          :gender_ratio       => contents["GenderRatio"] || contents["GenderRate"],
          :catch_rate         => contents["CatchRate"] || contents["Rareness"],
          :happiness          => contents["Happiness"],
          :loyalty            => contents["Loyalty"],
          :maxage             => contents["MaxAge"],
          :lifespan           => contents["Lifespan"],
          :moves              => contents["Moves"],
          :tutor_moves        => contents["TutorMoves"],
          :egg_moves          => contents["EggMoves"],
          :abilities          => contents["Abilities"],
          :hidden_abilities   => contents["HiddenAbilities"] || contents["HiddenAbility"],
          :wild_item_common   => contents["WildItemCommon"],
          :wild_item_uncommon => contents["WildItemUncommon"],
          :wild_item_rare     => contents["WildItemRare"],
          :egg_groups         => contents["EggGroups"] || contents["Compatibility"],
          :hatch_steps        => contents["HatchSteps"] || contents["StepsToHatch"],
          :incense            => contents["Incense"],
          :offspring          => contents["Offspring"],
          :evolutions         => contents["Evolutions"],
          :height             => contents["Height"],
          :weight             => contents["Weight"],
          :color              => contents["Color"],
          :shape              => contents["Shape"],
          :habitat            => contents["Habitat"],
          :generation         => contents["Generation"],
          :flags              => contents["Flags"]
        }
        # Add species' data to records
        GameData::Species.register(species_hash)
        species_names.push(species_hash[:name])
        species_form_names.push(species_hash[:form_name])
        species_categories.push(species_hash[:category])
        species_pokedex_entries.push(species_hash[:pokedex_entry])
        # Save metrics data if defined (backwards compatibility)
        if contents["BattlerPlayerX"] || contents["BattlerPlayerY"] ||
           contents["BattlerEnemyX"] || contents["BattlerEnemyY"] ||
           contents["BattlerAltitude"] || contents["BattlerShadowX"] ||
           contents["BattlerShadowSize"]
          metrics_hash = {
            :id                    => contents["InternalName"].to_sym,
            :back_sprite           => [contents["BattlerPlayerX"] || 0, contents["BattlerPlayerY"] || 0],
            :front_sprite          => [contents["BattlerEnemyX"] || 0, contents["BattlerEnemyY"] || 0],
            :front_sprite_altitude => contents["BattlerAltitude"] || 0,
            :shadow_x              => contents["BattlerShadowX"] || 0,
            :shadow_size           => contents["BattlerShadowSize"] || 2
          }
          GameData::SpeciesMetrics.register(metrics_hash)
        end
      }
    }
    # Enumerate all offspring species (this couldn't be done earlier)
    GameData::Species.each do |species|
      FileLineData.setSection(species.id.to_s, "Offspring", nil)   # For error reporting
      offspring = species.offspring
      offspring.each_with_index do |sp, i|
        offspring[i] = csvEnumField!(sp, :Species, "Offspring", species.id)
      end
    end
    # Enumerate all evolution species and parameters (this couldn't be done earlier)
    GameData::Species.each do |species|
      FileLineData.setSection(species.id.to_s, "Evolutions", nil)   # For error reporting
      species.evolutions.each do |evo|
        evo[0] = csvEnumField!(evo[0], :Species, "Evolutions", species.id)
        param_type = GameData::Evolution.get(evo[1]).parameter
        if param_type.nil?
          evo[2] = nil
        elsif param_type == Integer
          evo[2] = csvPosInt!(evo[2])
        elsif param_type != String
          evo[2] = csvEnumField!(evo[2], param_type, "Evolutions", species.id)
        end
      end
    end
    # Add prevolution "evolution" entry for all evolved species
    all_evos = {}
    GameData::Species.each do |species|   # Build a hash of prevolutions for each species
      species.evolutions.each do |evo|
        all_evos[evo[0]] = [species.species, evo[1], evo[2], true] if !all_evos[evo[0]]
      end
    end
    GameData::Species.each do |species|   # Distribute prevolutions
      species.evolutions.push(all_evos[species.species].clone) if all_evos[species.species]
    end
    # Save all data
    GameData::Species.save
    GameData::SpeciesMetrics.save
    MessageTypes.setMessagesAsHash(MessageTypes::Species, species_names)
    MessageTypes.setMessagesAsHash(MessageTypes::FormNames, species_form_names)
    MessageTypes.setMessagesAsHash(MessageTypes::Kinds, species_categories)
    MessageTypes.setMessagesAsHash(MessageTypes::Entries, species_pokedex_entries)
    process_pbs_file_message_end
  end

end 


def pbSetTemperature
  $PokemonSystem.temperaturemeasurement = 18 if (pbGetTimeNow.mon==3 && pbGetTimeNow.day==22)
  $PokemonSystem.temperaturemeasurement = 35 if (pbGetTimeNow.mon==6 && pbGetTimeNow.day==21)
  $PokemonSystem.temperaturemeasurement = 12 if (pbGetTimeNow.mon==9 && pbGetTimeNow.day==21)
  $PokemonSystem.temperaturemeasurement = 0 if (pbGetTimeNow.mon == 10 && pbGetTimeNow.day ==22)
end

def pbAmbientTemperature
   case pbGetTimeNow.mon
   when 0 #Jan
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement-7 #ambienttemperature
   when 1 #Feb
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement-5
   when 2 #Mar
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement-1
   when 3 #April
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement-0
   when 4 #may
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+1
   when 5 #june
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+2
   when 6 #july
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+5
   when 7 #august
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+7
   when 8 #september
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+1
   when 9 #october
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+3
   when 10 #november
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+4
   when 11 #december
    $PokemonSystem.temperaturemeasurement = $PokemonSystem.temperaturemeasurement+6
 end

end

def pbSleepRestore
 $player.playerstamina = $player.playermaxstamina
 if $player.playersleep<200
  $player.playersleep=$player.playersleep+($game_variables[247]*9)
 end
 if $player.playersaturation==0
   $player.playerfood=$player.playerfood-($game_variables[247]*2)
   $player.playerwater=$player.playerwater-($game_variables[247]*2)
   
  else
   $player.playersaturation=$player.playersaturation-($game_variables[247]*2)
 end
  deposited = DayCare.count
  if deposited==2 && $PokemonGlobal.daycareEgg==0
    $PokemonGlobal.daycareEggSteps = 0 if !$PokemonGlobal.daycareEggSteps
    $PokemonGlobal.daycareEggSteps += (1*$game_variables[247]*10)
  end
 end
 
 
 
 def pbEatingPkmn(item,pkmn)
 
pbMessage(_INTL("You offered {1} a {2}.",pkmn,item))
$PokemonBag.pbDeleteItem(item)
if item == :ORANBERRY
pkmn.food+=4
pkmn.water+=1
return 1
elsif item == :LEPPABERRY
pkmn.food+=5
pkmn.water+=2
return 1
elsif item == :CHERIBERRY
pkmn.food+=5
pkmn.water+=2
return 1
elsif item == :CHESTOBERRY
pkmn.food+=5
pkmn.water+=2
return 1
elsif item == :PECHABERRY
pkmn.food+=5
pkmn.water+=2
return 1
elsif item == :RAWSTBERRY
pkmn.food+=5
pkmn.water+=2
return 1
elsif item == :ASPEARBERRY
pkmn.food+=5
pkmn.water+=2
return 1
elsif item == :PERSIMBERRY
pkmn.food+=5
pkmn.water+=2
return 1
elsif item == :LUMBERRY
pkmn.food+=5
pkmn.water+=2
return 1
elsif item == :FIGYBERRY
pkmn.food+=5
pkmn.water+=2
return 1
elsif item == :WIKIBERRY
pkmn.food+=5
pkmn.water+=2
return 1
elsif item == :MAGOBERRY
pkmn.food+=5
pkmn.water+=2
return 1
elsif item == :AGUAVBERRY
pkmn.food+=5
pkmn.water+=2
return 1
elsif item == :IAPAPABERRY
pkmn.food+=5
pkmn.water+=2
return 1
elsif item == :IAPAPABERRY
pkmn.food+=5
pkmn.water+=2
return 1
elsif item == :SITRUSBERRY
pkmn.food+=5
pkmn.water+=1
return 1
elsif item == :BERRYJUICE
pkmn.food+=2
pkmn.water+=10
return 1
elsif item == :FRESHWATER
pkmn.water+=20
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
#You can add more if you want
elsif item == :ATKCURRY
pkmn.food+=8
pkmn.water-=7
return 1
elsif item == :SATKCURRY
pkmn.food+=8
pkmn.water-=7
return 1
elsif item == :SPEEDCURRY
pkmn.food+=8
pkmn.water-=7
return 1
elsif item == :SPDEFCURRY
pkmn.food+=8
pkmn.water-=7
return 1
elsif item == :ACCCURRY
pkmn.food+=8
pkmn.water-=7
return 1
elsif item == :DEFCURRY
pkmn.food+=8
pkmn.water-=7
return 1
elsif item == :CRITCURRY
pkmn.food+=8
pkmn.water-=7
return 1
elsif item == :GSCURRY
pkmn.food+=8#205 is Hunger
pkmn.water-=7#206 is Thirst
return 1
elsif item == :RAGECANDYBAR #chocolate
pkmn.food+=10
return 1
elsif item == :SWEETHEART #chocolate
pkmn.food+=10#205 is Hunger
return 1
elsif item == :SODAPOP
pkmn.water-=11#206 is Thirst
return 1
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
elsif item == :LEMONADE
pkmn.water+=10#206 is Thirst
return 1
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
elsif item == :HONEY
pkmn.water+=2#206 is Thirst
pkmn.food+=6#205 is Hunger
return 1
elsif item == :MOOMOOMILK
pkmn.water+=15
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
elsif item == :CSLOWPOKETAIL
pkmn.food+=10#205 is Hunger
return 1
elsif item == :BAKEDPOTATO
pkmn.water+=4#206 is Thirst
pkmn.food+=7#205 is Hunger
return 1
elsif item == :APPLE
pkmn.water+=3#206 is Thirst
pkmn.food+=3#205 is Hunger
return 1
elsif item == :CHOCOLATE
pkmn.food+=7#205 is Hunger
return 1
elsif item == :LEMON
pkmn.water+=3#206 is Thirst
pkmn.food+=4#205 is Hunger
return 1
elsif item == :OLDGATEAU
pkmn.water+=2#206 is Thirst
pkmn.food+=6#205 is Hunger
return 1
elsif item == :LAVACOOKIE
pkmn.water-=3#206 is Thirst
pkmn.food+=6#205 is Hunger
return 1
elsif item == :CASTELIACONE
pkmn.water+=7#206 is Thirst
pkmn.food+=7#205 is Hunger
return 1
elsif item == :LUMIOSEGALETTE
pkmn.food+=6#205 is Hunger
return 1
elsif item == :SHALOURSABLE
pkmn.food+=8#205 is Hunger
return 1
elsif item == :BIGMALASADA
pkmn.food+=8#205 is Hunger
return 1
elsif item == :ONION
pkmn.water+=3#206 is Thirst
pkmn.food+=3#205 is Hunger
return 1
elsif item == :COOKEDORAN
pkmn.water+=6#206 is Thirst
pkmn.food+=6#205 is Hunger
return 1
elsif item == :CARROT
pkmn.water+=3#206 is Thirst
pkmn.food+=3#205 is Hunger
return 1
elsif item == :BREAD
pkmn.water+=7#206 is Thirst
pkmn.food+=11#205 is Hunger
return 1
elsif item == :TEA
pkmn.water+=8#206 is Thirst
pkmn.food+=2#205 is Hunger
return 1
elsif item == :CARROTCAKE
pkmn.water+=15#206 is Thirst
pkmn.food+=10#205 is Hunger
return 1
elsif item == :COOKEDMEAT
pkmn.water+=0#206 is Thirst
pkmn.food+=20#205 is Hunger
return 1
elsif item == :SITRUSJUICE
pkmn.water+=25#206 is Thirst
pkmn.food+=0#205 is Hunger
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
elsif item == :BERRYMASH
pkmn.water+=5#206 is Thirst
pkmn.food+=5#205 is Hunger
return 1
elsif item == :LARGEMEAL
pkmn.water+=50#206 is Thirst
pkmn.food+=50#205 is Hunger
 if @pokemon_count==6
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[2].ev[:DEFENSE] += 1
  @party[3].ev[:DEFENSE] += 1
  @party[4].ev[:DEFENSE] += 1
  @party[5].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
  @party[2].ev[:HP] += 1
  @party[3].ev[:HP] += 1
  @party[4].ev[:HP] += 1
  @party[5].ev[:HP] += 1
 elsif @pokemon_count==5
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[2].ev[:DEFENSE] += 1
  @party[3].ev[:DEFENSE] += 1
  @party[4].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
  @party[2].ev[:HP] += 1
  @party[3].ev[:HP] += 1
  @party[4].ev[:HP] += 1
 elsif @pokemon_count==4
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[2].ev[:DEFENSE] += 1
  @party[3].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
  @party[2].ev[:HP] += 1
  @party[3].ev[:HP] += 1
 elsif @pokemon_count==3
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[2].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
  @party[2].ev[:HP] += 1
 elsif @pokemon_count==2
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
 elsif @pokemon_count==1
  @party[0].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
 end
return 1
else
$PokemonBag.pbStoreItem(item,1)
return 0
end
end

 
 def pbEating(bag,item)
 
pbMessage(_INTL("You ate/drank {1}.",item))
$PokemonBag.pbDeleteItem(item)
if item == :ORANBERRY
$player.playerfood+=4
$player.playersaturation+=3
$player.playerwater+=1
$player.playerhealth += 1
return 1
elsif item == :LEPPABERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :CHERIBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :CHESTOBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :PECHABERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :RAWSTBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :ASPEARBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :PERSIMBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :LUMBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :FIGYBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :WIKIBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :MAGOBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :AGUAVBERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :IAPAPABERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :IAPAPABERRY
$player.playerfood+=5
$player.playersaturation+=2
$player.playerwater+=2
return 1
elsif item == :SITRUSBERRY
$player.playerfood+=5
$player.playersaturation+=7
$player.playerwater+=1
$player.playerhealth += 4
return 1
elsif item == :BERRYJUICE
$player.playerfood+=2
$player.playersaturation+=2
$player.playerwater+=10
$player.playerhealth += 2
return 1
elsif item == :FRESHWATER
$player.playerwater+=20
$player.playersaturation+=10#207 is Saturation
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
#You can add more if you want
elsif item == :ATKCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return 1
elsif item == :SATKCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return 1
elsif item == :SPEEDCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return 1
elsif item == :SPDEFCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return 1
elsif item == :ACCCURRY
$player.playerfood+=8
$player.playersaturation+=12
$player.playerwater-=7
return 1
elsif item == :DEFCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return 1
elsif item == :CRITCURRY
$player.playerfood+=8
$player.playersaturation+=15
$player.playerwater-=7
return 1
elsif item == :GSCURRY
$player.playerfood+=8#205 is Hunger
$player.playersaturation+=5#207 is Saturation
$player.playerwater-=7#206 is Thirst
return 1
elsif item == :RAGECANDYBAR #chocolate
$player.playerfood+=10
$player.playersaturation+=3
$player.playersleep+=7
return 1
elsif item == :SWEETHEART #chocolate
$player.playerfood+=10#205 is Hunger
$player.playersaturation+=5#207 is Saturation
$player.playersleep+=6#208 is Sleep
return 1
elsif item == :SODAPOP
$player.playerwater-=11#206 is Thirst
$player.playersaturation+=11#207 is Saturation
$player.playersleep+=10#208 is Sleep
return 1
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
elsif item == :LEMONADE
$player.playersaturation+=11#207 is Saturation
$player.playerwater+=10#206 is Thirst
$player.playersleep+=7#208 is Sleep
return 1
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
elsif item == :HONEY
$player.playersaturation+=20#207 is Saturation
$player.playerwater+=2#206 is Thirst
$player.playerfood+=6#205 is Hunger
return 1
elsif item == :MOOMOOMILK
$player.playersaturation+=10
$player.playerwater+=15
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
elsif item == :CSLOWPOKETAIL
$player.playersaturation+=10#207 is Saturation
$player.playerfood+=10#205 is Hunger
return 1
elsif item == :BAKEDPOTATO
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=4#206 is Thirst
$player.playerfood+=7#205 is Hunger
return 1
elsif item == :APPLE
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=3#206 is Thirst
$player.playerfood+=3#205 is Hunger
return 1
elsif item == :CHOCOLATE
$player.playersaturation+=5#207 is Saturation
$player.playerfood+=7#205 is Hunger
return 1
elsif item == :LEMON
$player.playersaturation+=3#207 is Saturation
$player.playerwater+=3#206 is Thirst
$player.playerfood+=4#205 is Hunger
return 1
elsif item == :OLDGATEAU
$player.playersaturation+=6#207 is Saturation
$player.playerwater+=2#206 is Thirst
$player.playerfood+=6#205 is Hunger
return 1
elsif item == :LAVACOOKIE
$player.playersaturation+=5#207 is Saturation
$player.playerwater-=3#206 is Thirst
$player.playerfood+=6#205 is Hunger
return 1
elsif item == :CASTELIACONE
$player.playerwater+=7#206 is Thirst
$player.playerfood+=7#205 is Hunger
return 1
elsif item == :LUMIOSEGALETTE
$player.playersaturation+=5#207 is Saturation
$player.playerfood+=6#205 is Hunger
return 1
elsif item == :SHALOURSABLE
$player.playersaturation+=8#207 is Saturation
$player.playerfood+=8#205 is Hunger
return 1
elsif item == :BIGMALASADA
$player.playersaturation+=8#207 is Saturation
$player.playerfood+=8#205 is Hunger
return 1
elsif item == :ONION
$player.playersaturation+=5#207 is Saturation
$player.playerwater+=3#206 is Thirst
$player.playerfood+=3#205 is Hunger
return 1
elsif item == :COOKEDORAN
$player.playersaturation+=6#207 is Saturation
$player.playerwater+=6#206 is Thirst
$player.playerfood+=6#205 is Hunger
return 1
elsif item == :CARROT
$player.playersaturation+=6#207 is Saturation
$player.playerwater+=3#206 is Thirst
$player.playerfood+=3#205 is Hunger
return 1
elsif item == :BREAD
$player.playersaturation+=10#207 is Saturation
$player.playerwater+=7#206 is Thirst
$player.playerfood+=11#205 is Hunger
return 1
elsif item == :TEA
$player.playersaturation+=15#207 is Saturation
$player.playerwater+=8#206 is Thirst
$player.playerfood+=2#205 is Hunger
return 1
elsif item == :CARROTCAKE
$player.playersaturation+=15#207 is Saturation
$player.playerwater+=15#206 is Thirst
$player.playerfood+=10#205 is Hunger
return 1
elsif item == :COOKEDMEAT
$player.playersaturation+=40#207 is Saturation
$player.playerwater+=0#206 is Thirst
$player.playerfood+=20#205 is Hunger
return 1
elsif item == :SITRUSJUICE
$player.playersaturation+=20#207 is Saturation
$player.playerwater+=25#206 is Thirst
$player.playerfood+=0#205 is Hunger
$PokemonBag.pbStoreItem(:GLASSBOTTLE,1)
Kernel.pbMessage(_INTL("You put the bottle in your Bag."))
return 1
elsif item == :BERRYMASH
$player.playersaturation+=5#207 is Saturation
$player.playerwater+=5#206 is Thirst
$player.playerfood+=5#205 is Hunger
return 1
elsif item == :LARGEMEAL
$player.playersaturation+=50#207 is Saturation
$player.playerwater+=50#206 is Thirst
$player.playerfood+=50#205 is Hunger
$player.playerstaminamod+=15#205 is Hunger
 if @pokemon_count==6
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[2].ev[:DEFENSE] += 1
  @party[3].ev[:DEFENSE] += 1
  @party[4].ev[:DEFENSE] += 1
  @party[5].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
  @party[2].ev[:HP] += 1
  @party[3].ev[:HP] += 1
  @party[4].ev[:HP] += 1
  @party[5].ev[:HP] += 1
 elsif @pokemon_count==5
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[2].ev[:DEFENSE] += 1
  @party[3].ev[:DEFENSE] += 1
  @party[4].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
  @party[2].ev[:HP] += 1
  @party[3].ev[:HP] += 1
  @party[4].ev[:HP] += 1
 elsif @pokemon_count==4
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[2].ev[:DEFENSE] += 1
  @party[3].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
  @party[2].ev[:HP] += 1
  @party[3].ev[:HP] += 1
 elsif @pokemon_count==3
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[2].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
  @party[2].ev[:HP] += 1
 elsif @pokemon_count==2
  @party[0].ev[:DEFENSE] += 1
  @party[1].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
  @party[1].ev[:HP] += 1
 elsif @pokemon_count==1
  @party[0].ev[:DEFENSE] += 1
  @party[0].ev[:HP] += 1
 end
return 1
else
$PokemonBag.pbStoreItem(item,1)
return 0
end
end



 def pbMedicine(bag,item)
 return if $player.playerhealth == 100
pbMessage(_INTL("You used {1} to heal yourself.",item))
$PokemonBag.pbDeleteItem(item)
#205 is Hunger, 207 is Saturation, 206 is Thirst, 208 is Sleep
if item == :POTION
$player.playerhealth += 20
return 1
elsif item == :SUPERPOTION
$player.playerhealth += 40
return 1
elsif item == :HYPERPOTION
$player.playerhealth += 60
return 1
elsif item == :FULLRESTORE
$player.playerhealth += 100
return 1
else
$PokemonBag.pbStoreItem(item,1)
return 0
#full belly
end
end

def pbEndGame
 if $PokemonSystem.survivalmode = 0 && $player.playerhealth <= 0
  if $scene.is_a?(Scene_Map)
      pbFadeOutIn(99999){
         $game_temp.player_transferring = true
         $game_temp.player_new_map_id=292  
         $game_temp.player_new_x=002
         $game_temp.player_new_y=007
         $game_temp.player_new_direction=$PokemonGlobal.pokecenterDirection
         $scene.transfer_player
         $game_map.refresh
		 $scene = nil
		 exit!
    	 menu.pbShowMenu
      }
    end
  end
end




def checkHours(hour) # Hour is 0..23
  timeNow = pbGetTimeNow.hour
  timeHour = hour
  return true if timeNow == timeHour 
end

class PokemonSystem
  attr_accessor :survivalmode
  attr_accessor :temperature

  def initialize
    @textspeed     = 1     # Text speed (0=slow, 1=normal, 2=fast)
    @battlescene   = 0     # Battle effects (animations) (0=on, 1=off)
    @battlestyle   = 0     # Battle style (0=switch, 1=set)
    @sendtoboxes   = 0     # Send to Boxes (0=manual, 1=automatic)
    @givenicknames = 0     # Give nicknames (0=give, 1=don't give)
    @frame         = 0     # Default window frame (see also Settings::MENU_WINDOWSKINS)
    @textskin      = 0     # Speech frame
    @screensize    = (Settings::SCREEN_SCALE * 2).floor - 1   # 0=half size, 1=full size, 2=full-and-a-half size, 3=double size
    @language      = 0     # Language (see also Settings::LANGUAGES in script PokemonSystem)
    @runstyle      = 0     # Default movement speed (0=walk, 1=run)
    @bgmvolume     = 100   # Volume of background music and ME
    @sevolume      = 100   # Volume of sound effects
    @textinput     = 0     # Text input mode (0=cursor, 1=keyboard)
    @temperature = 1     # Default Temperature Mode (0=on, 1=off)	 
    @nuzlockemode = 1     # Default Nuzlocke Mode (0=on, 1=off)
  end
end




MenuHandlers.add(:options_menu, :survivalmode, {
  "name"        => _INTL("Survival Mode"),
  "order"       => 37,
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "description" => _INTL("Choose whether or not you play in Survival Mode."),
  "get_proc"    => proc { next $PokemonSystem.survivalmode },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.survivalmode = value }
})

MenuHandlers.add(:options_menu, :temperature, {
  "name"        => _INTL("Ambient Temperature"),
  "order"       => 39,
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "description" => _INTL("Choose whether or not Survival Mode has Temperature Mechanics."),
  "get_proc"    => proc { next $PokemonSystem.temperature },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.temperature = value }
})