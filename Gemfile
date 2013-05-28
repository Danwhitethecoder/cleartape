source 'https://rubygems.org'

gemspec

group :development, :test do
  gem 'rake'
  gem 'pry'
  gem 'pry-nav'

  platform :ruby do
    gem 'sqlite3'
  end

  platform :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
  end
end

group :test do
  gem 'shoulda', '~> 3.5.0'
  gem 'capybara', '~> 2.1.0'
  gem 'coveralls', :require => false
end

gem 'haml'
gem 'jquery-rails', :require => false

