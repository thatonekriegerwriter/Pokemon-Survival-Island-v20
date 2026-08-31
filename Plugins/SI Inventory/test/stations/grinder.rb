module InventoryScene
  module Stations
    class Grinder < BaseStation
      def initialize(event_data:, container:)
        # Defensive sizing, matching PkmnCrate's precedent for
        # container.box.pokemon - if internal_storage isn't already
        # slot_count+1 long, pad it in place. No writer exists
        # (internal_storage is attr_reader-only, deliberately), but that's
        # fine - this mutates the array's contents, never reassigns the
        # reference itself.
        needed = slot_count + 1
        short_by = needed - event_data.internal_storage.length
        event_data.internal_storage.concat(Array.new(short_by)) if short_by.positive?
        super
      end

      def slot_count = 1
      def background_key = "GRINDER"
      def hides_result_highlight? = true

      def initial_craft_contents = event_data.internal_storage
      def finalize_container = nil
	  def bonus_slot_function = :READ

      def recipe_matching_slots = craft[0...slot_count]

      def extra_slot_index = slot_count


      def station_can_afford_extra_cost?
        $player.playerstamina - 2 >= 0
      end

      def on_craft_consumed(_recipe)
        $player.playerstamina -= 2
      end

      private

      def render_station
        x = bonus_1 + 96
        y = bonus_2 + 58
        x2 = y2 = 0

        slot_count.times do |i|
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/grinder/placeholder_slot")
          sprites["craft_slots#{i}"].z = 70
          x2 = x + i * SLOT_SIZE
          y2 = y
          sprites["craft_slots#{i}"].x = x2
          sprites["craft_slots#{i}"].y = y2
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
        end

        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/grinder/equals")
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = x2 + 68
        sprites["craft_slots_equals"].y = y2 + 2

        sprites["craft_slots_result"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_result"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/grinder/result_slot")
        sprites["craft_slots_result"].z = 70
        sprites["craft_slots_result"].x = x2 + 136
        sprites["craft_slots_result"].y = y2 - 8
        
		render_bonus_slot
		
        sprites["tab"] = IconSprite.new(0, 0, viewport)
        sprites["tab"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/poptab")
        sprites["tab"].z = 70
        sprites["tab"].x = bonus_1 + 206
        sprites["tab"].y = bonus_2 + 118
        create_text3("tab_alttext", "STA: #{$player.playerstamina}/#{$player.playermaxstamina}", sprites["tab"].x + 12, sprites["tab"].y + 20)
        sprites["tab_alttext"].z = 71
      end
	  
      def render_bonus_slot
        index = extra_slot_index
        sprites["craft_slots#{index}"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots#{index}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/grinder/result_slot2")
        sprites["craft_slots#{index}"].z = 70
        sprites["craft_slots#{index}"].x = sprites["craft_slots_result"].x + 64
        sprites["craft_slots#{index}"].y = sprites["craft_slots_result"].y + 8
        render_slot_icon(:craft, index, *craft[index]) if craft[index]
      end

      def station_update
        sprites["tab_alttext"].text = "STA: #{$player.playerstamina}/#{$player.playermaxstamina}"
		event_data.update
        # Reflects whatever event_data.update just did to
        # internal_storage on screen - covers both the ingredient slot(s)
        # and the bonus slot in one range, since both live in the same
        # backing array.
        sync_slots_visuals!(:craft, 0..slot_count)
      end
    end
  end
end
