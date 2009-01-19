class Gems < Application
  before :ensure_authenticated, :only => [:new, :create]

  def index
    spec_path = File.join(Merb::Config[:gem_home], 'specifications')
    @gems = {}
    Dir.glob(File.join(spec_path, "*.gemspec")).each do |file|
      spec = Gem::Specification.load(file)
      @gems[spec.name] ||= []
      @gems[spec.name] << spec.version
    end
    render
  end

  def new
    render
  end

  def create(file)
    name = File.basename(file[:filename])
    raise "Invalid file type." unless File.extname(name) == ".gem"
    spec_name = "#{name}spec"
    spec_path = File.join(Merb::Config[:gem_home], 'specifications', spec_name)
    IO.popen("gem specification #{file[:tempfile].path}") do |io|
      spec = Gem::Specification.from_yaml(io.read)
      open(spec_path, "w") do |spec_file|
        spec_file.write spec.to_ruby
      end
    end
    gem_path = File.join(Merb::Config[:gem_home], 'cache', name)
    system "cp -f #{file[:tempfile].path} #{gem_path}"
    redirect resource(:gems, :new), :message => {
      :notice => "#{name} is successfully uploaded."}
  end

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
