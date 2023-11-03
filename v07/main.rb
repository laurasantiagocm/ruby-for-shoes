gm_name = 'Mestre'

player_name = 'Fulano'
player_xp = 0
player_statuses = [
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

player_skills = [
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

player_history = []

require_relative 'dm'
require_relative 'player'

extend Dm::Roll
extend Player::Display
extend Player::IncreaseLevel
extend Player::AddStatus
extend Player::RemoveStatus
extend Player::AddStatus
extend Player::RollForSkill

# By adding all dependencies to each function, we can remove global states and no function assumes too much about them.
# However, it is still costy to always send this many arguments to simple functions, they are doing too much.
# Smell: data clumps!
Player::Display.skills('Fulano', player_skills, player_name, gm_name)

Player::RollForSkill.call(player_skills[0][:subskills][0], player_statuses, player_history, player_skills)
Player::RollForSkill.call(player_skills[0], player_statuses, player_history, player_skills)

Dm::Roll.call(3)

new_subskill = { name: "Walk at home while sleepy", level: 4 }
Player::IncreaseLevel.call(player_skills, "Walk at home", new_subskill, player_history, player_skills, player_name, gm_name)

new_status = {
  name: 'bleeding',
  influence: -3,
  skills: ['Do anything']
}

Player::AddStatus.call(new_status, player_statuses, player_history, player_skills)
Player::RemoveStatus.call('poison', player_statuses, player_history, player_skills)

Player::RollForSkill.call(player_skills[0][:subskills][0], player_statuses, player_history, player_skills)

Player::Display.history(player_history)
