class MiningGameCounter < BitmapSprite
  attr_accessor :hits

  def initialize(x,y)
    @viewport=Viewport.new(x,y,416,60)
    @viewport.z=99999
    super(416,60,@viewport)
    @hits=0
    @image=AnimatedBitmap.new(_INTL("Graphics/Pictures/Mining/cracks"))
    update
  end

  def update
    self.bitmap.clear
    value=@hits
    startx=416-48
    while value>6
      self.bitmap.blt(startx,0,@image.bitmap,Rect.new(0,0,48,52))
      startx-=48
      value-=6
    end
    startx-=48
    if value>0
      self.bitmap.blt(startx,0,@image.bitmap,Rect.new(0,value*52,96,52))
    end
  end
end



class MiningGameTile < BitmapSprite
  attr_reader :layer

  def initialize(x,y)
    @viewport=Viewport.new(x,y,32,32)
    @viewport.z=99999
    super(32,32,@viewport)
    r = rand(100)
    if r<10;    @layer = 2   # 10%
    elsif r<25; @layer = 3   # 15%
    elsif r<60; @layer = 4   # 35%
    elsif r<85; @layer = 5   # 25%
    else;       @layer = 6   # 15%
    end
    @image=AnimatedBitmap.new(_INTL("Graphics/Pictures/Mining/tiles"))
    update
  end

  def layer=(value)
    @layer=value
    @layer=0 if @layer<0
  end

  def update
    self.bitmap.clear
    if @layer>0
      self.bitmap.blt(0,0,@image.bitmap,Rect.new(0,32*(@layer-1),32,32))
    end
  end
end



class MiningGameCursor < BitmapSprite
  attr_accessor :mode
  attr_accessor :position
  attr_accessor :hit
  attr_accessor :counter
  ToolPositions = [[1,0],[1,1],[1,1],[0,0],[0,0],
                   [0,2],[0,2],[0,0],[0,0],[0,2],[0,2]]   # Graphic, position

  def initialize(position=0,mode=0)   # mode: 0=pick, 1=hammer
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    super(Graphics.width,Graphics.height,@viewport)
    @position = position
    @mode     = mode
    @hit      = 0   # 0=regular, 1=hit item, 2=hit iron
    @counter  = 0
    @cursorbitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Mining/cursor"))
    @toolbitmap   = AnimatedBitmap.new(_INTL("Graphics/Pictures/Mining/tools"))
    @hitsbitmap   = AnimatedBitmap.new(_INTL("Graphics/Pictures/Mining/hits"))
    update
  end

  def isAnimating?
    return @counter>0
  end

  def animate(hit)
    @counter = 22
    @hit     = hit
  end

  def update
    self.bitmap.clear
    x = 32*(@position%MiningGameScene::BOARDWIDTH)
    y = 32*(@position/MiningGameScene::BOARDWIDTH)
    if @counter>0
      @counter -= 1
      toolx = x; tooly = y
      i = 10-(@counter/2).floor
      if ToolPositions[i][1]==1
        toolx -= 8; tooly += 8
      elsif ToolPositions[i][1]==2
        toolx += 6
      end
      self.bitmap.blt(toolx,tooly,@toolbitmap.bitmap,
                      Rect.new(96*ToolPositions[i][0],96*@mode,96,96))
      if i<5 && i%2==0
        if @hit==2
          self.bitmap.blt(x-64,y,@hitsbitmap.bitmap,Rect.new(160*2,0,160,160))
        else
          self.bitmap.blt(x-64,y,@hitsbitmap.bitmap,Rect.new(160*@mode,0,160,160))
        end
      end
      if @hit==1 && i<3
        self.bitmap.blt(x-64,y,@hitsbitmap.bitmap,Rect.new(160*i,160,160,160))
      end
    else
      self.bitmap.blt(x,y+64,@cursorbitmap.bitmap,Rect.new(32*@mode,0,32,32))
    end
  end
end



class MiningGameScene
  BOARDWIDTH  = 13
  BOARDHEIGHT = 10



  IRON = [   # Graphic x, graphic y, width, height, pattern
     [0,0, 1,4,[1,1,1,1]],
     [1,0, 2,4,[1,1,1,1,1,1,1,1]],
     [3,0, 4,2,[1,1,1,1,1,1,1,1]],
     [3,2, 4,1,[1,1,1,1]],
     [7,0, 3,3,[1,1,1,1,1,1,1,1,1]],
     [0,5, 3,2,[1,1,0,0,1,1]],
     [0,7, 3,2,[0,1,0,1,1,1]],
     [3,5, 3,2,[0,1,1,1,1,0]],
     [3,7, 3,2,[1,1,1,0,1,0]],
     [6,3, 2,3,[1,0,1,1,0,1]],
     [8,3, 2,3,[0,1,1,1,1,0]],
     [6,6, 2,3,[1,0,1,1,1,0]],
     [8,6, 2,3,[0,1,1,1,0,1]]
  ]
  def getItems(type)
     case type
      when 2
	   return [   # Item, probability, graphic x, graphic y, width, height, pattern
     [:STONE,100, 6,24, 2,2,[1,1,1,1]],
     [:STONE,100, 6,24, 2,2,[1,1,1,1]],
     [:STONE,100, 6,24, 2,2,[1,1,1,1]],
     [:STONE,100, 6,24, 2,2,[1,1,1,1]],
     [:STONE,100, 6,24, 2,2,[1,1,1,1]],
     [:COAL,100, 6,24, 2,2,[1,1,1,1]],
     [:COAL,100, 6,24, 2,2,[1,1,1,1]],
     [:COAL,100, 6,24, 2,2,[1,1,1,1]],
     [:COAL,100, 6,24, 2,2,[1,1,1,1]],
     [:HARDSTONE,200, 6,24, 2,2,[1,1,1,1]],
     [:HARDSTONE,200, 6,24, 2,2,[1,1,1,1]],
     [:HARDSTONE,200, 6,24, 2,2,[1,1,1,1]],
     [:HARDSTONE,200, 6,24, 2,2,[1,1,1,1]],
     [:HARDSTONE,200, 6,24, 2,2,[1,1,1,1]],
     [:LIGHTCLAY,100, 6,20, 4,4,[1,0,1,0,1,1,1,0,1,1,1,1,0,1,0,1]],
     [:HARDSTONE,200, 6,24, 2,2,[1,1,1,1]],
     [:STONE,100, 6,24, 2,2,[1,1,1,1]]
  ]

      when 3
	   return [   # Item, probability, graphic x, graphic y, width, height, pattern

     [:ICESTONE,10, 27,16, 2,4,[1,0,1,1,1,1,0,1]],
     [:ICYROCK,50, 17,22, 4,4,[0,1,1,0,1,1,1,1,1,1,1,1,1,0,0,1]],
     [:COAL,100, 6,24, 2,2,[1,1,1,1]],
     [:COAL,100, 6,24, 2,2,[1,1,1,1]],
     [:COAL,100, 6,24, 2,2,[1,1,1,1]],
     [:COAL,100, 6,24, 2,2,[1,1,1,1]],
     [:COAL,100, 6,24, 2,2,[1,1,1,1]],
     [:STONE,100, 6,24, 2,2,[1,1,1,1]],
     [:STONE,100, 6,24, 2,2,[1,1,1,1]],
     [:HARDSTONE,100, 6,24, 2,2,[1,1,1,1]],
     [:HARDSTONE,100, 6,24, 2,2,[1,1,1,1]],
     [:COPPERORE,20, 20,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:COPPERORE,20, 20,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:COPPERORE,20, 20,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:COPPERORE,20, 20,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:SILVERORE,20, 8,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:SILVERORE,20, 8,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:SILVERORE,20, 8,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:SILVERORE,20, 8,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:STARPIECE,100, 0,17, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:STARPIECE,100, 0,17, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:STARPIECE,100, 0,17, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:STARPIECE,100, 0,17, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:STARPIECE,100, 0,17, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:STARPIECE,100, 0,17, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:THUNDERSTONE,60, 26,11, 3,3,[0,1,1,1,1,1,1,1,0]],
     [:THUNDERSTONE,60, 26,11, 3,3,[0,1,1,1,1,1,1,1,0]],
     [:THUNDERSTONE,60, 26,11, 3,3,[0,1,1,1,1,1,1,1,0]],
     [:GOLDORE,20, 4,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:IRONORE,100, 8,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:IRONORE,100, 8,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:IRONORE,100, 8,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:IRONORE,100, 8,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:IRONORE,100, 8,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]]
  ]
	  else
	  return [   # Item, probability, graphic x, graphic y, width, height, pattern
     [:DOMEFOSSIL,20, 0,3, 5,4,[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0]],
     [:HELIXFOSSIL,5, 5,3, 4,4,[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0]],
     [:HELIXFOSSIL,5, 9,3, 4,4,[1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1]],
     [:HELIXFOSSIL,5, 13,3, 4,4,[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0]],
     [:HELIXFOSSIL,5, 17,3, 4,4,[1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1]],
     [:OLDAMBER,10, 21,3, 4,4,[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0]],
     [:OLDAMBER,10, 25,3, 4,4,[1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1]],
     [:ROOTFOSSIL,5, 0,7, 5,5,[1,1,1,1,0,1,1,1,1,1,1,1,0,1,1,0,0,0,1,1,0,0,1,1,0]],
     [:ROOTFOSSIL,5, 5,7, 5,5,[0,0,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,1,1,1,0,1,1,1,0]],
     [:ROOTFOSSIL,5, 10,7, 5,5,[0,1,1,0,0,1,1,0,0,0,1,1,0,1,1,1,1,1,1,1,0,1,1,1,1]],
     [:ROOTFOSSIL,5, 15,7, 5,5,[0,1,1,1,0,1,1,1,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,0,0]],
     [:SKULLFOSSIL,20, 20,7, 4,4,[1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0]],
     [:ARMORFOSSIL,20, 24,7, 5,4,[0,1,1,1,0,0,1,1,1,0,1,1,1,1,1,0,1,1,1,0]],
     [:CLAWFOSSIL,5, 0,12, 4,5,[0,0,1,1,0,1,1,1,0,1,1,1,1,1,1,0,1,1,0,0]],
     [:CLAWFOSSIL,5, 4,12, 5,4,[1,1,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1]],
     [:CLAWFOSSIL,5, 9,12, 4,5,[0,0,1,1,0,1,1,1,1,1,1,0,1,1,1,0,1,1,0,0]],
     [:CLAWFOSSIL,5, 13,12, 5,4,[1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0,1,1]],
     [:FIRESTONE,20, 20,11, 3,3,[1,1,1,1,1,1,1,1,1]],
     [:FIRESTONE,20, 20,11, 3,3,[1,1,1,1,1,1,1,1,1]],
     [:FIRESTONE,20, 20,11, 3,3,[1,1,1,1,1,1,1,1,1]],
     [:WATERSTONE,20, 23,11, 3,3,[1,1,1,1,1,1,1,1,0]],
     [:WATERSTONE,20, 23,11, 3,3,[1,1,1,1,1,1,1,1,0]],
     [:WATERSTONE,20, 23,11, 3,3,[1,1,1,1,1,1,1,1,0]],
     [:THUNDERSTONE,60, 26,11, 3,3,[0,1,1,1,1,1,1,1,0]],
     [:THUNDERSTONE,60, 26,11, 3,3,[0,1,1,1,1,1,1,1,0]],
     [:THUNDERSTONE,60, 26,11, 3,3,[0,1,1,1,1,1,1,1,0]],
     [:LEAFSTONE,10, 18,14, 3,4,[0,1,0,1,1,1,1,1,1,0,1,0]],
     [:LEAFSTONE,10, 21,14, 4,3,[0,1,1,0,1,1,1,1,0,1,1,0]],
     [:MOONSTONE,10, 25,14, 4,2,[0,1,1,1,1,1,1,0]],
     [:MOONSTONE,10, 27,16, 2,4,[1,0,1,1,1,1,0,1]],
     [:DAWNSTONE,10, 27,16, 2,4,[1,0,1,1,1,1,0,1]],
     [:ICESTONE,10, 27,16, 2,4,[1,0,1,1,1,1,0,1]],
     [:ICESTONE,10, 27,16, 2,4,[1,0,1,1,1,1,0,1]],
     [:SUNSTONE,20, 21,17, 3,3,[0,1,0,1,1,1,1,1,1]],
     [:OVALSTONE,150, 24,17, 3,3,[1,1,1,1,1,1,1,1,1]],
     [:EVERSTONE,150, 21,20, 4,2,[1,1,1,1,1,1,1,1]],
     [:STARPIECE,100, 0,17, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:STARPIECE,100, 0,17, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:STARPIECE,100, 0,17, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:STARPIECE,100, 0,17, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:STARPIECE,100, 0,17, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:STARPIECE,100, 0,17, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:EVIOLITE,25, 0,20, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:EVIOLITE,25, 0,20, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:RAREBONE,50, 3,17, 6,3,[1,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,1]],
     [:RAREBONE,50, 3,20, 3,6,[1,1,1,0,1,0,0,1,0,0,1,0,0,1,0,1,1,1]],
     [:LIGHTCLAY,100, 6,20, 4,4,[1,0,1,0,1,1,1,0,1,1,1,1,0,1,0,1]],
     [:HARDSTONE,200, 6,24, 2,2,[1,1,1,1]],
     [:THUNDERSTONE,60, 26,11, 3,3,[0,1,1,1,1,1,1,1,0]],
     [:THUNDERSTONE,60, 26,11, 3,3,[0,1,1,1,1,1,1,1,0]],
     [:HEARTSCALE,200, 8,24, 2,2,[1,0,1,1]],
     [:IRONBALL,20, 9,17, 3,3,[1,1,1,1,1,1,1,1,1]],
     [:ODDKEYSTONE,10, 10,20, 4,4,[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]],
     [:HEATROCK,50, 12,17, 4,3,[1,0,1,0,1,1,1,1,1,1,1,1]],
     [:DAMPROCK,50, 14,20, 3,3,[1,1,1,1,1,1,1,0,1]],
     [:SMOOTHROCK,50, 17,18, 4,4,[0,0,1,0,1,1,1,0,0,1,1,1,0,1,0,0]],
     [:ICYROCK,50, 17,22, 4,4,[0,1,1,0,1,1,1,1,1,1,1,1,1,0,0,1]],
     [:REDSHARD,100, 21,22, 3,3,[1,1,1,1,1,0,1,1,1]],
     [:GREENSHARD,100, 25,20, 4,3,[1,1,1,1,1,1,1,1,1,1,0,1]],
     [:YELLOWSHARD,100, 25,23, 4,3,[1,0,1,0,1,1,1,0,1,1,1,1]],
     [:BLUESHARD,100, 26,26, 3,3,[1,1,1,1,1,1,1,1,0]],
     [:INSECTPLATE,10, 0,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:DREADPLATE,10, 4,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:DRACOPLATE,10, 8,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:ZAPPLATE,10, 12,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:FISTPLATE,10, 16,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:FLAMEPLATE,10, 20,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:MEADOWPLATE,10, 0,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:EARTHPLATE,10, 4,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:ICICLEPLATE,10, 8,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:TOXICPLATE,10, 12,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:MINDPLATE,10, 16,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:STONEPLATE,10, 20,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:SKYPLATE,10, 0,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:SPOOKYPLATE,10, 4,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:IRONPLATE,10, 8,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:SPLASHPLATE,10, 12,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:COAL,100, 6,24, 2,2,[1,1,1,1]],
     [:STONE,100, 6,24, 2,2,[1,1,1,1]],
     [:COPPERORE,20, 20,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:COPPERORE,20, 20,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:SILVERORE,20, 8,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:SILVERORE,20, 8,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:GOLDORE,20, 4,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:GOLDORE,20, 4,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:IRONORE,100, 8,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:IRONORE,100, 8,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:IRONORE,100, 8,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:IRONORE,100, 8,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]]
  ]

     end
  
  end
  def update
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene(type)
    @sprites={}
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    addBackgroundPlane(@sprites,"bg","Mining/miningbg",@viewport)
    @sprites["itemlayer"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @itembitmap=AnimatedBitmap.new(_INTL("Graphics/Pictures/Mining/items"))
    @ironbitmap=AnimatedBitmap.new(_INTL("Graphics/Pictures/Mining/irons"))
	@itemslist = getItems(type)
    @items=[]
    @itemswon=[]
    @iron=[]
    pbDistributeItems
    pbDistributeIron
    for i in 0...BOARDHEIGHT
      for j in 0...BOARDWIDTH
        @sprites["tile#{j+i*BOARDWIDTH}"]=MiningGameTile.new(32*j,64+32*i)
      end
    end
    @sprites["crack"]=MiningGameCounter.new(0,4)
    @sprites["cursor"]=MiningGameCursor.new(58,0)   # central position, pick
    @sprites["tool"]=IconSprite.new(434,254,@viewport)
    @sprites["tool"].setBitmap(sprintf("Graphics/Pictures/Mining/toolicons"))
    @sprites["tool"].src_rect.set(0,0,68,100)
    update
    pbFadeInAndShow(@sprites)
  end

  def pbDistributeItems
    # Set items to be buried (index in @itemslist, x coord, y coord)
    ptotal=0
    for i in @itemslist
      ptotal+=i[1]
    end
    numitems=3+rand(4)
	
    numitems+=2 if $player.is_it_this_class?(:HIKER)
    tries = 0
    while numitems>0
      rnd=rand(ptotal)
      added=false
      for i in 0...@itemslist.length
        rnd-=@itemslist[i][1]
        if rnd<0
          if pbNoDuplicateItems(@itemslist[i][0])
            while !added
              provx=rand(BOARDWIDTH-@itemslist[i][4]+1)
              provy=rand(BOARDHEIGHT-@itemslist[i][5]+1)
              if pbCheckOverlaps(false,provx,provy,@itemslist[i][4],@itemslist[i][5],@itemslist[i][6])
                @items.push([i,provx,provy])
                numitems-=1
                added=true
              end
            end
          else
            break
          end
        end
        break if added
      end
      tries += 1
      break if tries>=500
    end
    # Draw items on item layer
    layer=@sprites["itemlayer"].bitmap
    for i in @items
      ox=@itemslist[i[0]][2]
      oy=@itemslist[i[0]][3]
      rectx=@itemslist[i[0]][4]
      recty=@itemslist[i[0]][5]
      layer.blt(32*i[1],64+32*i[2],@itembitmap.bitmap,Rect.new(32*ox,32*oy,32*rectx,32*recty))
    end
  end

  def pbDistributeIron
    # Set iron to be buried (index in IRON, x coord, y coord)
    numitems=4+rand(3)
    tries = 0
    while numitems>0
      rnd=rand(IRON.length)
      provx=rand(BOARDWIDTH-IRON[rnd][2]+1)
      provy=rand(BOARDHEIGHT-IRON[rnd][3]+1)
      if pbCheckOverlaps(true,provx,provy,IRON[rnd][2],IRON[rnd][3],IRON[rnd][4])
        @iron.push([rnd,provx,provy])
        numitems-=1
      end
      tries += 1
      break if tries>=500
    end
    # Draw items on item layer
    layer=@sprites["itemlayer"].bitmap
    for i in @iron
      ox=IRON[i[0]][0]
      oy=IRON[i[0]][1]
      rectx=IRON[i[0]][2]
      recty=IRON[i[0]][3]
      layer.blt(32*i[1],64+32*i[2],@ironbitmap.bitmap,Rect.new(32*ox,32*oy,32*rectx,32*recty))
    end
  end

  def pbNoDuplicateItems(newitem)
    return true if newitem==[:HEARTSCALE,:STARPIECE]   # Allow multiple Heart Scales
    fossils=[:DOMEFOSSIL,:HELIXFOSSIL,:OLDAMBER,:ROOTFOSSIL,
             :SKULLFOSSIL,:ARMORFOSSIL,:CLAWFOSSIL]
    plates=[:INSECTPLATE,:DREADPLATE,:DRACOPLATE,:ZAPPLATE,:FISTPLATE,
            :FLAMEPLATE,:MEADOWPLATE,:EARTHPLATE,:ICICLEPLATE,:TOXICPLATE,
            :MINDPLATE,:STONEPLATE,:SKYPLATE,:SPOOKYPLATE,:IRONPLATE,:SPLASHPLATE]
    for i in @items
      preitem=@itemslist[i[0]][0]
      return false if preitem==newitem   # No duplicate items
      return false if fossils.include?(preitem) && fossils.include?(newitem)
      return false if plates.include?(preitem) && plates.include?(newitem)
    end
    return true
  end

  def pbCheckOverlaps(checkiron,provx,provy,provwidth,provheight,provpattern)
    for i in @items
      prex=i[1]
      prey=i[2]
      prewidth=@itemslist[i[0]][4]
      preheight=@itemslist[i[0]][5]
      prepattern=@itemslist[i[0]][6]
      next if provx+provwidth<=prex || provx>=prex+prewidth ||
              provy+provheight<=prey || provy>=prey+preheight
      for j in 0...prepattern.length
        next if prepattern[j]==0
        xco=prex+(j%prewidth)
        yco=prey+(j/prewidth).floor
        next if provx+provwidth<=xco || provx>xco ||
                provy+provheight<=yco || provy>yco
        return false if provpattern[xco-provx+(yco-provy)*provwidth]==1
      end
    end
    if checkiron   # Check other irons as well
      for i in @iron
        prex=i[1]
        prey=i[2]
        prewidth=IRON[i[0]][2]
        preheight=IRON[i[0]][3]
        prepattern=IRON[i[0]][4]
        next if provx+provwidth<=prex || provx>=prex+prewidth ||
                provy+provheight<=prey || provy>=prey+preheight
        for j in 0...prepattern.length
          next if prepattern[j]==0
          xco=prex+(j%prewidth)
          yco=prey+(j/prewidth).floor
          next if provx+provwidth<=xco || provx>xco ||
                  provy+provheight<=yco || provy>yco
          return false if provpattern[xco-provx+(yco-provy)*provwidth]==1
        end
      end
    end
    return true
  end

  def pbHit
    hittype=0
    position=@sprites["cursor"].position
    if @sprites["cursor"].mode==1   # Hammer
      pattern=[1,2,1,
               2,2,2,
               1,2,1]
      @sprites["crack"].hits+=2 if !($DEBUG && Input.press?(Input::CTRL))
	elsif @sprites["cursor"].mode==3
    else                            # Pick
      pattern=[0,1,0,
               1,2,1,
               0,1,0]
      @sprites["crack"].hits+=1 if !($DEBUG && Input.press?(Input::CTRL))
    end
    if @sprites["tile#{position}"].layer<=pattern[4] && pbIsIronThere?(position)
      @sprites["tile#{position}"].layer-=pattern[4]
      pbSEPlay("Mining iron")
      hittype=2
    else
      for i in 0..2
        ytile=i-1+position/BOARDWIDTH
        next if ytile<0 || ytile>=BOARDHEIGHT
        for j in 0..2
          xtile=j-1+position%BOARDWIDTH
          next if xtile<0 || xtile>=BOARDWIDTH
          @sprites["tile#{xtile+ytile*BOARDWIDTH}"].layer-=pattern[j+i*3]
        end
      end
      if @sprites["cursor"].mode==1   # Hammer
        pbSEPlay("Mining hammer")
	  elsif @sprites["cursor"].mode==3
      else
        pbSEPlay("Mining pick")
      end
    end
    update
    Graphics.update
    hititem=(@sprites["tile#{position}"].layer==0 && pbIsItemThere?(position))
    hittype=1 if hititem
    @sprites["cursor"].animate(hittype)
    revealed=pbCheckRevealed
    if revealed.length>0
      pbSEPlay("Mining reveal full")
      pbFlashItems(revealed)
    elsif hititem
      pbSEPlay("Mining reveal")
    end
  end

  def pbIsItemThere?(position)
    posx=position%BOARDWIDTH
    posy=position/BOARDWIDTH
    for i in @items
      index=i[0]
      width=@itemslist[index][4]
      height=@itemslist[index][5]
      pattern=@itemslist[index][6]
      next if posx<i[1] || posx>=(i[1]+width)
      next if posy<i[2] || posy>=(i[2]+height)
      dx=posx-i[1]
      dy=posy-i[2]
      return true if pattern[dx+dy*width]>0
    end
    return false
  end

  def pbIsIronThere?(position)
    posx=position%BOARDWIDTH
    posy=position/BOARDWIDTH
    for i in @iron
      index=i[0]
      width=IRON[index][2]
      height=IRON[index][3]
      pattern=IRON[index][4]
      next if posx<i[1] || posx>=(i[1]+width)
      next if posy<i[2] || posy>=(i[2]+height)
      dx=posx-i[1]
      dy=posy-i[2]
      return true if pattern[dx+dy*width]>0
    end
    return false
  end

  def pbCheckRevealed
    ret=[]
    for i in 0...@items.length
      next if @items[i][3]
      revealed=true
      index=@items[i][0]
      width=@itemslist[index][4]
      height=@itemslist[index][5]
      pattern=@itemslist[index][6]
      for j in 0...height
        for k in 0...width
          layer=@sprites["tile#{@items[i][1]+k+(@items[i][2]+j)*BOARDWIDTH}"].layer
          revealed=false if layer>0 && pattern[k+j*width]>0
          break if !revealed
        end
        break if !revealed
      end
      ret.push(i) if revealed
    end
    return ret
  end

  def pbFlashItems(revealed)
    return if revealed.length<=0
    revealeditems = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    halfFlashTime = Graphics.frame_rate/8
    alphaDiff = (255.0/halfFlashTime).ceil
    for i in 1..halfFlashTime*2
      for index in revealed
        burieditem=@items[index]
        revealeditems.bitmap.blt(32*burieditem[1],64+32*burieditem[2],
           @itembitmap.bitmap,
           Rect.new(32*@itemslist[burieditem[0]][2],32*@itemslist[burieditem[0]][3],
           32*@itemslist[burieditem[0]][4],32*@itemslist[burieditem[0]][5]))
        if i>halfFlashTime
          revealeditems.color = Color.new(255,255,255,(halfFlashTime*2-i)*alphaDiff)
        else
          revealeditems.color = Color.new(255,255,255,i*alphaDiff)
        end
      end
      update
      Graphics.update
    end
    revealeditems.dispose
    for index in revealed
      @items[index][3]=true
      item=@itemslist[@items[index][0]][0]
      @itemswon.push(item)
    end
  end

  def pbMain
    pbSEPlay("Mining ping")
    pbMessage(_INTL("Something pinged in the wall!\n{1} confirmed!", @items.length))
    loop do
      update
      Graphics.update
      Input.update
      next if @sprites["cursor"].isAnimating?
      # Check end conditions
	   hitsamt = 49
	   hitsamt += 10 if $player.is_it_this_class?(:HIKER)
      if @sprites["crack"].hits >= hitsamt
        @sprites["cursor"].visible = false
        pbSEPlay("Mining collapse")
        collapseviewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
        collapseviewport.z = 99999
        @sprites["collapse"] = BitmapSprite.new(Graphics.width, Graphics.height, collapseviewport)
        collapseTime = Graphics.frame_rate * 8 / 10
        collapseFraction = (Graphics.height.to_f / collapseTime).ceil
        (1..collapseTime).each do |i|
          @sprites["collapse"].bitmap.fill_rect(0, collapseFraction * (i - 1),
                                                Graphics.width, collapseFraction * i, Color.new(0, 0, 0))
          Graphics.update
        end
        pbMessage(_INTL("The wall collapsed!"))
        break
      end
      foundall = true
      @items.each do |i|
        foundall = false if !i[3]
        break if !foundall
      end
      if foundall
        @sprites["cursor"].visible = false
        pbWait(Graphics.frame_rate * 3 / 4)
        pbSEPlay("Mining found all")
        pbMessage(_INTL("Everything was dug up!"))
        break
      end
      # Input
      #mousetech
      if Input.mouse_in_window?
        if Input.trigger?(Input::MOUSERIGHT)
		  	  # mode: 0=pick, 1=hammer
		   if hasPickaxe? && hasHammer?
              pbSEPlay("Mining tool change")
              newmode = (@sprites["cursor"].mode + 1) % 2
              @sprites["cursor"].mode = newmode
              @sprites["tool"].src_rect.set(newmode * 68, 0, 68, 100)
              @sprites["tool"].y = 254 - (144 * newmode)
		   end
        end
        if Input.mouse_x.between?(0+$PokemonSystem.screenposx,13*32+$PokemonSystem.screenposx) && Input.mouse_y.between?(64+$PokemonSystem.screenposy,64+10*32+$PokemonSystem.screenposy) #Mouse is on board
          x = Input.mouse_x/32
          y = (Input.mouse_y-64)/32
          newpos = x + y*13
          @sprites["cursor"].position = newpos
		 if hasPickaxe? 
		 pick = GameData::Item.get(getPickaxe)
		 name = pick.name
		 #pick.decreaseDurability(1)
		 if !hasPickaxe?
		   pbMessage(_INTL("Your #{name} broke!"))
		   @sprites["cursor"].mode=1
		 end
		end
		if hasHammer?
		 ham = GameData::Item.get(getHammer)
		 name = ham.name
		 #ham.decreaseDurability(1)
		 if !hasHammer?
		   pbMessage(_INTL("Your #{name} broke!"))
		   @sprites["cursor"].mode=0
		 end
		end
		if $PokemonSystem.survivalmode == 0 
          case $player.playerstamina
           when 0
             $player.playersleep -= 10
			 if $player.playersaturation>0
               $player.playersaturation -= 10 #take from saturation
			 else
               $player.playerfood -= 7#take from hunger
               $player.playerwater -= 7#take from drinking
			 end
             if $player.playerfood==0
			    $player.playerhealth-10
			 end
             if $player.playerwater==0
			    $player.playerhealth-10
			 end
          else
             $player.playerstamina -= 1
          end
        end
        break if $player.playerhealth==0
		
		pbMessage(_INTL("You don't have either a Hammer or a Pickaxe!")) if !hasPickaxe? && !hasHammer?
        break if !hasPickaxe? && !hasHammer?
          pbHit if Input.trigger?(Input::MOUSELEFT)
        elsif Input.mouse_x.between?(428+$PokemonSystem.screenposx,508+$PokemonSystem.screenposy) #mouse is by tool icons
          if Input.mouse_y.between?(98+$PokemonSystem.screenposx,216+$PokemonSystem.screenposy) #mouse is by hammer
            if Input.trigger?(Input::MOUSELEFT) && hasHammer?
              pbSEPlay("Mining tool change")
              newmode = 1
              @sprites["cursor"].mode = newmode
              @sprites["tool"].src_rect.set(newmode * 68, 0, 68, 100)
              @sprites["tool"].y = 254 - (144 * newmode)
            end
          elsif Input.mouse_y.between?(242+$PokemonSystem.screenposx,360+$PokemonSystem.screenposy) #mouse is by pick
            if Input.trigger?(Input::MOUSELEFT) && hasPickaxe?
              pbSEPlay("Mining tool change")
              newmode = 0
              @sprites["cursor"].mode = newmode
              @sprites["tool"].src_rect.set(newmode * 68, 0, 68, 100)
              @sprites["tool"].y = 254 - (144 * newmode)
            end
          end
        end
      elsif Input.trigger?(Input::UP) || Input.repeat?(Input::UP)
        if @sprites["cursor"].position >= 13
          pbSEPlay("Mining cursor")
          @sprites["cursor"].position -= 13
        end
      elsif Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN)
        if @sprites["cursor"].position < (13 * (10 - 1))
          pbSEPlay("Mining cursor")
          @sprites["cursor"].position += 13
        end
      elsif Input.trigger?(Input::LEFT) || Input.repeat?(Input::LEFT)
        if @sprites["cursor"].position % 13 > 0
          pbSEPlay("Mining cursor")
          @sprites["cursor"].position -= 1
        end
      elsif Input.trigger?(Input::RIGHT) || Input.repeat?(Input::RIGHT)
        if @sprites["cursor"].position % 13 < (13 - 1)
          pbSEPlay("Mining cursor")
          @sprites["cursor"].position += 1
        end
      elsif Input.trigger?(Input::ACTION)   # Change tool mode
		   if hasPickaxe? && hasHammer?
        pbSEPlay("Mining tool change")
        newmode = (@sprites["cursor"].mode + 1) % 2
        @sprites["cursor"].mode = newmode
        @sprites["tool"].src_rect.set(newmode * 68, 0, 68, 100)
        @sprites["tool"].y = 254 - (144 * newmode)
		   end
      elsif Input.trigger?(Input::USE) || ( !(Input.mouse_x.between?(0+$PokemonSystem.screenposx,13*32+$PokemonSystem.screenposx) && Input.mouse_y.between?(64+$PokemonSystem.screenposy,64+10*32+$PokemonSystem.screenposy)) && Input.trigger?(Input::MOUSELEFT) )   # Hit
	  # mode: 0=pick, 1=hammer
		if hasPickaxe? 
		 pick = GameData::Item.get(getPickaxe)
		 name = pick.name
		 #pick.decreaseDurability(1)
		 if !hasPickaxe?
		   pbMessage(_INTL("Your #{name} broke!"))
		   @sprites["cursor"].mode=1
		 end
		end
		if hasHammer?
		 ham = GameData::Item.get(getHammer)
		 name = ham.name
		 #ham.decreaseDurability(1)
		 if !hasHammer?
		   pbMessage(_INTL("Your #{name} broke!"))
		   @sprites["cursor"].mode=0
		 end
		end
		if $PokemonSystem.survivalmode == 0 
          case $player.playerstamina
           when 0
             $player.playersleep -= 10
			 if $player.playersaturation>0
               $player.playersaturation -= 10 #take from saturation
			 else
               $player.playerfood -= 7#take from hunger
               $player.playerwater -= 7#take from drinking
			 end
             if $player.playerfood==0
			    $player.playerhealth-10
			 end
             if $player.playerwater==0
			    $player.playerhealth-10
			 end
          else
             $player.playerstamina -= 1
          end
        end
        break if $player.playerhealth==0
		
		pbMessage(_INTL("You don't have either a Hammer or a Pickaxe!")) if !hasPickaxe? && !hasHammer?
        break if !hasPickaxe? && !hasHammer?
        pbHit
      elsif Input.trigger?(Input::BACK)   # Quit
        break if pbConfirmMessage(_INTL("Are you sure you want to give up?"))
      end
    end
    pbGiveItems
  end

  def pbGiveItems
    if @itemswon.length>0
      for i in @itemswon
        if GameData::Item.get(i).id == :STONE || GameData::Item.get(i).id == :HARDSTONE || GameData::Item.get(i).id == :COAL
        if $bag.add(i,rand(4)+1)
          pbMessage(_INTL("Some {1} was obtained.\\se[Mining item get]\\wtnp[30]",
             GameData::Item.get(i).name))
        else
          pbMessage(_INTL("Some {1} was found, but you have no room for it.",
             GameData::Item.get(i).name))
        end
        else
        if $bag.add(i)
          pbMessage(_INTL("One {1} was obtained.\\se[Mining item get]\\wtnp[30]",
             GameData::Item.get(i).name))
        else
          pbMessage(_INTL("One {1} was found, but you have no room for it.",
             GameData::Item.get(i).name))
        end
        end
      end
    end
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end



class MiningGame
  def initialize(scene)
    @scene=scene
  end

  def pbStartScreen(type)
     loop do
   if !hasPickaxe? && !hasHammer?
  pbMessage(_INTL("You don't have a Pick or a Hammer!"))
  break
  end
    @scene.pbStartScene(type)
    @scene.pbMain
  if !pbConfirmMessage(_INTL("Would you like to continue mining?"))
    break
  end
    end
    @scene.pbEndScene
  end
end

def hasPickaxe?
 return true if $bag.has?(:IRONPICKAXE)
 return false
end
def getPickaxe
  return :STONEPICKAXE if $bag.has?(:STONEPICKAXE)
  return :IRONPICKAXE if $bag.has?(:IRONPICKAXE)
end

def hasHammer?
 return true if $bag.has?(:STONEHAMMER)||$bag.has?(:IRONHAMMER)
 return false
end
def getHammer
  return :STONEHAMMER if $bag.has?(:STONEHAMMER)
  return :IRONHAMMER if $bag.has?(:IRONHAMMER)
end

def pbMiningGame(type=0)

 if !hasPickaxe? && !hasHammer?
  pbMessage(_INTL("You don't have a Pick or a Hammer!"))
 else
  pbFadeOutIn {
    scene = MiningGameScene.new
    screen = MiningGame.new(scene)
    screen.pbStartScreen(type)
  }
  end
end


def ov_mining(type)
 interp = pbMapInterpreter
 this_event = interp.get_self
 if hasPickaxe?
  image = nil
  pbMessage(_INTL("You hack away at it with a Pickaxe."))
   amt = rand(4)+1
  case type 
   when :TUMBLEROCK
     image = "Legends_Tumblestone"
   when :STONE
     image = "Legends_Tumblestone"
   
   when :IRON2
     image = "Legends_Tumblestone"
   else
     image = "Legends_Tumblestone"
  end
   amt *= 2 if $player.is_it_this_class?(:HIKER,false) && rand(100)<=25
  route = [PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 1,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 2,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 3,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 0]
  pbMoveRoute2(this_event,route)
  if !$bag.add(type,amt)
  pbMessage(_INTL("You don't have space!"))
  else 
   itemAnim(type,amt)
   pbSetEventTime

  end
 else 
  pbMessage(_INTL("While you don't have a pickaxe, you chip off a piece of the #{GameData::Item.get(type).name}."))
   amt = rand(2)+1
   amt *= 2 if $player.is_it_this_class?(:HIKER,false) && rand(100)<=25
  if !$bag.add(type,amt)
  pbMessage(_INTL("You don't have space!"))
  else 
   itemAnim(type,amt)
  pbSetEventTimeB

  end
 end
end


def ov_mining2(type)
 interp = pbMapInterpreter
 this_event = interp.get_self
 if hasPickaxe?
  image = nil
  pbMessage(_INTL("You hack away at it with a Pickaxe."))
   amt = rand(4)+1
  case type 
   when :TUMBLEROCK
     image = "Legends_Tumblestone"
	  amt = rand(4)+1
   when :STONE
     image = "Legends_Tumblestone"
   
   when :IRON2
     image = "Legends_Tumblestone"
   else
     image = "Legends_Tumblestone"
  end
  route = [PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 1,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 2,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 3,
		   PBMoveRoute::Wait,4,
          PBMoveRoute::Graphic, image, 0, 2, 0]
  pbMoveRoute2(this_event,route)
   amt *= 2 if $player.is_it_this_class?(:HIKER) && rand(100)<=25
  if !$bag.add(type,amt)
  pbMessage(_INTL("You don't have space!"))
  else 
   itemAnim(type,amt)
   pbSetEventTime

  end
 else 
  pbMessage(_INTL("While you don't have a pickaxe, you chip off a piece of the #{GameData::Item.get(type).name}."))
   amt = rand(2)+1
   amt *= 2 if $player.is_it_this_class?(:HIKER) && rand(100)<=25
  if !$bag.add(type,amt)
  pbMessage(_INTL("You don't have space!"))
  else 
   itemAnim(type,amt)

  end
 end
end
