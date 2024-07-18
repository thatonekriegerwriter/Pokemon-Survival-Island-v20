class Player < Trainer
  class Pokedex

    alias dewmpt_clear clear
    def clear
      @tasks = {} # Clear task data in Pokedex
      @tasks_completed = {}
      dewmpt_clear
    end


    def give_tasks(species)
	      species_id = GameData::Species.try_get(species)&.species
      if @tasks.nil?
	   @tasks={}
	  end
      if @tasks_completed.nil?
	   @tasks_completed={}
	  end
      if @tasks[species_id.name].nil?
        # Create record if one does not exist
        @tasks[species_id.name] = [] # if @tasks[species_id.name].nil?
        # Initialize all tasks to 0
        tasks = pbLoadTasks[species_id.name]
		if !tasks.nil?
		
		tasks.each do |task|
          # @tasks[species_id.name] == [{ :task => TASK_NAME, :move_item => MOVE|ITEM, :progress => 0 }]
          # e.g @tasks["EEVEE"] == [{ :task => "CAPTURE", :move_item => NONE, :progress => 5 }]
          hash = {
            :task      => task.keys.first,
            :move_item => task[task.keys.first],
            :progress  => 0
          }
          @tasks[species_id.name].push(hash) unless @tasks[species_id.name].include?(hash)
        end

        @tasks_completed[species_id.name] = false
      end
      end
	
	end



    # Increment task progress
    def increment_task_progress(task)
      return nil if task[:progress] >= GameData::Tasks.try_get(task[:task])&.thresholds.last
      task[:progress] += 1
    end

    # Returns all stored tasks, used by Pokedex UI
    def tasks
      @tasks
    end

    def tasks_completed
      @tasks_completed
    end

  end
end

module GameData
  class Species
  attr_accessor :the_dex_entry
  
  
    alias sidex_initialize initialize
    def initialize(hash)
     sidex_initialize(hash)
     @the_dex_entry       = ""
   end
   
   def the_dex_entry 
     @the_dex_entry= "" if @the_dex_entry.nil?
	 return @the_dex_entry
   end
   
   def set_dex_entry(value)
     @the_dex_entry= "" if @the_dex_entry.nil?
	 puts value
     @the_dex_entry=value
   end
  end
end