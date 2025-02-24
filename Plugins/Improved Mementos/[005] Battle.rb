#===============================================================================
# Battle send out.
#===============================================================================
# Adds memento animation as part of the general send out animation in battle.
#-------------------------------------------------------------------------------

#===============================================================================
# Memento animation.
#===============================================================================
# Displays a battler's memento when being sent out in battle.
#-------------------------------------------------------------------------------
class Battle::Scene::Animation::BattlerMemento < Battle::Scene::Animation
  def initialize(sprites, viewport, battle, idxBattler)
    @battle = battle
    @idxBattler = idxBattler
    super(sprites, viewport)
  end

  def createProcesses
    batSprite = @sprites["pokemon_#{@idxBattler}"]
    return if !batSprite
    memento = GameData::Ribbon.try_get(batSprite.pkmn.memento)
    return if !memento
    delay = 0
    coords = Battle::Scene.pbBattlerPosition(@idxBattler, batSprite.sideSize)
    pictureSPRITE = addMementoSprite(memento.icon_position)
    pictureSPRITE.setXY(0, coords[0], coords[1])
    pictureSPRITE.setZ(0, batSprite.z + 1)
    pictureSPRITE.setOpacity(0, 0)
    pictureSPRITE.moveXY(0, 16, coords[0], coords[1] - batSprite.height)
    pictureSPRITE.moveOpacity(0, 4, 255)
    pictureSPRITE.moveOpacity(8, 8, 0)
  end
  
  def addMementoSprite(icon)
    file_path = "Graphics/Plugins/Improved Mementos/mementos"
    picMemento = addNewSprite(Graphics.width, Graphics.height, file_path, PictureOrigin::CENTER)
    mementoSprite = @pictureSprites.last
    mementoSprite.src_rect.x = 78 * (icon % 8)
    mementoSprite.src_rect.y = 78 * (icon / 8).floor
    mementoSprite.src_rect.width = 78
    mementoSprite.src_rect.height = 78
    picMemento.setSrc(0, mementoSprite.src_rect.x, mementoSprite.src_rect.y)
    picMemento.setSrcSize(0, mementoSprite.src_rect.width, mementoSprite.src_rect.height)
    return picMemento
  end
end