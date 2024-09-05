# frozen_string_literal: true

module ColumnsTrace
  # @private
  class Railtie < Rails::Railtie
    initializer "columns_trace.set_configs" do
      ColumnsTrace.backtrace_cleaner = Rails.backtrace_cleaner

      logger = ActiveSupport::Logger.new(Rails.root.join("log", "columns_trace.log"))
      ColumnsTrace.reporter ||= LogReporter.new(logger)
    end
  end
end
