<h1>call_center_api-ruby</h1>

This is a Ruby wrapper for the Call Center API which is used to report completed order information from the Call Center back into the RingRevenue platform. You can read more about this API on the [documentation page](http://support.ringrevenue.com/advertisers/Sales_Reporting_API). 

Using this wrapper takes 2 steps:

1. Get your call center id and username + password credentials from RingRevenue Support. If you are an Advertiser interested in setting up a pay on sale campaign, please contact your network advisor to request your call center credentials.

2. Add your credentials to the sample script and fill the call information according to your needs.

The provided sample script processes 3 calls with example parameters. A full list of accepted parameters is in the [API docs](http://support.ringrevenue.com/advertisers/Sales_Reporting_API). To customize the script for your own use, you must first fill in your credentials in the `RingRevenue::CallCenter.config` hash. `call_attrs` is an array of hashes containing attributes for 3 example calls, which are then batch processed. The API call returns an HTTP response object, and in the example a message is printed depending on the response code. In the case of an error, the HTTP code and error message body are shown.

## Notes

* `start_time_t` is a required parameter.

* The `sku_list` and `quantity_list` array attributes are closely related, and must appear in the same order. In the example,  the sku DVD has a quantity value of 2 while cleaner is 1.