# frozen_string_literal: true

module ColumnsTrace
  # Reporter that reports into the provided logger.
  class LogReporter
    def initialize(logger)
      @logger = logger
    end

    # Main reporter's method
    #
    # @param title [String] title of the reporting, e.g. controller action etc
    # @param created_records [Array<ColumnsTrace::CreatedRecord>] items that hold
    #   metadata about created records
    #
    def report(title, created_records)
      lines = []

      created_records.group_by(&:model).each do |model, grouped_created_records|
        lines.concat(lines_for_created_records(model, grouped_created_records))
      end

      if lines.any?
        @logger.info("#{title}\n#{lines.join("\n")}")
      end
    end

    private
      def lines_for_created_records(model, created_records)
        lines = []

        created_records.group_by(&:backtrace).each do |backtrace, grouped_created_records|
          accessed = accessed_fields(grouped_created_records)
          unused = grouped_created_records.first.unused_fields - accessed
          unused.reject! { |column| ColumnsTrace.ignored_column?(model, column) }

          if unused.any?
            records_text = "record".pluralize(grouped_created_records.size)
            lines << <<-MSG
  #{grouped_created_records.size} #{model.name} #{records_text}: unused columns - #{format_columns(unused)}; used columns - #{format_columns(accessed)}
  ↳ #{backtrace.join("\n  ")}
            MSG
          end
        end

        lines
      end

      def accessed_fields(created_records)
        created_records.map(&:accessed_fields).flatten.uniq
      end

      def format_columns(columns)
        columns.map(&:inspect).join(", ")
      end
  end
end
