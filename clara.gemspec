require File.expand_path '../lib/clara/version', __FILE__

Gem::Specification.new do |s|
  s.name          = 'clara'
  s.version       = Clara::VERSION
  s.date          = '2013-04-20'
  s.summary       = 'Config package manager'
  s.description   = 'A tool for packaging and deploying configuration files.'
  s.authors       = ['Boris Bera']
  s.email         = ['bboris@rsoft.ca']
  s.files         = Dir['{lib}/**/*.rb', '{sql}/**/*.sql', 'Rakefile']
  s.test_files    = Dir['{test}/**/*.rb']

  s.add_dependency 'sqlite3', '~> 1.3.7'
end
