class PokemonGlobalMetadata
  attr_accessor :achievements
  
  def achievements
    @achievements={} if !@achievements
    return @achievements
  end
end

module Achievements
  # IDs determine the order that achievements appear in the menu.
  @achievementList={
    "BAG"=>{
      "id"=>1,
      "name"=>"Grabbed your Bag",
      "description"=>"Started your stay on the Island.",
      "goals"=>[1]
    },
    "POKEMON_KOED"=>{
      "id"=>2,
      "name"=>"The Violence Begins",
      "description"=>"KOed a POKeMON.",
      "goals"=>[1]
    },
    "STATUES"=>{
      "id"=>3,
      "name"=>"Fortress of Teamwork",
      "description"=>"Find and activate all statues.",
      "goals"=>[7]
    },
    "STEPS"=>{
      "id"=>4,
      "name"=>"The Long Walk",
      "description"=>"Walk 10,000 steps.",
      "goals"=>[10000]
    },
    "MAIN_CAMPAIGN"=>{
      "id"=>5,
      "name"=>"The End",
      "description"=>"Complete the Survival Island story.",
      "goals"=>[1]
    },
    "NUZLOCKED"=>{
      "id"=>6,
      "name"=>"Nuzlocke and Load",
      "description"=>"Start the game in Nuzlocke Mode.",
      "goals"=>[1]
    },
    "SURVIVOR"=>{
      "id"=>7,
      "name"=>"True Survivor",
      "description"=>"Start the game in Survival Mode.",
      "goals"=>[1]
    },
    "SBOSSES"=>{
      "id"=>8,
      "name"=>"So Very Sorry for your Loss.",
      "description"=>"Defeated Every Boss Pokemon.",
      "goals"=>[1]
    },
    "BASES"=>{
      "id"=>9,
      "name"=>"Covered Your Bases.",
      "description"=>"Found every base.",
      "goals"=>[3]
    },
    "WRECK"=>{
      "id"=>10,
      "name"=>"The Ruins",
      "description"=>"Visited the Sunken S.S Glittering.",
      "goals"=>[1]
    },
    "SKY"=>{
      "id"=>11,
      "name"=>"The Skys Above",
      "description"=>"Reached the Sky.",
      "goals"=>[1]
    },
    "PRIME"=>{
      "id"=>12,
      "name"=>"Temple Prime",
      "description"=>"Found the Prime Temple.",
      "goals"=>[1]
    },
    "ONLINE"=>{
      "id"=>13,
      "name"=>"A Friendly Dream",
      "description"=>"Used the Dream Connect.",
      "goals"=>[1]
    },
    "GARY"=>{
      "id"=>14,
      "name"=>"The Eternal Rival",
      "description"=>"Beat Blue.",
      "goals"=>[1]
    },
    "RED"=>{
      "id"=>15,
      "name"=>"The Champion",
      "description"=>"Beat Red.",
      "goals"=>[1]
    },
    "TRIP"=>{
      "id"=>16,
      "name"=>"A Bad Trip",
      "description"=>"Tried something you shouldn't have.",
      "goals"=>[1]
    },
    "GREENHOUSE"=>{
      "id"=>17,
      "name"=>"Green Thumb",
      "description"=>"Built the Greenhouses.",
      "goals"=>[1]
    },
    "HOUSE"=>{
      "id"=>18,
      "name"=>"Homeowner",
      "description"=>"Built a House.",
      "goals"=>[1]
    },
    "ITEMS_USED"=>{
      "id"=>19,
      "name"=>"Avid Crafter",
      "description"=>"Use crafted items.",
      "goals"=>[250,500,1000]
    },
    "ITEMS_USED_IN_BATTLE"=>{
      "id"=>20,
      "name"=>"Mid-Battle Maintenance",
      "description"=>"Use items in battle.",
      "goals"=>[100,250,500]
    },
    "INSOMNIA"=>{
      "id"=>21,
      "name"=>"Insomniac",
      "description"=>"Started dying of lack of Sleep.",
      "goals"=>[1]
    },
    "STARVING"=>{
      "id"=>22,
      "name"=>"Workoholic Part A",
      "description"=>"Started dying of lack of Food.",
      "goals"=>[1]
    },
    "THIRSTY"=>{
      "id"=>23,
      "name"=>"Workoholic Part B",
      "description"=>"Started dying of lack of Drink.",
      "goals"=>[1]
    },
    "DEAD"=>{
      "id"=>24,
      "name"=>"With the Angels.",
      "description"=>"Couldn't Survive the Island.",
      "goals"=>[1]
    }
=begin
    "STEPS"=>{
      "id"=>1,
      "name"=>"Tired Feet",
      "description"=>"Walk around the world.",
      "goals"=>[10000,50000,100000]
    },
    "POKEMON_CAUGHT"=>{
      "id"=>2,
      "name"=>"Gotta Catch 'Em All",
      "description"=>"Catch Pokémon.",
      "goals"=>[100,250,500]
    },
    "WILD_ENCOUNTERS"=>{
      "id"=>3,
      "name"=>"Running in the Tall Grass",
      "description"=>"Encounter Pokémon.",
      "goals"=>[250,500,1000]
    },
    "TRAINER_BATTLES"=>{
      "id"=>4,
      "name"=>"Battlin' Every Day",
      "description"=>"Go into Trainer battles.",
      "goals"=>[100,250,500]
    },
    "ITEMS_USED"=>{
      "id"=>5,
      "name"=>"Items Are Handy",
      "description"=>"Use items.",
      "goals"=>[250,500,1000]
    },
    "ITEMS_BOUGHT"=>{
      "id"=>6,
      "name"=>"Buying Supplies",
      "description"=>"Buy items.",
      "goals"=>[250,500,1000]
    },
    "ITEMS_SOLD"=>{
      "id"=>7,
      "name"=>"Seller",
      "description"=>"Sell items.",
      "goals"=>[100,250,500]
    },
    "MEGA_EVOLUTIONS"=>{
      "id"=>8,
      "name"=>"Mega Evolution Expert",
      "description"=>"Mega Evolve Pokémon.",
      "goals"=>[250,500,1000]
    },
    "PRIMAL_REVERSIONS"=>{
      "id"=>9,
      "name"=>"Primal Power",
      "description"=>"Primal Revert Pokémon.",
      "goals"=>[250,500,1000]
    },
    "ITEM_BALL_ITEMS"=>{
      "id"=>10,
      "name"=>"Finding Treasure",
      "description"=>"Find items in item balls.",
      "goals"=>[50,100,250]
    },
    "MOVES_USED"=>{
      "id"=>11,
      "name"=>"Ferocious Fighting",
      "description"=>"Use moves in battle.",
      "goals"=>[500,1000,2500]
    },
    "ITEMS_USED_IN_BATTLE"=>{
      "id"=>12,
      "name"=>"Mid-Battle Maintenance",
      "description"=>"Use items in battle.",
      "goals"=>[100,250,500]
    },
    "FAINTED_POKEMON"=>{
      "id"=>13,
      "name"=>"I Hope You're Not Doing a Nuzlocke",
      "description"=>"Have your Pokémon faint.",
      "goals"=>[100,250,500]
    }
=end
  }
  def self.list
    Achievements.fixAchievements
    return @achievementList
  end
  def self.fixAchievements
    @achievementList.keys.each{|a|
      if $PokemonGlobal.achievements[a].nil?
        $PokemonGlobal.achievements[a]={}
      end
      if $PokemonGlobal.achievements[a]["progress"].nil?
        $PokemonGlobal.achievements[a]["progress"]=0
      end
      if $PokemonGlobal.achievements[a]["level"].nil?
        $PokemonGlobal.achievements[a]["level"]=0
      end
    }
    $PokemonGlobal.achievements.keys.each{|k|
      if !@achievementList.keys.include? k
        $PokemonGlobal.achievements.delete(k)
      end
    }
  end
  def self.incrementProgress(name, amount)
    Achievements.fixAchievements
    if @achievementList.keys.include? name
      if !$PokemonGlobal.achievements[name].nil? && !$PokemonGlobal.achievements[name]["progress"].nil?
        $PokemonGlobal.achievements[name]["progress"]+=amount
        self.checkIfLevelUp(name)
        return true
      else
        return false
      end
    else
      raise "Undefined achievement: "+name.to_s
    end
  end
  def self.decrementProgress(name, amount)
    Achievements.fixAchievements
    if @achievementList.keys.include? name
      if !$PokemonGlobal.achievements[name].nil? && !$PokemonGlobal.achievements[name]["progress"].nil?
        $PokemonGlobal.achievements[name]["progress"]-=amount
        if $PokemonGlobal.achievements[name]["progress"]<0
          $PokemonGlobal.achievements[name]["progress"]=0
        end
        return true
      else
        return false
      end
    else
      raise "Undefined achievement: "+name.to_s
    end
  end
  def self.setProgress(name, amount)
    Achievements.fixAchievements
    if @achievementList.keys.include? name
      if !$PokemonGlobal.achievements[name].nil? && !$PokemonGlobal.achievements[name]["progress"].nil?
        $PokemonGlobal.achievements[name]["progress"]=amount
        if $PokemonGlobal.achievements[name]["progress"]<0
          $PokemonGlobal.achievements[name]["progress"]=0
        end
        self.checkIfLevelUp(name)
        return true
      else
        return false
      end
    else
      raise "Undefined achievement: "+name.to_s
    end
  end
  def self.checkIfLevelUp(name)
    Achievements.fixAchievements
    if @achievementList.keys.include? name
      if !$PokemonGlobal.achievements[name].nil? && !$PokemonGlobal.achievements[name]["progress"].nil?
        level=@achievementList[name]["goals"].length
        @achievementList[name]["goals"].each_with_index{|g,i|
          if $PokemonGlobal.achievements[name]["progress"] < g
            level=i
            break
          end
        }
        if level>$PokemonGlobal.achievements[name]["level"]
          $PokemonGlobal.achievements[name]["level"]=level
          self.queueMessage(_INTL("Achievement Reached!\n{1} Level {2}",@achievementList[name]["name"],level.to_s))
          return true
        else
          return false
        end
      else
        return false
      end
    else
      raise "Undefined achievement: "+name.to_s
    end
  end
  def self.getCurrentGoal(name)
    Achievements.fixAchievements
    if @achievementList.keys.include? name
      if !$PokemonGlobal.achievements[name].nil? && !$PokemonGlobal.achievements[name]["progress"].nil?
        @achievementList[name]["goals"].each_with_index{|g,i|
          if $PokemonGlobal.achievements[name]["progress"] < g
            return g
          end
        }
        return nil
      else
        return 0
      end
    else
      raise "Undefined achievement: "+name.to_s
    end
  end
  def self.queueMessage(msg)
    if $achievementmessagequeue.nil?
      $achievementmessagequeue=[]
    end
    $achievementmessagequeue.push(msg)
  end
end