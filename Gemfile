source 'http://rubygems.org'
# in order to get the next line working run:
# gem install bundler --pre
ruby "1.9.3"

gem "rails", "~> 3.2.12"
gem "bson_ext", "~> 1.5"
gem "mongoid", "~> 2.4.12"
gem "coderay", "~> 1.0.5"
gem 'fakefs', :require => "fakefs/safe"
gem 'jquery-rails'
gem 'devise', '~> 2.0.4'
gem "rinku"
gem 'exception_notification', :require => 'exception_notifier'
gem 'sicuro', '~> 0.3.0'
gem 'mongoid-history'
gem 'kaminari'
gem 'chosen-rails'
gem "uuid", "~> 2.3.5"
gem "rack-timeout"
gem "aws-ses", "~> 0.4.4", :require => 'aws/ses'
gem "rubyheap", "~> 0.1.2"
gem "trackman"
gem "twitter"

# omniauth gems
gem 'omniauth'
gem "omniauth-twitter"
gem "omniauth-github"
gem "omniauth-openid"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem "newrelic_rpm"
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test, :development do
  gem 'rspec-rails', "~> 2.8"
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
  gem 'launchy'
  gem 'awesome_print'
  gem 'interactive_editor'
  gem 'selenium-webdriver'
end

group :development do
  # bash < <(curl -L https://raw.github.com/gist/1333785)
  #gem 'debugger'
  gem 'heroku'
  gem 'pry-rails'
end

group :test do
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'capybara'
end
