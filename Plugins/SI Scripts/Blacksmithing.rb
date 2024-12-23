class Pokemon_OldGosuMinigame_Scene
  def pbStartScreen
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @pausetheme = "/Blacksmithing/pause.mp3"
	@background_music = "Big Blast Sonic - Daisuke Ishwatari.ogg"
	set_up_sfx
    @previousBGM = $game_system.getPlayingBGM
    $game_system.bgm_pause
	pbBGMPlay(@pausetheme)
	
	
	@bar_width = 20
	@green_starting_width = 75
	@green_width = @green_starting_width
	@bar_min = 20
	@speedcap = 20
	
	
	@sprites["bg"] = IconSprite.new(0,0,@viewport)
	@sprites["bg"].setBitmap("Graphics/Blacksmithing/bg.png")
	@sprites["bg"].z = 0
	@sprites["title"] = IconSprite.new(0,0,@viewport)
	@sprites["title"].setBitmap("Graphics/Blacksmithing/title.png")
	@sprites["title"].z = 1
	
	
	@sprites["winscreen"] = IconSprite.new(0,0,@viewport)
	@sprites["winscreen"].setBitmap("Graphics/Blacksmithing/winscreen.png")
	@sprites["winscreen"].ox = @sprites["winscreen"].width/2
	@sprites["winscreen"].oy = @sprites["winscreen"].height/2
	@sprites["winscreen"].x = @sprites["title"].width/2
	@sprites["winscreen"].y = @sprites["title"].height/2
	@sprites["winscreen"].z = 98
	@sprites["winscreen"].visible = false
	
	
	@sprites["arrow"] = IconSprite.new(0,0,@viewport)
	@sprites["arrow"].setBitmap("Graphics/Blacksmithing/arrow.png")
	@sprites["arrow"].z = 3
	@sprites["arrow"].visible = false
	
	
	

  end
  
  def set_up_sfx
    
    @winsong = "/Blacksmithing/win.mp3"
    @pick = "/Blacksmithing/pick.mp3"
    @crit = "/Blacksmithing/crit.mp3"
    @normaldamage = "/Blacksmithing/normaldamage.mp3"
    @fire = "/Blacksmithing/burn.mp3"
    @good = "/Blacksmithing/a good.mp3"
    @verygood = "/Blacksmithing/a verygood.mp3"
    @great = "/Blacksmithing/a great.mp3"
    @awesome = "/Blacksmithing/a awesome.mp3"
    @outstanding = "/Blacksmithing/a outstanding.mp3"
    @amazing = "/Blacksmithing/a amazing.mp3"
    @end1 = "/Blacksmithing/end1.mp3"
    @end2 = "/Blacksmithing/end2.mp3"
    @caution = "/Blacksmithing/caution.mp3"
    @power = "/Blacksmithing/Vs flash.ogg"
    @cooldown = "/Blacksmithing/cooldown.mp3"
    @low = "/Blacksmithing/alert.mp3"
  
  
  
  end
  
  
  def update
  
  
  
  end


  def pbEndScreen
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
    $game_system.bgm_resume(@previousBGM)
  end
end


class Pokemon_OldGosuMinigame_Screen
  def initialize(scene)
    @scene = scene
  end
  


  def pbDisplay(text, brief = false)
    @scene.pbDisplay(text, brief)
  end

  def pbDisplayPaused(text)
    @scene.pbDisplayPaused(text)
  end

  def pbConfirm(text)
    return @scene.pbConfirm(text)
  end
  
  

  def main_loop(menu=nil)
    ret = false
    @scene.pbStartScreen
	
  end




end