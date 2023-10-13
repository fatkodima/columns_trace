# frozen_string_literal: true

module ColumnsTrace
  # @private
  # Note: can use ActiveSupport::IsolatedExecutionState instead of this module for rails 7.0+.
  module Registry
    class << self
      def register(record, backtrace)
        state << CreatedRecord.new(record, backtrace)
      end

      def clear
        state.clear
      end

      def created_records
        state
      end

      private
        def state
          Thread.current[:columns_trace] ||= []
        end
    end
  end
end
