# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "rake", "~> 13.0"
gem "sqlite3"
gem "sidekiq"
gem "rubocop"
gem "rubocop-minitest"

if defined?(@rails_requirement)
  gem "actionpack", @rails_requirement
  gem "actionmailer", @rails_requirement
  gem "activejob", @rails_requirement
  gem "actionmailer", @rails_requirement
  gem "railties", @rails_requirement
else
  gem "actionpack"
  gem "actionmailer"
  gem "activejob"
  gem "actionmailer"
  gem "railties"
end
