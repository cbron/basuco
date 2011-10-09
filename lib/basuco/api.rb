module Basuco
  class << self
    attr_accessor :api
  end

  class Api
    include Request
    def initialize(options = {:host => 'http://www.freebase.com', :username => 'un', :password => 'pw'})
      @host = options[:host]
      @username = options[:username]
      @password = options[:password]
      Basuco.api = self
    end

    #yes or no
    def status?
      response = http_request status_service_url
      result = JSON.parse response
      return result["code"] == "/api/status/ok"
    end

    #hash of all statuses
    def check_statuses
      response = http_request status_service_url
      result = JSON.parse response
      result
    end

    def api(options = {})
      options.merge!({:query => query})
      
      response = http_request search_service_url, options
      result = JSON.parse response
      
      handle_read_error(result)
      
      result['result']
    end
  end
end