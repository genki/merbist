class Site
  include DataMapper::Resource
  
  property :id, Serial
  property :title, String, :size => 255
  property :uri, Text

  belongs_to :user

  validates_present :title, :uri, :user
  validates_format :uri, :as => :url

  def self.desc
    all(:order => [:id.desc])
  end
end
