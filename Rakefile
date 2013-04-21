require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task default: :test

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
