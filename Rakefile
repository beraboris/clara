require 'rspec/core/rake_task'
require 'rdoc/task'

RSpec::Core::RakeTask.new('spec')

desc "Run rspec tests"
task default: :spec

desc "Run from console"
task :console do
  # insert ourselves at the beginning of the loadpath
  $LOAD_PATH.insert 0, File.expand_path('../lib', __FILE__)
  require 'clara'
  begin
    # try loading pry
    require 'pry'
    binding.pry
  rescue LoadError
    # fallback onto IRB
    require 'irb'
    ARGV.clear
    IRB.start
  end
end

desc "Generate documentation"
RDoc::Task.new do |rdoc|
  rdoc.main = "README.rdoc"
  rdoc.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rdoc.rdoc_dir = "doc"
end
