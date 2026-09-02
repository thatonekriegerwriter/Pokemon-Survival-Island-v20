#===============================================================================
# Evolution screen
#===============================================================================
class PokemonEvolutionScene
  private

  def pbGenerateMetafiles(s1x, s1y, s2x, s2y)
    sprite = SpriteMetafile.new
    sprite.ox      = s1x
    sprite.oy      = s1y
    sprite.opacity = 255
    sprite2 = SpriteMetafile.new
    sprite2.ox      = s2x
    sprite2.oy      = s2y
    sprite2.zoom    = 0.0
    sprite2.opacity = 255
    alpha = 0
    alphaDiff = 10 * 20 / Graphics.frame_rate
    loop do
      sprite.color.red   = 255
      sprite.color.green = 255
      sprite.color.blue  = 255
      sprite.color.alpha = alpha
      sprite.color  = sprite.color
      sprite2.color = sprite.color
      sprite2.color.alpha = 255
      sprite.update
      sprite2.update
      break if alpha >= 255
      alpha += alphaDiff
    end
    totaltempo   = 0
    currenttempo = 25
    maxtempo = 7 * Graphics.frame_rate
    while totaltempo < maxtempo
      currenttempo.times do |j|
        if alpha < 255
          sprite.color.red   = 255
          sprite.color.green = 255
          sprite.color.blue  = 255
          sprite.color.alpha = alpha
          sprite.color = sprite.color
          alpha += 10
        end
        sprite.zoom  = [1.1 * (currenttempo - j - 1) / currenttempo, 1.0].min
        sprite2.zoom = [1.1 * (j + 1) / currenttempo, 1.0].min
        sprite.update
        sprite2.update
      end
      totaltempo += currenttempo
      if totaltempo + currenttempo < maxtempo
        currenttempo.times do |j|
          sprite.zoom  = [1.1 * (j + 1) / currenttempo, 1.0].min
          sprite2.zoom = [1.1 * (currenttempo - j - 1) / currenttempo, 1.0].min
          sprite.update
          sprite2.update
        end
      end
      totaltempo += currenttempo
      currenttempo = [(currenttempo / 1.5).floor, 5].max
    end
    @metafile1 = sprite
    @metafile2 = sprite2
  end

  public

  def pbUpdate(animating = false)
    if animating      # Pokémon shouldn't animate during the evolution animation
      @sprites["background"].update
      @sprites["msgwindow"].update
    else
      pbUpdateSpriteHash(@sprites)
    end
  end

  def pbUpdateNarrowScreen(timer_start)
    return if @bgviewport.rect.y >= 80
    buffer = 80
    @bgviewport.rect.height = Graphics.height - lerp(0, 64 + (buffer * 2), 0.7, timer_start, System.uptime).to_i
    @bgviewport.rect.y = lerp(0, buffer, 0.5, timer_start + 0.2, System.uptime).to_i
    @sprites["background"].oy = @bgviewport.rect.y
  end

  def pbUpdateExpandScreen(timer_start)
    return if @bgviewport.rect.height >= Graphics.height
    buffer = 80
    @bgviewport.rect.height = Graphics.height - lerp(64 + (buffer * 2), 0, 0.7, timer_start, System.uptime).to_i
    @bgviewport.rect.y = lerp(buffer, 0, 0.5, timer_start, System.uptime).to_i
    @sprites["background"].oy = @bgviewport.rect.y
  end

  def pbFlashInOut(canceled, oldstate, oldstate2)
    timer_start = System.uptime
    tone = 0
    toneDiff = 20 * 20 / Graphics.frame_rate
    loop do
      Graphics.update
      pbUpdate(true)
      pbUpdateExpandScreen(timer_start)
      tone += toneDiff
      @viewport.tone.set(tone, tone, tone, 0)
      break if tone >= 255
    end
    @bgviewport.rect.y      = 0
    @bgviewport.rect.height = Graphics.height
    @sprites["background"].oy = 0
    if canceled
      pbRestoreSpriteState(@sprites["rsprite1"], oldstate)
      pbRestoreSpriteState(@sprites["rsprite2"], oldstate2)
      @sprites["rsprite1"].zoom_x      = 1.0
      @sprites["rsprite1"].zoom_y      = 1.0
      @sprites["rsprite1"].color.alpha = 0
      @sprites["rsprite1"].visible     = true
      @sprites["rsprite2"].visible     = false
    else
      @sprites["rsprite1"].visible     = false
      @sprites["rsprite2"].visible     = true
      @sprites["rsprite2"].zoom_x      = 1.0
      @sprites["rsprite2"].zoom_y      = 1.0
      @sprites["rsprite2"].color.alpha = 0
    end
    (Graphics.frame_rate / 4).times do
      Graphics.update
      pbUpdate(true)
    end
    tone = 255
    toneDiff = 40 * 20 / Graphics.frame_rate
    loop do
      Graphics.update
      pbUpdate
      tone -= toneDiff
      @viewport.tone.set(tone, tone, tone, 0)
      break if tone <= 0
    end
  end

  def pbStartScreen(pokemon, newspecies)
    @pokemon = pokemon
    @newspecies = newspecies
    @sprites = {}
    @bgviewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @bgviewport.z = 99999
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @msgviewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @msgviewport.z = 99999
    addBackgroundOrColoredPlane(@sprites, "background", "evolutionbg",
                                Color.new(248, 248, 248), @bgviewport)
    rsprite1 = PokemonSprite.new(@viewport)
    rsprite1.setOffset(PictureOrigin::CENTER)
    rsprite1.setPokemonBitmap(@pokemon, false)
    rsprite1.x = Graphics.width / 2
    rsprite1.y = (Graphics.height - 64) / 2
    rsprite2 = PokemonSprite.new(@viewport)
    rsprite2.setOffset(PictureOrigin::CENTER)
    rsprite2.setPokemonBitmapSpecies(@pokemon, @newspecies, false)
    rsprite2.x       = rsprite1.x
    rsprite2.y       = rsprite1.y
    rsprite2.opacity = 0
    @sprites["rsprite1"] = rsprite1
    @sprites["rsprite2"] = rsprite2
    pbGenerateMetafiles(rsprite1.ox, rsprite1.oy, rsprite2.ox, rsprite2.oy)
    @sprites["msgwindow"] = pbCreateMessageWindow(@msgviewport)
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  # Closes the evolution screen.
  def pbEndScreen(need_fade_out = true)
    pbDisposeMessageWindow(@sprites["msgwindow"]) if @sprites["msgwindow"]
    if need_fade_out
      pbFadeOutAndHide(@sprites) { pbUpdate }
    end
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
    @bgviewport.dispose
    @msgviewport.dispose
  end

  # Opens the evolution screen
  def pbEvolution(cancancel = true)
    puts "killing"
    metaplayer1 = SpriteMetafilePlayer.new(@metafile1, @sprites["rsprite1"])
    metaplayer2 = SpriteMetafilePlayer.new(@metafile2, @sprites["rsprite2"])
    metaplayer1.play
    metaplayer2.play
    pbBGMStop
    pbMessageDisplay(@sprites["msgwindow"], "\\se[]" + _INTL("What?") + "\\1") { pbUpdate }
    pbPlayDecisionSE
    @pokemon.play_cry
    pbBGMPlay("evolv")
    @sprites["msgwindow"].text = _INTL("{1} is evolving!", @pokemon.name)
    timer_start = System.uptime
    loop do
      Graphics.update
      Input.update
      pbUpdate
      break if System.uptime - timer_start >= 1
    end
    oldstate  = pbSaveSpriteState(@sprites["rsprite1"])
    oldstate2 = pbSaveSpriteState(@sprites["rsprite2"])
    canceled = false
    timer_start = System.uptime
    loop do
      pbUpdateNarrowScreen(timer_start)
      metaplayer1.update
      metaplayer2.update
      Graphics.update
      Input.update
      pbUpdate(true)
      if Input.trigger?(Input::BACK) && cancancel
        pbBGMStop
        pbPlayCancelSE
        canceled = true
        break
      end
      break unless metaplayer1.playing? && metaplayer2.playing?
    end
    pbFlashInOut(canceled, oldstate, oldstate2)
    if canceled
      $stats.evolutions_cancelled += 1
      pbMessageDisplay(@sprites["msgwindow"],
                       _INTL("Huh? {1} stopped evolving!", @pokemon.name)) { pbUpdate }
    else
      pbEvolutionSuccess
    end
  end

  def pbEvolutionSuccess
    # Play cry of evolved species
    frames = (GameData::Species.cry_length(@newspecies, @pokemon.form) * Graphics.frame_rate).ceil
    Pokemon.play_cry(@newspecies, @pokemon.form)
    (frames + 4).times do
      Graphics.update
      pbUpdate
    end
    # Success jingle/message
    newspeciesname = GameData::Species.get(@newspecies).name
    puts "potato"
    pbMessageDisplay(@sprites["msgwindow"],
                     _INTL("\\se[]Congratulations! Your {1} evolved into {2}!\\wt[80]",
                           @pokemon.name, newspeciesname)) { pbUpdate }
    @sprites["msgwindow"].text = ""
    pbBGMStop
    # Check for consumed item and check if Pokémon should be duplicated
	was_owned = $player.owned?(@newspecies)
    moves_to_learn = @pokemon.evolve_to(@new_species)
    # Show Pokédex entry for new species if it hasn't been owned before
    if Settings::SHOW_NEW_SPECIES_POKEDEX_ENTRY_MORE_OFTEN && !was_owned && $player.has_pokedex
      pbMessageDisplay(@sprites["msgwindow"],
                       _INTL("{1}'s data was added to the Pokédex.", newspeciesname)) { pbUpdate }
      $player.pokedex.register_last_seen(@pokemon)
      pbFadeOutIn {
        scene = PokemonPokedexInfo_Scene.new
        screen = PokemonPokedexInfoScreen.new(scene)
        screen.pbDexEntry(@pokemon.species)
        @sprites["msgwindow"].text = "" if moves_to_learn.length > 0
        pbEndScreen(false) if moves_to_learn.length == 0
      }
    end
    # Learn moves upon evolution for evolved species
    moves_to_learn.each do |move|
      pbLearnMove(@pokemon, move, true) { pbUpdate }
    end
  end

  def pbEvolutionMethodAfterEvolution
    @pokemon.action_after_evolution(@newspecies)
  end

  def self.pbDuplicatePokemon(pkmn, new_species)
    new_pkmn = pkmn.clone
    new_pkmn.species   = new_species
    new_pkmn.name      = nil
    new_pkmn.markings  = []
    new_pkmn.poke_ball = :POKEBALLC
    new_pkmn.item      = nil
    new_pkmn.clearAllRibbons
    new_pkmn.calc_stats
    new_pkmn.heal
    # Add duplicate Pokémon to party
    $player.party.push(new_pkmn)
    # See and own duplicate Pokémon
    $player.pokedex.register(new_pkmn)
    $player.pokedex.set_owned(new_species)
  end
end
