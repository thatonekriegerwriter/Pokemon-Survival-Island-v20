

#This one's just to save space lol
def pbSetRunningShoes(status)
  $player.has_running_shoes = status
#v18  $PokemonGlobal.runningShoes = status
end

#Code to turn stop animation on/off.
#This is largely just for scripts; if you're doing this with an event,
#using Set Move Route would be easier.
 
#Returns the filename of an event's current graphic
def pbGetCharSet(event)
  if event == "player" || event == "Player"
    return $game_player.character_name
  else
    event = @event_id if event == "self" || event == "Self"
    return $game_map.events[event].character_name
  end
end
 

#Returns the normal walksprite for the player character
def pbGetNormalChar
  meta = GameData::Metadata.get_player($player.character_ID)
  graphic = pbGetPlayerCharset(meta,1,nil,true)
  return graphic
end

#Sets an event to the given charset
def pbSetCharSet(event,charset)
  if event == "player" || event == "Player"
    $game_player.character_name = charset
  else
    event = @event_id if event == "self" || event == "Self"
    $game_map.events[event].character_name = charset
  end
end


#A little "animation", event pictured turns into a puff of smoke
def pbPoof(event)
  Audio.se_stop
  pbSEPlay("battle recall",80,125)
  if event == "player" || event == "Player"
    pbMoveRoute($game_player,[PBMoveRoute::Graphic,"Cloud",0,$game_player.direction,0])
  else
    pbMoveRoute($game_map.events[event],[PBMoveRoute::Graphic,"Cloud",0,$game_map.events[event].direction,0])
  end
end


#Switches the player's location with another event (uses the event's ID number)
def pbSwapPos(event,poof=true)
  px=$game_player.x
  py=$game_player.y
  pd=$game_player.direction
  pc=pbGetCharSet("player")
  if event == "self" || event == "Self"
    event = @event_id
  end
  ex=$game_map.events[event].x
  ey=$game_map.events[event].y
  ed=$game_map.events[event].direction
  ec=pbGetCharSet(event)
  if poof==true
    pbPoof(event)
    pbPoof("player")
    pbWait(10)
  end
  $game_map.events[event].moveto(px,py)
  $game_player.moveto(ex,ey)
  $game_player.direction = ed
  $game_map.events[event].direction = pd
  pbSetCharSet("player",pc)
  pbSetCharSet(event,ec)
end

#Switches the player's current graphic with the current graphic of an event.
#Running shoes will undo the transformation, so turns them off, unless
#the player is turning back to their original graphic
def pbSwapGraphic(event,poof=true)
  pbSetRunningShoes(false)
  event = @event_id if event == "self" || event == "Self"
  eventchar =  pbGetCharSet(event)
  playerchar = pbGetCharSet("player")
  if poof==true
    pbPoof(event)
    pbPoof("player")
    pbWait(10)
  end
  pbSetCharSet(event,playerchar)
  pbSetCharSet("player",eventchar)
  if eventchar == pbGetNormalChar
    pbSetRunningShoes(true)
  end
end


#Returns true if the event is using the current graphic, and false if they're not
def pbWearing?(event,graphic)
  if event == "player" || event == "Player"
    if $game_player.character_name == graphic
      return true
    else
      return false
    end
  else 
  event = @event_id if event == "self" || event == "Self"
    if $game_map.events[event].character_name == graphic
      return true
    else
      return false
    end
  end
end


#Switches both location and charset
def pbFullSwap(event,poof=false)
  pbSwapGraphic(event,poof)
  pbSwapPos(event,poof)
end

#Changes the event's graphic to the given charset.
#Set stopanime=true if they should move in place as well.
#Running shoes will undo the transformation, so turns them off.
def pbTransform(event,graphic,stopanime = false,poof=true)
  if event == "player" || event == "Player"
    pbSetRunningShoes(false)
  end
  if poof==true
    pbPoof(event)
    pbWait(10)
  end
  event = @event_id if event == "self" || event == "Self"
  pbSetCharSet(event,graphic)
end

#Returns the player to their default charset, and gives back running shoes
def pbDetransform(poof=true)
  graphic = pbGetNormalChar
  pbTransform("player",graphic,poof)
  pbSetRunningShoes(true)
end

#Changes the player into a Pokemon's overworld sprite.
#Can be given a specific Pokemon or just the symbol for the species.
#Can account for form and shininess as well.
def pbTransformPoke(pokemon,form = 0, shiny = false, gender = nil)
  if !pokemon.is_a?(Symbol)
    shiny = pokemon.shiny?
    form = pokemon.form
    gender = pokemon.gender
    pokemon = pokemon.species
  end
  no = GameData::Species.get(pokemon).id_number
    graphic = _INTL("Followers")
    if shiny == true
      graphic+= _INTL(" shiny")
    end
    graphic+=_INTL("/{1}",pokemon)
  if form > 0
    graphic+=_INTL("_{1}",form)
  end
  if !safeExists?("Graphics/Characters/Followers")
    case gender
      when 0
        gender = "female"
      when 1, nil
        gender = "male"
    end
      graphic+=_INTL("_{1}",gender)
  end
    pbTransform("player",graphic,stopanime = false)
end
 

#Lets the player select a Pokemon from their party, and turns them into the
#matching overworld sprite
def pbSelectPokeTransform
PokemonSelection.choose(
     PokemonSelection::Parameters.new
           .setMinPokemon(1)
           .setMaxPokemon(1)
           .setCanCancel(true))
    pokemon=$player.party[0]
    pbTransformPoke(pokemon)
end

def pbSelectPokeTransform2
PokemonSelection.choose(
     PokemonSelection::Parameters.new
           .setMinPokemon(2)
           .setMaxPokemon(2)
           .setCanCancel(true))
    pokemon=$player.party[0]
    pbTransformPoke(pokemon)
  end

