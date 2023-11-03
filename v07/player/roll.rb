module Player
  module RollForSkill
    def self.call(skill, current_statuses, current_history, current_skills)
      puts "Checking for statuses"
      affecting_statuses = current_statuses.select { |status| status[:skills].include?(skill[:name]) }
      status_affection_dice = affecting_statuses.sum{ |s| s[:influence] } if affecting_statuses.any?
    
      Display.status(current_statuses, current_skills)
    
      p "Rolling for #{skill[:name]} - #{skill[:level]}d6 (status influence: #{status_affection_dice})"
      die_rolls = []
      skill[:level].times do
        die_rolls << rand(1..6)
      end
    
      if !status_affection_dice.nil?
        if status_affection_dice > 0
          status_affection_dice.times do
            die_rolls << rand(1..6)
          end
        elsif status_affection_dice < 0
          status_affection_dice.abs.times do
            die_rolls << (rand(1..6) * -1)
          end
        end
      end
    
      result = die_rolls.sum
      p "#{result} (#{die_rolls.join(' + ')})"
      result
    
      if die_rolls.all? { |roll| roll == 6 }
        p "Todos 6!! Pode adicionar uma skill nova."
      end
    
      current_history << { type: '🎲 roll', result: result, note: "affected by #{affecting_statuses.map{ |s| s[:name]}.join(', ')}" }
    end
  end
end
