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
      def slot_count = 2
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
		  render_charge_slots(i)
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
	  
      def render_assign_button
        objects["assign_button"] = IconSprite.new(0, 0, viewport)
        objects["assign_button"].x = bonus_1 + 110
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
		create_text_centered("power_text", "#{event_data.power.round(2)}/#{event_data.internal_battery_limit}", x + 40, y - 2)
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
        update_text_centered("power_text", "#{power.round(2)} / #{limit}")
        update_text_centered("output_text", "Out: #{event_data.average_power_output} EU/s")
      end

    end
  end
end

module InventoryScene
  module Stations
    # The original's setup_ui had an explicitly empty `when :MACHINEBOX`
    # branch - no craft slots, no result. Whatever this station is for,
    # it's evidently just bag + party access with no recipe grid.
    class FuellessGenerators < MachineBox
      def slot_count = 0
      def background_key = "FUELLESSGENERATORS"
	  
	  
      private

      def render_assign_button
        objects["assign_button"] = IconSprite.new(0, 0, viewport)
        objects["assign_button"].x = bonus_1 + 110
        objects["assign_button"].y = bonus_2 + 120
        objects["assign_button"].z = 0
        objects["assign_button"].visible = true
        text = connecting_power? ? "Connecting..." : "Connect"
        create_text_centered("current_task_label", text, objects["assign_button"].x + 44, objects["assign_button"].y + 12)
        refresh_assign_button
      end

      def render_power_display
	    return 
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
		create_text_centered("power_text", "#{event_data.power.round(2)}/#{event_data.internal_battery_limit}", x + 40, y - 2)
        create_text_centered("output_text", "Out: #{event_data.average_power_output} EU/s", x + 116, y + 60)
		update_power_display
      end

      def station_update
        event_data.update
       # sync_slots_visuals!(:craft, 0..slot_count)
       # update_power_display
		refresh_assign_button
      end

    end
  end
end


module InventoryScene
  module Stations
    class WaterMachines < FuellessGenerators
      def slot_count = 0
      def tank_count = 1
      def background_key = "FUELLESSGENERATORS"
      def handle_object_click(object_key)
        toggle_connection_mode if object_key == "assign_button"
        toggle_wconnection_mode if object_key == "water_button"
        tank_clicked(object_key) if object_key.match?(/\Atank_slot_\d+\z/)
      end 
	  
	  
      private
      def render_station

        slot_count.times do |i|
		  i < 2 ? render_charge_slots(i) : render_upgrade_slots(i)
        end
        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = 261
        sprites["craft_slots_equals"].y = 44
        tank_count.times do |i|
          render_tank(i)
        end
        render_power_display
		render_assign_button
		render_water_button
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

      def render_tank(i)
        x = tank_count == 1 ? bonus_1 + 86 : bonus_1 + 46 + (i * 70)
        y = bonus_2 + 24

        objects["tank_slot_#{i}"] = IconSprite.new(0, 0, viewport)
        objects["tank_slot_#{i}"].x = x
        objects["tank_slot_#{i}"].y = y
        objects["tank_slot_#{i}"].z = 0
        objects["tank_slot_#{i}"].setBitmap(
          "Graphics/Pictures/craftingMenu/tank_slot"
        )

        objects["tank_slot_#{i}_fluid"] = IconSprite.new(0, 0, viewport)
        objects["tank_slot_#{i}_fluid"].x = x
        objects["tank_slot_#{i}_fluid"].y = y
        objects["tank_slot_#{i}_fluid"].z = 1

        objects["tank_slot_#{i}_overlay"] = IconSprite.new(0, 0, viewport)
        objects["tank_slot_#{i}_overlay"].x = x
        objects["tank_slot_#{i}_overlay"].y = y
        objects["tank_slot_#{i}_overlay"].z = 2
        objects["tank_slot_#{i}_overlay"].setBitmap(
          "Graphics/Pictures/craftingMenu/tank_slot_overlay"
        )
      end


      def refresh_tanks
        tank_count.times do |i|
          refresh_tank(i)
        end
      end
      def refresh_tank(i)
        main_fluid_sprite = objects["tank_slot_#{i}"]
        fluid_sprite = objects["tank_slot_#{i}_fluid"]
        return unless fluid_sprite

        amount_per_tank = event_data.internal_water_storage.to_f
		water = i == 0 ? event_data.water : event_data.secondary_water
		fluid_type = i == 0 ? event_data.fluid_type : event_data.secondary_fluid_type
        tank_amount = [[water, 0.0].max, amount_per_tank].min

        if tank_amount <= 0 || fluid_type.nil?
          fluid_sprite.visible = false
          return
        end

        fluid_sprite.visible = true

        # The fluid graphic is expected to represent a full tank.
        # Its height is cropped according to the amount contained.
        bitmap = Bitmap.new(
          main_fluid_sprite.bitmap.width,
          main_fluid_sprite.bitmap.height
        )

        ratio = tank_amount / amount_per_tank
        height = (bitmap.height * ratio).to_i

        source_rect = Rect.new(
          0,
          bitmap.height - height,
          bitmap.width,
          height
        )

        bitmap.blt(
          0,
          bitmap.height - height,
          fluid_bitmap(fluid_type),
          source_rect
        )

        fluid_sprite.bitmap.dispose if fluid_sprite.bitmap
        fluid_sprite.bitmap = bitmap
      end

      def fluid_bitmap(fluid_type)
        path = "Graphics/Pictures/craftingMenu/fluids/#{fluid_type.to_s}"
        path = "Graphics/Pictures/craftingMenu/fluids/WATER" unless pbResolveBitmap(path)
        Bitmap.new(path)
      end
      def tank_clicked(object_key)
        return unless object_key.match?(/\Atank_slot_\d+\z/)
        index = object_key.split("_").last.to_i
		puts index
        # Tank interaction goes here.
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
      def render_water_button
        objects["water_button"] = IconSprite.new(0, 0, viewport)
        objects["water_button"].x = bonus_1 + 192
        objects["water_button"].y = bonus_2 + 120
        objects["water_button"].z = 0
        objects["water_button"].visible = true
        text = connecting_pipe? ? "Routing..." : "Route Pipe"
        create_text_centered("current_water_label", text, objects["water_button"].x + 44, objects["water_button"].y + 12)
        refresh_water_button
      end


	  
      def refresh_water_button
        bitmap = connecting_pipe? ? "smallbutton_down" : "smallbutton_up"
        objects["water_button"].setBitmap("Graphics/Pictures/craftingMenu/#{bitmap}")
        objects["water_button"].visible = true 
        text = connecting_pipe? ? "Routing..." : "Route Pipe"
		update_text_centered("current_water_label", text)
      end

      def toggle_wconnection_mode
 
        if connecting_pipe?
          $game_temp.piping_mode = false
          $game_temp.piping_source = nil
        else
          $game_temp.piping_mode = true
          $game_temp.piping_source = event_data
        end
        refresh_water_button
      end
	  
	  def connecting_pipe?
        $game_temp.piping_mode && $game_temp.piping_source.equal?(event_data)
	  end 

      def render_power_display
	    return 
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
		create_text_centered("power_text", "#{event_data.power.round(2)}/#{event_data.internal_battery_limit}", x + 40, y - 2)
        create_text_centered("output_text", "Out: #{event_data.average_power_output} EU/s", x + 116, y + 60)
		update_power_display
      end

      def station_update
        event_data.update
       # sync_slots_visuals!(:craft, 0..slot_count)
       # update_power_display
		refresh_assign_button
		refresh_water_button
        refresh_tanks
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
      end

    end

    class AdvancedWaterMachines < WaterMachines
     def tank_count = 2
    end
  end
end

