# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.3"

gem "bootsnap", require: false
gem "json-schema", "~> 4.3"
gem "multi_json", "~> 1.15"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.8", ">= 7.0.8.4"
gem "rubocop", "~> 1.64"
gem "rubocop-rails", "~> 2.25"
gem "solargraph", "~> 0.50.0"
gem "sprockets-rails"

group :development, :test do
  gem "byebug", platform: :mri
  gem "factory_bot_rails", "~> 6.4.3"
  gem "minitest", "~> 5.22.2"
  gem "minitest-profile"
  gem "rails-controller-testing", "~> 1.0"
  gem "webmock", "~> 3.23.0"
end
