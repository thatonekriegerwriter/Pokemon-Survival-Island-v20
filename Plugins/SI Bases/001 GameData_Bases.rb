module GameData
  class Base
    attr_reader :id
    attr_reader :real_name
    attr_reader :description
    attr_reader :indoor_maps
    attr_reader :outdoor_maps
    attr_reader :can_place_wilds
    attr_reader :type

    DATA = {}

    extend ClassMethodsSymbols
    include InstanceMethods

    def self.load; end
    def self.save; end

  
  
    def initialize(hash)
      @id           = hash[:id]
      @real_name    = hash[:name]         || "Unnamed"
      @description    = hash[:description]         || "None"
      @indoor_maps   = hash[:indoor_maps] || []
      @outdoor_maps   = hash[:outdoor_maps] || []
	  @can_place_wilds = hash[:can_place_wilds] || false
	  @type       = hash[:type] || :base
    end

    def name
      return _INTL(@real_name)
    end
  
  
  end
end 

GameData::Base.register({
  :id            => :TEMPERATEBASE,
  :name          => _INTL("Temperate Base"),
  :indoor_maps          => [10],
  :outdoor_maps          => [4, 5]
})
GameData::Base.register({
  :id            => :MOUNTAINBASE,
  :name          => _INTL("Mountain Base"),
  :indoor_maps          => [20],
  :outdoor_maps          => [24, 19]
})

GameData::Base.register({
  :id            => :SWAMPBASE,
  :name          => _INTL("Swamp Base"),
  :indoor_maps          => [40, 21],
  :outdoor_maps          => [33]
})

GameData::Base.register({
  :id            => :FRIGIDOUTPOST,
  :name          => _INTL("Frigid Outpost"),
  :indoor_maps          => [97],
  :outdoor_maps          => [85],
  :type => :outpost 
})

GameData::Base.register({
  :id            => :OILTANKER,
  :name          => _INTL("Oil Tanker"),
  :indoor_maps          => [143],
  :outdoor_maps          => [137, 141],
  :type => :headquarters 
})
GameData::Base.register({
  :id            => :CHALLENGEMAP,
  :name          => _INTL("Challenge Map"),
  :indoor_maps          => [11],
  :outdoor_maps          => [11],
  :can_place_wilds      => true,
  :type => :headquarters 
})