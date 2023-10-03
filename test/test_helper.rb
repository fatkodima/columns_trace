# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require "columns_trace"
require "logger"
require "minitest/autorun"

require_relative "dummy/config/environment"

ActiveRecord::Migration.suppress_messages do
  require_relative "dummy/db/schema"
end

User.create!([
  { name: "John", email: "john@example.com" },
  { name: "Jane", email: "jane@example.com" }
])

Project.create!(name: "Ruby on Rails")

# A hack to make server middleware work.
# See https://github.com/sidekiq/sidekiq/wiki/Testing#testing-server-middleware.
module Sidekiq
  class << self
    undef server?

    def server?
      true
    end
  end
end

ColumnsTrace.enable_sidekiq_tracing!

module ActiveSupport
  class TestCase
    def capture_logging(&block)
      out = StringIO.new
      logger = Logger.new(out)
      ColumnsTrace.stub(:logger, logger, &block)
      out.string
    end
  end
end
