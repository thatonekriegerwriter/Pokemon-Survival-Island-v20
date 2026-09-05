

ModifierManager::Modifier.add(:IRON2, proc { |modifier_item, item|
  if item.data.is_pokeball?
    if item.effects.add(:OnFailCatch, :BARBED)
	 next true 
	end 
	 next false 
  else
    item.durability += 25
	next false 
  end 
})
ModifierManager::ModifierRemove.add(:IRON2, proc { |modifier_item, item|
  if item.data.is_pokeball?
    if item.effects.remove(:OnFailCatch, :BARBED)
	 next true 
	end 
	next false 
  end 
  next true 
})

ModifierManager::Modifier.add(:HARDSTONE, proc { |modifier_item, item|
  if item.data.is_weapon?
    item.stats.stat_bonus += 1
	next true 
  end 
	next false 
})
ModifierManager::ModifierRemove.add(:HARDSTONE, proc { |modifier_item, item|
  if item.data.is_weapon?
    item.stats.stat_bonus -= 1
	next true 
  end 
	next false 
})