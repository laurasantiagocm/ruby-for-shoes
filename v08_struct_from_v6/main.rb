require_relative 'dm'
require_relative 'player'

dm = Dm::Data.new
dm.name = 'Mestre'

player = Player::Data.new

player.name = 'Fulano'
player.xp = 0
player.history = []
player.statuses = [
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

player.skills = [
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

Player::Display.skills(player, 'Fulano', player.skills)

Player::RollForSkill.call(player, 'Walk')
Player::RollForSkill.call(player, 'Do anything')

Dm::Roll.call(3)

new_subskill = { name: "Walk at home while sleepy", level: 4 }
Player::IncreaseLevel.call(player, player.skills, "Walk at home", new_subskill)

new_status = {
  name: 'bleeding',
  influence: -3,
  skills: ['Do anything']
}

Player::AddStatus.call(player, new_status)
Player::RemoveStatus.call(player, 'poison')

Player::RollForSkill.call(player, "Walk at home")

Player::Display.history(player)
