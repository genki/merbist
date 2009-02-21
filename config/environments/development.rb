Merb.logger.info("Loaded DEVELOPMENT Environment...")
Merb::Config.use { |c|
  c[:exception_details] = true
  c[:reload_templates] = true
  c[:reload_classes] = true
  c[:reload_time] = 0.5
  c[:ignore_tampered_cookies] = true
  c[:log_auto_flush ] = true
  c[:log_level] = :debug

  c[:log_stream] = STDOUT
  c[:log_file]   = nil
  # Or redirect logging into a file:
  # c[:log_file]  = Merb.root / "log" / "development.log"
}

Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
    
  Merb::Slices::config[:merb_auth_slice_activation].merge!({
    :from_email => 'no-reply@merbist.localhost',
    :activation_host => 'merbist.localhost',
  })

  Merb::Config[:gem_home] = Merb.root / "log/gems"

  Merb::Cache.setup do
    require 'logging_memcached_store'
    register(LoggingAdhocStore[:page_store, :action_store])
  end
end
