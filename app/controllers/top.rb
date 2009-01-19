class Top < Application
  def index
    render
  end

  def gems(path)
    path = File.join(Merb::Config[:gem_home],
      path.split(File::Separator).delete_if{|i| i =~ %r{^\.+$}})
    send_file path
  end
end
