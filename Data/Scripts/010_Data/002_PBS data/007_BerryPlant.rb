module GameData
  class BerryPlant
    attr_reader :id
    attr_reader :hours_per_stage
    attr_reader :drying_per_hour
    attr_reader :yield
    attr_reader :cropsticks
    attr_reader :crossbreeding
    attr_reader :breeding
    attr_reader :climate
    attr_reader :resistance
    attr_reader :mutativity
    attr_reader :weedchance
    attr_reader :weeded
    attr_reader :speciesallele
    attr_reader :growthallele
    attr_reader :dryallele
    attr_reader :minyieldallele
    attr_reader :maxyieldallele

    DATA = {}
    DATA_FILENAME = "berry_plants.dat"

    SCHEMA = {
      "HoursPerStage" => [:hours_per_stage, "v"],
      "DryingPerHour" => [:drying_per_hour, "u"],
      "Yield"         => [:yield,           "uv"],
      "Cropsticks"         => [:cropsticks,           "v"],
      "CrossBreeding"         => [:crossbreeding,           "v"],
      "Climate"         => [:climate,           "v"],
      "Resistance"         => [:resistance,           "v"],
      "Mutativity"         => [:mutativity,           "v"],
      "WeedChance"         => [:weedchance,           "v"],
      "Weeded"         => [:weeded,           "v"],
      "SpeciesAllele"         => [:speciesallele,           "v"],
      "GrowthAllele"         => [:growthallele,           "v"],
      "DryAllele"         => [:dryallele,           "v"],
      "MinYieldAllele"         => [:minyieldallele,           "v"],
      "MaxYieldAllele"         => [:maxyieldallele,           "v"]
    }

    NUMBER_OF_REPLANTS           = 9
    NUMBER_OF_GROWTH_STAGES      = 4
    NUMBER_OF_FULLY_GROWN_STAGES = 4
    WATERING_CANS                = [:SPRAYDUCK, :SQUIRTBOTTLE, :WAILMERPAIL, :SPRINKLOTAD]

    extend ClassMethodsSymbols
    include InstanceMethods

    def initialize(hash)
      @id              = hash[:id]
      @hours_per_stage = hash[:hours_per_stage] || 3
      @drying_per_hour = hash[:drying_per_hour] || 15
      @yield           = hash[:yield]           || [2, 5]
      @yield.reverse! if @yield[1] < @yield[0]
    end

    def minimum_yield
      return @yield[0]
    end

    def maximum_yield
      return @yield[1]
    end
  end
end
