
ItemHandlers::UseOnPokemon.add(:SUSPO,proc { |item,pkmn,scene|
       if pkmn.permaFaint==true
         if pkmn.happiness <= 75
          pkmn.species = pkmn.species_data.get_baby_species
          pkmn.level          = Settings::EGG_LEVEL
          pkmn.calc_stats
          pkmn.name           = _INTL("Egg")
          pkmn.steps_to_hatch = pkmn.species_data.hatch_steps
          pkmn.hatched_map    = 0
          pkmn.obtain_method  = 1
          pkmn.food  = 100
          pkmn.water  = 100
          pkmn.age  = 1
          pkmn.lifespan  = 50
		  pkmn.permaFaint = false
          next true
         else
         scene.pbDisplay(_INTL("It doesn't like you enough to reincarnate."))
         next false
         end
       else
         scene.pbDisplay(_INTL("It won't have any effect."))
         next false
         end
})