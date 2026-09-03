module InventoryScene
  module Stations
    class CraftingBench < BaseStation
      # slots:/bg: let this same layout stand in for the handful of types
      # that had a get_slot_amount entry but no setup_*_ui of their own
      # in the original (ELECTRICFURNACE, ELECTRICPRESS, SEWINGMACHINE) -
      # they fell through setup_ui's `else` to setup_craftingtable_ui too,
      # just with a different slot count.
      def initialize(event_data:, container:, upgraded: false, slots: nil, bg: nil)
        @upgraded = upgraded
        @slots_override = slots
        @bg_override = bg
        super(event_data:, container:)
      end

      def slot_count = @slots_override || (@upgraded ? 5 : 3)
      def background_key = @bg_override || (@upgraded ? "UPGRADEDCRAFTINGBENCH" : "CRAFTINGBENCH")

      private

      def render_station
        x = @upgraded ? bonus_1 + 56 : bonus_1 + 86
        y = bonus_2 + 56
        x2 = y2 = 0

        slot_count.times do |i|
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/craftingbench/placeholder_slot")
          sprites["craft_slots#{i}"].z = 70
          x2 = x + i * SLOT_SIZE
          y2 = y
          sprites["craft_slots#{i}"].x = x2
          sprites["craft_slots#{i}"].y = y2
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
        end

        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/craftingbench/equals")
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = x2 + 38
        sprites["craft_slots_equals"].y = y2 + 6

        sprites["craft_slots_result"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_result"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/craftingbench/result_slot")
        sprites["craft_slots_result"].z = 70
        sprites["craft_slots_result"].x = x2 + 66
        sprites["craft_slots_result"].y = y2 - 8
      end
    end
  end
end
