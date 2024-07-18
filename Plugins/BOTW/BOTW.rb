# BOTW-Like Item Gathering by: Kyu
# Updated to v19 by: Vendily
################################################################################
# How to install:
#   Add Object.png to the Graphics/Pictures folder.
#   Add this script over main.
#
# CREDITS MUST BE GIVEN TO EVERYONE LISTED ON THE POST
################################################################################
# CONSTANTS
################################################################################
NEWPICKBERRY = true # if true, berries will be picked directly with the new anim.
ITEMGETSE = "Voltorb Flip point" # ME that will play after obtaining an item.
################################################################################

if defined?(PluginManager)
  PluginManager.register({
    :name => "BOTW-Like Item Gathering",
    :version => "1.0",
    :credits => "Kyu"
  })
end
 
#UI Object with timer, animation and other relevant data
class UISprite < SpriteWrapper
  attr_accessor :scroll
  attr_accessor :timer

  def initialize(x, y, bitmap, viewport)
    super(viewport)
    self.bitmap = bitmap
    self.x = x
    self.y = y
    @scroll = false
    @timer = 0
  end

  def update
    return if self.disposed?
    @timer += 1
    case @timer
    when (0..10)
      self.x += self.bitmap.width/10
    when (100..110)
      self.x -= self.bitmap.width/10
    when 111
      self.dispose
    end
  end
end


class Spriteset_Map
  # Handles all UI objects in order to control their positions on screen, timing
  # and disposal. Acts like a Queue.
  class UIHandler
    def initialize
      @viewport = Viewport.new(0,0,Graphics.width,Graphics.height) # Uses its own viewport to make it compatible with both v16 and v17.
      @viewport.z = 9999
      @sprites = []
    end

    def addSprite(x, y, bitmap)
      @sprites.each{|sprite|
        sprite.scroll = true
      }
      index = @sprites.length
      @sprites[index] = UISprite.new(x, y, bitmap, @viewport)
    end

    def update
      removed = []
      @sprites.each_index{|key|
        sprite = @sprites[key]
        if sprite.scroll
          sprite2 = @sprites[key + 1]
          if sprite.x >= sprite2.x && sprite.x <= sprite2.bitmap.width + sprite2.x
            if sprite.y >= sprite2.y && sprite.y <= sprite2.bitmap.height + sprite2.y + 5
              sprite.y += 5
            end
          else
            sprite.scroll = false
          end
        end
        sprite.update
        if sprite.disposed?
          removed.push(sprite)
        end
      }
     
      removed.each{|sprite|
        @sprites.delete(sprite)
      }
    end
       
    def dispose
      @sprites.each{|sprite|
        if !sprite.disposed?
          sprite.dispose
        end
      }
      @viewport.dispose
    end
  end
 
  alias :disposeOld :dispose
  alias :updateOld :update

  def dispose
    @ui.dispose if @ui
    disposeOld
  end

  def update
    @ui = UIHandler.new if !@ui
    @ui.update
    updateOld
  end

  def ui
    return @ui
  end
end


class Scene_Map
  def addSprite(x, y, bitmap)
    self.spriteset.ui.addSprite(x, y, bitmap)
  end
end


def itemAnim(item,qty=1)
  item = GameData::Item.get(item)
  bitmap = Bitmap.new("Graphics/Pictures/Object")
  pbSetSystemFont(bitmap)
  base = Color.new(248,248,248)
  shadow = Color.new(72,80,88)
 
  if qty > 1
    textpos = [[_INTL("{1} x{2}",item.name_plural,qty),5,15,false,base,shadow]]
  else
    textpos = [[_INTL("{1}",item.name),5,15,false,base,shadow]]
  end
  pbDrawTextPositions(bitmap,textpos)
  bitmap.blt(274,5,Bitmap.new(GameData::Item.icon_filename(item.id)),Rect.new(0,0,48,48))
  pbSEPlay(ITEMGETSE)
  $scene.addSprite(-bitmap.width,200,bitmap)
end

def pkmnAnim(pkmn,party=false)
  bitmap = Bitmap.new("Graphics/Pictures/Object")
  pbSetSystemFont(bitmap)
  base = Color.new(248,248,248)
  shadow = Color.new(72,80,88)
  imgpos = [
    [GameData::Species.icon_filename_from_pokemon(pkmn),256,-4,0,0,64,64]
  ]
  if pkmn.shiny?
    imgpos.push(["Graphics/Pictures/shiny",256+48,32])
  end
  pbDrawImagePositions(bitmap,imgpos)
  textpos = [[pkmn.speciesName,5,15,false,base,shadow]]
  pbDrawTextPositions(bitmap,textpos)
  pbSEPlay(ITEMGETSE)
  $scene.addSprite(-bitmap.width,200,bitmap)
end


def pbItemBall(item,quantity=1)
  item = GameData::Item.get(item)
  return false if !item || quantity<1
  itemname = (quantity>1) ? item.name_plural : item.name
  if $bag.add(item,quantity)   # If item can be picked up
    itemAnim(item,quantity)
    return true
  else   # Can't add the item
    if item == :LEFTOVERS
    pbMessage(_INTL("{1} found some \\c[1]{2}\\c[0]!\\wtnp[30]",$player.name,itemname))
    elsif item.is_machine?   # TM or HM
      pbMessage(_INTL("\\l[2]{1} found \\c[1]{2} {3}\\c[0]!\\wtnp[30]",$player.name,itemname,GameData::Move.get(move).name))
    elsif quantity>1
      pbMessage(_INTL("\\l[2]{1} found {2} \\c[1]{3}\\c[0]!\\wtnp[30]",$player.name,quantity,itemname))
    elsif itemname.starts_with_vowel?
      pbMessage(_INTL("\\l[2]{1} found an \\c[1]{2}\\c[0]!\\wtnp[30]",$player.name,itemname))
    else
      pbMessage(_INTL("\\l[2]{1} found a \\c[1]{2}\\c[0]!\\wtnp[30]",$player.name,itemname))
    end
    pbMessage(_INTL("But your Bag is full..."))
    return false
  end
end
