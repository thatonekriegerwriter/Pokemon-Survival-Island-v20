module ClassMethodsSymbols

    def select
      result = []
      self::DATA.each_value do |value|
         result << value if yield value
      end
      return result
    end

end 

class ResearchTableData
   attr_reader :researching_item
   attr_accessor :time_last_updated
   attr_accessor :research_stage
   attr_reader   :active_researches
   
   def initialize
     reset
   end 
  
   def reset
    @researching_item   = nil
	@item_id            = nil
    @time_last_updated  = 0
    @time_alive         = 0
	@research_stage     = 0
	@active_researches    = nil
   end 

   def research(item)
     reset
     @researching_item   = item
	 @item_id            = item.id
     @time_last_updated  = pbGetTimeNow.to_i
	 @research_stage     = 1
	 @active_researches    = GameData::Research.select do |research| 
	  research.unlock_item == @item_id && !$recipe_book.has?(research.associated_recipe)
	 end 
   end 
   
   def researching_item=(item)
     @researching_item   = item
	 @item_id            = item.id
   end 
   
   def researching?
     return !@active_researches.empty? && @research_stage > 0 && @research_stage < @active_researches[0].stage_amt
   end 

   def complete?
     return !@active_researches.empty? && @research_stage >= @active_researches[0].stage_amt
   end
   
   def update
     return false unless researching?
     time_now = pbGetTimeNow
     time_delta = time_now.to_i - @time_last_updated
     return false if time_delta <= 0
     new_time_alive = @time_alive + time_delta
     research_data = @active_researches.sample
	 time_per_stage = research_data.hours_per_stage * 3600
     old_research_stage = @research_stage
     @time_alive = new_time_alive
     @research_stage = 1 + (@time_alive / time_per_stage)
     @time_last_updated = time_now.to_i
	 if complete?
	    recipe = GameData::Recipe.get(research_data.associated_recipe)
	    sideDisplay(_INTL("You have learned #{recipe.name}."))
	    $recipe_book.add(research_data.associated_recipe)
	    reset
		return true 
	 end 
	 return false 
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
end
end
