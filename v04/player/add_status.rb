module Player
  module AddStatus
    def add_status(status)
      $player_statuses << status
      puts "Status #{status[:name]} was added."
      $player_history << { type: '➕ add status', status: status[:name] }

      player_display_status
    end
  end
end