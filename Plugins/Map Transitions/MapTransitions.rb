

#Fade Speed is how fast the player sprite and screen fade out
FADE_SPEED = 15

class TrainerWalkingCharSprite < SpriteWrapper
  def direction=(value)
    @direction = value
    self.src_rect.y = @animbitmap.bitmap.height/4*@direction
  end
end

def dummyMove
  return if !$game_temp.cin_player
  case $game_player.direction
  when 2
    $game_temp.cin_player.y += 1
    $game_map.display_y += 5
    pbUpdateSceneMap
    $game_temp.cin_player.update
    Graphics.update
  when 4
    $game_temp.cin_player.x -= 1
    $game_map.display_x -= 5
    pbUpdateSceneMap
    $game_temp.cin_player.update
    Graphics.update
  when 6
    $game_temp.cin_player.x += 1
    $game_map.display_x += 5
    pbUpdateSceneMap
    $game_temp.cin_player.update
    Graphics.update
  when 8
    $game_temp.cin_player.y -= 1
    $game_map.display_y -= 5
    pbUpdateSceneMap
    $game_temp.cin_player.update
    Graphics.update
  end
end

def cinFadeOut
  pbMoveRoute($game_player,[PBMoveRoute::Opacity,0],true)
  $game_player.transparent = true
  pbWait(1)
  $game_temp.cin_viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
  $game_temp.cin_viewport.z = 99998
  meta = GameData::PlayerMetadata.get($player&.character_ID || 1)
  filename = pbGetPlayerCharset(meta.walk_charset,$player,true)
  $game_temp.cin_player = TrainerWalkingCharSprite.new(filename,$game_temp.cin_viewport)
  $game_temp.cin_player.animspeed = $game_player.move_speed * 3
  charwidth = $game_temp.cin_player.bitmap.width
  charheight = $game_temp.cin_player.bitmap.height
  $game_temp.cin_player.ox = charwidth/8
  $game_temp.cin_player.oy = charheight/8
  $game_temp.cin_player.x = (Graphics.width/2)
  $game_temp.cin_player.y = (Graphics.height/2) - 8
  pbDayNightTint($game_temp.cin_player)
  case $game_player.direction
  when 2
    $game_temp.cin_player.direction = 0
  when 4
    $game_temp.cin_player.direction = 1
  when 6
    $game_temp.cin_player.direction = 2
  when 8
    $game_temp.cin_player.direction = 3
  end
  $game_temp.cin_player.update
  Graphics.update
  $game_temp.cin_bg = BitmapSprite.new(Graphics.width,Graphics.height,$game_temp.cin_viewport)
  $game_temp.cin_bg.bitmap.fill_rect(0,0,Graphics.width,Graphics.height,Color.new(0,0,0))
  $game_temp.cin_bg.opacity = 0
  $game_temp.cin_player.z = 99999
  loop do
    break if $game_temp.cin_bg.opacity >= 255
    $game_temp.cin_bg.opacity += FADE_SPEED
    dummyMove
    $game_temp.cin_player.update
    Graphics.update
  end
  10.times do
    $game_temp.cin_player.update
  end
  loop do
    break if $game_temp.cin_player.opacity <= 0
    $game_temp.cin_player.opacity -= FADE_SPEED
    dummyMove
    Graphics.update
  end
  $game_temp.cin_bg.dispose
  $game_temp.cin_bg = nil
  $game_temp.cin_player.dispose
  $game_temp.cin_player = nil
  $game_temp.cin_viewport.dispose
  $game_temp.cin_viewport = nil
  pbMoveRoute($game_player,[PBMoveRoute::Opacity,255],true)
  $game_player.transparent=false
  $game_map.update
end



def cinFadeIn
  $game_temp.cin_viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
  $game_temp.cin_viewport.z = 99998
  $game_temp.cin_bg = BitmapSprite.new(Graphics.width,Graphics.height,$game_temp.cin_viewport)
  $game_temp.cin_bg.bitmap.fill_rect(0,0,Graphics.width,Graphics.height,Color.new(0,0,0))
  pbMoveRoute($game_player,[PBMoveRoute::Opacity,0],true)
  $game_player.transparent = true
  pbWait(1)
  meta = GameData::PlayerMetadata.get($player&.character_ID || 1)
  filename = pbGetPlayerCharset(meta.walk_charset,$player,true)
  $game_temp.cin_player = TrainerWalkingCharSprite.new(filename,$game_temp.cin_viewport)
  $game_temp.cin_player.animspeed = $game_player.move_speed * 3
  charwidth = $game_temp.cin_player.bitmap.width
  charheight = $game_temp.cin_player.bitmap.height
  $game_temp.cin_player.ox = charwidth/8
  $game_temp.cin_player.oy = charheight/8
  $game_temp.cin_player.x = (Graphics.width/2)
  $game_temp.cin_player.y = (Graphics.height/2) - 8
  pbDayNightTint($game_temp.cin_player)
  preplayer = (255/FADE_SPEED) * 2
  premap = (255/FADE_SPEED) * 10
  case $game_player.direction
  when 2
    $game_temp.cin_player.direction = 0
    $game_temp.cin_player.y -= preplayer
    $game_map.display_y -= premap
    pbUpdateSceneMap
  when 4
    $game_temp.cin_player.direction = 1
    $game_temp.cin_player.x += preplayer
    $game_map.display_x += premap
    pbUpdateSceneMap
  when 6
    $game_temp.cin_player.direction = 2
    $game_temp.cin_player.x -= preplayer
    $game_map.display_x -= premap
    pbUpdateSceneMap
  when 8
    $game_temp.cin_player.direction = 3
    $game_temp.cin_player.y += preplayer
    $game_map.display_y += premap
    pbUpdateSceneMap
  end
  $game_temp.cin_player.z = 99999
  $game_temp.cin_player.opacity = 0
  loop do
    break if $game_temp.cin_player.opacity >= 255
    $game_temp.cin_player.opacity += FADE_SPEED
    $game_temp.cin_player.update
    dummyMove
    Graphics.update
  end
  loop do
    break if $game_temp.cin_bg.opacity <= 0
    $game_temp.cin_bg.opacity -= FADE_SPEED
    dummyMove
    $game_temp.cin_player.update
    Graphics.update
  end
  $game_temp.cin_bg.dispose
  $game_temp.cin_bg = nil
  $game_temp.cin_player.dispose
  $game_temp.cin_player = nil
  $game_temp.cin_viewport.dispose
  $game_temp.cin_viewport = nil
  pbMoveRoute($game_player,[PBMoveRoute::Opacity,255],true)
  $game_player.transparent = false
  $game_map.update
end

def cinTransition(mapid,x,y,dir=nil)
  cinFadeOut
  case dir
  when nil,"retain","Retain","0"
    dir = 0
  when "2","up","Up"
    dir = 2
  when "4","left","Left"
    dir = 4
  when "6","right","Right"
    dir = 6
  when "8","down","Down"
    dir = 8
  end
  $game_temp.player_new_map_id    = mapid
  $game_temp.player_new_x         = x
  $game_temp.player_new_y         = y
  $game_temp.player_new_direction = dir
  $scene.transfer_player
  $game_map.autoplay
  $game_map.refresh
  cinFadeIn
end

class Game_Temp
  attr_accessor :cin_player
  attr_accessor :cin_bg
  attr_accessor :cin_viewport
end

