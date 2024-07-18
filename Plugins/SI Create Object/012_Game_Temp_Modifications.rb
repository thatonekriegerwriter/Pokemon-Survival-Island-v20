class Game_Temp
  attr_accessor :position_calling
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

  def automove
    @auto_move = false if !@auto_move
    return @auto_move
  end
  def bossfight
    @bossfight = false if !@bossfight
    return @bossfight
  end
  def following_ov_pokemon
    @following_ov_pokemon = false if !@following_ov_pokemon
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