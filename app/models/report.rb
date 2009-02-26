class Report
  include DataMapper::Resource
  
  property :id, Serial
  property :environment, String
  property :working, Boolean
  property :comment, Text
  
  belongs_to :user
  belongs_to :plugin

  validates_present :environment, :working, :user, :plugin

  def self.desc
    all(:order => [:id.desc])
  end
end
