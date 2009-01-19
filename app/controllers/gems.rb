class Gems < Application
  provides :gem

  def show(name)
    gem_path = File.join(Merb::Config[:gem_home], 'gems', name)
    send_file gem_path
  end
end
