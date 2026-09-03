module InventoryScene
  module Stations
    class ResearchTable < BaseStation
      def slot_count = 1
      def background_key = "RESEARCHTABLE"
      def uses_recipe_grid? = false

      def initialize(event_data:, container:)
        @old_research = nil
        super
      end

      def initial_craft_contents
        event_data.researching_item ? [[event_data.researching_item, 1]] : []
      end

      def finalize_container
        return unless craft[0]

        if @old_research == craft[0][0]
          event_data.reset if @old_research == event_data.researching_item
        elsif craft[0][1] > 0
          craft[0][1] -= 1
          event_data.research(craft[0][0]) if event_data.researching_item != craft[0][0]
          if event_data.active_researches.empty?
            craft[0][1] += 1
            sideDisplay(_INTL("There are no recipes for #{craft[0][0].name}."))
            event_data.reset
          else
            craft[0] = nil if craft[0][1] == 0
          end
        end
      end

      private

      def render_station
        x = bonus_1 + 168
        y = bonus_2 + 60
        sprites["craft_slots0"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots0"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/placeholder_slot")
        sprites["craft_slots0"].z = 1
        sprites["craft_slots0"].x = x
        sprites["craft_slots0"].y = y
        render_slot_icon(:craft, 0, *craft[0]) if craft[0]
      end

      # Ported close to verbatim - continuous research progress, not a
      # click-to-craft flow, so it lives entirely in station_update
      # instead of the shared result-slot machinery.
      def station_update
        return unless event_data.is_a?(ResearchTableData)

        if craft[0] && craft[0][1] > 0
          target = craft[0][0]
          if event_data.researching_item.nil? || event_data.researching_item != target
            event_data.research(target)
            sideDisplay(_INTL("You begin researching #{target.name}.")) if @old_research != target
          end
          if event_data.active_researches.empty? && @old_research != target
            @old_research = target
            sideDisplay(_INTL("You can't think of anything to make out of #{target.name}."))
            event_data.reset
          end
        end

        old_stage = event_data.research_stage
        serious_count = $player.party.count { |pkmn| pkmn.nature.id == :SERIOUS }
        multiplier = 2 + serious_count * 2

        if event_data.update(multiplier)
          remove_slot_icon(:craft, 0)
          craft[0] = nil
        elsif event_data.researching?
          if event_data.research_stage > old_stage
            sideDisplay(event_data.text_for_stage_internal)
          elsif pbGetTimeNow.to_i >= event_data.time_last_message && rand(1000) < 10
            sideDisplay(event_data.research_flavor)
            event_data.time_last_message = pbGetTimeNow.to_i + rand(720..1745)
          end
        end
      end
    end
  end
end
