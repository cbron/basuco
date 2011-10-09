module Request

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

    # raise an error if the inner response envelope is encoded as an error
    def handle_read_error(inner)
      unless inner['code'][0, '/api/status/ok'.length] == '/api/status/ok'
        error = inner['messages'][0]
        raise ReadError.new(error['code'], error['message'])
      end
    end # handle_read_error

    private
    # returns parsed json response from freebase mqlread service
    def get_query_response(query, cursor=nil)
      envelope = { :qname => {:query => query, :escape => false }}
      envelope[:qname][:cursor] = cursor if cursor
      
      response = http_request mqlread_service_url, :queries => envelope.to_json
      result = JSON.parse response
      inner = result['qname']
      handle_read_error(inner)
      inner
    end
    
    # encode parameters
    def params_to_string(parameters)
      parameters.keys.map {|k| "#{URI.encode(k.to_s)}=#{URI.encode(parameters[k].to_s)}" }.join('&')
    end
    
    # does the dirty work
    def http_request(url, parameters = {})
      params = params_to_string(parameters)
      url << '?'+params unless params !~ /\S/
            
      return Net::HTTP.get_response(::URI.parse(url)).body
      
      fname = "#{MD5.md5(params)}.mql"
      open(fname,"w") do |f|
        f << response
      end
    end

  end #Request