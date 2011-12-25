module Basuco
  class << self
    attr_accessor :trans
  end
  
  # partially taken from chris eppstein's freebase api
  # http://github.com/chriseppstein/freebase/tree
  class Trans
    include Request

    def initialize(options = {:host => 'http://www.freebase.com', :username => 'un', :password => 'pw'})
      @host = options[:host]
      @username = options[:username]
      @password = options[:password]
      Basuco.trans = self
    end

        #yes or no
    def status?
      response = http_request status_service_url
      result = JSON.parse response
      return result["blob"] == "OK"
    end
    
    def raw_content(id, options = {})
      response = http_request raw_service_url+id, options
      response
    end
    
    def blurb_content(id, options = {})
      response = http_request blurb_service_url+id, options
      response
    end
    
  end
end