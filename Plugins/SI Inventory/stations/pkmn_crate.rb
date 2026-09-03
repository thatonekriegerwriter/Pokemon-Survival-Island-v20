module InventoryScene
  module Stations
    class PkmnCrate < BaseStation
      def slot_count = PokemonBox::BOX_SIZE
      def background_key = "Inventory"
      def uses_recipe_grid? = false
      def craft_slots_hold_pokemon? = true

      def pokemon_box = container.box.pokemon

      def initialize(event_data:, container:)
        # Pad/truncate the box to a fixed size up front, same as the
        # original did in pbStartScene, so every slot index is safe to
        # index into without bounds checks scattered everywhere else.
        box_pokemon = container.box.pokemon
        if box_pokemon.length < PokemonBox::BOX_SIZE
          box_pokemon.concat(Array.new(PokemonBox::BOX_SIZE - box_pokemon.length))
        elsif box_pokemon.length > PokemonBox::BOX_SIZE
          box_pokemon.slice!(PokemonBox::BOX_SIZE, box_pokemon.length - PokemonBox::BOX_SIZE)
        end
        super
      end

      private

      def render_station
        y = bonus_2 + 16
        cols = 9

        slot_count.times do |i|
          col = i % cols
          row = i / cols
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot")
          sprites["craft_slots#{i}"].z = -2
          sprites["craft_slots#{i}"].x = start_x + col * SLOT_SIZE
          sprites["craft_slots#{i}"].y = y + row * SLOT_SIZE

          sprites["craft_slots_star#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots_star#{i}"].setBitmap("Graphics/Pictures/craftingMenu/star")
          sprites["craft_slots_star#{i}"].z = 9998
          sprites["craft_slots_star#{i}"].x = sprites["craft_slots#{i}"].x + 26
          sprites["craft_slots_star#{i}"].y = sprites["craft_slots#{i}"].y + 2
          sprites["craft_slots_star#{i}"].visible = false
          sprites["craft_slots_qstar#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots_qstar#{i}"].setBitmap("Graphics/Pictures/craftingMenu/redstar")
          sprites["craft_slots_qstar#{i}"].z = 9999
          sprites["craft_slots_qstar#{i}"].x = sprites["craft_slots#{i}"].x + 26
          sprites["craft_slots_qstar#{i}"].y = sprites["craft_slots#{i}"].y + 2
          sprites["craft_slots_qstar#{i}"].visible = false

          next unless pokemon_box[i]
          render_pokemon_icon(:craft, i, pokemon_box[i])
          sprites["craft_slots_star#{i}"].visible = $bag.registered?(pokemon_box[i])
          sprites["craft_slots_qstar#{i}"].visible = quick_access_identical?(pokemon_box[i])
        end

        sprites["cover"] = IconSprite.new(0, 0, viewport)
        sprites["cover"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/itemcrate/cover")
        sprites["cover"].z = 0
        sprites["cover"].x = bonus_1 - mamtx
        sprites["cover"].y = bonus_2 - (mamty + 12)
      end
    end
  end
end
