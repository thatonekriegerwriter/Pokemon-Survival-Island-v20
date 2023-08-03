#-------------------------------------------------------------------------------
# Change EBDX Following Pokemon check since EBDX hasn't updated
#-------------------------------------------------------------------------------
if PluginManager.findDirectory("Elite Battle: DX")
  module EliteBattle
    def self.follower(battle)
      return nil if !EliteBattle::USE_FOLLOWER_EXCEPTION
      return (FollowingPkmn.active? && battle.scene.firstsendout) ? 0 : nil
    end
  end
end

#-------------------------------------------------------------------------------
# New GameData::Species method for easily get the appropriate Following Pokemon
# graphic
#-------------------------------------------------------------------------------
module GameData
  class Species
    def self.ow_sprite_filename(species, form = 0, gender = 0, shiny = false, shadow = false)
      ret = self.check_graphic_file("Graphics/Characters/", species, form,
                                    gender, shiny, shadow, "Followers")
      ret = "Graphics/Characters/Followers/" if nil_or_empty?(ret)
	    return ret
    end
  end
end

#-------------------------------------------------------------------------------
# New option in the Options menu to toggle Following Pokemon
#-------------------------------------------------------------------------------


class PokemonOptionScreen
  alias __followingpkmn__pbStartScreen pbStartScreen unless method_defined?(:__followingpkmn__pbStartScreen)
  def pbStartScreen(*args)
    __followingpkmn__pbStartScreen(*args)
    pbRefreshSceneMap
  end
end

#-------------------------------------------------------------------------------
# New trigger method for Named Events that returns the value of the callback
#-------------------------------------------------------------------------------
class NamedEvent
  def trigger_2(*args)
    @callbacks.each_value { |callback|
      ret = callback.call(*args)
      return ret if !ret.nil?
    }
    return -1
  end
end

#-------------------------------------------------------------------------------
# New trigger method for EventHandlers that returns the value of the callback
#-------------------------------------------------------------------------------
module EventHandlers
  def self.trigger_2(event, *args)
    return @@events[event]&.trigger_2(*args)
  end
end
