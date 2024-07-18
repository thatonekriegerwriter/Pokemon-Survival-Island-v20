#===============================================================================
# * Weather System Configuration
#===============================================================================

module WeatherConfig
  # Set to false to use the Weather System.
  NO_WEATHER = false		# Default: false

  # Set to true to show the weather on the Town Map.
  SHOW_WEATHER_ON_MAP = false	# Default: true

  # Set to true to use the computer's time. Will not work without Unreal Time System.
  USE_REAL_TIME = false		# Default: true

  # Set to true to have the weather change at midnight.
  CHANGE_MIDNIGHT = false	# Default: true

  # Define the min and max amount of time (in hours) before the weather changes.
  # Set the same number to not randomize the amount of time before the weather changes.
  CHANGE_TIME_MIN = 1		# Default: 1
  CHANGE_TIME_MAX = 4		# Default: 4

  # Set to true to if you want to force the weather to change when interacting with certain events.
  # Use pbForceUpdateWeather in an event to update all zone weathers.
  # Use pbForceUpdateZoneWeather(zone) in an event to update the weather of a zone.
  FORCE_UPDATE = true		# Default: false

  # Set to true to have the outdoor maps change with seasons.
  # The map's appearance will update when leaving an indoor map.
  SEASON_CHANGE = false		# Default: false

  # Set to true if your game starts outdoors and want to show the season splash when going somewhere indoors.
  # Set to false if your game starts indoors and want to show the season splash when going somewhere outdoors.
  OUTDOOR = false		# Default: false

  # Array with the ID of outside tilesets that will change with seasons.
  OUTDOOR_TILESETS = [1, 2]

  # The difference between the ID of the tileset defined for an outdoor map and it's season version.
  # The difference has to be the same for any tileset defined in OUTDOOR_TILESETS.
  # Use the same season tileset as the default outdoor map tileset and define the diference for that season as 0.
  SUMMER_TILESET = 22
  AUTUMN_TILESET = 24
  WINTER_TILESET = 26
  SPRING_TILESET = 0

#===============================================================================
# * Weather Substitute
#===============================================================================
  # A hash with the ID of the maps that will have or not have certain weathers.
  MAPS_SUBSTITUTE = {
	:Snow => ["exclude", 111,130,131,158,138,132,159,142,133,160,161,134],
	:Blizzard => ["include", 71,72,77,73,78,80,74,85,82],
    :Sandstorm => ["include", 111,130,131,158,138,132,159,142,133,160,161,134]
  }

  # The ID of the weathers that will substitute the main when in one of the summer or sandstorm maps.
  # There has to be a hash (defined between {}) for each defined zone with weather to substitute.
  # Any weather not defined in the hash for a zone will use the main weather instead.
  WEATHER_SUBSTITUTE = [
	{:None => :None, :Rain => :Rain, :Storm => :Storm, :Snow => :Rain, :Blizzard => :Storm, :Sandstorm => :None, :HeavyRain => :HeavyRain, :Sun => :Sun, :Fog => :Fog},
	{:Snow => :Rain, :Blizzard => :Storm, :Sandstorm => :None},
	{:Snow => :Rain, :Blizzard => :HeavyRain}
  ]

#===============================================================================
# * Weather Names
#===============================================================================
  # A hash that contains the ID of weather and the name to display for each one.
  # Using .downcase will make them lowercase.
  WEATHER_NAMES = {
	:None		=> _INTL("None"),
	:Rain		=> _INTL("Rain"),
	:Storm		=> _INTL("Storm"),
	:Snow		=> _INTL("Snow"),
	:Blizzard	=> _INTL("Blizzard"),
	:Sandstorm	=> _INTL("Sandstorm"),
	:HeavyRain	=> _INTL("Heavy rain"),
	:Sun		=> _INTL("Sun"),
	:Fog		=> _INTL("Fog")
  }

#===============================================================================
# * Zones Configuration
#===============================================================================
  # Arrays of id of the maps of each zone. Each array within the main array is a zone.
  # The maps within each zone will have the same weather at the same time.
  # Each zone may have a different weather than the others.
 temperate_forest = [5,4,243,300,7,349,350,8,9,13,45,54,47,282,44,68,64]
 temperate_highlands=[16,24,31,19,30,29,28,17]
 temperate_marsh=[33,34,35,109,26,218,233]
 deep_marsh=[36,84,86,110,140,44,68]
 frigid_highlands=[71,72,77,73,78,80,74,85,82]
 tropical_coast=[111,130,131,158,138,132,159,142,133,160,161,134]
 temperate_ocean=[48,62,38,39,58,59,57,60,61,53,234,235,236,42,144,137,43,385,387,392,396,397]
 deep_forest=[200,201,204,202,203,244,205]
 northern_highlands=[207,208,157,237,238,313,315,311,312,209]
 western_shores=[205,295,296,308,302,310,307,309]
 western_temperate=[318,319,320,323,325,326,330,331,327,328,329]
 western_jungle=[338,354,355,356,357]
 ravine=[81]
  ZONE_MAPS = [[5,4,243,300,7,349,350,8,9,13,45,54,47,282,44,68,64], 
  [16,24,31,19,30,29,28,17], 
  [33,34,35,109,26,218,233], 
  [36,84,86,110,140,44,68], 
  [71,72,77,73,78,80,74,85,82],
  [111,130,131,158,138,132,159,142,133,160,161,134], 
  [48,62,38,39,58,59,57,60,61,53,234,235,236,42,144,137,43,385,387,392,396,397], 
  [200,201,204,202,203,244,205], 
  [207,208,157,237,238,313,315,311,312,209], 
  [205,295,296,308,302,310,307,309], 
  [318,319,320,323,325,326,330,331,327,328,329],
 [338,354,355,356,357]] 
  
#===============================================================================
# * Season Probability Configuration
#===============================================================================
  # Arrays of probability of weather for each zone in the different seasons.
  # Each array within the main array corresponds to a zone in ZONE_MAPS.
  # Put 0 to weather you don't want if you define a probability after it.
  # If your game doesn't use seasons, edit the probabilities of one season and copy it to the others.

  # Probability of weather in summer.
  # None,Rain,Storm, Snow, Blizzard, Sandstorm, HeavyRain, Sun/Sunny, Fog
  ZONE_WEATHER_SUMMER = [
    [30, 30, 15, 0, 0, 0, 5, 20, 0], #temperate_forest
    [30, 20, 10, 0, 0, 0, 1, 20, 0], #temperate_highlands
    [20, 30, 30, 0, 0, 0, 30, 5, 60], #temperate_marsh
    [40, 50, 0, 0, 0, 0, 50, 0, 70], #deep_marsh
    [60, 1, 1, 30, 1, 0, 1, 0, 60], #frigid_highlands
    [20, 5, 3, 0, 0, 0, 2, 20, 0], #tropical_coast
    [60, 20, 3, 0, 0, 0, 5, 20, 0], #temperate_ocean 
    [40, 10, 10, 3, 0, 0, 0, 5, 30], #deep_forest
    [60, 20, 3, 0, 0, 5, 0, 10, 0], #northern_highlands
    [30, 30, 15, 0, 0, 0, 5, 10, 0], #western_shore
    [30, 30, 15, 0, 0, 0, 5, 40, 0], #western_temperate
    [40, 20, 0, 0, 0, 0, 20, 0, 0], #western_jungle
  ]

  # Probability of weather in autumn.
  # Order: None, Rain, Storm, Snow, Blizzard, Sandstorm, HeavyRain, Sun/Sunny, Fog
  ZONE_WEATHER_AUTUMN = [
    [30, 30, 15, 0, 0, 0, 5, 0, 0], #temperate_forest
    [30, 20, 10, 0, 0, 0, 1, 0, 0], #temperate_highlands
    [20, 30, 30, 0, 0, 0, 30, 0, 60], #temperate_marsh
    [40, 40, 0, 0, 0, 0, 40, 0, 70], #deep_marsh
    [30, 0, 0, 40, 10, 0, 0, 0, 60], #frigid_highlands
    [20, 5, 3, 0, 0, 0, 2, 20, 0], #tropical_coast
    [40, 20, 0, 0, 0, 0, 5, 0, 10], #temperate_ocean 
    [40, 10, 10, 3, 0, 0, 0, 0, 30], #deep_forest
    [60, 0, 0, 5, 0, 0, 0, 0, 0], #northern_highlands
    [30, 30, 15, 0, 0, 0, 5, 20, 0], #western_shore
    [30, 30, 15, 0, 0, 0, 5, 0, 0], #western_temperate
    [40, 0, 0, 0, 0, 0, 0, 0, 0], #western_jungle
  ]

  # Probability of weather in winter.
  # Order: None, Rain, Storm, Snow, Blizzard, Sandstorm, HeavyRain, Sun/Sunny, Fog
  ZONE_WEATHER_WINTER = [
    [30, 1, 1, 60, 20, 0, 0, 0, 40], #temperate_forest
    [30, 1, 1, 40, 10, 0, 0, 0, 20], #temperate_highlands
    [20, 20, 0, 40, 10, 0, 0, 0, 75], #temperate_marsh
    [40, 0, 0, 0, 0, 0, 0, 0, 70], #deep_marsh
    [60, 0, 0, 80, 60, 0, 0, 0, 60], #frigid_highlands
    [20, 0, 0, 0, 0, 0, 0, 0, 0], #tropical_coast
    [60, 1, 1, 0, 10, 0, 0, 0, 40], #temperate_ocean 
    [40, 0, 0, 0, 0, 0, 0, 0, 30], #deep_forest
    [60, 20, 1, 0, 5, 1, 0, 0, 20], #northern_highlands
    [30, 30, 15, 0, 0, 0, 5, 40, 0], #western_shore
    [30, 1, 1, 60, 20, 0, 0, 0, 40], #western_temperate
    [40, 0, 0, 0, 0, 0, 0, 0, 0], #western_jungle
  ]

  # Probability of weather in spring.
  # Order: None, Rain, Storm, Snow, Blizzard, Sandstorm, HeavyRain, Sun/Sunny, Fog
  ZONE_WEATHER_SPRING = [
    [30, 40, 25, 0, 0, 0, 30, 0, 0], #temperate_forest
    [30, 20, 10, 0, 0, 0, 1, 0, 0], #temperate_highlands
    [20, 30, 30, 0, 0, 0, 30, 0, 60], #temperate_marsh
    [40, 40, 0, 0, 0, 0, 40, 0, 70], #deep_marsh
    [30, 0, 0, 40, 10, 0, 0, 0, 60], #frigid_highlands
    [20, 5, 3, 0, 0, 0, 2, 40, 0], #tropical_coast
    [40, 20, 0, 0, 0, 0, 5, 0, 10], #temperate_ocean 
    [40, 10, 10, 3, 0, 0, 0, 0, 30], #deep_forest
    [60, 0, 0, 5, 0, 0, 0, 0, 0], #northern_highlands
    [30, 30, 15, 0, 0, 0, 5, 40, 0], #western_shore
    [30, 40, 25, 0, 0, 0, 30, 0, 0], #western_temperate
    [40, 0, 0, 0, 0, 0, 0, 0, 0], #western_jungle
  ]
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
#===============================================================================
# * Map Display
#===============================================================================
  # Array of hashes to get each map's position in the Town Map. Each hash corresponds to a zone in ZONE_MAPS.
  # In "Map Name" you have to put the name the Town Map displays for that point.
  # In Map ID you have to put the ID of the map the name corresponds to, like in ZONE_MAPS.
    #{"Map Name" => Map ID},
  MAPS_POSITIONS = [
    {"Lappet Town" => 2, "Route 1" => 5},
    {"Cedolan City" => 7},
    {"Route 2" => 21}
  ]

  # A hash for the plugin to display the proper weather image on the map.
  # They have to be on Graphics/Pictures/Weather (in 20+) or Graphics/UI/Weather (in 21+).
  WEATHER_IMAGE = {
    :Rain => "mapRain",
    :Storm => "mapStorm",
    :Snow => "mapSnow",
    :Blizzard => "mapBlizzard",
    :Sandstorm => "mapSand",
    :HeavyRain => "mapRain",
    :Sun => "mapSun",
    :Fog => "mapFog"
  }

end