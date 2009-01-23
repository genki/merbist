class Plugin
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :home, Text
  property :description, Text
  property :repos, Text
  property :error, Text

  belongs_to :user

  validates_present :name
  validates_present :home
  validates_present :user
  validates_present :description
  validates_format :home, :as => :url

  def self.desc
    all(:order => [:id.desc])
  end

  def to_atom
    "test"
  end
end
