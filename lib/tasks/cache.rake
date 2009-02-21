namespace :cache do
  namespace :clear do
    desc 'clear all clear from memcached'
    task :memcached do
      Merb.cache[:memcached].delete_all!
    end

    desc 'clear all clear from file_store'
    task :file_store do
      # Not supported
      #Merb.cache[:file_store].delete_all
    end
  end

  desc 'Clear all caches'
  task :clear => ['clear:memcached', 'clear:file_store']
end
