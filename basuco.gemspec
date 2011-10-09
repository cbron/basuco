# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "basuco/version"

Gem::Specification.new do |s|
  s.name        = "basuco"
  s.version     = Basuco::VERSION
  s.authors     = ["Caleb Bron"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = %q{Freebase Wrapper}
  s.description = %q{Connect information from freebase.com through ruby.}

  s.rubyforge_project = "basuco"

  s.add_development_dependency "rspec"
  # s.add_development_dependency "json"
# gem 'extlib'
# gem 'json'
# gem 'addressable'

# group :development do
#   gem 'rake'
#   gem 'jeweler'
#   gem 'shoulda'
#   gem 'jnunemaker-matchy', '0.4.0'
# end


  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
