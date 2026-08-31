module GameData
  class Nature
    attr_reader :id
    attr_reader :real_name
    attr_reader :stat_changes
    attr_reader :base_happiness
    attr_reader :happiness_changes
    attr_reader :base_loyalty
    attr_reader :loyalty_changes
    attr_reader :flavors
    attr_reader :crisis_behavior
    attr_reader :preferred_jobs

    DATA = {}

    extend ClassMethodsSymbols
    include InstanceMethods

    def self.load; end
    def self.save; end

    def initialize(hash)
      @id           = hash[:id]
      @real_name    = hash[:name]         || "Unnamed"
      @stat_changes = hash[:stat_changes] || []
      @base_happiness = hash[:base_happiness] || 5
      @happiness_changes = hash[:happiness_changes] || [1, 1, 1]
      @base_loyalty = hash[:base_loyalty] || 5
      @loyalty_changes = hash[:loyalty_changes] || [1, 1, 1]
      @flavors = hash[:flavors] || build_flavors
      @crisis_behavior = hash[:crisis_behavior] || build_behavior
      @preferred_jobs = hash[:preferred_jobs] || []
    end
    
	def build_flavors
	  { :loves => [],
	    :likes => [],
	    :neutral => [],
		:dislikes => [],
		:hates => []
	  }
	end 
	
	def build_behavior
	  { :enjoys => [],
	    :accepts => [],
		:dislikes => [],
		:hates => []
	  }
	end 
	
    # @return [String] the translated name of this nature
    def name
      return _INTL(@real_name)
    end
  end
end

GameData::Nature.register({
  :id           => :HARDY,
  :name         => _INTL("Hardy")
})

GameData::Nature.register({
  :id           => :LONELY,
  :name         => _INTL("Lonely"),
  :stat_changes => [[:ATTACK, 10], [:DEFENSE, -10]]
})

GameData::Nature.register({
  :id           => :BRAVE,
  :name         => _INTL("Brave"),
  :stat_changes => [[:ATTACK, 10], [:SPEED, -10]]
})

GameData::Nature.register({
  :id           => :ADAMANT,
  :name         => _INTL("Adamant"),
  :stat_changes => [[:ATTACK, 10], [:SPECIAL_ATTACK, -10]]
})

GameData::Nature.register({
  :id           => :NAUGHTY,
  :name         => _INTL("Naughty"),
  :stat_changes => [[:ATTACK, 10], [:SPECIAL_DEFENSE, -10]]
})

GameData::Nature.register({
  :id           => :BOLD,
  :name         => _INTL("Bold"),
  :stat_changes => [[:DEFENSE, 10], [:ATTACK, -10]]
})

GameData::Nature.register({
  :id           => :DOCILE,
  :name         => _INTL("Docile")
})

GameData::Nature.register({
  :id           => :RELAXED,
  :name         => _INTL("Relaxed"),
  :stat_changes => [[:DEFENSE, 10], [:SPEED, -10]]
})

GameData::Nature.register({
  :id           => :IMPISH,
  :name         => _INTL("Impish"),
  :stat_changes => [[:DEFENSE, 10], [:SPECIAL_ATTACK, -10]]
})

GameData::Nature.register({
  :id           => :LAX,
  :name         => _INTL("Lax"),
  :stat_changes => [[:DEFENSE, 10], [:SPECIAL_DEFENSE, -10]]
})

GameData::Nature.register({
  :id           => :TIMID,
  :name         => _INTL("Timid"),
  :stat_changes => [[:SPEED, 10], [:ATTACK, -10]]
})

GameData::Nature.register({
  :id           => :HASTY,
  :name         => _INTL("Hasty"),
  :stat_changes => [[:SPEED, 10], [:DEFENSE, -10]]
})

GameData::Nature.register({
  :id           => :SERIOUS,
  :name         => _INTL("Serious")
})

GameData::Nature.register({
  :id           => :JOLLY,
  :name         => _INTL("Jolly"),
  :stat_changes => [[:SPEED, 10], [:SPECIAL_ATTACK, -10]]
})

GameData::Nature.register({
  :id           => :NAIVE,
  :name         => _INTL("Naive"),
  :stat_changes => [[:SPEED, 10], [:SPECIAL_DEFENSE, -10]]
})

GameData::Nature.register({
  :id           => :MODEST,
  :name         => _INTL("Modest"),
  :stat_changes => [[:SPECIAL_ATTACK, 10], [:ATTACK, -10]]
})

GameData::Nature.register({
  :id           => :MILD,
  :name         => _INTL("Mild"),
  :stat_changes => [[:SPECIAL_ATTACK, 10], [:DEFENSE, -10]]
})

GameData::Nature.register({
  :id           => :QUIET,
  :name         => _INTL("Quiet"),
  :stat_changes => [[:SPECIAL_ATTACK, 10], [:SPEED, -10]]
})

GameData::Nature.register({
  :id           => :BASHFUL,
  :name         => _INTL("Bashful")
})

GameData::Nature.register({
  :id           => :RASH,
  :name         => _INTL("Rash"),
  :stat_changes => [[:SPECIAL_ATTACK, 10], [:SPECIAL_DEFENSE, -10]]
})

GameData::Nature.register({
  :id           => :CALM,
  :name         => _INTL("Calm"),
  :stat_changes => [[:SPECIAL_DEFENSE, 10], [:ATTACK, -10]]
})

GameData::Nature.register({
  :id           => :GENTLE,
  :name         => _INTL("Gentle"),
  :stat_changes => [[:SPECIAL_DEFENSE, 10], [:DEFENSE, -10]]
})

GameData::Nature.register({
  :id           => :SASSY,
  :name         => _INTL("Sassy"),
  :stat_changes => [[:SPECIAL_DEFENSE, 10], [:SPEED, -10]]
})

GameData::Nature.register({
  :id           => :CAREFUL,
  :name         => _INTL("Careful"),
  :stat_changes => [[:SPECIAL_DEFENSE, 10], [:SPECIAL_ATTACK, -10]]
})

GameData::Nature.register({
  :id           => :QUIRKY,
  :name         => _INTL("Quirky")
})


GameData::Nature.register({
  :id           => :HATEFUL,
  :name         => _INTL("Hateful"),
  :stat_changes => [[:HP, 10], [:ATTACK, 10], [:DEFENSE, 10], [:SPEED, 10], [:SPECIAL_ATTACK, 10], [:SPECIAL_DEFENSE, 10]]
})

GameData::Nature.register({
  :id           => :LOVING,
  :name         => _INTL("Loving"),
  :stat_changes => [[:HP, 10], [:ATTACK, -10], [:DEFENSE, 10], [:SPEED, 0], [:SPECIAL_ATTACK, -10], [:SPECIAL_DEFENSE, 10]]
})

GameData::Nature.register({
  :id           => :GREEDY,
  :name         => _INTL("Greedy")
})
