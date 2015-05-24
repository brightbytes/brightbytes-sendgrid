# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'brightbytes/sendgrid/version'

Gem::Specification.new do |spec|
  spec.name          = "brightbytes-sendgrid"
  spec.version       = Brightbytes::Sendgrid::VERSION
  spec.authors       = ["Brightbytes Inc.", "Serhiy Rozum"]
  spec.email         = ["serhiy@brightbytes.net"]
  spec.summary       = %q{BrightBytes and Sendgrid integration gem}
  spec.description   = %q{Gem to extend ActionMailer with SMTP API support}
  spec.homepage      = "https://github.com/brightbytes/brightbytes-sendgrid"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "actionmailer", ">= 3.2", "< 5.0.0"
  
  spec.add_dependency "activesupport", ">= 3.2", "< 5.0.0"
end
