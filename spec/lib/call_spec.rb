require 'spec_helper'
require 'call'

describe "Call" do
  before(:all) do
    Invoca::CallCenter.config = {
      :CALL_CENTER_ID => 1,
      :API_VERSION    => '2010-04-22',
      :API_USERNAME   => 'user@invoca.com',
      :API_PASSWORD   => 'password',
    }
  end 

  it "should raise an error if a required option is not present" do
    lambda { Invoca::CallCenter::Call.new }.should raise_error(ArgumentError)
  end

  describe "server stubs" do

    context "successful calls" do
      before :each do
        WebMock.reset!

        @api_url = URI.parse Invoca::CallCenter.get_api_url

        @call = Invoca::CallCenter::Call.new(
          :start_time_t => 1339289018,
          :call_center_call_id => 1,
          :duration_in_seconds => 200,
          :reason_code   => "S",
          :sale_currency => "USD",
          :sale_amount   => 1.01
        )

        @url_regex = /http:\/\/user%40invoca.com:password@api[0|1].invoca.com#{@api_url.path}/
        @stub = stub_request(:post, @url_regex).
          with(:body => {
            "sale_amount"=>"1.01", 
            "call_center_call_id"=>"1", 
            "sale_currency"=>"USD",
            "reason_code"=>"S", 
            "duration_in_seconds"=>"200", 
            "start_time_t"=>"1339289018"
            },
            :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded'}).
          to_return(:code => 200, :body => " ", :headers => {})
      end

      it "makes a request to the api url" do
        @call.save
        @stub.should have_been_requested
      end

      it "returns a 200 status code and empty body" do
        response = @call.save
        response.code.to_i.should == 200
        response.body.should == " "
      end

      it "accepts array parameters do" do
        @stub = stub_request(:post, @url_regex).
          with(:body => {
            :start_time_t => '1339721018',

            :call_center_call_id => '1',
            :duration_in_seconds => '200',
            :reason_code   => "S",
            :sale_currency => "USD",
            :sale_amount   => '1.12',
            :email_address => "john@doe.com",
            :sku_list      => ['DVD', 'cleaner'],
            :quantity_list => ['2','1']
          },
          :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded'}).
        to_return(:code => 200, :body => "", :headers => {})

        @call = Invoca::CallCenter::Call.new(
          :start_time_t => 1339721018,

          :call_center_call_id => 1,
          :duration_in_seconds => 200,
          :reason_code   => "S",
          :sale_currency => "USD",
          :sale_amount   => 1.12,
          :email_address => "john@doe.com",
          :sku_list      => ['DVD', 'cleaner'],
          :quantity_list => ['2','1']
        )
        response = @call.save
        @stub.should have_been_requested
        response.code.to_i.should == 200
      end

    end


    context "invalid calls" do
      before :each do
        WebMock.reset!

        @api_url = URI.parse Invoca::CallCenter.get_api_url

        @invalid_call = Invoca::CallCenter::Call.new(
          :start_time_t => 1339289018,
          :sale_currency => 'x'
        )

        @url_regex = /http:\/\/user%40invoca.com:password@api[0|1].invoca.com#{@api_url.path}/
        @err_msg = %Q{
          Error 403:
          <?xml version="1.0" encoding="UTF-8"?>
          <Error>
            <Class>RecordInvalid</Class>
            <Message>money is invalid ["Currency x is not supported"]</Message>
          </Error>
        }
        @invalid_stub = stub_request(:post, @url_regex).
          with(:body => {"start_time_t"=>"1339289018", "sale_currency"=>"x"},
               :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded'}).
          to_return(:status => 403, :body => @err_msg, :headers => {})
      end

      it "makes a request to the api url" do
        @invalid_call.save
        @invalid_stub.should have_been_requested
      end

      it "returns a 403 status code and an error message in the body" do
        response = @invalid_call.save
        response.code.to_i.should == 403
        response.body.should == @err_msg
      end

    end

  end
end
