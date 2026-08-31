#===============================================================================
# Shows the player throwing bait at a wild Pokémon in a Safari battle.
#===============================================================================
class Battle::Scene::Animation::ThrowBait < Battle::Scene::Animation
  include Battle::Scene::Animation::BallAnimationMixin

  def initialize(sprites, viewport, battler)
    @battler = battler
    @trainer = battler.battle.pbGetOwnerFromBattlerIndex(battler.index)
    super(sprites, viewport)
  end

  def createProcesses
    # Calculate start and end coordinates for battler sprite movement
    batSprite = @sprites["pokemon_#{@battler.index}"]
    traSprite = @sprites["player_1"]
    ballPos = Battle::Scene.pbBattlerPosition(@battler.index, batSprite.sideSize)
    ballStartX = traSprite.x
    ballStartY = traSprite.y - (traSprite.bitmap.height / 2)
    ballMidX   = 0   # Unused in arc calculation
    ballMidY   = 122
    ballEndX   = ballPos[0] - 40
    ballEndY   = ballPos[1] - 4
    # Set up trainer sprite
    trainer = addSprite(traSprite, PictureOrigin::BOTTOM)
    # Set up bait sprite
    ball = addNewSprite(ballStartX, ballStartY,
                        "Graphics/Battle animations/safari_bait", PictureOrigin::CENTER)
    ball.setZ(0, batSprite.z + 1)
    # Trainer animation
    if traSprite.bitmap.width >= traSprite.bitmap.height * 2
      ballStartX, ballStartY = trainerThrowingFrames(ball, trainer, traSprite)
    end
    delay = ball.totalDuration   # 0 or 7
    # Bait arc animation
    ball.setSE(delay, "Battle throw")
    createBallTrajectory(ball, delay, 12,
                         ballStartX, ballStartY, ballMidX, ballMidY, ballEndX, ballEndY)
    ball.setZ(9, batSprite.z + 1)
    delay = ball.totalDuration
    ball.moveOpacity(delay + 8, 2, 0)
    ball.setVisible(delay + 10, false)
    # Set up battler sprite
    battler = addSprite(batSprite, PictureOrigin::BOTTOM)
    # Show Pokémon jumping before eating the bait
    delay = ball.totalDuration + 3
    2.times do
      battler.setSE(delay, "player jump")
      battler.moveDelta(delay, 3, 0, -16)
      battler.moveDelta(delay + 4, 3, 0, 16)
      delay = battler.totalDuration + 1
    end
    # Show Pokémon eating the bait
    delay = battler.totalDuration + 3
    2.times do
      battler.moveAngle(delay, 7, 5)
      battler.moveDelta(delay, 7, 0, 6)
      battler.moveAngle(delay + 7, 7, 0)
      battler.moveDelta(delay + 7, 7, 0, -6)
      delay = battler.totalDuration
    end
  end
end



#===============================================================================
# Shows the player throwing a rock at a wild Pokémon in a Safari battle.
#===============================================================================
class Battle::Scene::Animation::ThrowRock < Battle::Scene::Animation
  include Battle::Scene::Animation::BallAnimationMixin

  def initialize(sprites, viewport, battler)
    @battler = battler
    @trainer = battler.battle.pbGetOwnerFromBattlerIndex(battler.index)
    super(sprites, viewport)
  end

  def createProcesses
    # Calculate start and end coordinates for battler sprite movement
    batSprite = @sprites["pokemon_#{@battler.index}"]
    traSprite = @sprites["player_1"]
    ballStartX = traSprite.x
    ballStartY = traSprite.y - (traSprite.bitmap.height / 2)
    ballMidX   = 0   # Unused in arc calculation
    ballMidY   = 122
    ballEndX   = batSprite.x
    ballEndY   = batSprite.y - (batSprite.bitmap.height / 2)
    # Set up trainer sprite
    trainer = addSprite(traSprite, PictureOrigin::BOTTOM)
    # Set up bait sprite
    ball = addNewSprite(ballStartX, ballStartY,
                        "Graphics/Battle animations/safari_rock", PictureOrigin::CENTER)
    ball.setZ(0, batSprite.z + 1)
    # Trainer animation
    if traSprite.bitmap.width >= traSprite.bitmap.height * 2
      ballStartX, ballStartY = trainerThrowingFrames(ball, trainer, traSprite)
    end
    delay = ball.totalDuration   # 0 or 7
    # Bait arc animation
    ball.setSE(delay, "Battle throw")
    createBallTrajectory(ball, delay, 12,
                         ballStartX, ballStartY, ballMidX, ballMidY, ballEndX, ballEndY)
    ball.setZ(9, batSprite.z + 1)
    delay = ball.totalDuration
    ball.setSE(delay, "Battle damage weak")
    ball.moveOpacity(delay + 2, 2, 0)
    ball.setVisible(delay + 4, false)
    # Set up anger sprite
    anger = addNewSprite(ballEndX - 42, ballEndY - 36,
                         "Graphics/Battle animations/safari_anger", PictureOrigin::CENTER)
    anger.setVisible(0, false)
    anger.setZ(0, batSprite.z + 1)
    # Show anger appearing
    delay = ball.totalDuration + 5
    2.times do
      anger.setSE(delay, "Player jump")
      anger.setVisible(delay, true)
      anger.moveZoom(delay, 3, 130)
      anger.moveZoom(delay + 3, 3, 100)
      anger.setVisible(delay + 6, false)
      anger.setDelta(delay + 6, 96, -16)
      delay = anger.totalDuration + 3
    end
  end
end

