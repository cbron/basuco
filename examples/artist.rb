require 'rubygems'
require 'pathname'

EXAMPLES_ROOT = Pathname(__FILE__).dirname.expand_path
require EXAMPLES_ROOT.parent + 'lib/basuco'

session = Basuco::Search.new

resource = session.get('/en/tiesto') #basically everything starts with /en/

resource.views.each do |view|
  puts view
  puts "="*20
  view.attributes.each do |a|
    puts a.property
    puts "-"*20
    puts a
    puts # newline
  end
end
