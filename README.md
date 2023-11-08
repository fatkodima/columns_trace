# ColumnsTrace

[![Build Status](https://github.com/fatkodima/columns_trace/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/fatkodima/columns_trace/actions/workflows/test.yml)

Detects unnecessary selected database columns in Rails controllers, `ActiveJob` and `Sidekiq` jobs.

## Requirements

- ruby 2.7+
- rails 6.0+

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'columns_trace'
```

And then run:

```sh
$ bundle install
```

## Usage

Hit a controller or email action or run `ActiveJob` (or `Sidekiq`) job, open `log/columns_trace.log`,
and see the output:

```
ImportsController#create
  1 User record: unused columns - "bio", "settings"; used columns - "id", "email", "name",
  "account_id", "created_at", "updated_at"
  ↳ app/controllers/application_controller.rb:32:in `block in <class:ApplicationController>'

  1 Account record: unused columns - "settings", "logo", "updated_at";
  used columns - "id", "plan_id"
  ↳ app/controllers/application_controller.rb:33:in `block in <class:ApplicationController>'

  10 Project records: unused columns - "description", "avatar", "url", "created_at", "updated_at";
  used columns - "id", "user_id"
  ↳ app/models/user.rb:46: in `projects'
    app/services/imports_service.rb:129: in `import_projects'
    app/controllers/imports_controller.rb:49:in `index'

ImportProjectJob
  1 User record: unused columns - "email", "name", "bio", "created_at", "updated_at";
  used columns - "id", "settings"
  ↳ app/jobs/import_project_job.rb:23:in `perform'

  1 Project record: unused columns - "description", "avatar", "settings", "created_at",
  "updated_at"; used columns - "id", "user_id", "url"
  ↳ app/jobs/import_project_job.rb:24:in `perform'
```

### Tracing custom code

To get columns usage in the custom code, you can manually wrap it by `ColumnsTrace.report`:

```ruby
task my_rake_task: :environment do
  ColumnsTrace.report("my_rake_task") do
    # do stuff
  end
end
```

## Configuration

You can override the following default options:

```ruby
# config/initializers/columns_trace.rb

ColumnsTrace.configure do |config|
  # Configures models that will be ignored.
  # Always adds Rails' internal `ActiveRecord::SchemaMigration`
  # and `ActiveRecord::InternalMetadata` models by default.
  config.ignored_models = []

  # Configures columns that will be ignored.
  #
  # Global setting
  #   config.ignored_columns = [:updated_at]
  # Per-model setting
  #   config.ignored_columns = [:updated_at, { User => :admin }]
  config.ignored_columns = []

  # The reporter that is used for reporting.
  # Defaults to log reporter that outputs to `log/columns_trace.log` file
  # when inside a Rails application.
  config.reporter = nil

  # Controls the contents of the printed backtrace.
  # Is set to the default Rails.backtrace_cleaner when the gem is used in the Rails app.
  config.backtrace_cleaner = ->(backtrace) { backtrace }
end
```

`Sidekiq` integration is disabled by default. You need to explicitly enable it:

```ruby
# config/initializers/columns_trace.rb

ColumnsTrace.enable_sidekiq_tracing!
```

### Custom reporters

By default offenses are reported to a log reporter that outputs to `log/columns_trace.log` file
when inside a Rails application.

You can set your custom reporter by defining a class responding to `#report` method.

```ruby
class MyReporter
  def report(title, created_records)
    title # => "controller#action"
    created_records # => [#<ColumnsTrace::CreatedRecord>]
    created_records.each do |record|
      record.model # class of ActiveRecord model
      record.accessed_fields  # array of accessed fields
      record.unused_fields # array of unused fields
      record.backtrace # array of strings
      record.record # ActiveRecord model instance
    end
  end
end

ColumnsTrace.reporter = MyReporter.new
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake` to run the linter and tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Additional resources

Alternatives:

- [snip_snip](https://github.com/kddnewton/snip_snip) - archived, supports only controllers

Interesting reads:

- [Reasons why SELECT * is bad for SQL performance](https://tanelpoder.com/posts/reasons-why-select-star-is-bad-for-sql-performance/)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fatkodima/columns_trace.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
