# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "basuco/version"

Gem::Specification.new do |s|
  s.name        = "basuco"
  s.version     = Basuco::VERSION
  s.authors     = ["Caleb Bron"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = %q{Freebase Gem}
  s.description = %q{Transfer information from freebase.com through ruby.}

  s.rubyforge_project = "basuco"

  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end
