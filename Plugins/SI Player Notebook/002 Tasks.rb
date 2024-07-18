module GameData
  class Tasks

    attr_reader :id
    attr_reader :source_name
    attr_reader :name
    attr_reader :description
    attr_reader :thresholds

    DATA = {}
    DATA_FILENAME = "task.dat"

    extend ClassMethodsSymbols
    include InstanceMethods

    # Allows Compiler to create all task objects from PBS/task.txt
    SCHEMA = {
      "SourceName"  => [:source_name, "n"],
      "Name"        => [:name,        "s"],
      "Description" => [:description, "s"],
      "Thresholds"  => [:thresholds,  "*u"]
    }

    def initialize(hash)
      @id      = hash[:id]
      @source_name      = hash[:source_name]
      @name             = hash[:name]            || "Unnamed"
      @description      = hash[:description]     || "nil"
      @thresholds       = hash[:thresholds]      || []
    end

    def source_name
      @source_name
    end

    def name
      @name
    end

    def description
      @description
    end

    def thresholds
      @thresholds
    end

  end
end


alias dewmpt_pbClearData pbClearData
def pbClearData
  dewmpt_pbClearData
  if $game_temp
    $game_temp.tasks = nil
  end
end

# Loads and stores tasks
def pbLoadTasks
  $game_temp = Game_Temp.new if !$game_temp
  if !$game_temp.tasks
    $game_temp.tasks = load_data("Data/pkmn_tasks.dat")
  end

  return $game_temp.tasks
end

class Pokemon

  # Checks to see if the evolving Pokemon has the EVOLVED task and
  # if so then updates the task progress 
  alias dewmpt_action_after_evolution action_after_evolution
  def action_after_evolution(new_species)
    $player.pokedex.tasks[species.name].each do |task|
      if task[:task] == "EVOLVED"
        $player.pokedex.increment_task_progress(task) unless task.nil?
      end
    end

    dewmpt_action_after_evolution(new_species)

    $player.pokedex.set_seen(new_species)
    task = nil
    if PBDayNight.isNight?
      $player.pokedex.tasks[new_species.name].each { |t| task = t if t[:task] == "CAPTURENIGHT" }
    elsif PBDayNight.isEvening?
      $player.pokedex.tasks[new_species.name].each { |t| task = t if t[:task] == "CAPTUREEVENING" }
    end

    if task.nil?
      $player.pokedex.tasks[new_species.name].each do |t|
        task = t if t[:task] == "CAPTURE" || t[:task] == "CAPTURE1"
      end
    end
    $player.pokedex.increment_task_progress(task) unless task.nil?
  end

end

class Battle

  # At the end of battle, calculate if the player pokemon has not fainted
  # and is holding the item associated with the task, then update the task
  alias dewmpt_pbEndOfBattle pbEndOfBattle
  def pbEndOfBattle
    dewmpt_pbEndOfBattle

    @battlers.each do |b|
      next if !b || b.item_id.nil?

      if !b.fainted? && b.pbOwnedByPlayer?
        species = GameData::Species.try_get(b.species)&.species
        $player.pokedex.tasks[species.name].each do |task|
          case task[:task]
          when "ITEMWINBATTLES"
            if task[:move_item] == b.item_id.name
              $player.pokedex.increment_task_progress(task) unless task.nil?
            end
          end
        end
      end
    end
  
    return @decision
  end

end