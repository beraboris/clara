require 'bundler/setup'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'bundler/gem_tasks'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new('spec')
Cucumber::Rake::Task.new('features')
RuboCop::RakeTask.new 


desc 'Run all tests'
task default: [:spec, :features, :rubocop]
