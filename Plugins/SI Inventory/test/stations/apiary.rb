module InventoryScene
  module Stations
    class BeeHive < BaseStation

      QUEEN_SLOT    = 0
      BREEDING_SLOT = 1

      OFFSPRING_SLOTS = 2..8
      FRAME_SLOTS     = 9..11
     # STORAGE_SLOTS   = 12..20

      def initialize(event_data:, container:)
        super
		@apiary = event_data.apiary
      end

     class BeehiveStorageProxy
       def initialize(data)
         @data = data
       end

       def [](index)
         case index
         when 0
           @data.queen
         when 1
           @data.breeder
         when 2..8
           @data.comb[index - 2]
         when 9..11
           @data.frames[index - 9]
       #  when 12..20
       #    @data.internal_storage[index - 12]
         end
       end

       def []=(index, value)
         case index
         when 0
           @data.queen = value
         when 1
           @data.breeder = value
         when 2..8
           @data.comb[index - 2] = value
         when 9..11
		   
           @data.frames[index - 9] = value
       #  when 12..20
       #    @data.internal_storage[index - 12] = value
         end
       end
       def each
         return enum_for(:each) unless block_given?
         length.times { |i| yield self[i] }
       end
       def empty?
         all?(&:nil?)
       end

       def delete_at(index)
         value = self[index]
         self[index] = nil
         value
       end
  
       def compact
         to_a.compact
       end
	   def to_a
         each.to_a
	   end
       def length
         11
       end
       alias size length
end

      def initial_craft_contents
        [
          event_data.queen,
          event_data.breeder,
          *event_data.comb,
          *event_data.frames,
       #   *event_data.internal_storage
        ]
      end

      def slot_count = FRAME_SLOTS.max + 1
      def background_key = @apiary ? "APIARY" : "BEEHIVE"

      def craft_slots_hold_pokemon?
        true
      end

      def queen_slot = QUEEN_SLOT
      def breeding_slot = BREEDING_SLOT

      def offspring_slots = OFFSPRING_SLOTS
      def frame_slots = FRAME_SLOTS

      def pokemon_box
        @pokemon_box_proxy ||= BeehiveStorageProxy.new(event_data)
      end

      def finalize_container = nil

      private

def render_station
  # Queen
  render_station_slot(
    QUEEN_SLOT,
    bonus_1 + 8 + SLOT_SIZE,
    bonus_2 + 42
  )

  # Breeding Pokémon
  render_station_slot(
    BREEDING_SLOT,
    bonus_1 + 8 + SLOT_SIZE,
    bonus_2 + 42 + SLOT_SIZE
  )

  # Offspring / Honeycomb
  OFFSPRING_SLOTS.each_with_index do |index, i|
   row = i < 2 ? 0 : i < 5 ? 1 : 2
   column = row == 0 ? i : row == 1 ? i - 2 : i - 5
   row_size = row == 1 ? 3 : 2
   row_start = (3 - row_size) / 2.0

  render_station_slot(
    index,
    bonus_1 + 130 + (row_start + column) * SLOT_SIZE,
    bonus_2 + 22 + row * SLOT_SIZE
  )
  end

  # Frames
  FRAME_SLOTS.each_with_index do |index, i|
    render_station_slot(
      index,
      bonus_1 + 284,
      bonus_2 + 22 + i * SLOT_SIZE
    )
  end

end 
      def render_station_slot(index, x, y)
        sprites["craft_slots#{index}"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots#{index}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/beehive/placeholder_slot")
        sprites["craft_slots#{index}"].z = -2
        sprites["craft_slots#{index}"].x = x
        sprites["craft_slots#{index}"].y = y
		return unless pokemon_box[index]
        if pokemon_box[index].is_a?(Pokemon)
        render_pokemon_icon(:box, index, pokemon_box[index]) 
		else
        render_slot_icon(:box, index, *pokemon_box[index]) 
		end 
      end

      def station_update
        event_data.update
        sync_slots_visuals!(:box, 0..slot_count)
      end
    end
  end
end