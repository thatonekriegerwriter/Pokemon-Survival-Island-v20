module InventoryScene
  module Stations
    class ItemCrate < BaseStation
      def slot_count = PCItemStorage::MAX_SIZE
      def background_key = "Inventory"
      def uses_recipe_grid? = false

      def initial_craft_contents = container.items

      def finalize_container
        container.items = craft
      end

      private

      def render_station
        y = bonus_2 + 16
        cols = 9

        slot_count.times do |i|
          col = i % cols
          row = i / cols
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot")
          sprites["craft_slots#{i}"].z = -2
          sprites["craft_slots#{i}"].x = start_x + col * SLOT_SIZE
          sprites["craft_slots#{i}"].y = y + row * SLOT_SIZE

          sprites["craft_slots_star#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots_star#{i}"].setBitmap("Graphics/Pictures/craftingMenu/star")
          sprites["craft_slots_star#{i}"].z = 9998
          sprites["craft_slots_star#{i}"].x = sprites["craft_slots#{i}"].x + 26
          sprites["craft_slots_star#{i}"].y = sprites["craft_slots#{i}"].y + 2
          sprites["craft_slots_star#{i}"].visible = false
          sprites["craft_slots_qstar#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots_qstar#{i}"].setBitmap("Graphics/Pictures/craftingMenu/redstar")
          sprites["craft_slots_qstar#{i}"].z = 9999
          sprites["craft_slots_qstar#{i}"].x = sprites["craft_slots#{i}"].x + 26
          sprites["craft_slots_qstar#{i}"].y = sprites["craft_slots#{i}"].y + 2
          sprites["craft_slots_qstar#{i}"].visible = false

          next unless craft[i]

          item, amt = craft[i]
          render_slot_icon(:craft, i, item, amt)
          sprites["craft_slots_star#{i}"].visible = $bag.registered?(item)
          sprites["craft_slots_qstar#{i}"].visible = quick_access_identical?(item)
        end

        sprites["cover"] = IconSprite.new(0, 0, viewport)
        sprites["cover"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/itemcrate/cover")
        sprites["cover"].z = 0
        sprites["cover"].x = bonus_1 - mamtx
        sprites["cover"].y = bonus_2 - (mamty + 12)
      end

      def station_update
	    container.update
		event_data.update
        sync_slots_visuals!(:craft, 0..slot_count)
      end
    end
  end
end

