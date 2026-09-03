module InventoryScene
  module Stations
    class OneSlotStation < BaseStation
      def initialize(event_data:, container:)
        super
      end
	  
	  def initial_craft_contents = nil#event_data.internal_storage
      def slot_count = 1
      def background_key = "OSS"
	 # def bonus_slot_function = :READ
      #def extra_slot_index = slot_count

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
        sprites["craft_slots0"].x = x
        sprites["craft_slots0"].y = y
        render_slot_icon(:craft, 0, *craft[0]) if craft[0]
		
		#render_bonus_slot
      end

      def render_bonus_slot
        index = extra_slot_index
        sprites["craft_slots#{index}"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots#{index}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/grinder/result_slot2")
        sprites["craft_slots#{index}"].z = 70
        sprites["craft_slots#{index}"].x = sprites["craft_slots_result"].x + 64
        sprites["craft_slots#{index}"].y = sprites["craft_slots_result"].y + 8
        render_slot_icon(:craft, index, *craft[index]) if craft[index]
      end
      def station_update
		event_data.update
        sync_slots_visuals!(:craft, 0..slot_count)
      end
    end
  end
end
