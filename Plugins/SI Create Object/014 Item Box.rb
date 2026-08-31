
class PokemonGlobalMetadata
  attr_accessor :hud_selector
  attr_accessor :ball_order
  attr_accessor :bars_visible
  attr_accessor :hud_control
  attr_accessor :styler_control
  attr_accessor :positioning_controls_window

  def hud_selector
    @hud_selector = 0 if !@hud_selector
    return @hud_selector
  end
  def positioning_controls_window
    setup_positioning_controls_window if !@positioning_controls_window
    return @positioning_controls_window
  end
  
  def set_positioning_controls_window_text(text=nil)
    return if @positioning_controls_window.text==text
    if !text.nil? && !text.empty?
    @positioning_controls_window.text=text
    @positioning_controls_window.resizeToFit(text,@positioning_controls_window.width)
    @positioning_controls_window.visible = true
	else
    @positioning_controls_window.visible = false
    @positioning_controls_window.text=""
    @positioning_controls_window.resizeToFit("",@positioning_controls_window.width)
	end
  end
  
  def get_positioning_controls_window_text
    setup_positioning_controls_window if !@positioning_controls_window
    return if @positioning_controls_window.text
  end
  def setup_positioning_controls_window
  
	    @positioning_controls_window = Window_AdvancedTextPokemon.newWithSize("", 0, 0, 240, 64)
        @positioning_controls_window.resizeToFit("",@positioning_controls_window.width)
        @positioning_controls_window.x = Graphics.width-@positioning_controls_window.width
        @positioning_controls_window.z = 99999
        @positioning_controls_window.visible = false
  
  
  end

  def hud_control
    return @hud_control
  end

  def styler_control
    return @styler_control
  end

  def bars_visible
    @bars_visible = true if @bars_visible.nil?
    return @bars_visible
  end


  def ball_order
   @ball_order = [] if @ball_order.nil?
   return @ball_order
  end
end

class PokemonGlobalMetadata
  attr_writer :ball_hud_enabled #$PokemonGlobal.ball_hud_enabled = true
  attr_writer :ball_hud_index
  attr_writer :stored_ball_order
  attr_writer :ball_hud_type
  attr_writer :ball_hud_item_type
  attr_writer :ball_hud_item_type_old
  attr_writer :ball_hud_moves_index
  attr_writer :ball_hud_fishing_index
  attr_writer :ball_hud_pkmn_index
  attr_writer :ball_hud_item_index
  attr_writer :ball_hud_weapon_index
  attr_writer :ball_hud_battle_index
  attr_writer :ball_hud_crops_index
  attr_writer :ball_hud_place_index
  attr_writer :ball_hud_pkmn_index_old
  attr_writer :ball_hud_item_index_old
  attr_writer :selected_pokemon
  attr_writer :set_extended_hud
  attr_writer :alt_control_move
  attr_writer :hud_storage_for_alt
  attr_writer :junk_ass_multiselect_counter
  attr_writer :display_moves
  attr_accessor :hud_favorites
  attr_accessor :cur_stored_pokemon
  attr_accessor :cur_stored_fishing_rod
  
  def hud_favorites
    @hud_favorites = [] if @hud_favorites.nil?
    @hud_favorites.delete_if do |event|
     event.is_a?(Pokemon) && !$player.party.include?(event.pokemon)
    end
   return @hud_favorites
  end
  
  def cur_stored_fishing_rod
    return @cur_stored_fishing_rod
  end 
  def ball_hud_enabled
    @ball_hud_enabled = false if !@ball_hud_enabled
    return @ball_hud_enabled
  end
  def stored_ball_order
    @stored_ball_order = nil if !@stored_ball_order
    return @stored_ball_order
  end
  def ball_hud_weapon_index
    @ball_hud_weapon_index = 0 if @ball_hud_weapon_index.nil?
   
   return @ball_hud_weapon_index
  end
  def ball_hud_fishing_index
    @ball_hud_fishing_index = 0 if @ball_hud_fishing_index.nil?
   
   return @ball_hud_fishing_index
  end
  
  def ball_hud_battle_index
    @ball_hud_battle_index = 0 if @ball_hud_battle_index.nil?
   
   return @ball_hud_battle_index
  end
  
  
  def ball_hud_crops_index
    @ball_hud_crops_index = 0 if @ball_hud_crops_index.nil?
   
   return @ball_hud_crops_index
  end
  
  
  def ball_hud_moves_index
    @ball_hud_moves_index = 0 if @ball_hud_moves_index.nil?
   
   return @ball_hud_moves_index
  end


  def junk_ass_multiselect_counter
    @junk_ass_multiselect_counter = 0 if @junk_ass_multiselect_counter.nil?
    return @junk_ass_multiselect_counter
  end
  def alt_control_move
    @alt_control_move = false if !@alt_control_move
    return @alt_control_move
  end
  def display_moves
    @display_moves = false if !@display_moves
    return @display_moves
  end


  def hud_storage_for_alt
    @hud_storage_for_alt = :PKMN if !@hud_storage_for_alt
    return @hud_storage_for_alt
  end

  def set_extended_hud
    @set_extended_hud = true if @set_extended_hud.nil?
    return @set_extended_hud
  end

  def ball_hud_index
    @ball_hud_index = 0 if @ball_hud_index.nil?
    return @ball_hud_index
  end


  def cur_stored_pokemon
    return @cur_stored_pokemon
  end

  def selected_pokemon
    @selected_pokemon = [0] if @selected_pokemon.nil?
    return @selected_pokemon
  end
  
  def reset_selected_pokemon
    @selected_pokemon = [0]
  end
  
  def selected_pokemon_cleaned
     potato = []
     selected_pokemon.reject do |pkmn|
           pkmn == 0 ||
           !defined?(pkmn.associatedevent) ||
            pkmn.is_a?(Symbol) ||
           pkmn.associatedevent.nil?||
           potato.include?(pkmn)
      end.each do |pkmn|
  potato << pkmn unless potato.include?(pkmn)
end
	return potato
  end

def get_selected_pokemon
  return selected_pokemon_cleaned
end

def get_selected_pokemon_length
  length = selected_pokemon_cleaned.length
  return length
end

def get_single_selected_pokemon
  cleaned_pokemon = selected_pokemon_cleaned
  cleaned_pokemon.delete(0) if cleaned_pokemon[0]==0
  return nil if cleaned_pokemon.length>1
  return cleaned_pokemon[0]
end

  def ball_hud_type
    return @ball_hud_type || :PKMN
  end
  def ball_hud_type_old
    return @ball_hud_type_old || :PKMN
  end

  



  def ball_hud_item_type
    return @ball_hud_item_type || :PKMN
  end
  def ball_hud_item_type_old
    return @ball_hud_item_type_old || :PKMN
  end
  
  def ball_hud_item_type_force
    if $game_map.metadata&.base_map
	           set_item_hud(:PLACE)
	else
	           set_item_hud(:TOOL)
	end
  
  end
  
  def set_item_hud(type,update=false)
    set_item_box_index if $PokemonGlobal.alt_control_move==false && update==true
      @ball_hud_item_type_old=@ball_hud_item_type
	  @ball_hud_item_type=type
	getCurrentItemOrder(true) if $PokemonGlobal.alt_control_move==false && update==true
	 $OverworldMenu.should_refresh=true 
  end
  
  def set_weapon_permanent
    set_item_box_index
      @ball_hud_item_type_old=@ball_hud_item_type
	  @ball_hud_item_type=:WEAPONS
	  $game_temp.weapon_selection_end=-1
	getCurrentItemOrder(true)
	 $OverworldMenu.should_refresh=true 
    
  end
  
  def restore_item_hud
	  @ball_hud_item_type=@ball_hud_item_type_old
	 $OverworldMenu.should_refresh=true 
  end
  
  
  def ball_hud_item_type_toggle
	    case @ball_hud_item_type
		   when :PLACE
	           set_item_hud(:TOOL)
		   when :TOOL
	           set_item_hud(:WEAPONS)
		   when :WEAPONS
	           set_item_hud(:BATTLE)
		   when :BATTLE, :CROPS
	           set_item_hud(:PLACE)
		
		end
	 $OverworldMenu.should_refresh=true 
  end
  
  def ball_hud_type_toggle(update=false)
    set_item_box_index if $PokemonGlobal.alt_control_move==false && update==true
    if @ball_hud_type==:PKMN
	  $PokemonGlobal.set_item_hud(:TOOL,true) if cur_item_hud==:WEAPONS
	  @ball_hud_type=:ITEM
	 else
	  $PokemonGlobal.set_item_hud(:TOOL,true) if cur_item_hud==:WEAPONS
	  @ball_hud_type=:PKMN
	 end
	 $OverworldMenu.should_refresh=true 
  end
  

  def set_ball_hud_type(type,update=false,pkmn=nil)
      return if type.nil?
	  pkmn = $PokemonGlobal.cur_stored_pokemon if pkmn.nil? && !$PokemonGlobal.cur_stored_pokemon.nil? && type==:MOVES
	  pkmn = $PokemonGlobal.cur_stored_fishing_rod if pkmn.nil? && !$PokemonGlobal.cur_stored_pokemon.nil? && type==:FISHING
	  $game_temp.favorites_enabled=false
	  $game_temp.radial_enabled=false
	  $PokemonGlobal.alt_control_move=false
	  $PokemonGlobal.cur_stored_pokemon=nil
	  $PokemonGlobal.cur_stored_fishing_rod=nil
	  
	  return if type==@ball_hud_type
	  pbSEPlay("GUI sel decision", 60) 
	  @ball_hud_type_old = nil
    set_item_box_index if $PokemonGlobal.alt_control_move==false && update==true
	if type==:FAVORITES
	 $game_temp.favorites_enabled=true
	elsif type==:RADIAL
	 $game_temp.radial_enabled=true
	elsif type==:MULTISELECT
	  @ball_hud_type_old = @ball_hud_type
	  $PokemonGlobal.alt_control_move=true
	elsif type==:MOVES && !pkmn.nil?
	  @ball_hud_type_old = @ball_hud_type
	  $PokemonGlobal.cur_stored_pokemon=pkmn
	elsif type==:FISHING && !pkmn.nil?
	  @ball_hud_type_old = @ball_hud_type
	  $PokemonGlobal.cur_stored_fishing_rod=pkmn
	else
     @ball_hud_type=type
	end
	
	getCurrentItemOrder(true) if update==true
	$OverworldMenu.should_refresh=true 
  end
  
  
  def ball_hud_pkmn_index
    return @ball_hud_pkmn_index || 0
  end

  def ball_hud_item_index
    return @ball_hud_item_index || 0
  end
  def ball_hud_place_index
    return @ball_hud_place_index || 0
  end

  def ball_hud_pkmn_index_old
    return @ball_hud_pkmn_index_old || 0
  end

  def ball_hud_item_index_old
    return @ball_hud_item_index_old || 0
  end
  
  
  
    def set_hud_for(object)
      if object.is_a?(Pokemon)
	    @ball_hud_type=:PKMN
	    getCurrentItemOrder
	   @ball_hud_index = @ball_order.index(object)
	  elsif index = get_item_hud_type(object)
	    @ball_hud_type=:ITEM
		@ball_hud_item_type=index
	    getCurrentItemOrder
	    @ball_hud_index = @ball_order.index(object)
	  end
    end 
    def current_selection
      @ball_order[@ball_hud_index]
    end 
end
def pbTogglePokemonSelection(pkmn)
  if $PokemonGlobal.selected_pokemon.include?(pkmn)
    pbDeselectThisPokemon(pkmn)
  else
    pbSelectThisPokemon(pkmn)
  end
end
def pbSelectThisPokemon(pkmn, forced=false)
  return false if !pkmn.is_a?(Pokemon)
  return false if $PokemonGlobal.selected_pokemon.include?(pkmn) && $PokemonGlobal.selected_pokemon.index(pkmn)!=0 && forced==false
  return false if $PokemonGlobal.selected_pokemon.count(pkmn) > 1 && forced==false
  $PokemonGlobal.selected_pokemon[$PokemonGlobal.selected_pokemon.length] = pkmn
  return true
end

def pbDeselectThisPokemon(pkmn)
  return false if !$PokemonGlobal.selected_pokemon.include?(pkmn)
  if $PokemonGlobal.selected_pokemon.index(pkmn)==0
    $PokemonGlobal.selected_pokemon[0]=0
  end
  $PokemonGlobal.selected_pokemon.delete(pkmn)
  $selection_arrows.remove_sprite("Arrow#{pkmn.associatedevent}#{pkmn.name}")
  return true
end


EventHandlers.add(:on_enter_map, :selection_set, 
proc{

  }
)

EventHandlers.add(:on_leave_map, :selection_save,
  proc {
  
  }
)




def set_item_box_index
	if !$PokemonGlobal.cur_stored_pokemon.nil?
	      $PokemonGlobal.ball_hud_moves_index=$PokemonGlobal.ball_hud_index
   elsif !$PokemonGlobal.cur_stored_fishing_rod.nil?
	      $PokemonGlobal.ball_hud_fishing_index=$PokemonGlobal.ball_hud_index
   elsif $PokemonGlobal.ball_hud_type==:PKMN
	      $PokemonGlobal.ball_hud_pkmn_index=$PokemonGlobal.ball_hud_index
	elsif $PokemonGlobal.ball_hud_type==:ITEM
	    case $PokemonGlobal.ball_hud_item_type
		   when :PLACE
	       $PokemonGlobal.ball_hud_place_index=$PokemonGlobal.ball_hud_index
		   when :TOOL
	         $PokemonGlobal.ball_hud_item_index=$PokemonGlobal.ball_hud_index
		   when :WEAPONS
	         $PokemonGlobal.ball_hud_weapon_index=$PokemonGlobal.ball_hud_index
		   when :BATTLE
	         $PokemonGlobal.ball_hud_battle_index=$PokemonGlobal.ball_hud_index
		   when :CROPS
	         $PokemonGlobal.ball_hud_crops_index=$PokemonGlobal.ball_hud_index
		end
  else 
    
  end 


end


def get_pkmn_box(update_index,othersays=nil)
	 $PokemonGlobal.stored_ball_order = nil

	 potentional=$player.party.find_all { |p| p && !p.dead? && !p.fainted? } #&& !p.egg?
	 potentional.sort_by! { |pokemon| pokemon.name }
	  potentional << :MULTISELECT if $PokemonGlobal.get_selected_pokemon.length>1
	   
     item = :RADIAL
	 potentional.unshift(item)
       item = :NONE
	  potentional.unshift(item)
     item = :BATTLE
	 potentional.unshift(item)
	  $PokemonGlobal.ball_order = potentional
	  if update_index==true && potentional.length > 0
	   $PokemonGlobal.ball_hud_pkmn_index=potentional.length-1 if potentional.length < $PokemonGlobal.ball_hud_pkmn_index
	   $PokemonGlobal.ball_hud_index=$PokemonGlobal.ball_hud_pkmn_index
     end




end


def isSelectedThisItem?(item_id)
    curItem = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
  return false unless curItem.is_a?(ItemData)
  return curItem.id==item_id

end 

def get_item_box(update_index,othersays=nil)
    curItem = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
	 $PokemonGlobal.stored_ball_order = nil
	 if $game_temp.lockontarget==false && cur_item_hud==:WEAPONS && $game_temp.weapon_selection_end>0
	   $game_temp.weapon_selection_end-=1
	 elsif $game_temp.weapon_selection_end==0 && cur_item_hud==:WEAPONS
	  $PokemonGlobal.set_item_hud(:TOOL) 
	  update_index=true
	 end
	 if $game_temp.lockontarget!=false && cur_item_hud!=:WEAPONS
	  $PokemonGlobal.set_item_hud(:WEAPONS) 
	  update_index=true
	 elsif cur_item_hud.nil?
	  $PokemonGlobal.set_item_hud(:TOOL) 
	  update_index=true
	 end
	 basicitems = []
     basicitems=$bag.isPlacableinInventory if cur_item_hud==:PLACE
     basicitems=$bag.isWeaponinInventory if cur_item_hud==:WEAPONS
     basicitems=$bag.isToolinInventory if cur_item_hud==:TOOL
     basicitems=$bag.isBattleIteminInventory if cur_item_hud==:BATTLE
     basicitems=$bag.isCropIteminInventory if cur_item_hud==:CROPS
     basicitems.sort_by! do |item|
      item.is_a?(ItemData) ? item.name : item.to_s
     end
	
	 if cur_item_hud!=:WEAPONS && cur_item_hud!=:BATTLE && cur_item_hud!=:CROPS && cur_item_hud!=:FISHING
     item = ItemData.new(:NOTEBOOK)
	  basicitems.unshift(item)
	  end
	
	 if cur_item_hud==:WEAPONS || cur_item_hud==:TOOL
     item = :BATTLE
	  basicitems.unshift(item)
	  end
	 if cur_item_hud==:BATTLE
     item = :TOOL if $game_temp.lockontarget==false
     item = :WEAPONS if $game_temp.lockontarget!=false
	  basicitems.unshift(item)
     item = :PKMN
	  basicitems.unshift(item)
	  end
     item = :RADIAL
	 basicitems.unshift(item)
     item = :NONE
	 basicitems.unshift(item)
	 
	 if (cur_item_hud==:WEAPONS || cur_item_hud==:BATTLE) && update_index==true && basicitems.length > 0 
	   index = basicitems.index(curItem)
	   $PokemonGlobal.ball_hud_weapon_index = index if index
	 
	 end
	 
    $PokemonGlobal.ball_order=basicitems
	 if update_index==true && basicitems.length > 0 
	 if cur_item_hud==:PLACE
	   $PokemonGlobal.ball_hud_place_index=0 if basicitems.length < $PokemonGlobal.ball_hud_place_index
	   $PokemonGlobal.ball_hud_index=$PokemonGlobal.ball_hud_place_index
	 end
	 if cur_item_hud==:TOOL
	   $PokemonGlobal.ball_hud_item_index=basicitems.length-1 if basicitems.length < $PokemonGlobal.ball_hud_item_index
	   $PokemonGlobal.ball_hud_index=$PokemonGlobal.ball_hud_item_index
	 end
	 if cur_item_hud==:WEAPONS
	   $PokemonGlobal.ball_hud_weapon_index=basicitems.length-1 if basicitems.length < $PokemonGlobal.ball_hud_weapon_index
	   $PokemonGlobal.ball_hud_index=$PokemonGlobal.ball_hud_weapon_index
	 end
	 if cur_item_hud==:BATTLE
	   $PokemonGlobal.ball_hud_battle_index=basicitems.length-1 if basicitems.length < $PokemonGlobal.ball_hud_battle_index
	   $PokemonGlobal.ball_hud_index=$PokemonGlobal.ball_hud_battle_index
	 end
	 if cur_item_hud==:CROPS
	   $PokemonGlobal.ball_hud_crops_index=basicitems.length-1 if basicitems.length < $PokemonGlobal.ball_hud_crops_index
	   $PokemonGlobal.ball_hud_index=$PokemonGlobal.ball_hud_crops_index
	 end
     end
	 




	

	
	

end

def get_multiselect(update_index)
	 $PokemonGlobal.stored_ball_order = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index] if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon) || $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index] == :MULTISELECT
      itms = [:NONE,"Follow","Wait","Use Item","Hunt","Search","Recall","Wander",:RADIAL]
	   
	  $PokemonGlobal.ball_order = itms
	  if update_index==true
	   $PokemonGlobal.ball_hud_index=0
     end



end

def get_moves(update_index)
	 $PokemonGlobal.stored_ball_order = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index] if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon) || $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index] == :MULTISELECT
    itms = [:NONE]
	 duriscannon = $PokemonGlobal.cur_stored_pokemon
	       duriscannon.moves.each do |move|
	         itms << move
	     
	       end
	       duriscannon.moves2.each do |move|
	         itms << move
	     
	       end
	itms2 = ["Interact","Follow","Wait","Use Item","Hunt","Search","Recall","Wander",:RADIAL]
     itmsf = itms + itms2
	  $PokemonGlobal.ball_order = itmsf
	  if update_index==true
	   $PokemonGlobal.ball_hud_moves_index=0 if itmsf.length < $PokemonGlobal.ball_hud_moves_index
	   $PokemonGlobal.ball_hud_index=$PokemonGlobal.ball_hud_moves_index
     end


end

def get_bait(update_index)
	 $PokemonGlobal.stored_ball_order = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index] if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon) || $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index] == :MULTISELECT
     basicitems=$bag.isBaitIteminInventory
     basicitems.sort_by! do |item|
      item.is_a?(ItemData) ? item.name : item.to_s
     end
    itms = [:NONE] + basicitems
	 duriscannon = $PokemonGlobal.cur_stored_fishing_rod
	  $PokemonGlobal.ball_order = itms
	  if update_index==true
	   $PokemonGlobal.ball_hud_fishing_index=0 if itms.length < $PokemonGlobal.ball_hud_fishing_index
	   $PokemonGlobal.ball_hud_index=$PokemonGlobal.ball_hud_fishing_index
     end


end

def get_favorites(update_index)
	 $PokemonGlobal.stored_ball_order = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index] if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon) || $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index] == :MULTISELECT
 
     potato = [:NONE]
     potato2 = [:RADIAL]

     itms = potato + $PokemonGlobal.hud_favorites + potato2
	  $PokemonGlobal.ball_order = itms
	  if update_index==true
	   $PokemonGlobal.ball_hud_index=0
     end



end


def get_radial(update_index)
	 $PokemonGlobal.stored_ball_order = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index] if $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index].is_a?(Pokemon) || $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index] == :MULTISELECT
      itms = [:NONE,:FAVORITES,:PKMN,:TOOL,:WEAPONS,:BATTLE,:PLACE,:CROPS]
	  $PokemonGlobal.ball_order = itms
	  if update_index==true
	   $PokemonGlobal.ball_hud_index=0
     end



end


  
def get_item_hud_type(item)
  return :PLACE   if $bag.isPlacableinInventory.include?(item)
  return :CROPS   if $bag.isCropIteminInventory.include?(item)
  return :TOOL    if $bag.isToolinInventory.include?(item)
  return :BATTLE  if $bag.isBattleIteminInventory.include?(item)
  return :WEAPONS if $bag.isWeaponinInventory.include?(item)

  return false 
end
def getCurrentItemOrder(update_index=false)
 # puts $PokemonGlobal.ball_hud_type
 # puts $PokemonGlobal.ball_hud_index
 # puts $PokemonGlobal.ball_hud_pkmn_index
 # puts $PokemonGlobal.ball_hud_item_index
	if !$PokemonGlobal.cur_stored_pokemon.nil?
	  if $PokemonGlobal.cur_stored_pokemon.fainted?
		  $PokemonGlobal.cur_stored_pokemon=nil
	  end
	end
  $PokemonGlobal.ball_order = [] if $PokemonGlobal.ball_order.nil?
   get_moves(update_index) if $game_temp.favorites_enabled==false && $PokemonGlobal.alt_control_move==false && $game_temp.radial_enabled==false && !$PokemonGlobal.cur_stored_pokemon.nil? && $PokemonGlobal.cur_stored_fishing_rod.nil?
   get_bait(update_index) if $game_temp.favorites_enabled==false && $PokemonGlobal.alt_control_move==false && $game_temp.radial_enabled==false && !$PokemonGlobal.cur_stored_fishing_rod.nil? && $PokemonGlobal.cur_stored_pokemon.nil?
   get_favorites(update_index) if $game_temp.favorites_enabled==true && $PokemonGlobal.alt_control_move==false && $game_temp.radial_enabled==false && $PokemonGlobal.cur_stored_pokemon.nil?  && $PokemonGlobal.cur_stored_fishing_rod.nil?
   get_multiselect(update_index) if $PokemonGlobal.alt_control_move==true && $game_temp.radial_enabled==false && $game_temp.favorites_enabled==false && $PokemonGlobal.cur_stored_pokemon.nil?  && $PokemonGlobal.cur_stored_fishing_rod.nil?
   get_radial(update_index) if $game_temp.radial_enabled==true && $PokemonGlobal.alt_control_move==false && $game_temp.favorites_enabled==false && $PokemonGlobal.cur_stored_pokemon.nil?  && $PokemonGlobal.cur_stored_fishing_rod.nil?
   get_pkmn_box(update_index) if $PokemonGlobal.ball_hud_type==:PKMN && $PokemonGlobal.alt_control_move==false && $game_temp.radial_enabled==false && $game_temp.favorites_enabled==false && $PokemonGlobal.cur_stored_pokemon.nil?  && $PokemonGlobal.cur_stored_fishing_rod.nil?
   get_item_box(update_index) if $PokemonGlobal.ball_hud_type==:ITEM && $PokemonGlobal.alt_control_move==false && $game_temp.radial_enabled==false && $game_temp.favorites_enabled==false && $PokemonGlobal.cur_stored_pokemon.nil?  && $PokemonGlobal.cur_stored_fishing_rod.nil?
  $PokemonGlobal.ball_order = [] if $PokemonGlobal.ball_order.nil?
end

def cur_item_hud
 return $PokemonGlobal.ball_hud_item_type
end

def cur_ball_hud
 return $PokemonGlobal.ball_hud_type
end


class Game_Player < Game_Character
  alias old_gp_update update
  
  def update
    $player.update if $player
	old_gp_update
  end 
end 