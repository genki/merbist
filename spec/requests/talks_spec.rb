require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a talk exists" do
  Talk.all.destroy!
  Merb::Fixtures.load_fixture("users")
  login
  request(resource(:talks), :method => "POST", 
    :params => { :talk => { :id => nil , :message => 'hello'}})
end

describe "resource(:talks)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:talks))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of talks" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a talk exists" do
    before(:each) do
      @response = request(resource(:talks))
    end
    
    it "has a list of talks" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Talk.all.destroy!
      Merb::Fixtures.load_fixture("users")
      login
      @response = request(resource(:talks), :method => "POST", 
        :params => { :talk => { :id => nil, :message => 'hello' }})
    end
    
    it "redirects to resource(:talks)" do
      @response.should redirect_to(resource(:talks),
        :message => {:notice => "talk was successfully created"})
    end
    
  end
end

describe "resource(@talk)" do 
  describe "a successful DELETE", :given => "a talk exists" do
     before(:each) do
       @response = request(resource(Talk.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:talks))
     end

   end
end
