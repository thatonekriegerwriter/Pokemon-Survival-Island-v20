module InventoryScene
  module Stations
    class ButcherTable < BaseStation
      def initialize(event_data:, container:)
        needed = slot_count + 1
        short_by = needed - event_data.internal_storage.length
        event_data.internal_storage.concat(Array.new(short_by)) if short_by.positive?
        super
      end
	  
	  def initial_craft_contents = event_data.internal_storage
      def slot_count = 8
      def background_key = "BUTCHERTABLE"
	  def bonus_slot_function = :WRITE
      def craft_slots_hold_pokemon? = true
      def extra_slot_index = slot_count
      def extra_slot_result_sized?    = true



      def pokemon_box
        @pokemon_box_proxy ||= event_data.internal_storage
      end
	  
      # Matching the original's `if @type != :GARBAGEBIN` guard around the
      # "return craft contents to $bag" logic - whatever's dropped in
      # here is simply gone on exit.
      def finalize_container = nil

      private

      def render_station
        x = bonus_1 + 38
        y = bonus_2 + 92
        x2 = y2 = 0

        slot_count.times do |i|
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/butchertable/placeholder_slot")
          sprites["craft_slots#{i}"].z = -2
          x2 = x + i * SLOT_SIZE
          y2 = y
          sprites["craft_slots#{i}"].x = x2
          sprites["craft_slots#{i}"].y = y2
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
        end
		
		render_bonus_slot
      end

      def render_bonus_slot
        x = sprites["craft_slots4"].x - 26
        y = bonus_2 + 20
        index = extra_slot_index
        sprites["craft_slots#{index}"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots#{index}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/butchertable/result_slot")
        sprites["craft_slots#{index}"].z = -2
        sprites["craft_slots#{index}"].x = x
        sprites["craft_slots#{index}"].y = y
        render_pokemon_icon(:craft, index, pokemon_box[index]) if pokemon_box[index]
      end
      def station_update
	    
		event_data.update
        sync_slots_visuals!(:craft, 0..slot_count)
      end
    end
  end
end
