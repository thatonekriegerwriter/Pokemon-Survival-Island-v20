#-------------------------------------------------------------------------------
# Check Seasons like B2W2 by bo4p5687
#-------------------------------------------------------------------------------
# Don't change
$season_number = 4
# Picture
module ShowSeasonBW2
  module_function
  def showPicture(name=nil)
    return name if name.nil?
    return Bitmap.new("Graphics/Pictures/Seasons/#{name}")
  end
  def pbSeason_Screen
   $mouse.hide if $mouse && !$mouse.disposed?
    if !pbMapInterpreterRunning?
      checked = 0
      loop do
        $PokemonGlobal.addNewFrameCount 
        Graphics.update
        case checked
        when 0
          $season_number = pbGetSeason
          @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
          @viewport.z=99999
          @season = Sprite.new(@viewport)
          if pbIsSpring
            @season.bitmap = self.showPicture("Spring")
          elsif pbIsSummer
            @season.bitmap = self.showPicture("Summer")
          elsif pbIsAutumn
            @season.bitmap = self.showPicture("Autumn")
          elsif pbIsWinter
            @season.bitmap = self.showPicture("Winter")
          else
            @season.bitmap = self.showPicture
          end
          @season.opacity = 150
          checked = 1
        when 1
          @season.opacity += 15
          checked = 2 if @season.opacity >= 255
        when 2
          Graphics.wait(30)
          checked = 3
        when 3
          @season.opacity -= 5
          checked = 4 if @season.opacity <= 0
        when 4
          @season.dispose 
          @viewport.dispose
          break
        end
      end
    else
      @checked = nil if $season_number != pbGetSeason
    end
  end
    $mouse.show if $mouse && !$mouse.disposed?
end



module Game

  def self.load(save_data)
    validate save_data => Hash
    SaveData.load_all_values(save_data)
    $game_temp.last_uptime_refreshed_play_time = System.uptime
    $stats.play_sessions += 1
	 pbBGMFade(0.8)
    ShowHistory.pbHistory_Screen if $PokemonGlobal.history.length>0 && $PokemonSystem.journey==0
    self.load_map
    pbAutoplayOnSave
    $game_map.update
    $PokemonMap.updateMap
    $scene = Scene_Map.new
    ShowSeasonBW2.pbSeason_Screen if $season_number != pbGetSeason
    pbToneChangeAll(Tone.new(0,0,0,0),20)
    #$mouse.enable if $mouse && !$mouse.disposed?
  end
  
  
  
  
  
end

  EventHandlers.add(:on_map_transfer, :season_splash,
    proc { |_old_map_id|
      next if !$game_map
      next if !$game_map.metadata&.outdoor_map
      ShowSeasonBW2.pbSeason_Screen if $season_number != pbGetSeason
    }
  )
  
  
  