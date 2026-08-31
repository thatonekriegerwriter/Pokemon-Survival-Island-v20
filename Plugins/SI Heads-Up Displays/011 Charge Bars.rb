class HUD
  alias update_old update 
  def update(force=false)
    update_old(force=false)
	refreshChargeBars
  end 
  
  def removeaChargeBar(event)
    potato = event.id if event.is_a?(Game_PokeEventA)
    potato = event if event.is_a?(Integer)
	potato = -1 if event.is_a?(Game_Player)
   if !@pokemon_charge_bars[potato].nil?
   
    @pokemon_charge_bars[potato]["hpbarborderevent"].visible=false
    @pokemon_charge_bars[potato]["hpbarfillevent"].visible=false
	
    pbDisposeSprite(@pokemon_charge_bars[potato], "hpbarborderevent")
    pbDisposeSprite(@pokemon_charge_bars[potato], "hpbarfillevent")
	 @pokemon_charge_bars.delete(potato) 
   
   end
  
  
  end
  
  def createaChargeBar(event)
    potato = event.id if !event.is_a?(Game_Player)
	potato = -1 if event.is_a?(Game_Player)
   if !@pokemon_charge_bars[potato].nil?
   
    @pokemon_charge_bars[potato]["hpbarborderevent"].visible=false
    @pokemon_charge_bars[potato]["hpbarfillevent"].visible=false
	
    pbDisposeSprite(@pokemon_charge_bars[potato], "hpbarborderevent")
    pbDisposeSprite(@pokemon_charge_bars[potato], "hpbarfillevent")
	 @pokemon_charge_bars.delete(potato) 
   
   end
    @pokemon_charge_bars[potato] = {}
    x      = ScreenPosHelper.pbScreenX(event)
    y      = ScreenPosHelper.pbScreenY(event)
	 x -= -22
	 y -= 35
	 width = 9
	 height = 35
    fillWidth = width-4
    fillHeight = height-4
    @pokemon_charge_bars[potato]["hpbarborderevent"] = BitmapSprite.new(width,height,@viewport1)
    @pokemon_charge_bars[potato]["hpbarborderevent"].x = x
    @pokemon_charge_bars[potato]["hpbarborderevent"].y = y

    @pokemon_charge_bars[potato]["hpbarborderevent"].bitmap.fill_rect(
      Rect.new(0,0,width,height), Color.new(32,32,32)
    )
    @pokemon_charge_bars[potato]["hpbarborderevent"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )
    @pokemon_charge_bars[potato]["hpbarborderevent"].visible = false
    @pokemon_charge_bars[potato]["hpbarfillevent"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @pokemon_charge_bars[potato]["hpbarfillevent"].x = x+2
    @pokemon_charge_bars[potato]["hpbarfillevent"].y = y+2
    @pokemon_charge_bars[potato]["event"] = event
    @pokemon_charge_bars[potato]["rounds"] = 0.0
  
  end
  
  def refreshChargeBars
     @pokemon_charge_bars.each_key do |event_id|
	  event = @pokemon_charge_bars[event_id]["event"]
    x      = ScreenPosHelper.pbScreenX(event)
    y      = ScreenPosHelper.pbScreenY(event)
	 x -= -22
	 y -= 35
	 width = 9
	 height = 35
	if event.attack_opportunity==0
	 if @pokemon_charge_bars[event_id]["rounds"]>=10.0
    @pokemon_charge_bars[event_id]["hpbarborderevent"].visible=false
    @pokemon_charge_bars[event_id]["hpbarfillevent"].visible=false
	
    pbDisposeSprite(@pokemon_charge_bars[event_id], "hpbarborderevent")
    pbDisposeSprite(@pokemon_charge_bars[event_id], "hpbarfillevent")
	 @pokemon_charge_bars.delete(event_id) 
	  next
	  else
	    @pokemon_charge_bars[event_id]["rounds"]+=0.1
	  end
	end
    fillWidth = width-4
    fillHeight = height-4
    totalhp = 30
    hp = event.attack_opportunity
    @pokemon_charge_bars[event_id]["hpbarborderevent"].visible = hp!=nil
    @pokemon_charge_bars[event_id]["hpbarborderevent"].x = x
    @pokemon_charge_bars[event_id]["hpbarborderevent"].y = y
    @pokemon_charge_bars[event_id]["hpbarfillevent"].x = x+2
    @pokemon_charge_bars[event_id]["hpbarfillevent"].y = y+2
	
	
	
    @pokemon_charge_bars[event_id]["hpbarfillevent"].visible = @pokemon_charge_bars[event_id]["hpbarborderevent"].visible
    @pokemon_charge_bars[event_id]["hpbarfillevent"].bitmap.clear
	
	
    fillAmount = fillamtlookup(hp,totalhp,event_id)
    # Always show a bit of HP when alive
    return if fillAmount < 0
	
    hpColors = hpBarCurrentColors22(hp, totalhp - hp)
    shadowHeight = 0
    @pokemon_charge_bars[event_id]["hpbarfillevent"].bitmap.fill_rect(
      Rect.new(0,0,fillAmount,shadowHeight), hpColors[1]
    )
    @pokemon_charge_bars[event_id]["hpbarfillevent"].bitmap.fill_rect(
      Rect.new(
        0, @pokemon_charge_bars[event_id]["hpbarfillevent"].bitmap.height - fillAmount + shadowHeight,
        @pokemon_charge_bars[event_id]["hpbarfillevent"].bitmap.width, fillAmount
      ), hpColors[0]
    )
 
	 
	 end
  end
  
  def hpBarCurrentColors22(hp, totalhp)
    if hp<=(totalhp/4.0)
      return HUD::HP_BAR_GREEN
    elsif hp<=(totalhp/2.0)
      return HUD::HP_BAR_YELLOW
    end
    return HUD::HP_BAR_RED
  end
  

  

  def fillamtlookup(value,maxvalue,event_id)
   return 0 if value==maxvalue
   return @pokemon_charge_bars[event_id]["hpbarfillevent"].bitmap.height if value == 0
   return (@pokemon_charge_bars[event_id]["hpbarfillevent"].bitmap.height * (maxvalue - value) / maxvalue)
  end
  

end 