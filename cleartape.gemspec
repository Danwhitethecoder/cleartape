# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cleartape/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tomasz Szymczyszyn"]
  gem.email         = ["tomasz.szymczyszyn@gmail.com"]
  gem.description   = %q{}
  gem.summary       = %q{}
  gem.homepage      = "http://github.com/kammerer/cleartape"

  gem.files         = Array(Dir.glob("lib/**/*.rb")) + ["MIT-LICENSE", "Rakefile", "README.md"]
  gem.test_files    = Array(Dir.glob("^(test|spec)/**/*.rb"))
  gem.name          = "cleartape"
  gem.require_paths = ["lib"]
  gem.version       = Cleartape::VERSION

  # See Gemfile for development dependencies.

  gem.add_runtime_dependency "activemodel"
  gem.add_runtime_dependency "activesupport"
  gem.add_runtime_dependency "active_attr"

  gem.add_dependency "rails", "~> 3.2.12"

  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "shoulda", "~> 3.5.0"
  gem.add_development_dependency "capybara", "~> 2.1.0"
end


