OUTBREAK_TIME    = 24                   #

def pbPetCheck
  if pbGetTimeNow.to_i-$PokemonGlobal.petTime>=24*60*60
   return true
  else 
   return false
  end
end

def pbGroomCheck
  if pbGetTimeNow.to_i-$PokemonGlobal.groomTime>=24*60*60
   return true
  else 
   return false
  end

end


def pbFollowerInteraction(appear=false,poke=nil)
command = 0
if appear==false
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
	  if $PokemonGlobal.petTime.nil?
	  $PokemonGlobal.petTime= pbGetTimeNow.to_i
	  end
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
	  pkmn = FollowingPkmn.get_pokemon
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
	  pkmn = FollowingPkmn.get_pokemon
      pbMessage(_INTL("It's best not to pamper {1} too much!",pkmn.name))
	  end
    when 4   # Use Statue
	  break 
	end
end
else
  loop do
    msgwindow = pbCreateMessageWindow(nil,nil)
    pbMessageDisplay(msgwindow,_INTL("What do you want to do?"))
    command = pbShowCommands(msgwindow,
                    [_INTL("Talk"),
                    _INTL("Feed"),
                    _INTL("Pet"),
                    _INTL("Groom"),
                    _INTL("Pick Up"),
                    _INTL("Exit")],-1)
    pbDisposeMessageWindow(msgwindow)
    case command
    when 0   # Use Statue
	   FollowingPkmn.talk2(poke)
    when 1   # Use Statue
      pbEatingPkmn(poke)
    when 2   # Use Statue
	  if $PokemonGlobal.petTime.nil?
	  $PokemonGlobal.petTime= 0
	  end
	  if pbPetCheck == true
	  pkmn = poke
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
	  $PokemonGlobal.petTime= pbGetTimeNow.to_i
	  else
	  pkmn = poke
      pbMessage(_INTL("It's best not to pamper {1} too much!",pkmn.name))
	  end
    when 3   # Use Statue
	  pkmn = poke
	  if pbGroomCheck == true
	  if $PokemonGlobal.groomTime.nil?
	  $PokemonGlobal.groomTime= 0
	  end
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
	  
	  $PokemonGlobal.groomTime= pbGetTimeNow.to_i
	  else 
	  pkmn = poke
      pbMessage(_INTL("It's best not to pamper {1} too much!",pkmn.name))
	  end
    when 4   # Use Statue
    event = $game_player.pbFacingEvent
	pbReturnPokemon(event.id,true)
	break
	else
	  break 
	end
end





end

end