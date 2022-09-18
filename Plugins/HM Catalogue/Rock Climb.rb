def canUseMoveRockClimb?
  showmsg = true
  return false if $bag.has?(:SUPPLIES) != true
   if !$game_player.pbFacingTerrainTag.rock_climb
     pbMessage(_INTL("Can't use that here.")) if showmsg
     return false
   end
   return true
end

def useMoveRockClimb
   if !pbHiddenMoveAnimation(nil)
     pbMessage(_INTL("{1} used Rock Climb!",$Trainer.name))
   end
   if event.direction=8
     pbRockClimbUp
   elsif event.direction=2
     pbRockClimbDown
   end
   return true
end

def pbRockClimbUp(event=nil)
  event = $game_player if !event
  return if !event
  return if event.direction != 8   # can't ascend if not facing up
  oldthrough   = event.through
  oldmovespeed = event.move_speed
  return if !$game_player.pbFacingTerrainTag.rock_climb
  event.through = true
  event.move_speed += 2
  loop do
    event.move_up
    if !$game_player.pbFacingTerrainTag.rock_climb
      event.move_up
      break
    end
  end
  event.through    = oldthrough
  event.move_speed = oldmovespeed
end

def pbRockClimbDown(event=nil)
  event = $game_player if !event
  return if !event
  return if event.direction != 2    # Can't descend if not facing down
  oldthrough   = event.through
  oldmovespeed = event.move_speed
  return if !$game_player.pbFacingTerrainTag.rock_climb
  event.through = true
  event.move_speed += 2
  loop do
    event.move_down
    if !$game_player.pbFacingTerrainTag.rock_climb
      event.move_down
      break
    end
  end
  event.through    = oldthrough
  event.move_speed = oldmovespeed
end

def pbRockClimbRight(event=nil)
  event = $game_player if !event
  return if !event
  return if event.direction != 6   # can't ascend if not facing up
  oldthrough   = event.through
  oldmovespeed = event.move_speed
  return if !$game_player.pbFacingTerrainTag.rock_climb
  event.through = true
  event.move_speed += 2
  loop do
    event.move_right
    if !$game_player.pbFacingTerrainTag.rock_climb
      event.move_right
      break
    end
  end
  event.through    = oldthrough
  event.move_speed = oldmovespeed
end


def pbRockClimbLeft(event=nil)
  event = $game_player if !event
  return if !event
  return if event.direction != 4  # can't ascend if not facing up
  oldthrough   = event.through
  oldmovespeed = event.move_speed
  return if !$game_player.pbFacingTerrainTag.rock_climb
  event.through = true
  event.move_speed += 2
  loop do
    event.move_left
    if !$game_player.pbFacingTerrainTag.rock_climb
      event.move_left
      break
    end
  end
  event.through    = oldthrough
  event.move_speed = oldmovespeed
end

def pbRockClimb
  event = $game_player if !event
  if $bag.has?(:SUPPLIES) == false
    pbMessage(_INTL("These rocks look climbable."))
    return false
  end
  if pbConfirmMessage(_INTL("It's a large rock wall. Would you like to climb it?"))
    if $bag.has?(:SUPPLIES) == true
      pbMessage(_INTL("{1} used Rock Climb!"))
      pbHiddenMoveAnimation(nil)
    end
    if event.direction==8
      pbRockClimbUp
    elsif event.direction==2
      pbRockClimbDown
    elsif event.direction==4
      pbRockClimbLeft
    elsif event.direction==6
      pbRockClimbRight
    end
    return true
  end
  return false
end

EventHandlers.add(:on_action, :rock_climb,
proc {
  if $game_player.pbFacingTerrainTag.rock_climb
    pbRockClimb
  end
}
)


module GameData
  class TerrainTag
    attr_reader :rock_climb
    @rock_climb             = false
  end
end

GameData::TerrainTag.register({
  :id                     => :RockClimb,
  :id_number              => 35,
  :rock_climb             => true
})
