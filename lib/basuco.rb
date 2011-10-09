require 'net/http'
require 'json'

Dir[File.dirname(__FILE__) + '/basuco/*.rb'].each {|file| require file }

# init default session
Basuco::Search.new

module Basuco


  
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