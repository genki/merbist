require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/gems" do
  before(:each) do
    @response = request("/gems")
  end
end