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

require_relative 'player_display'
require_relative 'dm_roll'
require_relative 'player_increase_level'
require_relative 'player_add_status'
require_relative 'player_remove_status'
require_relative 'player_roll'
# Take a look at each of the files. All of them assume too much about our global variables. It's confusing! Where are they coming from? What are they? Their structure? You can never know...
# altamente acoplado.

print_skills('Fulano', $player_skills)

player_roll_for_skill($player_skills[0][:subskills][0])
player_roll_for_skill($player_skills[0])

dm_roll(3)

new_subskill = { name: "Walk at home while sleepy", level: 4 }
increase_level($player_skills, "Walk at home", new_subskill)

new_status = {
  name: 'bleeding',
  influence: -3,
  skills: ['Do anything']
}

add_status(new_status)
remove_status('poison')

player_roll_for_skill($player_skills[0][:subskills][0])

player_print_history
