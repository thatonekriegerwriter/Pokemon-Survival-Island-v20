module InventoryScene
  module Stations
    # The original's setup_ui had an explicitly empty `when :MACHINEBOX`
    # branch - no craft slots, no result. Whatever this station is for,
    # it's evidently just bag + party access with no recipe grid.
    class MachineBox < BaseStation
      def slot_count = 0
      def background_key = "MACHINEBOX"
      def uses_recipe_grid? = false
      def shows_search_ui? = false

      private

      def render_station = nil
    end
  end
end
