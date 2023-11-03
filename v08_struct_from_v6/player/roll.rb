module Player
  module RollForSkill
    def self.get_skill_by_name(structure, target_name)
      structure.each do |item|
        item.each do |key, value|
          if key == :name && value == target_name
            return item
          elsif key == :subskills && value.is_a?(Array) && !value.empty?
            subskill = get_skill_by_name(value, target_name)
            return subskill if subskill
          end
        end
      end

      nil
    end

    def self.call(player, skill_name)
      puts "Checking for statuses"
      affecting_statuses = player.statuses.select { |status| status[:skills].include?(skill_name) }
      status_affection_dice = affecting_statuses.sum{ |s| s[:influence] } if affecting_statuses.any?
    
      Display.status(player)

      skill = get_skill_by_name(player.skills, skill_name)
    
      p "Rolling for #{skill_name} - #{skill[:level]}d6 (status influence: #{status_affection_dice})"
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
    
      player.history << { type: '🎲 roll', result: result, note: "affected by #{affecting_statuses.map{ |s| s[:name]}.join(', ')}" }
    end
  end
end
