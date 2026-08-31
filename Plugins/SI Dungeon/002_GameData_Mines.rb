module GameData
 class Mine
    attr_reader :id
    attr_reader :real_name
    attr_reader :timer
    attr_reader :area_amt
    attr_reader :rnd_amt
    attr_reader :common_rewards
    attr_reader :uncommon_rewards
    attr_reader :rare_rewards
    attr_reader :max_mining_spots
    attr_reader :min_mining_spots
    attr_reader :tile_placement_distance
    attr_reader :roll_times
	
    DATA = {}
    extend ClassMethodsIDNumbers
    include InstanceMethods

    def self.load; end
    def self.save; end
 
    def initialize(hash)
      @id           = hash[:id]   || 0
      @real_name    = hash[:name]         || "Unnamed"
	  #The max amount of mining spots in a mine.
      @max_mining_spots   = hash[:max_mining_spots] || 7
	  #The max amount of mining spots in a mine.
      @min_mining_spots   = hash[:min_mining_spots] || 1
	  #The roll number that will be used when rolling the amount of mining spots.
      @max_mining_spots   = hash[:roll_times] || 12
	  #Tiles that are allowed to have mining spots on them.
	  @area_amt = hash[:area_amt] || 1
	  #If to use the whitelist or blacklist.
	  @use_whitelist     = hash[:use_whitelist] || false
	  #Tiles that are allowed to have mining spots on them.
	  @whitelisted_tiles = hash[:whitelisted_tiles] || []
	  #Tiles that are not allowed to have mining spots on them.
	  @blacklisted_tiles = hash[:blacklisted_tiles] || []
	  #A set of offsets that should have up to @max_mining_spots entries, these aren't always required, but they are good for maps that need an offset. If there is less than the required entries, it will use the last offset.
	  @tile_offsets = hash[:tile_offsets] || [[0,0]]
	  #A Base Timer which randomization will be layered on top of so time on the refresh isn't consistant
	  @timer       = hash[:timer] || 3600
	  #The number used for timer randomization.
	  @rnd_amt       = hash[:rnd_amt] || 1800
	  #The max distance away from a base position a tile can be.
      @tile_placement_distance   = hash[:tile_placement_distance] || [7]
	  #A set of rewards and their weights.
	  @common_rewards       = hash[:common_rewards] || [[:STONE,70],[:TUMBLEROCK,70],[:COAL,60],[:LIGHTCLAY,60],[:COPPERORE,50],[:IRONORE,40]]
	  @uncommon_rewards       = hash[:uncommon_rewards] || [[:HARDSTONE,80],[:GOLDORE,60],[:SILVERORE,30],[:EVERSTONE, 10]]
	  @rare_rewards       = hash[:rare_rewards] || [[:FIRESTONE, 30],[:WATERSTONE, 30],[:THUNDERSTONE, 30],[:LEAFSTONE, 30],[:MOONSTONE, 30],[:DAWNSTONE, 30],[:ICESTONE, 30],[:SUNSTONE, 30],[:OVALSTONE, 70],[:EVIOLITE, 40]]
    end

    def name
      return _INTL(@real_name)
    end
	def map_id
	  return @id 
	end 
	def valid_tile?(x, y)
	  if @use_whitelist
	    return @whitelisted_tiles.include?([x, y])
	  else
	    return !@blacklisted_tiles.include?([x, y])
	  end 
	end 
	
	def offset_for(index)
	  if index > @tile_offsets.length - 1
	    return @tile_offsets[@tile_offsets.length-1]
	  end
	  return @tile_offsets[index]
	end 
	def distance_for(index)
	  if index > @tile_placement_distance.length - 1
	    return @tile_placement_distance[@tile_placement_distance.length-1]
	  end
	  return @tile_placement_distance[index]
	
	end 
 end
end 

GameData::Mine.register({
  :id            => 18,
  :name          => _INTL("Shore Cave"), #Open when player finds it.
  :timer          => 7200,
  :rnd_amt          => 7200,
  :max_mining_spots => 12,
  :min_mining_spots => 5,
  :roll_times => 10,
  :area_amt => 1,
  :use_whitelist => false,
  :whitelisted_tiles => [],
  :blacklisted_tiles => [[9,8],[16,8],[9,15],[16,15],[11,15],[12,15],[13,15],[12,14]],
  :tile_offsets => [[9,8]],
  :tile_placement_distance => [7],
  :common_rewards => [[:STONE,90],[:TUMBLEROCK,70],[:COAL,60],[:LIGHTCLAY,40],[:COPPERORE,40],[:IRONORE,30]],
  :uncommon_rewards => [[:HARDSTONE,60],[:GOLDORE,30],[:SILVERORE,20],[:EVERSTONE, 10]],
  :rare_rewards => [[:FIRESTONE, 30],[:WATERSTONE, 30],[:THUNDERSTONE, 30],[:LEAFSTONE, 30],[:MOONSTONE, 30],[:DAWNSTONE, 30],[:ICESTONE, 30],[:SUNSTONE, 30],[:OVALSTONE, 70],[:EVIOLITE, 40]]
})

GameData::Mine.register({
  :id            => 15,
  :name          => _INTL("Mountain Cave"), #Open when player finds it.
  :timer          => 7200,
  :rnd_amt          => 3600,
  :max_mining_spots => 7,
  :min_mining_spots => 3,
  :roll_times => 9,
  :area_amt => 1,
  :use_whitelist => false,
  :whitelisted_tiles => [],
  :blacklisted_tiles => [[9,8],[16,8],[9,15],[16,15],[11,15],[12,15],[13,15],[12,14]],
  :tile_offsets => [[9,8]],
  :tile_placement_distance => [7],
  :common_rewards => [[:STONE,90],[:TUMBLEROCK,70],[:COAL,60],[:LIGHTCLAY,40],[:COPPERORE,40],[:IRONORE,30]],
  :uncommon_rewards => [[:HARDSTONE,60],[:GOLDORE,30],[:SILVERORE,20],[:EVERSTONE, 10]],
  :rare_rewards => [[:FIRESTONE, 30],[:WATERSTONE, 30],[:THUNDERSTONE, 30],[:LEAFSTONE, 30],[:MOONSTONE, 30],[:DAWNSTONE, 30],[:ICESTONE, 30],[:SUNSTONE, 30],[:OVALSTONE, 70],[:EVIOLITE, 40]]
})

GameData::Mine.register({
  :id            => 76,
  :name          => _INTL("Chilled Cave"), #Must be hammered open
  :timer          => 7200,
  :rnd_amt          => 1800,
  :min_mining_spots => 3,
  :max_mining_spots => 10,
  :roll_times => 14,
  :area_amt => 1,
  :use_whitelist => false,
  :whitelisted_tiles => [],
  :blacklisted_tiles => [[9,8],[16,8],[9,15],[16,15],[11,15],[12,15],[13,15],[12,14]],
  :tile_offsets => [[9,8]],
  :tile_placement_distance => [7],
  :common_rewards => [[:STONE,90],[:TUMBLEROCK,70],[:COAL,60],[:LIGHTCLAY,40],[:COPPERORE,40],[:IRONORE,30]],
  :uncommon_rewards => [[:HARDSTONE,60],[:GOLDORE,30],[:SILVERORE,20],[:EVERSTONE, 10]],
  :rare_rewards => [[:FIRESTONE, 30],[:WATERSTONE, 30],[:THUNDERSTONE, 30],[:LEAFSTONE, 30],[:MOONSTONE, 30],[:DAWNSTONE, 30],[:ICESTONE, 30],[:SUNSTONE, 30],[:OVALSTONE, 70],[:EVIOLITE, 40]]
})

GameData::Mine.register({
  :id            => 71,
  :name          => _INTL("Frigid Cave"), #Open when player finds it.
  :timer          => 7200,
  :rnd_amt          => 1800,
  :min_mining_spots => 3,
  :max_mining_spots => 12,
  :roll_times => 14,
  :area_amt => 1,
  :use_whitelist => false,
  :whitelisted_tiles => [],
  :blacklisted_tiles => [[190,30],[183,32],[185,35],[193,36],[183,39],[188,39],[191,39]],
  :tile_offsets => [[183,29]],
  :tile_placement_distance => [10],
  :common_rewards => [[:STONE,60],[:TUMBLEROCK,40],[:COAL,30],[:LIGHTCLAY,20],[:COPPERORE,15],[:IRONORE,10]],
  :uncommon_rewards => [[:GOLDORE,10],[:SILVERORE,5]],
  :rare_rewards => [[:NEVERMELTICE, 30],[:ICESTONE, 30]]
})

GameData::Mine.register({
  :id            => 31,
  :name          => _INTL("Mountain Interior"), #Open when player finds it.
  :timer          => 10800,
  :rnd_amt          => 3600,
  :min_mining_spots => 4,
  :max_mining_spots => 16,
  :roll_times => 12,
  :area_amt => 8,
  :use_whitelist => false,
  :whitelisted_tiles => [],
  :blacklisted_tiles => [],
  :tile_offsets => [[12,21],[12,37],[20,58],[34,40],[47,51],[59,63],[46,12],[58,7]],
  :tile_placement_distance => [7],
  :common_rewards => [[:STONE,90],[:TUMBLEROCK,70],[:COAL,60],[:LIGHTCLAY,40],[:COPPERORE,40],[:IRONORE,30]],
  :uncommon_rewards => [[:HARDSTONE,60],[:GOLDORE,30],[:SILVERORE,20],[:EVERSTONE, 10]],
  :rare_rewards => [[:FIRESTONE, 30],[:WATERSTONE, 30],[:THUNDERSTONE, 30],[:LEAFSTONE, 30],[:MOONSTONE, 30],[:DAWNSTONE, 30],[:ICESTONE, 30],[:SUNSTONE, 30],[:OVALSTONE, 70],[:EVIOLITE, 40]]
})