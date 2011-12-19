require 'net/http'
require 'json'

Dir[File.dirname(__FILE__) + '/basuco/*.rb'].each {|file| require file }

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