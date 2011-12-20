# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "kashiwamochi/version"

Gem::Specification.new do |s|
  s.name        = "kashiwamochi"
  s.version     = Kashiwamochi::VERSION
  s.authors     = ["mashiro"]
  s.email       = ["mail@mashiro.org"]
  s.homepage    = "https://github.com/mashiro/kashiwamochi"
  s.summary     = %q{Minimal searchng extension for Rails 3}
  s.description = %q{Searching form and sorting query builder}

  s.rubyforge_project = "kashiwamochi"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "railties", "~> 3.0"
  s.add_development_dependency "activerecord", "~> 3.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
end
