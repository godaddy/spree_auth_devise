# encoding: UTF-8

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_auth_devise'
  s.version     = '3.0.0'
  s.summary     = 'Provides authentication and authorization services for use with Spree by using Devise and CanCan.'
  s.description = s.summary

  s.required_ruby_version = '>= 1.9.3'
  s.author      = 'Sean Schofield'
  s.email       = 'sean@spreecommerce.com'
  s.homepage    = 'http://spreecommerce.com'
  s.license     = %q{BSD-3}

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_version = '~> 3.0.0'
  s.add_dependency 'spree_core', spree_version
  s.add_dependency 'devise', '~> 4.4.0'
  s.add_dependency 'devise-encryptable', '0.1.2'
  s.add_dependency 'cancancan', '~> 2.0'

  s.add_development_dependency 'spree_backend', spree_version
  s.add_development_dependency 'spree_frontend', spree_version
  s.add_development_dependency 'sqlite3', '~> 1.3.13'
  s.add_development_dependency 'sass-rails', '~> 5.0.7'
  s.add_development_dependency 'coffee-rails', '~> 4.2.0'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-activemodel-mocks'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'shoulda-matchers', '~> 3.1.2'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner', '~> 1.7.0'
  s.add_development_dependency 'simplecov', '~> 0.15.0'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'byebug'
end
