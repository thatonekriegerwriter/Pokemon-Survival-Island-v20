module InventoryScene
  module Stations
    class Cauldron < BaseStation
      def slot_count = 3
      def background_key = "CAULDRON"
      def hides_result_highlight? = true

      private

      def render_station
        x = bonus_1 + 56
        y = bonus_2 + 56
        pos = [[114, -30], [44, 18], [184, 18]]
        x2 = y2 = 0

        slot_count.times do |i|
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/cauldron/placeholder_slot")
          sprites["craft_slots#{i}"].z = 70
          x2 = x + pos[i][0]
          y2 = y + pos[i][1]
          sprites["craft_slots#{i}"].x = x2
          sprites["craft_slots#{i}"].y = y2
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
        end

        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/cauldron/equals")
        sprites["craft_slots_equals"].x = x2 + 38
        sprites["craft_slots_equals"].y = y2 + 6
        sprites["craft_slots_equals"].z = 70

        sprites["craft_slots_result"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_result"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/cauldron/result_slot")
        sprites["craft_slots_result"].x = x + 106
        sprites["craft_slots_result"].y = y + 10
        sprites["craft_slots_result"].z = 70
      end
    end
  end
end
