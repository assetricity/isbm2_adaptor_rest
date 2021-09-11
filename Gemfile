source 'https://rubygems.org'

gemspec

group :debugging do
  gem 'pry-byebug', group: :development, platforms: ['ruby', 'mingw', 'x64_mingw', 'mswin']
  # gem 'pry-debugger-jruby', group: :development, platforms: ['jruby'] # does not support 1.9.3
end

group :development, :test do
  # rake contraint relaxed temporarily as needs to be < 11.0.1 for 1.9.3 compatibility
  gem 'rake'#, '~> 12.0', '>= 12.3.3'
  # Optional dependencies for the notification service
  gem 'rack', require: false
  gem 'rack-contrib', require: false
  gem 'thin', require: false, platforms: ['ruby', 'mingw', 'x64_mingw', 'mswin']
  gem 'puma', require: false, platforms: ['jruby']
end

# Optional dependencies for testing, only if env var COVERAGE=on
gem 'simplecov', require: false, group: :test
gem 'coveralls', require: false, group: :test
