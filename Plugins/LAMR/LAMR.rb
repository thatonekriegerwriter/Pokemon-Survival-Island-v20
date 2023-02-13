#==============================================================================
# Config	
# LA Move Relearner base by IndianAnimator script by Kotaro
module Settings
  EGGMOVESSWITCH  = 99
  TMMOVESSWITCH   = 100
end  
EGGMOVES = true
TMMOVES = true
#==============================================================================
class MoveRelearnerScreen
  def MoveRelearnerScreen.pbGetRelearnableMoves(pkmn)
    return [] if !pkmn || pkmn.egg? || pkmn.shadowPokemon?
    moves = []
    pkmn.getMoveList.each do |m|
      next if m[0] > pkmn.level || pkmn.hasMove?(m[1])
      moves.push(m[1]) if !moves.include?(m[1])
    end
    tmoves = []
    if pkmn.first_moves
      for i in pkmn.first_moves
        tmoves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i)
      end
    end
    species_data = pkmn.species_data
    species_data.tutor_moves.each { |m| moves.push(m) }
    if EGGMOVES == true
      babyspecies = species_data.get_baby_species
      GameData::Species.get(babyspecies).egg_moves.each { |m| moves.push(m) }
    end  
    if TMMOVES==true
      species_data.tutor_moves.each { |m| moves.push(m) }
    end  
    moves = tmoves + moves
    return moves | []   # remove duplicates
  end

  def pbStartScreen(pkmn)
    moves = MoveRelearnerScreen.pbGetRelearnableMoves(pkmn)    #by Kota
    @scene.pbStartScene(pkmn, moves)
    loop do
      move = @scene.pbChooseMove
      if move
        if @scene.pbConfirm(_INTL("Teach {1}?", GameData::Move.get(move).name))
          if pbLearnMove(pkmn, move)
            @scene.pbEndScene
            return true
          end
        end
      elsif @scene.pbConfirm(_INTL("Give up trying to teach a new move to {1}?", pkmn.name))
        @scene.pbEndScene
        return false
      end
    end
  end
end
