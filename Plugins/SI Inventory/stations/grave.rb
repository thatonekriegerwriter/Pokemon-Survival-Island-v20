module InventoryScene
  module Stations
    class Grave < BaseStation
      def initialize(event_data:, container:)
        needed = slot_count
        short_by = needed - event_data.internal_storage.length
        event_data.internal_storage.concat(Array.new(short_by)) if short_by.positive?
        super
      end
	  
	  def initial_craft_contents = event_data.internal_storage
      def slot_count = 1
      def background_key = "GRAVE"
      def craft_slots_hold_pokemon? = true
	  def bonus_slot_function = :WRITE
      def extra_slot_index = 0

      def pokemon_box
        @pokemon_box_proxy ||= event_data.internal_storage
      end
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
        render_pokemon_icon(:craft, 0, pokemon_box[0]) if pokemon_box[0]
		
		#render_bonus_slot
      end

      def station_update
		event_data.update
        sync_slots_visuals!(:craft, 0..slot_count)
      end
    end
  end
end
