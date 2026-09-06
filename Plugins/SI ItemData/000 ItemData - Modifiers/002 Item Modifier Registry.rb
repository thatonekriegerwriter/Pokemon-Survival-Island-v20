ModifierManager::Modifier.add(:IRON2, proc { |modifier_item, item|
  if item.data.is_pokeball?
    if item.effects.add(:OnFailCatch, :BARBED)
	 next true 
	end 
	 next false 
  elsif item.durability 
   unless item.durability >= item.max_durability
    item.durability += 25
	item.durability = [item.durability, item.max_durability].min
	next :remove
   end 
  end 
  next false 
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
  if item.data.is_weapon? && !item.data.is_pokeball?
    item.stats.stat_bonus += 1
	next true 
  end 
	next false 
})
ModifierManager::ModifierRemove.add(:HARDSTONE, proc { |modifier_item, item|
  if item.data.is_weapon? && !item.data.is_pokeball?
    item.stats.stat_bonus -= 1
	next true 
  end 
	next false 
})





