

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
	  elsif !map.events[i].currentcustomsprite.nil? && map.events[i].has_a_light[0]==true && !map.events[i].has_a_light[1].nil?
        sizex = map.events[i].has_a_light[1][0]
        sizey = map.events[i].has_a_light[1][1]
        spriteset.addUserSprite(LightEffect_DayNight.new(map.events[i], viewport, map, sizex, sizey))
      end

    end
  }
)


def pbCreateParticleEngine(viewport=Spriteset_Map.viewport,map=$game_map,spriteset=nil)
   return if !$particle_engine.nil?
   return if !$scene.is_a?(Scene_Map)
   if spriteset.nil?
    spriteset = $scene.spriteset(map.map_id)
   end
   return if spriteset.nil?
	$particle_engine = Particle_Engine.new(viewport, map)
    spriteset.addUserSprite($particle_engine)

end

EventHandlers.add(:on_map_or_spriteset_change, :reset_particle_engine_state,
  proc { |scene, map_changed|
    next if !scene || !scene.spriteset || !$particle_engine
     $particle_engine.reset
  }
)
EventHandlers.add(:on_leave_map, :change_particle_engine_state,
  proc { |new_map_id, new_map|
    next if new_map_id == 0 || !$particle_engine
     $particle_engine.remove_particles

  }
)

def isaaparticle(event)
   return ["fire"] if event.name.include?("naturaltorch") 
   return ["fire"] if event.name.include?("playertorch")
   return nil
end

class Particle_Engine
  attr_accessor :firsttime
  def initialize(viewport = nil, map = nil)
    @map       = (map) ? map : $game_map
    @viewport  = viewport
    @effect    = []
    @disposed  = false
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
      "starteleport" => Particle_Engine::StarTeleport
    }
  end
  
  def reset
    dispose
    @firsttime = true
    @effect    = []
    @map = $game_map if @map!=$game_map
  end
  
  def remove_particles
    @effect.each do |particle|
      next if particle.nil?
      particle.dispose
    end
  
  
  end
  
  def dispose
    return if disposed?
    @effect.each do |particle|
      next if particle.nil?
      particle.dispose
    end
    @effect.clear
    @map = nil
    @disposed = true
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
    @effect.delete_at(event.id)
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
    if @firsttime
      @firsttime = false
	  @map = $game_map if !@map
      @map.events.each_value do |event|
	   next if !event.has_particle? && !event.should_have_particle?
       remove_effect(event)
        add_effect(event)
      
	  end
    end
    @effect.each_with_index do |particle, i|
      next if particle.nil?
	  
	   particle.event.pe_pause=false if particle.event.pe_pause.nil?
      if particle.event.pe_refresh
        event = particle.event
        event.pe_refresh = false
        particle = realloc_effect(event, particle)
        @effect[i] = particle
      end
      particle&.update
    end
  end



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
  pbCreateParticleEngine
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
  #spriteset.removeUserSprite(event.currentcustomsprite)
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


  def removeUserSprite(index)
    @usersprites.delete_at(index)
  end

end

class ParticleSprite
  attr_accessor :x, :y, :z, :ox, :oy, :opacity, :blend_type
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

  def initialize(event, viewport = nil)
    @event     = event
    @viewport  = viewport
    @particles = []
    @visible = true
    @bitmaps   = {}
  end

  def setParameters(params)
    @randomhue, @leftright, @fade,
    @maxparticless, @hue, @slowdown,
    @ytop, @ybottom, @xleft, @xright,
    @xgravity, @ygravity, @xoffset, @yoffset,
    @opacityvar, @originalopacity = params
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
      return
    end
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
	  
      if maxX < 0 || maxY < 0 || minX >= Graphics.width || minY >= Graphics.height
#        echo "skipped"
        return
      end
    end
    particleZ = selfZ + @zoffset
    @maxparticless.times do |i|
	    next if @particles[i].nil?
	   @particles[i].visible=true if @event.pe_pause==false
	   @particles[i].visible=false if @event.pe_pause==true
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
    setParameters([0, 0, 1, 20, 40, 0.5, -64,
                   Graphics.height, -64, Graphics.width, 0.5, 0.10, -5, -13, 30, 0])
    initParticles("particle", 250)
  end
end






class Particle_Engine::Smoke < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters([0, 0, 0, 80, 20, 0.5, -64,
                   Graphics.height, -64, Graphics.width, 0.5, 0.10, -5, -15, 5, 80])
    initParticles("smoke", 250)
  end
end



class Particle_Engine::Teleport < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters([1, 1, 1, 10, rand(360), 1, -64,
                   Graphics.height, -64, Graphics.width, 0, 3, -8, -15, 20, 0])
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
    setParameters([1, 0, 1, 20, rand(360), 0.5, -64,
                   Graphics.height, -64, Graphics.width, 0.5, 0.10, -5, -13, 30, 0])
    initParticles("particle", 250)
  end
end



class Particle_Engine::Explosion < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters([0, 0, 1, 20, 0, 0.5, -64,
                   Graphics.height, -64, Graphics.width, 0.5, 0.10, -5, -13, 30, 0])
    initParticles("explosion", 250)
  end
end



class Particle_Engine::Aura < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters([0, 0, 1, 20, 0, 1, -64,
                   Graphics.height, -64, Graphics.width, 2, 2, -5, -13, 30, 0])
    initParticles("particle", 250)
  end
end



class Particle_Engine::Soot < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters([0, 0, 0, 20, 0, 0.5, -64,
                   Graphics.height, -64, Graphics.width, 0.5, 0.10, -5, -15, 5, 80])
    initParticles("smoke", 100, 0, 2)
  end
end



class Particle_Engine::SootSmoke < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters([0, 0, 0, 30, 0, 0.5, -64,
                   Graphics.height, -64, Graphics.width, 0.5, 0.10, -5, -15, 5, 80])
    initParticles("smoke", 100, 0)
    @maxparticless.times do |i|
      @particles[i].blend_type = rand(6) < 3 ? 1 : 2
    end
  end
end



class Particle_Engine::Rocket < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters([0, 0, 0, 60, 0, 0.5, -64,
                   Graphics.height, -64, Graphics.width, 0.5, 0, -5, -15, 5, 80])
    initParticles("smoke", 100, -1)
  end
end



class Particle_Engine::FixedTeleport < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters([1, 0, 1, 10, rand(360), 1,
                   -Graphics.height, Graphics.height, 0, Graphics.width, 0, 3, -8, -15, 20, 0])
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
    setParameters([0, 0, 1, 10, 0, 1,
                   -Graphics.height, Graphics.height, 0, Graphics.width, 0, 3, -8, -15, 10, 0])
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
    setParameters([0, 0, 0, 250, 0, 0.2, -64,
                   Graphics.height, -64, Graphics.width, 0.8, 0.8, -5, -15, 5, 80])
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
    setParameters([0, 0, 1, 30, 10, 1, -64,
                   Graphics.height, -64, Graphics.width, 2, 2, -5, -12, 30, 0])
    initParticles("particle", 255)
  end
end



class Particle_Engine::Splash < ParticleEffect_Event
  def initialize(event, viewport)
    super
    setParameters([0, 0, 1, 30, 255, 1, -64,
                   Graphics.height, -64, Graphics.width, 4, 2, -5, -12, 30, 0])
    initParticles("smoke", 50)
  end

  def update
    super
    @maxparticless.times do |i|
      @particles[i].opacity = 50
      @particles[i].update
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
  def initialize(event, viewport = nil, map = nil, sizex = 1, sizey = 1)
    filename = nil
    super(event, viewport, map, filename)
    @light.ox = @light.bitmap.width / 2
    @light.oy = @light.bitmap.height / 2
	@sizex = sizex
	@sizey = sizey
  end
    
  def update
    return if !@light || !@event
    super
	@light.visible = false if @event.pe_pause==true
	@light.visible = true if @event.pe_pause==false
	return if @event.pe_pause==true
	if @light.name!="Graphics/Pictures/LE#{@sizex}" 
	  size = @sizex
	  if @sizex > 3
	   size=3
	  end
 
	 if pbResolveBitmap("Graphics/Pictures/LE#{size}")
      @light.setBitmap("Graphics/Pictures/LE#{size}")
	 end
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
        @light.zoom_x = (ScreenPosHelper.pbScreenZoomX(@event))*@sizex
        @light.zoom_y = (ScreenPosHelper.pbScreenZoomY(@event))*@sizey
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
   
     return @has_a_particle[0]
   end
   def should_have_particle?
      return true if @event.name[/^playertorch$/i] 
	  return true if @event.name[/^naturaltorch\((\d+),(\d+)\)/i]
	  return true if @event.name[/^naturaltorch$/i] 
	  return true if @event.name[/^playertorch\((\d+),(\d+)\)/i] 
	  return true if (@has_a_particle[0]==true && !@has_a_particle[1].nil?)
	  return false
   end
   
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