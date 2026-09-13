module InventoryScene
  module Stations
    class ApricornMachine < BaseStation
      def initialize(event_data:, container:, machine: false)
        @machine = machine
        needed = slot_count + 1
        short_by = needed - event_data.internal_storage.length
        event_data.internal_storage.concat(Array.new(short_by)) if short_by.positive?
		
        super(event_data:, container:)
      end
      

      def recipe_matching_slots = craft[0...slot_count]
      def initial_craft_contents = event_data.internal_storage
      def finalize_container
        unless @machine
          craft.each { |data| $bag.add(data[0], data[1]) if data }
        end
      end
	  
      def handle_object_click(object_key)
	    return unless @machine
        return unless object_key == "assign_button"
 
        toggle_connection_mode
      end 
	  
      def station_can_afford_extra_cost?
	    return true unless @machine
        event_data.power - 60 >= 0
      end

      def on_craft_consumed(_recipe)
	    return unless @machine
        event_data.power -= 60
      end

      def slot_count = 4
      def background_key = "APRICORNCRAFTING" #THIS IS OUR CRAFTING KEY
      def extra_slot_index = @machine ? 4 : nil
	  def bonus_slot_function = :READ
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
        unless @machine 
        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/equals")
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = x3 + 47 - 20
        sprites["craft_slots_equals"].y = y2 + 22 - 8
        else
        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = x3 + 160
        sprites["craft_slots_equals"].y = y2
		end 
        sprites["craft_slots_result"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_result"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/result_slot")
        sprites["craft_slots_result"].z = 70
        sprites["craft_slots_result"].x = bonus_1 + 161 - 20
        sprites["craft_slots_result"].y = bonus_2 + 82 - 8

		render_assign_button if @machine 
        return unless extra_slot_index

        sprites["craft_slots#{extra_slot_index}"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots#{extra_slot_index}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pokeball/placeholder_slot")
        sprites["craft_slots#{extra_slot_index}"].z = 70
        sprites["craft_slots#{extra_slot_index}"].x = x3 + 176
        sprites["craft_slots#{extra_slot_index}"].y = y2 + 62 - 8
        render_slot_icon(:craft, extra_slot_index, *craft[extra_slot_index]) if craft[extra_slot_index]
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
        objects["assign_button"].x = bonus_1 + 200
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
	    return unless @machine
		event_data.update
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
		refresh_assign_button
      end
	  


    end
  end
end
