module Player
  module AddStatus
    def self.call(status, current_statuses, current_history, current_skills)
      current_statuses << status

      puts "Status #{status[:name]} was added."

      current_history << { type: '➕ add status', status: status[:name] }

      Display.status(current_statuses, current_skills)
    end
  end
end