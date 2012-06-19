module RingRevenue
  module CallCenter

    @config = {}

    def self.config
      @config
    end

    def self.config=(options)
      @config.merge!(options)
    end

    def self.get_api_url
      api_num = rand(2) # Randomly choose between api0 and api1
      "https://api#{api_num}.ringrevenue.com/api/#{@config[:API_VERSION]}/calls/#{@config[:CALL_CENTER_ID]}.xml"
    end

  end
end

require File.expand_path('../call', __FILE__)