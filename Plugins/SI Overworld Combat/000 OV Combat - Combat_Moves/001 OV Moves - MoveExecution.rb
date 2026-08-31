class OverworldCombat::MoveExecution
  def self.apply(context)
    move   = context[:move]
	
    validate move => Pokemon::Move
	
    code = move.execution_type || "None"
	
    if code[/^\d/]   # Begins with a digit
      execution_type = sprintf("Effect%s", code)
    else
      execution_type = sprintf("%s", code)
    end
	
    return if execution_type.nil?

    puts execution_type
    if respond_to?(execution_type, true)
      return self.send(execution_type, context)
	else 
	  return self.unimplemented(execution_type, context)
    end
  end

  def self.unimplemented(execution_type, context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
      raise(
    "Unimplemented Move Execution Type\n\n" \
    "Move: #{move.name} (#{move.id})\n" \
    "Execution Type: #{execution_type}\n\n" \
    "Add a handler to OverworldCombat::MoveExecution."
  )
    return []
  end
  #===============================================================================
  # Fires a temporary event projectile. If the projectile hits something
  # that recieves the attack, it disappears.
  #===============================================================================
  def self.ProjectileMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
    results = []
	results << OverworldCombat::Movement.projectile_attack(user, target, move)
	return results 
  end 
  #===============================================================================
  # This move launches multiple projects sequencially, 
  # Each projectile disappears after hitting a valid target.
  #===============================================================================
  def self.MultiHitProjectileMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
    results = []
    numHits = OverworldCombat.num_hits(move, user, target)
    numHits.times do
      results << OverworldCombat::Movement.projectile_attack(user, target, move)
    end
	return results 
  end 
  #===============================================================================
  # Fires a temporary event projectile. If the projectile hits something
  # that recieves the attack, it continues past them.
  #===============================================================================
  def self.PiercingProjectileMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
    results = OverworldCombat::Movement.projectile_attack(user, target, move, true)
	return results 
  end 
  #===============================================================================
  # This move launches multiple projects sequencially.
  #===============================================================================
  def self.MultiHitPiercingProjectileMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
    results = []

    numHits = OverworldCombat.num_hits(move, user, target)
    numHits.times do
      results.concat(OverworldCombat::Movement.projectile_attack(user, target, move, true))
    end
	return results 
  end 
  #===============================================================================
  # Attacks an enemy within an immediate cardinal direction of the user.
  #===============================================================================
  def self.CardinalMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	return [target] if OverworldCombat::Movement.cardinal_attack(attacker, target)
  end
  #===============================================================================
  # This move physically hits multiple times.
  #===============================================================================
  def self.MultiHitCardinalMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
    results = []

    numHits = OverworldCombat.num_hits(move, user, target)
	 if OverworldCombat::Movement.cardinal_attack(user, target, move, true)
      numHits.times do
        results << target
      end
	 end 
	return results 
  end 
  #===============================================================================
  # Attempts a CardinalMove attack, if it fails
  # attempts the attack but by rushing directly towards an enemy
  #===============================================================================
  def self.RushDownMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
    results = []
	results << OverworldCombat::Movement.rushdown(user, target)
	return results 
  
  end 
  #===============================================================================
  # This move physically hits multiple times, but rushes down first.
  #===============================================================================
  def self.MultiHitRushdownMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
    results = []

    results << OverworldCombat::Movement.rushdown(user, target)
	return results 
  end 
  #===============================================================================
  # Performs a RushDown, but instead of stopping when hitting a tree or an object
  # the user is launched back a space instead of staying on the final one.
  #===============================================================================
  def self.RushDownRecoilMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
    results = []
	results << OverworldCombat::Movement.rushdown(user, target)
	results.each do |result|
	if result && (result.is_a?(Game_PokeEvent) || result.is_a?(Game_PokeEventA)) || result == :COLLIDED_WALL
	  user.move_backward_slide
	end 
	end 
	return results 
  end 
  #===============================================================================
  # Performs a RushDown, but instead of stopping when hitting a tree or an object
  # the target is launched forwards a space.
  #===============================================================================
  def self.RushDownKnockbackMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
    results = []
	results << OverworldCombat::Movement.rushdown(user, target)
	results.each do |result|
	if result && (result.is_a?(Game_PokeEvent) || result.is_a?(Game_PokeEventA)) 
	  unless result.move_forward_slide
	    OverworldCombat::Movement.displace(user, result)
	  end 
	end 
	end

	return results 
  end 
  #===============================================================================
  # Performs a RushDown, but instead of stopping when hitting a tree or an object
  # the target is launched towards the side.
  #===============================================================================
  def self.RushDownDisplaceMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
    results = []
	results << OverworldCombat::Movement.rushdown(user, target)
	results.each do |result|
	if results && (results.is_a?(Game_PokeEvent) || results.is_a?(Game_PokeEventA)) 
	    OverworldCombat::Movement.displace(user, results)
	end 
	end
	return results 
  end 
  #===============================================================================
  # Performs a RushDown, but if it encounters another event, continues moving
  # carrying the other event along.
  #===============================================================================
  def self.RushDownPushMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
    results = []
	results <<  OverworldCombat::Movement.rushdown(user, target, true)
	return results 
  end 





  #===============================================================================
  # This move will hit the target if it's within a given distance.
  # Mostly used for Status Moves.
  #===============================================================================
  def self.RangedTargetMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	sideDisplay("#{user.pokemon.name} focused!")if !target.is_a?(Game_PokeEvent) 
	loop = 0
	while loop < 30
   	  OverworldCombat.update_package
	  loop += 1
	end 
	return [target] if OverworldCombat.within_range?(user, target, move, move.overworld_range )
	return [] 
  end 
  #===============================================================================
  # This move will hit the target no matter it's location.
  # Mostly used for Status Moves.
  #===============================================================================
  def self.DistanceIgnorantMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	sideDisplay("#{user.pokemon.name} focused!")if !target.is_a?(Game_PokeEvent) 
	loop = 0
	while loop < 30
   	  OverworldCombat.update_package
	  loop += 1
	end 
	return [target] 
  end 
  #===============================================================================
  # This move is delayed by a few seconds, but will attack a Target no matter
  # its location.
  # Used by Doom Desire and Future Sight.
  #===============================================================================
  def self.DelayedDistanceIgnorantMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	sideDisplay("#{user.pokemon.name} focused!")if !target.is_a?(Game_PokeEvent) 
	loop = 0
	while loop < 120
   	  OverworldCombat.update_package
	  loop += 1
	end 
	return [target]
  end 
  #===============================================================================
  # This move will immediately move its user to an advantaged adjecent position of a target
  # and attacks, if no positions are available, it fails.
  #===============================================================================
  def self.InstantTransmissionMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
    results = []
	results <<  OverworldCombat::Movement.instant_transmission(user, target, move)
	return results 
  end 
  #===============================================================================
  # This move will immediately move its user to a random adjecent position of a target
  # and attacks, if no positions are available, it fails.
  #===============================================================================
  def self.InstantTransmissionRandomMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
    results = []
	results <<  OverworldCombat::Movement.instant_transmission_random(user, target, move)
	return results 
  end 
  #===============================================================================
  # This move attacks every space surrounding the user.
  #===============================================================================
  def self.AreaSurroundingUserMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	results = OverworldCombat::Movement.area_surrounding(user)
	return results 
  end 
  #===============================================================================
  # This move attacks every space within a range of the user determined
  # by the users sightline value.
  #===============================================================================
  def self.AreaSurroundingUserSightlineMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	results = OverworldCombat::Movement.area_surrounding(user, OverworldCombat.sight_line(user), false)
	return results 
  end 
  
  
  
  
  #===============================================================================
  # This move creates an event shaped as continious beam in front of the user
  #  for a few seconds anything within takes damage.
  #===============================================================================
  def self.BeamMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	results = OverworldCombat::Movement.beam_attack(user, target, move)
	return results 
  end 

  #===============================================================================
  # This move attacks every space in a V shape in front of the user
  # up to the users sightline.
  #===============================================================================
  def self.ConeMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	results = OverworldCombat::Movement.cone_attack(user, target, move)
	return results 
  end 
  #===============================================================================
  # This move creates an event that moves in an Arc, once it finishes it's arc
  # it will hit whatever is there.
  #===============================================================================
  def self.ArcMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	results = OverworldCombat::Movement.arc_movement(user, target, move)
	return results 
  end 
  #===============================================================================
  # This move creates an event that moves in an Arc, once it finishes it's arc
  # it will hit its landing location and the tiles surrounding.
  #===============================================================================
  def self.ArcExplodeMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	results = OverworldCombat::Movement.arc_movement(user, target, move, true)
	return results 
  end 
  #===============================================================================
  # This move attacks every space surrounding the user for a prolonged
  # period of time.
  #===============================================================================
  def self.AreaSurroundingUserAuraMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	results = OverworldCombat::Movement.aura_surrounding(user, target, move)
	return results 
  end 

 #===============================================================================
  # This move orbits the user a fix amount of time before launching.
  # it will hit its landing location and the tiles surrounding.
  #===============================================================================
  def self.OrbitingMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	results = OverworldCombat::Movement.orbiting_attack(user, target, move)
	return results 
  end 
  #===============================================================================
  # This move orbits the user a random amount of time before launching.
  # it will hit its landing location and the tiles surrounding.
  #===============================================================================
  def self.RandomOrbitingMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	results = OverworldCombat::Movement.orbiting_attack(user, target, move, true)
	return results 
  end 
  #===============================================================================
  # This move summons an object.
  #===============================================================================
  def self.SummonMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	results = OverworldCombat::Movement.summon_move(user, move)
	return results 
  end 
  #===============================================================================
  # This move creates an invisible event at their location that if triggered
  # launches the move.
  #===============================================================================
  def self.TrappedMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	results = OverworldCombat::Movement.trapped_move(user, move)
	return results 
  end 



  #===============================================================================
  # This move causes the user to 'disappear' and be unable to be attacked normally
  # before attacking the target, see Fly, Dig.
  #===============================================================================
  def self.DisappearanceMove(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	results = OverworldCombat::Movement.dissappearance_move(user, target, move)
	return results 
  end 


end