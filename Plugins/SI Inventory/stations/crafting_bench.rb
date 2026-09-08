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


module InventoryScene
  module Stations
    class ElectricCraftingBench < CraftingBench
      # slots:/bg: let this same layout stand in for the handful of types
      # that had a get_slot_amount entry but no setup_*_ui of their own
      # in the original (ELECTRICFURNACE, ELECTRICPRESS, SEWINGMACHINE) -
      # they fell through setup_ui's `else` to setup_craftingtable_ui too,
      # just with a different slot count.
      def initialize(event_data:, container:, upgraded: false, slots: nil, bg: nil, power_cost: nil)
        @power_cost = power_cost 
        @power_cost = 1 if @power_cost.nil?
        super(event_data:, container:, upgraded:, slots:, bg:)
      end

      def handle_object_click(object_key)
        return unless object_key == "assign_button"
 
        toggle_connection_mode
      end 
	  
      def station_can_afford_extra_cost?
        event_data.power - @power_cost >= 0
      end

      def on_craft_consumed(_recipe)
        event_data.power -= @power_cost
      end
	  
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
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = x2 + 38
        sprites["craft_slots_equals"].y = y2 + 6

        sprites["craft_slots_result"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_result"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/craftingbench/result_slot")
        sprites["craft_slots_result"].z = 70
        sprites["craft_slots_result"].x = x2 + 66
        sprites["craft_slots_result"].y = y2 - 8
		render_assign_button
      end


      def fuel_bitmap
        base = RPG::Cache.load_bitmap(
          "Graphics/Pictures/craftingMenu/newCraftingPages/",
          "electric_off"
        )

        burning = RPG::Cache.load_bitmap(
          "Graphics/Pictures/craftingMenu/newCraftingPages/",
          "electric_on"
        )

        bitmap = Bitmap.new(base.width, base.height)

        bitmap.blt(
          0, 0,
          base,
          Rect.new(0, 0, base.width, base.height)
        )

        fuel = [[event_data.power, 0].max, 20].min
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

      def render_assign_button
        objects["assign_button"] = IconSprite.new(0, 0, viewport)
        objects["assign_button"].x = bonus_1 + 268
        objects["assign_button"].y = bonus_2 + 120
        objects["assign_button"].z = 0
        objects["assign_button"].visible = true
        text = connecting_power? ? "Connecting..." : "Connect"
        create_text_centered("current_task_label", text, objects["assign_button"].x + 44, objects["assign_button"].y + 12)
        refresh_assign_button
      end
	  
      def refresh_assign_button
        bitmap = connecting_power? ? "smallbutton_down" : "smallbutton_up"
        objects["assign_button"].setBitmap("Graphics/Pictures/craftingMenu/#{bitmap}")
        objects["assign_button"].visible = true 
        text = connecting_power? ? "Connecting..." : "Connect"
		update_text_centered("current_task_label", text)
      end

      def toggle_connection_mode
 
        if connecting_power?
          $game_temp.connection_mode = false
          $game_temp.connection_source = nil
        else
          $game_temp.connection_mode = true
          $game_temp.connection_source = event_data
        end
        refresh_assign_button
      end

	  def connecting_power?
        $game_temp.connection_mode && $game_temp.connection_source.equal?(event_data)
	  end 

      def station_update
		event_data.update
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
		refresh_assign_button
      end
	  
    end
  end
end