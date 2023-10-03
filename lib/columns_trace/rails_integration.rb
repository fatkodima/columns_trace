# frozen_string_literal: true

module ColumnsTrace
  ActiveSupport.on_load(:active_record) do
    after_find do
      backtrace = Kernel.caller

      if ColumnsTrace.backtrace_cleaner
        backtrace = ColumnsTrace.backtrace_cleaner.call(backtrace)
      end

      Registry.register(self, backtrace) unless ColumnsTrace.ignored_model?(self.class)
    end
  end

  ActiveSupport.on_load(:action_controller) do
    before_action { Registry.clear }
    after_action { Reporter.report("#{self.class.name}##{action_name}") }
  end

  ActiveSupport.on_load(:active_job) do
    before_perform { Registry.clear }
    after_perform { Reporter.report(self.class.name) }
  end
end