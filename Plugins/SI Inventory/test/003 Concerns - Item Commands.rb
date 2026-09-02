module InventoryScene
  module Concerns
    # The bag-item command menu (opened via the USE key/middle-click on
    # whichever bag slot is under the mouse) plus the F (favorite) and I
    # (info/summary) keyboard shortcuts. Ported close to verbatim from the
    # original `use_item` - this is UI-flow code with a lot of engine
    # callouts (pbShowCommands, pbMedicine, pbUseItem, pbItemSummaryScreen)
    # that I can't exercise outside the engine, so treat the branching as
    # a faithful structural port rather than independently verified.
    module ItemCommands
      def use_item
        return if grabbed_item

        hit = slot_from_mouse
        return unless hit

        itemdata = current_pocket[hit[0]]
        return unless itemdata

        item = itemdata[0]
        itm = GameData::Item.get(item)
        commands, ids = build_item_command_list(itm, item)
        itemname = itm.name
        sprites["msgwindow"].visible = false
        
        toggle_legend
        loop do
          command = pbShowCommands(_INTL("{1} is selected.", itemname), commands)
          ret = run_item_command(ids, command, item, itm, itemname)
          break if ret == :cancel
		  if ret == :close_bag
           toggle_legend
           return item 
		  end
          itemname = itm.name # may have pluralized during Toss
        end
		
        toggle_legend
        nil
      end

      private

      def build_item_command_list(itm, item)
        commands = []
        ids = {}
        add_command = ->(key, text) { ids[key] = commands.length; commands << text }

        add_command.call(:read, _INTL("Read")) if itm.is_mail?
        add_command.call(:equip, _INTL("Equip")) if itm.is_tool? && $player.equipped_item == :PUNCH
        add_command.call(:unequip, _INTL("Unequip")) if itm.is_tool? && $player.equipped_item == item
        add_command.call(:drink, _INTL("Drink")) if itm.is_water?
        add_command.call(:eat, _INTL("Eat")) if (itm.is_foodwater? || itm.is_berry?) && !itm.is_water?
        add_command.call(:medicate, _INTL("Use (Self)")) if itm.is_medicine?
        if ItemHandlers.hasOutHandler(item) || (itm.is_machine? && $player.party.length > 0) || itm.field_use == 1
          add_command.call(:use, ItemHandlers.hasUseText(item) ? ItemHandlers.getUseText(item) : _INTL("Use"))
        end
        add_command.call(:info, _INTL("Info"))
        add_command.call(:give, _INTL("Give")) if $player.pokemon_party.length > 0 && itm.can_hold?
        add_command.call(:toss, _INTL("Toss")) if !itm.is_important? || $DEBUG
        if $bag.registered?(item)
          add_command.call(:register, _INTL("Unfavorite"))
        elsif pbCanRegisterItem?(item)
          add_command.call(:register, _INTL("Favorite"))
        end
        add_command.call(:debug, _INTL("Debug")) if $DEBUG
        commands << _INTL("Cancel")
        [commands, ids]
      end

      def run_item_command(ids, command, item, itm, itemname)
        case ids.key(command)
        when :read
          pbFadeOutIn { pbDisplayMail(Mail.new(item, "", "")) }
        when :drink, :eat
          ret = pbNeoEating(item)
          $bag.remove(item, 1)
          return :close_bag if ret == 2
        when :equip
          $player.equip(item)
          sideDisplay(_INTL("You will now use #{item.name} instead of punching."))
        when :unequip
          $player.unequip
          sideDisplay(_INTL("You are now unarmed."))
        when :medicate
          ret = pbMedicine($bag, item)
          return :close_bag if ret == 2
        when :use
          ret = pbUseItem($bag, item)
          decreaseStamina(1)
          return :close_bag if ret == 2
        when :info
          pbFadeOutIn { pbItemSummaryScreen(item) }
        when :give
          give_item_to_pokemon(item, itm, itemname)
        when :toss
          toss_item(item, itm, itemname)
        when :register
          $bag.registered?(item) ? $bag.unregister(item) : $bag.register(item)
        when :debug
          run_debug_menu(item, itm, itemname)
        else
          return :cancel
        end
        nil
      end

      def give_item_to_pokemon(item, itm, itemname)
        if $player.pokemon_count == 0
          pbDisplay(_INTL("There is no Pokémon."))
        elsif itm.is_important?
          pbDisplay(_INTL("The {1} can't be held.", itemname))
        else
          pbFadeOutIn do
            sscreen = PokemonPartyScreen.new(PokemonParty_Scene.new, $player.party)
            sscreen.pbPokemonGiveScreen(item)
          end
        end
      end

      def toss_item(item, itm, itemname)
        qty = $bag.quantity(item)
        qty = pbChooseNumber(_INTL("Toss out how many {1}?", itm.name_plural), qty) if qty > 1
        return unless qty > 0

        itemname = itm.name_plural if qty > 1
        return unless pbConfirm(_INTL("Is it OK to throw away {1} {2}?", qty, itemname))

        pbDisplay(_INTL("Threw away {1} {2}.", qty, itemname))
        qty.times { $bag.remove(item) }
      end

      def run_debug_menu(item, itm, itemname)
        loop do
          command = pbShowCommands(_INTL("Do what with {1}?", itemname),
                                    [_INTL("Change quantity"), _INTL("Make Mystery Gift"), _INTL("Cancel")])
          case command
          when 0
            qty = $bag.quantity(item)
            newqty = pbChooseNumber(_INTL("Choose new quantity of {1} (max. #{item.stack_size}).", itm.name_plural), item.stack_size) { pbUpdate }
            $bag.add(item, newqty - qty) if newqty > qty
            $bag.remove(item, qty - newqty) if newqty < qty
            break if newqty == 0
          when 1
            pbCreateMysteryGift(1, item)
          else
            break
          end
        end
      end

      public

      # ---- F (favorite) / I (info) shortcuts -----------------------

      def toggle_favorite_under_mouse
        return if grabbed_item

        data, sprite_key = hovered_favoritable_slot
        item = data&.first
        return if item.nil?

        if $bag.registered?(item)
          $bag.unregister(item)
          sprites[sprite_key]&.visible = false
        else
          $bag.register(item)
          sprites[sprite_key]&.visible = true
        end
      end
	  
	  def quick_access_identical?(item)
	    return item.identical($player.quick_access) if $player.quick_access.is_a?(ItemData) && item.is_a?(ItemData)
		return item == $player.quick_access
	  
	  end 
	  
      def toggle_quick_access_under_mouse
        return if grabbed_item

        data, sprite_key = hovered_quick_slot
        item = data&.first
        return if item.nil?
        
        if quick_access_identical?(item)
          $player.quick_access = :PUNCH
          sprites[sprite_key]&.visible = false
        else
          $player.quick_access = item
          sprites[sprite_key]&.visible = true
        end
      end

      def hovered_favoritable_slot
        if (hit = slot_from_mouse)
          [current_pocket[hit[0]], "slots_star#{hit[0]}"]
        elsif (hit = crafting_slot_from_mouse).is_a?(Integer)
		  return [nil, nil] if craft_slots_hold_pokemon?
          data =  craft[hit]
          [data, "craft_slots_star#{hit}"]
        elsif (idx = hit_pokemon_index)
          [[party[idx]], "slotimagepkmnstar#{idx}"]
        end
      end

      def hovered_quick_slot
        if (hit = slot_from_mouse)
          [current_pocket[hit[0]], "slots_qstar#{hit[0]}"]
        elsif (hit = crafting_slot_from_mouse).is_a?(Integer)
		  return [nil, nil] if craft_slots_hold_pokemon?
          data =  craft[hit]
          [data, "craft_slots_qstar#{hit}"]
        elsif (idx = hit_pokemon_index)
          [[party[idx]], "slotimagepkmnqstar#{idx}"]
        end
      end

      def show_info_under_mouse
        return if grabbed_item

        if (hit = slot_from_mouse)
          item = current_pocket[hit[0]]&.first
          pbFadeOutIn { pbItemSummaryScreen(item) } if item 
        elsif (hit = crafting_slot_from_mouse)
          show_info_for_craft_slot(hit)
        elsif (idx = hit_pokemon_index)
		  object = party[idx]
		  if object.is_a?(Pokemon)
           pbFadeOutIn { pbSummary(idx, party) }
		  else
           item = object.first
           pbFadeOutIn { pbItemSummaryScreen(item) } if item 
		  
		  end 
        end
      end

      def show_info_for_craft_slot(hit)
        return unless hit.is_a?(Integer)

        if hit >= 100
          return unless buttons["equipment_button"]

          item = equip[hit - 100]&.first
          pbFadeOutIn { pbItemSummaryScreen(item) } if item
        elsif craft_slots_hold_pokemon?
          pbFadeOutIn { pbSummary(hit, pokemon_box) } if pokemon_box[hit]
        else
          item = craft[hit]&.first
          pbFadeOutIn { pbItemSummaryScreen(item) } if item
        end
      end

      def pbSummary(pkmn_index, storage, inbattle = false)
        scene = PokemonSummary_Scene.new
        screen = PokemonSummaryScreen.new(scene, inbattle)
        screen.pbStartScreen(storage, pkmn_index)
      end
    end
  end
end
