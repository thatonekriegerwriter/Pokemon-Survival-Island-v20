module InventoryScene
  module Stations
    # The original's setup_ui had an explicitly empty `when :MACHINEBOX`
    # branch - no craft slots, no result. Whatever this station is for,
    # it's evidently just bag + party access with no recipe grid.
    class MachineBox < BaseStation
      def initialize(event_data:, container:)
        needed = slot_count + 1
        short_by = needed - event_data.internal_storage.length
        event_data.internal_storage.concat(Array.new(short_by)) if short_by.positive?
        super
      end
      def slot_count = 5
      def background_key = "MACHINEBOX"
      def uses_recipe_grid? = false
      def shows_search_ui? = false
      def initial_craft_contents = event_data.internal_storage
	  
	  def craft
	    event_data.internal_storage
	  end 
      def handle_object_click(object_key)
        return unless object_key == "assign_button"
 
        toggle_connection_mode
      end 
	  
      private


      def render_station

        slot_count.times do |i|
		  i < 2 ? render_charge_slots(i) : render_upgrade_slots(i)
        end
        render_power_display
		render_assign_button
      end
      
	  def render_charge_slots(i)
          x = bonus_1 + 46
          y = bonus_2 + 35
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap(
            "Graphics/Pictures/craftingMenu/newCraftingPages/pocket/placeholder_slot"
          )
          sprites["craft_slots#{i}"].z = 70
          sprites["craft_slots#{i}"].x = x
          sprites["craft_slots#{i}"].y = y + i * (SLOT_SIZE + 12)

          render_slot_icon(:craft, i, *craft[i]) if craft[i]
	  end
	  
	  def render_upgrade_slots(i)
        x = bonus_1 + 300
        y = bonus_2 + 22
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap(
            "Graphics/Pictures/craftingMenu/newCraftingPages/pocket/placeholder_slot"
          )
          sprites["craft_slots#{i}"].z = 70
          sprites["craft_slots#{i}"].x = x
          sprites["craft_slots#{i}"].y =  y + (i - 2) * SLOT_SIZE
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
	  end 

      def render_assign_button
        objects["assign_button"] = IconSprite.new(0, 0, viewport)
        objects["assign_button"].x = bonus_1 + 110
        objects["assign_button"].y = bonus_2 + 116
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
      def render_power_display
        x = bonus_1 + 110
        y = bonus_2 + 48

        sprites["power_bar"] = IconSprite.new(0, 0, viewport)
        sprites["power_bar"].setBitmap(
          "Graphics/Pictures/craftingMenu/newCraftingPages/machinebox/power_bar"
        )
        sprites["power_bar"].z = 70
        sprites["power_bar"].x = x
        sprites["power_bar"].y = y

        sprites["power_bar_fill"] = IconSprite.new(0, 0, viewport)
        sprites["power_bar_fill"].bitmap = Bitmap.new(
          sprites["power_bar"].bitmap.width,
          sprites["power_bar"].bitmap.height
        )
        sprites["power_bar_fill"].z = 71
        sprites["power_bar_fill"].x = x + 10
        sprites["power_bar_fill"].y = y + 10
		create_text_centered("power_text", "#{event_data.power}/#{event_data.internal_battery_limit}", x + 40, y - 2)
        create_text_centered("output_text", "Out: #{event_data.average_power_output} EU/s", x + 116, y + 60)
		update_power_display
      end

      def station_update
        event_data.update
        sync_slots_visuals!(:craft, 0..slot_count)
        update_power_display
		refresh_assign_button
      end

      def update_power_display
		bar = sprites["power_bar"]
		fill = sprites["power_bar_fill"]
		return unless bar && fill

		power = [event_data.power, 0].max
		limit = [event_data.internal_battery_limit, 0].max

		ratio = limit > 0 ? [[power.to_f / limit, 0.0].max, 1.0].min : 0.0

		bitmap = fill.bitmap
		bitmap.clear

		width = (138 * ratio).to_i
        bitmap.fill_rect(0,0,width,24,Color.new(255, 16, 0)) if width > 0
        update_text_centered("power_text", "#{power} / #{limit}")
        update_text_centered("output_text", "Out: #{event_data.average_power_output} EU/s")
      end

    end
  end
end
