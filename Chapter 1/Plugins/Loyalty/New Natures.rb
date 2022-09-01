GameData::Nature.register({
  :id           => :HATEFUL,
  :id_number    => 25,
  :name         => _INTL("Hateful"),
  :stat_changes => [[:HP, 10], [:ATTACK, 10], [:DEFENSE, 10], [:SPEED, 10], [:SPECIAL_ATTACK, 10], [:SPECIAL_DEFENSE, 10]]
})

GameData::Nature.register({
  :id           => :LOVING,
  :id_number    => 26,
  :name         => _INTL("Loving"),
  :stat_changes => [[:HP, 20], [:ATTACK, -10], [:DEFENSE, -10], [:SPEED, -10], [:SPECIAL_ATTACK, -10], [:SPECIAL_DEFENSE, -10]]
})