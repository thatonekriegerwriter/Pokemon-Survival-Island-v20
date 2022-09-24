#===============================================================================
# GameData class for Focus.
#===============================================================================
module GameData
  class Focus
    attr_reader :id
    attr_reader :focus
    attr_reader :users
    attr_reader :real_name
    attr_reader :icon_position

    DATA = {}

    extend ClassMethodsSymbols
    include InstanceMethods

    def self.load; end
    def self.save; end
    
    # Iterates through all Focus styles that aren't boss-exclusive.
    def self.each_main
      self.each { |f| yield f if [:any, :none].include?(f.users) }
    end
    
    # Iterates through only usable Focus styles for player's Pokemon.
    def self.each_usable
      self.each { |f| yield f if f.users == :any }
    end
    
    # Iterates through only boss-exclusive Focus styles.
    def self.each_boss
      self.each { |f| yield f if f.users == :boss }
    end

    def initialize(hash)
      @id            = hash[:id]
      @focus         = hash[:focus]
      @users         = hash[:users] || :none
      @real_name     = hash[:name] || "Unnamed"
      @icon_position = hash[:icon_position]
    end

    def name
      return _INTL(@real_name)
    end
  end
end

#===============================================================================

GameData::Focus.register({
  :id    => :None,
  :name  => _INTL("Unfocused"),
  :focus => _INTL("None"),
  :users => :none,
  :icon_position => 0
})

GameData::Focus.register({
  :id    => :Accuracy,
  :name  => _INTL("Accuracy"),
  :focus => _INTL("Focused Shot"),
  :users => :any,
  :icon_position => 1
})

GameData::Focus.register({
  :id    => :Evasion,
  :name  => _INTL("Evasion"),
  :focus => _INTL("Focused Dodge"),
  :users => :any,
  :icon_position => 2
})

GameData::Focus.register({
  :id    => :Critical,
  :name  => _INTL("Critical Hit"),
  :focus => _INTL("Focused Strike"),
  :users => :any,
  :icon_position => 3
})

GameData::Focus.register({
  :id    => :Potency,
  :name  => _INTL("Potency"),
  :focus => _INTL("Focused Effect"),
  :users => :any,
  :icon_position => 4
})

GameData::Focus.register({
  :id    => :Passive,
  :name  => _INTL("Passive"),
  :focus => _INTL("Focused Guard"),
  :users => :any,
  :icon_position => 5
})

GameData::Focus.register({
  :id    => :Enraged,
  :name  => _INTL("Enraged"),
  :focus => _INTL("Focused Rage"),
  :users => :boss,
  :icon_position => 6
})

#===============================================================================

module GameData
  class Trainer
    SCHEMA["Focus"] = [:focus, "e", :Focus]
  end
end