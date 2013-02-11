# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'bigcartel-builder/version'

Gem::Specification.new do |s|
  s.name         = 'bigcartel-builder'
  s.version      = BigCartel::Builder::VERSION
  s.authors      = ['Big Cartel']
  s.email        = 'dev@bigcartel.com'
  s.homepage     = 'https://github.com/bigcartel/bigcartel-builder'
  s.summary      = 'Easily build Big Cartel themes.'
  s.description  = 'Easily build and test Big Cartel themes locally.'

  s.files        = `git ls-files`.split($\)
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  
  s.add_dependency('bundler', ['~> 1.1'])
  s.add_dependency('rack', ['~> 1.4.1'])
  s.add_dependency('activesupport', ['~> 3.2.6'])
  s.add_dependency('liquid', '~> 2.4.1')
  s.add_dependency('sprockets', '~> 2.0')
  s.add_dependency('httparty', '~> 0.10.0')
  s.add_dependency('better_errors')
end
