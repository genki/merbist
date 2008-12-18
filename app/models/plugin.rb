class Plugin
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :home, URI
  property :description, Text

  belongs_to :user

  validates_present :name
  validates_present :home
  validates_present :description
  validates_format :home, :as => :url
end