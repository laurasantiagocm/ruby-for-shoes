module DmRoll
  def dm_roll(difficulty)
    p "Rolling #{difficulty}d6 for DM. Good luck >:)"
    die_rolls = []
    difficulty.times do
      die_rolls << rand(1..6)
    end
  
    result = die_rolls.sum
    p "#{result} (#{die_rolls.join(' + ')})"
    result
  end
end