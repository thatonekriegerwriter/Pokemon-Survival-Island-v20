OUTBREAK_TIME    = 24                   #

def pbPetCheck
  if pbGetTimeNow.to_i-$PokemonGlobal.petTime>=OUTBREAK_TIME*60*60
   return true
  else 
   return false
  end
end

def pbGroomCheck
  if pbGetTimeNow.to_i-$PokemonGlobal.groomTime>=OUTBREAK_TIME*60*60
   return true
  else 
   return false
  end

end


def pbFollowerInteraction
command = 0
  loop do
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?"))
    command = pbShowCommands(msgwindow,
                    [_INTL("Talk"),
                    _INTL("Feed"),
                    _INTL("Pet"),
                    _INTL("Groom"),
                    _INTL("Exit")],-1)
    pbDisposeMessageWindow(msgwindow)
    case command
    when 0   # Use Statue
	   FollowingPkmn.talk
    when 1   # Use Statue
	  pkmn = FollowingPkmn.get_pokemon
      pbEatingPkmn(pkmn)
    when 2   # Use Statue
	  $PokemonGlobal.petTime= pbGetTimeNow.to_i
	  if pbPetCheck == true
	  pkmn = FollowingPkmn.get_pokemon
      pkmn.changeHappiness("groom",pkmn)
      pbMessage(_INTL("You pet {1}!",pkmn.name))
      pkmn.cute += 5
	  if rand(100)<=1
      pbMoveRoute($game_player, [PBMoveRoute::Wait, 35])
      FollowingPkmn.move_route([
        PBMoveRoute::TurnRight,
        PBMoveRoute::Wait, 10,
        PBMoveRoute::TurnUp,
        PBMoveRoute::Wait, 10,
        PBMoveRoute::TurnLeft,
        PBMoveRoute::Wait, 10,
        PBMoveRoute::TurnDown
      ])
      pbMessage(_INTL("{1} did its best happy little dance!",pkmn.name))
      pkmn.changeHappiness("groom",pkmn)
	  end
	  else
      pbMessage(_INTL("It's best not to pamper {1} too much!",pkmn.name))
	  end
    when 3   # Use Statue
	  pkmn = FollowingPkmn.get_pokemon
	  if pbGroomCheck == true
	  $PokemonGlobal.groomTime= pbGetTimeNow.to_i
      pkmn.changeLoyalty("groom",pkmn)
      pbMessage(_INTL("You brush {1}!",pkmn.name))
      pkmn.beauty += 5
	  if rand(100)<=1
      pbMoveRoute($game_player, [PBMoveRoute::Wait, 35])
      FollowingPkmn.move_route([
        PBMoveRoute::TurnRight,
        PBMoveRoute::Wait, 10,
        PBMoveRoute::TurnUp,
        PBMoveRoute::Wait, 10,
        PBMoveRoute::TurnLeft,
        PBMoveRoute::Wait, 10,
        PBMoveRoute::TurnDown
      ])
      pbMessage(_INTL("{1} did its best happy little dance!",pkmn.name))
      pkmn.changeLoyalty("groom",pkmn)
	  end
	  else 
      pbMessage(_INTL("It's best not to pamper {1} too much!",pkmn.name))
	  end
    when 4   # Use Statue
	  break 
	end
end
end