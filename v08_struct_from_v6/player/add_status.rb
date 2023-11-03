module Player
  module AddStatus
    def self.call(player, status)
      player.statuses << status
      puts "Status #{status[:name]} was added."
      player.history << { type: '➕ add status', status: status[:name] }

      Display.status(player)
    end
  end
end