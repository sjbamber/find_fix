source 'https://rubygems.org'

gem 'rails', '3.2.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
  gem 'mysql2'
end
group :production do
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'uglifier', '>= 1.0.3'
end

# jQuery JavaScript framework including jQuery UI
gem 'jquery-rails'

# Framework used to create the mobile application
gem 'jquery_mobile_rails'

# Required for tree structure in Category
gem 'ancestry'

# Gem for pagination of form data
gem 'will_paginate'

# Gem for adding in line client side validation using jQuery
gem 'client_side_validations'

# Gem for the search engine IndexTank
gem 'tanker'

# Gem for AutoComplete of form data from ActiveRecord
gem 'rails3-jquery-autocomplete'

# Gem to handle dynamically adding nested fields on forms
gem 'nested_form', :git => 'https://github.com/ryanb/nested_form.git'

# Gem for jQuery modal box
gem 'facebox-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# Deploy to Heroku (Hosting)
gem 'heroku'

group :production do
  gem 'thin'
end
