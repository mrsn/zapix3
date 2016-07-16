# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zapix/version'

Gem::Specification.new do |spec|
  spec.name          = 'zapix3'
  spec.version       = Zapix::VERSION
  spec.authors       = ['stoyan']
  spec.email         = ['stoyanoff.s@gmail.com']
  spec.description   = 'Communication with the Zabbix API made easy. This version is compatible with zabbix 3.0'
  spec.summary       = 'A cool gem'
  spec.homepage      = 'https://github.com/mrsn/zapix3'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'json'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'activerecord'
end
