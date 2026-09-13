#===============================================================================
# Adventure Guide - an in-bag reference book / journal menu.
#
# Using the ADVENTURERULES item from the bag opens the guide. Books.rb (or
# any other file loaded after this one) registers content via
# AdventureGuide.register_book. Progress (unlocks, read/seen state, last
# position) persists via PokemonGlobalMetadata#adventure_guide_progress -
# see Adventure_Guide_Metadata.rb.
#===============================================================================
ItemHandlers::UseFromBag.add(:ADVENTURERULES, proc { |item|
  next AdventureGuide.show ? 1 : 0
})

class PokemonGlobalMetadata
  attr_accessor :adventure_guide_progress
end

module AdventureGuide
  # A single chapter inside a Book.
  #   unlocks_book - id (symbol) of another book to reveal once this chapter
  #                  has been read all the way through. nil if it doesn't
  #                  unlock anything extra.
  Chapter = Struct.new(:name, :description, :enabled, :unlocks_book, keyword_init: true) do
    def enabled? = !!enabled
  end

  # A book made up of one or more chapters.
  Book = Struct.new(:id, :name, :description, :enabled, :chapters, keyword_init: true) do
    def enabled? = !!enabled
    def enabled_chapters = chapters.select(&:enabled?)
  end

  UNLOCK_SE_NAME = "itemlevel"

  @books = []

  # Registers a new book. Example:
  #   AdventureGuide.register_book(
  #     id: :recipes, name: "...", description: "...", enabled: false,
  #     chapters: [
  #       { name: "Tea", description: "...", enabled: false },
  #       { name: "Lemonade", description: "...", enabled: false, unlocks_book: :some_other_book },
  #     ]
  #   )
  def self.register_book(id:, name:, description:, enabled:, chapters:)
    @books << Book.new(
      id: id, name: name, description: description, enabled: enabled,
      chapters: chapters.map { |c| Chapter.new(**c) }
    )
  end

  def self.books = @books

  def self.find_book(id) = @books.find { |b| b.id == id }

  def self.show
    pbFadeOutIn {
      scene = Scene.new
      scene.main
      scene.end_scene
    }
  end

  def self.play_unlock_se
    pbSEPlay(UNLOCK_SE_NAME) if defined?(pbSEPlay)
  end

  #---------------------------------------------------------------------------
  # Persisted progress (lives on $PokemonGlobal so it saves with the game).
  #---------------------------------------------------------------------------
  def self.default_progress
    { unlocked: [], read: [], seen_books: [], seen_chapters: [], last_position: nil }
  end

  def self.progress
    if defined?($PokemonGlobal) && $PokemonGlobal
      $PokemonGlobal.adventure_guide_progress ||= default_progress
    else
      # No active game session (e.g. testing outside the engine) - fall back
      # to an in-memory hash so nothing crashes.
      @fallback_progress ||= default_progress
    end
  end

  #=============================================================================
  # Scene - draws and drives the three-page guide UI (books -> chapters ->
  # description) and handles reading-based unlocks.
  #=============================================================================
  class Scene
    PAGE_BOOKS       = 0
    PAGE_CHAPTERS    = 1
    PAGE_DESCRIPTION = 2

    VISIBLE_ROWS = { PAGE_BOOKS => 8, PAGE_CHAPTERS => 10, PAGE_DESCRIPTION => 10 }.freeze

    DESCRIPTION_WRAP_WIDTH = { PAGE_BOOKS => 470, PAGE_DESCRIPTION => 450 }.freeze
    CHAR_WIDTH_PX = 12

    TEXT_ON_LIGHT = [Color.new(0, 0, 0), Color.new(255, 255, 255)].freeze # black text, white shadow
    TEXT_ON_DARK  = [Color.new(255, 255, 255), Color.new(0, 0, 0)].freeze # white text, black shadow

    def initialize
      @sprites = {}
      @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
      @viewport.z = 99_999

      @page = PAGE_BOOKS
      @previous_page = -1
      @position = [0, 0, 0]
      @exit = false

      @frame = 0
      @desc_scroll_offset = 0
      @chapter_fully_read = false

      @book_names = []
      @book_descriptions = []
      @chapter_names = []
      @chapter_descriptions = []
      @lists_dirty = true
    end

    def main
      apply_saved_progress
      restore_last_position
      create_scene
      until @exit
        update_ingame
        update_arrows
        update_background
        update_choice_cursor
        update_text
        process_input
      end
    end

    #---------------------------------------------------------------------------
    # Content lists (rebuilt only when something changes, not every frame)
    #---------------------------------------------------------------------------
    def enabled_books = AdventureGuide.books.select(&:enabled?)

    def current_book = enabled_books[@position[PAGE_BOOKS]]

    def current_chapter = current_book&.enabled_chapters&.[](@position[PAGE_CHAPTERS])

    def mark_lists_dirty = @lists_dirty = true

    def refresh_lists
      @book_names = []
      @book_descriptions = []
      @chapter_names = []
      @chapter_descriptions = []

      enabled_books.each do |book|
        @book_names << display_name_for_book(book)
        @book_descriptions << wrap_text(book.description, DESCRIPTION_WRAP_WIDTH[PAGE_BOOKS])

        chapters = book.enabled_chapters
        @chapter_names << chapters.map { |c| display_name_for_chapter(book, c) } + ["Return"]
        @chapter_descriptions << chapters.map { |c| wrap_text(c.description, DESCRIPTION_WRAP_WIDTH[PAGE_DESCRIPTION]) }
      end
      @book_names << "Exit"
      @lists_dirty = false
    end

    def wrap_text(text, max_width_px)
      return [] if text.nil? || text.empty?

      max_chars = max_width_px / CHAR_WIDTH_PX
      lines = []

      text.split("\n").each do |paragraph|
        line = ""
        paragraph.split(" ").each do |word|
          candidate = line.empty? ? word : "#{line} #{word}"
          if candidate.length > max_chars && !line.empty?
            lines << line
            line = word
          else
            line = candidate
          end
        end
        lines << line unless line.empty?
      end

      lines
    end

    #---------------------------------------------------------------------------
    # Shared windowed-scroll math: given a selected index, the total number of
    # items, and how many rows are visible at once, returns the first visible
    # index, how many rows to draw, and which visible row the cursor sits on.
    #---------------------------------------------------------------------------
    def scroll_window(position, total, visible)
      return [0, total, position] if total <= visible

      half = visible / 2
      if position < half
        [0, visible, position]
      elsif position < total - half
        [position - (half - 1), visible, half - 1]
      else
        [total - visible, visible, visible - 1 - (total - 1 - position)]
      end
    end

    #---------------------------------------------------------------------------
    # Progress persistence
    #---------------------------------------------------------------------------
    # Identity-based lookup (not by name/description) so two chapters with
    # coincidentally identical text can never be confused for one another.
    def chapter_index_in_book(book, chapter)
      book.chapters.find_index { |c| c.equal?(chapter) }
    end

    def chapter_key(book, chapter) = [book.id, chapter_index_in_book(book, chapter)]

    def apply_saved_progress
      data = AdventureGuide.progress
      AdventureGuide.books.each do |book|
        book.chapters.each_with_index do |chapter, idx|
          next unless data[:unlocked].include?([book.id, idx])

          chapter.enabled = true
          book.enabled = true
        end
      end
    end

    def record_unlock(book, chapter)
      key = chapter_key(book, chapter)
      progress = AdventureGuide.progress
      progress[:unlocked] << key unless progress[:unlocked].include?(key)
    end

    def record_read(book, chapter)
      key = chapter_key(book, chapter)
      progress = AdventureGuide.progress
      progress[:read] << key unless progress[:read].include?(key)
    end

    def mark_book_seen(book)
      progress = AdventureGuide.progress
      progress[:seen_books] << book.id unless progress[:seen_books].include?(book.id)
    end

    def mark_chapter_seen(book, chapter)
      key = chapter_key(book, chapter)
      progress = AdventureGuide.progress
      progress[:seen_chapters] << key unless progress[:seen_chapters].include?(key)
    end

    def book_new?(book) = !AdventureGuide.progress[:seen_books].include?(book.id)

    def chapter_new?(book, chapter) = !AdventureGuide.progress[:seen_chapters].include?(chapter_key(book, chapter))

    def chapter_read?(book, chapter) = AdventureGuide.progress[:read].include?(chapter_key(book, chapter))

    def display_name_for_book(book)
      book_new?(book) ? "#{book.name} (New!)" : book.name
    end

    def display_name_for_chapter(book, chapter)
      return "#{chapter.name} (Unread)" if chapter_new?(book, chapter)
      return "#{chapter.name}" if chapter_read?(book, chapter)

      chapter.name
    end

    def save_last_position
      book = current_book
      return unless book

      chapter_index = @page >= PAGE_CHAPTERS && current_chapter ? chapter_index_in_book(book, current_chapter) : nil
      AdventureGuide.progress[:last_position] = { page: @page, book_id: book.id, chapter_index: chapter_index }
    end

    # Restores the book/chapter selection from last time, landing on that
    # book's chapter list rather than jumping straight back into a
    # description (keeps this safe even if wrapping/rows changed since).
    def restore_last_position
      saved = AdventureGuide.progress[:last_position]
      return unless saved

      book_index = enabled_books.index { |b| b.id == saved[:book_id] }
      return unless book_index

      @position[PAGE_BOOKS] = book_index
      return unless saved[:page] && saved[:page] >= PAGE_CHAPTERS

      book = enabled_books[book_index]
      chapters = book.enabled_chapters
      chapter_row = chapters.index { |c| chapter_index_in_book(book, c) == saved[:chapter_index] }
      return unless chapter_row

      @position[PAGE_CHAPTERS] = chapter_row
      @page = PAGE_CHAPTERS
    end

    #---------------------------------------------------------------------------
    # Create
    #---------------------------------------------------------------------------
    def create_scene
      create_sprite(:background, "Scene_#{@page + 1}")
      %i[text title description].each { |key| create_text_sprite(key) }
      create_sprite(:choice, "Choice")
      update_choice_cursor
      show_sprite(:choice)

      2.times do |i|
        key = "arrow_#{i}".to_sym
        create_sprite(key, "Arrow")
        arrow = @sprites[key]
        w = arrow.bitmap.width
        h = arrow.bitmap.height / 2
        arrow.src_rect.set(0, h * i, w, h)
        arrow.x = Graphics.width / 2
        arrow.y = 43 + (241 + 20 - h) * i
        arrow.visible = false
      end

      update_text
    end

    def create_sprite(key, filename, folder: "Adventure Guide")
      @sprites[key] = Sprite.new(@viewport)
      @sprites[key].bitmap = Bitmap.new(sprite_path(filename, folder))
    end

    def create_text_sprite(key)
      @sprites[key] = Sprite.new(@viewport)
      @sprites[key].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    end

    def set_sprite_bitmap(key, filename, folder: "Adventure Guide")
      @sprites[key].bitmap = Bitmap.new(sprite_path(filename, folder))
    end

    def sprite_path(filename, folder)
      folder ? "Graphics/Pictures/#{folder}/#{filename}" : "Graphics/Pictures/#{filename}"
    end

    def show_sprite(key, visible = true) = @sprites[key].visible = visible

    #---------------------------------------------------------------------------
    # Update
    #---------------------------------------------------------------------------
    def update_background
      return if @previous_page == @page

      filename = (@page == PAGE_DESCRIPTION && description_overflows?) ? "Scene_#{@page + 1}_1" : "Scene_#{@page + 1}"
      set_sprite_bitmap(:background, filename)
      @previous_page = @page
    end

    def description_overflows?
      @chapter_descriptions[@position[PAGE_BOOKS]][@position[PAGE_CHAPTERS]].size > VISIBLE_ROWS[PAGE_DESCRIPTION]
    end

    def update_text
      refresh_lists if @lists_dirty
      draw_title
      draw_list
      draw_description
    end

    def update_choice_cursor
      show_sprite(:choice, @page != PAGE_DESCRIPTION)

      cursor_row =
        case @page
        when PAGE_BOOKS
          _, _, row = scroll_window(@position[PAGE_BOOKS], @book_names.size, VISIBLE_ROWS[PAGE_BOOKS])
          row
        when PAGE_CHAPTERS
          items = @chapter_names[@position[PAGE_BOOKS]]
          _, _, row = scroll_window(@position[PAGE_CHAPTERS], items.size, VISIBLE_ROWS[PAGE_CHAPTERS])
          row
        else
          0
        end

      @sprites[:choice].x = @page == PAGE_BOOKS ? 2 : 30
      @sprites[:choice].y = (@page == PAGE_BOOKS ? 63 : 95) + 28 * cursor_row
    end

    def update_arrows
      2.times do |i|
        arrow = @sprites["arrow_#{i}".to_sym]
        h = arrow.src_rect.height
        arrow.x = Graphics.width / 2
        arrow.y = @page == PAGE_BOOKS ? 43 + (241 - h) * i : 60 + 308 * i
      end

      visible_rows = VISIBLE_ROWS[@page]
      total =
        case @page
        when PAGE_BOOKS then @book_names.size
        when PAGE_CHAPTERS then @chapter_names[@position[PAGE_BOOKS]].size
        else @chapter_descriptions[@position[PAGE_BOOKS]][@position[PAGE_CHAPTERS]].size
        end


  if @page == PAGE_DESCRIPTION
    up_visible = @position[@page] > 0
    down_visible = @position[@page] < total - visible_rows
  else
    position = @position[@page]

    pos =
      if total > 0 && total < visible_rows
        0
      elsif position < visible_rows / 2
        0
      elsif position >= visible_rows / 2 && position < total - visible_rows / 2
        position - (visible_rows / 2 - 1)
      else
        total - visible_rows
      end

    up_visible = pos > 0
    down_visible = pos + visible_rows < total
  end

      @sprites[:arrow_0].visible = up_visible
      @sprites[:arrow_1].visible = down_visible
    end

    #---------------------------------------------------------------------------
    # Draw text
    #---------------------------------------------------------------------------
    def draw_title
      clear_text(:title)
      return if @page == PAGE_BOOKS

      entries = []
      title = @page == PAGE_CHAPTERS ? current_book&.name : current_chapter&.name
	  y = @page == PAGE_DESCRIPTION ? 35 : 45
      entries << [title, 20, y, 0, Color.new(255, 255, 255), Color.new(0, 0, 0)] if title

      if @page == PAGE_DESCRIPTION
        progress_text = description_progress_text
        # Right-aligned-ish fixed offset; nudge this if it clips at your resolution/font.
        entries << [progress_text, Graphics.width - 70, 35, 0, Color.new(255, 255, 255), Color.new(0, 0, 0)] if progress_text
      end

      draw_lines(:title, entries) unless entries.empty?
    end
    
	def get_lengths
      lines = @chapter_descriptions[@position[PAGE_BOOKS]][@position[PAGE_CHAPTERS]]
      return [0, 0] if lines.nil? || lines.empty?

      visible = VISIBLE_ROWS[PAGE_DESCRIPTION]
      max_position = [lines.size - visible, 0].max
      current_page = @position[PAGE_DESCRIPTION] + 1
      total_pages = max_position + 1
	  [current_page, total_pages]
	end 
	
	
    def description_progress_text
      lines = @chapter_descriptions[@position[PAGE_BOOKS]][@position[PAGE_CHAPTERS]]
      return nil if lines.nil? || lines.empty?

      visible = VISIBLE_ROWS[PAGE_DESCRIPTION]
      max_position = [lines.size - visible, 0].max
      current_page = @position[PAGE_DESCRIPTION] + 1
      total_pages = max_position + 1
      if total_pages > 1
       return "#{current_page}/#{total_pages}" 
	  else
	   return ""
	  end 
    end

    def draw_list
      clear_text(:text)
      return if @page == PAGE_DESCRIPTION

      items = @page == PAGE_BOOKS ? @book_names : @chapter_names[@position[PAGE_BOOKS]]
      start, count, = scroll_window(@position[@page], items.size, VISIBLE_ROWS[@page])

      x = @page == PAGE_BOOKS ? 18 : 50
      base_y = @page == PAGE_BOOKS ? 53 : 85

      entries = count.times.map do |i|
        [items[start + i], x, base_y + (20 + 8) * i - 10, 0, Color.new(255, 255, 255), Color.new(0, 0, 0)]
      end
      draw_lines(:text, entries)
    end

    def draw_description
      clear_text(:description)
      return if @page == PAGE_CHAPTERS

      x = @page == PAGE_BOOKS ? 40 : 50
      lines = @page == PAGE_BOOKS ? @book_descriptions[@position[PAGE_BOOKS]] : @chapter_descriptions[@position[PAGE_BOOKS]][@position[PAGE_CHAPTERS]]
      return unless lines

      entries = @page == PAGE_BOOKS ? animated_snippet_entries(lines, x) : full_description_entries(lines, x)
      draw_lines(:description, entries)
    end

    # The small auto-scrolling preview shown under a book on the book list page.
    def animated_snippet_entries(lines, x)
      start_index = 0
      visible = 3
      if lines.size > 3
        @frame += 1
        @frame = 0 if @frame > 32
        @desc_scroll_offset += 1 if @frame == 0
        @desc_scroll_offset = 0 if @desc_scroll_offset + 3 > lines.size
        start_index = @desc_scroll_offset
      else
        visible = lines.size
      end

      text_color, shadow_color = TEXT_ON_LIGHT
      visible.times.map { |i| [lines[start_index + i], x, 289 + (20 + 8) * i - 10, 0, text_color, shadow_color] }
    end

    # The full chapter text on the description page, scrolled by the player.
    def full_description_entries(lines, x)
      max = lines.size
      visible_rows = VISIBLE_ROWS[PAGE_DESCRIPTION]
      fits = max.positive? && max < visible_rows
      start = fits ? 0 : @position[PAGE_DESCRIPTION]
      count = fits ? max : visible_rows

      text_color, shadow_color = TEXT_ON_DARK
      count.times.map { |i| [lines[start + i], x, 75 + (20 + 8) * i - 10, 0, text_color, shadow_color] }
    end

    def draw_lines(sprite_key, entries)
      bitmap = @sprites[sprite_key].bitmap
      bitmap.clear
      pbSetSystemFont(bitmap)
      entries.each { |entry| entry[2] += 13 }
      pbDrawTextPositions(bitmap, entries)
    end

    def clear_text(sprite_key) = @sprites[sprite_key].bitmap.clear

    #---------------------------------------------------------------------------
    # Input
    #---------------------------------------------------------------------------
    def process_input
      if Input.trigger?(Input::BACK)
	    pbPlayCloseMenuSE
        handle_back
      elsif Input.trigger?(Input::USE)
        handle_confirm
		pbPlayDecisionSE
      elsif Input.trigger?(Input::UP) || Input.repeat?(Input::UP)
        move_selection(-1)
      elsif Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN)
        move_selection(1)
      end
      save_last_position unless @exit
    end
	

	
    def handle_back
      @page == PAGE_BOOKS ? (@exit = true) : (@page -= 1)

	    total_lines = @chapter_descriptions[@position[PAGE_BOOKS]][@position[PAGE_CHAPTERS]].size
        visible = VISIBLE_ROWS[PAGE_DESCRIPTION]
        @chapter_fully_read = true if total_lines < visible
      if @chapter_fully_read
        unlock_next_content
        @chapter_fully_read = false
        mark_lists_dirty
      end

      update_text
      reset_position
    end

    def handle_confirm
      case @page
      when PAGE_BOOKS, PAGE_CHAPTERS
        size = current_list_size
        if @position[@page] != size - 1
          mark_current_selection_seen
          @page += 1
        elsif @page == PAGE_BOOKS
          @exit = true
        else
          @page -= 1
        end
      else
	    total_lines = @chapter_descriptions[@position[PAGE_BOOKS]][@position[PAGE_CHAPTERS]].size
        visible = VISIBLE_ROWS[PAGE_DESCRIPTION]
        @chapter_fully_read = true if total_lines < visible
        if @chapter_fully_read
         unlock_next_content
         @chapter_fully_read = false
         mark_lists_dirty
       end
        @page -= 1
		
      end
      reset_position
    end

    def mark_current_selection_seen
      if @page == PAGE_BOOKS
        book = current_book
        mark_book_seen(book) if book
      elsif @page == PAGE_CHAPTERS
        book = current_book
        chapter = current_chapter
        mark_chapter_seen(book, chapter) if book && chapter
      end
    end

    def current_list_size
      @page == PAGE_BOOKS ? @book_names.size : @chapter_names[@position[PAGE_BOOKS]].size
    end

    def move_selection(delta)
      @position[@page] += delta
      return move_description_selection(delta) if @page == PAGE_DESCRIPTION

      size = current_list_size
      if delta.negative?
        @position[@page] = size - 1 if @position[@page] < 0
      else
        @position[@page] = 0 if @position[@page] >= size
      end
      pbPlayDecisionSE if size > 1
    end

    def move_description_selection(delta)
	  lengths = get_lengths
      pbPlayDecisionSE if lengths[1] > 1 && lengths[0]<lengths[1] && lengths[0]!=0
      if delta.negative?
        @position[PAGE_DESCRIPTION] = 0 if @position[PAGE_DESCRIPTION] < 0
        return
      end

      total_lines = @chapter_descriptions[@position[PAGE_BOOKS]][@position[PAGE_CHAPTERS]].size
      visible = VISIBLE_ROWS[PAGE_DESCRIPTION]
      if total_lines < visible
        @position[PAGE_DESCRIPTION] = 0
        @chapter_fully_read = true
      else
        max_scroll = total_lines - visible
        @position[PAGE_DESCRIPTION] = max_scroll if @position[PAGE_DESCRIPTION] > max_scroll
        @chapter_fully_read = true if @position[PAGE_DESCRIPTION] >= max_scroll
      end
    end

    # Data-driven replacement for the old identity-comparison unlock hack.
    # Any chapter that declares `unlocks_book:` reveals that book (and its
    # first chapter) once fully read. The next chapter in the same book is
    # always revealed too, regardless of unlocks_book. Plays UNLOCK_SE_NAME
    # once if this reading session actually unlocked something new.
    def unlock_next_content
      book = current_book
      chapter = current_chapter
      return unless book && chapter

      unlocked_something = false

      if chapter.unlocks_book
        target = AdventureGuide.find_book(chapter.unlocks_book)
        if target && !target.enabled?
          target.enabled = true
          first_chapter = target.chapters.first
          if first_chapter
            first_chapter.enabled = true
            record_unlock(target, first_chapter)
          end
          unlocked_something = true
        end
      end

      chapter_index = chapter_index_in_book(book, chapter)
      next_chapter = book.chapters[chapter_index + 1] if chapter_index
      if next_chapter && !next_chapter.enabled?
        next_chapter.enabled = true
        record_unlock(book, next_chapter)
      end

      record_read(book, chapter)
      AdventureGuide.play_unlock_se if unlocked_something
    end

    def reset_position
      case @page
      when PAGE_BOOKS
        @position = [0, 0, 0]
        @frame = 0
        @desc_scroll_offset = 0
      when PAGE_CHAPTERS
        @position[PAGE_CHAPTERS] = 0
        @position[PAGE_DESCRIPTION] = 0
      end
    end



    #---------------------------------------------------------------------------
    # Lifecycle
    #---------------------------------------------------------------------------
    def update_ingame
      Graphics.update
      Input.update
      pbUpdateSpriteHash(@sprites)
    end

    def dispose = pbDisposeSpriteHash(@sprites)

    def end_scene
      dispose
      @viewport.dispose
    end
  end
end
