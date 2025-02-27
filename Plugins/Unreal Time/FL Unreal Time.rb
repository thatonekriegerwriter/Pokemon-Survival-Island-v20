#===============================================================================
# * Unreal Time System - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It makes the time in game uses its
# own clock that only pass when you are in game instead of using real time
# (like Minecraft and Zelda: Ocarina of Time).
#
#== INSTALLATION ===============================================================
#
# To this script works, put it above main OR convert into a plugin.
#
#== HOW TO USE =================================================================
#
# This script automatic works after installed. 
#pbGetThisTime
# If you wish to add/reduce time, there are 3 ways:
#
# 1. EXTRA_SECONDS/EXTRA_DAYS are variables numbers that hold time passage;
# The time in these variable isn't affected by PROPORTION.
# Example: When the player sleeps you wish to the time in game advance
# 8 hours, so put in EXTRA_SECONDS a game variable number and sum 
# 28800 (60*60*8) in this variable every time that the players sleeps.
#
# 2. 'UnrealTime.add_seconds(seconds)' and 'UnrealTime.add_days(days)' does the
# same thing, in fact, EXTRA_SECONDS/EXTRA_DAYS call these methods.
#
# 3. 'UnrealTime.advance_to(16,17,18)' advance the time to a fixed time of day, 
# 16:17:18 on this example.
#
#== NOTES ======================================================================
#
# If you wish to some parts still use real time like the Trainer Card start time
# and Pokémon Trainer Memo, just change 'pbGetTimeNow' to 'Time.now' in their
# scripts.
#
# This script uses the Ruby Time class. Before Essentials version 19 (who came
# with 64-bit ruby) it can only have 1901-2038 range.
# 
# Some time methods:
# 'pbGetTimeNow.year', 'pbGetTimeNow.mon' (the numbers from 1-12), 
# 'pbGetTimeNow.day','pbGetTimeNow.hour', 'pbGetTimeNow.min', 
# 'pbGetTimeNow.sec', 'pbGetAbbrevMonthName(pbGetTimeNow.mon)',
# 'pbGetTimeNow.strftime("%A")' (displays weekday name),
# 'pbGetTimeNow.strftime("%I:%M %p")' (displays Hours:Minutes pm/am)
# 
#===============================================================================
if defined?(PluginManager) && !PluginManager.installed?("Unreal Time System")
  PluginManager.register({                                                 
    :name    => "Unreal Time System",                                        
    :version => "1.1.1",                                                     
    :link    => "https://www.pokecommunity.com/showthread.php?t=285831",             
    :credits => "FL"
  })
end

module UnrealTime
  # Set false to disable this system (returns Time.now)
  ENABLED=true

  # Time proportion here. 
  # So if it is 100, one second in real time will be 100 seconds in game.
  # If it is 60, one second in real time will be one minute in game.
  #PROPORTION=900
  PROPORTION=30

  # Starting on Essentials v17, the map tone only try to refresh tone each 30 
  # real time seconds. 
  # If this variable number isn't -1, the game use this number instead of 30.
  # When time is changed with advance_to or add_seconds, the tone refreshes.
  TONE_CHECK_INTERVAL = 10.0

  # Make this true to time only pass at field (Scene_Map) 
  # A note to scripters: To make time pass on other scenes, put line
  # '$PokemonGlobal.addNewFrameCount' near to line 'Graphics.update'
  TIME_STOPS=true 

  # Make this true to time pass in battle, during turns and command selection.
  # This won't affect the Pokémon and Bag submenus.
  # Only works if TIME_STOPS=true.
  BATTLE_PASS=true

  # Make this true to time pass when the Dialog box or the main menu are open.
  # This won't affect the submenus like Pokémon and Bag.
  # Only works if TIME_STOPS=true.
  TALK_PASS=true

  # Choose switch number that when true the time won't pass (or -1 to cancel). 
  # Only works if TIME_STOPS=true.
  SWITCH_STOPS=51

  # Choose variable(s) number(s) that can hold time passage (or -1 to cancel).
  # Look at description for more details.
  EXTRA_SECONDS=29
  EXTRA_DAYS=-1

  # Initial date. In sequence: Year, month, day, hour and minutes.
  # Method UnrealTime.reset resets time back to this time.
  def self.initial_date
    return Time.local(2011,6,9, 7,0)
  end

  # Advance to next time. If time already passed, advance 
  # into the time on the next day.
  # Hour is 0..23
  def self.advance_to(hour,min=0,sec=0) 
    if hour < 0 || hour > 23
      raise RangeError, "hour is #{hour}, should be 0..23"
    end
    day_seconds = 60*60*24
    seconds_now = pbGetTimeNow.hour*60*60+pbGetTimeNow.min*60+pbGetTimeNow.sec
    target_seconds = hour*60*60+min*60+sec
    seconds_added = target_seconds-seconds_now
    seconds_added += day_seconds if seconds_added<0
    $PokemonGlobal.newFrameCount+=seconds_added
    PBDayNight.sheduleToneRefresh
  end

  # Resets time to initial_date.
  def self.reset
    raise "Method doesn't work when TIME_STOPS is false!" if !TIME_STOPS
    $game_variables[EXTRA_SECONDS]=0 if EXTRA_DAYS>0
    $game_variables[EXTRA_DAYS]=0 if EXTRA_DAYS>0
    $PokemonGlobal.newFrameCount=0
    $PokemonGlobal.extraYears=0
    PBDayNight.sheduleToneRefresh
  end

  # Does the same thing as EXTRA_SECONDS variable.
  def self.add_seconds(seconds)
    raise "Method doesn't work when TIME_STOPS is false!" if !TIME_STOPS
    $PokemonGlobal.newFrameCount+=seconds/PROPORTION.to_f
    PBDayNight.sheduleToneRefresh
  end

  def self.add_days(days)
    add_seconds(60*60*24*days)
  end

  NEED_32_BIT_FIX = [''].pack('p').size <= 4
end

# Essentials V18 and lower compatibility
module Settings
  TIME_SHADING = defined?(ENABLESHADING) ? ENABLESHADING : ::TIME_SHADING 
end if defined?(TIME_SHADING) || defined?(ENABLESHADING)

module PBDayNight
  class << self
    if method_defined?(:getTone) && UnrealTime::TONE_CHECK_INTERVAL > 0
      def getTone
        @cachedTone = Tone.new(0,0,0) if !@cachedTone
        return @cachedTone if !Settings::TIME_SHADING
        toneNeedUpdate = (!@dayNightToneLastUpdate || 
          Graphics.frame_count-@dayNightToneLastUpdate >=
          Graphics.frame_rate*UnrealTime::TONE_CHECK_INTERVAL
        )
        if toneNeedUpdate
          getToneInternal
          @dayNightToneLastUpdate = Graphics.frame_count
        end
        return @cachedTone
      end
    end

    # Shedule a tone refresh on the next try (probably next frame)
    def sheduleToneRefresh
      @dayNightToneLastUpdate = nil
    end
  end
end

def pbGetTimeNow
  return Time.now if !$PokemonGlobal || !UnrealTime::ENABLED
  day_seconds = 60*60*24
  if UnrealTime::TIME_STOPS
    # Sum the extra values to newFrameCount
    if UnrealTime::EXTRA_SECONDS>0
      UnrealTime.add_seconds(pbGet(UnrealTime::EXTRA_SECONDS))
      $game_variables[UnrealTime::EXTRA_SECONDS]=0
    end  
    if UnrealTime::EXTRA_DAYS>0
      UnrealTime.add_seconds(day_seconds*pbGet(UnrealTime::EXTRA_DAYS))
      $game_variables[UnrealTime::EXTRA_DAYS]=0
    end
  elsif UnrealTime::EXTRA_SECONDS>0 && UnrealTime::EXTRA_DAYS>0
    # Checks to regulate the max/min values at UnrealTime::EXTRA_SECONDS
    while pbGet(UnrealTime::EXTRA_SECONDS)>=day_seconds
      $game_variables[UnrealTime::EXTRA_SECONDS]-=day_seconds
      $game_variables[UnrealTime::EXTRA_DAYS]+=1
    end
    while pbGet(UnrealTime::EXTRA_SECONDS)<=-day_seconds
      $game_variables[UnrealTime::EXTRA_SECONDS]+=day_seconds
      $game_variables[UnrealTime::EXTRA_DAYS]-=1
    end  
  end  
  start_time=UnrealTime.initial_date
  if UnrealTime::TIME_STOPS
    time_played=$PokemonGlobal.newFrameCount
  end
  time_played=(time_played*UnrealTime::PROPORTION)
  time_jumped=0
  if UnrealTime::EXTRA_SECONDS>-1 
    time_jumped+=pbGet(UnrealTime::EXTRA_SECONDS)
  end
  if UnrealTime::EXTRA_DAYS>-1 
    time_jumped+=pbGet(UnrealTime::EXTRA_DAYS)*day_seconds
  end
  time_ret = 0
  # Before Essentials V19, there is a year limit. To prevent crashes due to this
  # limit, every time that you reach in year 2036 the system will subtract 6
  # years (to works with leap year) from your date and sum in 
  # $PokemonGlobal.extraYears. You can sum your actual year with this extraYears
  # when displaying years.
  loop do
    time_fix=0
    if $PokemonGlobal.extraYears!=0
      time_fix = $PokemonGlobal.extraYears*day_seconds*(365*6+1)/6
    end
    time_ret=start_time+(time_played+time_jumped-time_fix)
    break if !UnrealTime::NEED_32_BIT_FIX || time_ret.year<2036
    $PokemonGlobal.extraYears+=6
  end
  return time_ret
end


def pbGetThisTime(time,type="add")
  day_seconds = 60*60*24
  curTime = time
  monthamt = 1
  start_time=UnrealTime.initial_date
  if type == "add"
    if curTime.month+monthamt==13
	themonth = 0
	else
	themonth = curTime.month
	end
    dayamt=pbGetTotalDays(themonth+monthamt,curTime.year)
    modifytime = monthamt*dayamt*day_seconds
    time_ret=curTime+modifytime
  else
    if curTime.month-monthamt==0
	themonth = 13
	else
	themonth = curTime.month
	end
    dayamt=pbGetTotalDays(curTime.month-monthamt,curTime.year)
    modifytime = monthamt*dayamt*day_seconds
	if (curTime-modifytime).sec > 0
    time_ret=curTime-modifytime
	else
    time_ret=start_time
	end
  end

  return time_ret
end

def pbGetNextYear(time,type="add")
  day_seconds = 60*60*24
  curTime = time
  start_time=UnrealTime.initial_date
  monthamt = 12
	themonth = curTime.month
  dayamt=pbGetTotalDays(themonth,curTime.year)
  modifytime = monthamt*dayamt*day_seconds
if type == "add"
  time_ret=curTime+modifytime
else
  time_ret=curTime-modifytime
end
  return time_ret
end





if UnrealTime::ENABLED
  class PokemonGlobalMetadata
    attr_accessor :newFrameCount # Became float when using extra values
    attr_accessor :extraYears 
    
    def addNewFrameCount
      return if (UnrealTime::SWITCH_STOPS>0 && $game_switches[UnrealTime::SWITCH_STOPS])		
	    if $game_temp.just_update_anyways==false
	   return if $game_temp.in_menu==true && !($DEBUG && Input.press?(Input::CTRL))
	   return if $game_temp.message_window_showing==true && $PokemonGlobal.alternate_control_mode==false
	     end
        deposited = pbDayCareDeposited
       if deposited==2 && day_care.egg_generated==0 && rand(10)==0
        day_care.step_counter = 0 if !day_care.egg_generated
        day_care.step_counter += Graphics.delta
	   end
      self.newFrameCount+=Graphics.delta
    end
    
    def newFrameCount
      @newFrameCount=0 if !@newFrameCount
      return @newFrameCount
    end
    
    def extraYears
      @extraYears=0 if !@extraYears
      return @extraYears
    end
  end  

  if UnrealTime::TIME_STOPS  
    class Scene_Map
    

  
    if UnrealTime::BATTLE_PASS
      class Battle::Scene
        alias :pbGraphicsUpdateold :pbGraphicsUpdate
        def pbGraphicsUpdate
          $PokemonGlobal.addNewFrameCount 
          pbGraphicsUpdateold
        end
      end
    end
  end
  end
end




def pbProgressTime(hours)
  UnrealTime.add_seconds(hours*3600)
end

def pbSetTime(minutes=pbGetTimeNow.min,hours=pbGetTimeNow.hour,days=pbGetTimeNow.day,months=pbGetTimeNow.month,years=pbGetTimeNow.year)
  timeNow = pbGetTimeNow.to_i
  timeThen = (Time.new(years, months, days, hours, minutes)).to_i
  timeCouldHaveBeen = timeThen - timeNow
  UnrealTime.add_seconds(timeCouldHaveBeen)
end

def pbSetMinute(min)
  pbSetTime(min)
end

def pbSetHour(hour)
  pbSetTime(pbGetTimeNow.min,hour)
end


def pbSetDay(day)
  pbSetTime(pbGetTimeNow.min,pbGetTimeNow.hour,day)
end

def pbSetMonth(mon)
  pbSetTime(pbGetTimeNow.min,pbGetTimeNow.hour,pbGetTimeNow.day,mon)
end

def pbSetYear(year)
  pbSetTime(pbGetTimeNow.min,pbGetTimeNow.hour,pbGetTimeNow.day,pbGetTimeNow.month,year)
end






def setNewTime(hour,min=0,sec=0) # Hour is 0..23
  timeNow = pbGetTimeNow
  secInDay = 60*60*24
  secNow = pbGetTimeNow.hour*60*60+pbGetTimeNow.min*60+pbGetTimeNow.sec
  secWished = hour*60*60+min*60+sec
  secondsAdded = secWished-secNow
  secondsAdded +=secInDay if secondsAdded<0
  $game_variables[UnrealTime::EXTRA_SECONDS]+=secondsAdded
end

def setDay(day) # Hour is 0..23
  timeNow = pbGetTimeNow
  curDay = timeNow.day
  wishedday = curDay-day
  secInDay = 60*60*24
  secWished = wishedday*secInDay
  secNow = pbGetTimeNow.hour*60*60+pbGetTimeNow.min*60+pbGetTimeNow.sec
  secWished = hour*60*60+min*60+sec
  secondsAdded = secWished-secNow
  secondsAdded +=secInDay if secondsAdded<0
  $game_variables[UnrealTime::EXTRA_SECONDS]+=secondsAdded
end

def setNewTimeWithinDay(hour,min=0,sec=0) # Hour is 0..23
  timeNow = pbGetTimeNow
  secInDay = 60*60*24
  secNow = pbGetTimeNow.hour*60*60+pbGetTimeNow.min*60+pbGetTimeNow.sec
  secWished = hour*60*60+min*60+sec
  secondsAdded = secWished-secNow
  $game_variables[UnrealTime::EXTRA_SECONDS]+=secondsAdded
end