class Gems < Application
  def show(name)
    only_provides :gem
    gem_path = File.join(Merb::Config[:gem_home], 'cache', name)
    send_file gem_path
  end
end
