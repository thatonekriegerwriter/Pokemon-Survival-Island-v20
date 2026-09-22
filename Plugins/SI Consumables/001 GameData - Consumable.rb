 
module GameData
  class Consumable
    attr_reader :id
    attr_reader :priority
    attr_reader :servings
    attr_reader :flavor
    attr_reader :food
    attr_reader :water
    attr_reader :saturation
    attr_reader :sleep
    attr_reader :health
    attr_reader :se
    attr_reader :diseases
    attr_reader :status
    attr_reader :healthiness
	
    DATA = {}
    DATA_FILENAME = "consumables.dat"
    SERVINGS = [:TINY, :SMALL, :AVERAGE, :LARGE, :HUGE, :FEAST]
	STAMINA_VALUES = {
	  :TINY => 0,
	  :SMALL => 5,
	  :AVERAGE => 10,
	  :LARGE => 20,
	  :HUGE => 25,
	  :FEAST => 25
	}
    SCHEMA = {
      "SpoilingRate" => [:spoiling_rate, "u"],
      "Priority"     => [:priority,      "u"],
      "Servings"     => [:servings,      "s"],
	  "FeastBoosts"  => [:feast_boosts, "*ev", :Stat],
      "Flavor"       => [:flavor,        "uuuuu"],
      "Food"         => [:food,          "i"],
      "Water"        => [:water,         "i"],
      "Saturation"   => [:saturation,    "i"],
      "Sleep"        => [:sleep,         "i"],
      "Health"       => [:health,        "f"], 
      "Healthiness"  => [:healthiness,   "i"], 
      "Status"       => [:status,        "e", :Status],
      "Bottle"       => [:bottle,        "b"],
      "Diseases"     => [:diseases,      "*e", :Diseases],
      "SE"           => [:se,            "s"]
    }

    extend ClassMethodsSymbols
    include InstanceMethods
	
	def initialize(hash)
	  @id = hash[:id]
	  @spoiling_rate = hash[:spoiling_rate]  || 1
	  @priority = hash[:priority]            || 1
	  @servings = (hash[:servings]            || "AVERAGE").to_s.upcase.to_sym
	  if !SERVINGS.include?(@servings)
        raise _INTL("Consumable {1}: unknown Servings '{2}'", @id, @servings)
      end
	  @flavor = hash[:flavor]                || [0,0,0,0,0]
	  @feast_boosts = hash[:feast_boosts]    || []
	  @food = hash[:food]                    || 0
	  @water = hash[:water]                  || 0
	  @saturation = hash[:saturation]        || 0
	  @sleep = hash[:sleep]                  || 0
	  @health = hash[:health]                || 0 
	  @healthiness = hash[:healthiness]      || 0 
	  @status = hash[:status]
	  @bottle = hash[:bottle]                || false 
	  @diseases = hash[:diseases]            || []
	  @se = hash[:se]
	end 
	
	def spoiling_rate
	  @spoiling_rate
	end 
	def feast?
	  @servings == :FEAST && !self.feast.empty?
	end 
	
	def feast
	  @feast_boosts
	end 
	
	def stamina
	  STAMINA_VALUES[@servings]
	end 
	
	def uses_bottle?
	  @bottle 
	end 
	
  end 
end 
 
module Compiler
     module_function
 def compile_consumables(path = "PBS/consumables.txt")
    compile_pbs_file_message_start(path)
    GameData::Consumable::DATA.clear
    schema = GameData::Consumable::SCHEMA
    item_hash = nil
    old_format = nil
    # Read each line of berry_plants.txt at a time and compile it into a berry plant
    idx = 0
    pbCompilerEachPreppedLine(path) { |line, line_no|
      echo "." if idx % 250 == 0
      idx += 1
      if line[/^\s*\[\s*(.+)\s*\]\s*$/]   # New section [item_id]
        old_format = false if old_format.nil?
        if old_format
          raise _INTL("Can't mix old and new formats.\r\n{1}", FileLineData.linereport)
        end
        GameData::Consumable.register(item_hash) if item_hash
        # Add previous berry plant's data to records
        item_id = $~[1].to_sym
        item_hash = {
          :id => item_id
        }
      elsif line[/^\s*(\w+)\s*=\s*(.*)\s*$/]   # XXX=YYY lines
          if !item_hash
            raise _INTL("Expected a section at the beginning of the file.\r\n{1}", FileLineData.linereport)
          end
          # Parse property and value
          property_name = $~[1]
          line_schema = schema[property_name]
          next if !line_schema
          property_value = pbGetCsvRecord($~[2], line_no, line_schema)
          # Record XXX=YYY setting
          item_hash[line_schema[0]] = property_value
    end
    }
    # Add last berry plant's data to records
    GameData::Consumable.register(item_hash) if item_hash
    # Save all data
    GameData::Consumable.save
    process_pbs_file_message_end
 end
end 