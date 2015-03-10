# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'receipt/version'

Gem::Specification.new do |spec|
  spec.name          = 'receipt'
  spec.version       = Receipt::VERSION
  spec.authors       = ['Fernando Almeida']
  spec.email         = ['fernando@fernandoalmeida.net']
  spec.summary       = 'Receipts generator for any ruby application.'
  spec.description   = 'Receipts generator for any ruby application.'
  spec.homepage      = 'http://github.com/fernandoalmeida/receipt'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(/^(test|spec|features)\//)
  end
  spec.executables   = spec.files.grep(/^exe\//) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'prawn', '~> 2.0'
  spec.add_dependency 'i18n'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'pdf-inspector'
end
