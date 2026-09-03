module InventoryScene
  module Stations
    # Slot 0 is a normal recipe ingredient; slot 1 is fuel, not part of
    # the recipe - feeding it tops up event_data.fuel instead of joining
    # the grid. That's the only thing genuinely furnace-specific here.
    class Furnace < BaseStation
      FUEL_HASH = {
        CHARCOAL: 4, COAL: 8, ACORN: 0.5, WOODENLOG: 2,
        WOODENSTICKS: 0.5, WOODENPLANKS: 1, HEATROCK: 16, FIRESTONE: 32
      }.freeze

      def slot_count = 2
      def background_key = "FURNACE"
      def recipe_matching_slots = [craft[0]]

      def station_can_afford_extra_cost?
        event_data.fuel - 1 >= 0
      end

      def on_craft_consumed(_recipe)
        event_data.fuel -= 1
      end

      def handle_station_click(kind, index)
        return unless kind == :craft && index == 1 && craft[1]

        add_fuel(craft[1])
      end

      private

      def render_station
        x = bonus_1 + 56
        y = bonus_2 + 37
        slot_count.times do |i|
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/furnace/placeholder_slot")
          sprites["craft_slots#{i}"].z = 70
          sprites["craft_slots#{i}"].x = x + SLOT_SIZE
          sprites["craft_slots#{i}"].y = y + i * SLOT_SIZE
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
        end

        last = sprites["craft_slots#{slot_count - 1}"]
        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = last.x + 68
        sprites["craft_slots_equals"].y = last.y - 12

        sprites["craft_slots_result"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_result"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/furnace/result_slot")
        sprites["craft_slots_result"].z = 70
        sprites["craft_slots_result"].x = last.x + 136
        sprites["craft_slots_result"].y = last.y - 24
      end

      def fuel_bitmap
        base = RPG::Cache.load_bitmap(
          "Graphics/Pictures/craftingMenu/newCraftingPages/furnace/",
          "equals"
        )

        burning = RPG::Cache.load_bitmap(
          "Graphics/Pictures/craftingMenu/newCraftingPages/furnace/",
          "equals_burning"
        )

        bitmap = Bitmap.new(base.width, base.height)

        bitmap.blt(
          0, 0,
          base,
          Rect.new(0, 0, base.width, base.height)
        )

        fuel = [[event_data.fuel, 0].max, 20].min
        height = (burning.height * fuel / 20.0).ceil

        if height > 0
          bitmap.blt(
            0,
            burning.height - height,
            burning,
            Rect.new(
              0,
              burning.height - height,
              burning.width,
              height
            )
          )
        end

        bitmap
      end

      def station_update
		event_data.update
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
      end

      # The original's `fuel(stack)` method - feeding fuel tops up
      # event_data.fuel and clears the slot instead of joining the recipe.
      def add_fuel(stack)
        item, amt = stack
        base = FUEL_HASH[item.id]
        return unless base

        event_data.fuel = [event_data.fuel + base * amt, 100.0].min
        craft[1] = nil
        remove_slot_icon(:craft, 1)
      end
    end
  end
end
