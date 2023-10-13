# frozen_string_literal: true

module ColumnsTrace
  # Class that is used to store metadata about created ActiveRecord records.
  class CreatedRecord
    # Model class
    # @return [Class]
    #
    attr_reader :model

    # Model instance
    # @return [ActiveRecord::Base]
    #
    attr_reader :record

    # Backtrace where the instance was created
    # @return [Array<String>]
    #
    attr_reader :backtrace

    def initialize(record, backtrace)
      @model = record.class
      @record = record
      @backtrace = backtrace
    end

    # Get accessed fields on model instance
    # @return [Array<String>]
    #
    def accessed_fields
      @accessed_fields ||= record.accessed_fields
    end

    # Get unused fields on model instance
    # @return [Array<String>]
    #
    def unused_fields
      # We need to store this into local variable, because `record.attributes`
      # will access all attributes.
      accessed = accessed_fields
      record.attributes.keys - accessed
    end
  end
end
