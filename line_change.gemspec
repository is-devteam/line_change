# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'line_change/version'

Gem::Specification.new do |spec|
  spec.name          = "line_change"
  spec.version       = LineChange::VERSION
  spec.authors       = ["IS Dev team"]
  spec.email         = ["devteam@isapp.com"]
  spec.summary       = %q{Easy apk upload tasks for HockeyApp.}
  spec.description   = %q{LineChange provides useful rake tasks for app deployment.}
  spec.homepage      = "https://github.com/is-devteam/line_change"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
