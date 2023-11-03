module Player
  module RemoveStatus
    def self.call(player, status_name)
      player.statuses = player.statuses.select { |s| s[:name] != status_name }
      puts "Status #{status_name} was removed."
      player.history << { type: '➖ remove status', status: status_name }
    
      Display.status(player)
    end
  end
end
