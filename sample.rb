require 'lib/call_center'

RingRevenue::CallCenter.config = {
  :CALL_CENTER_ID => 1,
  :API_VERSION    => '2010-04-22',
  :API_USERNAME   => 'andrew@ringrevenue.com',
  :API_PASSWORD   => 'sublime',
}


call = RingRevenue::CallCenter::Call.new(
  # Required parameter
  :start_time_t => 1338835119, 

  # Optional parameters
  :call_center_call_id => 1,
  :duration_in_seconds => 200,

  # Optional Parameters for Tracking Sales
  :reason_code   => "S",
  :sale_currency => "USD",
  :sale_amount   => 1.01
)

response = call.save

if (200..299) === response.code.to_i
  puts "Success!\n"
else
 puts "Error (HTTP #{response.code}):\n #{response.body}\n"
end




# calls = [
#   RingRevenue::CallCenter::Call.new(
#     :start_time_t => 123, 
#     :call_center_call_id => 1,
#     :duration_in_seconds => 200
#   ),
#   RingRevenue::CallCenter::Call.new(
#     :start_time_t => 123, 
#     :call_center_call_id => 1,
#     :duration_in_seconds => 200
#   ),
#   RingRevenue::CallCenter::Call.new(
#     :start_time_t => 123,
#     :call_center_call_id => 1,
#     :duration_in_seconds => 200
#   )
# ]

# calls.each do |call|
#   response = call.save

#   if (200..299) === response.code.to_i
#     puts "Success!\n"
#   else
#    puts "Error #{response.code}: #{response.body}\n"
#   end
# end