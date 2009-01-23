migration 1, :set_timestamps_to_plugins  do
  up do
    Plugin.all.each do |plugin|
      plugin.created_at = Time.now
      plugin.save
    end
  end

  down do
  end
end
