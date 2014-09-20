require 'spec_helper'
require 'call_center'

describe "Call Center" do
  before :each do
    Invoca::CallCenter.config = {
      :CALL_CENTER_ID => 1,
      :API_VERSION    => '2010-04-22',
      :API_USERNAME   => 'user@invoca.com',
      :API_PASSWORD   => 'password',
    }
  end

  it "should return a correct api url" do
    url = Invoca::CallCenter.get_api_url
    ["https://api0.invoca.com/api/2010-04-22/calls/1.xml",
     "https://api1.invoca.com/api/2010-04-22/calls/1.xml"].should include url
  end
end
