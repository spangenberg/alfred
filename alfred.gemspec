# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "alfred/version"

Gem::Specification.new do |s|
  s.name        = "alfred"
  s.version     = Alfred::VERSION
  s.authors     = ["Daniel Spangenberg"]
  s.email       = ["daniel.spangenberg@parcydo.com"]
  s.homepage    = "http://rubygems.org/gems/alfred"
  s.summary     = %q{Alfred is the unobtrusive butler who takes care of the uninvited guests.}
  s.description = %q{Alfred provides better attr_accessor handling on your application.}

  s.rubyforge_project = "alfred"

  s.add_development_dependency "activerecord"
  s.add_development_dependency "rails"
  s.add_development_dependency "rake"
  s.add_development_dependency "rr"
  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
