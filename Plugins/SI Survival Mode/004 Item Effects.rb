
ItemHandlers::UseOnPokemon.add(:SUSPO,proc { |item,pkmn,scene|
       chance = rand(255)
       if pkmn.permaFaint==true 
         if pkmn.happiness <= 75
		 if 5 > chance
          pkmn.species = pkmn.species_data.get_baby_species
          pkmn.calc_stats
          pkmn.name           = _INTL("Egg")
          pkmn.steps_to_hatch = pkmn.species_data.hatch_steps
          pkmn.food  = 100
          pkmn.water  = 100
          pkmn.age  = 1
          pkmn.lifespan  = 50
		  pkmn.permaFaint = false
          next true
		 else
          next true
         scene.pbDisplay(_INTL("It was indigested, but had no effect."))
		 end
         else
         scene.pbDisplay(_INTL("It doesn't like you enough to reincarnate."))
         next false
         end
       else
         scene.pbDisplay(_INTL("It won't have any effect."))
         next false
         end
})



ItemHandlers::UseInField.add(:CALENDAR,proc { |item|
  openCalendar
  next 2
})

