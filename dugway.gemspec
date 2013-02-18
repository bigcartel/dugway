# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'dugway/version'

Gem::Specification.new do |s|
  s.name         = 'dugway'
  s.version      = Dugway::VERSION
  s.authors      = ['Big Cartel']
  s.email        = 'dev@bigcartel.com'
  s.homepage     = 'https://github.com/bigcartel/dugway'
  s.summary      = 'Easily build and test Big Cartel themes locally.'
  s.description  = 'Easily build and test Big Cartel themes locally.'

  s.files        = `git ls-files`.split($\)
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  
  s.add_dependency('bundler', ['~> 1.1'])
  s.add_dependency('rack', ['~> 1.4.1'])
  s.add_dependency('activesupport', ['~> 3.2.6'])
  s.add_dependency('liquid', '~> 2.4.1')
  s.add_dependency('therubyracer', '~> 0.11.3')
  s.add_dependency('coffee-script', '~> 2.2.0')
  s.add_dependency('sass', '~> 3.2.5')
  s.add_dependency('less', '~> 2.2.2')
  s.add_dependency('sprockets', '~> 2.0')
  s.add_dependency('httparty', '~> 0.10.0')
  s.add_dependency('better_errors')
  s.add_dependency('will_paginate')
end
