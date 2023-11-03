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

# the history should not be a global variable. anyone could set it to nil or anything else.
# the application would imidiatelly break. i'll add it to the player display, where it's mostly used.
# $player_history = []

require_relative 'dm'
require_relative 'player'

extend Dm::Roll
extend Player::Display
extend Player::IncreaseLevel
extend Player::AddStatus
extend Player::RemoveStatus
extend Player::AddStatus
extend Player::RollForSkill

# by adding self.call for each method, we avoid redundant function names and make the origins of the method more explicit.
# however, if someone made a mistake (eg.: $player_name = 'a') our application would not run as we intended, simple as that.

Player::Display.skills('Fulano', $player_skills)

Player::RollForSkill.call($player_skills[0][:subskills][0])
Player::RollForSkill.call($player_skills[0])

Dm::Roll.call(3)

new_subskill = { name: "Walk at home while sleepy", level: 4 }
Player::IncreaseLevel.call($player_skills, "Walk at home", new_subskill)

new_status = {
  name: 'bleeding',
  influence: -3,
  skills: ['Do anything']
}

Player::AddStatus.call(new_status)
Player::RemoveStatus.call('poison')

Player::RollForSkill.call($player_skills[0][:subskills][0])

Player::Display.history
