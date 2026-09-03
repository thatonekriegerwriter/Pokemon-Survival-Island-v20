module ClassMethodsSymbols

    def select
      result = []
      self::DATA.each_value do |value|
         result << value if yield value
      end
      return result
    end

end 


module GameData
  class Research
    attr_reader :id
    attr_reader :name
    attr_reader :stage_amt
    attr_reader :hours_per_stage
    attr_reader :unlock_item
    attr_reader :associated_recipe
    attr_reader :flags

    DATA = {}
    DATA_FILENAME = "research.dat"
    PBS_BASE_FILENAME = "research"

    SCHEMA = {
      "Name" => [:name,        "s"],
      "HoursPerStage" => [:hours_per_stage, "u"],
      "StageAmt" => [:stage_amt, "u"],
      "UnlockItem" => [:unlock_item, "e", :Item],
      "AssociatedRecipe" => [:associated_recipe, "e", :Recipe],
      "Flags"         => [:flags,       "*s"]
    }

    extend ClassMethodsSymbols
    include InstanceMethods
  

    def initialize(hash)
      @id               = hash[:id]
      @name             = hash[:name]        || "Unnamed"
      @stage_amt        = hash[:stage_amt] || 5
      @hours_per_stage  = hash[:hours_per_stage] || 1
      @unlock_item      = hash[:unlock_item] || nil
      @associated_recipe= hash[:associated_recipe] || nil
      @flags            = hash[:flags]       || []
    end
	

    def name
      return @name
    end



    def has_flag?(flag)
      return @flags.any? { |f| f.downcase == flag.downcase }
    end
	
	def self.can_research?(item_id) 
	 researches = GameData::Research.select do |research| 
	    research.unlock_item == item_id && !$recipe_book.has?(research.associated_recipe)
	  end 
	 !researches.empty?
	end 
end
end
