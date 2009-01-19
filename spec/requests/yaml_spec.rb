require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/yaml" do
  before(:each) do
    @response = request("/yaml")
  end
end