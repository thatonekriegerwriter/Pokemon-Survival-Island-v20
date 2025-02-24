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







def sideDisplay(text,onlyme=false,looptimeadjustment=0,flashing=true)
return false if !$scene
$sidedisplay.set_text(text,onlyme,looptimeadjustment,flashing)
return true
end

class SideDisplayUI
  attr_accessor :text
  def initialize(viewport,x=10,y=1,z=999999)
    @bitmapsprite = BitmapSprite.new(Graphics.width,Graphics.height,viewport)
	@bitmapsprite.z = 999999
    @bitmap = @bitmapsprite.bitmap
    pbSetSmallFont(@bitmap)
	 @text = FixedSizeArray.new(7)
    @bitmapsprite.visible = true
    @frame = 0
    @looptime = 0
    @looptimetarget = 3
    @i = 1
	@x = x
	@y = y 
	@z = z
    @flashing = true
    @value = false
    @currentmap = $game_map.map_id
  end
  def add_looptime(amt)
    @looptimetarget+=amt
  end
  def set_text(text,onlyme,looptimet,flashing)
    @currentmap = $game_map.map_id
	 clear_text if onlyme==true
	  
	@text = FixedSizeArray.new(7) if !@text.is_a?(FixedSizeArray)
	 @text.add(text)
        @frame = 0
        @looptime = 0
        @i = 1
        @looptimetarget = 6 + looptimet
        @flashing = flashing
	 refresh
	 show
  end
  
  def disposed?
    @bitmapsprite.disposed?
  end
  
  def refresh
   return if cleared?
   @bitmap.clear
	text2 = []
	loops = 0
	@text = FixedSizeArray.new(7) if !@text.is_a?(FixedSizeArray)
	@text.to_a.each do |i|
	    y1 = @y+(loops*21)
	  text2 << [i,@x,y1,@z,Color.new(248,248,248),Color.new(97,97,97)]
	  loops+=1
	end
    pbDrawTextPositions(@bitmap,text2)
  
  end
  
  def update
    
    if @currentmap != $game_map.map_id
	   clear_text
      hide
      refresh
        @frame = 0
        @looptime = 0
        @i = 1
	  return
    end
    
    if $game_temp.in_menu==true
	   clear_text
      hide
      refresh
        @frame = 0
        @looptime = 0
        @i = 1
	  return
    end
    
    if $game_temp.in_battle==true
	   clear_text
      hide
      refresh
        @frame = 0
        @looptime = 0
        @i = 1
	  return
    end
	return if @bitmapsprite.visible == false
	return if cleared?
	if @text.length>4 && @looptime<@looptimetarget && @value==false
	    @frame = 16
	    @looptime = 2
		@value = true
	end
	
    if @frame > Graphics.frame_rate / 2
      if @looptime == @looptimetarget
	    clear_text
        hide
        refresh
        @frame = 0
        @looptime = 0
        @i = 1
      else
        @looptime += 1
        @frame = 0
        @i *= -1
      end
    else
      @frame += 1
      @bitmapsprite.opacity += 10 * @i if @looptime >= (2.0 / 3.0) * @looptimetarget && @flashing==true
    end
  end
  
  def clear_text
   @bitmapsprite.visible = false
   @text.clear
  end
  def cleared?
    return @text.empty?
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
end