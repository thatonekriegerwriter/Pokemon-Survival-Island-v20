module InventoryScene
  module Stations
    class MedicinePot < BaseStation
      def slot_count = 5
      def background_key = "MEDICINEPOT"

      private

      def render_station
        x = bonus_1 + 77
        y = bonus_2 + 30
        x2 = x3 = y2 = 0

        slot_count.times do |i|
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/placeholder_slot")
          sprites["craft_slots#{i}"].z = 70
          x2 = x + i * SLOT_SIZE
          x3 = x2 if i < 2
          y2 = y
          sprites["craft_slots#{i}"].x = x2
          sprites["craft_slots#{i}"].y = y2
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
        end

        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/equals")
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = x3 + 47 - 20
        sprites["craft_slots_equals"].y = y2 + 22 - 8

        sprites["craft_slots_result"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_result"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/result_slot")
        sprites["craft_slots_result"].z = 70
        sprites["craft_slots_result"].x = bonus_1 + 161 - 20
        sprites["craft_slots_result"].y = bonus_2 + 82 + 2 - 8
      end
    end
  end
end
