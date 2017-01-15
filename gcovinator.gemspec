# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gcovinator/version'

Gem::Specification.new do |spec|
  spec.name          = "gcovinator"
  spec.version       = Gcovinator::VERSION
  spec.authors       = ["Josh Holtrop"]
  spec.email         = ["jholtrop@gmail.com"]

  spec.summary       = %q{gcovinator generates HTML reports for gcov coverage data}
  spec.description   = %q{gcovinator generates HTML reports for gcov coverage data. It provides a command-line executable that can be run after the .gcda and .gcno files are present. It executes gcov, reads the .gcov output files, and combines the original source files with the coverage data into HTML reports.}
  spec.homepage      = "https://github.com/holtrop/gcovinator"
  spec.license       = "MIT"

  spec.files         = Dir["{assets,exe,lib}/**/*", "*.gemspec"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
