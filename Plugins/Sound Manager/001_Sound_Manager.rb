#filename = pbResolveAudioSE(filename)
#ret = getPlayTime(filename) if filename

module SoundManager
    @cached_sounds = {}
    @cached_songs = {}

class << self

  def play_se(param, volume = nil, pitch = nil)
  return if !param
  param = pbResolveAudioFile(param, volume, pitch)
  if param.name && param.name != ""
    filename = pbResolveAudioSE(param.name)
	return if !filename
    if @cached_sounds[param.name] && Graphics.frame_count < @cached_sounds[param.name]
        return
    end
	length  = getPlayTime(filename)
    frames = (length * Graphics.frame_rate).ceil
	@cached_sounds[param.name] ||= Graphics.frame_count + frames
    if $game_system
      $game_system.se_play(param)
      return
    end
    if (RPG.const_defined?(:SE) rescue false)
      b = RPG::SE.new(param.name, param.volume, param.pitch)
      if b.respond_to?("play")
        b.play
        return
      end
    end
    Audio.se_play(canonicalize(filename), param.volume, param.pitch)
  end
  
  
  
  end 


  def play_song(param, volume = nil, pitch = nil)
  return if !param
  param = pbResolveAudioFile(param, volume, pitch)
  if param.name && param.name != ""
    filename = pbResolveAudioSE(param.name)
	return if !filename
	ret = getPlayTime(filename)
	@cached_sounds[param.name] ||= ret
    if $game_system
      $game_system.se_play(param)
      return
    end
    if (RPG.const_defined?(:SE) rescue false)
      b = RPG::SE.new(param.name, param.volume, param.pitch)
      if b.respond_to?("play")
        b.play
        return
      end
    end
    Audio.se_play(canonicalize(filename), param.volume, param.pitch)
  end
  
  
  
  end 


 def update
      current = Graphics.frame_count
      @cached_sounds.delete_if { |_, end_frame| current >= end_frame }
 end
 

end








end


class Game_System

 alias original_gs_update update
 def update
   original_gs_update
   SoundManager.update
 end 

end 