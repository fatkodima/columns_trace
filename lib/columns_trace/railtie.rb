# frozen_string_literal: true

module ColumnsTrace
  # @private
  class Railtie < Rails::Railtie
    initializer "columns_trace.set_configs" do
      ColumnsTrace.backtrace_cleaner = Rails.backtrace_cleaner
      ColumnsTrace.logger = ActiveSupport::Logger.new(Rails.root.join("log", "columns_trace.log"))
    end
  end
end
