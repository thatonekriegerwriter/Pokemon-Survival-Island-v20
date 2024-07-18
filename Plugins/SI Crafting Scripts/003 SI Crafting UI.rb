###---craftS

#Call Crafts.craftWindow
module Crafts  
  def self.craftWindow(type,panels)
#  $DiscordRPC.details = "Cooking a Tasty Meal!"
#  $DiscordRPC.update
  craftScene=Crafts_Scene.new
  craftScene.pbStartScene(type,panels)
  craft=craftScene.pbSelectcraft
  craftScene.pbEndScene
 end
end

class Crafts_Scene
#################################
## Configuration
  craftNAMEBASECOLOR=Color.new(88,88,80)
  craftNAMESHADOWCOLOR=Color.new(168,184,184)
#################################
  
  def update
    pbUpdateSpriteHash(@sprites)
  end

  def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
  end
  
  def pbStartScene(type,amt)
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites={}
    @icons={}
	@amt = amt+1
	@ramt = amt
	@type = type
	@potato = 0
    @selection=0
    @quant=1
    @currentArray=0
    @alternatecontrolmode=false
	@items=[]
	@quants=[]
	 $value=0
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
    @sprites["headerstrip"].setBitmap("Graphics/Pictures/craftingMenu/HeaderStrip")
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
	
	 @amt.times do |i|
	  
	 @items << :NO
	 @quants << 0
    @sprites["quant#{i}"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["quant#{i}"])
	 if i == @ramt
    @sprites["quant#{i}"].x=fx+6+(64*(i+1))
	 else
    @sprites["quant#{i}"].x=fx+6+(64*i)
	 end 
    @sprites["quant#{i}"].y=180
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
    @sprites["craft#{i}"].x=fx-8+(64*(i+1))
	 else
    @sprites["craft#{i}"].x=fx-8+(64*i)
	 end 
    @sprites["craft#{i}"].y=200
    @sprites["craft#{i}"].width=Graphics.width-48
    @sprites["craft#{i}"].height=Graphics.height
    @sprites["craft#{i}"].baseColor=Color.new(0,0,0)
    @sprites["craft#{i}"].shadowColor=Color.new(160,160,160)
    @sprites["craft#{i}"].visible=true
    @sprites["craft#{i}"].viewport=@viewport
    @sprites["craft#{i}"].windowskin=nil
	
	
	
	
	 if i == @ramt
    @icons["item#{i}"]=IconSprite.new(fx+(64*(i+1)),168,@viewport)
	 else
    @icons["item#{i}"]=IconSprite.new(fx+(64*i),168,@viewport)
	 end 
    @icons["item#{i}"].setBitmap(GameData::Item.icon_filename(@items[i]))
    @icons["item#{i}"].z = 2 
	
	
	
    @icons["box#{i}"]=IconSprite.new(@icons["item#{i}"].x,168,@viewport)
    @icons["box#{i}"].setBitmap("Graphics/Pictures/craftingMenu/bgBox")
    @icons["box#{i}"].z= 1
	
	
	 end
	
	
	
    @icons["resulte"]=IconSprite.new((@icons["item#{@amt-1}"].x)-54,180,@viewport)
    @icons["resulte"].setBitmap("Graphics/Pictures/craftingMenu/Result Box")
	
	
	#if @amt<5
    @selectX=@icons["item0"].x
	#else
    #@selectX=100-((@amt-4)*60)
	#end
    @selectY=168
	
    @icons["selector"]=IconSprite.new(@selectX,@selectY,@viewport)
    @icons["selector"].setBitmap("Graphics/Pictures/craftingMenu/craftSelect")
    @icons["selector"].z = 98
    
	
    @sprites["craftResult"]=Window_UnformattedTextPokemon.new("")
	
    pbPrepareWindow(@sprites["craftResult"])
    @sprites["craftResult"].x=30
    @sprites["craftResult"].y=294
    @sprites["craftResult"].width=Graphics.width-48
    @sprites["craftResult"].height=Graphics.height
    @sprites["craftResult"].baseColor=Color.new(0,0,0)
    @sprites["craftResult"].shadowColor=Color.new(160,160,160)
    @sprites["craftResult"].visible=true
    @sprites["craftResult"].viewport=@viewport
    #@sprites["craftResult"].windowskin=nil
	
	
    pbDeactivateWindows(@sprites)
    pbFadeInAndShow(@sprites)
  end






  def pbEndScene
    pbFadeOutAndHide(@icons)
    pbDisposeSpriteHash(@icons)

    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end



  def reset_items
   @items=[]
   @quants=[]
   @amt.times do |i|
	 @items << :NO
	 @quants << 0
	end 
   @sprites["craftResult"].text=_INTL("No items selected.")
   @quant=1

  end
  





# Script that manages button inputs  
  def pbSelectcraft
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    pbSetSystemFont(overlay)
    pbDrawImagePositions(overlay,@imagepos)
	
if @type==:FURNACE
pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
$coal = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_coal? })
}
	 if $coal
	 if $coal == :CHARCOAL
  	   $value=3
	 elsif $coal == :COAL
  	   $value=2
	 elsif $coal == :ACORN
  	   $value=10
	 elsif $coal == :WOODENLOG
  	   $value=5
	 elsif $coal == :WOODENPLANKS
  	   $value=8
	 elsif $coal == :HEATROCK
  	   $value=1
	 elsif $coal == :FIRESTONE
  	   $value=1
	 end
 end

	if $coal.nil?
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
	else
           @items[0]=$coal
	
	end

end	
	
	
	
    while true
    Graphics.update
      Input.update
      self.update
      @icons["selector"].x=@selectX
      @icons["selector"].y=@selectY
      
	  
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
       @sprites["quant#{i}"].text=_INTL("{1}+{2}",$bag.quantity(@items[i][0]),@quants[i]*@quant)
	   else
       @sprites["quant#{i}"].text=_INTL("{1}-{2}",$bag.quantity(@items[i]),@quants[i]*@quant)
	   end
	   else
       @sprites["craft#{i}"].text=_INTL("")
       @sprites["quant#{i}"].text=_INTL("")
	   end
	   
	    end


      end
	  



	  
	if @alternatecontrolmode==false
	  
      if Input.trigger?(Input::LEFT) #SELECTING POSITION
        pbSEPlay("GUI sel cursor")
        if @selection==0
          @selection=@ramt
        else
          @selection-=1
        end
        @selectX=@icons["item#{@selection}"].x
		
		
		
		
		
      elsif Input.trigger?(Input::RIGHT)
        pbSEPlay("GUI sel cursor")
        if @selection==@ramt
          @selection=0
        else
          @selection+=1
        end
        @selectX=@icons["item#{@selection}"].x
      end
	  
	  
	  
	  
	  
	  
	  
	  
      if Input.trigger?(Input::UP) || Input.repeat?(Input::UP)  #INCREASING QUANTITY
        pbSEPlay("GUI sel cursor")
        if @quant>99
          @quant=1
        else
          @quant+=1
        end
	    set_remove_quant
      end
      if Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN) #DECREASING QUANTITY
        pbSEPlay("GUI sel cursor")
        if @quant==1
          @quant=100
        else
          @quant-=1
        end
	    set_remove_quant
      end
 
		 
        oranges = "" if oranges.nil?
        if @sprites["craftResult"].text!=oranges && @potato<60
           @potato+=1
		else
        oranges = ""
		 @items.each_with_index do |wha,index|
		 oranges += " + " if index > 0 && index < @ramt && wha!=:NO
		 oranges += " = " if index == @ramt && wha!=:NO
		  if wha.is_a? Array
        oranges += "#{GameData::Item.get(wha[0]).name}" if wha!=:NO
		  else
        oranges += "#{GameData::Item.get(wha).name}" if wha!=:NO
		  
		  end
        @sprites["craftResult"].text=oranges
        end
        end

      if Input.trigger?(Input::USE)
	    if @selection==@ramt 
		  
		   
		    if @items[@ramt]!=:NO
			  if pbCheckRecipe(@items[0...-1])
			    if pbGetAllowedAmounts
			    if pbCheckPrices 
                pbSEPlay("GUI save choice")
				  craft_item
				  pbWait(6)
				  reset_items
			    end
				end
			  end
           else
             @sprites["craftResult"].text=_INTL("You must first select an item!")
			end
		   
		elsif @type==:FURNACE && @selection == 0
		
pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
$coal = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_coal? })
}
	 if $coal
	 if $coal == :CHARCOAL
  	   $value=3
	 elsif $coal == :COAL
  	   $value=2
	 elsif $coal == :ACORN
  	   $value=6
	 elsif $coal == :WOODENLOG
  	   $value=4
	 elsif $coal == :WOODENPLANKS
  	   $value=6
	 elsif $coal == :HEATROCK
  	   $value=1
	 elsif $coal == :FIRESTONE
  	   $value=1
	 end
 end

	if $coal.nil?
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
	else
           @items[0]=$coal
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
		 
		else  
		  
		    @items[@ramt]=:NO
           @items[@selection]=pbChooseItem
		    if @items[@selection].nil?
		      @items[@selection] = :NO 
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



     if Input.triggerex?(0x2E)
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
  end


  def craft_item
        @items.each_with_index do |item,index|
		  if index == @items.length-1
		   if item.is_a? Array
           $bag.add(item[0],@quants[@ramt]*@quant)
		   
		   else
           $bag.add(item,@quants[@ramt]*@quant)
             @sprites["craftResult"].text=_INTL("You crafted #{item}!")
		   end
		  else
		    removeamt = get_remove_amt(item)*@quant
           $bag.remove(item,removeamt)
		  end
		
		 end 
  
  
  
  
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
			   
             @sprites["craftResult"].text=_INTL("You don't have that Recipe!") if $DEBUG
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

      if recipesthatmatch.length>1
      @alternatecontrolmode=true
      @sprites["craftResult"].text=_INTL("There is multiple recipes that match the result!")
      index = 0
	  loop do
	    if Input.trigger?(Input::LEFT)
		    index-=1 if index-1>=0
			index=recipesthatmatch.length if index-1<0
           @sprites["craftResult"].text=_INTL("#{recipesthatmatch[index]}!")
		 elsif Input.trigger?(Input::RIGHT)
		    index+=1 if index+1<=recipesthatmatch.length
			index=0 if index+1>recipesthatmatch.length
           @sprites["craftResult"].text=_INTL("#{recipesthatmatch[index]}!")
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
		   if item.is_a? Array
		    if $bag.quantity(item[0])<(item[1]*@quant)
			  
             @sprites["craftResult"].text=_INTL("You don't have enough #{item[0]}!")
		      return false
			end
		   else
		    if $bag.quantity(item)<@quant
             @sprites["craftResult"].text=_INTL("You don't have enough #{item}!")
		      return false
			end
		   
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

