require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Top do
  it "should handle request to the root" do
    req = request_to("/")
    req[:controller].should == "top"
    req[:action].should == "index"
  end

  it "should redirect to the doc page if domain begins with api/doc" do
    res = request("http://doc.merbi.st/")
    res.should redirect_to(Top::MERB_DOC_URI)
  end
end
