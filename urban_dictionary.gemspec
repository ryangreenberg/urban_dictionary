# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "urban_dictionary/version"

Gem::Specification.new do |s|
  s.name        = "urban_dictionary"
  s.version     = UrbanDictionary::VERSION
  s.authors     = ["Ryan Greenberg"]
  s.email       = ["ryangreenberg@gmail.com"]
  s.homepage    = ""
  s.summary     = "Interface to urbandictionary.com"
  s.description = s.summary

  s.rubyforge_project = "urban_dictionary"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "nokogiri", "~> 1.5.2"

  s.add_development_dependency "bundler", "~> 1.0.22"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
