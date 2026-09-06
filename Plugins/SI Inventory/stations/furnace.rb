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
	  def can_drop?(kind, index)
	    item = grabbed_item.item
        store = backing_store_for(kind)
        slot = store[index]
	    return false if kind == :craft && index == 1 && (!item.is_a?(ItemData) || !FUEL_HASH.keys.include?(item.id))
		return true 
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
          sprites["craft_slots#{i}"].y = y + i * (SLOT_SIZE + 10)
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

module InventoryScene
  module Stations
    # Slot 0 is a normal recipe ingredient; slot 1 is fuel, not part of
    # the recipe - feeding it tops up event_data.fuel instead of joining
    # the grid. That's the only thing genuinely furnace-specific here.
    class ElectricFurnace < Furnace


      def slot_count = 2
      def background_key = "ELECTRICFURNACE"
      def recipe_matching_slots = [craft[0]]
      def recipe_station_key = :FURNACE

      def station_can_afford_extra_cost?
        event_data.power - 30 >= 0
      end

      def on_craft_consumed(_recipe)
        event_data.power -= 30
      end

      def handle_station_click(kind, index)
        return unless kind == :craft && index == 1 && craft[1]

      end

      def handle_object_click(object_key)
        return unless object_key == "assign_button"
 
        toggle_connection_mode
      end 
	  
	  def can_drop?(kind, index)
	    item = grabbed_item.item
        store = backing_store_for(kind)
        slot = store[index]
	    return false if kind == :craft && index==1 && (!item.is_a?(ItemData) || !item.data.is_battery?)
		return true 
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
          sprites["craft_slots#{i}"].y = y + i * (SLOT_SIZE + 10)
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
        end

        last = sprites["craft_slots#{slot_count - 1}"]
        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = last.x + 74
        sprites["craft_slots_equals"].y = last.y - 16

        sprites["craft_slots_result"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_result"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/furnace/result_slot")
        sprites["craft_slots_result"].z = 70
        sprites["craft_slots_result"].x = last.x + 136
        sprites["craft_slots_result"].y = last.y - 30
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

      # The original's `fuel(stack)` method - feeding fuel tops up
      # event_data.fuel and clears the slot instead of joining the recipe.
      def add_fuel(stack)
        item, amt = stack
      end
    end
  end
end


module InventoryScene
  module Stations
    # Slot 0 is a normal recipe ingredient; slot 1 is fuel, not part of
    # the recipe - feeding it tops up event_data.fuel instead of joining
    # the grid. That's the only thing genuinely furnace-specific here.
    class CoalGenerator < Furnace
	POWER_HASH = {
     CHARCOAL: 0.75, COAL: 1.5, ACORN: 0.09375, WOODENLOG: 0.375,
     WOODENSTICKS: 0.09375, WOODENPLANKS: 0.1875, HEATROCK: 3, FIRESTONE: 6
    }.freeze


      def slot_count = 2
      def background_key = "COALGENERATOR"
      def recipe_matching_slots = []
      def uses_recipe_grid?           = false 

      def handle_station_click(kind, index)
        return unless kind == :craft && index == 1 && craft[1]

        add_fuel(craft[1])
      end

      def handle_object_click(object_key)
        return unless object_key == "assign_button"
 
        toggle_connection_mode
      end 
	  
	  def can_drop?(kind, index)
	    item = grabbed_item.item
        store = backing_store_for(kind)
        slot = store[index]
	    return false if kind == :craft && index == 1 && (!item.is_a?(ItemData) || !POWER_HASH.keys.include?(item.id))
	    return false if kind == :craft && index == 0 && (!item.is_a?(ItemData) || !item.data.is_battery?)
		return true 
	  end 
	  
	  
      private

      def render_station
        x = bonus_1 + 26
        y = bonus_2 + 20
        slot_count.times do |i|
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/furnace/placeholder_slot")
          sprites["craft_slots#{i}"].z = 70
          sprites["craft_slots#{i}"].x = x + SLOT_SIZE
          sprites["craft_slots#{i}"].y = y + i * (SLOT_SIZE + SLOT_SIZE)
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
        end

        last = sprites["craft_slots#{slot_count - 1}"]
        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = last.x + 4
        sprites["craft_slots_equals"].y = last.y + 4 - SLOT_SIZE

		render_assign_button
		render_power_display
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
	  
      def render_power_display
        x = bonus_1 + 130
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
		create_text_centered("power_text", "#{event_data.power.round(2)}/#{event_data.internal_battery_limit}", x + 40, y - 2)
        create_text_centered("output_text", "Out: #{event_data.average_power_output} EU/s", x + 116, y + 60)
		update_power_display
      end


      def station_update
		event_data.update
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
        update_power_display
		refresh_assign_button
      end


      def update_power_display
		bar = sprites["power_bar"]
		fill = sprites["power_bar_fill"]
		return unless bar && fill

		power = [event_data.power, 0.0].max
		limit = [event_data.internal_battery_limit, 0.0].max

		ratio = limit > 0 ? [[power.to_f / limit, 0.0].max, 1.0].min : 0.0

		bitmap = fill.bitmap
		bitmap.clear

		width = (138 * ratio).to_i
        bitmap.fill_rect(0,0,width,24,Color.new(255, 16, 0)) if width > 0
        update_text_centered("power_text", "#{power.round(2)} / #{limit}")
        update_text_centered("output_text", "Out: #{event_data.average_power_output} EU/s")
      end

      # The original's `fuel(stack)` method - feeding fuel tops up
      # event_data.fuel and clears the slot instead of joining the recipe.
      def add_fuel(stack)
        item, amt = stack
        base = POWER_HASH[item.id]
        return unless base

        event_data.fuel = [event_data.fuel + base * amt, 100.0].min
        craft[1] = nil
        remove_slot_icon(:craft, 1)
      end
    end
  end
end