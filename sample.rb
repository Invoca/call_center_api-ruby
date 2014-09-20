require 'lib/call_center'

Invoca::CallCenter.config = {
  :CALL_CENTER_ID => 1,
  :API_VERSION    => '2010-04-22',
  :API_USERNAME   => 'username@invoca.com',
  :API_PASSWORD   => 'password',
}

call_attrs = [
  {
    # Required parameter
    :start_time_t => 1339289018,

    # Optional parameters
    :call_center_call_id => 91234567,
    :duration_in_seconds => 200,

    # Optional Parameters for Tracking Sales
    :reason_code => 'S',
    :sale_currency => 'USD',
    :sale_amount => 1.01
  },

  {
    :start_time_t => 1339721018,

    :call_center_call_id => 91234568,
    :duration_in_seconds => 200,
    :reason_code   => "S",
    :sale_currency => "USD",
    :sale_amount   => 1.12,
    :email_address => "john@doe.com",
    :sku_list      => ['DVD', 'cleaner'],
    :quantity_list => ['2', '1']
  },

  {
    :start_time_t => 1340153017,

    :call_center_call_id => 91234569,
    :duration_in_seconds => 200,
    :reason_code => 'S',
    :sale_currency => 'USD',
    :sale_amount => 2.02,
    :called_phone_number => '+1 8888665440',
    :calling_phone_number => '+1 8056801218'
  }
]

call_attrs.each do |attrs|
  call = Invoca::CallCenter::Call.new(attrs)
  response = call.save

  if (200..299) === response.code.to_i
    puts "Success on call #{call.params[:call_center_call_id]}!\n\n"
  else
    puts "Error on call #{call.params[:call_center_call_id]} #{response.code}:\n#{response.body}\n"
  end
end
