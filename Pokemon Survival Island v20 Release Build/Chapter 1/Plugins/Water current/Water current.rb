# Water current
# Credit: Michael, Marcello/Reborn Team, bo4p5687
# You can modify the number
module GameData
  class TerrainTag
		attr_reader :current_left
		attr_reader :current_up
		attr_reader :current_right
		attr_reader :current_down
		attr_reader :w_current

		alias init_water_current initialize
		def initialize(hash)
			init_water_current(hash)
			@current_left  = hash[:current_left]  || false
			@current_up    = hash[:current_up]    || false
			@current_right = hash[:current_right] || false
			@current_down  = hash[:current_down]  || false
			@w_current     = hash[:w_current]     || false
		end
	end
end

GameData::TerrainTag.register({
  :id                     => :CurrentLeft,
  :id_number              => 23,
	:can_surf               => true,
	:w_current              => true,
	:current_left           => true
})

GameData::TerrainTag.register({
  :id                     => :CurrentUp,
  :id_number              => 24,
	:can_surf               => true,
	:w_current              => true,
	:current_up             => true
})

GameData::TerrainTag.register({
  :id                     => :CurrentRight,
  :id_number              => 25,
	:can_surf               => true,
	:w_current              => true,
	:current_right          => true
})

GameData::TerrainTag.register({
  :id                     => :CurrentDown,
  :id_number              => 26,
	:can_surf               => true,
	:w_current              => true,
	:current_down           => true
})
#-------------------------------------------------------------------------------
class PokemonEncounters
	def encounter_possible_here?
		terrain_tag = $game_map.terrain_tag($game_player.x, $game_player.y)
		(terrain_tag.w_current ? (return false) : (return true)) if $PokemonGlobal.surfing
    return false if terrain_tag.ice
    return true if has_cave_encounters?   # i.e. this map is a cave
    return true if has_land_encounters? && terrain_tag.land_wild_encounters
    return false
  end
end
#-------------------------------------------------------------------------------
# Add below lines above Main
class Scene_Map
  alias old_update_wct update
  def update
    old_update_wct
    # Water current
    pbWaterCurrent
  end
end

def pbWaterCurrent
	return if pbMapInterpreterRunning?
	return unless $PokemonGlobal.surfing && !$game_player.moving?
	return if $game_variables[4993]!=0
	terrain = $game_map.terrain_tag($game_player.x,$game_player.y)
	m = 0 if !m
	if terrain.current_left
		m = 4
	elsif terrain.current_right
		m = 6
	elsif terrain.current_up
		m = 8
	elsif terrain.current_down
		m = 2
	end
	return if m==0 || m.nil?
	pbUpdateSceneMap
	$game_player.move_generic(m)
end

# Change repel
EventHandlers.add(:on_player_step_taken_can_transfer, :fefeeggrhaVahgherzhshb,
  proc {
	# Shouldn't count down if on ice or on water current
  if $PokemonGlobal.repel > 0 && !$game_player.terrain_tag.ice && !$game_player.terrain_tag.w_current
    $PokemonGlobal.repel -= 1
    if $PokemonGlobal.repel <= 0
      if $PokemonBag.pbHasItem?(:REPEL) ||
         $PokemonBag.pbHasItem?(:SUPERREPEL) ||
         $PokemonBag.pbHasItem?(:MAXREPEL)
        if pbConfirmMessage(_INTL("The repellent's effect wore off! Would you like to use another one?"))
          ret = nil
          pbFadeOutIn {
            scene = PokemonBag_Scene.new
            screen = PokemonBagScreen.new(scene,$PokemonBag)
            ret = screen.pbChooseItemScreen(Proc.new { |item|
              [:REPEL, :SUPERREPEL, :MAXREPEL].include?(item)
            })
          }
          pbUseItem($PokemonBag,ret) if ret
        end
      else
        pbMessage(_INTL("The repellent's effect wore off!"))
      end
    end
  end
})

# Change count steps egg
EventHandlers.add(:on_player_step_taken_can_transfer, :fefeeggrhaVahgherzhshb,
  proc {
	terrain = $game_map.terrain_tag($game_player.x,$game_player.y)
	if !terrain.ice && !terrain.w_current
		for egg in $Trainer.party
			next if egg.steps_to_hatch <= 0
			egg.steps_to_hatch -= 1
			for i in $Trainer.pokemon_party
				next if !i.hasAbility?(:FLAMEBODY) && !i.hasAbility?(:MAGMAARMOR)
				egg.steps_to_hatch -= 1
				break
			end
			if egg.steps_to_hatch <= 0
				egg.steps_to_hatch = 0
				pbHatch(egg)
			end
		end
	end
})