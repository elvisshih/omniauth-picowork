# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-picowork/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-picowork"
  spec.version       = OmniAuth::Picowork::VERSION
  spec.authors       = ["elvis"]
  spec.email         = ["elvis@u3dspace.com"]
  spec.summary       = %q{"OmniAuth Strategies of Picowork"}
  spec.description   = %q{"OAuth2 with Picowork by omniauth"}
  spec.homepage      = "https://github.com/elvisshih/omniauth-picowork"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'omniauth', '~> 1.0'
  spec.add_runtime_dependency 'omniauth-oauth2'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
