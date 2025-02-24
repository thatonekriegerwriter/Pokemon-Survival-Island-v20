class Game_Temp
  attr_accessor :position_calling
  attr_accessor :in_throwing
  attr_accessor :no_moving
  attr_accessor :equipment_calling
  attr_accessor :pokemon_calling
  attr_accessor :in_safari
  attr_accessor :interactingwithpokemon
  attr_accessor :preventspawns
  attr_accessor :no_natural_spawning
  attr_accessor :getsomehelp
  attr_accessor :in_combat
  attr_accessor :auto_move
  attr_writer   :spawnqueue
  attr_writer   :lockontarget
  attr_writer   :stopmoving
  attr_accessor :stop_intro_animations
  attr_writer   :current_pkmn_controlled
  attr_accessor :dungeon_xatu_mart
  attr_accessor :tasks
  attr_writer   :bossfight
  attr_accessor :check_for_invisible_events
  attr_accessor :following_ov_pokemon
  attr_accessor :overworld_pokemon
  attr_accessor :notebook_calling
  attr_accessor :carried_evo_stones
  attr_accessor :saved_bgms
  attr_accessor :saved_bgm_poses
  attr_accessor :disable_running
  attr_accessor :dead
  attr_accessor :relock_prevention
  attr_accessor :currently_throwing_pkmn
  attr_accessor :weapon_selection_end
  attr_accessor :radial_enabled
  attr_accessor :favorites_enabled
  attr_accessor :currently_selecting
  
  def weapon_selection_end
    @weapon_selection_end = 0 if !@weapon_selection_end
    return @weapon_selection_end
  end
  
  def currently_selecting
    @currently_selecting = false if @currently_selecting.nil?
    return @currently_selecting
  end
  
  
  
  def radial_enabled
    @radial_enabled = false if @radial_enabled.nil?
    return @radial_enabled
  end
  
  
  def favorites_enabled
    @favorites_enabled = false if @favorites_enabled.nil?
    return @favorites_enabled
  end
  
  
  def saved_bgms
    @saved_bgms = [] if !@saved_bgms
    return @saved_bgms
  end
  def relock_prevention
    @relock_prevention = 0 if @relock_prevention.nil?
    return @relock_prevention
  end
  def disable_running
    @disable_running = false if !@disable_running
    return @disable_running
  end
  def dead
    @dead = false if !@dead
    return @dead
  end
  def currently_throwing_pkmn
    @currently_throwing_pkmn = false if !@currently_throwing_pkmn
    return @currently_throwing_pkmn
  end
  def saved_bgm_poses
    @saved_bgm_poses = {} if !@saved_bgm_poses
    return @saved_bgm_poses
  end
  def position_calling
    @position_calling = false if !@position_calling
    return @position_calling
  end
  def in_throwing
    @in_throwing = false if !@in_throwing
    return @in_throwing
  end
  def no_moving
    @no_moving = false if !@no_moving
    return @no_moving
  end
  def automove
    @auto_move = false if !@auto_move
    return @auto_move
  end
  def bossfight
    @bossfight = false if !@bossfight
    return @bossfight
  end
  def following_ov_pokemon
    @following_ov_pokemon = {} if !@following_ov_pokemon
    @following_ov_pokemon = {} if @following_ov_pokemon.is_a?(FalseClass)
    @following_ov_pokemon = {} if @following_ov_pokemon.is_a?(Array)
    return @following_ov_pokemon
  end
  def overworld_pokemon
    @following_ov_pokemon = @following_ov_pokemon if !@following_ov_pokemon
    return @following_ov_pokemon
  end
  def spawnqueue
    @spawnqueue = [] if !@spawnqueue
    return @spawnqueue
  end
  def carried_evo_stones
    @carried_evo_stones = [] if !@carried_evo_stones
    return @carried_evo_stones
  end
  def lockontarget
    @lockontarget = false if !@lockontarget
    return @lockontarget
  end

  def stopmoving
    @stopmoving = false if !@stopmoving
    return @stopmoving
  end
  def check_for_invisible_events
    @check_for_invisible_events = false if !@check_for_invisible_events
    return @check_for_invisible_events
  end
  def preventspawns
    @preventspawns = false if !@preventspawns
    return @preventspawns
  end
  def pokemon_calling
    @pokemon_calling = false if !@pokemon_calling
    return @pokemon_calling
  end
  
  
  def stop_intro_animations
    @stop_intro_animations = false if !@stop_intro_animations
    return @stop_intro_animations
  end
  def no_natural_spawning
    @no_natural_spawning = false if !@no_natural_spawning
    return @no_natural_spawning
  end

  def dungeon_xatu_mart
    @dungeon_xatu_mart = [] if !@dungeon_xatu_mart
    return @dungeon_xatu_mart
  end
  def current_pkmn_controlled
    @current_pkmn_controlled = false if !@current_pkmn_controlled
    return @current_pkmn_controlled
  end
end