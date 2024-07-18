SaveData.register(:ambient_temperature) do
  ensure_class :AmbientTemperature 
  save_value { $ambienttemperature  }
  load_value { |value| $ambienttemperature = value }
  new_game_value {
    AmbientTemperature.new
  }
end





 
 class AmbientTemperature
  attr_accessor :map_temperatures
    
	
	def initialize
       @maps_temperature = {} 
       @set_temp = false
       @room_temp = 20
       @freezing = 0
       @bodytemperature  = 37.0   # Speech frame
    end
   
   def set_up_maps
    $map_factory.maps.each do |map|
	  map_id = map.id
     @maps_temperature[map_id]=[map.name,average_climate_from_season(map_name),pbGetSeason]
	 @last_set = pbGetTimeNow
    end
   end
   
   def adjusttemperature(map_id)
     temperature = @maps_temperature[map_id][1]
     sourceseason = @maps_temperature[map_id][2]
	 if sourceseason!=pbGetSeason
	   sourceseason=pbGetSeason
	   temperature = average_climate_from_season($map_factory.getMap(map_id).name)
	 end
	  cool = 0
	  hot = 0
	  amt = rand(7)+1
	  amt.times do 
	  case season
		  when 0 #Spring
          hot += 1
		  when 1 #Summer
          hot += 2
		  when 2 #Autumn
          cool += 1
		  when 3 #Winter
          cool += 2
	   end

	    if rand(2)==0 #Cool
		  cool+=1
		else #Hot
		  hot+=1
		end


      end


	  if cool>hot
	     temperature-=amt
	  elsif hot>cool
	     temperature+=amt
	  else
	    if rand(2)==0 #Cool
	     temperature-=amt
		else #Hot
	     temperature+=amt
		end
	  end
	  @maps_temperature[map_id][1]=temperature
   end
   
   def average_climate_from_season(map_name)
     avtemp = 18
     season = pbGetSeason
     if map_name.include?(Temperate) || map_name.include?(Western)
	    case season
		  when 0 #Spring
          avtemp = 18
		  when 1 #Summer
          avtemp = 21
		  when 2 #Autumn
          avtemp = 13
		  when 3 #Winter
          avtemp = -3
		 end
	 elsif map_name.include?(Tropical)
	    case season
		  when 0 #Spring
          avtemp = 24
		  when 1 #Summer
          avtemp = 28
		  when 2 #Autumn
          avtemp = 24
		  when 3 #Winter
          avtemp = 20
		 end
	 elsif map_name.include?(Chilled)
	    case season
		  when 0 #Spring
          avtemp = 16
		  when 1 #Summer
          avtemp = 19
		  when 2 #Autumn
          avtemp = 10
		  when 3 #Winter
          avtemp = -13
		 end
	 elsif map_name.include?(Frigid)
	    case season
		  when 0 #Spring
          avtemp = 14
		  when 1 #Summer
          avtemp = 17
		  when 2 #Autumn
          avtemp = 8
		  when 3 #Winter
          avtemp = -30
		 end
	 elsif map_name.include?(Jungle)
	    case season
		  when 0 #Spring
          avtemp = 24
		  when 1 #Summer
          avtemp = 28
		  when 2 #Autumn
          avtemp = 24
		  when 3 #Winter
          avtemp = 20
		 end
	 elsif map_name.include?(Northern)
	    case season
		  when 0 #Spring
          avtemp = 18
		  when 1 #Summer
          avtemp = 21
		  when 2 #Autumn
          avtemp = 13
		  when 3 #Winter
          avtemp = -3
		 end
	 else
	    case season
		  when 0 #Spring
          avtemp = 18
		  when 1 #Summer
          avtemp = 21
		  when 2 #Autumn
          avtemp = 13
		  when 3 #Winter
          avtemp = -3
		 end
	 end
     if map_name.include?(Highland)
	    case season
		  when 0 #Spring
          avtemp -= 1
		  when 1 #Summer
          avtemp += 1
		  when 2 #Autumn
          avtemp -= 1
		  when 3 #Winter
          avtemp -= 7
		 end
	 end
     if map_name.include?(Skies)
	    case season
		  when 0 #Spring
          avtemp -= 7
		  when 1 #Summer
          avtemp -= 3
		  when 2 #Autumn
          avtemp -= 7
		  when 3 #Winter
          avtemp -= 13
		 end
	 end
     if map_name.include?(Desert)
	    case season
		  when 0 #Spring
          avtemp += 7
		  when 1 #Summer
          avtemp += 3
		  when 2 #Autumn
          avtemp += 7
		  when 3 #Winter
          avtemp += 13
		 end
	 end

      return avtemp
   end
 

   
   def adjust_body_temp
     player_temp = $player.playertemperature
     temperature = @maps_temperature[$game_map.map_id][1]
     homeostasis = false
	 if temperature>player_temp
	    player_temp+=0.15
		 homeostasis=true
	 else temperature<player_temp
	    player_temp-=0.15
		 homeostasis=true
     end 
     if temperature>=40 
	    player_temp+=0.75
     homeostasis = false
	 elsif temperature>=20 && temperature<40
	    player_temp+=0.50
     homeostasis = false
	 elsif temperature<=13 && temperature>0
	    player_temp-=0.50
     homeostasis = false
	 elsif temperature<=-20
	    player_temp-=0.75
     homeostasis = false
	 end
	   if homeostasis==true
	     if player_temp>@bodytemperature+3
	       player_temp=@bodytemperature+3
	     elsif player_temp<@bodytemperature-3
	       player_temp=@bodytemperature-3
		 
		 end
	   end
	 
	 end






   end






class Player < Trainer









end





