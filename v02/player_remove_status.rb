def remove_status(status_name)
  $player_statuses = $player_statuses.select { |s| s[:name] != status_name }
  puts "Status #{status_name} was removed."
  $player_history << { type: '➖ remove status', status: status_name }

  player_display_status
end
