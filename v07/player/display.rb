module Player
  module Display
    def self.not_found_skill(name)
      p "Skill #{name} was not found"
    end
    
    def self.not_allowed
      p "Display not allowed for different players"
    end
    
    def self.extract_skill_names(structure)
      skill_names = []
      return skill_names if structure.nil?
    
      structure.each do |item|
        item.each do |key, value|
          if key == :name
            skill_names << value
          elsif key == :subskills && value.is_a?(Array) && !value.empty?
            value.each do |subskill|
              skill_names << subskill[:name]
              skill_names.concat(extract_skill_names(subskill[:subskills]))
            end
          end
        end
      end
      skill_names
    end
    
    def self.skills(interested_name, structure, player_name, gm_name, indent = 0)
      return not_allowed if interested_name != player_name && interested_name != gm_name
      structure.each do |item|
        item.each do |key, value|
        if key == :subskills && value.is_a?(Array) && !value.empty?
          puts "  " * indent + "#{key}:"
          skills(interested_name, value, player_name, gm_name, indent + 1)
        else
          puts "  " * indent + "#{key}: #{value}"
        end
        end
      end
    end
    
    def self.status(current_statuses, current_skills)
      current_statuses.each do |status|
        next if (status[:skills] && extract_skill_names(current_skills)).empty?
        p "Player is affected by: #{status[:name]} (#{status[:influence]})"
      end
    end
    
    def self.history(current_history)
      p "Player history:"
      current_history.each do |action|
        puts "#{action.map {|key, val| "#{key}: #{val} |" }.join(' ')}"
      end
    end
  end
end
