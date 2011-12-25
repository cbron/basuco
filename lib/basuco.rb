require 'net/http'
require 'json'

require 'basuco/request.rb'
require 'basuco/api.rb'
require 'basuco/attribute.rb'
require 'basuco/collection.rb'
require 'basuco/property.rb'
require 'basuco/topic.rb'
require 'basuco/search.rb'
require 'basuco/trans.rb'
require 'basuco/type.rb'
require 'basuco/util.rb'
require 'basuco/type.rb'
require 'basuco/version.rb'
require 'basuco/view.rb'

module Basuco
    include Request

    #hash of all statuses
    def self.check_statuses
      response = http_request status_service_url
      result = JSON.parse response
      result
    end
  
end # module Basuco


#todo

#search = search,mql's, session = login/logout, status, trans = images, blurbs
#status all-in-one

#re-structure
#check all calls, add and modify
#writing ?
#rspec's

#write wd
#post wd