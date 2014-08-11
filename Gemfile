source 'https://rubygems.org'
ruby '2.1.2'
#ruby-gemset=railstutorial_rails_4_0


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.8'

# Use sqlite3 as the database for Active Record
group :development, :test do
  gem 'sqlite3', '1.3.9'
  gem 'rspec-rails', '2.13.1'
end

group :test do
  gem 'selenium-webdriver', '2.42.0'
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.2.0'
  
  gem 'cucumber-rails', '1.4.1', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
end

# Use SCSS for stylesheets
gem 'sass-rails', '4.0.3'

# Use bootstrap SASS for stylesheets
gem 'bootstrap-sass', '2.3.2.0'
gem 'sprockets', '2.11.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier',  '2.5.1'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '4.0.1'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '3.1.1'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '2.2.2'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '1.5.3'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '0.4.0', require: false
end

group :production do
  gem 'pg', '0.17.1'
  gem 'rails_12factor', '0.0.2'
end


# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
