module GameData
 class Zone
    attr_reader :id
    attr_reader :real_name
    attr_reader :maps
    attr_reader :weather

    DATA = {}
    # Weather probability order: None, Rain, Storm, Snow, Blizzard, Sandstorm, HeavyRain, Sun/Sunny, Fog
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
	  @weather = {
        :summer => hash[:weather_summer] || hash[:weather] || DEFAULT_WEATHER,
        :autumn => hash[:weather_autumn] || hash[:weather] || DEFAULT_WEATHER,
        :winter => hash[:weather_winter] || hash[:weather] || DEFAULT_WEATHER,
        :spring => hash[:weather_spring] || hash[:weather] || DEFAULT_WEATHER
      }
    end

    def name
      return _INTL(@real_name)
    end
	
    def weather(season = pbCurrentWeatherSeason)
      return @weather[season] || DEFAULT_WEATHER
    end
	
    def self.for_map(map_id)
     DATA.values.find { |zone| zone.maps.include?(map_id) }
   end
   
   def self.all
    DATA.values
   end 
 end
end 

def pbCurrentWeatherSeason
  season = :summer
  season = :autumn if pbIsAutumn
  season = :winter if pbIsWinter
  season = :spring if pbIsSpring
  return season
end


GameData::Zone.register({
  :id            => :TEMPERATEFOREST,
  :name          => _INTL("Temperate Forests"),
  :maps          => [5, 4, 243, 300, 7, 349, 350, 8, 9, 13, 45, 54, 47, 282, 44, 68, 64, 205],
  :weather       => [30, 30, 15, 0, 0, 0, 5, 20, 0]
})

GameData::Zone.register({
  :id             => :TEMPERATEFOREST,
  :name           => _INTL("Temperate Forest"),
  :maps           => [5, 4, 243, 300, 7, 349, 350, 8, 9, 13, 45, 54, 47, 282, 44, 68, 64, 205],
  :weather_summer => [30, 30, 15, 0, 0, 0, 5, 20, 0],
  :weather_autumn => [30, 30, 15, 0, 0, 0, 5, 0, 0],
  :weather_winter => [30, 1, 1, 60, 20, 0, 0, 0, 40],
  :weather_spring => [30, 40, 25, 0, 0, 0, 30, 0, 0]
})

GameData::Zone.register({
  :id             => :TEMPERATEHIGHLAND,
  :name           => _INTL("Temperate Highlands"),
  :maps           => [16, 24, 31, 19, 30, 29, 28, 17],
  :weather_summer => [30, 20, 10, 0, 0, 0, 1, 20, 0],
  :weather_autumn => [30, 20, 10, 0, 0, 0, 1, 0, 0],
  :weather_winter => [30, 1, 1, 40, 10, 0, 0, 0, 20],
  :weather_spring => [30, 20, 10, 0, 0, 0, 1, 0, 0]
})

GameData::Zone.register({
  :id             => :TEMPERATEMARSH,
  :name           => _INTL("Temperate Marsh"),
  :maps           => [33, 34, 35, 109, 26, 218, 233],
  :weather_summer => [20, 30, 30, 0, 0, 0, 30, 5, 60],
  :weather_autumn => [20, 30, 30, 0, 0, 0, 30, 0, 60],
  :weather_winter => [20, 20, 0, 40, 10, 0, 0, 0, 75],
  :weather_spring => [20, 30, 30, 0, 0, 0, 30, 0, 60]
})

GameData::Zone.register({
  :id             => :DEEPMARSH,
  :name           => _INTL("Deep Marsh"),
  :maps           => [36, 84, 86, 110, 140, 44, 68],
  :weather_summer => [40, 50, 0, 0, 0, 0, 50, 0, 70],
  :weather_autumn => [40, 40, 0, 0, 0, 0, 40, 0, 70],
  :weather_winter => [40, 0, 0, 0, 0, 0, 0, 0, 70],
  :weather_spring => [40, 40, 0, 0, 0, 0, 40, 0, 70]
})

GameData::Zone.register({
  :id             => :FRIGIDHIGHLANDS,
  :name           => _INTL("Frigid Highlands"),
  :maps           => [71, 72, 77, 73, 78, 80, 74, 85, 82],
  :weather_summer => [60, 1, 1, 30, 1, 0, 1, 0, 60],
  :weather_autumn => [30, 0, 0, 40, 10, 0, 0, 0, 60],
  :weather_winter => [60, 0, 0, 80, 60, 0, 0, 0, 60],
  :weather_spring => [30, 0, 0, 40, 10, 0, 0, 0, 60]
})

GameData::Zone.register({
  :id             => :TROPICALCOAST,
  :name           => _INTL("Tropical Coast"),
  :maps           => [111, 130, 131, 158, 138, 132, 159, 142, 133, 160, 161, 134],
  :weather_summer => [20, 5, 3, 0, 0, 0, 2, 20, 0],
  :weather_autumn => [20, 5, 3, 0, 0, 0, 2, 20, 0],
  :weather_winter => [20, 0, 0, 0, 0, 0, 0, 0, 0],
  :weather_spring => [20, 5, 3, 0, 0, 0, 2, 40, 0]
})

GameData::Zone.register({
  :id             => :TEMPERATEOCEAN,
  :name           => _INTL("Temperate Ocean"),
  :maps           => [48, 62, 38, 39, 58, 59, 57, 60, 61, 53, 234, 235, 236, 42, 144, 137, 43, 385, 387, 392, 396, 397],
  :weather_summer => [60, 20, 3, 0, 0, 0, 5, 20, 0],
  :weather_autumn => [40, 20, 0, 0, 0, 0, 5, 0, 10],
  :weather_winter => [60, 1, 1, 0, 10, 0, 0, 0, 40],
  :weather_spring => [40, 20, 0, 0, 0, 0, 5, 0, 10]
})

GameData::Zone.register({
  :id             => :DEEPFOREST,
  :name           => _INTL("Deep Forest"),
  :maps           => [200, 201, 204, 202, 203, 244],
  :weather_summer => [40, 10, 10, 3, 0, 0, 0, 5, 30],
  :weather_autumn => [40, 10, 10, 3, 0, 0, 0, 0, 30],
  :weather_winter => [40, 0, 0, 0, 0, 0, 0, 0, 30],
  :weather_spring => [40, 10, 10, 3, 0, 0, 0, 0, 30]
})

GameData::Zone.register({
  :id             => :NORTHERNHIGHLANDS,
  :name           => _INTL("Northern Highlands"),
  :maps           => [207, 208, 157, 237, 238, 313, 315, 311, 312, 209],
  :weather_summer => [60, 20, 3, 0, 0, 5, 0, 10, 0],
  :weather_autumn => [60, 0, 0, 5, 0, 0, 0, 0, 0],
  :weather_winter => [60, 20, 1, 0, 5, 1, 0, 0, 20],
  :weather_spring => [60, 0, 0, 5, 0, 0, 0, 0, 0]
})

GameData::Zone.register({
  :id             => :WESTERNSHORES,
  :name           => _INTL("Western Shores"),
  :maps           => [205, 295, 296, 308, 302, 310, 307, 309],
  :weather_summer => [30, 30, 15, 0, 0, 0, 5, 10, 0],
  :weather_autumn => [30, 30, 15, 0, 0, 0, 5, 20, 0],
  :weather_winter => [30, 30, 15, 0, 0, 0, 5, 40, 0],
  :weather_spring => [30, 30, 15, 0, 0, 0, 5, 40, 0]
})

GameData::Zone.register({
  :id             => :BEEFOREST,
  :name           => _INTL("Bee Forest"),
  :maps           => [318, 319, 320, 323, 325, 326, 330, 331, 327, 328, 329],
  :weather_summer => [30, 30, 15, 0, 0, 0, 5, 40, 0],
  :weather_autumn => [30, 30, 15, 0, 0, 0, 5, 0, 0],
  :weather_winter => [30, 1, 1, 60, 20, 0, 0, 0, 40],
  :weather_spring => [30, 40, 25, 0, 0, 0, 30, 0, 0]
})

GameData::Zone.register({
  :id             => :HUMIDJUNGLE,
  :name           => _INTL("Humid Jungle"),
  :maps           => [338, 354, 355, 356, 357],
  :weather_summer => [40, 20, 0, 0, 0, 0, 20, 0, 0],
  :weather_autumn => [40, 0, 0, 0, 0, 0, 0, 0, 0],
  :weather_winter => [40, 0, 0, 0, 0, 0, 0, 0, 0],
  :weather_spring => [40, 0, 0, 0, 0, 0, 0, 0, 0]
})

GameData::Zone.register({
  :id      => :DEEPCHASM,
  :name    => _INTL("Deep Chasm"),
  :maps    => [81],
  :weather => [100, 0, 0, 0, 0, 0, 0, 0, 0]
})
