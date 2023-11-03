module Player
  module IncreaseLevel
    def self.call(player, skills, target_subskill_name, new_subskill)
      subskill_found = false
      skills.each do |item|
        item.each do |key, value|
          if key == :subskills && value.is_a?(Array) && !value.empty?
            updated_subskills = []
            subskill_found = false
    
            value.each do |subskill|
              if subskill[:name] == target_subskill_name
                subskill_found = true
                if !subskill[:subskills]
                  subskill[:subskills] = []
                end
                subskill[:subskills] << new_subskill
                updated_subskills << subskill
              else
                updated_subskills << subskill
              end
            end
    
            item[:subskills] = updated_subskills if subskill_found
            self.call(player, updated_subskills, target_subskill_name, new_subskill)
          end
        end
      end
    
      if !subskill_found
        return Display.not_found_skill(target_subskill_name)
      end
    
      player.history << { type: '⏫ increase', skill: new_subskill[:name] }
    
      Display.skills(player, 'Fulano', player.skills)
    end
  end
end