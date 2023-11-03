module Player
  Data = Struct.new(:name, :xp, :statuses, :skills,  :history)

  require_relative 'player/display'
  require_relative 'player/increase_level'
  require_relative 'player/add_status'
  require_relative 'player/remove_status'
  require_relative 'player/roll'
end
