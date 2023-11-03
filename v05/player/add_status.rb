module Player
  module AddStatus
    def self.call(status)
      $player_statuses << status
      puts "Status #{status[:name]} was added."
      $player_history << { type: '➕ add status', status: status[:name] }

      Display.status
    end
  end
end