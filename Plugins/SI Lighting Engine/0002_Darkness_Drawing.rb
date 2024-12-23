class DarknessEffect
  attr_reader :sprite
 
  def initialize
    @sprite = Sprite.new
    @sprite.z = 9999  
  end
 
  def create_darkness_bitmap
    @sprite.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprite.bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, Color.new(0, 0, 0))
  end
 
  def opacity=(value)
    @sprite.opacity = value
  end
 
  def opacity
    @sprite.opacity
  end
 
  # Gradually change opacity
  def fade_to(target_opacity, duration = 60)
    start_opacity = @sprite.opacity
    duration.times do |i|
      @sprite.opacity = start_opacity + (target_opacity - start_opacity) * i / duration
      Graphics.update
    end
  end
 
  def dispose
    @sprite.dispose if @sprite
  end
   def ensure_darkness_initialized
    # Check if the sprite doesn't exist or has been disposed
    if @sprite.nil? || @sprite.disposed?
      create_darkness_bitmap
      return true
    end
    false
  end
end

$game_darkness_effect ||= DarknessEffect.new



def setDarknessIntensity(value)
  $game_darkness_effect.opacity = value
end

#Darkness value_one, applies with fade effect of value_two frames.
def DarkenessIntensityFade(value_one, value_two)
  $game_darkness_effect.fade_to(value_one, value_two) 
end


#Dispose all darkness system
def disposeDarkness
  $game_darkness_effect.dispose
end


#Reinitialize Darkness System
def recallDarkness
    $game_darkness_effect.initialize
    $game_darkness_effect.create_darkness_bitmap
end
 

#Checks if Darkness System is complete
def ensureDarkness
  $game_darkness_effect.ensure_darkness_initialized
end

#Recreates only the darkeness bitmap.
def recallDarkSprite
  $game_darkness_effect.create_darkness_bitmap
end



if false
class Spriteset_Map
  def self.viewport3   # For access by Spriteset_Global
    return @@viewport3
  end
end

	#@maxparticless = Settings::SCREEN_WIDTH * Settings::SCREEN_HEIGHT
	
	
class DarknessDrawing_Event < ParticleEffect

  def initialize(viewport=nil)
    @viewport  = viewport if !viewport.nil?
    @viewport  = Spriteset_Map.viewport3 if viewport.nil?
	
	
    @bitmap   = AnimatedBitmap.new("Graphics/Fogs/" + "darknessparticle", 0).deanimate
	
	
	@xoffset = 0
	@yoffset = 0
    @zoffset   = 0
    @particles = []
    @opacity   = []
	
	
    Settings::SCREEN_HEIGHT.times do |i|
       Settings::SCREEN_WIDTH.times do |j|
	     puts "#{i} - #{j}"
         @particles[i*j] = ParticleSprite.new(@viewport)
         @particles[i*j].bitmap = @bitmap
         @particles[i*j].blend_type = 1
         @particles[i*j].x = i
         @particles[i*j].y = j
         @particles[i*j].z = @zoffset
         @opacity[i*j] = 255
         @particles[i*j].opacity = 255
         @particles[i*j].update
	  end
    end
  end


  def update
    if @viewport &&
       (@viewport.rect.x >= Graphics.width ||
       @viewport.rect.y >= Graphics.height)
      return
    end
    #delta_t = Graphics.delta
    particleZ = @zoffset
	
	
    Settings::SCREEN_HEIGHT.times do |i|
       Settings::SCREEN_WIDTH.times do |j|
	     puts "2: #{i} - #{j}"
	      @particles[i*j].z = particleZ
	       @opacity[i*j] = @opacity[i*j] 
           @particles[i*j].opacity = @opacity[i*j]
           @particles[i*j].update
	  
	  
	  
    end
	end






  end

  def dispose
    @particles.each do |particle|
      particle.dispose
    end
    @bitmap.dispose
    @particles.clear
  end


end
end

# Display darkness circle on dark maps.
EventHandlers.add(:on_map_or_spriteset_change, :show_darkness,
  proc { |scene, _map_changed|
    next if !scene || !scene.spriteset
    map_metadata = $game_map.metadata
    if map_metadata&.dark_map
      $game_temp.darkness_sprite = DarknessSprite.new
      scene.spriteset.addUserSprite($game_temp.darkness_sprite)
      if $PokemonGlobal.flashUsed
        $game_temp.darkness_sprite.radius = $game_temp.darkness_sprite.radiusMax
      end
    else
      $PokemonGlobal.flashUsed = false
      $game_temp.darkness_sprite&.dispose
      $game_temp.darkness_sprite = nil
    end
  }
)

