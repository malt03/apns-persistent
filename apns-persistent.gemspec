# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apns/persistent/version'

Gem::Specification.new do |spec|
  spec.name          = "apns-persistent"
  spec.version       = Apns::Persistent::VERSION
  spec.authors       = ["malt03"]
  spec.email         = ["malt.koji@gmail.com"]

  spec.summary       = "Send Apple Push Notifications"
  spec.description   = "apns-persistent is a gem for sending APNs and easy to manage connections. "
  spec.homepage      = "https://github.com/malt03/apns-persistent"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
