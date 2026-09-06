module InventoryScene
  module Stations
    class ModificationTable < BaseStation
      def initialize(event_data:, container:)
        needed = extra_slot_index + 1
        short_by = needed - event_data.internal_storage.length
        event_data.internal_storage.concat(Array.new(short_by)) if short_by.positive?
        super
      end
	  
      def finalize_container
	  end 
      def slot_count = 3
      def extra_slot_index = slot_count + 1
      def background_key = "MODIFICATIONTABLE"
      def extra_slot_result_sized?    = false
	  def uses_recipe_grid? = false
	  
      def craft = event_data.internal_storage
	  
	  def can_drop?(kind, index)
	    puts kind
	    item = grabbed_item.item
        stack = craft[extra_slot_index]
        store = backing_store_for(kind)
        slot = store[index]
	    return false if kind == :craft && index!=extra_slot_index && stack.nil?
	    return false if kind == :craft && item.is_a?(ItemData) && event_data.recipe_has?(item.id) && ( slot && slot[0].id != item.id)
		return true 
	  end 
	  
      def finalize_container
        apply_batch_modifications
        eject_everything_to_bag
      end  
      private
	  
      def handle_custom_click(button)
        return false unless button == :left

        hit = crafting_slot_from_mouse
        return false unless hit == extra_slot_index

        handle_extra_slot_click
        true
      end
      def handle_extra_slot_click
        if grabbed_item.nil?
          stack = craft[extra_slot_index]
          return unless stack

          commit_modifiers_to_item
          pick_up(:craft, extra_slot_index)
          switch_tab_to_item_pocket(stack[0])
        else
          existing = craft[extra_slot_index]
          commit_modifiers_to_item if existing && !existing[0].identical(grabbed_item.item)
          drop_onto(:craft, extra_slot_index)
          prefill_modifier_slots(craft[extra_slot_index][0])
        end
      end
      def prefill_modifier_slots(item)
	    modifiers = item.modifiers.to_a
        return if modifiers.empty?

        slot_count.times do |i|
          stack = craft[i]
          next unless stack
          $bag.add(stack[0], stack[1])
          clear_modifier_slot(i)
        end

        modifiers.each_with_index do |(modifier_id, modifier_item), i|
          break if i >= slot_count
          craft[i] = [modifier_item, 1]
          render_slot_icon(:craft, i, modifier_item, 1)
        end
      end
	  
      def clear_modifier_slot(i)
        return unless craft[i]
        craft[i] = nil
        remove_slot_icon(:craft, i)
      end
	  
      def consume_modifiers
	    stack = craft[extra_slot_index]
		return unless stack
		total_qty = stack[1]
        slot_count.times do |i|
          next unless craft[i]
		  
          used = [craft[i][1], total_qty].min
          craft[i][1] -= used

          if craft[i][1] <= 0
            clear_modifier_slot(i)
          else
            update_slot_text(:craft, i, craft[i][1])
          end
        end
      end
	  
      def commit_modifiers_to_item
        stack = craft[extra_slot_index]
        return unless stack
 
        item, total_qty = stack
 
        variants = Array.new(total_qty) { item.dup }
        variants.each { |v| v.modifiers.to_a.each { |id| v.modifiers.remove(id) } if v.respond_to?(:modifiers) }
		

        successful_applications = []
        slot_count.times do |i|
          next unless craft[i]
          mod_item, mod_qty = craft[i]
          applied = 0

          variants.each do |variant|
            break if applied >= mod_qty

            applied += 1 if variant.modifiers.add(mod_item.dup)
          end

          successful_applications[i] = applied
        end
 
 
 
 
        puts successful_applications.inspect
 
 
 
 
        craft[extra_slot_index] = nil
 
        slot_count.times do |i|
          next unless craft[i]
          success = successful_applications[i]
		  puts success.inspect
		  puts total_qty.inspect
          used = [success, total_qty].min
          remaining = craft[i][1] - used
          craft[i] = remaining.positive? ? [craft[i][0], remaining] : nil
        end
        new_variants = variants.group_by { |v| v.modifiers.to_a.sort }.values.map { |g| [g.first, g.length] }
		return if new_variants.empty?
        craft[extra_slot_index] = new_variants.shift
		event_data.extra_storage = new_variants unless new_variants.empty?
      end


 
      def apply_batch_modifications
        stack = craft[extra_slot_index]
        return unless stack
 
        item, total_qty = stack
 
        variants = Array.new(total_qty) { item.dup }
        variants.each { |v| v.modifiers.to_a.each { |id| v.modifiers.remove(id) } if v.respond_to?(:modifiers) }
 
		
        successful_applications = []
        slot_count.times do |i|
          next unless craft[i]
          mod_item, mod_qty = craft[i]
          applied = 0

          variants.each do |variant|
            break if applied >= mod_qty

            applied += 1 if variant.modifiers.add(mod_item.dup)
          end

          successful_applications[i] = applied
        end
 
 

 
 
 
 
 
        craft[extra_slot_index] = nil
        @modified_output = variants.group_by { |v| v.modifiers.to_a.sort }.values.map { |g| [g.first, g.length] }
 
        slot_count.times do |i|
          next unless craft[i]
          success = successful_applications[i]
 
          used = [success, total_qty].min
          remaining = craft[i][1] - used
          craft[i] = remaining.positive? ? [craft[i][0], remaining] : nil
        end
      end
 
      def eject_everything_to_bag
        (@modified_output || []).each { |item, qty| $bag.add(item, qty) }
        @modified_output = nil
 
        slot_count.times { |i| $bag.add(craft[i][0], craft[i][1]) if craft[i] }
        $bag.add(craft[extra_slot_index][0], craft[extra_slot_index][1]) if craft[extra_slot_index]
      end
 
      def render_station
        x = bonus_1 + 134
        y = bonus_2 + 30
        x2 = y2 = 0
        slot_count.times do |i|
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot")
          sprites["craft_slots#{i}"].z = 70
          x2 = x + i * SLOT_SIZE
          y2 = y
          sprites["craft_slots#{i}"].x = x2
          sprites["craft_slots#{i}"].y = y2
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
        end
        render_bonus_slot
      end
 
      def render_bonus_slot
        anchor = sprites["craft_slots1"]
        index = extra_slot_index
        sprites["craft_slots#{index}"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots#{index}"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot")
        sprites["craft_slots#{index}"].z = -2
        sprites["craft_slots#{index}"].x = anchor.x
        sprites["craft_slots#{index}"].y = bonus_2 + SLOT_SIZE + SLOT_SIZE
        render_slot_icon(:craft, index, *craft[index]) if craft[index]
      end
 
      def station_update
        event_data.update
        sync_slots_visuals!(:craft, 0..extra_slot_index)
      end


	  
    end
  end
end
