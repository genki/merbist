require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Plugin do
  before do
    @plugin = Plugin.new(
      :name => 'test',
      :home => 'http://blog.s21g.com/genki',
      :description => 'Test plugin'
    )
    @plugin.user = User.create(
      :login => "krusty",
      :password => "klown",
      :password_confirmation => "klown",
      :email => 'genki@s21g.com',
      :activated_at => Time.now
    )
  end

  it "should have to user" do
    @plugin.should be_respond_to(:user)
    @plugin.user.should be_kind_of(User)
    @plugin.user.should_not be_new_record
  end

  it "should be able to be saved" do
    @plugin.save.should be_true
    @plugin.created_at.should be_kind_of(DateTime)
    @plugin.updated_at.should be_kind_of(DateTime)
  end

  it "should make repos nil if it is blank" do
    @plugin.repos = "  "
    @plugin.repos.should be_nil
    @plugin.repos = "git://test.com/foo.git"
    @plugin.repos.should_not be_nil
  end

  it "should make repos stripped if it has white spaces" do
    @plugin.repos = "  git://test.com/foo.git  "
    @plugin.repos.should == "git://test.com/foo.git"
  end

  it "should validate repos as an URL" do
    @plugin.should be_valid
    @plugin.repos = "foo.com"
    @plugin.should_not be_valid
    @plugin.repos = " http://test.com/foo.git "
    @plugin.valid?
    @plugin.should be_valid
  end
end
