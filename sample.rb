require 'lib/call_center'

RingRevenue::CallCenter.config = {
  :CALL_CENTER_ID => 1,
  :API_VERSION    => '2010-04-22',
  :API_USERNAME   => 'andrew@ringrevenue.com',
  :API_PASSWORD   => 'sublime',
}

call_attrs = [
  {
    # Required parameter
    :start_time_t => 1339289018,

    # Optional parameters
    :call_center_call_id => 1,
    :duration_in_seconds => 200,

    # Optional Parameters for Tracking Sales
    :reason_code => 'S',
    :sale_currency => 'USD',
    :sale_amount => 1.01
  },

  {
    :start_time_t => 1339721018,

    :call_center_call_id => 1,
    :duration_in_seconds => 200,
    :reason_code   => "S",
    :sale_currency => "USD",
    :sale_amount   => 1.12,
    :email_address => "john@doe.com",
    :sku_list      => ['dvd', 'apple'],
    :quantity_list => ['5', '10']
  },

  {
    :start_time_t => 1340153017,

    :call_center_call_id => 1,
    :duration_in_seconds => 200,
    :reason_code => 'S',
    :sale_currency => 'USD',
    :sale_amount => 2.02,
    :use_http_status => 1
  }
]

call_attrs.each do |opts|
  call = RingRevenue::CallCenter::Call.new(opts)
  response = call.save

  if (200..299) === response.code.to_i
    puts "Success!\n\n"
  else
   puts "Error #{response.code}:\n#{response.body}\n"
  end
end