require File.expand_path '../lib/clara/version', __FILE__

Gem::Specification.new do |s|
  s.name          = 'clara'
  s.version       = Clara::VERSION
  s.date          = '2013-09-28'
  s.summary       = 'A package manager for your config file'
  s.description   = 'A command line tool that allows you to manage configuration files as if they were packages.'
  s.authors       = ['Boris Bera']
  s.email         = ['bboris@rsoft.ca']
  s.files         = Dir['{lib}/**/*.rb', '{sql}/**/*.sql', 'Rakefile']
  s.test_files    = Dir['{spec}/**/*.rb']

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'bundler'
end
