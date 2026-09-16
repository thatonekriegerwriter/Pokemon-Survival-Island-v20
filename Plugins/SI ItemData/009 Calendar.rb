class Player < Trainer
  attr_accessor :calendar_month
  attr_accessor :calendar_marked
  attr_accessor :calendar_noted_days

     alias _SI3_Player_Init initialize
  def initialize(name, trainer_type)
    _SI3_Player_Init(name, trainer_type)
    @calendar_noted_days  = []
    @calendar_marked  = []
    @calendar_month  = pbGetTimeNow.month
  end
  
  def calendar_marked
    @calendar_marked  = [] if @calendar_marked.nil?
	return @calendar_marked
  end
  def calendar_month
    @calendar_month  = pbGetTimeNow.month if @calendar_month.nil?
	return @calendar_month
  end

end

def pbIsLeapYear?(y)
  return (y % 4 == 0) && !(y % 100 == 0) || (y % 400 == 0)
end

def pbGetTotalDays(t,y)
  return 29 if t == 2 && pbIsLeapYear?(y)
  return [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][t - 1]
end

def pbFirstDayOfMonth(t)
  wday = t.wday
  (t.day - 1).times do
    wday -= 1
    wday = 6 if wday < 0
  end
  return wday
end
def pbGetthisSeason(time)
  return 0 if (time.mon==3 && time.day>=22) || time.mon == 4 || time.mon == 5 ||(time.mon == 6 && time.day <20)#spring
  return 1 if (time.mon==6 && time.day>=21) || time.mon == 7 || time.mon == 8 || (time.mon == 9 && time.day <20) #SUMMER
  return 2 if (time.mon==9 && time.day>=21) || (time.mon == 10 && time.day <21)  #Fall
  return 3#winter 
end
class Scene_Calendar


  
  def pbStartScene
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @time = pbGetTimeNow
	@curmonth = pbGetTimeNow.month
	@background = {}
    @background["bg"] = AnimatedPlane.new(@viewport)
    if @time.month != $player.calendar_month
      $player.calendar_month = @time.month
    end
    @header = Window_UnformattedTextPokemon.new("")
    @header.viewport = @viewport
    @header.x = (Graphics.width/2) - 60
    @header.y = 4
    @header.width=200
    @header.height=64
	@header.windowskin  = nil
    display_month_day(@time)
  end
  
  
  def display_month_day(time)
	month = time.month
	year = time.year
    if month == pbGetTimeNow.month && year == pbGetTimeNow.year
    time = pbGetTimeNow
	month = time.month
	year = time.year
    end
	dayamt = pbGetTotalDays(month,year)
    season = pbGetthisSeason(time)
	seasontext = [_INTL("Spring"),_INTL("Summer"),_INTL("Autumn"),_INTL("Winter")][season]
    bitmapName = pbResolveBitmap("Graphics/Pictures/Calendar/#{seasontext}")
	@background["bg"].setBitmap(bitmapName)
	case season
	when 0
    @header.baseColor=Color.new(16, 24, 32)
    @header.shadowColor=Color.new(168, 184, 184)
	when 1
    @header.baseColor=Color.new(232, 232, 232)
    @header.shadowColor=Color.new(136, 136, 136)
	when 2
    @header.baseColor=Color.new(232, 232, 232)
    @header.shadowColor=Color.new(136, 136, 136)
	when 3
    @header.baseColor=Color.new(16, 24, 32)
    @header.shadowColor=Color.new(168, 184, 184)
	end
	
    start = pbFirstDayOfMonth(time)
	
	monthname = pbGetMonthName(month)
	name = "#{monthname} #{year}"
	@header.text=name
    @days = []
    for i in start...(dayamt + start)
      idx = i - start
      @days[idx] = []
      @days[idx][0] = Sprite.new(@viewport)
      w = 12
      @days[idx][0].bmp("Graphics/Pictures/Poketch/Calendar/numbers")
      @days[idx][0].src_rect.width = w
      @days[idx][0].src_rect.x = w * ((i + 1 - start).to_s.split("")[0].to_i)
      @days[idx][0].x = 40 + (64 * ((i+7) % 7))
	  #@days[idx][0].x += 14 if (i + 1 - start).to_s.size == 1
      @days[idx][0].y = 54 + (64 * (i / 7).floor)
      @days[idx][0].z = 4
      if (i + 1 - start).to_s.size > 1 #If the length is greater than 2.
        #@days[idx][0].x -= 11
        @days[idx][0].x -= 4 if i % 7 == 0
        @days[idx][1] = Sprite.new(@viewport)
        @days[idx][1].bmp("Graphics/Pictures/Poketch/Calendar/numbers")
        @days[idx][1].src_rect.width = w
        @days[idx][1].src_rect.x = w * ((i + 1 - start).to_s.split("")[1].to_i)
        @days[idx][1].x = 54 + (64 * (i % 7))
        @days[idx][1].y = 54 + (64 * (i / 7).floor)
        @days[idx][1].x -= 4 if i % 7 == 0
        @days[idx][1].z = 4
      end
      @days[idx][2] = Sprite.new(@viewport)
      if $player.calendar_marked.include?([@time.year,@time.month,(i + 1 - start)])
        @days[idx][2].bmp("Graphics/Pictures/Poketch/Calendar/marked")
        @days[idx][2].z = 3
      else
        @days[idx][2].bmp(32,32)
        @days[idx][2].z = 2
      end
	  if idx==0||idx==1||idx==2||idx==3||idx==4||idx==5||idx==6||idx==7||idx==8
         @days[idx][2].x = @days[idx][0].x
	  else
         @days[idx][2].x = (@days[idx][1] || @days[idx][0]).x - ((@days[idx][1] || @days[idx][0]).x == 48 ? 14 : 16)
	  end
       @days[idx][2].y = @days[idx][0].y - 2
	  
	  
        @days[idx][3] = Sprite.new(@viewport)
        @days[idx][3].bmp("Graphics/Pictures/Poketch/Calendar/selector")
	    if idx==1||idx==2||idx==3||idx==4||idx==5||idx==6||idx==7||idx==8
        @days[idx][3].x = @days[idx][0].x-4
	    else
        @days[idx][3].x = (@days[idx][1] || @days[idx][0]).x - (w == 16 ? 18 : 20)
	    end
        @days[idx][3].y = @days[idx][0].y - 6
        @days[idx][3].z = 2
		 @days[idx][3].visible = false
		 @days[idx][3].visible = true if time.day == (i + 1 - start) && month == pbGetTimeNow.month && year == pbGetTimeNow.year
	  
      @days[idx][4] = i + 1 - start
    end
  
  
  
  end
  
  
  def toggle_marker(day)
    @days[day][2] = Sprite.new(@viewport) if !@days[day][2]
    if @days[day][2].z == 2
      @days[day][2].bmp("Graphics/Pictures/Poketch/Calendar/marked")
      @days[day][2].z = 3
    else
      @days[day][2].bmp(32,32)
      @days[day][2].z = 2
    end
	if day==0||day==1||day==2||day==3||day==4||day==5||day==6||day==7||day==8
    @days[day][2].x = @days[day][0].x
	else
    @days[day][2].x = (@days[day][1] || @days[day][0]).x - ((@days[day][1] || @days[day][0]).x == 48 ? 14 : 16)
	end
    @days[day][2].y = @days[day][0].y - 2
  end
  
  def pbTrainerCard
    pbSEPlay("GUI trainer card open")
    loop do
      Graphics.update
      Input.update
	if Input.trigger?(Input::USE)
    for i in 0...@days.size
	 if !@days[i][2].nil?
	 if Input.mouse_y.between?(@days[i][2].y,@days[i][2].y+@days[i][2].height) && Input.mouse_x.between?(@days[i][2].x,@days[i][2].x+@days[i][2].width)
      toggle_marker(i) 
	  if $player.calendar_marked.include?([@time.year,@time.month,@days[i][4]])
      $player.calendar_marked.delete([@time.year,@time.month,@days[i][4]])
	  else
      $player.calendar_marked << [@time.year,@time.month,@days[i][4]] if @days[i][2].z == 3
	  end
	 end
	 end
	end
	elsif Input.trigger?(Input::LEFT)
	  @time = pbGetThisTime(@time,"not")
	  pbClear
	  display_month_day(@time)
	elsif Input.trigger?(Input::RIGHT)
	  @time = pbGetThisTime(@time)
	  pbClear
	  display_month_day(@time)
	elsif Input.trigger?(Input::UP)
	  @time = pbGetNextYear(@time,"not")
	  pbClear
	  display_month_day(@time)
	elsif Input.trigger?(Input::DOWN)
	  @time = pbGetNextYear(@time)
	  pbClear
	  display_month_day(@time)
	elsif Input.trigger?(Input::BACK)
	 break
    end

	end
   end
  
  def pbEndScene
    for day in @days
      day[0].dispose if day[0]
      day[1].dispose if day[1]
      day[2].dispose if day[2]
      day[3].dispose if day[3]
    end
    @header.dispose
    @background["bg"].dispose
    @viewport.dispose
end

  def pbClear
    for day in @days
      day[0].dispose if day[0]
      day[1].dispose if day[1]
      day[2].dispose if day[2]
      day[3].dispose if day[3]
    end
end



  end



class CalendarScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbTrainerCard
    @scene.pbEndScene
  end
end


def pbDayChecker(month,day,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month && d == day #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
 end

def pbIndigoPlateauDays(month1,day1,day2,day3,day4,day5,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month1 && d == day1 || m == month1 && d == day2 || m == month1 && d == day3 || m == month1 && d == day4 || m == month1 && d == day5  #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
end

def pbIndigoPlateauDays2(month1,day1,month2,day2,month3,day3,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month1 && d == day1 || m == month2 && d == day2 || m == month3 && d == day3  #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
end




	
def pbNextChampionShip
    $game_variables[421]=rand(40)
end



def openCalendar
pbFadeOutIn {
scene = Scene_Calendar.new
screen = CalendarScreen.new(scene)
screen.pbStartScreen
}


end