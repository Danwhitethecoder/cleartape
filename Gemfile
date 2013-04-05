source 'https://rubygems.org'

gemspec

group :development do
  gem 'rake'
  gem 'rspec'

  platform :ruby do
    gem 'sqlite3'
  end

  platform :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
  end
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
end

gem 'haml'
gem 'jquery-rails', :require => false

