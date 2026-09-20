class MiningGameCounter < BitmapSprite
  attr_accessor :hits

  def initialize(x,y)
    @viewport=Viewport.new(x,y,208,30)
    @viewport.z=99999
    super(208,30,@viewport)
    @hits=0
    @image=AnimatedBitmap.new(_INTL("Graphics/Pictures/Mining/cracks"))
    update
  end

  def update
    self.bitmap.clear
    value=@hits
    startx=208-24
    while value>6
      self.bitmap.blt(startx,0,@image.bitmap,Rect.new(0,0,24,26))
      startx-=24
      value-=6
    end
    startx-=24
    if value>0
      self.bitmap.blt(startx,0,@image.bitmap,Rect.new(0,value*26,48,26))
    end
  end
end

class MiningGameCounterBackground < BitmapSprite

  def initialize(x,y)
    @viewport=Viewport.new(x,y,208,30)
    @viewport.z=99999
    super(208,30,@viewport)
    @image=AnimatedBitmap.new(_INTL("Graphics/Pictures/Mining/cracksbg"))
    update
  end

  def update
    self.bitmap.clear
    self.bitmap.blt(0,0,@image.bitmap,Rect.new(0,0,@image.bitmap.width,@image.bitmap.height))
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



class MiningGameCursorOld < BitmapSprite
  attr_accessor :mode
  attr_accessor :position
  attr_accessor :hit
  attr_accessor :counter
  attr_accessor :x_offset
  attr_accessor :y_offset
  ToolPositions = [[1,0],[1,1],[1,1],[0,0],[0,0],
                   [0,2],[0,2],[0,0],[0,0],[0,2],[0,2]]   # Graphic, position

  def initialize(position=0,mode=0,x_offset=0,y_offset=0)   # mode: 0=pick, 1=hammer, 2:None
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    super(Graphics.width,Graphics.height,@viewport)
    @position = position
    @mode     = mode
    @x_offset = x_offset
    @y_offset = y_offset
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
    x = @x_offset + 32*(@position%MiningGameScene::BOARDWIDTH)
    y = @y_offset + 32*(@position/MiningGameScene::BOARDWIDTH)
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

class MiningGameCursor < BitmapSprite
  attr_accessor :mode
  attr_accessor :position
  attr_accessor :hit
  attr_accessor :counter
  attr_accessor :pixel_x
  attr_accessor :pixel_y
  ToolPositions = [[1,0],[1,1],[1,1],[0,0],[0,0],
                   [0,2],[0,2],[0,0],[0,0],[0,2],[0,2]]
  HARD_OFFSET_X = -22
  HARD_OFFSET_Y = 0
  TOOL_CENTER_OFFSET = {
    [0,0] => [65 + HARD_OFFSET_X,47 + HARD_OFFSET_Y],  # pick, resting graphic
    [0,1] => [50 + HARD_OFFSET_X,41 + HARD_OFFSET_Y],  # pick, raised graphic
    [1,0] => [70 + HARD_OFFSET_X,48 + HARD_OFFSET_Y],  # hammer, resting graphic
    [1,1] => [43 + HARD_OFFSET_X,41 + HARD_OFFSET_Y],  # hammer, raised graphic
  }.freeze

  def initialize(position=0,mode=0,x_offset=0,y_offset=0)
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    super(Graphics.width,Graphics.height,@viewport)
    @position = position
    @mode     = mode
    @hit      = 0   # 0=regular, 1=hit item, 2=hit iron
    @counter  = 0
    @pixel_x  = x_offset + 32*(position%MiningGameScene::BOARDWIDTH)
    @pixel_y  = y_offset + 32*(position/MiningGameScene::BOARDWIDTH)
    @anim_x   = @pixel_x
    @anim_y   = @pixel_y
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
    @anim_x  = @pixel_x
    @anim_y  = @pixel_y
  end

  def update
    self.bitmap.clear
    if @counter>0
      x = @anim_x; y = @anim_y
      @counter -= 1
      i = 10-(@counter/2).floor
      graphic_col = ToolPositions[i][0]
      offset_x, offset_y = TOOL_CENTER_OFFSET[[@mode, graphic_col]]
      toolx = x - offset_x
      tooly = y - offset_y
      if ToolPositions[i][1]==1
        toolx -= 8; tooly += 8
      elsif ToolPositions[i][1]==2
        toolx += 6
      end
      self.bitmap.blt(toolx,tooly,@toolbitmap.bitmap,
                      Rect.new(96*graphic_col,96*@mode,96,96))
      if i<5 && i%2==0
        if @hit==2
          self.bitmap.blt(x-80,y-80,@hitsbitmap.bitmap,Rect.new(160*2,0,160,160))
        else
          self.bitmap.blt(x-80,y-80,@hitsbitmap.bitmap,Rect.new(160*@mode,0,160,160))
        end
      end
      if @hit==1 && i<3
        self.bitmap.blt(x-80,y-80,@hitsbitmap.bitmap,Rect.new(160*i,160,160,160))
      end
    elsif @mode != 2
      offset_x, offset_y = TOOL_CENTER_OFFSET[[@mode, 0]]
      self.bitmap.blt(@pixel_x - offset_x, @pixel_y - offset_y,@toolbitmap.bitmap,Rect.new(0,96*@mode,96,96))
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
  when 1, :STONEMINE
    return MiningGameItems::STONEMINE
  when 2, :COLDMINE
    return MiningGameItems::COLDMINE
  when 0, :MOUNTAINMINE
    return MiningGameItems::MOUNTAINMINE
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
	@x_offset = 48
	@y_offset = 0
    @sprites["itemlayer"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
	@sprites["itemlayer"].x += @x_offset 
	@sprites["itemlayer"].y += @y_offset 
    @itembitmap=AnimatedBitmap.new(_INTL("Graphics/Pictures/Mining/items"))
    @ironbitmap=AnimatedBitmap.new(_INTL("Graphics/Pictures/Mining/irons"))
	@itemslist = getItems(type)
	@pickaxe = getPickaxe
	@hammer = getHammer
    @items=[]
    @itemswon=[]
    @iron=[]
    pbDistributeItems
    pbDistributeIron
    for i in 0...BOARDHEIGHT
      for j in 0...BOARDWIDTH
        @sprites["tile#{j+i*BOARDWIDTH}"]=MiningGameTile.new(@x_offset + 32*j, @y_offset + 64+32*i)
      end
    end
	mininggamecounter_x = @x_offset - 2
	mininggamecounter_y = @y_offset + 30
    @sprites["crackbg"]=MiningGameCounterBackground.new(mininggamecounter_x, mininggamecounter_y)
    @sprites["crack"]=MiningGameCounter.new(mininggamecounter_x, mininggamecounter_y)
	$mouse.disable 
    @sprites["cursor"]=MiningGameCursor.new(58,0,@x_offset,@y_offset)   # central position, pick
    @sprites["tool"]=IconSprite.new(434,254,@viewport)
    @sprites["tool"].setBitmap(sprintf("Graphics/Pictures/Mining/toolicons"))
    @sprites["tool"].src_rect.set(0,0,68,100)
    @sprites["tool"].visible = false 
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
	elsif @sprites["cursor"].mode==2
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
	  elsif @sprites["cursor"].mode==2
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
	  cur_pattern = pattern[dx+dy*width]
      return true if cur_pattern && cur_pattern > 0
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
        revealeditems.bitmap.blt(@x_offset + 32*burieditem[1], @y_offset + 64+32*burieditem[2],
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

  def drops_multiple?(id)
    return id == :STONE || id == :HARDSTONE || id == :COAL
  end 

  def pbGiveItems
    return unless @itemswon.length>0
    for drop in @itemswon
	 item = ItemData.new(drop)
	 amount = drops_multiple?(item.id) ? rand(4)+1 : 1
	 if $bag.add(item, amount)
	   itemAnim(item, amount)
	 else 
	   sideDisplay(_INTL("You have no more room for items, you leave some behind."))
	   break
	 end 
    end
  end





  def pbEndScene
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end


  def pbMain
    pbSEPlay("Mining ping")
	
  #  pbMessage(_INTL("Something pinged in the wall!\n{1} confirmed!", @items.length))

    loop do
      update
      Graphics.update
      Input.update
      next if @sprites["cursor"].isAnimating?

      break if check_end_conditions
      break if handle_input
    end

    pbGiveItems
  end


def check_end_conditions
  hitsamt = 49
  hitsamt += 10 if $player.is_it_this_class?(:HIKER)

  if @sprites["crack"].hits >= hitsamt
    collapse
    return true
  end

  if found_all?
    @sprites["cursor"].visible = false
    pbWait(Graphics.frame_rate * 3 / 4)
    pbSEPlay("Mining found all")
    sideDisplay(_INTL("Everything was dug up!"))
    return true
  end

  false
end

def found_all?
  @items.each do |i|
    return false unless i[3]
  end
  true
end

def collapse
  @sprites["cursor"].visible = false
  pbSEPlay("Mining collapse")

  collapseviewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  collapseviewport.z = 99999
  @sprites["collapse"] = BitmapSprite.new(
    Graphics.width,
    Graphics.height,
    collapseviewport
  )

  collapseTime = Graphics.frame_rate * 8 / 10
  collapseFraction = (Graphics.height.to_f / collapseTime).ceil

  (1..collapseTime).each do |i|
    @sprites["collapse"].bitmap.fill_rect(
      0,
      collapseFraction * (i - 1),
      Graphics.width,
      collapseFraction * i,
      Color.new(0, 0, 0)
    )
    Graphics.update
  end

  sideDisplay(_INTL("The wall collapsed!"))
end

def handle_input
  if Input.mouse_in_window?
    return handle_mouse_input
  elsif Input.trigger?(Input::UP) || Input.repeat?(Input::UP)
    move_cursor(13, -1)
  elsif Input.trigger?(Input::DOWN) || Input.repeat?(Input::DOWN)
    move_cursor(13, 1)
  elsif Input.trigger?(Input::LEFT) || Input.repeat?(Input::LEFT)
    move_cursor(1, -1)
  elsif Input.trigger?(Input::RIGHT) || Input.repeat?(Input::RIGHT)
    move_cursor(1, 1)
  elsif Input.trigger?(Input::ACTION)
    change_tool
  elsif Input.trigger?(Input::USE)
    hit
  elsif Input.trigger?(Input::BACK)
    return quit_mining
  end
  return false 
end

def move_cursor(amount, direction)
  position = @sprites["cursor"].position

  if direction < 0
    return if position < amount.abs
  else
    return if position + amount >= 13 * 10
  end

  if direction == -1 && position % 13 == 0
    return
  elsif direction == 1 && position % 13 == 12
    return
  end

  pbSEPlay("Mining cursor")
  @sprites["cursor"].position += amount * direction
end

def change_tool
  return if @sprites["cursor"].mode == 2
  return unless hasPickaxe? && hasHammer?

  $mouse.disable 
  pbSEPlay("Mining tool change")
  newmode = (@sprites["cursor"].mode + 1) % 2
  @sprites["cursor"].mode = newmode
  @sprites["tool"].src_rect.set(newmode * 68, 0, 68, 100)
  @sprites["tool"].y = 254 - (144 * newmode)
end

def handle_mouse_input
  @sprites["cursor"].pixel_x = Input.mouse_x
  @sprites["cursor"].pixel_y = Input.mouse_y
  if Input.trigger?(Input::MOUSEMIDDLE) || Input.triggerex?(:TAB)
    change_tool
  elsif Input.trigger?(Input::MOUSERIGHT)
    return quit_mining
  elsif mouse_on_board?
    @sprites["cursor"].position = mouse_board_position
    if Input.trigger?(Input::MOUSELEFT)
      hit
    end
  end
  return false 
end

def mouse_on_board?
  Input.mouse_x.between?(
    @x_offset + $PokemonSystem.screenposx,
    @x_offset + 13 * 32 + $PokemonSystem.screenposx
  ) &&
    Input.mouse_y.between?(
      @y_offset + 64 + $PokemonSystem.screenposy,
      @y_offset + 64 + 10 * 32 + $PokemonSystem.screenposy
    )
end

def mouse_board_position
  x = (Input.mouse_x - @x_offset) / 32
  y = (Input.mouse_y - @y_offset - 64) / 32
  x + y * 13
end

def mouse_on_tools?
  Input.mouse_x.between?(
    428 + $PokemonSystem.screenposx,
    508 + $PokemonSystem.screenposx
  ) &&
    Input.mouse_y.between?(
      98 + $PokemonSystem.screenposy,
      360 + $PokemonSystem.screenposy
    )
end

def handle_tool_click
  if Input.mouse_y.between?(
       98 + $PokemonSystem.screenposy,
       216 + $PokemonSystem.screenposy
     )
    select_tool(1) if Input.trigger?(Input::MOUSELEFT) && hasHammer?
  elsif Input.mouse_y.between?(
          242 + $PokemonSystem.screenposy,
          360 + $PokemonSystem.screenposy
        )
    select_tool(0) if Input.trigger?(Input::MOUSELEFT) && hasPickaxe?
  end
end

def select_tool(mode)
  return if @sprites["cursor"].mode == 2
  pbSEPlay("Mining tool change")
  @sprites["cursor"].mode = mode
  @sprites["tool"].src_rect.set(mode * 68, 0, 68, 100)
  @sprites["tool"].y = 254 - (144 * mode)
end

def hit
  check_tools
  if @sprites["cursor"].mode == 2
    sideDisplay(_INTL("You don't have any tools to mine with!"))
    return
  end 
  if $PokemonSystem.survivalmode == 0
    use_stamina
  end

  return if $player.playerhealth == 0

  unless hasPickaxe? || hasHammer?
    sideDisplay(_INTL("You don't have any tools to mine with!"))
    return
  end
  
  unless hasHammer?
    sideDisplay(_INTL("You don't have a Hammer!"))
    return
  end
  unless hasPickaxe?
    sideDisplay(_INTL("You don't have either a Pickaxe!"))
    return
  end

  pbHit
end

def check_tools
  if hasPickaxe?
    if @pickaxe.durability == 0 
      sideDisplay(_INTL("Your #{@pickaxe.name} broke!"))
      @sprites["cursor"].mode = 1 if @hammer.durability == 0 
    end
  end
  if hasHammer?
    if @hammer.durability == 0 
      sideDisplay(_INTL("Your #{@hammer.name} broke!"))
      @sprites["cursor"].mode = 0 if @pickaxe.durability == 0 
    end
  end
  if @hammer.durability == 0 && @pickaxe.durability == 0 
      @sprites["cursor"].mode = 2
	  $mouse.enable 
  end 
end

def use_stamina
  case $player.playerstamina
  when 0
    $player.playersleep -= 10

    if $player.playersaturation > 0
      $player.playersaturation -= 10
    else
      $player.playerfood -= 7
      $player.playerwater -= 7
    end

    $player.playerhealth -= 10 if $player.playerfood == 0 || $player.playerwater == 0
  else
    $player.playerstamina -= 1
  end
end

def quit_mining
  pbConfirmMessage(_INTL("Are you sure you want to give up?"))
end

def hasPickaxe?
 $bag.has?(:IRONPICKAXE) && @pickaxe
end

def getPickaxe
  return $bag.get_sym(:IRONPICKAXE) if $bag.has?(:IRONPICKAXE)
end

def getHammer
  return $bag.get_sym(:IRONHAMMER) if $bag.has?(:IRONHAMMER)
end

def hasHammer?
 $bag.has?(:IRONHAMMER) && @hammer
end

end


class MiningGameItems
STONEMINE = [
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
].freeze

COLDMINE = [
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
  [:IRONORE,100, 8,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]]
].freeze

MOUNTAINMINE = [
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
  [:EVERSTONE,150, 21,20, 4,2,[1,1,1,1,1,1,1]],
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
  [:DREADPLATE,10, 4,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1]],
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
  [:IRONORE,100, 8,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]]
].freeze



end 


class MiningGame
  def initialize(scene)
    @scene=scene
  end

  def pbStartScreen(type)
 #   loop do
     @scene.pbStartScene(type)
     @scene.pbMain
 #    if !pbConfirmMessage(_INTL("Would you like to continue mining?"))
 #     break
 #    end
 #   end
    @scene.pbEndScene
  end
end



def pbMiningGame(type=0)

  pbFadeOutIn {
    scene = MiningGameScene.new
    screen = MiningGame.new(scene)
    screen.pbStartScreen(type)
  }
end
