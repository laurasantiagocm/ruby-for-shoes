def increase_level(structure, target_subskill_name, new_subskill)
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
        increase_level(updated_subskills, target_subskill_name, new_subskill)
      end
    end
  end

  if !subskill_found
    return player_display_not_found_skill(target_subskill_name)
  end

  $player_history << { type: '⏫ increase', skill: new_subskill[:name] }

  print_skills('Fulano', $player_skills)
end