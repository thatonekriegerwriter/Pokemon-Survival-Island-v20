
EventHandlers.add(:on_end_battle, :check_achievements,
  proc { |_decision, _canLose|
  if decision ==1
      pbAchievementGet(0)
  end
  }
)