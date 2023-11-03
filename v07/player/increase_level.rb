module Player
  module IncreaseLevel
    def self.call(structure, target_subskill_name, new_subskill, current_history, current_skills, player_name, gm_name)
      subskill_found = false
      structure.each do |item|
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
            self.call(updated_subskills, target_subskill_name, new_subskill, current_history, current_skills, player_name, gm_name)
          end
        end
      end
    
      if !subskill_found
        return Display.not_found_skill(target_subskill_name)
      end
    
      current_history << { type: '⏫ increase', skill: new_subskill[:name] }
    
      Display.skills('Fulano', current_skills, player_name, gm_name)
      # def self.skills(interested_name, structure, player_name, gm_name, indent = 0)
    end
  end
end