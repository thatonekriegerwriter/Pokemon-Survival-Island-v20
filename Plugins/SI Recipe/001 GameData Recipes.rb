module GameData
  class Recipe
    attr_reader :id

    DATA = {}
    DATA_FILENAME = "recipes.dat"
    PBS_BASE_FILENAME = "recipes"

    SCHEMA = {
      "Name"          => [:name,        "s"],
      "Result"         => [:result, "*e", :Item],
      "Yield"          => [:yield, "v"],
      "Recipe"         => [:recipe, "*sv"],
      "Station"       => [:station, "*e", :Item],
      "CookingTime"    => [:cookingtime, "u"],
      "Locked"       => [:locked, "b"],
	  "Type" => [:type, "s"],
      "Flags"         => [:flags,       "*s"]
    }

    extend ClassMethodsSymbols
    include InstanceMethods
  

    def initialize(hash)
      @id                  = hash[:id]
      @name                = hash[:name]        || "Recipe"
      @result              = hash[:result] || :NO
      @yield              = hash[:yield] || 1
	  raw_recipe = hash[:recipe] || []
      @recipe              = raw_recipe.map do |entry|
	    next if entry.nil? 
		item, qty = Array(entry)
		[item.to_sym, qty || 1]
	  end.compact
	  #puts "#{@id} - #{@recipe}"
	  @type                = (hash[:type] || "MATERIAL").to_sym
      @station             = hash[:station] || :CRAFTINGBENCH
      @cookingtime          = hash[:cookingtime] || 2000
      @locked             = hash[:locked] || false
      @flags               = hash[:flags]       || []
    end
	

    def yield
      return @yield
    end

    def name
      return @name
    end

    def result
      return @result
    end

    def results
      return @result[0]
    end
	
    def type
	  return @type
	end 
    def recipe
      return @recipe
    end
    
	def include?(id)
	 @recipe.any? { |item, _qty| item == id }
	end 
	
    def cookingtime
      return @cookingtime
    end
    def time
      return @cookingtime
	end 
    def station
      return @station
    end

    def locked
      return @locked
    end

    def locked?
      return @locked
    end

    def has_flag?(flag)
      return @flags.any? { |f| f.downcase == flag.downcase }
    end
end
end
