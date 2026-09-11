module InventoryScene
  module Stations
    class Sifter < ButcherTable
      def initialize(event_data:, container:, machine: false)
        needed = slot_count + 1
        short_by = needed - event_data.internal_storage.length
        event_data.internal_storage.concat(Array.new(short_by)) if short_by.positive?
        @machine = machine
        super(event_data:, container:)
      end
	  
      def handle_object_click(object_key)
        return unless object_key == "assign_button"
 
        @machine ? toggle_connection_mode : click_item
      end 
	  
	  def bonus_slot_function = nil
      def station_can_afford_extra_cost?
	    if @machine
         return event_data.power - 60 >= 0
		else
         return $player.playerstamina - 2 >= 0
		end 
      end

      def on_craft_consumed(_recipe)
	    if @machine
        event_data.power -= 60
		else
        $player.playerstamina -= 2
		end 
      end
  
	  def initial_craft_contents = event_data.internal_storage
      def slot_count = 8
      def background_key = "SIFTER"
      def craft_slots_hold_pokemon? = false
      def extra_slot_index = slot_count
      def extra_slot_result_sized?    = true


	  def can_drop?(kind, index)
	    item = grabbed_item.item
#        store = backing_store_for(kind)
#        slot = store[index]
	    return false if kind == :craft && index==extra_slot_index && (!item.is_a?(ItemData) || item.id != :SIFTEDORE)
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
        y = bonus_2 + 92
        x2 = y2 = 0

        slot_count.times do |i|
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/butchertable/placeholder_slot")
          sprites["craft_slots#{i}"].z = -2
          x2 = x + i * SLOT_SIZE
          y2 = y
          sprites["craft_slots#{i}"].x = x2
          sprites["craft_slots#{i}"].y = y2 - 14 
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
        end
		if @machine
        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = x2 + 47 - 16
        sprites["craft_slots_equals"].y = y2 - 60
		else
        sprites["tab"] = IconSprite.new(0, 0, viewport)
        sprites["tab"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/poptab")
        sprites["tab"].z = 70
        sprites["tab"].x = bonus_1 + 206
        sprites["tab"].y = bonus_2 + 118
        create_text3("tab_alttext", "STA: #{$player.playerstamina}/#{$player.playermaxstamina}", sprites["tab"].x + 12, sprites["tab"].y + 20)
        sprites["tab_alttext"].z = 71
		end 
		render_assign_button
		render_bonus_slot
      end

      def render_bonus_slot
        x = sprites["craft_slots4"].x - 26
        y = bonus_2 + 20
        index = extra_slot_index
        sprites["craft_slots#{index}"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots#{index}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/butchertable/result_slot")
        sprites["craft_slots#{index}"].z = -2
        sprites["craft_slots#{index}"].x = x
        sprites["craft_slots#{index}"].y = y
        render_slot_icon(:craft, index, *craft[index]) if craft[index]
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
        objects["assign_button"].x = @machine ? bonus_1 + 268 : bonus_1 + 268
        objects["assign_button"].y = @machine ? bonus_2 + 120 : bonus_2 + 50
        objects["assign_button"].z = 0
        objects["assign_button"].visible = true
        text =  @machine ? connecting_power? ? "Connecting..." : "Connect" : "Sift"
        create_text_centered("current_task_label", text, objects["assign_button"].x + 44, objects["assign_button"].y + 12)
        refresh_assign_button
      end
	  
      def refresh_assign_button
	    if @machine 
        bitmap = connecting_power? ? "smallbutton_down" : "smallbutton_up"
        text = connecting_power? ? "Connecting..." : "Connect"
		else
		bitmap = event_data.clicked ? "smallbutton_down" : "smallbutton_up"
		text = "Sift"
		end 
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

      def click_item 
        return if event_data.clicked
		return unless station_can_afford_extra_cost?
        event_data.clicked = true 
        refresh_assign_button
		on_craft_consumed(nil)
      end

	  def connecting_power?
        $game_temp.connection_mode && $game_temp.connection_source.equal?(event_data)
	  end 


      def station_update
		event_data.update
        sync_slots_visuals!(:craft, 0..slot_count)
		refresh_assign_button
	    if @machine
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
		else
        sprites["tab_alttext"].text = "STA: #{$player.playerstamina}/#{$player.playermaxstamina}"
		end
      end
    end

    class Panner < ButcherTable
      def initialize(event_data:, container:)
        needed = slot_count + 1
        short_by = needed - event_data.internal_storage.length
        event_data.internal_storage.concat(Array.new(short_by)) if short_by.positive?
        super
      end
	  
	  def bonus_slot_function = nil
      def handle_object_click(object_key)
        toggle_connection_mode if object_key == "assign_button"
        toggle_wconnection_mode if object_key == "water_button"
        tank_clicked(object_key) if object_key.match?(/\Atank_slot_\d+\z/)
      end 
      def show_tank_tooltip(object_key)
        return unless object_key.match?(/\Atank_slot_\d+\z/)
        index = object_key.split("_").last.to_i
		fluid_type = index == 0 ? event_data.fluid_type : event_data.secondary_fluid_type
		water = index == 0 ? event_data.water : event_data.secondary_water
		if fluid_type
		item = GameData::Item.get(fluid_type)
		name = "#{item.name} Tank"
		else 
		name = "Empty Tank"
		end 
        hash = { name: [name, 0, 0] }
		maxwater = event_data.internal_water_storage.to_f
        hash[:water] = [water, 0, 0]
        hash[:maxwater] = [maxwater, 0, 0]
        tooltip.show(hash)
      end
	  
      def update_hover_tooltip
	    return show_empty_tooltip unless @show_tooltip
        if (object_key = clicked_object?)
		  if object_key.match?(/\Atank_slot_\d+\z/)
		    show_tank_tooltip(object_key)
		    return 
		  end 
		end 
        stack = item_hovered?
        return show_empty_tooltip if stack.nil?
        item = stack.is_a?(Array) ? stack[0] : stack
        if item.is_a?(Pokemon)
          show_pokemon_tooltip(item)
        else
          show_item_tooltip(item.is_a?(Symbol) ? ItemData.new(item) : item)
        end
      end
	  
      def station_can_afford_extra_cost?
	    true
      end

      def on_craft_consumed(_recipe)
	    true
      end
  
	  def initial_craft_contents = event_data.internal_storage
      def tank_count = 1
      def slot_count = 1
      def background_key = "PANNER"
      def craft_slots_hold_pokemon? = false
      def extra_slot_index = slot_count
      def extra_slot_result_sized?    = true


	  def can_drop?(kind, index)
	    item = grabbed_item.item
#        store = backing_store_for(kind)
#        slot = store[index]
	    return false if kind == :craft && index==extra_slot_index && (!item.is_a?(ItemData) || item.id != :SOFTSAND)
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
        x = bonus_1 + 168
        y = bonus_2 + 92
        x2 = y2 = 0

        slot_count.times do |i|
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/butchertable/placeholder_slot")
          sprites["craft_slots#{i}"].z = -2
          x2 = x + i * SLOT_SIZE
          y2 = y
          sprites["craft_slots#{i}"].x = x2
          sprites["craft_slots#{i}"].y = y2 - 14 
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
        end
        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = x2 + 87
        sprites["craft_slots_equals"].y = y2 - 60
        tank_count.times do |i|
          render_tank(i)
        end
		render_assign_button
		render_water_button
		render_bonus_slot
      end
      def render_tank(i)
        x = bonus_1 + 66 + (i * 50)
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
		return unless grabbed_item
        index = object_key.split("_").last.to_i
        selected_tank = index == 0 ? event_data.water : event_data.secondary_water
		fluid_type = index == 0 ? event_data.fluid_type : event_data.secondary_fluid_type
		item = grabbed_item.item
		
		#If we have an item that contains the same fluid as the target tank, or the tank is empty, fill it with that fluid.
		if CANTEEN_FILLABLE_DRINKS.include?(item.id) && (fluid_type == item.id || fluid_type.nil?)
		#If this is an empty bottle and there is a fluid.
		 drink = item
         bottle = drink.respond_to?(:bottle) ? drink.bottle : ItemData.new(:GLASSBOTTLE)
		 selected_tank += 25
		 if index == 0
          event_data.fluid_type = drink.id
    	     event_data.water = selected_tank
         else
          event_data.secondary_fluid_type = drink.id
    	     event_data.secondary_water = selected_tank
         end
         $bag.add(bottle)
         shrink_grabbed_by(1)
		elsif item.id == :GLASSBOTTLE && fluid_type
		 return if selected_tank < 25

		 drink = ItemData.new(fluid_type)
		 drink.set_bottle(item)

		 selected_tank -= 25
		   if index == 0
    	     event_data.water = selected_tank
             event_data.fluid_type = nil if event_data.water <= 0
		   else
    	     event_data.secondary_water = selected_tank
             event_data.secondary_fluid_type = nil if event_data.secondary_water <= 0
		   end
		 $bag.add(drink)
		 shrink_grabbed_by(1)
		#If this is a canteen, and the fluid in front of us can be placed in it.
		elsif item.id == :WATERBOTTLE && CANTEEN_FILLABLE_DRINKS.include?(fluid_type) && (item.liquid_type == fluid_type || item.liquid_type.nil?)
    	 canteen = item
    	 drink = ItemData.new(fluid_type)
         amount = [100, selected_tank, 100.0 - canteen.water].min
		 
    	 if amount > 0
    	   selected_tank -= amount

    	   unless pbFillCanteen(canteen, drink, amount, false)
    	     selected_tank += amount
    	   end
		   if index == 0
    	     event_data.water = selected_tank
		   else
    	     event_data.secondary_water = selected_tank
		   end
    	 end

		#If this is a canteen, and the tank is empty, but the Canteen isn't.
		elsif item.id == :WATERBOTTLE && fluid_type.nil? && item.liquid_type
    	 canteen = item
         amount = [100, canteen.water, event_data.internal_water_storage - selected_tank].min
    	 if amount > 0
    	   canteen.water -= amount
    	   selected_tank += amount

    	   if index == 0
    	     event_data.fluid_type = canteen.liquid_type
    	     event_data.water = selected_tank
    	   else
   	         event_data.secondary_fluid_type = canteen.liquid_type
    	     event_data.secondary_water = selected_tank
    	   end

    	   canteen.liquid_type = nil if canteen.water <= 0
		 end
        elsif GameData::BerryPlant::WATERING_CANS.include?(item.id) && fluid_type.nil? && item.water > 0
    	 can = item
         amount = [100, can.water, event_data.internal_water_storage - selected_tank].min
    	 if amount > 0
    	   can.water -= amount
    	   selected_tank += amount

    	   if index == 0
    	     event_data.fluid_type = :WATER
    	     event_data.water = selected_tank
    	   else
   	         event_data.secondary_fluid_type = :WATER
    	     event_data.secondary_water = selected_tank
    	   end
		 end
         elsif GameData::BerryPlant::WATERING_CANS.include?(item.id) && fluid_type && fluid_type == :WATER
    	 can = item
         amount = [100, selected_tank, 100.0 - can.water].min
		 
    	 if amount > 0
    	   selected_tank -= amount

    	   if can.increase_water(amount)#pbFillCanteen(canteen, drink, amount, false)
	         SoundManager.play_se("can_fill")
		   else
    	     selected_tank += amount
    	   end
		   if index == 0
    	     event_data.water = selected_tank
		   else
    	     event_data.secondary_water = selected_tank
		   end
    	 end

		end 
      end

	  
      def render_bonus_slot
        x = sprites["craft_slots0"].x - 8
        y = bonus_2 + 20
        index = extra_slot_index
        sprites["craft_slots#{index}"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots#{index}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/butchertable/result_slot")
        sprites["craft_slots#{index}"].z = -2
        sprites["craft_slots#{index}"].x = x
        sprites["craft_slots#{index}"].y = y
        render_slot_icon(:craft, index, *craft[index]) if craft[index]
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
		refresh_water_button
		refresh_tanks
        sprites["craft_slots_equals"].bitmap = fuel_bitmap
      end
    end


  end
end 