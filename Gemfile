# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'concurrent-ruby', require: 'concurrent'
gem 'concurrent-ruby-ext'
gem 'faraday'
gem 'puma'
gem 'rack'

group :development, :test do
  gem 'guard'
  gem 'guard-rack'
  gem 'pry-byebug'
  gem 'terminal-notifier'
  gem 'terminal-notifier-guard'
end
