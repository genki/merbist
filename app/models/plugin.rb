class Plugin
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :home, Text
  property :description, Text
  property :repos, Text
  property :error, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :user

  validates_present :name
  validates_present :home
  validates_present :user
  validates_present :description
  validates_format :home, :as => :url
  validates_with_block :repos do
    begin
      @repos.blank? || ::URI.parse(@repos).scheme
    rescue Exception => e
      [false, e.message]
    end
  end

  before(:create){@created_at = DateTime.now}
  before(:save){@updated_at = DateTime.now}
  before(:save){@error = nil if repos.blank?}

  def self.desc
    all(:order => [:id.desc])
  end

  def gemname
    return nil if repos.blank?
    File.basename(repos.strip).split(%r{\.git$})[0]
  end

  def version
    return @version if @version
    return nil if repos.blank?
    gemdir = File.join(Merb::Config[:gem_home], 'gems')
    pattern = File.join(gemdir, "#{gemname}-*.gem")
    path = Dir.glob(pattern).sort.last
    return if path.blank?
    @version ||= path.split('-').last.split('.gem').first
  end

  def signature
    version ? "#{name}-#{version}" : name
  end

  def readme
    return @readme if @readme
    return nil if repos.blank?
    gemdir = File.join(Merb::Config[:gem_home], 'gems')
    pattern = File.join(gemdir, gemname, "README*")
    path = Dir.glob(pattern).sort.first
    return nil if path.blank?
    @readme ||= open(path).read
  end

  def repos=(repos)
    attribute_set :repos, repos.blank? ? nil : repos.strip
  end
end
