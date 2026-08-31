def play_speech_parallel(text,message=true,name="boopSINE",num=DialogueSound.sound_interval)
    DialogueSound.playing(text) 
    DialogueSound.set_sound_effect(name) if name!=DialogueSound.default_sound_effect
    DialogueSound.custom_sound_interval(num) if num!=DialogueSound.sound_interval_default
    sideDisplay(text,false,3,false) if message==true
	 text.length.times do |i|
      DialogueSound.play_sound_effect(i, text)
	 end


    DialogueSound.playing(nil) 
    DialogueSound.set_sound_effect(DialogueSound.default_sound_effect) if DialogueSound.sound_effect_name!=DialogueSound.default_sound_effect
    DialogueSound.custom_sound_interval(DialogueSound.sound_interval_default) if DialogueSound.sound_interval!=DialogueSound.sound_interval_default

end

def play_speech(text,message=true,name="boopSINE",num=DialogueSound.sound_interval)
    DialogueSound.set_sound_effect(name) if name!=DialogueSound.default_sound_effect
    DialogueSound.custom_sound_interval(num) if num!=DialogueSound.sound_interval_default
    sideDisplay(text,false,3,false) if message==true
	 text.length.times do |i|
		Graphics.update
		Input.update
		  $scene.miniupdate 
      DialogueSound.play_sound_effect(i, text)
	 end


    DialogueSound.set_sound_effect(DialogueSound.default_sound_effect) if DialogueSound.sound_effect_name!=DialogueSound.default_sound_effect
    DialogueSound.custom_sound_interval(DialogueSound.sound_interval_default) if DialogueSound.sound_interval!=DialogueSound.sound_interval_default

end

