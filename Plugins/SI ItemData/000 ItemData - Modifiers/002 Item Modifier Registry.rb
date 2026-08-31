ModifierManager::Modifier.add(:IRON2, proc { |modifier, item|
  if item.data.is_pokeball?
    item.effects.add(:OnFailCatch, :BARBED)
  else
    item.durability += 25
	item.modifiers.remove(modifier.id)
  end 
})
