module InventoryScene
  module Stations
    class GarbageBin < BaseStation
      def initialize(event_data:, container:)
        # Defensive sizing, matching PkmnCrate's precedent for
        # container.box.pokemon - if internal_storage isn't already
        # slot_count+1 long, pad it in place. No writer exists
        # (internal_storage is attr_reader-only, deliberately), but that's
        # fine - this mutates the array's contents, never reassigns the
        # reference itself.
        needed = slot_count + 1
        short_by = needed - event_data.internal_storage.length
        event_data.internal_storage.concat(Array.new(short_by)) if short_by.positive?
        super
      end
	  
	  def initial_craft_contents = event_data.internal_storage
      def slot_count = 1
      def background_key = "GARBAGEBIN"
	  def bonus_slot_function = :READ
      def extra_slot_index = slot_count

      # Matching the original's `if @type != :GARBAGEBIN` guard around the
      # "return craft contents to $bag" logic - whatever's dropped in
      # here is simply gone on exit.
      def finalize_container = nil

      private

      def render_station
        x = bonus_1 + 168
        y = bonus_2 + 60
        sprites["craft_slots0"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots0"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/placeholder_slot")
        sprites["craft_slots0"].z = 1
        sprites["craft_slots0"].x = x - 64
        sprites["craft_slots0"].y = y
        render_slot_icon(:craft, 0, *craft[0]) if craft[0]
		
		render_bonus_slot
      end

      def render_bonus_slot
        index = extra_slot_index
        sprites["craft_slots#{index}"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots#{index}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/grinder/result_slot2")
        sprites["craft_slots#{index}"].z = 70
        sprites["craft_slots#{index}"].x = sprites["craft_slots0"].x + 136
        sprites["craft_slots#{index}"].y = sprites["craft_slots0"].y
        render_slot_icon(:craft, index, *craft[index]) if craft[index]
      end
      def station_update
		event_data.update
        sync_slots_visuals!(:craft, 0..slot_count)
      end
    end
  end
end


module InventoryScene
  module Stations
    class Composter < GarbageBin
      def background_key = "COMPOSTER"
	end
  end
end 