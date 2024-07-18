class PokemonSystem
  attr_accessor :battlesize

  def initialize
    @textspeed     = 1     # Text speed (0=slow, 1=normal, 2=fast)
    @battlescene   = 0     # Battle effects (animations) (0=on, 1=off)
    @battlestyle   = 0     # Battle style (0=switch, 1=set)
    @sendtoboxes   = 0     # Send to Boxes (0=manual, 1=automatic)
    @givenicknames = 0     # Give nicknames (0=give, 1=don't give)
    @frame         = 0     # Default window frame (see also Settings::MENU_WINDOWSKINS)
    @textskin      = 0     # Speech frame
    @screensize    = (Settings::SCREEN_SCALE * 2).floor - 1   # 0=half size, 1=full size, 2=full-and-a-half size, 3=double size
    @language      = 0     # Language (see also Settings::LANGUAGES in script PokemonSystem)
    @runstyle      = 0     # Default movement speed (0=walk, 1=run)
    @bgmvolume     = 100   # Volume of background music and ME
    @sevolume      = 100   # Volume of sound effects
    @textinput     = 0     # Text input mode (0=cursor, 1=keyboard)
    @battlesize    = 0     # Battle size (0 = single, 1 = double 2 = triple)
  end
end

MenuHandlers.add(:options_menu, :text_input_style, {
  "name"        => _INTL("Battle Size"),
  "parent"      => :gameplay_menu,
  "order"       => 55,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Single"), _INTL("Double"), _INTL("Triple")],
  "description" => _INTL("Choose the size battles are fought in."),
  "get_proc"    => proc { next $PokemonSystem.battlesize },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.battlesize = value }
})


EventHandlers.add(:on_trainer_load, :battle_size_option,
  proc { |trainer|
    if !$game_temp.battle_rules["size"] && trainer
    case $PokemonSystem.battlesize
      when 1
          setBattleRule("double") if pbCanDoubleBattle?
      when 2
          setBattleRule("triple") if pbCanTripleBattle?
          setBattleRule("double") if !pbCanTripleBattle? && pbCanDoubleBattle?
      end
    end
  }
)