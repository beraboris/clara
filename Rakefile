require 'rspec/core/rake_task'
require 'rdoc/task'

RSpec::Core::RakeTask.new('spec')

desc "Run rspec tests"
task default: :spec

desc "Generate documentation"
RDoc::Task.new do |rdoc|
  rdoc.main = "README.rdoc"
  rdoc.rdoc_files.include("*.rdoc", "lib/**/*.rb")
  rdoc.rdoc_dir = "doc"
end
