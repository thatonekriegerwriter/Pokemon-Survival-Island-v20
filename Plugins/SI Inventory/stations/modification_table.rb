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

          commit_modifiers_to_item(stack[0])
          pick_up(:craft, extra_slot_index)
        else
          existing = craft[extra_slot_index]
          commit_modifiers_to_item(existing[0]) if existing
          drop_onto(:craft, extra_slot_index)
          prefill_modifier_slots(craft[extra_slot_index][0]) if craft[extra_slot_index]
        end
      end
      def prefill_modifier_slots(item)
        slot_count.times { |i| clear_modifier_slot(i) }
        return unless item.respond_to?(:modifiers)

        item.modifiers.to_a.each_with_index do |(modifier_id, modifier_item), i|
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
	  
      def commit_modifiers_to_item(item)
        return unless item.respond_to?(:modifiers)

        desired_items = slot_count.times.filter_map { |i| craft[i]&.first }
        desired_ids = desired_items.map(&:id)
        current_items = item.modifiers.to_a
       current_ids = current_items.map(&:id)

       (current_ids - desired_ids).each { |id| item.modifiers.remove(id) }
       (desired_ids - current_ids).each { |id| item.modifiers.add(desired_items.find { |modifier| modifier.id == id }) }
      end


 
      def apply_batch_modifications
        stack = craft[extra_slot_index]
        return unless stack
 
        item, total_qty = stack
        modifier_slots = slot_count.times.filter_map { |i| craft[i] }
        return if modifier_slots.empty?
 
        variants = Array.new(total_qty) { item.dup }
        variants.each { |v| v.modifiers.to_a.each { |id| v.modifiers.remove(id) } if v.respond_to?(:modifiers) }
 
        modifier_slots.each do |mod_item, mod_qty|
          applied = [mod_qty, total_qty].min
          applied.times { |i| variants[i].modifiers.add(mod_item.dup) }
        end
 
        craft[extra_slot_index] = nil
        @modified_output = variants.group_by { |v| v.modifiers.to_a.sort }.values.map { |g| [g.first, g.length] }
 
        slot_count.times do |i|
          next unless craft[i]
 
          used = [craft[i][1], total_qty].min
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
