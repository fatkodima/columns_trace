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
    around_action do |controller, action|
      ColumnsTrace.report("#{controller.class.name}##{action_name}", &action)
    end
  end

  ActiveSupport.on_load(:action_mailer) do
    around_action do |mailer, action|
      ColumnsTrace.report("#{mailer.class.name}##{action_name}", &action)
    end
  end

  ActiveSupport.on_load(:active_job) do
    around_perform do |job, perform|
      ColumnsTrace.report("#{job.class.name}#perform", &perform)
    end
  end
end
