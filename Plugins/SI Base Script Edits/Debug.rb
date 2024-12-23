MenuHandlers.add(:debug_menu, :time_menu, {
  "name"        => _INTL("Time Options..."),
  "parent"      => :field_menu,
  "description" => _INTL("Set time..."),
  "always_show" => false
})
MenuHandlers.add(:debug_menu, :set_time_p, {
  "name"        => _INTL("Set Time - Presets"),
  "parent"      => :time_menu,
  "description" => _INTL("Set time to a preset time."),
  "effect"      => proc {
      params = ChooseNumberParams.new
      params.setRange(1, 999999)
      params.setInitialValue(0)
      params.setCancelValue(0)
      level = pbMessageChooseNumber(_INTL("Set time."), params)
      if level == 1
	   setNewTimeWithinDay(5)
	  elsif level == 2
	   setNewTimeWithinDay(14)
	  elsif level == 3
	   setNewTimeWithinDay(17)
	  elsif level == 4
	   setNewTimeWithinDay(20)
	  elsif level == 5
	   setNewTimeWithinDay(0,0,0)
	  elsif Input.trigger?(Input::BACK)
	  else
	  end
  }
})

MenuHandlers.add(:debug_menu, :set_time, {
  "name"        => _INTL("Set Time"),
  "parent"      => :time_menu,
  "description" => _INTL("Set time to a specific numerical time."),
  "effect"      => proc {
      params = ChooseNumberParams.new
      params.setRange(1, 999999)
	  time = "{#pbGetTimeNow.hour}{#pbGetTimeNow.min}{#pbGetTimeNow.sec}".to_i
      params.setInitialValue(time)
      params.setCancelValue(0)
      level = pbMessageChooseNumber(_INTL("Set time HH:MM:SS."), params)
      if level > 0
	     nulevel = level.to_s
		  case nulevel.length
		    when 0
			nulevel = "000000"
			when 1
			nulevel = "00000#{nulevel}"
			when 2
			nulevel = "0000#{nulevel}"
			when 3
			nulevel = "000#{nulevel}"
			when 4
			nulevel = "00#{nulevel}"
			when 5
			nulevel = "0#{nulevel}"
			else
		  end
	     chunks = nulevel.scan(/../)
        setNewTimeWithinDay(chunks[0].to_i,chunks[1].to_i,chunks[2].to_i)
      end
 
  }
})

MenuHandlers.add(:debug_menu, :set_time_day, {
  "name"        => _INTL("Set Day"),
  "parent"      => :time_menu,
  "description" => _INTL("Increase or Decrease Day."),
  "effect"      => proc {
      params = ChooseNumberParams.new
      params.setRange(1, 99)
      params.setInitialValue(pbGetTimeNow.day)
      params.setCancelValue(0)
      level = pbMessageChooseNumber(_INTL("Set day."), params)
      if level > 0
        setDay(level)
      end
 
  }
})

