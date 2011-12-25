module Basuco
  class << self
    attr_accessor :api
  end

  class Api
    def initialize(options = {:host => 'http://www.freebase.com', :username => 'un', :password => 'pw'})
      @host = options[:host]
      @username = options[:username]
      @password = options[:password]
      Basuco.api = self
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