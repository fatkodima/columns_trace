# frozen_string_literal: true

module ColumnsTrace
  # @private
  class Reporter
    def self.report(title)
      new.report(title)
    end

    def report(title)
      lines = []

      Registry.entries.group_by(&:model).each do |model, entries|
        lines.concat(lines_for_entries(model, entries))
      end

      if lines.any?
        ColumnsTrace.logger.info("#{title}\n#{lines.join("\n")}")
      end
    end

    private
      def lines_for_entries(model, entries)
        lines = []

        entries.group_by(&:backtrace).each do |backtrace, grouped_entries|
          records = grouped_entries.map(&:record)

          accessed = accessed_fields(records)
          unused = records.first.attributes.keys - accessed
          unused.reject! { |column| ColumnsTrace.ignored_column?(model, column) }

          if unused.any?
            records_text = "record".pluralize(records.size)
            lines << <<-MSG
  #{records.size} #{model.name} #{records_text}: unused columns - #{format_columns(unused)}; used columns - #{format_columns(accessed)}
  ↳ #{backtrace.join("\n  ")}
            MSG
          end
        end

        lines
      end

      def accessed_fields(records)
        records.map(&:accessed_fields).flatten.uniq
      end

      def format_columns(columns)
        columns.map(&:inspect).join(", ")
      end
  end
end
