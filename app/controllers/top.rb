class Top < Application
  before do
    debugger
  end

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
    gems_count = plugins.size
    gemdir = File.join(Merb::Config[:gem_home], 'gems')
    lockfile = File.join(gemdir, '.lockfile')
    file = open(lockfile, "w")
    if file.flock(File::LOCK_EX|File::LOCK_NB)
      Thread.new do
        begin
          generate_index(gemdir, plugins)
        ensure
          file.flock(File::LOCK_UN)
        end
      end
      redirect url(:root), :message => {
        :notice => "#{gems_count} repos are being fetched in background."}
    else
      redirect url(:root), :message => {
        :error => "Previous task is running."}
    end
  end

private
  def generate_index(gemdir, plugins)
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
          FileUtils.mv filename, "..", :force => true
        end
      rescue Exception => e
        plugin.update_attributes :error => e.message
      else
        plugin.update_attributes :error => nil
      end
    end
    system "gem", "generate_index", "-d", Merb::Config[:gem_home]
  end
end
