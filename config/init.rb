# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'
 
use_orm :datamapper
use_test :rspec
use_template_engine :erb
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = 'f833e301825188c1780cdbff54bb5d85a589466f'  # required for cookie session store
  c[:session_id_key] = '_merbist_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  require "fixtures_hash_fix"
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.

  Merb::Slices::config[:merb_auth_slice_activation].merge!({
    :from_email => 'do_not_reply@merbi.st',
    :activation_host => 'merbi.st',
  })
            
  Merb::Mailer.config = {
    :sendmail_path => '/usr/sbin/sendmail'
  } 
  Merb::Mailer.delivery_method = :sendmail
  Merb.add_mime_type(:atom, :to_atom, %w[application/atom+xml])
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
end
