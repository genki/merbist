class Top < Application
  def index
    render
  end

  def gems(path)
    path = File.join(Merb::Config[:gem_home],
      path.split(File::Separator).delete_if{|i| i =~ %r{^\.+$}})
    send_file path
  end

  def fetch
    plugins = Plugin.all(:repos.not => nil)
    run_later do
      gemdir = File.join(Merb::Config[:gem_home], 'gems')
      plugins.each do |plugin|
        begin
          name = File.basename(plugin.repos.strip).split(/\.git$/)[0]
          path = File.join(gemdir, name)
          if File.exist?(path)
            git = Git.open(path)
            git.pull
          else
            repos = "--depth=1 #{plugin.repos.strip}"
            git = Git.clone(repos, path)
          end
          spec = Gem::Specification.load(File.join(path, "#{name}.gemspec"))
          git.chdir do
            filename = Gem::Builder.new(spec).build
            system "mv", '-f', filename, ".."
          end
        rescue Exception
        end
      end
      system "gem", "generate_index", "-d", Merb::Config[:gem_home]
    end
    redirect :index, :message => {
      :notice => "#{plugins.size} repos are being fetched in background."}
  end
end
