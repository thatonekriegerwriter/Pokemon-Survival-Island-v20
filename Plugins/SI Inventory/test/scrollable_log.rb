module InventoryScene
  # A minimal scrollable text display. Window_AdvancedTextPokemon doesn't
  # appear to support scrolling on its own, so this manually wraps text
  # into fixed-width lines and renders a scrolling WINDOW of them.
  # Scrolls via Input.jumping_up?/jumping_down?, only while the mouse is
  # over its bounds (per your spec).
  #
  # CAVEAT: line-wrapping here is by character count, not measured pixel
  # width - I don't have access to a text-measurement API in this
  # environment, so CHARS_PER_LINE below is an approximation. If lines
  # run visibly long/short against your actual font, adjust it.
  class ScrollableLog
    CHARS_PER_LINE_DIVISOR = 6 # rough px-per-character guess at font size ~14

    attr_reader :scroll_offset

    def initialize(viewport:, x:, y:, width:, height:, font_size: 14, line_height: 16)
      @x, @y, @width, @height = x, y, width, height
      @line_height = line_height
      @visible_lines = [height / line_height, 1].max
      @lines = []
      @scroll_offset = 0

      @window = Window_AdvancedTextPokemon.new("")
      @window.visible = true
      @window.letterbyletter = false
      @window.viewport = viewport
      @window.windowskin = nil
      @window.baseColor = MessageConfig::DARK_TEXT_MAIN_COLOR if defined?(MessageConfig)
      @window.contents.font.size = font_size if @window.contents
      @window.x = x
      @window.y = y
      @window.width = width
      @window.height = height
      @window.z = 9999
    end

    def text=(full_text)
      @lines = wrap_text(full_text.to_s)
      @scroll_offset = 0
      refresh
    end

    def hovered?
      mouse_x, mouse_y = Mouse.getMousePos
      return false if mouse_x.nil?

      mouse_x >= @x && mouse_x < @x + @width && mouse_y >= @y && mouse_y < @y + @height
    end

    def update
      return unless hovered?

      if Input.jumping_up? && @scroll_offset.positive?
        @scroll_offset -= 1
        refresh
      elsif Input.jumping_down? && @scroll_offset < max_offset
        @scroll_offset += 1
        refresh
      end
    end

    def dispose
      @window.dispose unless @window.disposed?
    end

    private

    def max_offset = [@lines.length - @visible_lines, 0].max

    def wrap_text(text)
      chars_per_line = [@width / CHARS_PER_LINE_DIVISOR, 1].max
      text.split("\n").flat_map do |paragraph|
        next [""] if paragraph.empty?

        paragraph.scan(/.{1,#{chars_per_line}}(?:\s|$)/).map(&:strip)
      end
    end

    def refresh
      visible = @lines[@scroll_offset, @visible_lines] || []
      @window.text = visible.join("\n")
    end
  end
end
