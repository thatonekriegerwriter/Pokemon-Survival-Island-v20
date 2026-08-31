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
   attr_accessor :event_id
   attr_accessor :time_last_updated
   attr_accessor :research_stage
   attr_reader   :active_researches
   attr_accessor :time_last_message
   
   def initialize(event_id)
     @event_id = event_id 
     reset
   end 
   
   def event = $game_map.events[@event_id]
   def reset
    @researching_item   = nil
	@item_id            = nil
    @time_last_updated  = 0
    @time_alive         = 0
	@research_stage     = 0
	@active_researches    = []
	@cur_research = nil
	@time_last_message = 0
   end 
   
   def workers
    event.workers.current_workers 
   end 
   
   def serious_workers_count
    workers.count do |worker|
     worker && worker.pokemon && worker.pokemon.nature == :SERIOUS
    end
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
	 @cur_research = @active_researches.sample
	 @time_last_message = pbGetTimeNow.to_i + rand(20..45)
   end 
   
   def researching_item=(item)
     @researching_item   = item
	 @item_id            = item.id
   end 
   
   def researching?
     return !@active_researches.empty? && @research_stage > 0 && @research_stage < @cur_research.stage_amt
   end 

   def complete?
     return !@active_researches.empty? && @research_stage >= @cur_research.stage_amt
   end
   
   def update(multiplier = 1)
    # puts "Research Table (#{event.id}) updating..."
     return false unless researching?
     time_now = pbGetTimeNow
     time_delta = time_now.to_i - @time_last_updated
     return false if time_delta <= 0
	 multiplier += workers.sum do |worker_id|
	   worker = $game_map.events[worker_id]
       next 0.0 unless worker
       next 0.0 unless worker&.pokemon
       worker&.pokemon&.nature == :SERIOUS ? 0.5 : 0.25
     end
	 time_delta *= multiplier
	 
     new_time_alive = @time_alive + time_delta
	 time_per_stage = @cur_research.hours_per_stage * 3600
     old_research_stage = @research_stage
     @time_alive = new_time_alive
     @research_stage = 1 + (@time_alive / time_per_stage)
     @time_last_updated = time_now.to_i
	 if complete?
	    recipe = GameData::Recipe.get(@cur_research.associated_recipe)
	    sideDisplay(_INTL("You have learned #{recipe.name}."))
	    $recipe_book.add(@cur_research.associated_recipe)
	    reset
		return true 
	 end 
	 return false 
   end 
   
   def unlock_item
     GameData::Item.get(@cur_research.unlock_item)
   end 
   def research_progress
    return 0.0 if @cur_research.nil?
    time_per_stage = @cur_research.hours_per_stage * 3600
    total_time = @cur_research.stage_amt * time_per_stage
    @time_alive.to_f / total_time
  end
   def text_for_stage
     case research_progress
      when 0.0...0.25
       return _INTL("You aren't quite sure what #{@researching_item.name} can be used for.")
      when 0.25...0.50
       return _INTL("You have developed a few ideas on how to use #{@researching_item.name}.")
      when 0.50...0.75
       return _INTL("You are researching using #{@researching_item.name} to make #{self.unlock_item.name}.")
      when 0.75...0.99
       return _INTL("You are close to figuring out the recipe for #{self.unlock_item.name}.")
     end
   end 
   
   def text_for_stage_internal
     case research_progress
      when 0.0...0.25
       return _INTL("You aren't quite sure what #{@researching_item.name} can be used for.")
      when 0.25...0.50
       return _INTL("#{@researching_item.name} has a lot of potential.")
      when 0.50...0.75
       return _INTL("You have set your thoughts on figuring out how to make #{self.unlock_item.name}.")
      when 0.75...0.99
       return _INTL("You are close to figuring out how to make #{self.unlock_item.name}.")
     end
   end 
   
   def research_flavor
     case research_progress
      when 0.0...0.50
       flavor = [
                 _INTL("You consider another possibility."),
                 _INTL("You aren't convinced that idea is correct."),
                 _INTL("You think there may be another use for #{@researching_item.name}."),
                 _INTL("You jot down a few thoughts."),
                 _INTL("You reconsider one of your earlier ideas."),
                 _INTL("You wonder if you're overlooking something.")
                ]
     else
       flavor = [
                 _INTL("You wonder if you are on the right track with #{self.unlock_item.name}."),
                 _INTL("You quickly write down a few more ideas for later."),
                 _INTL("You feel like you are progressing well."),
                 _INTL("You jot down a few thoughts."),
                 _INTL("You reconsider one of your earlier ideas."),
                 _INTL("You wonder if you're overlooking something.")
                ]
	 end
	 flavor.sample
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


def pbResearchTable(item_id, data)
 if data.researching?
  completed = data.update
  unless completed
    sideDisplay(data.text_for_stage)
  end 
 else
   pbCraftingBench(item_id, data)
 end 

end 