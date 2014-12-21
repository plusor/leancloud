$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "lean_cloud/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "lean_cloud"
  s.version     = LeanCloud::VERSION
  s.authors     = ["plusrez"]
  s.email       = ["plusor@icloud.com"]
  s.homepage    = "https://github.com/plusrez/lean_cloud"
  s.summary     = "LeanCloud SDK."
  s.description = "LeanCloud SDK."
  s.license     = "MIT"

  s.files = `git ls-files`.split("\n")
  s.test_files = Dir["test/**/*"]

  s.add_dependency "faraday"
  s.add_dependency "activesupport"
  s.add_development_dependency 'rake', '~> 0.9.2'
  s.add_development_dependency 'rspec', '~> 2.5'
end
