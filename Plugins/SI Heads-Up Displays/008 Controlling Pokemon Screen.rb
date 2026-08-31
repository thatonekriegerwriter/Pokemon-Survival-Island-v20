class ControllingPokemonScreen

  def initialize(viewport)
    @viewport = viewport 
	@sprites = {}
    @y_position = Graphics.height-64 + $PokemonSystem.screenposy + 45
    @x_position = 440 + $PokemonSystem.screenposx
	$ControllingPokemonScreen = self 
   
  end 

  def dispose
    pbDisposeSpriteHash(@sprites)
  end
  def hasSprites?
    return !@sprites.empty?
  end


  def create
    createSprites
    refresh
  end 
  def createSprites
    createSelection(@x_position , @yposition, 70, 11)
  end
  def refresh
    return unless hasSprites?
    refreshSelection
  end
  def update
    pbUpdateSpriteHash(@sprites)
  end 
  def createSelection(x, y, width, height)
      5.times do |i| 
        @sprites["selection#{i}"]=IconSprite.new(x-30,100+(i*32),@viewport)
        @sprites["selection#{i}"].setBitmap("Graphics/Pictures/ov_selection_box")
        @sprites["selection#{i}"].z=9
        @sprites["selection#{i}"].opacity = 127
        @sprites["selection#{i}"].visible=false
		 if i==4
	       @sprites["item_sel#{i}"] = Window_AdvancedTextPokemon.newWithSize(_INTL("<o=#{@sprites["selection#{i}"].opacity}>5. Interact"), x-46,86+(i*32), 270, 64)
		 else
	       @sprites["item_sel#{i}"] = Window_AdvancedTextPokemon.newWithSize("", x-46,86+(i*32), 270, 64)
		 end
	     @sprites["item_sel#{i}"].opacity = @sprites["selection#{i}"].opacity
        @sprites["item_sel#{i}"].visible = false
        @sprites["item_sel#{i}"].z=10
        @sprites["item_sel#{i}"].windowskin  = nil
      end
      @sprites["pause"] = Window_AdvancedTextPokemon.newWithSize("PAUSE", Graphics.width/2-40,Graphics.height/2-70, 270, 64)
      @sprites["pause"].visible = false
      @sprites["pause"].windowskin  = nil
      @sprites["pause"].z=99
      @sprites["bar"]=IconSprite.new(0,0,@viewport)
      @sprites["bar"].setBitmap("Graphics/Pictures/loadslotsbg")
      @sprites["bar"].visible = false
      @sprites["bar"].z=98
  end
  def hideSelectionHUD
  @sprites.each_key do |key|
    @sprites[key].visible=false
  end
   
  end
  def revealSelectionHUD
  @sprites.each_key do |key|
    @sprites[key].visible=true
  end
   
  end
 
  def disallowed_values
   return true if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:MULTISELECT
   return true if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:NONE
   return true if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:NO
   return true if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:BATTLE
   return true if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:TOOL
   return true if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:WEAPONS
   return true if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:FAVORITES
   return true if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:RADIAL
   return true if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:PLACE
   return true if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:PKMN
   return false
  end

  def refreshSelection
   return false
   return if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(String)
   return if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(ItemData)
   return if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon::Move)
   return if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:NO
   return if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]==:NONE
    if $PokemonGlobal.display_moves==true
      if $game_temp.current_pkmn_controlled!=false
        broseph = $game_temp.current_pkmn_controlled
	  
	  else
	      if !disallowed_values
            id = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]&.associatedevent
		   end
		 id = $PokemonGlobal.stored_ball_order&.associatedevent if $PokemonGlobal.stored_ball_order && id.nil?
        broseph = $game_map.events[id] if !id.nil?
	   end
		if !broseph.nil?
		if $PokemonGlobal.ball_hud_enabled==true
       broseph.type.moves.each_with_index do |move,index|
        @sprites["selection#{index}"].visible = true
        @sprites["item_sel#{index}"].text=""
		  movename = move.name
		  if movename.length>7
		   movename = movename.slice(0, 7)
		   movename = "#{movename...}"
		  end
        @sprites["item_sel#{index}"].text=_INTL("<o=#{@sprites["selection#{index}"].opacity}>#{index+1}. #{movename} (#{move.pp}/#{move.total_pp})")
        @sprites["item_sel#{index}"].baseColor=get_type_color(move.type)
        @sprites["item_sel#{index}"].shadowColor=get_shadow_color(move.type)
        @sprites["item_sel#{index}"].visible = true
        if index == $PokemonGlobal.hud_selector && $game_temp.current_pkmn_controlled!=false
          @sprites["item_sel#{index}"].x = 420-30
          @sprites["selection#{index}"].x = 420-30
          @sprites["selection#{index}"].setBitmap("Graphics/Pictures/ov_selection_box2")
        else
          @sprites["item_sel#{index}"].x = 415-60
          @sprites["selection#{index}"].x = 415-60
          @sprites["selection#{index}"].setBitmap("Graphics/Pictures/ov_selection_box")
        end
       end
       @sprites["selection4"].visible = true 
       @sprites["item_sel4"].visible = true 
		if 4 == $PokemonGlobal.hud_selector && $game_temp.current_pkmn_controlled!=false
          @sprites["selection4"].setBitmap("Graphics/Pictures/ov_selection_box2")
 
          @sprites["item_sel4"].x = 420-30
          @sprites["selection4"].x = 420-30
		else
          @sprites["selection4"].setBitmap("Graphics/Pictures/ov_selection_box")
          @sprites["item_sel4"].x = 415-60
          @sprites["selection4"].x = 415-60
 
		end
       else 
     5.times do |index| 
	     next if @sprites["selection#{index}"].visible == false && @sprites["item_sel#{index}"].visible == false
        @sprites["selection#{index}"].visible = false
        @sprites["item_sel#{index}"].visible = false
        @sprites["item_sel#{index}"].baseColor=get_type_color(:DURIS)
        @sprites["item_sel#{index}"].shadowColor=get_shadow_color(:DURIS)
        @sprites["item_sel#{index}"].text="" if index!=4
      
	  end
     end
       else

      5.times do |index| 
	     next if @sprites["selection#{index}"].visible == false && @sprites["item_sel#{index}"].visible == false
        @sprites["selection#{index}"].visible = false
        @sprites["item_sel#{index}"].visible = false
        @sprites["item_sel#{index}"].baseColor=get_type_color(:DURIS)
        @sprites["item_sel#{index}"].shadowColor=get_shadow_color(:DURIS)
        @sprites["item_sel#{index}"].text="" if index!=4
      
	  end
       end	   
    else
	
     5.times do |index| 
	     next if @sprites["selection#{index}"].visible == false && @sprites["item_sel#{index}"].visible == false
        @sprites["selection#{index}"].visible = false
        @sprites["item_sel#{index}"].visible = false
        @sprites["item_sel#{index}"].baseColor=get_type_color(:DURIS)
        @sprites["item_sel#{index}"].shadowColor=get_shadow_color(:DURIS)
        @sprites["item_sel#{index}"].text="" if index!=4
      
	  end
	end
 end

  def get_type_color(type=nil)
       case type
         when :NORMAL
           return Color.new(168, 167, 122)
         when :FIRE
           return Color.new(238, 129, 48)
         when :WATER
           return Color.new(99, 144, 240)
         when :ELECTRIC
           return Color.new(247, 208, 44)
         when :GRASS
           return Color.new(122, 199, 76)
         when :ICE
           return Color.new(150, 217, 214)
         when :FIGHTING
           return Color.new(194, 46, 40)
         when :POISON
           return Color.new(163, 62, 161)
         when :GROUND
           return Color.new(226, 191, 101)
         when :FLYING
           return Color.new(169, 143, 243)
         when :PSYCHIC
           return Color.new(249, 85, 135)
         when :BUG
           return Color.new(166, 185, 26)
         when :ROCK
           return Color.new(182, 161, 54)
         when :GHOST
           return Color.new(115, 87, 151)
         when :DRAGON
           return Color.new(111, 53, 252)
         when :DARK
           return Color.new(112, 87, 70)
         when :STEEL
           return Color.new(183, 183, 206)
         when :FAIRY
           return Color.new(214, 133, 173)
         else
           return Color.new(80, 80, 88)
       end
  end
 
  def get_shadow_color(type)
       case type
         when :NORMAL
           return Color.new(80, 80, 88)
         when :FIRE
           return Color.new(80, 80, 88)
         when :WATER
           return Color.new(80, 80, 88)
         when :ELECTRIC
           return Color.new(80, 80, 88)
         when :GRASS
           return Color.new(80, 80, 88)
         when :ICE
           return Color.new(80, 80, 88)
         when :FIGHTING
           return Color.new(80, 80, 88)
         when :POISON
           return Color.new(80, 80, 88)
         when :GROUND
           return Color.new(80, 80, 88)
         when :FLYING
           return Color.new(80, 80, 88)
         when :PSYCHIC
           return Color.new(80, 80, 88)
         when :BUG
           return Color.new(80, 80, 88)
         when :ROCK
           return Color.new(80, 80, 88)
         when :GHOST
           return Color.new(80, 80, 88)
         when :DRAGON
           return Color.new(80, 80, 88)
         when :DARK
           return Color.new(80, 80, 88)
         when :STEEL
           return Color.new(80, 80, 88)
         when :FAIRY
           return Color.new(80, 80, 88)
         else
           return Color.new(160, 160, 168)
       end
  end 
  
end 