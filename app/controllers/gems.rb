class Gems < Application
  def show(name)
    only_provides :gem
    gem_path = File.join(Merb::Config[:gem_home], 'cache', name)
    send_file gem_path
  end

  def specs
    spec_path = File.join(Merb::Config[:gem_home], 'specifications')
    index = Gem::SourceIndex.from_gems_in(spec_path)
    specs = []
    index.each do |(name, spec)|
      specs << [spec.name, spec.version, spec.platform]
    end
    dump = Marshal.dump(specs)
    require 'zlib'
    send_data Zlib::Deflate.deflate(dump)
  end
end
