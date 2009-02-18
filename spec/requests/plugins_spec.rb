require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "fixture" do
  Merb::Fixtures.load_fixture("users")
  login
end

describe "resource(:plugins)" do
  describe "GET" do
    before(:each) do
      @response = request(resource(:plugins))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of plugins" do
      @response.should have_xpath("//ul")
    end
  end
  
  describe "GET", :given => "fixture" do
    before(:each) do
      @response = request(resource(:plugins))
    end
    
    it "has a list of plugins" do
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST", :given => "fixture" do
    before(:each) do
      login
      @response = request(resource(:plugins), :method => "POST", 
        :params => { :plugin => {
          :id => nil,
          :name => 'test',
          :home => 'http://blog.s21g.com/genki',
          :user_id => User.first.id,
          :description => "Test Plugin"
        }})
    end
    
    it "redirects to resource(:plugins)" do
      @response.should redirect_to(resource(Plugin.all.last),
        :message => {:notice => "plugin was successfully created"})
    end
  end
end

describe "resource(@plugin)" do 
  describe "a successful DELETE", :given => "fixture" do
     before(:each) do
       @response = request(resource(Plugin.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:plugins))
     end
   end
end

describe "resource(:plugins, :new)" do
  before(:each) do
    @response = request(resource(:plugins, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@plugin, :edit)", :given => "fixture" do
  before(:each) do
    @response = request(resource(Plugin.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@plugin)", :given => "fixture" do
  describe "GET" do
    before(:each) do
      @response = request(resource(Plugin.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @plugin = Plugin.first
      @response = request(resource(@plugin), :method => "PUT", 
        :params => { :plugin => {:id => @plugin.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@plugin))
    end
  end
end

