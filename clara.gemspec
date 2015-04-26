# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clara/version'

Gem::Specification.new do |s|
  s.name          = 'clara'
  s.version       = Clara::VERSION
  s.authors       = ['Boris Bera']
  s.email         = %w(bboris@rsoft.ca)
  s.summary       = 'A package manager for your config files'
  s.description   = 'A command line tool that allows you to manage' \
                    'configuration files as if they were packages.'
  s.homepage      = 'https://github.com/beraboris/clara'
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'boson', '~> 1.3'
  s.add_dependency 'safe_yaml', '~> 1.0'
  s.add_dependency 'erubis', '~> 2.7'

  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'cucumber', '~> 1.3'
  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'fakefs', '~> 0.6'
  s.add_development_dependency 'rubocop', '~> 0.30'
  s.add_development_dependency 'pry'
end
