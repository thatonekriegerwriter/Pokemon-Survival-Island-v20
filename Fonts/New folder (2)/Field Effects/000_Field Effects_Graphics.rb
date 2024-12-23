#============================================================================
#			Field Effects V 1							for Essentials v20.1
#============================================================================
# 	This section of the code dictates all the graphical aspects.
# 	It connects each Field to a Battle Background; 
# 	This is used for when a battle starts for the game to identify the field 
# used in that area and also for when a field transforms into another one, 
# allowing it to change to the proper background.
# 	Also adds introduction/announcement text at the start of battle.
#
# One thing of note, this isn't fully based on Reborns way of doing fields,
# this code makes Terrains overlay on top of fields. I'm too lazy to explain 
# how to change it to not overlay, but youre smart and have eyes, you can probably
# figure it out by reading the code (I hope #badcoder).
#============================================================================

class Game_Temp
    # Field Effects 
	attr_accessor :fieldEffectsBg
	attr_accessor :fieldOverride
	attr_accessor :tempField
	attr_accessor :fieldCounter
	attr_accessor :fieldCollapse
	attr_accessor :fieldBackup
    attr_accessor :fieldMessage
	# Terrains
	attr_accessor :terrainEffectsBg
	attr_accessor :terrainOverride
	attr_accessor :tempTerrain 
	attr_accessor :terrainCounter 
	attr_accessor :terrainCollapse 
	attr_accessor :terrainBackup
	attr_accessor :terrainMessage
	# This is used to calculate how long each terrain acts
	attr_accessor :terrainDuration
end

#==========================================================
# 	Define here all your backgrounds for each Field Effect.
# 	This section is what controls the background of each field
# when transforming from one field to another.
# 	It DOES NOT connect a field to a specific background, thats done a bit lower.
#==========================================================

class Battle::Scene
    module FieldEffects
    Files = {
        0 => { # Indoor
            :battle_bg => "indoor1_bg.png",
            :base_0 => "indoor1_base0_png",
            :base_1 => "indoor1_base1.png"
        },
        1 => { # Example Field
            :battle_bg => "example_bg.png",
            :base_0 => "example_base0.png",
            :base_1 => "example_base1.png"
        }
    };
	end

	def pbChangeBGSprite
		id = $game_temp.fieldEffectsBg
		if id && FieldEffects::Files.key?(id)
			files = FieldEffects::Files[id]
			root = "Graphics/Battlebacks/"
			@sprites["battle_bg"].setBitmap("#{root}/#{files[:battle_bg]}") 
			@sprites["base_0"].setBitmap("#{root}/#{files[:base_0]}") 
			@sprites["base_1"].setBitmap("#{root}/#{files[:base_1]}")  
		end
	end
end

#============================================================================
# This section tells the game that if background is X, then Field is X
#============================================================================

class Battle::Scene
  def pbCreateBackdropSprites
    case @battle.time
    when 1; time = "eve"
    when 2; time = "night"
    end
	# Choose backdrop based on:
		# Don't touch any of these, they all need to be 0
		# it resets the field and terrain to be non-existent at the start, before verifying the area
		# Field Effects 
			$game_temp.fieldOverride = 0
			$game_temp.tempField = 0
			$game_temp.fieldCounter = 0
			$game_temp.fieldCollapse = 0
		# Terrains 
			$game_temp.terrainOverride = 0
			$game_temp.tempTerrain = 0
			$game_temp.terrainCounter = 0
			$game_temp.terrainCollapse = 0
    # Put everything together into backdrop, bases and message bar filenames
    backdropFilename = @battle.backdrop
    baseFilename = @battle.backdrop
    baseFilename = sprintf("%s_%s", baseFilename, @battle.backdropBase) if @battle.backdropBase
    messageFilename = @battle.backdrop
    if time
      trialName = sprintf("%s_%s", backdropFilename, time)
      if pbResolveBitmap(sprintf("Graphics/Battlebacks/" + trialName + "_bg"))
        backdropFilename = trialName
      end
      trialName = sprintf("%s_%s", baseFilename, time)
      if pbResolveBitmap(sprintf("Graphics/Battlebacks/" + trialName + "_base0"))
        baseFilename = trialName
      end
      trialName = sprintf("%s_%s", messageFilename, time)
      if pbResolveBitmap(sprintf("Graphics/Battlebacks/" + trialName + "_message"))
        messageFilename = trialName
      end
    end
    if !pbResolveBitmap(sprintf("Graphics/Battlebacks/" + baseFilename + "_base0")) &&
       @battle.backdropBase
      baseFilename = @battle.backdropBase
      if time
        trialName = sprintf("%s_%s", baseFilename, time)
        if pbResolveBitmap(sprintf("Graphics/Battlebacks/" + trialName + "_base0"))
          baseFilename = trialName
        end
      end
    end
	
	# FIELD EFFECTS + TERRAINS
	# NOTE: fieldbd is strictly used for Fields
	#		terrainbd is for Terrains
	# 			This distinction here while not directly tied to Terrains overlaying
	#		Fields, it does end up making that connection later down the line through
	#		this line of code below '$game_temp.terrainEffectsBg = terrainbd'
	#
	# 	If you want to add more fields here all you have to do is follow the example shown below.
	# just add more 'elsif backdropFilename == "xxx"'
	#	If you want to add night time versions for fields (why would you though, thats so much work art-wise)
	# just uncomment the area just below, and then follow that example for the other fields/terrains.
	
	if backdropFilename == "example" # || backdropFilename == "example_night"
	  fieldbd = 1
	elsif backdropFilename == "grassy" 
	  terrainbd = 1
	elsif backdropFilename == "electric" 
	  terrainbd = 2
	elsif backdropFilename == "misty" 
	  terrainbd = 3
	elsif backdropFilename == "psychic"
	  terrainbd = 4
	else 
	  fieldbd = 0
	end

    # Connects Bakcground to Field
		$game_temp.fieldEffectsBg = fieldbd
		$game_temp.fieldBackup = $game_temp.fieldEffectsBg   
	# Connects Background to Terrain
		$game_temp.terrainEffectsBg = terrainbd
		$game_temp.terrainBackup = $game_temp.terrainEffectsBg 
	
    # Finalise filenames
    battleBG   = "Graphics/Battlebacks/" + backdropFilename + "_bg"
    playerBase = "Graphics/Battlebacks/" + baseFilename + "_base0"
    enemyBase  = "Graphics/Battlebacks/" + baseFilename + "_base1"
    messageBG  = "Graphics/Battlebacks/" + messageFilename + "_message"
    # Apply graphics
    bg = pbAddSprite("battle_bg", 0, 0, battleBG, @viewport)
    bg.z = 0
    bg = pbAddSprite("battle_bg2", -Graphics.width, 0, battleBG, @viewport)
    bg.z      = 0
    bg.mirror = true
    2.times do |side|
      baseX, baseY = Battle::Scene.pbBattlerPosition(side)
      base = pbAddSprite("base_#{side}", baseX, baseY,
                         (side == 0) ? playerBase : enemyBase, @viewport)
      base.z = 1
      if base.bitmap
        base.ox = base.bitmap.width / 2
        base.oy = (side == 0) ? base.bitmap.height : base.bitmap.height / 2
      end
    end
    cmdBarBG = pbAddSprite("cmdBar_bg", 0, Graphics.height - 96, messageBG, @viewport)
    cmdBarBG.z = 180
  end
 end

#
# The starting battle message for all Field Effects and Terrains is set here.
# I took some liberties for the Terrains intro text, as I don't think there's any in 
# the normal Game Freak games. If there is, change it accordingly and tell me later too.

class Battle
	def pbStartBattleCore
    # Set up the battlers on each side
    sendOuts = pbSetUpSides
    # Create all the sprites and play the battle intro animation
    @scene.pbStartBattle(self)
    # Show trainers on both sides sending out Pokémon
    pbStartBattleSendOut(sendOuts)
	
	
	# Field announcement
	case $game_temp.fieldEffectsBg
		when 1 # Forest Field
		 pbDisplay(_INTL("Example text for the example field!"))
	end
	
	# Terrain announcement
	case $game_temp.terrainEffectsBg
		when 1 # Grassy Terrain
		 pbDisplay(_INTL("The terrain is in full bloom!"))
		when 2 # Electric Terrain
		 pbDisplay(_INTL("The terrain is hyper-charged!"))
		when 3 # Misty Terrain
		 pbDisplay(_INTL("Mist is surrounding the terrain."))
		when 4 # Psychic Terrain
		 pbDisplay(_INTL("The terrain feels confusing."))
	end
	
    # Weather announcement
    weather_data = GameData::BattleWeather.try_get(@field.weather)
    pbCommonAnimation(weather_data.animation) if weather_data
    case @field.weather
		when :Sun         then pbDisplay(_INTL("The sunlight is strong."))
		when :Rain        then pbDisplay(_INTL("It is raining."))
		when :Sandstorm   then pbDisplay(_INTL("A sandstorm is raging."))
		when :Hail        then pbDisplay(_INTL("Hail is falling."))
		when :HarshSun    then pbDisplay(_INTL("The sunlight is extremely harsh."))
		when :HeavyRain   then pbDisplay(_INTL("It is raining heavily."))
		when :StrongWinds then pbDisplay(_INTL("The wind is strong."))
		when :ShadowSky   then pbDisplay(_INTL("The sky is shadowy."))
    end
    # Abilities upon entering battle
    pbOnAllBattlersEnteringBattle
    # Main battle loop
    pbBattleLoop
  end
end