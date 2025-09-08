# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'cssbundling-rails'
gem 'jsbundling-rails'
gem 'pg'
gem 'puma'
gem 'rails'
gem 'sprockets-rails', require: 'sprockets/railtie'
gem 'rails-ujs'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :test do
  gem 'shoulda-matchers'
  gem 'database_cleaner-active_record'
end
