#!/usr/bin/env rake

begin
  require 'bundler/setup'
  require "bundler/gem_tasks"
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler.require
Bundler::GemHelper.install_tasks

require 'rspec'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :default => :spec

