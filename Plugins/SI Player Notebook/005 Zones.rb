module GameData
 class Zone
    attr_reader :id
    attr_reader :real_name
    attr_reader :maps
    attr_reader :weather

    DATA = {}
    DEFAULT_WEATHER = [0, 0, 0, 0, 0, 0, 0, 0, 0].freeze
    extend ClassMethodsSymbols
    include InstanceMethods

    def self.load; end
    def self.save; end
 
    def initialize(hash)
      @id           = hash[:id]
      @real_name    = hash[:name]         || "Unnamed"
	  # # Arrays of id of the maps of each zone. Each array within the main array is a zone.
      @maps   = hash[:maps] || []
      # None, Rain, Storm, Snow, Blizzard, Sandstorm, HeavyRain, Sun/Sunny, Fog
      # [30, 30, 15, 0, 0, 0, 5, 20, 0], 
	  @weather       = hash[:weather] || DEFAULT_WEATHER
    end

    def name
      return _INTL(@real_name)
    end
    def self.for_map(map_id)
     DATA.values.find { |zone| zone.maps.include?(map_id) }
   end
   def self.all
    DATA.values
   end 
 end
end 

GameData::Zone.register({
  :id            => :TEMPERATEFOREST,
  :name          => _INTL("Temperate Forests"),
  :maps          => [5, 4, 243, 300, 7, 349, 350, 8, 9, 13, 45, 54, 47, 282, 44, 68, 64, 205],
  :weather       => [30, 30, 15, 0, 0, 0, 5, 20, 0]
})

GameData::Zone.register({
  :id            => :TEMPERATEHIGHLAND,
  :name          => _INTL("Temperate Highlands"),
  :maps          => [16,24,31,19,30,29,28,17],
  :weather       => [30, 20, 10, 0, 0, 0, 1, 20, 0]
})

GameData::Zone.register({
  :id            => :TEMPERATEMARSH,
  :name          => _INTL("Temperate Marsh"),
  :maps          => [33,34,35,109,26,218,233],
  :weather       => [20, 30, 30, 0, 0, 0, 30, 5, 60]
})

GameData::Zone.register({
  :id            => :DEEPMARSH,
  :name          => _INTL("Deep Marsh"),
  :maps          => [36,84,86,110,140,44,68],
  :weather       => [40, 50, 0, 0, 0, 0, 50, 0, 70]
})

GameData::Zone.register({
  :id            => :FRIGIDHIGHLANDS,
  :name          => _INTL("Frigid Highlands"),
  :maps          => [71,72,77,73,78,80,74,85,82],
  :weather       => [60, 1, 1, 30, 1, 0, 1, 0, 60]
})

GameData::Zone.register({
  :id            => :TROPICALCOAST,
  :name          => _INTL("Temperate Forests"),
  :maps          => [111,130,131,158,138,132,159,142,133,160,161,134],
  :weather       => [30, 30, 15, 0, 0, 0, 5, 20, 0]
})

GameData::Zone.register({
  :id            => :TEMPERATEOCEAN,
  :name          => _INTL("Temperate Highlands"),
  :maps          => [48,62,38,39,58,59,57,60,61,53,234,235,236,42,144,137,43,385,387,392,396,397],
  :weather       => [30, 20, 10, 0, 0, 0, 1, 20, 0]
})

GameData::Zone.register({
  :id            => :DEEPFOREST,
  :name          => _INTL("Temperate Marsh"),
  :maps          => [200,201,204,202,203,244],
  :weather       => [20, 30, 30, 0, 0, 0, 30, 5, 60]
})

GameData::Zone.register({
  :id            => :NORTHERNHIGHLANDS,
  :name          => _INTL("Deep Marsh"),
  :maps          => [207,208,157,237,238,313,315,311,312,209],
  :weather       => [40, 50, 0, 0, 0, 0, 50, 0, 70]
})

GameData::Zone.register({
  :id            => :WESTERNSHORES,
  :name          => _INTL("Western Shores"),
  :maps          => [205,295,296,308,302,310,307,309],
  :weather       => [60, 1, 1, 30, 1, 0, 1, 0, 60]
})

GameData::Zone.register({
  :id            => :BEEFOREST,
  :name          => _INTL("Bee Forest"),
  :maps          => [318,319,320,323,325,326,330,331,327,328,329],
  :weather       => [60, 1, 1, 30, 1, 0, 1, 0, 60]
})

GameData::Zone.register({
  :id            => :HUMIDJUNGLE,
  :name          => _INTL("Humid Jungle"),
  :maps          => [338,354,355,356,357],
  :weather       => [40, 0, 0, 0, 0, 0, 0, 0, 0]
})

GameData::Zone.register({
  :id            => :DEEPCHASM,
  :name          => _INTL("Deep Chasm"),
  :maps          => [81],
  :weather       => [0, 0, 0, 0, 0, 0, 0, 0, 0]
})