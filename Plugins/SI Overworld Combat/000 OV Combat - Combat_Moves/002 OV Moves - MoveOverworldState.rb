class OverworldCombat::MoveOverworldState
  def self.apply(context)
    move   = context[:move]
	
    validate move => Pokemon::Move
	
    code = move.overworld_state || "None"
	
    if code[/^\d/]   # Begins with a digit
      overworld_state = sprintf("Effect%s", code)
    else
      overworld_state = sprintf("%s", code)
    end
	
    return if overworld_state.nil?
    return if overworld_state == "None"
 

    if respond_to?(overworld_state, true)
      return self.send(overworld_state, context)
	else 
	  return self.unimplemented(overworld_state, context)
    end
  end

  def self.unimplemented(overworld_state, context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
      raise(
    "Unimplemented Move Overworld State\n\n" \
    "Move: #{move.name} (#{move.id})\n" \
    "Overworld State: #{overworld_state}\n\n" \
    "Add a handler to OverworldCombat::MoveOverworldState."
  )
    return {}
  end
  #===============================================================================
  # Throws target in a random direction, if it hits a wall, they take damage, both take fixed damage.
  #===============================================================================
  def self.ThrowsTarget(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	puts "This is a placeholder for until systems are in place to handle OverworldState moves."
  end 
#===============================================================================
# Launches target up to 10 tiles away, if they hit a wall they take fixed damage. If they hit another enemy, both take fixed damage.
# (Roar, Whirlwind)
#DO NOT ADD THE SOUNDPROOF IMMUNITY CODE HERE. THAT NEEDS TO BE CHECKED ELSEWHERE.
#===============================================================================
  def self.LaunchesTarget(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	puts "This is a placeholder for until systems are in place to handle OverworldState moves."
  end 
#===============================================================================
# Pulls all Dynamic Events towards user.
# (Gravity)
#===============================================================================
  def self.GravitiesTarget(context)
    user   = context[:user]
    target = context[:target]
    move   = context[:move]
	puts "This is a placeholder for until systems are in place to handle OverworldState moves."
  end 





end 