class Yaml < Application
  def index
    only_provides :text
    spec_path = File.join(Merb::Config[:gem_home], 'specifications')
    index = Gem::SourceIndex.from_gems_in(spec_path)
    render index.to_yaml
  end
end
