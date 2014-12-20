require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'bundler/gem_tasks'

RSpec::Core::RakeTask.new('spec')
Cucumber::Rake::Task.new('features')

desc 'Run all tests'
task default: [:spec, :features]
