module GameData
  class Species
    def legendary?
	  return has_flag?("Legendary")
	end 
    def mythical?
	  return has_flag?("Mythical")
	end 
    def milkable?
	  return has_flag?("Milkable")
	end 
    def shearable?
	  return has_flag?("Shearable")
	end 
    def bee?
	  return has_flag?("Bee")
	end 
  end
end 


EventHandlers.add(:on_player_step_taken, :hatch_eggs,
  proc {
    $player.party.each do |egg|
      next unless egg 
      next if egg.steps_to_hatch <= 0
      egg.steps_to_hatch -= 1
      $player.pokemon_party.each do |pkmn|
        next if !pkmn.ability&.has_flag?("FasterEggHatching")
        egg.steps_to_hatch -= 1
        break
      end
      if egg.steps_to_hatch <= 0
        egg.steps_to_hatch = 0
        pbHatch(egg)
      end
    end
  }
)


class Pokemon
  attr_accessor :water
  attr_accessor :food
  attr_accessor :sleep
  attr_accessor :maxage
  attr_accessor :lifespan
  attr_accessor :height
  attr_accessor :weight
  attr_accessor :birth_date
  attr_accessor :memory
  attr_accessor :item_timer
  attr_accessor :stamina 


  def location
    @associatedevent.nil? ? @current_map : self.event.map_id
  end 
  
  def bee?
    self.species_data.bee?
  end 
  
#alias _SI_Pokemon_species= species=
#def species=(species_id)
#  _SI_Pokemon_species=(species_id)
#end
  

alias _SI_Pokemon_init initialize
def initialize(*args)
    _SI_Pokemon_init(*args)
	species_data = GameData::Species.get(species)
    @maxage          = species_data.maxage || 100
    @lifespan          = 100
    @starter          = false
    @food             = rand(50...100)
    @water            = rand(50...100)
    @stamina            = 7
	@handled_aging = false 
    @height = species_data.height + (rand(2).zero? ? -rand(1.0) : rand(1.0))
    @weight = species_data.weight * (1 + (rand(2).zero? ? -rand(0.06) : rand(0.06)))
	@memory       = _INTL("Press [ALT] to write more.")
    @shiny_leaf = 0
    @hidden_modifiers = []
	@extra_moves = []
	@handled_aging = false 
	@item_timer = pbGetTimeNow.to_i - 3600
	@last_interacted_with = pbGetTimeNow.to_i
	
	@birth_date = generate_birthday

end
  def stamina
    @stamina = 7 if @stamina.nil?
    return @stamina
  end 
  def extra_moves
    @extra_moves = [] if @extra_moves.nil?
    return @extra_moves
  end 
  
  def add_extra_species_moves
    @extra_moves = [] if @extra_moves.nil?
    movelist = getMoveList
	movelist.each do |i|
       next if i[0] > level
       next if hasMove?(i[1])
       next if @extra_moves.include?(i[1])
       @extra_moves.push(i[1])
    end
    species_data.tutor_moves.each do |m|
     next if hasMove?(m)
     next if @extra_moves.include?(m)
     @extra_moves.push(m)
    end
  end 
  
  def last_interacted_with
    @last_interacted_with = pbGetTimeNow.to_i if @last_interacted_with.nil?
    return @last_interacted_with
  end 
  def update_interacted
    @last_interacted_with = pbGetTimeNow.to_i
  end 
  
  def can_harvest?
	@item_timer ||= pbGetTimeNow.to_i - 3600
	time_now = pbGetTimeNow.to_i
    time_delta = time_now - @item_timer
    return time_delta >= 3600
  end 
  def harvest
	@item_timer = pbGetTimeNow.to_i
  end 
  def update
    if is_birthday? && @handled_aging==false
	
      age_ratio = self.age.to_f / @maxage
      if age_ratio >= 1.00
       changeLifespan("aging_wilderness")
      elsif age_ratio >= 0.85
       changeLifespan("aging_advancing")
      elsif age_ratio >= 0.70
       changeLifespan("aging_starting")
      end
      @handled_aging = true
	elsif !is_birthday? && @handled_aging==true
	  @handled_aging = false
	end 
  end
 
   
  def changeLifespan(method)
    gain = 0
    lifespan_range = @lifespan / 100
      case method
      when "aging_starting"
        gain = [-1, -1, -1][lifespan_range]
      when "aging_advancing"
        gain = [-2, -2, -2][lifespan_range]
      when "aging_wilderness"
        gain = [-9, -10, -9][lifespan_range]
      when "dehydrated"
        gain = [-2, -1, -2][lifespan_range]
      when "starving"
        gain = [-2, -2, -1][lifespan_range]
      when "dehydratedbadly"
        gain = [-9, -10, -9][lifespan_range]
      when "starvingbadly"
        gain = [-9, -10, -9][lifespan_range]
      when "mortally_wounded"
        gain = [-3, -4, -5][lifespan_range]
      when "suspo"
        gain = [100, 100, 100][lifespan_range]
	  end
    @lifespan = (@lifespan + gain).clamp(0, 100)
  end
  
  def die
    return unless lifespan_zero?
    data = Nuzlocke.rules; data = [] if data.nil?
	pbShowTipCardsGrouped(:DEATH) if !pbSeenTipCard?(:DOWNED)
    pkmn.hp = 0
	if $player.party.include?(pkmn)
	 pbSEPlay("DeathDQ")
	 puts "#{pkmn.name}'s lifespan is now #{pkmn.lifespan} wellness."
     pbMessage(_INTL("{1} died...", pkmn.name))
	end
    pkmn.permaFaint=true
	if data.include?(:PERMADEATH)
	  index = $player.party.index(pkmn)
      $player.party.delete_at(index)
	end 
  end 
  
  def lifespan_zero?
    return @lifespan<=0
  
  end 
  
    def get_lifespan
	  species_data.lifespan || 100
	
	end 
	def generate_birthday
       age = rand(1..100)
       days = rand(0..365)
       seconds = ((age * 365) + days) * 24 * 60 * 60
       pbGetTimeNow - seconds
	end 
	
	def set_birthday(time=pbGetTimeNow)
	   @birth_date = time
	end 
	
	def birth_date
	 @birth_date = generate_birthday if @birth_date.nil?
	 @birth_date
	end 
	def is_birthday?
 	 now = pbGetTimeNow
 	 now.month == self.birth_date.month && now.day == self.birth_date.day
	end
	
	def age
     now = pbGetTimeNow
     years = now.year - birth_date.year
     years -= 1 if now.month < birth_date.month ||
              (now.month == birth_date.month && now.day < birth_date.day)
     return years
    end
	

    def poke_ball
	   @poke_ball = @poke_ball.id if @poke_ball.is_a?(ItemData)
	  return @poke_ball
	 end
	def pokemon
	  return self
	end
	def gender_symbol
	  return "♂" if self.male?
	  return "♀" if self.female?
	  return ""
	end
	


   


   def permadeath
    return @permaFaint
   end
   def dead?
    return @permaFaint==true
   end
  # @return [Integer] the height of this Pokémon in decimetres (0.1 metres)
  def height
    @height = species_data.height + (rand(2).zero? ? -"#{0.rand(15)}".to_f : "#{0.rand(15)}".to_f) if @height.nil?
    return @height
  end

  # @return [Integer] the weight of this Pokémon in hectograms (0.1 kilograms)
  def weight
    @weight = species_data.weight + (rand(2).zero? ? -"#{0.rand(30)}".to_f : "#{0.rand(30)}".to_f) if @height.nil?
    return @weight
  end

 

  def food
    @food = 100 if !@food
    return @food
  end
  def water
    @water = 100 if !@water
    return @water
  end
  def sleep
    @sleep = 100 if !@sleep
    return @sleep
  end
  def maxage
    @maxage = 100 if !@maxage
    return @maxage
  end
  def lifespan
    @lifespan = 100 if !@lifespan
    return @lifespan
  end


  def changeFood

  end
  
  def changeWater

  end
  
  def changeSleep

  end

  def changeAge
    raise "Change Age Called"
    if @age.nil?
	 @age = 1
	end
    gain = 0
    age_range = @age / 100
    gain = [1, 1, 1][age_range]
    @age = (@age + gain).clamp(0, 100)
  end

 
end

