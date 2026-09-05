SaveData.register(:ambient_temperature) do
  ensure_class :AmbientTemperature 
  save_value { $ambienttemperature  }
  load_value { |value| $ambienttemperature = value }
  new_game_value {
    AmbientTemperature.new
  }
end





 
class AmbientTemperature
  attr_accessor :temperature
  #Measured in Celcius 
  BASE_BODY_TEMPERATURE = 37.0  
  WATERFREEZING = 0.0
  ROOMTEMPERATURE = 20.0
  COMFORTABLE_LOW  = 18.0
  COMFORTABLE_HIGH = 24.0
  def initialize 
    @temperature = {} 
	time_now = pbGetTimeNow.to_i
    @last_time_changed = time_now
    @last_time_changed_player = time_now
	set_up_maps
  end 
  
  def last_time_changed
    @last_time_changed = pbGetTimeNow.to_i if @last_time_changed.nil?
    return @last_time_changed
  end 
  def last_time_changed_player
    @last_time_changed_player = pbGetTimeNow.to_i if @last_time_changed_player.nil?
    return @last_time_changed_player
  end 
  def temperature
    if @temperature.nil?
      @temperature = {} 
	  set_up_maps
    end 
	@temperature
  end 
  
  def update
    puts "Fuck." unless should_have_temperature?
    return unless should_have_temperature?
    if @temperature.nil?
      @temperature = {} 
	  set_up_maps
    end 
    time_now = pbGetTimeNow.to_i
	player_time_delta = time_now - last_time_changed_player
	map_time_delta = time_now - last_time_changed
    if map_time_delta >= 3600
     adjust_temperature
     @last_time_changed = time_now
    end
	if player_time_delta >= 60
      adjust_body_temperature
      @last_time_changed_player = time_now
    end
  end 
  
  def set_up_maps
    season = pbGetSeason
   GameData::MapMetadata.each do |map_data|
     map_id = map_data.id
     @temperature[map_id] = {
        :temperature => average_climate_from_season(map_data),
        :season      => season}
   end 
  end 
  

  def adjust_temperature(map_id = $game_map.map_id)
    data = @temperature[map_id]
    return unless data

    season = pbGetSeason
    puts "Current Temperature: #{data[:temperature]} C"
    # Reset the map to its seasonal average when the season changes.
    if data[:season] != season
      data[:season] = season
      data[:temperature] = average_climate_from_season(GameData::MapMetadata.get(map_id))
      puts "New Temperature (Season Change): #{data[:temperature]} C"
      return
    end

    cool = 0
    hot  = 0
    amount = rand(7) + 1

    amount.times do
      case season
      when 0 # Spring
        hot += 1
      when 1 # Summer
        hot += 2
      when 2 # Autumn
        cool += 1
      when 3 # Winter
        cool += 2
      end

      if rand(2) == 0
        cool += 1
      else
        hot += 1
      end
    end

    if cool > hot
      data[:temperature] -= amount
    elsif hot > cool
      data[:temperature] += amount
    elsif rand(2) == 0
      data[:temperature] -= amount
    else
      data[:temperature] += amount
    end
    puts "New Temperature: #{data[:temperature]} C"
  end
   
  def average_climate_from_season(map_data)
    map_name = map_data.name
    season = pbGetSeason
    return ROOMTEMPERATURE unless map_data.outdoor_map
    if map_name.include?("Temperate") || map_name.include?("Western")
      avtemp = case season
               when 0 then 18 # Spring
               when 1 then 21 # Summer
               when 2 then 13 # Autumn
               when 3 then -3 # Winter
               end

    elsif map_name.include?("Tropical")
      avtemp = case season
               when 0 then 24 # Spring
               when 1 then 28 # Summer
               when 2 then 24 # Autumn
               when 3 then 20 # Winter
               end

    elsif map_name.include?("Chilled")
      avtemp = case season
               when 0 then 16  # Spring
               when 1 then 19  # Summer
               when 2 then 10  # Autumn
               when 3 then -13 # Winter
               end

    elsif map_name.include?("Frigid")
      avtemp = case season
               when 0 then 14  # Spring
               when 1 then 17  # Summer
               when 2 then 8   # Autumn
               when 3 then -30 # Winter
               end

    elsif map_name.include?("Jungle")
      avtemp = case season
               when 0 then 24 # Spring
               when 1 then 28 # Summer
               when 2 then 24 # Autumn
               when 3 then 20 # Winter
               end

    elsif map_name.include?("Northern")
      avtemp = case season
               when 0 then 18 # Spring
               when 1 then 21 # Summer
               when 2 then 13 # Autumn
               when 3 then -3 # Winter
               end

    else
      avtemp = case season
               when 0 then 18 # Spring
               when 1 then 21 # Summer
               when 2 then 13 # Autumn
               when 3 then -3 # Winter
               end
    end

    if map_name.include?("Highland")
      avtemp += case season
                when 0 then -1 # Spring
                when 1 then 1  # Summer
                when 2 then -1 # Autumn
                when 3 then -7 # Winter
                end
    end

    if map_name.include?("Skies")
      avtemp += case season
                when 0 then -7  # Spring
                when 1 then -3  # Summer
                when 2 then -7  # Autumn
                when 3 then -13 # Winter
                end
    end

    if map_name.include?("Desert")
      avtemp += case season
                when 0 then 7  # Spring
                when 1 then 3  # Summer
                when 2 then 7  # Autumn
                when 3 then 13 # Winter
                end
    end

    avtemp
  end
   

def adjust_body_temperature
  player_temp = $player.playertemperature
  ambient = map_temperature
  return unless ambient

  player_temp += (BASE_BODY_TEMPERATURE - player_temp) * 0.01

  if ambient < COMFORTABLE_LOW
    difference = COMFORTABLE_LOW - ambient
	exposure = 0.0002 * (difference ** 1.5)
	player_temp -= exposure
  elsif ambient > COMFORTABLE_HIGH
    difference = ambient - COMFORTABLE_HIGH
	exposure = 0.0002 * (difference ** 1.5)
	player_temp += exposure
  end
   if $player.playertemperature!=player_temp
   puts "Current Map Temperature: #{ambient} C"
   puts "Current Body Temperature: #{$player.playertemperature} C"
   puts "New Body Temperature: #{player_temp} C"
   end
  $player.playertemperature = player_temp
  update_temperature_animation(player_temp)
end

def update_temperature_animation(temperature)
  animation =
    if temperature <= 29.0
      65
    elsif temperature <= 32.0
      64
    elsif temperature <= 35.0
      63
    elsif temperature < COMFORTABLE_LOW
      62
    elsif temperature >= 43.0
      69
    elsif temperature >= 41.0
      68
    elsif temperature >= 39.0
      67
    elsif temperature > BASE_BODY_TEMPERATURE
      66
    else
	  50
    end


  return if animation == @temperature_animation

  @temperature_animation = animation
  return unless animation

  $scene.spriteset.addUserAnimation(
    animation,
    $game_player.x,
    $game_player.y,
    true,
    1
  )
end

def map_temperature(map_id = $game_map.map_id)
  data = @temperature[map_id]
  return nil unless data

  data[:temperature]
end


def hypothermia?
  temperature = $player.playertemperature
  temperature <= 35.0
end

def severe_hypothermia?
  temperature = $player.playertemperature
  temperature <= 32.0
end

def hyperthermia?
  temperature = $player.playertemperature
  temperature >= 39.0
end

def severe_hyperthermia?
  temperature = $player.playertemperature
  temperature >= 41.0
end

end






