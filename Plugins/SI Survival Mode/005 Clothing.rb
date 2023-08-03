

def pbCrateClothes
      scene = WardrobeScene.new
      screen = WardrobeScreen.new(scene)
      screen.pbStartScreen
end

def pbClothingEffect(clothing)
		  $player.playerhealthmod=0
        case clothing
		when :NORMALSHOES
		  #YOU GET NOTHING, GOOD DAY SIR.
		when :MAKESHIFTRUNNINGSHOES
		  #YOU GET NOTHING, GOOD DAY SIR.
		when :RUNNINGSHOES
		  #YOU GET NOTHING, GOOD DAY SIR.
		when :SEASHOES
		  #AAAAAAAAAAAAAAAAAAAAAAA
		when :NORMALSHIRT
		  #YOU GET NOTHING, GOOD DAY SIR.
		when :SILKSHIRT
		  #MAKES YOU FEEL CLEAN?!??! WTF DOES THIS DO?
		when :WOOLENCLOAK
		  #Helps with cold?
		when :LEATHERJACKET
		  #I D F K
		when :IRONARMOR
		  $player.playerhealthmod+=25
		when :NORMALPANTS
		  #YOU GET NOTHING, GOOD DAY SIR.
		when :SPOOKYPANTS
		  #If you die you dont?
		when :PROTECTIVEPANTS
		  $player.playerhealthmod+=15
		end
end

class WardrobeScene
  # Waits x frames
  def wait(frames)
    frames.times do
      Graphics.update
    end
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
    if @sprites["bg"]
      @sprites["bg"].ox -= 2
      @sprites["bg"].oy -= 2
    end
  end

  def pbStartScene
    @front      = true
    @flip       = false
    @viewport   = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    bgColor = Color.new(100,100,100)
    @sprites    = {}
    @sprites["bg"] = ColoredPlane.new(bgColor, @viewport)
	@sprites["bg"].z = -1
    @sprites["bg"].visible = true
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
	@sprites["overlay"].z = 10
    @overlay = @sprites["overlay"].bitmap
    @sprites["trainer"] = IconSprite.new(336, 112, @viewport)
    @sprites["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($player.trainer_type))
    @sprites["trainer"].x -= ((@sprites["trainer"].bitmap.width - 128) / 2)+100
    @sprites["trainer"].y -= ((@sprites["trainer"].bitmap.height - 128))-20
    @tx=@sprites["trainer"].x
    @ty=@sprites["trainer"].y
    @sprites["trainer"].z = 2
    @sprites["selarrow"] = AnimatedSprite.new("Graphics/Pictures/downarrow", 8, 28, 40, 2, @viewport)
    @sprites["selarrow"].x = 230
    @sprites["selarrow"].y = 110
    @sprites["selarrow"].z = 99
    @sprites["selarrow"].play
    @sprites["selarrow"].visible = false
    pbDrawTest
    pbFadeInAndShow(@sprites) { pbUpdate }

  end


  def pbDrawTest
    baseColor   = Color.new(72, 72, 72)
    shadowColor = Color.new(160, 160, 160)
    textPositions = [
     [_INTL("Wardrobe"), 220, 10, 0, baseColor, shadowColor],
      [$player.name, 330, 64, 1, baseColor, shadowColor],
#      [_INTL("{1}",$player.playerclass), 350, 64, 0, baseColor, shadowColor],
#      [_INTL("Lv{1}",$game_system.level_cap), 468, 64, 1, baseColor, shadowColor],
       [_INTL("{1}",GameData::Item.get($player.playershirt).name.to_s),227,140,0,baseColor,shadowColor],
       [_INTL("{1}",GameData::Item.get($player.playerpants).name.to_s),266,175,1,baseColor,shadowColor],
       [_INTL("{1}",GameData::Item.get($player.playershoes).name.to_s),270,220,1,baseColor,shadowColor]
#       [_INTL("Pokédex"),36,152,0,baseColor,shadowColor],
#       [sprintf("%d/%d",$player.pokedex.owned_count,$player.pokedex.seen_count),302,152,1,baseColor,shadowColor],
#       [_INTL("FOD"),34,190,0,baseColor,shadowColor],
#       [_INTL("a"),305,190,1,baseColor,shadowColor],
#       [_INTL("{1}%",$player.playerfood.to_s_formatted),190,190,1,baseColor,shadowColor],
#       [_INTL("H20"),34,221,0,baseColor,shadowColor],
#       [_INTL("a"),305,221,1,baseColor,shadowColor],
#       [_INTL("{1}%",$player.playerwater.to_s_formatted),190,221,1,baseColor,shadowColor],
#       [_INTL("SLP"),34,250,0,baseColor,shadowColor],
#       [_INTL("a"),305,250,1,baseColor,shadowColor],
#       [_INTL("{1}%",$player.playersleep.to_s_formatted),190,250,1,baseColor,shadowColor]
    ]
    pbDrawTextPositions(@overlay, textPositions)
    x = 72
    imagepos=[]
  end


  def pbControls
    @position = -1
    loop do
      if Input.trigger?(Input::USE)
	  if @position == -1
      @sprites["selarrow"].visible = true
	  @position = 0
	  else
	  case @position 
	   when 0
       cmd2 = pbMessage(_INTL("Do you want to put another top on?"),[_INTL("Yes"), _INTL("No")])
       if cmd2 == 0
	    $bag.add(GameData::Item.get($player.playershirt).id,1) if $player.playershirt != 0
        $player.playershirt = 0
        pbFadeOutIn {
                              scene = PokemonBag_Scene.new
                              screen = PokemonBagScreen.new(scene, $bag)
                             $player.playershirt = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_shirt? })}
		$bag.remove($player.playershirt,1)
		pbClothingEffect($player.playershirt)
       end
	   when 1
       cmd2 = pbMessage(_INTL("Do you want to put different bottoms on?"),[_INTL("Yes"), _INTL("No")])
       if cmd2 == 0
	    $bag.add(GameData::Item.get($player.playerpants).id,1) if $player.playerpants != 0
        $player.playerpants = 0
        pbFadeOutIn {
                              scene = PokemonBag_Scene.new
                              screen = PokemonBagScreen.new(scene, $bag)
                             $player.playerpants = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_pants? })}
		$bag.remove($player.playerpants,1)
		pbClothingEffect($player.playerpants)
       end
	   when 2
       cmd2 = pbMessage(_INTL("Do you want to put different shoes on?"),[_INTL("Yes"), _INTL("No")])
       if cmd2 == 0
	    $bag.add(GameData::Item.get($player.playershoes).id,1) if $player.playershoes != 0
        $player.playershoes = 0
        pbFadeOutIn {
                              scene = PokemonBag_Scene.new
                              screen = PokemonBagScreen.new(scene, $bag)
                             $player.playershoes = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_shoes? })}
		$bag.remove($player.playershoes,1)
		pbClothingEffect($player.playershoes)
       end
	  end
      end
	  end
      if Input.trigger?(Input::UP)
	  if (@position - 1) < 0
	  @position = 2
	  else
	  @position -= 1
	  end
	  case @position 
	   when 0
         @sprites["selarrow"].y = 110
	   when 1
         @sprites["selarrow"].y = 145
	   when 2
         @sprites["selarrow"].y = 190
	  end
	  end
      if Input.trigger?(Input::DOWN)
	  if (@position + 1) > 2
	  @position = 0
	  else
	  @position += 1
	  end
	  case @position 
	   when 0
         @sprites["selarrow"].y = 110
	   when 1
         @sprites["selarrow"].y = 145
	   when 2
         @sprites["selarrow"].y = 190
	  end
      end
      if Input.trigger?(Input::BACK)
        break
      end
      Graphics.update
      Input.update
      pbUpdate
    end
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end
#===============================================================================
#
#===============================================================================

class WardrobeScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbControls
    @scene.pbEndScene
  end
end


  EventHandlers.add(:on_frame_update, :spookieshouseofpoopies,
  proc {
  if  $PokemonSystem.survivalmode==0 && $player.playerhealth == 0 && $player.playershoes == :SPOOKYPANTS && $player.playerstamina != 0
     $player.playerhealth = 1
     $player.playerstamina = 0
     $player.playerfood = 0
     $player.playerwater = 0
     $player.playersleep = 0
     $player.playersaturation = 0
  end
  }
)