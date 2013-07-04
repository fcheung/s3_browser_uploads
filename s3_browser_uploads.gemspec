# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3_browser_uploads/version'

Gem::Specification.new do |spec|
  spec.name          = "s3_browser_uploads"
  spec.version       = S3BrowserUploads::VERSION
  spec.authors       = ["Frederick Cheung"]
  spec.email         = ["frederick.cheung@gmail.com"]
  spec.description   = %q{Easy straight-to-s3 uploads from your browser}
  spec.summary       = %q{Easy straight-to-s3 uploads from your browser}
  spec.homepage      = "https://github.com/fcheung/s3_browser_uploads"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.13.0"
end
