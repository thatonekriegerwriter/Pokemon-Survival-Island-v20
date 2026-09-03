module InventoryScene
  module Stations
    # FLAGGING RATHER THAN GUESSING: in the original, :BEDROLL fell through
    # setup_ui's case statement to the `else -> setup_craftingtable_ui`
    # branch, which computes slot positions from a loop that runs
    # `get_slot_amount` times - and get_slot_amount's case statement has
    # no :BEDROLL entry either, so that loop runs 0 times, leaving the
    # equals/result sprites placed using leftover (0, 0) coordinates from
    # variables that were never assigned. That reads as a real bug in the
    # original (or evidence Bedroll never actually exercises this code
    # path in practice - maybe sleeping is handled by a different script
    # entirely and this class is only reached for some edge case). Rather
    # than reproduce a (0,0)-positioned crafting UI, I've made Bedroll a
    # bag/party-free, craft-free station - just the bare scene. Please
    # confirm what Bedroll is actually meant to show before relying on
    # this file.
    class Bedroll < BaseStation
      def slot_count = 0
      def background_key = "BEDROLL"
      def uses_recipe_grid? = false
      def has_party_sidebar? = false
      def has_bag_grid? = false
      def shows_search_ui? = false

      private

      def render_station = nil
    end
  end
end
