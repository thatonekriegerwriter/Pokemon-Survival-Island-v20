class Bitmap
  def apply_sepia_tone
    # Iterate through all pixels in the bitmap
    width.times do |x|
      height.times do |y|
        # Get the current pixel color
        color = self.get_pixel(x, y)
        
        # Extract the red, green, and blue components
        r = color.red
        g = color.green
        b = color.blue
        
        # Apply the sepia tone effect
        tr = (r * 0.393 + g * 0.769 + b * 0.189).to_i
        tg = (r * 0.349 + g * 0.686 + b * 0.168).to_i
        tb = (r * 0.272 + g * 0.534 + b * 0.131).to_i

        # Clamp values to ensure they're within valid color range (0-255)
        tr = [[tr, 255].min, 0].max
        tg = [[tg, 255].min, 0].max
        tb = [[tb, 255].min, 0].max

        # Set the new pixel color
        self.set_pixel(x, y, Color.new(tr, tg, tb))
      end
    end
  end
  def apply_monochrome
    # Iterate through all pixels in the bitmap
    width.times do |x|
      height.times do |y|
        # Get the current pixel color
        color = self.get_pixel(x, y)
        
        # Extract the red, green, and blue components
        r = color.red
        g = color.green
        b = color.blue
        
        # Calculate the grayscale value using the weighted average
        gray = (r * 0.299 + g * 0.587 + b * 0.114).to_i
        
        # Clamp the value to the valid color range (0-255)
        gray = [[gray, 255].min, 0].max
        
        # Set the pixel to the grayscale value (same for R, G, B)
        self.set_pixel(x, y, Color.new(gray, gray, gray))
      end
    end
  end
  def apply_washed_out
    # Iterate through all pixels in the bitmap
    width.times do |x|
      height.times do |y|
        # Get the current pixel color
        color = self.get_pixel(x, y)
        
        # Extract the red, green, and blue components
        r = color.red
        g = color.green
        b = color.blue
        
        # Calculate the grayscale value using the weighted average
        gray = (r * 0.299 + g * 0.587 + b * 0.114).to_i
        
        # Calculate a washed-out effect by blending original color with grayscale
        washed_r = (r * 0.6 + gray * 0.4).to_i
        washed_g = (g * 0.6 + gray * 0.4).to_i
        washed_b = (b * 0.6 + gray * 0.4).to_i
        
        # Clamp the values to ensure they remain within the valid range (0-255)
        washed_r = [[washed_r, 255].min, 0].max
        washed_g = [[washed_g, 255].min, 0].max
        washed_b = [[washed_b, 255].min, 0].max
        
        # Set the new pixel color
        self.set_pixel(x, y, Color.new(washed_r, washed_g, washed_b))
      end
    end
  end

end

class History
  attr_accessor :history
 
 
  def initialize
   @history = FixedSizeArray.new(5)
   @fullhistory = []
   @lastvalued = [pbGetTimeNow.day-1,pbGetTimeNow.month,pbGetTimeNow.year]
   #@history = ["#{$player.name} crafted 4 Poké Ball(s) at a Pokéball Carver.","#{$player.name} slept for 4 hours in a Bed.","#{$player.name} stored Snorlax in Crate 'FBox'.","#{$player.name} fished up a Magikarp in Temperate Shore!","Scyther defeated a Plusle!"]
  end
  
  def array
   return @history.to_a
  end
  def length
    return @history.length
  end
  def add_history(text,logged=false)
   @lastvalued = [pbGetTimeNow.day-1,pbGetTimeNow.month,pbGetTimeNow.year] if @lastvalued.nil?
    return pbMessage(_INTL("You've already done this today!")) if logged==true && @lastvalued == [pbGetTimeNow.day-1,pbGetTimeNow.month,pbGetTimeNow.year]
    index = @history.next_position
    take_screenshot("history#{index}")
    @history.add(text)
	 @fullhistory << text if logged==true
	  pbAutosave if pbCanAutosave?
	  @lastvalued = [pbGetTimeNow.day-1,pbGetTimeNow.month,pbGetTimeNow.year] if logged==true
  end
  def take_screenshot(name=nil)
    t = pbGetTimeNow
    name = t.strftime("[%Y-%m-%d] %H_%M_%S.%L") if name.nil?
    capturefile = (sprintf("%s.png", name))
    $mouse.hide
    $hud.hideMainHUD
    result = Graphics.snap_to_bitmap
    $hud.revealMainHUD
    $mouse.show
    result.apply_monochrome
    result.save_to_png("Data/History/#{capturefile}")
  end
  def get_history(index)
   data = @history.to_a[index]
   
   return data
  end

end

class PokemonGlobalMetadata
  attr_accessor :history

  def history
    @history = History.new if @history.nil?
    return @history
  end

end

module ShowHistory
  module_function
  def showPicture(name=nil)
    return name if name.nil?
    return Bitmap.new("Data/History/history#{name}")
  end
  
  def pbHistory_Screen
   $mouse.hide if $mouse && !$mouse.disposed? 
     if !pbMapInterpreterRunning?
      checked = 0
	  
		   pbFadeOutIn {
      @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z=99999
      @history = Sprite.new(@viewport)
      @overlay2 = Sprite.new(@viewport)
      @overlay2.bitmap = Bitmap.new("Graphics/UI/history_overlaybc")
      @overlay = Sprite.new(@viewport)
      @overlay.bitmap = Bitmap.new("Graphics/UI/history_overlay")
	   @toptext = Window_AdvancedTextPokemon.newWithSize("", -2, 0-10, 240, 64)
	   @bottomtext = Window_AdvancedTextPokemon.newWithSize("", -2, Graphics.height - 120, 240, 64)
	   @toptext.windowskin  = nil
	   @bottomtext.windowskin  = nil
	   @toptext.z = 99999
	   @bottomtext.z = 99999
          Graphics.wait(50)
	    }
	    potato = $PokemonGlobal.history.array + ["drusiiejfafjiegojrsogiriojrbij"]
		 textindex = potato.reverse
      potato.each_with_index do |history, index|
      checked = 0
      loop do
        $PokemonGlobal.addNewFrameCount 
        Graphics.update
        Input.update
		
		
        case checked
        when 0
		      if pbResolveBitmap("Data/History/history#{index+1}")
            @history.bitmap = self.showPicture(index+1)
			   if index==5
		     @toptext.setTextToFit("")
		     @bottomtext.setTextToFit("")
			   
			   else
			   text = "(#{textindex.index(potato[index+1])})"
			   text = "" if textindex.index(potato[index+1])==0
		     @toptext.setTextToFit("Previously on your journey... #{text}")
		     @bottomtext.setTextToFit(history)
			   end
			   elsif index==5
		     @toptext.setTextToFit("")
		     @bottomtext.setTextToFit("")
			   else
			   break
             end
 
		  
		    if index==5
            #@history.opacity = 150
			   #@overlay.opacity = 150
            checked = 1
			 
			 else
          checked = 4
		     end
		  
        when 1
          #@history.opacity += 15
			 #@overlay.opacity += 15
          Graphics.wait(10)
          checked = 2 #if @history.opacity >= 255 && @overlay.opacity >= 255
		  
		  
        when 2
          Graphics.wait(30)
          checked = 3
		  
		  
        when 3
          @history.opacity -= 15
			 @overlay.opacity -= 5
          checked = 4 if @history.opacity <= 0 && @overlay.opacity <= 0
		  
		  
		  
        when 4
		    if index>=$PokemonGlobal.history.length
			  if index+1==5
		     @toptext.setTextToFit("")
		     @bottomtext.setTextToFit("")
			  end
          break
			 
			 else
		   if Input.trigger?(Input::USE)
			   if index+1==5
		     @toptext.setTextToFit("")
		     @bottomtext.setTextToFit("")
			  else
		   pbFadeOutIn {
		      if pbResolveBitmap("Data/History/history#{index+2}")
            @history.bitmap = self.showPicture(index+2)
			   end
			   text = "(#{textindex.index(potato[index+2])})"
			   text = "" if textindex.index(potato[index+2])==0
		     @toptext.setTextToFit("Previously on your journey... #{text}")
		     @bottomtext.setTextToFit(potato[index+1])
			 
          Graphics.wait(10)
		    }
			  end
          break
		   end
		    end
        end

      
      end

      end
	  @history.dispose 
	  @overlay.dispose 
     @overlay2.dispose 
     @viewport.dispose
	  @toptext.setTextToFit("")
	  @bottomtext.setTextToFit("")
	  @toptext.dispose
	  @bottomtext.dispose
    else
      @checked = nil 
    end
  end
          Graphics.wait(90)
   # $mouse.show if $mouse && !$mouse.disposed?
end





def pbAddToHistory(text)
   $PokemonGlobal.history.add_history(text)
end

def pbHistoryScreenshot
 if pbConfirmMessage(_INTL("Do you want to log this as an important moment in your Adventure Session? You can only do this once a day."))
      msg = pbFreeTextNoWindow("What did #{$player.name} do?",false,256,Graphics.width,false)
      if msg != "" && !msg.nil?
        $PokemonGlobal.history.add_history(msg,true)
	   end
 end
end