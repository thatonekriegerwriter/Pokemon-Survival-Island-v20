def pbTurnBerryPlant(this_event,berry_plant)
   if !berry_plant.planted?
	elsif berry_plant.grown?
    this_event.turn_up 
	elsif berry_plant.growing? && (berry_plant.growth_stage==1 || berry_plant.growth_stage==2)
    this_event.turn_down
	elsif berry_plant.growing? && berry_plant.growth_stage==3
	 this_event.turn_left
	else
	 this_event.turn_right
	end

end

def bag_has_a_watering_can?
has = 0
GameData::BerryPlant::WATERING_CANS.each do |item|
  if $bag.has?(item)
    has+=1
  end
end

return true if has>0
return false
end

def pbBerryPlant
  interp = pbMapInterpreter
  this_event = interp.get_self
  berry_plant = interp.getVariable
  if !berry_plant.is_a?(BerryPlantData)
    berry_plant = BerryPlantData.new(this_event)
    interp.setVariable(berry_plant)
  end
  berry = berry_plant.berry_obj
  if berry.nil? && !berry_plant.berry_id.nil?
   berry_plant.berry_obj = ItemData.new(berry_plant.berry_id)
   berry = berry_plant.berry_obj
  
  end 
  berry_plant.dead=false if berry_plant.dead.nil?
  
    pbTurnBerryPlant(this_event,berry_plant) 
  if !bag_has_a_watering_can?
    pbTurnBerryPlant(this_event,berry_plant)   # Stop the event turning towards the player
    pbMessage(_INTL("You do not have a Watering Can. You will be unable to water the plant."))
  end
  
  if berry_plant.beside_water==false && berry_plant.tile_data.waterless_length<6 && !berry_plant.growth_stalled? && berry_plant.stagnation_message==false
    pbTurnBerryPlant(this_event,berry_plant)   # Stop the event turning towards the player
    pbMessage(_INTL("The plant isn't near any water, it may need to be watered more often."))
	 berry_plant.stagnation_message=true
  end
  
  
  if berry_plant.overall_soil_quality==0
    pbTurnBerryPlant(this_event,berry_plant)   # Stop the event turning towards the player
    pbMessage(_INTL("The soil seems to have become ruined."))
    pbMessage(_INTL("The plant appears to have died."))
	pbBerryPlantWitheredItem
    berry_plant.reset
    return
  end
  
  if berry_plant.growth_stalled? && berry_plant.tile_data.waterless_length<6
    pbTurnBerryPlant(this_event,berry_plant)   # Stop the event turning towards the player
    pbMessage(_INTL("The plant's growth seems to have stalled."))
  end
  
  
  if berry_plant.growth_stalled? && berry_plant.tile_data.waterless_length>=6
    pbTurnBerryPlant(this_event,berry_plant)   # Stop the event turning towards the player
    pbMessage(_INTL("The plant's growth seems to have stalled."))
    pbMessage(_INTL("The plant appears to have died."))
	pbBerryPlantWitheredItem
    berry_plant.reset
    return
  end
  
  if berry_plant.dead==true
    pbTurnBerryPlant(this_event,berry_plant)  # Stop the event turning towards the player
    pbMessage(_INTL("The plant appears to have died."))
	pbBerryPlantWitheredItem
    berry_plant.reset
    return
  end
    not_planted = !berry_plant&.planted?
	if !not_planted
    if pbPestInteraction(this_event,berry_plant)
	  return
	 end
	end
    pbOtherInteractions if !not_planted
  if berry_plant.grown?
    this_event.turn_up   # Stop the event turning towards the player
	theyield = berry_plant.berry_yield
	if theyield>0
    berry_plant.reset if pbPickBerry(berry, theyield, true, berry_plant.mutated_berry_info)
	else
     pbMessage(_INTL("There were no berries on the bush!"))
	 berry_plant.reset
	end
    return
  end
	if !not_planted
    if pailInteraction(this_event,berry_plant)
	  return
    end
	end
  # Interact with the event based on its growth
  

	
	
  if berry_plant.growing?
    berry_name = GameData::Item.get(berry).name
    case berry_plant.growth_stage
   
   
    when 1   # X planted
	
	
	
      this_event.turn_down   # Stop the event turning towards the player
	  if pbShowBerryMessage
      if berry_name.starts_with_vowel?
        pbMessage(_INTL("An {1} was planted here.", berry_name))
      else
        pbMessage(_INTL("A {1} was planted here.", berry_name))
      end
	  end






    when 2   # X sprouted
	
	
      this_event.turn_down   # Stop the event turning towards the player
	  
      pbMessage(_INTL("The {1} has sprouted.", berry_name)) if pbShowBerryMessage
	  
	  
	  
    when 3   # X taller
      this_event.turn_left 
      pbMessage(_INTL("The {1} is growing bigger.", berry_name)) if pbShowBerryMessage
	  
	  
    else     # X flowering
      this_event.turn_right   # Stop the event turning towards the player
            mutation_comment = Settings::BERRY_PLANT_BLOOMING_COMMENT
	  if pbShowBerryMessage
        mutation_comment = Settings::BERRY_PLANT_BLOOMING_COMMENT if berry_plant&.mutated_berry_info
        case berry_plant.watering_count
        when 4
          pbMessage(_INTL("This {1} is wiggling!", berry_name))
        when 3
          pbMessage(_INTL("This {1} is sitting pretty!", berry_name))
        when 2
          pbMessage(_INTL("This {1} is great!", berry_name))
        when 1
          pbMessage(_INTL("This {1} is going to be big one day!", berry_name))
        else
          pbMessage(_INTL("This {1} is in bloom!!", berry_name))
        end
        pbMessage(mutation_comment) if mutation_comment if berry_plant&.mutated_berry_info
	  end

   end
    #dothewateringthingplant
    return
  end
  

  
  # Nothing planted yet
  ask_to_plant = true
  
  
    # New mechanics
	
  if berry_plant.mulch_id && berry_plant.cropsticks == false
    if pbConfirmMessage(_INTL("{1} has been laid down.\1 Would you like to add Cropsticks?", GameData::Item.get(berry_plant.mulch_id).name))
			if $bag.has?(:CROPSTICKS)
          $bag.remove(:CROPSTICKS)
		  berry_plant.cropsticks = true
		else
          pbMessage(_INTL("You don't have any Cropsticks."))
          return
		end

	
	end
  elsif berry_plant.mulch_id && berry_plant.cropsticks == true
      pbMessage(_INTL("{1} has been laid down, surrounded by {2}.", GameData::Item.get(berry_plant.mulch_id).name,GameData::Item.get(:CROPSTICKS).name))
  else
      case pbMessage(_INTL("It's soft, loamy soil."),
                     [_INTL("Plant Berry"), _INTL("Fertilize"), _INTL("Cropsticks"), _INTL("Exit")], -1)
      when 1   # Fertilize
        mulch = nil
		 berry_plant.water(100)
        pbFadeOutIn {
          scene = PokemonBag_Scene.new
          screen = PokemonBagScreen.new(scene, $bag)
          mulch = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_mulch? })
        }
        return if !mulch
        mulch_data = GameData::Item.get(mulch)
        if mulch_data.is_mulch?
          berry_plant.mulch_id = mulch
          $bag.remove(mulch)
          pbMessage(_INTL("The {1} was scattered on the soil.\1", mulch_data.name))
        else
          pbMessage(_INTL("That won't fertilize the soil!"))
          return
        end
      when 2
	    if pbConfirmMessage(_INTL("Would you like to use Cropsticks for this plant?"))
		if $bag.has?(:CROPSTICKS)
          $bag.remove(:CROPSTICKS)
		  berry_plant.cropsticks = true
		else
          pbMessage(_INTL("You don't have any Cropsticks."))
          return
		end

		end
      when 0   # Plant Berry
        ask_to_plant = false
      else   # Exit/cancel
        return
      end
	  
	  
	  
	
  end
 
 
 
 
 
  if !ask_to_plant || pbConfirmMessage(_INTL("Want to plant a Berry?"))
    pbFadeOutIn {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene, $bag)
      berry = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_berry? })
    }
    if berry
      $stats.berries_planted += 1
      berry_plant.plant(berry)
      $bag.remove(berry)
	  
	  
	  
	  
      if GameData::Item.get(berry).name.starts_with_vowel?
        pbMessage(_INTL("{1} planted an {2} in the soft, loamy soil.",
                        $player.name, GameData::Item.get(berry).name))
      else
        pbMessage(_INTL("{1} planted a {2} in the soft, loamy soil.",
                        $player.name, GameData::Item.get(berry).name))
      end


    end
  end


end


def pbPickBerry(berry, qty = 1, replant=false, mutation_info=nil)
  if berry.is_a?(Symbol)
  berry = ItemData.new(berry) 
  end
  qty *= 2 if $bag.has?(:BERRYCHARM)
  interp = pbMapInterpreter
  this_event = interp.get_self
  berry_plant = interp.getVariable
  if !berry_plant
    berry_plant = BerryPlantData.new(this_event)
    interp.setVariable(berry_plant)
    berry_plant.berry_obj = berry
  end
  berry_plant.last_berry = berry
  berry_plant.timewithoutberry = pbGetTimeNow.to_i
  
  
  berrydata = GameData::Item.get(berry)
  mut_berry_qty = 0
  
  
  if !mutation_info.nil?
  mut_berry = mutation_info[0]
  mut_berrydata = GameData::Item.get(mutation_info[0])
  mut_berry_qty = mutation_info[1]
  mut_berry_qty -= 1 while qty - mut_berry_qty < 1
  mut_berry_name = (mut_berry_qty > 1) ? mut_berrydata.name_plural : mut_berrydata.name
  end
  berry_name = (qty > 1) ? berrydata.name_plural : berrydata.name
  
  
  
  
  
  
  
  
  if qty > 1
    message = _INTL("There are {1} \\c[1]{2}\\c[0]!\nWant to pick them?", qty, berry_name)
  else
    message = _INTL("There is 1 \\c[1]{1}\\c[0]!\nWant to pick it?", berry_name)
  end
  
  
  
  message = _INTL("Do you want to knock down this Tree?", berry_name) if berry.id == :ACORN || berry.id == :APPLE
  return false if !pbConfirmMessage(message)
  pbMessage(_INTL("Oh! There are some odd berries mixed in! It seems to be some {1}!", mut_berry_name)) if !mutation_info.nil?
   
   
  if !mutation_info.nil?
  if !$bag.can_add?(berry, qty)  || !$bag.can_add?(mut_berry, mut_berry_qty)
    pbMessage(_INTL("Too bad...\nThe Bag is full..."))
    return false
  end
  else
  if !$bag.can_add?(berry, qty)
    pbMessage(_INTL("Too bad...\nThe Bag is full..."))
    return false
  end
  end
  
  
  
    $stats.berry_plants_picked += 1
    $stats.mutated_berries_picked ||= 0
    $stats.mutated_berries_picked += mut_berry_qty
  
  
  
    if qty + mut_berry_qty >= GameData::BerryPlant.get(berry.id).maximum_yield
      $stats.max_yield_berry_plants += 1
    end









  $bag.add(berry, qty)
  $bag.add(mut_berry, mut_berry_qty) if !mutation_info.nil?



if true
      axe = nil
    if hasAxe? == true
	  axe2 = getAxe
     if axe2!=false || 
      axe = GameData::Item.get(axe2)
      axe.decreaseDurability(1)
     end
	 end
	 
	 show_log = false
	 show_log = true if !axe.nil? || berry.id == :ACORN || berry.id == :APPLE
    wooden_log_amt = ((rand(4))+((qty/4).to_i))
	wooden_log_amt = (wooden_log_amt < 1) ? 1 : wooden_log_amt
    wooden_log = (wooden_log_amt > 1) ? GameData::Item.get(:WOODENLOG).name_plural : GameData::Item.get(:WOODENLOG).name
	berry_name = "Trees" if berry.id == :ACORN
	berry_name = "Tree" if berry.id == :ACORN  && berry == 1
	berry_name = "Apple Trees" if berry.id == :APPLE
	berry_name = "Apple Tree" if berry.id == :APPLE && berry == 1
	berry_name_extra = ""
	berry_name_extra = "" if berry.id == :ACORN || berry.id == :APPLE
	if !mutation_info.nil?
	mut_berry_name = "Trees" if mut_berry.id == :ACORN 
	mut_berry_name = "Tree" if mut_berry.id == :ACORN && mut_berry_qty == 1
	mut_berry_name = "Apple Trees" if mut_berry.id == :APPLE
	mut_berry_name = "Apple Tree" if mut_berry.id == :APPLE && mut_berry_qty == 1
	berry_name_extra2 = "" 
	berry_name_extra2 = "" if (mut_berry.id == :ACORN || mut_berry.id == :APPLE)
	end

    message = "\\me[Berry get]\\PN "
    message += "knocked down the" if show_log == true
    message += "picked the" if show_log == false
	 message += " #{qty}" if qty > 1 && !(berry.id == :ACORN || berry.id == :APPLE)
    message += " \\c[1]#{berry_name}\\c[0]#{berry_name_extra}"
	 message += ", and also picked the #{mut_berry_name}#{berry_name_extra2}" if (!mutation_info.nil? && show_log == false) && mut_berry_qty == 1
	 message += ", and also picked the #{mut_berry_qty} #{mut_berry_name}  #{berry_name_extra2}" if (!mutation_info.nil? && show_log == false) && mut_berry_qty > 1
	 
	 message += ", obtained a #{mut_berry_name}#{berry_name_extra2}, and got a #{wooden_log}" if !mutation_info.nil? && show_log == true && mut_berry_qty == 1 && wooden_log_amt==1
	 message += ", obtained a #{mut_berry_name}#{berry_name_extra2}, and got #{wooden_log_amt} #{wooden_log}" if !mutation_info.nil? && show_log == true && mut_berry_qty == 1 && wooden_log_amt>1
	 message += ", obtained #{mut_berry_qty} #{mut_berry_name}#{berry_name_extra2}, and got a #{wooden_log}" if !mutation_info.nil? && show_log == true && mut_berry_qty > 1 && wooden_log_amt==1
	 message += ", obtained #{mut_berry_qty} #{mut_berry_name}#{berry_name_extra2}, and got #{wooden_log_amt} #{wooden_log}" if !mutation_info.nil? && show_log == true && mut_berry_qty > 1 && wooden_log_amt>1
	 
	 message += ", and got a #{wooden_log}" if mutation_info.nil? && show_log == true && wooden_log_amt==1
	 message += ", and got #{wooden_log_amt} #{wooden_log}" if mutation_info.nil? && show_log == true && wooden_log_amt>1
	 message += "."
	 pbMessage((message))
end
    if pbShowBerryMessage
    pocket = berry.pocket
    pbMessage(_INTL("{1} put the berries in the <icon=bagPocket{2}>\\c[1]{3}\\c[0] Pocket.\1", $player.name, pocket, PokemonBag.pocket_names[pocket - 1]))

    end
	
    if !$bag.can_add?(:WOODENLOG, wooden_log_amt) && show_log==true
    pbMessage(_INTL("You lost the logs... The Bag is full..."))
	else
	$bag.add(:WOODENLOG, wooden_log_amt) if show_log==true
	if show_log==true && pbShowBerryMessage
    pocket = :WOODENLOG.pocket
    pbMessage(_INTL("{1} put the berries in the <icon=bagPocket{2}>\\c[1]{3}\\c[0] Pocket.\1", $player.name, pocket, PokemonBag.pocket_names[pocket - 1]))
	end 
    end
	berry_plant.persistent = false if berry_plant.persistent.nil?
    berry_plant.persistent = true if Settings::BERRY_PERSISTENT_PLANT_CHANCE > 0 && berry_plant && berry_plant.replant_count < GameData::BerryPlant::NUMBER_OF_REPLANTS && 
            rand(100) < Settings::BERRY_PERSISTENT_PLANT_CHANCE
    if berry_plant&.persistent==false
    
	
	
   confirmmessage = "Do you want to replant #{berry_name}?" if mutation_info.nil?
   confirmmessage = "Do you want to replant one of the crops?" if !mutation_info.nil?





  if pbConfirmMessage(_INTL(confirmmessage))
    if !mutation_info.nil?
       commands=[]
       commands.push(_INTL"#{berry_name}")
       commands.push(_INTL("#{mut_berry_name}")) 
     commandMail = pbMessage(_INTL("Which crops do you want to replant?"),commands, -1)
     if commandMail == 0
	 
	 
	 
	 
  if $bag.remove(berry)
  $stats.berries_planted += 1
  pbSetSelfSwitch(this_event.id, "A", true)  
  berry_plant.event           = this_event if berry_plant.event.nil?
  berry_plant.plant(berry)
  if pbShowBerryMessage
  if GameData::Item.get(berry).name.starts_with_vowel?
    pbMessage(_INTL("{1} planted an {2} in the soft, loamy soil.",
                        $player.name, GameData::Item.get(berry).name))
  else
        pbMessage(_INTL("{1} planted a {2} in the soft, loamy soil.",
                        $player.name, GameData::Item.get(berry).name))
  end
  end
  return false
  else
  pbMessage(_INTL("You don't have enough {1}.", berry_name))
  pbMessage(_INTL("The soil returned to its soft, and loamy state.")) if pbShowBerryMessage
  pbSetSelfSwitch(this_event.id, "A", true)  
  return true
  end
 
 
 
 
 
     else
	 
	 
	 
  if $bag.remove(mut_berry)
  $stats.berries_planted += 1
  pbSetSelfSwitch(this_event.id, "A", true)  
  berry_plant.event           = this_event if berry_plant.event.nil?
  berry_plant.plant(mut_berry)
  if pbShowBerryMessage
  if GameData::Item.get(mut_berry).name.starts_with_vowel?
    pbMessage(_INTL("{1} planted an {2} in the soft, loamy soil.",
                        $player.name, GameData::Item.get(mut_berry).name))
  else
        pbMessage(_INTL("{1} planted a {2} in the soft, loamy soil.",
                        $player.name, GameData::Item.get(mut_berry).name))
  end
  end
  return false
  else
  pbMessage(_INTL("You don't have enough {1}.", berry_name))
  pbMessage(_INTL("The soil returned to its soft, and loamy state.")) if pbShowBerryMessage
  pbSetSelfSwitch(this_event.id, "A", true)  
  return true
  end
 
 
 
 
	  end
	 
	 
	 
	 else
  if $bag.remove(berry)
  $stats.berries_planted += 1
  pbSetSelfSwitch(this_event.id, "A", true)  
  berry_plant.event           = this_event if berry_plant.event.nil?
  berry_plant.plant(berry)
  if pbShowBerryMessage
  if GameData::Item.get(berry).name.starts_with_vowel?
    pbMessage(_INTL("{1} planted an {2} in the soft, loamy soil.",
                        $player.name, GameData::Item.get(berry).name))
  else
        pbMessage(_INTL("{1} planted a {2} in the soft, loamy soil.",
                        $player.name, GameData::Item.get(berry).name))
  end
  end
  return false
  else
  pbMessage(_INTL("You don't have enough {1}.", berry_name))
  pbMessage(_INTL("The soil returned to its soft, and loamy state.")) if pbShowBerryMessage
  pbSetSelfSwitch(this_event.id, "A", true)  
  return true
  end
 
     end
  else
  pbMessage(_INTL("The soil returned to its soft, and loamy state.")) if pbShowBerryMessage
  pbSetSelfSwitch(this_event.id, "A", true)  
  return true
  end
   else
    if pbShowBerryMessage
			pbMessage(_INTL("The {1} plant seems to have survived you picking it!", berry_name))
	end
  berry_plant.event           = this_event if berry_plant.event.nil?
  berry_plant.plant(berry)
    return false
end
    
   
end


class PokemonGlobalMetadata
    attr_accessor :berry_plant_mutation_parents
    attr_accessor :maps_first_setups
    attr_accessor :watering_can_levels
    attr_accessor :tool_durability
    attr_accessor :tile_data

    alias tdw_berry_plant_global_init initialize
    def initialize
        tdw_berry_plant_global_init
        compilePlantMutationParents
        @maps_first_setups = {}
        @tile_data = {}
    end




	 
	def tile_data
	@tile_data = {} if @tile_data.nil?
	return @tile_data
	end





    def compilePlantMutationParents
        @berry_plant_mutation_parents = []
        Settings::BERRY_MUTATION_POSSIBILITIES.each { |key| 
            @berry_plant_mutation_parents.push(key[0][0]) if !@berry_plant_mutation_parents.include?(key[0][0])
            @berry_plant_mutation_parents.push(key[0][1]) if !@berry_plant_mutation_parents.include?(key[0][1])
        }
    end


    def initializeWateringCanLevels
        @watering_can_levels = {}
        GameData::BerryPlant::WATERING_CANS.each do |item|
            @watering_can_levels[item] = pbGetWateringCanMax(item)
        end
    end

    def initializeToolDurability
        @tool_durability = {}
        GameData::Item::TOOLS.each do |item|
            @tool_durability[item] = pbGetDurabilityMax(item)
        end
    end

end




module GameData
  class BerryPlant
    attr_reader :id
    attr_reader :hours_per_stage
    attr_reader :drying_per_hour
    attr_reader :yield
    attr_reader :climate
    attr_reader :season
    attr_reader :weather
    attr_reader :flavor

    DATA = {}
    DATA_FILENAME = "berry_plants.dat"

    SCHEMA = {
      "HoursPerStage" => [:hours_per_stage, "v"],
      "DryingPerHour" => [:drying_per_hour, "u"],
      "Yield"         => [:yield,           "uv"],
      "Season"       => [:season,         "u"],
      "Climate"       => [:climate,         "s"],
      "Weather"       => [:weather,         "e",:Weather],
      "Flavor"       => [:flavor,         "uuuuu"]
    }

    NUMBER_OF_REPLANTS           = 9
    NUMBER_OF_GROWTH_STAGES      = 4
    NUMBER_OF_FULLY_GROWN_STAGES = 4
    WATERING_CANS                = [:SPRAYDUCK, :SQUIRTBOTTLE, :WAILMERPAIL, :SPRINKLOTAD, :WOODENPAIL]

    extend ClassMethodsSymbols
    include InstanceMethods

    def initialize(hash)
      @id                = hash[:id]
      @hours_per_stage    = hash[:hours_per_stage]    || 3
      @drying_per_hour    = hash[:drying_per_hour]    || 15
      @yield             = hash[:yield]             || [2, 5]
      @yield.reverse! if @yield[1] < @yield[0]
      @season            = hash[:season]            || 0
      @climate           = hash[:climate]           || "Temperate"
      @weather           = hash[:weather]           || :None
      @flavor           = hash[:flavor]           || [0,0,0,0,0]
    end

    def minimum_yield
      return @yield[0]
    end
    def min_yield
      return @yield[0]
    end

    def maximum_yield
      return @yield[1]
    end
	
    def max_yield
      return @yield[1]
    end
	def weather
	 return @weather.to_sym
	end
  end
	def flavor
	 return @flavor
	end
end

#===============================================================================
# Represents a planted berry. Stored in $PokemonGlobal.eventvars.
#===============================================================================

module Settings
        BERRY_MUTATION_POSSIBILITIES        = {
            [:ORANBERRY,:PECHABERRY]    => [:SITRUSBERRY],

			
            [:SEEDOFMASTERY,:PURPLEAPRICORN]  => [:ENIGMABERRY],
			
			
			
			
            [:ACORN,:ACORN]               => [:APPLE],
            [:APPLE,:APPLE]               => [:BAIT],
            [:ACORN,:APPLE]               => [:APPLE],
            [:BAIT,:APPLE]               => [:BAIT],
			
			
			
			
			
			
            [:ACORN,:ORANBERRY]           => [:REDAPRICORN],
            [:ACORN,:REDAPRICORN]         => [:ORANBERRY],
            [:REDAPRICORN,:ORANBERRY]         => [:ACORN],
			
			
			
			
			
            [:PSYCHICSEED,:MISTYSEED]  => [:MIRACLESEED],
            [:ELECTRICSEED,:GRASSYSEED]  => [:PURESEED],
            [:MIRACLESEED,:PURESEED]  => [:SEEDOFMASTERY],
			
			
			
			
			
            [:REDAPRICORN,:ORANBERRY]     => [:BLUEAPRICORN],
            [:BLUEAPRICORN,:SITRUSBERRY]  => [:GREENAPRICORN],
            [:GREENAPRICORN,:APICOTBERRY]  => [:BLACKAPRICORN],
            [:BLACKAPRICORN,:SEEDOFMASTERY]  => [:PURPLEAPRICORN],
			
			
			
			
			
            [:ARGOSTBERRY,:WHITEHERB]  => [:REVIVALHERB],
            [:SITRUSBERRY,:ENERGYROOT]  => [:ARGOSTBERRY],
            [:TINYMUSHROOM,:TINYMUSHROOM]  => [:BIGMUSHROOM],
            [:BIGMUSHROOM,:BALMMUSHROOM]  => [:MAXMUSHROOMS],
            [:TINYMUSHROOM,:PURESEED]  => [:BALMMUSHROOM]
			
			
			
			
			
        }

        #--------------------------------------------------------------------------------
        # List of Mulch items that will impact the chance of berry mutations occuring
        # Format: ITEM_ID => CHANCE
        # ITEM_ID   => Item ID of the Mulch
        # CHANCE    => Chance out of 100 mutated berries will appear when the mulch is 
        #              used
        #--------------------------------------------------------------------------------		
		
        BERRY_MULCHES_IMPACTING_MUTATIONS    = {
            :SURPRISEMULCH  => 50,
            :AMAZEMULCH     => 50
        }


        #--------------------------------------------------------------------------------
        # Base chance out of 100 that berry mutation will occur without mulch influence.
        #--------------------------------------------------------------------------------	

        BERRY_BASE_MUTATION_CHANCE          = 10
        #--------------------------------------------------------------------------------
        # If berry mutations occur, how many of the original berries will be replaced by
        # mutations. The number of mutations will never completely overtake the original
        # berries. Examples:
        # - BERRY_MUTATION_COUNT is set to 1, but the plant will only produce 1 berry.
        #   The plant will only produce 1 original berry and no mutated berry.
        # - BERRY_MUTATION_COUNT is set to 2, but the plant will only produce 2 berries.
        #   The plant will produce 1 original berry and 1 mutated berry.
        # - BERRY_MUTATION_COUNT is set to 1, and the plant will produce 5 berries.
        #   The plant will produce 4 original berries and 1 mutated berry.
        #--------------------------------------------------------------------------------	
        BERRY_MUTATION_COUNT                = 1
		
		
		
		
        BERRY_PLANT_BLOOMING_COMMENT        = _INTL("There is something unique about it...")


    #====================================================================================
    #============================== Propagation Settings ================================
    #====================================================================================
    # Berry propagation can occur when a berry plant replants itself. Instead of just
    # replanting on its own spot, it can also plant one of its berries that "dropped" 
    # in a plantable spot next to it. As far as I know, this is not a mechanic available
    # in mainline Pokemon games.

        #--------------------------------------------------------------------------------
        # List of Mulch items that will impact the chance of berry propagation occuring
        # on an empty berry spot nearby. The mulch must be put on the empty spot, not the
        # parent berry plant's spot.
        # Format: ITEM_ID => CHANCE
        # ITEM_ID   => Item ID of the Mulch
        # CHANCE    => Chance out of 1000 berries from nearby replanting plants get
        #              planted on the spot the mulch is.
        #--------------------------------------------------------------------------------	
        BERRY_MULCHES_IMPACTING_PROPAGATION    = {
            :ALLUREMULCH  => 100
        }
		
		
        #--------------------------------------------------------------------------------
        # Base chance out of 1000 that berry propagation will occur on an empty berry
        # spot when a plant replants itself. Since propagation should be a rare 
        # occurance, it's out of 1000 to allow smaller chances.
        #--------------------------------------------------------------------------------	
        BERRY_BASE_PROPAGATION_CHANCE          = 5
    
	    BERRY_PERSISTENT_PLANT_CHANCE = 1
	
	
        BERRY_JUST_MULCH_GRAPHIC            = "berrytreewet"
        BERRY_PREFERRED_WEATHER_YIELD       = 2
		
		
		
		        #--------------------------------------------------------------------------------
        # If true, the player must fill up watering cans to use them.
        #--------------------------------------------------------------------------------	
        BERRY_WATERING_MUST_FILL            = true

        #--------------------------------------------------------------------------------
        # If BERRY_WATERING_MUST_FILL is true, set how many times a watering can can be
        # used to water berry plants before becoming empty.
        #--------------------------------------------------------------------------------	
        BERRY_WATERING_USES_BEFORE_EMPTY    = 8

        #--------------------------------------------------------------------------------
        # List of watering can items that have different number of times they can be used 
        # to water berry plants before becoming empty than what's set in 
        # BERRY_WATERING_USES_BEFORE_EMPTY.
        # Format: ITEM_ID => TIMES
        # ITEM_ID   => Item ID of the Watering can
        # TIMES     => Positive integer representing the number of times the item can be
        #              used before becoming empty.
        #--------------------------------------------------------------------------------	
        BERRY_WATERING_USES_OVERRIDES = {
            # :SPRAYDUCK      => 10,
            # :SPRINKLOTAD    => 20
        }



        DURABILITY    = 50

        #--------------------------------------------------------------------------------
        # List of watering can items that have different number of times they can be used 
        # to water berry plants before becoming empty than what's set in 
        # BERRY_WATERING_USES_BEFORE_EMPTY.
        # Format: ITEM_ID => TIMES
        # ITEM_ID   => Item ID of the Watering can
        # TIMES     => Positive integer representing the number of times the item can be
        #              used before becoming empty.
        #--------------------------------------------------------------------------------	
        DURABILITY_OVERRIDES = {
            # :SPRAYDUCK      => 10,
            # :SPRINKLOTAD    => 20
        }



end



class BerryTileData
  attr_accessor :tile_x 
  attr_accessor :tile_y 
  attr_accessor :tile_map
  attr_accessor :overall_soil_quality 
  attr_accessor :beside_water 
  attr_accessor :planted_crops_array 
  attr_accessor :waterless_length 
  attr_accessor :soil_dryness 
  attr_accessor :cropsticks 


  def initialize(x,y)
    #SOIL QUALITY GOES FROM 0-4, 0 is worst, 4 is best
	 @tile_x = x
	 @tile_y = y
	 @tile_map = $game_map.map_id
     @overall_soil_quality = 4.0
	 #A plant will only grow if water is available.
	 @beside_water = true
	 #The tile will remember 
	 @planted_crops_array = FixedSizeArray.new(10)
	 @soil_dryness = 0
	 @waterless_length = 0
	 @cropsticks = false
	 $PokemonGlobal.tile_data[[@tile_map,@tile_x,@tile_y]] = self
  end
  
  def add_berry_to_array(berry)
	 @planted_crops_array.add(berry)
  end
  
  def update(berry_id)
    quality =  @overall_soil_quality
    update_dryness(berry_id)
    update_quality(quality)
  
  end
  
  def update_quality(quality)
   change_qual = 0
   soil_effect = 0
    case @soil_dryness
	   when 3
	     soil_effect = 0.5
	   when 4
	     soil_effect = 1
	   when 5
	     soil_effect = 2
	   when 0
	     soul_effect = -2
	   when 1
	     soul_effect = -1
	   else
         soil_effect = 0
	end
	
	 change_qual = change_qual.to_i
	 change_qual -= soul_effect.to_i
	 
     change_qual -= @waterless_length.to_f
	 quality += change_qual.to_i
	 quality = 0 if quality<0
  
  end
 
 def update_dryness(berry_id)
   if !berry_id.nil?
   @soil_dryness = 0
   @soil_dryness += (@planted_crops_array.how_many?(berry_id,(@planted_crops_array.length/2)))
   elsif berry_id.nil?
    amt = @soil_dryness-=1
   @soil_dryness = [0,amt].max
   
   end
 end
 
end


class BerryPlantData
  attr_accessor :event
  attr_accessor :tile_data
  attr_accessor :berry_obj
  attr_accessor :berry_id
  attr_accessor :mulch_id             # Gen 4 mechanics
  attr_accessor :time_alive
  attr_accessor :time_last_updated
  attr_accessor :growth_stage
  attr_accessor :last_berry
  attr_accessor :last_berry_qual
  attr_accessor :replant_count
  attr_accessor :watered_this_stage   # Gen 3 mechanics
  attr_accessor :watering_count       # Gen 3 mechanics
  attr_accessor :moisture_level       # Gen 4 mechanics
  attr_accessor :yield_penalty        # Gen 4 mechanics
  attr_accessor :checkedcropsticks        # Gen 4 mechanics
  attr_accessor :grabbedsticks        # Gen 4 mechanics
  attr_accessor :needtoshovel        # Gen 4 mechanics
  attr_accessor :timewithoutberry        # Gen 4 mechanics
  attr_accessor :times_in_each_moist       # Gen 3 mechanics
  attr_accessor :not_watered_count       # Gen 4 mechanics
  attr_accessor :quality       # Gen 4 mechanics
  attr_accessor :mutated_berry_tried
  attr_accessor :mutated_berry_info
  attr_accessor :preferred_weather
  attr_accessor :preferred_season
  attr_accessor :exposed_to_preferred_weather
  attr_accessor :weeds
  attr_accessor :weeds_timer
  attr_accessor :pests
  attr_accessor :pests_timer
  attr_accessor :persistent
  attr_accessor :bitten
  attr_accessor :stoppedbitting
  attr_accessor :weedsamt
  attr_accessor :pulledweeds
  attr_accessor :dead
  attr_accessor :time_in_stage
  attr_accessor :centered
  attr_accessor :exposed_to_rain
  attr_accessor :time_rain_last_updated
  attr_accessor :time_tile_last_updated
  attr_accessor :jit
  attr_accessor :stagnation_message

	
  def initialize(event = nil)
     @event = event if !event.nil?
     @event = pbMapInterpreter.get_self if @event.nil?
	 @tile_data = BerryTileData.new(@event.x,@event.y)
	 @centered = false
	 @jit = false
	 @centered = true if @event.name.include?("center") if !event.nil?
    @moisture_level     = 100
    reset
  end
  def cropsticks 
    return @tile_data.cropsticks
  end
  
  
  def reset(planting = false)
	@berry_obj           = nil
    @berry_id           = nil
    @mulch_id           = nil if !planting
    @time_alive         = 0
    @time_last_updated  = 0
    @growth_stage       = 0
    @replant_count      = 0
    @quality            = 0
    @watered_this_stage = false
    @watering_count     = 0
    @not_watered_count     = 0
    @times_in_each_moist     = [0,0,0,0]
    @yield_penalty      = 0
    @checkedcropsticks  = false
    @grabbedsticks      = false
    @needtoshovel       = false
    @timewithoutberry       = 0
    @mutated_berry_tried = false
    @mutated_berry_info = nil
    @weeds = false
    @weeds_timer = nil
    @pests = false
    @pests_timer = nil
    @persistent = nil
    @bitten = 0
    @stoppedbitting = 0
    @weedsamt = 0
    @pulledweeds = 0
    @preferred_weather = nil
    @preferred_season = nil
    @exposed_to_preferred_weather = false
    @watering_cans_used = []
	@time_in_stage = 0
	@dead = false
	@time_rain_last_updated = pbGetTimeNow.to_i
	@time_tile_last_updated = pbGetTimeNow.to_i
    @exposed_to_rain = false
    @stagnation_message = false
  end

  def plant(berry_id)
    reset(true)
	 @berry_obj = berry_id
    @berry_id          = @berry_obj.id
    @tile_data.add_berry_to_array(@berry_id)
    @growth_stage      = 1
    @time_last_updated = pbGetTimeNow.to_i
    @timewithoutberry       = 0
    @preferred_weather = GameData::BerryPlant.get(@berry_id).weather
    @preferred_season = @berry_obj.season
	@time_in_stage = 0
    @weeds = false
    @weeds_timer = pbGetTimeNow.to_i
    @pests = false
    @pests_timer = pbGetTimeNow.to_i
	@time_rain_last_updated = pbGetTimeNow.to_i
  end

  def replant
    propagate if cropsticks == true
    @time_alive         = 0
    @growth_stage       = 0
    @replant_count      += 1
    @watered_this_stage = false
    @watering_count     = 0
  end
  
   def get_hours_per_stage(plant_data)
     hours = plant_data.hours_per_stage
	  hours -= rand(2)+1 if $player.is_it_this_class?(:GARDENER,false)
     return [hours,1].max
   end   
  
   def mulchly_actions(tps,dph,mr,sfg)
       case @mulch_id
         when :GROWTHMULCH
            tps = (tps * 0.75).to_i
            dph = (dph * 1.5).ceil
         when :DAMPMULCH
            tps = (tps * 1.25).to_i
            dph /= 2
         when :GOOEYMULCH
            mr = (mr * 1.5).ceil
         when :STABLEMULCH
            sfg = (sfg * 1.5).ceil
         when :GROWTHMULCH2
            tps = (tps * 0.50).to_i
            dph = (dph * 1.5).ceil
         when :DAMPMULCH2
            tps = (tps * 1.50).to_i
            dph /= 2
         when :GOOEYMULCH2
            mr = (mr * 1.75).ceil
         when :STABLEMULCH2
            sfg = (sfg * 3).ceil
         end
     return tps,dph,mr,sfg
   end
   

   
   
   
  def berry_plant_growth_modifications(tps,dph,mr,sfg)
     plant_data = GameData::BerryPlant.get(@berry_id)
     berry_season = @preferred_season || plant_data.season
     berry_climate = plant_data.climate
     berry_weather = plant_data.weather
	 
	 tps -= overall_soil_quality * 1800 if overall_soil_quality > 2
	 tps += overall_soil_quality * 1800 if overall_soil_quality < 2
	 
	 
     tps,dph,mr,sfg = mulchly_actions(tps,dph,mr,sfg)
     if !$game_map.name.include?(berry_climate)
		  tps = (tps * 1.75).ceil
         sfg += 1
     end

		if pbGetSeason == berry_season
		  tps = (tps * 0.75).ceil
		elsif pbGetSeason == (berry_season.to_i+1).to_i || pbGetSeason == (berry_season.to_i-3).to_i
		  tps = (tps * 0.999).ceil
		elsif pbGetSeason == (berry_season.to_i+2).to_i || pbGetSeason == (berry_season.to_i-4).to_i
		  tps = (tps * 1.25).ceil
		elsif pbGetSeason == (berry_season.to_i+3).to_i || pbGetSeason == (berry_season.to_i-5).to_i
		  tps = (tps * 1.5).ceil
         sfg += 1
		end


  
     return tps,dph,mr,sfg
  end
  
  def detriment_effects(time_now)
  
  

        if @event && @weeds_timer && !@weeds && @growth_stage > 1 && cropsticks==true
            weed_delta = time_now.to_i - @weeds_timer
            time_for_checks = 4 * 3600
            rolls = (weed_delta / time_for_checks).floor
			 rolls-=1
			 if rolls>0
            rolls.times do 
                @weeds = true if rand(100) < getWeedGrowthChance
                @weeds_timer += time_for_checks
                break if @weeds
            end   
			 end
        end
        #Pests
        if @event && @pests_timer && cropsticks==true
            if !@pests && @growth_stage > 2
                pests_delta = time_now.to_i - @pests_timer
                time_for_checks = 8 * 3600
                rolls = (pests_delta / time_for_checks).floor
			     rolls-=1
			     if rolls>0
                rolls.times do 
                    @pests = true if rand(100) < getPestAppearChance
                    @pests_timer += time_for_checks
                    break if @pests
                end  
			     end
            end
            @event.move_speed = @pests ? 6 : 3
            $game_map.events[@event.id].move_speed = @event.move_speed if $game_map.map_id == @event.map_id
        end


  
  
  
  
  end
  
  def is_raining?
    zone = pbGetZone(@event.map_id)
    weather = $WeatherSystem.nextWeather[zone].mainWeather
    return true if weather == :Rain || weather == :HeavyRain
	return false
  end 
  def rain_type
    return GameData::Weather.get($game_screen.weather_type).category
  end

  def growth_stalled?
   return @exposed_to_rain == false && @tile_data.beside_water == false && @growth_stage >= 2 && @watered_this_stage == false
  end


  def update
   $ExtraEvents.berry_plants[[@event.map_id,@event.id]] = StoredEvent.new(@event.map_id,event,:BERRYPLANT) if $ExtraEvents.berry_plants[[@event.map_id,@event.id]].nil?
	 @tile_data = BerryTileData.new(@event.x,@event.y) if @tile_data.nil?
    @exposed_to_rain = false if @exposed_to_rain.nil?
    @jit = false if @jit.nil?
    @stagnation_message = false if @stagnation_message.nil?
	 time_now = pbGetTimeNow
	 @time_tile_last_updated ||= time_now.to_i
	 tile_delta = time_now.to_i - @time_tile_last_updated
	 
    if tile_delta > 600
	   @tile_data.update(@berry_id)
		@time_rain_last_updated = time_now.to_i
    end
    return if !planted?
    
	 @time_rain_last_updated ||= time_now.to_i
	 rain_delta = time_now.to_i - @time_rain_last_updated
    if is_raining? && rain_delta > 60
	        water(1.5,true) if rain_type == :Rain
	        water(2.5, true) if rain_type == :HeavyRain
			 @exposed_to_rain = true
			@time_rain_last_updated = time_now.to_i
    end
	
    time_delta = time_now.to_i - @time_last_updated
    return if time_delta <= 0
    plant_data = GameData::BerryPlant.get(@berry_id)
    new_time_alive = @time_alive + time_delta
	 
    max_yield = plant_data.maximum_yield
    min_yield = plant_data.minimum_yield



	hours_per_stage = get_hours_per_stage(plant_data)
    tps = hours_per_stage * 3600   # In seconds


    dph = plant_data.drying_per_hour
    mr = GameData::BerryPlant::NUMBER_OF_REPLANTS
    stages_growing = 4
    sfg = GameData::BerryPlant::NUMBER_OF_FULLY_GROWN_STAGES
    berry_season = @preferred_season || plant_data.season
	
    tps,dph,mr,sfg = berry_plant_growth_modifications(tps,dph,mr,sfg)
		
	
    old_growth_stage = @growth_stage
    old_time_alive = @time_alive
	@time_in_stage ||= 0
    @time_in_stage += time_delta
	


    done_replant = false
	@weeds_timer||=0
	@pests_timer||=0 
	
	
	
	
	
	
	
    loop do
      stages_this_life = stages_growing + sfg - (replanted? ? 1 : 0)
      break if new_time_alive < stages_this_life * tps
	  
	  
      if @replant_count >= mr || (growth_stalled? && @tile_data.waterless_length>=6) || overall_soil_quality==0
        @dead = true
        return
      end
	  
	  
      replant
      done_replant = true
      new_time_alive -= stages_this_life * tps
	  
	  
	  
	  
	  
    end


	  detriment_effects(time_now)










    # Update how long plant has been alive for

    @time_alive = new_time_alive
    @growth_stage = 1 + (@time_alive / tps)
	if growth_stalled?
     @growth_stage = 2 
	 @tile_data.waterless_length+=1
	end
    @time_last_updated = time_now.to_i
	  
      @weeds_timer += tps*2 if @event && @weeds_timer && cropsticks==true && @growth_stage > old_growth_stage
      @pests_timer += tps*4 if @event && @pests_timer && cropsticks==true && @growth_stage > old_growth_stage && old_growth_stage >= 2
		
		
	
	
    old_growth_hour = (done_replant) ? 0 : (@time_alive - time_delta) / 3600
    new_growth_hour = @time_alive / 3600
    if new_growth_hour > old_growth_hour
	   moist
	   @bitten += 0.50 if @pests==true
       @weedsamt += 0.25 if @weeds==true
	    @checkedcropsticks = false
		@exposed_to_rain = false
        (new_growth_hour - old_growth_hour).times do
		   growth(berry_season,dph)
        end
    end




	@exposed_to_preferred_weather = true if checkPreferredWeather
    return if !planted? || !@event || @mutated_berry_tried || @growth_stage < 2
    checkNearbyPlantsForMutation
  end
  
  
  
  
  def growth(berry_season,drying_per_hour)

   if @moisture_level > 0
	  if pbGetSeason == berry_season
	        @moisture_level -= 1 if drying_per_hour-2 < 1
	        @moisture_level -= (drying_per_hour-2) if drying_per_hour-2 > -1
			
	  elsif pbGetSeason == (berry_season.to_i+1).to_i || pbGetSeason == (berry_season.to_i-3).to_i
	        @moisture_level -= drying_per_hour
			
	  elsif pbGetSeason == (berry_season.to_i+2).to_i || pbGetSeason == (berry_season.to_i-4).to_i
	        @moisture_level -= (drying_per_hour+1)
			
	  elsif pbGetSeason == (berry_season.to_i+3).to_i || pbGetSeason == (berry_season.to_i-5).to_i
	        @moisture_level -= (drying_per_hour+3)
	  else
	        @moisture_level -= drying_per_hour
	  end
	  return
	end
   @yield_penalty += 1
  end





end
















class BerryPlantData
   
    def soil_dryness
	 @tile_data = BerryTileData.new(@event.x,@event.y) if @tile_data.nil?
	  return @tile_data.soil_dryness
	end
    def overall_soil_quality
	 @tile_data = BerryTileData.new(@event.x,@event.y) if @tile_data.nil?
	  return @tile_data.overall_soil_quality
	end
    def planted_crops_array
	 @tile_data = BerryTileData.new(@event.x,@event.y) if @tile_data.nil?
	  return @tile_data.planted_crops_array.to_a
	end
    def add_berry_to_array(berry)
	 @tile_data = BerryTileData.new(@event.x,@event.y) if @tile_data.nil?
	  return @tile_data.add_berry_to_array(berry)
	end
    def beside_water
	 @tile_data = BerryTileData.new(@event.x,@event.y) if @tile_data.nil?
	  return @tile_data.beside_water
	end
    def beside_water=(value)
	 @tile_data = BerryTileData.new(@event.x,@event.y) if @tile_data.nil?
	  @tile_data.beside_water=value
	end


    def getWeedGrowthChance
        return 0 unless cropsticks==true
        weeds_chance =  15
        #weeds_chance += getWateringCansUsedTraits(:weed_chance) if @event
        return weeds_chance
    end

    def getPestAppearChance
        pests_chance =  1
        return pests_chance
    end


    def pullWeeds
        @weeds = false
        @weeds_timer = pbGetTimeNow.to_i
	    @pulledweeds+=1
        $stats.berry_weeds_pulled ||= 0
        $stats.berry_weeds_pulled += 1
    end


    def getWateringCansUsedTraits(trait_sym)
        return 0 if !@watering_cans_used || @watering_cans_used.empty?
        ret = 0
        @watering_cans_used.each do |can|
            next if !Settings::BERRY_WATERING_CAN_TRAITS[can]
            traits = Settings::BERRY_WATERING_CAN_TRAIT_DEFINITIONS[Settings::BERRY_WATERING_CAN_TRAITS[can]]
            next if !traits
            ret += traits[trait_sym] || 0
        end
        return ret
    end



  def planted?
    return @growth_stage > 0
  end

  def growing?
    return @growth_stage > 0 && @growth_stage < 5
  end

  def grown?
    return @growth_stage >= 5
  end

  def replanted?
    return @replant_count > 0
  end

  def moisture_stage
	return 3 if @moisture_level >= 100
    return 2 if @moisture_level > 50
    return 1 if @moisture_level > 0
    return 0
  end


  def berry_yield
    data = GameData::BerryPlant.get(@berry_id)
    min_yield = data.minimum_yield
	max_yield = data.max_yield 
	 case @mulch_id
      when :PRODUCEMULCH
        min_yield+=(rand(2)+2)
      when :POTENTIALMULCH
        max_yield+=(rand(2)+2)
      when :PRODUCEMULCH2
        min_yield+=(rand(2)+4)
      when :POTENTIALMULCH2
        max_yield+=(rand(2)+4)
	 end
	 @weedsamt = 0 if @weedsamt.nil?
	 @pulledweeds = 0 if @pulledweeds.nil?
	 @bitten = 0 if @bitten.nil?
	 @stoppedbitting = 0 if @stoppedbitting.nil?
	 amt1 = (@weedsamt-@pulledweeds)
	 amt2 = (@bitten-@stoppedbitting).ceil
	 if min_yield-amt1 < 0
	   amt1=min_yield
	 end
	 if max_yield-amt2 < 0
	   amt2=max_yield
	 end
	 min_yield -= amt1
	 max_yield -= amt2
	 
	 
	 get_penalties
     ret =  [(max_yield * (5 + @yield_penalty) / 5), max_yield].max
	 @exposed_to_preferred_weather=false if @exposed_to_preferred_weather.nil?
     ret += Settings::BERRY_PREFERRED_WEATHER_YIELD if @exposed_to_preferred_weather
     ret += 2 if @mulch_id == :RICHMULCH
	 if ret > max_yield
	   ret = max_yield
	 end 
	 if ret < min_yield
	   ret = min_yield
	 end 
	 
    return ret
	
  end





  def climates
    return ["Temperate Highlands","Forest","Plain","Ocean","Highlands","Marsh","Skies","Jungle","Cave","Temperate","Tropical","Frigid","Chilled","Northern","Western","Mountain","Ravine"]
  
  
  end


  def moist
    @times_in_each_moist[3]+=1 if @moisture_level == 0
    @times_in_each_moist[2]+=1 if @moisture_level > 0 && @moisture_level < 51
    @times_in_each_moist[1]+=1 if @moisture_level > 50 && @moisture_level < 100
    @times_in_each_moist[0]+=1 if @moisture_level >= 100
    
  end  


  def water(amt,rain=false)
    @moisture_level += amt
    if @watered_this_stage==false
      @watered_this_stage = true
      @watering_count += 1
    end
	@tile_data.waterless_length = 0 if rain==false
  end




    def propagate
        return if !@event
        propagation = []
        berry = @berry_id
        qty = berry_yield
        qty.times { propagation.push(berry) }
        if @mutation_info
            mut_berry = @mutation_info[0] 
            mut_berry_qty = @mutation_info[1]
            mut_berry_qty -= 1 while qty - mut_berry_qty < 1
            mut_berry_qty.times { propagation.push(mut_berry) }
        end
        checkNearbyPlantsForPropagation(propagation)
    end





    def pbGetNeighbors(position_array = nil, map = nil)
        position = position_array || [@event.map_id, @event.x, @event.y]
        map = map || $map_factory.getMap(position[0])
        neighbors = []
        neighbors[0] = $PokemonGlobal.eventvars[[position[0],map.check_event(position[1], position[2]-1)]]
        neighbors[1] = $PokemonGlobal.eventvars[[position[0],map.check_event(position[1]+1, position[2])]]
        neighbors[2] = $PokemonGlobal.eventvars[[position[0],map.check_event(position[1], position[2]+1)]]
        neighbors[3] = $PokemonGlobal.eventvars[[position[0],map.check_event(position[1]-1, position[2])]]
        return neighbors
    end



    def checkNearbyPlantsForMutation
        $PokemonGlobal.compilePlantMutationParents if !$PokemonGlobal.berry_plant_mutation_parents
        @mutated_berry_tried = true
		 return if cropsticks==false
        return if !@event || !$PokemonGlobal.berry_plant_mutation_parents.include?(@berry_id)
        mutation_chance = Settings::BERRY_MULCHES_IMPACTING_MUTATIONS[@mulch_id] || Settings::BERRY_BASE_MUTATION_CHANCE
        return if mutation_chance <= 0 || rand(100) >= mutation_chance
        #position = [@event.map_id, @event.x, @event.y]
        #map = $map_factory.getMap(position[0])
        neighbors = pbGetNeighbors
        possible = []
        neighbors.each do |data|
            next if data.nil? || !data.is_a?(BerryPlantData) || !data.planted?
            id = data.berry_id
            if Settings::BERRY_MUTATION_POSSIBILITIES[[@berry_id,id]]
                possible.concat(Settings::BERRY_MUTATION_POSSIBILITIES[[@berry_id,id]])
            elsif Settings::BERRY_MUTATION_POSSIBILITIES[[id,@berry_id]]
                possible.concat(Settings::BERRY_MUTATION_POSSIBILITIES[[id,@berry_id]])
            end
        end
		 mutated_berry = ItemData.new(possible.sample)
        @mutated_berry_info = [mutated_berry,Settings::BERRY_MUTATION_COUNT] if possible.length > 0
    end

    def checkNearbyPlantsForPropagation(dropped_berries)
        return if dropped_berries.nil? || dropped_berries.empty?
        neighbors = pbGetNeighbors
        neighbors.each do |data|
            next if data.nil? || !data.is_a?(BerryPlantData) || data.planted?
            mulch_id = data.mulch_id
            propagation_chance = Settings::BERRY_MULCHES_IMPACTING_PROPAGATION[mulch_id] || Settings::BERRY_BASE_PROPAGATION_CHANCE
            next if propagation_chance <= 0 || rand(1000) >= propagation_chance
            data.plant(dropped_berries.sample)
            $stats.berries_propagated ||= 0
            $stats.berries_propagated += 1
        end
    end




    def checkPreferredWeather
	     return false
        return true if @exposed_to_preferred_weather 
        return false if !@preferred_weather || @growth_stage <= 1 || @growth_stage >= 5 
        return true if $game_screen && @preferred_weather==$game_screen.weather_type
        return false
    end



  
  def get_penalties
   max_value =  @times_in_each_moist.max
   index_of_max = @times_in_each_moist.index(max_value)
     case index_of_max 
	   when 0
	     @yield_penalty+=(2 + @not_watered_count)
	   when 1
	      @yield_penalty+=(0 + @not_watered_count)
	   when 2
	     @yield_penalty+=(-2 + @not_watered_count)
	   when 3
	     @yield_penalty+=(-4 + @not_watered_count)
	  end
	  if @yield_penalty<0
	   @yield_penalty=0
	  end
end
  
  
  def get_quality
   max_value =  @times_in_each_moist.max
   index_of_max = @times_in_each_moist.index(max_value)
   lastberryinf=0
   lastberryinf= @last_berry_qual if !@last_berry.nil?
     case index_of_max 
	   when 0
	     @quality=4 + (@watering_count/2).to_i
	   when 1
	      @quality=2 + (@watering_count/2).to_i
	   when 2
	     @quality=-2 + (@watering_count/2).to_i
	   when 3
	     @quality=-4 + (@watering_count/2).to_i
	  end
	  if @quality<lastberryinf
	    @quality=lastberryinf
	  end
	  if @quality<1
	   @quality=1
	  end
  
  
  
  
  end
  
  
  




end

#===============================================================================
# Preferred Weather check
#===============================================================================

def pbBerryPreferredWeatherEnabled?
    return true
end



#===============================================================================
#
#===============================================================================

def pbShowBerryMessage
  return false if Input.press?(Input::SHIFT) && $PokemonSystem.fastberries == 0
  return true if Input.press?(Input::SHIFT) && $PokemonSystem.fastberries == 1
  return true if $PokemonSystem.fastberries == 0
  return false
end


#===============================================================================
#
#===============================================================================

def hasAxe?
 return true if $bag.has?(:STONEAXE)||$bag.has?(:IRONAXE)
 return false
end
def getAxe
  return :STONEAXE if $bag.has?(:STONEAXE)
  return :IRONAXE if $bag.has?(:IRONAXE)
  retun false
end



class GameStats
    attr_accessor :mutated_berries_picked
    attr_accessor :berries_propagated
    attr_accessor :berry_weeds_pulled
    attr_accessor :berry_pest_battles

    alias tdw_berry_improvements_stats_init initialize
    def initialize
        tdw_berry_improvements_stats_init
        @mutated_berries_picked = 0
        @berries_propagated = 0
        @berry_weeds_pulled = 0
        @berry_pest_battles = 0
    end
end























MenuHandlers.add(:options_menu, :fastberries, {
  "name"        => _INTL("Fast Crops"),
  "parent"      => :gameplay_menu2,
  "order"       => 41,
  "type"        => EnumOption,
  "parameters"  => [_INTL("On"), _INTL("Off")],
  "condition"   => proc { next $player },
  "description" => _INTL("Choose if you have info text for berries."),
  "get_proc"    => proc { next $PokemonSystem.fastberries },
  "set_proc"    => proc { |value, _scene|
  $PokemonSystem.fastberries = value



  }
})



class PokemonSystem
   attr_accessor :fastberries
   
   alias :_old_system_init :initialize
   def initialize
   _old_system_init
    @fastberries     = 0     # OFF
   end
end


class PokemonEncounters


  def choose_wild_pokemon(enc_type, chance_rolls = 1)
    if !enc_type || !GameData::EncounterType.exists?(enc_type)
      raise ArgumentError.new(_INTL("Encounter type {1} does not exist", enc_type))
    end
    enc_list = @encounter_tables[enc_type]
    return nil if !enc_list || enc_list.length == 0
    # Static/Magnet Pull prefer wild encounters of certain types, if possible.
    # If they activate, they remove all Pokémon from the encounter table that do
    # not have the type they favor. If none have that type, nothing is changed.
    first_pkmn = $player.first_pokemon
    if first_pkmn
      favored_type = nil
      case first_pkmn.ability_id
      when :FLASHFIRE
        favored_type = :FIRE if MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS &&
                                GameData::Type.exists?(:FIRE) && rand(100) < 50
      when :HARVEST
        favored_type = :GRASS if MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS &&
                                 GameData::Type.exists?(:GRASS) && rand(100) < 50
      when :LIGHTNINGROD
        favored_type = :ELECTRIC if MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS &&
                                    GameData::Type.exists?(:ELECTRIC) && rand(100) < 50
      when :MAGNETPULL
        favored_type = :STEEL if GameData::Type.exists?(:STEEL) && rand(100) < 50
      when :STATIC
        favored_type = :ELECTRIC if GameData::Type.exists?(:ELECTRIC) && rand(100) < 50
      when :STORMDRAIN
        favored_type = :WATER if MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS &&
                                 GameData::Type.exists?(:WATER) && rand(100) < 50
      end
      if favored_type
        new_enc_list = []
        enc_list.each do |enc|
          species_data = GameData::Species.get(enc[1])
          new_enc_list.push(enc) if species_data.types.include?(favored_type)
        end
        enc_list = new_enc_list if new_enc_list.length > 0
      end
    end
    enc_list.sort! { |a, b| b[0] <=> a[0] }   # Highest probability first
    # Calculate the total probability value
    chance_total = 0
    enc_list.each { |a| chance_total += a[0] }
    # Choose a random entry in the encounter table based on entry probabilities
    rnd = 0
    chance_rolls.times do
      r = rand(chance_total)
      rnd = r if r > rnd   # Prefer rarer entries if rolling repeatedly
    end
    encounter = nil
    enc_list.each do |enc|
      rnd -= enc[0]
      next if rnd >= 0
      encounter = enc
      break
    end
   
    level =  new_set_enemy_level(encounter)
 
    # Some abilities alter the level of the wild Pokémon
    if first_pkmn
      case first_pkmn.ability_id
      when :HUSTLE, :PRESSURE, :VITALSPIRIT
        level = [level + rand(1..4), GameData::GrowthRate.max_level].max
      end
    end
    # Black Flute and White Flute alter the level of the wild Pokémon
    if Settings::FLUTES_CHANGE_WILD_ENCOUNTER_LEVELS
      if $PokemonMap.blackFluteUsed
        level = [level + rand(1..4), GameData::GrowthRate.max_level].min
      elsif $PokemonMap.whiteFluteUsed
        level = [level - rand(1..4), 1].max
      end
    end
    if level < 3
     level = 3 
    end
    # Return [species, level]
    return [encounter[1], level]
  end

  def choose_wild_pokemon_for_map(map_ID, enc_type)
    if !enc_type || !GameData::EncounterType.exists?(enc_type)
      raise ArgumentError.new(_INTL("Encounter type {1} does not exist", enc_type))
    end
    # Get the encounter table
    encounter_data = GameData::Encounter.get(map_ID, $PokemonGlobal.encounter_version)
    return nil if !encounter_data
    enc_list = encounter_data.types[enc_type]
    return nil if !enc_list || enc_list.length == 0
    # Calculate the total probability value
    chance_total = 0
    enc_list.each { |a| chance_total += a[0] }
    # Choose a random entry in the encounter table based on entry probabilities
    rnd = rand(chance_total)
    encounter = nil
    enc_list.each do |enc|
      rnd -= enc[0]
      next if rnd >= 0
      encounter = enc
      break
    end
    # Return [species, level]
    level =  new_set_enemy_level(encounter)
    if level < 3
     level = 3 
    end
    return [encounter[1], level]
  end

end



# This sets up berry data if the event has pbberryplant in the event pages, but not pbpickberry before it.
class Game_Map
    alias tdw_berry_improvements_map_setup setup
    def setup(map_id)
        tdw_berry_improvements_map_setup(map_id)
        return if $PokemonGlobal.maps_first_setups && $PokemonGlobal.maps_first_setups[map_id]
        @events.each do |event|
            next if !event[1].name[/berryplant/i]
            next if $PokemonGlobal.eventvars[[map_id, event[1].id]]
            next if event[1].list.nil?
            next unless event[1].list.is_a?(Array)
            plant = false
            pick = false
            event[1].list.each do |item|
                break if pick || plant
                next if ![355, 655].include?(item.code)
                next plant = true if item.parameters[0][/pbberryplant/i]
                next pick = true if item.parameters[0][/pbpickberry/i]
            end
            if plant && !pick
                berry_plant = $PokemonGlobal.eventvars[[map_id, event[1].id]]
                if !berry_plant
                    berry_plant = BerryPlantData.new(event[1])
                    $PokemonGlobal.eventvars[[map_id, event[1].id]] = berry_plant
                end
            end
        end
        $PokemonGlobal.maps_first_setups ||= {}
        $PokemonGlobal.maps_first_setups[map_id] = true
    end
end



#===============================================================================
# Town Map
#===============================================================================



def pbBerryPlantPestRandomEncounter(berry)
    #return false if $game_system.encounter_disabled
  encounter_type = $PokemonEncounters.find_valid_encounter_type_for_weather(encounter_type, encounter_type)
  encounter = $PokemonEncounters.has_encounter_type?(encounter_type)
    return if encounter_type.nil?
    $stats.berry_pest_battles ||= 0
    $stats.berry_pest_battles += 1
	$game_temp.in_safari=true
    result = pbEncounter(encounter_type)
	$game_temp.in_safari==false
	
    return result
end



def pailInteraction(event,berry_plant)
current_selection=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
return false if $PokemonGlobal.ball_hud_enabled==false
return false if current_selection.nil?
return false if !current_selection.is_a?(ItemData)
return false if !GameData::BerryPlant::WATERING_CANS.include?(current_selection.id)
pbTurnBerryPlant(event,berry_plant)
ItemHandlers.triggerUseFromBox(current_selection, event)
return true
end


def pbPestInteraction(this_event,berry_plant)
    return false if !berry_plant.pests
    berry = berry_plant.berry_id
    if berry_plant.grown?
        this_event.turn_up
    elsif
        case berry_plant.growth_stage
        when 1 then this_event.turn_down
        when 2 then this_event.turn_down
        when 3 then this_event.turn_left
        else this_event.turn_right
        end
    end
    pbMessage(_INTL("A Pokémon jumped out at you!"))
    pbBerryPlantPestRandomEncounter(berry)
	
	berry_plant.stoppedbitting+=1
    berry_plant.pests = false
    berry_plant.pests_timer = pbGetTimeNow.to_i
	 return true
end


def pbBerryPlantWitheredItem
    berry_plant = pbMapInterpreter.getVariable
    berry = berry_plant.berry_id
    return if !berry_plant
    item = berry_plant.withered_item
    return if berry_plant.planted? #|| !item
    pbReceiveItem(:WOODENSTICKS,rand(7)+4)
    $bag.add(item) if item
	$bag.add(berry) if $player.is_it_this_class?(:GARDENER)
end


def pbOtherInteractions
    berry_plant = pbMapInterpreter.getVariable
    berry = berry_plant.berry_id
    if berry_plant.weeds
        if pbConfirmMessage(_INTL("Weeds are growing here. Pull out the weeds?"))
            berry_plant.pullWeeds
            pbMessage(_INTL("{1} pulled out the weeds!", $player.name))
        end
    end
    current_selection=$PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
    return if $PokemonGlobal.ball_hud_enabled==false
    return if current_selection.nil?
    return if !current_selection.is_a?(ItemData)
    # Dig Up
    if berry_plant.growing? && berry_plant.growth_stage == 1 && current_selection.id==:SHOVEL && current_selection.decrease_durability(1)
        if pbConfirmMessage(_INTL("You may be able to dig up the berry. Dig up the {1}?", GameData::Item.get(berry).name))
            berry_plant.reset
            if rand(100) < 50 || $player.is_it_this_class?(:GARDENER)
                $bag.add(berry)
                pbMessage(_INTL("The dug up {1} was in good enough condition to keep.",GameData::Item.get(berry).name))
            else
                pbMessage(_INTL("The dug up {1} broke apart in your hands.",GameData::Item.get(berry).name))
            end
        end
    end
    #Weeds


end



class BerryPlantGroundSprite
    def initialize(event, map, viewport = nil)
        @event          = event
        @map            = map
        @justintime          = false
        berry_plant = @event.variable
        @justintime          = berry_plant.jit if berry_plant
        @sprite         = IconSprite.new(0, 0, viewport)
        @sprite.ox      = 16
        @sprite.oy      = 24
        @disposed       = false
        update_graphic
    end
  
    def dispose
        @sprite.dispose
        @map      = nil
        @event    = nil
        @disposed = true
    end
  
    def disposed?
        return @disposed
    end
  
    def update_graphic
        if @justintime  
            @sprite.setBitmap("Graphics/Characters/berrytreeground")
        else
            @sprite.setBitmap("") 
        end
    end
  
    def update
        return if !@sprite || !@event
        cur_jit = @justintime
        berry_plant = @event.variable
        return if !berry_plant.is_a?(BerryPlantData)
        @justintime = berry_plant.jit
        update_graphic if cur_jit != @justintime
        @sprite.update
        @sprite.x      = ScreenPosHelper.pbScreenX(@event)
        @sprite.y      = ScreenPosHelper.pbScreenY(@event)
        @sprite.zoom_x = ScreenPosHelper.pbScreenZoomX(@event)
        @sprite.zoom_y = @sprite.zoom_x
        pbDayNightTint(@sprite)
    end
end



class BerryPlantMulchSprite
    def initialize(event, map, viewport = nil)
        @event          = event
        @map            = map
        @mulch          = false
        @sprite         = IconSprite.new(0, 0, viewport)
        @sprite.ox      = 16
        @sprite.oy      = 24
        @disposed       = false
        update_graphic
    end
  
    def dispose
        @sprite.dispose
        @map      = nil
        @event    = nil
        @disposed = true
    end
  
    def disposed?
        return @disposed
    end
  
    def update_graphic
	   
        if @mulch  
            @sprite.setBitmap("Graphics/Characters/berrytreewet")
        else
            @sprite.setBitmap("") 
        end
    end
  
    def update
        return if !@sprite || !@event
        cur_mulch = @mulch
        berry_plant = @event.variable
        return if !berry_plant.is_a?(BerryPlantData)
        if berry_plant.planted? || !berry_plant.mulch_id
            @mulch = false
        else
            @mulch = true
        end
        update_graphic if cur_mulch != @mulch
        @sprite.update
        @sprite.x      = ScreenPosHelper.pbScreenX(@event)
        @sprite.y      = ScreenPosHelper.pbScreenY(@event)
        @sprite.zoom_x = ScreenPosHelper.pbScreenZoomX(@event)
        @sprite.zoom_y = @sprite.zoom_x
        pbDayNightTint(@sprite)
    end
end

class BerryPlantWeedSprite
    def initialize(event, map, viewport = nil)
        @event          = event
        @map            = map
        @weeds          = false
        @sprite         = IconSprite.new(0, 0, viewport)
        @sprite.ox      = 16
        @sprite.oy      = 24
        @disposed       = false
        update_graphic
    end
  
    def dispose
        @sprite.dispose
        @map      = nil
        @event    = nil
        @disposed = true
    end
  
    def disposed?
        return @disposed
    end
  
    def update_graphic
        if @weeds  
            @sprite.setBitmap("Graphics/Characters/berrytreeweeds")
        else
            @sprite.setBitmap("") 
        end
    end
  
    def update
        return if !@sprite || !@event
        cur_weeds = @weeds
        berry_plant = @event.variable
        return if !berry_plant.is_a?(BerryPlantData)
        @weeds = berry_plant.weeds
        update_graphic if cur_weeds != @weeds
        @sprite.update
        @sprite.x      = ScreenPosHelper.pbScreenX(@event)
        @sprite.y      = ScreenPosHelper.pbScreenY(@event)
        @sprite.zoom_x = ScreenPosHelper.pbScreenZoomX(@event)
        @sprite.zoom_y = @sprite.zoom_x
        pbDayNightTint(@sprite)
    end
end



#===============================================================================
#
#===============================================================================
class BerryPlantMoistureSprite
  def initialize(event, map, viewport = nil)
    @event          = event
    @map            = map
    @sprite         = IconSprite.new(0, 0, viewport)
    @sprite.ox      = 16
    @sprite.oy      = 24
    @moisture_stage = -1   # -1 = none, 0 = dry, 1 = damp, 2 = wet
    @disposed       = false
    update_graphic
  end

  def dispose
    @sprite.dispose
    @map      = nil
    @event    = nil
    @disposed = true
  end

  def disposed?
    return @disposed
  end

  def update_graphic
    case @moisture_stage
    when -1 then @sprite.setBitmap("")
    when 0  then @sprite.setBitmap("Graphics/Characters/berrytreedry")
    when 1  then @sprite.setBitmap("Graphics/Characters/berrytreedamp")
    when 2  then @sprite.setBitmap("Graphics/Characters/berrytreewet")
    when 3  then @sprite.setBitmap("Graphics/Characters/berrytree100")
    end
  end

  def update
    return if !@sprite || !@event
    new_moisture = -1
    berry_plant = @event.variable
    if berry_plant.is_a?(BerryPlantData) && berry_plant.planted?
      new_moisture = berry_plant.moisture_stage
    end
    if new_moisture != @moisture_stage
      @moisture_stage = new_moisture
      update_graphic
    end
    @sprite.update
    @sprite.x      = ScreenPosHelper.pbScreenX(@event)
    @sprite.y      = ScreenPosHelper.pbScreenY(@event)
    @sprite.zoom_x = ScreenPosHelper.pbScreenZoomX(@event)
    @sprite.zoom_y = @sprite.zoom_x
    pbDayNightTint(@sprite)
  end
end

#===============================================================================
#
#===============================================================================
class BerryPlantSprite
  def initialize(event, map, _viewport)
    @event     = event
	@centered = event.centered if defined?(event.centered)
    @map       = map
    @old_stage = 0
    @disposed  = false
    berry_plant = event.variable
    return if !berry_plant
    @old_stage = berry_plant.growth_stage
    @event.character_name = ""
    update_plant(berry_plant)
    set_event_graphic(berry_plant, true)   # Set the event's graphic
  end

  def dispose
    @event    = nil
    @map      = nil
    @disposed = true
  end

  def disposed?
    @disposed
  end

  def set_event_graphic(berry_plant, full_check = false)
    return if !berry_plant || (berry_plant.growth_stage == @old_stage && !full_check)
    case berry_plant.growth_stage
    when 0
      @event.character_name = ""
    else
      if berry_plant.growth_stage == 1
        @event.character_name = "berrytreeplanted"   # Common to all berries
        @event.turn_down
      else
        filename = sprintf("berrytree_%s", GameData::Item.get(berry_plant.berry_id).id.to_s)
        if pbResolveBitmap("Graphics/Characters/" + filename)
          @event.character_name = filename
          case berry_plant.growth_stage
          when 2 then @event.turn_down    # X sprouted
          when 3 then @event.turn_left    # X taller
          when 4 then @event.turn_right   # X flowering
          when 5 then @event.turn_up      # X berries
		  else 
		  @event.turn_up
          end
        else
          @event.character_name = "berrytree_ACORN"
        end
      end
	  if berry_plant.moisture_level >= 100 && @old_stage != berry_plant.growth_stage && @old_stage > 0 && berry_plant.growth_stage >= 5
	    spriteset = $scene.spriteset(@map.map_id)
        spriteset&.addUserAnimation(Settings::PLANT_SPARKLE_ANIMATION_ID,@event.x, @event.y, false, 1)
	  end
      if @old_stage != berry_plant.growth_stage && @old_stage > 0 && berry_plant.growth_stage <= 4 + 1
        spriteset = $scene.spriteset(@map.map_id)
        spriteset&.addUserAnimation(Settings::PLANT_SPARKLE_ANIMATION_ID,
                                    @event.x, @event.y, false, 1)
      end
    end
    @old_stage = berry_plant.growth_stage
  end

  def update_plant(berry_plant, initial = false)
    berry_plant.update if berry_plant.planted?
  end

  def update
    berry_plant = @event.variable
    return if !berry_plant
    update_plant(berry_plant)
    set_event_graphic(berry_plant)
  end
end

#===============================================================================
#
#===============================================================================


EventHandlers.add(:on_new_spriteset_map, :add_berry_plant_ground_graphic,
  proc { |spriteset, viewport|
    map = spriteset.map
    map.events.each do |event|
      next if !event[1].name[/berryplant/i]
      #
    end
  }
)





EventHandlers.add(:on_new_spriteset_map, :add_berry_plant_weed_graphic,
  proc { |spriteset, viewport|
    map = spriteset.map
    map.events.each do |event|
      next if !event[1].name[/berryplant/i]
    end
  }
)



EventHandlers.add(:on_new_spriteset_map, :add_berry_plant_mulch_graphic,
  proc { |spriteset, viewport|
    map = spriteset.map
    map.events.each do |event|
      next if !event[1].name[/berryplant/i]
    end
  }
)


EventHandlers.remove(:on_new_spriteset_map, :add_berry_plant_graphics)
 
EventHandlers.add(:on_new_spriteset_map, :add_berry_plant_graphics,
  proc { |spriteset, viewport|
    map = spriteset.map
    map.events.each do |event|
      next if !event[1].name[/berryplant/i]
	  spriteset.addUserSprite(BerryPlantGroundSprite.new(event[1], map, viewport))
      spriteset.addUserSprite(BerryPlantMoistureSprite.new(event[1], map, viewport))
      spriteset.addUserSprite(BerryPlantMulchSprite.new(event[1], map, viewport))
      spriteset.addUserSprite(BerryPlantSprite.new(event[1], map, viewport))
      spriteset.addUserSprite(BerryPlantWeedSprite.new(event[1], map, viewport))
    end
  }
)







if false

def dothewateringthingplant
	 watered = false
	 
  interp = pbMapInterpreter
  this_event = interp.get_self
  berry_plant = interp.getVariable
	 
	 
	 
GameData::BerryPlant::WATERING_CANS.each do |item|
      next if !$bag.has?(item)
      next if watered==true
	   next if pbGetWateringCanLevel(item,true)==0
	  if pbShowBerryMessage
      break if !pbConfirmMessage(_INTL("Want to sprinkle some water with the {1}?", GameData::Item.get(item).name))
      end	  
	  
        $PokemonGlobal.watering_can_levels[item] -= 1
	 watered = true
	  if item == :SPRAYDUCK
    case @mulch_id
    when :DAMPMULCH
      berry_plant.water(40)
    when :DAMPMULCH2
      berry_plant.water(60)
	else
      berry_plant.water(20)
    end
	
	
	
	
      break


	  elsif item == :SQUIRTBOTTLE
    case @mulch_id
    when :DAMPMULCH
      berry_plant.water(50)
    when :DAMPMULCH2
      berry_plant.water(75)
	else
      berry_plant.water(25)
    end

      break



	  elsif item == :WAILMERPAIL
    case @mulch_id
    when :DAMPMULCH
      berry_plant.water(60)
    when :DAMPMULCH2
      berry_plant.water(90)
	else
      berry_plant.water(30)
    end












      break

	  elsif item == :SPRINKLOTAD
    case @mulch_id
    when :DAMPMULCH
      berry_plant.water(70)
    when :DAMPMULCH2
      berry_plant.water(100)
	else
      berry_plant.water(35)
    end











      break


	  elsif item == :WOODENPAIL
    case @mulch_id
    when :DAMPMULCH
      berry_plant.water(20)
    when :DAMPMULCH2
      berry_plant.water(40)
	else
      berry_plant.water(10)
    end





      break

	end


end


if pbCheckMoveTypeforWatering(:WATER) && watered == false
	if pbConfirmMessage(_INTL("Would you like to have one of your Pokemon water the plant?"))
	  berry_plant.water(waterPlantWithMove)
	  watered = true
	end
end

if pbShowBerryMessage
pbMessage(_INTL("{1} watered the plant.\\wtnp[40]", $player.name))
pbMessage(_INTL("The plant seemed to be delighted."))
end
end



def pbGetWateringCanLevel(can,string = false)
    level = 
	pbMessage(_INTL("The #{GameData::Item.get(cans).name} has no water!")) if string == true && level == 0
	return level
end

def pbFillWateringCans
    return false if !$PokemonGlobal.watering_can_levels
    can = ""
    GameData::BerryPlant::WATERING_CANS.each do |item|
        next if !$bag.has?(item)
        can = GameData::Item.get(item).name
        $PokemonGlobal.watering_can_levels[item] = pbGetWateringCanMax(item)
    end
    return true
end

def pbGetWateringCanMax(can)
    ret = Settings::BERRY_WATERING_USES_OVERRIDES[can] || Settings::BERRY_WATERING_USES_BEFORE_EMPTY
    return ret
end


end


