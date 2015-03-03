# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pdf_receipt/version'

Gem::Specification.new do |spec|
  spec.name          = 'pdf_receipt'
  spec.version       = PdfReceipt::VERSION
  spec.authors       = ['Fernando Almeida']
  spec.email         = ['fernando@fernandoalmeida.net']
  spec.summary       = 'PDF Receipts generator for any ruby application.'
  spec.description   = 'PDF Receipts generator for any ruby application.'
  spec.homepage      = 'http://github.com/fernandoalmeida/pdf_receipt'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(/^(test|spec|features)\//)
  end
  spec.executables   = spec.files.grep(/^exe\//) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry', '~> 0.10'
end
