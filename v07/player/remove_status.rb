module Player
  module RemoveStatus
    def self.call(status_name, current_statuses, current_history, current_skills)
      current_statuses = current_statuses.select { |s| s[:name] != status_name }
      puts "Status #{status_name} was removed."
      current_history << { type: '➖ remove status', status: status_name }
    
      Display.status(current_statuses, current_skills)
    end
  end
end
