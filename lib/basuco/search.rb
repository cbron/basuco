module Basuco
  require 'request'
  class << self
    attr_accessor :search
  end
  
  # A class for returing errors from the freebase api.
  # For more infomation see the freebase documentation:
  class ReadError < ArgumentError
    attr_accessor :code, :msg
    def initialize(code,msg)
      self.code = code
      self.msg = msg
    end
    def message
      "#{code}: #{msg}"
    end
  end
  
  class AttributeNotFound < StandardError ; end
  class PropertyNotFound < StandardError ; end
  class ResourceNotFound < StandardError ; end
  class TopicNotFound < StandardError ; end
  class ViewNotFound < StandardError ; end
  
  # partially taken from chris eppstein's freebase api
  # http://github.com/chriseppstein/freebase/tree
  class Search
    public
    # @param host<String>          the API host
    # @param username<String>      freebase username
    # @param password<String>      user password
    def initialize(options = {:host => 'http://www.freebase.com', :username => 'un', :password => 'pw'})
      @host = options[:host]
      @username = options[:username]
      @password = options[:password]
      Basuco.search = self

      # TODO: check connection
    end
    
    SERVICES = {
      :mqlread => '/api/service/mqlread',
      :mqlwrite => '/api/service/mqlwrite',
      :blurb => '/api/trans/blurb/guid/',
      :raw => '/api/trans/raw/guid/',
      :login => '/api/account/login', #not done
      :logout => '/api/account/logout', #not done
      :upload => '/api/service/upload',
      :topic => '/experimental/topic',
      :search => '/api/service/search',
      :status => '/api/status', #not done
      :thumb => 'api/trans/image_thumb'

    }

    def service_url(svc)
      "#{@host}#{SERVICES[svc]}"
    end

    SERVICES.each_key do |k|
      define_method("#{k}_service_url") do
        service_url(k)
      end
    end

    # raise an error if the inner response envelope is encoded as an error
    def handle_read_error(inner)
      unless inner['code'][0, '/api/status/ok'.length] == '/api/status/ok'
        error = inner['messages'][0]
        raise ReadError.new(error['code'], error['message'])
      end
    end # handle_read_error

    # Perform a mqlread and return the results
    # Specify :cursor => true to batch the results of a query, sending multiple requests if necessary.
    # TODO: should support multiple queries
    #       you should be able to pass an array of queries
    def mqlread(query, options = {})
      cursor = options[:cursor]
      if cursor
        query_result = []
        while cursor
          response = get_query_response(query, cursor)
          query_result += response['result']
          cursor = response['cursor']
        end
      else
        response = get_query_response(query, cursor)
        cursor = response['cursor']
        query_result = response['result']
      end
      query_result
    end


      # Executes an Mql Query against the Freebase API and returns the result as
    # a <tt>Collection</tt> of <tt>Resources</tt>.
    def all(options = {})
      #assert_kind_of 'options', options, Hash
      query = { :name => nil }.merge!(options).merge!(:id => nil)
      result = Basuco.search.mqlread([ query ], :cursor => !options[:limit])    
      Basuco::Collection.new(result.map { |r| Basuco::Resource.new(r) })
    end

      
    # Executes an Mql Query against the Freebase API and returns the result wrapped
    # in a <tt>Resource</tt> Object.
    #
    # == Examples
    #
    #  Basuco.get('/en/the_police') => #<Resource id="/en/the_police" name="The Police">
    # @api public
    def get(id)
      Basuco::Resource.get(id)
    end
    
    def raw_content(id, options = {})
      response = http_request raw_service_url+id, options
      response
    end
    
    def blurb_content(id, options = {})
      response = http_request blurb_service_url+id, options
      response
    end
    
    def topic(id, options = {})
      options.merge!({:id => id})

      response = http_request topic_service_url+"/standard", options
            --debugger
      result = JSON.parse response
      inner = result[id]
      handle_read_error(inner)
      inner['result']
    end
    
    def search(query, options = {})
      options.merge!({:query => query})
      
      response = http_request search_service_url, options
      result = JSON.parse response
      
      handle_read_error(result)
      
      result['result']
    end

  end # class Search
end # module Basuco