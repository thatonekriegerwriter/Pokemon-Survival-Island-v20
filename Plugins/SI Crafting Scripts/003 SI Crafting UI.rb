###---craftS

#Call Crafts.craftWindow
module Crafts  
  def self.craftWindow(type,panels, data)
#  $DiscordRPC.details = "Cooking a Tasty Meal!"
#  $DiscordRPC.update
  craftScene=Crafts_Scene.new
  craftScene.pbStartScene(type, panels, data)
  craft=craftScene.pbSelectcraft
  craftScene.pbEndScene
 end
end

class Crafts_Scene
#################################
## Configuration
#################################
  
  def update
    pbUpdateSpriteHash(@sprites)
  end

  def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
  end
  
  def pbStartScene(type, amt, displaydata)
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites={}
    @icons={}
	@amt = amt+1
	@ramt = amt
	@type = type
	@event_data = displaydata
	@potato = 0
    @selection=0
    @quant=1
    @currentArray=0
    @alternatecontrolmode=false
	@items=[]
   @itemsdata=[{},{},{},{}]
	@quants=[]
    @fuel_amt=@event_data.fuel
	$coal=0
	
	
	
    #@itemA=:NO
    #@itemB=:NO
    #@itemC=:NO
    #@returnItem=:NO
	
	
	
	
	
	
    @sprites["background"]=IconSprite.new(0,0,@viewport)
	if pbResolveBitmap("Graphics/Pictures/craftingMenu/craftingPage#{@type.to_s}")
	  bitmap = "Graphics/Pictures/craftingMenu/craftingPage#{type.to_s}"
	else
	  bitmap = "Graphics/Pictures/craftingMenu/craftingPage"
	end
    @sprites["background"].setBitmap(bitmap)
    @sprites["background"].z = 0 
    @sprites["headerstrip"]=IconSprite.new(0,0,@viewport)
	if pbResolveBitmap("Graphics/Pictures/craftingMenu/HeaderStrip#{@type.to_s}")
	  bitmawfwap = "Graphics/Pictures/craftingMenu/HeaderStrip#{type.to_s}"
	else
	  bitmawfwap = "Graphics/Pictures/craftingMenu/HeaderStrip"
	end
    @sprites["headerstrip"].setBitmap(bitmawfwap)
    @sprites["headerstrip"].z = 1
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @sprites["overlay"].z = 99 
    coord=0
    @imagepos=[]
	
	 case @ramt 
	  when 1
	   fx = 148
	  when 2
	   fx = 138
	  when 3
	   fx = 128
	  when 4
	   fx = 64
	  when 5
	   fx = 32
	 end
	  fyy = 40
	 @amt.times do |i|
	  
	 @items << :NO
	 @quants << 0
    @sprites["quant#{i}"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["quant#{i}"])
	 if i == @ramt
    @sprites["quant#{i}"].x=fx+6+(64*(i+1)) if @type!=:GRINDER
    @sprites["quant#{i}"].x=(128+6+(10+64*(2+1)))  if @type==:GRINDER
    @sprites["quant#{i}"].y=180
	 else
	 
	 
	  if @type==:FURNACE
         @sprites["quant#{i}"].x=fx+6+(32)
	     puts i
	    case i
		 when 0
          @sprites["quant#{i}"].y=180+fyy
		 when 1
          @sprites["quant#{i}"].y=180-fyy
		  else
          @sprites["quant#{i}"].y=180
		 end
	  else
    @sprites["quant#{i}"].x=fx+6+(64*i)
    @sprites["quant#{i}"].y=180
	  end


	 end 
    @sprites["quant#{i}"].width=Graphics.width-48
    @sprites["quant#{i}"].height=Graphics.height
    @sprites["quant#{i}"].baseColor=Color.new(240,240,240)
    @sprites["quant#{i}"].shadowColor=Color.new(40,40,40)
    @sprites["quant#{i}"].visible=true
    @sprites["quant#{i}"].viewport=@viewport
    @sprites["quant#{i}"].windowskin=nil
	
	
	
    @sprites["craft#{i}"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["craft#{i}"])
	 if i == @ramt
    @sprites["craft#{i}"].x=fx-8+(64*(i+1)) if @type!=:GRINDER
    @sprites["craft#{i}"].x=(128-8+(10+64*(2+1))) if @type==:GRINDER
    @sprites["craft#{i}"].y=200
	 else
	  
	  if @type==:FURNACE
	    case i
		 when 0
          ty=200+fyy
		 when 1
          ty=200-fyy
		 else
          ty=200
		 end
    @sprites["craft#{i}"].x=fx-8+(32)
    @sprites["craft#{i}"].y=ty
	  else
    @sprites["craft#{i}"].x=fx-8+(64*i)
    @sprites["craft#{i}"].y=200
	  end
	 end 
    @sprites["craft#{i}"].width=Graphics.width-48
    @sprites["craft#{i}"].height=Graphics.height
    @sprites["craft#{i}"].baseColor=Color.new(0,0,0)
    @sprites["craft#{i}"].shadowColor=Color.new(160,160,160)
    @sprites["craft#{i}"].visible=true
    @sprites["craft#{i}"].viewport=@viewport
    @sprites["craft#{i}"].windowskin=nil
	
	
	
	
	 if i == @ramt
    @icons["item#{i}"]=IconSprite.new(fx+(64*(i+1)),168,@viewport) if @type!=:GRINDER
    @icons["item#{i}"]=IconSprite.new(128+(10+64*(2+1)),168,@viewport) if @type==:GRINDER
	 else
	 
	  if @type==:FURNACE
	     puts i
	    case i
		 when 0
          ty=168+fyy
		 when 1
          ty=168-fyy
		 else
          ty=168
		 end
      @icons["item#{i}"]=IconSprite.new(fx+(32),ty,@viewport)
	  else
    @icons["item#{i}"]=IconSprite.new(fx+(64*i),168,@viewport)
	  end

	 end 
    @icons["item#{i}"].setBitmap(GameData::Item.icon_filename(@items[i]))
    @icons["item#{i}"].z = 2 
	
	
	

    @icons["box#{i}"]=IconSprite.new(@icons["item#{i}"].x,@icons["item#{i}"].y,@viewport)
    @icons["box#{i}"].setBitmap("Graphics/Pictures/craftingMenu/bgBox")
    @icons["box#{i}"].z= 1
	
	
	 end
	
	
	
    @icons["resulte"]=IconSprite.new((@icons["item#{@amt-1}"].x)-54,@sprites["quant#{@amt-1}"].y,@viewport)
	if pbResolveBitmap("Graphics/Pictures/craftingMenu/ResultBox#{@type.to_s}")
	  bitmaprggrsg = "Graphics/Pictures/craftingMenu/ResultBox#{type.to_s}"
	else
	  bitmapsgrrgs = "Graphics/Pictures/craftingMenu/ResultBox"
	end
    @icons["resulte"].setBitmap(bitmaprggrsg)
	
	
	#if @amt<5
    @selectX=@icons["item0"].x
	#else
    #@selectX=100-((@amt-4)*60)
	#end
    @selectY=@icons["item0"].y
	
    @icons["selector"]=IconSprite.new(@selectX,@selectY,@viewport)
    @icons["selector"].setBitmap("Graphics/Pictures/craftingMenu/craftSelect")
    @icons["selector"].z = 98
    
	
    @sprites["craftResult"]=Window_UnformattedTextPokemon.new("")
	
    pbPrepareWindow(@sprites["craftResult"])
    @sprites["craftResult"].x=30
    @sprites["craftResult"].y=294
    @sprites["craftResult"].width=Graphics.width-48
    @sprites["craftResult"].height=Graphics.height
	colors = getDefaultTextColors(@sprites["craftResult"].windowskin)
    @sprites["craftResult"].baseColor=colors[0]
    @sprites["craftResult"].shadowColor=colors[1]
    @sprites["craftResult"].visible=true
    @sprites["craftResult"].viewport=@viewport
	   amt = ""
	   amt = "Fuel:
	 #{@event_data.fuel.to_s}" if @type == :FURNACE
	   amt = "Stamina:
	 #{$player.playerstamina}/#{$player.playermaxstamina}" if @type == :GRINDER
    @sprites["fuel"]=Window_UnformattedTextPokemon.new(amt)
	
    pbPrepareWindow(@sprites["fuel"])
    @sprites["fuel"].x=5
    @sprites["fuel"].y=35
    @sprites["fuel"].resizeToFit(@event_data.fuel.to_s,Graphics.width)
	colors = getDefaultTextColors(@sprites["fuel"].windowskin)
    @sprites["fuel"].baseColor=colors[0]
    @sprites["fuel"].shadowColor=colors[1]
    @sprites["fuel"].visible=false
    @sprites["fuel"].viewport=@viewport
	
	
    pbDeactivateWindows(@sprites)
    pbFadeInAndShow(@sprites)
  end






  def pbEndScene
	 $coal=0
    pbFadeOutAndHide(@icons)
    pbDisposeSpriteHash(@icons)

    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end



  def reset_items
   @items=[]
   @itemsdata=[{},{},{},{}]
   @quants=[]
   @amt.times do |i|
	 @items << :NO
	 @quants << 0
	end 
   @quant=1
  end
  

  def get_clicked_on
	  @amt.times do |i|
       icon_x = @icons["box#{i}"].x+ $PokemonSystem.screenposx
       icon_y = @icons["box#{i}"].y + $PokemonSystem.screenposy
       if Input.mouse_x.between?(icon_x, icon_x + @icons["box#{i}"].width) && Input.mouse_y.between?(icon_y, icon_y + @icons["box#{i}"].height)
    # The mouse click is on this icon, do something here
	      @selectX=@icons["item#{i}"].x
	      @selectY=@icons["item#{i}"].y
          @icons["selector"].x=@selectX
          @icons["selector"].y=@selectY
	       return i
           puts "Clicked on icon #{i}"
        end
	  end
	  return nil
  end
# Script that manages button inputs  
  def pbSelectcraft
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    pbSetSystemFont(overlay)
    pbDrawImagePositions(overlay,@imagepos)
	coal = nil
	
    while true
    Graphics.update
	$PokemonGlobal.addNewFrameCount
      Input.update
      self.update
	  stamina_management_for_ov if @items.empty? && rand(2)==0
      @icons["selector"].x=@selectX
      @icons["selector"].y=@selectY
	   amt = ""
	   amt = "Fuel:
	 #{@event_data.fuel.to_s}" if @type == :FURNACE
	   amt = "Stamina:
	 #{$player.playerstamina}/#{$player.playermaxstamina}" if @type == :GRINDER
      @sprites["fuel"].text=amt
      @sprites["fuel"].resizeToFit(amt,Graphics.width)
      @sprites["fuel"].visible=true if @type==:FURNACE || @type == :GRINDER
	  #puts @items.to_s
	  @amt.times do |i|
	    if @items[i].is_a? Array
       @icons["item#{i}"].setBitmap(GameData::Item.icon_filename(@items[i][0]))
	   if @items[i][0]!=:NO
	    #puts @items[i]
       @sprites["craft#{i}"].text=_INTL("{1}",GameData::Item.get(@items[i][0]).name.slice(0, 5))
	   if @ramt==i
       @sprites["quant#{i}"].text=_INTL("{1}+{2}",$bag.quantity(@items[i][0]),@quants[i]*@quant)
	   else
       @sprites["quant#{i}"].text=_INTL("{1}-{2}",$bag.quantity(@items[i][0]),@quants[i]*@quant)
	   end
	   else
       @sprites["craft#{i}"].text=_INTL("")
       @sprites["quant#{i}"].text=_INTL("")




	   
	   end
	    else
       @icons["item#{i}"].setBitmap(GameData::Item.icon_filename(@items[i]))
	   if @items[i]!=:NO
	    #puts @items[i]
       @sprites["craft#{i}"].text=_INTL("{1}",GameData::Item.get(@items[i]).name.slice(0, 5))
	   if @ramt==i
       @sprites["quant#{i}"].text=_INTL("{1}+{2}",$bag.quantity(@items[i]),@quants[i]*@quant)
	   else
       @sprites["quant#{i}"].text=_INTL("{1}-{2}",$bag.quantity(@items[i]),@quants[i]*@quant)
	   end
	   else
       @sprites["craft#{i}"].text=_INTL("")
       @sprites["quant#{i}"].text=_INTL("")
	   end
	   
	    end


      end
	  

     oranges = "" if oranges.nil?
     if @sprites["craftResult"].text!=oranges && @potato<60
           @potato+=1
	 #elsif oranges == @sprites["craftResult"].text && oranges != "" 
	 #  puts "fuck2"
	 else
        oranges = ""
		 @items.each_with_index do |wha,index|
		  next if wha==:NO
		 oranges += " + " if index > 0 && index < @ramt
		 oranges += " = " if index == @ramt
		  if wha.is_a? Array
        oranges += "#{GameData::Item.get(wha[0]).name}"
		  else
        oranges += "#{GameData::Item.get(wha).name}"
		  
		  end
         end
        @sprites["craftResult"].text=oranges
		 oranges = ""
    end

	    @selection = get_clicked_on if !get_clicked_on.nil?
	  
      if Input.trigger?(Input::LEFT) #SELECTING POSITION
        pbSEPlay("GUI sel cursor")
        if @selection==0
          @selection=@ramt
        else
          @selection-=1
        end
        @selectX=@icons["item#{@selection}"].x
        @selectY=@icons["item#{@selection}"].y
		
		
		
		
		
      elsif Input.trigger?(Input::RIGHT)
        pbSEPlay("GUI sel cursor")
        if @selection==@ramt
          @selection=0
        else
          @selection+=1
        end
        @selectX=@icons["item#{@selection}"].x
        @selectY=@icons["item#{@selection}"].y
      end
	  
	  
	  
	  
      if Input.trigger?(Input::UP) || Input.repeat?(Input::UP) || Input.repeat?(Input::JUMPUP) || Input.trigger?(Input::JUMPUP) || Input.scroll_v==1#A #INCREASING QUANTITY
        pbSEPlay("GUI sel cursor")
        if @quant>99
          @quant=1
        else
          @quant+=1
        end
	    set_remove_quant
      end
      if Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN) || Input.repeat?(Input::JUMPDOWN) || Input.trigger?(Input::JUMPDOWN) || Input.scroll_v==-1#A#DECREASING QUANTITY
        pbSEPlay("GUI sel cursor")
        if @quant==1
          @quant=100
        else
          @quant-=1
        end
	    set_remove_quant
      end
 
		 


      if Input.trigger?(Input::USE)
	    if @selection==@ramt 
		  
		   
		    if @items[@ramt]!=:NO
			  if pbCheckRecipe(@items[0...-1])
			    if $player.is_it_this_class?(:RANGER,false) && GameData::Item&.try_get(item).is_poke_ball?
                  @sprites["craftResult"].text=_INTL("You are a Ranger! You don't need POKeBALLs!")
			  pbWait(80)
             @sprites["craftResult"].text=_INTL("")
				else
			    if pbGetAllowedAmounts
			    if pbCheckPrices 
                pbSEPlay("GUI save choice")
				  craft_item
			    end
				end
               end 
			  end
           else
             @sprites["craftResult"].text=_INTL("You must first select an item!")
			  pbWait(80)
             @sprites["craftResult"].text=_INTL("")
			end
		   
		elsif @type==:FURNACE && @selection == 0
		
pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
$coal = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_coal? })
coal = $coal
}
	 if coal
	  coal = coal.id
	 if coal == :CHARCOAL
  	   @event_data.fuel+=4
	 elsif coal == :COAL
  	   @event_data.fuel+=8
	 elsif coal == :ACORN
  	   @event_data.fuel+=0.5
	 elsif coal == :WOODENLOG
  	   @event_data.fuel+=2
	 elsif coal == :WOODENSTICKS
  	   @event_data.fuel+=0.5
	 elsif coal == :WOODENPLANKS
  	   @event_data.fuel+=1
	 elsif coal == :HEATROCK
  	   @event_data.fuel+=16
	 elsif coal == :FIRESTONE
  	   @event_data.fuel+=32
	 end
     $bag.remove(coal,1)
 end
	 
		    @quant = 1
		else  
		  
		    @items[@ramt]=:NO
           item=pbChooseItem
		    @quant = 1
		    if item.nil?
		      @items[@selection] = :NO 
             @itemsdata[@selection] = {}
			 else
		      @items[@selection] = item.id
             @itemsdata[@selection] = item
		    end 
			if $bag.quantity(@items[@selection]).is_a? Float
			  amt = $bag.quantity(@items[@selection]).to_i
			  $bag.remove(@items[@selection],$bag.quantity(@items[@selection]))
			  $bag.add(@items[@selection],amt)
			  
			end
			@quants[@selection]=@quant
		    crafts = CraftsList.getcrafts(@type)		
           if pbCheckRecipe(@items[0...-1])
			   if @items[@items.length-1].is_a? Array
              @items[@items.length-1]=crafts[@currentArray][0]
			  else
              @items[@items.length-1]=crafts[@currentArray][0]
              @quants[@ramt]=1
			  end
		       set_remove_quant

           end

		
		
		
		 end






      end



     if Input.triggerex?(0x52)
         if @selection==@ramt
		   reset_items
		  else
		   @items[@selection]=:NO
		   @items[@ramt]=:NO
		    crafts = CraftsList.getcrafts(@type)		
           if pbCheckRecipe(@items[0...-1])
		      
			   if @items[@ramt].is_a? Array
              @items[@ramt]=crafts[@currentArray][0]
			  else
              @items[@ramt]=crafts[@currentArray][0]
              @quants[@ramt]=1
			  end
		       set_remove_quant
           end
		  
		  
		  end
     end





        #@sprites["craftResult"].text=_INTL("{1} + {2} + {3} = {4}",@craftA,@craftB,@craftC,@craftResult)



       #Cancel
	   
      if Input.trigger?(Input::BACK)
      @sprites["craftResult"].windowskin=nil
	  @sprites["craftResult"].text=""
	  
	  @amt.times do |i|
       @sprites["craft#{i}"].text=""
       @sprites["quant#{i}"].text=""
      end
	  


	 pbFadeOutAndHide(@icons)
	 pbFadeOutAndHide(@sprites)
	     @sprites.each_key do |key|
          @sprites[key].visible=false
          @sprites.delete(key)
        end
	     @icons.each_key do |key|
          @icons[key].visible=false
          @icons.delete(key)
        end
        return -1
      end     



    end
  end


  def craft_item
        finalitem = nil
		 bottleindex = nil
        @items.each_with_index do |item,index|
		  if index == @items.length-1
		   if item.is_a? Array
		      finalitem = item[0]
		   else
		      finalitem = item
             @sprites["craftResult"].text=_INTL("You crafted #{@quants[@ramt]*@quant} #{GameData::Item.get(item).name}(s)!")
		   end
		  else
		    if item == :BOWL || item == :GLASSBOTTLE || item == :WATERBOTTLE || item == :WATER || item == :FRESHWATER
			 bottleindex = index
			end
		    removeamt = get_remove_amt(item)*@quant
           $bag.remove(item,removeamt)
		  end
		
		 end 
  
  
           item = ItemData.new(finalitem)
		    item.max_durability = 10 if finalitem == :WHITEFLUTE || finalitem == :BLACKFLUTE
		    item.max_durability = 25 if finalitem == :BOWL || finalitem == :GLASSBOTTLE || finalitem == :WATERBOTTLE
			 if !bottleindex.nil?
			  bottle = @itemsdata[bottleindex] if @itemsdata[bottleindex].bottle.nil?
			  bottle = @itemsdata[bottleindex].bottle if !@itemsdata[bottleindex].bottle.nil?
		    item.set_bottle(bottle)
			
			end
			@event_data.fuel-=(@quants[@ramt-1]*@quant) if @type==:FURNACE
			$player.playerstamina-=((@quants[@ramt-1]*@quant)*2) if @type==:GRINDER
		    $bag.add(item,@quants[@ramt]*@quant)
           @sprites["craftResult"].text=_INTL("You crafted #{@quants[@ramt]*@quant} #{GameData::Item.get(item).name}(s)!")
			  pbWait(60)
             pbItemSummaryScreen(item)
			  pbWait(20)
             @sprites["craftResult"].text=_INTL("")
  
  end

 def get_remove_amt(curItem)
		  crafts = CraftsList.getcrafts(@type)[@currentArray]
		  crafts.each_with_index do |item,index|
		   #next if index == 0
		   next if item.is_a? TrueClass
		   next if item.is_a? FalseClass
		   if item.is_a? Array
		    if item[0].is_a? Array
			
			
		      if item[0][0]==curItem
			    return item[0][1]
			  elsif item[0]==curItem
			    return item[1]
			  end
			 
			else
			   
		      if item[0]==curItem
			    return item[1]
			  elsif item[0]==curItem[0]
			    return item[1]
			  end
			 end
		   end
		  end
		  
		  

 
   return 1
 end

def set_remove_quant
  @items.each_with_index do |item,index|
    
     @quants[index] = get_remove_amt(item)
  end

end


  def pbCheckRecipe(recipe)
    results = false
  
  
    if recipe.is_a? Array
    sorted_recipe = recipe.sort
	end
    for i in 0..CraftsList.getcrafts(@type).length-1
	   thepog = CraftsList.getcrafts(@type)[i][1..-1].reject do |item|
           item.is_a?(FalseClass)
       end

      if thepog.length<sorted_recipe.length
	     theamt = sorted_recipe.length-thepog.length
		 theamt.times do
		   thepog << :NO
		 end
	  end
	   
	   
	  thecraftslist = thepog.map do |item|
	   
	  if item.is_a?(Array)
	   if item[0].is_a?(Array)
	    item =item[0][0]
	   else
	    item =item[0]
	   end
	  else
	  item = item
	  end
	  end
     sorted_craft = thecraftslist.sort
	 
      if sorted_craft.length>sorted_recipe.length
	     next
	  end
	  
	  
	  
	  recipesthatmatch = []
      if sorted_recipe == sorted_craft
	    CraftsList.getcrafts(@type)[i].each do |item|
		   next if results == true
		   if item.is_a? FalseClass
		    if true
		     if $recipe_book.has(item) 
	          recipesthatmatch << i if !recipesthatmatch.include?(i)
		     else
			   
             @sprites["craftResult"].text=_INTL("You don't have that Recipe!")
			  pbWait(80)
             @sprites["craftResult"].text=_INTL("")
			   next
			 end
           else
		    recipesthatmatch << i if !recipesthatmatch.include?(i)
		   end
          else
		    recipesthatmatch << i if !recipesthatmatch.include?(i)
		   end
		 end
		 
      end

      if recipesthatmatch.length>1 && false
      @sprites["craftResult"].text=_INTL("There is multiple recipes that match the result!")
			  pbWait(80)
             @sprites["craftResult"].text=_INTL("")
      index = 0
	  loop do
	    if Input.trigger?(Input::LEFT)
		    index-=1 if index-1>=0
			index=recipesthatmatch.length if index-1<0
           @sprites["craftResult"].text=_INTL("#{recipesthatmatch[index]}!")
			  pbWait(80)
             @sprites["craftResult"].text=_INTL("")
		 elsif Input.trigger?(Input::RIGHT)
		    index+=1 if index+1<=recipesthatmatch.length
			index=0 if index+1>recipesthatmatch.length
           @sprites["craftResult"].text=_INTL("#{recipesthatmatch[index]}!")
			  pbWait(80)
             @sprites["craftResult"].text=_INTL("")
		 elsif Input.trigger?(Input::USE)
	       @currentArray=recipesthatmatch[index]
          @alternatecontrolmode=false
	       results = true
	       break
	     end
	  
	  
	  
	  end
      break
      elsif recipesthatmatch.length>0
	   @currentArray=recipesthatmatch[0]
	   results = true
	   break
	  end
 
    end

   return results
  end
  
  
  
  def pbGetAllowedAmounts
    allowed = false
		  crafts = CraftsList.getcrafts(@type)[@currentArray]
		  curItem = crafts[0]
		   if curItem.is_a? Array
		        curItem=curItem[0]
               item_data = GameData::Item.try_get(curItem)
			     if !$PokemonGlobal.pcItemStorage
                  storage = false
				  else 
				    storage = $PokemonGlobal.pcItemStorage.has?(curItem) 
                end
			    if item_data.is_durable? && (!$bag.has?(curItem) || !storage || !has_items_from_storages(curItem))
				  allowed = true
				end

				if !item_data.is_durable?
				  allowed = true
				end



          else
		  
               item_data = GameData::Item.try_get(curItem)
			     if !$PokemonGlobal.pcItemStorage
                  storage = false
				  else 
				    storage = $PokemonGlobal.pcItemStorage.has?(curItem) 
                end
			    if item_data.is_durable? && (!$bag.has?(curItem) || !storage || !has_items_from_storages(curItem))
				  allowed = true
				end
				if !item_data.is_durable?
				  allowed = true
				end
		   end
		  
		  
		  
 
  
  
   return allowed
  end
  def pbCheckPrices
		  items6 = []
		  qants = []
		  crafts = CraftsList.getcrafts(@type)[@currentArray]
		  crafts.each_with_index do |item,index|
		   next if index == 0
		   next if item.is_a? TrueClass
		   next if item.is_a? FalseClass
		    theitem = nil
			 quant = 1
		   if item.is_a? Array
		    theitem = item[0]
			 quant = item[1]
		   else
		    theitem = item
			 quant = 2
		   end

           itemName = GameData::Item.get(theitem).name
		   	if $bag.quantity(theitem)<(quant*@quant)
             @sprites["craftResult"].text=_INTL("You don't have enough #{itemName}!")
			  pbWait(80)
             @sprites["craftResult"].text=_INTL("")
		      return false
			end
		   	if @type==:FURNACE && @event_data.fuel==0
             @sprites["craftResult"].text=_INTL("The Furnace does not have enough fuel!")
			  pbWait(80)
             @sprites["craftResult"].text=_INTL("")
		      return false
			end
		   	if @type==:FURNACE && @event_data.fuel<(quant*@quant)
             @sprites["craftResult"].text=_INTL("The Furnace does not have enough fuel for that many items!")
			  pbWait(80)
             @sprites["craftResult"].text=_INTL("")
		      return false
			end
		   	if @type==:GRINDER && $player.playerstamina==0
             @sprites["craftResult"].text=_INTL("You are too tired to grind down more items!")
			  pbWait(80)
             @sprites["craftResult"].text=_INTL("")
		      return false
			end
		   	if @type==:GRINDER && $player.playerstamina<((quant*@quant)*2)
             @sprites["craftResult"].text=_INTL("You are too tired to grind down that many items!")
			  pbWait(80)
             @sprites["craftResult"].text=_INTL("")
		      return false
			end

		  end
		  
		  

         return true
  end


  def has_items_from_storages(item)
    hasit=false
    if !$PokemonGlobal.itemStorageSystems.empty?
    $PokemonGlobal.itemStorageSystems.each_key do |i|
	  thestorage = storage[i]
	   if thestorage.has?(item)
	     hasit=true
	   end
	end
    end
	return hasit
  end


end

