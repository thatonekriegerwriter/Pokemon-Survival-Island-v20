#=======================================================
# This section handles the playing of the sound effects 
# associated with the weather condition. All sound
# effects must be placed in the BGS folder, as this is
# how they will play alongside map bgm.
#=======================================================
class Game_Screen
  alias owsfx_weather weather
	
  def weather(type, power, duration)
    owsfx_weather(type, power, duration)
    case @weather_type
      when :Rain        then pbBGSPlay("Rain",50)
      when :Storm 		then pbBGSPlay("Storm",50)
      when :Snow        then pbBGSPlay("Snow",50)
      when :Blizzard    then pbBGSPlay("Blizzard",50)
      when :Sandstorm   then pbBGSPlay("Sandstorm",50)
      when :HeavyRain   then pbBGSPlay("HeavyStorm",50)
      when :Sun         then pbBGSPlay("Sunny",50)
      when :Fog         then pbBGSPlay("Fog",50)
      else                   pbBGSFade(duration)
	end
  end
end

#=======================================================
# This section handles the playing of thunder sound
# effects when it is storming. These sound effects must
# be in the SE folder.
#=======================================================
module RPG
  class Weather
    alias owsfx_update update unless method_defined?(:owsfx_update)
    def update
      if @type == :Storm && !@fading && @time_until_flash > 0 && @time_until_flash - Graphics.delta_s <= 0
        sfx = ["OWThunder1", "OWThunder2", nil].sample
        pbSEPlay(sfx) if sfx
      end
      owsfx_update
    end
  end
end