module InventoryScene
  TradeRecipe = Struct.new(:recipe, :result, :yield)
end

module InventoryScene
  module Stations
    class XatuTrader < BaseStation
      TRADES_PER_PAGE = Settings::MAX_PARTY_SIZE
      TRADE_SLOT_SIZE = 36

      def initialize(event_data:, container:, trades:)
        @trades = trades
        @selected_trade = 0
        @trade_page = 0
        super(event_data: event_data, container: container)
      end

      def slot_count = 1
      def recipe_station_key = :XATUTRADER
      def background_key = "Inventory"
      def has_party_sidebar? = false
      def recipe_matching_slots = craft
      def shows_search_ui? = false 
	  
      def on_craft_consumed(_recipe)
        entry = @trades[@selected_trade]
        entry[2] -= 1 if entry[2]
      end
	  
      def crafting_data
        return [] unless @selected_trade
        cost, output, uses = @trades[@selected_trade]
        return [] if uses && uses <= 0
        [InventoryScene::TradeRecipe.new([cost], [output[0]], output[1])]
      end

      private

      def render_station
        render_trade_slots
        render_trade_sidebar
      end

      def render_trade_slots
        sprites["craft_slots0"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots0"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/placeholder_slot")
        sprites["craft_slots0"].z = 70
        sprites["craft_slots0"].x = bonus_1 + 94
        sprites["craft_slots0"].y = bonus_2 + 60
        render_slot_icon(:craft, 0, *craft[0]) if craft[0]

        sprites["craft_slots_equals"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_equals"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/arrow")
        sprites["craft_slots_equals"].z = 70
        sprites["craft_slots_equals"].x = sprites["craft_slots0"].x + 36
        sprites["craft_slots_equals"].y = sprites["craft_slots0"].y - 10

        sprites["craft_slots_result"] = IconSprite.new(0, 0, viewport)
        sprites["craft_slots_result"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/pocket/result_slot")
        sprites["craft_slots_result"].z = 70
        sprites["craft_slots_result"].x = sprites["craft_slots0"].x + 128
        sprites["craft_slots_result"].y = sprites["craft_slots0"].y - 8
      end

      def hit_tradeside?
        sprite_hit?(sprites["tradeside"])
      end
      def render_trade_sidebar
        sprites["tradeside"] = IconSprite.new(0, 0, viewport)
        sprites["tradeside"].setBitmap("Graphics/Pictures/craftingMenu/newCraftingPages/sidepkmn")
        sprites["tradeside"].z = 0
        sprites["tradeside"].x = Graphics.width - 56 - 72 - 12
        sprites["tradeside"].y = 14

        TRADES_PER_PAGE.times { |i| build_trade_row_sprites(i) }

        sprites["trade_uparrow"] = AnimatedSprite.new("Graphics/Pictures/uparrow", 8, 28, 40, 2, viewport)
        sprites["trade_uparrow"].x = sprites["tradeside"].x + 50
        sprites["trade_uparrow"].y = sprites["tradeside"].y - 20
        sprites["trade_uparrow"].play
        sprites["trade_uparrow"].visible = @trades.length > TRADES_PER_PAGE

        sprites["trade_downarrow"] = AnimatedSprite.new("Graphics/Pictures/downarrow", 8, 28, 40, 2, viewport)
        sprites["trade_downarrow"].x = sprites["tradeside"].x + 50
        sprites["trade_downarrow"].y = sprites["tradeside"].y + 10 + TRADES_PER_PAGE * TRADE_SLOT_SIZE
        sprites["trade_downarrow"].play
        sprites["trade_downarrow"].visible = @trades.length > TRADES_PER_PAGE

        refresh_trade_sidebar
      end

      def build_trade_row_sprites(i)
        sprites["#{i}_traderowslot"] = IconSprite.new(0, 0, viewport)
        sprites["#{i}_traderowslot"].setBitmap("Graphics/Pictures/craftingMenu/placeholder_slot")
        sprites["#{i}_traderowslot"].x = sprites["tradeside"].x - 4 + sprites["#{i}_traderowslot"].width / 2
        sprites["#{i}_traderowslot"].y = sprites["tradeside"].y - 4 + (TRADE_SLOT_SIZE * i) + sprites["#{i}_traderowslot"].height / 2
        sprites["#{i}_traderowslot"].z = 1

        sprites["traderowstar#{i}"] = IconSprite.new(0, 0, viewport)
        sprites["traderowstar#{i}"].setBitmap("Graphics/Pictures/craftingMenu/star")
        sprites["traderowstar#{i}"].z = 9998
        sprites["traderowstar#{i}"].x = sprites["#{i}_traderowslot"].x + 26
        sprites["traderowstar#{i}"].y = sprites["#{i}_traderowslot"].y + 2
        sprites["traderowstar#{i}"].visible = false
      end

      def refresh_trade_sidebar
        rows = visible_trades

        TRADES_PER_PAGE.times do |i|
          sprites["#{i}_traderowslot"].visible = i < rows.length

          unless i < rows.length
            remove(icons[icon_key(:trade_cost, i, :image)])
            remove(icons[icon_key(:trade_cost, i, :text)])
            remove(icons[icon_key(:trade_output, i, :image)])
            remove(icons[icon_key(:trade_output, i, :text)])
            next
          end

          cost, output, uses = rows[i]
          exhausted = uses && uses <= 0
		  
		  
		  
          cost_img, cost_txt = render_slot_icon(:trade_cost, i, cost[0], cost[1])
		  cost_txt.z = cost_img.z + 1
          output_img, output_txt = render_slot_icon(:trade_output, i, output[0], output[1])
		  output_txt.z = output_img.z + 1

          if exhausted
            cost_img.opacity = SEARCH_DIM_OPACITY
            cost_txt.contents_opacity = SEARCH_DIM_OPACITY
            output_img.opacity = SEARCH_DIM_OPACITY
            output_txt.contents_opacity = SEARCH_DIM_OPACITY
          end
		  
          trade_index = @trade_page * TRADES_PER_PAGE + i
          sprites["traderowstar#{i}"].visible = (trade_index == @selected_trade)
        end

        sprites["trade_uparrow"].visible   = @trade_page > 0 && @trades.length > TRADES_PER_PAGE
        sprites["trade_downarrow"].visible = (@trade_page + 1) * TRADES_PER_PAGE < @trades.length && @trades.length > TRADES_PER_PAGE
      end

      def visible_trades
        @trades[@trade_page * TRADES_PER_PAGE, TRADES_PER_PAGE] || []
      end

      def handle_custom_click(button)
        return false unless button == :left

        if hit_trade_uparrow?
          return true unless @trade_page > 0
          @trade_page -= 1
          refresh_trade_sidebar
          return true
        end

        if hit_trade_downarrow?
          return true unless (@trade_page + 1) * TRADES_PER_PAGE < @trades.length
          @trade_page += 1
          refresh_trade_sidebar
          return true
        end

        row = hit_trade_row_index
        return false unless row

        trade_index = @trade_page * TRADES_PER_PAGE + row
        return false unless trade_index < @trades.length

        _, _, uses = @trades[trade_index]
        return true if uses && uses <= 0
		
		
        @selected_trade = trade_index
        refresh_trade_sidebar
        return true
      end

      def process_input
        super
        if Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN) || (hit_tradeside? && Input.jumping_down?)
          trade_page_down!
        elsif Input.trigger?(Input::UP) || Input.repeat?(Input::UP) || (hit_tradeside? && Input.jumping_up?)
          trade_page_up!
        end
      end
 
      def trade_page_up!
        return unless @trade_page > 0
        @trade_page -= 1
        refresh_trade_sidebar
      end
 
      def trade_page_down!
        return unless (@trade_page + 1) * TRADES_PER_PAGE < @trades.length
        @trade_page += 1
        refresh_trade_sidebar
      end

      def hit_trade_row_index
        mouse_x, mouse_y = Mouse.getMousePos
        return nil if mouse_x.nil?

        TRADES_PER_PAGE.times do |i|
          slot = sprites["#{i}_traderowslot"]
          next unless slot && slot.visible

          return i if point_in_slot?(mouse_x, mouse_y, slot.x, slot.y) ||
                      point_in_slot?(mouse_x, mouse_y, slot.x + 40, slot.y)
        end
        nil
      end
      def item_hovered?
        super || hovered_trade_stack
      end

      def hovered_trade_stack
        mouse_x, mouse_y = Mouse.getMousePos
        return nil if mouse_x.nil?

        TRADES_PER_PAGE.times do |i|
          slot = sprites["#{i}_traderowslot"]
          next unless slot && slot.visible

          trade_index = @trade_page * TRADES_PER_PAGE + i
          next unless trade_index < @trades.length

          cost, output = @trades[trade_index]
          return cost   if point_in_slot?(mouse_x, mouse_y, slot.x, slot.y)
          return output if point_in_slot?(mouse_x, mouse_y, slot.x + 40, slot.y)
        end
        nil
      end

      def point_in_slot?(mouse_x, mouse_y, x, y)
        mouse_x >= x && mouse_x < x + BaseStation::SLOT_SIZE &&
          mouse_y >= y && mouse_y < y + BaseStation::SLOT_SIZE
      end

      def hit_trade_uparrow?
        sprite_hit?(sprites["trade_uparrow"])
      end

      def hit_trade_downarrow?
        sprite_hit?(sprites["trade_downarrow"])
      end
      def sprite_hit?(sprite)
        return false unless sprite && sprite.visible

        mouse_x, mouse_y = Mouse.getMousePos
        return false if mouse_x.nil?

        mouse_x >= sprite.x && mouse_x < sprite.x + sprite.bitmap.width &&
          mouse_y >= sprite.y && mouse_y < sprite.y + sprite.bitmap.height
      end
    end
  end
end


def pbXatuTrade(trade_id)
  trades = pbGetXatuTrade(trade_id)
  Inventory.tradeWindow(trades)
end

module Inventory
  def self.tradeWindow(trades)
    return if $game_temp.in_inventory==true
    return if $game_temp.assignment_cooldown>0
    $game_temp.in_menu = true
    $game_temp.inv_cooldown = 5
    $OverworldMenu.should_refresh = true 
    craftScene=InventoryScene::Stations::XatuTrader.new(event_data: nil, container: [], trades: trades)
    item=craftScene.pbSelectcraft
    $game_temp.in_inventory = false 
    $game_temp.in_menu = false
  end
end 



EventHandlers.add(:on_new_day, :clear_trades,
  proc {
	$PokemonGlobal.xatu_trades = {}
  }
)

class PokemonGlobalMetadata
	attr_accessor :xatu_trades

    def xatu_trades
	  @xatu_trades = {} if @xatu_trades.nil?
	  return @xatu_trades 
	end 

end 


def pbGetXatuTrade(trade_id)
   interp = pbMapInterpreter
   this_event = interp.get_self
  if this_event
    id = this_event.id
  else
    id = :PLAYER
  end 
  return $PokemonGlobal.xatu_trades[id] if $PokemonGlobal.xatu_trades[id] && id != :PLAYER
  if trade_id.is_a?(Array)
    randomize = trade_id[0]
	trades = trade_id[1]
	trades = trades.sample(Settings::MAX_PARTY_SIZE) if randomize
  else
   original_trades =  case trade_id
     when :OCEAN then Trades::TRADE1
     when :BREEDXATU then Trades::TRADE2
     when :TMXATU then Trades::TRADE3
     when :MARTXATU then Trades::TRADE4
     when :OCEANDUPE then Trades::TRADE5
   end
   if Trades::RANDOMIZETRADES[trade_id]
    trades = original_trades.sample(Settings::MAX_PARTY_SIZE) 
   else
    trades = original_trades
   end 
  end 
  
  trades = trades.map { |cost, result, max_uses| [cost.dup, result.dup, max_uses] }
  $PokemonGlobal.xatu_trades[id] = trades if id != :PLAYER
  return trades
end


class Trades
RANDOMIZETRADES = {
  :OCEAN      => true,
  :BREEDXATU  => true,
  :TMXATU     => true,
  :MARTXATU   => false,
  :OCEANDUPE  => false
}

TRADE1 = [
  [[:REDSHARD, 9], [:STARPIECE, 1], 16], 
  [[:SNOWBALL, 16], [:STARPIECE, 1], 16], 
  [[:GREENSHARD, 9], [:STARPIECE, 1], 16],
  [[:BLUESHARD, 9], [:STARPIECE, 1], 16],
  [[:YELLOWSHARD, 9], [:STARPIECE, 1], 16],
  [[:SHOALSALT, 1], [:STARPIECE, 1], 16],
  [[:RAREBONE, 8], [:STARPIECE, 1], 8],
  [[:REDAPRICORN, 28], [:STARPIECE, 1], 8],
  [[:ORANBERRY, 20], [:STARPIECE, 1], 8],
  [[:DAMPROCK, 4], [:STARPIECE, 1], 4],
  [[:HEATROCK, 4], [:STARPIECE, 1], 4],
  [[:SMOOTHROCK, 4], [:STARPIECE, 1], 4],
  [[:ICYROCK, 4], [:STARPIECE, 1], 4],
  [[:SHOALSHELL, 2], [:STARPIECE, 1], 4],
  [[:OVALSTONE, 1], [:STARPIECE, 1], 4],
  [[:EVIOLITE, 1], [:STARPIECE, 1], 4],
  [[:EVERSTONE, 1], [:STARPIECE, 1], 4],
  [[:PEARL, 4], [:STARPIECE, 1], 4],
  [[:HONEY, 4], [:STARPIECE, 1], 4],
  [[:DEEPSEATOOTH, 2], [:STARPIECE, 1], 4],
  [[:DEEPSEASCALE, 2], [:STARPIECE, 1], 4],
  [[:MYSTICWATER, 2], [:STARPIECE, 1], 4],
  [[:BIGPEARL, 1], [:STARPIECE, 1], 2],
  [[:KINGSROCK, 2], [:STARPIECE, 1], 2],
  
  
  [[:STARPIECE, 1], [:SHOALSALT, 1], 16],
  [[:STARPIECE, 2], [:BRIGHTPOWDER, 1], 16],
  [[:STARPIECE, 4], [:LEPPABERRY, 1], 8],
  [[:STARPIECE, 4], [:OCCABERRY, 1], 8],
  [[:STARPIECE, 4], [:PASSHOBERRY, 1], 8],
  [[:STARPIECE, 4], [:SHUCABERRY, 1], 8],
  [[:STARPIECE, 4], [:YACHEBERRY, 1], 8],
  [[:STARPIECE, 8], [:LUCKYEGG, 1], 2],
  [[:STARPIECE, 8], [:IRONBALL, 1], 2],
  [[:STARPIECE, 4], [:HARDSTONE, 1], 2],
  [[:STARPIECE, 8], [:BLUEFLUTE, 1], 1],
  [[:STARPIECE, 8], [:SHELLBELL, 1], 1],
  [[:STARPIECE, 16], [:WIDELENS, 1], 1],
  [[:STARPIECE, 16], [:ZOOMLENS, 1], 1],
  [[:STARPIECE, 16], [:SCOPELENS, 1], 1],
].freeze 


TRADE1NEW = [
  [[:RAREBONE, 1], [:LEPPABERRY, 1]],
  [[:HEATROCK, 1], [:OCCABERRY, 1]],
  [[:DAMPROCK, 1], [:PASSHOBERRY, 1]],
  [[:SMOOTHROCK, 1], [:SHUCABERRY, 1]],
  [[:ICYROCK, 1], [:YACHEBERRY, 1]],
  [[:BLUESHARD, 1], [:BLUEFLUTE, 1]],
  [[:WATERSTONE, 1], [:MYSTICWATER, 1]],
  [[:THUNDERSTONE, 1], [:BRIGHTPOWDER, 1]], #This needs to be cheaper but still thematic
  [[:OVALSTONE, 1], [:LUCKYEGG, 1]],
  [[:ODDKEYSTONE, 1], [:SPELLTAG, 1]],



#Add trades for starpieces? Replace the item trades with starpiece trades?
].freeze 

TRADE1OLD = [
#  [[:STARPIECE, 1], [:YELLOWAPRICORN, 1]], #CHANGE YELLOW APRICORNS ARE IN THE WORLD, UNNEEDED
  [[:RAREBONE, 1], [:LEPPABERRY, 1]],
 # [[:HEARTSCALE, 1], [:STARFBERRY, 1]],
  [[:HEATROCK, 1], [:OCCABERRY, 1]],
  [[:DAMPROCK, 1], [:PASSHOBERRY, 1]],
  [[:SMOOTHROCK, 1], [:SHUCABERRY, 1]],
  [[:ICYROCK, 1], [:YACHEBERRY, 1]],
 # [[:REDSHARD, 1], [:JOYSCENT, 1]], #CHANGE
 # [[:GREENSHARD, 1], [:EXCITESCENT, 1]], #CHANGE
#  [[:YELLOWSHARD, 1], [:VIVIDSCENT, 1]], #CHANGE
  [[:BLUESHARD, 1], [:BLUEFLUTE, 1]],
#  [[:LIGHTCLAY, 1], [:WHITEAPRICORN, 1]], #CHANGE WHITE APRICORNS ARE IN THE WORLD, UNNEEDED
#  [[:FIRESTONE, 1], [:CHARCOAL, 1]], #CHANGE
  [[:WATERSTONE, 1], [:MYSTICWATER, 1]],
  [[:THUNDERSTONE, 1], [:BRIGHTPOWDER, 1]],
#  [[:LEAFSTONE, 1], [:MIRACLESEED, 1]], #CHANGE
#  [[:MOONSTONE, 1], [:ROSELIBERRY, 1]], #CHANGE
#  [[:SUNSTONE, 1], [:SILKSCARF, 1]], #SILK SCARF IS A SEWING MACHINE ITEM
  [[:OVALSTONE, 1], [:LUCKYEGG, 1]],
#  [[:EVERSTONE, 1], [:ABILITYCAPSULE, 1]], #CHANGE
#  [[:EVIOLITE, 1], [:ABILITYPATCH, 1]], #CHANGE
  [[:ODDKEYSTONE, 1], [:SPELLTAG, 1]],
#  [[:INSECTPLATE, 1], [:SWIFTWING, 1]],
#  [[:DREADPLATE, 1], [:COLBURBERRY, 1]],
#  [[:DRACOPLATE, 1], [:DRAGONFANG, 1]],
#  [[:ZAPPLATE, 1], [:ELECTRICGEM, 1]],
#  [[:FISTPLATE, 1], [:BLACKBELT, 1]],
#  [[:FLAMEPLATE, 1], [:ELECTRICGEM, 1]],
#  [[:MEADOWPLATE, 1], [:ROSEINCENSE, 1]],
#  [[:EARTHPLATE, 1], [:SOFTSAND, 1]], #REMOVE
#  [[:ICICLEPLATE, 1], [:WEAKNESSPOLICY, 1]],
#  [[:TOXICPLATE, 1], [:BLACKSLUDGE, 1]],
#  [[:MINDPLATE, 1], [:MAGOSTBERRY, 1]],
#  [[:STONEPLATE, 1], [:CORNNBERRY, 1]],
#  [[:SKYPLATE, 1], [:FLYINGGEM, 1]],
#  [[:SPOOKYPLATE, 1], [:WIDELENS, 1]],
#  [[:IRONPLATE, 1], [:STEELGEM, 1]],
#  [[:SPLASHPLATE, 1], [:SAFETYGOGGLES, 1]],
#  [[:NOMELBERRY, 1], [:FLYINGGEM, 1]],
#  [[:SMOKEBALL, 1], [:ASSAULTVEST, 1]],
].freeze 

TRADE2 = [
  [[:STARPIECE, 2], [:FULLINCENSE, 1]],
  [[:STARPIECE, 2], [:LAXINCENSE, 1]],
  [[:STARPIECE, 2], [:LUCKINCENSE, 1]],
  [[:STARPIECE, 2], [:PUREINCENSE, 1]],
  [[:STARPIECE, 2], [:SEAINCENSE, 1]],
  [[:STARPIECE, 2], [:WAVEINCENSE, 1]],
  [[:STARPIECE, 2], [:ROSEINCENSE, 1]],
  [[:STARPIECE, 2], [:ODDINCENSE, 1]],
  [[:STARPIECE, 2], [:ROCKINCENSE, 1]],
  [[:STARPIECE, 5], [:ABILITYCAPSULE, 1]],
  [[:STARPIECE, 10], [:DESTINYKNOT, 1]],
].freeze 

TRADE3 = [
  [[:STARPIECE, 2], [:TM93, 1]],
  [[:STARPIECE, 2], [:TM86, 1]],
  [[:STARPIECE, 2], [:TM87, 1]],
  [[:STARPIECE, 2], [:TM35, 1]],
  [[:STARPIECE, 2], [:TM30, 1]],
  [[:STARPIECE, 2], [:TM22, 1]],
  [[:STARPIECE, 2], [:TM24, 1]],
  [[:STARPIECE, 2], [:TM02, 1]],
  [[:STARPIECE, 2], [:TM10, 1]],
  [[:STARPIECE, 2], [:TM64, 1]],
  [[:STARPIECE, 2], [:TM62, 1]],
  [[:STARPIECE, 2], [:TM81, 1]],
  [[:STARPIECE, 2], [:TM92, 1]],
  [[:STARPIECE, 2], [:TM38, 1]],
  [[:STARPIECE, 2], [:TM29, 1]],
  [[:STARPIECE, 2], [:TM23, 1]],
  [[:STARPIECE, 2], [:TM46, 1]],
  [[:STARPIECE, 2], [:TM48, 1]],
  [[:STARPIECE, 2], [:TM18, 1]],
  [[:STARPIECE, 2], [:TM17, 1]],
  [[:STARPIECE, 2], [:TM27, 1]],
  [[:STARPIECE, 2], [:TM04, 1]],
  [[:STARPIECE, 2], [:TM43, 1]],
  [[:STARPIECE, 2], [:TM36, 1]],
  [[:STARPIECE, 2], [:TM37, 1]],
  [[:STARPIECE, 2], [:TM15, 1]],
  [[:STARPIECE, 2], [:TM59, 1]],
  [[:STARPIECE, 2], [:TM71, 1]],
  [[:STARPIECE, 2], [:TM75, 1]],
  [[:STARPIECE, 2], [:TM08, 1]],
  [[:STARPIECE, 2], [:TM76, 1]],
  [[:STARPIECE, 2], [:TM70, 1]],
  [[:STARPIECE, 2], [:TM78, 1]],
  [[:STARPIECE, 2], [:TM28, 1]],
  [[:STARPIECE, 2], [:TM01, 1]],
  [[:STARPIECE, 2], [:TM96, 1]],
  [[:STARPIECE, 2], [:TM98, 1]],
  [[:STARPIECE, 2], [:TM94, 1]],
  [[:STARPIECE, 2], [:TM12, 1]],
  [[:STARPIECE, 2], [:TM99, 1]],
].freeze 

TRADE4 = [
  [[:STARPIECE, 1], [:ORANBERRY, 2]],
  [[:STARPIECE, 2], [:FRESHWATER, 1]],
  [[:STARPIECE, 1], [:EVERSTONE, 1]],
  [[:STARPIECE, 2], [:EVIOLITE, 1]],
  [[:STARPIECE, 4], [:BLACKFLUTE, 1]],
  [[:STARPIECE, 4], [:WHITEFLUTE, 1]],
  [[:STARPIECE, 6], [:LEFTOVERS, 1]],
  [[:STARPIECE, 20], [:ARGOSTBERRY, 1]],
  [[:STARPIECE, 20], [:WONDERORB, 1]],
].freeze 

TRADE5 = [
  [[:STARPIECE, 1], [:YELLOWAPRICORN, 1]],
  [[:RAREBONE, 1], [:LEPPABERRY, 1]],
#  [[:HEARTSCALE, 1], [:STARFBERRY, 1]],
  [[:HEATROCK, 1], [:OCCABERRY, 1]],
  [[:DAMPROCK, 1], [:PASSHOBERRY, 1]],
  [[:SMOOTHROCK, 1], [:SHUCABERRY, 1]],
  [[:ICYROCK, 1], [:YACHEBERRY, 1]],
  [[:REDSHARD, 1], [:JOYSCENT, 1]],
  [[:GREENSHARD, 1], [:EXCITESCENT, 1]],
  [[:YELLOWSHARD, 1], [:VIVIDSCENT, 1]],
  [[:BLUESHARD, 1], [:BLUEFLUTE, 1]],
  [[:LIGHTCLAY, 1], [:WHITEAPRICORN, 1]],
  [[:FIRESTONE, 1], [:CHARCOAL, 1]],
  [[:WATERSTONE, 1], [:MYSTICWATER, 1]],
  [[:THUNDERSTONE, 1], [:BRIGHTPOWDER, 1]],
  [[:LEAFSTONE, 1], [:MIRACLESEED, 1]],
  [[:MOONSTONE, 1], [:ROSELIBERRY, 1]],
  [[:SUNSTONE, 1], [:SILKSCARF, 1]],
  [[:OVALSTONE, 1], [:LUCKYEGG, 1]],
  [[:EVERSTONE, 1], [:ABILITYCAPSULE, 1]],
  [[:SILVERORE, 1], [:EXPSHARE, 1]],
  [[:EVIOLITE, 1], [:ABILITYPATCH, 1]],
  [[:IRONBALL, 1], [:IRON2, 2]],
  [[:HARDSTONE, 1], [:STONE, 2]],
  [[:ODDKEYSTONE, 1], [:SPELLTAG, 1]],
#  [[:INSECTPLATE, 1], [:SWIFTWING, 1]],
#  [[:DREADPLATE, 1], [:COLBURBERRY, 1]],
  [[:DRACOPLATE, 1], [:DRAGONFANG, 1]],
  [[:ZAPPLATE, 1], [:TM15, 1]],
  [[:FISTPLATE, 1], [:BLACKBELT, 1]],
  [[:FLAMEPLATE, 1], [:TM11, 1]],
  [[:MEADOWPLATE, 1], [:ROSEINCENSE, 1]],
  [[:EARTHPLATE, 1], [:SOFTSAND, 1]],
  [[:ICICLEPLATE, 1], [:WEAKNESSPOLICY, 1]],
  [[:TOXICPLATE, 1], [:BLACKSLUDGE, 1]],
  [[:MINDPLATE, 1], [:MAGOSTBERRY, 1]],
  [[:STONEPLATE, 1], [:CORNNBERRY, 1]],
  [[:SKYPLATE, 1], [:FLYINGGEM, 1]],
  [[:SPOOKYPLATE, 1], [:WIDELENS, 1]],
  [[:IRONPLATE, 1], [:TM37, 1]],
  [[:SPLASHPLATE, 1], [:SAFETYGOGGLES, 1]],
#  [[:NOMELBERRY, 1], [:FLYINGGEM, 1]],
  [[:SMOKEBALL, 1], [:ASSAULTVEST, 1]],
].freeze 



end 
