
EventHandlers.add(:on_end_battle, :check_achievements,
  proc { |decision, canLose|
  if decision ==1
      pbAchievementGet(3)
  end
  }
)