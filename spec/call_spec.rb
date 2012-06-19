require 'call'

describe "Call" do
  before(:each) do
    RingRevenue::CallCenter.config = {
      :CALL_CENTER_ID => 1,
      :API_VERSION    => '2010-04-22',
      :API_USERNAME   => 'andrew@ringrevenue.com',
      :API_PASSWORD   => 'sublime',
    }

    @call = RingRevenue::CallCenter::Call.new(
      # Required parameters
      :start_time_t => 1338835119, 
      :call_center_call_id => 1,   # Listed as optional?
      :duration_in_seconds => 200, # Listed as optional?

      # Optional parameters
      :reason_code => "S",
      :sale_amount => 1.01,
      :sale_currency => "USD"
    )
  end 

  it "should raise an error if a required option is not present" do
    lambda { RingRevenue::CallCenter::Call.new }.should raise_error(ArgumentError)
  end

  it "should return 401 for bad auth" do
    RingRevenue::CallCenter.config[:API_USERNAME] = "fake@fake.com"
    RingRevenue::CallCenter.config[:API_USERNAME] = "fake"

    response = @call.save
    response.code.to_i.should == 401
  end

  it "should return 201 for successful attempt" do
    response = @call.save
    response.code.to_i.should == 201
  end

end