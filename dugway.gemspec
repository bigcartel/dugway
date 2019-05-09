# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'dugway/version'

Gem::Specification.new do |s|
  s.name         = 'dugway'
  s.version      = Dugway::VERSION
  s.authors      = ['Big Cartel']
  s.email        = 'dev@bigcartel.com'
  s.homepage     = 'https://github.com/bigcartel/dugway'
  s.summary      = %{Easily build and test Big Cartel themes.}
  s.description  = %{Dugway allows you to run your Big Cartel theme on your computer, test it in any browser, write code in your favorite editor, and use fancy new tools like CoffeeScript, Sass, and LESS. It's awesome.}
  s.license      = 'MIT'

  s.files        = `git ls-files`.split($\)
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.executables  << 'dugway'

  s.add_dependency('bundler', '~> 1.1')
  s.add_dependency('rack', '~> 1.4.1')
  s.add_dependency('rack-mount', '~> 0.8.3')
  s.add_dependency('activesupport', '~> 5.2')
  s.add_dependency('liquid', '~> 3.0.6')
  s.add_dependency('coffee-script', '~> 2.4.1')
  s.add_dependency('sass', '~> 3.2.5')
  s.add_dependency('sprockets', '~> 2.0')
  s.add_dependency('sprockets-sass', '~> 0.9.1')
  s.add_dependency('compass', '~> 0.12.2')
  s.add_dependency('httparty', '~> 0.10.0')
  s.add_dependency('better_errors', '~> 0.9.0')
  s.add_dependency('will_paginate', '~> 3.0.4')
  s.add_dependency('i18n', '1.6')
  s.add_dependency('htmlentities', '~> 4.3.1')
  s.add_dependency('thor', '~> 0.20.3')
  s.add_dependency('rubyzip', '~> 0.9.9')
  s.add_dependency('uglifier', '~> 1.3.0')
  s.add_dependency('thin', '~> 1.7.2')
  s.add_dependency('bigcartel-theme-fonts')
  s.add_dependency('bigcartel-currency-locales')

  s.add_development_dependency('rake', '~> 10.0.3')
  s.add_development_dependency('rspec', '~> 2.12.0')
  s.add_development_dependency('webmock', '~> 1.9.3')
  s.add_development_dependency('json_expressions', '~> 0.9.0')
  s.add_development_dependency('capybara', '~> 2.0.2')
  s.add_development_dependency('simplecov', '~> 0.16.1')
end
