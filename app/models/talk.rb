class Talk
  include DataMapper::Resource
  
  property :id, Serial
  property :message, Text
  property :created_at, DateTime

  belongs_to :user

  validates_present :message, :user, :created_at

  def self.desc
    all(:order => [:id.desc])
  end
end
