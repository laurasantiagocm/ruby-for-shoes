$gm_name = 'Mestre'

$player_name = 'Fulano'
$player_xp = 0
$player_statuses = [
  {
    name: 'poison',
    influence: -2,
    skills: ['Do anything']
  },
  {
    name: 'leg day',
    influence: 2,
    skills: ['Run', 'Walk']
  }
]

$player_skills = [
  {
    name: "Do anything",
    level: 1,
    subskills: [
      {
        name: "Walk",
        level: 2,
        subskills: [
          {
            name: "Walk at home",
            level: 3
          }
        ]
      },
      {
        name: "Run",
        level: 2,
        subskills: []
      }
    ]
  }
]

$player_history = []

def player_display_not_allowed
  p "Display not allowed for different players"
end

def print_skills(interested_name, structure, indent = 0)
  return player_display_not_allowed if interested_name != $player_name && interested_name != $gm_name
  structure.each do |item|
    item.each do |key, value|
      if key == :subskills && value.is_a?(Array) && !value.empty?
        puts "  " * indent + "#{key}:"
        print_skills(interested_name, value, indent + 1)
      else
        puts "  " * indent + "#{key}: #{value}"
      end
    end
  end
end

print_skills('Fulano', $player_skills)

def extract_skill_names(structure)
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

def player_display_status
  $player_statuses.each do |status|
    next if (status[:skills] && extract_skill_names($player_skills)).empty?
    p "Player is affected by: #{status[:name]} (#{status[:influence]})"
  end
end

def player_roll_for_skill(skill)
  puts "Checking for statuses"
  affecting_statuses = $player_statuses.select { |status| status[:skills].include?(skill[:name]) }
  status_affection_dice = affecting_statuses.sum{ |s| s[:influence] } if affecting_statuses.any?

  player_display_status

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

  $player_history << { type: '🎲 roll', result: result, note: "affected by #{affecting_statuses.map{ |s| s[:name]}.join(', ')}" }
end

player_roll_for_skill($player_skills[0][:subskills][0])
player_roll_for_skill($player_skills[0])

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

def player_display_not_found_skill(name)
  p "Skill #{name} was not found"
end

dm_roll(3)

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

new_subskill = { name: "Walk at home while sleepy", level: 4 }
increase_level($player_skills, "Walk at home", new_subskill)

new_status = {
  name: 'bleeding',
  influence: -3,
  skills: ['Do anything']
}

def add_status(status)
  $player_statuses << status
  puts "Status #{status[:name]} was added."
  $player_history << { type: '➕ add status', status: status[:name] }

  player_display_status
end

def remove_status(status_name)
  $player_statuses = $player_statuses.select { |s| s[:name] != status_name }
  puts "Status #{status_name} was removed."
  $player_history << { type: '➖ remove status', status: status_name }

  player_display_status
end

add_status(new_status)
remove_status('poison')

player_roll_for_skill($player_skills[0][:subskills][0])

def player_print_history
  p "Player history:"
  $player_history.each do |action|
    puts "#{action.map {|key, val| "#{key}: #{val} |" }.join(' ')}"
  end
end

player_print_history