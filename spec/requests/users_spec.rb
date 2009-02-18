require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "fixture" do
  Merb::Fixtures.load_fixture("users")
  login
  request(resource(:users), :method => "POST", 
    :params => { :user => { :id => nil }})
end

describe "resource(:users)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:users))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of users" do
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "fixture" do
    before(:each) do
      @response = request(resource(:users))
    end
    
    it "has a list of users" do
      @response.should have_xpath("//ul/li")
    end
  end
end

describe "resource(@user)" do 
  describe "a successful DELETE", :given => "fixture" do
     before(:each) do
       @response = request(resource(User.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:users))
     end

   end
end

describe "resource(:users, :new)" do
  before(:each) do
    @response = request(resource(:users, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@user, :edit)", :given => "fixture" do
  before(:each) do
    @response = request(resource(User.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@user)", :given => "fixture" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(User.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @user = User.first
      @response = request(resource(@user), :method => "PUT", 
        :params => { :user => {:id => @user.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@user))
    end
  end
  
end

