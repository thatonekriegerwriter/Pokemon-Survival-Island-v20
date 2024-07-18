
class Game_Temp
  attr_accessor :battle_theme
end

class Battle::Scene::PokemonDataBox < Sprite

  def visible=(value)
    super
	lowhealthbgm = nil
	lowhealthbgs = nil
    @sprites.each do |i|
      i[1].visible = value if !i[1].disposed?
    end
    @expBar.visible = (value && @showExp)
    if value == true && ((@battler.index%2)==0)
	  if $PokemonSystem.lowHPMusic == 0
	  elsif $PokemonSystem.lowHPMusic == 2
	   lowhealthbgm = "Low HP Battle"
	  elsif $PokemonSystem.lowHPMusic == 1
	   lowhealthbgs = "Low HP Beep"
	  end
	  if @battler.hp<=@battler.totalhp/4 && lowhealthbgs
	  pbBGSPlay(lowhealthbgs)
	  puts "potato"
	  end
      if @battler.hp<=@battler.totalhp/4 && lowhealthbgm
        if $game_system.playing_bgm.name!=lowhealthbgm
          $game_temp.battle_theme = $game_system.playing_bgm.name
          pbBGMPlay(lowhealthbgm)
        end
      else
        low = 0
        @battler.battle.battlers.each_with_index do |b,i|
          next if !b || (b.index%2)==1
          low +=1 if b.hp<b.totalhp/4
        end
        pbBGMPlay($game_temp.battle_theme) if low == 0 && $game_system.playing_bgm.name==lowhealthbgm       
        pbBGSStop(lowhealthbgs) if low == 0 && $game_system.playing_bgs.name==lowhealthbgs
      end
    end
	
  end
  

  alias oldupdateHPAnimation updateHPAnimation
  def updateHPAnimation
    oldupdateHPAnimation
    return if !@animatingHP
	   lowhealthbgm = nil
	   lowhealthbgs = nil
	  if $PokemonSystem.lowHPMusic == 0
	  elsif $PokemonSystem.lowHPMusic == 2
	   lowhealthbgm = "Low HP Battle"
	  elsif $PokemonSystem.lowHPMusic == 1
	   lowhealthbgs = "Low HP Beep"
	  end
    if ((@battler.index%2)==0)
	  if @battler.hp<=@battler.totalhp/4 && lowhealthbgs
	  pbBGSPlay(lowhealthbgs)
	  end
      if @battler.hp<=@battler.totalhp/4 && @battler.hp>0 && lowhealthbgm
        if $game_system.playing_bgm.name!=lowhealthbgm
          $game_temp.battle_theme = $game_system.playing_bgm.name
          pbBGMPlay(lowhealthbgm)
        end
      elsif $game_system.playing_bgm.name==lowhealthbgm
        low = 0
        @battler.battle.battlers.each_with_index do |b,i|
          next if !b || (b.index%2)==1
          low +=1 if b.hp<b.totalhp/4
        end
	if $game_system.playing_bgm
        pbBGMPlay($game_temp.battle_theme) if low == 0 && $game_system.playing_bgm.name==lowhealthbgm
	end
	if $game_system.playing_bgs
        pbBGSStop(lowhealthbgs) if low == 0 && $game_system.playing_bgs.name==lowhealthbgs       
	end   
      end
    end
  end
  
end

class Battle::Battler

  alias old_pbFaint pbFaint
  def pbFaint(showMessage = true)
    old_pbFaint
    low = 0
	   lowhealthbgm = nil
	   lowhealthbgs = nil
	if $PokemonSystem.lowHPMusic == 0
	  elsif $PokemonSystem.lowHPMusic == 2
	   lowhealthbgm = "Low HP Battle"
	  elsif $PokemonSystem.lowHPMusic == 1
	   lowhealthbgs = "Low HP Beep"
	  end
    @battle.battlers.each_with_index do |b,i|
      next if !b || (b.index%2)==1
      low +=1 if b.hp<b.totalhp/4 && b.hp > 0
    end
	if $game_system.playing_bgm
    pbBGMPlay($game_temp.battle_theme) if low == 0 && $game_system.playing_bgm.name==lowhealthbgm
	end
	if $game_system.playing_bgs
    pbBGSStop(lowhealthbgs) if low == 0 && $game_system.playing_bgs.name==lowhealthbgs
	end
  end
  
end