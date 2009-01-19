require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Plugin do
  before do
    @plugin = Plugin.new
  end

  it "should have to user" do
    @plugin.should be_respond_to(:user)
  end
end
