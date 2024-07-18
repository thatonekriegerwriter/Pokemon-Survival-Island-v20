#########################################
#                                       #
# Easy Debug Terminal                   #
# by ENLS                               #
# no clue what to write here honestly   #
#                                       #
#########################################

###########################
#      Configuration      #
###########################

# Enable or disable the debug terminal
TERMINAL_ENABLED = true

# Button used to open the terminal
TERMINAL_KEYBIND = :T
# Uses SDL scancodes, without the SDL_SCANCODE_ prefix.
# https://github.com/mkxp-z/mkxp-z/wiki/Extensions-(RGSS,-Modules)#detecting-key-states





###########################
#       Code Stuff        #
###########################

module Input
  unless defined?(update_Debug_Terminal)
    class << Input
      alias update_Debug_Terminal update
    end
  end

  def self.update
    update_Debug_Terminal
    if Input.trigger?(Input::DEBUGMENU) && !$InCommandLine && TERMINAL_ENABLED && !$game_temp.in_menu
      $InCommandLine = true
      pbFreeTextNoWindow("",false,256,Graphics.width)
	  $InCommandLine = false
    end
  end
end


$InCommandLine = false
# Custom Message Input Box Stuff







# Custom Message Input Box Stuff
def pbFreeTextNoWindow(currenttext, passwordbox, maxlength, width = 240,debuginput=true)
  if currenttext.nil?
    currenttext=""
  else
   currenttext=currenttext.gsub("\n","\\n")
  end
  text2 = ""
  if $game_temp.lastcommand.length > 0
	text2 = $game_temp.lastcommand.reverse.join("\n")
  end
  window = Window_TextEntry_Keyboard_Terminal.new("", 0, 0, width, 64)
  window2 = Window_UnformattedTextPokemon.newWithSize(text2, 0, 64, width, 128)
  ret = ""
  window2.text = text2
  window.maxlength = maxlength
  window.visible = true
  window.z = 99999
  window.text = currenttext
	if window.text.scan(/./m).length>0
	window.set_to_end
	end
  window2.visible = true
  window2.z = 99999
  window.passwordChar = "*" if passwordbox
  window2.visible = false if debuginput==false
  Input.text_input = true
  loop do
    Graphics.update
    Input.update
    if Input.triggerex?(:ESCAPE)
      ret = currenttext
      Input.text_input = false
      window.dispose
      window2.dispose
      break
    elsif Input.triggerex?(:RETURN) && !Input.press?(Input::SHIFT)
      ret = window.text
	  script = ret
	  script2 = []
	  if script.chars[0]=='/'
	    script = script.tr('/', '')
        if script.includes?("$DEBUG")
	      ret = nil
	    elsif script.includes?("give")
         script = script.gsub('give ', '')
		 script = script.split(' ')
		 puts script
		 amt = script[1]
		 script = script[0]
		 if script[1].nil?
		 amt=1
		 end
		 puts amt
	     ret = "$bag.add(#{script},#{amt})"
	     response = "Gave #{amt} #{script}"
	    elsif script.includes?("pokemon add")
         script = script.gsub('pokemon add ', '')
		 script = script.split(' ')
		 pokemon = script[0]
		 level = script[1]
		 if level.nil?
		 level = 5
		 end
		 pkmn = pokemon.upcase
	     pkmn = GameData::Species.try_get(pkmn).id
	     ret = "pbAddPokemonSilent(Pokemon.new(#{pkmn}, #{level}))"
	     pkmn = GameData::Species.get(pkmn).name
	     response = "Added one #{pkmn} at #{level}"
	    elsif script.includes?("egg add")
         script = script.gsub('egg add ', '')
		 pkmn = script.upcase
	     pkmn = GameData::Species.try_get(pkmn).id
	     ret = "pbGenerateEgg(#{pkmn})"
	     pkmn = GameData::Species.get(pkmn).name
	     response = "Added one #{pkmn} egg."
	     else
	     end

      else
	    if debuginput==false
      ret = window.text.gsub("\\n", "\n")
      Input.text_input = false
      window.dispose
      window2.dispose
          return ret
		else
	      ret = nil
       end
	  end	
 	  if $game_temp.lastcommand.length+1 == 4
	  $game_temp.lastcommand.delete_at(0)
	  end
	  $game_temp.lastcommand << window.text 
      $game_temp.lastcommand << response unless nil_or_empty?(response)
	  text2 = ""
	  if $game_temp.lastcommand.length > 0
	    text2 = $game_temp.lastcommand.reverse.join("\n")
	  end
	  window.text = ""
      window2.text = text2 
	    if $PokemonSystem.cheats==0
      begin
        pbMapInterpreter.execute_script(ret)
      rescue Exception
	    end
	  end
      end
	  
	  

    window2.update
    window.update
    yield if block_given?
  end

  Input.update

end




class Window_TextEntry_Keyboard_Terminal < Window_TextEntry
  def update
    @frame += 1
    @frame %= 20
    self.refresh if (@frame % 10) == 0
    return if !self.active
    # Moving cursor
    if Input.triggerex?(:LEFT) || Input.repeatex?(:LEFT)
      if @helper.cursor > 0
        @helper.cursor -= 1
        @frame = 0
        self.refresh
      end
      return
    elsif Input.triggerex?(:RIGHT) || Input.repeatex?(:RIGHT)
      if @helper.cursor < self.text.scan(/./m).length
        @helper.cursor += 1
        @frame = 0
        self.refresh
      end
      return
    elsif Input.triggerex?(:BACKSPACE) || Input.repeatex?(:BACKSPACE)
      self.delete if @helper.cursor > 0
      return
    elsif Input.triggerex?(:UP) && $InCommandLine && !$game_temp.lastcommand.empty?
      self.text = $game_temp.lastcommand[0]
      @helper.cursor = self.text.scan(/./m).length
      return
	 
    elsif Input.triggerex?(:RETURN) && Input.press?(Input::SHIFT)
	  puts self.text
	   self.text.insert(@helper.cursor,"\\n")
	   @helper.cursor = self.text.scan(/./m).length
    elsif Input.triggerex?(:ESCAPE)
      return
    end
    Input.gets.each_char { |c| insert(c) }
  end
  
  def set_to_end
    @helper.cursor = self.text.scan(/./m).length
  end
end



# Saving the last executed command
class Game_Temp
  attr_accessor :lastcommand

  def lastcommand
    @lastcommand = [] if !@lastcommand
    return @lastcommand
  end
end