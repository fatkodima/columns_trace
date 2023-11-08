## master (unreleased)

## 0.3.0 (2023-11-09)

  - Add ability to trace columns usage in custom code
  - Trace unused columns in mailers

## 0.2.0 (2023-10-13)

- Allow to use custom reporters

  ```ruby
  class MyReporter
    def report(title, created_records)
      # do actual reporting
    end
  end

  ColumnsTrace.reporter = MyReporter.new
  ```

  `ColumnsTrace.logger=` setting is removed in favor of using `ColumnsTrace.reporter=`.
  If you configured custom logger, you should now configure it via:

  ```ruby
  logger = ActiveSupport::Logger.new("/my/custom/logger.log")
  ColumnsTrace.reporter = ColumnsTrace::LogReporter.new(logger)
  ```

## 0.1.0 (2023-10-04)

- First release
