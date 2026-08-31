module InventoryScene
  module Stations
    class Bag < BaseStation
      def slot_count = 2
      def background_key = "Inventory"
      def recipe_station_key = :POCKET

      attr_accessor :equip

      def initial_craft_contents = []

      def finalize_container
        super
        $player.playershirt, $player.playerpants, $player.playershoes = equip.map { |data| data ? data[0] : nil }
      end

      def handle_object_click(object_key)
        case object_key
        when "equipment_button" then toggle_equipment_panel
        when "player_square" then use_grabbed_item_on_self
        end
      end

      private

      def render_station
        @equip = [[$player.playershirt, 1], [$player.playerpants, 1], [$player.playershoes, 1]]
        render_trainer_and_bars
        render_equipment_button
        render_pocket_crafting_slots
        render_equipment_slots
      end

      def render_trainer_and_bars
        objects["player_square"] = BitmapSprite.new(80, 80, viewport)
        objects["player_square"].bitmap.fill_rect(0, 0, 80, 80, Color.new(0, 0, 0))
        objects["player_square"].x = bonus_1 + 34
        objects["player_square"].y = bonus_2 + 24

        sprites["trainer"] = IconSprite.new(0, 0, viewport)
        sprites["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($player.trainer_type))
        sprites["trainer"].x = bonus_1 + 30
        sprites["trainer"].y = bonus_2 + 24
        sprites["trainer"].zoom_x = sprites["trainer"].zoom_y = 0.5
        sprites["trainer"].z = 1

        build_player_hp_bar
        build_player_stat_bar("fod", "FOD", bonus_1 + 150, 18)
        build_player_stat_bar("H2O", "H2O", bonus_1 + 150, 38)
        build_player_stat_bar("SLP", "SLP", bonus_1 + 150, 58)
      end
      # HP shows a live "HP: X/Y" count; FOD/H2O/SLP stay as bare labels
      # (never gain numbers) - both get their text color driven by the
      # bar's fill color every frame instead of a fixed color. That's a
      # different convention from the party sidebar's build_bar (small
      # static-colored text below each icon), which is why this doesn't
      # reuse it.
      def build_player_hp_bar
        build_player_bar_shape("hp", bonus_1 + 76, 100)
        create_text3("hpbartext", "HP: #{$player.playerhealth.to_i}/#{$player.playermaxhealth2.to_i}",
                      sprites["hpbarborder"].x - 20, sprites["hpbarborder"].y, MessageConfig::DARK_TEXT_MAIN_COLOR, nil, 14)
      end

      def build_player_stat_bar(key, label, x, y_offset)
        build_player_bar_shape(key, x, y_offset)
        create_text3("#{key}bartext", label, sprites["#{key}barborder"].x - 20, sprites["#{key}barborder"].y,
                      MessageConfig::DARK_TEXT_MAIN_COLOR, nil, 14)
      end

      def build_player_bar_shape(key, x, y_offset, width: 56, height: 6)
        sprites["#{key}barborder"] = BitmapSprite.new(width, height, viewport)
        sprites["#{key}barborder"].x = x - width / 2
        sprites["#{key}barborder"].y = (sprites["trainer"].y - height / 2) + y_offset
        sprites["#{key}barborder"].bitmap.fill_rect(Rect.new(0, 0, width, height), Color.new(32, 32, 32))
        sprites["#{key}barborder"].bitmap.fill_rect(1, 1, width - 2, height - 2, Color.new(96, 96, 96))
        sprites["#{key}barfill"] = BitmapSprite.new(width - 2, height - 2, viewport)
        sprites["#{key}barfill"].x = x - (width - 2) / 2
        sprites["#{key}barfill"].y = (sprites["trainer"].y - (height - 2) / 2) + y_offset
      end

      def render_equipment_button
        objects["equipment_button"] = IconSprite.new(0, 0, viewport)
        objects["equipment_button"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/smallbutton_up")
        objects["equipment_button"].x = bonus_1 + 116
        objects["equipment_button"].y = bonus_2 + 116
        objects["equipment_button"].z = 0
        objects["equipment_button"].visible = true
        buttons["equipment_button"] = false
      end

      def render_pocket_crafting_slots
        x, y = 186, 56
        x2 = y2 = 0
        slot_count.times do |i|
          col = i % 2
          row = i / 2
          sprites["craft_slots#{i}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{i}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/placeholder_slot")
          sprites["craft_slots#{i}"].z = 70
          x2 = bonus_1 + x + col * SLOT_SIZE
          y2 = bonus_2 + y + row * SLOT_SIZE
          sprites["craft_slots#{i}"].x = x2
          sprites["craft_slots#{i}"].y = y2
          render_slot_icon(:craft, i, *craft[i]) if craft[i]
        end

        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/equals")
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = x2 + 38
        sprites["craft_slots_equals"].y = y2 + 6

        sprites["craft_slots_result"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_result"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/result_slot")
        sprites["craft_slots_result"].z = 70
        sprites["craft_slots_result"].x = x2 + 66
        sprites["craft_slots_result"].y = y2 - 8
      end

      def render_equipment_slots
        x = bonus_1 + 134
        y = bonus_2 + 20
        3.times do |i|
          index = i + 100
          sprites["craft_slots#{index}"] = IconSprite.new(0, 0, viewport)
          sprites["craft_slots#{index}"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/placeholder_slot")
          sprites["craft_slots#{index}"].z = 70
          sprites["craft_slots#{index}"].x = x
          sprites["craft_slots#{index}"].y = y + i * SLOT_SIZE
          sprites["craft_slots#{index}"].visible = false
          next unless equip[i]

          render_slot_icon(:equipment, index, *equip[i])
          icons[icon_key(:equipment, index, :image)].visible = false
        end
      end

      def toggle_equipment_panel
        buttons["equipment_button"] = !buttons["equipment_button"]
        bitmap = buttons["equipment_button"] ? "smallbutton_down" : "smallbutton_up"
        objects["equipment_button"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/#{bitmap}")
      end

      def use_grabbed_item_on_self
        return unless grabbed_item && !grabbed_item.pokemon? && grabbed_item.qty > 0

        item = grabbed_item.item
        itm = GameData::Item.get(item)
        if itm.is_foodwater? || itm.is_berry?
          shrink_grabbed_by(1) if pbNeoEating(item)
        elsif itm.is_medicine?
          shrink_grabbed_by(1) if pbNeoMedicine(item)
        elsif item.id == :WATERBOTTLE 
		  pbCanteen(item, false)
        else
          exit!(item)
        end
      end

      def station_update
        toggle_stat_panels
        update_hp_bar
        update_stat_bar_visuals
      end

      def toggle_stat_panels
        showing_equipment = buttons["equipment_button"]
        %w[fod H2O SLP].each do |key|
          sprites["#{key}barfill"].visible = sprites["#{key}barborder"].visible = !showing_equipment
          sprites["#{key}bartext"].visible = !showing_equipment
        end
        3.times do |i|
          index = i + 100
          sprites["craft_slots#{index}"].visible = showing_equipment
		  image_key = icon_key(:equipment, index, :image)
		  text_key = icon_key(:equipment, index, :text)
          icons[image_key]&.visible = showing_equipment if icons[image_key] && !icons[image_key].disposed?
          icons[text_key]&.visible = showing_equipment if icons[text_key] && !icons[text_key].disposed?
        end
      end

      def update_hp_bar
        colors = fill_bar_bitmap("hp", $player.playerhealth.to_i, $player.playermaxhealth2.to_i)
        sprites["hpbartext"].text = "HP: #{$player.playerhealth.to_i}/#{$player.playermaxhealth2.to_i}"
        sprites["hpbartext"].baseColor = colors
      end

      def update_stat_bar_visuals
        return if buttons["equipment_button"]

        update_player_stat_bar("fod", $player.playerfood, $player.playermaxfood, saturation_sensitive: true)
        update_player_stat_bar("H2O", $player.playerwater, $player.playermaxwater, saturation_sensitive: true)
        update_player_stat_bar("SLP", $player.playersleep, $player.playermaxsleep, saturation_sensitive: false)
      end

      # Label text ("FOD"/"H2O"/"SLP") never changes - only the fill and
      # its color do. FOD/H2O swap to a fixed "well-fed" color while the
      # player has active saturation; SLP never does (matches the
      # original's CurrentColorsAlt only being consulted for food/water).
      def update_player_stat_bar(key, value, max, saturation_sensitive:)
        colors = fill_bar_bitmap(key, value, max, saturation_sensitive)
        colors = bar_colors_alt(value, max) if saturation_sensitive && $player.playersaturation > 0
        sprites["#{key}bartext"].baseColor = colors
      end
    end
  end
end
