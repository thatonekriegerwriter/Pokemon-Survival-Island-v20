class Pokemon

  class Move
  
    def record_move_use(user, targets)
	 return if $player.pokedex.tasks[user.species.name].nil?
    $player.pokedex.tasks[user.species.name].each do |task|
      if task[:task] == "MOVE" && task[:move_item] == self.id.name
        $player.pokedex.increment_task_progress(task)
      end
    end
    end
  
  
  end

  def hasMove?(move_id)
    move_data = GameData::Move.try_get(move_id)
    return false if !move_data
    return @moves.any? { |m| m.id == move_data.id }
  end
  def hasMove2?(move_id)
    move_data = GameData::Move.try_get(move_id)
    return false if !move_data
	return @moves2.any? { |m| m.id == move_data.id } 
  end
   def moves2
    @moves2 = [] if @moves2.nil?
    return @moves2
   end
  def learn_move2(move_id)
    move_data = GameData::Move.try_get(move_id)
    return if !move_data
    @moves2 = [] if @moves2.nil?
    # Check if self already knows the move; if so, move it to the end of the array
    @moves2.each_with_index do |m, i|
      next if m.id != move_data.id
      @moves2.push(m)
      @moves2.delete_at(i)
      return
    end
    # Move is not already known; learn it
    @moves2.push(Pokemon::Move.new(move_data.id))
    # Delete the first known move if self now knows more moves than it should
    @moves2.shift if numMoves2 > MAX_MOVES
  end

  def numMoves2
    return @moves2.length
  end



end 