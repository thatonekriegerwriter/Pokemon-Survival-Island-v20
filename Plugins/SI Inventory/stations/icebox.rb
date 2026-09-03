module InventoryScene
  module Stations
    class Icebox < BaseStation

      def slot_count = IceBoxStorage::MAX_SIZE
      def background_key = "Inventory"
      def uses_recipe_grid? = false

      def initial_craft_contents = container.items

      def finalize_container
        container.items = craft
      end

      private

      # NOTE: matching the original, slots beyond `container.maxsize` are
      # drawn with the "disabled" bitmap but are NOT actually blocked from
      # receiving items in click handling (the original only added that
      # guard for bag slots, not crate/icebox slots) - possibly a bug
      # worth checking rather than something I should silently "fix" here.
      def render_station
        y = bonus_2 + 16
        cols = 9

        slot_count.times do |i|
          col = i % cols
          row = i / cols
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          bitmap = i < available ? "Graphics/Pictures/craftingMenu/placeholder_slot" : "Graphics/Pictures/craftingMenu/placeholder_slot_2"
          sprites["craft_slots#{i}"].setBitmap(bitmap)
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
    end
  end
end
