

EventHandlers.add(:on_new_spriteset_map, :add_light_effects,
  proc { |spriteset, viewport|
    map = spriteset.map   # Map associated with the spriteset (not necessarily the current map)
	pbCreateParticleEngine(viewport, map, spriteset)
    map.events.each_key do |i|
      if map.events[i].name[/^outdoorlight\((\d+),(\d+)\)/i]
        sizex = $~[1].to_i
        sizey = $~[2].to_i
        spriteset.addUserSprite(LightEffect_DayNight.new(map.events[i], viewport, map, sizex, sizey))
      elsif map.events[i].name[/^outdoorlight$/i]
        spriteset.addUserSprite(LightEffect_DayNight.new(map.events[i], viewport, map))
      elsif map.events[i].name[/^light\((\d+),(\d+)\)/i]
        sizex = $~[1].to_i
        sizey = $~[2].to_i
        spriteset.addUserSprite(LightEffect_Basic.new(map.events[i], viewport, map, sizex, sizey))
      elsif map.events[i].name[/^light$/i]
        spriteset.addUserSprite(LightEffect_Basic.new(map.events[i], viewport, map))
      elsif map.events[i].name[/^naturaltorch\((\d+),(\d+)\)/i]
        sizex = $~[1].to_i
        sizey = $~[2].to_i
        spriteset.addUserSprite(LightEffect_DayNight.new(map.events[i], viewport, map, sizex, sizey))
      elsif map.events[i].name[/^naturaltorch$/i]
        spriteset.addUserSprite(LightEffect_DayNight.new(map.events[i], viewport, map))
      elsif map.events[i].name[/^playertorch\((\d+),(\d+)\)/i]
        sizex = $~[1].to_i
        sizey = $~[2].to_i
        spriteset.addUserSprite(LightEffect_DayNight.new(map.events[i], viewport, map, sizex, sizey))
      elsif map.events[i].name[/^playertorch$/i]
        spriteset.addUserSprite(LightEffect_DayNight.new(map.events[i], viewport, map))
      elsif map.events[i].name[/^AncientStone\((\d+)\)/i]
        spriteset.addUserSprite(LightEffect_DayNight.new(map.events[i], viewport, map, 3, 3))
      elsif map.events[i].is_a?(Game_PokeEvent) && map.events[i].pokemon.types.include?(:FIRE)
        spriteset.addUserSprite(LightEffect_DayNight.new(map.events[i], viewport, map, 3, 3))
      elsif (map.events[i].is_a?(Game_PokeEvent) || map.events[i].is_a?(Game_PokeEventA) ) && map.events[i].pokemon.types.include?(:FIRE)
        spriteset.addUserSprite(LightEffect_DayNight.new(map.events[i], viewport, map, 3, 3))
	  elsif !map.events[i].currentcustomsprite.nil? && map.events[i].has_a_light[0]==true && !map.events[i].has_a_light[1].nil?
        sizex = map.events[i].has_a_light[1][0]
        sizey = map.events[i].has_a_light[1][1]
        spriteset.addUserSprite(LightEffect_DayNight.new(map.events[i], viewport, map, sizex, sizey))
      end

    end
  }
)


def pbCreateParticleEngine(viewport=Spriteset_Map.viewport,map=$game_map,spriteset=nil)
    return if !$scene.is_a?(Scene_Map)
 
    spriteset ||= $scene.spriteset(map.map_id)
    return if spriteset.nil?
    if $particle_engine.nil? || $particle_engine.disposed?
      $particle_engine = Particle_Engine.new(viewport, map)
    else
      $particle_engine.reset_for_map(map)
    end
    spriteset.addUserSprite($particle_engine)
end




def isaaparticle(event)
   return ["fire"] if event.name.include?("naturaltorch") 
   return ["fire"] if event.name.include?("playertorch")
   return nil
end




 # Particle Engine Type
#fire
 #Lighting Engine
#basic
 #
 #

def get_light_size(event)
  sizex = 1
  sizey = 1
      if event.name[/^outdoorlight\((\d+),(\d+)\)/i]
        sizex = $~[1].to_i
        sizey = $~[2].to_i
      elsif event.name[/^light\((\d+),(\d+)\)/i]
        sizex = $~[1].to_i
        sizey = $~[2].to_i
      elsif event.name[/^naturaltorch\((\d+),(\d+)\)/i]
        sizex = $~[1].to_i
        sizey = $~[2].to_i
      elsif event.name[/^playertorch\((\d+),(\d+)\)/i]
        sizex = $~[1].to_i
        sizey = $~[2].to_i
      elsif event.name[/^AncientStone\((\d+)\)/i]
        sizex = 3
        sizey = 3
      elsif (event.is_a?(Game_PokeEvent) || event.is_a?(Game_PokeEventA) ) && event.pokemon.types.include?(:FIRE)
        sizex = 3
        sizey = 3
      end

	    return sizex,sizey
end

def activatetorch(sizex=nil,sizey=nil)
pbAddLightEffecttoEvent(sizex,sizey)
pbAddParticleEffecttoEvent()


end

def pausetorch(event=nil)
if event.nil?
  interp = pbMapInterpreter
  event = interp.get_self
end
  event.pe_pause=true
end

def resumetorch(event=nil)
if event.nil?
  interp = pbMapInterpreter
  event = interp.get_self
end
  event.pe_pause=false
end

def deactivatetorch
pbRemoveLightEffectfromEvent
pbRemoveParticleEffectfromEvent
end

def pbAddParticleEffecttoEvent(type="fire",event=nil)
  if event.nil?
  interp = pbMapInterpreter
  event = interp.get_self
  end
  return if event.nil?
  return if !$scene
  return if !$scene.spriteset
  return if !$particle_engine
  puts "adding #{type} to #{event.name}"
  $particle_engine.add_effect(event,nil,type)
end

def pbRemoveParticleEffectfromEvent(event=nil)
  if event.nil?
  interp = pbMapInterpreter
  event = interp.get_self
  end
  return if !$scene
  return if !$scene.spriteset
  return if !$particle_engine
  $particle_engine.remove_effect(event)
end

def pbAddLightEffecttoThisEvent(event,sizex=nil,sizey=nil)
  return if !$scene
  return if !$scene.spriteset
  return if !Spriteset_Map.viewport
  return if !event.currentcustomsprite.nil?
  spriteset = $scene.spriteset($game_map.map_id)
  sizex,sizey = get_light_size(event) if (sizex.nil? || sizey.nil?)
  index = spriteset.addUserSprite(LightEffect_DayNight.new(event, Spriteset_Map.viewport, $game_map, sizex, sizey))
  
  event.currentcustomsprite = index
  event.has_a_light=[true,[sizex,sizey]]
end
def pbRemoveLightEffectfromThisEvent(event)
  return if !$scene
  return if !$scene.spriteset
  event.has_a_light=[false,[1,1]]
  custom = event.currentcustomsprite
  event.currentcustomsprite=nil
  return if custom.nil?
  spriteset = $scene.spriteset($game_map.map_id)
  sprite = spriteset.usersprites[custom]
  return if sprite.nil?
  return if (!sprite.is_a?(LightEffect_DayNight) || (sprite.is_a?(LightEffect_DayNight) && sprite.event != event))
  sprite.dispose
  spriteset.removeUserSprite2(sprite)



end
def pbAddLightEffecttoEvent(sizex=nil,sizey=nil)
  return if !$scene
  return if !$scene.spriteset
  return if !Spriteset_Map.viewport
  interp = pbMapInterpreter
  event = interp.get_self
  return if !event.currentcustomsprite.nil?
  spriteset = $scene.spriteset($game_map.map_id)
  sizex,sizey = get_light_size(event) if (sizex.nil? || sizey.nil?)
  index = spriteset.addUserSprite(LightEffect_DayNight.new(event, Spriteset_Map.viewport, $game_map, sizex, sizey))
  
  event.currentcustomsprite = index
  event.has_a_light=[true,[sizex,sizey]]
end

def pbRemoveLightEffectfromEvent
  interp = pbMapInterpreter
  event = interp.get_self
  return if !$scene
  return if !$scene.spriteset
  return if event.currentcustomsprite.nil?
  spriteset = $scene.spriteset($game_map.map_id)
  spriteset.usersprites[event.currentcustomsprite].dispose
  spriteset.removeUserSprite2(spriteset.usersprites[custom])
  event.has_a_light=[false,[1,1]]
  event.currentcustomsprite=nil



end

class Spriteset_Map
  attr_reader :character_sprites
  attr_reader :usersprites
  def addUserSprite(new_sprite)
    @usersprites.each_with_index do |sprite, i|
      next if sprite && !sprite.disposed?
      @usersprites[i] = new_sprite
      return i
    end
    @usersprites.push(new_sprite)
	return @usersprites.index(new_sprite)
  end

  def getUserSprite(new_sprite)
  
  end 
  def removeUserSprite(index)
    @usersprites.delete_at(index)
  end
  def removeUserSprite2(sprite)
   return unless sprite
   sprite.dispose unless sprite.disposed?
   @usersprites.delete(sprite)
  end

end
class Particle_Engine
  attr_accessor :firsttime
  LEGACY_PARTICLE_SCALE = 60
  def initialize(viewport = nil, map = nil)
   # puts "Particle Engine #{object_id} initialized"
    @map       = (map) ? map : $game_map
    @viewport  = viewport
    @effect    = {}
    @disposed  = false
    @lastRefreshFrame = Graphics.frame_count
    @firsttime = true
    @effects   = {
      # PinkMan's Effects
      "fire"         => Particle_Engine::Fire,
      "smoke"        => Particle_Engine::Smoke,
      "teleport"     => Particle_Engine::Teleport,
      "spirit"       => Particle_Engine::Spirit,
      "explosion"    => Particle_Engine::Explosion,
      "aura"         => Particle_Engine::Aura,
      # BlueScope's Effects
      "soot"         => Particle_Engine::Soot,
      "sootsmoke"    => Particle_Engine::SootSmoke,
      "rocket"       => Particle_Engine::Rocket,
      "fixteleport"  => Particle_Engine::FixedTeleport,
      "smokescreen"  => Particle_Engine::Smokescreen,
      "flare"        => Particle_Engine::Flare,
      "splash"       => Particle_Engine::Splash,
      # By Peter O.
      "starteleport" => Particle_Engine::StarTeleport,
	  # By systeromen_
      "combat_projectile"         => Particle_Engine::CombatProjectile,
	  "cone_projectile"         => Particle_Engine::Cone,
	  "beam_projectile"         => Particle_Engine::Beam,
	  "cone"         => Particle_Engine::Cone
    }
  end
  
  def reset
    dispose
  end
 def reset_for_map(map)
  @map = map
  @firsttime = true
end 
  def remove_particles
    @effect.each_value do |particle|
      next if particle.nil?
      particle.dispose
    end
  
  
  end
  
  def dispose
    return if disposed?
    return if !$scene.is_a?(Scene_Map)
    @disposed = true
    @effect.each_value do |particle|
      next if particle.nil?
      particle.dispose
    end
    @effect.clear
    #@firsttime = true
	#puts "Particle Engine #{object_id} disposed"
    spriteset ||= $scene.spriteset(@map.map_id)
    spriteset.removeUserSprite2($particle_engine) if spriteset
    @map = nil
	$particle_engine = nil if defined?($particle_engine) && $particle_engine == self
  end

  def disposed?
    return @disposed
  end

  def add_effect(event, particle=nil, type = nil)
    return if event.id.nil?
    event.has_a_particle=[true,type]
    @effect[event.id] = pbParticleEffect(event, particle, type)
  end

  def remove_effect(event)
    return if event.id.nil?
    return if @effect[event.id].nil?
    event.has_a_particle=[false,nil]
    @effect[event.id].dispose
    @effect.delete(event.id)
  end
  
  def realloc_effect(event, particle = nil, type = nil)
    type = pbShouldShowThisParticle(event, 1, "Particle Engine Type") if type.nil?
	type = isaaparticle(event) if type.nil?
    if type.nil?
      particle&.dispose
      return nil
    end
    type = type[0] if type.is_a? Array
    type = type.downcase
    cls = @effects[type]
    if cls.nil?
      particle&.dispose
      return nil
    end
    if !particle || !particle.is_a?(cls)
      particle&.dispose
      particle = cls.new(event, @viewport)
    end
    return particle
  end


  def pbParticleEffect(event, particle = nil, type = nil)
    return realloc_effect(event, particle, type)
  end

  def update
    return if @disposed
    if @firsttime
      @firsttime = false
	  @map = $game_map if !@map
	  events = @map.events.values + $DynamicEvents.events_for_map + [$game_player]
      events.each do |event|
	   next if event.nil?
	   next if !event.has_particle? 
	   next if !event.should_have_particle?
       remove_effect(event)
       add_effect(event)
      
	  end
    end
    @effect.each do |id, particle|
      next if particle.nil?
	  
	   particle.event.pe_pause=false if particle.event.pe_pause.nil?
      if particle.event.pe_refresh
        event = particle.event
        event.pe_refresh = false
        particle = realloc_effect(event, particle)
        @effect[id] = particle
      end
      particle&.update
    end
  end
  def clear
    @effect.each_value(&:dispose)
    @effect.clear
  end

  def showHUD?
    return (
      $player && $scene.is_a?(Scene_Map)
    )
  end

  def tryUpdate
      return if @lastRefreshFrame == Graphics.frame_count
	  @lastRefreshFrame = Graphics.frame_count
      update if @lastRefreshFrame != Graphics.frame_count
  end

  def hasSprites?
    return !@effect.empty?
  end
  
end


class ParticleSprite
  attr_accessor :x, :y, :z, :ox, :oy, :opacity, :blend_type, :dead
  attr_reader :bitmap

  def initialize(viewport)
    @viewport   = viewport
    @sprite     = nil
    @x          = 0
    @y          = 0
    @z          = 0
    @ox         = 0
    @oy         = 0
    @opacity    = 255
    @bitmap     = nil
    @blend_type = 0
    @minleft    = 0
    @mintop     = 0
	@dead       = false 
  end

  def dispose
    @sprite&.dispose
  end

  def bitmap=(value)
    @bitmap = value
    if value
      @minleft = -value.width
      @mintop  = -value.height
    else
      @minleft = 0
      @mintop  = 0
    end
  end

  def visible=(value)
    return if @sprite.nil?
    @sprite.visible=value
  end
  
  
  def update
    w = Graphics.width
    h = Graphics.height
    if !@sprite && @x >= @minleft && @y >= @mintop && @x < w && @y < h
      @sprite = Sprite.new(@viewport)
    elsif @sprite && (@x < @minleft || @y < @mintop || @x >= w || @y >= h)
      @sprite.dispose
      @sprite = nil
    end
    if @sprite
      @sprite.x          = @x if @sprite.x != @x
      @sprite.x          -= @ox
      @sprite.y          = @y if @sprite.y != @y
      @sprite.y          -= @oy
      @sprite.z          = @z if @sprite.z != @z
      @sprite.opacity    = @opacity if @sprite.opacity != @opacity
      @sprite.blend_type = @blend_type if @sprite.blend_type != @blend_type
      @sprite.bitmap     = @bitmap if @sprite.bitmap != @bitmap
    end
  end




end

class ParticleEffect
  attr_accessor :x, :y, :z

  def initialize
    @x = 0
    @y = 0
    @z = 0
  end

  def update;  end
  def dispose; end
end


class ParticleEffect_Event < ParticleEffect
  attr_accessor :event
  attr_accessor :visible
  attr_accessor :complete 
  
  def initialize(event, viewport = nil)
    @event     = event
    @viewport  = viewport
	@time_last_updated = Graphics.frame_count.to_i
    @particles = []
    @lastRefreshFrame = Graphics.frame_count
    @visible = true
	@complete = false 
    @bitmaps   = {}
  end
def finished?
  @particles.all?(&:dead)
end

  def showHUD?
    return (
      $player && $scene.is_a?(Scene_Map)
    )
  end

  def tryUpdate
    if showHUD?
      update if @lastRefreshFrame != Graphics.frame_count
    else
      dispose if hasSprites?
    end
  end

  def hasSprites?
    return !@particles.empty?
  end



  def setParameters(params = {})
    @randomhue        = params[:randomhue]        || 0
    @leftright        = params[:leftright]        || 0
    @fade             = params[:fade]             || 0
    @maxparticless    = params[:maxparticles]     || 20
    @hue              = params[:hue]              || 0
    @slowdown         = params[:slowdown]         || 1
    @ytop             = params[:ytop]             || -64
    @ybottom          = params[:ybottom]          || Graphics.height
    @xleft            = params[:xleft]            || -64
    @xright           = params[:xright]           || Graphics.width
    @xgravity         = params[:xgravity]         || 0
    @ygravity         = params[:ygravity]         || 0
    @xoffset          = params[:xoffset]          || 0
    @yoffset          = params[:yoffset]          || 0
    @opacityvar       = params[:opacityvar]       || 0
    @originalopacity  = params[:originalopacity]  || 255
	#@xoffset +=$PokemonSystem.screenposx
	#@yoffset +=$PokemonSystem.screenposy
  end

  def loadBitmap(filename, hue)
    key = [filename, hue]
    bitmap = @bitmaps[key]
    if !bitmap || bitmap.disposed?
      bitmap = AnimatedBitmap.new("Graphics/Fogs/" + filename, hue).deanimate
      @bitmaps[key] = bitmap
    end
    return bitmap
  end

  def initParticles(filename, opacity, zOffset = 0, blendtype = 1)
    @particles = []
    @particlex = []
    @particley = []
    @opacity   = []
    @startingx = self.x + @xoffset
    @startingy = self.y + @yoffset
    @screen_x  = self.x
    @screen_y  = self.y
    @real_x    = @event.real_x
    @real_y    = @event.real_y
	#puts "INIT #{@event.id}: #{@event.real_x}, #{@event.real_y}"
    @filename  = filename
    @zoffset   = zOffset
    @bmwidth   = 32
    @bmheight  = 32
    @maxparticless.times do |i|
      @particlex[i] = -@xoffset
      @particley[i] = -@yoffset
      @particles[i] = ParticleSprite.new(@viewport)
      @particles[i].bitmap = loadBitmap(filename, @hue) if filename
      if i == 0 && @particles[i].bitmap
        @bmwidth  = @particles[i].bitmap.width
        @bmheight = @particles[i].bitmap.height
      end
      @particles[i].blend_type = blendtype
      @particles[i].y = @startingy
      @particles[i].x = @startingx
      @particles[i].z = self.z + zOffset
      @opacity[i] = rand(opacity / 4)
      @particles[i].opacity = @opacity[i]
      @particles[i].update
    end
  end

  def x; return ScreenPosHelper.pbScreenX(@event); end
  def y; return ScreenPosHelper.pbScreenY(@event); end
  def z; return ScreenPosHelper.pbScreenZ(@event); end
  
  
  def update
    if @viewport &&
       (@viewport.rect.x >= Graphics.width ||
       @viewport.rect.y >= Graphics.height)
	#  puts "SKIPPED VIEWPORT"
      return
    end
	 time_now = Graphics.frame_count
    time_delta = time_now.to_i - @time_last_updated
    return if time_delta <= 0
	 @time_last_updated = time_now.to_i
    #delta_t = Graphics.delta
    selfX = self.x
    selfY = self.y
    selfZ = self.z
    newRealX = @event.real_x
    newRealY = @event.real_y
    @startingx = selfX + @xoffset
    @startingy = selfY + @yoffset
    @__offsetx = (@real_x == newRealX) ? 0 : selfX - @screen_x
    @__offsety = (@real_y == newRealY) ? 0 : selfY - @screen_y
    @screen_x = selfX
    @screen_y = selfY
    @real_x = newRealX
    @real_y = newRealY
    if @opacityvar > 0 && @viewport
      opac = 255.0 / @opacityvar
      minX = (opac * (-@xgravity.to_f / @slowdown).floor) + @startingx
      maxX = (opac * (@xgravity.to_f / @slowdown).floor) + @startingx
      minY = (opac * (-@ygravity.to_f / @slowdown).floor) + @startingy
      maxY = @startingy
      minX -= @bmwidth
      minY -= @bmheight
      maxX += @bmwidth
      maxY += @bmheight
	  
     offscreen =  maxX < 0 || maxY < 0 || minX >= Graphics.width || minY >= Graphics.height
#        echo "skipped"
 #       return
    end
    particleZ = selfZ + @zoffset
    @maxparticless.times do |i|
	    next if @particles[i].nil?
		if offscreen
		  @particles[i].visible = false
		  next
		else
	     @particles[i].visible=!@event.pe_pause
		end 
      @particles[i].z = particleZ
      if @particles[i].y <= @ytop
        @particles[i].y = @startingy + @yoffset
        @particles[i].x = @startingx + @xoffset
        @particlex[i] = 0.0
        @particley[i] = 0.0
      end
      if @particles[i].x <= @xleft
        @particles[i].y = @startingy + @yoffset
        @particles[i].x = @startingx + @xoffset
        @particlex[i] = 0.0
        @particley[i] = 0.0
      end
      if @particles[i].y >= @ybottom
        @particles[i].y = @startingy + @yoffset
        @particles[i].x = @startingx + @xoffset
        @particlex[i] = 0.0
        @particley[i] = 0.0
      end
      if @particles[i].x >= @xright
        @particles[i].y = @startingy + @yoffset
        @particles[i].x = @startingx + @xoffset
        @particlex[i] = 0.0
        @particley[i] = 0.0
      end
      if @fade == 0
        if @opacity[i] <= 0
          @opacity[i] = @originalopacity
          @particles[i].y = @startingy + @yoffset
          @particles[i].x = @startingx + @xoffset
          @particlex[i] = 0.0
          @particley[i] = 0.0
        end
      elsif @opacity[i] <= 0
        @opacity[i] = 250
        @particles[i].y = @startingy + @yoffset
        @particles[i].x = @startingx + @xoffset
        @particlex[i] = 0.0
        @particley[i] = 0.0
      end

      calcParticlePos(i)
      if @randomhue == 1
        @hue += 0.5
        @hue = 0 if @hue >= 360
        @particles[i].bitmap = loadBitmap(@filename, @hue) if @filename
      end
      @opacity[i] = @opacity[i] - rand(@opacityvar)
      @particles[i].opacity = @opacity[i]
      @particles[i].update
    end
  end

  def calcParticlePos(i)
    @leftright = rand(2)
    if @leftright == 1
      xo = -@xgravity.to_f / @slowdown
    else
      xo = @xgravity.to_f / @slowdown
    end
    yo = -@ygravity.to_f / @slowdown
    @particlex[i] += xo
    @particley[i] += yo
    @particlex[i] -= @__offsetx
    @particley[i] -= @__offsety
    @particlex[i] = @particlex[i].floor
    @particley[i] = @particley[i].floor
    @particles[i].x = @particlex[i] + @startingx + @xoffset
    @particles[i].y = @particley[i] + @startingy + @yoffset
  end

  def dispose
    @particles.each do |particle|
      particle.dispose
    end
    @bitmaps.each_value do |bitmap|
      bitmap.dispose
    end
    @particles.clear
    @bitmaps.clear
  end

end



class Particle_Engine::Fire < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters(
  randomhue: 0,
  leftright: 0,
  fade: 1,
  maxparticles: 20,
  hue: 0,
  slowdown: 0.5,
  ytop: -64,
  ybottom: Graphics.height,
  xleft: -64,
  xright: Graphics.width,
  xgravity: 0.5,
  ygravity: 0.10,
  xoffset: -5,
  yoffset: -13,
  opacityvar: 30,
  originalopacity: 0
)
    initParticles("particle", 250)
  end
end
class Particle_Engine::CombatProjectile < ParticleEffect_Event
  def initialize(event, viewport)
    super
	type = "particle"
    if event.respond_to?(:data) && event.data.is_a?(Pokemon::Move)
      type = case event.data.type
	    when :FIRE then "particle"
	    when :WATER then "particle_water"
		else 
		 "smoke"
	  end
    end
    setParameters(
  randomhue: 0,
  leftright: 0,
  fade: 1,
  maxparticles: 20,
  hue: 0,
  slowdown: 0.5,
  ytop: -64,
  ybottom: Graphics.height,
  xleft: -64,
  xright: Graphics.width,
  xgravity: 0.5,
  ygravity: 0.10,
  xoffset: -5,
  yoffset: -13,
  opacityvar: 30,
  originalopacity: 0
)
  
    initParticles(type, 250)
  end
end






class Particle_Engine::Smoke < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters(
  randomhue: 0,
  leftright: 0,
  fade: 0,
  maxparticles: 80,
  hue: 20,
  slowdown: 0.5,
  ytop: -64,
  ybottom: Graphics.height,
  xleft: -64,
  xright: Graphics.width,
  xgravity: 0.5,
  ygravity: 0.10,
  xoffset: -5,
  yoffset: -15,
  opacityvar: 5,
  originalopacity: 80
)
    initParticles("smoke", 250)
  end
end



class Particle_Engine::Teleport < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters(
  randomhue: 1,
  leftright: 1,
  fade: 1,
  maxparticles: 10,
  hue: rand(360),
  slowdown: 1,
  ytop: -64,
  ybottom: Graphics.height,
  xleft: -64,
  xright: Graphics.width,
  xgravity: 0,
  ygravity: 3,
  xoffset: -8,
  yoffset: -15,
  opacityvar: 20,
  originalopacity: 0
)
    initParticles("wideportal", 250)
    @maxparticless.times do |i|
      @particles[i].ox = 16
      @particles[i].oy = 16
    end
  end
end



class Particle_Engine::Spirit < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters(
  randomhue: 1,
  leftright: 0,
  fade: 1,
  maxparticles: 20,
  hue: rand(360),
  slowdown: 0.5,
  ytop: -64,
  ybottom: Graphics.height,
  xleft: -64,
  xright: Graphics.width,
  xgravity: 0.5,
  ygravity: 0.10,
  xoffset: -5,
  yoffset: -13,
  opacityvar: 30,
  originalopacity: 0
)
    initParticles("particle", 250)
  end
end



class Particle_Engine::Explosion < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters(
  randomhue: 0,
  leftright: 0,
  fade: 1,
  maxparticles: 20,
  hue: 0,
  slowdown: 0.5,
  ytop: -64,
  ybottom: Graphics.height,
  xleft: -64,
  xright: Graphics.width,
  xgravity: 0.5,
  ygravity: 0.10,
  xoffset: -5,
  yoffset: -13,
  opacityvar: 30,
  originalopacity: 0
)
    initParticles("explosion", 250)
  end
end



class Particle_Engine::Aura < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters(
  randomhue: 0,
  leftright: 0,
  fade: 1,
  maxparticles: 20,
  hue: 0,
  slowdown: 1,
  ytop: -64,
  ybottom: Graphics.height,
  xleft: -64,
  xright: Graphics.width,
  xgravity: 2,
  ygravity: 2,
  xoffset: -5,
  yoffset: -13,
  opacityvar: 30,
  originalopacity: 0
)
    initParticles("particle", 250)
  end
end



class Particle_Engine::Soot < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters(
  randomhue: 0,
  leftright: 0,
  fade: 0,
  maxparticles: 20,
  hue: 0,
  slowdown: 0.5,
  ytop: -64,
  ybottom: Graphics.height,
  xleft: -64,
  xright: Graphics.width,
  xgravity: 0.5,
  ygravity: 0.10,
  xoffset: -5,
  yoffset: -15,
  opacityvar: 5,
  originalopacity: 80
)
    initParticles("smoke", 100, 0, 2)
  end
end



class Particle_Engine::SootSmoke < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters(
  randomhue: 0,
  leftright: 0,
  fade: 0,
  maxparticles: 30,
  hue: 0,
  slowdown: 0.5,
  ytop: -64,
  ybottom: Graphics.height,
  xleft: -64,
  xright: Graphics.width,
  xgravity: 0.5,
  ygravity: 0.10,
  xoffset: -5,
  yoffset: -15,
  opacityvar: 5,
  originalopacity: 80
)
    initParticles("smoke", 100, 0)
    @maxparticless.times do |i|
      @particles[i].blend_type = rand(6) < 3 ? 1 : 2
    end
  end
end



class Particle_Engine::Rocket < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters(
  randomhue: 0,
  leftright: 0,
  fade: 0,
  maxparticles: 60,
  hue: 0,
  slowdown: 0.5,
  ytop: -64,
  ybottom: Graphics.height,
  xleft: -64,
  xright: Graphics.width,
  xgravity: 0.5,
  ygravity: 0,
  xoffset: -5,
  yoffset: -15,
  opacityvar: 5,
  originalopacity: 80
)
    initParticles("smoke", 100, -1)
  end
end



class Particle_Engine::FixedTeleport < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters(
  randomhue: 1,
  leftright: 0,
  fade: 1,
  maxparticles: 10,
  hue: rand(360),
  slowdown: 1,
  ytop: -Graphics.height,
  ybottom: Graphics.height,
  xleft: 0,
  xright: Graphics.width,
  xgravity: 0,
  ygravity: 3,
  xoffset: -8,
  yoffset: -15,
  opacityvar: 20,
  originalopacity: 0
)
    initParticles("wideportal", 250)
    @maxparticless.times do |i|
      @particles[i].ox = 16
      @particles[i].oy = 16
    end
  end
end



# By Peter O.
class Particle_Engine::StarTeleport < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters(
  randomhue: 0,
  leftright: 0,
  fade: 1,
  maxparticles: 10,
  hue: 0,
  slowdown: 1,
  ytop: -Graphics.height,
  ybottom: Graphics.height,
  xleft: 0,
  xright: Graphics.width,
  xgravity: 0,
  ygravity: 3,
  xoffset: -8,
  yoffset: -15,
  opacityvar: 10,
  originalopacity: 0
)
    initParticles("star", 250)
    @maxparticless.times do |i|
      @particles[i].ox = 48
      @particles[i].oy = 48
    end
  end
end



class Particle_Engine::Smokescreen < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters(
  randomhue: 0,
  leftright: 0,
  fade: 0,
  maxparticles: 250,
  hue: 0,
  slowdown: 0.2,
  ytop: -64,
  ybottom: Graphics.height,
  xleft: -64,
  xright: Graphics.width,
  xgravity: 0.8,
  ygravity: 0.8,
  xoffset: -5,
  yoffset: -15,
  opacityvar: 5,
  originalopacity: 80
)
    initParticles(nil, 100)
    @maxparticless.times do |i|
      rnd = rand(3)
      @opacity[i] = (rnd == 0) ? 1 : 100
      filename = (rnd == 0) ? "explosionsmoke" : "smoke"
      @particles[i].bitmap = loadBitmap(filename, @hue)
    end
  end

  def calcParticlePos(i)
    if @randomhue == 1
      filename = (rand(3) == 0) ? "explosionsmoke" : "smoke"
      @particles[i].bitmap = loadBitmap(filename, @hue)
    end
    multiple = 1.7
    xgrav = @xgravity * multiple / @slowdown
    xgrav = -xgrav if rand(2) == 1
    ygrav = @ygravity * multiple / @slowdown
    ygrav = -ygrav if rand(2) == 1
    @particlex[i] += xgrav
    @particley[i] += ygrav
    @particlex[i] -= @__offsetx
    @particley[i] -= @__offsety
    @particlex[i] = @particlex[i].floor
    @particley[i] = @particley[i].floor
    @particles[i].x = @particlex[i] + @startingx + @xoffset
    @particles[i].y = @particley[i] + @startingy + @yoffset
  end
end



class Particle_Engine::Flare < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters(
  randomhue: 0,
  leftright: 0,
  fade: 1,
  maxparticles: 30,
  hue: 10,
  slowdown: 1,
  ytop: -64,
  ybottom: Graphics.height,
  xleft: -64,
  xright: Graphics.width,
  xgravity: 2,
  ygravity: 2,
  xoffset: -5,
  yoffset: -12,
  opacityvar: 30,
  originalopacity: 0
)
    initParticles("particle", 255)
  end
end



class Particle_Engine::Splash < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters(
  randomhue: 0,
  leftright: 0,
  fade: 1,
  maxparticles: 30,
  hue: 255,
  slowdown: 1,
  ytop: -64,
  ybottom: Graphics.height,
  xleft: -64,
  xright: Graphics.width,
  xgravity: 4,
  ygravity: 2,
  xoffset: -5,
  yoffset: -12,
  opacityvar: 30,
  originalopacity: 0
)
    initParticles("smoke", 50)
  end

  def update
    super
    @maxparticless.times do |i|
	  next if @particles[i].nil?
      @particles[i].opacity = 50
      @particles[i].update
    end
  end
end

class Particle_Engine::Cone < ParticleEffect_Event
  def initialize(event, viewport)
    super
	particle_range = 5 
    if event.respond_to?(:data) && event.data.is_a?(Pokemon::Move)
      particle_range = event.data.overworld_range || 5
    end
    @max_distance = particle_range * 32
    setParameters(
  randomhue: 0,
  leftright: 0,
  fade: 0,
  maxparticles: 40,
  hue: 0,
  slowdown: 1,
  ytop: -64,
  ybottom: Graphics.height,
  xleft: -64,
  xright: Graphics.width,
  xgravity: 0,
  ygravity: 0,
  xoffset: 0,
  yoffset: 0,
  opacityvar: 0,
  originalopacity: 255
)

    initParticles("particle", 250)
  end


def calcParticlePos(i)
  spread = 16

  if @particlex[i] == 0
    @particlex[i] = 0#rand(1..5) * 32
    @particley[i] = rand(-spread..spread)
  end

  distance = @particlex[i]
  offset = rand(-distance / 2..distance / 2)

  base_angle = case @event.direction
  when 2 then 90
  when 4 then 180
  when 6 then 0
  when 8 then 270
  end

  radians = base_angle * Math::PI / 180

  x = Math.cos(radians) * distance
  y = Math.sin(radians) * distance

  side_angle = (base_angle + 90) * Math::PI / 180

  x += Math.cos(side_angle) * offset
  y += Math.sin(side_angle) * offset

  @particles[i].x = @startingx + x
  @particles[i].y = @startingy + y

  @particlex[i] += 4
  if @particlex[i] > @max_distance
    @opacity[i] = 0
	
  end
end

def cone_offset
  case @event.direction
  when 2 # down
    [-10, -8]
  when 4 # left
    [-12, -24]
  when 6 # right
    [12, -16]
  when 8 # up
    [-10, -40]
  end
end
  def update
    return if @complete
    if @viewport &&
       (@viewport.rect.x >= Graphics.width ||
       @viewport.rect.y >= Graphics.height)
      return
    end
	 time_now = Graphics.frame_count
    time_delta = time_now.to_i - @time_last_updated
    return if time_delta <= 0
	 @time_last_updated = time_now.to_i
    #delta_t = Graphics.delta
    selfX = self.x
    selfY = self.y
    selfZ = self.z
    newRealX = @event.real_x
    newRealY = @event.real_y
	offset_x, offset_y = cone_offset
    @startingx = selfX + @xoffset + offset_x
    @startingy = selfY + @yoffset + offset_y
    @__offsetx = (@real_x == newRealX) ? 0 : selfX - @screen_x
    @__offsety = (@real_y == newRealY) ? 0 : selfY - @screen_y
    @screen_x = selfX
    @screen_y = selfY
    @real_x = newRealX
    @real_y = newRealY
    if @opacityvar > 0 && @viewport
      opac = 255.0 / @opacityvar
      minX = (opac * (-@xgravity.to_f / @slowdown).floor) + @startingx
      maxX = (opac * (@xgravity.to_f / @slowdown).floor) + @startingx
      minY = (opac * (-@ygravity.to_f / @slowdown).floor) + @startingy
      maxY = @startingy
      minX -= @bmwidth
      minY -= @bmheight
      maxX += @bmwidth
      maxY += @bmheight
	  
      if maxX < 0 || maxY < 0 || minX >= Graphics.width || minY >= Graphics.height
#        echo "skipped"
        return
      end
    end
    particleZ = selfZ + @zoffset
    @maxparticless.times do |i|
	    
	    next if @particles[i].nil?
		next if @particles[i].dead
		if @particlex[i] >= @max_distance
          @particles[i].dead = true
          @particles[i].visible = false
           next
        end
      @particles[i].z = particleZ
      if @particles[i].y <= @ytop
        @particles[i].y = @startingy + @yoffset
        @particles[i].x = @startingx + @xoffset
        @particlex[i] = 0.0
        @particley[i] = 0.0
      end
      if @particles[i].x <= @xleft
        @particles[i].y = @startingy + @yoffset
        @particles[i].x = @startingx + @xoffset
        @particlex[i] = 0.0
        @particley[i] = 0.0
      end
      if @particles[i].y >= @ybottom
        @particles[i].y = @startingy + @yoffset
        @particles[i].x = @startingx + @xoffset
        @particlex[i] = 0.0
        @particley[i] = 0.0
      end
      if @particles[i].x >= @xright
        @particles[i].y = @startingy + @yoffset
        @particles[i].x = @startingx + @xoffset
        @particlex[i] = 0.0
        @particley[i] = 0.0
      end
      if @fade == 0
        if @opacity[i] <= 0
          @opacity[i] = @originalopacity
          @particles[i].y = @startingy + @yoffset
          @particles[i].x = @startingx + @xoffset
          @particlex[i] = 0.0
          @particley[i] = 0.0
        end
      elsif @opacity[i] <= 0
        @opacity[i] = 255
      end
      calcParticlePos(i)
      if @randomhue == 1
        @hue += 0.5
        @hue = 0 if @hue >= 360
        @particles[i].bitmap = loadBitmap(@filename, @hue) if @filename
      end
      @opacity[i] = @opacity[i] - rand(@opacityvar)
      @particles[i].opacity = @opacity[i]
      @particles[i].update
    end
    
    @complete = finished?
  end

end

class Particle_Engine::Beam < ParticleEffect_Event
  attr_reader :complete

  def initialize(event, viewport)
    super

    @complete = false

    @range = 5
    @duration = 60
    if event.respond_to?(:data) && event.data.is_a?(Pokemon::Move)
      @range = event.data.overworld_range
      @duration = event.data.beam_time
    end

    @current_length = 0
	@last_length = @current_length
    @speed = 8
	
    @max_length = @range * 32
    @beam_width = 3

    setParameters(
      randomhue: 0,
      leftright: 0,
      fade: 0,
      maxparticles: 120,
      hue: 0,
      slowdown: 1,
      ytop: -64,
      ybottom: Graphics.height,
      xleft: -64,
      xright: Graphics.width,
      xgravity: 0,
      ygravity: 0,
      xoffset: 0,
      yoffset: 0,
      opacityvar: 0,
      originalopacity: 255
    )

    initParticles("particle", 250)

    @particle_distance = Array.new(@maxparticless, 0)
    @particle_offset = Array.new(@maxparticless, 0)
    @particle_initialized = Array.new(@maxparticless, false)
	
    @angle = case @event.direction
    when 2 then 90
    when 4 then 180
    when 6 then 0
    when 8 then 270
    end

    @radians = @angle * Math::PI / 180
    @side_radians = (@angle + 90) * Math::PI / 180
  end
def cone_offset
  case @event.direction
  when 2 # down
    [-10, -8]
  when 4 # left
    [-12, -24]
  when 6 # right
    [12, -24]
  when 8 # up
    [-10, -40]
  end
end


  def resetParticle(i)
    @particle_distance[i] = rand(0..[@current_length, 1].max)
    @particle_offset[i] = rand(-@beam_width..@beam_width)
    @particle_initialized[i] = true
    @opacity[i] = rand(180..255)
  end


  def calcParticlePos(i)
    resetParticle(i) unless @particle_initialized[i]

    distance = @particle_distance[i]
    offset = @particle_offset[i]

    x = Math.cos(@radians) * distance
    y = Math.sin(@radians) * distance

    x += Math.cos(@side_radians) * offset
    y += Math.sin(@side_radians) * offset

	offset_x, offset_y = cone_offset
    @particles[i].x = @startingx + x + offset_x
    @particles[i].y = @startingy + y + offset_y

    # subtle energy movement
    @particle_distance[i] += rand(-1..1)
    @particle_distance[i] += rand(0..2)
	
    if @particle_distance[i] < 0
      @particle_distance[i] = @current_length
    elsif @particle_distance[i] > @current_length
      @particle_distance[i] = rand(0..@current_length)
    end
  end


  def update
    return if @complete
	
    @current_length += @speed
    @current_length = @max_length if @current_length > @max_length
	
    if @current_length > @last_length
      growth = @current_length - @last_length
      new_particles = 5

      @particle_initialized.each_with_index do |initialized, i|
       next unless initialized

    # chance to populate newly created space
       if rand < 0.05
        @particle_distance[i] = rand(@last_length..@current_length)
        @particle_offset[i] = rand(-@beam_width..@beam_width)
       end
     end
      @last_length = @current_length
    end
	
	
	
    selfX = self.x
    selfY = self.y

    @startingx = selfX + @xoffset
    @startingy = selfY + @yoffset

    particleZ = self.z + @zoffset

    @maxparticless.times do |i|
      next if @particles[i].nil?

      @particles[i].z = particleZ

      calcParticlePos(i)

      @particles[i].opacity = @opacity[i]
      @particles[i].update
    end

    @duration -= 1

    if @duration <= 0
      @complete = true
      @particles.each do |particle|
        particle.opacity = 0
        particle.visible = false
      end
    end
  end


end



def pbShouldShowThisParticle(*args)
  parameters = []
  event = args[0]
  list = *args[0].list # Event or event page
  elements = *args[1] # Number of elements
  trigger = *args[2] # Trigger
  elements = elements[0] if elements.is_a?(Array)
  trigger = trigger[0] if trigger.is_a?(Array)
  return event.has_a_particle[1] if event.has_a_particle[0]==true
  return nil if list == nil
  return nil unless list.is_a?(Array)
  for item in list
    next unless item.code == 108 || item.code == 408
    if item.parameters[0] == trigger
      start = list.index(item) + 1
      finish = start + elements
      for id in start...finish
        next if !list[id]
        parameters.push(list[id].parameters[0])
      end
      return parameters
    end
  end
  return nil
end



class LightEffect_DayNight < LightEffect
  attr_accessor :sizex
  attr_accessor :sizey
  def initialize(event, viewport = nil, map = nil, sizex = 1, sizey = 1, light_effect = "LETorch")
    filename = nil
    super(event, viewport, map, filename)
	@sizex = sizex
	@sizey = sizey
	@basic_light_effect = light_effect  || "LETorch"
	  size = GameData::Weather.get($game_screen.weather_type).category == :Rain ? (@sizex/2).floor : @sizex
	bitmap = "#{@basic_light_effect}#{size}"
    custom_bitmap = pbResolveBitmap("Graphics/Pictures/#{bitmap}")
    if custom_bitmap
      @light.setBitmap("Graphics/Pictures/#{bitmap}")
      @light_scale = [1.0, 1.0]
    else
      @light.setBitmap("Graphics/Pictures/#{@basic_light_effect}")
      @light_scale = [[@sizex,1.0].max, [@sizey,1.0].max]
    end
 
    @light.ox = @light.bitmap.width / 2
    @light.oy = @light.bitmap.height / 2
  end
    
  def update
    return if !@light || !@event
    super
	@basic_light_effect = "LE" if @basic_light_effect.nil?
	@light.visible = !@event.pe_pause
	
	return if @event.pe_pause==true
	
	
	  size = GameData::Weather.get($game_screen.weather_type).category == :Rain ? (@sizex/2).floor : @sizex
      bitmap = "#{@basic_light_effect}#{size}"
	if @light.name!="Graphics/Pictures/Lights/#{bitmap}"
	  custom_bitmap = pbResolveBitmap("Graphics/Pictures/Lights/#{bitmap}")

      if custom_bitmap
       @light.setBitmap("Graphics/Pictures/Lights/#{bitmap}")
       @light_scale = [1.0, 1.0]
	  
	  else
       bitmap = @basic_light_effect
       @light.setBitmap("Graphics/Pictures/Lights/#{bitmap}")
       @light_scale = [[@sizex,1.0].max, [@sizey,1.0].max]
      end
       @light.ox = @light.bitmap.width / 2
       @light.oy = @light.bitmap.height / 2
	end
    shade = PBDayNight.getShade
    if shade >= 144   # If light enough, call it fully day
      shade = 255
    elsif shade <= 64   # If dark enough, call it fully night
      shade = 0
    else
      shade = 255 - (255 * (144 - shade) / (144 - 64))
    end
    @light.opacity = 255 - shade
    if @light.opacity > 0
      if (Object.const_defined?(:ScreenPosHelper) rescue false)
	  
	  
        @light.x      = ScreenPosHelper.pbScreenX(@event)
        @light.y      = ScreenPosHelper.pbScreenY(@event) - (@event.height * Game_Map::TILE_HEIGHT / 2)
        @light.zoom_x = (ScreenPosHelper.pbScreenZoomX(@event)) * @light_scale[0]
        @light.zoom_y = (ScreenPosHelper.pbScreenZoomY(@event)) * @light_scale[1]
		
		
		
      else
        @light.x = @event.screen_x
        @light.y = @event.screen_y - (Game_Map::TILE_HEIGHT / 2)
      end
      @light.tone.set($game_screen.tone.red,
                      $game_screen.tone.green,
                      $game_screen.tone.blue,
                      $game_screen.tone.gray)
    end
  end
end


class Game_Event < Game_Character
  attr_accessor :pe_refresh
  attr_accessor :pe_pause
  attr_accessor :currentcustomsprite
  attr_accessor :has_a_particle
  attr_accessor :has_a_light
   
   def has_particle?
     @has_a_particle = [false,nil] if @has_a_particle.nil?
      return true if @event.name[/^playertorch$/i] 
	  return true if @event.name[/^naturaltorch\((\d+),(\d+)\)/i]
	  return true if @event.name[/^naturaltorch$/i] 
	  return true if @event.name[/^playertorch\((\d+),(\d+)\)/i] 
     return @has_a_particle[0]
   end
   def should_have_particle?
     @has_a_particle = [false,nil] if @has_a_particle.nil?
      return true if @event.name[/^playertorch$/i] 
	  return true if @event.name[/^naturaltorch\((\d+),(\d+)\)/i]
	  return true if @event.name[/^naturaltorch$/i] 
	  return true if @event.name[/^playertorch\((\d+),(\d+)\)/i] 
	  return true if (@has_a_particle[0]==true && !@has_a_particle[1].nil?)
	  return false
   end
   alias nf_particles_game_map_initialize initialize unless private_method_defined?(:nf_particles_game_map_initialize)

   def initialize(map_id, event, map = nil)
    @pe_refresh = false
    @pe_pause = false
    @currentcustomsprite = nil
    @has_a_particle = [false,nil]
    @has_a_light = [false,[1,1]]

    begin
      nf_particles_game_map_initialize(map_id, event, map)
    rescue ArgumentError
      nf_particles_game_map_initialize(map_id, event)
    end
  end

  alias nf_particles_game_map_refresh refresh unless method_defined?(:nf_particles_game_map_refresh)

  def refresh
    nf_particles_game_map_refresh
    @pe_refresh = true
  end



  def toggle_particles(forced=nil)
   if forced.nil?
   if @pe_pause == false
    @pe_pause = true 
   else
    @pe_pause = false 
   end
   else
    @pe_pause = forced
   end
  end
end
class Game_Player < Game_Character
  attr_accessor :pe_refresh
  attr_accessor :pe_pause
  attr_accessor :currentcustomsprite
  attr_accessor :has_a_particle
  attr_accessor :has_a_light
   alias nf_particles_game_map_initialize2 initialize unless private_method_defined?(:nf_particles_game_map_initialize2)

   def has_particle?
     @has_a_particle = [false,nil] if @has_a_particle.nil?
     return @has_a_particle[0]
   end
   def should_have_particle?
     @has_a_particle = [false,nil] if @has_a_particle.nil?
	  return true if (@has_a_particle[0]==true && !@has_a_particle[1].nil?)
	  return false
   end
   
   def initialize
    @pe_refresh = false
    @pe_pause = false
    @currentcustomsprite = nil
    @has_a_particle = [false,nil]
    @has_a_light = [false,[1,1]]
    nf_particles_game_map_initialize2

  end

  alias nf_particles_game_map_refresh_p refresh unless method_defined?(:nf_particles_game_map_refresh_p)

  def refresh
    nf_particles_game_map_refresh_p
    @pe_refresh = true
  end

  alias lighting_engine_light_update update
  def update
    lighting_engine_light_update
	spriteset = $scene.spriteset($game_map.map_id)
    map_metadata = $game_map.metadata
	if $bag.has?(:TORCH) && map_metadata.outdoor_map==true && PBDayNight.isNight?(pbCurrentTime)
	   pbAddLightEffecttoThisEvent($game_player, 5, 5)
	else
	   pbRemoveLightEffectfromThisEvent($game_player)
	end 
  end 

  def toggle_particles(forced=nil)
   if forced.nil?
   if @pe_pause == false
    @pe_pause = true 
   else
    @pe_pause = false 
   end
   else
    @pe_pause = forced
   end
  end
end

EventHandlers.add(:on_leave_map, :change_light,
  proc { |new_map_id, new_map|
    next if new_map_id == 0
	next if !$scene.is_a?(Scene_Map)
	old_map_spriteset = $scene.spriteset($game_map.map_id)
	new_map_spriteset = $scene.spriteset(new_map_id)
    if $game_player.has_a_light[0]==true
        sizex, sizey = $game_player.has_a_light[1]
	   old_map_spriteset.usersprites[$game_player.currentcustomsprite].dispose if old_map_spriteset.usersprites[$game_player.currentcustomsprite]
	   index = new_map_spriteset.addUserSprite(LightEffect_DayNight.new($game_player, Spriteset_Map.viewport, $game_map, sizex, sizey))
        $game_player.currentcustomsprite = index
	end 
  }
)


  def pbGetCurrentTone(hour)
    tone = [0, 0, 0, 0]
    case hour
	 when 0 
    tone = [-130, -150,  15, 115]
	 when 1 
    tone = [-130, -150,  15, 115]
	 when 2
    tone = [-130, -150,  15, 115]
	 when 3 
    tone = [-70, -90,  15, 55]
	 when 4
    tone = [-60, -70,  -5, 50]
	 when 5 
    tone = [-40, -50, -35, 50]
	 when 6 
    tone = [-40, -50, -35, 50]
	 when 7 
    tone = [-40, -50, -35, 50]
	 when 8 
    tone = [-40, -50, -35, 50]
	 when 9
    tone = [-20, -25, -15, 20]
	 when 10
	 when 11
	 when 12
	 when 13
	 when 14
	 when 15
	 when 16 
	 when 17
	 when 18
    tone = [ -5, -30, -20,  0]
	 when 19
    tone = [-15, -60, -10, 20]
	 when 20
    tone = [-15, -60, -10, 20]
	 when 21
    tone = [-40, -75,   5, 40]
	 when 22 
    tone = [-70, -90,  15, 55]
	 when 23
    tone = [-130, -150,  15, 115]
	
	end
    season = pbGetSeason
    moon = moonphase
    case season
	  when 0
       tone[0]+=15
       tone[1]+=15
       tone[2]+=15
       tone[3]-=15
	  when 1
       tone[0]+=15
       tone[1]+=15
       tone[2]+=15
       tone[3]-=15
	  when 2
       tone[0]+=15
       tone[1]+=15
       tone[2]+=15
       tone[3]-=15
	  when 3
       tone[0]-=15
       tone[1]-=15
       tone[2]-=15
       tone[3]+=15
	  else
       tone[0]+=15
       tone[1]+=15
       tone[2]+=15
       tone[3]+=15
	end
	
	if hour == (23 || 22 || 21 || 0 || 1 || 2)
	  case moon
	   when 0
	  end
	end
   return Tone.new(*tone)

  end

module PBDayNight
  HOURLY_TONES = [
    Tone.new(-130, -150,  15, 115),   # Night           # Midnight
    Tone.new(-130, -150,  15, 115),   # Night
    Tone.new(-130, -150,  15, 115),   # Night
    Tone.new(-70, -90,  15, 55),   # Night
    Tone.new(-60, -70,  -5, 50),   # Night
    Tone.new(-40, -50, -35, 50),   # Day/morning
    Tone.new(-40, -50, -35, 50),   # Day/morning     # 6AM
    Tone.new(-40, -50, -35, 50),   # Day/morning
    Tone.new(-40, -50, -35, 50),   # Day/morning
    Tone.new(-20, -25, -15, 20),   # Day/morning
    Tone.new(  0,   0,   0,  0),   # Day
    Tone.new(  0,   0,   0,  0),   # Day
    Tone.new(  0,   0,   0,  0),   # Day             # Noon
    Tone.new(  0,   0,   0,  0),   # Day
    Tone.new(  0,   0,   0,  0),   # Day/afternoon
    Tone.new(  0,   0,   0,  0),   # Day/afternoon
    Tone.new(  0,   0,   0,  0),   # Day/afternoon
    Tone.new(  0,   0,   0,  0),   # Day/afternoon
    Tone.new( -5, -30, -20,  0),   # Day/evening     # 6PM
    Tone.new(-15, -60, -10, 20),   # Day/evening
    Tone.new(-15, -60, -10, 20),   # Day/evening
    Tone.new(-40, -75,   5, 40),   # Night
    Tone.new(-70, -90,  15, 55),   # Night
    Tone.new(-130, -150,  15, 115)    # Night
  ]



  def self.getToneInternal
    # Calculates the tone for the current frame, used for day/night effects
    realMinutes = pbGetDayNightMinutes
    hour   = realMinutes / 60
    minute = realMinutes % 60
    tone         = pbGetCurrentTone(hour)
    nexthourtone = pbGetCurrentTone((hour + 1) % 24)
    # Calculate current tint according to current and next hour's tint and
    # depending on current minute
    @cachedTone.red   = ((nexthourtone.red - tone.red) * minute * @oneOverSixty) + tone.red
    @cachedTone.green = ((nexthourtone.green - tone.green) * minute * @oneOverSixty) + tone.green
    @cachedTone.blue  = ((nexthourtone.blue - tone.blue) * minute * @oneOverSixty) + tone.blue
    @cachedTone.gray  = ((nexthourtone.gray - tone.gray) * minute * @oneOverSixty) + tone.gray
  end

end