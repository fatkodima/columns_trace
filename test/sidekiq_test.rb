# frozen_string_literal: true

require "test_helper"

class SidekiqTest < ActiveSupport::TestCase
  test "reports unused columns" do
    output = capture_logging do
      SidekiqJob.perform_inline
    end

    assert_match %(SidekiqJob#perform\n  1 User record: unused columns - "id", "email", "created_at", "updated_at"; used columns - "name"), output
    assert_match "↳", output
    assert_match(/app\/jobs\/sidekiq_job\.rb:\d+:in `perform/, output)
  end
end
