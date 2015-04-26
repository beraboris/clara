require 'bundler/setup'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new('spec')
RuboCop::RakeTask.new

desc 'Run all tests and checks'
task default: [:spec, :rubocop]
