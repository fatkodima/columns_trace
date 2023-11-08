# frozen_string_literal: true

require "active_record"

require_relative "columns_trace/created_record"
require_relative "columns_trace/registry"
require_relative "columns_trace/rails_integration"
require_relative "columns_trace/log_reporter"
require_relative "columns_trace/version"
require_relative "columns_trace/railtie" if defined?(Rails)

module ColumnsTrace
  class << self
    # Manually trace columns usage in an arbitrary code.
    #
    # @param title [String] title of the reporting, e.g. controller action etc
    #
    # @example
    #   task my_rake_task: :environment do
    #     ColumnsTrace.report("my_rake_task") do
    #       # do stuff
    #     end
    #   end
    #
    def report(title)
      Registry.clear
      yield
      reporter.report(title, Registry.created_records)
    end

    # @private
    attr_reader :ignored_models

    # Configures models that will be ignored.
    #
    # @example
    #   ColumnsTrace.ignored_models = [Settings]
    #
    # Always adds Rails' internal `ActiveRecord::SchemaMigration`
    # and `ActiveRecord::InternalMetadata` models by default.
    #
    def ignored_models=(models)
      @ignored_models = Array(models) | [ActiveRecord::SchemaMigration, ActiveRecord::InternalMetadata]
    end

    # @private
    def ignored_model?(model)
      ignored_models.include?(model)
    end

    # Configures columns that will be ignored.
    #
    # @example Global setting
    #   ColumnsTrace.ignored_columns = [:updated_at]
    # @example Per-model setting
    #   ColumnsTrace.ignored_columns = [:updated_at, { User => :admin }]
    #
    attr_accessor :ignored_columns

    # @private
    def ignored_column?(model, column)
      ignored_columns.any? do |value|
        if value.is_a?(Hash)
          columns = value[model] || value[model.name] || value[model.name.to_sym]
          if columns
            columns = Array(columns).map(&:to_s)
            columns.include?(column)
          end
        else
          value.to_s == column
        end
      end
    end

    # Allows to set the reporter.
    # Defaults to log reporter that outputs to `log/columns_trace.log` file
    # when inside a rails application.
    #
    attr_accessor :reporter

    # @private
    attr_reader :backtrace_cleaner

    # Allows to set a backtrace_cleaner used to clean backtrace before printing them.
    # Defaults to `Rails.backtrace_cleaner` when inside a rails application.
    #
    def backtrace_cleaner=(cleaner)
      @backtrace_cleaner =
        if cleaner.respond_to?(:clean)
          ->(backtrace) { cleaner.clean(backtrace) }
        else
          cleaner
        end
    end

    # Enables integration with Sidekiq, which is disabled by default.
    #
    def enable_sidekiq_tracing!
      require_relative "columns_trace/sidekiq_integration"
      true
    end

    # A convenient method to configure this gem.
    #
    # @example
    #   ColumnsTrace.configure do |config|
    #     # ...
    #   end
    #
    def configure
      yield self
    end
  end

  self.ignored_models = []
  self.ignored_columns = []
  self.backtrace_cleaner = ->(backtrace) { backtrace }
end
