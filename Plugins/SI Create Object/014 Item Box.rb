
#===============================================================================
# HUDRegistry -- the actual place to register new modes/tabs from now on.
# Nothing here is special-cased for the built-in modes/tabs: they're
# registered through this same API below, so registering your own works
# exactly the same way.
#===============================================================================
module HUDRegistry
  # --- Top-level "override" modes (MOVES, FISHING, FAVORITES, RADIAL,
  # MULTISELECT, PKMN, ITEM, and anything you add). Order matters: earlier
  # entries take priority. New registrations are inserted before the given
  # anchor (default :get_pkmn_box) so they outrank the PKMN/ITEM fallbacks
  # unless you say otherwise.
  def self.override_modes
    @override_modes ||= []
  end

  def self.register_override_mode(build:, active:, before: :get_pkmn_box)
    entry = { build: build, active: active }
    idx = override_modes.index { |m| m[:build] == before }
    idx ? override_modes.insert(idx, entry) : override_modes.push(entry)
  end

  # --- ITEM sub-tabs (PLACE, TOOL, WEAPONS, BATTLE, CROPS, and anything
  # you add). See register_item_tab's seeding calls (further down) for what
  # each keyword argument does.
  def self.item_tabs
    @item_tabs ||= {}
  end

  def self.register_item_tab(key, source:, skip_notebook: false, prepends: nil, reset_to_start: false)
    item_tabs[key] = { source: source, skip_notebook: skip_notebook, prepends: prepends, reset_to_start: reset_to_start }
  end

  # --- The ITEM sub-tab toggle cycle (what the toggle button goes to next).
  def self.item_tab_cycle
    @item_tab_cycle ||= {}
  end

  # Splices new_tab in right after an existing tab in the cycle, e.g.
  # HUDRegistry.insert_item_tab_in_cycle(:INTERACTION, after: :BATTLE)
  # turns ...BATTLE->PLACE... into ...BATTLE->INTERACTION->PLACE...
  def self.insert_item_tab_in_cycle(new_tab, after:)
    old_next = item_tab_cycle[after]
    item_tab_cycle[after] = new_tab
    item_tab_cycle[new_tab] = old_next if old_next
  end
end

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
  # The 8 per-tab index accessors (ball_hud_pkmn_index, ball_hud_item_index,
  # ball_hud_place_index, ball_hud_weapon_index, ball_hud_battle_index,
  # ball_hud_crops_index, ball_hud_fishing_index, ball_hud_moves_index) used
  # to each be a hand-copied ivar+method pair. They're unchanged from the
  # outside -- same names, same behavior -- but now share one hash so a new
  # tab's index doesn't need a new copy-pasted accessor.
  def hud_tab_indices
    @hud_tab_indices = {} if @hud_tab_indices.nil?
    return @hud_tab_indices
  end

  {
    ball_hud_pkmn_index:    :PKMN,
    ball_hud_item_index:    :TOOL,
    ball_hud_place_index:   :PLACE,
    ball_hud_weapon_index:  :WEAPONS,
    ball_hud_battle_index:  :BATTLE,
    ball_hud_crops_index:   :CROPS,
    ball_hud_fishing_index: :FISHING,
    ball_hud_moves_index:   :MOVES,
  }.each do |method_name, key|
    define_method(method_name) { hud_tab_indices[key] || 0 }
    define_method("#{method_name}=") { |value| hud_tab_indices[key] = value }
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
  
  
  # Was a `case` with one when-branch per tab; now registered through
  # HUDRegistry (seeded at the bottom of this file). To add a tab to the
  # toggle cycle: HUDRegistry.insert_item_tab_in_cycle(:YOURTAB, after: :SOMETAB)
  def ball_hud_item_type_toggle
    next_type = HUDRegistry.item_tab_cycle[@ball_hud_item_type]
    set_item_hud(next_type) if next_type
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
      @ball_hud_type=:PKMN
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
  return false unless pkmn.is_a?(Pokemon)
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

def pbDeselectAllSelected
  selected = $PokemonGlobal.selected_pokemon.dup
  selected.each_with_index do |pkmn, index|
    next unless pkmn.is_a?(Pokemon)
	pbDeselectThisPokemon(pkmn)
  end 

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
	    # was a `case ball_hud_item_type` with one line per tab; the shared
	    # hash means this line covers every current and future ITEM tab.
	    $PokemonGlobal.hud_tab_indices[$PokemonGlobal.ball_hud_item_type] = $PokemonGlobal.ball_hud_index
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

#===============================================================================
# ITEM sub-tabs are registered through HUDRegistry.register_item_tab (seeded
# at the bottom of this file) -- see that call for what source/skip_notebook/
# prepends/reset_to_start each do. get_item_box below reads the registry
# generically, so a newly-registered tab needs no change here.
#===============================================================================
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
	 # Was 5 near-identical "basicitems = ... if cur_item_hud==:X" lines, then
	 # 3 more if-blocks hand-deciding the Notebook/shortcut prepends per tab.
	 # HUDRegistry.item_tabs (registered at the bottom of this file) is now the only place
	 # a new ITEM tab needs to be described.
	 tab = HUDRegistry.item_tabs[cur_item_hud] || {}
	 basicitems = tab[:source] ? tab[:source].call.dup : []
     basicitems.sort_by! do |item|
      item.is_a?(ItemData) ? item.name : item.to_s
     end

	 basicitems.unshift(ItemData.new(:NOTEBOOK)) unless tab[:skip_notebook] || cur_item_hud==:FISHING
	 Array(tab[:prepends]&.call).reverse_each { |entry| basicitems.unshift(entry) }
     basicitems.unshift(:RADIAL)
     basicitems.unshift(:NONE)
	 
	 if (cur_item_hud==:WEAPONS || cur_item_hud==:BATTLE) && update_index==true && basicitems.length > 0 
	   index = basicitems.index(curItem)
	   $PokemonGlobal.ball_hud_weapon_index = index if index
	 
	 end
	 
    $PokemonGlobal.ball_order=basicitems
	 # Was 5 near-identical "if cur_item_hud==:X" blocks (one per tab,
	 # clamping a stale saved index and restoring it). PLACE is the one
	 # tab that resets to the start instead of the end when stale --
	 # everything else keeps that distinction via tab[:reset_to_start].
	 if update_index==true && basicitems.length > 0
	   idx = $PokemonGlobal.hud_tab_indices[cur_item_hud] || 0
	   if basicitems.length < idx
	     idx = tab[:reset_to_start] ? 0 : basicitems.length - 1
	   end
	   $PokemonGlobal.hud_tab_indices[cur_item_hud] = idx
	   $PokemonGlobal.ball_hud_index = idx
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
#===============================================================================
# Override modes are registered through HUDRegistry.register_override_mode
# (seeded at the bottom of this file). getCurrentItemOrder below reads the
# registry directly, so a newly-registered mode needs no change here.
#===============================================================================
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
  HUDRegistry.override_modes.each do |mode|
    send(mode[:build], update_index) if mode[:active].call
  end
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

#===============================================================================
# Seeding the built-ins through HUDRegistry -- not a special case, this is
# the exact API a new mode or tab would use. To add your own:
#
#   HUDRegistry.register_item_tab(:INTERACTION, source: -> { $bag.isInteractionItemInInventory })
#   HUDRegistry.insert_item_tab_in_cycle(:INTERACTION, after: :BATTLE)
#
#   HUDRegistry.register_override_mode(build: :get_interaction_picker, active: -> { ... })
#===============================================================================

# --- ITEM sub-tabs -----------------------------------------------------------
# source          - proc returning the tab's raw item list
# skip_notebook   - true if this tab should NOT get the Notebook prepended
#                   (original: WEAPONS, BATTLE, CROPS skip it)
# prepends        - proc returning extra entries to prepend, in the order
#                   the original's sequential unshift calls produced
# reset_to_start  - true if a stale saved index clamps to 0 instead of the
#                   tab's last index (original: only PLACE does this)
HUDRegistry.register_item_tab(:PLACE,   source: -> { $bag.isPlacableinInventory },   reset_to_start: true)
HUDRegistry.register_item_tab(:TOOL,    source: -> { $bag.isToolinInventory },       prepends: -> { [:BATTLE] })
HUDRegistry.register_item_tab(:WEAPONS, source: -> { $bag.isWeaponinInventory },     skip_notebook: true, prepends: -> { [:BATTLE] })
HUDRegistry.register_item_tab(:BATTLE,  source: -> { $bag.isBattleIteminInventory }, skip_notebook: true,
                               prepends: -> { [$game_temp.lockontarget == false ? :TOOL : :WEAPONS, :PKMN] })
HUDRegistry.register_item_tab(:CROPS,   source: -> { $bag.isCropIteminInventory },   skip_notebook: true)
HUDRegistry.register_item_tab(:INTERACTION, source: -> { $bag.isInteractionIteminInventory },     skip_notebook: true, prepends: -> { [:PET, :SPEAK] })

# --- ITEM sub-tab toggle cycle ------------------------------------------------
# PLACE->TOOL->WEAPONS->BATTLE->PLACE. CROPS also feeds back to PLACE but is
# deliberately not part of the forward cycle (reached only via the radial
# menu); toggling out of it returns to PLACE.
HUDRegistry.item_tab_cycle.merge!(
  PLACE:   :TOOL,
  TOOL:    :WEAPONS,
  WEAPONS: :BATTLE,
  BATTLE:  :PLACE,
  CROPS:   :TOOL,
)

# --- Top-level override modes -------------------------------------------------
# Order matters -- earlier entries take priority. Each was a 7-line chain
# repeating the same 5 boolean checks (favorites_enabled, alt_control_move,
# radial_enabled, cur_stored_pokemon, cur_stored_fishing_rod) in a different
# combination; same priority order, now data instead of copy-pasted
# conditions. Pushed directly, in exact original order, rather than through
# register_override_mode's before:-search (seeding needs an exact sequence;
# register_override_mode is for adding ONE new mode to an already-seeded
# list afterward, e.g. from a different file, which is what its `before:`
# default is designed for).
HUDRegistry.override_modes.push(
  { build: :get_moves,
    active: -> { $game_temp.favorites_enabled==false && $PokemonGlobal.alt_control_move==false && $game_temp.radial_enabled==false && !$PokemonGlobal.cur_stored_pokemon.nil? && $PokemonGlobal.cur_stored_fishing_rod.nil? } },
  { build: :get_multiselect,
    active: -> { $PokemonGlobal.alt_control_move==true && $game_temp.radial_enabled==false && $game_temp.favorites_enabled==false && $PokemonGlobal.cur_stored_pokemon.nil? && $PokemonGlobal.cur_stored_fishing_rod.nil? } },
  { build: :get_bait,
    active: -> { $game_temp.favorites_enabled==false && $PokemonGlobal.alt_control_move==false && $game_temp.radial_enabled==false && !$PokemonGlobal.cur_stored_fishing_rod.nil? && $PokemonGlobal.cur_stored_pokemon.nil? } },
  { build: :get_favorites,
    active: -> { $game_temp.favorites_enabled==true && $PokemonGlobal.alt_control_move==false && $game_temp.radial_enabled==false && $PokemonGlobal.cur_stored_pokemon.nil? && $PokemonGlobal.cur_stored_fishing_rod.nil? } },
  { build: :get_radial,
    active: -> { $game_temp.radial_enabled==true && $PokemonGlobal.alt_control_move==false && $game_temp.favorites_enabled==false && $PokemonGlobal.cur_stored_pokemon.nil? && $PokemonGlobal.cur_stored_fishing_rod.nil? } },
  { build: :get_pkmn_box,
    active: -> { $PokemonGlobal.ball_hud_type==:PKMN && $PokemonGlobal.alt_control_move==false && $game_temp.radial_enabled==false && $game_temp.favorites_enabled==false && $PokemonGlobal.cur_stored_pokemon.nil? && $PokemonGlobal.cur_stored_fishing_rod.nil? } },
  { build: :get_item_box,
    active: -> { $PokemonGlobal.ball_hud_type==:ITEM && $PokemonGlobal.alt_control_move==false && $game_temp.radial_enabled==false && $game_temp.favorites_enabled==false && $PokemonGlobal.cur_stored_pokemon.nil? && $PokemonGlobal.cur_stored_fishing_rod.nil? } },
)