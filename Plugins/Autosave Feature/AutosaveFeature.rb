#===============================================================================
# "Autosave Feature v20"
# By Caruban
#-------------------------------------------------------------------------------
# With this plugin, the game will be saved after player catching a Pokemon
# or when transferred into another map.
# Except : 
#  - Transferring between 2 indoor maps
#  - Transferring between 2 connected maps
#  - Transferring while doing the safari game
#  - Transferring while doing a bug catching contest
#  - Transferring while doing a battle challenge
#
# This plugin can be turned off/on temporary by using this script
# pbSetDisableAutosave = value (true or false)
# 
# or from the game options permanently.
#=============================================================================== 
# System and Temp Variables
#===============================================================================
class Game_Temp
  attr_accessor :changeUnConnectedMap
  attr_accessor :disableAutosave
  
  def changeUnConnectedMap
    @changeUnConnectedMap = false if !@changeUnConnectedMap
    return @changeUnConnectedMap
  end
  def disableAutosave
    @disableAutosave = false if !@disableAutosave
    return @disableAutosave
  end
end


class PokemonGlobalMetadata
  attr_accessor :lastSave
  def lastSave
    @lastSave = pbGetTimeNow.to_i if !@lastSave
    return @lastSave
  end
end


class PokemonSystem
  attr_accessor :autosave
  def autosave
    # Autosave (0=on, 1=off)
    @autosave = 0 if !@autosave
    return @autosave
  end
end
#===============================================================================
# Game Option
#===============================================================================
MenuHandlers.add(:options_menu, :autosave, {
  "name"        => _INTL("Autosave"),
  "order"       => 20,
  "parent"      => :main,
  "type"        => EnumOption,
  "condition"   => proc { next $player
    next $PokemonGlobal
    next $PokemonGlobal.hardcore==false},
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "description" => _INTL("Choose whether your game saved automatically or not."),
  "get_proc"    => proc { next $PokemonSystem.autosave },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.autosave = value }
})
#===============================================================================
# Script
#===============================================================================
def pbCanAutosave?
  return $PokemonSystem.autosave==0 && !$game_temp.disableAutosave && !$game_system.save_disabled
end

def pbSetDisableAutosave=(value)
  $game_temp.disableAutosave = value
end

def pbAutosave(scene = nil)
  scene = $scene if !scene
  return if $PokemonGlobal.cur_challenge!=false
  return if $PokemonSystem.autosave!=0
  return if $PokemonGlobal.hardcore==true
  return if $game_temp.in_temple==true
  return if SaveData::TESTING_MODE==false
  if !pbInBugContest? && !pbBattleChallenge.pbInChallenge? 
    sideDisplay("Now Saving...",true)
	 Game.auto_save
    $PokemonGlobal.lastSave = pbGetTimeNow.to_i
  end
end

# Check if the map are connected
EventHandlers.add(:on_enter_map, :autosave,
  proc { |old_map_id|   # previous map ID, is 0 if no map ID
    next if $game_map.map_id==3
    next if $PokemonGlobal.hardcore==true
    map_metadata = GameData::MapMetadata.try_get($game_map.map_id)
    old_map_metadata = GameData::MapMetadata.try_get(old_map_id)
    if old_map_id>0 && !$map_factory.areConnected?($game_map.map_id, old_map_id) && map_metadata && old_map_metadata && (map_metadata.outdoor_map || old_map_metadata.outdoor_map)
      $game_temp.changeUnConnectedMap = true 
    end
  }
  )

  # Walk in or out of a building
  EventHandlers.add(:on_map_or_spriteset_change, :autosave,
    proc { |scene, map_changed|
      next if !scene || !scene.spriteset
      next if $game_map.map_id==3
	   next if pbGetTimeNow.to_i<$PokemonGlobal.lastSave+3600
      if pbCanAutosave? && map_changed && $game_temp.changeUnConnectedMap==true
        pbAutosave(scene)
      end
      $game_temp.changeUnConnectedMap = false
    }
  )

# Autosave when caught a pokemon
EventHandlers.add(:on_wild_battle_end, :autosave_catchpkm,
  proc { |species, level, decision|
    pbAutosave if pbCanAutosave? && decision==4
  }
)

EventHandlers.add(:on_wild_ovbattle_end, :autosave_catchpkm,
  proc { |species, level, decision|
    pbAutosave if pbCanAutosave? && decision==4
  }
)
def sideDisplayOriginal(text)
return false if !$scene
$scene.spriteset.addUserSprite(SideDisplayUIOriginal.new(text)) 
return true
end

class SideDisplayUIOriginal
  attr_accessor :text
  def initialize(text="Now Saving...",x=10,y=1,z=99999)
    $scene.spriteset.usersprites.each do |sprite| 
	  next if !sprite.is_a?(SideDisplayUI) 
	  next if sprite == self
	  next if sprite.disposed?
	  if sprite.text.is_a? Array
	    potato = sprite.text
	   potato << text
	  text = potato
	  else
	  text = [sprite.text,text]
	  end
	  sprite.dispose 
	end
	 text = [text] if text.is_a? String
	@text = text
    @bitmapsprite = BitmapSprite.new(Graphics.width,Graphics.height,nil)
    @bitmap = @bitmapsprite.bitmap
    pbSetSmallFont(@bitmap)
	text2 = []
	 loops = 0
	text.each do |i|
	    y1 = y+(loops*21)
	  text2 << [i,x,y1,z,Color.new(248,248,248),Color.new(97,97,97)]
	  loops+=1
	end
    pbDrawTextPositions(@bitmap,text2)
    @bitmapsprite.visible = true
    @frame = 0
    @looptime = 0
    @i = 1
    @value = false
    @currentmap = $game_map.map_id
  end
  
  def pbStart
    @bitmapsprite.visible = true
    @i = -1
  end
  
  def isStart?
    return @start
  end
  def disposed?
    @bitmapsprite.disposed?
  end
  
  def update
    if @currentmap != $game_map.map_id
      @bitmapsprite.dispose
      return
    end
	if @text.length>4 && @looptime<3 && @value==false
	    @frame = 16
	    @looptime = 2
		@value = true
	end
	
    if @frame > Graphics.frame_rate / 2
      if @looptime == 3
        @bitmapsprite.dispose
        @frame = 0
      else
        @looptime += 1
        @frame = 0
        @i *= -1
      end
    else
      @frame += 1
      @bitmapsprite.opacity += 10 * @i
    end
  end
  def dispose
    @bitmapsprite.dispose if @bitmapsprite
  end
end




def sideDisplay(text, onlyme = false, looptimeadjustment = 0, flashing = true)
  return false unless $scene
  $sidedisplay.set_text(text, onlyme, looptimeadjustment, flashing)
  true
end

class SideDisplayUI
  attr_accessor :text

  X            = 10
  Y            = 1
  Z            = 999999
  MAX_MESSAGES = 7
  LINE_HEIGHT  = 21
  PADDING      = 10

  TEXT_COLOR   = Color.new(248, 248, 248)
  SHADOW_COLOR = Color.new(97, 97, 97)

  def initialize(viewport, x = X, y = Y, z = Z)
    @bitmapsprite = BitmapSprite.new(Graphics.width, Graphics.height, viewport)
    @bitmapsprite.z = z
    @bitmap = @bitmapsprite.bitmap

    pbSetSmallFont(@bitmap)

    @x = x
    @y = y
    @z = z

    @messages = []
    @currentmap = $game_map.map_id
  end

  # Kept for compatibility with existing calls.
  # Adds time to the newest message.
  def add_looptime(amount)
    return if @messages.empty?
    @messages.last[:duration] += amount
  end

  def text
    @messages.map { |message| message[:text] }
  end

  def set_text(text, onlyme = false, looptimeadjustment = 0, flashing = true)
    return if text.nil? || text.to_s.empty?

    @currentmap = $game_map.map_id

    clear_text if onlyme

    # Don't add the same message twice.
    return if @messages.any? { |message| message[:text] == text.to_s }

    @messages << {
      :text      => text.to_s,
      :lines     => wrap_text(text.to_s),
      :frame     => 0,
      :duration  => 6 + looptimeadjustment,
      :flashing  => flashing
    }

    # Keep the queue bounded.
    @messages.shift while @messages.length > MAX_MESSAGES

    refresh
    show
  end

  def disposed?
    @bitmapsprite.disposed?
  end

  def refresh
    @bitmap.clear
    return if @messages.empty?

    y = @y

    @messages.each do |message|
      message[:lines].each do |line|
        color = message_color(message)

        pbDrawTextPositions(
          @bitmap,
          [[line, @x, y, @z, color, SHADOW_COLOR]]
        )

        y += LINE_HEIGHT
      end

      # Small gap between messages.
      y += 2
    end
  end

  def update
    if invalid_context?
      clear_and_hide
      return
    end

    return if @messages.empty?
    return unless @bitmapsprite.visible

    changed = false

    @messages.each do |message|
      message[:frame] += 1
    end

    # Remove messages individually.
    before = @messages.length

    @messages.reject! do |message|
      message_expired?(message)
    end

    changed = true if before != @messages.length

    refresh if changed

    if @messages.empty?
      hide
    end
  end

  def clear_text
    @messages.clear
    hide
    @bitmap.clear
  end

  def cleared?
    @messages.empty?
  end

  def hide
    @bitmapsprite.visible = false
  end

  def show
    @bitmapsprite.visible = true
  end

  def dispose
    @bitmapsprite.dispose if @bitmapsprite
  end

  private

  def invalid_context?
    return true if @currentmap != $game_map.map_id

    if $game_temp.in_menu == true &&
       $game_temp.just_update_anyways == false
      return true
    end

    return true if $game_temp.in_battle == true

    false
  end

  def clear_and_hide
    @messages.clear
    @bitmap.clear
    hide
    @currentmap = $game_map.map_id
  end

  # --------------------------------------------------------------------------
  # Text wrapping
  # --------------------------------------------------------------------------

  def wrap_text(text)
    max_width = Graphics.width - @x - PADDING
    lines = []

    text.to_s.split(/\r?\n/).each do |paragraph|
      words = paragraph.split(/\s+/)
      current = ""

      words.each do |word|
        test = current.empty? ? word : "#{current} #{word}"

        if text_width(test) <= max_width
          current = test
          next
        end

        unless current.empty?
          lines << current
          current = ""
        end

        # A single word can itself be wider than the screen.
        if text_width(word) > max_width
          chunks = split_long_word(word, max_width)
          lines.concat(chunks[0...-1])
          current = chunks[-1]
        else
          current = word
        end
      end

      lines << current unless current.empty?
    end

    lines
  end

  def text_width(text)
    @bitmap.text_size(text).width
  end

  def split_long_word(word, max_width)
    chunks = []
    current = ""

    word.each_char do |char|
      test = current + char

      if current.empty? || text_width(test) <= max_width
        current = test
      else
        chunks << current
        current = char
      end
    end

    chunks << current unless current.empty?
    chunks
  end

  # --------------------------------------------------------------------------
  # Message timing / flashing
  # --------------------------------------------------------------------------

  def message_expired?(message)
    half_second = Graphics.frame_rate / 2

    # The message lasts for `duration` half-second intervals.
    message[:frame] >= message[:duration] * half_second
  end

  def message_color(message)
    return TEXT_COLOR unless message[:flashing]

    half_second = Graphics.frame_rate / 2
    flash_start = (message[:duration] * 2 / 3.0) * half_second

    return TEXT_COLOR if message[:frame] < flash_start

    # Fade repeatedly during the final third of the message's lifetime.
    elapsed = message[:frame] - flash_start
    cycle = elapsed % half_second
    midpoint = half_second / 2.0

    alpha =
      if cycle < midpoint
        255 - ((cycle / midpoint) * 180).to_i
      else
        75 + (((cycle - midpoint) / midpoint) * 180).to_i
      end

    Color.new(
      TEXT_COLOR.red,
      TEXT_COLOR.green,
      TEXT_COLOR.blue,
      alpha
    )
  end
end