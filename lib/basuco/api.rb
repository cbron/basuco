module Basuco
  class << self
    attr_accessor :api
  end

  class Api
    include Request
    public
    def initialize(options = {:host => 'http://www.freebase.com', :username => 'un', :password => 'pw'})
      @host = options[:host]
      @username = options[:username]
      @password = options[:password]
      Basuco.Api = self
    end

    def check_status
      http_request status_service_url
    end


  end
end