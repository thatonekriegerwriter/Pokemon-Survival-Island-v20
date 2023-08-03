#===============================================================================
# Day and night system
#===============================================================================



module PBDayNight
  HOURLY_TONES = [
    Tone.new(-70, -90,  15, 55),   # Night           # Midnight
    Tone.new(-70, -90,  15, 55),   # Night
    Tone.new(-70, -90,  15, 55),   # Night
    Tone.new(-70, -90,  15, 55),   # Night
    Tone.new(-60, -70,  -5, 50),   # Night
    Tone.new(-40, -50, -35, 50),   # Day/morning
    Tone.new(-40, -50, -35, 50),   # Day/morning     # 6AM
    Tone.new(-40, -50, -35, 50),   # Day/morning
    Tone.new(-40, -50, -35, 50),   # Day/morning
    Tone.new(-20, -25, -15, 20),   # Day/morning
    Tone.new(  0,   0,   0,  0),   # Day
    Tone.new(  0,   0,   0,  0),   # Day
    Tone.new(  0,   0,   0,  0),   # Day             # Noon
    Tone.new(  0,   0,   0,  0),   # Day
    Tone.new(  0,   0,   0,  0),   # Day/afternoon
    Tone.new(  0,   0,   0,  0),   # Day/afternoon
    Tone.new(  0,   0,   0,  0),   # Day/afternoon
    Tone.new(  0,   0,   0,  0),   # Day/afternoon
    Tone.new( -5, -30, -20,  0),   # Day/evening     # 6PM
    Tone.new(-15, -60, -10, 20),   # Day/evening
    Tone.new(-15, -60, -10, 20),   # Day/evening
    Tone.new(-40, -75,   5, 40),   # Night
    Tone.new(-70, -90,  15, 55),   # Night
    Tone.new(-70, -90,  15, 55)    # Night
  ]
  @cachedTone = nil
  @dayNightToneLastUpdate = nil
  @oneOverSixty = 1 / 60.0

  # Returns true if it's day.
  def self.isDay?(time = nil)
    time = pbGetTimeNow if !time
    return (time.hour >= 5 && time.hour < 20)
  end

  # Returns true if it's night.
  def self.isNight?(time = nil)
    time = pbGetTimeNow if !time
    return (time.hour >= 20 || time.hour < 5)
  end

  # Returns true if it's morning.
  def self.isMorning?(time = nil)
    time = pbGetTimeNow if !time
    return (time.hour >= 5 && time.hour < 10)
  end

  # Returns true if it's the afternoon.
  def self.isAfternoon?(time = nil)
    time = pbGetTimeNow if !time
    return (time.hour >= 14 && time.hour < 17)
  end

  # Returns true if it's the evening.
  def self.isEvening?(time = nil)
    time = pbGetTimeNow if !time
    return (time.hour >= 17 && time.hour < 20)
  end

  # Gets a number representing the amount of daylight (0=full night, 255=full day).
  def self.getShade
    time = pbGetDayNightMinutes
    time = (24 * 60) - time if time > (12 * 60)
    return 255 * time / (12 * 60)
  end

  # Gets a Tone object representing a suggested shading
  # tone for the current time of day.
  def self.getTone
    @cachedTone = Tone.new(0, 0, 0) if !@cachedTone
    return @cachedTone if !Settings::TIME_SHADING
    if !@dayNightToneLastUpdate ||
       Graphics.frame_count - @dayNightToneLastUpdate >= Graphics.frame_rate * 30
      getToneInternal
      @dayNightToneLastUpdate = Graphics.frame_count
    end
    return @cachedTone
  end

  def self.pbGetDayNightMinutes
    now = pbGetTimeNow   # Get the current in-game time
    return (now.hour * 60) + now.min
  end

  def self.getToneInternal
    # Calculates the tone for the current frame, used for day/night effects
    realMinutes = pbGetDayNightMinutes
    hour   = realMinutes / 60
    minute = realMinutes % 60
    tone         = PBDayNight::HOURLY_TONES[hour]
    nexthourtone = PBDayNight::HOURLY_TONES[(hour + 1) % 24]
    # Calculate current tint according to current and next hour's tint and
    # depending on current minute
    @cachedTone.red   = ((nexthourtone.red - tone.red) * minute * @oneOverSixty) + tone.red
    @cachedTone.green = ((nexthourtone.green - tone.green) * minute * @oneOverSixty) + tone.green
    @cachedTone.blue  = ((nexthourtone.blue - tone.blue) * minute * @oneOverSixty) + tone.blue
    @cachedTone.gray  = ((nexthourtone.gray - tone.gray) * minute * @oneOverSixty) + tone.gray
  end
end



def pbDayNightTint(object)
  return if !$scene.is_a?(Scene_Map)
  if Settings::TIME_SHADING && $game_map.metadata&.outdoor_map
    tone = PBDayNight.getTone
    object.tone.set(tone.red, tone.green, tone.blue, tone.gray)
  else
    object.tone.set(0, 0, 0, 0)
  end
end



#===============================================================================
# Moon phases and Zodiac
#===============================================================================
# Calculates the phase of the moon.
# 0 - New Moon
# 1 - Waxing Crescent
# 2 - First Quarter
# 3 - Waxing Gibbous
# 4 - Full Moon
# 5 - Waning Gibbous
# 6 - Last Quarter
# 7 - Waning Crescent
def moonphase(time = nil) # in UTC
  time = pbGetTimeNow if !time
  transitions = [
    1.8456618033125,
    5.5369854099375,
    9.2283090165625,
    12.9196326231875,
    16.6109562298125,
    20.3022798364375,
    23.9936034430625,
    27.6849270496875
  ]
  yy = time.year - ((12 - time.mon) / 10.0).floor
  j = (365.25 * (4712 + yy)).floor + ((((time.mon + 9) % 12) * 30.6) + 0.5).floor + time.day + 59
  j -= (((yy / 100.0) + 49).floor * 0.75).floor - 38 if j > 2_299_160
  j += (((time.hour * 60) + (time.min * 60)) + time.sec) / 86_400.0
  v = (j - 2_451_550.1) / 29.530588853
  v = ((v - v.floor) + (v < 0 ? 1 : 0))
  ag = v * 29.53
  transitions.length.times do |i|
    return i if ag <= transitions[i]
  end
  return 0
end

# Calculates the zodiac sign based on the given month and day:
# 0 is Aries, 11 is Pisces. Month is 1 if January, and so on.
def zodiac(month, day)
  time = [
    3, 21, 4, 19,   # Aries
    4, 20, 5, 20,   # Taurus
    5, 21, 6, 20,   # Gemini
    6, 21, 7, 20,   # Cancer
    7, 23, 8, 22,   # Leo
    8, 23, 9, 22,   # Virgo
    9, 23, 10, 22,  # Libra
    10, 23, 11, 21, # Scorpio
    11, 22, 12, 21, # Sagittarius
    12, 22, 1, 19,  # Capricorn
    1, 20, 2, 18,   # Aquarius
    2, 19, 3, 20    # Pisces
  ]
  (time.length / 4).times do |i|
    return i if month == time[i * 4] && day >= time[(i * 4) + 1]
    return i if month == time[(i * 4) + 2] && day <= time[(i * 4) + 3]
  end
  return 0
end

# Returns the opposite of the given zodiac sign.
# 0 is Aries, 11 is Pisces.
def zodiacOpposite(sign)
  return (sign + 6) % 12
end

# 0 is Aries, 11 is Pisces.
def zodiacPartners(sign)
  return [(sign + 4) % 12, (sign + 8) % 12]
end

# 0 is Aries, 11 is Pisces.
def zodiacComplements(sign)
  return [(sign + 1) % 12, (sign + 11) % 12]
end

#===============================================================================
# Days of the week
#===============================================================================
def pbIsWeekday(wdayVariable, *arg)
  timenow = pbGetTimeNow
  wday = timenow.wday
  ret = false
  arg.each do |wd|
    ret = true if wd == wday
  end
  if wdayVariable > 0
    $game_variables[wdayVariable] = [
      _INTL("Sunday"),
      _INTL("Monday"),
      _INTL("Tuesday"),
      _INTL("Wednesday"),
      _INTL("Thursday"),
      _INTL("Friday"),
      _INTL("Saturday")
    ][wday]
    $game_map.need_refresh = true if $game_map
  end
  return ret
end

#===============================================================================
# Months
#===============================================================================
def pbIsMonth(monVariable, *arg)
  timenow = pbGetTimeNow
  thismon = timenow.mon
  ret = false
  arg.each do |wd|
    ret = true if wd == thismon
  end
  if monVariable > 0
    $game_variables[monVariable] = pbGetMonthName(thismon)
    $game_map.need_refresh = true if $game_map
  end
  return ret
end

def pbGetMonthName(month)
  return [_INTL("January"),
          _INTL("February"),
          _INTL("March"),
          _INTL("April"),
          _INTL("May"),
          _INTL("June"),
          _INTL("July"),
          _INTL("August"),
          _INTL("September"),
          _INTL("October"),
          _INTL("November"),
          _INTL("December")][month - 1]
end

def pbGetAbbrevMonthName(month)
  return [_INTL("Jan."),
          _INTL("Feb."),
          _INTL("Mar."),
          _INTL("Apr."),
          _INTL("May"),
          _INTL("Jun."),
          _INTL("Jul."),
          _INTL("Aug."),
          _INTL("Sep."),
          _INTL("Oct."),
          _INTL("Nov."),
          _INTL("Dec.")][month - 1]
end

#===============================================================================
# Seasons
#===============================================================================
def pbGetSeason
  return 0 if pbGetTimeNow.mon== 3 || pbGetTimeNow.mon == 4 || pbGetTimeNow.mon == 5 #Spring
  return 1 if pbGetTimeNow.mon== 6 || pbGetTimeNow.mon == 7 || pbGetTimeNow.mon == 8 #Summer
  return 2 if pbGetTimeNow.mon== 9 || pbGetTimeNow.mon == 10 || pbGetTimeNow.mon == 11 #Fall
  return 3 if pbGetTimeNow.mon== 12 || pbGetTimeNow.mon == 1 || pbGetTimeNow.mon == 2 #Winter
end

def pbIsSeason(seasonVariable, *arg)
  thisseason = pbGetSeason
  ret = false
  arg.each do |wd|
    ret = true if wd == thisseason
  end
  if seasonVariable > 0
    $game_variables[seasonVariable] = [_INTL("Spring"),
                                       _INTL("Summer"),
                                       _INTL("Autumn"),
                                       _INTL("Winter")][thisseason]
    $game_map.need_refresh = true if $game_map
  end
  return ret
end

def pbIsSpring; return pbIsSeason(0, 0); end # Jan, May, Sep
def pbIsSummer; return pbIsSeason(0, 1); end # Feb, Jun, Oct
def pbIsAutumn; return pbIsSeason(0, 2); end # Mar, Jul, Nov
def pbIsFall; return pbIsAutumn; end
def pbIsWinter; return pbIsSeason(0, 3); end # Apr, Aug, Dec

def pbGetSeasonName(season)
  return [_INTL("Spring"),
          _INTL("Summer"),
          _INTL("Autumn"),
          _INTL("Winter")][season]
end


def pbGetDaysinMonth(month)
  return 31 if [1, 3, 5, 7, 8, 10, 12].include?(month) # January, March, May, July, August, October, December
  return 30 if [4, 6, 9, 11].include?(month) # April, June, September, November
  return 28 if month==2
end



class CalendarScene
  
  def pbStartScene
    @calendar=Sprite.new
    @calendar.bitmap=RPG::Cache.picture("Calendar")
    @calendar.x=(Graphics.width-@calendar.bitmap.width)/2
    @calendar.y=(Graphics.height-@calendar.bitmap.height)/2
    
    @overlay=Sprite.new
    @overlay.bitmap=Bitmap.new(450,322)
    @overlay.x=@calendar.x+32
    @overlay.y=@calendar.y+48
    @overlay2=Sprite.new
    @overlay2.bitmap=Bitmap.new(450,322)
    @overlay2.x=@calendar.x+32
    @overlay2.y=@calendar.y
    @overlay2.bitmap.font.color=Color.new(0,0,0)
    @overlay.bitmap.font.color=Color.new(0,0,0)
    @overlay3=Sprite.new
    @overlay3.bitmap=Bitmap.new(450,322)
    @overlay3.x=@calendar.x+32
    @overlay3.y=@calendar.y
    @overlay3.bitmap.font.color=Color.new(0,0,0)
    
    @year=pbGetTimeNow.year
    @season=pbGetSeason
    @month=(pbGetTimeNow.mon+1)
    @days=(pbGetTimeNow.day+1)
    @wday=(pbGetTimeNow.wday+1)
	@potato=0
	@wdays = []
	@wdays2 = [_INTL("Mon"),
      _INTL("Tue"),
      _INTL("Wed"),
      _INTL("Thu"),
      _INTL("Fri"),
      _INTL("Sat"),
	  _INTL("Sun")]
	pbCalendarLogic
  end
  
  def pbUpdate
#    pbUpdateSpriteHash(@sprites)
  end
  def get_elapsed_days
  # Get the current time as a Time object.

  # Calculate the difference in days between the current time and the starting time.
  elapsed_sec = (pbGetTimeNow - UnrealTime.initial_date).to_i
  return elapsed_sec
end

  def pbCalendarLogic
	puts "#{get_elapsed_days} a"
	seconds = get_elapsed_days
	secdays = (seconds.to_f / (60 * 60 * 24)).to_i
	puts "#{secdays} b"
	puts @wdays2[UnrealTime.initial_date.wday-1]
    for i in 0...pbGetDaysinMonth(@month)
      offset_x=30+64*((0*4+i)%7)
	  if i==0
	  puts offset_x
	  end
      offset_y=64*(i/7)#((@month*4+@days+i)/7)
	  if i+3 >= pbGetTimeNow.day && @potato < 7
	     @wdays << offset_x
		 @potato+=1
	  end
      @overlay.bitmap.draw_text(offset_x,offset_y,30,30,(i+1).to_s,2)
    end
	save1=0
    @wdays.each_with_index do |w, ind|
     @overlay2.bitmap.draw_text(w-9,25,30,30,@wdays2[ind].to_s,2)
	 if ind == 3
		save1=w-20
	 end
	end
     @overlay3.bitmap.draw_text(save1,3,60,60,pbGetMonthName(@month).to_s,4)



  end



  def pbControls
    @volume = 0

    loop do
=begin
      if Input.trigger?(Input::USE)
	  end
      if Input.trigger?(Input::UP)
	  end
      if Input.trigger?(Input::DOWN)
      end
      if Input.trigger?(Input::RIGHT)
      @overlay.bitmap.clear
      @overlay2.bitmap.clear
      @overlay3.bitmap.clear
	  if @month+1 == 13
	  @month=1
	  else
	  @month+=1
	  end
	  pbCalendarLogic
      end
      if Input.trigger?(Input::LEFT)
      @overlay.bitmap.clear
      @overlay2.bitmap.clear
      @overlay3.bitmap.clear
	  if @month-1 == 0
      @month=12
	  else
	  @month-=1
	  end
	  pbCalendarLogic
      end
=end
      if Input.trigger?(Input::BACK)
        break
      end
      Graphics.update
      Input.update
      pbUpdate
    end
  end


  def pbEndScene
    @calendar.dispose
    @overlay.bitmap.clear
    @overlay2.bitmap.clear
    @overlay3.bitmap.clear
  end

  
end

def pbCalendar
      scene = CalendarScene.new
      screen = CalendarScreen.new(scene)
      screen.pbStartScreen
end

class CalendarScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbControls
    @scene.pbEndScene
  end
end
