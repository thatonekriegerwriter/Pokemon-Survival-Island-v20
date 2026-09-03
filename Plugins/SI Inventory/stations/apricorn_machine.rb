module InventoryScene
  module Stations
    # NOTE ON THE "MODIFIER" SLOT: the original read `@craft[4]` as a
    # "modifier_item" while producing the crafted result, and separately
    # did `inventory.delete_at(4)` inside get_recipe for :APRICORNMACHINE
    # specifically. But `delete_at(4)` ran on the ALREADY-SORTED,
    # already-normalized ingredient list, not on craft slot index 4
    # directly - so it was deleting whatever landed at position 4 after
    # sorting, not "the modifier slot". Combined with the fact that no
    # sprite was ever created for craft_slots[4] (rendering jumps straight
    # from slot 3 to the extra slot at index 5), slot 4 looks unreachable
    # through the UI entirely - I think this was a partially-removed or
    # never-finished feature, not something safe for me to guess back into
    # working order. I've reproduced the REACHABLE parts faithfully
    # (slots 0-3 as the recipe grid, slot 5 as a plain extra craft slot)
    # and left slot 4 out rather than inventing behavior for it - please
    # confirm what it's supposed to do before this ships.
    class ApricornMachine < BaseStation
      def initialize(event_data:, container:, machine: false)
        @machine = machine
        super(event_data:, container:)
      end

      def slot_count = 4
      def background_key = "APRICORNCRAFTING"
      def extra_slot_index = @machine ? 5 : nil
      def hides_result_highlight? = true

      private

      def render_station
        x = bonus_1 + 82
        y = bonus_2 + 36
        x2 = x3 = y2 = 0

        slot_count.times do |i|
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/placeholder_slot")
          sprites["craft_slots#{i}"].z = 70
          bonus = i > 1 ? 26 : 0
          x2 = x + bonus + i * SLOT_SIZE
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
        sprites["craft_slots_result"].y = bonus_2 + 82 - 8

        return unless extra_slot_index

        sprites["craft_slots#{extra_slot_index}"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots#{extra_slot_index}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/placeholder_slot")
        sprites["craft_slots#{extra_slot_index}"].z = 70
        sprites["craft_slots#{extra_slot_index}"].x = x3 + 176
        sprites["craft_slots#{extra_slot_index}"].y = y2 + 62 - 8
        render_slot_icon(:craft, extra_slot_index, *craft[extra_slot_index]) if craft[extra_slot_index]
      end
    end
  end
end
