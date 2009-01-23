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

  before(:create){@created_at = DateTime.now}
  before(:save){@updated_at = DateTime.now}

  def self.desc
    all(:order => [:id.desc])
  end
end
