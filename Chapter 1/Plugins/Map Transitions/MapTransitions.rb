

#Fade Speed is how fast the player sprite and screen fade out
FADE_SPEED = 15

class TrainerWalkingCharSprite < SpriteWrapper
  def direction=(value)
    @direction = value
    self.src_rect.y = @animbitmap.bitmap.height/4*@direction
  end
end

def dummyMove
  return if !$PokemonTemp.cin_player
  case $game_player.direction
  when 2
    $PokemonTemp.cin_player.y += 1
    $game_map.display_y += 5
    pbUpdateSceneMap
    $PokemonTemp.cin_player.update
    Graphics.update
  when 4
    $PokemonTemp.cin_player.x -= 1
    $game_map.display_x -= 5
    pbUpdateSceneMap
    $PokemonTemp.cin_player.update
    Graphics.update
  when 6
    $PokemonTemp.cin_player.x += 1
    $game_map.display_x += 5
    pbUpdateSceneMap
    $PokemonTemp.cin_player.update
    Graphics.update
  when 8
    $PokemonTemp.cin_player.y -= 1
    $game_map.display_y -= 5
    pbUpdateSceneMap
    $PokemonTemp.cin_player.update
    Graphics.update
  end
end

def cinFadeOut
  pbMoveRoute($game_player,[PBMoveRoute::Opacity,0],true)
  $game_player.transparent = true
  pbWait(1)
  $PokemonTemp.cin_viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
  $PokemonTemp.cin_viewport.z = 99998
  meta = GameData::Metadata.get_player($Trainer.character_ID)
  filename = pbGetPlayerCharset(meta,1,nil,true)
  $PokemonTemp.cin_player = TrainerWalkingCharSprite.new(filename,$PokemonTemp.cin_viewport)
  $PokemonTemp.cin_player.animspeed = $game_player.move_speed * 3
  charwidth = $PokemonTemp.cin_player.bitmap.width
  charheight = $PokemonTemp.cin_player.bitmap.height
  $PokemonTemp.cin_player.ox = charwidth/8
  $PokemonTemp.cin_player.oy = charheight/8
  $PokemonTemp.cin_player.x = (Graphics.width/2)
  $PokemonTemp.cin_player.y = (Graphics.height/2) - 8
  pbDayNightTint($PokemonTemp.cin_player)
  case $game_player.direction
  when 2
    $PokemonTemp.cin_player.direction = 0
  when 4
    $PokemonTemp.cin_player.direction = 1
  when 6
    $PokemonTemp.cin_player.direction = 2
  when 8
    $PokemonTemp.cin_player.direction = 3
  end
  $PokemonTemp.cin_player.update
  Graphics.update
  $PokemonTemp.cin_bg = BitmapSprite.new(Graphics.width,Graphics.height,$PokemonTemp.cin_viewport)
  $PokemonTemp.cin_bg.bitmap.fill_rect(0,0,Graphics.width,Graphics.height,Color.new(0,0,0))
  $PokemonTemp.cin_bg.opacity = 0
  $PokemonTemp.cin_player.z = 99999
  loop do
    break if $PokemonTemp.cin_bg.opacity >= 255
    $PokemonTemp.cin_bg.opacity += FADE_SPEED
    dummyMove
    $PokemonTemp.cin_player.update
    Graphics.update
  end
  10.times do
    $PokemonTemp.cin_player.update
  end
  loop do
    break if $PokemonTemp.cin_player.opacity <= 0
    $PokemonTemp.cin_player.opacity -= FADE_SPEED
    dummyMove
    Graphics.update
  end
  $PokemonTemp.cin_bg.dispose
  $PokemonTemp.cin_bg = nil
  $PokemonTemp.cin_player.dispose
  $PokemonTemp.cin_player = nil
  $PokemonTemp.cin_viewport.dispose
  $PokemonTemp.cin_viewport = nil
  pbMoveRoute($game_player,[PBMoveRoute::Opacity,255],true)
  $game_player.transparent=false
  $game_map.update
end



def cinFadeIn
  $PokemonTemp.cin_viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
  $PokemonTemp.cin_viewport.z = 99998
  $PokemonTemp.cin_bg = BitmapSprite.new(Graphics.width,Graphics.height,$PokemonTemp.cin_viewport)
  $PokemonTemp.cin_bg.bitmap.fill_rect(0,0,Graphics.width,Graphics.height,Color.new(0,0,0))
  pbMoveRoute($game_player,[PBMoveRoute::Opacity,0],true)
  $game_player.transparent = true
  pbWait(1)
  meta = GameData::Metadata.get_player($Trainer.character_ID)
  filename = pbGetPlayerCharset(meta,1,nil,true)
  $PokemonTemp.cin_player = TrainerWalkingCharSprite.new(filename,$PokemonTemp.cin_viewport)
  $PokemonTemp.cin_player.animspeed = $game_player.move_speed * 3
  charwidth = $PokemonTemp.cin_player.bitmap.width
  charheight = $PokemonTemp.cin_player.bitmap.height
  $PokemonTemp.cin_player.ox = charwidth/8
  $PokemonTemp.cin_player.oy = charheight/8
  $PokemonTemp.cin_player.x = (Graphics.width/2)
  $PokemonTemp.cin_player.y = (Graphics.height/2) - 8
  pbDayNightTint($PokemonTemp.cin_player)
  preplayer = (255/FADE_SPEED) * 2
  premap = (255/FADE_SPEED) * 10
  case $game_player.direction
  when 2
    $PokemonTemp.cin_player.direction = 0
    $PokemonTemp.cin_player.y -= preplayer
    $game_map.display_y -= premap
    pbUpdateSceneMap
  when 4
    $PokemonTemp.cin_player.direction = 1
    $PokemonTemp.cin_player.x += preplayer
    $game_map.display_x += premap
    pbUpdateSceneMap
  when 6
    $PokemonTemp.cin_player.direction = 2
    $PokemonTemp.cin_player.x -= preplayer
    $game_map.display_x -= premap
    pbUpdateSceneMap
  when 8
    $PokemonTemp.cin_player.direction = 3
    $PokemonTemp.cin_player.y += preplayer
    $game_map.display_y += premap
    pbUpdateSceneMap
  end
  $PokemonTemp.cin_player.z = 99999
  $PokemonTemp.cin_player.opacity = 0
  loop do
    break if $PokemonTemp.cin_player.opacity >= 255
    $PokemonTemp.cin_player.opacity += FADE_SPEED
    $PokemonTemp.cin_player.update
    dummyMove
    Graphics.update
  end
  loop do
    break if $PokemonTemp.cin_bg.opacity <= 0
    $PokemonTemp.cin_bg.opacity -= FADE_SPEED
    dummyMove
    $PokemonTemp.cin_player.update
    Graphics.update
  end
  $PokemonTemp.cin_bg.dispose
  $PokemonTemp.cin_bg = nil
  $PokemonTemp.cin_player.dispose
  $PokemonTemp.cin_player = nil
  $PokemonTemp.cin_viewport.dispose
  $PokemonTemp.cin_viewport = nil
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

class PokemonTemp
  attr_accessor :cin_player
  attr_accessor :cin_bg
  attr_accessor :cin_viewport
end

