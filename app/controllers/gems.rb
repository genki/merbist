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
    require 'tempfile'
    begin
      tmp = Tempfile.new("merbist-gems")
      Zlib::GzipWriter.open(tmp.path, Zlib::BEST_COMPRESSION) do |gz|
        gz.mtime = File.mtime(tmp.path)
        gz.orig_name = "specs.4.8"
        gz.write dump
      end
      send_file tmp.path, :filename => "spec.4.8.gz"
    ensure
      tmp.close
    end
  end

  def marshal
    spec_path = File.join(Merb::Config[:gem_home], 'specifications')
    index = Gem::SourceIndex.from_gems_in(spec_path)
    send_data Marshal.dump(index)
  end
end
