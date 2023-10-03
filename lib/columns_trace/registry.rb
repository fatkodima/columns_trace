# frozen_string_literal: true

module ColumnsTrace
  # @private
  # Note: can use ActiveSupport::IsolatedExecutionState instead of this module for rails 7.0+.
  module Registry
    Entry = Struct.new(:model, :record, :backtrace)

    class << self
      def register(record, backtrace)
        state << Entry.new(record.class, record, backtrace)
      end

      def clear
        state.clear
      end

      def entries
        state
      end

      private
        def state
          Thread.current[:columns_trace] ||= []
        end
    end
  end
end
