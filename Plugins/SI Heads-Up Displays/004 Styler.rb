class MouseTrail
  attr_accessor :styler_on
  attr_accessor :user_styler
  attr_accessor :styler_dead
  attr_accessor :max_trail_length
  attr_accessor :trigger_cooldown
  attr_accessor :target_hits_f
  attr_accessor :styler_health

  def initialize(viewport = nil)
    @viewport = viewport || Viewport.new(0, 0, Graphics.width, Graphics.height)
    @trail_sprites = []
    @trail_positions = {}
    @most_recent_trail = nil
    @styler_on = false
    
    # Screen bounds for pixel-level line logic
    @min_x = 999
    @max_x = 0
    @min_y = 999
    @max_y = 0

    # Map grid bounds for event checking (prevents float iteration errors)
    @min_map_x = 999
    @max_map_x = 0
    @min_map_y = 999
    @max_map_y = 0

    @trigger_cooldown = 0
    @stamina_cooldown = 0
    @target_hits_f = 0
    @disposed = false
    @styler_dead = false
    @stamina_cooldown_target = 40
    @lastsound = 0
    @last_mouse_x = 0
    @last_mouse_y = 0

    # Spin Combo, Line Regeneration & Visuals
    @spin_combo = 0
    @last_loop_frame = 0
    @line_age_bonus = 0
    @combo_sprite = create_combo_sprite

    set_styler(ItemData.new(:CAPTURESTYLUS))
    @styler = create_styler
  end

  def same_styler?(styler)
    styler.identical(@user_styler)
  end

  def toggle_styler
    return if @styler_dead
    @styler_on = !@styler_on
  end

  def activate_styler
    return if @styler_dead || @styler_on
    @styler_on = true
  end

  def set_styler(styler)
    @user_styler = styler
    @styler_health = @user_styler.stats.health
    power = @user_styler.stats.power
    line = @user_styler.stats.line
    recovery = @user_styler.stats.recovery
    latent_power = @user_styler.stats.latent_power

    @max_trail_length = 120 + (line * 2)
    @trigger_target = [60 - latent_power, 5].max
    @power = power + 1
    @recovery = recovery + 1
  end

  def clear_trail
    @trail_sprites.each(&:dispose)
    @trail_sprites.clear
    @trail_positions.clear
    @most_recent_trail = nil
    @spin_combo = 0
    @line_age_bonus = 0
    update_combo_display
  end

  def get_unsafe_cutoff
    # Lines under 25 segments are completely safe to prevent punishing short strokes
    return 0 if @trail_sprites.length < 40

    # Fixed-age cutoff independent of overall line length
    base_cutoff = 15
    return [base_cutoff - @line_age_bonus, 0].max
  end

  def check_trail_collision(given_key)
    current_pos = @trail_positions[given_key]
    return :none if current_pos.nil?

    unsafe_cutoff = get_unsafe_cutoff
    current_sprite_idx = @trail_sprites.index(given_key)
    return :none unless current_sprite_idx

    @trail_positions.each do |sprite, coords|
      @min_x = [@min_x, coords[0]].min
      @max_x = [@max_x, coords[0]].max
      @min_y = [@min_y, coords[1]].min
      @max_y = [@max_y, coords[1]].max

      map_x = (((coords[0] * Game_Map::X_SUBPIXELS) + $game_map.display_x) / Game_Map::REAL_RES_X).round
      map_y = (((coords[1] * Game_Map::Y_SUBPIXELS) + $game_map.display_y) / Game_Map::REAL_RES_Y).round

      @min_map_x = [@min_map_x, map_x].min
      @max_map_x = [@max_map_x, map_x].max
      @min_map_y = [@min_map_y, map_y].min
      @max_map_y = [@max_map_y, map_y].max

      next if sprite == given_key

      sprite_idx = @trail_sprites.index(sprite)
      next unless sprite_idx

      # Ignore immediate tail segments to prevent self-collision on active stroke tip
      next if (current_sprite_idx - sprite_idx).abs < 15

      distance = Math.hypot(current_pos[0] - coords[0], current_pos[1] - coords[1])
      if distance <= 12
        return :none if (@max_x - @min_x) < 24 || (@max_y - @min_y) < 24

        if !sprite.disposed?
          return sprite_idx <= unsafe_cutoff ? :unsafe_loop : :safe_loop
        end
      end
    end
    :none
  end

  def dispose
    clear_trail
    @styler.dispose if @styler
    @combo_sprite.dispose if @combo_sprite
    @disposed = true
  end

  def update
    return if $game_temp.in_menu || @disposed

    @styler = create_styler if !@styler || @styler.disposed?
    current_selection = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]

    hide_styler = false
    if $PokemonGlobal.ball_hud_enabled && !(current_selection.is_a?(ItemData) && current_selection.id == :CAPTURESTYLUS)
      hide_styler = true
    elsif !@styler_on
      hide_styler = true
    end

    if hide_styler
      @styler.visible = false if @styler.visible
      @combo_sprite.visible = false if @combo_sprite
      clear_trail
      return
    else
      @styler.visible = true unless @styler.visible
      update_styler
    end

    if Input.release?(Input::MOUSELEFT) || !Input.mouse_in_window? || @styler_dead
      clear_trail
      pbBGSFade(1.0)
    end

    if Input.mouse_in_window? && !@styler_dead
      if Input.trigger?(Input::MOUSELEFT)
        clear_trail
        @last_mouse_x = Input.mouse_x
        @last_mouse_y = Input.mouse_y + 5
        create_start_node(@last_mouse_x, @last_mouse_y)
      elsif Input.press?(Input::MOUSELEFT)
        pbBGSPlay("charge_loop", 75)
        if @stamina_cooldown == 0 && !($DEBUG && Input.press?(Input::CTRL))
          decreaseStamina(1.8) rescue nil
          @stamina_cooldown = @stamina_cooldown_target
        else
          @stamina_cooldown -= 1 if @stamina_cooldown > 0
        end

        @most_recent_trail = create_trail_segment
      end
    end

    unsafe_cutoff = get_unsafe_cutoff
    @trail_sprites.each_with_index do |sprite, index|
      next unless sprite.bitmap
      bitmap_path = index <= unsafe_cutoff ?
        "Graphics/Plugins/Capture Styler/styler_line_unsafe.png" :
        "Graphics/Plugins/Capture Styler/styler_line.png"
      sprite.setBitmap(bitmap_path)
    end

    if @trigger_cooldown == 0 && !@styler_dead && @most_recent_trail
      collision = check_trail_collision(@most_recent_trail)

      if collision == :unsafe_loop
        @styler_health -= 15
        pbSEPlay("styler_recoil") rescue nil
        sideDisplay("Line snapped! Styler damaged!") rescue nil
        clear_trail
        @trigger_cooldown = 20
      elsif collision == :safe_loop
        triggered = false
        if @min_map_x != @max_map_x && @min_map_y != @max_map_y
          (@min_map_x..@max_map_x).each do |x|
            break if triggered
            (@min_map_y..@max_map_y).each do |y|
              break if triggered

              event_id = $game_map.check_event(x, y)
              event = $game_map.events[event_id]

              if event && event.name[/vanishingEncounter/]
                triggered = true
                event.remaining_steps += 10
                pkmn = event.pokemon

                current_frame = Graphics.frame_count
                if (current_frame - @last_loop_frame) <= 35
                  @spin_combo = [@spin_combo + 1, 5].min
                else
                  @spin_combo = 1
                end
                @last_loop_frame = current_frame
                update_combo_display

                @line_age_bonus += (3 * @spin_combo)

                total_power = @power + (@spin_combo - 1)
                pkmn.hits += total_power

                stamina_refund = 1.5 * @spin_combo
                decreaseStamina(-stamina_refund) rescue nil

                makeAggressive(event) if !pkmn.is_aggressive?
                target_hits = get_target_hits(pkmn)

                extra = ""
                extra = " Only halfway to go!" if pkmn.hits == (target_hits / 2).to_i
                extra = " Almost There!" if pkmn.hits + 10 >= target_hits
                combo_str = @spin_combo > 1 ? " (#{@spin_combo}x Combo!)" : ""
                sideDisplay("#{pkmn.hits} hits on #{pkmn.name}!#{combo_str}#{extra}") if pkmn.hits < target_hits

                sound_index = [(pkmn.hits / (target_hits / 8.0)).floor, 7].min
                sound_index = [sound_index, 0].max
                if @lastsound == sound_index && sound_index != 7
                  sound_index += (rand(2) == 0 ? 1 : -1)
                  sound_index = 0 if sound_index < 0
                end
                @lastsound = sound_index

                pbSEPlay("Stylus#{sound_index + 1}")
                @styler_health += @recovery

                if pkmn.hits >= target_hits
                  if $game_map.map_id != 11
                    sideDisplay("#{pkmn.name} has been caught!")
                    $scene.spriteset.addUserAnimation(7, event.x, event.y, true, 1)
                    pbHeldItemDropOW(pkmn)
                    pkmnAnim(pkmn)
                    pbAddPokemonSilent(pkmn)
                    event.removeThisEventfromMap
                  elsif $game_map.map_id == 11 && (pokemon = get_form_for_species(pkmn))
                    $game_temp.preventspawns = false
                    $PokemonGlobal.cur_challenge.beaten += 1 if $PokemonGlobal.cur_challenge
                    sideDisplay("#{pkmn.name} has been defeated!")
                    pbPlaceEncounter(event.x, event.y, pokemon, 2)
                    event.removeThisEventfromMap
                  else
                    $PokemonGlobal.cur_challenge.beaten += 1 if $PokemonGlobal.cur_challenge
                    sideDisplay("#{pkmn.name} has been defeated!")
                    pbHeldItemDropOW(pkmn, true)
                    event.removeThisEventfromMap
                  end
                end
                @trigger_cooldown = @trigger_target
                clear_trail
              end
            end
          end
        end
      end
    else
      @trigger_cooldown -= 1 if @trigger_cooldown > 0
    end

    @min_x, @max_x, @min_y, @max_y = 999, 0, 999, 0
    @min_map_x, @max_map_x, @min_map_y, @max_map_y = 999, 0, 999, 0

    @last_mouse_x = Input.mouse_x
    @last_mouse_y = Input.mouse_y + 5
  end

  def get_form_for_species(pkmn)
    if pkmn.species == :GIRATINA && pkmn.form == 0
      pokemon = Pokemon.new(:GIRATINA, pkmn.level)
      pokemon.item = :GRISEOUSORB
      pokemon.form = 1
      pokemon.shiny = true
      return pokemon
    elsif pkmn.species == :MEWTWO && pkmn.form == 0
      pokemon = Pokemon.new(:MEWTWO, pkmn.level)
      pokemon.form = 1
      pokemon.shiny = true
      return pokemon
    elsif pkmn.species == :MEWTWO && pkmn.form == 1
      pokemon = Pokemon.new(:MEWTWO, pkmn.level)
      pokemon.form = 2
      pokemon.shiny = true
      return pokemon
    end
    false
  end

  def get_target_hits(pkmn)
    target_hits = pkmn.hp / 4
    target_hits = 50 if target_hits > 50
    target_hits = 10 if target_hits < 10
    target_hits = @target_hits_f if @target_hits_f != 0
    target_hits
  end

  def remove_oldest_trail
    return if @trail_sprites.empty?
    sprite = @trail_sprites.shift
    @trail_positions.delete(sprite)
    sprite.dispose
  end

  def update_styler
    return if @styler_dead
    if @user_styler && @styler_health <= 0
      @styler_dead = true
      @styler.setBitmap("Graphics/Plugins/Capture Styler/loss.gif")
      @styler.bitmap.looping = false
      @combo_sprite.visible = false if @combo_sprite
    end

    return if @styler_dead
    @styler.x = Input.mouse_x
    @styler.y = Input.mouse_y + 5

    if @combo_sprite && @combo_sprite.visible
      @combo_sprite.x = Input.mouse_x
      @combo_sprite.y = Input.mouse_y - 25
    end
  end

  def create_styler
    styler = IconSprite.new(@viewport)
    styler.setBitmap("Graphics/Plugins/Capture Styler/capture styler.gif")
    if styler.bitmap
      styler.ox = styler.bitmap.width / 2
      styler.oy = styler.bitmap.height / 2
    end
    styler.x = Input.mouse_x
    styler.y = Input.mouse_y + 5
    styler.z = 99999
    styler
  end

  private

  def create_combo_sprite
    sprite = Sprite.new(@viewport)
    sprite.bitmap = Bitmap.new(100, 30)
    sprite.ox = 50
    sprite.oy = 15
    sprite.z = 100000
    sprite.visible = false
    sprite
  end

  def update_combo_display
    return unless @combo_sprite && @combo_sprite.bitmap

    @combo_sprite.bitmap.clear
    if @spin_combo > 1 && !@styler_dead
      pbSetSystemFont(@combo_sprite.bitmap) rescue nil
      text = "#{@spin_combo}x COMBO!"

      @combo_sprite.bitmap.font.color = Color.new(0, 0, 0)
      [-1, 1].each do |x_off|
        [-1, 1].each do |y_off|
          @combo_sprite.bitmap.draw_text(x_off, y_off, 100, 30, text, 1)
        end
      end

      @combo_sprite.bitmap.font.color = Color.new(255, 215, 0)
      @combo_sprite.bitmap.draw_text(0, 0, 100, 30, text, 1)
      @combo_sprite.visible = true
    else
      @combo_sprite.visible = false
    end
  end

  def create_start_node(x, y)
    sprite = IconSprite.new(@viewport)
    sprite.setBitmap("Graphics/Plugins/Capture Styler/styler_light.png")
    if sprite.bitmap
      sprite.ox = sprite.bitmap.width / 2
      sprite.oy = sprite.bitmap.height / 2
    end
    sprite.x = x
    sprite.y = y
    sprite.z = 99998
    sprite.visible = true

    @trail_sprites.push(sprite)
    @trail_positions[sprite] = [x, y]
    remove_oldest_trail if @trail_sprites.size > @max_trail_length
  end

  def create_trail_segment
    return nil if @last_mouse_x == 0 && @last_mouse_y == 0

    current_x = Input.mouse_x
    current_y = Input.mouse_y + 5

    dx = current_x - @last_mouse_x
    dy = current_y - @last_mouse_y
    distance = Math.hypot(dx, dy)

    return nil if distance < 2

    max_segment_length = 6
    steps = (distance / max_segment_length).ceil
    steps = [steps, 1].max

    last_seg = nil
    start_x = @last_mouse_x
    start_y = @last_mouse_y

    steps.times do |i|
      t1 = i.to_f / steps
      t2 = (i + 1).to_f / steps

      seg_start_x = start_x + (dx * t1)
      seg_start_y = start_y + (dy * t1)
      seg_end_x = start_x + (dx * t2)
      seg_end_y = start_y + (dy * t2)

      seg_dx = seg_end_x - seg_start_x
      seg_dy = seg_end_y - seg_start_y
      seg_dist = Math.hypot(seg_dx, seg_dy)

      sprite = IconSprite.new(@viewport)

      unsafe_cutoff = get_unsafe_cutoff
      bitmap_path = @trail_sprites.length <= unsafe_cutoff ?
        "Graphics/Plugins/Capture Styler/styler_line_unsafe.png" :
        "Graphics/Plugins/Capture Styler/styler_line.png"

      sprite.setBitmap(bitmap_path)

      if sprite.bitmap
        sprite.ox = 0
        sprite.oy = sprite.bitmap.height / 2.0
        angle = Math.atan2(seg_dy, seg_dx) * (180.0 / Math::PI)

        sprite.zoom_x = seg_dist / sprite.bitmap.width.to_f
        sprite.angle = -angle
      end

      sprite.x = seg_start_x
      sprite.y = seg_start_y
      sprite.z = 99998
      sprite.visible = true

      @trail_sprites.push(sprite)
      @trail_positions[sprite] = [seg_end_x, seg_end_y]

      remove_oldest_trail if @trail_sprites.size > @max_trail_length
      last_seg = sprite
    end

    last_seg
  end
end