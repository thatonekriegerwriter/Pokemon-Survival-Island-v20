#===============================================================================
###---EDIT---###
#===============================================================================
class PokemonTrainerCard_Scene
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    background = pbResolveBitmap(sprintf("Graphics/Pictures/Trainer Card/bg_f"))
    if $Trainer.female? && background
      addBackgroundPlane(@sprites,"bg","Trainer Card/bg_f",@viewport)
    else
      addBackgroundPlane(@sprites,"bg","Trainer Card/bg",@viewport)
    end
    cardexists = pbResolveBitmap(sprintf("Graphics/Pictures/Trainer Card/card_f"))
    @sprites["card"] = IconSprite.new(0,0,@viewport)
    if $Trainer.female? && cardexists
      @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card_f")
    else
      @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card")
    end
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["trainer"] = IconSprite.new(336,112,@viewport)
    @sprites["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($Trainer.trainer_type))
    @sprites["trainer"].x -= (@sprites["trainer"].bitmap.width-128)/2
    @sprites["trainer"].y -= (@sprites["trainer"].bitmap.height-128)
    @sprites["trainer"].z = 2
    pbDrawTrainerCardFront
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbDrawTrainerCardFront
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    baseColor   = Color.new(72,72,72)
    shadowColor = Color.new(160,160,160)
    totalsec = Graphics.frame_count / Graphics.frame_rate
    hour = totalsec / 60 / 60
    min = totalsec / 60 % 60
    time = (hour>0) ? _INTL("{1}h {2}m",hour,min) : _INTL("{1}m",min)
	
	
    if $Trainer.money >= 80
         trainerhealth = _INTL("Healthy")
         healthColor=Color.new(55,255,55)
     else
       if $Trainer.money >= 50
         trainerhealth = _INTL("Injured")
         healthColor=Color.new(255,255,55)
     else
        if $Trainer.money >= 25
         trainerhealth = _INTL("Wounded")
         healthColor=Color.new(255,125,55)
     else
        if $Trainer.money >= 25
         trainerhealth = _INTL("Critical")
         healthColor=Color.new(255,55,55)
        end
        end
     end
    end

    if $game_variables[205] >= 80
         trainerhunger = _INTL("Full")
         hungerColor=Color.new(55,255,55)
       else
         if $game_variables[205] >= 75
           trainerhunger = _INTL("Well Off")
           hungerColor=Color.new(255,255,55)
         else
           if $game_variables[205] >= 50
             trainerhunger = _INTL("Hungry")
             hungerColor=Color.new(255,125,55)
           else
               if $game_variables[205] >= 25
                trainerhunger = _INTL("Starving")
                hungerColor=Color.new(255,125,55)
                else
                 if $game_variables[205] >= 0
                   trainerhunger= _INTL("Dying")
                   hungerColor=Color.new(255,55,55)
			    end
			   end
           end
         end
       end   


    if $game_variables[206] >= 80
         trainerthirst = _INTL("Quenched")
         thirstColor=Color.new(55,255,55)
       else
         if $game_variables[206] >= 75
           trainerthirst = _INTL("Well Off")
           thirstColor=Color.new(255,255,55)
         else
           if $game_variables[206] >= 50
             trainerthirst = _INTL("Thirsty")
             thirstColor=Color.new(255,125,55)
           else
               if $game_variables[206] >= 25
                trainerthirst = _INTL("Dehydrated")
                thirstColor=Color.new(255,125,55)
                else
                 if $game_variables[206] >= 0
                   trainerthirst= _INTL("Dying")
                   thirstColor=Color.new(255,55,55)
			    end
			   end
           end
         end
       end   

    if $game_variables[208] >= 80
          trainersleep = _INTL("Rested")
          sleepColor=Color.new(55,255,55)
       else
         if $game_variables[208] >= 75
            trainersleep = _INTL("Well Off")
            sleepColor=Color.new(255,255,55)
         else
           if $game_variables[208] >= 50
              trainersleep = _INTL("Tired")
              sleepColor=Color.new(255,125,55)
           else
               if $game_variables[208] >= 25
                 trainersleep = _INTL("Deprived")
                 sleepColor=Color.new(255,125,55)
                else
                 if $game_variables[208] >= 0
                   trainersleep= _INTL("Dying")
                   sleepColor=Color.new(255,55,55)
			    end
			   end
           end
         end
       end 
    $PokemonGlobal.startTime = pbGetTimeNow if !$PokemonGlobal.startTime
    starttime = _INTL("{1} {2}, {3}",
       pbGetAbbrevMonthName($PokemonGlobal.startTime.mon),
       $PokemonGlobal.startTime.day,
       $PokemonGlobal.startTime.year)
    textPositions = [
       [_INTL("Name"),36,60,0,baseColor,shadowColor],
       [$Trainer.name,302,60,1,baseColor,shadowColor],
       [_INTL("ID No."),332,60,0,baseColor,shadowColor],
       [sprintf("%05d",$Trainer.publicID($Trainer.id)),468,60,1,baseColor,shadowColor],
       [_INTL("Health"),40,103,0,baseColor,shadowColor],
       [_INTL(trainerhealth),302,103,1,healthColor,shadowColor],
       [_INTL("{1}%",$Trainer.money.to_s_formatted),190,103,1,healthColor,shadowColor],
       [_INTL("Pokédex"),36,147,0,baseColor,shadowColor],
       [sprintf("%d/%d",$Trainer.pokedex.owned_count,$Trainer.pokedex.seen_count),302,147,1,baseColor,shadowColor],
       [_INTL("FOD"),34,186,0,baseColor,shadowColor],
       [_INTL(trainerhunger),302,186,1,hungerColor,shadowColor],
       [_INTL("{1}%",$game_variables[205].to_s_formatted),190,186,1,hungerColor,shadowColor],
       [_INTL("H20"),34,217,0,baseColor,shadowColor],
       [_INTL(trainerthirst),302,217,1,thirstColor,shadowColor],
       [_INTL("{1}%",$game_variables[206].to_s_formatted),190,217,1,thirstColor,shadowColor],
       [_INTL("SLP"),34,246,0,baseColor,shadowColor],
       [_INTL(trainersleep),302,246,1,sleepColor,shadowColor],
       [_INTL("{1}%",$game_variables[208].to_s_formatted),190,246,1,sleepColor,shadowColor]
    ]
    pbDrawTextPositions(overlay,textPositions)
    x = 72
    region = pbGetCurrentRegion(0) # Get the current region
    imagePositions = []
    for i in 0...8
      if $Trainer.badges[i+region*8]
        imagePositions.push(["Graphics/Pictures/Trainer Card/icon_badges",x,310,i*32,region*32,32,32])
      end
      x += 48
    end
    pbDrawImagePositions(overlay,imagePositions)
  end

  def pbTrainerCard
    pbSEPlay("GUI trainer card open")
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      end
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

class PokemonTrainerCardScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbTrainerCard
    @scene.pbEndScene
  end
end
	 ###---EDIT END---###