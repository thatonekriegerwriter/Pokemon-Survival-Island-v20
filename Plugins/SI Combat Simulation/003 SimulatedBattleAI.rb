# Ported from the old chooseMove/get_ov_move_score. Two real changes from
# the original, both flagged here rather than silently carried over:
#
# 1. The old sleep/frozen "prefer a wake-up move" check compared a move
#    OBJECT to a bare symbol (`m==:SNORE`) - that can never be true for a
#    real Move instance, so that whole branch was dead code in the
#    original. Fixed to compare `m.id` instead.
# 2. Dropped the `attacker.moves2`/`attacker.pokemon` branch entirely -
#    that looked like it was for a second movepool in some other battle
#    context (a trainer's second Pokemon?), not something a single
#    SimulatedPokemon has. Also dropped every "target is not a Pokemon"
#    branch (fixed-damage-vs-non-Pokemon-target scoring) - your note said
#    Blocks are for base raids, not adventures, so adventure targets are
#    always a wild Pokemon.
#
module SimulatedBattleAI
  module_function

  def choose_action(user, target)
    scored = user.moves.select { |m| can_choose_move?(user, m) }
                 .map { |m| [m, score_move(m, user, target, calculate_skill)] }
    return nil if scored.empty?

    best = scored.max_by { |(_, s)| s }
    return nil if best[1] <= 0 && scored.all? { |(_, s)| s <= 0 } # nothing worth doing at all

    SimulatedAction.new(best[0])
  end

  def calculate_skill
    difficulty = $PokemonSystem.difficulty || 4
    modifier = $PokemonSystem.difficultymodifier || 80
    ((difficulty + 1) * modifier) + rand(80) + 1
  end

  def can_choose_move?(user, move)
    return false if move.pp <= 0 && move.total_pp > 0
    return false if %i[FROZEN PARALYSIS SLEEP].include?(user.status)

    true
  end

  def score_move(move, user, target, skill)
    score = 100
    score = status_tier_score(score, move, user, target) if skill > 120
    score = positioning_tier_score(score, move) if skill > 160
    score = utility_tier_score(score, move, target) if skill > 200

    score -= user.hp * 100 / user.totalhp if move.function_code == "UserFaintsExplosive"
    score -= 40 if move.category == 2 # status
    score += 80 if [0, 1].include?(move.category) # physical/special
    score = damage_score(score, move, user, target, skill)

    effectiveness = Effectiveness.calculate(move.type, *target.types)
    score += 60 if Effectiveness.super_effective?(effectiveness)
    score = 0 if Effectiveness.ineffective?(effectiveness)
    score -= 60 if Effectiveness.not_very_effective?(effectiveness) || Effectiveness.resistant?(effectiveness)

    score = 10 if move.function_code == "FleeFromBattle"
    score += rand(2).zero? ? rand(30) : -rand(30)
    [score.to_i, 0].max
  end

  def status_tier_score(score, move, user, target)
    if user.status == :SLEEP
      has_wakeup = user.moves.any? { |m| %i[SNORE SLEEPTALK].include?(m.id) }
      score -= 60 if has_wakeup && !%i[SNORE SLEEPTALK].include?(move.id)
    end

    if user.status == :FROZEN
      if move.flags.any? { |f| f[/^ThawsUser$/i] }
        score += 40
      else
        has_thaw = user.moves.any? { |m| m.flags.any? { |f| f[/^ThawsUser$/i] } }
        score -= 60 if has_thaw
      end
    end

    score -= 60 if target.status == :FROZEN && !move.flags.any? { |f| f[/^ThawsUser$/i] }

    %w[SleepTarget ParalyzeTarget PoisonTarget BurnTarget FreezeTarget].each do |code|
      score += 40 if move.function_code.include?(code)
    end

    score += user.status == :NONE ? -90 : 40 if move.function_code == "GiveUserStatusToTarget"
    score
  end

  def positioning_tier_score(score, move)
    score -= 100 if move.function_code.include?("SwitchOut")
    score += 30 if move.function_code == "TrapTargetInBattle"
    score += 80 if move.function_code == "PursueSwitchingFoe"
    score
  end

  def utility_tier_score(score, move, target)
    held = target.object.respond_to?(:item) && target.object.item
    score += 20 if move.function_code == "RemoveTargetItem" && held
    score += 30 if move.function_code == "DestroyTargetBerryOrGem"
    score += 30 if move.function_code == "HealUserHalfOfTotalHP"
    score += 80 if %w[FixedDamage20 FixedDamage40 FixedDamageHalfTargetHP FixedDamageUserLevel].include?(move.function_code)
    score
  end

  # move.category: 0 physical, 1 special, 2 status - matches how the rest
  # of this scoring already branches on it above, not a new guess.
  def damage_score(score, move, user, target, skill)
    return score if move.base_damage <= 0

    offensive_stat = move.category.zero? ? :attack : :spatk
    attack = [user.stats[offensive_stat], 1].max
    damage = ((move.base_damage + attack) / 2).floor
    damage = damage * 2 / 3 if move.function_code == "AttackAndSkipNextTurn"

    damage_pct = damage * 100.0 / target.hp
    damage_pct *= 1.2 if user.level - 10 > target.level

    if skill > 160
      damage_pct = 120 if damage_pct > 120
      damage_pct += 40 if damage_pct > 100
    end
    score + damage_pct.to_i
  end
end
