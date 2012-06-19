require 'net/http'
require 'uri'

module RingRevenue
  module CallCenter
    PORT = 3000

    class Call
      attr_accessor :params

      def initialize(params={})
        raise ArgumentError, "start_time_t must be provided" if params[:start_time_t].nil?

        @params = params
      end

      def initialize_request(uri)
        # Set body data and authenticate the request
        config = RingRevenue::CallCenter.config
        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data(@params)
        request.basic_auth(config[:API_USERNAME], config[:API_PASSWORD])
        request
      end

      def save
        # Configure URI / HTTP objects
        api_url = RingRevenue::CallCenter.get_api_url
        uri = URI.parse(api_url)
        

        # Send the request and return the response
        request = initialize_request(uri)
        response = Net::HTTP.new(uri.host, PORT).request(request)
        response
      end

    end

  end
end