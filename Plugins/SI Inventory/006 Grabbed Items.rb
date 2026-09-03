module InventoryScene
  # Replaces the old `{ icon:, stack:, index:, craft:, pkmn_inv: }` hash.
  # The old code used two booleans (craft / pkmn_inv) to represent what was
  # really a single choice of "where did this item come from" - one enum
  # replaces both and removes the three-way branch that appeared at every
  # call site in the original (~25 times).
  class GrabbedItem
    SOURCES = %i[bag craft pokemon_inventory party pokemon_slot equipment held adventure_party].freeze

    attr_accessor :icon, :stack, :index, :store
    attr_reader :source

    def initialize(icon:, stack:, index:, source:, store: nil)
      raise ArgumentError, "unknown source #{source.inspect}" unless SOURCES.include?(source)

      @icon   = icon
      @stack  = stack
      @index  = index
      @source = source
      @store  = store
    end

    def item = stack[0]
    def qty  = stack[1]

    def qty=(v)
      stack[1] = v
    end

    def pokemon? = item.is_a?(Pokemon)
    def item? = item.is_a?(Array) && item[0].is_a?(ItemData)

    # Which array this came from, for the generic "put it back" / "clear
    # the source slot" logic in Concerns::DraggableSlots.
    def from_fixed_slot? = index != "held" && !%i[held].include?(source)

    # The suffix used to build this item's paired sprite keys. Held
    # (split-off) stacks always use plain "_image"/"_text" regardless of
    # where they came from - that's a straight port of the original's
    # new_icon/new_icon3, which both used that suffix for split stacks.
    def text_icon_suffix
      return "_text" if source == :held

      case source
      when :craft, :equipment, :pokemon_slot, :box then "_slottext"
      when :pokemon_inventory then "_invtext"
      when :party then "_partytext"
      when :adventure_party then "_apartytext"
      when :traveling_partner then "_tpartnertext"
      else "_text"
      end
    end

    def image_icon_suffix
      return "_image" if source == :held

      case source
      when :craft, :equipment, :pokemon_slot, :box then "_slotimage"
      when :pokemon_inventory then "_invimage"
      when :party then "_partyimage"
      when :adventure_party then "_apartyimage"
      when :traveling_partner then "_tpartnerimage"
      else "_image"
      end
    end
  end
end
