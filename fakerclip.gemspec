$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fakerclip/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fakerclip"
  s.version     = Fakerclip::VERSION
  s.authors     = ["Dave Rogers"]
  s.email       = ["dave@codefling.com"]
  s.homepage    = "https://github.com/davidtrogers/fakerclip"
  s.summary     = "Fake S3 on your filesystem for Paperclip."
  s.description = "Simulate writing and reading from S3 by using your filesystem as a Fake S3."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "paperclip", "~> 3.4.1"
  s.add_dependency "fog"
  s.add_dependency "excon"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'database_cleaner'
end
