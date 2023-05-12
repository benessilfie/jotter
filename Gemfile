source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

gem "bcrypt"
gem "bootsnap", require: false
gem "email_address"
gem "fast_jsonapi"
gem "graphql"
gem "jwt"
gem "puma", "~> 5.0"
gem "rack-cors"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "sqlite3", "~> 1.4"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "shoulda-matchers"
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
end

group :development do
  gem "solargraph"
end
