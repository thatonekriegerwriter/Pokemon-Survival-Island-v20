class Tooltip
  attr_accessor :viewport, :sprites, :width, :padding, :offset_x, :offset_y

  def initialize(width = 200, padding = 8)
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites = {}
    @width = width
    @padding = padding
	
	
    @sprites["bg"] = Sprite.new(@viewport)
    @sprites["bg"].bitmap = Bitmap.new(@width, 1) 
    @sprites["bg"].bitmap.fill_rect(0, 0, @width, 1, Color.new(0, 0, 0, 192))
    @sprites["bg"].visible = false
    mouse_x, mouse_y = $mouse.getMousePos
	if mouse_x && mouse_y
	bx = mouse_x + $mouse.width
    by = mouse_y - @sprites["bg"].height/2
    @sprites["bg"].x = bx
    @sprites["bg"].y = by
	end
    @line_sprites = []  
    @image_sprites = [] 
  end
  
  def show(info_hash)
    if info_hash.nil? || info_hash && info_hash.empty?
     hide 
	 return
	end 
    clear_contents
    @sprites["bg"].bitmap.clear

    # Starting vertical offset
    cursor_y = @padding

    if info_hash[:name].is_a?(Array)
      name, icon_x, icon_y = info_hash[:name]
      name_sprite = create_text_sprite(name, 16, @width - (@padding * 2) - icon_x, Color.new(255, 255, 255))
      name_sprite.x = @padding + icon_x 
      name_sprite.y = cursor_y + icon_y
	  name_sprite.instance_variable_set(:@rel_x, @padding + icon_x )
      name_sprite.instance_variable_set(:@rel_y, cursor_y + icon_y)
      @line_sprites << name_sprite
	  dims = [0, 0]
      dims = getLineBrokenChunksHeight(
        name_sprite.contents,
        name,
        @width - (@padding * 2)- icon_x,
        dims
      )
      text_height = dims[1]
      cursor_y += text_height + 4 
    end
	
	

    if info_hash[:description].is_a?(Array)
      description, icon_x, icon_y = info_hash[:description]
      desc_sprite = create_text_sprite(description, 14, @width - (@padding * 2) - icon_x, Color.new(200, 200, 200))
      desc_sprite.x = @padding + icon_x 
      desc_sprite.y = cursor_y + icon_y
	  desc_sprite.instance_variable_set(:@rel_x, @padding + icon_x)
      desc_sprite.instance_variable_set(:@rel_y, cursor_y + icon_y)
      @line_sprites << desc_sprite
	  dims = [0, 0]
      dims = getLineBrokenChunksHeight(
        desc_sprite.contents,
        description,
        @width - (@padding * 2) - icon_x,
        dims
      )
      text_height = dims[1]
      cursor_y += text_height + 4
    end

    combined_stats(info_hash).each do |key, value|
      next if [:name, :description, :item_icon].include?(key)
      data, icon_x, icon_y = value
      line = "#{key.to_s.capitalize}: #{data}"
      stat_sprite = create_text_sprite(line, 14, @width - (@padding * 2) - icon_x, Color.new(255, 255, 200))
      stat_sprite.x = @padding + icon_x
      stat_sprite.y = cursor_y + icon_y
	  stat_sprite.instance_variable_set(:@rel_x, @padding + icon_x)
      stat_sprite.instance_variable_set(:@rel_y, cursor_y + icon_y)
      @line_sprites << stat_sprite
	  dims = [0, 0]
      dims = getLineBrokenChunksHeight(
        stat_sprite.contents,
        data,
        @width - (@padding * 2) - icon_x,
        dims
      )
      text_height = dims[1]
      cursor_y += text_height + 2
    end

    if info_hash[:item_icon].is_a?(Array)
      icon_bitmap, icon_x, icon_y = info_hash[:item_icon]
      icon_sprite = IconSprite.new(@padding + icon_x,cursor_y + icon_y,@viewport)
      icon_sprite.setBitmap(icon_bitmap)
	  icon_sprite.instance_variable_set(:@rel_x, @padding + icon_x)
      icon_sprite.instance_variable_set(:@rel_y, cursor_y + icon_y)
      @image_sprites << icon_sprite
    end
    
    @sprites["bg"].bitmap.dispose
    @sprites["bg"].bitmap = Bitmap.new(@width, cursor_y + @padding)
    @sprites["bg"].bitmap.fill_rect(0, 0, @sprites["bg"].bitmap.width, @sprites["bg"].bitmap.height, Color.new(0, 0, 0, 192))

    @sprites["bg"].visible = true
  end
  
  
  def combined_stats(info_hash)
  combined = {}

  info_hash.each do |key, data|
    str_key = key.to_s.downcase
    next if str_key.start_with?("max")  # skip max keys for now
    value, x, y = data
    max_key = "max#{key}".to_sym
    if info_hash.key?(max_key)
      max_value = info_hash[max_key][0]
      combined[key] = ["#{value} / #{max_value}", x, y]
    else
      combined[key] = [value, x, y]
    end
  end

  combined
end
  
  
  def update
    mouse_x, mouse_y = $mouse.getMousePos
	if mouse_x && mouse_y
	bx = mouse_x + $mouse.width
    by = mouse_y - @sprites["bg"].height/2
    @sprites["bg"].x = bx
    @sprites["bg"].y = by
    @line_sprites.each do |s|
      s.x = bx - $mouse.width + s.instance_variable_get(:@rel_x)
      s.y = by - $mouse.height + s.instance_variable_get(:@rel_y)
	   s.refresh
    end
    @image_sprites.each do |s|
      s.x = bx - $mouse.width + s.instance_variable_get(:@rel_x)
      s.y = by - $mouse.height+ s.instance_variable_get(:@rel_y)
    end
    return unless @sprites["bg"].visible
    (@line_sprites + @image_sprites).each { |s| s.visible = true }
	end 
  end
  
  def hide
    @sprites["bg"].visible = false
    (@line_sprites + @image_sprites).each { |s| s.visible = false }
    (@line_sprites + @image_sprites).each { |s| s.dispose }
  end

  def dispose
    @sprites.each_value(&:dispose)
    @line_sprites.each(&:dispose)
    @image_sprites.each(&:dispose)
    @sprites.clear
    @line_sprites.clear
    @image_sprites.clear
  end
  
  def clear_contents
    @line_sprites.each { |s| s.dispose }
    @image_sprites.each { |s| s.dispose }
    @line_sprites.clear
    @image_sprites.clear
  end

   def create_text_sprite(text, size = 14, width = @width, color = MessageConfig::DARK_TEXT_MAIN_COLOR, shadow_color = nil)
    text_sprite=Window_UnformattedTextPokemon.new(text)
    text_sprite.viewport=@viewport
	text_sprite.contents.font.size = size 
	text_sprite.letterbyletter=false
    text_sprite.setTextToFit(text,width)
    text_sprite.windowskin=nil
    text_sprite.baseColor=color
    text_sprite.shadowColor=shadow_color
	text_sprite.refresh
	text_sprite.visible=false
	return text_sprite 
  end 
 
end 


