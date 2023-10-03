# frozen_string_literal: true

module ColumnsTrace
  # @private
  class SidekiqMiddleware
    def call(worker, _job, _queue)
      Registry.clear
      yield
      Reporter.report(worker.class.name)
    end
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add(ColumnsTrace::SidekiqMiddleware)
  end
end
