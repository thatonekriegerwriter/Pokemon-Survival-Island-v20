class Battle::Scene
  def pbAnimationCore(animation, user, target, oppMove = false)
    return if !animation
    @briefMessage = false
    userSprite   = (user) ? @sprites["pokemon_#{user.index}"] : nil
    targetSprite = (target) ? @sprites["pokemon_#{target.index}"] : nil
    oldUserX = (userSprite) ? userSprite.x : 0
    oldUserY = (userSprite) ? userSprite.y : 0
    oldTargetX = (targetSprite) ? targetSprite.x : oldUserX
    oldTargetY = (targetSprite) ? targetSprite.y : oldUserY
    
    
    newcolor  = Settings::SHADOW_COLOR
    oldcolor  = Color.new(0,0,0,0)
     
    if userSprite && user.shadowPokemon?
      oldUserColor = newcolor
    else
      oldUserColor = oldcolor
    end
      
    if targetSprite && target.shadowPokemon?
      oldTargetColor = newcolor
    else
      oldTargetColor = oldcolor
    end
    
    animPlayer = PBAnimationPlayerX.new(animation,user,target,self,oppMove)
    userHeight = (userSprite && userSprite.bitmap && !userSprite.bitmap.disposed?) ? userSprite.bitmap.height : 128
    if targetSprite
      targetHeight = (targetSprite.bitmap && !targetSprite.bitmap.disposed?) ? targetSprite.bitmap.height : 128
    else
      targetHeight = userHeight
    end
    animPlayer.setLineTransform(FOCUSUSER_X, FOCUSUSER_Y, FOCUSTARGET_X, FOCUSTARGET_Y, oldUserX, oldUserY - (userHeight / 2), oldTargetX, oldTargetY - (targetHeight / 2))
    animPlayer.start
    loop do
      animPlayer.update
      userSprite.color   = oldUserColor    if userSprite
      targetSprite.color = oldTargetColor  if targetSprite
      pbUpdate
      break if animPlayer.animDone?
    end
    animPlayer.dispose
    if userSprite
      userSprite.x = oldUserX
      userSprite.y = oldUserY
      userSprite.pbSetOrigin
    end
    if targetSprite
      targetSprite.x = oldTargetX
      targetSprite.y = oldTargetY
      targetSprite.pbSetOrigin
    end
  end
end





class PokemonIconSprite < SpriteWrapper
  def pokemon=(value)
    @pokemon = value
    @animBitmap&.dispose
    @animBitmap = nil
    if !@pokemon
      self.bitmap = nil
      @currentFrame = 0
      @counter = 0
      return
    end
    hue = (PluginManager.installed?("Pokémon Birthsigns")) ? pbCelestialHue(@pokemon.species, @pokemon.celestial?) : 0
    @animBitmap = AnimatedBitmap.new(GameData::Species.icon_filename_from_pokemon(value), hue)
    self.bitmap = @animBitmap.bitmap
    self.src_rect.width  = @animBitmap.height
    self.src_rect.height = @animBitmap.height
    @numFrames    = @animBitmap.width / @animBitmap.height
    @currentFrame = 0 if @currentFrame >= @numFrames
    if @pokemon.shadowPokemon?
      self.color = Color.new(60, 0, 160, 140)
    end
    changeOrigin
  end
end





class PokemonPartyPanel < Sprite
  attr_reader :pokemon

  def dispose
    @pkmnsprite.dispose
    super
  end

  def x=(value)
    super
    refresh
  end

  def y=(value)
    super
    refresh
  end

  def color=(value)
    super
    refresh
  end

  def pokemon=(value)
    @pokemon = value
    @pkmnsprite.pokemon = value if @pkmnsprite && !@pkmnsprite.disposed?
    @refreshBitmap = true
    refresh
  end

 
  def refresh_pokemon_icon
    return if !@pkmnsprite || @pkmnsprite.disposed?
    @pkmnsprite.x        = self.x + 60
    @pkmnsprite.y        = self.y + 40

    if @pokemon.shadowPokemon?
      @pkmnsprite.color    = Color.new(60, 0, 160, 140)
    end

    @pkmnsprite.selected = self.selected
  end


  def update
    super
    @pkmnsprite.update if @pkmnsprite && !@pkmnsprite.disposed?
  end
end

