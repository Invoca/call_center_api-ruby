require 'spec_helper'
require 'call'

describe "Call" do
  before(:all) do
    RingRevenue::CallCenter.config = {
      :CALL_CENTER_ID => 1,
      :API_VERSION    => '2010-04-22',
      :API_USERNAME   => 'andrew@ringrevenue.com',
      :API_PASSWORD   => 'sublime',
    }
  end 

  it "should raise an error if a required option is not present" do
    lambda { RingRevenue::CallCenter::Call.new }.should raise_error(ArgumentError)
  end

  describe "server stubs" do

    context "successful calls" do
      before :each do
        WebMock.reset!

        @api_url = URI.parse RingRevenue::CallCenter.get_api_url

        @call = RingRevenue::CallCenter::Call.new({
          :start_time_t => 1339289018,
          :call_center_call_id => 1,
          :duration_in_seconds => 200,
          :reason_code   => "S",
          :sale_currency => "USD",
          :sale_amount   => 1.01
        })

        @url_regex = /http:\/\/andrew%40ringrevenue.com:sublime@api[0|1].ringrevenue.com#{@api_url.path}/
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
          to_return(:code => 200, :body => "", :headers => {})
      end

      it "makes a request to the api url" do
        @call.save
        @stub.should have_been_requested
      end

      it "returns a 200 status code" do
        response = @call.save
        response.code.to_i.should == 200
      end

      it "outputs a success message" do
        $stdout.should_receive(:write).with("Success!\n\n")
        response = @call.save

        if (200..299) === response.code.to_i
          puts "Success!\n\n"
        else
         puts "Error #{response.code}:\n#{response.body}\n"
        end
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

        @call = RingRevenue::CallCenter::Call.new({
          :start_time_t => 1339721018,

          :call_center_call_id => 1,
          :duration_in_seconds => 200,
          :reason_code   => "S",
          :sale_currency => "USD",
          :sale_amount   => 1.12,
          :email_address => "john@doe.com",
          :sku_list      => ['DVD', 'cleaner'],
          :quantity_list => ['2','1']
        })
        response = @call.save
        response.code.to_i.should == 200
      end

    end


    context "invalid calls" do
      before :each do
        WebMock.reset!

        @api_url = URI.parse RingRevenue::CallCenter.get_api_url

        @invalid_call = RingRevenue::CallCenter::Call.new({
          :start_time_t => 1339289018,
          :sale_currency => 'x',
        })

        @url_regex = /http:\/\/andrew%40ringrevenue.com:sublime@api[0|1].ringrevenue.com#{@api_url.path}/
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

      it "returns a 403 status code for bad parameters" do
        response = @invalid_call.save
        response.code.to_i.should == 403
      end

      it "returns the error message in the body" do
        response = @invalid_call.save
        response.body.should == @err_msg
      end

      it "outputs an error message" do
        $stdout.should_receive(:write).with("Error 403:\n#{@err_msg}\n")
        response = @invalid_call.save

        if (200..299) === response.code.to_i
          puts "Success!\n\n"
        else
         puts "Error #{response.code}:\n#{response.body}\n"
        end
      end

    end

  end
end