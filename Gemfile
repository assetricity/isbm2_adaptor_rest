source 'https://rubygems.org'

gemspec

group :development, :test do
  gem 'rake', '~> 12.0.0'
  gem 'pry-byebug'
  # Optional dependencies for the notification service
  gem 'rack', require: false
  gem 'rack-contrib', require: false
  gem 'thin', require: false
end

# Optional dependencies for testing, only if env var COVERAGE=on
gem 'simplecov', require: false, group: :test
gem 'coveralls', require: false, group: :test
