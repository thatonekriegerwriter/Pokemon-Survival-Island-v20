module InventoryScene
  module Stations
    class Quarry < ButcherTable
      def initialize(event_data:, container:)
        needed = slot_count + 1
        short_by = needed - event_data.internal_storage.length
        event_data.internal_storage.concat(Array.new(short_by)) if short_by.positive?
        super
      end
	  
      def handle_object_click(object_key)
        return unless object_key == "assign_button"
        toggle_connection_mode
      end 
	  
	  def bonus_slot_function = nil
      def station_can_afford_extra_cost?
	    true 
      end

      def on_craft_consumed(_recipe)
	    true 
      end
  
	  def initial_craft_contents = event_data.internal_storage
      def slot_count = 16
      def background_key = "QUARRY"
      def craft_slots_hold_pokemon? = false


	  def can_drop?(kind, index)
	    item = grabbed_item.item
	    return false if kind == :craft
		return true 
	  end 

      def craft
        @craft_proxy ||= event_data.internal_storage
      end
	  
      # Matching the original's `if @type != :GARBAGEBIN` guard around the
      # "return craft contents to $bag" logic - whatever's dropped in
      # here is simply gone on exit.
      def finalize_container = nil

      private

      def render_station
        x = bonus_1 + 38
        y = bonus_2 + 74
        x2 = y2 = 0

        slot_count.times do |i|
          row = i / 8
          col = i % 8
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/butchertable/placeholder_slot")
          sprites["craft_slots#{i}"].z = -2
          x2 = x + col * SLOT_SIZE
          y2 = y + row * SLOT_SIZE
          sprites["craft_slots#{i}"].x = x2
          sprites["craft_slots#{i}"].y = y2 - 14 
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
        end
        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = x2 + 47 - 16
        sprites["craft_slots_equals"].y = y2 - 88
        create_text_centered("output_text", "In: #{event_data.average_power_input} EU/s", 60, 60)
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
        objects["assign_button"].x = bonus_1 + 250
        objects["assign_button"].y = bonus_2 + 30
        objects["assign_button"].z = 0
        objects["assign_button"].visible = true
        text = connecting_power? ? "Connecting..." : "Connect"
        create_text_centered("current_task_label", text, objects["assign_button"].x + 44, objects["assign_button"].y + 12)
        refresh_assign_button
      end
	  
      def refresh_assign_button
        bitmap = connecting_power? ? "smallbutton_down" : "smallbutton_up"
        text = connecting_power? ? "Connecting..." : "Connect"
        objects["assign_button"].setBitmap("Graphics/Pictures/craftingMenu/#{bitmap}")
        objects["assign_button"].visible = true 
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
        sync_slots_visuals!(:craft, 0..slot_count)
		refresh_assign_button
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
      end
    end
  end
end