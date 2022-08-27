### EDIT ###

Events.onSpritesetCreate += proc { |_sender,e|
  spriteset = e[0]
  viewport  = e[1]
  map = spriteset.map
  for i in map.events.keys
    if map.events[i].name[/berryplant/i]
      spriteset.addUserSprite(BerryPlantMoistureSprite.new(map.events[i],map,viewport))
      spriteset.addUserSprite(BerryPlantSprite.new(map.events[i],map,viewport))
    end
  end
}



class BerryPlantMoistureSprite
  def initialize(event,map,viewport=nil)
    @event=event
    @map=map
    @light = IconSprite.new(0,0,viewport)
    @light.ox=16
    @light.oy=24
    @oldmoisture=-1   # -1=none, 0=dry, 1=damp, 2=wet
    updateGraphic
    @disposed=false
  end

  def disposed?
    return @disposed
  end

  def dispose
    @light.dispose
    @map=nil
    @event=nil
    @disposed=true
  end

  def updateGraphic
    case @oldmoisture
    when -1 then @light.setBitmap("")
    when 0  then @light.setBitmap("Graphics/Characters/berrytreeDry")
    when 1  then @light.setBitmap("Graphics/Characters/berrytreeDamp")
    when 2  then @light.setBitmap("Graphics/Characters/berrytreeWet")
    end
  end

  def update
    return if !@light || !@event
    newmoisture=-1
    if @event.variable && @event.variable.length>6 && @event.variable[1]
      # Berry was planted, show moisture patch
      newmoisture=(@event.variable[4]>50) ? 2 : (@event.variable[4]>0) ? 1 : 0
    end
    if @oldmoisture!=newmoisture
      @oldmoisture=newmoisture
      updateGraphic
    end
    @light.update
    if (Object.const_defined?(:ScreenPosHelper) rescue false)
      @light.x = ScreenPosHelper.pbScreenX(@event)
      @light.y = ScreenPosHelper.pbScreenY(@event)
      @light.zoom_x = ScreenPosHelper.pbScreenZoomX(@event)
    else
      @light.x = @event.screen_x
      @light.y = @event.screen_y
      @light.zoom_x = 1.0
    end
    @light.zoom_y = @light.zoom_x
    pbDayNightTint(@light)
  end
end



class BerryPlantSprite
  def initialize(event,map,_viewport)
    @event=event
    @map=map
    @oldstage=0
    @disposed=false
    berryData=event.variable
    return if !berryData
    @oldstage=berryData[0]
    @event.character_name=""
    berryData=updatePlantDetails(berryData)
    setGraphic(berryData,true)      # Set the event's graphic
    @event.setVariable(berryData)   # Set new berry data
  end

  def dispose
    @event=nil
    @map=nil
    @disposed=true
  end

  def disposed?
    @disposed
  end

  def update                      # Constantly updates, used only to immediately
    berryData=@event.variable     # change sprite when planting/picking berries
    if berryData
      berryData=updatePlantDetails(berryData) if berryData.length>6
      setGraphic(berryData)
      @event.setVariable(berryData)
    end
  end

  def updatePlantDetails(berryData)
  
    return berryData if berryData[0]==0
    map = 0
    berryvalues = GameData::BerryPlant.get(berryData[1])
    timeperstage = berryvalues.hours_per_stage * 3600
    crossbreedchance = berryvalues.crossbreeding
	  berryclimate = berryvalues.climate
	  berrycropsticks = berryvalues.cropsticks
	  berryresistance = berryvalues.resistance
	  berrymutativity = berryvalues.mutativity
	  berryweedchance = berryvalues.weedchance
	  berryweeded = berryvalues.weeded
	  berryspeciesallele = berryvalues.speciesallele
	  berrygrowthallele = berryvalues.growthallele
	  berrydryallele = berryvalues.dryallele
	  berryminyieldallele = berryvalues.minyieldallele
	  berrymaxyieldallele = berryvalues.maxyieldallele
    timenow=pbGetTimeNow
      # Check time elapsed since last check
      timeDiff=(timenow.to_i-berryData[3])   # in seconds
      return berryData if timeDiff<=0
      berryData[3]=timenow.to_i   # last updated now
      # Mulch modifiers
      minyield = berryvalues.minimum_yield
      maxyield = berryvalues.maximum_yield
      dryingrate = berryvalues.drying_per_hour
      maxreplants = GameData::BerryPlant::NUMBER_OF_REPLANTS
      ripestages = 4
	  
	  
	  
	  
	  if berryData[1] #This is designed to facilitate crossbreeding. If two Berries have the same 
       map = $game_map
       for i in map.events.keys
         if berryvalues.cropsticks == 1
           if map.events[i].name[/berryplant/i]
		    if map.events[i].variable && map.events[i].variable.length>6 && map.events[i].variable[1]
		     return if map.events[i].variable[1]==0
			 if rand(100)<=crossbreedchance && GameData::BerryPlant.get(map.events[i].variable[1]).speciesallele > berryspeciesallele
			  berryData[1] = map.events[i].variable[1]
			 elsif rand(100)==berrymutativity
			  berryData[1] = map.events[i].variable[1]
			 end
		   end
        end
       end
	  end
	  
	  if berryData[1]
	  if berryvalues.cropsticks == 1
	  weeded= berryweedchance-berryresistance
	  berryweeded = 1 if rand(100)==weeded
	  end
  end
  
	  if berryData[1]
	   map = $game_map
       for i in map.events.keys
         if berryvalues.cropsticks == 1
           if map.events[i].name[/berryplant/i]
		    if map.events[i].variable && map.events[i].variable.length>6 && map.events[i].variable[1]
			 if rand(100)==berrymutativity
			     timeperstage = (timeperstage * 1.75).to_i if rand(100)<=berrymutativity
			     timeperstage = (timeperstage * 1.5).to_i if rand(100)<=berrymutativity
			     timeperstage = (timeperstage * 1.25).to_i if rand(100)<=berrymutativity
			     timeperstage = (timeperstage * 0.75).to_i if rand(100)<=berrymutativity
			     timeperstage = (timeperstage * 0.50).to_i if rand(100)<=berrymutativity
			     timeperstage = (timeperstage * 0.25).to_i if rand(100)<=berrymutativity
                 dryingrate = (dryingrate * 1.25).ceil  if rand(100)<=berrymutativity
                 dryingrate = (dryingrate * 1.5).ceil  if rand(100)<=berrymutativity
                 dryingrate = (dryingrate * 1.75).ceil  if rand(100)<=berrymutativity
                 dryingrate = (dryingrate * 0.25).floor  if rand(100)<=berrymutativity
                 dryingrate = (dryingrate * 0.5).floor  if rand(100)<=berrymutativity
                 dryingrate = (dryingrate * 0.75).floor  if rand(100)<=berrymutativity
				 maxreplants = (maxreplants * 1.25).ceil  if rand(100)<=berrymutativity
				 maxreplants = (maxreplants * 1.5).ceil  if rand(100)<=berrymutativity
				 maxreplants = (maxreplants * 1.75).ceil  if rand(100)<=berrymutativity
				 maxreplants = (maxreplants * 0.25).floor  if rand(100)<=berrymutativity
				 maxreplants = (maxreplants * 0.5).floor  if rand(100)<=berrymutativity
				 maxreplants = (maxreplants * 0.75).floor  if rand(100)<=berrymutativity
				 minyield=minyield-rand(4)   if rand(100)<=berrymutativity 
				 minyield=minyield+rand(4)   if rand(100)<=berrymutativity 
				 maxyield=maxyield-rand(4)  if rand(100)<=berrymutativity
				 maxyield=maxyield+rand(4)  if rand(100)<=berrymutativity
				 ripestages -= rand(3)  if rand(100)<=berrymutativity
				 ripestages += rand(3)  if rand(100)<=berrymutativity
				 berryresistance += rand(4)  if rand(100)<=berrymutativity
				 berrymutativity += rand(4)  if rand(100)<=berrymutativity
				 berryresistance -= rand(4)  if rand(100)<=berrymutativity
				 berrymutativity -= rand(4)  if rand(100)<=berrymutativity
				 berryclimate == rand(3)  if rand(200)<=berrymutativity
				 crossbreedchance -= rand(4)  if rand(100)<=berrymutativity
			 end
	        end
		   end
		 end
   end
   end
	  end
	  
      case berryData[7]
      when :GROWTHMULCH
        timeperstage = (timeperstage * 0.75).to_i
        dryingrate = (dryingrate * 1.5).ceil
      when :DAMPMULCH
        timeperstage = (timeperstage * 1.25).to_i
        dryingrate = (dryingrate * 0.5).floor
      when :GOOEYMULCH
        maxreplants = (maxreplants * 1.5).ceil
      when :STABLEMULCH
        ripestages = 6
      when :PRODUCEMULCH
        minyield=minyield+rand(4)
      when :POTENTIALMULCH
        maxyield=maxyield+rand(4)
      when :GROWTHMULCH2
        timeperstage = (timeperstage * 0.50).to_i
        dryingrate = (dryingrate * 1.5).ceil
      when :DAMPMULCH2
        timeperstage = (timeperstage * 1.50).to_i
        dryingrate = (dryingrate * 0.50).floor
      when :GOOEYMULCH2
        maxreplants = (maxreplants * 1.75).ceil
      when :STABLEMULCH2
        ripestages = 8
      when :PRODUCEMULCH2
        minyield=minyield+rand(6)
      when :POTENTIALMULCH2
        maxyield=maxyield+rand(6)
      end
      # Cycle through all replants since last check
      loop do
        secondsalive=berryData[2]
        growinglife=(berryData[5]>0) ? 3 : 4 # number of growing stages
        numlifestages=growinglife+ripestages # number of growing + ripe stages
        # Should replant itself?
        if secondsalive+timeDiff>=timeperstage*numlifestages
          # Should replant
          if berryData[5]>=maxreplants   # Too many replants
            return [0,0,0,0,0,0,0,0]
          end
          # Replant
          berryData[0]=2   # replants start in sprouting stage
          berryData[2]=0   # seconds alive
          berryData[5]+=1  # add to replant count
          berryData[6]=0   # yield penalty
          timeDiff-=(timeperstage*numlifestages-secondsalive)
        else
          break
        end
      end
      # Update current stage and dampness
      if berryData[0]>0
        # Advance growth stage
        oldlifetime=berryData[2]
        newlifetime=oldlifetime+timeDiff
        if berryData[0]<5
          berryData[0]=1+(newlifetime/timeperstage).floor
          berryData[0]+=1 if berryData[5]>0   # replants start at stage 2
          berryData[0]=5 if berryData[0]>5
        end
        # Update the "seconds alive" counter
        berryData[2]=newlifetime
        # Reduce dampness, apply yield penalty if dry
        map1= [147]
        map2= [148]
        map3= [149]
        map4= [150]
        map5= [151]
        map6= [152]
        map7= [153]
        map8= [154]
        map9= [155]
        growinglife=(berryData[5]>0) ? 3 : 4 # number of growing stages
        oldhourtick=(oldlifetime/3600).floor
        newhourtick=(([newlifetime,timeperstage*growinglife].min)/3600).floor
        (newhourtick-oldhourtick).times do
          if map1.include?($game_map.map_id) && !$game_variables[291]==0 && $game_switches[467]==true 
            berryData[4]=100
          elsif map2.include?($game_map.map_id) && !$game_variables[291]==0 && $game_switches[468]==true 
            berryData[4]=100
          elsif map3.include?($game_map.map_id) && !$game_variables[291]==0 && $game_switches[469]==true
            berryData[4]=100 
          elsif map4.include?($game_map.map_id) && !$game_variables[291]==0 && $game_switches[470]==true 
            berryData[4]=100
          elsif map5.include?($game_map.map_id) && !$game_variables[291]==0 && $game_switches[471]==true 
            berryData[4]=100
          elsif map6.include?($game_map.map_id) && !$game_variables[291]==0 && $game_switches[472]==true 
            berryData[4]=100
          elsif map7.include?($game_map.map_id) && !$game_variables[291]==0 && $game_switches[473]==true
            berryData[4]=100 
          elsif map8.include?($game_map.map_id) && !$game_variables[291]==0 && $game_switches[474]==true
            berryData[4]=100 
          elsif map9.include?($game_map.map_id) && !$game_variables[291]==0 && $game_switches[475]==true
            berryData[4]=100 
          elsif berryData[4]>75
            berryData[4]=[berryData[4]-dryingrate,0].max
          elsif berryData[4]>50
            berryData[4]=[berryData[4]-(dryingrate*1.25),0].max
          elsif berryData[4]>25
            berryData[4]=[berryData[4]-(dryingrate*1.5),0].max
          elsif berryData[4]>15
            berryData[4]=[berryData[4]-(dryingrate*1.75),0].max
          elsif berryData[4]>5
            berryData[4]=[berryData[4]-(dryingrate*2),0].max
          else
            berryData[6]+=1
          end
		  if berryweeded == 1 && rand(100) == 20
		    berryData[4]-=10 
            berryData[6]-=10
			crossbreedchance -= 10
			dryingrate = (dryingrate * 4).ceil
			ripestages = 0
		  end 
        end
      end
    return berryData
  end

  def setGraphic(berryData,fullcheck=false)
    return if !berryData || (@oldstage==berryData[0] && !fullcheck)
    case berryData[0]
    when 0
      @event.character_name=""
    when 1
      @event.character_name="berrytreeplanted"   # Common to all berries
      @event.turn_down
    else
      filename=sprintf("berrytree%s",GameData::Item.get(berryData[1]).id.to_s)
      if pbResolveBitmap("Graphics/Characters/"+filename)
        @event.character_name=filename
        case berryData[0]
        when 2 then @event.turn_down    # X sprouted
        when 3 then @event.turn_left    # X taller
        when 4 then @event.turn_right   # X flowering
        when 5 then @event.turn_up      # X berries
        end
      else
        @event.character_name="Object ball"
      end
      if @oldstage!=berryData[0] && berryData.length>6   # Gen 4 growth mechanisms
        $scene.spriteset.addUserAnimation(Settings::PLANT_SPARKLE_ANIMATION_ID,@event.x,@event.y,false,1) if $scene.spriteset
      end
    end
    @oldstage=berryData[0]
  end
end



def pbBerryPlant
  $DiscordRPC.details = "Farming"
  $DiscordRPC.update
  interp=pbMapInterpreter
  thisEvent=interp.get_character(0)
  berryData=interp.getVariable
  if !berryData
      berryData=[0,nil,0,0,0,0,0,0]
  end
  # Stop the event turning towards the player
  case berryData[0]   #Growth State
  when 1 then thisEvent.turn_down  # X planted
  when 2 then thisEvent.turn_down  # X sprouted
  when 3 then thisEvent.turn_left  # X taller
  when 4 then thisEvent.turn_right  # X flowering
  when 5 then thisEvent.turn_up  # X berries
  end
  watering = [:SPRAYDUCK, :SQUIRTBOTTLE, :WAILMERPAIL, :SPRINKLOTAD]
  berry=berryData[1]
  case berryData[0]
  when 0  # empty
      if !berryData[7] || berryData[7]==0 # No mulch used yet
        cmd=pbMessage(_INTL("It's soft soil, where you can plant a plant."),[
                            _INTL("Quick Plant"),
                            _INTL("Plant"),
                            _INTL("Fertilize"),
                            _INTL("Check Plant"),
                            _INTL("Place Cropsticks"),
                            _INTL("Exit")],-1)
        if cmd==2 # Fertilize
          ret=0
          pbFadeOutIn {
            scene = PokemonBag_Scene.new
            screen = PokemonBagScreen.new(scene,$PokemonBag)
            ret = screen.pbChooseItemScreen(Proc.new { |item| GameData::Item.get(item).is_mulch? })
          }
          if ret
            if GameData::Item.get(ret).is_mulch?
              berryData[7]=ret
              pbMessage(_INTL("The {1} was thrown onto the soil.\1",GameData::Item.get(ret).name))
              if pbConfirmMessage(_INTL("Do you want to plant a Berry?"))
                pbFadeOutIn {
                  scene = PokemonBag_Scene.new
                  screen = PokemonBagScreen.new(scene,$PokemonBag)
                  berry = screen.pbChooseItemScreen(Proc.new { |item| GameData::Item.get(item).is_berry? })
                }
                if berry
                  timenow=pbGetTimeNow
                  berryData[0]=1             # growth stage (1-5)
                  berryData[1]=berry         # item ID of planted berry
                  berryData[2]=0             # seconds alive
                  berryData[3]=timenow.to_i  # time of last checkup (now)
                  berryData[4]=100           # dampness value
                  berryData[5]=0             # number of replants
                  berryData[6]=0             # yield penalty
                  $PokemonBag.pbDeleteItem(berry,1)
                  pbMessage(_INTL("The {1} was planted in the soft, earthy soil.",
                     GameData::Item.get(berry).name))
                end
              end
              interp.setVariable(berryData)
            else
              pbMessage(_INTL("That won't fertilize the soil!"))
            end
            return
          end
        elsif cmd==1 # Plant Berry
          pbFadeOutIn {
            scene = PokemonBag_Scene.new
            screen = PokemonBagScreen.new(scene,$PokemonBag)
            berry = screen.pbChooseItemScreen(Proc.new { |item|  GameData::Item.get(item).is_berry? })
          }
          if berry
            timenow=pbGetTimeNow
            berryData[0]=1             # growth stage (1-5)
            berryData[1]=berry         # item ID of planted berry
            berryData[2]=0             # seconds alive
            berryData[3]=timenow.to_i  # time of last checkup (now)
            berryData[4]=100           # dampness value
            berryData[5]=0             # number of replants
            berryData[6]=0             # yield penalty
            $PokemonBag.pbDeleteItem(berry,1)
            pbMessage(_INTL("The {1} was planted in the soft, loamy soil.",
               GameData::Item.get(berry).name))
            interp.setVariable(berryData)
          end
          return
		  elsif cmd==3 # Check Plant
            pbMessage(_INTL("You look over your plant carefully."))
			if GameData::BerryPlant.get(berryData[1]).weeded==1
            pbMessage(_INTL("Your Plant has weeds they must be removed."))
            pbMessage(_INTL("You spend some time cleaning weeds off this plant."))
            GameData::BerryPlant.get(berryData[1]).weeded = 0
			else
            pbMessage(_INTL("Your plant is healthy!"))
			end
            pbMessage(_INTL("You won't be getting a lot of fruit from it.")) if maxyield >2
            pbMessage(_INTL("You will be getting a decent amount from it.")) if maxyield >4
            pbMessage(_INTL("You will be getting a lot from it!")) if maxyield >6
            pbMessage(_INTL("You are in for some loot!")) if maxyield >8
          return
		  elsif cmd==4 # Shovel Plant
		   if $PokemonBag.pbHasItem?(:CROPSTICKS)
         if $PokemonBag.pbQuantity(:CROPSTICKS)>=1
            pbMessage(_INTL("You set up cropsticks on  the Berry Plant."))
          pbFadeOutIn {
            scene = PokemonBag_Scene.new
            screen = PokemonBagScreen.new(scene,$PokemonBag)
            berry = screen.pbChooseItemScreen(Proc.new { |item|  GameData::Item.get(item).is_berry? })
          }
          if berry
            timenow=pbGetTimeNow
            berryData[0]=1             # growth stage (1-5)
            berryData[1]=berry         # item ID of planted berry
            berryData[2]=0             # seconds alive
            berryData[3]=timenow.to_i  # time of last checkup (now)
            berryData[4]=100           # dampness value
            berryData[5]=0             # number of replants
            berryData[6]=0             # yield penalty
            $PokemonBag.pbDeleteItem(berry,1)
            pbMessage(_INTL("The {1} was planted in the soft, loamy soil.",
               GameData::Item.get(berry).name))
            interp.setVariable(berryData)
          end
            cropsticks1 = GameData::BerryPlant.get(berryData[1]).cropsticks
            cropsticks1 = cropsticks1 + 1
          else
            pbMessage(_INTL("You don't have any cropsticks!"))
          end
		   else
            pbMessage(_INTL("You don't have any cropsticks!"))
          end
          return
      elsif cmd==0 # Quick Berry
        if GameData::Item.get($game_variables[4976]).is_berry?
         berry = $game_variables[4976]
         cmd2=pbMessage(_INTL("Redefine Quick Plant?."),[
                          _INTL("No"),
                          _INTL("Yes")])
          if cmd2==1
            pbFadeOutIn {
              scene = PokemonBag_Scene.new
             screen = PokemonBagScreen.new(scene,$PokemonBag)
             $game_variables[4976] = screen.pbChooseItemScreen(Proc.new { |item|  GameData::Item.get(item).is_berry? })
            }
            berry = $game_variables[4976]
          elsif cmd2==0 && $PokemonBag.pbQuantity($game_variables[4976])>=0
            berry = $game_variables[4976]
            timenow=pbGetTimeNow
            berryData[0]=1             # growth stage (1-5)
            berryData[1]=berry         # item ID of planted berry
            berryData[2]=0             # seconds alive
            berryData[3]=timenow.to_i  # time of last checkup (now)
            berryData[4]=100           # dampness value
            berryData[5]=0             # number of replants
            berryData[6]=0             # yield penalty
            if $PokemonBag.pbDeleteItem(berry,1)
            pbMessage(_INTL("The {1} was planted in the soft, loamy soil.",
               GameData::Item.get(berry).name))
            interp.setVariable(berryData)
			else
            pbMessage(_INTL("Could not delete.",
               GameData::Item.get(berry).name))
			end
          else
            pbMessage(_INTL("You have none of your Quick Berry."))
          end
        else
            berry = $game_variables[4976]
          if $game_variables[4976] == 0
          pbFadeOutIn {
            scene = PokemonBag_Scene.new
            screen = PokemonBagScreen.new(scene,$PokemonBag)
            $game_variables[4976] = screen.pbChooseItemScreen(Proc.new { |item|  GameData::Item.get(item).is_berry? })
          }
            berry = $game_variables[4976]
		  end
		end
        end
		return
      end
  when 1 # X planted
        cmd=pbMessage(_INTL("A {1} was planted here.",GameData::Item.get(berry).name),[
                            _INTL("Check Plant"),
                            _INTL("Axe Plant"),
                            _INTL("Exit")],-1)
        if cmd==0 # Check Plant
            pbMessage(_INTL("You look over your plant carefully."))
			if GameData::BerryPlant.get(berryData[1]).weeded == 1
            pbMessage(_INTL("Your Plant has weeds they must be removed."))
            pbMessage(_INTL("You spend some time cleaning weeds off this plant."))
            GameData::BerryPlant.get(berryData[1]).weeded = 0
			else
            pbMessage(_INTL("Your plant is healthy!"))
			end
            pbMessage(_INTL("You won't be getting a lot of fruit from it.")) if maxyield >2 && maxyield<4
            pbMessage(_INTL("You will be getting a decent amount from it.")) if maxyield >4 && maxyield<6
            pbMessage(_INTL("You will be getting a lot from it!")) if maxyield >6 && maxyield<8
            pbMessage(_INTL("You are in for some loot!")) if maxyield >8
          return
        elsif cmd==1# Shovel Plant
		   if $PokemonBag.pbHasItem?(:IRONAXE) || $PokemonBag.pbHasItem?(:STONEAXE)
            pbMessage(_INTL("The soil returned to its soft and loamy state."))
            berryData=[0,nil,false,0,0,0]
            interp.setVariable(berryData)
	          $PokemonBag.pbStoreItem(:ACORN,(rand(17)))
             pbMessage(_INTL("You put the remaining logs in the bag.\1"))
		   else
            pbMessage(_INTL("You don't have a axe to cut down the plant!"))
          end
          return
          end
  when 2  # X sprouted
    cmd=pbMessage(_INTL("This {1} has sprouted.",GameData::Item.get(berry).name),[
                            _INTL("Check Plant"),
                            _INTL("Shovel Plant"),
                            _INTL("Exit")],-1)
        if cmd==0 # Check Plant
        maxyield = GameData::BerryPlant.get(berryData[1]).maximum_yield
            pbMessage(_INTL("You look over your plant carefully."))
			if GameData::BerryPlant.get(berryData[1]).weeded == 1
            pbMessage(_INTL("Your Plant has weeds they must be removed."))
            pbMessage(_INTL("You spend some time cleaning weeds off this plant."))
            GameData::BerryPlant.get(berryData[1]).weeded = 0
			else
            pbMessage(_INTL("Your plant is healthy!"))
			end
            pbMessage(_INTL("You won't be getting a lot of fruit from it.")) if maxyield >2 && maxyield<4
            pbMessage(_INTL("You will be getting a decent amount from it.")) if maxyield >4 && maxyield<6
            pbMessage(_INTL("You will be getting a lot from it!")) if maxyield >6 && maxyield<8
            pbMessage(_INTL("You are in for some loot!")) if maxyield >8
          return
        elsif cmd==1# Shovel Plant
		   if $PokemonBag.pbHasItem?(:IRONAXE) || $PokemonBag.pbHasItem?(:STONEAXE)
            pbMessage(_INTL("The soil returned to its soft and loamy state."))
            berryData=[0,nil,false,0,0,0]
            interp.setVariable(berryData)
	          $PokemonBag.pbStoreItem(:ACORN,(rand(17)))
             pbMessage(_INTL("You put the remaining logs in the bag.\1"))
		   else
            pbMessage(_INTL("You don't have a axe to cut down the plant!"))
          end
          return
          end
  when 3  # X taller
    cmd=pbMessage(_INTL("This {1} is growing bigger.",GameData::Item.get(berry).name),[
                            _INTL("Check Plant"),
                            _INTL("Shovel Plant"),
                            _INTL("Exit")],-1)
        if cmd==0 # Check Plant
            pbMessage(_INTL("You look over your plant carefully."))
			if GameData::BerryPlant.get(berryData[1]).weeded == 1
            pbMessage(_INTL("Your Plant has weeds they must be removed."))
            pbMessage(_INTL("You spend some time cleaning weeds off this plant."))
            GameData::BerryPlant.get(berryData[1]).weeded = 0
			else
            pbMessage(_INTL("Your plant is healthy!"))
			end
            pbMessage(_INTL("You won't be getting a lot of fruit from it.")) if maxyield >2 && maxyield<4
            pbMessage(_INTL("You will be getting a decent amount from it.")) if maxyield >4 && maxyield<6
            pbMessage(_INTL("You will be getting a lot from it!")) if maxyield >6 && maxyield<8
            pbMessage(_INTL("You are in for some loot!")) if maxyield >8
          return
        elsif cmd==1# Shovel Plant
		   if $PokemonBag.pbHasItem?(:IRONAXE) || $PokemonBag.pbHasItem?(:STONEAXE)
            pbMessage(_INTL("The soil returned to its soft and loamy state."))
            berryData=[0,nil,false,0,0,0]
            interp.setVariable(berryData)
	          $PokemonBag.pbStoreItem(:ACORN,(rand(17)))
             pbMessage(_INTL("You put the remaining logs in the bag.\1"))
		   else
            pbMessage(_INTL("You don't have a axe to cut down the plant!"))
          end
          return
          end
  when 4  # X flowering
      case berryData[4]
      when berryData[4]==100
        cmd=pbMessage(_INTL("This {1} is in fabulous bloom!",GameData::Item.get(berry).name),[
                            _INTL("Check Plant"),
                            _INTL("Shovel Plant"),
                            _INTL("Exit")],-1)
        if cmd==0 # Check Plant
            pbMessage(_INTL("You look over your plant carefully."))
			if GameData::BerryPlant.get(berryData[1]).weeded == 1
            pbMessage(_INTL("Your Plant has weeds they must be removed."))
            pbMessage(_INTL("You spend some time cleaning weeds off this plant."))
            GameData::BerryPlant.get(berryData[1]).weeded = 0
			else
            pbMessage(_INTL("Your plant is healthy!"))
			end
            pbMessage(_INTL("You won't be getting a lot of fruit from it.")) if maxyield >2 && maxyield<4
            pbMessage(_INTL("You will be getting a decent amount from it.")) if maxyield >4 && maxyield<6
            pbMessage(_INTL("You will be getting a lot from it!")) if maxyield >6 && maxyield<8
            pbMessage(_INTL("You are in for some loot!")) if maxyield >8
          return
        elsif cmd==1# Shovel Plant
		   if $PokemonBag.pbHasItem?(:IRONAXE) || $PokemonBag.pbHasItem?(:STONEAXE)
            pbMessage(_INTL("The soil returned to its soft and loamy state."))
            berryData=[0,nil,false,0,0,0]
            interp.setVariable(berryData)
	          $PokemonBag.pbStoreItem(:ACORN,(rand(17)))
             pbMessage(_INTL("You put the remaining logs in the bag.\1"))
		   else
            pbMessage(_INTL("You don't have a axe to cut down the plant!"))
          end
          return
          end
      when berryData[4]>=75
        cmd=pbMessage(_INTL("This {1} is blooming very beautifully!",GameData::Item.get(berry).name),[
                            _INTL("Check Plant"),
                            _INTL("Shovel Plant"),
                            _INTL("Exit")],-1)
        if cmd==0 # Check Plant
            pbMessage(_INTL("You look over your plant carefully."))
			if GameData::BerryPlant.get(berryData[1]).weeded == 1
            pbMessage(_INTL("Your Plant has weeds they must be removed."))
            pbMessage(_INTL("You spend some time cleaning weeds off this plant."))
            GameData::BerryPlant.get(berryData[1]).weeded = 0
			else
            pbMessage(_INTL("Your plant is healthy!"))
			end
            pbMessage(_INTL("You won't be getting a lot of fruit from it.")) if maxyield >2 && maxyield<4
            pbMessage(_INTL("You will be getting a decent amount from it.")) if maxyield >4 && maxyield<6
            pbMessage(_INTL("You will be getting a lot from it!")) if maxyield >6 && maxyield<8
            pbMessage(_INTL("You are in for some loot!")) if maxyield >8
          return
        elsif cmd==1# Shovel Plant
		   if $PokemonBag.pbHasItem?(:IRONAXE) || $PokemonBag.pbHasItem?(:STONEAXE)
            pbMessage(_INTL("The soil returned to its soft and loamy state."))
            berryData=[0,nil,false,0,0,0]
            interp.setVariable(berryData)
	          $PokemonBag.pbStoreItem(:ACORN,(rand(17)))
             pbMessage(_INTL("You put the remaining logs in the bag.\1"))
		   else
            pbMessage(_INTL("You don't have a axe to cut down the plant!"))
          end
          return
          end
      when berryData[4]>=50
        cmd=pbMessage(_INTL("This {1} is blooming prettily!",GameData::Item.get(berry).name),[
                            _INTL("Check Plant"),
                            _INTL("Shovel Plant"),
                            _INTL("Exit")],-1)
        if cmd==0 # Check Plant
            pbMessage(_INTL("You look over your plant carefully."))
			if GameData::BerryPlant.get(berryData[1]).weeded == 1
            pbMessage(_INTL("Your Plant has weeds they must be removed."))
            pbMessage(_INTL("You spend some time cleaning weeds off this plant."))
            GameData::BerryPlant.get(berryData[1]).weeded = 0
			else
            pbMessage(_INTL("Your plant is healthy!"))
			end
            pbMessage(_INTL("You won't be getting a lot of fruit from it.")) if maxyield >2 && maxyield<4
            pbMessage(_INTL("You will be getting a decent amount from it.")) if maxyield >4 && maxyield<6
            pbMessage(_INTL("You will be getting a lot from it!")) if maxyield >6 && maxyield<8
            pbMessage(_INTL("You are in for some loot!")) if maxyield >8
          return
        elsif cmd==1# Shovel Plant
		   if $PokemonBag.pbHasItem?(:IRONAXE) || $PokemonBag.pbHasItem?(:STONEAXE)
            pbMessage(_INTL("The soil returned to its soft and loamy state."))
            berryData=[0,nil,false,0,0,0]
            interp.setVariable(berryData)
	          $PokemonBag.pbStoreItem(:ACORN,(rand(17)))
             pbMessage(_INTL("You put the remaining logs in the bag.\1"))
		   else
            pbMessage(_INTL("You don't have a axe to cut down the plant!"))
          end
          return
          end
      when berryData[4]>=25
        cmd=pbMessage(_INTL("This {1} is blooming cutely!",GameData::Item.get(berry).name),[
                            _INTL("Check Plant"),
                            _INTL("Shovel Plant"),
                            _INTL("Exit")],-1)
        if cmd==0 # Check Plant
            pbMessage(_INTL("You look over your plant carefully."))
			if GameData::BerryPlant.get(berryData[1]).weeded == 1
            pbMessage(_INTL("Your Plant has weeds they must be removed."))
            pbMessage(_INTL("You spend some time cleaning weeds off this plant."))
            GameData::BerryPlant.get(berryData[1]).weeded = 0
			else
            pbMessage(_INTL("Your plant is healthy!"))
			end
            pbMessage(_INTL("You won't be getting a lot of fruit from it.")) if maxyield >2 && maxyield<4
            pbMessage(_INTL("You will be getting a decent amount from it.")) if maxyield >4 && maxyield<6
            pbMessage(_INTL("You will be getting a lot from it!")) if maxyield >6 && maxyield<8
            pbMessage(_INTL("You are in for some loot!")) if maxyield >8
          return
        elsif cmd==1# Shovel Plant
		   if $PokemonBag.pbHasItem?(:IRONAXE) || $PokemonBag.pbHasItem?(:STONEAXE)
            pbMessage(_INTL("The soil returned to its soft and loamy state."))
            berryData=[0,nil,false,0,0,0]
            interp.setVariable(berryData)
	          $PokemonBag.pbStoreItem(:ACORN,(rand(17)))
             pbMessage(_INTL("You put the remaining logs in the bag.\1"))
		   else
            pbMessage(_INTL("You don't have a axe to cut down the plant!"))
          end
          return
          end
      else
        cmd=pbMessage(_INTL("This {1} is in bloom!",GameData::Item.get(berry).name),[
                            _INTL("Check Plant"),
                            _INTL("Shovel Plant"),
                            _INTL("Exit")],-1)
        if cmd==0 # Check Plant
            pbMessage(_INTL("You look over your plant carefully."))
			if GameData::BerryPlant.get(berryData[1]).weeded == 1
            pbMessage(_INTL("Your Plant has weeds they must be removed."))
            pbMessage(_INTL("You spend some time cleaning weeds off this plant."))
            GameData::BerryPlant.get(berryData[1]).weeded = 0
			else
            pbMessage(_INTL("Your plant is healthy!"))
			end
            pbMessage(_INTL("You won't be getting a lot of fruit from it.")) if GameData::BerryPlant.get(berryData[1]).maximum_yield >2 && GameData::BerryPlant.get(berryData[1]).maximum_yield<4
            pbMessage(_INTL("You will be getting a decent amount from it.")) if GameData::BerryPlant.get(berryData[1]).maximum_yield>4 && GameData::BerryPlant.get(berryData[1]).maximum_yield<6
            pbMessage(_INTL("You will be getting a lot from it!")) if GameData::BerryPlant.get(berryData[1]).maximum_yield >6 && GameData::BerryPlant.get(berryData[1]).maximum_yield<8
            pbMessage(_INTL("You are in for some loot!")) if GameData::BerryPlant.get(berryData[1]).maximum_yield >8
          return
        elsif cmd==1# Shovel Plant
		   if $PokemonBag.pbHasItem?(:IRONAXE) || $PokemonBag.pbHasItem?(:STONEAXE)
            pbMessage(_INTL("The soil returned to its soft and loamy state."))
            berryData=[0,nil,false,0,0,0]
            interp.setVariable(berryData)
	          $PokemonBag.pbStoreItem(:ACORN,(rand(17)))
             pbMessage(_INTL("You put the remaining logs in the bag.\1"))
		   else
            pbMessage(_INTL("You don't have a axe to cut down the plant!"))
          end
          return
          end
      end
  when 5  # X berries
    berryvalues = GameData::BerryPlant.get(berryData[1])
    # Get berry yield (berrycount)
    berrycount=1
    
  minyield = GameData::BerryPlant.get(berryData[1]).minimum_yield
  maxyield = GameData::BerryPlant.get(berryData[1]).maximum_yield
  hoursperstage = GameData::BerryPlant.get(berryData[1]).hours_per_stage * 3600
  timeperstage = (hoursperstage*3)
      # Gen 4 berry yield calculation
    berrycount = [berryvalues.maximum_yield - berryData[6], berryvalues.minimum_yield].max
    item = GameData::Item.get(berry)
    itemname = (berrycount>1) ? item.name_plural : item.name
    pocket = item.pocket
    if berrycount>1
      message=_INTL("There are {1} \\c[1]{2}\\c[0]!\nWant to pick them?",berrycount,itemname)
    else
      message=_INTL("There is 1 \\c[1]{1}\\c[0]!\nWant to pick it?",itemname)
    end
    if pbConfirmMessage(message)
      if berry == :ACORN 
    if pbConfirmMessage(message)
      if !$PokemonBag.pbCanStore?(berry,berrycount)
        pbMessage(_INTL("Too bad...\nThe Bag is full..."))
        return
      end
      $PokemonBag.pbStoreItem(berry,berrycount)
       if !$PokemonBag.pbCanStore?(:WOODENLOG,(berrycount*2))
         pbMessage(_INTL("Too bad...\nThe Bag is full..."))
         return
      end
      $PokemonBag.pbStoreItem(:WOODENLOG,(berrycount*2))
        pbMessage(_INTL("You knocked down the tree.",berrycount,itemname))
      pbMessage(_INTL("{1} put the \\c[1]{2}\\c[0] in the <icon=bagPocket{3}>\\c[1]{4}\\c[0] Pocket.\1",
         $Trainer.name,itemname,pocket,PokemonBag.pocketNames()[pocket]))
        pbMessage(_INTL("The soil returned to its soft and loamy state."))
        berryData=[0,nil,0,0,0,0,0,0]
      interp.setVariable(berryData)
    end
      else
       if !$PokemonBag.pbCanStore?(berry,berrycount)
         pbMessage(_INTL("Too bad...\nThe Bag is full..."))
         return
       end
       $PokemonBag.pbStoreItem(berry,berrycount)
       
       if !$PokemonBag.pbCanStore?(:WOODENLOG,99)
         pbMessage(_INTL("Too bad...\nThe Bag is full..."))
         return
      end
      $PokemonBag.pbStoreItem(:WOODENLOG,(rand(7)+1))
       timenow=pbGetTimeNow
             berryData[0]=3             # growth stage (1-5)
             berryData[1]=berry         # item ID of planted berry
             berryData[2]=timeperstage  # seconds alive
             berryData[3]=timenow.to_i  # time of last checkup (now)
             berryData[4]=100           # dampness value
             berryData[5]=0             # number of replants
             berryData[6]=0             # yield penalty
       interp.setVariable(berryData)
      end
		end
  end
  case berryData[0]
  when 1, 2, 3, 4
    for i in watering
      next if !GameData::Item.exists?(i) || !$PokemonBag.pbHasItem?(i)
      if !$PokemonBag.pbHasItem?(:WAILMERPAIL)
       if pbConfirmMessage(_INTL("Want to sprinkle some water with the {1}?",GameData::Item.get(i).name))
        berryData[4]=100
        interp.setVariable(berryData)
        pbMessage(_INTL("{1} watered the plant.\\wtnp[40]",$Trainer.name))
        pbMessage(_INTL("The plant seemed to be delighted."))
       end
      else
          berryData[4]=100
          interp.setVariable(berryData)
       end
      break
    end
  end
end

def pbPickBerry(berry, qty = 1)
  interp=pbMapInterpreter
  thisEvent=interp.get_character(0)
  berryData=interp.getVariable
  berry=GameData::Item.get(berry)
  itemname=(qty>1) ? berry.name_plural : berry.name
  if qty>1
    message=_INTL("There are {1} \\c[1]{2}\\c[0]!\nWant to pick them?",qty,itemname)
  else
    message=_INTL("There is 1 \\c[1]{1}\\c[0]!\nWant to pick it?",itemname)
  end
  if pbConfirmMessage(message)
    if !$PokemonBag.pbCanStore?(berry,qty)
      pbMessage(_INTL("Too bad...\nThe Bag is full..."))
      return
    end
    $PokemonBag.pbStoreItem(berry,qty)
    if qty>1
      pbMessage(_INTL("You picked the {1} \\c[1]{2}\\c[0].\\wtnp[30]",qty,itemname))
    else
      pbMessage(_INTL("You picked the \\c[1]{1}\\c[0].\\wtnp[30]",itemname))
    end
    pocket = berry.pocket
    pbMessage(_INTL("{1} put the \\c[1]{2}\\c[0] in the <icon=bagPocket{3}>\\c[1]{4}\\c[0] Pocket.\1",
       $Trainer.name,itemname,pocket,PokemonBag.pocketNames()[pocket]))
      pbMessage(_INTL("The Fragile Plant fell apart from you taking its fruit."))
      berryData=[0,nil,0,0,0,0,0,0]
    interp.setVariable(berryData)
    pbSetSelfSwitch(thisEvent.id,"A",true)
  end
end
### EDIT END ###