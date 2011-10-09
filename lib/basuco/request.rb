module Basuco 
 module Request
    protected
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
  end # class Search