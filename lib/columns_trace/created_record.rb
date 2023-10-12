# frozen_string_literal: true

module ColumnsTrace
  # Class that is used to store metadata about created ActiveRecord records.
  class CreatedRecord
    attr_reader :model, :record, :backtrace

    def initialize(record, backtrace)
      @model = record.class
      @record = record
      @backtrace = backtrace
    end

    def accessed_fields
      record.accessed_fields
    end

    def unused_fields
      # We need to store this into local variable, because `record.attributes`
      # will access all attributes.
      accessed = accessed_fields
      record.attributes.keys - accessed
    end
  end
end
