# coding: utf-8
require File.expand_path("../lib/lcbo/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'lcbo'
  s.version     = LCBO::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Carsten Nielsen']
  s.email       = ['heycarsten@gmail.com']
  s.homepage    = 'http://github.com/heycarsten/lcbo'
  s.summary     = %q{A library for parsing HTML pages from http://lcbo.com}
  s.description = %q{Request and parse product, store, inventory, and product search pages directly from the official LCBO website.}

  s.rubyforge_project = 'lcbo'

  s.add_dependency 'typhoeus',      '~> 0.6.3'
  s.add_dependency 'nokogiri',      '~> 1.5.9'
  s.add_dependency 'unicode_utils', '~> 1.4.0'
  s.add_dependency 'stringex',      '~> 1.5.1'

  s.files         = `git ls-files`.split(?\n)
  s.test_files    = `git ls-files -- {test,spec}/*`.split(?\n)
  s.require_paths = ['lib']
end
